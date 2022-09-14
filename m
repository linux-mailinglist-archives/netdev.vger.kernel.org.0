Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBBE25B8608
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 12:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiINKNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 06:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiINKNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 06:13:35 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B15C21267;
        Wed, 14 Sep 2022 03:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=SMMfDV/qgPfXjoJXWylOHL4DAz4NjIRd7Xc11YJj6/Q=; b=oNRHdDrL51DpaHi8SeVV4Iy42o
        BlI4ijdxy1JU4PGz81FIE3Zmj56jgwGJwQfVhEDTSHxvceBAQUtlidYSWGcL2ytq1A2fio2bsMwjQ
        8JEv1tW+yLFtutLxz0qMYSW4okJaPufz/D/0haDbfeSK8YbZMCVUgYCxz73donkviVg7YcUmycW5M
        1g9AhV9Y0560G4kkkJg+Iwztqh/TbYdnCc9OREQbY8C4/NuDitc27pOAufj/2wDm9ReCfjtm0KIPj
        rALpztv95ln1AhfWClYdume4GbQZD01WrrZ7L55nRXyTZ6rRqLTVvngpg3vu8sui7AaCNyWffEFAe
        zgZJ5xDg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34314)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oYPOQ-0004Eg-If; Wed, 14 Sep 2022 11:13:18 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oYPOL-0001Yj-Tc; Wed, 14 Sep 2022 11:13:13 +0100
Date:   Wed, 14 Sep 2022 11:13:13 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Frank <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, yinghong.zhang@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6] net: phy: Add driver for Motorcomm yt8521
 gigabit ethernet phy
Message-ID: <YyGpORi7l1F0to2M@shell.armlinux.org.uk>
References: <20220914093209.1960-1-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220914093209.1960-1-Frank.Sae@motor-comm.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 14, 2022 at 05:32:09PM +0800, Frank wrote:
> +static int ytphy_modify_ext(struct phy_device *phydev, u16 regnum, u16 mask,
> +			    u16 set)
> +{
> +	u16 val;
> +	int ret;
> +
> +	ret = ytphy_read_ext(phydev, regnum);
> +	if (ret < 0)
> +		return ret;
> +
> +	val = ret & 0xffff;
> +	val &= ~mask;
> +	val |= set;
> +
> +	return ytphy_write_ext(phydev, regnum, val);

Is there a reason not to implement this as:

	ret = __phy_write(phydev, YTPHY_PAGE_SELECT, regnum);
	if (ret < 0)
		return ret;

	return __phy_modify(phydev, YTPHY_PAGE_DATA, mask, set);

The considerations would be:
1) Does the page select register need to be written prior to every access?
2) Do we always have to write the value back even when the value hasn't
   changed by action of the mask and set parameters?

> +/**
> + * yt8521_read_status() -  determines the negotiated speed and duplex
> + * @phydev: a pointer to a &struct phy_device
> + *
> + * returns 0 or negative errno code
> + */
> +static int yt8521_read_status(struct phy_device *phydev)
> +{
> +	struct yt8521_priv *priv = phydev->priv;
> +	int link_utp = 0;
> +	int link_fiber;
> +	int link;
> +	int ret;
> +
> +	if (priv->reg_page != YT8521_RSSR_TO_BE_ARBITRATED) {
> +		link = yt8521_read_status_paged(phydev, priv->reg_page);
> +		if (link < 0)
> +			return link;
> +	} else {
> +		/* when page is YT8521_RSSR_TO_BE_ARBITRATED, arbitration is
> +		 * needed. by default, fiber is of higher priority.
> +		 */
> +
> +		link_fiber = yt8521_read_status_paged(phydev,
> +						      YT8521_RSSR_FIBER_SPACE);
> +		if (link_fiber < 0)
> +			return link_fiber;
> +
> +		if (!link_fiber) {
> +			link_utp = yt8521_read_status_paged(phydev,
> +							    YT8521_RSSR_UTP_SPACE);
> +			if (link_utp < 0)
> +				return link_utp;
> +		}
> +
> +		link = link_utp || link_fiber;
> +	}
> +
> +	if (link) {
> +		if (phydev->link == 0) {
> +			/* arbitrate reg space based on linkup media type. */
> +			if (priv->polling_mode == YT8521_MODE_POLL &&
> +			    priv->reg_page == YT8521_RSSR_TO_BE_ARBITRATED) {
> +				if (link_fiber)
> +					priv->reg_page =
> +						YT8521_RSSR_FIBER_SPACE;
> +				else
> +					priv->reg_page = YT8521_RSSR_UTP_SPACE;
> +
> +				ret = ytphy_write_ext_with_lock(phydev,
> +								YT8521_REG_SPACE_SELECT_REG,
> +								priv->reg_page);
> +				if (ret < 0)
> +					return ret;
> +
> +				phydev->port = link_fiber ? PORT_FIBRE : PORT_TP;
> +
> +				phydev_info(phydev,
> +					    "%s, phy addr: %d, link up, media: %s\n",
> +					    __func__, phydev->mdio.addr,
> +					    (phydev->port == PORT_TP) ?
> +					    "UTP" : "Fiber");

Why do you need to print the PHY address? Isn't the driver model's
printing of the device and driver name by phydev_info() sufficient?
The same comment applies elsewhere.

> +static int yt8521_modify_bmcr_paged(struct phy_device *phydev, int page,
> +				    u16 mask, u16 set)
> +{
> +	int max_cnt = 500; /* the max wait time of reset ~ 500 ms */
> +	int old_page;
> +	int ret = 0;
> +
> +	old_page = phy_select_page(phydev, page & YT8521_RSSR_SPACE_MASK);
> +	if (old_page < 0)
> +		goto err_restore_page;
> +
> +	ret = __phy_modify(phydev, MII_BMCR, mask, set);
> +	if (ret < 0)
> +		goto err_restore_page;
> +
> +	/* If it is reset, need to wait for the reset to complete */
> +	if (set == BMCR_RESET) {
> +		while (max_cnt--) {
> +			/* unlock mdio bus during sleep */
> +			phy_unlock_mdio_bus(phydev);
> +			usleep_range(1000, 1100);
> +			phy_lock_mdio_bus(phydev);

Dropping the lock makes phy_select_page()..phy_restore_page() unsafe
since some other code path could change the page selection register
while you're sleeping here. If you need to do this, then use
phy_restore_page() and re-acquire using phy_select_page() afterwards.

The same comment applies everywhere where you drop the mdio bus
lock while in a phy_select_page()..phy_restore_page() region. Every
case of that is buggy.

> +static int yt8521_fiber_setup_forced(struct phy_device *phydev)
> +{
> +	int max_cnt = 500; /* the max wait time of reset ~ 500 ms */
> +	u16 val;
> +	int ret;
> +
> +	if (phydev->speed == SPEED_1000)
> +		val = YTPHY_MCR_FIBER_1000BX;
> +	else if (phydev->speed == SPEED_100)
> +		val = YTPHY_MCR_FIBER_100FX;
> +	else
> +		return -EINVAL;
> +
> +	ret =  phy_modify(phydev,  MII_BMCR, BMCR_ANENABLE, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* disable Fiber auto sensing */
> +	ret =  ytphy_modify_ext_with_lock(phydev, YT8521_LINK_TIMER_CFG2_REG,
> +					  YT8521_LTCR_EN_AUTOSEN, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	phydev->pause = 0;
> +	phydev->asym_pause = 0;

Isn't that the responsibility of read_status() ?

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
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(fiber_supported);
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
> +	 * phydev->advertising should be updated.
> +	 */
> +	if (priv->reg_page == YT8521_RSSR_TO_BE_ARBITRATED) {
> +		linkmode_zero(fiber_supported);
> +		yt8521_prepare_fiber_features(phydev, fiber_supported);
> +
> +		/* prepare fiber_supported, then setup advertising. */
> +		if (page == YT8521_RSSR_FIBER_SPACE) {
> +			linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT,
> +					 fiber_supported);
> +			linkmode_set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
> +					 fiber_supported);
> +			linkmode_and(phydev->advertising,
> +				     priv->combo_advertising, fiber_supported);
> +		} else {
> +			/* ETHTOOL_LINK_MODE_Autoneg_BIT is also used in utp */
> +			linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
> +					   fiber_supported);
> +			linkmode_andnot(phydev->advertising,
> +					priv->combo_advertising,
> +					fiber_supported);
> +		}
> +	}
> +
> +	/* unlock mdio bus during genphy_config_aneg/yt8521_fiber_config_aneg,
> +	 * because it will operate this lock.
> +	 */
> +	phy_unlock_mdio_bus(phydev);
> +	if (page == YT8521_RSSR_FIBER_SPACE)
> +		ret = yt8521_fiber_config_aneg(phydev);
> +	else
> +		ret = genphy_config_aneg(phydev);
> +
> +	phy_lock_mdio_bus(phydev);

As previously pointed out, dropping the MDIO bus lock in a
phy_select_page()..phy_restore_page() region unsafe. I think you need
to ensure that yt8521_fiber_config_aneg() is safe to be called under
the lock, and I suspect having a version of genphy_config_aneg() which
can be called with the lock held would be a better approach.

> +/**
> + * yt8521_get_features_paged() -  read supported link modes for one page
> + * @phydev: a pointer to a &struct phy_device
> + * @page: The reg page(YT8521_RSSR_FIBER_SPACE/YT8521_RSSR_UTP_SPACE) to
> + * operate.
> + *
> + * returns 0 or negative errno code
> + */
> +static int yt8521_get_features_paged(struct phy_device *phydev, int page)
> +{
> +	int old_page;
> +	int ret = 0;
> +
> +	page &= YT8521_RSSR_SPACE_MASK;
> +	if (page == YT8521_RSSR_FIBER_SPACE) {
> +		linkmode_zero(phydev->supported);
> +		yt8521_prepare_fiber_features(phydev, phydev->supported);
> +		return 0;
> +	}
> +
> +	old_page = phy_select_page(phydev, page);
> +	if (old_page < 0)
> +		goto err_restore_page;
> +
> +	/* unlock mdio bus during genphy_read_abilities,
> +	 * because it will operate this lock.
> +	 */
> +	phy_unlock_mdio_bus(phydev);
> +	ret = genphy_read_abilities(phydev);
> +	phy_lock_mdio_bus(phydev);

As previously pointed out, this makes the page select/page restore unsafe.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
