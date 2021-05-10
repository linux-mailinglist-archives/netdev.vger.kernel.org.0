Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A15377F25
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 11:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhEJJMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 05:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbhEJJMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 05:12:12 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECAD9C061760
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 02:11:06 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lg1wK-0003Lz-7I; Mon, 10 May 2021 11:11:00 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lg1wJ-0004iW-PC; Mon, 10 May 2021 11:10:59 +0200
Date:   Mon, 10 May 2021 11:10:59 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: [RFC PATCH v1 5/9] net: phy: micrel: ksz886x add MDI-X support
Message-ID: <20210510091059.de2ahmmoyzggzqaq@pengutronix.de>
References: <20210505092025.8785-1-o.rempel@pengutronix.de>
 <20210505092025.8785-6-o.rempel@pengutronix.de>
 <YJKRj2tD0rPd+S0j@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YJKRj2tD0rPd+S0j@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:07:30 up 158 days, 23:13, 47 users,  load average: 0.08, 0.07,
 0.04
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 05, 2021 at 02:37:35PM +0200, Andrew Lunn wrote:
> > +/* Device specific MII_BMCR (Reg 0) bits */
> > +/* 1 = HP Auto MDI/MDI-X mode, 0 = Microchip Auto MDI/MDI-X mode */
> > +#define KSZ886X_BMCR_HP_MDIX			BIT(5)
> > +/* 1 = Force MDI (transmit on RXP/RXM pins), 0 = Normal operation
> > + * (transmit on TXP/TXM pins)
> > + */
> > +#define KSZ886X_BMCR_FORCE_MDI			BIT(4)
> > +/* 1 = Disable auto MDI-X */
> > +#define KSZ886X_BMCR_DISABLE_AUTO_MDIX		BIT(3)
> > +#define KSZ886X_BMCR_DISABLE_FAR_END_FAULT	BIT(2)
> > +#define KSZ886X_BMCR_DISABLE_TRANSMIT		BIT(1)
> > +#define KSZ886X_BMCR_DISABLE_LED		BIT(0)
> 
> Do these have the same values as what you added in patch 1?

ACK, i'll move it

> > +static int ksz886x_config_mdix(struct phy_device *phydev, u8 ctrl)
> > +{
> > +	u16 val;
> > +
> > +	switch (ctrl) {
> > +	case ETH_TP_MDI:
> > +		val = KSZ886X_BMCR_DISABLE_AUTO_MDIX;
> > +		break;
> > +	case ETH_TP_MDI_X:
> > +		/* Note: The naming of the bit KSZ886X_BMCR_FORCE_MDI is bit
> > +		 * counter intuitive, the "-X" in "1 = Force MDI" in the data
> > +		 * sheet seems to be missing:
> > +		 * 1 = Force MDI (sic!) (transmit on RX+/RX- pins)
> > +		 * 0 = Normal operation (transmit on TX+/TX- pins)
> > +		 */
> > +		val = KSZ886X_BMCR_DISABLE_AUTO_MDIX | KSZ886X_BMCR_FORCE_MDI;
> > +		break;
> > +	case ETH_TP_MDI_AUTO:
> > +		val = 0;
> > +		break;
> > +	default:
> > +		return 0;
> > +	}
> > +
> > +	return phy_modify(phydev, MII_BMCR,
> > +			  KSZ886X_BMCR_HP_MDIX | KSZ886X_BMCR_FORCE_MDI |
> > +			  KSZ886X_BMCR_DISABLE_AUTO_MDIX,
> > +			  KSZ886X_BMCR_HP_MDIX | val);
> > +}
> 
> Maybe this will also work for the PHY driver embedded in ksz8795.c?
> Maybe as another patchset, see if that PHY driver can be moved out of the DSA driver,
> and share some code with this driver?

Hm, i'm sure it can be done, but right now i have no access to ksz8795
hardware. I'll keep it in mind.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
