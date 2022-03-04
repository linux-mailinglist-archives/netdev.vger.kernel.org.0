Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 288A14CD2D0
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 11:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235443AbiCDKz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 05:55:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbiCDKzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 05:55:25 -0500
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7771AE67E;
        Fri,  4 Mar 2022 02:54:37 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 185FD240013;
        Fri,  4 Mar 2022 10:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1646391275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eXWcd5ScNqhkX6C5764mjPM5HnQekhV1ceSNzCWoJJ8=;
        b=Qdji2veqz6rI0IxZsljA48y18Zp8Wpt2lYcrLCvMi1yoCZLrXiZpLQ2gQ4onihdApod+W9
        0JBHYcxZRREorOrW/sQDUHeA0hf7Jn67lVmMoAryS8FdfO6BFpN0eCCp/6zNvpy7+SrWse
        YWXaeqm4ifJ1eI/m2FkZzY5TByKfSKASCWajs+PBGd0FRzIxKgBGxyD9x7i9qvMvq/SDpC
        bXfVduM5NeegH0bsfNSQTcgznp9D+3sqhB6l7JHHJWV1eFixS2MG9PU/xLEQqEdAjidkku
        WMxDyg+//hs8wXZFTXOnWxdlfuCiQzErFQcTbQKJ0+b7DWx3Mtj9VyDJeDyzNQ==
Date:   Fri, 4 Mar 2022 11:54:32 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next v2 13/14] net: mac802154: Introduce a tx queue
 flushing mechanism
Message-ID: <20220304115432.7913f2ef@xps13>
In-Reply-To: <20220303191723.39b87766@xps13>
References: <20220207144804.708118-1-miquel.raynal@bootlin.com>
        <20220207144804.708118-14-miquel.raynal@bootlin.com>
        <CAB_54W5ao0b6QE7E_uXFeorbn6UjB6NV4emtibqswL4iXYEfng@mail.gmail.com>
        <20220303191723.39b87766@xps13>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

miquel.raynal@bootlin.com wrote on Thu, 3 Mar 2022 19:17:23 +0100:

> Hi Alexander,
>=20
> alex.aring@gmail.com wrote on Sun, 20 Feb 2022 18:49:06 -0500:
>=20
> > Hi,
> >=20
> > On Mon, Feb 7, 2022 at 9:48 AM Miquel Raynal <miquel.raynal@bootlin.com=
> wrote: =20
> > >
> > > Right now we are able to stop a queue but we have no indication if a
> > > transmission is ongoing or not.
> > >
> > > Thanks to recent additions, we can track the number of ongoing
> > > transmissions so we know if the last transmission is over. Adding on =
top
> > > of it an internal wait queue also allows to be woken up asynchronously
> > > when this happens. If, beforehands, we marked the queue to be held and
> > > stopped it, we end up flushing and stopping the tx queue.
> > >
> > > Thanks to this feature, we will soon be able to introduce a synchrono=
us
> > > transmit API.
> > >
> > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > ---
> > >  include/net/cfg802154.h      |  1 +
> > >  net/ieee802154/core.c        |  1 +
> > >  net/mac802154/cfg.c          |  5 ++---
> > >  net/mac802154/ieee802154_i.h |  1 +
> > >  net/mac802154/tx.c           | 11 ++++++++++-
> > >  net/mac802154/util.c         |  3 ++-
> > >  6 files changed, 17 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> > > index 043d8e4359e7..0d385a214da3 100644
> > > --- a/include/net/cfg802154.h
> > > +++ b/include/net/cfg802154.h
> > > @@ -217,6 +217,7 @@ struct wpan_phy {
> > >         /* Transmission monitoring and control */
> > >         atomic_t ongoing_txs;
> > >         atomic_t hold_txs;
> > > +       wait_queue_head_t sync_txq;
> > >
> > >         char priv[] __aligned(NETDEV_ALIGN);
> > >  };
> > > diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
> > > index de259b5170ab..0953cacafbff 100644
> > > --- a/net/ieee802154/core.c
> > > +++ b/net/ieee802154/core.c
> > > @@ -129,6 +129,7 @@ wpan_phy_new(const struct cfg802154_ops *ops, siz=
e_t priv_size)
> > >         wpan_phy_net_set(&rdev->wpan_phy, &init_net);
> > >
> > >         init_waitqueue_head(&rdev->dev_wait);
> > > +       init_waitqueue_head(&rdev->wpan_phy.sync_txq);
> > >
> > >         return &rdev->wpan_phy;
> > >  }
> > > diff --git a/net/mac802154/cfg.c b/net/mac802154/cfg.c
> > > index e8aabf215286..da94aaa32fcb 100644
> > > --- a/net/mac802154/cfg.c
> > > +++ b/net/mac802154/cfg.c
> > > @@ -46,8 +46,7 @@ static int ieee802154_suspend(struct wpan_phy *wpan=
_phy)
> > >         if (!local->open_count)
> > >                 goto suspend;
> > >
> > > -       atomic_inc(&wpan_phy->hold_txs);
> > > -       ieee802154_stop_queue(&local->hw);
> > > +       ieee802154_sync_and_stop_tx(local);
> > >         synchronize_net();
> > >
> > >         /* stop hardware - this must stop RX */
> > > @@ -73,7 +72,7 @@ static int ieee802154_resume(struct wpan_phy *wpan_=
phy)
> > >                 return ret;
> > >
> > >  wake_up:
> > > -       if (!atomic_dec_and_test(&wpan_phy->hold_txs))
> > > +       if (!atomic_read(&wpan_phy->hold_txs))
> > >                 ieee802154_wake_queue(&local->hw);
> > >         local->suspended =3D false;
> > >         return 0;
> > > diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_=
i.h
> > > index 56fcd7ef5b6f..295c9ce091e1 100644
> > > --- a/net/mac802154/ieee802154_i.h
> > > +++ b/net/mac802154/ieee802154_i.h
> > > @@ -122,6 +122,7 @@ extern struct ieee802154_mlme_ops mac802154_mlme_=
wpan;
> > >
> > >  void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *s=
kb);
> > >  void ieee802154_xmit_sync_worker(struct work_struct *work);
> > > +void ieee802154_sync_and_stop_tx(struct ieee802154_local *local);
> > >  netdev_tx_t
> > >  ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device=
 *dev);
> > >  netdev_tx_t
> > > diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> > > index abd9a057521e..06ae2e6cea43 100644
> > > --- a/net/mac802154/tx.c
> > > +++ b/net/mac802154/tx.c
> > > @@ -47,7 +47,8 @@ void ieee802154_xmit_sync_worker(struct work_struct=
 *work)
> > >                 ieee802154_wake_queue(&local->hw);
> > >
> > >         kfree_skb(skb);
> > > -       atomic_dec(&local->phy->ongoing_txs);
> > > +       if (!atomic_dec_and_test(&local->phy->ongoing_txs))
> > > +               wake_up(&local->phy->sync_txq);
> > >         netdev_dbg(dev, "transmission failed\n");
> > >  }
> > >
> > > @@ -117,6 +118,14 @@ ieee802154_hot_tx(struct ieee802154_local *local=
, struct sk_buff *skb)
> > >         return ieee802154_tx(local, skb);
> > >  }
> > >
> > > +void ieee802154_sync_and_stop_tx(struct ieee802154_local *local)
> > > +{
> > > +       atomic_inc(&local->phy->hold_txs);
> > > +       ieee802154_stop_queue(&local->hw);
> > > +       wait_event(local->phy->sync_txq, !atomic_read(&local->phy->on=
going_txs));
> > > +       atomic_dec(&local->phy->hold_txs);   =20
> >=20
> > In my opinion this _still_ races as I mentioned earlier. You need to
> > be sure that if you do ieee802154_stop_queue() that no ieee802154_tx()
> > or hot_tx() is running at this time. Look into the function I
> > mentioned earlier "?netif_tx_disable()?". =20
>=20
> I think now I get the problem, but I am having troubles understanding
> the logic in netif_tx_disable(), or should I say, the idea that I
> should adapt to our situation.
>=20
> I understand that we should make sure the following situation does not
> happen:
> - ieee802154_subif_start_xmit() is called
> - ieee802154_subif_start_xmit() is called again
> - ieee802154_tx() get's executed once and stops the queue
> - ongoing_txs gets incremented once
> - the first transfer finishes and ongoing_txs gets decremented
> - the tx queue is supposedly empty by the current series while
>   the second transfer requested earlier has not yet been processed and
>   will definitely be tried in a short moment.
>=20
> I don't find a pretty solution for that. Is your suggestion to use the
> netdev tx_global_lock? If yes, then, how? Because it does not appear
> clear to me how we should tackle this issue.

I had a second look at it and it appears to me that the issue was
already there and is structural. We just did not really cared about it
because we didn't bother with synchronization issues.

Here is a figure to base our discussions on:

                       enable
                         =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
                         =E2=94=82                                         =
                   =E2=94=82
                         =E2=96=BC                                         =
                   =E2=94=82
          packet     =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=90   =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=90   =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90   =E2=
=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=90   =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
            =E2=94=8C=E2=94=90       =E2=94=82        =E2=94=82   =E2=94=82=
            =E2=94=82   =E2=94=82            =E2=94=82   =E2=94=82       =
=E2=94=82   =E2=94=82           =E2=94=82
User  =E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=
=B4=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=96=BA=E2=94=82=
 Queue  =E2=94=9C=E2=94=80=E2=94=80=E2=96=BA=E2=94=82 ieee*_tx() =E2=94=9C=
=E2=94=80=E2=94=80=E2=96=BA=E2=94=82stop_queue()=E2=94=9C=E2=94=80=E2=94=80=
=E2=96=BA=E2=94=82xmit() =E2=94=9C=E2=94=80=E2=94=80=E2=96=BA=E2=94=82 wait=
/sync =E2=94=82
                     =E2=94=82        =E2=94=82   =E2=94=82            =E2=
=94=82   =E2=94=82            =E2=94=82   =E2=94=82       =E2=94=82   =E2=
=94=82           =E2=94=82
                     =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=98   =E2=94=94=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=98   =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98   =E2=
=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=98   =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
                         =E2=96=B2                               =E2=94=82
                         =E2=94=82                               =E2=94=82
                         =E2=94=82                               =E2=94=82
                         =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=98
                      disable

I assumed that we don't have the hand on the queuing mechanism (on the
left of the 'queue' box). I looked at the core code under
net/ieee802154/ and even if incrementing a counter there would be
handy, I assumed this was not an acceptable solution.

So then we end up with the possible situation where there are two (or
more) packets that must be processed by the mac tx logic (at the right
of the 'queue' box). The problem is of course the atomicity of the
stop_queue() compared to the number of times the ieee802154_tx()
function call can be made. We can have several packets being processed,
we don't have any way to know that.

Moving the stop_queue earlier would just reduce the racy area, without
fully preventing it, so not a solution per-se.

Perhaps we could monitor the state of the queue, it would help us know
if we need to retain a packet, but I personally find this a bit crappy,
yet probably working. Here is a drafted implementation, I'm only half
convinced this is a good idea and your input is welcome here:

--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -77,14 +77,26 @@ ieee802154_tx(struct ieee802154_local *local, struct sk=
_buff *skb)
                put_unaligned_le16(crc, skb_put(skb, 2));
        }
=20
+retry:
+       while (netif_queue_stopped())
+               schedule();
+
+       acquire_lock();
+       if (netif_queue_stopped()) {
+               release_lock();
+               goto retry;
+       }
+
        /* Stop the netif queue on each sub_if_data object. */
        ieee802154_stop_queue(&local->hw);
=20
+       atomic_inc(&local->phy->ongoing_txs);
+       release_lock();
+
        /* Drivers should preferably implement the async callback. In some =
rare
         * cases they only provide a sync callback which we will use as a
         * fallback.
         */
        if (local->ops->xmit_async) {
                unsigned int len =3D skb->len;
=20
@@ -122,8 +134,10 @@ int ieee802154_sync_and_stop_tx(struct ieee802154_loca=
l *local)
 {
        int ret;
=20
+       acquire_lock();
        atomic_inc(&local->phy->hold_txs);
        ieee802154_stop_queue(&local->hw);
+       release_lock();
        wait_event(local->phy->sync_txq, !atomic_read(&local->phy->ongoing_=
txs));
        ret =3D local->tx_result;
        atomic_dec(&local->phy->hold_txs);


If we go in this direction, perhaps it's best to rework the sync API
like you already proposed: just stopping the queue and syncing the
ongoing transfers, so that after that we can use a dedicated tx path
for MLME commands, bypassing the queue-is-stopped check. This way we
avoid risking to deliver data packets between two MLME calls.

Thanks,
Miqu=C3=A8l
