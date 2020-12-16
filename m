Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1A32DC04F
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 13:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgLPM3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 07:29:48 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:56571 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbgLPM3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 07:29:48 -0500
X-Originating-IP: 86.202.109.140
Received: from localhost (lfbn-lyo-1-13-140.w86-202.abo.wanadoo.fr [86.202.109.140])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 946701BF203;
        Wed, 16 Dec 2020 12:29:03 +0000 (UTC)
Date:   Wed, 16 Dec 2020 13:29:03 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [RFC PATCH net-next 10/16] net: mscc: ocelot: reapply bridge
 forwarding mask on bonding join/leave
Message-ID: <20201216122903.GD2814589@piout.net>
References: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
 <20201208120802.1268708-11-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208120802.1268708-11-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12/2020 14:07:56+0200, Vladimir Oltean wrote:
> Applying the bridge forwarding mask currently is done only on the STP
> state changes for any port. But it depends on both STP state changes,
> and bonding interface state changes. Export the bit that recalculates
> the forwarding mask so that it could be reused, and call it when a port
> starts and stops offloading a bonding interface.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
>  drivers/net/ethernet/mscc/ocelot.c | 68 +++++++++++++++++-------------
>  1 file changed, 38 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index c3c6682e6e79..ee0fcee8e09a 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -899,11 +899,45 @@ static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
>  	return bond_mask;
>  }
>  
> +static void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
> +{
> +	int port;
> +
> +	/* Apply FWD mask. The loop is needed to add/remove the current port as
> +	 * a source for the other ports. If the source port is in a bond, then
> +	 * all the other ports from that bond need to be removed from this
> +	 * source port's forwarding mask.
> +	 */
> +	for (port = 0; port < ocelot->num_phys_ports; port++) {
> +		if (ocelot->bridge_fwd_mask & BIT(port)) {
> +			unsigned long mask = ocelot->bridge_fwd_mask & ~BIT(port);
> +			int lag;
> +
> +			for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
> +				unsigned long bond_mask = ocelot->lags[lag];
> +
> +				if (!bond_mask)
> +					continue;
> +
> +				if (bond_mask & BIT(port)) {
> +					mask &= ~bond_mask;
> +					break;
> +				}
> +			}
> +
> +			ocelot_write_rix(ocelot, mask,
> +					 ANA_PGID_PGID, PGID_SRC + port);
> +		} else {
> +			ocelot_write_rix(ocelot, 0,
> +					 ANA_PGID_PGID, PGID_SRC + port);
> +		}
> +	}
> +}
> +
>  void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
>  {
>  	struct ocelot_port *ocelot_port = ocelot->ports[port];
>  	u32 port_cfg;
> -	int p;
>  
>  	if (!(BIT(port) & ocelot->bridge_mask))
>  		return;
> @@ -927,35 +961,7 @@ void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
>  
>  	ocelot_write_gix(ocelot, port_cfg, ANA_PORT_PORT_CFG, port);
>  
> -	/* Apply FWD mask. The loop is needed to add/remove the current port as
> -	 * a source for the other ports. If the source port is in a bond, then
> -	 * all the other ports from that bond need to be removed from this
> -	 * source port's forwarding mask.
> -	 */
> -	for (p = 0; p < ocelot->num_phys_ports; p++) {
> -		if (ocelot->bridge_fwd_mask & BIT(p)) {
> -			unsigned long mask = ocelot->bridge_fwd_mask & ~BIT(p);
> -			int lag;
> -
> -			for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
> -				unsigned long bond_mask = ocelot->lags[lag];
> -
> -				if (!bond_mask)
> -					continue;
> -
> -				if (bond_mask & BIT(p)) {
> -					mask &= ~bond_mask;
> -					break;
> -				}
> -			}
> -
> -			ocelot_write_rix(ocelot, mask,
> -					 ANA_PGID_PGID, PGID_SRC + p);
> -		} else {
> -			ocelot_write_rix(ocelot, 0,
> -					 ANA_PGID_PGID, PGID_SRC + p);
> -		}
> -	}
> +	ocelot_apply_bridge_fwd_mask(ocelot);
>  }
>  EXPORT_SYMBOL(ocelot_bridge_stp_state_set);
>  
> @@ -1315,6 +1321,7 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
>  	}
>  
>  	ocelot_setup_lag(ocelot, lag);
> +	ocelot_apply_bridge_fwd_mask(ocelot);
>  	ocelot_set_aggr_pgids(ocelot);
>  
>  	return 0;
> @@ -1350,6 +1357,7 @@ void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
>  	ocelot_write_gix(ocelot, port_cfg | ANA_PORT_PORT_CFG_PORTID_VAL(port),
>  			 ANA_PORT_PORT_CFG, port);
>  
> +	ocelot_apply_bridge_fwd_mask(ocelot);
>  	ocelot_set_aggr_pgids(ocelot);
>  }
>  EXPORT_SYMBOL(ocelot_port_lag_leave);
> -- 
> 2.25.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
