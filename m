Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAC259A3C3
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352031AbiHSRq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 13:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352024AbiHSRqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 13:46:24 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DBB110DCDE;
        Fri, 19 Aug 2022 10:11:18 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 349711C0008;
        Fri, 19 Aug 2022 17:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1660929073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HNkhd3kPX+ZKn7GTp9qxjZ60OKpKd8YDywyTcmUMzEk=;
        b=kpZQkVYLx4gQlWzozESnKJ6fvxYObQUrbJ5Gue4hdgfuYZO3w4Xkv3/K2W3rcm8ORRgibZ
        ZI6Vt7UimdgnWySVZP6jyqbDSV95zHN6uK86hs9X9jMXu5x4yS/4fBJJXXwppOt+tAQBgq
        muyYPcSBN2JPKYhgsVt0XNbeaiid0UfNQ99aYljt/KfxjomOh3poo6iTy6nUaUdbDgb5r8
        AdeAivoc3it1kRqdfYulC/ZHk27gsW8gVlDpStABZAkiHVPpbkE0NoDoPPRZZqcHQUecZ1
        l+ztIBewB6YCZ0umD2So37MZOo+YOUg7LNqY/ieIx3I8KnDDzp9Dcevs4Hw3ZA==
Date:   Fri, 19 Aug 2022 19:11:09 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next 01/20] net: mac802154: Allow the creation of
 coordinator interfaces
Message-ID: <20220819191109.0e639918@xps-13>
In-Reply-To: <CAK-6q+jkUUjAGqEDgU1oJvRkigUbvSO5SXWRau6+320b=GbfxQ@mail.gmail.com>
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
        <20220701143052.1267509-2-miquel.raynal@bootlin.com>
        <CAK-6q+jkUUjAGqEDgU1oJvRkigUbvSO5SXWRau6+320b=GbfxQ@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
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

aahringo@redhat.com wrote on Tue, 5 Jul 2022 21:51:02 -0400:

> Hi,
>=20
> On Fri, Jul 1, 2022 at 10:36 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > As a first strep in introducing proper PAN management and association,
> > we need to be able to create coordinator interfaces which might act as
> > coordinator or PAN coordinator.
> >
> > Hence, let's add the minimum support to allow the creation of these
> > interfaces. This might be restrained and improved later.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  net/mac802154/iface.c | 14 ++++++++------
> >  net/mac802154/rx.c    |  2 +-
> >  2 files changed, 9 insertions(+), 7 deletions(-)
> >
> > diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
> > index 500ed1b81250..7ac0c5685d3f 100644
> > --- a/net/mac802154/iface.c
> > +++ b/net/mac802154/iface.c
> > @@ -273,13 +273,13 @@ ieee802154_check_concurrent_iface(struct ieee8021=
54_sub_if_data *sdata,
> >                 if (nsdata !=3D sdata && ieee802154_sdata_running(nsdat=
a)) {
> >                         int ret;
> >
> > -                       /* TODO currently we don't support multiple nod=
e types
> > -                        * we need to run skb_clone at rx path. Check i=
f there
> > -                        * exist really an use case if we need to suppo=
rt
> > -                        * multiple node types at the same time.
> > +                       /* TODO currently we don't support multiple nod=
e/coord
> > +                        * types we need to run skb_clone at rx path. C=
heck if
> > +                        * there exist really an use case if we need to=
 support
> > +                        * multiple node/coord types at the same time.
> >                          */
> > -                       if (wpan_dev->iftype =3D=3D NL802154_IFTYPE_NOD=
E &&
> > -                           nsdata->wpan_dev.iftype =3D=3D NL802154_IFT=
YPE_NODE)
> > +                       if (wpan_dev->iftype !=3D NL802154_IFTYPE_MONIT=
OR &&
> > +                           nsdata->wpan_dev.iftype !=3D NL802154_IFTYP=
E_MONITOR)
> >                                 return -EBUSY;
> >
> >                         /* check all phy mac sublayer settings are the =
same.
> > @@ -577,6 +577,7 @@ ieee802154_setup_sdata(struct ieee802154_sub_if_dat=
a *sdata,
> >         wpan_dev->short_addr =3D cpu_to_le16(IEEE802154_ADDR_BROADCAST);
> >
> >         switch (type) {
> > +       case NL802154_IFTYPE_COORD:
> >         case NL802154_IFTYPE_NODE:
> >                 ieee802154_be64_to_le64(&wpan_dev->extended_addr,
> >                                         sdata->dev->dev_addr);
> > @@ -636,6 +637,7 @@ ieee802154_if_add(struct ieee802154_local *local, c=
onst char *name,
> >         ieee802154_le64_to_be64(ndev->perm_addr,
> >                                 &local->hw.phy->perm_extended_addr);
> >         switch (type) {
> > +       case NL802154_IFTYPE_COORD:
> >         case NL802154_IFTYPE_NODE:
> >                 ndev->type =3D ARPHRD_IEEE802154;
> >                 if (ieee802154_is_valid_extended_unicast_addr(extended_=
addr)) {
> > diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
> > index b8ce84618a55..39459d8d787a 100644
> > --- a/net/mac802154/rx.c
> > +++ b/net/mac802154/rx.c
> > @@ -203,7 +203,7 @@ __ieee802154_rx_handle_packet(struct ieee802154_loc=
al *local,
> >         }
> >
> >         list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> > -               if (sdata->wpan_dev.iftype !=3D NL802154_IFTYPE_NODE)
> > +               if (sdata->wpan_dev.iftype =3D=3D NL802154_IFTYPE_MONIT=
OR)
> >                         continue; =20
>=20
> I probably get why you are doing that, but first the overall design is
> working differently - means you should add an additional receive path
> for the special interface type.
>=20
> Also we "discovered" before that the receive path of node vs
> coordinator is different... Where is the different handling here? I
> don't see it, I see that NODE and COORD are the same now (because that
> is _currently_ everything else than monitor). This change is not
> enough and does "something" to handle in some way coordinator receive
> path but there are things missing.
>=20
> 1. Changing the address filters that it signals the transceiver it's
> acting as coordinator
> 2. We _should_ also have additional handling for whatever the
> additional handling what address filters are doing in mac802154
> _because_ there is hardware which doesn't have address filtering e.g.
> hwsim which depend that this is working in software like other
> transceiver hardware address filters.
>=20
> For the 2. one, I don't know if we do that even for NODE right or we
> just have the bare minimal support there... I don't assume that
> everything is working correctly here but what I want to see is a
> separate receive path for coordinators that people can send patches to
> fix it.

Yes, we do very little differently between the two modes, that's why I
took the easy way: just changing the condition. I really don't see what
I can currently add here, but I am fine changing the style to easily
show people where to add filters for such or such interface, but right
now both path will look very "identical", do we agree on that?

Thanks,
Miqu=C3=A8l
