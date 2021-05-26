Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C8E391716
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 14:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234665AbhEZMNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 08:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234624AbhEZMNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 08:13:07 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60151C061574
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 05:11:35 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id d14so630993ual.5
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 05:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wUrqUb+kQg/Cy2UpM0h/vb3YRuG2NknvwTkQpjDYiFE=;
        b=T75LtX9Ha4dUohpGT6QW/p+sIlKUltSigBHVaV9Y6z8OpanQ7PeoIN7kwbh8nNtDj4
         RylFW4YBVRIKh5Tn+cnmBrz7NFncGEwLLEAHu6YBvIZdwftBODAKeBGau9rKLFdJvaCf
         o32WXcNI+TNb7/QTh3RM4J6uSxTpCt4+VKUjT18cw8gYMAUuYidQz2H/ln/2aDQbeYrK
         bxOWkJzlZFIbE+BYZHqxA2vngVs7BQzP0j32J9fqsa2rROZndeMR8+6PbCRXR3d0xbOX
         nCArosdAVzNuO1RUqjDjupELYpLt0xQMmACD0ELKgtDxnR1T3EkSixT+2VLqmiu/zZEu
         M0YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wUrqUb+kQg/Cy2UpM0h/vb3YRuG2NknvwTkQpjDYiFE=;
        b=ZViQ7vx8muXm2JT51EkG0LJpf/NVuxwrEmNpDs+nij2Xig9nz+XERjPI7notA7CMKy
         dtfnwLpjKCAgB3mK4z1Q+gQhLx1QunJntzLVYYaoCnhdbjfzsgvQjfrJoUT8xf34xtAW
         EFqrMxy4O4QZRFkutQy4Q56IbIQ4HmWcCmlGlejDrtQpZA8zaeBoDP8Z2+dU/2Wp6FTZ
         GA6/dq2GJO3sSONFhyuqXAAwPP6RvMeV+TFg2LccU8U3ss8/Uc2wWyZIPuK0XvZx3GxY
         mpvaTxJDbyrVLR05GIevrwEroEV+GyHrJ25vToYaS2gaZEEi6PCRG+1AXxR9bkKXvZ9c
         ydmQ==
X-Gm-Message-State: AOAM532Bz4bzof6VJR2bOrAJ38INKuXaD0Oh3Y+RrQ2bU0c65+AlL/LK
        xal2RUpgANbNEcrVoEvwwpHl8J4Zh53G8F9gd5YgIw==
X-Google-Smtp-Source: ABdhPJydoB/kck2wwRkxwdIl52sarGpJ+jtKrbgItW2PI1YMDBkkWfNXsZe0zB/i4T1hICv4GLkTRQwa5+YLRJhMqHQ=
X-Received: by 2002:a9f:382c:: with SMTP id p41mr31641886uad.65.1622031094259;
 Wed, 26 May 2021 05:11:34 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1622025457.git.cdleonard@gmail.com> <750563aba3687119818dac09fc987c27c7152324.1622025457.git.cdleonard@gmail.com>
In-Reply-To: <750563aba3687119818dac09fc987c27c7152324.1622025457.git.cdleonard@gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Wed, 26 May 2021 08:11:17 -0400
Message-ID: <CADVnQynoD=NF2hG6Bs44A0jrnKG=3f97OywS-tq-p-KQAsf5Fg@mail.gmail.com>
Subject: Re: [RFCv2 1/3] tcp: Use smaller mtu probes if RACK is enabled
To:     Leonard Crestez <cdleonard@gmail.com>
Cc:     Matt Mathis <mattmathis@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        John Heffner <johnwheffner@gmail.com>,
        Leonard Crestez <lcrestez@drivenets.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 6:38 AM Leonard Crestez <cdleonard@gmail.com> wrote:
>
> RACK allows detecting a loss in rtt + min_rtt / 4 based on just one
> extra packet. If enabled use this instead of relying of fast retransmit.

IMHO it would be worth adding some more text to motivate the change,
to justify the added complexity and risk from the change. The
substance of the change seems to be decreasing the requirement for
PMTU probing from needing roughly 5 packets worth of data to needing
roughly 3 packets worth of data. It's not clear to me as a reader of
this patch by itself that there are lots of applications that very
often only have 3-4 packets worth of data to send and yet can benefit
greatly from PMTU discovery.

> Suggested-by: Neal Cardwell <ncardwell@google.com>
> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> ---
>  Documentation/networking/ip-sysctl.rst |  5 +++++
>  include/net/netns/ipv4.h               |  1 +
>  net/ipv4/sysctl_net_ipv4.c             |  7 +++++++
>  net/ipv4/tcp_ipv4.c                    |  1 +
>  net/ipv4/tcp_output.c                  | 26 +++++++++++++++++++++++++-
>  5 files changed, 39 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index a5c250044500..7ab52a105a5d 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -349,10 +349,15 @@ tcp_mtu_probe_floor - INTEGER
>         If MTU probing is enabled this caps the minimum MSS used for search_low
>         for the connection.
>
>         Default : 48
>
> +tcp_mtu_probe_rack - BOOLEAN
> +       Try to use shorter probes if RACK is also enabled
> +
> +       Default: 1

I  would vote to not have a sysctl for this. If we think it's a good
idea to allow MTU probing with a smaller amount of data if RACK is
enabled (which seems true to me), then this is a low-risk enough
change that we should just change the behavior.

>  tcp_min_snd_mss - INTEGER
>         TCP SYN and SYNACK messages usually advertise an ADVMSS option,
>         as described in RFC 1122 and RFC 6691.
>
>         If this ADVMSS option is smaller than tcp_min_snd_mss,
> diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
> index 746c80cd4257..b4ff12f25a7f 100644
> --- a/include/net/netns/ipv4.h
> +++ b/include/net/netns/ipv4.h
> @@ -112,10 +112,11 @@ struct netns_ipv4 {
>  #ifdef CONFIG_NET_L3_MASTER_DEV
>         u8 sysctl_tcp_l3mdev_accept;
>  #endif
>         u8 sysctl_tcp_mtu_probing;
>         int sysctl_tcp_mtu_probe_floor;
> +       int sysctl_tcp_mtu_probe_rack;
>         int sysctl_tcp_base_mss;
>         int sysctl_tcp_min_snd_mss;
>         int sysctl_tcp_probe_threshold;
>         u32 sysctl_tcp_probe_interval;
>
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index 4fa77f182dcb..275c91fb9cf8 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -847,10 +847,17 @@ static struct ctl_table ipv4_net_table[] = {
>                 .mode           = 0644,
>                 .proc_handler   = proc_dointvec_minmax,
>                 .extra1         = &tcp_min_snd_mss_min,
>                 .extra2         = &tcp_min_snd_mss_max,
>         },
> +       {
> +               .procname       = "tcp_mtu_probe_rack",
> +               .data           = &init_net.ipv4.sysctl_tcp_mtu_probe_rack,
> +               .maxlen         = sizeof(int),
> +               .mode           = 0644,
> +               .proc_handler   = proc_dointvec,
> +       },
>         {
>                 .procname       = "tcp_probe_threshold",
>                 .data           = &init_net.ipv4.sysctl_tcp_probe_threshold,
>                 .maxlen         = sizeof(int),
>                 .mode           = 0644,
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 4f5b68a90be9..ed8af4a7325b 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -2892,10 +2892,11 @@ static int __net_init tcp_sk_init(struct net *net)
>         net->ipv4.sysctl_tcp_base_mss = TCP_BASE_MSS;
>         net->ipv4.sysctl_tcp_min_snd_mss = TCP_MIN_SND_MSS;
>         net->ipv4.sysctl_tcp_probe_threshold = TCP_PROBE_THRESHOLD;
>         net->ipv4.sysctl_tcp_probe_interval = TCP_PROBE_INTERVAL;
>         net->ipv4.sysctl_tcp_mtu_probe_floor = TCP_MIN_SND_MSS;
> +       net->ipv4.sysctl_tcp_mtu_probe_rack = 1;
>
>         net->ipv4.sysctl_tcp_keepalive_time = TCP_KEEPALIVE_TIME;
>         net->ipv4.sysctl_tcp_keepalive_probes = TCP_KEEPALIVE_PROBES;
>         net->ipv4.sysctl_tcp_keepalive_intvl = TCP_KEEPALIVE_INTVL;
>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index bde781f46b41..9691f435477b 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -2311,10 +2311,19 @@ static bool tcp_can_coalesce_send_queue_head(struct sock *sk, int len)
>         }
>
>         return true;
>  }
>
> +/* Check if rack is supported for current connection */
> +static int tcp_mtu_probe_is_rack(const struct sock *sk)
> +{
> +       struct net *net = sock_net(sk);
> +
> +       return (net->ipv4.sysctl_tcp_recovery & TCP_RACK_LOSS_DETECTION &&
> +                       net->ipv4.sysctl_tcp_mtu_probe_rack);
> +}

You may want to use the existing helper, tcp_is_rack(), by moving it
to include/net/tcp.h

thanks,
neal
