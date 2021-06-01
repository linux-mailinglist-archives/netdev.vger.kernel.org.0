Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5206E397372
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 14:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbhFAMnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 08:43:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38658 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233064AbhFAMnk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 08:43:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=gKKpO391XBh4leKxDCfefVpj0S/WsneY7p24wo8Y0XA=; b=g3FBSis3QYeuduL62EM7gmb8f/
        evZNb968/7GTyH34pb46Ehmvr79X+LyDvgix/ld5s8arGFIj3t72t9Rhip0TYhpesCiesZegNrhhA
        88A23GBnePETguY+bMlGKJHFpl7vUJ20VyXnd3JDkenHqzlE9xFc/BYk5cXtCD/+2mdY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lo3iW-007HrR-8n; Tue, 01 Jun 2021 14:41:56 +0200
Date:   Tue, 1 Jun 2021 14:41:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Xu Liang <lxu@maxlinear.com>
Cc:     hkallweit1@gmail.com, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, linux@armlinux.org.uk, hmehrtens@maxlinear.com,
        tmohren@maxlinear.com
Subject: Re: [PATCH] phy: maxlinear: add Maxlinear GPY115/21x/24x driver
Message-ID: <YLYrFDvGr7flA9rt@lunn.ch>
References: <20210601074427.40990-1-lxu@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601074427.40990-1-lxu@maxlinear.com>
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

This file is sorted based on the tristate string. So this entry should
come after the "Marvell 88X2222 PHY"


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

And this file is sorted on the CONFIG_XXX value.

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

Does genphy_c45_pma_read_abilities() do the wrong thing here? What
does it get wrong?

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

You define PHY_FWV_TYPE_MASK and PHY_FWV_MINOR_MASK. Does it make
sense to break this up a bit more?

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

Please make this const. And to fix reverse christmas tree, you might
want to move it out of the function.

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

This name got me for a while. p meaning point? I would prefer 
gpy_sgmii_2500_chk.

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

Then function is called SGMII but here you use 2500BaseX? Which is the
hardware doing?

> +static bool gpy_sgmii_aneg_en(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, VSPEC1_SGMII_CTRL);
> +	if (ret < 0) {
> +		phydev_err(phydev, "Error: MMD register access failed: %d\n",
> +			   ret);

You seem to like bool functions meaning you cannot return an error
code. You might want to consider using int.

> +		return true;
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

It is normal to put the || at the end of the line.

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

Please move the ||

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

can genphy_read_lpa() be used here?

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

It seems like there is the potential to loose other interrupts here?
I wonder if you should call phy_trigger_machine(phydev) if other bits
are set?

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
> +static struct phy_driver gpy_drivers[] = {
> +	{
> +		.phy_id		= PHY_ID_GPY,
> +		.phy_id_mask	= PHY_ID_MASK,

> +#define PHY_ID_MASK		GENMASK(31, 10)

That is a rather large mask? Can you split this up into individual
devices?


  Andrew
