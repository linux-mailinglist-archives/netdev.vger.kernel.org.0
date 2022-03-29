Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFB94EB1E2
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 18:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239663AbiC2Qg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 12:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234114AbiC2Qg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 12:36:57 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5126C2F9;
        Tue, 29 Mar 2022 09:35:13 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8C60B100005;
        Tue, 29 Mar 2022 16:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1648571709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2Glt3hiry2Y4e5b04DNdY+DxUuuEZBfdyIRJmLzeL2g=;
        b=TL4ON2rvelmT7DUQLIlOSr6cD/0CfjJ++e+Uht9jP3Zmmug/fP8fW4fm2+bqfnZ9fmoLhR
        T3qQdy8u+xDG5I8VM3KXsuYOYr0xO7J+b3aGYwFmliJnSiYvHqbMkGTxHTHsZ0nhmyRHcp
        f3gF/q2hPnD1mL3NpriTnFxR1gqy9d41pV3ywVvd+t9jbEwr7sXI4AV299BxtczEXJMHQ8
        OxPsu7QHhMrjdGGXsEaYveetB0i9Wt3OAczl8LR+NtfEJHqak6QlrlueaogVVxcdllnXbU
        B9NsUmsYIcxQmH4Yjq2jwQgbS8sPCtuimbv5eBrZx7TF6032XanKz6SCXiIFTQ==
Date:   Tue, 29 Mar 2022 18:35:06 +0200
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
Message-ID: <20220329183506.513b93cb@xps13>
In-Reply-To: <CAB_54W5A1xmHO-YrWS3+RD0N_66mzkDpPYjosHU3vHgn1zmONg@mail.gmail.com>
References: <20220318185644.517164-1-miquel.raynal@bootlin.com>
        <20220318185644.517164-8-miquel.raynal@bootlin.com>
        <CAB_54W5A1xmHO-YrWS3+RD0N_66mzkDpPYjosHU3vHgn1zmONg@mail.gmail.com>
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

I think we definitely need to handle both, see below.

>=20
> > +       case TRAC_CHANNEL_ACCESS_FAILURE:
> > +               reason =3D IEEE802154_CHANNEL_ACCESS_FAILURE;
> > +               break;
> > +       case TRAC_NO_ACK:
> > +               reason =3D IEEE802154_NO_ACK;
> > +               break;
> > +       default:
> > +               reason =3D IEEE802154_SYSTEM_ERROR;
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
> handling, it is a bus error handling.

Both will have to be handled asynchronously, which means we have to
tell the soft mac layer that something bad happened in each case.

> As noted above. With this change
> you mix bus errors and trac errors (which are not bus errors).

In the case of a SPI error, it will happen asynchronously, which means
the tx call is over and something bad happened. We are aware that
something bad happened and there was a bus error. We need to:
- Free the skb
- Restart the internal machinery
- Somehow tell the soft mac layer something bad happened and the packet
  will not be transmitted as expected (IOW, balance the "end" calls
  with the "start" calls, just because we did not return immediately
  when we got the transmit request).

In the case of a transmission error, this is a trac condition that is
reported to us by an IRQ. We know it is a trac error, we can look at a
buffer to find which trac error exactly happened. In this case we need
to go through exactly the same steps as above.

But you are right that a spi_async() error is not a trac error, hence
my choice in the switch statement to default to the
IEEE80154_SYSTEM_ERROR flag in this case.

Should I ignore spi bus errors? I don't think I can, so I don't really
see how to handle it differently.

Thanks,
Miqu=C3=A8l
