Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD322377EDA
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 11:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhEJJDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 05:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhEJJDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 05:03:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFD3C061573
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 02:02:48 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lg1oF-0002FD-B8; Mon, 10 May 2021 11:02:39 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lg1oD-0003wE-N7; Mon, 10 May 2021 11:02:37 +0200
Date:   Mon, 10 May 2021 11:02:37 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: Re: [RFC PATCH v1 2/9] net: dsa: microchip: ksz8795: add phylink
 support
Message-ID: <20210510090237.dbrkpfd7eioi5eat@pengutronix.de>
References: <20210505092025.8785-1-o.rempel@pengutronix.de>
 <20210505092025.8785-3-o.rempel@pengutronix.de>
 <20210506132855.fv4dqagjg3zfue3i@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210506132855.fv4dqagjg3zfue3i@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:50:04 up 158 days, 22:56, 47 users,  load average: 0.34, 0.16,
 0.06
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Thu, May 06, 2021 at 04:28:55PM +0300, Vladimir Oltean wrote:
> On Wed, May 05, 2021 at 11:20:18AM +0200, Oleksij Rempel wrote:
> > From: Michael Grzeschik <m.grzeschik@pengutronix.de>
> > 
> > This patch adds the phylink support to the ksz8795 driver, since
> > phylib is obsolete for dsa drivers.
> > 
> > Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  drivers/net/dsa/microchip/ksz8795.c | 73 +++++++++++++++++++++++++++++
> >  1 file changed, 73 insertions(+)
> > 
> > diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
> > index 4ca352fbe81c..0ddaf2547f18 100644
> > --- a/drivers/net/dsa/microchip/ksz8795.c
> > +++ b/drivers/net/dsa/microchip/ksz8795.c
> > @@ -18,6 +18,7 @@
> >  #include <linux/micrel_phy.h>
> >  #include <net/dsa.h>
> >  #include <net/switchdev.h>
> > +#include <linux/phylink.h>
> >  
> >  #include "ksz_common.h"
> >  #include "ksz8795_reg.h"
> > @@ -1420,11 +1421,83 @@ static int ksz8_setup(struct dsa_switch *ds)
> >  	return 0;
> >  }
> >  
> > +static int ksz_get_state(struct dsa_switch *ds, int port,
> > +					  struct phylink_link_state *state)
> > +{
> > +	struct ksz_device *dev = ds->priv;
> > +	struct ksz8 *ksz8 = dev->priv;
> > +	const u8 *regs = ksz8->regs;
> > +	u8 speed, link;
> > +
> > +	ksz_pread8(dev, port, regs[P_LINK_STATUS], &link);
> > +	ksz_pread8(dev, port, regs[P_SPEED_STATUS], &speed);
> > +
> > +	state->link = !!(link & PORT_STAT_LINK_GOOD);
> > +	if (state->link) {
> > +		state->speed =
> > +			(speed & PORT_STAT_SPEED_100MBIT) ? SPEED_100 : SPEED_10;
> > +		state->duplex =
> > +			(speed & PORT_STAT_FULL_DUPLEX) ? DUPLEX_FULL : DUPLEX_HALF;
> > +	}
> > +
> > +	return 0;
> > +}
> 
> How does the port know the speed?

PHY and switch control registers are mixed on this switch, so we have
access to the PHY bits directly over switch control registers.
On other hand, we provide proper PHY abstraction and there is no need to
provide this function at all. I'll remove it.

> > +
> > +static void ksz_validate(struct dsa_switch *ds, int port,
> > +			       unsigned long *supported,
> > +			       struct phylink_link_state *state)
> 
> Indentation looks odd.
> Also, I expect that not all KSZ PHYs to have the same validation
> function, so maybe you should call this ksz8_phylink_validate.

done

> > +{
> > +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> > +	struct ksz_device *dev = ds->priv;
> > +
> > +	if (port == dev->cpu_port) {
> > +		if ((state->interface != PHY_INTERFACE_MODE_RMII) &&
> > +		   (state->interface != PHY_INTERFACE_MODE_MII))
> > +			goto unsupported;
> 
> The phylink API says that when .validate is called with state->interface
> as PHY_INTERFACE_MODE_NA, you should report all supported capabilities.

done

> > +	} else if (port > dev->port_cnt) {
> > +		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
> > +		dev_err(ds->dev, "Unsupported port: %i\n", port);
> > +		return;
> > +	} else {
> > +		if (state->interface != PHY_INTERFACE_MODE_INTERNAL)
> > +			goto unsupported;
> > +	}
> > +
> > +	/* Allow all the expected bits */
> > +	phylink_set_port_modes(mask);
> > +	phylink_set(mask, Autoneg);
> > +
> > +	phylink_set(mask, Pause);
> > +	/* Silicon Errata Sheet (DS80000830A): Asym_Pause limit to port 2 */
> > +	if (port || !ksz_is_ksz88x3(dev))
> > +		phylink_set(mask, Asym_Pause);
> 
> The code doesn't seem to match the comment? If the switch is a KSZ88x3,
> ASM_DIR will be advertised for all ports except port 0, is this what you
> want?

good point, no. Fixed.

> > +
> > +	/* 10M and 100M are only supported */
> > +	phylink_set(mask, 10baseT_Half);
> > +	phylink_set(mask, 10baseT_Full);
> > +	phylink_set(mask, 100baseT_Half);
> > +	phylink_set(mask, 100baseT_Full);
> > +
> > +	bitmap_and(supported, supported, mask,
> > +		   __ETHTOOL_LINK_MODE_MASK_NBITS);
> > +	bitmap_and(state->advertising, state->advertising, mask,
> > +		   __ETHTOOL_LINK_MODE_MASK_NBITS);
> > +
> > +	return;
> > +
> > +unsupported:
> > +	bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
> > +	dev_err(ds->dev, "Unsupported interface: %d, port: %d\n",
> > +		state->interface, port);
> 
> %s, phy_modes(state->interface)

done

> > +}
> > +
> >  static const struct dsa_switch_ops ksz8_switch_ops = {
> >  	.get_tag_protocol	= ksz8_get_tag_protocol,
> >  	.setup			= ksz8_setup,
> >  	.phy_read		= ksz_phy_read16,
> >  	.phy_write		= ksz_phy_write16,
> > +	.phylink_validate	= ksz_validate,
> > +	.phylink_mac_link_state	= ksz_get_state,
> >  	.phylink_mac_link_down	= ksz_mac_link_down,
> >  	.port_enable		= ksz_enable_port,
> >  	.get_strings		= ksz8_get_strings,
> > -- 
> > 2.29.2
> > 
> 
> 

Regards,
Oleksij

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
