Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884A4508340
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 10:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376657AbiDTIU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 04:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244925AbiDTIU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 04:20:59 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC554237FF;
        Wed, 20 Apr 2022 01:18:12 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 92C04C000A;
        Wed, 20 Apr 2022 08:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1650442691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pipAui7tZg86jwSsjTxySU/yNzSclL96wyixIPeZQDY=;
        b=KSwSuWGJRpM8VvguqLazaiWg0G2R2V+Iv6Pi8lDiWIWnD6VlJeSfCqjEfhRDNg/qXBhiZC
        VuEtw0qybjZrXHhuVdonCLJEjhtK4weydCLZ8JdJIZ3BRa4qy49ILY58TMIbEhgM59e2HA
        jvadde3Kt+AafCDl1G6CRHkCuUyT5mvpG1uQty65BRMwOAjtGyQVyhNE78+euyN+AztS+H
        Pi3ZdcyXRjZBmHEjqUS2/OfokINU1Gc6/+ycNIp32RQDrfui9jp+Pve+aV23fjHaYG+pfG
        uwr2har8vYKYSSXwAiEqMkw5JFy51roTJvtEFOAhRb3r543hGacwLXXyQkUx9w==
Date:   Wed, 20 Apr 2022 10:16:48 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 08/12] net: dsa: rzn1-a5psw: add FDB support
Message-ID: <20220420101648.7aa973b2@fixe.home>
In-Reply-To: <20220414175140.p2vyy7f7yk6vlomi@skbuf>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
        <20220414122250.158113-9-clement.leger@bootlin.com>
        <20220414175140.p2vyy7f7yk6vlomi@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
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

Le Thu, 14 Apr 2022 20:51:40 +0300,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> > +
> > +static int a5psw_port_fdb_add(struct dsa_switch *ds, int port,
> > +			      const unsigned char *addr, u16 vid,
> > +			      struct dsa_db db) =20
>=20
> This isn't something that is documented because I haven't had time to
> update that, but new drivers should comply to the requirements for FDB
> isolation (not ignore the passed "db" here) and eventually set
> ds->fdb_isolation =3D true. Doing so would allow your switch to behave
> correctly when
> - there is more than one bridge spanning its ports,
> - some ports are standalone and some ports are bridged
> - standalone ports are looped back via an external cable with bridged
>   ports
> - unrecognized upper interfaces (bond, team) are used, and those are
>   bridged directly with some other switch ports
>=20
> The most basic thing you need to do to satisfy the requirements is to
> figure out what mechanism for FDB partitioning does your hardware have.
> If the answer is "none", then we'll have to use VLANs for that: all
> standalone ports to share a VLAN, each VLAN-unaware bridge to share a
> VLAN across all member ports, each VLAN of a VLAN-aware bridge to
> reserve its own VLAN. Up to a total of 32 VLANs, since I notice that's
> what the limit for your hardware is.

Ok, I see the idea. In the mean time, could we make a first step with a
single bridge and without VLAN support ? This is expected to come later
anyway.

>=20
> But I see this patch set doesn't include VLAN functionality (and also
> ignores the "vid" from FDB entries), so I can't really say more right now.
> But if you could provide more information about the hardware
> capabilities we can discuss implementation options.

That's indeed the problem. The FDB table does not seems to have
partitionning at all (except for ports) and entries (such as seen below)
do not contain any VLAN information.

> > diff --git a/drivers/net/dsa/rzn1_a5psw.h b/drivers/net/dsa/rzn1_a5psw.h
> > index b34ea549e936..37aa89383e70 100644
> > --- a/drivers/net/dsa/rzn1_a5psw.h
> > +++ b/drivers/net/dsa/rzn1_a5psw.h
> > @@ -167,6 +167,22 @@
> >  #define A5PSW_CTRL_TIMEOUT		1000
> >  #define A5PSW_TABLE_ENTRIES		8192
> > =20
> > +struct fdb_entry { =20
>=20
> Shouldn't this contain something along the lines of a VID, FID, something?

This is extracted directly from the datasheet [1]. The switch FDB table
does not seems to store the VID with the entries (See page 300).

[1]
https://www.renesas.com/us/en/document/mah/rzn1d-group-rzn1s-group-rzn1l-gr=
oup-users-manual-r-engine-and-ethernet-peripherals
>=20
> > +	u8 mac[ETH_ALEN];
> > +	u8 valid:1;
> > +	u8 is_static:1;
> > +	u8 prio:3;
> > +	u8 port_mask:5;
> > +} __packed;
> > +
> > +union lk_data {
> > +	struct {
> > +		u32 lo;
> > +		u32 hi;
> > +	};
> > +	struct fdb_entry entry;
> > +};
> > +
> >  /**
> >   * struct a5psw - switch struct
> >   * @base: Base address of the switch
> > --=20
> > 2.34.1
> >  =20
>=20



--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
