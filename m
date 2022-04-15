Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE2A450295D
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 14:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344007AbiDOMIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 08:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353205AbiDOMID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 08:08:03 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA54AD111;
        Fri, 15 Apr 2022 05:05:33 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 7B693240011;
        Fri, 15 Apr 2022 12:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1650024331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mMMKTkI1t74z457D3rwnXDbJeDE/63zmewzC5BANBFk=;
        b=g+3Y9bOloddX2/b2HGfVlTPEpWZ68ZUGgetSueVe3wm8nyZ1jhl+j7fGPhOFtKPNiZxZnr
        R612kZmmwUw7Xqg+I9vYT6F27U3rZQTtiDYCZAW/cokGwdT4Hv/XWaKj2sExNp3+u0EWbY
        kQCEdZUplGQW1jWY3eoWjGttge76exXEw4Nv7Bz7ggutCJrisZrtWsid3Iz31TGD8FoJRW
        /AQetx8nkMRHniYA7ZtshW84j1lAfgX1mLbOyNp/GJ/lO3fQb087qPmJHc/dbBT4ooZB/I
        FH/OcCgaKpxgsw3HH7sUR360KZN2L6lwK386buhPttqL8+VGGNt4ri0YRAuH9A==
Date:   Fri, 15 Apr 2022 14:04:02 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
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
Subject: Re: [PATCH net-next 07/12] net: dsa: rzn1-a5psw: add statistics
 support
Message-ID: <20220415140402.76822543@fixe.home>
In-Reply-To: <YlirO7VrfyUH33rV@lunn.ch>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
        <20220414122250.158113-8-clement.leger@bootlin.com>
        <YlirO7VrfyUH33rV@lunn.ch>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Fri, 15 Apr 2022 01:16:11 +0200,
Andrew Lunn <andrew@lunn.ch> a =C3=A9crit :

> On Thu, Apr 14, 2022 at 02:22:45PM +0200, Cl=C3=A9ment L=C3=A9ger wrote:
> > Add per-port statistics. This support requries to add a stat lock since
> > statistics are stored in two 32 bits registers, the hi part one being
> > global and latched when accessing the lo part.
> >=20
> > Signed-off-by: Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com>
> > ---
> >  drivers/net/dsa/rzn1_a5psw.c | 101 +++++++++++++++++++++++++++++++++++
> >  drivers/net/dsa/rzn1_a5psw.h |   2 +
> >  2 files changed, 103 insertions(+)
> >=20
> > diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
> > index 5bee999f7050..7ab7d9054427 100644
> > --- a/drivers/net/dsa/rzn1_a5psw.c
> > +++ b/drivers/net/dsa/rzn1_a5psw.c
> > @@ -16,6 +16,59 @@
> > =20
> >  #include "rzn1_a5psw.h"
> > =20
> > +struct a5psw_stats {
> > +	u16 offset;
> > +	const char *name;
> > +};
> > +
> > +#define STAT_DESC(_offset, _name) {.offset =3D _offset, .name =3D _nam=
e}
> > +
> > +static const struct a5psw_stats a5psw_stats[] =3D {
> > +	STAT_DESC(0x868, "aFrameTransmitted"),
> > +	STAT_DESC(0x86C, "aFrameReceived"),
> > +	STAT_DESC(0x8BC, "etherStatsetherStatsOversizePktsDropEvents"), =20
>=20
> > +}; =20
>=20
>=20
> > +static void a5psw_get_strings(struct dsa_switch *ds, int port, u32 str=
ingset,
> > +			      uint8_t *data)
> > +{
> > +	unsigned int u;
> > +
> > +	if (stringset !=3D ETH_SS_STATS)
> > +		return;
> > +
> > +	for (u =3D 0; u < ARRAY_SIZE(a5psw_stats); u++) {
> > +		strncpy(data + u * ETH_GSTRING_LEN, a5psw_stats[u].name,
> > +			ETH_GSTRING_LEN);
> > +	} =20
>=20
> The kernel strncpy() is like the user space one. It does not add a
> NULL if the string is longer than ETH_GSTRING_LEN and it needs to
> truncate. So there is a danger here.
>=20
> What you find most drivers do is
>=20
> struct a5psw_stats {
> 	u16 offset;
> 	const char name[ETH_GSTRING_LEN];
> };
>=20
> You should then get a compiler warning/error if you string is ever
> longer than allowed. And use memcpy() rather than strcpy(), which is
> faster anyway. But you do use up a bit more memory.

Acked.

>=20
> > +static void a5psw_get_ethtool_stats(struct dsa_switch *ds, int port,
> > +				    uint64_t *data)
> > +{
> > +	struct a5psw *a5psw =3D ds->priv;
> > +	u32 reg_lo, reg_hi;
> > +	unsigned int u;
> > +
> > +	for (u =3D 0; u < ARRAY_SIZE(a5psw_stats); u++) {
> > +		/* A5PSW_STATS_HIWORD is global and thus, access must be
> > +		 * exclusive
> > +		 */ =20
>=20
> Could you explain that a bit more. The RTNL lock will prevent two
> parallel calls to this function.

Ok, I wasn't sure of the locking applicable here.



--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
