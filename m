Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D06C4626058
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 18:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbiKKRUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 12:20:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbiKKRUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 12:20:50 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6E8D137
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 09:20:47 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id f7so8485240edc.6
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 09:20:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9SU9sudcOLw8oF/wf8plWj42fYAsw/tcVb/9ZlJjUMs=;
        b=Ogle2F4P1KcevNIXcX4kcOXKhphPL2aZjxL2V9FcRVhHtHbNnR2uaydFFavk48EeWN
         jOzDRDYzh6+8+NMLol7KmoHsBXKL+ZldJTqriR2lqzT+lhX2ZrafL138y9uBuZLi+T2w
         AXwbC9H2mmFQcum012ohWJ2xw0mmtWd111JQdo4weAMRT0gdXHaZ+aUOKwM6IHoJILW4
         FL2+aBjajh3zx0H5iAaHShGTSPL4cdRuRiNGstrlnZsW7JBBL6U0gKf2y8aP8gGY17T4
         q4pqLkxfJVg0NkxGKnVxAr43Tz2xB7FWNxEVT+KOAwfeDXr0kNRfXwKt5prbYR7hhkuG
         QROg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9SU9sudcOLw8oF/wf8plWj42fYAsw/tcVb/9ZlJjUMs=;
        b=38vyTFivwu95uMLbh1Zbb0Q+YvGkE1uUmKUVKAY1+CUgHlQvQI71Px2jW3dFMY1i6v
         oACmZXLgF2ZbNRl8tOVsYjsbJnHOmEoQWnOCn5lAjqNVZ4eJvwHKokf8iq/yF5AluBiR
         YX+lPDoJj4Vkb9JuzqSW4FY4RchJFo5iJB2NmtsaqAzsq+WHkcdj/FpFXzBbmY4MPHd3
         qgZmcukZISbMKW6oscWsLxPFjlJhYTBY22s/uxFJK7gH71Xndjx7qbk4Q+Mrc4ODqlIL
         ojsRpL9yfJYQiS7rv+k2INdNX4dzQREMd8s0Xt0VJfrpL2e8VJJN21ZBy7JOAkvKKePu
         QROA==
X-Gm-Message-State: ANoB5pkGB5H8NHY3VL0aejVTIv7yU82ECiMScajU/D1urstMmT1fm59v
        DVEJZjBwxcKIOK2LFWKHhJE+V0PQ+Qi7IpBFVlw=
X-Google-Smtp-Source: AA0mqf6d3+OHXB7izoPZoXEElQy5dosvaD9GG3pE9mzEzRJOawBWo5fAYQ/kJorclEdFcupWobwNxAwQQpwBfqXBLCo=
X-Received: by 2002:a05:6402:31f0:b0:461:deed:6d20 with SMTP id
 dy16-20020a05640231f000b00461deed6d20mr2471192edb.55.1668187245965; Fri, 11
 Nov 2022 09:20:45 -0800 (PST)
MIME-Version: 1.0
References: <20221109180249.4721-1-dnlplm@gmail.com> <20221109180249.4721-3-dnlplm@gmail.com>
 <20221110173222.3536589-1-alexandr.lobakin@intel.com>
In-Reply-To: <20221110173222.3536589-1-alexandr.lobakin@intel.com>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Fri, 11 Nov 2022 18:23:24 +0100
Message-ID: <CAGRyCJFAU6yBv3KN2=FP8v017M8_a9FM5d60xTe2HO9sT57q5w@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net: qualcomm: rmnet: add tx packets aggregation
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

Il giorno gio 10 nov 2022 alle ore 18:35 Alexander Lobakin
<alexandr.lobakin@intel.com> ha scritto:
>
> From: Daniele Palmas <dnlplm@gmail.com>
> Date: Wed,  9 Nov 2022 19:02:48 +0100
>
> > Bidirectional TCP throughput tests through iperf with low-cat
> > Thread-x based modems showed performance issues both in tx
> > and rx.
> >
> > The Windows driver does not show this issue: inspecting USB
> > packets revealed that the only notable change is the driver
> > enabling tx packets aggregation.
> >
> > Tx packets aggregation, by default disabled, requires flag
> > RMNET_FLAGS_EGRESS_AGGREGATION to be set (e.g. through ip command).
> >
> > The maximum number of aggregated packets and the maximum aggregated
> > size are by default set to reasonably low values in order to support
> > the majority of modems.
> >
> > This implementation is based on patches available in Code Aurora
> > repositories (msm kernel) whose main authors are
> >
> > Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> > Sean Tranchetti <stranche@codeaurora.org>
> >
> > Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
> > ---
> >  .../ethernet/qualcomm/rmnet/rmnet_config.c    |   5 +
> >  .../ethernet/qualcomm/rmnet/rmnet_config.h    |  19 ++
> >  .../ethernet/qualcomm/rmnet/rmnet_handlers.c  |  25 ++-
> >  .../net/ethernet/qualcomm/rmnet/rmnet_map.h   |   7 +
> >  .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 196 ++++++++++++++++++
> >  include/uapi/linux/if_link.h                  |   1 +
> >  6 files changed, 251 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> > index 27b1663c476e..39d24e07f306 100644
> > --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> > +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> > @@ -12,6 +12,7 @@
> >  #include "rmnet_handlers.h"
> >  #include "rmnet_vnd.h"
> >  #include "rmnet_private.h"
> > +#include "rmnet_map.h"
> >
> >  /* Local Definitions and Declarations */
> >
> > @@ -39,6 +40,8 @@ static int rmnet_unregister_real_device(struct net_device *real_dev)
> >       if (port->nr_rmnet_devs)
> >               return -EINVAL;
> >
> > +     rmnet_map_tx_aggregate_exit(port);
> > +
> >       netdev_rx_handler_unregister(real_dev);
> >
> >       kfree(port);
> > @@ -79,6 +82,8 @@ static int rmnet_register_real_device(struct net_device *real_dev,
> >       for (entry = 0; entry < RMNET_MAX_LOGICAL_EP; entry++)
> >               INIT_HLIST_HEAD(&port->muxed_ep[entry]);
> >
> > +     rmnet_map_tx_aggregate_init(port);
> > +
> >       netdev_dbg(real_dev, "registered with rmnet\n");
> >       return 0;
> >  }
> > diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
> > index 3d3cba56c516..d341df78e411 100644
> > --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
> > +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
> > @@ -6,6 +6,7 @@
> >   */
> >
> >  #include <linux/skbuff.h>
> > +#include <linux/time.h>
> >  #include <net/gro_cells.h>
> >
> >  #ifndef _RMNET_CONFIG_H_
> > @@ -19,6 +20,12 @@ struct rmnet_endpoint {
> >       struct hlist_node hlnode;
> >  };
> >
> > +struct rmnet_egress_agg_params {
> > +     u16 agg_size;
>
> skbs can now be way longer than 64 Kb.
>

OK, I can use u32.

For further information, I would like to explain where u16 is coming from.

The value of agg_size is returned by the modem through a qmi request
(wda set data format): so far, all the modem I've been able to test
have less than 64KB as the maximum size for the aggregated packets
block, so I thought u16 was enough.

But, to be honest, I can't exclude that there are modems where this
value is > 64KB, so I think it could make sense using u32.

> > +     u16 agg_count;
> > +     u64 agg_time_nsec;
> > +};
> > +
> >  /* One instance of this structure is instantiated for each real_dev associated
> >   * with rmnet.
> >   */
>
> [...]
>
> > @@ -518,3 +519,198 @@ int rmnet_map_process_next_hdr_packet(struct sk_buff *skb,
> >
> >       return 0;
> >  }
> > +
> > +long rmnet_agg_bypass_time __read_mostly = 10000L * NSEC_PER_USEC;
>
> Why __read_mostly if you don't change it anywhere? Could be const.
> Why here if you use it only in one file? Could be static there.
> Why variable if it could be a definition?
>

All your remarks make sense.

> > +
> > +bool rmnet_map_tx_agg_skip(struct sk_buff *skb)
> > +{
> > +     bool is_icmp = 0;
> > +
> > +     if (skb->protocol == htons(ETH_P_IP)) {
> > +             struct iphdr *ip4h = ip_hdr(skb);
>
> [...]
>
> > +static void rmnet_map_flush_tx_packet_work(struct work_struct *work)
> > +{
> > +     struct sk_buff *skb = NULL;
> > +     struct rmnet_port *port;
> > +     unsigned long flags;
> > +
> > +     port = container_of(work, struct rmnet_port, agg_wq);
> > +
> > +     spin_lock_irqsave(&port->agg_lock, flags);
>
> I don't see aggregation fields used in any hardware interrupt
> handlers, are you sure you need _irq*(), not _bh()?
>

I think you are right.

> > +     if (likely(port->agg_state == -EINPROGRESS)) {
> > +             /* Buffer may have already been shipped out */
> > +             if (likely(port->agg_skb)) {
> > +                     skb = port->agg_skb;
> > +                     reset_aggr_params(port);
> > +             }
> > +             port->agg_state = 0;
> > +     }
> > +
> > +     spin_unlock_irqrestore(&port->agg_lock, flags);
> > +     if (skb)
> > +             dev_queue_xmit(skb);
> > +}
> > +
> > +enum hrtimer_restart rmnet_map_flush_tx_packet_queue(struct hrtimer *t)
> > +{
> > +     struct rmnet_port *port;
> > +
> > +     port = container_of(t, struct rmnet_port, hrtimer);
> > +
> > +     schedule_work(&port->agg_wq);
> > +
> > +     return HRTIMER_NORESTART;
> > +}
> > +
> > +void rmnet_map_tx_aggregate(struct sk_buff *skb, struct rmnet_port *port,
> > +                         struct net_device *orig_dev)
> > +{
> > +     struct timespec64 diff, last;
> > +     int size = 0;
>
> RCT style?
>

Ack.

> > +     struct sk_buff *agg_skb;
> > +     unsigned long flags;
> > +
> > +new_packet:
> > +     spin_lock_irqsave(&port->agg_lock, flags);
> > +     memcpy(&last, &port->agg_last, sizeof(struct timespec64));
> > +     ktime_get_real_ts64(&port->agg_last);
> > +
> > +     if (!port->agg_skb) {
> > +             /* Check to see if we should agg first. If the traffic is very
> > +              * sparse, don't aggregate.
> > +              */
> > +             diff = timespec64_sub(port->agg_last, last);
> > +             size = port->egress_agg_params.agg_size - skb->len;
> > +
> > +             if (size < 0) {
> > +                     struct rmnet_priv *priv;
> > +
> > +                     /* dropped */
>
> So if a packet is smaller than the aggregation threshold, you just
> drop it? Why, if you could just let it go the "standard" way, like
> ICMP does?
>

If skb->len is bigger than the maximum possible aggregated block size,
then the packet is dropped: this is because with some modems, sending
a block that is bigger than the maximum supported size causes the
modem to crash.

> > +                     dev_kfree_skb_any(skb);
> > +                     spin_unlock_irqrestore(&port->agg_lock, flags);
>
> You could release this lock a line above, so that
> dev_kfree_skb_any() wouldn't be called in the HWIRQ context and
> postpone skb freeing via the softnet queue.
>

Ack.

> > +                     priv = netdev_priv(orig_dev);
> > +                     this_cpu_inc(priv->pcpu_stats->stats.tx_drops);
> > +
> > +                     return;
> > +             }
> > +
> > +             if (diff.tv_sec > 0 || diff.tv_nsec > rmnet_agg_bypass_time ||
> > +                 size == 0) {
> > +                     spin_unlock_irqrestore(&port->agg_lock, flags);
> > +                     skb->protocol = htons(ETH_P_MAP);
> > +                     dev_queue_xmit(skb);
> > +                     return;
> > +             }
> > +
> > +             port->agg_skb = skb_copy_expand(skb, 0, size, GFP_ATOMIC);
>
> You could use skb_cow_head(skb, 0) and skip allocating a new skb if
> the current one is writable, which usually is the case.
>

Ok, I will look at how to do that.

> > +             if (!port->agg_skb) {
> > +                     reset_aggr_params(port);
> > +                     spin_unlock_irqrestore(&port->agg_lock, flags);
> > +                     skb->protocol = htons(ETH_P_MAP);
> > +                     dev_queue_xmit(skb);
> > +                     return;
> > +             }
> > +             port->agg_skb->protocol = htons(ETH_P_MAP);
> > +             port->agg_count = 1;
> > +             ktime_get_real_ts64(&port->agg_time);
> > +             dev_kfree_skb_any(skb);
> > +             goto schedule;
> > +     }
> > +     diff = timespec64_sub(port->agg_last, port->agg_time);
> > +     size = port->egress_agg_params.agg_size - port->agg_skb->len;
> > +
> > +     if (skb->len > size ||
> > +         diff.tv_sec > 0 || diff.tv_nsec > port->egress_agg_params.agg_time_nsec) {
> > +             agg_skb = port->agg_skb;
> > +             reset_aggr_params(port);
> > +             spin_unlock_irqrestore(&port->agg_lock, flags);
> > +             hrtimer_cancel(&port->hrtimer);
> > +             dev_queue_xmit(agg_skb);
> > +             goto new_packet;
> > +     }
> > +
> > +     skb_put_data(port->agg_skb, skb->data, skb->len);
>
> IIUC, RMNet netdevs support %NETIF_F_SG. Which means you could just
> attach skb data as frags to the first skb in the aggregation
> session instead of copying the data all the time.
> ...or even add %NETIF_F_FRAGLIST handling, that would save even more
> -- just use skb->frag_list once you run out of skb_shinfo()->frags.
>

I think I get the general idea behind your comment, but honestly I
need to study and work on this a bit more, since I'm missing specific
knowledge on the things you are mentioning.

> > +     port->agg_count++;
> > +     dev_kfree_skb_any(skb);
> > +
> > +     if (port->agg_count == port->egress_agg_params.agg_count ||
> > +         port->agg_skb->len == port->egress_agg_params.agg_size) {
>
> I think ::agg_count and ::agg_size are the thresholds, so the
> comparison should be >= I guess (especially ::agg_size which gets
> increased by a random value each time, not by 1)?
>

Sorry, I'm probably missing something.

port->egress_agg_params.agg_count and port->egress_agg_params.agg_size
are supposed to stay fixed throughout the life of the device since
they are configured usually during modem initialization with the
values returned by qmi wda set data format request.

The number of packets in an aggregated block sent to the modem can't
be > port->egress_agg_params.agg_count and the size of the aggregated
block can't be > port->egress_agg_params.agg_size, otherwise the modem
could crash.

The actual status of the aggregated block is stored in port->agg_count
and port->agg_skb->len. Due to the reason above (modem crashing) the
code should not arrive in a situation in which port->agg_skb->len >
port->egress_agg_params.agg_size or port->agg_count >
port->egress_agg_params.agg_count, besides possible bug I could have
done.

I think I don't understand this sentence "especially ::agg_size which
gets increased by a random value each time, not by 1".

> > +             agg_skb = port->agg_skb;
> > +             reset_aggr_params(port);
> > +             spin_unlock_irqrestore(&port->agg_lock, flags);
> > +             hrtimer_cancel(&port->hrtimer);
> > +             dev_queue_xmit(agg_skb);
> > +             return;
> > +     }
> > +
> > +schedule:
> > +     if (!hrtimer_active(&port->hrtimer) && port->agg_state != -EINPROGRESS) {
> > +             port->agg_state = -EINPROGRESS;
> > +             hrtimer_start(&port->hrtimer,
> > +                           ns_to_ktime(port->egress_agg_params.agg_time_nsec),
> > +                           HRTIMER_MODE_REL);
> > +     }
> > +     spin_unlock_irqrestore(&port->agg_lock, flags);
> > +}
> > +
> > +void rmnet_map_update_ul_agg_config(struct rmnet_port *port, u16 size,
> > +                                 u16 count, u32 time)
> > +{
> > +     unsigned long irq_flags;
> > +
> > +     spin_lock_irqsave(&port->agg_lock, irq_flags);
> > +     port->egress_agg_params.agg_size = size;
> > +     port->egress_agg_params.agg_count = count;
> > +     port->egress_agg_params.agg_time_nsec = time * NSEC_PER_USEC;
> > +     spin_unlock_irqrestore(&port->agg_lock, irq_flags);
> > +}
> > +
> > +void rmnet_map_tx_aggregate_init(struct rmnet_port *port)
> > +{
> > +     hrtimer_init(&port->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> > +     port->hrtimer.function = rmnet_map_flush_tx_packet_queue;
> > +     spin_lock_init(&port->agg_lock);
> > +     rmnet_map_update_ul_agg_config(port, 4096, 16, 800);
> > +     INIT_WORK(&port->agg_wq, rmnet_map_flush_tx_packet_work);
> > +}
> > +
> > +void rmnet_map_tx_aggregate_exit(struct rmnet_port *port)
> > +{
> > +     unsigned long flags;
> > +
> > +     hrtimer_cancel(&port->hrtimer);
> > +     cancel_work_sync(&port->agg_wq);
> > +
> > +     spin_lock_irqsave(&port->agg_lock, flags);
> > +     if (port->agg_state == -EINPROGRESS) {
> > +             if (port->agg_skb) {
> > +                     kfree_skb(port->agg_skb);
> > +                     reset_aggr_params(port);
> > +             }
> > +
> > +             port->agg_state = 0;
> > +     }
> > +
> > +     spin_unlock_irqrestore(&port->agg_lock, flags);
> > +}
>
> Do I get the whole logics correctly, you allocate a new big skb and
> just copy several frames into it, then send as one chunk once its
> size reaches the threshold? Plus linearize every skb to be able to
> do that... That's too much of overhead I'd say, just handle S/G and
> fraglists and make long trains of frags from them without copying
> anything?

Yes, you get the logic right.

And my reply is like above, I think I understand your comment at a
high level, but I need to learn how to do that.

> Also BQL/DQL already does some sort of aggregation via
> ::xmit_more, doesn't it? Do you have any performance numbers?
>

I've mainly tested with iperf tcp with the cat. 4 modem in which the
issue is showing and the driver is capable of reaching the limits of
the modem (50Mbps), but I understand that it's quite low.

I've tried testing also with a 5G modem, but I could only test with a
custom udp loopback mode, no real network or network simulator,
through iperf, something like:

$ iperf --client 192.168.1.172 --udp --interval 10 --port 5001
--bandwidth 600M --parallel 3 --time 10
------------------------------------------------------------
Client connecting to 192.168.1.172, UDP port 5001
Sending 1470 byte datagrams, IPG target: 18.69 us (kalman adjust)
UDP buffer size:  208 KByte (default)
------------------------------------------------------------
[  6] local 192.168.48.173 port 54765 connected with 192.168.1.172 port 5001
[  3] local 192.168.48.173 port 41767 connected with 192.168.1.172 port 5001
[  5] local 192.168.48.173 port 33300 connected with 192.168.1.172 port 5001
[ ID] Interval       Transfer     Bandwidth
[  6]  0.0-10.0 sec   750 MBytes   629 Mbits/sec
[  5]  0.0-10.0 sec   750 MBytes   629 Mbits/sec
[  5]  0.0-10.0 sec   750 MBytes   629 Mbits/sec
[  5] Sent 534987 datagrams
[SUM]  0.0-10.0 sec  2.20 GBytes  1.89 Gbits/sec
[SUM] Sent 1604960 datagrams
[  5] Server Report:
[  5]  0.0-10.2 sec  1.21 GBytes  1.02 Gbits/sec  23.271 ms    0/534988 (0%)
[  5] 0.0000-10.2199 sec  835183 datagrams received out-of-order
[  6]  0.0-10.0 sec   750 MBytes   629 Mbits/sec
[  6] Sent 534990 datagrams
[  6] Server Report:
[  6]  0.0-10.2 sec  1.20 GBytes  1.00 Gbits/sec  14.879 ms    0/534991 (0%)
[  6] 0.0000-10.2320 sec  818506 datagrams received out-of-order
[  3]  0.0-10.0 sec   750 MBytes   629 Mbits/sec
[  3] Sent 534978 datagrams
[  3] Server Report:
[  3]  0.0-10.2 sec  1.20 GBytes  1.01 Gbits/sec  11.631 ms    0/534979 (0%)
[  3] 0.0000-10.2320 sec  824594 datagrams received out-of-order

Not sure how much meaningful those are, since I don't have a clear
vision on how the modem implements the loopback.

> > diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> > index 5e7a1041df3a..09a30e2b29b1 100644
> > --- a/include/uapi/linux/if_link.h
> > +++ b/include/uapi/linux/if_link.h
> > @@ -1351,6 +1351,7 @@ enum {
> >  #define RMNET_FLAGS_EGRESS_MAP_CKSUMV4            (1U << 3)
> >  #define RMNET_FLAGS_INGRESS_MAP_CKSUMV5           (1U << 4)
> >  #define RMNET_FLAGS_EGRESS_MAP_CKSUMV5            (1U << 5)
> > +#define RMNET_FLAGS_EGRESS_AGGREGATION            (1U << 6)
>
> But you could rely on the aggregation parameters passed via Ethtool
> to decide whether to enable aggregation or not. If any of them is 0,
> it means the aggregation needs to be disabled.
> Otherwise, to enable it you need to use 2 utilities: the one that
> creates RMNet devices at first and Ethtool after, isn't it too
> complicated for no reason?
>

The rationale behind this was to keep a conservative approach by
leaving the tx aggregation disabled by default and at the same time
provide default values for the aggregation parameters.

But I agree with you that it is redundant, I can manage that with just
the value of the egress_agg_params.agg_count (1 = no aggregation).

Thanks for your time and for the review.

Thanks,
Daniele

> >
> >  enum {
> >       IFLA_RMNET_UNSPEC,
> > --
> > 2.37.1
>
> Thanks,
> Olek
