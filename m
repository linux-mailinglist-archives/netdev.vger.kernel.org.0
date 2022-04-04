Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6294F1506
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 14:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347156AbiDDMmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 08:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346057AbiDDMmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 08:42:39 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9472E689;
        Mon,  4 Apr 2022 05:40:42 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 6778F6000F;
        Mon,  4 Apr 2022 12:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649076041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pluALRTX+3BTYVs1g0iwHll8/F19OBnKsFlKgubvcKE=;
        b=hSsRw+QB0r4Uq9KRCsMDiHnoD/GuH/N9WOGNzPO8Ktvd4CZxAoX2lVrhXeEDxZm549pjEX
        eWoqWXnvwk/V1XBVVzix1fqQmooVljEVbXuCnVEh/xKmHKE2sAeWpo8uO7OW47Grclnx9U
        OInoi/xOJoKc4w0UJPE5R6z9Gpkef6PpiP6t8AWDM00sP7dGkg6rO7/JMA7VzWzeCPWUiB
        48OzVgzgsca1aXywVeviac7FIzsupzvcmQmezC5uM++K6SQbI5FRrcnLrpp/0r73pafr96
        X9jFM+y9ci/gyrcdQ62T80xiGSEeBSH/qF1Bc/7MUSgbjVzQhJmD6T3napMiqQ==
Date:   Mon, 4 Apr 2022 14:40:38 +0200
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
Message-ID: <20220404144038.050ffc2b@xps13>
In-Reply-To: <20220329183506.513b93cb@xps13>
References: <20220318185644.517164-1-miquel.raynal@bootlin.com>
        <20220318185644.517164-8-miquel.raynal@bootlin.com>
        <CAB_54W5A1xmHO-YrWS3+RD0N_66mzkDpPYjosHU3vHgn1zmONg@mail.gmail.com>
        <20220329183506.513b93cb@xps13>
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

Hello,

miquel.raynal@bootlin.com wrote on Tue, 29 Mar 2022 18:35:06 +0200:

> Hi Alexander,
>=20
> alex.aring@gmail.com wrote on Sun, 27 Mar 2022 11:46:12 -0400:
>=20
> > Hi,
> >=20
> > On Fri, Mar 18, 2022 at 2:56 PM Miquel Raynal <miquel.raynal@bootlin.co=
m> wrote: =20
> > >
> > > Either the spi operation failed, or the offloaded transmit operation
> > > failed and returned a TRAC value. Use this value when available or use
> > > the default "SYSTEM_ERROR" otherwise, in order to propagate one step
> > > above the error.
> > >
> > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > ---
> > >  drivers/net/ieee802154/at86rf230.c | 25 +++++++++++++++++++++++--
> > >  1 file changed, 23 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802=
154/at86rf230.c
> > > index d3cf6d23b57e..34d199f597c9 100644
> > > --- a/drivers/net/ieee802154/at86rf230.c
> > > +++ b/drivers/net/ieee802154/at86rf230.c
> > > @@ -358,7 +358,23 @@ static inline void
> > >  at86rf230_async_error(struct at86rf230_local *lp,
> > >                       struct at86rf230_state_change *ctx, int rc)
> > >  {
> > > -       dev_err(&lp->spi->dev, "spi_async error %d\n", rc);
> > > +       int reason;
> > > +
> > > +       switch (rc) {   =20
> >=20
> > I think there was a miscommunication last time, this rc variable is
> > not a trac register value, it is a linux errno. Also the error here
> > has nothing to do with a trac error. A trac error is the result of the
> > offloaded transmit functionality on the transceiver, here we dealing
> > about bus communication errors produced by the spi subsystem. What we
> > need is to report it to the softmac layer as "IEEE802154_SYSTEM_ERROR"
> > (as we decided that this is a user specific error and can be returned
> > by the transceiver for non 802.15.4 "error" return code. =20
>=20
> I think we definitely need to handle both, see below.
>=20
> >  =20
> > > +       case TRAC_CHANNEL_ACCESS_FAILURE:
> > > +               reason =3D IEEE802154_CHANNEL_ACCESS_FAILURE;
> > > +               break;
> > > +       case TRAC_NO_ACK:
> > > +               reason =3D IEEE802154_NO_ACK;
> > > +               break;
> > > +       default:
> > > +               reason =3D IEEE802154_SYSTEM_ERROR;
> > > +       }
> > > +
> > > +       if (rc < 0)
> > > +               dev_err(&lp->spi->dev, "spi_async error %d\n", rc);
> > > +       else
> > > +               dev_err(&lp->spi->dev, "xceiver error %d\n", reason);
> > >
> > >         at86rf230_async_state_change(lp, ctx, STATE_FORCE_TRX_OFF,
> > >                                      at86rf230_async_error_recover);
> > > @@ -666,10 +682,15 @@ at86rf230_tx_trac_check(void *context)
> > >         case TRAC_SUCCESS:
> > >         case TRAC_SUCCESS_DATA_PENDING:
> > >                 at86rf230_async_state_change(lp, ctx, STATE_TX_ON, at=
86rf230_tx_on);
> > > +               return;
> > > +       case TRAC_CHANNEL_ACCESS_FAILURE:
> > > +       case TRAC_NO_ACK:
> > >                 break;
> > >         default:
> > > -               at86rf230_async_error(lp, ctx, -EIO);
> > > +               trac =3D TRAC_INVALID;
> > >         }
> > > +
> > > +       at86rf230_async_error(lp, ctx, trac);   =20
> >=20
> > That makes no sense, at86rf230_async_error() is not a trac error
> > handling, it is a bus error handling. =20
>=20
> Both will have to be handled asynchronously, which means we have to
> tell the soft mac layer that something bad happened in each case.
>=20
> > As noted above. With this change
> > you mix bus errors and trac errors (which are not bus errors). =20
>=20
> In the case of a SPI error, it will happen asynchronously, which means
> the tx call is over and something bad happened. We are aware that
> something bad happened and there was a bus error. We need to:
> - Free the skb
> - Restart the internal machinery
> - Somehow tell the soft mac layer something bad happened and the packet
>   will not be transmitted as expected (IOW, balance the "end" calls
>   with the "start" calls, just because we did not return immediately
>   when we got the transmit request).
>=20
> In the case of a transmission error, this is a trac condition that is
> reported to us by an IRQ. We know it is a trac error, we can look at a
> buffer to find which trac error exactly happened. In this case we need
> to go through exactly the same steps as above.
>=20
> But you are right that a spi_async() error is not a trac error, hence
> my choice in the switch statement to default to the
> IEEE80154_SYSTEM_ERROR flag in this case.
>=20
> Should I ignore spi bus errors? I don't think I can, so I don't really
> see how to handle it differently.

Sorry to bother you again, but in the end, do you agree on returning
IEEE802154_SYSTEM_ERROR upon asynchronous bus errors?

Any other modification of the driver in favor of having two distinct
paths would be really costly in term of time spent and probability of
breaking something, so I would rather avoid it, unless I am missing
something simpler?

Cheers,
Miqu=C3=A8l
