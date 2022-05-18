Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90B0152B4F2
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 10:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233054AbiERI1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 04:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233112AbiERI1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 04:27:05 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B69106355;
        Wed, 18 May 2022 01:26:50 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8DB9A20005;
        Wed, 18 May 2022 08:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652862407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hnQyRtvJ3KBc+efqXaPBV7QBnmSHHsoNFrZIKCN/h74=;
        b=i7VL4AjuuK2Nu3POCrZ5qRVFR3Ed1GAqB7HvxwWMQSPKrbh0qf1fVsQ20jFqkl4FtGeWrJ
        iT/E6GXmGsPP5/ppQRpXm+18Gaf1kDFALvyeRVPTkAMCF9Q5GxOgn36fsGxPLiLyXmVVQo
        +vnHHQxLCKR4zAO/NFDSBOSBFqp/fYeDtN6DfMyBOktERy47nKZw/7/XZvSDbWoqHWvhex
        eT9a4E6RkopNJzbi5S49mcaB7TFIMfSy4nLTd0m3ZcqXS7IyIZdU1LU1xjSzlzap7c5d87
        0akRciqc3vc6CPXCF0kpG79BseKqLn/IkBIfs3XZ9TzmU0qd0WZxW0B5ak1j6A==
Date:   Wed, 18 May 2022 10:26:44 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH wpan-next v3 05/11] net: mac802154: Bring the ability to
 hold the transmit queue
Message-ID: <20220518102644.2a123e8c@xps-13>
In-Reply-To: <CAK-6q+jh_PfkWB4odE8Dr+sxwWTqhirr8hyOxFFyEUzLDJC7+w@mail.gmail.com>
References: <20220517163450.240299-1-miquel.raynal@bootlin.com>
        <20220517163450.240299-6-miquel.raynal@bootlin.com>
        <CAK-6q+jh_PfkWB4odE8Dr+sxwWTqhirr8hyOxFFyEUzLDJC7+w@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alex,

aahringo@redhat.com wrote on Tue, 17 May 2022 20:37:38 -0400:

> Hi,
> 
> On Tue, May 17, 2022 at 12:35 PM Miquel Raynal
> <miquel.raynal@bootlin.com> wrote:
> >
> > Create a hold_txs atomic variable and increment/decrement it when
> > relevant, ie. when we want to hold the queue or release it: currently
> > all the "stopped" situations are suitable, but very soon we will more
> > extensively use this feature for MLME purposes.
> >
> > Upon release, the atomic counter is decremented and checked. If it is
> > back to 0, then the netif queue gets woken up. This makes the whole
> > process fully transparent, provided that all the users of
> > ieee802154_wake/stop_queue() now call ieee802154_hold/release_queue()
> > instead.
> >
> > In no situation individual drivers should call any of these helpers
> > manually in order to avoid messing with the counters. There are other
> > functions more suited for this purpose which have been introduced, such
> > as the _xmit_complete() and _xmit_error() helpers which will handle all
> > that for them.
> >
> > One advantage is that, as no more drivers call the stop/wake helpers
> > directly, we can safely stop exporting them and only declare the
> > hold/release ones in a header only accessible to the core.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  include/net/cfg802154.h      |  6 +++--
> >  include/net/mac802154.h      | 27 -------------------
> >  net/ieee802154/core.c        |  2 ++
> >  net/mac802154/cfg.c          |  4 +--
> >  net/mac802154/ieee802154_i.h | 19 +++++++++++++
> >  net/mac802154/tx.c           |  6 ++---
> >  net/mac802154/util.c         | 52 +++++++++++++++++++++++++++++++-----
> >  7 files changed, 75 insertions(+), 41 deletions(-)
> >
> > diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> > index 473ebcb9b155..7a191418f258 100644
> > --- a/include/net/cfg802154.h
> > +++ b/include/net/cfg802154.h
> > @@ -11,7 +11,7 @@
> >
> >  #include <linux/ieee802154.h>
> >  #include <linux/netdevice.h>
> > -#include <linux/mutex.h>
> > +#include <linux/spinlock.h>
> >  #include <linux/bug.h>
> >
> >  #include <net/nl802154.h>
> > @@ -214,8 +214,10 @@ struct wpan_phy {
> >         /* the network namespace this phy lives in currently */
> >         possible_net_t _net;
> >
> > -       /* Transmission monitoring */
> > +       /* Transmission monitoring and control */
> > +       spinlock_t queue_lock;
> >         atomic_t ongoing_txs;
> > +       atomic_t hold_txs;
> >
> >         char priv[] __aligned(NETDEV_ALIGN);
> >  };
> > diff --git a/include/net/mac802154.h b/include/net/mac802154.h
> > index bdac0ddbdcdb..357d25ef627a 100644
> > --- a/include/net/mac802154.h
> > +++ b/include/net/mac802154.h
> > @@ -460,33 +460,6 @@ void ieee802154_unregister_hw(struct ieee802154_hw *hw);
> >   */
> >  void ieee802154_rx_irqsafe(struct ieee802154_hw *hw, struct sk_buff *skb,
> >                            u8 lqi);
> > -/**
> > - * ieee802154_wake_queue - wake ieee802154 queue
> > - * @hw: pointer as obtained from ieee802154_alloc_hw().
> > - *
> > - * Tranceivers usually have either one transmit framebuffer or one framebuffer
> > - * for both transmitting and receiving. Hence, the core currently only handles
> > - * one frame at a time for each phy, which means we had to stop the queue to
> > - * avoid new skb to come during the transmission. The queue then needs to be
> > - * woken up after the operation.
> > - *
> > - * Drivers should use this function instead of netif_wake_queue.
> > - */
> > -void ieee802154_wake_queue(struct ieee802154_hw *hw);
> > -
> > -/**
> > - * ieee802154_stop_queue - stop ieee802154 queue
> > - * @hw: pointer as obtained from ieee802154_alloc_hw().
> > - *
> > - * Tranceivers usually have either one transmit framebuffer or one framebuffer
> > - * for both transmitting and receiving. Hence, the core currently only handles
> > - * one frame at a time for each phy, which means we need to tell upper layers to
> > - * stop giving us new skbs while we are busy with the transmitted one. The queue
> > - * must then be stopped before transmitting.
> > - *
> > - * Drivers should use this function instead of netif_stop_queue.
> > - */
> > -void ieee802154_stop_queue(struct ieee802154_hw *hw);
> >
> >  /**
> >   * ieee802154_xmit_complete - frame transmission complete
> > diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
> > index de259b5170ab..47a4de6df88b 100644
> > --- a/net/ieee802154/core.c
> > +++ b/net/ieee802154/core.c
> > @@ -130,6 +130,8 @@ wpan_phy_new(const struct cfg802154_ops *ops, size_t priv_size)
> >
> >         init_waitqueue_head(&rdev->dev_wait);
> >
> > +       spin_lock_init(&rdev->wpan_phy.queue_lock);
> > +
> >         return &rdev->wpan_phy;
> >  }
> >  EXPORT_SYMBOL(wpan_phy_new);
> > diff --git a/net/mac802154/cfg.c b/net/mac802154/cfg.c
> > index 1e4a9f74ed43..b51100fd9e3f 100644
> > --- a/net/mac802154/cfg.c
> > +++ b/net/mac802154/cfg.c
> > @@ -46,7 +46,7 @@ static int ieee802154_suspend(struct wpan_phy *wpan_phy)
> >         if (!local->open_count)
> >                 goto suspend;
> >
> > -       ieee802154_stop_queue(&local->hw);
> > +       ieee802154_hold_queue(local);
> >         synchronize_net();
> >
> >         /* stop hardware - this must stop RX */
> > @@ -72,7 +72,7 @@ static int ieee802154_resume(struct wpan_phy *wpan_phy)
> >                 return ret;
> >
> >  wake_up:
> > -       ieee802154_wake_queue(&local->hw);
> > +       ieee802154_release_queue(local);
> >         local->suspended = false;
> >         return 0;
> >  }
> > diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
> > index a8b7b9049f14..0c7ff9e0b632 100644
> > --- a/net/mac802154/ieee802154_i.h
> > +++ b/net/mac802154/ieee802154_i.h
> > @@ -130,6 +130,25 @@ netdev_tx_t
> >  ieee802154_subif_start_xmit(struct sk_buff *skb, struct net_device *dev);
> >  enum hrtimer_restart ieee802154_xmit_ifs_timer(struct hrtimer *timer);
> >
> > +/**
> > + * ieee802154_hold_queue - hold ieee802154 queue
> > + * @local: main mac object
> > + *
> > + * Hold a queue by incrementing an atomic counter and requesting the netif
> > + * queues to be stopped. The queues cannot be woken up while the counter has not
> > + * been reset with as any ieee802154_release_queue() calls as needed.
> > + */
> > +void ieee802154_hold_queue(struct ieee802154_local *local);
> > +
> > +/**
> > + * ieee802154_release_queue - release ieee802154 queue
> > + * @local: main mac object
> > + *
> > + * Release a queue which is held by decrementing an atomic counter and wake it
> > + * up only if the counter reaches 0.
> > + */
> > +void ieee802154_release_queue(struct ieee802154_local *local);
> > +
> >  /* MIB callbacks */
> >  void mac802154_dev_set_page_channel(struct net_device *dev, u8 page, u8 chan);
> >
> > diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> > index 33f64ecd96c7..6a53c83cf039 100644
> > --- a/net/mac802154/tx.c
> > +++ b/net/mac802154/tx.c
> > @@ -43,7 +43,7 @@ void ieee802154_xmit_sync_worker(struct work_struct *work)
> >
> >  err_tx:
> >         /* Restart the netif queue on each sub_if_data object. */
> > -       ieee802154_wake_queue(&local->hw);
> > +       ieee802154_release_queue(local);
> >         atomic_dec(&local->phy->ongoing_txs);
> >         kfree_skb(skb);
> >         netdev_dbg(dev, "transmission failed\n");
> > @@ -75,7 +75,7 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
> >         }
> >
> >         /* Stop the netif queue on each sub_if_data object. */
> > -       ieee802154_stop_queue(&local->hw);
> > +       ieee802154_hold_queue(local);
> >         atomic_inc(&local->phy->ongoing_txs);
> >
> >         /* Drivers should preferably implement the async callback. In some rare
> > @@ -99,7 +99,7 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
> >         return NETDEV_TX_OK;
> >
> >  err_wake_netif_queue:
> > -       ieee802154_wake_queue(&local->hw);
> > +       ieee802154_release_queue(local);
> >         atomic_dec(&local->phy->ongoing_txs);
> >  err_free_skb:
> >         kfree_skb(skb);
> > diff --git a/net/mac802154/util.c b/net/mac802154/util.c
> > index 76dc663e2af4..6176cc40df91 100644
> > --- a/net/mac802154/util.c
> > +++ b/net/mac802154/util.c
> > @@ -13,7 +13,17 @@
> >  /* privid for wpan_phys to determine whether they belong to us or not */
> >  const void *const mac802154_wpan_phy_privid = &mac802154_wpan_phy_privid;
> >
> > -void ieee802154_wake_queue(struct ieee802154_hw *hw)
> > +/**
> > + * ieee802154_wake_queue - wake ieee802154 queue
> > + * @local: main mac object
> > + *
> > + * Tranceivers usually have either one transmit framebuffer or one framebuffer
> > + * for both transmitting and receiving. Hence, the core currently only handles
> > + * one frame at a time for each phy, which means we had to stop the queue to
> > + * avoid new skb to come during the transmission. The queue then needs to be
> > + * woken up after the operation.
> > + */
> > +static void ieee802154_wake_queue(struct ieee802154_hw *hw)
> >  {
> >         struct ieee802154_local *local = hw_to_local(hw);
> >         struct ieee802154_sub_if_data *sdata;
> > @@ -27,9 +37,18 @@ void ieee802154_wake_queue(struct ieee802154_hw *hw)
> >         }
> >         rcu_read_unlock();
> >  }
> > -EXPORT_SYMBOL(ieee802154_wake_queue);
> >
> > -void ieee802154_stop_queue(struct ieee802154_hw *hw)
> > +/**
> > + * ieee802154_stop_queue - stop ieee802154 queue
> > + * @local: main mac object
> > + *
> > + * Tranceivers usually have either one transmit framebuffer or one framebuffer
> > + * for both transmitting and receiving. Hence, the core currently only handles
> > + * one frame at a time for each phy, which means we need to tell upper layers to
> > + * stop giving us new skbs while we are busy with the transmitted one. The queue
> > + * must then be stopped before transmitting.
> > + */
> > +static void ieee802154_stop_queue(struct ieee802154_hw *hw)
> >  {
> >         struct ieee802154_local *local = hw_to_local(hw);
> >         struct ieee802154_sub_if_data *sdata;
> > @@ -43,14 +62,33 @@ void ieee802154_stop_queue(struct ieee802154_hw *hw)
> >         }
> >         rcu_read_unlock();
> >  }
> > -EXPORT_SYMBOL(ieee802154_stop_queue);
> > +
> > +void ieee802154_hold_queue(struct ieee802154_local *local)
> > +{
> > +       unsigned long flags;
> > +
> > +       spin_lock_irqsave(&local->phy->queue_lock, flags);
> > +       ieee802154_stop_queue(&local->hw);
> > +       atomic_inc(&local->phy->hold_txs);
> > +       spin_unlock_irqrestore(&local->phy->queue_lock, flags);
> > +}  
> 
> I think that works, but I would expect something like:
> 
> if (!atomic_fetch_inc(hold_txs))
>       ieee802154_stop_queue(&local->hw);

I didn't know about the _fetch_ alternative, that looks much better
this way!

