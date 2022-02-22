Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5778D4BF3E2
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 09:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiBVInf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 03:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiBVInb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 03:43:31 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A896D3ACD;
        Tue, 22 Feb 2022 00:43:05 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A0F8EC0005;
        Tue, 22 Feb 2022 08:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645519384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yMJpKNOFrSvhoD4frK5CvGjEmGfGH3X1SvaVEYIamGM=;
        b=ZcnApdIWhh6y3fdBWparSiErGJcyIeZCxXY+BVsY+8LEVXYLGM2CSN3huuW3Tiu2PF+B9x
        Hz5pHrBcwlYjc5oal88l5RWR0PyqRh77DL2rSXyJaVehKWc7RmTsl12IZuphfiMSul863r
        x+D1WUhzqsa59It61eQ2mg5BYqUH3Av98TwShp46hk/d09ed22nKEFYFQAwYYOE3VBQbK9
        +FzLLxORWcUGOIg3oPTwxOnIArwb+Txh17evqY1U5CU3o9WrGApDRVSLKD+7qs7nzWqruj
        I/hUtLdEkboMeb3ibNCq5BnFFDEiP2jORdgVsfoFUPl8Skfjw0Im4SDfgiWXUg==
Date:   Tue, 22 Feb 2022 09:43:00 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next v2 02/14] net: mac802154: Create a transmit
 error helper
Message-ID: <20220222094300.698c39c9@xps13>
In-Reply-To: <CAB_54W6iBmxnRjdjmbWTPzci0za7Lu5UwVFqLJsjQFacxAYQYQ@mail.gmail.com>
References: <20220207144804.708118-1-miquel.raynal@bootlin.com>
        <20220207144804.708118-3-miquel.raynal@bootlin.com>
        <CAK-6q+iebK43LComxxjvg0pBiD_AK0MMyMucLHmeVG2zbHPErQ@mail.gmail.com>
        <CAB_54W6iBmxnRjdjmbWTPzci0za7Lu5UwVFqLJsjQFacxAYQYQ@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Mon, 21 Feb 2022 15:22:40 -0500:

> Hi,
>=20
> On Sun, Feb 20, 2022 at 6:31 PM Alexander Aring <aahringo@redhat.com> wro=
te:
> >
> > Hi,
> >
> > On Mon, Feb 7, 2022 at 10:09 AM Miquel Raynal <miquel.raynal@bootlin.co=
m> wrote: =20
> > >
> > > So far there is only a helper for successful transmission, which led
> > > device drivers to implement their own handling in case of
> > > error. Unfortunately, we really need all the drivers to give the hand
> > > back to the core once they are done in order to be able to build a
> > > proper synchronous API. So let's create a _xmit_error() helper.
> > >
> > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > ---
> > >  include/net/mac802154.h | 10 ++++++++++
> > >  net/mac802154/util.c    | 10 ++++++++++
> > >  2 files changed, 20 insertions(+)
> > >
> > > diff --git a/include/net/mac802154.h b/include/net/mac802154.h
> > > index 2c3bbc6645ba..9fe8cfef1ba0 100644
> > > --- a/include/net/mac802154.h
> > > +++ b/include/net/mac802154.h
> > > @@ -498,4 +498,14 @@ void ieee802154_stop_queue(struct ieee802154_hw =
*hw);
> > >  void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_bu=
ff *skb,
> > >                               bool ifs_handling);
> > >
> > > +/**
> > > + * ieee802154_xmit_error - frame transmission failed
> > > + *
> > > + * @hw: pointer as obtained from ieee802154_alloc_hw().
> > > + * @skb: buffer for transmission
> > > + * @ifs_handling: indicate interframe space handling
> > > + */
> > > +void ieee802154_xmit_error(struct ieee802154_hw *hw, struct sk_buff =
*skb,
> > > +                          bool ifs_handling);
> > > +
> > >  #endif /* NET_MAC802154_H */
> > > diff --git a/net/mac802154/util.c b/net/mac802154/util.c
> > > index 6f82418e9dec..9016f634efba 100644
> > > --- a/net/mac802154/util.c
> > > +++ b/net/mac802154/util.c
> > > @@ -102,6 +102,16 @@ void ieee802154_xmit_complete(struct ieee802154_=
hw *hw, struct sk_buff *skb,
> > >  }
> > >  EXPORT_SYMBOL(ieee802154_xmit_complete);
> > >
> > > +void ieee802154_xmit_error(struct ieee802154_hw *hw, struct sk_buff =
*skb,
> > > +                          bool ifs_handling)
> > > +{
> > > +       unsigned int skb_len =3D skb->len;
> > > +
> > > +       dev_kfree_skb_any(skb);
> > > +       ieee802154_xmit_end(hw, ifs_handling, skb_len);
> > > +} =20
> >
> > Remove ieee802154_xmit_end() function and just call to wake up the
> > queue here, also drop the "ifs_handling" parameter here. =20
>=20
> I am sorry, I think I should deliver an explanation here... I think
> the handling of success and error paths are just too different. In
> error there will also never ifs handling in the error path. Also
> please note there are not just errors as bus/transceiver errors, in
> future transceiver should also deliver [0] to the caller, in sync
> transmit it should return those errors to the caller... in async mode
> there exists different ways to deliver errors like (no ack) to user
> space by using socket error queue, here again is worth to look into
> wireless subsystem which have a similar feature.
>=20
> The errors in [0] are currently ignored but I think should be switched
> some time soon or with an additional patch by you to calling
> xmit_error with an int for $REASON. Those errors are happening on the
> transceiver because some functionality is offloaded. btw: so far I
> know some MLME-ops need to know if an ack is received or not.
>=20
> You can split the functionality somehow it makes sense, but with the
> above change I only see the wake up queue is the only thing that both
> (success/error) should have in common.

Very clear, thanks for the additional details. Indeed I would find much
better to be able to propagate the error reasons to upper layers. Even
though at this time we don't propagate them all the way up to userspace,
having them *at least* in the ieee core would be a nice feature. I'll
see what I can do.

>=20
> - Alex
>=20
> [0] https://elixir.bootlin.com/linux/v5.16-rc7/source/drivers/net/ieee802=
154/at86rf230.c#L670


Thanks,
Miqu=C3=A8l
