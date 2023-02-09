Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65D9A690262
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 09:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjBIIpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 03:45:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjBIIpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 03:45:08 -0500
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E4A2C666;
        Thu,  9 Feb 2023 00:45:06 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 118E6E000A;
        Thu,  9 Feb 2023 08:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675932304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lsM5D50PzVIPFH+SjdumhMwvBSFWE+VCnF+/HwUWPF0=;
        b=IYvEv71/5dXj2VmBueRtcbpUtatEwm5HrqsF+17xX6bIaYTkSXhGbI0rdMHd5cjwT4VFNP
        jflYdhrAsaz7l5EDj5wNuC5DktevkaKfXgO4XOQ5/J6No93S7cldfJUkT/PvHxO0PVDrCY
        1i4agU1AWG7Qe+Xifzg2+o3tsdOrbdNAcIh1WpKiYLVtChS7nL8DU4llKVUtTXo+phphl6
        fHjrmsCe4amHu+t0ckdxXEbgiGOTFhV+bdYDE6EE+albI7reJ4+ovcQIN0iLIl7NeZujqa
        zl4CWQC9igFUmA+OvgvvBjuMoUlV78ktjLjDtGcupP4Z97a7gqSb/edOfpr7iA==
Date:   Thu, 9 Feb 2023 09:47:25 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Arun Ramadoss <Arun.Ramadoss@microchip.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/3] net: dsa: rzn1-a5psw: add vlan support
Message-ID: <20230209094725.3ac772ff@fixe.home>
In-Reply-To: <20230208220309.4ekk4xpmpx27rkt6@skbuf>
References: <20230208161749.331965-1-clement.leger@bootlin.com>
        <20230208161749.331965-1-clement.leger@bootlin.com>
        <20230208161749.331965-4-clement.leger@bootlin.com>
        <20230208161749.331965-4-clement.leger@bootlin.com>
        <20230208220309.4ekk4xpmpx27rkt6@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Thu, 9 Feb 2023 00:03:09 +0200,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> On Wed, Feb 08, 2023 at 05:17:49PM +0100, Cl=C3=A9ment L=C3=A9ger wrote:
> > +static void a5psw_port_vlan_tagged_cfg(struct a5psw *a5psw, int vlan_r=
es_id,
> > +				       int port, bool set)
> > +{
> > +	u32 mask =3D A5PSW_VLAN_RES_WR_PORTMASK | A5PSW_VLAN_RES_RD_TAGMASK |
> > +		   BIT(port);
> > +	u32 vlan_res_off =3D A5PSW_VLAN_RES(vlan_res_id);
> > +	u32 val =3D A5PSW_VLAN_RES_WR_TAGMASK, reg;
> > +
> > +	if (set)
> > +		val |=3D BIT(port);
> > +
> > +	/* Toggle tag mask read */
> > +	a5psw_reg_writel(a5psw, vlan_res_off, A5PSW_VLAN_RES_RD_TAGMASK);
> > +	reg =3D a5psw_reg_readl(a5psw, vlan_res_off);
> > +	a5psw_reg_writel(a5psw, vlan_res_off, A5PSW_VLAN_RES_RD_TAGMASK); =20
>=20
> Is it intentional that this register is written twice?

Yes, the A5PSW_VLAN_RES_RD_TAGMASK bit is a toggle-bit (toggled
by writing a 1 in it) and it allows to read the tagmask (for
vlan tagging) instead of the portmask (for vlan membership):

"""
b28 read_tagmask:

Select contents of mask bits (4:0) when reading the
register. If this bit is set during a write into the register, all
other bits of the write are ignored (i.e. 30,29,16:0) and the bit 28 of
the register toggles (1-> 0; 0-> 1). This is used only to allow
changing the bit 28 without changing any table contents.
"""

>=20
> > +
> > +	reg &=3D ~mask;
> > +	reg |=3D val;
> > +	a5psw_reg_writel(a5psw, vlan_res_off, reg);
> > +} =20



--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
