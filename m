Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A89C602A7F
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 13:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiJRLp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 07:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiJRLp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 07:45:56 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7CC3B40E2
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 04:45:54 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 21B2F60008;
        Tue, 18 Oct 2022 11:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666093553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=foqT3NAnuG1A67EIZZREcFShvqHNGhgtMHvlC41QDNQ=;
        b=jE87XLA/2qSt48gbFPp4XbsbR24R1mdE943v/8/bHn6VGBZcA6BiXclBs6rg9YEZkuCvxo
        3Au1A7xZS46mxMGoD6SzXp7Du50O6gGGwqRwv5ig0b3+QhSZmR5wfMl9BW0aHbuXzSZ2ff
        hcxDz6rb1HrRfso6BQHmrf2Ur1wqbKL7s00BwKn7s1RgID2ZXdGgHGjo15AVb71p13jQt6
        VOnP1oXo/G9aSKG13ogKSoI+A5FeSiR0DWYHL1C6VAgOHj8gT6bZrM4Qc8kkHi+IA7mClr
        p34V0FvtlXWrrK5ODytYe+F7+2T9v0T0V4v/hw6C96A13gH5uLswAwpcSB4AGg==
Date:   Tue, 18 Oct 2022 13:45:47 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Antoine Tenart <atenart@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: Multi-PHYs and multiple-ports bonding support
Message-ID: <20221018134547.18a7e36e@pc-8.home>
In-Reply-To: <Y01Sv63B5ijqD48a@lunn.ch>
References: <20221017105100.0cb33490@pc-8.home>
        <Y00fYeZEcG/E3FPV@shell.armlinux.org.uk>
        <Y01Sv63B5ijqD48a@lunn.ch>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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

Hello Andrew,

On Mon, 17 Oct 2022 15:03:59 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> On Mon, Oct 17, 2022 at 10:24:49AM +0100, Russell King (Oracle) wrote:
> > On Mon, Oct 17, 2022 at 10:51:00AM +0200, Maxime Chevallier wrote: =20
> > > 2) Changes in Phylink
> > >=20
> > > This might be the tricky part, as we need to track several ports,
> > > possibly connected to different PHYs, to get their state. For
> > > now, I haven't prototyped any of this yet. =20
> >=20
> > The problem is _way_ larger than phylink. It's a fundamental
> > throughout the net layer that there is one-PHY to one-MAC
> > relationship. Phylink just adopts this because it is the
> > established norm, and trying to fix it is rather rediculous without
> > a use case.
> >=20
> > See code such as the ethtool code, where the MAC and associated
> > layers are# entirely bypassed with all the PHY-accessing ethtool
> > commands and the commands are passed directly to phylib for the PHY
> > registered against the netdev. =20
>=20
> We probably need to model the MII MUX. We can then have netdev->phydev
> and netdev->sfp_bus point to the MUX, which then defers to the
> currently active PHY/SFP for backwards compatibility. Additionally,
> for netlink ethtool, we can add a new property which allows a specific
> PHY/SFP hanging off the MUX to be addressed.

That's a good idea ! I find it pretty elegant indeed, and would be the
right place to implement the switching logic too.

> Modeling the MUX probably helps us with the overall architecture.  As
> Maxime described, there are at least two different architectures: the
> MUX is between the MAC and the PHYs, and the MUX is inside the PHY
> between the host interface and the line interfaces. There are at least
> 4 PHYs like this.
>=20
> We also have Russells problem of two PHYs on one path. It would be
> nice to solve that at the same time, which the additional identifier
> attribute should help solve.
>=20
> I would probably start this work from the uAPI. How does the uAPI
> work?

=46rom the doc of struct ethtool_link_setting, there seems to be an
attempt to support that already :

"* Some hardware interfaces may have multiple PHYs and/or physical
 * connectors fitted or do not allow the driver to detect which are
 * fitted.  For these interfaces @port and/or @phy_address may be
 * writable, possibly dependent on @autoneg being %AUTONEG_DISABLE.
 * Otherwise, attempts to write different values may be ignored or
 * rejected.
"

https://elixir.bootlin.com/linux/latest/source/include/uapi/linux/ethtool.h=
#L2047

However, this doesn't allow to enumerate clearly the interfaces
available, and it relies on the mdio address + port. This doesn't
address the chained PHYs as we don't have a clear view of the topology
(but do we need to ?)

I like very much the concept of having a way to address the interfaces
or the parts of the link chain.

Could we introduce a new ethtool cmd, allowing to enumerate the
ports and discover the topology, and another one to get an equivalent
of the ethtool_link_settings for each block in the chain ?

I'll try to prototype a few things to get a clearer picture...

Thanks a lot for your input,

Maxime

> 	Andrew

