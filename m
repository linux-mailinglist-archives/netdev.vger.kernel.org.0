Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E102E115D
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 02:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbgLWBYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 20:24:42 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37668 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgLWBYm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 20:24:42 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1krssf-00DU5r-3T; Wed, 23 Dec 2020 02:23:57 +0100
Date:   Wed, 23 Dec 2020 02:23:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Marko <robert.marko@sartura.hr>
Cc:     agross@kernel.org, bjorn.andersson@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux@armlinux.org.uk,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: Re: [PATCH 3/4] net: phy: Add Qualcomm QCA807x driver
Message-ID: <20201223012357.GS3107610@lunn.ch>
References: <20201222222637.3204929-1-robert.marko@sartura.hr>
 <20201222222637.3204929-4-robert.marko@sartura.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201222222637.3204929-4-robert.marko@sartura.hr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +++ b/drivers/net/phy/Kconfig
> @@ -264,6 +264,16 @@ config QSEMI_PHY
>  	help
>  	  Currently supports the qs6612
>  
> +config QCA807X_PHY
> +	tristate "Qualcomm QCA807X PHYs"

Kconfig is sorted based on the tristate string. So this should be
after AT803X_PHY.

> +	depends on OF_MDIO
> +	help
> +	  Adds support for the Qualcomm QCA807x PHYs.
> +	  These are 802.3 Clause 22 compliant PHYs supporting gigabit
> +	  ethernet as well as 100Base-FX and 1000Base-X fibre.
> +
> +	  Currently supports the QCA8072 and QCA8075 models.
> +
>  config REALTEK_PHY
>  	tristate "Realtek PHYs"
>  	help
> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index ca0a313423b9..5f463ce0f711 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -74,6 +74,7 @@ obj-$(CONFIG_MICROSEMI_PHY)	+= mscc/
>  obj-$(CONFIG_NATIONAL_PHY)	+= national.o
>  obj-$(CONFIG_NXP_TJA11XX_PHY)	+= nxp-tja11xx.o
>  obj-$(CONFIG_QSEMI_PHY)		+= qsemi.o
> +obj-$(CONFIG_QCA807X_PHY)		+= qca807x.o
>  obj-$(CONFIG_REALTEK_PHY)	+= realtek.o

One line earlier please.

> +static int qca807x_cable_test_report_trans(int result)
> +{
> +	switch (result) {
> +	case QCA807X_CDT_RESULTS_OK:
> +		return ETHTOOL_A_CABLE_RESULT_CODE_OK;
> +	case QCA807X_CDT_RESULTS_OPEN:
> +		return ETHTOOL_A_CABLE_RESULT_CODE_OPEN;
> +	case QCA807X_CDT_RESULTS_SAME_SHORT:
> +		return ETHTOOL_A_CABLE_RESULT_CODE_SAME_SHORT;
> +	case QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI1_SAME_OK:
> +	case QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI2_SAME_OK:
> +	case QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI3_SAME_OK:
> +	case QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI1_SAME_OPEN:
> +	case QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI2_SAME_OPEN:
> +	case QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI3_SAME_OPEN:
> +	case QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI1_SAME_SHORT:
> +	case QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI2_SAME_SHORT:
> +	case QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI3_SAME_SHORT:

Feel free to add an optional pair to the netlink message, indicating
which pair this pair is shorted to.

> +		return ETHTOOL_A_CABLE_RESULT_CODE_CROSS_SHORT;
> +	default:
> +		return ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC;
> +	}
> +}

> +static int qca807x_cable_test_start(struct phy_device *phydev)
> +{
> +	int val, ret;
> +
> +	val = phy_read(phydev, QCA807X_CDT);
> +	/* Enable inter-pair short check as well */
> +	val &= ~QCA807X_CDT_ENABLE_INTER_PAIR_SHORT;
> +	val |= QCA807X_CDT_ENABLE;
> +	ret = phy_write(phydev, QCA807X_CDT, val);

What happens when you are using the PHY as a media converted to Fibre?
Should we return -EOPNOTSUPP here? I'm assuming it cannot do cable
test on a fibre pair.

> +static int qca807x_read_fiber_status(struct phy_device *phydev, bool combo_port)
> +{
> +	int ss, err, page, lpa, old_link = phydev->link;
> +
> +	/* Check whether fiber page is set and set if needed */
> +	page = phy_read(phydev, QCA807X_CHIP_CONFIGURATION);
> +	if (page & QCA807X_BT_BX_REG_SEL) {
> +		page &= ~QCA807X_BT_BX_REG_SEL;
> +		phy_write(phydev, QCA807X_CHIP_CONFIGURATION, page);
> +	}
> +
> +	/* Update the link, but return if there was an error */
> +	err = genphy_update_link(phydev);
> +	if (err)
> +		return err;
> +
> +	/* why bother the PHY if nothing can have changed */
> +	if (phydev->autoneg == AUTONEG_ENABLE && old_link && phydev->link)
> +		return 0;
> +
> +	phydev->speed = SPEED_UNKNOWN;
> +	phydev->duplex = DUPLEX_UNKNOWN;
> +	phydev->pause = 0;
> +	phydev->asym_pause = 0;
> +
> +	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete) {
> +		lpa = phy_read(phydev, MII_LPA);
> +		if (lpa < 0)
> +			return lpa;
> +
> +		linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
> +				 phydev->lp_advertising, lpa & LPA_LPACK);
> +		linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
> +				 phydev->lp_advertising, lpa & LPA_1000XFULL);
> +		linkmode_mod_bit(ETHTOOL_LINK_MODE_Pause_BIT,
> +				 phydev->lp_advertising, lpa & LPA_1000XPAUSE);
> +		linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
> +				 phydev->lp_advertising,
> +				 lpa & LPA_1000XPAUSE_ASYM);
> +
> +		phy_resolve_aneg_linkmode(phydev);
> +	}

This looks a lot like genphy_c37_read_status(). You could call it, and
then over write the speed and duplex with values from the PHY specific
registers.

> +static int qca807x_config_intr(struct phy_device *phydev)
> +{
> +	int ret, val;
> +
> +	val = phy_read(phydev, QCA807X_INTR_ENABLE);
> +
> +	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
> +		/* Check for combo port as it has fewer interrupts */
> +		if (phy_read(phydev, QCA807X_CHIP_CONFIGURATION)) {
> +			val |= QCA807X_INTR_ENABLE_SPEED_CHANGED;
> +			val |= QCA807X_INTR_ENABLE_LINK_FAIL;
> +			val |= QCA807X_INTR_ENABLE_LINK_SUCCESS;
> +		} else {
> +			val |= QCA807X_INTR_ENABLE_AUTONEG_ERR;
> +			val |= QCA807X_INTR_ENABLE_SPEED_CHANGED;
> +			val |= QCA807X_INTR_ENABLE_DUPLEX_CHANGED;
> +			val |= QCA807X_INTR_ENABLE_LINK_FAIL;
> +			val |= QCA807X_INTR_ENABLE_LINK_SUCCESS;
> +		}
> +		ret = phy_write(phydev, QCA807X_INTR_ENABLE, val);
> +	} else {
> +		ret = phy_write(phydev, QCA807X_INTR_ENABLE, 0);
> +	}
> +
> +	return ret;
> +}
> +
> +static int qca807x_ack_intr(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = phy_read(phydev, QCA807X_INTR_STATUS);
> +
> +	return (ret < 0) ? ret : 0;
> +}

You need to rework this to follow what Ioana has done for interrupt
handling.

> +	{
> +		PHY_ID_MATCH_EXACT(PHY_ID_QCA8075),
> +		.name           = "Qualcomm QCA8075",
> +		.flags		= PHY_POLL_CABLE_TEST,
> +		/* PHY_GBIT_FEATURES */
> +		.probe		= qca807x_probe,
> +		.config_init	= qca807x_config,
> +		.read_status	= qca807x_read_status,
> +		.config_intr	= qca807x_config_intr,
> +		.ack_interrupt	= qca807x_ack_intr,
> +		.soft_reset	= genphy_soft_reset,
> +		.get_tunable	= qca807x_get_tunable,
> +		.set_tunable	= qca807x_set_tunable,
> +		.cable_test_start	= qca807x_cable_test_start,
> +		.cable_test_get_status	= qca807x_cable_test_get_status,
> +	},
> +	{
> +		PHY_ID_MATCH_EXACT(PHY_ID_QCA807X_PSGMII),
> +		.name           = "Qualcomm QCA807x PSGMII",
> +		.probe		= qca807x_psgmii_config,

This looks odd. 

     Andrew
