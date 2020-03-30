Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95A321973D4
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 07:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbgC3F0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 01:26:15 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:52073 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728445AbgC3F0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 01:26:15 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jImw9-0008CY-FM; Mon, 30 Mar 2020 07:26:13 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jImw7-0002A4-F1; Mon, 30 Mar 2020 07:26:11 +0200
Date:   Mon, 30 Mar 2020 07:26:11 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        linux-imx@nxp.com, kernel@pengutronix.de,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v2] ARM: imx: allow to disable board specific PHY fixups
Message-ID: <20200330052611.2bgu7x4nmimf7pru@pengutronix.de>
References: <20200329110457.4113-1-o.rempel@pengutronix.de>
 <20200329150854.GA31812@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200329150854.GA31812@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 07:03:38 up 135 days, 20:22, 141 users,  load average: 0.02, 0.06,
 0.02
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Sun, Mar 29, 2020 at 05:08:54PM +0200, Andrew Lunn wrote:
> On Sun, Mar 29, 2020 at 01:04:57PM +0200, Oleksij Rempel wrote:
> 
> Hi Oleksij
> 
> > +config DEPRECATED_PHY_FIXUPS
> > +	bool "Enable deprecated PHY fixups"
> > +	default y
> > +	---help---
> > +	  In the early days it was common practice to configure PHYs by adding a
> > +	  phy_register_fixup*() in the machine code. This practice turned out to
> > +	  be potentially dangerous, because:
> > +	  - it affects all PHYs in the system
> > +	  - these register changes are usually not preserved during PHY reset
> > +	    or suspend/resume cycle.
> > +	  - it complicates debugging, since these configuration changes were not
> > +	    done by the actual PHY driver.
> > +	  This option allows to disable all fixups which are identified as
> > +	  potentially harmful and give the developers a chance to implement the
> > +	  proper configuration via the device tree (e.g.: phy-mode) and/or the
> > +	  related PHY drivers.
> 
> This appears to be an IMX only problem. Everybody else seems to of got
> this right. There is no need to bother everybody with this new
> option. Please put this in arch/arm/mach-mxs/Kconfig and have IMX in
> the name.

Actually, all fixups seems to do wring thing:
arch/arm/mach-davinci/board-dm644x-evm.c:915:		phy_register_fixup_for_uid(LXT971_PHY_ID, LXT971_PHY_MASK,

Increased MII drive strength. Should be probably enabled by the PHY
driver.

arch/arm/mach-imx/mach-imx6q.c:167:		phy_register_fixup_for_uid(PHY_ID_KSZ9021, MICREL_PHY_ID_MASK,
arch/arm/mach-imx/mach-imx6q.c:169:		phy_register_fixup_for_uid(PHY_ID_KSZ9031, MICREL_PHY_ID_MASK,
arch/arm/mach-imx/mach-imx6q.c:171:		phy_register_fixup_for_uid(PHY_ID_AR8031, 0xffffffef,
arch/arm/mach-imx/mach-imx6q.c:173:		phy_register_fixup_for_uid(PHY_ID_AR8035, 0xffffffef,
arch/arm/mach-imx/mach-imx6sx.c:40:		phy_register_fixup_for_uid(PHY_ID_AR8031, 0xffffffff,
arch/arm/mach-imx/mach-imx6ul.c:47:		phy_register_fixup_for_uid(PHY_ID_KSZ8081, MICREL_PHY_ID_MASK,
arch/arm/mach-imx/mach-imx7d.c:54:		phy_register_fixup_for_uid(PHY_ID_AR8031, 0xffffffff,
arch/arm/mach-imx/mach-imx7d.c:56:		phy_register_fixup_for_uid(PHY_ID_BCM54220, 0xffffffff,
arch/arm/mach-mxs/mach-mxs.c:262:		phy_register_fixup_for_uid(PHY_ID_KSZ8051, MICREL_PHY_ID_MASK,

Fix in some random manner PHY specific errata, enable clock output and
configure the clock skew.

arch/arm/mach-orion5x/dns323-setup.c:645:		phy_register_fixup_for_uid(MARVELL_PHY_ID_88E1118,

Enable LED. Should be done in DT if supported.

arch/powerpc/platforms/85xx/mpc85xx_mds.c:305:		phy_register_fixup_for_id(phy_id, mpc8568_fixup_125_clock);
arch/powerpc/platforms/85xx/mpc85xx_mds.c:306:		phy_register_fixup_for_id(phy_id, mpc8568_mds_phy_fixups);
arch/powerpc/platforms/85xx/mpc85xx_mds.c:311:		phy_register_fixup_for_id(phy_id, mpc8568_mds_phy_fixups);

Fix in some random manner PHY specific errata, enable clock output and
configure the clock skew.

drivers/net/ethernet/dnet.c:818:	err = phy_register_fixup_for_uid(0x01410cc0, 0xfffffff0,

Enable LED. Should be done in DT if supported.

drivers/net/usb/lan78xx.c:2071:		ret = phy_register_fixup_for_uid(PHY_KSZ9031RNX, 0xfffffff0,
drivers/net/usb/lan78xx.c:2078:		ret = phy_register_fixup_for_uid(PHY_LAN8835, 0xfffffff0,

enable clock output and configure the clock skew.

As we can see, all of used fixups seem to be wrong. For example micrel
PHY errata should be fixed in one place for all devices. Not only for
some iMX6 SoC. I used this option for iMX, because i can test it.

> There is no need to bother everybody with this new
> option. Please put this in arch/arm/mach-mxs/Kconfig and have IMX in
> the name.

A lot of work is needed to fix all of them. I just do not have enough
time to do it.

> Having said that, i'm not sure this is the best solution. You cannot
> build one kernel which runs on all machines.  Did you consider some
> sort of DT property to disable these fixup? What other ideas did you
> have before deciding on this solution?

As soon as all PHY driver support all needed bits used in this fixups,
we can use drivers on top of fixups. Since changes made by fixups will
be overwritten by PHY drivers any way. The Kconfig option is needed only for
developers who has enough resource to investigate this issues and
mainline needed changes.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
