Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C86F66CFF6D
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 11:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjC3JJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 05:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjC3JJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 05:09:28 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F50F65AC;
        Thu, 30 Mar 2023 02:09:25 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 63F2AC0009;
        Thu, 30 Mar 2023 09:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680167364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WtUh57EJJSQe6Pe0U1pJ/OpWThBAVkWCUDMXG8Z66Qg=;
        b=P2mH3v3WV41ffCI+oj7We8XxB8se0IuaI6vUAL6RQaC+lmZqHDH5weRakWMvtllQCaHtPZ
        K2lE9su42PdM6NYUHeM604aLdGdhXY4rKN8N1Zipm1uMmsMBj97rzHVAaqcND1cnUaEQEp
        k7iQqoXuKDpKqr6YXxGw+B7XN4mzTi+Lg9Ay0ISe8J2MIr7iley9Qfo0Xz6LLpFu5kHcGZ
        OxBJI2HFWviUMqIKJyUBad6isIhi3aPK3fBg//Dxbw6H3kJbd4ZkTMoRI5lrD/XdFNYiyB
        xQDDMBpl7Dyz1M5Dg3Nfeol5h13NKlAqTLUA7qjSwlD4bB8WWd5tqQveupDp8Q==
Date:   Thu, 30 Mar 2023 11:09:59 +0200
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
        linux-kernel@vger.kernel.org,
        Alexis Lothore <alexis.lothore@bootlin.com>
Subject: Re: [PATCH RESEND net-next v4 3/3] net: dsa: rzn1-a5psw: add vlan
 support
Message-ID: <20230330110959.2132cd07@fixe.home>
In-Reply-To: <20230329131613.zg4whzzoa4yna7lh@skbuf>
References: <20230324220042.rquucjt7dctn7xno@skbuf>
        <20230314163651.242259-1-clement.leger@bootlin.com>
        <20230314163651.242259-1-clement.leger@bootlin.com>
        <20230314163651.242259-4-clement.leger@bootlin.com>
        <20230314163651.242259-4-clement.leger@bootlin.com>
        <20230314233454.3zcpzhobif475hl2@skbuf>
        <20230315155430.5873cdb6@fixe.home>
        <20230324220042.rquucjt7dctn7xno@skbuf>
        <20230328104429.5d2e475a@fixe.home>
        <20230328104429.5d2e475a@fixe.home>
        <20230329131613.zg4whzzoa4yna7lh@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Wed, 29 Mar 2023 16:16:13 +0300,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> > After thinking about the current mechasnim, let me summarize why I
> > think it almost matches what you described in this last paragraph:
> >=20
> > - Port is set to match a specific matching rule which will enforce port
> >   to CPU forwarding only based on the MGMTFWD bit of PATTERN_CTRL which
> >   states the following: "When set, the frame is forwarded to the
> >   management port only (suppressing destination address lookup)"
> >=20
> > This means that for the "port to CPU" path when in standalone mode, we
> > are fine. Regarding the other "CPU to port" path only:
> >=20
> > - Learning will be disabled when leaving the bridge. This will allow
> >   not to have any new forwarding entries in the MAC lookup table.
> >=20
> > - Port is fast aged which means it won't be targeted for packet
> >   forwarding.
> >=20
> > - We remove the port from the flooding mask which means it won't be
> >   flooded after being removed from the port.
> >=20
> > Based on that, the port should not be the target of any forward packet
> > from the other ports. Note that anyway, even if using per-port VLAN for
> > standalone mode, we would also end up needing to disable learning,
> > fast-age the port and disable flooding (at least from my understanding
> > if we want the port to be truly isolated).
> >=20
> > Tell me if it makes sense. =20
>=20
> This makes sense.
>=20
> However, I still spotted a bug and I don't know where to mention it
> better, so I'll mention it here:
>=20
> a5psw_port_vlan_add()
>=20
> 	if (pvid) {
> 		a5psw_reg_rmw(a5psw, A5PSW_VLAN_IN_MODE_ENA, BIT(port),
> 			      BIT(port));
> 		a5psw_reg_writel(a5psw, A5PSW_SYSTEM_TAGINFO(port), vid);
> 	}
>=20
> You don't want a5psw_port_vlan_add() to change VLAN_IN_MODE_ENA, because
> port_vlan_add() will be called even for VLAN-unaware bridges, and you
> want all traffic to be forwarded as if untagged, and not according to
> the PVID. In other words, in a setup like this:
>=20
> ip link add br0 type bridge vlan_filtering 0 && ip link set br0 up
> ip link set swp0 master br0 && ip link set swp0 up
> ip link set swp1 master br0 && ip link set swp1 up
> bridge vlan del dev swp1 vid 1
>=20
> forwarding should still take place with no issues, because the entire
> VLAN table is bypassed by the software bridge when vlan_filtering=3D0, and
> the hardware accelerator should replicate that behavior.

Ok, we'll see how to fix that.

>=20
> I suspect that the PVID handling in a5psw_port_vlan_del() is also
> incorrect:
>=20
> 	/* Disable PVID if the vid is matching the port one */
> 	if (vid =3D=3D a5psw_reg_readl(a5psw, A5PSW_SYSTEM_TAGINFO(port)))
> 		a5psw_reg_rmw(a5psw, A5PSW_VLAN_IN_MODE_ENA, BIT(port), 0);
>=20
> VLAN-aware bridge ports without a PVID should drop untagged and VID-0-tag=
ged
> packets. However, as per your own comments:
>=20
> | > What does it mean to disable PVID?
> |=20
> | It means it disable the input tagging of packets with this PVID.
> | Incoming packets will not be modified and passed as-is.
>=20
> so this is not what happens.

Yes indeed, and we noticed the handling of VLANVERI and VLANDISC in
vlan_filtering() should be set according to the fact there is a PVID or
not (which is not the case right now).

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
