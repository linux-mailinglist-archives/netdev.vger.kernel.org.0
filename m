Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B57D17118A
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 08:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728467AbgB0HeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 02:34:05 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41200 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726999AbgB0HeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 02:34:05 -0500
Received: by mail-lf1-f68.google.com with SMTP id y17so1286112lfe.8
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 23:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7FXmAOI0TK8OIIGxcKrX+W3GItlYbusW284mh3PEp7Q=;
        b=Q/50H6u534ixqEeQzEhY7RPuyErJG7/rhl6kWq48zXsJv2wNp9W7znoXv3J7e/uigC
         jzpt6jUFSxn1EjygUmn1eZhu7ympyvigx2pBrunkWoYedkMIkKART/1B8SvVhd2fQ1Fd
         3kyHlRKe3mr7m6ZZvxl0KOYmK94WUu0zXSNTDUDCFBDlEICpkmpCIdNsmwmNJ1NODVHW
         dzV0CEJsGptXgxCnIOnGqqjtiCUtwZhoK2FqutDj/PRtOKPqlI0aP+ASQ1DNvVifPwBe
         Tl0zbQH84KBIjz9e/52RiM9HebtR3vI8BM8QJTGDiyeFTnio5BNCUZoQy3i2kQsjxRBr
         4slQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7FXmAOI0TK8OIIGxcKrX+W3GItlYbusW284mh3PEp7Q=;
        b=LTaC5IDWYc/R1xKjNeuoh02/DnEEY8qlIeGTKKoYZ56F8BxW5uQjPb5WYBN0pa8CKq
         JNWmN+Q6qK65f8kCkoaptOYYI+mG1yKomcyJVE7cnHf95p3x0aM85gpA0SNRcMqUvR5R
         J59nafgGUd+LzP4/rilNyhjF5I92Q4UYx3wGGY8RFqVW+ZSo8bQS5a7rIuuKhl8ONcS7
         RPSUW9GHRvm/FauWKhJlQOmiQaz+PzFvlG8rB8gRr3UNz+vV4QEonSYDOG4tQQdeBXAj
         7cfi9PTeJmbXpqlixuHiPFQMSFXSnXdTfnJckSJbmxKAcz7PNKe83Z2MSuprlAESnmIg
         rezA==
X-Gm-Message-State: ANhLgQ1Lwpl83kitLrnyEwusZbF+IRDrrF+NcrBJz+u6fEf9WkqQBjFa
        E/C8kJ2Dfy7DkfmElQcXVseSDeIbdFU4R3e46Vs=
X-Google-Smtp-Source: ADFU+vtmoBE7SD35umAqp7VsxowGydlB+C8/xMy84zbD469a9QbWLyn0y3IzBiT7IzNRR14eTIgsbsy+AHfM3y81VI4=
X-Received: by 2002:a19:ed08:: with SMTP id y8mr1422536lfy.56.1582788842976;
 Wed, 26 Feb 2020 23:34:02 -0800 (PST)
MIME-Version: 1.0
References: <20200226174706.5334-1-ap420073@gmail.com> <473fc49bd479ecfeb92adbd9a26fba2e@codeaurora.org>
In-Reply-To: <473fc49bd479ecfeb92adbd9a26fba2e@codeaurora.org>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Thu, 27 Feb 2020 16:33:51 +0900
Message-ID: <CAMArcTWDf+K4MECEz0yuqpFrng8ND_eJgX0uTaN=MMYETggh+A@mail.gmail.com>
Subject: Re: [PATCH net 04/10] net: rmnet: fix suspicious RCU usage
To:     subashab@codeaurora.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, stranche@codeaurora.org,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Feb 2020 at 05:33, <subashab@codeaurora.org> wrote:
>

Hi,
Thank you for the review!

> On 2020-02-26 10:47, Taehee Yoo wrote:
> > rmnet_get_port() internally calls rcu_dereference_rtnl(),
> > which checks RTNL.
> > But rmnet_get_port() could be called by packet path.
> > The packet path is not protected by RTNL.
> > So, the suspicious RCU usage problem occurs.
> >
> > Test commands:
> >     ip netns add nst
> >     ip link add veth0 type veth peer name veth1
> >     ip link set veth1 netns nst
> >     ip link add rmnet0 link veth0 type rmnet mux_id 1
> >     ip netns exec nst ip link add rmnet1 link veth1 type rmnet mux_id 1
> >     ip netns exec nst ip link set veth1 up
> >     ip netns exec nst ip link set rmnet1 up
> >     ip netns exec nst ip a a 192.168.100.2/24 dev rmnet1
> >     ip link set veth0 up
> >     ip link set rmnet0 up
> >     ip a a 192.168.100.1/24 dev rmnet0
> >     ping 192.168.100.2
> >
> > Splat looks like:
> > [  339.775811][  T969] =============================
> > [  339.777204][  T969] WARNING: suspicious RCU usage
> > [  339.778188][  T969] 5.5.0+ #407 Not tainted
> > [  339.779123][  T969] -----------------------------
> > [  339.780100][  T969]
> > drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c:389 suspicious
> > rcu_dereference_check() usage!
> > [  339.781943][  T969]
> > [  339.781943][  T969] other info that might help us debug this:
> > [  339.781943][  T969]
> > [  339.783475][  T969]
> > [  339.783475][  T969] rcu_scheduler_active = 2, debug_locks = 1
> > [  339.784656][  T969] 5 locks held by ping/969:
> > [  339.785406][  T969]  #0: ffff88804cb897f0 (sk_lock-AF_INET){+.+.},
> > at: raw_sendmsg+0xab8/0x2980
> > [  339.786766][  T969]  #1: ffffffff92925460 (rcu_read_lock_bh){....},
> > at: ip_finish_output2+0x243/0x2150
> > [  339.788308][  T969]  #2: ffffffff92925460 (rcu_read_lock_bh){....},
> > at: __dev_queue_xmit+0x213/0x2e10
> > [  339.790662][  T969]  #3: ffff88805a924158
> > (&dev->qdisc_running_key#3){+...}, at: ip_finish_output2+0x714/0x2150
> > [  339.792072][  T969]  #4: ffff88805b4fdc98
> > (&dev->qdisc_xmit_lock_key#3){+.-.}, at: sch_direct_xmit+0x1e2/0x1020
> > [  339.793445][  T969]
> > [  339.793445][  T969] stack backtrace:
> > [  339.794691][  T969] CPU: 3 PID: 969 Comm: ping Not tainted 5.5.0+
> > #407
> > [  339.795946][  T969] Hardware name: innotek GmbH
> > VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> > [  339.797621][  T969] Call Trace:
> > [  339.798249][  T969]  dump_stack+0x96/0xdb
> > [  339.798847][  T969]  rmnet_get_port.part.9+0x76/0x80 [rmnet]
> > [  339.799583][  T969]  rmnet_egress_handler+0x107/0x420 [rmnet]
> > [  339.800350][  T969]  ? sch_direct_xmit+0x1e2/0x1020
> > [  339.801027][  T969]  rmnet_vnd_start_xmit+0x3d/0xa0 [rmnet]
> > [  339.801784][  T969]  dev_hard_start_xmit+0x160/0x740
> > [  339.802667][  T969]  sch_direct_xmit+0x265/0x1020
> > [ ... ]
> >
> > Fixes: ceed73a2cf4a ("drivers: net: ethernet: qualcomm: rmnet: Initial
> > implementation")
> > Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> > ---
> >  drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c  | 13 ++++++-------
> >  drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h  |  2 +-
> >  .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c    |  4 ++--
> >  drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c     |  2 ++
> >  4 files changed, 11 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> > b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> > index 7a7d0f521352..93642cdd3305 100644
> > --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> > +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> > @@ -382,11 +382,10 @@ struct rtnl_link_ops rmnet_link_ops __read_mostly
> > = {
> >       .fill_info      = rmnet_fill_info,
> >  };
> >
> > -/* Needs either rcu_read_lock() or rtnl lock */
> > -struct rmnet_port *rmnet_get_port(struct net_device *real_dev)
> > +struct rmnet_port *rmnet_get_port_rcu(struct net_device *real_dev)
> >  {
> >       if (rmnet_is_real_dev_registered(real_dev))
> > -             return rcu_dereference_rtnl(real_dev->rx_handler_data);
> > +             return rcu_dereference(real_dev->rx_handler_data);
> >       else
> >               return NULL;
> >  }
> > @@ -412,7 +411,7 @@ int rmnet_add_bridge(struct net_device *rmnet_dev,
> >       struct rmnet_port *port, *slave_port;
> >       int err;
> >
> > -     port = rmnet_get_port(real_dev);
> > +     port = rmnet_get_port_rtnl(real_dev);
> >
> >       /* If there is more than one rmnet dev attached, its probably being
> >        * used for muxing. Skip the briding in that case
> > @@ -427,7 +426,7 @@ int rmnet_add_bridge(struct net_device *rmnet_dev,
> >       if (err)
> >               return -EBUSY;
> >
> > -     slave_port = rmnet_get_port(slave_dev);
> > +     slave_port = rmnet_get_port_rtnl(slave_dev);
> >       slave_port->rmnet_mode = RMNET_EPMODE_BRIDGE;
> >       slave_port->bridge_ep = real_dev;
> >
> > @@ -445,11 +444,11 @@ int rmnet_del_bridge(struct net_device
> > *rmnet_dev,
> >       struct net_device *real_dev = priv->real_dev;
> >       struct rmnet_port *port, *slave_port;
> >
> > -     port = rmnet_get_port(real_dev);
> > +     port = rmnet_get_port_rtnl(real_dev);
> >       port->rmnet_mode = RMNET_EPMODE_VND;
> >       port->bridge_ep = NULL;
> >
> > -     slave_port = rmnet_get_port(slave_dev);
> > +     slave_port = rmnet_get_port_rtnl(slave_dev);
> >       rmnet_unregister_real_device(slave_dev, slave_port);
> >
> >       netdev_dbg(slave_dev, "removed from rmnet as slave\n");
> > diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
> > b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
> > index cd0a6bcbe74a..0d568dcfd65a 100644
> > --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
> > +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
> > @@ -65,7 +65,7 @@ struct rmnet_priv {
> >       struct rmnet_priv_stats stats;
> >  };
> >
> > -struct rmnet_port *rmnet_get_port(struct net_device *real_dev);
> > +struct rmnet_port *rmnet_get_port_rcu(struct net_device *real_dev);
> >  struct rmnet_endpoint *rmnet_get_endpoint(struct rmnet_port *port, u8
> > mux_id);
> >  int rmnet_add_bridge(struct net_device *rmnet_dev,
> >                    struct net_device *slave_dev,
> > diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> > b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> > index 1b74bc160402..074a8b326c30 100644
> > --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> > +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> > @@ -184,7 +184,7 @@ rx_handler_result_t rmnet_rx_handler(struct sk_buff
> > **pskb)
> >               return RX_HANDLER_PASS;
> >
> >       dev = skb->dev;
> > -     port = rmnet_get_port(dev);
> > +     port = rmnet_get_port_rcu(dev);
> >
> >       switch (port->rmnet_mode) {
> >       case RMNET_EPMODE_VND:
> > @@ -217,7 +217,7 @@ void rmnet_egress_handler(struct sk_buff *skb)
> >       skb->dev = priv->real_dev;
> >       mux_id = priv->mux_id;
> >
> > -     port = rmnet_get_port(skb->dev);
> > +     port = rmnet_get_port_rcu(skb->dev);
> >       if (!port)
> >               goto drop;
> >
> > diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
> > b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
> > index 509dfc895a33..a26e76e9d382 100644
> > --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
> > +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
> > @@ -50,7 +50,9 @@ static netdev_tx_t rmnet_vnd_start_xmit(struct
> > sk_buff *skb,
> >
> >       priv = netdev_priv(dev);
> >       if (priv->real_dev) {
>
> This rcu lock shouldn't be needed as it is acquired already in
> __dev_queue_xmit().
>

You're right, __dev_queue_xmit() already acquires rcu_read_lock_bh().
So, rcu_read_lock() is unnecessary in rmnet_vnd_start_xmit().
And I think rcu_dereference_bh() should be used instead of
rcu_dereference() in the rmnet_get_port_rcu().
I will send a v2 patch, which changes these two things.

Thank you!
Taehee Yoo

> > +             rcu_read_lock();
> >               rmnet_egress_handler(skb);
> > +             rcu_read_unlock();
> >       } else {
> >               this_cpu_inc(priv->pcpu_stats->stats.tx_drops);
> >               kfree_skb(skb);
