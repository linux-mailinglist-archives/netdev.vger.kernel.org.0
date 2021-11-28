Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4069B460926
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 19:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353460AbhK1Szd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 13:55:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359365AbhK1Sxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 13:53:32 -0500
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B79C0613F9
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 10:49:35 -0800 (PST)
Received: from smtp102.mailbox.org (smtp102.mailbox.org [80.241.60.233])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4J2HZz4ycxzQk2F;
        Sun, 28 Nov 2021 19:49:31 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1638125369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8LW0HH2pvtJAzDV+KSbSk6QZvInYLDMmELzuzCNKFRw=;
        b=RMnw2em1XYrt9PAhOEXtO1EUQGhkpce09QmTCd49ceP4EV979U+XqG+o9UFLfcsySXwt7v
        X5RUlH+yziqCAesD474yZmfYVnwcjBQDc0qkgPvJxM114mJQozjgGhcsD17T8gSQDV9Fxy
        NIOCMKChP3nK/OxW2sI6v6LubfsP/uTXQR/B3nP+VRehrBSoxFCk6wRL4OoBlyf5WgcmTt
        zU8wW9zb24QR7KMbjy+Q72tPL2FcaXXOOcIJ5mxy4PT+ajwICUR6R5GWQB33kK8t5b0vfs
        vX+RS9R7gQsrRfJPYX+b/tuNH+o/jfyLtGi1DnBUeDjQGXZ9BK9eGzIvPMyd8A==
Subject: Re: [PATCH RFC net-next 08/12] net: dsa: lantiq: convert to
 phylink_generic_validate()
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Woojung Huh <woojung.huh@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
 <E1mpwS8-00D8Lh-49@rmk-PC.armlinux.org.uk>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Message-ID: <82a754f7-cc38-06f0-348a-972612ce9085@hauke-m.de>
Date:   Sun, 28 Nov 2021 19:49:25 +0100
MIME-Version: 1.0
In-Reply-To: <E1mpwS8-00D8Lh-49@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/24/21 6:53 PM, Russell King (Oracle) wrote:
> Populate the supported interfaces and MAC capabilities for the Lantiq
> DSA switches and remove the old validate implementation to allow DSA to
> use phylink_generic_validate() for this switch driver.
> 
> The exclusion of Gigabit linkmodes for MII, Reverse MII and Reduced MII
> links is handled within phylink_generic_validate() in phylink, so there
> is no need to make them conditional on the interface mode in the driver.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Hauke Mehrtens <hauke@hauke-m.de>

> ---
>   drivers/net/dsa/lantiq_gswip.c | 120 +++++++++++----------------------
>   1 file changed, 38 insertions(+), 82 deletions(-)
> 
> diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
> index 7056d98d8177..583af774e1bd 100644
> --- a/drivers/net/dsa/lantiq_gswip.c
> +++ b/drivers/net/dsa/lantiq_gswip.c
> @@ -1438,114 +1438,70 @@ static int gswip_port_fdb_dump(struct dsa_switch *ds, int port,
>   	return 0;
>   }
>   
> -static void gswip_phylink_set_capab(unsigned long *supported,
> -				    struct phylink_link_state *state)
> -{
> -	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> -
> -	/* Allow all the expected bits */
> -	phylink_set(mask, Autoneg);
> -	phylink_set_port_modes(mask);
> -	phylink_set(mask, Pause);
> -	phylink_set(mask, Asym_Pause);
> -
> -	/* With the exclusion of MII, Reverse MII and Reduced MII, we
> -	 * support Gigabit, including Half duplex
> -	 */
> -	if (state->interface != PHY_INTERFACE_MODE_MII &&
> -	    state->interface != PHY_INTERFACE_MODE_REVMII &&
> -	    state->interface != PHY_INTERFACE_MODE_RMII) {
> -		phylink_set(mask, 1000baseT_Full);
> -		phylink_set(mask, 1000baseT_Half);
> -	}
> -
> -	phylink_set(mask, 10baseT_Half);
> -	phylink_set(mask, 10baseT_Full);
> -	phylink_set(mask, 100baseT_Half);
> -	phylink_set(mask, 100baseT_Full);
> -
> -	linkmode_and(supported, supported, mask);
> -	linkmode_and(state->advertising, state->advertising, mask);
> -}
> -
> -static void gswip_xrx200_phylink_validate(struct dsa_switch *ds, int port,
> -					  unsigned long *supported,
> -					  struct phylink_link_state *state)
> +static void gswip_xrx200_phylink_get_caps(struct dsa_switch *ds, int port,
> +					  struct phylink_config *config)
>   {
>   	switch (port) {
>   	case 0:
>   	case 1:
> -		if (!phy_interface_mode_is_rgmii(state->interface) &&
> -		    state->interface != PHY_INTERFACE_MODE_MII &&
> -		    state->interface != PHY_INTERFACE_MODE_REVMII &&
> -		    state->interface != PHY_INTERFACE_MODE_RMII)
> -			goto unsupported;
> +		phy_interface_set_rgmii(config->supported_interfaces);
> +		__set_bit(PHY_INTERFACE_MODE_MII,
> +			  config->supported_interfaces);
> +		__set_bit(PHY_INTERFACE_MODE_REVMII,
> +			  config->supported_interfaces);
> +		__set_bit(PHY_INTERFACE_MODE_RMII,
> +			  config->supported_interfaces);
>   		break;
> +
>   	case 2:
>   	case 3:
>   	case 4:
> -		if (state->interface != PHY_INTERFACE_MODE_INTERNAL)
> -			goto unsupported;
> +		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
> +			  config->supported_interfaces);
>   		break;
> +
>   	case 5:
> -		if (!phy_interface_mode_is_rgmii(state->interface) &&
> -		    state->interface != PHY_INTERFACE_MODE_INTERNAL)
> -			goto unsupported;
> +		phy_interface_set_rgmii(config->supported_interfaces);
> +		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
> +			  config->supported_interfaces);
>   		break;
> -	default:
> -		linkmode_zero(supported);
> -		dev_err(ds->dev, "Unsupported port: %i\n", port);
> -		return;
>   	}
>   
> -	gswip_phylink_set_capab(supported, state);
> -
> -	return;
> -
> -unsupported:
> -	linkmode_zero(supported);
> -	dev_err(ds->dev, "Unsupported interface '%s' for port %d\n",
> -		phy_modes(state->interface), port);
> +	config->mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
> +		MAC_10 | MAC_100 | MAC_1000;
>   }
>   
> -static void gswip_xrx300_phylink_validate(struct dsa_switch *ds, int port,
> -					  unsigned long *supported,
> -					  struct phylink_link_state *state)
> +static void gswip_xrx300_phylink_get_caps(struct dsa_switch *ds, int port,
> +					  struct phylink_config *config)
>   {
>   	switch (port) {
>   	case 0:
> -		if (!phy_interface_mode_is_rgmii(state->interface) &&
> -		    state->interface != PHY_INTERFACE_MODE_GMII &&
> -		    state->interface != PHY_INTERFACE_MODE_RMII)
> -			goto unsupported;
> +		phy_interface_set_rgmii(config->supported_interfaces);
> +		__set_bit(PHY_INTERFACE_MODE_GMII,
> +			  config->supported_interfaces);
> +		__set_bit(PHY_INTERFACE_MODE_RMII,
> +			  config->supported_interfaces);
>   		break;
> +
>   	case 1:
>   	case 2:
>   	case 3:
>   	case 4:
> -		if (state->interface != PHY_INTERFACE_MODE_INTERNAL)
> -			goto unsupported;
> +		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
> +			  config->supported_interfaces);
>   		break;
> +
>   	case 5:
> -		if (!phy_interface_mode_is_rgmii(state->interface) &&
> -		    state->interface != PHY_INTERFACE_MODE_INTERNAL &&
> -		    state->interface != PHY_INTERFACE_MODE_RMII)
> -			goto unsupported;
> +		phy_interface_set_rgmii(config->supported_interfaces);
> +		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
> +			  config->supported_interfaces);
> +		__set_bit(PHY_INTERFACE_MODE_RMII,
> +			  config->supported_interfaces);
>   		break;
> -	default:
> -		linkmode_zero(supported);
> -		dev_err(ds->dev, "Unsupported port: %i\n", port);
> -		return;
>   	}
>   
> -	gswip_phylink_set_capab(supported, state);
> -
> -	return;
> -
> -unsupported:
> -	linkmode_zero(supported);
> -	dev_err(ds->dev, "Unsupported interface '%s' for port %d\n",
> -		phy_modes(state->interface), port);
> +	config->mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
> +		MAC_10 | MAC_100 | MAC_1000;
>   }
>   
>   static void gswip_port_set_link(struct gswip_priv *priv, int port, bool link)
> @@ -1827,7 +1783,7 @@ static const struct dsa_switch_ops gswip_xrx200_switch_ops = {
>   	.port_fdb_add		= gswip_port_fdb_add,
>   	.port_fdb_del		= gswip_port_fdb_del,
>   	.port_fdb_dump		= gswip_port_fdb_dump,
> -	.phylink_validate	= gswip_xrx200_phylink_validate,
> +	.phylink_get_caps	= gswip_xrx200_phylink_get_caps,
>   	.phylink_mac_config	= gswip_phylink_mac_config,
>   	.phylink_mac_link_down	= gswip_phylink_mac_link_down,
>   	.phylink_mac_link_up	= gswip_phylink_mac_link_up,
> @@ -1851,7 +1807,7 @@ static const struct dsa_switch_ops gswip_xrx300_switch_ops = {
>   	.port_fdb_add		= gswip_port_fdb_add,
>   	.port_fdb_del		= gswip_port_fdb_del,
>   	.port_fdb_dump		= gswip_port_fdb_dump,
> -	.phylink_validate	= gswip_xrx300_phylink_validate,
> +	.phylink_get_caps	= gswip_xrx300_phylink_get_caps,
>   	.phylink_mac_config	= gswip_phylink_mac_config,
>   	.phylink_mac_link_down	= gswip_phylink_mac_link_down,
>   	.phylink_mac_link_up	= gswip_phylink_mac_link_up,
> 

