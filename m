Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48AA64E9C3A
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 18:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239191AbiC1QaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 12:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237909AbiC1QaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 12:30:22 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DCC252B4;
        Mon, 28 Mar 2022 09:28:40 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id C440120002;
        Mon, 28 Mar 2022 16:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1648484918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I9mphLePkyzcwWDEKfwyuK7DKAmWX/IQH0d4nKJH7Jc=;
        b=c9KYBvr0N0fJscZkPK4gP1ShzZxXWmHnHCEwLXObLj4VjZahBEqVqMiEXef/SQnx1N3RzS
        B+JO8aMrSHYjPAYTnBpjod5mpHC5fME0h0GSRAX2R6CBbFIGuX3DTBcTtfRhtOt/1UalGZ
        YSI8LmIzkoZXgu63wDMpgiTIkqy+j5lIXGniZde4RvgSes2UedEDLkWx2R/FdqMfBb1w4g
        68lwDmDhfYvlKG+uhGX7ehhs9NSGi2f02xEePjTu83xMNLUhJeUOk7lJjdduMg29Zv0m1+
        bljE9+wRipTU3xYLn3cLGHd3jPrGJkfm66nH6Hq/qTpMbftS2SlMrAaTaX3ckA==
Date:   Mon, 28 Mar 2022 18:28:35 +0200
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
Subject: Re: [PATCH wpan-next v4 07/11] net: ieee802154: at86rf230: Provide
 meaningful error codes when possible
Message-ID: <20220328182835.3e3e1030@xps13>
In-Reply-To: <CAB_54W5A1xmHO-YrWS3+RD0N_66mzkDpPYjosHU3vHgn1zmONg@mail.gmail.com>
References: <20220318185644.517164-1-miquel.raynal@bootlin.com>
        <20220318185644.517164-8-miquel.raynal@bootlin.com>
        <CAB_54W5A1xmHO-YrWS3+RD0N_66mzkDpPYjosHU3vHgn1zmONg@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,LOTS_OF_MONEY,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Sun, 27 Mar 2022 11:46:12 -0400:

> Hi,
>=20
> On Fri, Mar 18, 2022 at 2:56 PM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Either the spi operation failed, or the offloaded transmit operation
> > failed and returned a TRAC value. Use this value when available or use
> > the default "SYSTEM_ERROR" otherwise, in order to propagate one step
> > above the error.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  drivers/net/ieee802154/at86rf230.c | 25 +++++++++++++++++++++++--
> >  1 file changed, 23 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee80215=
4/at86rf230.c
> > index d3cf6d23b57e..34d199f597c9 100644
> > --- a/drivers/net/ieee802154/at86rf230.c
> > +++ b/drivers/net/ieee802154/at86rf230.c
> > @@ -358,7 +358,23 @@ static inline void
> >  at86rf230_async_error(struct at86rf230_local *lp,
> >                       struct at86rf230_state_change *ctx, int rc)
> >  {
> > -       dev_err(&lp->spi->dev, "spi_async error %d\n", rc);
> > +       int reason;
> > +
> > +       switch (rc) { =20
>=20
> I think there was a miscommunication last time, this rc variable is
> not a trac register value, it is a linux errno. Also the error here
> has nothing to do with a trac error. A trac error is the result of the
> offloaded transmit functionality on the transceiver, here we dealing
> about bus communication errors produced by the spi subsystem. What we
> need is to report it to the softmac layer as "IEEE802154_SYSTEM_ERROR"
> (as we decided that this is a user specific error and can be returned
> by the transceiver for non 802.15.4 "error" return code.
>=20
> > +       case TRAC_CHANNEL_ACCESS_FAILURE:
> > +               reason =3D IEEE802154_CHANNEL_ACCESS_FAILURE;
> > +               break;
> > +       case TRAC_NO_ACK:
> > +               reason =3D IEEE802154_NO_ACK;
> > +               break;
> > +       default:
> > +               reason =3D IEEE802154_SYSTEM_ERROR;

I went for the solution: if it is a bus error, I return SYSTEM ERROR,
otherwise I return a trac error.

> > +       }
> > +
> > +       if (rc < 0)
> > +               dev_err(&lp->spi->dev, "spi_async error %d\n", rc);
> > +       else
> > +               dev_err(&lp->spi->dev, "xceiver error %d\n", reason);
> >
> >         at86rf230_async_state_change(lp, ctx, STATE_FORCE_TRX_OFF,
> >                                      at86rf230_async_error_recover);
> > @@ -666,10 +682,15 @@ at86rf230_tx_trac_check(void *context)
> >         case TRAC_SUCCESS:
> >         case TRAC_SUCCESS_DATA_PENDING:
> >                 at86rf230_async_state_change(lp, ctx, STATE_TX_ON, at86=
rf230_tx_on);
> > +               return;
> > +       case TRAC_CHANNEL_ACCESS_FAILURE:
> > +       case TRAC_NO_ACK:
> >                 break;
> >         default:
> > -               at86rf230_async_error(lp, ctx, -EIO);
> > +               trac =3D TRAC_INVALID;
> >         }
> > +
> > +       at86rf230_async_error(lp, ctx, trac); =20
>=20
> That makes no sense, at86rf230_async_error() is not a trac error
> handling, it is a bus error handling. As noted above. With this change
> you mix bus errors and trac errors (which are not bus errors). If
> there are no bus errors then trac should be evaluated and should
> either deliver some 802.15.4 $SUCCESS_CODE or $ERROR_CODE to the
> softmac stack, which is xmit_complete() or xmit_error().

There is no specific path for bus errors, everything is supposedly
asynchronous and all the function return void. In both cases I need to
free the skb. So I am questioning myself about the right solution (need
to think further...)

Thanks,
Miqu=C3=A8l
