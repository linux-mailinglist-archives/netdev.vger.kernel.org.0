Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D0F6A565B
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 11:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjB1KJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 05:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbjB1KJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 05:09:01 -0500
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468ADDBE9;
        Tue, 28 Feb 2023 02:08:59 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 995DDE0012;
        Tue, 28 Feb 2023 10:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1677578936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jq4CAXPaGT61q79hErbl8neygvo74vy/GTvXxBzgk0M=;
        b=AagRiIkT4yCz23Fmei/+B6P2olcbQsBHRShBT7XQURRcDvmWYeUCUAtoPXybuWQxHH7EDh
        k4UAyk71Pbt+ie2glYtvJ34GsOTcv7KzTAK2/97msIkohLfWzheJIxOIDs2Qi3CDVJecex
        duc/fPZNf5KkpRBUqNfqWnra2QuPLUQgMUyb9bK2sjZe3tCrtWUkUEj5Tzu59TigZdr6ox
        HgTK8jd0vXiuTUoW1HK05M4MlUC7ic4gGeLqOkxmzTzcmVuUvYQPNwomOHQiR4/4lW3oXf
        v97mtCq+Ewvy+e7Ba8KSq+fO3ANv2aw1/YEfRHwpc6Q4U80RuRRundKsJ46q4w==
Date:   Tue, 28 Feb 2023 11:08:53 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan v2 2/6] ieee802154: Convert scan error messages to
 extack
Message-ID: <20230228110853.28e0cc1b@xps-13>
In-Reply-To: <CANn89iLGLcQKYCTi7Vu3fm7n6v3mgeedeG4sE0MR2WG-dOWsXw@mail.gmail.com>
References: <20230214135035.1202471-1-miquel.raynal@bootlin.com>
        <20230214135035.1202471-3-miquel.raynal@bootlin.com>
        <CANn89iLGLcQKYCTi7Vu3fm7n6v3mgeedeG4sE0MR2WG-dOWsXw@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
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

Hi Eric,

edumazet@google.com wrote on Mon, 27 Feb 2023 21:41:51 +0100:

> On Tue, Feb 14, 2023 at 2:50=E2=80=AFPM Miquel Raynal <miquel.raynal@boot=
lin.com> wrote:
> >
> > Instead of printing error messages in the kernel log, let's use extack.
> > When there is a netlink error returned that could be further specified
> > with a string, use extack as well.
> >
> > Apply this logic to the very recent scan/beacon infrastructure.
> >
> > Fixes: ed3557c947e1 ("ieee802154: Add support for user scanning request=
s")
> > Fixes: 9bc114504b07 ("ieee802154: Add support for user beaconing reques=
ts")
> > Suggested-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  net/ieee802154/nl802154.c | 19 +++++++++++++------
> >  1 file changed, 13 insertions(+), 6 deletions(-)
> >
> > diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
> > index 64fa811e1f0b..d3b6e9e80941 100644
> > --- a/net/ieee802154/nl802154.c
> > +++ b/net/ieee802154/nl802154.c
> > @@ -1407,9 +1407,15 @@ static int nl802154_trigger_scan(struct sk_buff =
*skb, struct genl_info *info)
> >         u8 type;
> >         int err;
> >
> > -       /* Monitors are not allowed to perform scans */
> > -       if (wpan_dev->iftype =3D=3D NL802154_IFTYPE_MONITOR)
> > +       if (wpan_dev->iftype =3D=3D NL802154_IFTYPE_MONITOR) {
> > +               NL_SET_ERR_MSG(info->extack, "Monitors are not allowed =
to perform scans");
> >                 return -EPERM;
> > +       }
> > +
> > +       if (!nla_get_u8(info->attrs[NL802154_ATTR_SCAN_TYPE])) {
>=20
> syzbot crashes hosts by _not_ adding NL802154_ATTR_SCAN_TYPE attribute.

I was looking at Sanan Hasanov's e-mail, I believe this is the same
breakage that is being reported?
Link: https://lore.kernel.org/netdev/IA1PR07MB98302CDCC21F6BA664FB7298ABAF9=
@IA1PR07MB9830.namprd07.prod.outlook.com/

> Did you mean to write :
>=20
> diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
> index 2215f576ee3788f74ea175b046d05d285bac752d..d8f4379d4fa68b5b07bb2c45c=
d74d4b73213c107
> 100644
> --- a/net/ieee802154/nl802154.c
> +++ b/net/ieee802154/nl802154.c
> @@ -1412,7 +1412,7 @@ static int nl802154_trigger_scan(struct sk_buff
> *skb, struct genl_info *info)
>                 return -EOPNOTSUPP;
>         }
>=20
> -       if (!nla_get_u8(info->attrs[NL802154_ATTR_SCAN_TYPE])) {
> +       if (!info->attrs[NL802154_ATTR_SCAN_TYPE]) {

That is absolutely what I intended to do, I will send a fix immediately.

>                 NL_SET_ERR_MSG(info->extack, "Malformed request,
> missing scan type");
>                 return -EINVAL;
>         }
>=20

Thanks a lot,
Miqu=C3=A8l
