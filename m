Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F78367F93A
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 16:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbjA1PnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 10:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjA1PnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 10:43:06 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91721A4A3;
        Sat, 28 Jan 2023 07:43:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wUi74KtdSXKX64QHZXYmsThtpxECPWzUkYIa0sd0LmY=; b=jnIR1VMq6UWPmOrvgnWOOpnbA+
        6ZGyIdlLZvqEB2ftxunczawqzCSJWak1wSSGkFKhFR6MzCQCl7yspkAr1/RuEiPAQzZavjy/QI6NX
        BgPQKRD288e+EDHbx/xVyKvWIIKaDkQrmA1VzHeopSMh47KZZdy2cwgFjPxvdDleGMXM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pLnLy-003SOt-92; Sat, 28 Jan 2023 16:42:54 +0100
Date:   Sat, 28 Jan 2023 16:42:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Frank Sae <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, xiaogang.fan@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 5/5] net: phy: Add driver for Motorcomm
 yt8531 gigabit ethernet phy
Message-ID: <Y9VCfkzjHBDjXmet@lunn.ch>
References: <20230128031314.19752-1-Frank.Sae@motor-comm.com>
 <20230128031314.19752-6-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230128031314.19752-6-Frank.Sae@motor-comm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 28, 2023 at 11:13:14AM +0800, Frank Sae wrote:
>  Add a driver for the motorcomm yt8531 gigabit ethernet phy. We have
>  verified the driver on AM335x platform with yt8531 board. On the
>  board, yt8531 gigabit ethernet phy works in utp mode, RGMII
>  interface, supports 1000M/100M/10M speeds, and wol(magic package).
> 
> Signed-off-by: Frank Sae <Frank.Sae@motor-comm.com>
> ---
>  drivers/net/phy/Kconfig     |   2 +-
>  drivers/net/phy/motorcomm.c | 204 +++++++++++++++++++++++++++++++++++-
>  2 files changed, 203 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index f5df2edc94a5..dc2f7d0b0cd8 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -257,7 +257,7 @@ config MOTORCOMM_PHY
>  	tristate "Motorcomm PHYs"
>  	help
>  	  Enables support for Motorcomm network PHYs.
> -	  Currently supports the YT8511, YT8521, YT8531S Gigabit Ethernet PHYs.
> +	  Currently supports the YT8511, YT8521, YT8531, YT8531S Gigabit Ethernet PHYs.

This is O.K. for now, but when you add the next PHY, please do this in
some other way, because it does not scale. Maybe just say YT85xx?

>  
>  config NATIONAL_PHY
>  	tristate "National Semiconductor PHYs"
> diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
> index 9559fc52814f..f1fc912738e0 100644
> --- a/drivers/net/phy/motorcomm.c
> +++ b/drivers/net/phy/motorcomm.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0+
>  /*
> - * Motorcomm 8511/8521/8531S PHY driver.
> + * Motorcomm 8511/8521/8531/8531S PHY driver.
>   *
>   * Author: Peter Geis <pgwipeout@gmail.com>
>   * Author: Frank <Frank.Sae@motor-comm.com>
> @@ -14,6 +14,7 @@
>  
>  #define PHY_ID_YT8511		0x0000010a
>  #define PHY_ID_YT8521		0x0000011A
> +#define PHY_ID_YT8531		0x4f51e91b
>  #define PHY_ID_YT8531S		0x4F51E91A
>  
>  /* YT8521/YT8531S Register Overview
> @@ -517,6 +518,68 @@ static int ytphy_set_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol)
>  	return phy_restore_page(phydev, old_page, ret);
>  }
>  
> +static int yt8531_set_wol(struct phy_device *phydev,
> +			  struct ethtool_wolinfo *wol)
> +{
> +	struct net_device *p_attached_dev;
> +	const u16 mac_addr_reg[] = {
> +		YTPHY_WOL_MACADDR2_REG,
> +		YTPHY_WOL_MACADDR1_REG,
> +		YTPHY_WOL_MACADDR0_REG,
> +	};
> +	const u8 *mac_addr;
> +	u16 mask, val;
> +	int ret;
> +	u8 i;
> +
> +	if (wol->wolopts & WAKE_MAGIC) {
> +		p_attached_dev = phydev->attached_dev;
> +		if (!p_attached_dev)
> +			return -ENODEV;
> +
> +		mac_addr = (const u8 *)p_attached_dev->dev_addr;
> +		if (!is_valid_ether_addr(mac_addr))
> +			return -EINVAL;

Have you ever seen that happen? It suggests the MAC driver has a bug,
not validating its MAC address.

Also, does the PHY actually care? Will the firmware crash if given a
bad MAC address?

    Andrew
