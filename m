Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3409D397298
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 13:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233064AbhFALmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 07:42:53 -0400
Received: from mga18.intel.com ([134.134.136.126]:47268 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230288AbhFALmw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 07:42:52 -0400
IronPort-SDR: 97ws4QOVA+b8EE5jFRtz5KuU8L4S3Ks8w5gkZccML2iVG6yl8yCwQU4gMB4whySg4csJ9TSFMO
 +fl3AYSQ8PZg==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="190883374"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="190883374"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 04:41:11 -0700
IronPort-SDR: Twmt0o/tVoTlTC6RofepCObqjIrkqlDzYpqkPEppZFnV+SrIgJIYdcFkMWAyELKAUvLxuFM3YV
 ho1R7Gtz74Ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="446930599"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga008.fm.intel.com with ESMTP; 01 Jun 2021 04:41:10 -0700
Received: from linux.intel.com (unknown [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 5104558090A;
        Tue,  1 Jun 2021 04:41:08 -0700 (PDT)
Date:   Tue, 1 Jun 2021 19:41:05 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Xu Liang <lxu@maxlinear.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        hmehrtens@maxlinear.com, tmohren@maxlinear.com
Subject: Re: [PATCH] phy: maxlinear: add Maxlinear GPY115/21x/24x driver
Message-ID: <20210601114105.GA26705@linux.intel.com>
References: <20210601074427.40990-1-lxu@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601074427.40990-1-lxu@maxlinear.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 03:44:27PM +0800, Xu Liang wrote:
> ---
>  drivers/net/phy/Kconfig   |   5 +
>  drivers/net/phy/Makefile  |   1 +
>  drivers/net/phy/mxl-gpy.c | 537 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 543 insertions(+)
>  create mode 100644 drivers/net/phy/mxl-gpy.c
> 
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index 288bf405ebdb..7f1a0d62d83a 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -186,6 +186,11 @@ config INTEL_XWAY_PHY
>  	  PEF 7061, PEF 7071 and PEF 7072 or integrated into the Intel
>  	  SoCs xRX200, xRX300, xRX330, xRX350 and xRX550.
>  
> +config MXL_GPHY
> +	tristate "Maxlinear 2.5G PHYs"
> +	help
> +	  Support for the Maxlinear 2.5G PHYs.
> +

I think its better to explicitly spell out the supported models.
i.e. GPY115/21x/24x PHYs.

>  config LSI_ET1011C_PHY
>  	tristate "LSI ET1011C PHY"
>  	help
> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index bcda7ed2455d..28aa2a198d00 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -59,6 +59,7 @@ obj-$(CONFIG_DP83TC811_PHY)	+= dp83tc811.o
>  obj-$(CONFIG_FIXED_PHY)		+= fixed_phy.o
>  obj-$(CONFIG_ICPLUS_PHY)	+= icplus.o
>  obj-$(CONFIG_INTEL_XWAY_PHY)	+= intel-xway.o
> +obj-$(CONFIG_MXL_GPHY)          += mxl-gpy.o
>  obj-$(CONFIG_LSI_ET1011C_PHY)	+= et1011c.o
>  obj-$(CONFIG_LXT_PHY)		+= lxt.o
>  obj-$(CONFIG_MARVELL_10G_PHY)	+= marvell10g.o
> diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
> new file mode 100644
> index 000000000000..757e65e48567
> --- /dev/null
> +++ b/drivers/net/phy/mxl-gpy.c
> @@ -0,0 +1,537 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/* Copyright (C) 2021 Maxlinear Corporation
> + * Copyright (C) 2020 Intel Corporation
> + *
> + * Maxlinear Ethernet GPY

Drivers for Maxlinear Ethernet GPY

> + *
> + */
> +
> +#include <linux/version.h>
> +#include <linux/module.h>
> +#include <linux/bitfield.h>
> +#include <linux/phy.h>
> +#include <linux/netdevice.h>
> +
> +/* PHY ID */
> +#define PHY_ID_GPY		0x67C9DC00
> +#define PHY_ID_MASK		GENMASK(31, 10)
> +
> +#define PHY_MIISTAT		0x18	/* MII state */
> +#define PHY_IMASK		0x19	/* interrupt mask */
> +#define PHY_ISTAT		0x1A	/* interrupt status */
> +#define PHY_FWV			0x1E	/* firmware version */
> +
> +#define PHY_MIISTAT_SPD_MASK	GENMASK(2, 0)
> +#define PHY_MIISTAT_DPX		BIT(3)
> +#define PHY_MIISTAT_LS		BIT(10)
> +
> +#define PHY_MIISTAT_SPD_10	0
> +#define PHY_MIISTAT_SPD_100	1
> +#define PHY_MIISTAT_SPD_1000	2
> +#define PHY_MIISTAT_SPD_2500	4
> +
> +#define PHY_IMASK_WOL		BIT(15)	/* Wake-on-LAN */
> +#define PHY_IMASK_ANC		BIT(10)	/* Auto-Neg complete */
> +#define PHY_IMASK_ADSC		BIT(5)	/* Link auto-downspeed detect */
> +#define PHY_IMASK_DXMC		BIT(2)	/* Duplex mode change */
> +#define PHY_IMASK_LSPC		BIT(1)	/* Link speed change */
> +#define PHY_IMASK_LSTC		BIT(0)	/* Link state change */
> +#define PHY_IMASK_MASK		(PHY_IMASK_LSTC | \
> +				 PHY_IMASK_LSPC | \
> +				 PHY_IMASK_DXMC | \
> +				 PHY_IMASK_ADSC | \
> +				 PHY_IMASK_ANC)
> +
> +#define PHY_FWV_TYPE_MASK	GENMASK(11, 8)
> +#define PHY_FWV_MINOR_MASK	GENMASK(7, 0)
> +
> +/* ANEG dev */
> +#define ANEG_MGBT_AN_CTRL	0x20
> +#define ANEG_MGBT_AN_STAT	0x21
> +#define CTRL_AB_2G5BT_BIT	BIT(7)
> +#define CTRL_AB_FR_2G5BT	BIT(5)
> +#define STAT_AB_2G5BT_BIT	BIT(5)
> +#define STAT_AB_FR_2G5BT	BIT(3)
> +
> +/* SGMII */
> +#define VSPEC1_SGMII_CTRL	0x08
> +#define VSPEC1_SGMII_CTRL_ANEN	BIT(12)		/* Aneg enable */
> +#define VSPEC1_SGMII_CTRL_ANRS	BIT(9)		/* Restart Aneg */
> +#define VSPEC1_SGMII_ANEN_ANRS	(VSPEC1_SGMII_CTRL_ANEN | \
> +				 VSPEC1_SGMII_CTRL_ANRS)
> +
> +/* WoL */
> +#define VPSPEC2_WOL_CTL		0x0E06
> +#define VPSPEC2_WOL_AD01	0x0E08
> +#define VPSPEC2_WOL_AD23	0x0E09
> +#define VPSPEC2_WOL_AD45	0x0E0A
> +#define WOL_EN			BIT(0)
> +
> +static int gpy_read_abilities(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = genphy_read_abilities(phydev);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Detect 2.5G/5G support. */
> +	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_STAT2);
> +	if (ret < 0)
> +		return ret;
> +	if (!(ret & MDIO_PMA_STAT2_EXTABLE))
> +		return 0;
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_EXTABLE);
> +	if (ret < 0)
> +		return ret;
> +	if (!(ret & MDIO_PMA_EXTABLE_NBT))
> +		return 0;
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_NG_EXTABLE);
> +	if (ret < 0)
> +		return ret;
> +
> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT,
> +			 phydev->supported,
> +			 ret & MDIO_PMA_NG_EXTABLE_2_5GBT);
> +
> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_5000baseT_Full_BIT,
> +			 phydev->supported,
> +			 ret & MDIO_PMA_NG_EXTABLE_5GBT);
> +
> +	return 0;
> +}
> +
> +static int gpy_config_init(struct phy_device *phydev)
> +{
> +	int ret, fw_ver;
> +
> +	/* Show GPY PHY FW version in dmesg */
> +	fw_ver = phy_read(phydev, PHY_FWV);
> +	if (fw_ver < 0)
> +		return fw_ver;
> +
> +	phydev_info(phydev, "Firmware Version: 0x%04X (%s)\n", fw_ver,
> +		    (fw_ver & BIT(15)) ? "release" : "test");
> +
> +	/* Mask all interrupts */
> +	ret = phy_write(phydev, PHY_IMASK, 0);
> +	if (ret)
> +		return ret;
> +
> +	/* Clear all pending interrupts */
> +	return phy_read(phydev, PHY_ISTAT);
> +}
> +
> +static bool gpy_sgmii_need_reaneg(struct phy_device *phydev)
> +{
> +	struct {
> +		int type;
> +		int minor;
> +	} table[] = {
> +		{7, 0x6D},
> +		{8, 0x6D},
> +		{9, 0x73},
> +	};
> +
> +	int fw_ver, fw_type, fw_minor;
> +	size_t i;
> +
> +	fw_ver = phy_read(phydev, PHY_FWV);
> +	if (fw_ver < 0)
> +		return true;
> +
> +	fw_type = FIELD_GET(PHY_FWV_TYPE_MASK, fw_ver);
> +	fw_minor = FIELD_GET(PHY_FWV_MINOR_MASK, fw_ver);
> +
> +	for (i = 0; i < ARRAY_SIZE(table); i++) {
> +		if (fw_type != table[i].type)
> +			continue;
> +		if (fw_minor < table[i].minor)
> +			return true;
> +		break;
> +	}
> +
> +	return false;
> +}
> +
> +static bool gpy_sgmii_2p5g_chk(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = phy_read(phydev, PHY_MIISTAT);
> +	if (ret < 0) {
> +		phydev_err(phydev, "Error: MDIO register access failed: %d\n",
> +			   ret);
> +		return false;
> +	}
> +
> +	if (!(ret & PHY_MIISTAT_LS)
> +	    || FIELD_GET(PHY_MIISTAT_SPD_MASK, ret) != PHY_MIISTAT_SPD_2500)
> +		return false;
> +
> +	phydev->speed = SPEED_2500;
> +	phydev->interface = PHY_INTERFACE_MODE_2500BASEX;
> +	phy_modify_mmd_changed(phydev, MDIO_MMD_VEND1,
> +			       VSPEC1_SGMII_CTRL,
> +			       VSPEC1_SGMII_CTRL_ANEN, 0);
> +	return true;
> +}
> +
> +static bool gpy_sgmii_aneg_en(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, VSPEC1_SGMII_CTRL);
> +	if (ret < 0) {
> +		phydev_err(phydev, "Error: MMD register access failed: %d\n",
> +			   ret);
> +		return true;

Don't we need some error handling here, instead of return true?

> +	}
> +
> +	return (ret & VSPEC1_SGMII_CTRL_ANEN) ? true : false;
> +}
> +
> +static int gpy_config_aneg(struct phy_device *phydev)
> +{
> +	bool changed = false;
> +	u32 adv;
> +	int ret;
> +
> +	if (phydev->autoneg == AUTONEG_DISABLE) {
> +		return phydev->duplex != DUPLEX_FULL
> +			? genphy_setup_forced(phydev)
> +			: genphy_c45_pma_setup_forced(phydev);
> +	}
> +
> +	ret = genphy_c45_an_config_aneg(phydev);
> +	if (ret < 0)
> +		return ret;
> +	if (ret)
> +		changed = true;
> +
> +	adv = linkmode_adv_to_mii_ctrl1000_t(phydev->advertising);
> +	ret = phy_modify_changed(phydev, MII_CTRL1000,
> +				 ADVERTISE_1000FULL | ADVERTISE_1000HALF,
> +				 adv);
> +	if (ret < 0)
> +		return ret;
> +	if (ret > 0)
> +		changed = true;
> +
> +	ret = genphy_c45_check_and_restart_aneg(phydev, changed);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (phydev->interface == PHY_INTERFACE_MODE_USXGMII
> +	    || phydev->interface == PHY_INTERFACE_MODE_INTERNAL)
> +		return 0;
> +
> +	/* No need to trigger re-ANEG if SGMII link speed is 2.5G
> +	 * or SGMII ANEG is disabled.
> +	 */
> +	if (!gpy_sgmii_need_reaneg(phydev) || gpy_sgmii_2p5g_chk(phydev)
> +	    || !gpy_sgmii_aneg_en(phydev))
> +		return 0;
> +
> +	/* There is a design constraint in GPY2xx device where SGMII AN is
> +	 * only triggered when there is change of speed. If, PHY link
> +	 * partner`s speed is still same even after PHY TPI is down and up
> +	 * again, SGMII AN is not triggered and hence no new in-band message
> +	 * from GPY to MAC side SGMII.
> +	 * This could cause an issue during power up, when PHY is up prior to
> +	 * MAC. At this condition, once MAC side SGMII is up, MAC side SGMII
> +	 * wouldn`t receive new in-band message from GPY with correct link
> +	 * status, speed and duplex info.
> +	 *
> +	 * 1) If PHY is already up and TPI link status is still down (such as
> +	 *    hard reboot), TPI link status is polled for 4 seconds before
> +	 *    retriggerring SGMII AN.
> +	 * 2) If PHY is already up and TPI link status is also up (such as soft
> +	 *    reboot), polling of TPI link status is not needed and SGMII AN is
> +	 *    immediately retriggered.
> +	 * 3) Other conditions such as PHY is down, speed change etc, skip
> +	 *    retriggering SGMII AN. Note: in case of speed change, GPY FW will
> +	 *    initiate SGMII AN.
> +	 */
> +
> +	if (phydev->state != PHY_UP)
> +		return 0;
> +
> +	ret = phy_read_poll_timeout(phydev, MII_BMSR, ret, ret & BMSR_LSTATUS,
> +				    20000, 4000000, false);
> +	if (ret == -ETIMEDOUT)
> +		return 0;
> +	else if (ret < 0)
> +		return ret;
> +
> +	/* Trigger SGMII AN. */
> +	return phy_modify_mmd_changed(phydev, MDIO_MMD_VEND1, VSPEC1_SGMII_CTRL,
> +				      VSPEC1_SGMII_CTRL_ANRS,
> +				      VSPEC1_SGMII_CTRL_ANRS);
> +}
> +
> +static void gpy_update_interface(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	/* Interface mode is fixed for USXGMII and integrated PHY */
> +	if (phydev->interface == PHY_INTERFACE_MODE_USXGMII
> +	    || phydev->interface == PHY_INTERFACE_MODE_INTERNAL)
> +		return;
> +
> +	/* Automatically switch SERDES interface between SGMII and 2500-BaseX
> +	 * according to speed. Disable ANEG in 2500-BaseX mode.
> +	 */
> +	switch (phydev->speed) {
> +	case SPEED_2500:
> +		phydev->interface = PHY_INTERFACE_MODE_2500BASEX;
> +		ret = phy_modify_mmd_changed(phydev, MDIO_MMD_VEND1,
> +					     VSPEC1_SGMII_CTRL,
> +					     VSPEC1_SGMII_CTRL_ANEN, 0);
> +		if (ret < 0)
> +			phydev_err(phydev,
> +				   "Error: Disable of SGMII ANEG failed: %d\n",
> +				   ret);
> +		break;
> +	case SPEED_1000:
> +	case SPEED_100:
> +	case SPEED_10:
> +		phydev->interface = PHY_INTERFACE_MODE_SGMII;
> +		if (gpy_sgmii_aneg_en(phydev))
> +			break;
> +		/* Enable and restart SGMII ANEG for 10/100/1000Mbps link speed
> +		 * if ANEG is disabled (in 2500-BaseX mode).
> +		 */
> +		ret = phy_modify_mmd_changed(phydev, MDIO_MMD_VEND1,
> +					     VSPEC1_SGMII_CTRL,
> +					     VSPEC1_SGMII_ANEN_ANRS,
> +					     VSPEC1_SGMII_ANEN_ANRS);
> +		if (ret < 0)
> +			phydev_err(phydev,
> +				   "Error: Enable of SGMII ANEG failed: %d\n",
> +				   ret);
> +		break;
> +	}
> +}
> +
> +static int gpy_read_status(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = genphy_update_link(phydev);
> +	if (ret)
> +		return ret;
> +
> +	phydev->speed = SPEED_UNKNOWN;
> +	phydev->duplex = DUPLEX_UNKNOWN;
> +	phydev->pause = 0;
> +	phydev->asym_pause = 0;
> +
> +	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete) {
> +		ret = genphy_c45_read_lpa(phydev);
> +		if (ret < 0)
> +			return ret;
> +
> +		/* Read the link partner's 1G advertisement */
> +		ret = phy_read(phydev, MII_STAT1000);
> +		if (ret < 0)
> +			return ret;
> +		mii_stat1000_mod_linkmode_lpa_t(phydev->lp_advertising, ret);
> +	} else if (phydev->autoneg == AUTONEG_DISABLE) {
> +		linkmode_zero(phydev->lp_advertising);
> +	}
> +
> +	ret = phy_read(phydev, PHY_MIISTAT);
> +	if (ret < 0)
> +		return ret;
> +
> +	phydev->link = (ret & PHY_MIISTAT_LS) ? 1 : 0;
> +	phydev->duplex = (ret & PHY_MIISTAT_DPX) ? DUPLEX_FULL : DUPLEX_HALF;
> +	switch (FIELD_GET(PHY_MIISTAT_SPD_MASK, ret)) {
> +	case PHY_MIISTAT_SPD_10:
> +		phydev->speed = SPEED_10;
> +		break;
> +	case PHY_MIISTAT_SPD_100:
> +		phydev->speed = SPEED_100;
> +		break;
> +	case PHY_MIISTAT_SPD_1000:
> +		phydev->speed = SPEED_1000;
> +		break;
> +	case PHY_MIISTAT_SPD_2500:
> +		phydev->speed = SPEED_2500;
> +		break;
> +	}
> +
> +	if (phydev->link)
> +		gpy_update_interface(phydev);
> +
> +	return 0;
> +}
> +
> +static int gpy_config_intr(struct phy_device *phydev)
> +{
> +	u16 mask = 0;
> +
> +	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
> +		mask = PHY_IMASK_MASK;
> +
> +	return phy_write(phydev, PHY_IMASK, mask);
> +}
> +
> +static irqreturn_t gpy_handle_interrupt(struct phy_device *phydev)
> +{
> +	int reg;
> +
> +	reg = phy_read(phydev, PHY_ISTAT);
> +	if (reg < 0) {
> +		phy_error(phydev);
> +		return IRQ_NONE;
> +	}
> +
> +	if (!(reg & PHY_IMASK_MASK))
> +		return IRQ_NONE;
> +
> +	phy_trigger_machine(phydev);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int gpy_set_wol(struct phy_device *phydev,
> +		       struct ethtool_wolinfo *wol)
> +{
> +	struct net_device *attach_dev = phydev->attached_dev;
> +	int ret;
> +
> +	if (wol->wolopts & WAKE_MAGIC) {
> +		/* MAC address - Byte0:Byte1:Byte2:Byte3:Byte4:Byte5
> +		 * VPSPEC2_WOL_AD45 = Byte0:Byte1
> +		 * VPSPEC2_WOL_AD23 = Byte2:Byte3
> +		 * VPSPEC2_WOL_AD01 = Byte4:Byte5
> +		 */
> +		ret = phy_set_bits_mmd(phydev, MDIO_MMD_VEND2,
> +				       VPSPEC2_WOL_AD45,
> +				       ((attach_dev->dev_addr[0] << 8) |
> +				       attach_dev->dev_addr[1]));
> +		if (ret < 0)
> +			return ret;
> +
> +		ret = phy_set_bits_mmd(phydev, MDIO_MMD_VEND2,
> +				       VPSPEC2_WOL_AD23,
> +				       ((attach_dev->dev_addr[2] << 8) |
> +				       attach_dev->dev_addr[3]));
> +		if (ret < 0)
> +			return ret;
> +
> +		ret = phy_set_bits_mmd(phydev, MDIO_MMD_VEND2,
> +				       VPSPEC2_WOL_AD01,
> +				       ((attach_dev->dev_addr[4] << 8) |
> +				       attach_dev->dev_addr[5]));
> +		if (ret < 0)
> +			return ret;
> +
> +		/* Enable the WOL interrupt */
> +		ret = phy_write(phydev, PHY_IMASK, PHY_IMASK_WOL);
> +		if (ret < 0)
> +			return ret;
> +
> +		/* Enable magic packet matching */
> +		ret = phy_set_bits_mmd(phydev, MDIO_MMD_VEND2,
> +				       VPSPEC2_WOL_CTL,
> +				       WOL_EN);
> +		if (ret < 0)
> +			return ret;
> +
> +		/* Clear the interrupt status register */
> +		ret = phy_read(phydev, PHY_ISTAT);
> +		if (ret < 0)
> +			return ret;
> +
> +	} else {
> +		/* Disable magic packet matching */
> +		ret = phy_clear_bits_mmd(phydev, MDIO_MMD_VEND2,
> +					 VPSPEC2_WOL_CTL,
> +					 WOL_EN);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	if (wol->wolopts & WAKE_PHY) {
> +		/* Enable the link state change interrupt */
> +		ret = phy_set_bits(phydev, PHY_IMASK, PHY_IMASK_LSTC);
> +		if (ret < 0)
> +			return ret;
> +
> +		/* Clear the interrupt status register */
> +		ret = phy_read(phydev, PHY_ISTAT);
> +	} else {
> +		/* Disable the link state change interrupt */
> +		ret = phy_clear_bits(phydev, PHY_IMASK, PHY_IMASK_LSTC);
> +	}
> +
> +	return ret;
> +}
> +
> +static void gpy_get_wol(struct phy_device *phydev,
> +			struct ethtool_wolinfo *wol)
> +{
> +	int ret;
> +
> +	wol->supported = WAKE_MAGIC | WAKE_PHY;
> +	wol->wolopts = 0;
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, VPSPEC2_WOL_CTL);
> +	if (ret & WOL_EN)
> +		wol->wolopts |= WAKE_MAGIC;
> +
> +	ret = phy_read(phydev, PHY_IMASK);
> +	if (ret & PHY_IMASK_LSTC)
> +		wol->wolopts |= WAKE_PHY;
> +}
> +
> +static int gpy_loopback(struct phy_device *phydev, bool enable)
> +{
> +	int ret;
> +
> +	ret = genphy_loopback(phydev, enable);

genphy_c45_loopback()

> +	if (!ret) {
> +		/* It takes some time for PHY deviceto switch

device to

> +		 * into/out-of loopback mode.
> +		 */
> +		usleep_range(100, 200);
> +	}
> +
> +	return ret;
> +}
> +
> +static struct phy_driver gpy_drivers[] = {
> +	{
> +		.phy_id		= PHY_ID_GPY,
> +		.phy_id_mask	= PHY_ID_MASK,
> +		.name		= "Maxlinear Ethernet GPY",
> +		.get_features	= gpy_read_abilities,
> +		.config_init	= gpy_config_init,
> +		.suspend	= genphy_suspend,
> +		.resume		= genphy_resume,

There is the new genphy_c45_pma_{suspend|resume} that you can use here.

> +		.config_aneg	= gpy_config_aneg,
> +		.aneg_done	= genphy_c45_aneg_done,
> +		.read_status	= gpy_read_status,
> +		.config_intr	= gpy_config_intr,
> +		.handle_interrupt = gpy_handle_interrupt,
> +		.set_wol	= gpy_set_wol,
> +		.get_wol	= gpy_get_wol,
> +		.set_loopback	= gpy_loopback,
> +	},
> +};
> +module_phy_driver(gpy_drivers);
> +
> +static struct mdio_device_id __maybe_unused gpy_tbl[] = {
> +	{PHY_ID_GPY, PHY_ID_MASK},
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(mdio, gpy_tbl);
> +
> +MODULE_DESCRIPTION("Maxlinear Ethernet GPY Driver");
> +MODULE_AUTHOR("Maxlinear Corporation");
> +MODULE_LICENSE("GPL");
