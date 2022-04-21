Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8935F5099A7
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 09:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385937AbiDUHm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 03:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386067AbiDUHmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 03:42:21 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183DD1B78B;
        Thu, 21 Apr 2022 00:39:28 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8C43DC0006;
        Thu, 21 Apr 2022 07:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1650526767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qYEuMKcRPLE7kv8cT5u0HPUdYyTsqKBj+98EErK/TJ0=;
        b=cB4C5DPCEOYqaVr9TDlENrzgBO5YhoarBWOEZgIWnUCbvvjTlFrP03L1s5ToSBdMOUPO8m
        dnq1jUaH8UIPO3XlNQhX1uCuKQI6QAill+P6dq5dTL5b5u9DFOOUg0b6ju7dUtPNY5+kLy
        ohRTLazqOvlRjrQCy0V/ZTsCl2HZcvcbwFlDCui7i9IegCqRbHDt87bmhylkc7MVKEBn4w
        UL80gxiE8d2mxED8UxMeuQtrpINohimKy2k5T5ddfmU2AgUkgcpEL66Kydzt28aowuN7ay
        RabEWJWw9osi10CVeYQD+jyv4aYzANUS8n0jOOw2PCuNxCqLj9c7VHTQXyFIHg==
Date:   Thu, 21 Apr 2022 09:38:03 +0200
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
Message-ID: <20220421093803.64ad7cc8@fixe.home>
In-Reply-To: <20220420195214.dnekbfhha53trbke@skbuf>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
        <20220414122250.158113-9-clement.leger@bootlin.com>
        <20220414175140.p2vyy7f7yk6vlomi@skbuf>
        <20220420101648.7aa973b2@fixe.home>
        <20220420195214.dnekbfhha53trbke@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Wed, 20 Apr 2022 22:52:14 +0300,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> > >=20
> > > Shouldn't this contain something along the lines of a VID, FID, somet=
hing? =20
> >=20
> > This is extracted directly from the datasheet [1]. The switch FDB table
> > does not seems to store the VID with the entries (See page 300).
> >=20
> > [1]
> > https://www.renesas.com/us/en/document/mah/rzn1d-group-rzn1s-group-rzn1=
l-group-users-manual-r-engine-and-ethernet-peripherals =20
>=20
> Thanks for the link. I see that the switch has a non-partitionable
> lookup table, not even by VLAN. A shame.
>=20
> This is also in contrast with the software bridge driver, where FDB and
> MDB entries can have independent destinations per VID.
>=20
> So there's nothing you can do beyond limiting to a single offloaded
> bridge and hoping for the best w.r.t. per-VLAN forwarding destinations.
>=20
> Note that if you limit to a single bridge does not mean that you can
> declare ds->fdb_isolation =3D true. Declaring that would opt you into
> unicast and multicast filtering towards the CPU, i.o.w. a method for
> software to only receive the addresses it has expressed an interest in,
> rather than all packets received on standalone ports. The way that is
> implemented in DSA is by adding FDB and MDB entries on the management
> port, and it would break a lot of things without a partitioning scheme
> for the lookup table.

Thanks Vladimir, it confirms what I thought.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
