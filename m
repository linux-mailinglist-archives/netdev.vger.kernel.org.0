Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9B44F791F
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 10:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233871AbiDGIJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 04:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243183AbiDGIIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 04:08:53 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB909FE9;
        Thu,  7 Apr 2022 01:06:50 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 90974E0009;
        Thu,  7 Apr 2022 08:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649318809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PPoXp+o85lJaUNDTEzKGLQjgDZZbZUu76+1guehyhFE=;
        b=fStcAjKUpKw0jCJPTgJ4Q5603NdigBu4RWofl8+UBMJX+kw43SQP0vhXODW3UQx8hiqOzd
        tcxCcEexU8MQL+c9/YOaahnUdMr8Y9MJKX8GcyrJb2uXeHhtSZCl9f5qqrEuYc41jNVpPH
        IycYQbhnuLD4zlGr0Cac5poaUJlUFrVJUIsJ/XkZOYQLWzFT1dMYudxNZZ6pzSiKNHLiz9
        tpeuFuEiRWTLzBXapSOWl/jqdXJcp+oNFIXU3tZvT7njj9XNVqDcbilPdcqsY5TL2Ciujx
        lwYxyYV6nNSgqZqrhrzz8tiRLYU1Sn9IC293ttCFMtkbpGg5b/ANr1fZ00Fu7A==
Date:   Thu, 7 Apr 2022 10:06:46 +0200
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
Subject: Re: [PATCH v5 09/11] net: ieee802154: atusb: Call _xmit_error()
 when a transmission fails
Message-ID: <20220407100646.049467af@xps13>
In-Reply-To: <CAB_54W4epiqcATJhLB9JDZPKGZTj_jbmVwDHRZT9MxtXY6g-QA@mail.gmail.com>
References: <20220406153441.1667375-1-miquel.raynal@bootlin.com>
        <20220406153441.1667375-10-miquel.raynal@bootlin.com>
        <CAB_54W4epiqcATJhLB9JDZPKGZTj_jbmVwDHRZT9MxtXY6g-QA@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Wed, 6 Apr 2022 17:58:59 -0400:

> Hi,
>=20
> On Wed, Apr 6, 2022 at 11:34 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > ieee802154_xmit_error() is the right helper to call when a transmission
> > has failed. Let's use it instead of open-coding it.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  drivers/net/ieee802154/atusb.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/at=
usb.c
> > index f27a5f535808..d04db4d07a64 100644
> > --- a/drivers/net/ieee802154/atusb.c
> > +++ b/drivers/net/ieee802154/atusb.c
> > @@ -271,9 +271,8 @@ static void atusb_tx_done(struct atusb *atusb, u8 s=
eq)
> >                  * unlikely case now that seq =3D=3D expect is then tru=
e, but can
> >                  * happen and fail with a tx_skb =3D NULL;
> >                  */
> > -               ieee802154_wake_queue(atusb->hw);
> > -               if (atusb->tx_skb)
> > -                       dev_kfree_skb_irq(atusb->tx_skb);
> > +               ieee802154_xmit_error(atusb->hw, atusb->tx_skb,
> > +                                     IEEE802154_SYSTEM_ERROR); =20
>=20
> That should then call the xmit_error for ANY other reason which is not
> 802.15.4 specific which is the bus_error() function?

I'll drop the bus error function so we can stick to a regular
_xmit_error() call.

Besides, we do not have any trac information nor any easy access to
what failed exactly, so it's probably best anyway.

Thanks,
Miqu=C3=A8l
