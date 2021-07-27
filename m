Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078C93D6FA3
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 08:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235679AbhG0Grx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 02:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235609AbhG0Grt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 02:47:49 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791D3C061760
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 23:47:49 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1m8GsW-0005gD-07; Tue, 27 Jul 2021 08:47:48 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1m8GsU-0007nA-7z; Tue, 27 Jul 2021 08:47:46 +0200
Date:   Tue, 27 Jul 2021 08:47:46 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     alexandru.tachici@analog.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: Re: [PATCH v2 3/7] net: phy: adin1100: Add initial support for
 ADIN1100 industrial PHY
Message-ID: <20210727064746.lsz3ip7jyjbjkskj@pengutronix.de>
References: <20210712130631.38153-1-alexandru.tachici@analog.com>
 <20210712130631.38153-4-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210712130631.38153-4-alexandru.tachici@analog.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:31:44 up 236 days, 20:38, 14 users,  load average: 0.11, 0.09,
 0.03
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 04:06:27PM +0300, alexandru.tachici@analog.com wrote:
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
>  drivers/net/phy/adin1100.c | 326 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 334 insertions(+)
>  create mode 100644 drivers/net/phy/adin1100.c
> 
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index c56f703ae998..8f9f61fe0020 100644
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
> index 172bb193ae6a..3bd6a369d60c 100644
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
> index 000000000000..682fc617c51b
> --- /dev/null
> +++ b/drivers/net/phy/adin1100.c
> @@ -0,0 +1,326 @@
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
> +	ETHTOOL_LINK_MODE_1000mv_BIT,
> +};
> +
> +#define ADIN_B10L_PCS_CNTRL			0x08e6
> +#define   ADIN_PCS_CNTRL_B10L_LB_PCS_EN		BIT(14)

This register is "45.2.3.68a 10BASE-T1L PCS control register (Register
3.2278)" according to the 802.3cg-2019.

> +#define ADIN_B10L_PMA_CNTRL			0x08f6
> +#define   ADIN_PMA_CNTRL_B10L_LB_PMA_LOC_EN	BIT(0)
> +
> +#define ADIN_B10L_PMA_STAT			0x08f7
> +#define   ADIN_PMA_STAT_B10L_LB_PMA_LOC_ABLE	BIT(13)
> +#define   ADIN_PMA_STAT_B10L_TX_LVL_HI_ABLE	BIT(12)
> +
> +#define ADIN_AN_CONTROL				0x0200
> +#define   ADIN_AN_RESTART			BIT(9)
> +#define   ADIN_AN_EN				BIT(12)
> +
> +#define ADIN_AN_STATUS				0x0201
> +#define ADIN_AN_ADV_ABILITY_L			0x0202
> +#define ADIN_AN_ADV_ABILITY_M			0x0203
> +#define ADIN_AN_ADV_ABILITY_H			0x0204U
> +#define   ADIN_AN_ADV_B10L_TX_LVL_HI_ABL	BIT(13)
> +#define   ADIN_AN_ADV_B10L_TX_LVL_HI_REQ	BIT(12)

All of this bits are implemented according to the 802.3-2018 standard,
For example ADIN_AN_CONTROL is corresponding to "45.2.7.19 BASE-T1 AN control register (Register 7.512)"

> +
> +#define ADIN_AN_LP_ADV_ABILITY_L		0x0205
> +
> +#define ADIN_AN_LP_ADV_ABILITY_M		0x0206
> +#define   ADIN_AN_LP_ADV_B10L			BIT(14)
> +#define   ADIN_AN_LP_ADV_B1000			BIT(7)
> +#define   ADIN_AN_LP_ADV_B10S_FD		BIT(6)
> +#define   ADIN_AN_LP_ADV_B100			BIT(5)
> +#define   ADIN_AN_LP_ADV_MST			BIT(4)
> +
> +#define ADIN_AN_LP_ADV_ABILITY_H		0x0207
> +#define   ADIN_AN_LP_ADV_B10L_EEE		BIT(14)
> +#define   ADIN_AN_LP_ADV_B10L_TX_LVL_HI_ABL	BIT(13)
> +#define   ADIN_AN_LP_ADV_B10L_TX_LVL_HI_REQ	BIT(12)
> +#define   ADIN_AN_LP_ADV_B10S_HD		BIT(11)

This registers are:
45.2.7.22 BASE-T1 AN LP Base Page ability register (Registers 7.517, 7.518 ..

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
> +#define ADIN_MAC_IF_LOOPBACK			0x803d
> +#define   ADIN_MAC_IF_LOOPBACK_EN		BIT(0)
> +#define   ADIN_MAC_IF_REMOTE_LOOPBACK_EN	BIT(2)
> +

Please compare the PHY datasheet with 802.3.2018 and 802.3cg-2019, and
implement common parts as phy generic code.

> +/**
> + * struct adin_priv - ADIN PHY driver private data
> + * tx_level_24v			set if the PHY supports 2.4V TX levels (10BASE-T1L)
> + */
> +struct adin_priv {
> +	unsigned int		tx_level_24v:1;
> +};
> +
> +static void adin_mii_adv_m_to_ethtool_adv_t(unsigned long *advertising, u32 adv)
> +{
> +	if (adv & ADIN_AN_LP_ADV_B10L)
> +		linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT1L_Full_BIT, advertising);
> +}
> +
> +static void adin_mii_adv_h_to_ethtool_adv_t(unsigned long *advertising, u32 adv)
> +{
> +	if (adv & ADIN_AN_LP_ADV_B10S_HD)
> +		linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT1L_Half_BIT, advertising);
> +	if (adv & ADIN_AN_LP_ADV_B10L_TX_LVL_HI_ABL)
> +		linkmode_set_bit(ETHTOOL_LINK_MODE_2400mv_BIT, advertising);
> +	if (!(adv & ADIN_AN_LP_ADV_B10L_TX_LVL_HI_REQ))
> +		linkmode_set_bit(ETHTOOL_LINK_MODE_1000mv_BIT, advertising);
> +}
> +
> +static int adin_read_lpa(struct phy_device *phydev)
> +{
> +	int val;
> +
> +	linkmode_zero(phydev->lp_advertising);
> +
> +	val = phy_read_mmd(phydev, MDIO_MMD_AN, ADIN_AN_STATUS);
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
> +	val = phy_read_mmd(phydev, MDIO_MMD_AN, ADIN_AN_LP_ADV_ABILITY_L);
> +	if (val < 0)
> +		return val;
> +
> +	phydev->pause = val & LPA_PAUSE_CAP ? 1 : 0;
> +	phydev->asym_pause = val & LPA_PAUSE_ASYM ? 1 : 0;
> +
> +	val = phy_read_mmd(phydev, MDIO_MMD_AN, ADIN_AN_LP_ADV_ABILITY_M);
> +	if (val < 0)
> +		return val;
> +
> +	adin_mii_adv_m_to_ethtool_adv_t(phydev->lp_advertising, val);
> +
> +	val = phy_read_mmd(phydev, MDIO_MMD_AN, ADIN_AN_LP_ADV_ABILITY_H);
> +	if (val < 0)
> +		return val;
> +
> +	adin_mii_adv_h_to_ethtool_adv_t(phydev->lp_advertising, val);
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
> +	if (priv->tx_level_24v)
> +		ret = phy_set_bits_mmd(phydev, MDIO_MMD_AN,
> +				       ADIN_AN_ADV_ABILITY_H,
> +				       ADIN_AN_ADV_B10L_TX_LVL_HI_ABL |
> +				       ADIN_AN_ADV_B10L_TX_LVL_HI_REQ);
> +	else
> +		ret = phy_clear_bits_mmd(phydev, MDIO_MMD_AN,
> +					 ADIN_AN_ADV_ABILITY_H,
> +					 ADIN_AN_ADV_B10L_TX_LVL_HI_ABL |
> +					 ADIN_AN_ADV_B10L_TX_LVL_HI_REQ);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	return phy_set_bits_mmd(phydev, MDIO_MMD_AN, ADIN_AN_CONTROL, ADIN_AN_RESTART);
> +}
> +
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
> +		return phy_set_bits_mmd(phydev, MDIO_MMD_PCS, ADIN_B10L_PCS_CNTRL,
> +					ADIN_PCS_CNTRL_B10L_LB_PCS_EN);
> +
> +	/* PCS loopback (according to 10BASE-T1L spec) */
> +	return phy_clear_bits_mmd(phydev, MDIO_MMD_PCS, ADIN_B10L_PCS_CNTRL,
> +				 ADIN_PCS_CNTRL_B10L_LB_PCS_EN);
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
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, ADIN_B10L_PMA_STAT);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* This depends on the voltage level from the power source */
> +	priv->tx_level_24v = !!(ret & ADIN_PMA_STAT_B10L_TX_LVL_HI_ABLE);
> +
> +	phydev_dbg(phydev, "PHY supports 2.4V TX level: %s\n",
> +		   priv->tx_level_24v ? "yes" : "no");
> +
> +	if (device_property_present(dev, "adi,disable-2400mv-tx-level")) {
> +		if (priv->tx_level_24v)
> +			phydev_info(phydev,
> +				    "PHY supports 2.4V TX level, but disabled via config\n");
> +
> +		priv->tx_level_24v = 0;
> +	}
> +
> +	if (priv->tx_level_24v)
> +		linkmode_set_bit(ETHTOOL_LINK_MODE_2400mv_BIT, phydev->supported);
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
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
