Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7EC1642F8F
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 19:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbiLESFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 13:05:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbiLESFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 13:05:16 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746701F627;
        Mon,  5 Dec 2022 10:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+uOk4r1kIs18BqPaDqirsB9HgQ0g7FLtL1ZZXGSiEKU=; b=lqr+/KfZhLszcIftHEIUNAlYg1
        QlcwhP1ucDSt1TIxecMDZGtTws9RndvoTXGnJCrfD9shwfJshEb/nPqe/+MWEhQOudaqctfdRvSEO
        qNB6eOlaG4d3hNpgquf8xAXzRxoIujTbRvLvrWuUEK5X7fVeIHfCoT5K6ceZscvgLzC0X8NLqUo1i
        5w+TKMTx8U1sdfGlhp5cPSnzGHIhhyefvNEE5ViU1onStG/6JW0f6/wMfCs+xbbBm6MnQwbF7kAYg
        7S04T/04Eku9qREnPuhKxqhj761io8WRWmI7Rxg2XQ3QZuQija2wN4JeYokp5yC/mz4it4TC03zdz
        FrTM+SQg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35586)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p2Fq1-00072b-HS; Mon, 05 Dec 2022 18:05:09 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p2Fpz-0007Qv-6K; Mon, 05 Dec 2022 18:05:07 +0000
Date:   Mon, 5 Dec 2022 18:05:07 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v3 net-next 1/4] net/ethtool: add netlink interface for
 the PLCA RS
Message-ID: <Y44y05M+6NGod+4x@shell.armlinux.org.uk>
References: <d53ffecdde8d3950a24155228a3439f2c9b10b9b.1670259123.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d53ffecdde8d3950a24155228a3439f2c9b10b9b.1670259123.git.piergiorgio.beruto@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 06:17:37PM +0100, Piergiorgio Beruto wrote:
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index e5b6cb1a77f9..99e3497b6aa1 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -543,6 +543,40 @@ int phy_ethtool_get_stats(struct phy_device *phydev,
>  }
>  EXPORT_SYMBOL(phy_ethtool_get_stats);
>  
> +/**
> + *
> + */
> +int phy_ethtool_get_plca_cfg(struct phy_device *dev,
> +			     struct phy_plca_cfg *plca_cfg)
> +{
> +	// TODO
> +	return 0;
> +}
> +EXPORT_SYMBOL(phy_ethtool_get_plca_cfg);
> +
> +/**
> + *
> + */
> +int phy_ethtool_set_plca_cfg(struct phy_device *dev,
> +			     struct netlink_ext_ack *extack,
> +			     const struct phy_plca_cfg *plca_cfg)
> +{
> +	// TODO
> +	return 0;
> +}
> +EXPORT_SYMBOL(phy_ethtool_set_plca_cfg);
> +
> +/**
> + *
> + */
> +int phy_ethtool_get_plca_status(struct phy_device *dev,
> +				struct phy_plca_status *plca_st)
> +{
> +	// TODO
> +	return 0;
> +}
> +EXPORT_SYMBOL(phy_ethtool_get_plca_status);
> +
>  /**
>   * phy_start_cable_test - Start a cable test
>   *
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 716870a4499c..f248010c403d 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -3262,6 +3262,9 @@ static const struct ethtool_phy_ops phy_ethtool_phy_ops = {
>  	.get_sset_count		= phy_ethtool_get_sset_count,
>  	.get_strings		= phy_ethtool_get_strings,
>  	.get_stats		= phy_ethtool_get_stats,
> +	.get_plca_cfg		= phy_ethtool_get_plca_cfg,
> +	.set_plca_cfg		= phy_ethtool_set_plca_cfg,
> +	.get_plca_status	= phy_ethtool_get_plca_status,
>  	.start_cable_test	= phy_start_cable_test,
>  	.start_cable_test_tdr	= phy_start_cable_test_tdr,
>  };

From what I can see, none of the above changes need to be part of
patch 1 - nothing in the rest of the patch requires these members to be
filled in, since you explicitly test to see whether they are before
calling them.

So, rather than introducing docbook stubs and stub functions that
do nothing, marked with "TODO" comments, just merge these changes
above with patch 3, where you actually populate these functions.

Also, why do they need to be exported to modules? From what I can see,
the only user of these functions is phy_device.c, which is part of
the same module as phy.c where the functions live, meaning that they
don't need to be exported.

It's also surely wrong to introduce stubs that return success but
do nothing.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
