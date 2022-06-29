Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0703B55F97D
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 09:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbiF2How (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 03:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbiF2Hot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 03:44:49 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4901037016;
        Wed, 29 Jun 2022 00:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=DyJ+EIV3CVOsR/CVCtlypG7BucCFTMptol7OZJQiOyA=; b=TB
        IUDUQ8PAFT6ucLGnQypMnma778FRENnZ8j4L7RDJog+cGoFwRtd60uGSigmJrSrY8oKl8RTwCCZzJ
        RhN9FdBS6Cd11KDjFtIkcFTLFmtJN4ArxwDdGlHwp6IdGbm3RPLUSJMQy1L220BKMzG1Gs1hjVuIN
        4lTqZdHJmhng4g8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o6SNJ-008gVX-AO; Wed, 29 Jun 2022 09:44:37 +0200
Date:   Wed, 29 Jun 2022 09:44:37 +0200
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
Subject: Re: [PATCH v2] net: phy: Add driver for Motorcomm yt8521 gigabit
 ethernet phy
Message-ID: <YrwC5X4oc8rXnubC@lunn.ch>
References: <20220628104245.35-1-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220628104245.35-1-Frank.Sae@motor-comm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int yt8521_probe(struct phy_device *phydev)
> +{
> +	struct device *dev = &phydev->mdio.dev;
> +	struct yt8521_priv *priv;
> +	int chip_config;
> +
> +	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	phy_lock_mdio_bus(phydev);
> +	chip_config = ytphy_read_ext(phydev, YT8521_CHIP_CONFIG_REG);
> +	phy_unlock_mdio_bus(phydev);
> +	if (chip_config < 0)
> +		return chip_config;
> +
> +	priv->strap_mode = chip_config & YT8521_CCR_MODE_SEL_MASK;
> +	switch (priv->strap_mode) {

Please add #defines for these magic numbers. In general, not magic
numbers in code.

> +	case 1:
> +	case 4:
> +	case 5:
> +		priv->polling_mode = YT8521_MODE_FIBER;
> +		break;
> +	case 2:
> +	case 6:
> +	case 7:
> +		priv->polling_mode = YT8521_MODE_POLL;
> +		break;
> +	case 3:
> +	case 0:
> +		priv->polling_mode = YT8521_MODE_UTP;
> +		break;
> +	}
> +
> +	phydev->priv = priv;
> +
> +	return 0;
> +}
> +
> +/**
> + * yt8521_adjust_status() - adjust speed and duplex according to is_utp, then
> + * update speed and duplex to phydev
> + *
> + * @phydev: a pointer to a &struct phy_device
> + * @status: yt8521 status read from YTPHY_SPECIFIC_STATUS_REG
> + * @is_utp: false(yt8521 work in fiber mode) or true(yt8521 work in utp mode)
> + *
> + * NOTE: there is no 10M speed mode in fiber mode, so need adjust.
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
> +		duplex = 1;

DUPLEX_FULL

> +
> +	speed_mode = (status & YTPHY_SSR_SPEED_MODE_MASK) >>
> +		     YTPHY_SSR_SPEED_MODE_OFFSET;
> +	switch (speed_mode) {
> +	case 0:

Please add #defines for these magic numbers

> +		if (is_utp)
> +			speed = SPEED_10;
> +		else
> +			speed = SPEED_UNKNOWN;
> +		break;
> +	case 1:
> +		speed = SPEED_100;
> +		break;
> +	case 2:
> +		speed = SPEED_1000;
> +		break;
> +	default:
> +		speed = SPEED_UNKNOWN;
> +		break;
> +	}
> +
> +	phydev->speed = speed;
> +	phydev->duplex = duplex;
> +	phydev->port = is_utp ? PORT_TP : PORT_FIBRE;
> +
> +	return 0;
> +}
> +
> +/**
> + * yt8521_read_status() -  determines the negotiated speed and duplex
> + * @phydev: a pointer to a &struct phy_device
> + *
> + * returns 0 or negative errno code
> + */
> +static int yt8521_read_status(struct phy_device *phydev)
> +{
> +	struct yt8521_priv *priv = phydev->priv;
> +	u8 polling_mode = priv->polling_mode;
> +	int old_link = phydev->link;
> +	int old_page;
> +	int status;
> +	int ret;
> +
> +	old_page = yt8521_read_page_with_lock(phydev);
> +	if (old_page)
> +		return old_page;
> +
> +	/* YT8521 has two reg space (utp/fiber) and three work mode (utp/fiber/poll),
> +	 * each reg space has MII standard regs. reg space should be properly set
> +	 * before read link status. Poll mode combines utp and faber mode,so
> +	 * need check both.
> +	 */
> +
> +	if (polling_mode == YT8521_MODE_UTP ||
> +	    polling_mode == YT8521_MODE_POLL) {
> +		ret = yt8521_write_page_with_lock(phydev,
> +						  YT8521_RSSR_UTP_SPACE);
> +		if (ret < 0)
> +			goto err_restore_page;
> +
> +		/* Update the link, but return if there was an error */
> +		ret = genphy_update_link(phydev);
> +		if (ret)
> +			goto err_restore_page;
> +
> +		/* why bother the PHY if nothing can have changed */
> +		if (phydev->autoneg == AUTONEG_ENABLE && old_link &&
> +		    phydev->link)
> +			return yt8521_write_page_with_lock(phydev, old_page);
> +
> +		phydev->speed = SPEED_UNKNOWN;
> +		phydev->duplex = DUPLEX_UNKNOWN;
> +		phydev->pause = 0;
> +		phydev->asym_pause = 0;
> +
> +		/* Read YTPHY_SPECIFIC_STATUS_REG, which indicates the
> +		 * speed and duplex of the PHY is actually using.
> +		 */
> +		status = phy_read(phydev, YTPHY_SPECIFIC_STATUS_REG);
> +		if (status < 0)
> +			goto err_restore_page;
> +
> +		/* check Link status real-time ,if linked then adjust the status*/
> +		if (status & YTPHY_SSR_LINK) {
> +			ret = yt8521_adjust_status(phydev, status, true);
> +			if (ret < 0)
> +				goto err_restore_page;
> +		}
> +		if (phydev->autoneg == AUTONEG_ENABLE &&
> +		    phydev->autoneg_complete)
> +			phy_resolve_aneg_pause(phydev);
> +	}
> +
> +	if (polling_mode == YT8521_MODE_FIBER ||
> +	    polling_mode == YT8521_MODE_POLL) {
> +		ret = yt8521_write_page_with_lock(phydev,
> +						  YT8521_RSSR_FIBER_SPACE);
> +		if (ret < 0)
> +			return ret;
> +
> +		/* Update the link, but return if there was an error */
> +		ret = genphy_update_link(phydev);
> +		if (ret)
> +			goto err_restore_page;
> +
> +		/* why bother the PHY if nothing can have changed */
> +		if (phydev->autoneg == AUTONEG_ENABLE && old_link &&
> +		    phydev->link)
> +			return yt8521_write_page_with_lock(phydev, old_page);
> +
> +		phydev->speed = SPEED_UNKNOWN;
> +		phydev->duplex = DUPLEX_UNKNOWN;
> +		phydev->pause = 0;
> +		phydev->asym_pause = 0;
> +
> +		/* Read YTPHY_SPECIFIC_STATUS_REG, which indicates the
> +		 * speed and duplex of the PHY is actually using.
> +		 */
> +		status = phy_read(phydev, YTPHY_SPECIFIC_STATUS_REG);
> +		if (status < 0)
> +			goto err_restore_page;
> +
> +		/* check Link status real-time ,if linked then adjust the status*/
> +		if (status & YTPHY_SSR_LINK) {
> +			ret = yt8521_adjust_status(phydev, status, false);
> +			if (ret < 0)
> +				goto err_restore_page;
> +		}
> +		if (phydev->autoneg == AUTONEG_ENABLE &&
> +		    phydev->autoneg_complete)
> +			phy_resolve_aneg_pause(phydev);
> +	}

This looks very similar to the code above. Can it be turned into a
helper?

> + * yt8521_modify_UTP_FIBER_BMCR - bits modify a PHY's BMCR register according to the
> + * current mode
> + * @phydev: the phy_device struct
> + * @mask: bit mask of bits to clear
> + * @set: bit mask of bits to set
> + *
> + * NOTE: Convenience function which allows a PHY‘s BMCR register to be
> + * modified as new register value = (old register value & ~mask) | set.
> + * YT8521 has two space (utp/fiber) and three mode (utp/fiber/poll), each space
> + * has MII_BMCR. poll mode combines utp and faber,so need do both.
> + * The caller must have taken the MDIO bus lock.
> + *
> + * returns 0 or negative errno code
> + */
> +static int yt8521_modify_UTP_FIBER_BMCR(struct phy_device *phydev, u16 mask,
> +					u16 set)

Please don't use upper case in function names.

> + * yt8521_soft_reset() - called to issue a PHY software reset
> + * @phydev: a pointer to a &struct phy_device
> + *
> + * returns 0 or negative errno code
> + */
> +int yt8521_soft_reset(struct phy_device *phydev)
> +{
> +	int old_page;
> +	int ret = 0;
> +
> +	old_page = phy_save_page(phydev);
> +	if (old_page < 0)
> +		goto err_restore_page;
> +
> +	ret = yt8521_modify_UTP_FIBER_BMCR(phydev, 0, BMCR_RESET);
> +	if (ret < 0)
> +		goto err_restore_page;

You should wait for the reset to completed. Can you actually use the
core helper? Is the BMCR in the usual place? So long as you hold the
lock, nothing is going to change the page, so you should be able to
use the helper.

> +	/* enable RXC clock when no wire plug */
> +	ret = ytphy_modify_ext(phydev, 0xc, BIT(12), 0);

#defines please.

> +	if (ret < 0)
> +		goto err_restore_page;
> +
> +err_restore_page:
> +	return phy_restore_page(phydev, old_page, ret);
> +}
> +
> +/**
> + * yt8521_config_aneg() - change reg space then call genphy_config_aneg
> + * @phydev: a pointer to a &struct phy_device
> + *
> + * returns 0 or negative errno code
> + */
> +int yt8521_config_aneg(struct phy_device *phydev)
> +{
> +	struct yt8521_priv *priv = phydev->priv;
> +	u8 polling_mode = priv->polling_mode;
> +	int old_page;
> +	int ret;
> +
> +	old_page = yt8521_read_page_with_lock(phydev);
> +	if (old_page)
> +		return old_page;
> +
> +	if (polling_mode == YT8521_MODE_FIBER ||
> +	    polling_mode == YT8521_MODE_POLL) {
> +		ret = yt8521_write_page_with_lock(phydev,
> +						  YT8521_RSSR_FIBER_SPACE);
> +		if (ret < 0)
> +			goto err_restore_page;
> +
> +		ret = genphy_config_aneg(phydev);
> +		if (ret < 0)
> +			goto err_restore_page;
> +	}
> +
> +	if (polling_mode == YT8521_MODE_UTP ||
> +	    polling_mode == YT8521_MODE_POLL) {
> +		ret = yt8521_write_page_with_lock(phydev,
> +						  YT8521_RSSR_UTP_SPACE);
> +		if (ret < 0)
> +			goto err_restore_page;
> +
> +		ret = genphy_config_aneg(phydev);
> +		if (ret < 0)
> +			goto err_restore_page;
> +	}

Looks like this could be refactored to reduce duplication.

> +
> +	return yt8521_write_page_with_lock(phydev, old_page);
> +
> +err_restore_page:
> +	yt8521_write_page_with_lock(phydev, old_page);
> +	return ret;
> +}
> +
> +/**
> + * yt8521_aneg_done() - determines the auto negotiation result
> + * @phydev: a pointer to a &struct phy_device
> + *
> + * returns 0(no link)or 1( fiber or utp link) or negative errno code
> + */
> +int yt8521_aneg_done(struct phy_device *phydev)
> +{
> +	struct yt8521_priv *priv = phydev->priv;
> +	u8 polling_mode = priv->polling_mode;
> +	int link_fiber = 0;
> +	int link_utp = 0;
> +	int old_page;
> +	int ret = 0;
> +
> +	old_page = phy_save_page(phydev);
> +	if (old_page < 0)
> +		goto err_restore_page;
> +
> +	if (polling_mode == YT8521_MODE_FIBER ||
> +	    polling_mode == YT8521_MODE_POLL) {
> +		/* switch to FIBER reg space*/
> +		ret = yt8521_write_page(phydev, YT8521_RSSR_FIBER_SPACE);
> +		if (ret < 0)
> +			goto err_restore_page;
> +
> +		ret = __phy_read(phydev, YTPHY_SPECIFIC_STATUS_REG);
> +		if (ret < 0)
> +			goto err_restore_page;
> +
> +		link_fiber = !!(ret & YTPHY_SSR_LINK);
> +	}
> +
> +	if (polling_mode == YT8521_MODE_UTP ||
> +	    polling_mode == YT8521_MODE_POLL) {
> +		/* switch to UTP reg space */
> +		ret = yt8521_write_page(phydev, YT8521_RSSR_UTP_SPACE);
> +		if (ret < 0)
> +			goto err_restore_page;
> +
> +		ret = __phy_read(phydev, YTPHY_SPECIFIC_STATUS_REG);
> +		if (ret < 0)
> +			goto err_restore_page;
> +
> +		link_utp = !!(ret & YTPHY_SSR_LINK);
> +	}
> +
> +	ret = !!(link_fiber | link_utp);

Does this mean it can do both copper and fibre at the same time. And
whichever gives up first wins?

	  Andrew
