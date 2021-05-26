Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFDDC391E72
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 19:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbhEZRz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 13:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234790AbhEZRzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 13:55:24 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D654C06175F
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 10:53:52 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id j14so2031486wrq.5
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 10:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8Z2K++KuCClDy9KbutpofrcdapQ1Tt8SVGV0bdU7V8A=;
        b=eL3+6MfSM3PCtoxaRXow6IcRXBwwWESzbCM/8Dc4wDaSiJ2i0MpJP1yxnKDTBwfcHn
         jdbun3ZwmSGHi6XP+j7JUCzJhjQHWtetTBqxBoKRm40WbHUz/B6oFPA7AyxH9CAt1dGy
         lruuaxMU63WI13bsqjDz9Aj4gXXwoqJZkEKf3lXx9e97yenNiRE+5g4c/YJRqfpFx/5H
         xJwf9Bs6UFl7/V5Jluq/xO/69o5LASXmAM3CVWiR0vGVhbw6jvSBbCytzp9eMQmaCmzl
         kdMCgerwj7yGfVHKtmRnbmzuYUdJn7vzndOqKkQkKhTbgncyEjHddGnWgPpLAMTu985T
         0rgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8Z2K++KuCClDy9KbutpofrcdapQ1Tt8SVGV0bdU7V8A=;
        b=Y59dSovAKokjQOF4AJSR8UzoTmXCshT1lhLQrwNZsawnIHGiXD7hiS3SUFc2u4Bwk0
         zTxfVMsiStYFPQoxyEMsaZThbg+SktcyFTa1AK6ss+wzL2zbJ8KVJRExUUpREDJwz3KV
         tzEnL69pjPYwtMrCfiU5AWLvnffPEXvPk+6LjDqHm9QHM9jhMynv6y+CWfqVqV1O0/s2
         X0qtaDvtyGAicIMHyHckqSb8HkjlGr9rXkd8l9ldAkV9o0swmu23LaaoZygM//L09NIa
         8LtS0n67utCUMfrRSTV9wS2HAc16Tyz7l+L1Z2vHWQ59sYoQuXN3h/R8/sirlzgAkcSj
         V9Ag==
X-Gm-Message-State: AOAM531EGdfT3KKabsn0urOvumYpQLM9qJR+TrcTBf68EsKHPLqjaDwo
        CSvsiquvZsxEhdRDDb9u4qpTfa6JHV/HBBs+FNSvsQ==
X-Google-Smtp-Source: ABdhPJxLIlhNvZv2XP4yDtI90mcc+qhbH1ZAKx6Cgpy8PWhy3LFytAzzivlrGrK0FDvEtyhhHe7jDDhTcdzTKlcWYUA=
X-Received: by 2002:a5d:4c48:: with SMTP id n8mr33349537wrt.422.1622051630749;
 Wed, 26 May 2021 10:53:50 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1622025457.git.cdleonard@gmail.com> <750563aba3687119818dac09fc987c27c7152324.1622025457.git.cdleonard@gmail.com>
 <CADVnQynoD=NF2hG6Bs44A0jrnKG=3f97OywS-tq-p-KQAsf5Fg@mail.gmail.com>
In-Reply-To: <CADVnQynoD=NF2hG6Bs44A0jrnKG=3f97OywS-tq-p-KQAsf5Fg@mail.gmail.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Wed, 26 May 2021 10:53:13 -0700
Message-ID: <CAK6E8=fZwUuymaz_VUarENCuj_bZEZhXdP6ZkHYZtvDiyrWjVQ@mail.gmail.com>
Subject: Re: [RFCv2 1/3] tcp: Use smaller mtu probes if RACK is enabled
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Leonard Crestez <cdleonard@gmail.com>,
        Matt Mathis <mattmathis@google.com>,
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

On Wed, May 26, 2021 at 5:11 AM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Wed, May 26, 2021 at 6:38 AM Leonard Crestez <cdleonard@gmail.com> wrote:
> >
> > RACK allows detecting a loss in rtt + min_rtt / 4 based on just one
> > extra packet. If enabled use this instead of relying of fast retransmit.
>
> IMHO it would be worth adding some more text to motivate the change,
> to justify the added complexity and risk from the change. The
> substance of the change seems to be decreasing the requirement for
> PMTU probing from needing roughly 5 packets worth of data to needing
> roughly 3 packets worth of data. It's not clear to me as a reader of
> this patch by itself that there are lots of applications that very
> often only have 3-4 packets worth of data to send and yet can benefit
> greatly from PMTU discovery.
>
> > Suggested-by: Neal Cardwell <ncardwell@google.com>
> > Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> > ---
> >  Documentation/networking/ip-sysctl.rst |  5 +++++
> >  include/net/netns/ipv4.h               |  1 +
> >  net/ipv4/sysctl_net_ipv4.c             |  7 +++++++
> >  net/ipv4/tcp_ipv4.c                    |  1 +
> >  net/ipv4/tcp_output.c                  | 26 +++++++++++++++++++++++++-
> >  5 files changed, 39 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> > index a5c250044500..7ab52a105a5d 100644
> > --- a/Documentation/networking/ip-sysctl.rst
> > +++ b/Documentation/networking/ip-sysctl.rst
> > @@ -349,10 +349,15 @@ tcp_mtu_probe_floor - INTEGER
> >         If MTU probing is enabled this caps the minimum MSS used for search_low
> >         for the connection.
> >
> >         Default : 48
> >
> > +tcp_mtu_probe_rack - BOOLEAN
> > +       Try to use shorter probes if RACK is also enabled
> > +
> > +       Default: 1
>
> I  would vote to not have a sysctl for this. If we think it's a good
> idea to allow MTU probing with a smaller amount of data if RACK is
> enabled (which seems true to me), then this is a low-risk enough
> change that we should just change the behavior.
+1 to not have another sysctl

>
> >  tcp_min_snd_mss - INTEGER
> >         TCP SYN and SYNACK messages usually advertise an ADVMSS option,
> >         as described in RFC 1122 and RFC 6691.
> >
> >         If this ADVMSS option is smaller than tcp_min_snd_mss,
> > diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
> > index 746c80cd4257..b4ff12f25a7f 100644
> > --- a/include/net/netns/ipv4.h
> > +++ b/include/net/netns/ipv4.h
> > @@ -112,10 +112,11 @@ struct netns_ipv4 {
> >  #ifdef CONFIG_NET_L3_MASTER_DEV
> >         u8 sysctl_tcp_l3mdev_accept;
> >  #endif
> >         u8 sysctl_tcp_mtu_probing;
> >         int sysctl_tcp_mtu_probe_floor;
> > +       int sysctl_tcp_mtu_probe_rack;
> >         int sysctl_tcp_base_mss;
> >         int sysctl_tcp_min_snd_mss;
> >         int sysctl_tcp_probe_threshold;
> >         u32 sysctl_tcp_probe_interval;
> >
> > diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> > index 4fa77f182dcb..275c91fb9cf8 100644
> > --- a/net/ipv4/sysctl_net_ipv4.c
> > +++ b/net/ipv4/sysctl_net_ipv4.c
> > @@ -847,10 +847,17 @@ static struct ctl_table ipv4_net_table[] = {
> >                 .mode           = 0644,
> >                 .proc_handler   = proc_dointvec_minmax,
> >                 .extra1         = &tcp_min_snd_mss_min,
> >                 .extra2         = &tcp_min_snd_mss_max,
> >         },
> > +       {
> > +               .procname       = "tcp_mtu_probe_rack",
> > +               .data           = &init_net.ipv4.sysctl_tcp_mtu_probe_rack,
> > +               .maxlen         = sizeof(int),
> > +               .mode           = 0644,
> > +               .proc_handler   = proc_dointvec,
> > +       },
> >         {
> >                 .procname       = "tcp_probe_threshold",
> >                 .data           = &init_net.ipv4.sysctl_tcp_probe_threshold,
> >                 .maxlen         = sizeof(int),
> >                 .mode           = 0644,
> > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > index 4f5b68a90be9..ed8af4a7325b 100644
> > --- a/net/ipv4/tcp_ipv4.c
> > +++ b/net/ipv4/tcp_ipv4.c
> > @@ -2892,10 +2892,11 @@ static int __net_init tcp_sk_init(struct net *net)
> >         net->ipv4.sysctl_tcp_base_mss = TCP_BASE_MSS;
> >         net->ipv4.sysctl_tcp_min_snd_mss = TCP_MIN_SND_MSS;
> >         net->ipv4.sysctl_tcp_probe_threshold = TCP_PROBE_THRESHOLD;
> >         net->ipv4.sysctl_tcp_probe_interval = TCP_PROBE_INTERVAL;
> >         net->ipv4.sysctl_tcp_mtu_probe_floor = TCP_MIN_SND_MSS;
> > +       net->ipv4.sysctl_tcp_mtu_probe_rack = 1;
> >
> >         net->ipv4.sysctl_tcp_keepalive_time = TCP_KEEPALIVE_TIME;
> >         net->ipv4.sysctl_tcp_keepalive_probes = TCP_KEEPALIVE_PROBES;
> >         net->ipv4.sysctl_tcp_keepalive_intvl = TCP_KEEPALIVE_INTVL;
> >
> > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > index bde781f46b41..9691f435477b 100644
> > --- a/net/ipv4/tcp_output.c
> > +++ b/net/ipv4/tcp_output.c
> > @@ -2311,10 +2311,19 @@ static bool tcp_can_coalesce_send_queue_head(struct sock *sk, int len)
> >         }
> >
> >         return true;
> >  }
> >
> > +/* Check if rack is supported for current connection */
> > +static int tcp_mtu_probe_is_rack(const struct sock *sk)
> > +{
> > +       struct net *net = sock_net(sk);
> > +
> > +       return (net->ipv4.sysctl_tcp_recovery & TCP_RACK_LOSS_DETECTION &&
> > +                       net->ipv4.sysctl_tcp_mtu_probe_rack);
> > +}
>
> You may want to use the existing helper, tcp_is_rack(), by moving it
> to include/net/tcp.h
>
> thanks,
> neal
