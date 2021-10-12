Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3702E429FCE
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 10:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234961AbhJLIbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 04:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234660AbhJLIbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 04:31:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13954C061570
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 01:29:17 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1maD9r-0004k7-1F; Tue, 12 Oct 2021 10:29:11 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1maD9o-0004Ur-OT; Tue, 12 Oct 2021 10:29:08 +0200
Date:   Tue, 12 Oct 2021 10:29:08 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     alexandru.tachici@analog.com
Cc:     andrew@lunn.ch, davem@davemloft.net, devicetree@vger.kernel.org,
        hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: Re: [PATCH v3 4/8] net: phy: adin1100: Add initial support for
 ADIN1100 industrial PHY
Message-ID: <20211012082908.GD938@pengutronix.de>
References: <20211011142215.9013-1-alexandru.tachici@analog.com>
 <20211011142215.9013-5-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211011142215.9013-5-alexandru.tachici@analog.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:19:51 up 236 days, 10:43, 125 users,  load average: 0.12, 0.19,
 0.23
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 11, 2021 at 05:22:11PM +0300, alexandru.tachici@analog.com wrote:
> From: Alexandru Ardelean <alexandru.ardelean@analog.com>
> 
> The ADIN1100 is a low power single port 10BASE-T1L transceiver designed for
> industrial Ethernet applications and is compliant with the IEEE 802.3cg
> Ethernet standard for long reach 10 Mb/s Single Pair Ethernet.
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
> ---
>  drivers/net/phy/Kconfig    |   7 +
>  drivers/net/phy/Makefile   |   1 +
>  drivers/net/phy/adin1100.c | 279 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 287 insertions(+)
>  create mode 100644 drivers/net/phy/adin1100.c
> 
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index 902495afcb38..2f65d39e0f2c 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -83,6 +83,13 @@ config ADIN_PHY
>  	  - ADIN1300 - Robust,Industrial, Low Latency 10/100/1000 Gigabit
>  	    Ethernet PHY
>  
> +config ADIN1100_PHY
> +	tristate "Analog Devices Industrial Ethernet T1L PHYs"
> +	help
> +	  Adds support for the Analog Devices Industrial T1L Ethernet PHYs.
> +	  Currently supports the:
> +	  - ADIN1100 - Robust,Industrial, Low Power 10BASE-T1L Ethernet PHY
> +
>  config AQUANTIA_PHY
>  	tristate "Aquantia PHYs"
>  	help
> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index b2728d00fc9a..b82651b57043 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -31,6 +31,7 @@ sfp-obj-$(CONFIG_SFP)		+= sfp-bus.o
>  obj-y				+= $(sfp-obj-y) $(sfp-obj-m)
>  
>  obj-$(CONFIG_ADIN_PHY)		+= adin.o
> +obj-$(CONFIG_ADIN1100_PHY)	+= adin1100.o
>  obj-$(CONFIG_AMD_PHY)		+= amd.o
>  aquantia-objs			+= aquantia_main.o
>  ifdef CONFIG_HWMON
> diff --git a/drivers/net/phy/adin1100.c b/drivers/net/phy/adin1100.c
> new file mode 100644
> index 000000000000..dc5c1987dc43
> --- /dev/null
> +++ b/drivers/net/phy/adin1100.c
> @@ -0,0 +1,279 @@
> +// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
> +/*
> + *  Driver for Analog Devices Industrial Ethernet T1L PHYs
> + *
> + * Copyright 2020 Analog Devices Inc.
> + */
> +#include <linux/kernel.h>
> +#include <linux/bitfield.h>
> +#include <linux/delay.h>
> +#include <linux/errno.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/mii.h>
> +#include <linux/phy.h>
> +#include <linux/property.h>
> +
> +#define PHY_ID_ADIN1100				0x0283bc81
> +
> +static const int phy_10_features_array[] = {
> +	ETHTOOL_LINK_MODE_10baseT1L_Full_BIT,
> +};
> +
> +#define ADIN_CRSM_SFT_RST			0x8810
> +#define   ADIN_CRSM_SFT_RST_EN			BIT(0)
> +
> +#define ADIN_CRSM_SFT_PD_CNTRL			0x8812
> +#define   ADIN_CRSM_SFT_PD_CNTRL_EN		BIT(0)
> +
> +#define ADIN_CRSM_STAT				0x8818
> +#define   ADIN_CRSM_SFT_PD_RDY			BIT(1)
> +#define   ADIN_CRSM_SYS_RDY			BIT(0)
> +
> +/**
> + * struct adin_priv - ADIN PHY driver private data
> + * tx_level_2v4_able		set if the PHY supports 2.4V TX levels (10BASE-T1L)
> + * tx_level_2v4			set if the PHY requests 2.4V TX levels (10BASE-T1L)
> + * tx_level_prop_present	set if the TX level is specified in DT
> + */
> +struct adin_priv {
> +	unsigned int		tx_level_2v4_able:1;
> +	unsigned int		tx_level_2v4:1;
> +	unsigned int		tx_level_prop_present:1;
> +};
> +
> +static void adin_mii_adv_m_to_ethtool_adv_t(unsigned long *advertising, u32 adv)
> +{
> +	if (adv & MDIO_AN_T1_ADV_M_B10L)
> +		linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT1L_Full_BIT, advertising);
> +}

Please extend genphy_c45_pma_read_abilities() to set 10baseT1L_Full_BIT.

It is already doing most of needed work:
..
  if (val & MDIO_PMA_STAT2_EXTABLE) {
          val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_EXTABLE);
	  // This is 45.2.1.10 PMA/PMD extended ability register (Register 1.11)
	  // You should test for bit 1.11.11 and read register register 1.18
	  // to set missing abilities.

> +static int adin_read_lpa(struct phy_device *phydev)
> +{
> +	int val;
> +
> +	linkmode_zero(phydev->lp_advertising);
> +
> +	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_T1_STAT);
> +	if (val < 0)
> +		return val;
> +
> +	if (!(val & MDIO_AN_STAT1_COMPLETE)) {
> +		phydev->pause = 0;
> +		phydev->asym_pause = 0;
> +
> +		return 0;
> +	}
> +
> +	linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
> +			 phydev->lp_advertising);
> +
> +	/* Read the link partner's base page advertisement */
> +	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_T1_LP_L);
> +	if (val < 0)
> +		return val;
> +
> +	phydev->pause = val & MDIO_AN_T1_LP_L_PAUSE_CAP ? 1 : 0;
> +	phydev->asym_pause = val & MDIO_AN_T1_LP_L_PAUSE_ASYM ? 1 : 0;
> +
> +	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_T1_LP_M);
> +	if (val < 0)
> +		return val;
> +
> +	adin_mii_adv_m_to_ethtool_adv_t(phydev->lp_advertising, val);
> +
> +	return 0;
> +}
> +
> +static int adin_read_status(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = genphy_c45_read_link(phydev);
> +	if (ret)
> +		return ret;
> +
> +	phydev->speed = SPEED_UNKNOWN;
> +	phydev->duplex = DUPLEX_UNKNOWN;
> +	phydev->pause = 0;
> +	phydev->asym_pause = 0;
> +
> +	if (phydev->autoneg == AUTONEG_ENABLE) {
> +		ret = adin_read_lpa(phydev);
> +		if (ret)
> +			return ret;
> +
> +		phy_resolve_aneg_linkmode(phydev);
> +	} else {
> +		/* Only one mode & duplex supported */
> +		linkmode_zero(phydev->lp_advertising);
> +		phydev->speed = SPEED_10;
> +		phydev->duplex = DUPLEX_FULL;
> +	}
> +
> +	return ret;
> +}
> +
> +static int adin_config_aneg(struct phy_device *phydev)
> +{
> +	struct adin_priv *priv = phydev->priv;
> +	int ret;
> +
> +	/* No sense to continue if auto-neg is disabled,
> +	 * only one link-mode supported.
> +	 */
> +	if (phydev->autoneg == AUTONEG_DISABLE)
> +		return 0;
> +
> +	/* Request increased transmit level from LP. */
> +	if (priv->tx_level_prop_present && priv->tx_level_2v4) {
> +		ret = phy_set_bits_mmd(phydev, MDIO_MMD_AN, MDIO_AN_T1_ADV_H,
> +				       MDIO_AN_T1_ADV_H_10L_TX_HI |
> +				       MDIO_AN_T1_ADV_H_10L_TX_HI_REQ);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	/* Disable 2.4 Vpp transmit level. */
> +	if ((priv->tx_level_prop_present && !priv->tx_level_2v4) || !priv->tx_level_2v4_able) {
> +		ret = phy_clear_bits_mmd(phydev, MDIO_MMD_AN, MDIO_AN_T1_ADV_H,
> +					 MDIO_AN_T1_ADV_H_10L_TX_HI |
> +					 MDIO_AN_T1_ADV_H_10L_TX_HI_REQ);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return phy_set_bits_mmd(phydev, MDIO_MMD_AN, MDIO_AN_T1_CTRL, BMCR_ANRESTART);
> +}
>
> +static int adin_set_powerdown_mode(struct phy_device *phydev, bool en)
> +{
> +	int ret;
> +	int val;
> +
> +	if (en)
> +		val = ADIN_CRSM_SFT_PD_CNTRL_EN;
> +	else
> +		val = 0;
> +
> +	ret = phy_write_mmd(phydev, MDIO_MMD_VEND1,
> +			    ADIN_CRSM_SFT_PD_CNTRL, val);
> +	if (ret < 0)
> +		return ret;
> +
> +	return phy_read_mmd_poll_timeout(phydev, MDIO_MMD_VEND1, ADIN_CRSM_STAT, ret,
> +					 (ret & ADIN_CRSM_SFT_PD_RDY) == val,
> +					 1000, 30000, true);
> +}
> +
> +static int adin_suspend(struct phy_device *phydev)
> +{
> +	return adin_set_powerdown_mode(phydev, true);
> +}
> +
> +static int adin_resume(struct phy_device *phydev)
> +{
> +	return adin_set_powerdown_mode(phydev, false);
> +}
> +
> +static int adin_set_loopback(struct phy_device *phydev, bool enable)
> +{
> +	if (enable)
> +		return phy_set_bits_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_10T1L_CTRL,
> +					BMCR_LOOPBACK);
> +
> +	/* PCS loopback (according to 10BASE-T1L spec) */
> +	return phy_clear_bits_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_10T1L_CTRL,
> +				 BMCR_LOOPBACK);
> +}
> +
> +static int adin_soft_reset(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, ADIN_CRSM_SFT_RST, ADIN_CRSM_SFT_RST_EN);
> +	if (ret < 0)
> +		return ret;
> +
> +	return phy_read_mmd_poll_timeout(phydev, MDIO_MMD_VEND1, ADIN_CRSM_STAT, ret,
> +					 (ret & ADIN_CRSM_SYS_RDY),
> +					 10000, 30000, true);
> +}
> +
> +static int adin_get_features(struct phy_device *phydev)
> +{
> +	struct adin_priv *priv = phydev->priv;
> +	struct device *dev = &phydev->mdio.dev;
> +	int ret;
> +	u8 val;
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_10T1L_STAT);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* This depends on the voltage level from the power source */
> +	priv->tx_level_2v4_able = !!(ret & MDIO_PMA_10T1L_STAT_2V4_ABLE);
> +
> +	phydev_dbg(phydev, "PHY supports 2.4V TX level: %s\n",
> +		   priv->tx_level_2v4_able ? "yes" : "no");
> +
> +	priv->tx_level_prop_present = device_property_present(dev, "10base-t1l-2.4vpp");
> +	if (priv->tx_level_prop_present) {
> +		ret = device_property_read_u8(dev, "10base-t1l-2.4vpp", &val);
> +		if (ret < 0)
> +			return ret;
> +
> +		priv->tx_level_2v4 = val;
> +		if (!priv->tx_level_2v4 && priv->tx_level_2v4_able)
> +			phydev_info(phydev,
> +				    "PHY supports 2.4V TX level, but disabled via config\n");
> +	}
> +
> +	linkmode_set_bit_array(phy_basic_ports_array, ARRAY_SIZE(phy_basic_ports_array),
> +			       phydev->supported);
> +
> +	linkmode_set_bit_array(phy_10_features_array, ARRAY_SIZE(phy_10_features_array),
> +			       phydev->supported);
> +
> +	return 0;
> +}
> +
> +static int adin_probe(struct phy_device *phydev)
> +{
> +	struct device *dev = &phydev->mdio.dev;
> +	struct adin_priv *priv;
> +
> +	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	phydev->priv = priv;
> +
> +	return 0;
> +}
> +

Without spending too much time on review right now, I would expect that
most of this code should got to the drivers/net/phy/phy-c45.c

> +static struct phy_driver adin_driver[] = {
> +	{
> +		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1100),
> +		.name			= "ADIN1100",
> +		.get_features		= adin_get_features,
> +		.soft_reset		= adin_soft_reset,
> +		.probe			= adin_probe,
> +		.config_aneg		= adin_config_aneg,
> +		.read_status		= adin_read_status,
> +		.set_loopback		= adin_set_loopback,
> +		.suspend		= adin_suspend,
> +		.resume			= adin_resume,
> +	},
> +};
> +
> +module_phy_driver(adin_driver);
> +
> +static struct mdio_device_id __maybe_unused adin_tbl[] = {
> +	{ PHY_ID_MATCH_MODEL(PHY_ID_ADIN1100) },
> +	{ }
> +};
> +
> +MODULE_DEVICE_TABLE(mdio, adin_tbl);
> +MODULE_DESCRIPTION("Analog Devices Industrial Ethernet T1L PHY driver");
> +MODULE_LICENSE("Dual BSD/GPL");
> -- 
> 2.25.1
> 

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
