Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA98600FD7
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 15:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbiJQNEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 09:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbiJQNEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 09:04:07 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73255F22C
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 06:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=UKBi0FNN9u33tTEw8/XVN/EAYN1acJAaABnam46l1A8=; b=3+B7ffxagQ6K3ft7ZCWaYK6ydi
        WqqcYcfeLUc294sTy2OO7w8pgSoijuT8dJukiuiwCfD7PAx6lH0At1GY7ITLLENcOvjpwPeMt+/CL
        cQ8Xn8XZ6J62gmJxBIj6mb4+qRpdyhIpV6x47ZFEwRCJIU2qeT04RKf9rvBl3IN0QJbc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1okPmh-002E5o-86; Mon, 17 Oct 2022 15:03:59 +0200
Date:   Mon, 17 Oct 2022 15:03:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
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
Message-ID: <Y01Sv63B5ijqD48a@lunn.ch>
References: <20221017105100.0cb33490@pc-8.home>
 <Y00fYeZEcG/E3FPV@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y00fYeZEcG/E3FPV@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 17, 2022 at 10:24:49AM +0100, Russell King (Oracle) wrote:
> On Mon, Oct 17, 2022 at 10:51:00AM +0200, Maxime Chevallier wrote:
> > 2) Changes in Phylink
> > 
> > This might be the tricky part, as we need to track several ports,
> > possibly connected to different PHYs, to get their state. For now, I
> > haven't prototyped any of this yet.
> 
> The problem is _way_ larger than phylink. It's a fundamental throughout
> the net layer that there is one-PHY to one-MAC relationship. Phylink
> just adopts this because it is the established norm, and trying to fix
> it is rather rediculous without a use case.
> 
> See code such as the ethtool code, where the MAC and associated layers
> are# entirely bypassed with all the PHY-accessing ethtool commands and
> the commands are passed directly to phylib for the PHY registered
> against the netdev.

We probably need to model the MII MUX. We can then have netdev->phydev
and netdev->sfp_bus point to the MUX, which then defers to the
currently active PHY/SFP for backwards compatibility. Additionally,
for netlink ethtool, we can add a new property which allows a specific
PHY/SFP hanging off the MUX to be addressed.

Modeling the MUX probably helps us with the overall architecture.  As
Maxime described, there are at least two different architectures: the
MUX is between the MAC and the PHYs, and the MUX is inside the PHY
between the host interface and the line interfaces. There are at least
4 PHYs like this.

We also have Russells problem of two PHYs on one path. It would be
nice to solve that at the same time, which the additional identifier
attribute should help solve.

I would probably start this work from the uAPI. How does the uAPI
work?

	Andrew
