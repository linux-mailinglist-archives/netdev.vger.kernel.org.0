Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6755F4DD5A1
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 08:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233391AbiCRH5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 03:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbiCRH5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 03:57:45 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63EA195332;
        Fri, 18 Mar 2022 00:56:26 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id C9CDB60007;
        Fri, 18 Mar 2022 07:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1647590184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4NwkkStdNu11mn5gK4D0mxHvWj3GhZdPgKFTgeu/D90=;
        b=lnYPYaZJX2a1V9Qg+8zCUcB9aWx7eVkLA8tbp353yVIQ8DWEsH+hXwpjzmDOMEI/oRg8sS
        3+q3NYZ1TLRc6+4ltlkMOO+L/jxU5hypHhtP8A9/48HxupAdbOSp++CbNinYjvqbOewyPM
        fTyQggGdRu5cGfoX+YENJHVcpNrZDEGJzH8GMw9mI71V0e/1r0M2vBmvohs6KS9dktcLrQ
        seJZiUDF4VWOgM9ibJZckCtpNw34xRh7mMoGtzQvQfzbE9m2BCkUbCiK6/KIxTAASl//9F
        1PKoie1jr1sKUcHpUkWVVJwLQtaDNtCgR/2vgvFPddJ3lCotTH/8IUYGcZbl7A==
Date:   Fri, 18 Mar 2022 08:56:21 +0100
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
Subject: Re: [PATCH wpan-next v3 07/11] net: ieee802154: at86rf230: Provide
 meaningful error codes when possible
Message-ID: <20220318085621.2de9730b@xps13>
In-Reply-To: <CAB_54W5f87H2umyRsjAZ--x_BiN8D7taG4BnyEXx1EWQyQSyBA@mail.gmail.com>
References: <20220303182508.288136-1-miquel.raynal@bootlin.com>
        <20220303182508.288136-8-miquel.raynal@bootlin.com>
        <CAB_54W5f87H2umyRsjAZ--x_BiN8D7taG4BnyEXx1EWQyQSyBA@mail.gmail.com>
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

alex.aring@gmail.com wrote on Sun, 13 Mar 2022 16:16:45 -0400:

> Hi,
>=20
> On Thu, Mar 3, 2022 at 1:25 PM Miquel Raynal <miquel.raynal@bootlin.com> =
wrote:
> >
> > Either the spi operation failed, or the device encountered an error. In
> > both case, we know more or less what happened thanks to the spi call
> > return code or the content of the TRAC register otherwise. Use them in
> > order to propagate one step above the error.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  drivers/net/ieee802154/at86rf230.c | 25 +++++++++++++++++++++++--
> >  1 file changed, 23 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee80215=
4/at86rf230.c
> > index 12ee071057d2..5f19266b3045 100644
> > --- a/drivers/net/ieee802154/at86rf230.c
> > +++ b/drivers/net/ieee802154/at86rf230.c
> > @@ -370,7 +370,27 @@ static inline void
> >  at86rf230_async_error(struct at86rf230_local *lp,
> >                       struct at86rf230_state_change *ctx, int rc)
> >  {
> > -       dev_err(&lp->spi->dev, "spi_async error %d\n", rc);
> > +       int reason;
> > +
> > +       switch (rc) {
> > +       case TRAC_CHANNEL_ACCESS_FAILURE:
> > +               reason =3D IEEE802154_CHANNEL_ACCESS_FAILURE;
> > +               break;
> > +       case TRAC_NO_ACK:
> > +               reason =3D IEEE802154_NO_ACK;
> > +               break;
> > +       case TRAC_INVALID:
> > +               reason =3D IEEE802154_SYSTEM_ERROR;
> > +               break;
> > +       default:
> > +               reason =3D rc;
> > +       }
> > + =20
>=20
> Actually the rc value here is not a TRAC status register value... and
> it should not be one.
>=20
> The reason is because this function can also be called during a non-tx
> state change failure whereas the trac register is only valid when the
> transmission "is successfully offloaded to device" and delivers us an
> error of the transmission operation on the device. It is called during
> the tx case only if there was a "state transition error" and then it
> should report IEEE802154_SYSTEM_ERROR in
> at86rf230_async_error_recover_complete(). Whereas I think we can use
> IEEE802154_SYSTEM_ERROR as a non-specific 802.15.4 error code, because
> a bus error of a state transition is not 802.15.4 specific.

Ok I'm totally fine using SYSTEM_ERROR as a generic placeholder in
these cases.

Thanks,
Miqu=C3=A8l
