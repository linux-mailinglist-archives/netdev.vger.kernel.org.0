Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B7E2DB1A0
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 17:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgLOQhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 11:37:05 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:47311 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgLOQgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 11:36:51 -0500
X-Originating-IP: 86.202.109.140
Received: from localhost (lfbn-lyo-1-13-140.w86-202.abo.wanadoo.fr [86.202.109.140])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 09D2D60003;
        Tue, 15 Dec 2020 16:36:07 +0000 (UTC)
Date:   Tue, 15 Dec 2020 17:36:07 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [RFC PATCH net-next 07/16] net: mscc: ocelot: set up the bonding
 mask in a way that avoids a net_device
Message-ID: <20201215163607.GK1781038@piout.net>
References: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
 <20201208120802.1268708-8-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208120802.1268708-8-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12/2020 14:07:53+0200, Vladimir Oltean wrote:
> Since this code should be called from pure switchdev as well as from
> DSA, we must find a way to determine the bonding mask not by looking
> directly at the net_device lowers of the bonding interface, since those
> could have different private structures.
> 
> We keep a pointer to the bonding upper interface, if present, in struct
> ocelot_port. Then the bonding mask becomes the bitwise OR of all ports
> that have the same bonding upper interface. This adds a duplication of
> functionality with the current "lags" array, but the duplication will be
> short-lived, since further patches will remove the latter completely.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
>  drivers/net/ethernet/mscc/ocelot.c | 29 ++++++++++++++++++++++-------
>  include/soc/mscc/ocelot.h          |  2 ++
>  2 files changed, 24 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index 13e86dd71e5a..30dee1f957d1 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -881,6 +881,24 @@ int ocelot_get_ts_info(struct ocelot *ocelot, int port,
>  }
>  EXPORT_SYMBOL(ocelot_get_ts_info);
>  
> +static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
> +{
> +	u32 bond_mask = 0;
> +	int port;
> +
> +	for (port = 0; port < ocelot->num_phys_ports; port++) {
> +		struct ocelot_port *ocelot_port = ocelot->ports[port];
> +
> +		if (!ocelot_port)
> +			continue;
> +
> +		if (ocelot_port->bond == bond)
> +			bond_mask |= BIT(port);
> +	}
> +
> +	return bond_mask;
> +}
> +
>  void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
>  {
>  	struct ocelot_port *ocelot_port = ocelot->ports[port];
> @@ -1272,17 +1290,12 @@ static void ocelot_setup_lag(struct ocelot *ocelot, int lag)
>  int ocelot_port_lag_join(struct ocelot *ocelot, int port,
>  			 struct net_device *bond)
>  {
> -	struct net_device *ndev;
>  	u32 bond_mask = 0;
>  	int lag, lp;
>  
> -	rcu_read_lock();
> -	for_each_netdev_in_bond_rcu(bond, ndev) {
> -		struct ocelot_port_private *priv = netdev_priv(ndev);
> +	ocelot->ports[port]->bond = bond;
>  
> -		bond_mask |= BIT(priv->chip_port);
> -	}
> -	rcu_read_unlock();
> +	bond_mask = ocelot_get_bond_mask(ocelot, bond);
>  
>  	lp = __ffs(bond_mask);
>  
> @@ -1315,6 +1328,8 @@ void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
>  	u32 port_cfg;
>  	int i;
>  
> +	ocelot->ports[port]->bond = NULL;
> +
>  	/* Remove port from any lag */
>  	for (i = 0; i < ocelot->num_phys_ports; i++)
>  		ocelot->lags[i] &= ~BIT(port);
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index 50514c087231..b812bdff1da1 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -597,6 +597,8 @@ struct ocelot_port {
>  	phy_interface_t			phy_mode;
>  
>  	u8				*xmit_template;
> +
> +	struct net_device		*bond;
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
