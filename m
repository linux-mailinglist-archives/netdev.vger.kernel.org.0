Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6784CC4F1
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 19:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235703AbiCCSSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 13:18:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233465AbiCCSSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 13:18:21 -0500
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82558FFB;
        Thu,  3 Mar 2022 10:17:28 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 9BDA5240005;
        Thu,  3 Mar 2022 18:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1646331446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nIxXXXLHD2E+XTdC/+BYIGzpWC1fkka21Aw0CcVXIMk=;
        b=NvNqnWrS6k8dD9aCJ3bbWJNjrkPz9R8lvW/usQDq8XXbeqT+XQRTwTyD0ai7xV5g0kyTmB
        YYdHtzzzfCkXCmzED+OrcxxoZfYOd5mwOFrJYHise1tYy6p5juJR8aMZ+J3KDseDsv91yS
        BTR+43MijeLqNV9RvR1JThyPlXFRpiZk+1q35wvxIA5pbuj+Ble8C4YOSy/pMi/YGeBbsX
        EBeJJrd6lLyRueLC/d6/5paKuwiVgi6BKycLOB9f/9u811Pm8OvX96kokupOCcQODOpIGk
        RSDxeNfpshdZ4LHWRdM2oBkmZIKJ5HXpYBW4mWTjFIZ9253T7lVrmj4eDTzgdg==
Date:   Thu, 3 Mar 2022 19:17:23 +0100
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
Message-ID: <20220303191723.39b87766@xps13>
In-Reply-To: <CAB_54W5ao0b6QE7E_uXFeorbn6UjB6NV4emtibqswL4iXYEfng@mail.gmail.com>
References: <20220207144804.708118-1-miquel.raynal@bootlin.com>
        <20220207144804.708118-14-miquel.raynal@bootlin.com>
        <CAB_54W5ao0b6QE7E_uXFeorbn6UjB6NV4emtibqswL4iXYEfng@mail.gmail.com>
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

alex.aring@gmail.com wrote on Sun, 20 Feb 2022 18:49:06 -0500:

> Hi,
>=20
> On Mon, Feb 7, 2022 at 9:48 AM Miquel Raynal <miquel.raynal@bootlin.com> =
wrote:
> >
> > Right now we are able to stop a queue but we have no indication if a
> > transmission is ongoing or not.
> >
> > Thanks to recent additions, we can track the number of ongoing
> > transmissions so we know if the last transmission is over. Adding on top
> > of it an internal wait queue also allows to be woken up asynchronously
> > when this happens. If, beforehands, we marked the queue to be held and
> > stopped it, we end up flushing and stopping the tx queue.
> >
> > Thanks to this feature, we will soon be able to introduce a synchronous
> > transmit API.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  include/net/cfg802154.h      |  1 +
> >  net/ieee802154/core.c        |  1 +
> >  net/mac802154/cfg.c          |  5 ++---
> >  net/mac802154/ieee802154_i.h |  1 +
> >  net/mac802154/tx.c           | 11 ++++++++++-
> >  net/mac802154/util.c         |  3 ++-
> >  6 files changed, 17 insertions(+), 5 deletions(-)
> >
> > diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> > index 043d8e4359e7..0d385a214da3 100644
> > --- a/include/net/cfg802154.h
> > +++ b/include/net/cfg802154.h
> > @@ -217,6 +217,7 @@ struct wpan_phy {
> >         /* Transmission monitoring and control */
> >         atomic_t ongoing_txs;
> >         atomic_t hold_txs;
> > +       wait_queue_head_t sync_txq;
> >
> >         char priv[] __aligned(NETDEV_ALIGN);
> >  };
> > diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
> > index de259b5170ab..0953cacafbff 100644
> > --- a/net/ieee802154/core.c
> > +++ b/net/ieee802154/core.c
> > @@ -129,6 +129,7 @@ wpan_phy_new(const struct cfg802154_ops *ops, size_=
t priv_size)
> >         wpan_phy_net_set(&rdev->wpan_phy, &init_net);
> >
> >         init_waitqueue_head(&rdev->dev_wait);
> > +       init_waitqueue_head(&rdev->wpan_phy.sync_txq);
> >
> >         return &rdev->wpan_phy;
> >  }
> > diff --git a/net/mac802154/cfg.c b/net/mac802154/cfg.c
> > index e8aabf215286..da94aaa32fcb 100644
> > --- a/net/mac802154/cfg.c
> > +++ b/net/mac802154/cfg.c
> > @@ -46,8 +46,7 @@ static int ieee802154_suspend(struct wpan_phy *wpan_p=
hy)
> >         if (!local->open_count)
> >                 goto suspend;
> >
> > -       atomic_inc(&wpan_phy->hold_txs);
> > -       ieee802154_stop_queue(&local->hw);
> > +       ieee802154_sync_and_stop_tx(local);
> >         synchronize_net();
> >
> >         /* stop hardware - this must stop RX */
> > @@ -73,7 +72,7 @@ static int ieee802154_resume(struct wpan_phy *wpan_ph=
y)
> >                 return ret;
> >
> >  wake_up:
> > -       if (!atomic_dec_and_test(&wpan_phy->hold_txs))
> > +       if (!atomic_read(&wpan_phy->hold_txs))
> >                 ieee802154_wake_queue(&local->hw);
> >         local->suspended =3D false;
> >         return 0;
> > diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
> > index 56fcd7ef5b6f..295c9ce091e1 100644
> > --- a/net/mac802154/ieee802154_i.h
> > +++ b/net/mac802154/ieee802154_i.h
> > @@ -122,6 +122,7 @@ extern struct ieee802154_mlme_ops mac802154_mlme_wp=
an;
> >
> >  void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb=
);
> >  void ieee802154_xmit_sync_worker(struct work_struct *work);
> > +void ieee802154_sync_and_stop_tx(struct ieee802154_local *local);
> >  netdev_tx_t
> >  ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *=
dev);
> >  netdev_tx_t
> > diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> > index abd9a057521e..06ae2e6cea43 100644
> > --- a/net/mac802154/tx.c
> > +++ b/net/mac802154/tx.c
> > @@ -47,7 +47,8 @@ void ieee802154_xmit_sync_worker(struct work_struct *=
work)
> >                 ieee802154_wake_queue(&local->hw);
> >
> >         kfree_skb(skb);
> > -       atomic_dec(&local->phy->ongoing_txs);
> > +       if (!atomic_dec_and_test(&local->phy->ongoing_txs))
> > +               wake_up(&local->phy->sync_txq);
> >         netdev_dbg(dev, "transmission failed\n");
> >  }
> >
> > @@ -117,6 +118,14 @@ ieee802154_hot_tx(struct ieee802154_local *local, =
struct sk_buff *skb)
> >         return ieee802154_tx(local, skb);
> >  }
> >
> > +void ieee802154_sync_and_stop_tx(struct ieee802154_local *local)
> > +{
> > +       atomic_inc(&local->phy->hold_txs);
> > +       ieee802154_stop_queue(&local->hw);
> > +       wait_event(local->phy->sync_txq, !atomic_read(&local->phy->ongo=
ing_txs));
> > +       atomic_dec(&local->phy->hold_txs); =20
>=20
> In my opinion this _still_ races as I mentioned earlier. You need to
> be sure that if you do ieee802154_stop_queue() that no ieee802154_tx()
> or hot_tx() is running at this time. Look into the function I
> mentioned earlier "?netif_tx_disable()?".

I think now I get the problem, but I am having troubles understanding
the logic in netif_tx_disable(), or should I say, the idea that I
should adapt to our situation.

I understand that we should make sure the following situation does not
happen:
- ieee802154_subif_start_xmit() is called
- ieee802154_subif_start_xmit() is called again
- ieee802154_tx() get's executed once and stops the queue
- ongoing_txs gets incremented once
- the first transfer finishes and ongoing_txs gets decremented
- the tx queue is supposedly empty by the current series while
  the second transfer requested earlier has not yet been processed and
  will definitely be tried in a short moment.

I don't find a pretty solution for that. Is your suggestion to use the
netdev tx_global_lock? If yes, then, how? Because it does not appear
clear to me how we should tackle this issue.

In the mean time, I believe the first half of the series is now big
enough to be sent aside given the number of additional commits that
have popped up following your last review :)

Thanks,
Miqu=C3=A8l
