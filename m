Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F152169427F
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 11:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbjBMKQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 05:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBMKQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 05:16:04 -0500
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [217.70.178.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322474C0C;
        Mon, 13 Feb 2023 02:15:58 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id CDA7824000A;
        Mon, 13 Feb 2023 10:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1676283357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZLSuRUYWEmq01XY9c0Hrrl81X+I4m+hB9cvE9ZNmpW0=;
        b=T6keZ1eCmOH4RPASy5PnlIUsCjQ830L2CZGCbnHk9XpwEkWLGBRPIAU2JKZ1vHHb0rxq75
        r6K/mIh1bVlA4/7yrbS9LHvXMlgfTsS/A90jUMHoVdso5MiaQxkRH3swK9My06LrWnnxNQ
        zgjD8UKcENlIZF2FU0UIeIEqypVga8kT9U7bN9Z4iyLJnOkNXmWBVEJhJdrO6JBZo4dYMs
        LdIGaqpU2PAWbJJvEE56d2rXjrWoulVi0/2QXIIQIBSL3Bkbn5WjHiuR3YUT9r23pV3mdC
        GGOoXpntVJAusRRlKntLCU6FJnguj8vxc87RkX/K5f4b5aGXjjHs83K/UQk6og==
Date:   Mon, 13 Feb 2023 11:15:53 +0100
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
Message-ID: <20230213111553.0dcce5c2@xps-13>
In-Reply-To: <CAK-6q+jLKo1bLBie_xYZyZdyjNB_M8JvxDfr77RQAY9WYcQY8w@mail.gmail.com>
References: <20221129160046.538864-1-miquel.raynal@bootlin.com>
        <20221129160046.538864-2-miquel.raynal@bootlin.com>
        <CAK-6q+iwqVx+6qQ-ctynykdrbN+SHxzk91gQCSdYCUD-FornZA@mail.gmail.com>
        <20230206101235.0371da87@xps-13>
        <CAK-6q+jav4yJD3MsOssyBobg1zGqKC5sm-xCRYX1SCkH9GhmHw@mail.gmail.com>
        <20230210182129.77c1084d@xps-13>
        <CAK-6q+jLKo1bLBie_xYZyZdyjNB_M8JvxDfr77RQAY9WYcQY8w@mail.gmail.com>
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

> > > > > > +static int nl802154_trigger_scan(struct sk_buff *skb, struct g=
enl_info *info)
> > > > > > +{
> > > > > > +       struct cfg802154_registered_device *rdev =3D info->user=
_ptr[0];
> > > > > > +       struct net_device *dev =3D info->user_ptr[1];
> > > > > > +       struct wpan_dev *wpan_dev =3D dev->ieee802154_ptr;
> > > > > > +       struct wpan_phy *wpan_phy =3D &rdev->wpan_phy;
> > > > > > +       struct cfg802154_scan_request *request;
> > > > > > +       u8 type;
> > > > > > +       int err;
> > > > > > +
> > > > > > +       /* Monitors are not allowed to perform scans */
> > > > > > +       if (wpan_dev->iftype =3D=3D NL802154_IFTYPE_MONITOR)
> > > > > > +               return -EPERM; =20
> > > > >
> > > > > btw: why are monitors not allowed? =20
> > > >
> > > > I guess I had the "active scan" use case in mind which of course do=
es
> > > > not work with monitors. Maybe I can relax this a little bit indeed,
> > > > right now I don't remember why I strongly refused scans on monitors=
. =20
> > >
> > > Isn't it that scans really work close to phy level? Means in this case
> > > we disable mostly everything of MAC filtering on the transceiver side.
> > > Then I don't see any reasons why even monitors can't do anything, they
> > > also can send something. But they really don't have any specific
> > > source address set, so long addresses are none for source addresses, I
> > > don't see any problem here. They also don't have AACK handling, but
> > > it's not required for scan anyway... =20
> >
> > I think I remember why I did not want to enable scans on monitors: we
> > actually change the filtering level to "scan", which is very
> > different to what a monitor is supposed to receive, which means in scan
> > mode a monitor would no longer receive all what it is supposed to
> > receive. Nothing that cannot be workaround'ed by software, probably,
> > but I believe it is safer right now to avoid introducing potential
> > regressions. So I will just change the error code and still refuse
> > scans on monitor interfaces for now, until we figure out if it's
> > actually safe or not (and if we really want to allow it).
> > =20
>=20
> Okay, for scan yes we tell them to be in scan mode and then the
> transceiver can filter whatever it delivers to the next level which is
> necessary for filtering scan mac frames only. AACK handling is
> disabled for scan mode for all types !=3D MONITORS.
>=20
> For monitors we mostly allow everything and AACK is _always_ disabled.
> The transceiver filter is completely disabled for at least what looks
> like a 802.15.4 MAC header (even malformed). There are some frame
> length checks which are necessary for specific hardware because
> otherwise they would read out the frame buffer. For me it can still
> feed the mac802154 stack for scanning (with filtering level as what
> the monitor sets to, but currently our scan filter is equal to the
> monitor filter mode anyway (which probably can be changed in
> future?)). So in my opinion the monitor can do both -> feed the scan
> mac802154 deliver path and the packet layer. And I also think that on
> a normal interface type the packet layer should be feeded by those
> frames as well and do not hit the mac802154 layer scan path only.

Actually that would be an out-of-spec situation, here is a quote of
chapter "6.3.1.3 Active and passive channel scan"

	During an active or passive scan, the MAC sublayer shall
	discard all frames received over the PHY data service that are
	not Beacon frames.

I don't think this is possible to do anyway on devices with a single
hardware filter setting?

> However this can be done in future and I think, indeed there might be
> other problems to tackle to enable such functionality.

Indeed.

Thanks,
Miqu=C3=A8l
