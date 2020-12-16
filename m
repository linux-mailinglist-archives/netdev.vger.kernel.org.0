Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0992DC861
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 22:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgLPVdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 16:33:08 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:53411 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgLPVdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 16:33:07 -0500
X-Originating-IP: 86.202.109.140
Received: from localhost (lfbn-lyo-1-13-140.w86-202.abo.wanadoo.fr [86.202.109.140])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 4DB6240002;
        Wed, 16 Dec 2020 21:32:24 +0000 (UTC)
Date:   Wed, 16 Dec 2020 22:32:24 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [RFC PATCH net-next 14/16] net: mscc: ocelot: rebalance LAGs on
 link up/down events
Message-ID: <20201216213224.GR2814589@piout.net>
References: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
 <20201208120802.1268708-15-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208120802.1268708-15-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12/2020 14:08:00+0200, Vladimir Oltean wrote:
> At present there is an issue when ocelot is offloading a bonding
> interface, but one of the links of the physical ports goes down. Traffic
> keeps being hashed towards that destination, and of course gets dropped
> on egress.
> 
> Monitor the netdev notifier events emitted by the bonding driver for
> changes in the physical state of lower interfaces, to determine which
> ports are active and which ones are no longer.
> 
> Then extend ocelot_get_bond_mask to return either the configured bonding
> interfaces, or the active ones, depending on a boolean argument. The
> code that does rebalancing only needs to do so among the active ports,
> whereas the bridge forwarding mask and the logical port IDs still need
> to look at the permanently bonded ports.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/mscc/ocelot.c     | 43 ++++++++++++++++++++------
>  drivers/net/ethernet/mscc/ocelot.h     |  2 ++
>  drivers/net/ethernet/mscc/ocelot_net.c | 26 ++++++++++++++++
>  include/soc/mscc/ocelot.h              |  1 +
>  4 files changed, 63 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index d87e80a15ca5..5c71d121048d 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -881,7 +881,8 @@ int ocelot_get_ts_info(struct ocelot *ocelot, int port,
>  }
>  EXPORT_SYMBOL(ocelot_get_ts_info);
>  
> -static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
> +static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond,
> +				bool just_active_ports)

only_active_ports maybe ?

>  {
>  	u32 bond_mask = 0;
>  	int port;
> @@ -892,8 +893,12 @@ static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
>  		if (!ocelot_port)
>  			continue;
>  
> -		if (ocelot_port->bond == bond)
> +		if (ocelot_port->bond == bond) {
> +			if (just_active_ports && !ocelot_port->lag_tx_active)
> +				continue;
> +
>  			bond_mask |= BIT(port);
> +		}
>  	}
>  
>  	return bond_mask;
> @@ -919,7 +924,7 @@ static void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
>  			struct net_device *bond = ocelot_port->bond;
>  
>  			if (bond)
> -				mask &= ~ocelot_get_bond_mask(ocelot, bond);
> +				mask &= ~ocelot_get_bond_mask(ocelot, bond, false);
>  
>  			ocelot_write_rix(ocelot, mask,
>  					 ANA_PGID_PGID, PGID_SRC + port);
> @@ -1261,22 +1266,22 @@ static int ocelot_set_aggr_pgids(struct ocelot *ocelot)
>  		bonds[port] = ocelot_port->bond;
>  	}
>  
> -	/* Now, set PGIDs for each LAG */
> +	/* Now, set PGIDs for each active LAG */
>  	for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
> -		int num_ports_in_lag = 0;
> +		int num_active_ports = 0;
>  		unsigned long bond_mask;
>  		u8 aggr_idx[16];
>  
>  		if (!bonds[lag])
>  			continue;
>  
> -		bond_mask = ocelot_get_bond_mask(ocelot, bonds[lag]);
> +		bond_mask = ocelot_get_bond_mask(ocelot, bonds[lag], true);
>  
>  		for_each_set_bit(port, &bond_mask, ocelot->num_phys_ports) {
>  			// Destination mask
>  			ocelot_write_rix(ocelot, bond_mask,
>  					 ANA_PGID_PGID, port);
> -			aggr_idx[num_ports_in_lag++] = port;
> +			aggr_idx[num_active_ports++] = port;
>  		}
>  
>  		for_each_aggr_pgid(ocelot, i) {
> @@ -1284,7 +1289,11 @@ static int ocelot_set_aggr_pgids(struct ocelot *ocelot)
>  
>  			ac = ocelot_read_rix(ocelot, ANA_PGID_PGID, i);
>  			ac &= ~bond_mask;
> -			ac |= BIT(aggr_idx[i % num_ports_in_lag]);
> +			/* Don't do division by zero if there was no active
> +			 * port. Just make all aggregation codes zero.
> +			 */
> +			if (num_active_ports)
> +				ac |= BIT(aggr_idx[i % num_active_ports]);
>  			ocelot_write_rix(ocelot, ac, ANA_PGID_PGID, i);
>  		}
>  
> @@ -1320,7 +1329,8 @@ static void ocelot_setup_logical_port_ids(struct ocelot *ocelot)
>  
>  		bond = ocelot_port->bond;
>  		if (bond) {
> -			int lag = __ffs(ocelot_get_bond_mask(ocelot, bond));
> +			int lag = __ffs(ocelot_get_bond_mask(ocelot, bond,
> +							     false));
>  
>  			ocelot_rmw_gix(ocelot,
>  				       ANA_PORT_PORT_CFG_PORTID_VAL(lag),
> @@ -1357,6 +1367,21 @@ int ocelot_port_lag_leave(struct ocelot *ocelot, int port,
>  }
>  EXPORT_SYMBOL(ocelot_port_lag_leave);
>  
> +int ocelot_port_lag_change(struct ocelot *ocelot, int port,
> +			   struct netdev_lag_lower_state_info *info)
> +{
> +	struct ocelot_port *ocelot_port = ocelot->ports[port];
> +	bool is_active = info->link_up && info->tx_enabled;
> +
> +	if (ocelot_port->lag_tx_active == is_active)
> +		return 0;
> +
> +	ocelot_port->lag_tx_active = is_active;
> +
> +	/* Rebalance the LAGs */
> +	return ocelot_set_aggr_pgids(ocelot);
> +}
> +
>  /* Configure the maximum SDU (L2 payload) on RX to the value specified in @sdu.
>   * The length of VLAN tags is accounted for automatically via DEV_MAC_TAGS_CFG.
>   * In the special case that it's the NPI port that we're configuring, the
> diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
> index bef8d5f8e6e5..0860125b623c 100644
> --- a/drivers/net/ethernet/mscc/ocelot.h
> +++ b/drivers/net/ethernet/mscc/ocelot.h
> @@ -116,6 +116,8 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
>  			 struct net_device *bond);
>  int ocelot_port_lag_leave(struct ocelot *ocelot, int port,
>  			  struct net_device *bond);
> +int ocelot_port_lag_change(struct ocelot *ocelot, int port,
> +			   struct netdev_lag_lower_state_info *info);
>  struct net_device *ocelot_port_to_netdev(struct ocelot *ocelot, int port);
>  int ocelot_netdev_to_port(struct net_device *dev);
>  
> diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
> index 93aaa631e347..714fc99f8339 100644
> --- a/drivers/net/ethernet/mscc/ocelot_net.c
> +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> @@ -1065,6 +1065,23 @@ ocelot_netdevice_lag_changeupper(struct net_device *dev,
>  	return NOTIFY_DONE;
>  }
>  
> +static int
> +ocelot_netdevice_changelowerstate(struct net_device *dev,
> +				  struct netdev_lag_lower_state_info *linfo)
> +{
> +	struct ocelot_port_private *priv = netdev_priv(dev);
> +	struct ocelot_port *ocelot_port = &priv->port;
> +	struct ocelot *ocelot = ocelot_port->ocelot;
> +	int port = priv->chip_port;
> +	int err;
> +
> +	if (!ocelot_port->bond)
> +		return NOTIFY_DONE;
> +
> +	err = ocelot_port_lag_change(ocelot, port, linfo);
> +	return notifier_from_errno(err);
> +}
> +
>  static int ocelot_netdevice_event(struct notifier_block *unused,
>  				  unsigned long event, void *ptr)
>  {
> @@ -1082,6 +1099,15 @@ static int ocelot_netdevice_event(struct notifier_block *unused,
>  
>  		break;
>  	}
> +	case NETDEV_CHANGELOWERSTATE: {
> +		struct netdev_notifier_changelowerstate_info *info = ptr;
> +
> +		if (!ocelot_netdevice_dev_check(dev))
> +			break;
> +
> +		return ocelot_netdevice_changelowerstate(dev,
> +							 info->lower_state_info);
> +	}
>  	default:
>  		break;
>  	}
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index 0cd45659430f..8a44b9064789 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -599,6 +599,7 @@ struct ocelot_port {
>  	u8				*xmit_template;
>  
>  	struct net_device		*bond;
> +	bool				lag_tx_active;
>  };
>  
>  struct ocelot {
> -- 
> 2.25.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
