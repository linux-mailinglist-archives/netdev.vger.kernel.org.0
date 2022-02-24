Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709314C2E9E
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 15:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235569AbiBXOoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 09:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiBXOoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 09:44:22 -0500
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDA016DAD6;
        Thu, 24 Feb 2022 06:43:51 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 1DA5CFF804;
        Thu, 24 Feb 2022 14:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645713828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YZughI9ZeCv/vnyB36tBYBZ/3P9vg7OprA1EeVei8so=;
        b=YJRWtlAr++51AJ9d3bR/QEamMDbjHujQBOPkB1FdZljOmQh67HafE/vHarNipYh1vs5DeY
        1sIFouOTyo/FCpMZBak4f0so4nS5YgQEcVTDpKcYttWTN0e+iNwy7SW2TpkJ4SzOxxPjvc
        YApjLc+B5TB9hwtfGwFG3UT6/B+2UgXo3o4ohocDQO7WIxl0gKIoPTHdtvnMsGvTDKodJ4
        1JsEHMw5GY7hyr0OBc1gvtGvOjGYiJcWBfk8QgXILTxspdZX2z2D23BbgDXlFynULUvPd+
        Iy6OKec9aBvviWv91gJWELSoer+xOTwM66aw5uedrY5YZa58dSrMy3QfP4n6Yw==
Date:   Thu, 24 Feb 2022 15:43:46 +0100
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
Subject: Re: [PATCH wpan-next v2 04/14] net: ieee802154: atusb: Call
 _xmit_error() when a transmission fails
Message-ID: <20220224154346.210ac89b@xps13>
In-Reply-To: <CAB_54W6Rs1tkzkOvgQuMKNtFrWY+OZjhUZ-t2qh9QdmZOHAsvw@mail.gmail.com>
References: <20220207144804.708118-1-miquel.raynal@bootlin.com>
        <20220207144804.708118-5-miquel.raynal@bootlin.com>
        <CAB_54W5X+zN1YvN9SL32NVFCbqFbiR2GE-r132SXkpMKN21FhQ@mail.gmail.com>
        <CAB_54W6Rs1tkzkOvgQuMKNtFrWY+OZjhUZ-t2qh9QdmZOHAsvw@mail.gmail.com>
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

alex.aring@gmail.com wrote on Wed, 23 Feb 2022 21:00:23 -0500:

> Hi,
>=20
> On Sun, Feb 20, 2022 at 6:35 PM Alexander Aring <alex.aring@gmail.com> wr=
ote:
> >
> > Hi,
> >
> > On Mon, Feb 7, 2022 at 9:48 AM Miquel Raynal <miquel.raynal@bootlin.com=
> wrote: =20
> > >
> > > ieee802154_xmit_error() is the right helper to call when a transmissi=
on
> > > has failed. Let's use it instead of open-coding it.
> > >
> > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > ---
> > >  drivers/net/ieee802154/atusb.c | 4 +---
> > >  1 file changed, 1 insertion(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/=
atusb.c
> > > index f27a5f535808..0e6f180b4e79 100644
> > > --- a/drivers/net/ieee802154/atusb.c
> > > +++ b/drivers/net/ieee802154/atusb.c
> > > @@ -271,9 +271,7 @@ static void atusb_tx_done(struct atusb *atusb, u8=
 seq)
> > >                  * unlikely case now that seq =3D=3D expect is then t=
rue, but can
> > >                  * happen and fail with a tx_skb =3D NULL;
> > >                  */
> > > -               ieee802154_wake_queue(atusb->hw);
> > > -               if (atusb->tx_skb)
> > > -                       dev_kfree_skb_irq(atusb->tx_skb);
> > > +               ieee802154_xmit_error(atusb->hw, atusb->tx_skb, false=
);
> > > =20
> > Are you sure you can easily convert this? You should introduce a
> > "ieee802154_xmit_error_irq()"? =20
>=20
> Should be fine as you are using dev_kfree_skb_any().

Haha, you answer my questions before I even take the time to write them
down :-)

Yes I agree, because of dev_kfree_skb_any(), my understanding is that
we do not need an _irq specific error handler.

Thanks,
Miqu=C3=A8l
