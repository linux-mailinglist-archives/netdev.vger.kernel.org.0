Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A37303FFE
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 15:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405775AbhAZOSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 09:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405723AbhAZORj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 09:17:39 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D22C0611BD
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 06:16:59 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id r12so23116778ejb.9
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 06:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition:user-agent;
        bh=QKucVU+UOcfFyl7BB9PcuZRXR5t3NHOsqDsthUZXp+E=;
        b=I45mAryyqQdYYB3DbW+UzuCGT2IjWNSuRlyjhQPfbIJVCby9AlnQGbTTlcJoSn5L14
         rgR2Vr4W47GGseLIGYv17ToAlGdZuvqfrt1H7nda7FgAM8rMRGY0nmi+bU7amdW6ykzP
         F4IMIYUxNfgJAiF53OLsJ+nCpXHVPFJu3/9gULyO3VsRwdj5OutbajXdbv+6XIPsVYsE
         VAcmSkN9+0U5bj0YnO7V7QXMXOfk85OO3OoU2XuHBULL8dlR+nA7L4uYx8rmfh1Z+kbe
         2TzzIn+xFfgr2vxpe877eFY1I77KKC6I0zb6KHqArT10R/+pkcazd+I2MOBhqIWBAySn
         1TZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition:user-agent;
        bh=QKucVU+UOcfFyl7BB9PcuZRXR5t3NHOsqDsthUZXp+E=;
        b=PjFhq9KLTU8Wd96flCHXXjYwhHMPRCA3B3HGjTVZ+oYql5SExnqI0zN4pca+DRRTxz
         Y/CKnZpddxZNEbKL/AHds/PfrjymWehMnFEGbE9GqMY/nk6nPCtyCm9AaTPoe4k/r1yR
         hQz1XnpvdOf4XrYxmrnGGvl7bSuoQ6Bj1MQqv21SlaqhqpqX5la8raLcTPVY8mE7ucqq
         /11LzzxRr/6fXYA9pg7g5LhxcQCLgupySTV7L7f2SAJHQp1ricv7+IXXL3ivi/A9MFBN
         Ak2TkgjLACjx5sYYOP84n8XdWalXoRanSfFbgnKP8wpwxow+o1IbagDS8wX+LWWgNHrr
         Tpyg==
X-Gm-Message-State: AOAM5331H2anlnqWPUS+VjuF4niSj/d4bvmzY+umeJCjp8B4mdvZf4sw
        g27viFM2OUax/5BbYKLHJws=
X-Google-Smtp-Source: ABdhPJwi5cHzpKsFy2OaeKI8j5JUBfi3YFoRkLLptcDV3zY05gIp0MmexjTvylJtV/m1NmNaNvza8g==
X-Received: by 2002:a17:907:3f9e:: with SMTP id hr30mr3511686ejc.445.1611670617877;
        Tue, 26 Jan 2021 06:16:57 -0800 (PST)
Received: from localhost (dslb-002-207-138-002.002.207.pools.vodafone-ip.de. [2.207.138.2])
        by smtp.gmail.com with ESMTPSA id c14sm12865559edr.46.2021.01.26.06.16.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 Jan 2021 06:16:57 -0800 (PST)
Date:   Tue, 26 Jan 2021 15:12:49 +0100
From:   Oliver Graute <oliver.graute@gmail.com>
To:     kernelnewbies@kernelnewbies.org, netdev@vger.kernel.org
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        jakub@cloudflare.com, pabeni@redhat.com
Subject: UDP implementation and the MSG_MORE flag
Message-ID: <20210126141248.GA27281@optiplex>
Mail-Followup-To: kernelnewbies@kernelnewbies.org, netdev@vger.kernel.org,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, jakub@cloudflare.com,
        pabeni@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

we observe some unexpected behavior in the UDP implementation of the
linux kernel.

Some UDP packets send via the loopback interface are dropped in the
kernel on the receive side when using sendto with the MSG_MORE flag.
Every drop increases the InCsumErrors in /proc/self/net/snmp. Some
example code to reproduce it is appended below.

In the code we tracked it down to this code section. ( Even a little
further but its unclear to me wy the csum() is wrong in the bad case)

udpv6_recvmsg()
...
if (checksum_valid || udp_skb_csum_unnecessary(skb)) {
		if (udp_skb_is_linear(skb))
			err = copy_linear_skb(skb, copied, off, &msg->msg_iter);
		else
			err = skb_copy_datagram_msg(skb, off, msg, copied);
	} else {
		err = skb_copy_and_csum_datagram_msg(skb, off, msg);
		if (err == -EINVAL) {
			goto csum_copy_err;
		}
	}
...


Perhaps someone with deeper knowledge can comment on this and can explain
us the reason of this behavior.

Best regards,

Oliver


udp-send.c

#include <arpa/inet.h>
#include <errno.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <poll.h>
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/un.h>
#include <unistd.h>

#define BUFFSIZE 512*1024

int main(int argc, char** argv)
{
    int fd = 0;
    int port = 0;
    char *buffer;
    struct sockaddr_in addr;
    ssize_t addrlen = 0;

    if(argc == 2)
    {
        port = atoi(argv[1]);
    }
    else
    {
        port = 4711;
    }

    fd = socket(PF_INET, SOCK_DGRAM, 0);
    addr.sin_family = AF_INET;
    addr.sin_port = htons(port);
    addr.sin_addr.s_addr = inet_addr("127.0.0.1");
    addrlen = sizeof(addr);

    buffer = malloc(BUFFSIZE);
    if (!buffer) {
        return 0;
    }

    printf("\nsending BROKEN segmented testdata on local port %i \n", port);
    snprintf(buffer, BUFFSIZE, "start-data {\n");
    sendto(fd, buffer, strlen(buffer), MSG_MORE, (struct sockaddr *) &addr, addrlen);
    snprintf(buffer, BUFFSIZE, "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n");
    sendto(fd, buffer, strlen(buffer), MSG_MORE, (struct sockaddr *) &addr, addrlen);
    snprintf(buffer, BUFFSIZE, "}\n");
    sendto(fd, buffer, strlen(buffer), 0, (struct sockaddr *) &addr, addrlen);

    printf("\nsending VALID segmented testdata on local port %i \n", port);
    snprintf(buffer, BUFFSIZE, "start-data {\n");
    sendto(fd, buffer, strlen(buffer), MSG_MORE, (struct sockaddr *) &addr, addrlen);
    snprintf(buffer, BUFFSIZE, "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n");
    sendto(fd, buffer, strlen(buffer), MSG_MORE, (struct sockaddr *) &addr, addrlen);
    snprintf(buffer, BUFFSIZE, "}\n");
    sendto(fd, buffer, strlen(buffer), 0, (struct sockaddr *) &addr, addrlen);

    printf("\nsending VALID unsegmented testdata on local port %i \n", port);
    snprintf(buffer, BUFFSIZE, "start-data {\n");
    snprintf(buffer + strlen(buffer), BUFFSIZE - strlen(buffer), "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n");
    snprintf(buffer+ strlen(buffer), BUFFSIZE - strlen(buffer), "}\n");
    sendto(fd, buffer, strlen(buffer), 0, (struct sockaddr *) &addr, addrlen);

    free(buffer);
    return 0;
}
-------

udp-receive.c 

#include <arpa/inet.h>
#include <errno.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <poll.h>
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/un.h>
#include <unistd.h>

int main(int argc, char** argv)
{
    int fd = 0;
    int arg = 0;
    int ret = 0;
    struct sockaddr_in addr;
    ssize_t addrlen = 0;
    int port = 0;
    char *buffer;
    char *printbuffer;
    int recvlen = 0;

    if(argc == 2)
    {
        port = atoi(argv[1]);
    }
    else
    {
        port = 4711;
    }

    fd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);

    addr.sin_family = AF_INET;
    addr.sin_port = htons(port);
    addr.sin_addr.s_addr = inet_addr("0.0.0.0");
    addrlen = sizeof(addr);

    buffer = malloc(65536);
    if (!buffer) {
        return 0;
    }

    printbuffer = malloc(65537);
    if (!printbuffer) {
        return 0;
    }

    if(fd)
    {
        printf("\nbinding to local port %i \n", port);
        //bind
        ret = bind(fd, (struct sockaddr *)&addr, addrlen);
        printf("result error %i, errno %i\n", ret, errno);

        do {
            recvlen = recvfrom(fd, buffer, 65536, 0, NULL, NULL);

            if (recvlen >0) {
                printf("\nreceived %i bytes of data:\n", recvlen);

                memset(printbuffer, 0, 65537);
                memcpy(printbuffer, buffer, recvlen);

                printf("%s\n", printbuffer);
            }
            else if(recvlen < 0) {
                printf("\n receive error %i, errno %i\n", recvlen, errno);
            }
        } while(1);

        close(fd);
    }
    else
    {
        printf("\nerror creating socket\n");
    }
    
    free(buffer);
    free(printbuffer);
    return 0;
}

