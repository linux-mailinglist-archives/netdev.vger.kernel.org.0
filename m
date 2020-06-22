Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B32203492
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 12:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgFVKMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 06:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgFVKMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 06:12:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6219DC061794
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 03:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=8MH46/U0BeS+7F5lFTtKTeOjJp2/v9K/Yij48BCwKnA=; b=VtptGsbTNQA8TzvAyr45R30Bc
        ngteBrRx7KQzujeyggjoZKo9AcwUtnYNfrBYH6n0gJTS+ybQ0GCKDew2kjQyXToYGVu55WBSmpm9A
        upJuBb1leNh2uZ9aZ0m4Wuno2i6oT0fkT5+/digUPrIdHJX7W3r4qXu1iQfZPZ/Eu2hz2uIKzokz6
        ZS04tURl3JZL5tC9ojw7bF6APHiKRr5h2WR57AUXmCpBY/T5cv6mODxA9+dZC5FPzZ6w3naLmpXEH
        8hxIxZlA+Twh2Ui1CSgVlCzZlve29v3Ymbs/srTYtlJcCjs1bPh5q2qSNV8RUtG0faunwd9owLBu2
        mM4S1bDpQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58946)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jnJQq-0008Tq-HK; Mon, 22 Jun 2020 11:12:04 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jnJQm-0008Po-VJ; Mon, 22 Jun 2020 11:12:01 +0100
Date:   Mon, 22 Jun 2020 11:12:00 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, michael@walle.cc, andrew@lunn.ch,
        f.fainelli@gmail.com, olteanv@gmail.com
Subject: Re: [PATCH net-next v3 4/9] net: phy: add Lynx PCS module
Message-ID: <20200622101200.GC1551@shell.armlinux.org.uk>
References: <20200621225451.12435-1-ioana.ciornei@nxp.com>
 <20200621225451.12435-5-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200621225451.12435-5-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 01:54:46AM +0300, Ioana Ciornei wrote:
> Add a Lynx PCS module which exposes the necessary operations to drive
> the PCS using PHYLINK.
> 
> The majority of the code is extracted from the Felix DSA driver, which
> will be also modified in a later patch, and exposed as a separate module
> for code reusability purposes.
> 
> At the moment, USXGMII (only with in-band AN and speeds up to 2500),
> SGMII, QSGMII and 2500Base-X (only w/o in-band AN) are supported by the
> Lynx PCS module since these were also supported by Felix.
> 
> The module can only be enabled by the drivers in need and not user
> selectable.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
> Changes in v2:
>  * got rid of the mdio_lynx_pcs structure and directly exported the
>  functions without the need of an indirection
>  * solved the broken allmodconfig build test by making the module
>  tristate instead of bool
> 
> Changes in v3:
>  * renamed the file to pcs-lynx.c
> 
> 
>  MAINTAINERS                |   7 +
>  drivers/net/phy/Kconfig    |   6 +
>  drivers/net/phy/Makefile   |   1 +
>  drivers/net/phy/pcs-lynx.c | 337 +++++++++++++++++++++++++++++++++++++
>  include/linux/pcs-lynx.h   |  25 +++
>  5 files changed, 376 insertions(+)
>  create mode 100644 drivers/net/phy/pcs-lynx.c
>  create mode 100644 include/linux/pcs-lynx.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 301330e02bca..850d8b4f2d29 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10168,6 +10168,13 @@ S:	Maintained
>  W:	http://linux-test-project.github.io/
>  T:	git git://github.com/linux-test-project/ltp.git
>  
> +LYNX PCS MODULE
> +M:	Ioana Ciornei <ioana.ciornei@nxp.com>
> +L:	netdev@vger.kernel.org
> +S:	Maintained
> +F:	drivers/net/phy/pcs-lynx.c
> +F:	include/linux/pcs-lynx.h
> +
>  M68K ARCHITECTURE
>  M:	Geert Uytterhoeven <geert@linux-m68k.org>
>  L:	linux-m68k@lists.linux-m68k.org
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index f25702386d83..3a573afb21a3 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -235,6 +235,12 @@ config MDIO_XPCS
>  	  This module provides helper functions for Synopsys DesignWare XPCS
>  	  controllers.
>  
> +config PCS_LYNX
> +	tristate
> +	help
> +	  This module provides helper functions for Lynx PCS enablement
> +	  representing the PCS as an MDIO device.
> +
>  endif
>  endif
>  
> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index dc9e53b511d6..15ea3345fe3c 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -47,6 +47,7 @@ obj-$(CONFIG_MDIO_SUN4I)	+= mdio-sun4i.o
>  obj-$(CONFIG_MDIO_THUNDER)	+= mdio-thunder.o
>  obj-$(CONFIG_MDIO_XGENE)	+= mdio-xgene.o
>  obj-$(CONFIG_MDIO_XPCS)		+= mdio-xpcs.o
> +obj-$(CONFIG_PCS_LYNX)		+= pcs-lynx.o
>  
>  obj-$(CONFIG_NETWORK_PHY_TIMESTAMPING) += mii_timestamper.o
>  
> diff --git a/drivers/net/phy/pcs-lynx.c b/drivers/net/phy/pcs-lynx.c
> new file mode 100644
> index 000000000000..23bdd9db4340
> --- /dev/null
> +++ b/drivers/net/phy/pcs-lynx.c
> @@ -0,0 +1,337 @@
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
> +#define SGMII_LINK_TIMER_VAL(ns)	((u32)((ns) / SGMII_CLOCK_PERIOD_NS))
> +
> +#define SGMII_AN_LINK_TIMER_NS		1600000 /* defined by SGMII spec */
> +
> +#define SGMII_LINK_TIMER_LO		0x12
> +#define SGMII_LINK_TIMER_HI		0x13
> +#define SGMII_IF_MODE			0x14
> +#define SGMII_IF_MODE_SGMII_EN		BIT(0)
> +#define SGMII_IF_MODE_USE_SGMII_AN	BIT(1)
> +#define SGMII_IF_MODE_SPEED(x)		(((x) << 2) & GENMASK(3, 2))
> +#define SGMII_IF_MODE_SPEED_MSK		GENMASK(3, 2)
> +#define SGMII_IF_MODE_DUPLEX		BIT(4)

Given that this is in the .c file, and this code will be re-used in
other places where there is support for more than Cisco SGMII, can
we lose the SGMII_ prefix please?  Maybe use names such as those
I have in "dpaa2-mac: add 1000BASE-X/SGMII PCS support" ?

(I hate the way a single lane gigabit serdes link that supports
1000base-x gets incorrectly called "SGMII".)

> +
> +#define USXGMII_ADVERTISE_LSTATUS(x)	(((x) << 15) & BIT(15))
> +#define USXGMII_ADVERTISE_FDX		BIT(12)
> +#define USXGMII_ADVERTISE_SPEED(x)	(((x) << 9) & GENMASK(11, 9))
> +
> +#define USXGMII_LPA_LSTATUS(lpa)	((lpa) >> 15)
> +#define USXGMII_LPA_DUPLEX(lpa)		(((lpa) & GENMASK(12, 12)) >> 12)
> +#define USXGMII_LPA_SPEED(lpa)		(((lpa) & GENMASK(11, 9)) >> 9)
> +
> +enum usxgmii_speed {
> +	USXGMII_SPEED_10	= 0,
> +	USXGMII_SPEED_100	= 1,
> +	USXGMII_SPEED_1000	= 2,
> +	USXGMII_SPEED_2500	= 4,
> +};

These are not specific to the Lynx PCS, but are the standard layout
of the USXGMII word.  These ought to be in a header file similar to
what we do with the SGMII definitions in include/uapi/linux/mii.h.
I think as these are Clause 45, they possibly belong in
include/uapi/linux/mdio.h ?  In any case, one of my comments below
suggests that some of the uses of these definitions should be moved
into phylink's helpers.

> +
> +enum sgmii_speed {
> +	SGMII_SPEED_10		= 0,
> +	SGMII_SPEED_100		= 1,
> +	SGMII_SPEED_1000	= 2,
> +	SGMII_SPEED_2500	= 2,
> +};
> +
> +static void lynx_pcs_an_restart_usxgmii(struct mdio_device *pcs)
> +{
> +	mdiobus_c45_write(pcs->bus, pcs->addr,
> +			  MDIO_MMD_VEND2, MII_BMCR,
> +			  BMCR_RESET | BMCR_ANENABLE | BMCR_ANRESTART);
> +}

Phylink will not call *_an_restart() for USXGMII, so this code is
unreachable.

> +
> +void lynx_pcs_an_restart(struct mdio_device *pcs, phy_interface_t ifmode)
> +{
> +	switch (ifmode) {
> +	case PHY_INTERFACE_MODE_SGMII:
> +	case PHY_INTERFACE_MODE_QSGMII:
> +		phylink_mii_c22_pcs_an_restart(pcs);

Phylink will not call *_an_restart() for SGMII, so this code is
unreachable.

> +		break;
> +	case PHY_INTERFACE_MODE_USXGMII:
> +		lynx_pcs_an_restart_usxgmii(pcs);
> +		break;
> +	case PHY_INTERFACE_MODE_2500BASEX:
> +		break;
> +	default:
> +		dev_err(&pcs->dev, "Invalid PCS interface type %s\n",
> +			phy_modes(ifmode));
> +		break;
> +	}
> +}
> +EXPORT_SYMBOL(lynx_pcs_an_restart);
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
> +	switch (USXGMII_LPA_SPEED(lpa)) {
> +	case USXGMII_SPEED_10:
> +		state->speed = SPEED_10;
> +		break;
> +	case USXGMII_SPEED_100:
> +		state->speed = SPEED_100;
> +		break;
> +	case USXGMII_SPEED_1000:
> +		state->speed = SPEED_1000;
> +		break;
> +	case USXGMII_SPEED_2500:
> +		state->speed = SPEED_2500;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	if (USXGMII_LPA_DUPLEX(lpa))
> +		state->duplex = DUPLEX_FULL;
> +	else
> +		state->duplex = DUPLEX_HALF;

This should be added to phylink_mii_c45_pcs_get_state().  There is
nothing that is Lynx PCS specific here.

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

How do you know the other side is using pause frames, or is capable
of dealing with them?

In any case, phylink_mii_c22_pcs_get_state() should be expanded to
deal with the non-inband cases, where we are only interested in the
link state.  It isn't passed the link AN mode, which may be an
issue that needs resolving in some way.

> +}
> +
> +void lynx_pcs_get_state(struct mdio_device *pcs, phy_interface_t ifmode,
> +			struct phylink_link_state *state)
> +{
> +	switch (ifmode) {
> +	case PHY_INTERFACE_MODE_SGMII:
> +	case PHY_INTERFACE_MODE_QSGMII:
> +		phylink_mii_c22_pcs_get_state(pcs, state);
> +		break;
> +	case PHY_INTERFACE_MODE_2500BASEX:
> +		lynx_pcs_get_state_2500basex(pcs, state);
> +		break;
> +	case PHY_INTERFACE_MODE_USXGMII:
> +		lynx_pcs_get_state_usxgmii(pcs, state);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	dev_dbg(&pcs->dev,
> +		"mode=%s/%s/%s link=%u an_enabled=%u an_complete=%u\n",
> +		phy_modes(ifmode),
> +		phy_speed_to_str(state->speed),
> +		phy_duplex_to_str(state->duplex),
> +		state->link, state->an_enabled, state->an_complete);
> +}
> +EXPORT_SYMBOL(lynx_pcs_get_state);
> +
> +static int lynx_pcs_config_sgmii(struct mdio_device *pcs, unsigned int mode,
> +				 const unsigned long *advertising)
> +{
> +	struct mii_bus *bus = pcs->bus;
> +	int addr = pcs->addr;
> +	u16 if_mode;
> +	int err;
> +
> +	/* SGMII spec requires tx_config_Reg[15:0] to be exactly 0x4001
> +	 * for the MAC PCS in order to acknowledge the AN.
> +	 */
> +	mdiobus_write(bus, addr, MII_ADVERTISE,
> +		      ADVERTISE_SGMII | ADVERTISE_LPACK);

This will be overwritten by phylink_mii_c22_pcs_config() below.

> +
> +	if_mode = SGMII_IF_MODE_SGMII_EN;
> +	if (mode == MLO_AN_INBAND) {
> +		u32 link_timer;
> +
> +		if_mode |= SGMII_IF_MODE_USE_SGMII_AN;
> +
> +		/* Adjust link timer for SGMII */
> +		link_timer = SGMII_LINK_TIMER_VAL(SGMII_AN_LINK_TIMER_NS);
> +		mdiobus_write(bus, addr, SGMII_LINK_TIMER_LO, link_timer & 0xffff);
> +		mdiobus_write(bus, addr, SGMII_LINK_TIMER_HI, link_timer >> 16);
> +	}
> +	mdiobus_modify(bus, addr, SGMII_IF_MODE,
> +		       SGMII_IF_MODE_SGMII_EN | SGMII_IF_MODE_USE_SGMII_AN,
> +		       if_mode);
> +
> +	err = phylink_mii_c22_pcs_config(pcs, mode, PHY_INTERFACE_MODE_SGMII,
> +					 advertising);
> +	return err;
> +}
> +
> +static int lynx_pcs_config_usxgmii(struct mdio_device *pcs, unsigned int mode,
> +				   const unsigned long *advertising)
> +{
> +	struct mii_bus *bus = pcs->bus;
> +	int addr = pcs->addr;
> +
> +	/* Configure device ability for the USXGMII Replicator */
> +	mdiobus_c45_write(bus, addr, MDIO_MMD_VEND2, MII_ADVERTISE,
> +			  USXGMII_ADVERTISE_SPEED(USXGMII_SPEED_2500) |
> +			  USXGMII_ADVERTISE_LSTATUS(1) |
> +			  ADVERTISE_SGMII |
> +			  ADVERTISE_LPACK |
> +			  USXGMII_ADVERTISE_FDX);
> +	return 0;
> +}
> +
> +int lynx_pcs_config(struct mdio_device *pcs, unsigned int mode,
> +		    phy_interface_t ifmode,
> +		    const unsigned long *advertising)
> +{
> +	switch (ifmode) {
> +	case PHY_INTERFACE_MODE_SGMII:
> +	case PHY_INTERFACE_MODE_QSGMII:
> +		lynx_pcs_config_sgmii(pcs, mode, advertising);
> +		break;
> +	case PHY_INTERFACE_MODE_2500BASEX:
> +		/* 2500Base-X only works without in-band AN,
> +		 * thus nothing to do here
> +		 */
> +		break;
> +	case PHY_INTERFACE_MODE_USXGMII:
> +		lynx_pcs_config_usxgmii(pcs, mode, advertising);
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(lynx_pcs_config);
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
> +		if_mode |= SGMII_IF_MODE_DUPLEX;
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
> +	if_mode |= SGMII_IF_MODE_SPEED(sgmii_speed);
> +
> +	mdiobus_modify(bus, addr, SGMII_IF_MODE,
> +		       SGMII_IF_MODE_DUPLEX | SGMII_IF_MODE_SPEED_MSK,
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
> +
> +	if (mode == MLO_AN_INBAND) {
> +		dev_err(&pcs->dev, "AN not supported for 2500BaseX\n");
> +		return;
> +	}
> +
> +	mdiobus_write(bus, addr, SGMII_IF_MODE,
> +		      SGMII_IF_MODE_SGMII_EN |
> +		      SGMII_IF_MODE_SPEED(SGMII_SPEED_2500));
> +}
> +
> +void lynx_pcs_link_up(struct mdio_device *pcs, unsigned int mode,
> +		      phy_interface_t interface,
> +		      int speed, int duplex)
> +{
> +	switch (interface) {
> +	case PHY_INTERFACE_MODE_SGMII:
> +	case PHY_INTERFACE_MODE_QSGMII:
> +		lynx_pcs_link_up_sgmii(pcs, mode, speed, duplex);
> +		break;
> +	case PHY_INTERFACE_MODE_2500BASEX:
> +		lynx_pcs_link_up_2500basex(pcs, mode, speed, duplex);
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
> +EXPORT_SYMBOL(lynx_pcs_link_up);
> +
> +MODULE_LICENSE("Dual BSD/GPL");
> diff --git a/include/linux/pcs-lynx.h b/include/linux/pcs-lynx.h
> new file mode 100644
> index 000000000000..336fccb8c55f
> --- /dev/null
> +++ b/include/linux/pcs-lynx.h
> @@ -0,0 +1,25 @@
> +/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
> +/* Copyright 2020 NXP
> + * Lynx PCS helpers
> + */
> +
> +#ifndef __LINUX_PCS_LYNX_H
> +#define __LINUX_PCS_LYNX_H
> +
> +#include <linux/phy.h>
> +#include <linux/mdio.h>
> +
> +void lynx_pcs_an_restart(struct mdio_device *pcs, phy_interface_t ifmode);
> +
> +void lynx_pcs_get_state(struct mdio_device *pcs, phy_interface_t ifmode,
> +			struct phylink_link_state *state);
> +
> +int lynx_pcs_config(struct mdio_device *pcs, unsigned int mode,
> +		    phy_interface_t ifmode,
> +		    const unsigned long *advertising);
> +
> +void lynx_pcs_link_up(struct mdio_device *pcs, unsigned int mode,
> +		      phy_interface_t interface,
> +		      int speed, int duplex);
> +
> +#endif /* __LINUX_PCS_LYNX_H */
> -- 
> 2.25.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
