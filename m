Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5A4492D0F
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 19:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347859AbiARSOi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 18 Jan 2022 13:14:38 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:48303 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347861AbiARSOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 13:14:36 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 9371E60002;
        Tue, 18 Jan 2022 18:14:31 +0000 (UTC)
Date:   Tue, 18 Jan 2022 19:14:29 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH v3 27/41] net: mac802154: Introduce a tx queue flushing
 mechanism
Message-ID: <20220118191429.19ea3c7d@xps13>
In-Reply-To: <CAB_54W562uzk3NzXDTgRLbQzi=hgQDntJOqmMDVZwaJ_eDZZMQ@mail.gmail.com>
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
        <20220117115440.60296-28-miquel.raynal@bootlin.com>
        <CAB_54W562uzk3NzXDTgRLbQzi=hgQDntJOqmMDVZwaJ_eDZZMQ@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Mon, 17 Jan 2022 17:43:49 -0500:

> Hi,
> 
> On Mon, 17 Jan 2022 at 06:55, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> ...
> >
> >         /* stop hardware - this must stop RX */
> > diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
> > index 0291e49058f2..37d5438fdb3f 100644
> > --- a/net/mac802154/ieee802154_i.h
> > +++ b/net/mac802154/ieee802154_i.h
> > @@ -122,6 +122,7 @@ extern struct ieee802154_mlme_ops mac802154_mlme_wpan;
> >
> >  void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb);
> >  void ieee802154_xmit_sync_worker(struct work_struct *work);
> > +void ieee802154_sync_tx(struct ieee802154_local *local);
> >  netdev_tx_t
> >  ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
> >  netdev_tx_t
> > diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> > index de5ecda80472..d1fd2cc67cbe 100644
> > --- a/net/mac802154/tx.c
> > +++ b/net/mac802154/tx.c
> > @@ -48,6 +48,7 @@ void ieee802154_xmit_sync_worker(struct work_struct *work)
> >
> >         kfree_skb(skb);
> >         atomic_dec(&local->phy->ongoing_txs);
> > +       wake_up(&local->phy->sync_txq);  
> 
> if (atomic_dec_and_test(&hw->phy->ongoing_txs))
>       wake_up(&hw->phy->sync_txq);

As we test this condition in the waiting path I assumed it was fine to
do it this way, but the additional check does not hurt, so I'll add it.

Thanks,
Miquèl
