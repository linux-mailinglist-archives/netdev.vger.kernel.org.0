Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6774052A31E
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 15:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347537AbiEQNUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 09:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244252AbiEQNUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 09:20:37 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9DF41F94;
        Tue, 17 May 2022 06:20:34 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 4392CE0004;
        Tue, 17 May 2022 13:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652793633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VGA1m2y8YSHz8H7uGnZBsOWObUywmlYTfnHhSOJQS5U=;
        b=gINv2Y2kScCWE0hSptZwqibParbTB6i+tV6PFuAWfP6rbFdEeVslAbijmQH4Y5CtdTh4YX
        2i5EXCJGDpolSj5lIAznIPSB5ajxbHHErAwyROKxG4Elz3LEvVZpjTwUCfsumCvdEmZ3GR
        V3jmGKpngZg+9i10fYynECWcxyH37FV8xebMPq5xt1/elAVT9LE5V2bw7uGLtLoXAsEptb
        gnWECkSqTuyqiCWInU58v/DKRt5f/EN4j0gBTCYFq4JN1QTnOLM3dU8q9wynZy4163zyPa
        JnkCRloOKHI5uYm85mCXs50C2MHByW52y8e1jKB76nhuKi4mmbVl7+CvfETQyQ==
Date:   Tue, 17 May 2022 15:20:29 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next v2 08/11] net: mac802154: Introduce a tx queue
 flushing mechanism
Message-ID: <20220517152029.792200a6@xps-13>
In-Reply-To: <CAK-6q+iazXHZmf2vteXGEEpSXLLp9279g5JD2whBn-_FPL0piw@mail.gmail.com>
References: <20220512143314.235604-1-miquel.raynal@bootlin.com>
        <20220512143314.235604-9-miquel.raynal@bootlin.com>
        <CAK-6q+iazXHZmf2vteXGEEpSXLLp9279g5JD2whBn-_FPL0piw@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
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

Hi Alex,

aahringo@redhat.com wrote on Sun, 15 May 2022 18:23:04 -0400:

> Hi,
>=20
> On Thu, May 12, 2022 at 10:34 AM Miquel Raynal
> <miquel.raynal@bootlin.com> wrote:
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
> >  net/mac802154/cfg.c          |  2 +-
> >  net/mac802154/ieee802154_i.h |  1 +
> >  net/mac802154/tx.c           | 26 ++++++++++++++++++++++++--
> >  net/mac802154/util.c         |  6 ++++--
> >  6 files changed, 32 insertions(+), 5 deletions(-)
> >
> > diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> > index ad3f438e4583..8b6326aa2d42 100644
> > --- a/include/net/cfg802154.h
> > +++ b/include/net/cfg802154.h
> > @@ -218,6 +218,7 @@ struct wpan_phy {
> >         struct mutex queue_lock;
> >         atomic_t ongoing_txs;
> >         atomic_t hold_txs;
> > +       wait_queue_head_t sync_txq;
> >
> >         char priv[] __aligned(NETDEV_ALIGN);
> >  };
> > diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
> > index d81b7301e013..f13e3082d988 100644
> > --- a/net/ieee802154/core.c
> > +++ b/net/ieee802154/core.c
> > @@ -129,6 +129,7 @@ wpan_phy_new(const struct cfg802154_ops *ops, size_=
t priv_size)
> >         wpan_phy_net_set(&rdev->wpan_phy, &init_net);
> >
> >         init_waitqueue_head(&rdev->dev_wait);
> > +       init_waitqueue_head(&rdev->wpan_phy.sync_txq);
> >
> >         mutex_init(&rdev->wpan_phy.queue_lock);
> >
> > diff --git a/net/mac802154/cfg.c b/net/mac802154/cfg.c
> > index b51100fd9e3f..93df24f75572 100644
> > --- a/net/mac802154/cfg.c
> > +++ b/net/mac802154/cfg.c
> > @@ -46,7 +46,7 @@ static int ieee802154_suspend(struct wpan_phy *wpan_p=
hy)
> >         if (!local->open_count)
> >                 goto suspend;
> >
> > -       ieee802154_hold_queue(local);
> > +       ieee802154_sync_and_hold_queue(local);
> >         synchronize_net();
> >
> >         /* stop hardware - this must stop RX */
> > diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
> > index e34db1d49ef4..a057827fc48a 100644
> > --- a/net/mac802154/ieee802154_i.h
> > +++ b/net/mac802154/ieee802154_i.h
> > @@ -124,6 +124,7 @@ extern struct ieee802154_mlme_ops mac802154_mlme_wp=
an;
> >
> >  void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb=
);
> >  void ieee802154_xmit_sync_worker(struct work_struct *work);
> > +int ieee802154_sync_and_hold_queue(struct ieee802154_local *local);
> >  netdev_tx_t
> >  ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *=
dev);
> >  netdev_tx_t
> > diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> > index 607019b8f8ab..38f74b8b6740 100644
> > --- a/net/mac802154/tx.c
> > +++ b/net/mac802154/tx.c
> > @@ -44,7 +44,8 @@ void ieee802154_xmit_sync_worker(struct work_struct *=
work)
> >  err_tx:
> >         /* Restart the netif queue on each sub_if_data object. */
> >         ieee802154_release_queue(local);
> > -       atomic_dec(&local->phy->ongoing_txs);
> > +       if (!atomic_dec_and_test(&local->phy->ongoing_txs))
> > +               wake_up(&local->phy->sync_txq);
> >         kfree_skb(skb);
> >         netdev_dbg(dev, "transmission failed\n");
> >  }
> > @@ -100,12 +101,33 @@ ieee802154_tx(struct ieee802154_local *local, str=
uct sk_buff *skb)
> >
> >  err_wake_netif_queue:
> >         ieee802154_release_queue(local);
> > -       atomic_dec(&local->phy->ongoing_txs);
> > +       if (!atomic_dec_and_test(&local->phy->ongoing_txs))
> > +               wake_up(&local->phy->sync_txq);
> >  err_free_skb:
> >         kfree_skb(skb);
> >         return NETDEV_TX_OK;
> >  }
> >
> > +static int ieee802154_sync_queue(struct ieee802154_local *local)
> > +{
> > +       int ret;
> > +
> > +       ieee802154_hold_queue(local);
> > +       ieee802154_disable_queue(local);
> > +       wait_event(local->phy->sync_txq, !atomic_read(&local->phy->ongo=
ing_txs));
> > +       ret =3D local->tx_result;
> > +       ieee802154_release_queue(local); =20
>=20
> I am curious, why this extra hold, release here?

My idea was:
- stop the queue
- increment the hold counter to be sure the queue does not get
  restarted asynchronously
- wait for the last transmission to finish
- decrement the hold counter
- restart the queue if the hold counter is null

What is bothering you with it? Without the hold we cannot be sure that
an asynchronous event will not restart the queue and possibly fail our
logic.

Thanks,
Miqu=C3=A8l
