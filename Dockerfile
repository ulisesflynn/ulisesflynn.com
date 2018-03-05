FROM alpine:3.6

LABEL caddy_version="0.10.7" architecture="amd64"

ARG plugins=http.git

RUN apk add --no-cache openssh-client git tar curl

RUN curl --silent --show-error --fail --location \
         --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
         "https://caddyserver.com/download/linux/amd64?plugins=${plugins}" \
         | tar --no-same-owner -C /usr/bin/ -xz caddy \
         && chmod 0755 /usr/bin/caddy \
         && /usr/bin/caddy -version

EXPOSE 80 443 2015
WORKDIR /srv

ENV CADDYPATH="/etc/caddycerts"
VOLUME etc/caddycerts /etc/caddycerts

COPY Caddyfile /etc/Caddyfile
COPY index.html /srv/index.html
COPY package.json /srv/package.json
COPY css /srv/css
COPY img /srv/img
COPY docs /srv/docs
COPY js /srv/js
COPY node_modules /srv/node_modules
COPY scss /srv/scss
COPY vendor /srv/vendor

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["--conf", "/etc/Caddyfile", "--log", "stdout"]