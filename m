Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E94230E53
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 17:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731028AbgG1Pqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 11:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730856AbgG1Pqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 11:46:34 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EADCC061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 08:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NNIi+FcnYoSTzgRPH16GvXbjEMRt0yQ2D368FRkKPLo=; b=z93AZwZIr3kYEUk81Y1QXzF9T
        TdWJScHfjariZt069nXlA9YcfEoFrNQFPlpQe3akcUXC2FXnzPnWMdeSHPWbKn+aTTkH71LNY4y9a
        8o873U0sqUvCmMCIP3x0a+YrELZpYzBQjiV3GZCYQJlViKC76mDp8u+tSSZLDhmTW5ZdJKqRrhDyn
        qtAGl9s2kX52Z1lY8beRJz7OFkwM/f4xnA9qznJ4MBUGSYbuO7eOfj76sTVihIv7Mo3tYzjCNPO80
        BrYhFirADbeA3ekWVnw4yXbmOEcV0o3GapsM1TyTmGx/4xa4YexYiiNSnrGrbCPywUBuFb/zy/NpN
        sqpvZGCDA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45290)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k0RoG-0004RL-E7; Tue, 28 Jul 2020 16:46:32 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k0RoF-0004mg-MU; Tue, 28 Jul 2020 16:46:31 +0100
Date:   Tue, 28 Jul 2020 16:46:31 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, andrew@lunn.ch, f.fainelli@gmail.com,
        olteanv@gmail.com
Subject: Re: [PATCH net-next v4 4/5] net: phy: add Lynx PCS module
Message-ID: <20200728154631.GR1551@shell.armlinux.org.uk>
References: <20200724080143.12909-1-ioana.ciornei@nxp.com>
 <20200724080143.12909-5-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724080143.12909-5-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 11:01:42AM +0300, Ioana Ciornei wrote:
> Add a Lynx PCS module which exposes the necessary operations to drive
> the PCS using phylink.
> 
> The majority of the code is extracted from the Felix DSA driver, which
> will be also modified in a later patch, and exposed as a separate module
> for code reusability purposes.
> At the moment, USXGMII, SGMII, QSGMII and 2500Base-X (only w/o in-band
> AN) are supported by the Lynx PCS module since these were also supported
> by Felix.

Probably better to say that "As such, this aims at feature and bug
parity with the existing Felix DSA driver, and thus USXGMII, SGMII..."
in light of the comments below.

> 
> The module can only be enabled by the drivers in need and not user
> selectable.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---

Generally looks good, this time I've gone through it with a fine tooth
comb, so have picked up a load of issues, which may already exist in
the Felix code - don't feel you need to address these right now, but
please address them in the near future.

> Changes in v4:
>  * use the newly introduced phylink PCS mechanism
>  * do no use the SGMII_ prefix when referring to the IF_MORE register

IF_MODE

> 
>  MAINTAINERS                |   7 +
>  drivers/net/phy/Kconfig    |   6 +
>  drivers/net/phy/Makefile   |   1 +
>  drivers/net/phy/pcs-lynx.c | 314 +++++++++++++++++++++++++++++++++++++
>  include/linux/pcs-lynx.h   |  21 +++
>  5 files changed, 349 insertions(+)
>  create mode 100644 drivers/net/phy/pcs-lynx.c
>  create mode 100644 include/linux/pcs-lynx.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6200eb14757c..bfd0d174f4e4 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10158,6 +10158,13 @@ S:	Maintained
>  W:	http://linux-test-project.github.io/
>  T:	git git://github.com/linux-test-project/ltp.git
>  
> +LYNX PCS MODULE
> +M:	Ioana Ciornei <ioana.ciornei@nxp.com>
> +L:	netdev@vger.kernel.org
> +S:	Supported
> +F:	drivers/net/phy/pcs-lynx.c
> +F:	include/linux/pcs-lynx.h
> +
>  M68K ARCHITECTURE
>  M:	Geert Uytterhoeven <geert@linux-m68k.org>
>  L:	linux-m68k@lists.linux-m68k.org
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index dd20c2c27c2f..f8016e64e1a5 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -239,6 +239,12 @@ config MDIO_XPCS
>  	  This module provides helper functions for Synopsys DesignWare XPCS
>  	  controllers.
>  
> +config PCS_LYNX
> +	tristate
> +	help
> +	  This module provides helpers to phylink for managing the Lynx PCS
> +	  which is part of the Layerscape and QorIQ Ethernet SERDES.
> +
>  endif
>  endif
>  
> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index d84bab489a53..0e5539c05c81 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -48,6 +48,7 @@ obj-$(CONFIG_MDIO_SUN4I)	+= mdio-sun4i.o
>  obj-$(CONFIG_MDIO_THUNDER)	+= mdio-thunder.o
>  obj-$(CONFIG_MDIO_XGENE)	+= mdio-xgene.o
>  obj-$(CONFIG_MDIO_XPCS)		+= mdio-xpcs.o
> +obj-$(CONFIG_PCS_LYNX)		+= pcs-lynx.o
>  
>  obj-$(CONFIG_NETWORK_PHY_TIMESTAMPING) += mii_timestamper.o
>  
> diff --git a/drivers/net/phy/pcs-lynx.c b/drivers/net/phy/pcs-lynx.c
> new file mode 100644
> index 000000000000..9ea8b90a1350
> --- /dev/null
> +++ b/drivers/net/phy/pcs-lynx.c
> @@ -0,0 +1,314 @@
> +// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
> +/* Copyright 2020 NXP
> + * Lynx PCS MDIO helpers
> + */
> +
> +#include <linux/mdio.h>
> +#include <linux/phylink.h>
> +#include <linux/pcs-lynx.h>
> +
> +#define SGMII_CLOCK_PERIOD_NS		8 /* PCS is clocked at 125 MHz */
> +#define LINK_TIMER_VAL(ns)		((u32)((ns) / SGMII_CLOCK_PERIOD_NS))
> +
> +#define SGMII_AN_LINK_TIMER_NS		1600000 /* defined by SGMII spec */

I've been wondering why you've decided to work the timer out using the
clock period, when it's just as easy to do it via:

#define LINK_TIMER_US_SGMII     1600
#define DPAA2_MAC_PCS_CLK_MHZ   125

link_timer = DPAA2_MAC_PCS_CLK_MHZ * LINK_TIMER_US_SGMII;

It makes little difference either way, since the compiler will reduce
the code down to a single constant of 200000, except this way requires
less explanation.

> +
> +#define LINK_TIMER_LO			0x12
> +#define LINK_TIMER_HI			0x13
> +#define IF_MODE				0x14
> +#define IF_MODE_SGMII_EN		BIT(0)
> +#define IF_MODE_USE_SGMII_AN		BIT(1)
> +#define IF_MODE_SPEED(x)		(((x) << 2) & GENMASK(3, 2))
> +#define IF_MODE_SPEED_MSK		GENMASK(3, 2)

Consider switching these two definitions, and use IF_MODE_SPEED_MSK in
the definition of IF_MODE_SPEED().  Also, if we define the speeds
directly:

#define IF_MODE_SGMII_SPEED_10  (0 << 2)
#define IF_MODE_SGMII_SPEED_100 (1 << 2)
#define IF_MODE_SGMII_SPEED_1G  (2 << 2)
#define IF_MODE_SGMII_SPEED_2G5 (2 << 2)

Then there is no need for the sgmii_speed enum or the extra code to
merge that value into the if_mode register value.  ("2G5" is a way
to specify 2.5G - it comes from schematics, where resistors commonly
use 1K2 for 1.2K or capacitors commonly use 2n2 instead of 2.2n since
the "." can vanish or be missed.)

> +#define IF_MODE_DUPLEX			BIT(4)

Maybe IF_MODE_HALF_DUPLEX, since this bit is set for half duplex.
Helps to make the definition more descriptive.

> +
> +enum sgmii_speed {
> +	SGMII_SPEED_10		= 0,
> +	SGMII_SPEED_100		= 1,
> +	SGMII_SPEED_1000	= 2,
> +	SGMII_SPEED_2500	= 2,
> +};
> +
> +#define phylink_pcs_to_lynx(pl_pcs) container_of((pl_pcs), struct lynx_pcs, pcs)
> +
> +static void lynx_pcs_get_state_usxgmii(struct mdio_device *pcs,
> +				       struct phylink_link_state *state)
> +{
> +	struct mii_bus *bus = pcs->bus;
> +	int addr = pcs->addr;
> +	int status, lpa;
> +
> +	status = mdiobus_c45_read(bus, addr, MDIO_MMD_VEND2, MII_BMSR);
> +	if (status < 0)

lynx_pcs_get_state_2500basex() sets state->link false on error,
should there be some consistency?

> +		return;
> +
> +	state->link = !!(status & MDIO_STAT1_LSTATUS);
> +	state->an_complete = !!(status & MDIO_AN_STAT1_COMPLETE);
> +	if (!state->link || !state->an_complete)
> +		return;
> +
> +	lpa = mdiobus_c45_read(bus, addr, MDIO_MMD_VEND2, MII_LPA);
> +	if (lpa < 0)
> +		return;
> +
> +	phylink_decode_usxgmii_word(state, lpa);
> +}
> +
> +static void lynx_pcs_get_state_2500basex(struct mdio_device *pcs,
> +					 struct phylink_link_state *state)
> +{
> +	struct mii_bus *bus = pcs->bus;
> +	int addr = pcs->addr;
> +	int bmsr, lpa;
> +
> +	bmsr = mdiobus_read(bus, addr, MII_BMSR);
> +	lpa = mdiobus_read(bus, addr, MII_LPA);
> +	if (bmsr < 0 || lpa < 0) {
> +		state->link = false;
> +		return;
> +	}
> +
> +	state->link = !!(bmsr & BMSR_LSTATUS);
> +	state->an_complete = !!(bmsr & BMSR_ANEGCOMPLETE);
> +	if (!state->link)
> +		return;
> +
> +	state->speed = SPEED_2500;
> +	state->pause |= MLO_PAUSE_TX | MLO_PAUSE_RX;
> +	state->duplex = DUPLEX_FULL;
> +}
> +
> +static void lynx_pcs_get_state(struct phylink_pcs *pcs,
> +			       struct phylink_link_state *state)
> +{
> +	struct lynx_pcs *lynx = phylink_pcs_to_lynx(pcs);
> +
> +	switch (state->interface) {
> +	case PHY_INTERFACE_MODE_SGMII:
> +	case PHY_INTERFACE_MODE_QSGMII:
> +		phylink_mii_c22_pcs_get_state(lynx->mdio, state);
> +		break;
> +	case PHY_INTERFACE_MODE_2500BASEX:
> +		lynx_pcs_get_state_2500basex(lynx->mdio, state);
> +		break;
> +	case PHY_INTERFACE_MODE_USXGMII:
> +		lynx_pcs_get_state_usxgmii(lynx->mdio, state);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	dev_dbg(&lynx->mdio->dev,
> +		"mode=%s/%s/%s link=%u an_enabled=%u an_complete=%u\n",
> +		phy_modes(state->interface),
> +		phy_speed_to_str(state->speed),
> +		phy_duplex_to_str(state->duplex),
> +		state->link, state->an_enabled, state->an_complete);
> +}
> +
> +static int lynx_pcs_config_sgmii(struct mdio_device *pcs, unsigned int mode,
> +				 const unsigned long *advertising)
> +{
> +	struct mii_bus *bus = pcs->bus;
> +	int addr = pcs->addr;
> +	u16 if_mode;
> +	int err;
> +
> +	if_mode = IF_MODE_SGMII_EN;
> +	if (mode == MLO_AN_INBAND) {
> +		u32 link_timer;
> +
> +		if_mode |= IF_MODE_USE_SGMII_AN;
> +
> +		/* Adjust link timer for SGMII */
> +		link_timer = LINK_TIMER_VAL(SGMII_AN_LINK_TIMER_NS);
> +		mdiobus_write(bus, addr, LINK_TIMER_LO, link_timer & 0xffff);
> +		mdiobus_write(bus, addr, LINK_TIMER_HI, link_timer >> 16);
> +	}
> +	mdiobus_modify(bus, addr, IF_MODE,
> +		       IF_MODE_SGMII_EN | IF_MODE_USE_SGMII_AN,
> +		       if_mode);

Should this be error-checked?

> +
> +	err = phylink_mii_c22_pcs_config(pcs, mode, PHY_INTERFACE_MODE_SGMII,
> +					 advertising);
> +	return err;

Consider just:

	return phylink_mii_c22_pcs_config(...);

and eliminate "err".

> +}
> +
> +static int lynx_pcs_config_usxgmii(struct mdio_device *pcs, unsigned int mode,
> +				   const unsigned long *advertising)

This makes no use of "advertising" - do you need to pass it?

> +{
> +	struct mii_bus *bus = pcs->bus;
> +	int addr = pcs->addr;
> +
> +	if (!phylink_autoneg_inband(mode)) {
> +		dev_err(&pcs->dev, "USXGMII only supports in-band AN for now\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	/* Configure device ability for the USXGMII Replicator */
> +	mdiobus_c45_write(bus, addr, MDIO_MMD_VEND2, MII_ADVERTISE,
> +			  MDIO_USXGMII_10G | MDIO_USXGMII_LINK |
> +			  MDIO_USXGMII_FULL_DUPLEX |
> +			  ADVERTISE_SGMII | ADVERTISE_LPACK);
> +	return 0;

Should we propagate any error from mdiobus_c45_write()?

> +}
> +
> +static int lynx_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
> +			   phy_interface_t ifmode,
> +			   const unsigned long *advertising,
> +			   bool permit)
> +{
> +	struct lynx_pcs *lynx = phylink_pcs_to_lynx(pcs);
> +
> +	switch (ifmode) {
> +	case PHY_INTERFACE_MODE_SGMII:
> +	case PHY_INTERFACE_MODE_QSGMII:
> +		lynx_pcs_config_sgmii(lynx->mdio, mode, advertising);

error propagation?

> +		break;
> +	case PHY_INTERFACE_MODE_2500BASEX:
> +		if (phylink_autoneg_inband(mode)) {
> +			dev_err(&lynx->mdio->dev,
> +				"AN not supported on 3.125GHz SerDes lane\n");
> +			return -EOPNOTSUPP;
> +		}
> +		break;

Doesn't this need to do some configuration so the PCS is not in SGMII
mode, possibly expecting some autonegotiation?

> +	case PHY_INTERFACE_MODE_USXGMII:
> +		lynx_pcs_config_usxgmii(lynx->mdio, mode, advertising);

error propagation?

> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return 0;
> +}
> +
> +static void lynx_pcs_link_up_sgmii(struct mdio_device *pcs, unsigned int mode,
> +				   int speed, int duplex)
> +{
> +	struct mii_bus *bus = pcs->bus;
> +	u16 if_mode = 0, sgmii_speed;
> +	int addr = pcs->addr;
> +
> +	/* The PCS needs to be configured manually only
> +	 * when not operating on in-band mode
> +	 */
> +	if (mode == MLO_AN_INBAND)
> +		return;
> +
> +	if (duplex == DUPLEX_HALF)
> +		if_mode |= IF_MODE_DUPLEX;
> +
> +	switch (speed) {
> +	case SPEED_1000:
> +		sgmii_speed = SGMII_SPEED_1000;
> +		break;
> +	case SPEED_100:
> +		sgmii_speed = SGMII_SPEED_100;
> +		break;
> +	case SPEED_10:
> +		sgmii_speed = SGMII_SPEED_10;
> +		break;
> +	case SPEED_UNKNOWN:
> +		/* Silently don't do anything */
> +		return;
> +	default:
> +		dev_err(&pcs->dev, "Invalid PCS speed %d\n", speed);
> +		return;
> +	}
> +	if_mode |= IF_MODE_SPEED(sgmii_speed);
> +
> +	mdiobus_modify(bus, addr, IF_MODE,
> +		       IF_MODE_DUPLEX | IF_MODE_SPEED_MSK,
> +		       if_mode);
> +}
> +
> +/* 2500Base-X is SerDes protocol 7 on Felix and 6 on ENETC. It is a SerDes lane
> + * clocked at 3.125 GHz which encodes symbols with 8b/10b and does not have
> + * auto-negotiation of any link parameters. Electrically it is compatible with
> + * a single lane of XAUI.
> + * The hardware reference manual wants to call this mode SGMII, but it isn't
> + * really, since the fundamental features of SGMII:
> + * - Downgrading the link speed by duplicating symbols
> + * - Auto-negotiation
> + * are not there.
> + * The speed is configured at 1000 in the IF_MODE because the clock frequency
> + * is actually given by a PLL configured in the Reset Configuration Word (RCW).
> + * Since there is no difference between fixed speed SGMII w/o AN and 802.3z w/o
> + * AN, we call this PHY interface type 2500Base-X. In case a PHY negotiates a
> + * lower link speed on line side, the system-side interface remains fixed at
> + * 2500 Mbps and we do rate adaptation through pause frames.
> + */
> +static void lynx_pcs_link_up_2500basex(struct mdio_device *pcs,
> +				       unsigned int mode,
> +				       int speed, int duplex)
> +{
> +	struct mii_bus *bus = pcs->bus;
> +	int addr = pcs->addr;
> +	u16 if_mode = 0;
> +
> +	if (mode == MLO_AN_INBAND) {
> +		dev_err(&pcs->dev, "AN not supported for 2500BaseX\n");
> +		return;
> +	}
> +
> +	if (duplex == DUPLEX_HALF)
> +		if_mode |= IF_MODE_DUPLEX;
> +	if_mode |= IF_MODE_SPEED(SGMII_SPEED_2500);
> +
> +	mdiobus_modify(bus, addr, IF_MODE,
> +		       IF_MODE_DUPLEX | IF_MODE_SPEED_MSK,
> +		       if_mode);

From what I read in the LX2160A manual, the IF_MODE speed and duplex
settings are only applicable for SGMII mode.  This has IF_MODE_SGMII_EN
clear, which means it is not in SGMII mode, and thus the duplex and
speed settings here do not seem to be meaningful.  Maybe a point to be
addressed in a future patch?

Another point - half duplex is rarely supported at 1G.  The comment
above talks about rate adaption, which means the properties on the
media side (speed, duplex above) have little meaning on the system
side of the interface; the link between the PHY and the MAC is
effectively full duplex, with the half duplex-ness handled by the
PHY.

> +}
> +
> +static void lynx_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
> +			     phy_interface_t interface,
> +			     int speed, int duplex)
> +{
> +	struct lynx_pcs *lynx = phylink_pcs_to_lynx(pcs);
> +
> +	switch (interface) {
> +	case PHY_INTERFACE_MODE_SGMII:
> +	case PHY_INTERFACE_MODE_QSGMII:
> +		lynx_pcs_link_up_sgmii(lynx->mdio, mode, speed, duplex);
> +		break;
> +	case PHY_INTERFACE_MODE_2500BASEX:
> +		lynx_pcs_link_up_2500basex(lynx->mdio, mode, speed, duplex);
> +		break;
> +	case PHY_INTERFACE_MODE_USXGMII:
> +		/* At the moment, only in-band AN is supported for USXGMII
> +		 * so nothing to do in link_up
> +		 */
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
> +static const struct phylink_pcs_ops lynx_pcs_phylink_ops = {
> +	.pcs_get_state = lynx_pcs_get_state,
> +	.pcs_config = lynx_pcs_config,
> +	.pcs_link_up = lynx_pcs_link_up,
> +};
> +
> +struct lynx_pcs *lynx_pcs_create(struct mdio_device *mdio)
> +{
> +	struct lynx_pcs *lynx_pcs;
> +
> +	lynx_pcs = kzalloc(sizeof(*lynx_pcs), GFP_KERNEL);
> +	if (!lynx_pcs)
> +		return NULL;
> +
> +	lynx_pcs->mdio = mdio;
> +	lynx_pcs->pcs.ops = &lynx_pcs_phylink_ops;
> +	lynx_pcs->pcs.poll = true;

Great, an example of why pcs.poll is necessary!

> +
> +	return lynx_pcs;
> +}
> +EXPORT_SYMBOL(lynx_pcs_create);
> +
> +void lynx_pcs_destroy(struct lynx_pcs *pcs)
> +{
> +	kfree(pcs);
> +}
> +EXPORT_SYMBOL(lynx_pcs_destroy);
> +
> +MODULE_LICENSE("Dual BSD/GPL");
> diff --git a/include/linux/pcs-lynx.h b/include/linux/pcs-lynx.h
> new file mode 100644
> index 000000000000..a6440d6ebe95
> --- /dev/null
> +++ b/include/linux/pcs-lynx.h
> @@ -0,0 +1,21 @@
> +/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
> +/* Copyright 2020 NXP
> + * Lynx PCS helpers
> + */
> +
> +#ifndef __LINUX_PCS_LYNX_H
> +#define __LINUX_PCS_LYNX_H
> +
> +#include <linux/mdio.h>
> +#include <linux/phylink.h>
> +
> +struct lynx_pcs {
> +	struct phylink_pcs pcs;
> +	struct mdio_device *mdio;
> +};
> +
> +struct lynx_pcs *lynx_pcs_create(struct mdio_device *mdio);
> +
> +void lynx_pcs_destroy(struct lynx_pcs *pcs);
> +
> +#endif /* __LINUX_PCS_LYNX_H */
> -- 
> 2.25.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
