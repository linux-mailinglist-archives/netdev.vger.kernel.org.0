Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90AC511E782
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 17:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbfLMQEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 11:04:24 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:48019 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727990AbfLMQEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 11:04:23 -0500
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id C91361BF20D;
        Fri, 13 Dec 2019 16:04:20 +0000 (UTC)
Date:   Fri, 13 Dec 2019 17:04:20 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net: mvpp2: update mvpp2 validate()
 implementation
Message-ID: <20191213160420.GA26710@kwain>
References: <20191212174309.GM25745@shell.armlinux.org.uk>
 <E1ifSV8-0000b1-NW@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1ifSV8-0000b1-NW@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell,

On Thu, Dec 12, 2019 at 05:43:46PM +0000, Russell King wrote:
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index 111b3b8239e1..fddd856338b4 100644
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
> @@ -4796,13 +4798,21 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
>  		phylink_set(mask, 10baseT_Full);
>  		phylink_set(mask, 100baseT_Half);
>  		phylink_set(mask, 100baseT_Full);
> +		if (state->interface != PHY_INTERFACE_MODE_NA)
> +			break;

The two checks above will break the 10G/1G interfaces on the mcbin
(eth0/eth1) as they can support both 10gbase-kr and 10/100/1000baseT
modes depending on what's connected. With this patch only the modes
related to the one defined in the device tree would be valid, breaking
run-time reconfiguration of the link.

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
