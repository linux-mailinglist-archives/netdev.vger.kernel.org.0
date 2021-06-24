Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454EF3B3486
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 19:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbhFXRSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 13:18:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54210 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229573AbhFXRSH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 13:18:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kSsjxwZRslySf80Y/EKfWIecdzmcKIG4X3T8rjafjRg=; b=3gD2r8ljGNIJ2DQzUCKQoLjZ4O
        f61BUlvCWKdfaMRjhF3qTiAeHeC1lR4PA4hegSDpogsTnTNJfIHcPAzBdpD5pu6o5LQMOD18atCi1
        B76XwHbcJhwOLYcIQHLtDDd8OdVecB9hW2XdidxWZpX5bWVAzuc0oMGUO4d4Up1bIVh8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lwSx7-00B0SK-Fy; Thu, 24 Jun 2021 19:15:45 +0200
Date:   Thu, 24 Jun 2021 19:15:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     alexandru.tachici@analog.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: Re: [PATCH 1/4] net: phy: adin1100: Add initial support for ADIN1100
 industrial PHY
Message-ID: <YNS9wb/HjxZZA1rE@lunn.ch>
References: <20210624145353.6910-1-alexandru.tachici@analog.com>
 <20210624145353.6910-2-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210624145353.6910-2-alexandru.tachici@analog.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static const int phy_10_features_array[] = {
> +	ETHTOOL_LINK_MODE_10baseT_Full_BIT,
> +};

Since this is a T1 PHY, please add a
ETHTOOL_LINK_MODE_10baseT1_Full_BIT definition, and use that. It looks
like the device also supports half duplex? So add
ETHTOOL_LINK_MODE_10baseT1_Half_BIT as well.

What does genphy_read_abilities() determine for this device? Is there
a standardized way to detect 10BaseT1?

> +
> +#define ADIN_B10L_PCS_CNTRL			0x08e6
> +#define   ADIN_PCS_CNTRL_B10L_LB_PCS_EN		BIT(14)
> +
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
> +/**
> + * struct adin_priv - ADIN PHY driver private data
> + * tx_level_24v			set if the PHY supports 2.4V TX levels (10BASE-T1L)
> + */
> +struct adin_priv {
> +	unsigned int		tx_level_24v:1;
> +};
> +

> +static int adin_match_phy_device(struct phy_device *phydev)
> +{
> +	struct mii_bus *bus = phydev->mdio.bus;
> +	int phy_addr = phydev->mdio.addr;
> +	u32 id;
> +	int rc;
> +
> +	mutex_lock(&bus->mdio_lock);
> +
> +	/* Need to call __mdiobus_read() directly here, because at this point
> +	 * in time, the driver isn't attached to the PHY device.
> +	 */
> +	rc = __mdiobus_read(bus, phy_addr, MDIO_DEVID1);
> +	if (rc < 0) {
> +		mutex_unlock(&bus->mdio_lock);
> +		return rc;
> +	}
> +
> +	id = rc << 16;
> +
> +	rc = __mdiobus_read(bus, phy_addr, MDIO_DEVID2);
> +	mutex_unlock(&bus->mdio_lock);
> +
> +	if (rc < 0)
> +		return rc;
> +
> +	id |= rc;
> +
> +	switch (id) {
> +	case PHY_ID_ADIN1100:
> +		return 1;
> +	default:
> +		return 0;
> +	}
> +}

I must be missing something here. Why do you need this?

> +static void adin_mii_adv_m_to_ethtool_adv_t(unsigned long *advertising, u32 adv)
> +{
> +	if (adv & ADIN_AN_LP_ADV_B10L)
> +		linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT, advertising);
> +	if (adv & ADIN_AN_LP_ADV_B1000) {
> +		linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT, advertising);
> +		linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT, advertising);
> +	}
> +	if (adv & ADIN_AN_LP_ADV_B10S_FD)
> +		linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT, advertising);
> +	if (adv & ADIN_AN_LP_ADV_B100)
> +		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT, advertising);

Since this is a T1 PHY, i assume these are all T1 link modes? Please
use ETHTOOL_LINK_MODE_1000baseT1_Half_BIT,
ETHTOOL_LINK_MODE_100baseT1_Full_BIT, etc.


> +static void adin_link_change_notify(struct phy_device *phydev)
> +{
> +	bool tx_level_24v;
> +	bool lp_tx_level_24v;
> +	int val, mask;
> +
> +	if (phydev->state != PHY_RUNNING || phydev->autoneg == AUTONEG_DISABLE)
> +		return;
> +
> +	val = phy_read_mmd(phydev, MDIO_MMD_AN, ADIN_AN_LP_ADV_ABILITY_H);
> +	if (val < 0)
> +		return;
> +
> +	mask = ADIN_AN_LP_ADV_B10L_TX_LVL_HI_ABL | ADIN_AN_LP_ADV_B10L_TX_LVL_HI_REQ;
> +	lp_tx_level_24v = (val & mask) == mask;
> +
> +	val = phy_read_mmd(phydev, MDIO_MMD_AN, ADIN_AN_ADV_ABILITY_H);
> +	if (val < 0)
> +		return;
> +
> +	mask = ADIN_AN_ADV_B10L_TX_LVL_HI_ABL | ADIN_AN_ADV_B10L_TX_LVL_HI_REQ;
> +	tx_level_24v = (val & mask) == mask;
> +
> +	if (tx_level_24v && lp_tx_level_24v)
> +		phydev_info(phydev, "Negotiated 2.4V TX level\n");
> +	else
> +		phydev_info(phydev, "Negotiated 1.0V TX level\n");>

We have ETHTOOL_LINK_MODE_Autoneg_BIT to indicate autoneg is
supported.  Maybe we should add ETHTOOL_LINK_MODE_2400mv_BIT? Are
there other voltages defined in the standards?

> +static int adin_set_powerdown_mode(struct phy_device *phydev, bool en)
> +{
> +	int ret, timeout;
> +	u16 val;
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
> +	timeout = 30;
> +	while (timeout-- > 0) {
> +		ret = phy_read_mmd(phydev, MDIO_MMD_VEND1,
> +				   ADIN_CRSM_STAT);
> +		if (ret < 0)
> +			return ret;
> +
> +		if ((ret & ADIN_CRSM_SFT_PD_RDY) == val)
> +			return 0;
> +
> +		mdelay(1);
> +	}
> +
> +	return -ETIMEDOUT;

We already have phy_read_poll_timeout(). Please add a
phy_read_mmd_poll_timeout() function.

> +static int adin_set_loopback(struct phy_device *phydev, bool enable)
> +{
> +	int ret;
> +
> +	if (enable)
> +		return phy_set_bits_mmd(phydev, MDIO_MMD_PCS,
> +					ADIN_B10L_PCS_CNTRL,
> +					ADIN_PCS_CNTRL_B10L_LB_PCS_EN);
> +
> +	/* MAC interface block loopback */
> +	ret = phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1, ADIN_MAC_IF_LOOPBACK,
> +				 ADIN_MAC_IF_LOOPBACK_EN |
> +				 ADIN_MAC_IF_REMOTE_LOOPBACK_EN);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* PCS loopback (according to 10BASE-T1L spec) */
> +	ret = phy_clear_bits_mmd(phydev, MDIO_MMD_PCS, ADIN_B10L_PCS_CNTRL,
> +				 ADIN_PCS_CNTRL_B10L_LB_PCS_EN);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* PMA loopback (according to 10BASE-T1L spec) */
> +	return phy_clear_bits_mmd(phydev, MDIO_MMD_PMAPMD, ADIN_B10L_PMA_CNTRL,
> +				  ADIN_PMA_CNTRL_B10L_LB_PMA_LOC_EN);

Why three loopbacks at the same time. The outgoing frame it going to
hit the first loopback, and never reach the other two.

    Andrew
