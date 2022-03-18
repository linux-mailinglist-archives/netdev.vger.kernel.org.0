Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFEE4DD5A9
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 08:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbiCRH7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 03:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbiCRH7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 03:59:16 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E856F2BB348;
        Fri, 18 Mar 2022 00:57:56 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 206A5C0007;
        Fri, 18 Mar 2022 07:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1647590273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EAlUHGnTP1tK2XZ6IOyGWb0YEmSTsipzNBrDkpQYzNw=;
        b=kaF+sX1f7x2Ipg9a2qEOydu1W05urWZqaMkYG3ofzk+dAHdg84UoS4rlR4lSCKfYPaIDNl
        i6Lef3E0/C5f9uV3veUVDwnUboUf6mNXByceFyqZZ4nlX4sjeEoUMAJN3LJuHLRRUxpYri
        H8JTy2IQf+VajX2NyxrHPnxuMLa55g866WXlhRWZXu3IAoG7hqzCLioIfVJNYK/drCiirK
        0j8LsRAbBylRm4i+LIEeQedA62y2cs+E5XMIwNBpXLluwHzYBKbvbSmfuz0hUrHvjIkgq+
        tf6wQPccsBNwl536dSHHyiXmqLx5EchAiJnn73HL4PN2T/zDZkR9F4rmZidyPw==
Date:   Fri, 18 Mar 2022 08:57:49 +0100
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
Subject: Re: [PATCH wpan-next v3 09/11] net: ieee802154: atusb: Call
 _xmit_error() when a transmission fails
Message-ID: <20220318085749.322f2f85@xps13>
In-Reply-To: <CAB_54W5Fr-1d7O4L4s4A=-TWiP9X06C9u9gC8pKM7TE9B+6shQ@mail.gmail.com>
References: <20220303182508.288136-1-miquel.raynal@bootlin.com>
        <20220303182508.288136-10-miquel.raynal@bootlin.com>
        <CAB_54W5Fr-1d7O4L4s4A=-TWiP9X06C9u9gC8pKM7TE9B+6shQ@mail.gmail.com>
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

alex.aring@gmail.com wrote on Sun, 13 Mar 2022 16:20:53 -0400:

> Hi,
>=20
> On Thu, Mar 3, 2022 at 1:25 PM Miquel Raynal <miquel.raynal@bootlin.com> =
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
> > index f27a5f535808..9fa7febddff2 100644
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
> > +                                     IEEE802154_MAC_ERROR); =20
>=20
> I think we should have a consens what kind of 802.15.4 error we
> deliver in such a case. This is more some kind of bus/device error not
> related to a 802.15.4 operation, and in this case we should use the
> SYSTEM_ERROR which 802.15.4 says it can be used for a kind of "user
> specific error"? I mean it is not user specific but 802.15.4 spec will
> never reference it to make some special handling if it occurs... just
> "something failed".

Sure, I initially thought "MAC_ERROR" was generic enough, but you're
certainly right, it's probably best to switch to SYSTEM_ERROR in this
case.

Thanks,
Miqu=C3=A8l
