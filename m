Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6346610B3
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 19:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbjAGSIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 13:08:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjAGSIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 13:08:05 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A1F3592E;
        Sat,  7 Jan 2023 10:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=MWOG1/eoo2lMKL+kIYISY5kixiwMhP8ydoboKwnTI1w=; b=3L212PM/xxJ52x8Frf4u9lfgjw
        POEnTw6m3gJs3hSYOIFD8I++2kHrVplyR1Zd1ykhIXzSgHOdzFACpqhFz0PWhsGf4b0/xldEWjwPM
        loAaGgTk1XJX+vlTkbLWavMq4GXZCzMgk2Jqb04Qqwix5YxnBTfs9qmDllV7bzCZLp5Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pEDbk-001RAA-9L; Sat, 07 Jan 2023 19:07:52 +0100
Date:   Sat, 7 Jan 2023 19:07:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        mailhol.vincent@wanadoo.fr, sudheer.mogilappagari@intel.com,
        sbhatta@marvell.com, linux-doc@vger.kernel.org,
        wangjie125@huawei.com, corbet@lwn.net, lkp@intel.com,
        gal@nvidia.com, gustavoars@kernel.org
Subject: Re: [PATCH v2 net-next 4/5] drivers/net/phy: add helpers to get/set
 PLCA configuration
Message-ID: <Y7m0+MQggJrxfYju@lunn.ch>
References: <cover.1673030528.git.piergiorgio.beruto@gmail.com>
 <35720efb893ac9ae2667110d4c2dc2828e9d4222.1673030528.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35720efb893ac9ae2667110d4c2dc2828e9d4222.1673030528.git.piergiorgio.beruto@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/**
> + * genphy_c45_plca_set_cfg - set PLCA configuration using standard registers
> + * @phydev: target phy_device struct
> + * @plca_cfg: structure containing the PLCA configuration. Fields set to -1 are
> + * not to be changed.
> + *
> + * Description: if the PHY complies to the Open Alliance TC14 10BASE-T1S PLCA
> + *   Management Registers specifications, this function can be used to modify
> + *   the PLCA configuration using the standard registers in MMD 31.
> + */
> +int genphy_c45_plca_set_cfg(struct phy_device *phydev,
> +			    const struct phy_plca_cfg *plca_cfg)
> +{
> +	int ret;
> +	u16 val;
> +
> +	// PLCA IDVER is read-only
> +	if (plca_cfg->version >= 0)
> +		return -EINVAL;
> +
> +	// first of all, disable PLCA if required
> +	if (plca_cfg->enabled == 0) {
> +		ret = phy_clear_bits_mmd(phydev, MDIO_MMD_VEND2,
> +					 MDIO_OATC14_PLCA_CTRL0,
> +					 MDIO_OATC14_PLCA_EN);
> +
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	if (plca_cfg->node_cnt >= 0 || plca_cfg->node_id >= 0) {
> +		if (plca_cfg->node_cnt < 0 || plca_cfg->node_id < 0) {

I think it would be good to add some comments since this code is not
immediately obvious to me. I had to think about it for a while.

> +	if (plca_cfg->burst_cnt >= 0 || plca_cfg->burst_tmr >= 0) {
> +		if (plca_cfg->burst_cnt < 0 || plca_cfg->burst_tmr < 0) {
> +			ret = phy_read_mmd(phydev, MDIO_MMD_VEND2,
> +					   MDIO_OATC14_PLCA_BURST);
> +

This follows the same patterns, so maybe comments here as well?

With that, you can add my Reviewed-by.

     Andrew
