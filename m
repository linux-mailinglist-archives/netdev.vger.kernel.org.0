Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15317486D8
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 17:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbfFQPTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 11:19:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33436 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726215AbfFQPTd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 11:19:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=u8BXVhx3Xt01zURMOtWv/YAU6w23gGORQqBBwLmef78=; b=Qx9QZU8GMiQRkSX4qAsLLCrF2T
        L7fei+oqujqTKEXqX2N1Q+5IBeHIcWxsS9VWnN+9PpEglnq2dO++xEFqo6h0yCJIuJ1fY09/rLVw8
        dHG3Kt+QCP4ktvrLPOFBtooJhgwPUO6O4xUGcvRzUB778wBWCTSPsQua3PYLZ/ZgiirM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hctPr-0008W0-T1; Mon, 17 Jun 2019 17:19:27 +0200
Date:   Mon, 17 Jun 2019 17:19:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Parshuram Thombare <pthombar@cadence.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net,
        f.fainelli@gmail.com, netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, rafalc@cadence.com,
        aniljoy@cadence.com, piotrs@cadence.com
Subject: Re: [PATCH 5/6] net: macb: add support for high speed interface
Message-ID: <20190617151927.GI25211@lunn.ch>
References: <1560642481-28297-1-git-send-email-pthombar@cadence.com>
 <1560642512-28765-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560642512-28765-1-git-send-email-pthombar@cadence.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  	switch (state->interface) {
> +	case PHY_INTERFACE_MODE_NA:

I would not list PHY_INTERFACE_MODE_NA here.

> +	case PHY_INTERFACE_MODE_USXGMII:
> +	case PHY_INTERFACE_MODE_10GKR:
> +		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
> +			phylink_set(mask, 10000baseCR_Full);
> +			phylink_set(mask, 10000baseER_Full);
> +			phylink_set(mask, 10000baseKR_Full);
> +			phylink_set(mask, 10000baseLR_Full);
> +			phylink_set(mask, 10000baseLRM_Full);
> +			phylink_set(mask, 10000baseSR_Full);
> +			phylink_set(mask, 10000baseT_Full);
> +			phylink_set(mask, 5000baseT_Full);
> +			phylink_set(mask, 2500baseX_Full);
> +			phylink_set(mask, 1000baseX_Full);
> +		}
> +		/* Fall-through */
>  	case PHY_INTERFACE_MODE_SGMII:
>  		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
>  			phylink_set(mask, 2500baseT_Full);
> @@ -594,17 +639,55 @@ static void gem_mac_config(struct phylink_config *pl_config, unsigned int mode,
>  			reg |= MACB_BIT(FD);
>  		macb_or_gem_writel(bp, NCFGR, reg);
>  
> -		if (state->speed == SPEED_2500) {
> -			gem_writel(bp, NCFGR, GEM_BIT(GBE) |
> -				   gem_readl(bp, NCFGR));
> -			gem_writel(bp, NCR, GEM_BIT(TWO_PT_FIVE_GIG) |
> -				   gem_readl(bp, NCR));
> -		} else if (state->speed == SPEED_1000) {
> -			gem_writel(bp, NCFGR, GEM_BIT(GBE) |
> -				   gem_readl(bp, NCFGR));
> -		} else if (state->speed == SPEED_100) {
> -			macb_writel(bp, NCFGR, MACB_BIT(SPD) |
> -				    macb_readl(bp, NCFGR));
> +		if (bp->phy_interface == PHY_INTERFACE_MODE_USXGMII) {
> +			u32 speed;
> +
> +			switch (state->speed) {
> +			case SPEED_10000:
> +				if (bp->serdes_rate ==
> +				    MACB_SERDES_RATE_10_PT_3125Gbps) {
> +					speed = HS_MAC_SPEED_10000M;
> +				} else {
> +					netdev_warn(netdev,
> +						    "10G not supported by HW");
> +					netdev_warn(netdev, "Setting speed to 1G");
> +					speed = HS_MAC_SPEED_1000M;
> +				}
> +				break;
> +			case SPEED_5000:
> +				speed = HS_MAC_SPEED_5000M;
> +				break;
> +			case SPEED_2500:
> +				speed = HS_MAC_SPEED_2500M;
> +				break;
> +			case SPEED_1000:
> +				speed = HS_MAC_SPEED_1000M;
> +				break;
> +			default:
> +			case SPEED_100:
> +				speed = HS_MAC_SPEED_100M;
> +				break;
> +			}
> +
> +			gem_writel(bp, HS_MAC_CONFIG,
> +				   GEM_BFINS(HS_MAC_SPEED, speed,
> +					     gem_readl(bp, HS_MAC_CONFIG)));
> +			gem_writel(bp, USX_CONTROL,
> +				   GEM_BFINS(USX_CTRL_SPEED, speed,
> +					     gem_readl(bp, USX_CONTROL)));
> +		} else {
> +			if (state->speed == SPEED_2500) {
> +				gem_writel(bp, NCFGR, GEM_BIT(GBE) |
> +					   gem_readl(bp, NCFGR));
> +				gem_writel(bp, NCR, GEM_BIT(TWO_PT_FIVE_GIG) |
> +					   gem_readl(bp, NCR));
> +			} else if (state->speed == SPEED_1000) {
> +				gem_writel(bp, NCFGR, GEM_BIT(GBE) |
> +					   gem_readl(bp, NCFGR));
> +			} else if (state->speed == SPEED_100) {
> +				macb_writel(bp, NCFGR, MACB_BIT(SPD) |
> +					    macb_readl(bp, NCFGR));
> +			}

Maybe split this up into two helper functions?

      Andrew
