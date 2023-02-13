Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F6C694E1F
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 18:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjBMRfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 12:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjBMRfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 12:35:47 -0500
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [217.70.178.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A755FFB;
        Mon, 13 Feb 2023 09:35:45 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E0026240008;
        Mon, 13 Feb 2023 17:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1676309744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+XxkYe9ix/RRf5nv4U8b1q4K7UAx5tDijvFbItJ0wok=;
        b=CUhm/tj063qhaoysFyALzycqPw4PNyPKYOYTK4EijRLa6LDFmrKEQ/uPTpk3l+Qba7xPcj
        zgRIycoznWt22qlE4VbBI5Wu0rButDb+8t65fcoCSt7/2+cA5CAb6oFqTUf0c7vjahS7EP
        sULYjCkwA1L6sH1hpIxC1E+I22nwzke6MSYsHX5ieK0fIbHTmFs1lN/bm3SLQ/iua7/SiM
        fPIg5GE+SfVT43eHrDr1vL7MDe5R/7kEMtvIr2mpxaNGiH5pFgpmV3WzF5Beyts98ZPp4w
        i3bbpsAxgj1/L8NjnEyrGbxZuk5h8t5E7iH9p8RiI0F+2w6XFs8JCT/5kf9ELg==
Date:   Mon, 13 Feb 2023 18:35:35 +0100
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
Message-ID: <20230213183535.05e62c1c@xps-13>
In-Reply-To: <CAK-6q+jbcMZK16pfZTb5v8-jvhmvk9-USr6hZE34H1MOrpF=JQ@mail.gmail.com>
References: <20221129160046.538864-1-miquel.raynal@bootlin.com>
        <20221129160046.538864-2-miquel.raynal@bootlin.com>
        <CAK-6q+iwqVx+6qQ-ctynykdrbN+SHxzk91gQCSdYCUD-FornZA@mail.gmail.com>
        <20230206101235.0371da87@xps-13>
        <CAK-6q+jav4yJD3MsOssyBobg1zGqKC5sm-xCRYX1SCkH9GhmHw@mail.gmail.com>
        <CAK-6q+jbcMZK16pfZTb5v8-jvhmvk9-USr6hZE34H1MOrpF=JQ@mail.gmail.com>
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

Hi Alexander,

> > > > > +static int nl802154_trigger_scan(struct sk_buff *skb, struct gen=
l_info *info)
> > > > > +{
> > > > > +       struct cfg802154_registered_device *rdev =3D info->user_p=
tr[0];
> > > > > +       struct net_device *dev =3D info->user_ptr[1];
> > > > > +       struct wpan_dev *wpan_dev =3D dev->ieee802154_ptr;
> > > > > +       struct wpan_phy *wpan_phy =3D &rdev->wpan_phy;
> > > > > +       struct cfg802154_scan_request *request;
> > > > > +       u8 type;
> > > > > +       int err;
> > > > > +
> > > > > +       /* Monitors are not allowed to perform scans */
> > > > > +       if (wpan_dev->iftype =3D=3D NL802154_IFTYPE_MONITOR)
> > > > > +               return -EPERM; =20
> > > >
> > > > btw: why are monitors not allowed? =20
> > >
> > > I guess I had the "active scan" use case in mind which of course does
> > > not work with monitors. Maybe I can relax this a little bit indeed,
> > > right now I don't remember why I strongly refused scans on monitors. =
=20
> >
> > Isn't it that scans really work close to phy level? Means in this case
> > we disable mostly everything of MAC filtering on the transceiver side.
> > Then I don't see any reasons why even monitors can't do anything, they
> > also can send something. But they really don't have any specific
> > source address set, so long addresses are none for source addresses, I
> > don't see any problem here. They also don't have AACK handling, but
> > it's not required for scan anyway...
> >
> > If this gets too complicated right now, then I am also fine with
> > returning an error here, we can enable it later but would it be better
> > to use ENOTSUPP or something like that in this case? EPERM sounds like
> > you can do that, but you don't have the permissions.
> > =20
>=20
> For me a scan should also be possible from iwpan phy $PHY scan (or
> whatever the scan command is, or just enable beacon)... to go over the
> dev is just a shortcut for "I mean whatever the phy is under this dev"
> ?

Actually only coordinators (in a specific state) should be able to send
beacons, so I am kind of against allowing that shortcut, because there
are usually two dev interfaces on top of the phy's, a regular "NODE"
and a "COORD", so I don't think we should go that way.

For scans however it makes sense, I've added the necessary changes in
wpan-tools. The TOP_LEVEL(scan) macro however does not support using
the same command name twice because it creates a macro, so this one
only supports a device name (the interface command has kind of the same
situation and uses a HIDDEN() macro which cannot be used here).

So in summary here is what is supported:
- dev <dev> beacon
- dev <dev> scan trigger|abort
- phy <phy> scan trigger|abort
- dev <dev> scan (the blocking one, which triggers, listens and returns)

Do you agree?

Thanks,
Miqu=C3=A8l
