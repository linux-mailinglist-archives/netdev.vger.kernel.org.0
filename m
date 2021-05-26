Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA15391A5B
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 16:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234830AbhEZOgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 10:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbhEZOgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 10:36:44 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278BFC061574
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 07:35:13 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id y2so2303011ybq.13
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 07:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JFMiQ1oT/nQBQJWxoBwnG19CNT17KDuyVJC9NnQkfeE=;
        b=soGJnD66WxbUEW5De3S4mUIIu2isKw3F6DMPY+JrtIUdSOhVv2nEV3r+Q23nQwTDIZ
         IJs29pCzl0ap3ZE1MHQ0SJjYX/8E6KpYjRtVyEXKKLC+znmr1+6R/joRIyFw9udNYd62
         No591Otf1NcbHlycSAtbyNwYACzsaNfq13pEVLgClxBaPVbE85Eho4/JQAMHYk/nRGKo
         QCzoZNU7pUFwnQswm0SzNbBt0chqPwRQcKgmvdHmtEiDOlEaDTKADcGwXFWbJFiARTtq
         tMaUt/LEJQVsQISCyQ8r/q5/uRe+ZxXPisjYip4B5Wt003o1DIXUcgVrVzUnoV8w9YM0
         gq1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JFMiQ1oT/nQBQJWxoBwnG19CNT17KDuyVJC9NnQkfeE=;
        b=tc7epWdsWAJZrPxDmSK53gYInYcB/+aboTM7MIhbwMcpF8kVzxQEAU+DOZKDOqxpog
         WQUCCayORDBKxjuHL5vxUM/y0RSBQr/MJKIb+SoBscHm1uQQt7HXE3RCMbzKGvYxkFzP
         xNasfhEdVbcMW2Zx28tkkdjv9IZsjYRbS8AentzRax53s/xR7GSPtSoRFgtH7UoVrs2z
         d6JOvRku9czBABR+RZ5hDZmP2SXpzMonKVIx8wAAUsRJXoVF5T7LyUc2F8CNlvAELsPN
         fddd+biAA153PhZjP8d1u2bZmDlJ0L1POAPq7SBkD1oNJWaMe4D/q/OBEkuD0/TJs8+W
         Xztg==
X-Gm-Message-State: AOAM530CoOaSxcwPNOfU6MUPAkEdVMLI1yBSyGMYwrBVs28JUwuWsOk4
        g9zlZsvwO7YiO3r/EzcoPZ8qMekTIzGTRkss9UG0Fw==
X-Google-Smtp-Source: ABdhPJwU5LlUgtsHl1OpJHfF3AHb+E7Fh1N4xsVob/Xz1TvnI0xhHbTWRnoipbfuYuvxQsumv/3JENW1SwVbdEsBLkg=
X-Received: by 2002:a25:5ec2:: with SMTP id s185mr49604119ybb.303.1622039711946;
 Wed, 26 May 2021 07:35:11 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1622025457.git.cdleonard@gmail.com> <e6dac4f513fa2ca96ccb4dcc5b11f96b3f9ddc40.1622025457.git.cdleonard@gmail.com>
In-Reply-To: <e6dac4f513fa2ca96ccb4dcc5b11f96b3f9ddc40.1622025457.git.cdleonard@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 26 May 2021 16:35:00 +0200
Message-ID: <CANn89iKT9-dsynbQaWywJ=+=mQmqU7uWesmT6iJBCjzyZMTXFg@mail.gmail.com>
Subject: Re: [RFCv2 3/3] tcp: Wait for sufficient data in tcp_mtu_probe
To:     Leonard Crestez <cdleonard@gmail.com>
Cc:     Neal Cardwell <ncardwell@google.com>,
        Matt Mathis <mattmathis@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        John Heffner <johnwheffner@gmail.com>,
        Leonard Crestez <lcrestez@drivenets.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 12:38 PM Leonard Crestez <cdleonard@gmail.com> wrote:
>
> According to RFC4821 Section 7.4 "Protocols MAY delay sending non-probes
> in order to accumulate enough data" but linux almost never does that.
>
> Implement this by returning 0 from tcp_mtu_probe if not enough data is
> queued locally but some packets are still in flight. This makes mtu
> probing more likely to happen for applications that do small writes.
>
> Only doing this if packets are in flight should ensure that writing will
> be attempted again later. This is similar to how tcp_mtu_probe already
> returns zero if the probe doesn't fit inside the receiver window or the
> congestion window.
>
> Control this with a sysctl because this implies a latency tradeoff but
> only up to one RTT.
>
> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> ---
>  Documentation/networking/ip-sysctl.rst |  5 +++++
>  include/net/netns/ipv4.h               |  1 +
>  net/ipv4/sysctl_net_ipv4.c             |  7 +++++++
>  net/ipv4/tcp_ipv4.c                    |  1 +
>  net/ipv4/tcp_output.c                  | 18 ++++++++++++++----
>  5 files changed, 28 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index 7ab52a105a5d..967b7fac35b1 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -349,10 +349,15 @@ tcp_mtu_probe_floor - INTEGER
>         If MTU probing is enabled this caps the minimum MSS used for search_low
>         for the connection.
>
>         Default : 48
>
> +tcp_mtu_probe_waitdata - BOOLEAN
> +       Wait for enough data for an mtu probe to accumulate on the sender.
> +
> +       Default: 1
> +
>  tcp_mtu_probe_rack - BOOLEAN
>         Try to use shorter probes if RACK is also enabled
>
>         Default: 1
>
> diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
> index b4ff12f25a7f..366e7b325778 100644
> --- a/include/net/netns/ipv4.h
> +++ b/include/net/netns/ipv4.h
> @@ -112,10 +112,11 @@ struct netns_ipv4 {
>  #ifdef CONFIG_NET_L3_MASTER_DEV
>         u8 sysctl_tcp_l3mdev_accept;
>  #endif
>         u8 sysctl_tcp_mtu_probing;
>         int sysctl_tcp_mtu_probe_floor;
> +       int sysctl_tcp_mtu_probe_waitdata;

If this is a boolean, you should use u8, and place this field to avoid
adding a hole.

>         int sysctl_tcp_mtu_probe_rack;
>         int sysctl_tcp_base_mss;
>         int sysctl_tcp_min_snd_mss;
>         int sysctl_tcp_probe_threshold;
>         u32 sysctl_tcp_probe_interval;
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index 275c91fb9cf8..53868b812958 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -847,10 +847,17 @@ static struct ctl_table ipv4_net_table[] = {
>                 .mode           = 0644,
>                 .proc_handler   = proc_dointvec_minmax,
>                 .extra1         = &tcp_min_snd_mss_min,
>                 .extra2         = &tcp_min_snd_mss_max,
>         },
> +       {
> +               .procname       = "tcp_mtu_probe_waitdata",
> +               .data           = &init_net.ipv4.sysctl_tcp_mtu_probe_waitdata,
> +               .maxlen         = sizeof(int),
> +               .mode           = 0644,
> +               .proc_handler   = proc_dointvec,

If this is a boolean, please use proc_dou8vec_minmax, and SYSCTL_ZERO/SYSCTL_ONE

> +       },
>         {
>                 .procname       = "tcp_mtu_probe_rack",
>                 .data           = &init_net.ipv4.sysctl_tcp_mtu_probe_rack,
>                 .maxlen         = sizeof(int),
>                 .mode           = 0644,
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index ed8af4a7325b..940df2ae4636 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -2892,10 +2892,11 @@ static int __net_init tcp_sk_init(struct net *net)
>         net->ipv4.sysctl_tcp_base_mss = TCP_BASE_MSS;
>         net->ipv4.sysctl_tcp_min_snd_mss = TCP_MIN_SND_MSS;
>         net->ipv4.sysctl_tcp_probe_threshold = TCP_PROBE_THRESHOLD;
>         net->ipv4.sysctl_tcp_probe_interval = TCP_PROBE_INTERVAL;
>         net->ipv4.sysctl_tcp_mtu_probe_floor = TCP_MIN_SND_MSS;
> +       net->ipv4.sysctl_tcp_mtu_probe_waitdata = 1;
>         net->ipv4.sysctl_tcp_mtu_probe_rack = 1;
>
>         net->ipv4.sysctl_tcp_keepalive_time = TCP_KEEPALIVE_TIME;
>         net->ipv4.sysctl_tcp_keepalive_probes = TCP_KEEPALIVE_PROBES;
>         net->ipv4.sysctl_tcp_keepalive_intvl = TCP_KEEPALIVE_INTVL;
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 362f97cfb09e..268e1bac001f 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -2394,14 +2394,10 @@ static int tcp_mtu_probe(struct sock *sk)
>                  */
>                 tcp_mtu_check_reprobe(sk);
>                 return -1;
>         }
>
> -       /* Have enough data in the send queue to probe? */
> -       if (tp->write_seq - tp->snd_nxt < size_needed)
> -               return -1;
> -
>         /* Can probe fit inside congestion window? */
>         if (packets_needed > tp->snd_cwnd)
>                 return -1;
>
>         /* Can probe fit inside receiver window? If not then skip probing.
> @@ -2411,10 +2407,24 @@ static int tcp_mtu_probe(struct sock *sk)
>          * clear below.
>          */
>         if (tp->snd_wnd < size_needed)
>                 return -1;
>
> +       /* Have enough data in the send queue to probe? */
> +       if (tp->write_seq - tp->snd_nxt < size_needed) {
> +               /* If packets are already in flight it's safe to wait for more data to
> +                * accumulate on the sender because writing will be triggered as ACKs
> +                * arrive.
> +                * If no packets are in flight returning zero can stall.
> +                */
> +               if (net->ipv4.sysctl_tcp_mtu_probe_waitdata &&

I have serious doubts about RPC traffic.
Adding one RTT latency is going to make this unlikely to be used.

> +                   tcp_packets_in_flight(tp))
> +                       return 0;
> +               else
> +                       return -1;
> +       }
> +
>         /* Do we need for more acks to clear the receive window? */
>         if (after(tp->snd_nxt + size_needed, tcp_wnd_end(tp)))
>                 return 0;
>
>         /* Do we need the congestion window to clear? */
> --
> 2.25.1
>
