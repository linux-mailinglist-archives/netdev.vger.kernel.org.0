Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A612DC858
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 22:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgLPV37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 16:29:59 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:54455 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgLPV37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 16:29:59 -0500
X-Originating-IP: 86.202.109.140
Received: from localhost (lfbn-lyo-1-13-140.w86-202.abo.wanadoo.fr [86.202.109.140])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id CAEE11C0008;
        Wed, 16 Dec 2020 21:29:14 +0000 (UTC)
Date:   Wed, 16 Dec 2020 22:29:14 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [RFC PATCH net-next 12/16] net: mscc: ocelot: drop the use of
 the "lags" array
Message-ID: <20201216212914.GP2814589@piout.net>
References: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
 <20201208120802.1268708-13-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208120802.1268708-13-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12/2020 14:07:58+0200, Vladimir Oltean wrote:
> We can now simplify the implementation by always using ocelot_get_bond_mask
> to look up the other ports that are offloading the same bonding interface
> as us.
> 
> In ocelot_set_aggr_pgids, the code had a way to uniquely iterate through
> LAGs. We need to achieve the same behavior by marking each LAG as visited,
> which we do now by temporarily allocating an array of pointers to bonding
> uppers of each port, and marking each bonding upper as NULL once it has
> been treated by the first port that is a member. And because we now do
> some dynamic allocation, we need to propagate errors from
> ocelot_set_aggr_pgid all the way to ocelot_port_lag_leave.

I would say that this allocation never fails but wouldn't it be better
to simply put that on the stack? It is just a bunch of pointers, that
would be 10 on ocelot, maximum would be 64 on jaguar if we ever use the
same driver. This seems reasonable to me, the main issue is that you
have to avoid VLAs.

> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/mscc/ocelot.c     | 104 ++++++++++---------------
>  drivers/net/ethernet/mscc/ocelot.h     |   4 +-
>  drivers/net/ethernet/mscc/ocelot_net.c |   4 +-
>  include/soc/mscc/ocelot.h              |   2 -
>  4 files changed, 47 insertions(+), 67 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index 1a98c24af056..d4dbba66aa65 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -909,21 +909,17 @@ static void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
>  	 * source port's forwarding mask.
>  	 */
>  	for (port = 0; port < ocelot->num_phys_ports; port++) {
> -		if (ocelot->bridge_fwd_mask & BIT(port)) {
> -			unsigned long mask = ocelot->bridge_fwd_mask & ~BIT(port);
> -			int lag;
> +		struct ocelot_port *ocelot_port = ocelot->ports[port];
>  
> -			for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
> -				unsigned long bond_mask = ocelot->lags[lag];
> +		if (!ocelot_port)
> +			continue;
>  
> -				if (!bond_mask)
> -					continue;
> +		if (ocelot->bridge_fwd_mask & BIT(port)) {
> +			unsigned long mask = ocelot->bridge_fwd_mask & ~BIT(port);
> +			struct net_device *bond = ocelot_port->bond;
>  
> -				if (bond_mask & BIT(port)) {
> -					mask &= ~bond_mask;
> -					break;
> -				}
> -			}
> +			if (bond)
> +				mask &= ~ocelot_get_bond_mask(ocelot, bond);
>  
>  			ocelot_write_rix(ocelot, mask,
>  					 ANA_PGID_PGID, PGID_SRC + port);
> @@ -1238,10 +1234,16 @@ int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
>  }
>  EXPORT_SYMBOL(ocelot_port_bridge_leave);
>  
> -static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
> +static int ocelot_set_aggr_pgids(struct ocelot *ocelot)
>  {
> +	struct net_device **bonds;
>  	int i, port, lag;
>  
> +	bonds = kcalloc(ocelot->num_phys_ports, sizeof(struct net_device *),
> +			GFP_KERNEL);
> +	if (!bonds)
> +		return -ENOMEM;
> +
>  	/* Reset destination and aggregation PGIDS */
>  	for_each_unicast_dest_pgid(ocelot, port)
>  		ocelot_write_rix(ocelot, BIT(port), ANA_PGID_PGID, port);
> @@ -1250,16 +1252,26 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
>  		ocelot_write_rix(ocelot, GENMASK(ocelot->num_phys_ports - 1, 0),
>  				 ANA_PGID_PGID, i);
>  
> +	for (port = 0; port < ocelot->num_phys_ports; port++) {
> +		struct ocelot_port *ocelot_port = ocelot->ports[port];
> +
> +		if (!ocelot_port)
> +			continue;
> +
> +		bonds[port] = ocelot_port->bond;
> +	}
> +
>  	/* Now, set PGIDs for each LAG */
>  	for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
>  		unsigned long bond_mask;
>  		int aggr_count = 0;
>  		u8 aggr_idx[16];
>  
> -		bond_mask = ocelot->lags[lag];
> -		if (!bond_mask)
> +		if (!bonds[lag])
>  			continue;
>  
> +		bond_mask = ocelot_get_bond_mask(ocelot, bonds[lag]);
> +
>  		for_each_set_bit(port, &bond_mask, ocelot->num_phys_ports) {
>  			// Destination mask
>  			ocelot_write_rix(ocelot, bond_mask,
> @@ -1276,7 +1288,19 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
>  			ac |= BIT(aggr_idx[i % aggr_count]);
>  			ocelot_write_rix(ocelot, ac, ANA_PGID_PGID, i);
>  		}
> +
> +		/* Mark the bonding interface as visited to avoid applying
> +		 * the same config again
> +		 */
> +		for (i = lag + 1; i < ocelot->num_phys_ports; i++)
> +			if (bonds[i] == bonds[lag])
> +				bonds[i] = NULL;
> +
> +		bonds[lag] = NULL;
>  	}
> +
> +	kfree(bonds);
> +	return 0;
>  }
>  
>  /* When offloading a bonding interface, the switch ports configured under the
> @@ -1315,59 +1339,22 @@ static void ocelot_setup_logical_port_ids(struct ocelot *ocelot)
>  int ocelot_port_lag_join(struct ocelot *ocelot, int port,
>  			 struct net_device *bond)
>  {
> -	u32 bond_mask = 0;
> -	int lag;
> -
>  	ocelot->ports[port]->bond = bond;
>  
> -	bond_mask = ocelot_get_bond_mask(ocelot, bond);
> -
> -	lag = __ffs(bond_mask);
> -
> -	/* If the new port is the lowest one, use it as the logical port from
> -	 * now on
> -	 */
> -	if (port == lag) {
> -		ocelot->lags[port] = bond_mask;
> -		bond_mask &= ~BIT(port);
> -		if (bond_mask)
> -			ocelot->lags[__ffs(bond_mask)] = 0;
> -	} else {
> -		ocelot->lags[lag] |= BIT(port);
> -	}
> -
>  	ocelot_setup_logical_port_ids(ocelot);
>  	ocelot_apply_bridge_fwd_mask(ocelot);
> -	ocelot_set_aggr_pgids(ocelot);
> -
> -	return 0;
> +	return ocelot_set_aggr_pgids(ocelot);
>  }
>  EXPORT_SYMBOL(ocelot_port_lag_join);
>  
> -void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
> -			   struct net_device *bond)
> +int ocelot_port_lag_leave(struct ocelot *ocelot, int port,
> +			  struct net_device *bond)
>  {
> -	int i;
> -
>  	ocelot->ports[port]->bond = NULL;
>  
> -	/* Remove port from any lag */
> -	for (i = 0; i < ocelot->num_phys_ports; i++)
> -		ocelot->lags[i] &= ~BIT(port);
> -
> -	/* if it was the logical port of the lag, move the lag config to the
> -	 * next port
> -	 */
> -	if (ocelot->lags[port]) {
> -		int n = __ffs(ocelot->lags[port]);
> -
> -		ocelot->lags[n] = ocelot->lags[port];
> -		ocelot->lags[port] = 0;
> -	}
> -
>  	ocelot_setup_logical_port_ids(ocelot);
>  	ocelot_apply_bridge_fwd_mask(ocelot);
> -	ocelot_set_aggr_pgids(ocelot);
> +	return ocelot_set_aggr_pgids(ocelot);
>  }
>  EXPORT_SYMBOL(ocelot_port_lag_leave);
>  
> @@ -1543,11 +1530,6 @@ int ocelot_init(struct ocelot *ocelot)
>  		}
>  	}
>  
> -	ocelot->lags = devm_kcalloc(ocelot->dev, ocelot->num_phys_ports,
> -				    sizeof(u32), GFP_KERNEL);
> -	if (!ocelot->lags)
> -		return -ENOMEM;
> -
>  	ocelot->stats = devm_kcalloc(ocelot->dev,
>  				     ocelot->num_phys_ports * ocelot->num_stats,
>  				     sizeof(u64), GFP_KERNEL);
> diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
> index 739bd201d951..bef8d5f8e6e5 100644
> --- a/drivers/net/ethernet/mscc/ocelot.h
> +++ b/drivers/net/ethernet/mscc/ocelot.h
> @@ -114,8 +114,8 @@ int ocelot_mact_forget(struct ocelot *ocelot,
>  		       const unsigned char mac[ETH_ALEN], unsigned int vid);
>  int ocelot_port_lag_join(struct ocelot *ocelot, int port,
>  			 struct net_device *bond);
> -void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
> -			   struct net_device *bond);
> +int ocelot_port_lag_leave(struct ocelot *ocelot, int port,
> +			  struct net_device *bond);
>  struct net_device *ocelot_port_to_netdev(struct ocelot *ocelot, int port);
>  int ocelot_netdev_to_port(struct net_device *dev);
>  
> diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
> index 77957328722a..93aaa631e347 100644
> --- a/drivers/net/ethernet/mscc/ocelot_net.c
> +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> @@ -1035,8 +1035,8 @@ static int ocelot_netdevice_changeupper(struct net_device *dev,
>  			err = ocelot_port_lag_join(ocelot, port,
>  						   info->upper_dev);
>  		else
> -			ocelot_port_lag_leave(ocelot, port,
> -					      info->upper_dev);
> +			err = ocelot_port_lag_leave(ocelot, port,
> +						    info->upper_dev);
>  	}
>  
>  	return notifier_from_errno(err);
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index b812bdff1da1..0cd45659430f 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -639,8 +639,6 @@ struct ocelot {
>  	enum ocelot_tag_prefix		inj_prefix;
>  	enum ocelot_tag_prefix		xtr_prefix;
>  
> -	u32				*lags;
> -
>  	struct list_head		multicast;
>  	struct list_head		pgids;
>  
> -- 
> 2.25.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
