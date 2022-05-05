Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0715C51C12D
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379976AbiEENti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245347AbiEENtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:49:36 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221F42CCB7;
        Thu,  5 May 2022 06:45:53 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id AEC8F20007;
        Thu,  5 May 2022 13:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1651758352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=APu3zruYgegUIFbJNxsW/QRCDb/RNd0lCGoQLnybkX4=;
        b=hUZr8TqznISglCXOoDmPQNy7VHUGtOg+69KBoCaQd/aG4OVfyqpsks65iqjmh72mBdeXZM
        0YPfZJtxrCxY8H4UyIyoEI4A/Z0hEKXhMxjxwhAFj3SPxo6uWGOeijXR0X2L6cwgTpu1im
        uF970G2QBHi2j/kOlJYJwwz+QEqqaWZLM5tu5fxLuIkcxiwdZxMwy1i0OKdIScypL6mfOx
        okMTMJ9zYHkK4oKnRuFT8IPSzpXSDQs3NKvQtPlsfMAmc+jHqcApGopY32O8fpBS38DYnW
        5RvF3zRgZjAiLnD7qadNVm/0OTDMyX+LB+tMsgJtKzn+porWx/vqlTVeZqGnPw==
Date:   Thu, 5 May 2022 15:44:31 +0200
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
Subject: Re: [PATCH net-next v3 08/12] net: dsa: rzn1-a5psw: add FDB support
Message-ID: <20220505154431.06174a04@fixe.home>
In-Reply-To: <20220504162457.eeggo4xenvxddpkr@skbuf>
References: <20220504093000.132579-1-clement.leger@bootlin.com>
        <20220504093000.132579-9-clement.leger@bootlin.com>
        <20220504162457.eeggo4xenvxddpkr@skbuf>
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

Le Wed, 4 May 2022 19:24:57 +0300,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> On Wed, May 04, 2022 at 11:29:56AM +0200, Cl=C3=A9ment L=C3=A9ger wrote:
> > +static int a5psw_port_fdb_del(struct dsa_switch *ds, int port,
> > +			      const unsigned char *addr, u16 vid,
> > +			      struct dsa_db db)
> > +{
> > +	struct a5psw *a5psw =3D ds->priv;
> > +	union lk_data lk_data =3D {0};
> > +	bool clear =3D false;
> > +	int ret =3D 0;
> > +	u16 entry;
> > +	u32 reg;
> > +
> > +	ether_addr_copy(lk_data.entry.mac, addr);
> > +
> > +	spin_lock(&a5psw->lk_lock);
> > +
> > +	ret =3D a5psw_lk_execute_lookup(a5psw, &lk_data, &entry);
> > +	if (ret) {
> > +		dev_err(a5psw->dev, "Failed to lookup mac address\n");
> > +		goto lk_unlock;
> > +	}
> > +
> > +	lk_data.hi =3D a5psw_reg_readl(a5psw, A5PSW_LK_DATA_HI);
> > +	if (!lk_data.entry.valid) {
> > +		dev_err(a5psw->dev, "Tried to remove non-existing entry\n");
> > +		ret =3D -ENOENT;
> > +		goto lk_unlock; =20
>=20
> These error messages can happen under quite normal use with your hardware.
> For example:
>=20
> ip link add br0 type bridge && ip link set br0 master br0
> bridge fdb add dev swp0 00:01:02:03:04:05 vid 1 master static
> bridge fdb add dev swp0 00:01:02:03:04:05 vid 2 master static
> bridge fdb del dev swp0 00:01:02:03:04:05 vid 2 master static
> bridge fdb del dev swp0 00:01:02:03:04:05 vid 1 master static
>=20
> Because the driver ignores the VID, then as soon as the VID 2 FDB entry
> is removed, the VID 1 FDB entry doesn't exist anymore, either.

Argh did not thought about that but indeed, that will for sure trigger
the error.

>=20
> The above is a bit artificial. More practically, the bridge installs
> local FDB entries (MAC address of bridge device, MAC addresses of ports)
> once in the VLAN-unaware database (VID 0), and once per VLAN installed
> on br0.

Ok, seems clear.

>=20
> When the MAC address of br0 is different from that of the ports, and it
> is changed by the user, you'll get these errors too, since those changes
> translate into a deletion of the old local FDB entries (installed as FDB
> entries towards the CPU port). Do you want the users to see them and
> think something is wrong?  I mean, something _is_ wrong (the hardware),
> but you have to work with that somehow.

Indeed, I'll simply remove these error message. Should I still return
an error value however ? Seems like I should not to avoid triggering
any error that might confuse the user.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
