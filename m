Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B06D43A5B9
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 23:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235085AbhJYVVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 17:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235148AbhJYVVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 17:21:31 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3349EC061767
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 14:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=40A0H35vvMHPb18bZBeaWpygEhlNrT9Q/cswcIVH2vU=; b=Hc8XF3FTP/mHqFhwx9DcfhNOUp
        PKh//YSyrciRyI7c1yT6DZZCX1irk2G9f9TbOBFp/Yv/jQbKQzRNsbj/J3EAuwoV3UPKRvKuNJZfQ
        0/bagL9QRHEAAVXFmccmqqta/6ppmAGYa+bBp5Oqio3Yyl4mLJkZ0Y/Nc2ZA3dcuWS4qPVIMDB44b
        VB9H5vSs4wNq/+uasmmuXHMYtF/N80FFcy0TM00Q8phpZxjGMu+rF4VDBRpqG6arWf5hcfMxcy41G
        rsbSU1a7Xgfgtb4AJS00jkRUBeuP6WAGeSUZ2CYhZaGHM2AXN8dN4Rc7K8rVZ03yC3XLPmiZA5gHN
        /3UIkZ9w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55292)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mf7N1-0004d3-9Q; Mon, 25 Oct 2021 22:19:03 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mf7Mz-0004Ig-9G; Mon, 25 Oct 2021 22:19:01 +0100
Date:   Mon, 25 Oct 2021 22:19:01 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH v4] net: macb: Fix several edge cases in validate
Message-ID: <YXcfRciQWl9t3E5Y@shell.armlinux.org.uk>
References: <20211025172405.211164-1-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025172405.211164-1-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 01:24:05PM -0400, Sean Anderson wrote:
> There were several cases where validate() would return bogus supported
> modes with unusual combinations of interfaces and capabilities. For
> example, if state->interface was 10GBASER and the macb had HIGH_SPEED
> and PCS but not GIGABIT MODE, then 10/100 modes would be set anyway. In
> another case, SGMII could be enabled even if the mac was not a GEM
> (despite this being checked for later on in mac_config()). These
> inconsistencies make it difficult to refactor this function cleanly.
> 
> This attempts to address these by reusing the same conditions used to
> decide whether to return early when setting mode bits. The logic is
> pretty messy, but this preserves the existing logic where possible.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> 
> Changes in v4:
> - Drop cleanup patch
> 
> Changes in v3:
> - Order bugfix patch first
> 
> Changes in v2:
> - New
> 
>  drivers/net/ethernet/cadence/macb_main.c | 59 +++++++++++++++++-------
>  1 file changed, 42 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 309371abfe23..40bd5a069368 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -510,11 +510,16 @@ static void macb_validate(struct phylink_config *config,
>  			  unsigned long *supported,
>  			  struct phylink_link_state *state)
>  {
> +	bool have_1g = true, have_10g = true;
>  	struct net_device *ndev = to_net_dev(config->dev);
>  	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };

I think DaveM would ask for this to be reverse-christmas-tree, so the
new bool should be here.

>  	struct macb *bp = netdev_priv(ndev);
>  
> -	/* We only support MII, RMII, GMII, RGMII & SGMII. */
> +	/* There are three major types of interfaces we support:
> +	 * - (R)MII supporting 10/100 Mbit/s
> +	 * - GMII, RGMII, and SGMII supporting 10/100/1000 Mbit/s
> +	 * - 10GBASER supporting 10 Gbit/s only
> +	 */
>  	if (state->interface != PHY_INTERFACE_MODE_NA &&
>  	    state->interface != PHY_INTERFACE_MODE_MII &&
>  	    state->interface != PHY_INTERFACE_MODE_RMII &&
> @@ -526,27 +531,48 @@ static void macb_validate(struct phylink_config *config,
>  		return;
>  	}
>  
> -	if (!macb_is_gem(bp) &&
> -	    (state->interface == PHY_INTERFACE_MODE_GMII ||
> -	     phy_interface_mode_is_rgmii(state->interface))) {
> -		linkmode_zero(supported);
> -		return;
> +	/* For 1G and up we must have both have a GEM and GIGABIT_MODE */
> +	if (!macb_is_gem(bp) ||
> +	    (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)) {
> +		if (state->interface == PHY_INTERFACE_MODE_GMII ||
> +		    phy_interface_mode_is_rgmii(state->interface) ||
> +		    state->interface == PHY_INTERFACE_MODE_SGMII ||
> +		    state->interface == PHY_INTERFACE_MODE_10GBASER) {
> +			linkmode_zero(supported);
> +			return;
> +		} else if (state->interface == PHY_INTERFACE_MODE_NA) {
> +			have_1g = false;
> +			have_10g = false;
> +		}
>  	}

Would it make more sense to do:

	bool have_1g = false, have_10g = false;

	if (macb_is_gem(bp) &&
	    (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)) {
		if (bp->caps & MACB_CAPS_PCS)
			have_1g = true;
		if (bp->caps & MACB_CAPS_HIGH_SPEED)
			have_10g = true;
	}

	switch (state->interface) {
	case PHY_INTERFACE_MODE_NA:
	case PHY_INTERFACE_MODE_MII:
	case PHY_INTERFACE_MODE_RMII:
		break;

	case PHY_INTERFACE_MODE_GMII:
	case PHY_INTERFACE_MODE_RGMII:
	case PHY_INTERFACE_MODE_RGMII_ID:
	case PHY_INTERFACE_MODE_RGMII_RXID:
	case PHY_INTERFACE_MODE_RGMII_TXID:
	case PHY_INTERFACE_MODE_SGMII:
		if (!have_1g) {
			linkmode_zero(supported);
			return;
		}
		break;

	case PHY_INTERFACE_MODE_10GBASER:
		if (!have_10g) {
			linkmode_zero(supported);
			return;
		}
		break;

	default:
		linkmode_zero(supported);
		return;
	}

This uses positive logic to derive have_1g and have_10g, and then uses
the switch statement to validate against those. Would the above result
in more understandable code?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
