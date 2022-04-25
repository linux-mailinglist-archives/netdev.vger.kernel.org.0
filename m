Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDFC950E162
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 15:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235590AbiDYNUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 09:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240139AbiDYNTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 09:19:54 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3B519C09;
        Mon, 25 Apr 2022 06:16:49 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 4CE0D240009;
        Mon, 25 Apr 2022 13:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1650892607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yL+1WwuyV0gkc8EVoVMsP5ICunelXrVakkuddNSBziE=;
        b=WLJgKmD85wBFk0heoDC7n1i9OcmOBy4XU905wiUIg05eiVS9Yza+T+Fsans7FP+NfmOCdT
        ju5jxaX3pdN5/gclNIHOsqWKWLfFgGYsyai6T0r37iGaRRl6QAZu3Ej9OuNmH9j44OyqLo
        F0RMcY2HKiFUtCGyVw7ECKqV9EY9SiACAEvre5vWfQxcAsd9fGkakrzr9U78SKPsg2kK1c
        yYjCqoJf682IrhW2rutBL26mce9nPC3KjPaFemVnDmGjvBsdWj2t59C2L8UtkRO8dPnr6x
        elP6HcrOfYo0ouxpvDtIQAHbYUQb17CGyB4LiBzre9R1XmWcxZDtX3CnqUkllA==
Date:   Mon, 25 Apr 2022 15:16:44 +0200
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
Message-ID: <20220425151644.01dd47f4@xps13>
In-Reply-To: <CAB_54W4X4--=kmXW-xtV5WiawP0s0UWSCZWb4U8wOR-xhhgR9g@mail.gmail.com>
References: <20220406153441.1667375-1-miquel.raynal@bootlin.com>
        <20220406153441.1667375-10-miquel.raynal@bootlin.com>
        <CAB_54W4epiqcATJhLB9JDZPKGZTj_jbmVwDHRZT9MxtXY6g-QA@mail.gmail.com>
        <20220407100646.049467af@xps13>
        <CAB_54W5ovb9=rWB-H9oZygWuQpLSG58XFtgniNn9eDh51BBQNw@mail.gmail.com>
        <CAB_54W4X4--=kmXW-xtV5WiawP0s0UWSCZWb4U8wOR-xhhgR9g@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Mon, 25 Apr 2022 09:05:49 -0400:

> Hi,
>=20
> On Mon, Apr 25, 2022 at 8:35 AM Alexander Aring <alex.aring@gmail.com> wr=
ote:
> >
> > Hi,
> >
> > On Thu, Apr 7, 2022 at 4:06 AM Miquel Raynal <miquel.raynal@bootlin.com=
> wrote: =20
> > >
> > > Hi Alexander,
> > >
> > > alex.aring@gmail.com wrote on Wed, 6 Apr 2022 17:58:59 -0400:
> > > =20
> > > > Hi,
> > > >
> > > > On Wed, Apr 6, 2022 at 11:34 AM Miquel Raynal <miquel.raynal@bootli=
n.com> wrote: =20
> > > > >
> > > > > ieee802154_xmit_error() is the right helper to call when a transm=
ission
> > > > > has failed. Let's use it instead of open-coding it.
> > > > >
> > > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > > ---
> > > > >  drivers/net/ieee802154/atusb.c | 5 ++---
> > > > >  1 file changed, 2 insertions(+), 3 deletions(-)
> > > > >
> > > > > diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802=
154/atusb.c
> > > > > index f27a5f535808..d04db4d07a64 100644
> > > > > --- a/drivers/net/ieee802154/atusb.c
> > > > > +++ b/drivers/net/ieee802154/atusb.c
> > > > > @@ -271,9 +271,8 @@ static void atusb_tx_done(struct atusb *atusb=
, u8 seq)
> > > > >                  * unlikely case now that seq =3D=3D expect is th=
en true, but can
> > > > >                  * happen and fail with a tx_skb =3D NULL;
> > > > >                  */
> > > > > -               ieee802154_wake_queue(atusb->hw);
> > > > > -               if (atusb->tx_skb)
> > > > > -                       dev_kfree_skb_irq(atusb->tx_skb);
> > > > > +               ieee802154_xmit_error(atusb->hw, atusb->tx_skb,
> > > > > +                                     IEEE802154_SYSTEM_ERROR); =
=20
> > > >
> > > > That should then call the xmit_error for ANY other reason which is =
not
> > > > 802.15.4 specific which is the bus_error() function? =20
> > >
> > > I'll drop the bus error function so we can stick to a regular
> > > _xmit_error() call.
> > > =20
> >
> > Okay, this error is only hardware related.
> > =20
> > > Besides, we do not have any trac information nor any easy access to
> > > what failed exactly, so it's probably best anyway. =20
> >
> > This is correct, Somebody needs to write support for it for atusb firmw=
are. [0]
> > However some transceivers can't yet or will never (because lack of
> > functionality?) report such errors back... they will act a little bit
> > weird.
> >
> > However, this return value is a BIG step moving into the right
> > direction that other drivers can follow.
> >
> > I think for MLME ops we can definitely handle some transmit errors now
> > and retry so that we don't wait for anything when we know the
> > transceiver was never submitting.
> > =20
>=20
> s/submitting/transmitted/
>=20
> I could more deeper into that topic:
>=20
> 1.
>=20
> In my opinion this result value was especially necessary for MLME-ops,
> for others which do not directly work with MAC... they provide an
> upper layer protocol if they want something reliable.
>=20
> 2.
>=20
> Later on we can do statistics like what was already going around in
> the linux-wpan community to have something like whatever dump to see
> all neighbors and see how many ack failures there, etc. Some people
> want to make some predictions about link quality here. The kernel
> should therefore only capture some stats and the $WHATEVER userspace
> capable netlink monitor daemon should make some heuristic by dumping
> those stats.

I like the idea of having a per-device dump of the stats. It would be
really straightforward to implement with the current scan
implementation that I am about to share. We already have a per PAN
structure (with information like ID, channel, last time it was seen,
strength, etc). We might improve this structure with counters for all
the common mac errors. Maybe an option to the "pans dump" command
(again, in the pipe) might be a good start to get all the stats, like
"pans dump [stats]". I'll keep this in mind.

> 3.
>=20
> Sometimes even IP capable protocols (using 6LoWPAN) want to know if
> ack was received or not, as mentioned. But this required additional
> handling in the socket layers... I didn't look into that topic yet but
> I know wireless solved it because they have some similar problems.

I did not look at the upper layers yet, but that would indeed be a nice
use case of these MAC statuses.

Thanks,
Miqu=C3=A8l
