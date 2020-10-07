Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA043285D27
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbgJGKsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbgJGKsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 06:48:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC36C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 03:48:02 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kQ6zG-0000iq-Ac; Wed, 07 Oct 2020 12:47:58 +0200
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1kQ6zF-00053K-EB; Wed, 07 Oct 2020 12:47:57 +0200
Date:   Wed, 7 Oct 2020 12:47:57 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Marek Vasut <marex@denx.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        kernel@pengutronix.de, David Jander <david@protonic.nl>
Subject: Re: PHY reset question
Message-ID: <20201007104757.fntgjiwt4tst3w3f@pengutronix.de>
References: <20201006080424.GA6988@pengutronix.de>
 <2cc5ea02-707e-dbb5-c081-4c5202bd5815@gmail.com>
 <42d4c4b2-d3ea-9130-ef7f-3d1955116fdc@denx.de>
 <0687984c-5768-7c71-5796-8e16169f5192@gmail.com>
 <20201007081410.jk5fi6x5w3ab3726@pengutronix.de>
 <7edb2e01-bec5-05b0-aa47-caf6e214e5a0@denx.de>
 <20201007090636.t5rsus3tnkwuekjj@pengutronix.de>
 <2b6a1616-beb8-fd12-9932-1e7d1ef04769@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b6a1616-beb8-fd12-9932-1e7d1ef04769@denx.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:15:08 up 327 days,  1:33, 362 users,  load average: 0.26, 0.20,
 0.10
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20-10-07 11:20, Marek Vasut wrote:
> On 10/7/20 11:06 AM, Marco Felsch wrote:

...

> > You're right, just wanted to provide you a link :)
> 
> Can you CC me on the next version of those patches ? I seems the LAN8710
> is causing grief to many.

No need to since this serie was already applied.

> >> but isn't the
> >> last patch 5/5 breaking existing setups ?
> > 
> > IMHO the solution proposed using the PHY_RST_AFTER_CLK_EN was wrong so
> > we needed to fix that. Yes we need to take care of DT backward
> > compatibility but we still must be able to fix wrong behaviours within
> > the driver. I could also argue that PHY_RST_AFTER_CLK_EN solution was
> > breaking exisitng setups too.
> > 
> >> The LAN8710 surely does need
> >> clock enabled before the reset line is toggled.
> > 
> > Yep and therefore you can specify it yet within the DT.
> 
> So the idea is that the PHY enables the clock for itself . And if the
> MAC doesn't export these clock as clk to which you can refer to in DT,
> then you still need the PHY_RST_AFTER_CLK_EN flag, so the MAC can deal
> with enabling the clock ? Or is the idea to fix the MAC drivers too ?

First we need to consider that the PHY_RST_AFTER_CLK_EN flag gets only
handled by the imx-fec driver currently. This particular MAC driver
don't provide clks instead it is just a clock consumer. The clock is
coming from the clock driver and the clk-id is IMX6QDL_CLK_ENET_REF. If
the imx host is the clock provider for smsc-phy you need to specify that
clock-id. There are other phy-drivers using the same mechanism currently.
But yes, you need at least one clock provider. My solution is not
complete as Florian proposal [1] since it rely on the fact that the MAC
enables all clocks before probing the mdio bus. Luckily the imx-fec
driver has this behaviour and my patches are valid till Florian's
patches are merged. Resetting the phy should only be done within the phy
state machine and not from outside without respecting the phy state
since this can cause undefined behaviours.

Florian did you send a new version of those patches?

[1] https://www.spinics.net/lists/netdev/msg680412.html
