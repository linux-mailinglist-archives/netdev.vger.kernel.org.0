Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54229512D96
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 09:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343681AbiD1ICT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 04:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343692AbiD1ICI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 04:02:08 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4437820BCE;
        Thu, 28 Apr 2022 00:58:53 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id AF8451C0003;
        Thu, 28 Apr 2022 07:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1651132731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3wu9h3NKSKmvHgwXQf+X1OC4mECGCeu1/MQPJ6QY6SE=;
        b=bijCSztHgJJMugFQFHiUQ8aYuRkjruUCYnmB0kgjbJAB1EEdR4wYJf/Y0mbA+kgCGF7JDE
        I/iYOiYIB8edk+3JyFYwuGrJtngst0ToSfMzvrBg9TpRnxazbFPe24IHBcrHqGYbkKnwzJ
        AmoRy/5ozhvOXJYSLEMTxBnTDuuhWqOnFEpFGe+CaZspKLXsYEOuRRSHA7ajdmvRI6UTIu
        YnzzEjZsG8UwGxkKMTAxiAJciDyFnbE/CbyVMQe/a09ZEm0kffvG5ewYVmmPyKNOmpHxT5
        1fERTsbKynD+H9DtSoJSXV5e0lcbuNApL0mADhbfu6iecEqiaOEAKoS7S4O0zQ==
Date:   Thu, 28 Apr 2022 09:58:48 +0200
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
Subject: Re: [PATCH wpan-next 08/11] net: mac802154: Add a warning in the
 hot path
Message-ID: <20220428095848.34582df4@xps13>
In-Reply-To: <CAB_54W7NWEYgmLfowvyXtKEsKhBaVrPzpkB1kasYpAst98mKNA@mail.gmail.com>
References: <20220427164659.106447-1-miquel.raynal@bootlin.com>
        <20220427164659.106447-9-miquel.raynal@bootlin.com>
        <CAB_54W7NWEYgmLfowvyXtKEsKhBaVrPzpkB1kasYpAst98mKNA@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Wed, 27 Apr 2022 14:01:25 -0400:

> Hi,
>=20
> On Wed, Apr 27, 2022 at 12:47 PM Miquel Raynal
> <miquel.raynal@bootlin.com> wrote:
> >
> > We should never start a transmission after the queue has been stopped.
> >
> > But because it might work we don't kill the function here but rather
> > warn loudly the user that something is wrong.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---

[...]

> > diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> > index a8a83f0167bf..021dddfea542 100644
> > --- a/net/mac802154/tx.c
> > +++ b/net/mac802154/tx.c
> > @@ -124,6 +124,8 @@ bool ieee802154_queue_is_held(struct ieee802154_loc=
al *local)
> >  static netdev_tx_t
> >  ieee802154_hot_tx(struct ieee802154_local *local, struct sk_buff *skb)
> >  {
> > +       WARN_ON_ONCE(ieee802154_queue_is_stopped(local));
> > +
> >         return ieee802154_tx(local, skb);
> >  }
> >
> > diff --git a/net/mac802154/util.c b/net/mac802154/util.c
> > index 847e0864b575..cfd17a7db532 100644
> > --- a/net/mac802154/util.c
> > +++ b/net/mac802154/util.c
> > @@ -44,6 +44,24 @@ void ieee802154_stop_queue(struct ieee802154_local *=
local)
> >         rcu_read_unlock();
> >  }
> >
> > +bool ieee802154_queue_is_stopped(struct ieee802154_local *local)
> > +{
> > +       struct ieee802154_sub_if_data *sdata;
> > +       bool stopped =3D true;
> > +
> > +       rcu_read_lock();
> > +       list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> > +               if (!sdata->dev)
> > +                       continue;
> > +
> > +               if (!netif_queue_stopped(sdata->dev))
> > +                       stopped =3D false;
> > +       }
> > +       rcu_read_unlock();
> > +
> > +       return stopped;
> > +} =20
>=20
> sorry this makes no sense, you using net core functionality to check
> if a queue is stopped in a net core netif callback. Whereas the sense
> here for checking if the queue is really stopped is when 802.15.4
> thinks the queue is stopped vs net core netif callback running. It
> means for MLME-ops there are points we want to make sure that net core
> is not handling any xmit and we should check this point and not
> introducing net core functionality checks.

I think I've mixed two things, your remark makes complete sense. I
should instead here just check a 802.15.4 internal variable.

> btw: if it's hit your if branch the first time you can break?

Yes, we could definitely improve a bit the logic to break earlier, but
in the end these checks won't remain I believe.

> I am not done with the review, this is just what I see now and we can
> discuss that. Please be patient.

Sure, thanks for the quick feedback anyway!

hanks,
Miqu=C3=A8l
