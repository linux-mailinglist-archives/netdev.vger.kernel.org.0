Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F29AF690251
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 09:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjBIImH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 03:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjBIImG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 03:42:06 -0500
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB8F2C64B;
        Thu,  9 Feb 2023 00:42:02 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 4D32FE000B;
        Thu,  9 Feb 2023 08:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675932120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ooVzYxiM4t9AebCSCVJ70rAuJCUUUwE+rUOXUOUgcxM=;
        b=gstnFl6MBRr8xq0O17JVgbC1YKDk12nT78/vBDZ4dmM39tT3igbzZ8jeCjdF/Cxjhe6iF/
        UgGVXO9IqWJ1+PZXQnCXHbWyLRDbOg3pE1UvG0AU3UEALIZ0K0mib7BcwMO45uuCHruW9k
        fedjyeDwdrrDzQd5dxbPku7/DY6S8VJXMjQCC9w5M3QJ5KyRmg6FdGSuJ6Ul5pOeWcbxs8
        wqgIJIkS+zpGk7rinikMpK/ejKUlRf6P+oE4BjnyQ0OX6NIhqW4+12Bema7q8gVfMChtm5
        sd+8EHTtUJ0Il6FLWzVDrJxzWjP4/QVUFC2fTwpiCgPIYLgg2NO9aO5Ptm+mww==
Date:   Thu, 9 Feb 2023 09:44:22 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
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
Message-ID: <20230209094422.3905428c@fixe.home>
In-Reply-To: <20230208220219.t7nejekbmqu7vv75@skbuf>
References: <20230208161749.331965-1-clement.leger@bootlin.com>
        <20230208161749.331965-4-clement.leger@bootlin.com>
        <317ec9fc-87de-2683-dfd4-30fe94e2efd7@gmail.com>
        <20230208220219.t7nejekbmqu7vv75@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-pc-linux-gnu)
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

Le Thu, 9 Feb 2023 00:02:19 +0200,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> On Wed, Feb 08, 2023 at 09:38:04AM -0800, Florian Fainelli wrote:
> > > +	/* Enable TAG always mode for the port, this is actually controlled
> > > +	 * by VLAN_IN_MODE_ENA field which will be used for PVID insertion
> > > +	 */
> > > +	reg =3D A5PSW_VLAN_IN_MODE_TAG_ALWAYS;
> > > +	reg <<=3D A5PSW_VLAN_IN_MODE_PORT_SHIFT(port);
> > > +	a5psw_reg_rmw(a5psw, A5PSW_VLAN_IN_MODE, A5PSW_VLAN_IN_MODE_PORT(po=
rt),
> > > +		      reg); =20
> >=20
> > If we always enable VLAN mode, which VLAN ID do switch ports not part o=
f a
> > VLAN aware bridge get classified into? =20
>=20
> Good question. I'd guess 0, since otherwise, the VLAN-unaware FDB
> entries added with a5psw_port_fdb_add() wouldn't work.

The name of the mode is probably missleading. When setting VLAN_IN_MODE
with A5PSW_VLAN_IN_MODE_TAG_ALWAYS, the input packet will be tagged
_only_ if VLAN_IN_MODE_ENA port bit is set. If this bit is not set,
packet will passthrough transparently. This bit is actually enabled in
a5psw_port_vlan_add() when a PVID is set and unset when the PVID is
removed. Maybe the comment above these lines was not clear enough.

>=20
> But the driver has to survive the following chain of commands, which, by
> looking at the current code structure, it doesn't:
>=20
> ip link add br0 type bridge vlan_filtering 0
> ip link set swp0 master br0 # PVID should remain at a value chosen privat=
ely by the driver
> bridge vlan add dev swp0 vid 100 pvid untagged # PVID should not change i=
n hardware yet
> ip link set br0 type bridge vlan_filtering 1 # PVID should change to 100 =
now
> ip link set br0 type bridge vlan_filtering 0 # PVID should change to the =
value chosen by the driver
>=20
> Essentially, what I'm saying is that VLANs added with "bridge vlan add"
> should only be active while vlan_filtering=3D1.
>=20
> If you search for "commit_pvid" in drivers/net/dsa, you'll find a number
> of drivers which have a more elaborate code structure which allows the
> commands above to work properly.



--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
