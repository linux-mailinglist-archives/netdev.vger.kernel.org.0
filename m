Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E41F25E9A9
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 20:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbgIESSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 14:18:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728393AbgIESR6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 14:17:58 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B30CA2078E;
        Sat,  5 Sep 2020 18:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599329877;
        bh=531Tacsm9qEnm8tPEhULr0JTsL/WaQbglnAVWly9wrk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GM3lvXFMCDeGKwgtTJMY14EjBiG679FJhE/qa0Ul78+6lEPWcou0iUgnqB7XXmSpj
         iRcxb26HvEXGUiM0E+ldXK7ZwT32nacLIvRN117sfv1Mk8ZR4vID9I007wfnv0tgam
         y/Sjj3af78FTQRca5Ch32nk6H+5tj5HYGQo/WJ4M=
Date:   Sat, 5 Sep 2020 11:17:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 1/3] net: dp83869: Add ability to advertise
 Fiber connection
Message-ID: <20200905111755.4bd874b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200903114259.14013-2-dmurphy@ti.com>
References: <20200903114259.14013-1-dmurphy@ti.com>
        <20200903114259.14013-2-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Sep 2020 06:42:57 -0500 Dan Murphy wrote:
> Add the ability to advertise the Fiber connection if the strap or the
> op-mode is configured for 100Base-FX.
> 
> Auto negotiation is not supported on this PHY when in fiber mode.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Some comments, I'm not very phy-knowledgeable so bear with me
(hopefully PHY maintainers can correct me, too).

> diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
> index 58103152c601..48a68474f89c 100644
> --- a/drivers/net/phy/dp83869.c
> +++ b/drivers/net/phy/dp83869.c
> @@ -52,6 +52,11 @@
>  					 BMCR_FULLDPLX | \
>  					 BMCR_SPEED1000)
>  
> +#define MII_DP83869_FIBER_ADVERTISE    (ADVERTISED_TP | ADVERTISED_MII | \
> +					ADVERTISED_FIBRE | ADVERTISED_BNC |  \

I'm not actually sure myself what the semantics of port type advertise
bits are, but if this is fiber why advertise TP and do you really have
BNC connectors? :S

> +					ADVERTISED_Pause | ADVERTISED_Asym_Pause | \
> +					ADVERTISED_100baseT_Full)

You say 100Base-FX, yet you advertise 100Base-T?

>  /* This is the same bit mask as the BMCR so re-use the BMCR default */
>  #define DP83869_FX_CTRL_DEFAULT	MII_DP83869_BMCR_DEFAULT
>  
> @@ -300,6 +305,7 @@ static int dp83869_configure_mode(struct phy_device *phydev,
>  {
>  	int phy_ctrl_val;
>  	int ret;
> +	int bmcr;

Please keep reverse xmas tree ordering.

>  	if (dp83869->mode < DP83869_RGMII_COPPER_ETHERNET ||
>  	    dp83869->mode > DP83869_SGMII_COPPER_ETHERNET)
> @@ -383,7 +389,37 @@ static int dp83869_configure_mode(struct phy_device *phydev,
>  
>  		break;
>  	case DP83869_RGMII_1000_BASE:
> +		break;
>  	case DP83869_RGMII_100_BASE:
> +		/* Only allow advertising what this PHY supports */
> +		linkmode_and(phydev->advertising, phydev->advertising,
> +			     phydev->supported);
> +
> +		linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
> +				 phydev->supported);
> +		linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
> +				 phydev->advertising);
> +
> +		/* Auto neg is not supported in fiber mode */
> +		bmcr = phy_read(phydev, MII_BMCR);
> +		if (bmcr < 0)
> +			return bmcr;
> +
> +		phydev->autoneg = AUTONEG_DISABLE;
> +		linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
> +				   phydev->supported);
> +		linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
> +				   phydev->advertising);
> +
> +		if (bmcr & BMCR_ANENABLE) {
> +			ret =  phy_modify(phydev, MII_BMCR, BMCR_ANENABLE, 0);
> +			if (ret < 0)
> +				return ret;
> +		}
> +
> +		phy_modify_changed(phydev, MII_ADVERTISE,
> +				   MII_DP83869_FIBER_ADVERTISE,
> +				   MII_DP83869_FIBER_ADVERTISE);

This only accesses standard registers, should it perhaps be a helper in
the kernel's phy code?

>  		break;
>  	default:
>  		return -EINVAL;

