Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9D0502B38
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 15:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354131AbiDONsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 09:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235290AbiDONsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 09:48:21 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B05F18385;
        Fri, 15 Apr 2022 06:45:51 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A45F9C0011;
        Fri, 15 Apr 2022 13:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1650030349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r5e/ituSe4Bvmn7/ipiIp9xLyWhKGgopzYJiAYxoSB0=;
        b=dP1/xN0GlD+5NO3uXdngygB6HWCd34pEyuj2uJZuOjEhCjNV8KDx/W6DPiiCDOqogfDQqV
        DmuZrWkzeibO1RY6xPNIXlHafkYusP16Mw5fhuJEM2RKlPCTUd7Ysw24zp4lbQvZiqKj5Y
        APIDQs52Lr/5dCbwI2iwQ7wcVPBv3cKPgbz51JA368MmF/XLK6pDNMq1Xj++bDH82Vy/ys
        16bqIrZe+CurQqZG/ji7Gx9s7sS4DFvQXUqMpLLXSJt1yxAJZNgzuUtKIw/tCVzzFfaZBw
        UNjrh1QHY1OwWY6iCBmpi5uds62SenhMsbzgdOv784fwRMQ3P5qd48Iyl75K7Q==
Date:   Fri, 15 Apr 2022 15:44:20 +0200
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
Message-ID: <20220415154420.128a0fca@fixe.home>
In-Reply-To: <Yll1IsIYKHC/n+sg@lunn.ch>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
        <20220414122250.158113-8-clement.leger@bootlin.com>
        <YlirO7VrfyUH33rV@lunn.ch>
        <20220415140402.76822543@fixe.home>
        <Yll1IsIYKHC/n+sg@lunn.ch>
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

Le Fri, 15 Apr 2022 15:37:38 +0200,
Andrew Lunn <andrew@lunn.ch> a =C3=A9crit :

> > > > +static void a5psw_get_ethtool_stats(struct dsa_switch *ds, int por=
t,
> > > > +				    uint64_t *data)
> > > > +{
> > > > +	struct a5psw *a5psw =3D ds->priv;
> > > > +	u32 reg_lo, reg_hi;
> > > > +	unsigned int u;
> > > > +
> > > > +	for (u =3D 0; u < ARRAY_SIZE(a5psw_stats); u++) {
> > > > +		/* A5PSW_STATS_HIWORD is global and thus, access must be
> > > > +		 * exclusive
> > > > +		 */   =20
> > >=20
> > > Could you explain that a bit more. The RTNL lock will prevent two
> > > parallel calls to this function. =20
> >=20
> > Ok, I wasn't sure of the locking applicable here. =20
>=20
> In general, RTNL protects you for any user space management like
> operation on the driver. In this case, if you look in net/ethtool, you
> will find the IOCTL handler code takes RTNL before calling into the
> main IOCTL dispatcher. If you want to be paranoid/document the
> assumption, you can add an ASSERT_RTNL().

Ok, I'll look at the call stack in details to see what locking is
applied.

>=20
> The semantics for some of the other statistics Vladimir requested can
> be slightly different. One of them is in atomic context, because a
> spinlock is held. But i don't remember if RTNL is also held. This is
> less of an issue for your switch, since it uses MMIO, however many
> switches need to perform blocking IO over MDIO, SPI, IC2 etc to get
> stats, which you cannot do in atomic context. So they end up returning
> cached values.
>=20
> Look in the mailing list for past discussion for details.

Ok, thanks,

>=20
>     Andrew


--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
