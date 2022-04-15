Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856D9502A82
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 14:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353732AbiDOMqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 08:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241937AbiDOMqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 08:46:00 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9439AC31D7;
        Fri, 15 Apr 2022 05:43:31 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 3E09CE0005;
        Fri, 15 Apr 2022 12:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1650026610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8erFvk+2hjel+P0tYw+hz99use+hgo7ZwPscCOBWUUI=;
        b=O4r486fzPea8x95LEc66uX+VfbejUeNr3S9jo6emAvz/RAciWQTeIoLsBKasizdh1s5Hx+
        PTMlexfVy0fQsijFnKOcoZz58EaQFcqrwxyC8VzGwQlFsJ/4+AnoikyAIlkrgWTTUVb96Y
        083jY2EzKumwc11wphcnozz/t3ou6xO9E6ubaLTWQ42Oxtwz1dK0opxkLtOzefLsKXIE6j
        4yYc2Ap2Tndz/D4Kw5cThhJzRPXR0UMoSEQRL2V0UnYOu0lcy8eYop1Ul+ao88VEIgHIvV
        zVpP+qIegCingWUaCxiPz2tUMrUrWhC9Cd6wNFeKs73f15Vx1GaYQZA8XOhWxQ==
Date:   Fri, 15 Apr 2022 14:42:02 +0200
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
Subject: Re: [PATCH net-next 07/12] net: dsa: rzn1-a5psw: add statistics
 support
Message-ID: <20220415144202.64b6c3b4@fixe.home>
In-Reply-To: <20220414173444.iymkyes7iu4jifte@skbuf>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
        <20220414122250.158113-8-clement.leger@bootlin.com>
        <20220414173444.iymkyes7iu4jifte@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Thu, 14 Apr 2022 20:34:44 +0300,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> On Thu, Apr 14, 2022 at 02:22:45PM +0200, Cl=C3=A9ment L=C3=A9ger wrote:
> > Add per-port statistics. This support requries to add a stat lock since
> > statistics are stored in two 32 bits registers, the hi part one being
> > global and latched when accessing the lo part.
> >=20
> > Signed-off-by: Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com>
> > --- =20
>=20
> I think for new drivers Jakub will also want to see the more specific
> and less free-form get_stats64, get_eth_mac_stats, get_eth_phy_stats,
> get_eth_ctrl_stats ops implemented. Your counters should map nicely over
> these.

Ok, I'll implement these callbacks !

>=20
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
> > +	STAT_DESC(0x870, "aFrameCheckSequenceErrors"),
> > +	STAT_DESC(0x874, "aAlignmentErrors"),
> > +	STAT_DESC(0x878, "aOctetsTransmitted"),
> > +	STAT_DESC(0x87C, "aOctetsReceived"),
> > +	STAT_DESC(0x880, "aTxPAUSEMACCtrlFrames"),
> > +	STAT_DESC(0x884, "aRxPAUSEMACCtrlFrames"), =20
>=20
> What does the "a" stand for?

That's a mystery :/ I tried to be a normal person and copy/pasted these
from the datasheet ;)

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
