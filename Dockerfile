FROM python:3.9-alpine3.18
LABEL maintainer="Luke Childs <lukechilds123@gmail.com>"

COPY ./bin /usr/local/bin

RUN chmod a+x /usr/local/bin/* && \
    apk add --no-cache git build-base openssl leveldb-dev rocksdb-dev gcompat libstdc++ && \
    pip install aiohttp pylru plyvel websockets git+https://github.com/HathorNetwork/python-rocksdb.git@master uvloop && \
    git clone -b master https://github.com/spesmilo/electrumx.git && \
    cd electrumx && \
    python setup.py install && \
    apk del git build-base && \
    rm -rf /tmp/*

VOLUME ["/data"]
ENV HOME /data
ENV ALLOW_ROOT 1
ENV EVENT_LOOP_POLICY uvloop
ENV DB_DIRECTORY /data
ENV SERVICES=tcp://:50001,ssl://:50002,wss://:50004,rpc://0.0.0.0:8000
ENV SSL_CERTFILE ${DB_DIRECTORY}/electrumx.crt
ENV SSL_KEYFILE ${DB_DIRECTORY}/electrumx.key
ENV HOST ""
WORKDIR /data

EXPOSE 50001 50002 50004 8000

CMD ["init"]
