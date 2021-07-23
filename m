Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C243D3E36
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 19:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhGWQ2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 12:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhGWQ2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 12:28:23 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4474C061575
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 10:08:56 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1m6yfL-0003cr-AI; Fri, 23 Jul 2021 19:08:51 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1m6yfJ-0008Gy-0t; Fri, 23 Jul 2021 19:08:49 +0200
Date:   Fri, 23 Jul 2021 19:08:49 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Dan Murphy <dmurphy@ti.com>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v1 1/1] net: phy: dp83td510: Add basic support
 for the DP83TD510 Ethernet PHY
Message-ID: <20210723170848.lh3l62l7spcyphly@pengutronix.de>
References: <20210723104218.25361-1-o.rempel@pengutronix.de>
 <YPrCiIz7baU26kLU@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YPrCiIz7baU26kLU@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:45:05 up 233 days,  4:51, 30 users,  load average: 0.21, 0.12,
 0.10
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Fri, Jul 23, 2021 at 03:22:16PM +0200, Andrew Lunn wrote:
> On Fri, Jul 23, 2021 at 12:42:18PM +0200, Oleksij Rempel wrote:
> > The DP83TD510E is an ultra-low power Ethernet physical layer transceiver
> > that supports 10M single pair cable.
> > 
> > This driver provides basic support for this chip:
> > - link status
> > - autoneg can be turned off
> > - master/slave can be configured to be able to work without autoneg
> > 
> > This driver and PHY was tested with ASIX AX88772B USB Ethernet controller.
> 
> Hi Oleksij
> 
> There were patches flying around recently for another T1L PHY which
> added new link modes. Please could you work together with that patch
> to set the phydev features correctly to indicate this PHY is also a
> T1L, and if it support 2.4v etc.

ACK, thx. I was not able to spend enough time to investigate all needed
caps, so I decided to go mainline with limited functionality first.

> > +static int dp83td510_config_aneg(struct phy_device *phydev)
> > +{
> > +	u16 ctrl = 0, pmd_ctrl = 0;
> > +	int ret;
> > +
> > +	switch (phydev->master_slave_set) {
> > +	case MASTER_SLAVE_CFG_MASTER_FORCE:
> > +		if (phydev->autoneg) {
> > +			phydev->master_slave_set = MASTER_SLAVE_CFG_UNSUPPORTED;
> > +			phydev_warn(phydev, "Can't force master mode if autoneg is enabled\n");
> > +			goto do_aneg;
> > +		}
> > +		pmd_ctrl |= DP83TD510_PMD_CTRL_MASTER_MODE;
> > +		break;
> > +	case MASTER_SLAVE_CFG_SLAVE_FORCE:
> > +		if (phydev->autoneg) {
> > +			phydev->master_slave_set = MASTER_SLAVE_CFG_UNSUPPORTED;
> > +			phydev_warn(phydev, "Can't force slave mode if autoneg is enabled\n");
> > +			goto do_aneg;
> > +		}
> > +		break;
> > +	case MASTER_SLAVE_CFG_MASTER_PREFERRED:
> > +	case MASTER_SLAVE_CFG_SLAVE_PREFERRED:
> > +		phydev->master_slave_set = MASTER_SLAVE_CFG_UNSUPPORTED;
> > +		phydev_warn(phydev, "Preferred master/slave modes are not supported\n");
> > +		goto do_aneg;
> > +	case MASTER_SLAVE_CFG_UNKNOWN:
> > +	case MASTER_SLAVE_CFG_UNSUPPORTED:
> > +		goto do_aneg;
> > +	default:
> > +		phydev_warn(phydev, "Unsupported Master/Slave mode\n");
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	ret = dp83td510_modify(phydev, DP83TD510_PMA_PMD_CTRL,
> > +			       DP83TD510_PMD_CTRL_MASTER_MODE, pmd_ctrl);
> > +	if (ret)
> > +		return ret;
> > +
> > +do_aneg:
> > +	if (phydev->autoneg)
> > +		ctrl |= DP83TD510_AN_ENABLE;
> > +
> > +	ret = dp83td510_modify_changed(phydev, DP83TD510_AN_CONTROL,
> > +				       DP83TD510_AN_ENABLE, ctrl);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	/* Reset link if settings are changed */
> > +	if (ret)
> > +		ret = dp83td510_write(phydev, MII_BMCR, BMCR_RESET);
> > +
> > +	return ret;
> > +}
> > +
> > +static int dp83td510_strap(struct phy_device *phydev)
> > +{
> 
> > +	phydev_info(phydev,
> > +		    "bootstrap cfg: Pin 18: %s, Pin 30: %s, TX Vpp: %s, RX trap: %s, xMII mode: %s, PHY addr: 0x%x\n",
> > +		    pin18 ? "RX_DV" : "CRS_DV",
> > +		    pin30 ? "LED_1" : "CLKOUT",
> > +		    tx_vpp ? "1.0V p2p" : "2.4V & 1.0V p2p",
> > +		    rx_trap ? "< 40Ω" : "50Ω",
> > +		    dp83td510_get_xmii_mode_str(xmii_mode),
> > +		    addr);
> 
> What i learned reviewing the other T1L driver is that 2.4v operation
> seems to be something you negotiate. Yet i don't see anything about it
> in dp83td510_config_aneg() ?

voltage depends on the end application: cable length, safety requirements. I do
not see how this can be chosen only on auto negotiation. We would need proper
user space interface to let user/integrator set the limits.

May be IEEE 802.3cg (802.3-2019?) provides more information on how this should be
done. Do any one has access to it? I'll be happy to have it.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
