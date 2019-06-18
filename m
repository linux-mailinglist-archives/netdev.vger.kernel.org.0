Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE8D4963E
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 02:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbfFRASf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 20:18:35 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44701 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbfFRASe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 20:18:34 -0400
Received: by mail-pl1-f196.google.com with SMTP id t7so4897639plr.11
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 17:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hocnr3ADCF/48h6qr4g0S/T+ZTxODk59b0+DzVZlOBs=;
        b=PHCrgBbtf5C0aydCYWmKUjQ+4KtVtgRWVWEDO/SCotog+R8lPb5OiPa797A6Zm7f1E
         TehHQdJ5MeCUEn8NcRfnBvsnzKRZupcvplCO7xiTW6R3VhAlR4eTWb3ueVkhzG0qg+d6
         rPZKPk39PT1fnMeHBPteJbW+LujySiYMfKmQ6QpUuHKz3VuxrRmPYzlKpCjaUImhW5Mn
         O3P03M0OPUydOefBvd8Ho+zNxp7f8izemSR4z5U9blEsu3HnKSzDMXs9uGsmUgnEz5Lg
         8RUepQPdrlzuYbnlG6G2vUZDAaC3oeWhG28e0HB1BrZf+FF91PjAbqaCdNp0+Q0FfqS2
         cCnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hocnr3ADCF/48h6qr4g0S/T+ZTxODk59b0+DzVZlOBs=;
        b=fu1zB3EIUrryhkvuWi5R8syiNTa6fBokeKHVnr9Irm3fzK190p2hY4nXj7fVe4O8Ne
         XPrvneMGNmBMdS4q8SY4IcMXLywFMFYUDNPIF5TvWkb9RxYJvxz/x7BI4MDlYIiER3Bi
         BQPD3vtVJLiFnWxQIx+Izb+/4jR+G53G+Nmik77oN7F5I705/Tsqh2RHdiS5/LDqW7j9
         guOMfPVnW101dTx8zGdAmfM5rTsk3YYfSxS00RehqUoXs8vkkqum0/BUMki4sYn2xLyB
         CO61UEPE7SsWHtWN6cMABAtTclUaqRGH3rs6yaHroII9APFDODTe7PiKNWz2Zlgkkk8P
         NUnA==
X-Gm-Message-State: APjAAAURnJ44KNlBID3rjaa5caK7jVPS3JAr5OLCRV5D0C7mZHv9A3b4
        OUL4PUHU/1117bcVkXaUqwYwRTxaMom6qQ0Y9tg=
X-Google-Smtp-Source: APXvYqzO/xcSyg/vuZoglbXwK2RlIM8o2c4dZb+xPTlF+IMNoDFN6yNcWbYW4nUpGM983Qvhi1eWgvGorNbr29Q7+68=
X-Received: by 2002:a17:902:363:: with SMTP id 90mr24993279pld.340.1560817113574;
 Mon, 17 Jun 2019 17:18:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190617170354.37770-1-edumazet@google.com> <20190617170354.37770-3-edumazet@google.com>
In-Reply-To: <20190617170354.37770-3-edumazet@google.com>
From:   Christoph Paasch <christoph.paasch@gmail.com>
Date:   Mon, 17 Jun 2019 17:18:22 -0700
Message-ID: <CALMXkpYVRxgeqarp4gnmX7GqYh1sWOAt6UaRFqYBOaaNFfZ5sw@mail.gmail.com>
Subject: Re: [PATCH net 2/4] tcp: tcp_fragment() should apply sane memory limits
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Looney <jtl@netflix.com>,
        Neal Cardwell <ncardwell@google.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Yuchung Cheng <ycheng@google.com>,
        Bruce Curtis <brucec@netflix.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dustin Marquess <dmarquess@apple.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 10:05 AM Eric Dumazet <edumazet@google.com> wrote:
>
> Jonathan Looney reported that a malicious peer can force a sender
> to fragment its retransmit queue into tiny skbs, inflating memory
> usage and/or overflow 32bit counters.
>
> TCP allows an application to queue up to sk_sndbuf bytes,
> so we need to give some allowance for non malicious splitting
> of retransmit queue.
>
> A new SNMP counter is added to monitor how many times TCP
> did not allow to split an skb if the allowance was exceeded.
>
> Note that this counter might increase in the case applications
> use SO_SNDBUF socket option to lower sk_sndbuf.
>
> CVE-2019-11478 : tcp_fragment, prevent fragmenting a packet when the
>         socket is already using more than half the allowed space
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Jonathan Looney <jtl@netflix.com>
> Acked-by: Neal Cardwell <ncardwell@google.com>
> Acked-by: Yuchung Cheng <ycheng@google.com>
> Reviewed-by: Tyler Hicks <tyhicks@canonical.com>
> Cc: Bruce Curtis <brucec@netflix.com>
> Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  include/uapi/linux/snmp.h | 1 +
>  net/ipv4/proc.c           | 1 +
>  net/ipv4/tcp_output.c     | 5 +++++
>  3 files changed, 7 insertions(+)
>
> diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
> index 86dc24a96c90ab047d5173d625450facd6c6dd79..fd42c1316d3d112ecd8a00d2b499d6f6901c5e81 100644
> --- a/include/uapi/linux/snmp.h
> +++ b/include/uapi/linux/snmp.h
> @@ -283,6 +283,7 @@ enum
>         LINUX_MIB_TCPACKCOMPRESSED,             /* TCPAckCompressed */
>         LINUX_MIB_TCPZEROWINDOWDROP,            /* TCPZeroWindowDrop */
>         LINUX_MIB_TCPRCVQDROP,                  /* TCPRcvQDrop */
> +       LINUX_MIB_TCPWQUEUETOOBIG,              /* TCPWqueueTooBig */
>         __LINUX_MIB_MAX
>  };
>
> diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
> index 4370f4246e86dfe06a9e07cace848baeaf6cc4da..073273b751f8fcda1c9c79cd1ab566f2939b2517 100644
> --- a/net/ipv4/proc.c
> +++ b/net/ipv4/proc.c
> @@ -287,6 +287,7 @@ static const struct snmp_mib snmp4_net_list[] = {
>         SNMP_MIB_ITEM("TCPAckCompressed", LINUX_MIB_TCPACKCOMPRESSED),
>         SNMP_MIB_ITEM("TCPZeroWindowDrop", LINUX_MIB_TCPZEROWINDOWDROP),
>         SNMP_MIB_ITEM("TCPRcvQDrop", LINUX_MIB_TCPRCVQDROP),
> +       SNMP_MIB_ITEM("TCPWqueueTooBig", LINUX_MIB_TCPWQUEUETOOBIG),
>         SNMP_MIB_SENTINEL
>  };
>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index b8e3bbb852117459d131fbb41d69ae63bd251a3e..1bb1c46b4abad100622d3f101a0a3ca0a6c8e881 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -1296,6 +1296,11 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
>         if (nsize < 0)
>                 nsize = 0;
>
> +       if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf)) {
> +               NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPWQUEUETOOBIG);
> +               return -ENOMEM;
> +       }
> +

Hi Eric, I now have a packetdrill test that started failing (see
below). Admittedly, a bit weird test with the SO_SNDBUF forced so low.

Nevertheless, previously this test would pass, now it stalls after the
write() because tcp_fragment() returns -ENOMEM. Your commit-message
mentions that this could trigger when one sets SO_SNDBUF low. But,
here we have a complete stall of the connection and we never recover.

I don't know if we care about this, but there it is :-)


Christoph

----
--tolerance_usecs=10000

+0.0 `ifconfig tun0 mtu 5060`
+0.0 `ethtool -K tun0 tso off` // don't send big segments > MSS

+0.015 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
+0.0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
+0.0 bind(3, ..., ...) = 0

+0.0 setsockopt(3, SOL_SOCKET, SO_SNDBUF, [2000], 4) = 0

+0.0 listen(3, 1) = 0

+0 < S 0:0(0) win 24900 <mss 5020,sackOK,nop,nop,nop,wscale 7>
+0 > S. 0:0(0) ack 1 <mss 5020,sackOK,nop,nop,nop,wscale 7>
+0 < . 1:1(0) ack 1 win 257
+0 accept(3, ..., ...) = 4

+0 setsockopt(4, SOL_TCP, TCP_CORK, [1], 4) = 0

+0 write(4, ..., 9999) = 9999
+0.0 > . 1:5021(5020) ack 1
+0.01 <  . 1:1(0) ack 5021 win 257

+0.206 > P. 5021:10000(4979) ack 1
+0.01 <  . 1:1(0) ack 10000 win 257
