Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8BDF681DAB
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 23:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbjA3WGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 17:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbjA3WGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 17:06:35 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7B4305F3;
        Mon, 30 Jan 2023 14:06:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ztecZ3g9LjCJKcTxS5Z/dUk/Qeli1L8qLCCV3a3CLLQ=; b=eMWWR9+moYsrurBf1z3IJg3Uqa
        WatXSAdV0EqjHl4H+f5Aef93khfIYyfjme/nmWPfYbZF2mtFe/bpwiKZH4VyJzPXaeir76OME+Kwu
        MS/ObPKSSI6Ls8y/t2+UZbxJElkeL89e6mNjV95YdupW+qYNKnwvY0XQFne7ifB7kjdA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pMcID-003ctt-PY; Mon, 30 Jan 2023 23:06:25 +0100
Date:   Mon, 30 Jan 2023 23:06:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: Re: [PATCH net-next v3 05/15] net: phy: add
 genphy_c45_ethtool_get/set_eee() support
Message-ID: <Y9g/YSTaSKRoAWos@lunn.ch>
References: <20230130080714.139492-1-o.rempel@pengutronix.de>
 <20230130080714.139492-6-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130080714.139492-6-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/**
> + * genphy_c45_write_eee_adv - read advertised EEE link modes

s/read/write

> + * @phydev: target phy_device struct
> + */
> +int genphy_c45_write_eee_adv(struct phy_device *phydev, unsigned long *adv)
> +{
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(common);
> +	int val, changed;
> +
> +	linkmode_and(common, phydev->supported_eee, PHY_EEE_100_10000_FEATURES);
> +	if (!linkmode_empty(common)) {
> +		val = linkmode_adv_to_mii_eee_100_10000_adv_t(adv);
> +
> +		/* In eee_broken_modes are stored MDIO_AN_EEE_ADV specific raw
> +		 * register values.
> +		 */
> +		val &= ~phydev->eee_broken_modes;
> +
> +		val = phy_modify_mmd_changed(phydev, MDIO_MMD_AN,
> +					     MDIO_AN_EEE_ADV,
> +					     MDIO_EEE_100TX | MDIO_EEE_1000T |
> +					     MDIO_EEE_10GT | MDIO_EEE_1000KX |
> +					     MDIO_EEE_10GKX4 | MDIO_EEE_10GKR,
> +					     val);
> +		if (val < 0)
> +			return val;
> +		if (val > 0)
> +			changed = 1;
> +	}
> +
> +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_10baseT1L_Full_BIT,
> +			      phydev->supported_eee)) {
> +		val = linkmode_adv_to_mii_10base_t1_t(adv);
> +
> +		val = phy_modify_mmd_changed(phydev, MDIO_MMD_AN,
> +					     MDIO_AN_10BT1_AN_CTRL,
> +					     MDIO_AN_10BT1_AN_CTRL_ADV_EEE_T1L,
> +					     val);
> +		if (val < 0)
> +			return val;
> +		if (val > 0)
> +			changed = 1;
> +	}
> +
> +	return changed;
> +}
> +
> +/**
> + * genphy_c45_read_eee_adv - read advertised EEE link modes
> + * @phydev: target phy_device struct
> + */
> +static int genphy_c45_read_eee_adv(struct phy_device *phydev,
> +				   unsigned long *adv)
> +{
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(common);
> +	int val;
> +
> +	linkmode_and(common, phydev->supported_eee, PHY_EEE_100_10000_FEATURES);
> +	if (!linkmode_empty(common)) {
> +		/* IEEE 802.3-2018 45.2.7.13 EEE advertisement 1
> +		 * (Register 7.60)
> +		 */
> +		val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV);
> +		if (val < 0)
> +			return val;
> +
> +		mii_eee_100_10000_adv_mod_linkmode_t(adv, val);
> +	}
> +
> +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_10baseT1L_Full_BIT,
> +			      phydev->supported_eee)) {
> +		/* IEEE 802.3cg-2019 45.2.7.25 10BASE-T1 AN control register
> +		 * (Register 7.526)
> +		 */
> +		val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_10BT1_AN_CTRL);
> +		if (val < 0)
> +			return val;
> +
> +		mii_10base_t1_adv_mod_linkmode_t(adv, val);
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * genphy_c45_read_eee_lpa - read advertised LP EEE link modes
> + * @phydev: target phy_device struct
> + */
> +static int genphy_c45_read_eee_lpa(struct phy_device *phydev,
> +				   unsigned long *lpa)
> +{
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(common);
> +	int val;
> +
> +	linkmode_and(common, phydev->supported_eee, PHY_EEE_100_10000_FEATURES);
> +	if (!linkmode_empty(common)) {
> +		/* IEEE 802.3-2018 45.2.7.14 EEE link partner ability 1
> +		 * (Register 7.61)
> +		 */
> +		val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_LPABLE);
> +		if (val < 0)
> +			return val;
> +
> +		mii_eee_100_10000_adv_mod_linkmode_t(lpa, val);
> +	}
> +
> +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_10baseT1L_Full_BIT,
> +			      phydev->supported_eee)) {
> +		/* IEEE 802.3cg-2019 45.2.7.26 10BASE-T1 AN status register
> +		 * (Register 7.527)
> +		 */
> +		val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_10BT1_AN_STAT);
> +		if (val < 0)
> +			return val;
> +
> +		mii_10base_t1_adv_mod_linkmode_t(lpa, val);
> +	}
> +
> +	return 0;
> +}
> +
>  /**
>   * genphy_c45_read_eee_abilities - read supported EEE link modes
>   * @phydev: target phy_device struct
> @@ -1173,6 +1294,80 @@ int genphy_c45_plca_get_status(struct phy_device *phydev,
>  }
>  EXPORT_SYMBOL_GPL(genphy_c45_plca_get_status);
>  
> +/**
> + * genphy_c45_ethtool_get_eee - get EEE supported and status
> + * @phydev: target phy_device struct
> + * @data: ethtool_eee data
> + *
> + * Description: it reportes the Supported/Advertisement/LP Advertisement
> + * capabilities.
> + */
> +int genphy_c45_ethtool_get_eee(struct phy_device *phydev,
> +			       struct ethtool_eee *data)
> +{
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv) = {};
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(lp) = {};
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(common);
> +	int ret;
> +
> +	ret = genphy_c45_read_eee_adv(phydev, adv);
> +	if (ret)
> +		return ret;
> +
> +	ret = genphy_c45_read_eee_lpa(phydev, lp);
> +	if (ret)
> +		return ret;
> +
> +	data->eee_enabled = !linkmode_empty(adv);
> +	linkmode_and(common, adv, lp);
> +	if (data->eee_enabled && !linkmode_empty(common))
> +		data->eee_active = phy_check_valid(phydev->speed,
> +						   phydev->duplex, common);
> +	else
> +		data->eee_active = false;
> +
> +	/* FIXME: EEE ethtool interface currently do not support full set of
> +	 * possible EEE link modes.
> +	 */
> +	data->supported = phydev->supported_eee[0];
> +	data->advertised = adv[0];
> +	data->lp_advertised = lp[0];
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(genphy_c45_ethtool_get_eee);
> +
> +/**
> + * genphy_c45_ethtool_set_eee - get EEE supported and status
> + * @phydev: target phy_device struct
> + * @data: ethtool_eee data
> + *
> + * Description: it reportes the Supported/Advertisement/LP Advertisement
> + * capabilities.
> + */
> +int genphy_c45_ethtool_set_eee(struct phy_device *phydev,
> +			       struct ethtool_eee *data)
> +{
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv) = {};
> +	int ret;
> +
> +	if (data->eee_enabled) {
> +		if (data->advertised)
> +			adv[0] = data->advertised;
> +		else
> +			linkmode_copy(adv, phydev->supported_eee);
> +	}
> +
> +	ret = genphy_c45_write_eee_adv(phydev, adv);
> +	if (ret < 0)
> +		return ret;
> +	if (ret > 0)
> +		return phy_restart_aneg(phydev);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(genphy_c45_ethtool_set_eee);
> +
>  struct phy_driver genphy_c45_driver = {
>  	.phy_id         = 0xffffffff,
>  	.phy_id_mask    = 0xffffffff,
> diff --git a/include/linux/mdio.h b/include/linux/mdio.h
> index ea4f7d08d1a6..231cf02671a7 100644
> --- a/include/linux/mdio.h
> +++ b/include/linux/mdio.h
> @@ -427,6 +427,42 @@ static inline void mii_eee_100_10000_adv_mod_linkmode_t(unsigned long *adv,
>  			 adv, val & MDIO_EEE_10GKR);
>  }
>  
> +static inline u32 linkmode_adv_to_mii_eee_100_10000_adv_t(unsigned long *adv)
> +{
> +	u32 result = 0;
> +
> +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT, adv))
> +		result |= MDIO_EEE_100TX;
> +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT, adv))
> +		result |= MDIO_EEE_1000T;
> +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_10000baseT_Full_BIT, adv))
> +		result |= MDIO_EEE_10GT;
> +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_1000baseKX_Full_BIT, adv))
> +		result |= MDIO_EEE_1000KX;
> +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT, adv))
> +		result |= MDIO_EEE_10GKX4;
> +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT, adv))
> +		result |= MDIO_EEE_10GKR;
> +
> +	return result;

Please could you remove the duplication with ethtool_adv_to_mmd_eee_adv_t().

       Andrew
