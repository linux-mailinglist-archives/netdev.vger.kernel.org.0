Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E22468F0DD
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 15:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbjBHObu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 09:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbjBHObr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 09:31:47 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC005188;
        Wed,  8 Feb 2023 06:31:45 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A5A6010000E;
        Wed,  8 Feb 2023 14:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675866704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=irdGRSt4Z7sX+S6Tk9I9NCh4/p/qTN/4YFULPPNe5Ak=;
        b=Re5BF/TNXUaVNt35ua0Ak9KiwLD3VAQNgjL9sbPsebXU4Tj4v/UfffST3/BDJsqz3sLZ+3
        TyjHpLOcFKTRqOMczcsBtQft5sfVmg+mr3rZjM5FTeaWp4S6aOrdGvD3R2fA0wZ8OFsg3z
        LMJO1isSfllUwXhffX2Z2du+9JJi3lklWdAxIvZtdFDzt0vmbizjJMGzOmQHr8ak8yuYpG
        AjPcGAnRTmkyS5CTSe6zPUPN1y3t5qnpK5Pc5oTjalyWxmtibe6iB1BOUbOlM+jfgokcCc
        3TwBCWBykz1Z+9rHEzgu2TKJsCLG7L4N64KzMYWWrauq0BObHXacT6DnmohplQ==
Date:   Wed, 8 Feb 2023 15:33:56 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>
Subject: Re: [PATCH net-next] net: dsa: rzn1-a5psw: Add vlan support
Message-ID: <20230208153356.619356d2@fixe.home>
In-Reply-To: <20230116101914.2998445b@fixe.home>
References: <20230111115607.1146502-1-clement.leger@bootlin.com>
        <20230113151248.22xexjyxmlyeeg7r@skbuf>
        <20230116101914.2998445b@fixe.home>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Mon, 16 Jan 2023 10:19:14 +0100,
Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com> a =C3=A9crit :

> Le Fri, 13 Jan 2023 17:12:48 +0200,
> Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :
>=20
> > On Wed, Jan 11, 2023 at 12:56:07PM +0100, Cl=C3=A9ment L=C3=A9ger wrote=
: =20
> > > Add support for vlan operation (add, del, filtering) on the RZN1
> > > driver. The a5psw switch supports up to 32 VLAN IDs with filtering,
> > > tagged/untagged VLANs and PVID for each ports.
> > >=20
> > > Signed-off-by: Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com>
> > > ---   =20
> >=20
> > Have you run the bridge_vlan_aware.sh and bridge_vlan_unaware.sh from
> > tools/testing/selftests/drivers/net/dsa/? =20
>=20
> Nope, I will do that.
>=20

Finally found the time to run them and both bridge_vlan_aware.sh and
bridge_vlan_unaware.sh all tests yields a [ OK ] status.

I'll resubmit a V2 with Arun Ramadoss comments fixed.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
