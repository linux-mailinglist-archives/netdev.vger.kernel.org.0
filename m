Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BAE677765
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 09:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbfG0HFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 03:05:53 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:41194 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfG0HFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 03:05:53 -0400
Received: by mail-yb1-f194.google.com with SMTP id x188so15750962yba.8
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 00:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ub5PKkn5EFfxxnY9bb39Ftw8pu5yDUa3VBuzjuSOfzE=;
        b=XfmmckmQDh6+fBoBPIeXBbtQpCSL4eyFL8BIQ+pdmEK7vvAmPm30S1i19dXL2B3Oro
         DXCjAWVsow7yHUOgU34oYt6BcM317Kz8ZFDL7LnmkI9XpjQQJ8HrupoNCMzFXnQVMxFY
         PkwT/qL8mi7Z83zmfEXYsUEsq45U2EzS9apsoQqM1izTDpdt2G6/x5O9VqM+o1m9p3ZY
         qbtA163DOKDHnuNI5JxG7GxcTL+586vk2Tgm2667R5IcHUf19uuA9YCkTHj2MCUfaI80
         cHjgGLiKatAsjtfSvrZoCwcrwsKW+bGzNycpB74M8US70kv36R+Uzp9zZ/uEZfkeSj1H
         MiaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ub5PKkn5EFfxxnY9bb39Ftw8pu5yDUa3VBuzjuSOfzE=;
        b=j1oWIN6cRkpDDV4GyUmrTDT+Z6gDH8ZKMmvOdrUFsBDRTasfFK+zLGPkWQ4kt51Jaf
         GxTTDq9uXv6o6gyGDfVIxYr1B9A800wrsalLKnxPM/VQeQIe79Ahl/MfdGK8Do+0XWaH
         pFIdCUaBfuMpkA6bleEH6Z5WfyLY1WS48/JfTURNS+zPJRa6DswsrooLNHKyrhHuhVDA
         uGd+TvajprKYJtmGj0XLhyNCh0FdJNNwn6hujsE3O/fScwYhaQooEwLRl7ffRdqXC1xp
         WeaO/4mGRthtpFxqFp9dlZjl51f67stgg+hvWPbdQAZwk1dswsWYJ09V8HVCKO7am0sC
         GJNA==
X-Gm-Message-State: APjAAAWieJMeWEs9VX+FsaTv+xOLzRSQI/abzH1lg78qZHc/OWKpC3pX
        9GOClFY9s4YvSncIbUBxUJ7dk0voG4TckHAcIDBxpA==
X-Google-Smtp-Source: APXvYqziauk9S0SO4ysDFYsjbZ+1M6kxz19XmDsYg/G/M4Av0VWWr0BGcgGH1k3VXMe0GMphuyP/WkdPHvZGpmrebL8=
X-Received: by 2002:a25:9343:: with SMTP id g3mr52940500ybo.234.1564211151456;
 Sat, 27 Jul 2019 00:05:51 -0700 (PDT)
MIME-Version: 1.0
References: <1564194225-14342-1-git-send-email-johunt@akamai.com>
In-Reply-To: <1564194225-14342-1-git-send-email-johunt@akamai.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 27 Jul 2019 09:05:39 +0200
Message-ID: <CANn89iJtw_XrU-F0-frE=P6egH99kF0W0kTzReK701LmigcJ4Q@mail.gmail.com>
Subject: Re: [PATCH] tcp: add new tcp_mtu_probe_floor sysctl
To:     Josh Hunt <johunt@akamai.com>
Cc:     netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 27, 2019 at 4:23 AM Josh Hunt <johunt@akamai.com> wrote:
>
> The current implementation of TCP MTU probing can considerably
> underestimate the MTU on lossy connections allowing the MSS to get down to
> 48. We have found that in almost all of these cases on our networks these
> paths can handle much larger MTUs meaning the connections are being
> artificially limited. Even though TCP MTU probing can raise the MSS back up
> we have seen this not to be the case causing connections to be "stuck" with
> an MSS of 48 when heavy loss is present.
>
> Prior to pushing out this change we could not keep TCP MTU probing enabled
> b/c of the above reasons. Now with a reasonble floor set we've had it
> enabled for the past 6 months.

And what reasonable value have you used ???

>
> The new sysctl will still default to TCP_MIN_SND_MSS (48), but gives
> administrators the ability to control the floor of MSS probing.
>
> Signed-off-by: Josh Hunt <johunt@akamai.com>
> ---
>  Documentation/networking/ip-sysctl.txt | 6 ++++++
>  include/net/netns/ipv4.h               | 1 +
>  net/ipv4/sysctl_net_ipv4.c             | 9 +++++++++
>  net/ipv4/tcp_ipv4.c                    | 1 +
>  net/ipv4/tcp_timer.c                   | 2 +-
>  5 files changed, 18 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
> index df33674799b5..49e95f438ed7 100644
> --- a/Documentation/networking/ip-sysctl.txt
> +++ b/Documentation/networking/ip-sysctl.txt
> @@ -256,6 +256,12 @@ tcp_base_mss - INTEGER
>         Path MTU discovery (MTU probing).  If MTU probing is enabled,
>         this is the initial MSS used by the connection.
>
> +tcp_mtu_probe_floor - INTEGER
> +       If MTU probing is enabled this caps the minimum MSS used for search_low
> +       for the connection.
> +
> +       Default : 48
> +
>  tcp_min_snd_mss - INTEGER
>         TCP SYN and SYNACK messages usually advertise an ADVMSS option,
>         as described in RFC 1122 and RFC 6691.
> diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
> index bc24a8ec1ce5..c0c0791b1912 100644
> --- a/include/net/netns/ipv4.h
> +++ b/include/net/netns/ipv4.h
> @@ -116,6 +116,7 @@ struct netns_ipv4 {
>         int sysctl_tcp_l3mdev_accept;
>  #endif
>         int sysctl_tcp_mtu_probing;
> +       int sysctl_tcp_mtu_probe_floor;
>         int sysctl_tcp_base_mss;
>         int sysctl_tcp_min_snd_mss;
>         int sysctl_tcp_probe_threshold;
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index 0b980e841927..59ded25acd04 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -820,6 +820,15 @@ static struct ctl_table ipv4_net_table[] = {
>                 .extra2         = &tcp_min_snd_mss_max,
>         },
>         {
> +               .procname       = "tcp_mtu_probe_floor",
> +               .data           = &init_net.ipv4.sysctl_tcp_mtu_probe_floor,
> +               .maxlen         = sizeof(int),
> +               .mode           = 0644,
> +               .proc_handler   = proc_dointvec_minmax,
> +               .extra1         = &tcp_min_snd_mss_min,
> +               .extra2         = &tcp_min_snd_mss_max,
> +       },
> +       {
>                 .procname       = "tcp_probe_threshold",
>                 .data           = &init_net.ipv4.sysctl_tcp_probe_threshold,
>                 .maxlen         = sizeof(int),
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index d57641cb3477..e0a372676329 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -2637,6 +2637,7 @@ static int __net_init tcp_sk_init(struct net *net)
>         net->ipv4.sysctl_tcp_min_snd_mss = TCP_MIN_SND_MSS;
>         net->ipv4.sysctl_tcp_probe_threshold = TCP_PROBE_THRESHOLD;
>         net->ipv4.sysctl_tcp_probe_interval = TCP_PROBE_INTERVAL;
> +       net->ipv4.sysctl_tcp_mtu_probe_floor = TCP_MIN_SND_MSS;
>
>         net->ipv4.sysctl_tcp_keepalive_time = TCP_KEEPALIVE_TIME;
>         net->ipv4.sysctl_tcp_keepalive_probes = TCP_KEEPALIVE_PROBES;
> diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
> index c801cd37cc2a..dbd9d2d0ee63 100644
> --- a/net/ipv4/tcp_timer.c
> +++ b/net/ipv4/tcp_timer.c
> @@ -154,7 +154,7 @@ static void tcp_mtu_probing(struct inet_connection_sock *icsk, struct sock *sk)
>         } else {
>                 mss = tcp_mtu_to_mss(sk, icsk->icsk_mtup.search_low) >> 1;
>                 mss = min(net->ipv4.sysctl_tcp_base_mss, mss);
> -               mss = max(mss, 68 - tcp_sk(sk)->tcp_header_len);
> +               mss = max(mss, net->ipv4.sysctl_tcp_mtu_probe_floor);
>                 mss = max(mss, net->ipv4.sysctl_tcp_min_snd_mss);
>                 icsk->icsk_mtup.search_low = tcp_mss_to_mtu(sk, mss);
>         }


Existing sysctl should be enough ?

tcp_min_snd_mss  documentation could be slightly updated.

And maybe its default value could be raised a bit.
