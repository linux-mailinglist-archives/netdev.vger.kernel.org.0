Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D575F2DC79E
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 21:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbgLPUQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 15:16:43 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:56631 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbgLPUQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 15:16:42 -0500
X-Originating-IP: 86.202.109.140
Received: from localhost (lfbn-lyo-1-13-140.w86-202.abo.wanadoo.fr [86.202.109.140])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id B97AE40006;
        Wed, 16 Dec 2020 20:15:58 +0000 (UTC)
Date:   Wed, 16 Dec 2020 21:15:58 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [RFC PATCH net-next 11/16] net: mscc: ocelot: set up logical
 port IDs centrally
Message-ID: <20201216201558.GN2814589@piout.net>
References: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
 <20201208120802.1268708-12-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208120802.1268708-12-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12/2020 14:07:57+0200, Vladimir Oltean wrote:
> The setup of logical port IDs is done in two places: from the inconclusively
> named ocelot_setup_lag and from ocelot_port_lag_leave, a function that
> also calls ocelot_setup_lag (which apparently does an incomplete setup
> of the LAG).
> 
> To improve this situation, we can rename ocelot_setup_lag into
> ocelot_setup_logical_port_ids, and drop the "lag" argument. It will now
> set up the logical port IDs of all switch ports, which may be just
> slightly more inefficient but more maintainable.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
>  drivers/net/ethernet/mscc/ocelot.c | 47 ++++++++++++++++++------------
>  1 file changed, 28 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index ee0fcee8e09a..1a98c24af056 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -1279,20 +1279,36 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
>  	}
>  }
>  
> -static void ocelot_setup_lag(struct ocelot *ocelot, int lag)
> +/* When offloading a bonding interface, the switch ports configured under the
> + * same bond must have the same logical port ID, equal to the physical port ID
> + * of the lowest numbered physical port in that bond. Otherwise, in standalone/
> + * bridged mode, each port has a logical port ID equal to its physical port ID.
> + */
> +static void ocelot_setup_logical_port_ids(struct ocelot *ocelot)
>  {
> -	unsigned long bond_mask = ocelot->lags[lag];
> -	unsigned int p;
> +	int port;
>  
> -	for_each_set_bit(p, &bond_mask, ocelot->num_phys_ports) {
> -		u32 port_cfg = ocelot_read_gix(ocelot, ANA_PORT_PORT_CFG, p);
> +	for (port = 0; port < ocelot->num_phys_ports; port++) {
> +		struct ocelot_port *ocelot_port = ocelot->ports[port];
> +		struct net_device *bond;
> +
> +		if (!ocelot_port)
> +			continue;
>  
> -		port_cfg &= ~ANA_PORT_PORT_CFG_PORTID_VAL_M;
> +		bond = ocelot_port->bond;
> +		if (bond) {
> +			int lag = __ffs(ocelot_get_bond_mask(ocelot, bond));
>  
> -		/* Use lag port as logical port for port i */
> -		ocelot_write_gix(ocelot, port_cfg |
> -				 ANA_PORT_PORT_CFG_PORTID_VAL(lag),
> -				 ANA_PORT_PORT_CFG, p);
> +			ocelot_rmw_gix(ocelot,
> +				       ANA_PORT_PORT_CFG_PORTID_VAL(lag),
> +				       ANA_PORT_PORT_CFG_PORTID_VAL_M,
> +				       ANA_PORT_PORT_CFG, port);
> +		} else {
> +			ocelot_rmw_gix(ocelot,
> +				       ANA_PORT_PORT_CFG_PORTID_VAL(port),
> +				       ANA_PORT_PORT_CFG_PORTID_VAL_M,
> +				       ANA_PORT_PORT_CFG, port);
> +		}
>  	}
>  }
>  
> @@ -1320,7 +1336,7 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
>  		ocelot->lags[lag] |= BIT(port);
>  	}
>  
> -	ocelot_setup_lag(ocelot, lag);
> +	ocelot_setup_logical_port_ids(ocelot);
>  	ocelot_apply_bridge_fwd_mask(ocelot);
>  	ocelot_set_aggr_pgids(ocelot);
>  
> @@ -1331,7 +1347,6 @@ EXPORT_SYMBOL(ocelot_port_lag_join);
>  void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
>  			   struct net_device *bond)
>  {
> -	u32 port_cfg;
>  	int i;
>  
>  	ocelot->ports[port]->bond = NULL;
> @@ -1348,15 +1363,9 @@ void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
>  
>  		ocelot->lags[n] = ocelot->lags[port];
>  		ocelot->lags[port] = 0;
> -
> -		ocelot_setup_lag(ocelot, n);
>  	}
>  
> -	port_cfg = ocelot_read_gix(ocelot, ANA_PORT_PORT_CFG, port);
> -	port_cfg &= ~ANA_PORT_PORT_CFG_PORTID_VAL_M;
> -	ocelot_write_gix(ocelot, port_cfg | ANA_PORT_PORT_CFG_PORTID_VAL(port),
> -			 ANA_PORT_PORT_CFG, port);
> -
> +	ocelot_setup_logical_port_ids(ocelot);
>  	ocelot_apply_bridge_fwd_mask(ocelot);
>  	ocelot_set_aggr_pgids(ocelot);
>  }
> -- 
> 2.25.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
