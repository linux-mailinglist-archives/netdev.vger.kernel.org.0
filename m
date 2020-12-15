Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7997E2DB1DC
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 17:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731088AbgLOQsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 11:48:55 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:40859 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728896AbgLOQsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 11:48:43 -0500
X-Originating-IP: 86.202.109.140
Received: from localhost (lfbn-lyo-1-13-140.w86-202.abo.wanadoo.fr [86.202.109.140])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id C19DE40002;
        Tue, 15 Dec 2020 16:47:56 +0000 (UTC)
Date:   Tue, 15 Dec 2020 17:47:56 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [RFC PATCH net-next 08/16] net: mscc: ocelot: avoid unneeded
 "lp" variable in LAG join
Message-ID: <20201215164756.GL1781038@piout.net>
References: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
 <20201208120802.1268708-9-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208120802.1268708-9-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12/2020 14:07:54+0200, Vladimir Oltean wrote:
> The index of the LAG is equal to the logical port ID that all the
> physical port members have, which is further equal to the index of the
> first physical port that is a member of the LAG.
> 
> The code gets a bit carried away with logic like this:
> 
> 	if (a == b)
> 		c = a;
> 	else
> 		c = b;
> 
> which can be simplified, of course, into:
> 
> 	c = b;
> 
> (with a being port, b being lp, c being lag)
> 
> This further makes the "lp" variable redundant, since we can use "lag"
> everywhere where "lp" (logical port) was used. So instead of a "c = b"
> assignment, we can do a complete deletion of b. Only one comment here:
> 
> 		if (bond_mask) {
> 			lp = __ffs(bond_mask);
> 			ocelot->lags[lp] = 0;
> 		}
> 
> lp was clobbered before, because it was used as a temporary variable to
> hold the new smallest port ID from the bond. Now that we don't have "lp"
> any longer, we'll just avoid the temporary variable and zeroize the
> bonding mask directly.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
>  drivers/net/ethernet/mscc/ocelot.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index 30dee1f957d1..080fd4ce37ea 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -1291,28 +1291,24 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
>  			 struct net_device *bond)
>  {
>  	u32 bond_mask = 0;
> -	int lag, lp;
> +	int lag;
>  
>  	ocelot->ports[port]->bond = bond;
>  
>  	bond_mask = ocelot_get_bond_mask(ocelot, bond);
>  
> -	lp = __ffs(bond_mask);
> +	lag = __ffs(bond_mask);
>  
>  	/* If the new port is the lowest one, use it as the logical port from
>  	 * now on
>  	 */
> -	if (port == lp) {
> -		lag = port;
> +	if (port == lag) {
>  		ocelot->lags[port] = bond_mask;
>  		bond_mask &= ~BIT(port);
> -		if (bond_mask) {
> -			lp = __ffs(bond_mask);
> -			ocelot->lags[lp] = 0;
> -		}
> +		if (bond_mask)
> +			ocelot->lags[__ffs(bond_mask)] = 0;
>  	} else {
> -		lag = lp;
> -		ocelot->lags[lp] |= BIT(port);
> +		ocelot->lags[lag] |= BIT(port);
>  	}
>  
>  	ocelot_setup_lag(ocelot, lag);
> -- 
> 2.25.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
