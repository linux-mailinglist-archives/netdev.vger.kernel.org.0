Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 411B051C15D
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380092AbiEENxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380076AbiEENxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:53:07 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1088C57B3B;
        Thu,  5 May 2022 06:49:26 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 5683160006;
        Thu,  5 May 2022 13:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1651758565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vqDFbGmKNJruiByQjIrXNv8C+KNkeae3TcAb//Cv/EY=;
        b=nOLhuyhIIqkvP7KRf+NXyjpJTXmH0yxAIjp/oMAZ0GOrCUrvr8n6FxwX5VZoXGn+zjt731
        enmNxNiXH5C6XMhFrNwX5zkW+s96XPUwJt/T93XZHAWGYko/VMR2jYCp6i6+XokP/UCRD0
        d+2E3gwjD8XX1hoafN7C910XMmgct9qEpS152tZsFJEs/6HjT4Hz0euYzwesZalC5Ywpdn
        D0nfoKsKCn805Fn8iQAkMiLomxFriaE8EHYC08dbVLabJo8ZeQhAW4QqH3GJLbOavyE9Sk
        6/9f3NjHRsTAuhB4Kv47b5p3tmM6zZlCFwIEiIr3NhLnd117PBqQ50UzBaMPtw==
Date:   Thu, 5 May 2022 15:48:06 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 02/12] net: dsa: add Renesas RZ/N1 switch
 tag driver
Message-ID: <20220505154806.7a7a182c@fixe.home>
In-Reply-To: <20220504160039.5viu3cqd5zbmo6n2@skbuf>
References: <20220504093000.132579-1-clement.leger@bootlin.com>
        <20220504093000.132579-3-clement.leger@bootlin.com>
        <20220504160039.5viu3cqd5zbmo6n2@skbuf>
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

Le Wed, 4 May 2022 19:00:39 +0300,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> > +/* To define the outgoing port and to discover the incoming port a TAG=
 is
> > + * inserted after Src MAC :
> > + *
> > + *       Dest MAC       Src MAC           TAG         Type
> > + * ...| 1 2 3 4 5 6 | 1 2 3 4 5 6 | 1 2 3 4 5 6 7 8 | 1 2 |...
> > + *                                |<--------------->|
> > + *
> > + * See struct a5psw_tag for layout
> > + */
> > +
> > +#define A5PSW_TAG_VALUE			0xE001 =20
>=20
> Maybe an ETH_P_DSA_A5PSW definition in include/uapi/linux/if_ether.h
> would be appropriate? I'm not sure.

That's a good question. Actually, this value is the default=20
but is configurable in the hardware so I'm not sure this should be a
reserved value. Maybe it would make sense to add it anyway to have the
define shared between the switch driver and the tag driver.

>=20
> > +#define A5PSW_TAG_LEN			8
> > +#define A5PSW_CTRL_DATA_FORCE_FORWARD	BIT(0)
> > +/* This is both used for xmit tag and rcv tagging */
> > +#define A5PSW_CTRL_DATA_PORT		GENMASK(3, 0)
> > +
> > +struct a5psw_tag {
> > +	__be16 ctrl_tag;
> > +	__be16 ctrl_data;
> > +	__be16 ctrl_data2_hi;
> > +	__be16 ctrl_data2_lo;
> > +};
> > +
> > +static struct sk_buff *a5psw_tag_xmit(struct sk_buff *skb, struct net_=
device *dev)
> > +{
> > +	struct dsa_port *dp =3D dsa_slave_to_port(dev);
> > +	struct a5psw_tag *ptag;
> > +	u32 data2_val;
> > +
> > +	BUILD_BUG_ON(sizeof(*ptag) !=3D A5PSW_TAG_LEN);
> > +
> > +	/* The Ethernet switch we are interfaced with needs packets to be at
> > +	 * least 64 bytes (including FCS) otherwise they will be discarded wh=
en
> > +	 * they enter the switch port logic. When tagging is enabled, we need
> > +	 * to make sure that packets are at least 70 bytes (including FCS and
> > +	 * tag).
> > +	 */
> > +	if (__skb_put_padto(skb, ETH_ZLEN + ETH_FCS_LEN + A5PSW_TAG_LEN, fals=
e))
> > +		return NULL; =20
>=20
> I'm confused by the inclusion of the FCS length in this calculation,
> since the FCS space isn't present in the skb buffer as far as I know?

I'm not sure either, the documentation is not really clear on what is
the requirement for the minimal size of a packet. This was the closest
thing I could find about that requirement:

"A frame has a valid length if it contains at least 64 octets and does
not exceed the programmed maximum length"

And the figure associated to the frame show that the frame length
includes the FCS which lead to a 64bytes frame.
>=20
> "64 bytes including FCS" means "60 bytes excluding FCS".
> And ETH_ZLEN is 60...
>=20
> And I'm also not sure how we got to the number 70? A5PSW_TAG_LEN is 8.
> If we add it to 60 we get 68. If we add it to 64 we get 72?
>

I'll check all these numbers and find the correct size that is expected
by the switch.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
