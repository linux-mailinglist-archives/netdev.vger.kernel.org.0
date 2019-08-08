Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6A9386A9E
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 21:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389995AbfHHTcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 15:32:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45404 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732758AbfHHTcs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 15:32:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=o+hc3gLilwFMCFaETnB4Up46zV7neFr+lHPexMejDsg=; b=StZrOPRrr+ze7My9mIFu8m+rXY
        z762aTpKKLjXUT4W+xE2EHidFblYjjtM+G6qz/16/fATkCFQ1GEM5YygzzXbdSu4MVACAv2+jDmDg
        FP1MkUh2o7rjtkVb9Sa7dWcskdnUe8u6ibXwt2OMcbrAI7o174/UrAXWxYdAhZ1FxYEI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hvo9T-0005Vr-5g; Thu, 08 Aug 2019 21:32:43 +0200
Date:   Thu, 8 Aug 2019 21:32:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/3] net: phy: prepare phylib to deal with PHY's
 extending Clause 22
Message-ID: <20190808193243.GK27917@lunn.ch>
References: <ddbf28b9-f32e-7399-10a6-27b79ca0aaf9@gmail.com>
 <214bedc0-4ae0-b15f-e03c-173f17527417@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <214bedc0-4ae0-b15f-e03c-173f17527417@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 08, 2019 at 09:03:42PM +0200, Heiner Kallweit wrote:
> The integrated PHY in 2.5Gbps chip RTL8125 is the first (known to me)
> PHY that uses standard Clause 22 for all modes up to 1Gbps and adds
> 2.5Gbps control using vendor-specific registers. To use phylib for
> the standard part little extensions are needed:
> - Move most of genphy_config_aneg to a new function
>   __genphy_config_aneg that takes a parameter whether restarting
>   auto-negotiation is needed (depending on whether content of
>   vendor-specific advertisement register changed).
> - Don't clear phydev->lp_advertising in genphy_read_status so that
>   we can set non-C22 mode flags before.
> 
> Basically both changes mimic the behavior of the equivalent Clause 45
> functions.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/phy/phy_device.c | 35 +++++++++++++++--------------------
>  include/linux/phy.h          |  8 +++++++-
>  2 files changed, 22 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 7ddd91df9..bd7e7db8c 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -1571,11 +1571,9 @@ static int genphy_config_advert(struct phy_device *phydev)
>  	/* Only allow advertising what this PHY supports */
>  	linkmode_and(phydev->advertising, phydev->advertising,
>  		     phydev->supported);
> -	if (!ethtool_convert_link_mode_to_legacy_u32(&advertise,
> -						     phydev->advertising))
> -		phydev_warn(phydev, "PHY advertising (%*pb) more modes than genphy supports, some modes not advertised.\n",
> -			    __ETHTOOL_LINK_MODE_MASK_NBITS,
> -			    phydev->advertising);
> +
> +	ethtool_convert_link_mode_to_legacy_u32(&advertise,
> +						phydev->advertising);

Hi Heiner

linkmode_adv_to_mii_adv_t() would remove the need to use
ethtool_convert_link_mode_to_legacy_u32(), and this warning would also
go away. 

   Andrew
