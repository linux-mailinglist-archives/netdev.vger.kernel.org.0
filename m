Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E04F5696744
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 15:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbjBNOql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 09:46:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233278AbjBNOqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 09:46:39 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8328B3586;
        Tue, 14 Feb 2023 06:46:37 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 4D876100002;
        Tue, 14 Feb 2023 14:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1676385996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SPvjzojXQ8S13JvGk/gXuqmumm1P/PXJpYOc68WCiDo=;
        b=CKHuUTv0AVaxcYKxL7UDhLeX2kE5L8SAPs1ySRf1X/aghkeo5F8uP/eRiDf0FPyjQ56f1e
        FBlnHcDB6Up+m3LkbzPYsdMVO9cwtpYYZVCSnW2RkkRIEI4a/wNA8K9dtCIgh2hf9i2hjj
        QDlyNAP24XfNa6mYLbVQmFzxbXVvBG1EDV/mWMn8+sVjs66meCarkOYFZNnqDzrA4hd02o
        wZGBuiqexEohRYFf6AZ1MM+6f3PTYhnyzECX4yWnckbOjaYUMg9qXzNZLl6VIemoWZCusW
        wtf0UGM3Os5W4LiIddnLlYukMWzAmoRYEnfjDXHSn+mKW7Lxp64nWYB7wuDXLg==
Date:   Tue, 14 Feb 2023 15:46:32 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next 1/6] ieee802154: Add support for user scanning
 requests
Message-ID: <20230214154632.69e8e339@xps-13>
In-Reply-To: <20230214150600.1c21066b@xps-13>
References: <20221129160046.538864-1-miquel.raynal@bootlin.com>
        <20221129160046.538864-2-miquel.raynal@bootlin.com>
        <CAK-6q+iwqVx+6qQ-ctynykdrbN+SHxzk91gQCSdYCUD-FornZA@mail.gmail.com>
        <20230206101235.0371da87@xps-13>
        <CAK-6q+jav4yJD3MsOssyBobg1zGqKC5sm-xCRYX1SCkH9GhmHw@mail.gmail.com>
        <CAK-6q+jbcMZK16pfZTb5v8-jvhmvk9-USr6hZE34H1MOrpF=JQ@mail.gmail.com>
        <20230213183535.05e62c1c@xps-13>
        <CAK-6q+hkJpqNG9nO_ugngjGQ_q9VdLu+xDjmD09MT+5=tvd0QA@mail.gmail.com>
        <CAK-6q+jU7-ETKeoM=MLmfyMUqywteBC8sUAndRF1vx0PgA+WAA@mail.gmail.com>
        <20230214150600.1c21066b@xps-13>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


miquel.raynal@bootlin.com wrote on Tue, 14 Feb 2023 15:06:00 +0100:

> Hi Alexander,
>=20
> aahringo@redhat.com wrote on Tue, 14 Feb 2023 08:53:57 -0500:
>=20
> > Hi,
> >=20
> > On Tue, Feb 14, 2023 at 8:34 AM Alexander Aring <aahringo@redhat.com> w=
rote: =20
> > >
> > > Hi,
> > >
> > > On Mon, Feb 13, 2023 at 12:35 PM Miquel Raynal
> > > <miquel.raynal@bootlin.com> wrote:   =20
> > > >
> > > > Hi Alexander,
> > > >   =20
> > > > > > > > > +static int nl802154_trigger_scan(struct sk_buff *skb, st=
ruct genl_info *info)
> > > > > > > > > +{
> > > > > > > > > +       struct cfg802154_registered_device *rdev =3D info=
->user_ptr[0];
> > > > > > > > > +       struct net_device *dev =3D info->user_ptr[1];
> > > > > > > > > +       struct wpan_dev *wpan_dev =3D dev->ieee802154_ptr;
> > > > > > > > > +       struct wpan_phy *wpan_phy =3D &rdev->wpan_phy;
> > > > > > > > > +       struct cfg802154_scan_request *request;
> > > > > > > > > +       u8 type;
> > > > > > > > > +       int err;
> > > > > > > > > +
> > > > > > > > > +       /* Monitors are not allowed to perform scans */
> > > > > > > > > +       if (wpan_dev->iftype =3D=3D NL802154_IFTYPE_MONIT=
OR)
> > > > > > > > > +               return -EPERM;   =20
> > > > > > > >
> > > > > > > > btw: why are monitors not allowed?   =20
> > > > > > >
> > > > > > > I guess I had the "active scan" use case in mind which of cou=
rse does
> > > > > > > not work with monitors. Maybe I can relax this a little bit i=
ndeed,
> > > > > > > right now I don't remember why I strongly refused scans on mo=
nitors.   =20
> > > > > >
> > > > > > Isn't it that scans really work close to phy level? Means in th=
is case
> > > > > > we disable mostly everything of MAC filtering on the transceive=
r side.
> > > > > > Then I don't see any reasons why even monitors can't do anythin=
g, they
> > > > > > also can send something. But they really don't have any specific
> > > > > > source address set, so long addresses are none for source addre=
sses, I
> > > > > > don't see any problem here. They also don't have AACK handling,=
 but
> > > > > > it's not required for scan anyway...
> > > > > >
> > > > > > If this gets too complicated right now, then I am also fine with
> > > > > > returning an error here, we can enable it later but would it be=
 better
> > > > > > to use ENOTSUPP or something like that in this case? EPERM soun=
ds like
> > > > > > you can do that, but you don't have the permissions.
> > > > > >   =20
> > > > >
> > > > > For me a scan should also be possible from iwpan phy $PHY scan (or
> > > > > whatever the scan command is, or just enable beacon)... to go ove=
r the
> > > > > dev is just a shortcut for "I mean whatever the phy is under this=
 dev"
> > > > > ?   =20
> > > >
> > > > Actually only coordinators (in a specific state) should be able to =
send
> > > > beacons, so I am kind of against allowing that shortcut, because th=
ere
> > > > are usually two dev interfaces on top of the phy's, a regular "NODE"
> > > > and a "COORD", so I don't think we should go that way.
> > > >
> > > > For scans however it makes sense, I've added the necessary changes =
in
> > > > wpan-tools. The TOP_LEVEL(scan) macro however does not support using
> > > > the same command name twice because it creates a macro, so this one
> > > > only supports a device name (the interface command has kind of the =
same
> > > > situation and uses a HIDDEN() macro which cannot be used here).
> > > >   =20
> > >
> > > Yes, I was thinking about scanning only.
> > >   =20
> > > > So in summary here is what is supported:
> > > > - dev <dev> beacon
> > > > - dev <dev> scan trigger|abort
> > > > - phy <phy> scan trigger|abort
> > > > - dev <dev> scan (the blocking one, which triggers, listens and ret=
urns)
> > > >
> > > > Do you agree?
> > > >   =20
> > >
> > > Okay, yes. I trust you.   =20
> >=20
> > btw: at the point when a scan requires a source address... it cannot
> > be done because then a scan is related to a MAC instance -> an wpan
> > interface and we need to bind to it. But I think it doesn't? =20
>=20
> I'm not sure I follow you here. You mean in case of active scan?

Actually a beacon requests do not require any kind of source identifier,
so what do you mean by source address?

A regular beacon, however, does. Which means sending beacons would
include being able to set an address into a monitor interface. So if we
want to play with beacons on monitor interfaces, we should also relax
the pan_id/addressing rules.

> The operation is always tight to a device in the end, even if you
> provide a phy in userspace. So I guess it's not a problem. Or maybe I
> didn't get the question right?
>=20
> Thanks,
> Miqu=C3=A8l


Thanks,
Miqu=C3=A8l
