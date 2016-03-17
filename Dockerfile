From ubuntu:trusty
MAINTAINER Elliott Ye

# 기존 미러 서버를 한국 서버로 변경
RUN sed -i 's/archive.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list



# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive

# Update
RUN apt-get update

# Relocate the timezone file
RUN mkdir -p /config/etc && mv /etc/timezone /config/etc/ && ln -s /config/etc/timezone /etc/

# Set timezone as specified in /config/etc/timezone
dpkg-reconfigure -f noninteractive tzdata

# Set the time zone
RUN echo "Asia/Seoul" > /etc/timezone

# Set the time zone
#RUN echo "Asia/Seoul" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata
#VOLUME ["/etc/timezone","/etc/localtime"]

RUN locale-gen ko_KR.UTF-8 && \
    echo 'LANG="ko_KR.UTF-8"' > /etc/default/locale
RUN dpkg-reconfigure locales

# Start editing
# Install package here for cache
RUN apt-get -y install supervisor postfix sasl2-bin opendkim opendkim-tools

# Add files
ADD assets/install.sh /opt/install.sh

# Run
CMD /opt/install.sh;/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
