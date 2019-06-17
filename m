Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37A6E48675
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 17:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbfFQPBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 11:01:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33360 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727783AbfFQPBw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 11:01:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oV13KY0pVdhVds9kzmA59RghDN5FrYy7qszIRRB2LYE=; b=jO/jsL101dgdLMOF0mqexLGJ94
        1FphbBZ2pY1ctskVFxD44XZ/5+L9p2bKi6ZYsHvUrJDI+Oc329gLG8GclVZ8BO8OKasU2eBit/zBO
        0CTvo2CLmYdIUq9dLHf5D2aA02UJM5dSVoz4xL7BlB7Uas840r6yrL0yU57e+Oph94ec=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hct8j-0008FO-3u; Mon, 17 Jun 2019 17:01:45 +0200
Date:   Mon, 17 Jun 2019 17:01:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Parshuram Thombare <pthombar@cadence.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net,
        f.fainelli@gmail.com, netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, rafalc@cadence.com,
        aniljoy@cadence.com, piotrs@cadence.com
Subject: Re: [PATCH 2/6] net: macb: add support for sgmii MAC-PHY interface
Message-ID: <20190617150145.GF25211@lunn.ch>
References: <1560642367-26425-1-git-send-email-pthombar@cadence.com>
 <1560642409-27074-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560642409-27074-1-git-send-email-pthombar@cadence.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -159,6 +160,9 @@
>  #define GEM_PEFTN		0x01f4 /* PTP Peer Event Frame Tx Ns */
>  #define GEM_PEFRSL		0x01f8 /* PTP Peer Event Frame Rx Sec Low */
>  #define GEM_PEFRN		0x01fc /* PTP Peer Event Frame Rx Ns */
> +#define GEM_PCS_CTRL		0x0200 /* PCS Control */
> +#define GEM_PCS_STATUS          0x0204 /* PCS Status */
> +#define GEM_PCS_AN_LP_BASE      0x0214 /* PCS AN LP BASE*/

It looks like there are some space vs tab issues here and else where.

>  static int gem_phylink_mac_link_state(struct phylink_config *pl_config,
>  				      struct phylink_link_state *state)
>  {
> +	u32 status;
>  	struct net_device *netdev = to_net_dev(pl_config->dev);
>  	struct macb *bp = netdev_priv(netdev);

Reverse christmas tree please, here and everywhere you add new
variables.

>  
> -	state->speed = bp->speed;
> -	state->duplex = bp->duplex;
> -	state->link = bp->link;
> +	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII) {
> +		status = gem_readl(bp, PCS_STATUS);
> +		state->an_complete = GEM_BFEXT(PCS_STATUS_AN_DONE, status);
> +		status = gem_readl(bp, PCS_AN_LP_BASE);
> +		switch (GEM_BFEXT(PCS_AN_LP_BASE_SPEED, status)) {
> +		case 0:
> +			state->speed = 10;
> +			break;
> +		case 1:
> +			state->speed = 100;
> +			break;
> +		case 2:
> +			state->speed = 1000;
> +			break;
> +		default:
> +			break;

It would be nice to use SPEED_10, SPEED_100, etc.

> @@ -494,17 +551,23 @@ static void gem_mac_config(struct phylink_config *pl_config, unsigned int mode,
>  		reg &= ~(MACB_BIT(SPD) | MACB_BIT(FD));
>  		if (macb_is_gem(bp))
>  			reg &= ~GEM_BIT(GBE);
> -
>  		if (state->duplex)
>  			reg |= MACB_BIT(FD);
> -		if (state->speed == SPEED_100)
> -			reg |= MACB_BIT(SPD);
> -		if (state->speed == SPEED_1000 &&
> -		    bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
> -			reg |= GEM_BIT(GBE);
> -
>  		macb_or_gem_writel(bp, NCFGR, reg);
>  
> +		if (state->speed == SPEED_2500) {
> +			gem_writel(bp, NCFGR, GEM_BIT(GBE) |
> +				   gem_readl(bp, NCFGR));
> +			gem_writel(bp, NCR, GEM_BIT(TWO_PT_FIVE_GIG) |
> +				   gem_readl(bp, NCR));
> +		} else if (state->speed == SPEED_1000) {
> +			gem_writel(bp, NCFGR, GEM_BIT(GBE) |
> +				   gem_readl(bp, NCFGR));
> +		} else if (state->speed == SPEED_100) {
> +			macb_writel(bp, NCFGR, MACB_BIT(SPD) |
> +				    macb_readl(bp, NCFGR));
> +		}

Maybe a switch statement?

> @@ -4232,11 +4327,37 @@ static int macb_probe(struct platform_device *pdev)
>  	}
>  
>  	err = of_get_phy_mode(np);

The following code would be more readable if you replaced err with
phy_mode, or interface.

> -	if (err < 0)
> +	if (err < 0) {
>  		/* not found in DT, MII by default */
>  		bp->phy_interface = PHY_INTERFACE_MODE_MII;
> -	else
> +	} else if (bp->caps & MACB_CAPS_MACB_IS_GEM_GXL) {
> +		u32 interface_supported = 1;
> +
> +		if (err == PHY_INTERFACE_MODE_SGMII ||
> +		    err == PHY_INTERFACE_MODE_1000BASEX ||
> +		    err == PHY_INTERFACE_MODE_2500BASEX) {
> +			if (!(bp->caps & MACB_CAPS_PCS))
> +				interface_supported = 0;
> +		} else if (err == PHY_INTERFACE_MODE_GMII ||
> +			   err == PHY_INTERFACE_MODE_RGMII) {
> +			if (!macb_is_gem(bp))
> +				interface_supported = 0;
> +		} else if (err != PHY_INTERFACE_MODE_RMII &&
> +			   err != PHY_INTERFACE_MODE_MII) {
> +			/* Add new mode before this */
> +			interface_supported = 0;
> +		}
> +
> +		if (!interface_supported) {
> +			netdev_err(dev, "Phy mode %s not supported",
> +				   phy_modes(err));
> +			goto err_out_free_netdev;
> +		}
> +
>  		bp->phy_interface = err;
> +	} else {
> +		bp->phy_interface = err;
> +	}

  Andrew
