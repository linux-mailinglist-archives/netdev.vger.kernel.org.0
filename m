Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 010DE5A8994
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 01:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiHaXtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 19:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiHaXtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 19:49:17 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D195EA310;
        Wed, 31 Aug 2022 16:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ymVxlH0A9lwWpFSXSFQc8WNIndkyagzXhqbOaAMvPpk=; b=0p1G0DA76yf8/T/CoR/vH5hSqt
        W2PD9CWrJo6bAVsXeNfzmQO8EjfXpSxPdEm1b8euC37VFQLqIHI17ofXnqetIRWSl/2QngNsVyQvT
        cvXYXqmGUZN9rzrxKo0qHuvYav5wuGBIeZ9N9fmGgvLs4bLc49uMY6c1/j80SF8Tzns4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oTXS2-00FFU3-IM; Thu, 01 Sep 2022 01:48:54 +0200
Date:   Thu, 1 Sep 2022 01:48:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Frank <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, yinghong.zhang@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v5] net: phy: Add driver for Motorcomm yt8521
 gigabit ethernet phy
Message-ID: <Yw/zZqfhuiYQqSYR@lunn.ch>
References: <20220831015235.455-1-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831015235.455-1-Frank.Sae@motor-comm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> + * yt8521_adjust_status() - update speed and duplex to phydev. when in fiber
> + * mode, adjust speed and duplex.
> + *
> + * @phydev: a pointer to a &struct phy_device
> + * @status: yt8521 status read from YTPHY_SPECIFIC_STATUS_REG
> + * @is_utp: false(yt8521 work in fiber mode) or true(yt8521 work in utp mode)
> + *
> + * NOTE: there is no 10M speed mode in fiber mode, so need adjust.

You appear to only advertise 1G speeds. Does 100M actually work, but
you don't advertise it?

> + *
> + * returns 0
> + */
> +static int yt8521_adjust_status(struct phy_device *phydev, int status,
> +				bool is_utp)
> +{
> +	int speed_mode, duplex;
> +	int speed;
> +
> +	if (is_utp)
> +		duplex = (status & YTPHY_SSR_DUPLEX) >> YTPHY_SSR_DUPLEX_OFFSET;
> +	else
> +		duplex = DUPLEX_FULL;

I could be reading yt8521_fiber_config_aneg() wrong, but you appear to
be ADVERTISE_1000XHALF. Yet here you force full duplex?

> +
> +	speed_mode = (status & YTPHY_SSR_SPEED_MODE_MASK) >>
> +		     YTPHY_SSR_SPEED_MODE_OFFSET;
> +
> +	switch (speed_mode) {
> +	case YTPHY_SSR_SPEED_10M:
> +		if (is_utp)
> +			speed = SPEED_10;
> +		else
> +			speed = SPEED_UNKNOWN;
> +		break;

Does this mean the hardware can actually report 10M, even though it
does not support it?

> +static int yt8521_fiber_config_aneg(struct phy_device *phydev)
> +{
> +	int err, changed = 0;
> +	u16 adv;
> +
> +	if (phydev->autoneg != AUTONEG_ENABLE)
> +		return yt8521_fiber_setup_forced(phydev);
> +
> +	err =  ytphy_modify_ext_with_lock(phydev, YTPHY_MISC_CONFIG_REG,
> +					  YTPHY_MCR_FIBER_SPEED_MASK,
> +					  YTPHY_MCR_FIBER_1000BX);
> +	if (err < 0)
> +		return err;
> +
> +	/* enable Fiber auto sensing */
> +	err =  ytphy_modify_ext_with_lock(phydev, YT8521_LINK_TIMER_CFG2_REG,
> +					  0, YT8521_LTCR_EN_AUTOSEN);
> +	if (err < 0)
> +		return err;
> +
> +	/* Only allow advertising what this PHY supports */
> +	linkmode_and(phydev->advertising, phydev->advertising,
> +		     phydev->supported);

phylib does this step for you. phydev->advertising should always be a
subset of phydev->supported.

> +
> +	/* some mac not support ETHTOOL_LINK_MODE_1000baseX_Full_BIT, so use
> +	 * ETHTOOL_LINK_MODE_1000baseT_Full_BIT instead.
> +	 */
> +	adv = linkmode_adv_to_mii_adv_x(phydev->advertising,
> +					ETHTOOL_LINK_MODE_1000baseT_Full_BIT);

I don't follow this. When the PHY driver is loaded, it should set
phydev->supported with everything it supports. So that should include
both ETHTOOL_LINK_MODE_1000baseX_Full_BIT and
ETHTOOL_LINK_MODE_1000baseT_Full_BIT.

Generally, the MAC removes modes by calling phy_set_max_speed(). Or it
ask for the 1/2 duplex modes to be removed. I don't think i've seen a
MAC remove ETHTOOL_LINK_MODE_1000baseX_Full_BIT.

Please can you point to code which does this.

> +
> +	/* Setup fiber advertisement */
> +	err = phy_modify_changed(phydev, MII_ADVERTISE,
> +				 ADVERTISE_1000XHALF | ADVERTISE_1000XFULL |
> +				 ADVERTISE_1000XPAUSE | ADVERTISE_1000XPSE_ASYM,
> +				 adv);
> +	if (err < 0)
> +		return err;
> +
> +	if (err > 0)
> +		changed = 1;
> +
> +	return genphy_check_and_restart_aneg(phydev, changed);
> +}
> +
> +/**
> + * yt8521_config_aneg_paged() - switch reg space then call genphy_config_aneg
> + * of one page
> + * @phydev: a pointer to a &struct phy_device
> + * @page: The reg page(YT8521_RSSR_FIBER_SPACE/YT8521_RSSR_UTP_SPACE) to
> + * operate.
> + *
> + * returns 0 or negative errno code
> + */
> +static int yt8521_config_aneg_paged(struct phy_device *phydev, int page)
> +{
> +	struct yt8521_priv *priv = phydev->priv;
> +	int old_page;
> +	int ret = 0;
> +
> +	page &= YT8521_RSSR_SPACE_MASK;
> +
> +	old_page = phy_select_page(phydev, page);
> +	if (old_page < 0)
> +		goto err_restore_page;
> +
> +	/* If reg_page is YT8521_RSSR_TO_BE_ARBITRATED,
> +	 * phydev->supported and phydev->advertising should be updated.
> +	 */
> +	if (priv->reg_page == YT8521_RSSR_TO_BE_ARBITRATED) {
> +		if (page == YT8521_RSSR_FIBER_SPACE)
> +			linkmode_and(phydev->supported, priv->fiber_supported,
> +				     priv->utp_mac_supported);
> +		else
> +			linkmode_and(phydev->supported, priv->utp_supported,
> +				     priv->utp_mac_supported);
> +
> +		phy_advertise_supported(phydev);
> +	}

This is another place the two line side model falls apart. You should
not be modifying phydev->supported, because how do you get back the
bits your cleared when it swaps from one to the other? phylib has no
concept of phydev->supported changing at run time. It is set when the
PHY probes, and only changed when the MAC remove what it does not
support.

You need yt8521_fiber_config_aneg() to take a copy of
phydev->advertising, mask out what fibre does not support, and program
the hardware based on that. You need yt8521_utp_config_aneg() to take
a copy of phydev->advertising, mask out what copper does not support,
and program the hardware based on that. phydev->supported and
phydev->advertising should always be a superset of both copper and
fibre, if both are available.

Maybe, in a flow up patch, you can actually look at
phydev->advertising, see all the fibre modes have been removed, fibre
will never get link, and so power the fibre off. Or all the copper
modes have been removed, the copper will never get link, so turn it
off.

> +static int yt8521_get_features_paged(struct phy_device *phydev, int page)
> +{
> +	struct yt8521_priv *priv = phydev->priv;
> +	int old_page;
> +	int ret = 0;
> +
> +	page &= YT8521_RSSR_SPACE_MASK;
> +
> +	old_page = phy_select_page(phydev, page);
> +	if (old_page < 0)
> +		goto err_restore_page;
> +
> +	if (page == YT8521_RSSR_FIBER_SPACE) {
> +		linkmode_zero(priv->fiber_supported);
> +
> +		/* some mac not support 1000baseX_Full, so use 1000baseT_Full
> +		 * instead.
> +		 */
> +		phylink_set(priv->fiber_supported, 1000baseT_Full);

Ah. That partially explains the above. But you really are doing
1000baseX_Full here, so that is what you should set as supported.

> +		phylink_set(priv->fiber_supported, Autoneg);
> +		phylink_set(priv->fiber_supported, Pause);
> +		phylink_set(priv->fiber_supported, Asym_Pause);
> +		linkmode_copy(phydev->supported, priv->fiber_supported);
> +	} else {
> +		linkmode_zero(priv->utp_supported);
> +
> +		/* unlock mdio bus during genphy_read_abilities,
> +		 * because it will operate this lock.
> +		 */
> +		phy_unlock_mdio_bus(phydev);
> +		ret = genphy_read_abilities(phydev);
> +		phy_lock_mdio_bus(phydev);
> +
> +		linkmode_copy(priv->utp_supported, phydev->supported);
> +	}
> +
> +err_restore_page:
> +	return phy_restore_page(phydev, old_page, ret);
> +}
> +
> +/**
> + * yt8521_get_features - switch reg space then call yt8521_get_features_paged
> + * @phydev: target phy_device struct
> + *
> + * returns 0 or negative errno code
> + */
> +static int yt8521_get_features(struct phy_device *phydev)
> +{
> +	struct yt8521_priv *priv = phydev->priv;
> +	int ret;
> +
> +	if (priv->reg_page != YT8521_RSSR_TO_BE_ARBITRATED) {
> +		ret = yt8521_get_features_paged(phydev, priv->reg_page);
> +	} else {
> +		linkmode_zero(priv->utp_mac_supported);
> +
> +		/* Get the features of utp and fiber, save them to
> +		 * priv->utp_supported and priv->fiber_supported.
> +		 * Aftert get both features, phydev->supported is the features
> +		 * of utp.
> +		 */
> +		ret = yt8521_get_features_paged(phydev,
> +						YT8521_RSSR_FIBER_SPACE);
> +		if (ret < 0)
> +			return ret;
> +
> +		ret = yt8521_get_features_paged(phydev,
> +						YT8521_RSSR_UTP_SPACE);
> +		if (ret < 0)
> +			return ret;
> +	}

If you are strapped to just UTP, set phydev->supported to just what
the copper side supports. If you are strapped to fibre, set
phydev->supported to what the fibre side supports. And if you are in
'whatever wins first mode', you need to set it to the superset.

	  Andrew
