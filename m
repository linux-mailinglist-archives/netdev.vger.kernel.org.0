Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15850365A6F
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 15:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbhDTNqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 09:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232443AbhDTNqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 09:46:01 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8899C06174A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 06:45:29 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id k73so36742629ybf.3
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 06:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=npQOAk4f1Iv7DwBnRcXaic7lK/TQsKHITZ6kiHMeceE=;
        b=HEneWeYmGUlCkBIPOZ3QG56s33aFaziBUk3egJBDs4ZyRwYJUgOAQJnM7OLuWiOLfJ
         Yfu3zPbVV+S2ZZDnwjK+8ap8uy/fWjP0xX63TIHjF12UzKFA5FsOSlWn8zqzj4IYZubP
         +6ff47X14pCrfJ0ka1buFiqUxbGDNJGaSC2up8qjT7cIcz/izyD4LLoVuyjxPvKH06nY
         K7/nzFU+H13iRopQMP2v3l4FEe5Wji3GSY2QxolsR5x4OpWxi3rYXEtKxCtUlPQJojvv
         5YjFvuIUAST9mYOVcCKLPXIfev73xtkIuVJGC9A2nfIIoRMZwvw8Q06nFe74JOHdSzGm
         WWZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=npQOAk4f1Iv7DwBnRcXaic7lK/TQsKHITZ6kiHMeceE=;
        b=D+m1KTVkjO0KnKpRsdVTYPcuCnWY/a5fHzZQyNStySwyJQqrLIciTUUoxTi1wGH8/e
         VfHmGRJtKMduyk9po4dQEeckAYZmbSaziyUZgIGZMDAMe9WvvYH5zrK0os+u401wltM+
         6R2ZMKBtZV2WMh6gIBtrpCMxz8pD+IbL9N/mclwNq+wakTcUvhslds16lyTQBQ2T4Gqa
         9urkC7bq4cvFAxKjXgmBq3N1p0jig93+JSVRX3Y1tB8dojz6CMIgJZUpSSxVP69/qao7
         fLXEPTzgfqYQ+BYYWuUkBOAJImSwg9jtMGoGA8Po+YtefP0J72w+v3rfUwLU/2055DyO
         n1zw==
X-Gm-Message-State: AOAM533fpMe19dUKa3Mqh45JFo0DQYZWLMusQ/0k+MXHOlnkVUWuiMSV
        83JNymVDyQ90HgwPN7bHDTPPNEoYZ1SBx575aOXeJu38ucJI3w==
X-Google-Smtp-Source: ABdhPJw728/1mJ+tG5HNKDa0l6W6sLKFmLb0Cp38aAMFhVdGyamPoi8sUlwzZTe+mNfZUazkl6GSRxodb5/jUNpXwHU=
X-Received: by 2002:a25:4244:: with SMTP id p65mr24674712yba.452.1618926328570;
 Tue, 20 Apr 2021 06:45:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210420120043.48151-1-zhaoya.gaius@bytedance.com>
In-Reply-To: <20210420120043.48151-1-zhaoya.gaius@bytedance.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 20 Apr 2021 15:45:17 +0200
Message-ID: <CANn89i+CH1uHem_QaCxoWxKVWyM8qsz_zi4Dhm26Tni2EsW71A@mail.gmail.com>
Subject: Re: [PATCH] tcp: prevent loss of bytes when using syncookie
To:     =?UTF-8?B?6LW15Lqa?= <zhaoya.gaius@bytedance.com>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 2:00 PM zhaoya <zhaoya.gaius@bytedance.com> wrote:
>
> When using syncookie, since $MSSID is spliced into cookie and
> the legal index of msstab  is 0,1,2,3, this gives client 3 bytes
> of freedom, resulting in at most 3 bytes of silent loss.
>
> C ------------seq=12345-------------> S
> C <------seq=cookie/ack=12346-------- S S generated the cookie
>                                         [RFC4987 Appendix A]
> C ---seq=123456/ack=cookie+1-->X      S The first byte was loss.
> C -----seq=123457/ack=cookie+1------> S The second byte was received and
>                                         cookie-check was still okay and
>                                         handshake was finished.
> C <--------seq=.../ack=12348--------- S acknowledge the second byte.
>
> Here is a POC:
>
> $ cat poc.c
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <unistd.h>
> #include <pthread.h>
> #include <sys/types.h>
> #include <sys/socket.h>
> #include <netinet/in.h>
> #include <arpa/inet.h>
>
> void *serverfunc(void *arg)
> {
>         int sd = -1;
>         int csd = -1;
>         struct sockaddr_in servaddr, cliaddr;
>         int len = sizeof(cliaddr);
>
>         sd = socket(AF_INET, SOCK_STREAM, 0);
>         servaddr.sin_family = AF_INET;
>         servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
>         servaddr.sin_port = htons(1234);
>         bind(sd, (struct sockaddr *)&servaddr, sizeof(servaddr));
>         listen(sd, 1);
>
>         while (1) {
>                 char buf[2];
>                 int ret;
>                 csd = accept(sd, (struct sockaddr *)&cliaddr, &len);
>                 memset(buf, 0, 2);
>                 ret = recv(csd, buf, 1, 0);
>                 // but unexpected char is 'b'
>                 if (ret && strncmp(buf, "a", 1)) {
>                         printf("unexpected:%s\n", buf);
>                         close(csd);
>                         exit(0);
>                 }
>                 close(csd);
>         }
> }
>
> void *connectfunc(void *arg)
> {
>         struct sockaddr_in addr;
>         int sd;
>         int i;
>
>         for (i = 0; i < 500; i++) {
>                 sd = socket(AF_INET, SOCK_STREAM, 0);
>                 addr.sin_family = AF_INET;
>                 addr.sin_addr.s_addr = inet_addr("127.0.0.1");
>                 addr.sin_port = htons(1234);
>
>                 connect(sd, (struct sockaddr *)&addr, sizeof(addr));
>
>                 send(sd, "a", 1, 0); // expected char is 'a'
>                 send(sd, "b", 1, 0);
>                 close(sd);
>         }
>         return NULL;
> }
>
> int main(int argc, char *argv[])
> {
>         int i;
>         pthread_t id;
>
>         pthread_create(&id, NULL, serverfunc, NULL);
>         sleep(1);
>         for (i = 0; i < 500; i++) {
>                 pthread_create(&id, NULL, connectfunc, NULL);
>         }
>         sleep(5);
> }
>
> $ sudo gcc poc.c -lpthread
> $ sudo sysctl -w net.ipv4.tcp_syncookies=1
> $ sudo ./a.out # please try as many times.
>

POC is distracting, you could instead give a link to
https://kognitio.com/blog/syn-cookies-ate-my-dog-breaking-tcp-on-linux/
where all the details can be found.

Also it gives credits to past work.

If you feel a program needs to be written and recorded for posterity,
add a selftest. (in tools/testing/selftests/net )

> This problem can be fixed by having $SSEQ itself participate in the
> hash operation.
>
> The feature is protected by a sysctl so that admins can choose
> the preferred behavior.
>
> Signed-off-by: zhaoya <zhaoya.gaius@bytedance.com>
> ---
>  Documentation/networking/ip-sysctl.rst |  9 ++++++++
>  include/linux/netfilter_ipv6.h         | 24 +++++++++++++-------
>  include/net/netns/ipv4.h               |  1 +
>  include/net/tcp.h                      | 20 ++++++++++-------
>  net/core/filter.c                      |  6 +++--
>  net/ipv4/syncookies.c                  | 31 ++++++++++++++++----------
>  net/ipv4/sysctl_net_ipv4.c             |  7 ++++++
>  net/ipv4/tcp_ipv4.c                    |  4 +++-
>  net/ipv6/syncookies.c                  | 29 +++++++++++++++---------
>  net/ipv6/tcp_ipv6.c                    |  3 ++-
>  net/netfilter/nf_synproxy_core.c       | 10 +++++----
>  11 files changed, 97 insertions(+), 47 deletions(-)
>
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index c7952ac5bd2f..a430e8736c2b 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -732,6 +732,15 @@ tcp_syncookies - INTEGER
>         network connections you can set this knob to 2 to enable
>         unconditionally generation of syncookies.
>
> +tcp_syncookies_enorder - INTEGER

enorder ? What does it mean ?

> +       Only valid when the kernel was compiled with CONFIG_SYN_COOKIES
> +       Prevent the loss of at most 3 bytes of which sent by client when
> +       syncookies as generated to complete TCP-Handshake.
> +       Default: 0
> +
> +       Note that if it was enabled, any out-of-order bytes sent by client
> +       to complete TCP-Handshake could get the session killed.

Technically speaking, the client does not send out-of-order packets.

The issue here is that loss of packets sent after 3WHS can lead to RST
and session being killed.


> +
>  tcp_fastopen - INTEGER
>         Enable TCP Fast Open (RFC7413) to send and accept data in the opening
>         SYN packet.
> diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
> index 48314ade1506..97b67672dee7 100644
> --- a/include/linux/netfilter_ipv6.h
> +++ b/include/linux/netfilter_ipv6.h
> @@ -49,9 +49,11 @@ struct nf_ipv6_ops {
>         int (*route)(struct net *net, struct dst_entry **dst, struct flowi *fl,
>                      bool strict);
>         u32 (*cookie_init_sequence)(const struct ipv6hdr *iph,
> -                                   const struct tcphdr *th, u16 *mssp);
> +                                   const struct tcphdr *th, u16 *mssp,
> +                                   int enorder);
>

Patch is too big, and passing either a ' struct net'  or an ' int
enorder' is not pretty/consistent.

Please send a patch series :

1) Add ' struct net'  pointers to all helpers which will need it
later. This is a pure preparation work, easy to review.

2) Patch itself, adding the sysctl.

    I would prefer you add a helper like this and use it every where
you need to use the sysctl so that it is factorized

  static inline u32 tcp_cond_seq(const struct net *net, u32 seq)
{
    return net->ipv4.sysctl_tcp_syncookie_no_eat ? seq : 0;
}

And use this helper  in functions right before using (or not) the seq
in hash functions/
(Do not pass around the result of the helper)

Thanks.
