Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5AD54F7C50
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 12:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236044AbiDGKFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 06:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235915AbiDGKE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 06:04:58 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A184AE34;
        Thu,  7 Apr 2022 03:02:55 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 3A2F560003;
        Thu,  7 Apr 2022 10:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649325774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kei7tpdBiTStLWxMw1bmF2HQh48Sk0nc8cF/hCT1xSI=;
        b=gVu7Bo9Hjo5C13j8ARKg9J2LiDC6CZqBQy6GhjjnicKQkTfYQd5eCDdLBjgGs4oFvsIaue
        vvi2NVsTvthnXP3aiqdxyyKTLg2eBot2BRHSM0pEZ6WqFnjuhcSOap5uhsd/dIU4NvmWz2
        fRihyWvnhGFp//j4HFroZJRCPawhH1TO+FWzQaiDknbCrubT5AfQwRpzqZ8rwoQ76sx5ua
        VzYKfHnL14BomegsUa6DmUYZb2S91K1B/20OjQwZpvhjBVoWeSpeWGaqf1RAuU9vitbkA5
        Pbhrr9V+CtpXtzfENN7wCluPOE8YkDxD7ZxjPBiRxnyIZOM0kOvefZ84IWDz6w==
Date:   Thu, 7 Apr 2022 12:02:51 +0200
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
Subject: Re: [PATCH v5 05/11] net: mac802154: Create a transmit bus error
 helper
Message-ID: <20220407120251.5b15db9d@xps13>
In-Reply-To: <20220407095605.1ca9f6e6@xps13>
References: <20220406153441.1667375-1-miquel.raynal@bootlin.com>
        <20220406153441.1667375-6-miquel.raynal@bootlin.com>
        <CAB_54W53OrQVYo4pjCpgYaQGVsa-hZ2gBrquFGO_vQ5RMsm-jQ@mail.gmail.com>
        <20220407095605.1ca9f6e6@xps13>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


miquel.raynal@bootlin.com wrote on Thu, 7 Apr 2022 09:56:05 +0200:

> Hi Alexander,
>=20
> alex.aring@gmail.com wrote on Wed, 6 Apr 2022 17:43:30 -0400:
>=20
> > Hi,
> >=20
> > On Wed, Apr 6, 2022 at 11:34 AM Miquel Raynal <miquel.raynal@bootlin.co=
m> wrote: =20
> > >
> > > A few drivers do the full transmit operation asynchronously, which me=
ans
> > > that a bus error that happens when forwarding the packet to the
> > > transmitter will not be reported immediately. The solution in this ca=
se
> > > is to call this new helper to free the necessary resources, restart t=
he
> > > the queue and return a generic TRAC error code: IEEE802154_SYSTEM_ERR=
OR.
> > >
> > > Suggested-by: Alexander Aring <alex.aring@gmail.com>
> > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > ---
> > >  include/net/mac802154.h |  9 +++++++++
> > >  net/mac802154/util.c    | 10 ++++++++++
> > >  2 files changed, 19 insertions(+)
> > >
> > > diff --git a/include/net/mac802154.h b/include/net/mac802154.h
> > > index abbe88dc9df5..5240d94aad8e 100644
> > > --- a/include/net/mac802154.h
> > > +++ b/include/net/mac802154.h
> > > @@ -498,6 +498,15 @@ void ieee802154_stop_queue(struct ieee802154_hw =
*hw);
> > >  void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_bu=
ff *skb,
> > >                               bool ifs_handling);
> > >
> > > +/**
> > > + * ieee802154_xmit_bus_error - frame could not be delivered to the t=
rasmitter
> > > + *                             because of a bus error
> > > + *
> > > + * @hw: pointer as obtained from ieee802154_alloc_hw().
> > > + * @skb: buffer for transmission
> > > + */
> > > +void ieee802154_xmit_bus_error(struct ieee802154_hw *hw, struct sk_b=
uff *skb);
> > > +
> > >  /**
> > >   * ieee802154_xmit_error - frame transmission failed
> > >   *
> > > diff --git a/net/mac802154/util.c b/net/mac802154/util.c
> > > index ec523335336c..79ba803c40c9 100644
> > > --- a/net/mac802154/util.c
> > > +++ b/net/mac802154/util.c
> > > @@ -102,6 +102,16 @@ void ieee802154_xmit_error(struct ieee802154_hw =
*hw, struct sk_buff *skb,
> > >  }
> > >  EXPORT_SYMBOL(ieee802154_xmit_error);
> > >
> > > +void ieee802154_xmit_bus_error(struct ieee802154_hw *hw, struct sk_b=
uff *skb)
> > > +{
> > > +       struct ieee802154_local *local =3D hw_to_local(hw);
> > > +
> > > +       local->tx_result =3D IEEE802154_SYSTEM_ERROR;
> > > +       ieee802154_wake_queue(hw);
> > > +       dev_kfree_skb_any(skb);
> > > +}
> > > +EXPORT_SYMBOL(ieee802154_xmit_bus_error);
> > > +   =20
> >=20
> > why not calling ieee802154_xmit_error(..., IEEE802154_SYSTEM_ERROR) ?
> > Just don't give the user a chance to pick a error code if something
> > bad happened. =20
>=20
> Oh ok, I assumed, based on your last comment, that you wanted a
> dedicated helper for that, but if just calling xmit_error() with the
> a fixed value is enough I'll drop this commit.

I am re-reading your comment and actually you want this helper, but you
advise to call ieee802154_xmit_error() instead of re-writing its
content, which I agree with. So I will adapt the series in this
direction, hopefully that will match your expectations.

Thanks,
Miqu=C3=A8l
