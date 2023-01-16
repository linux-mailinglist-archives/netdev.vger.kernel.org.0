Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4099D66B8C8
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 09:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbjAPIIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 03:08:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbjAPIIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 03:08:06 -0500
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EBE312060;
        Mon, 16 Jan 2023 00:06:29 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B40B3FF803;
        Mon, 16 Jan 2023 08:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1673856388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jKlqXRziLzS7Xh6vcawTt0PG/It1v0slhKbICt31lUQ=;
        b=GKM/ipfMwzxvNvBkS2EmIVMLbKO5PqeE8Bj45ZxnA8pUUYbgJ9G0fh9ekxdn8drbt8UgKj
        qjRFMeup/uk4imU22mKV7vUhcNCv+un9Bo2VXenVlmRXHGlxbWBJmYaf5OBXosqIYCf2N7
        vZZDgP4Wen0f2kltgpgIGUQigSqwphxM79QmBGoIDDrSSYyQmR3t9BLNh3RHJCKEDAqWiL
        VMpIpFZlsdhbMJp2Pf8IfCiVxc/pptGJQCgCHsnRkFLhO9ou/7wK01MQLu6IYdFvCVKI1q
        RlKhYwTEqD9mauyiq+PZzFzL9Kuuid/FEw4svtlVXWJ0gmoyGEC9sD68V/eaIA==
Date:   Mon, 16 Jan 2023 09:08:37 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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
Message-ID: <20230116090837.105b42a9@fixe.home>
In-Reply-To: <20230113153730.bcj5iqkgilgmgds3@skbuf>
References: <20230111115607.1146502-1-clement.leger@bootlin.com>
        <20230112213755.42f6cf75@kernel.org>
        <Y8Fm2GdUF9R1asZs@lunn.ch>
        <20230113153730.bcj5iqkgilgmgds3@skbuf>
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

Le Fri, 13 Jan 2023 17:37:30 +0200,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> On Fri, Jan 13, 2023 at 03:12:40PM +0100, Andrew Lunn wrote:
> > On Thu, Jan 12, 2023 at 09:37:55PM -0800, Jakub Kicinski wrote: =20
> > > On Wed, 11 Jan 2023 12:56:07 +0100 Cl=C3=A9ment L=C3=A9ger wrote: =20
> > > > Add support for vlan operation (add, del, filtering) on the RZN1
> > > > driver. The a5psw switch supports up to 32 VLAN IDs with filtering,
> > > > tagged/untagged VLANs and PVID for each ports. =20
> > >=20
> > > noob question - do you need that mutex?=20
> > > aren't those ops all under rtnl_lock? =20
> >=20
> > Hi Jakub
> >=20
> > Not commenting about this specific patch, but not everything in DSA is
> > done under RTNL. So you need to deal with some parallel API calls. But
> > they tend to be in different areas. I would not expect to see two VLAN
> > changes as the same time, but maybe VLAN and polling in a workqueue to
> > update the statistics for example could happen. Depending on the
> > switch, some protect might be needed to stop these operations
> > interfering with each other. And DSA drivers in general tend to KISS
> > and over lock. Nothing here is particularly hot path, the switch
> > itself is on the end of a slow bus, so the overhead of locks are
> > minimum. =20
>=20
> That being said, port_vlan_add(), port_vlan_del() and port_vlan_filtering=
()
> are all serialized by the rtnl_lock().

Ok then, I'll remove this lock and rely on the RTNL lock.

Thanks,

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
