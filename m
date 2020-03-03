Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B127B177A99
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 16:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730053AbgCCPgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 10:36:42 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:43451 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730046AbgCCPgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 10:36:42 -0500
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1j99b3-0000hX-Jg; Tue, 03 Mar 2020 16:36:37 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1j99b1-0000Xn-7U; Tue, 03 Mar 2020 16:36:35 +0100
Date:   Tue, 3 Mar 2020 16:36:35 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        Quentin Schulz <quentin.schulz@bootlin.com>
Subject: Re: [PATCH v1] net: phy: tja11xx: add TJA1102 support
Message-ID: <20200303153635.hiojz5hrj2hhlggt@pengutronix.de>
References: <20200303073715.32301-1-o.rempel@pengutronix.de>
 <20200303135936.GG31977@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200303135936.GG31977@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:16:05 up 109 days,  6:34, 140 users,  load average: 0.32, 0.14,
 0.17
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 02:59:36PM +0100, Andrew Lunn wrote:
> Hi Oleksij
> 
> > TJA1102 is an dual T1 PHY chip. Both PHYs are separately addressable.
> > PHY 0 can be identified by PHY ID. PHY 1 has no PHY ID and can be
> > configured in device tree by setting compatible =
> > "ethernet-phy-id0180.dc81".
> 
> Why-o-why do silicon vendors make devices with invalid PHY IDs!?!?!
> 
> Did you try avoiding the compatible string. We know PHY 0 will probe
> as normal. From its PHY ID we know it is a dual device. Could the
> probe of PHY 0 register PHY 1?
> 
> No idea if it will work, but could nxp-tja11xx.c register is fixup for
> PHY_ID_TJA1102. That fixup would do something like:
> 
> void tja1102_fixup(struct phy_device *phydev_phy0)
> {
>         struct mii_bus *bus = phydev_phy0->mdio.mii;
>         struct phy_device *phydev_phy1;
> 
>         phydev_phy1 = phy_device_create(bus, phydev_phy0->addr + 1,
>                                         PHY_ID_TJA1102, FALSE, NULL);
> 	if (phydev_phy1)
>                phy_device_register(phydev_phy1);
> }
> 
> I think the issue here is, it will deadlock when scanning for fixup
> for phydev_phy1. So this basic idea, but maybe hooked in somewhere
> else?
> 
> Something like this might also help vsc8584 which is a quad PHY with
> some shared registers?

OK, thx! I'll take a look on it.
Currently there is not solved issues with controlled power on/reset sequence
of this chip. The reset and enable pins will affect both PHYs. So, may be vsc8584
will answer my questions.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
