Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBCA12292C
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 11:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbfLQKsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 05:48:52 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:45293 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfLQKsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 05:48:52 -0500
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id CDF0240004;
        Tue, 17 Dec 2019 10:48:49 +0000 (UTC)
Date:   Tue, 17 Dec 2019 11:48:49 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/3] net: mvpp2: update mvpp2 validate()
 implementation
Message-ID: <20191217104849.GH3160@kwain>
References: <20191213175415.GW25745@shell.armlinux.org.uk>
 <E1ifpZs-0005kJ-Ll@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1ifpZs-0005kJ-Ll@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell,

On Fri, Dec 13, 2019 at 06:22:12PM +0000, Russell King wrote:
> Fix up the mvpp2 validate implementation to adopt the same behaviour as
> mvneta:
> - only allow the link modes that the specified PHY interface mode
>   supports with the exception of 1000base-X and 2500base-X.
> - use the basex helper to deal with SFP modules that can be switched
>   between 1000base-X vs 2500base-X.
> 
> This gives consistent behaviour between mvneta and mvpp2.
> 
> This commit depends on "net: phylink: extend clause 45 PHY validation
> workaround" so is not marked for backporting to stable kernels.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Acked-by: Antoine Tenart <antoine.tenart@bootlin.com>

Thanks!
Antoine

> ---
>  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 22 +++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index 111b3b8239e1..f09fcbe6ea88 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -4786,6 +4786,8 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
>  			phylink_set(mask, 10000baseER_Full);
>  			phylink_set(mask, 10000baseKR_Full);
>  		}
> +		if (state->interface != PHY_INTERFACE_MODE_NA)
> +			break;
>  		/* Fall-through */
>  	case PHY_INTERFACE_MODE_RGMII:
>  	case PHY_INTERFACE_MODE_RGMII_ID:
> @@ -4796,13 +4798,23 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
>  		phylink_set(mask, 10baseT_Full);
>  		phylink_set(mask, 100baseT_Half);
>  		phylink_set(mask, 100baseT_Full);
> +		phylink_set(mask, 1000baseT_Full);
> +		phylink_set(mask, 1000baseX_Full);
> +		if (state->interface != PHY_INTERFACE_MODE_NA)
> +			break;
>  		/* Fall-through */
>  	case PHY_INTERFACE_MODE_1000BASEX:
>  	case PHY_INTERFACE_MODE_2500BASEX:
> -		phylink_set(mask, 1000baseT_Full);
> -		phylink_set(mask, 1000baseX_Full);
> -		phylink_set(mask, 2500baseT_Full);
> -		phylink_set(mask, 2500baseX_Full);
> +		if (port->comphy ||
> +		    state->interface != PHY_INTERFACE_MODE_2500BASEX) {
> +			phylink_set(mask, 1000baseT_Full);
> +			phylink_set(mask, 1000baseX_Full);
> +		}
> +		if (port->comphy ||
> +		    state->interface == PHY_INTERFACE_MODE_2500BASEX) {
> +			phylink_set(mask, 2500baseT_Full);
> +			phylink_set(mask, 2500baseX_Full);
> +		}
>  		break;
>  	default:
>  		goto empty_set;
> @@ -4811,6 +4823,8 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
>  	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
>  	bitmap_and(state->advertising, state->advertising, mask,
>  		   __ETHTOOL_LINK_MODE_MASK_NBITS);
> +
> +	phylink_helper_basex_speed(state);
>  	return;
>  
>  empty_set:
> -- 
> 2.20.1
> 

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
