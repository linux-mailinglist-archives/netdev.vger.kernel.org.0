Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98ACE2DAF1D
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 15:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729486AbgLOOiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 09:38:23 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:42273 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729317AbgLOOiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 09:38:02 -0500
X-Originating-IP: 86.202.109.140
Received: from localhost (lfbn-lyo-1-13-140.w86-202.abo.wanadoo.fr [86.202.109.140])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 97B7A1BF203;
        Tue, 15 Dec 2020 14:37:11 +0000 (UTC)
Date:   Tue, 15 Dec 2020 15:37:11 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [RFC PATCH net-next 01/16] net: mscc: ocelot: offload bridge
 port flags to device
Message-ID: <20201215143711.GC1781038@piout.net>
References: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
 <20201208120802.1268708-2-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208120802.1268708-2-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12/2020 14:07:47+0200, Vladimir Oltean wrote:
> We should not be unconditionally enabling address learning, since doing
> that is actively detrimential when a port is standalone and not offloading
> a bridge. Namely, if a port in the switch is standalone and others are
> offloading the bridge, then we could enter a situation where we learn an
> address towards the standalone port, but the bridged ports could not
> forward the packet there, because the CPU is the only path between the
> standalone and the bridged ports. The solution of course is to not
> enable address learning unless the bridge asks for it. Currently this is
> the only bridge port flag we are looking at. The others (flooding etc)
> are TBD.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
>  drivers/net/ethernet/mscc/ocelot.c     | 21 ++++++++++++++++++++-
>  drivers/net/ethernet/mscc/ocelot.h     |  3 +++
>  drivers/net/ethernet/mscc/ocelot_net.c |  4 ++++
>  include/soc/mscc/ocelot.h              |  2 ++
>  4 files changed, 29 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index b9626eec8db6..7a5c534099d3 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -883,6 +883,7 @@ EXPORT_SYMBOL(ocelot_get_ts_info);
>  
>  void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
>  {
> +	struct ocelot_port *ocelot_port = ocelot->ports[port];
>  	u32 port_cfg;
>  	int p, i;
>  
> @@ -896,7 +897,8 @@ void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
>  		ocelot->bridge_fwd_mask |= BIT(port);
>  		fallthrough;
>  	case BR_STATE_LEARNING:
> -		port_cfg |= ANA_PORT_PORT_CFG_LEARN_ENA;
> +		if (ocelot_port->brport_flags & BR_LEARNING)
> +			port_cfg |= ANA_PORT_PORT_CFG_LEARN_ENA;
>  		break;
>  
>  	default:
> @@ -1178,6 +1180,7 @@ EXPORT_SYMBOL(ocelot_port_bridge_join);
>  int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
>  			     struct net_device *bridge)
>  {
> +	struct ocelot_port *ocelot_port = ocelot->ports[port];
>  	struct ocelot_vlan pvid = {0}, native_vlan = {0};
>  	struct switchdev_trans trans;
>  	int ret;
> @@ -1200,6 +1203,10 @@ int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
>  	ocelot_port_set_pvid(ocelot, port, pvid);
>  	ocelot_port_set_native_vlan(ocelot, port, native_vlan);
>  
> +	ocelot_port->brport_flags = 0;
> +	ocelot_rmw_gix(ocelot, 0, ANA_PORT_PORT_CFG_LEARN_ENA,
> +		       ANA_PORT_PORT_CFG, port);
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL(ocelot_port_bridge_leave);
> @@ -1391,6 +1398,18 @@ int ocelot_get_max_mtu(struct ocelot *ocelot, int port)
>  }
>  EXPORT_SYMBOL(ocelot_get_max_mtu);
>  
> +void ocelot_port_bridge_flags(struct ocelot *ocelot, int port,
> +			      unsigned long flags,
> +			      struct switchdev_trans *trans)
> +{
> +	struct ocelot_port *ocelot_port = ocelot->ports[port];
> +
> +	if (switchdev_trans_ph_prepare(trans))
> +		return;
> +
> +	ocelot_port->brport_flags = flags;
> +}
> +
>  void ocelot_init_port(struct ocelot *ocelot, int port)
>  {
>  	struct ocelot_port *ocelot_port = ocelot->ports[port];
> diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
> index 291d39d49c4e..739bd201d951 100644
> --- a/drivers/net/ethernet/mscc/ocelot.h
> +++ b/drivers/net/ethernet/mscc/ocelot.h
> @@ -102,6 +102,9 @@ struct ocelot_multicast {
>  	struct ocelot_pgid *pgid;
>  };
>  
> +void ocelot_port_bridge_flags(struct ocelot *ocelot, int port,
> +			      unsigned long flags,
> +			      struct switchdev_trans *trans);
>  int ocelot_port_fdb_do_dump(const unsigned char *addr, u16 vid,
>  			    bool is_static, void *data);
>  int ocelot_mact_learn(struct ocelot *ocelot, int port,
> diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
> index 9ba7e2b166e9..93ecd5274156 100644
> --- a/drivers/net/ethernet/mscc/ocelot_net.c
> +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> @@ -882,6 +882,10 @@ static int ocelot_port_attr_set(struct net_device *dev,
>  	case SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED:
>  		ocelot_port_attr_mc_set(ocelot, port, !attr->u.mc_disabled);
>  		break;
> +	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
> +		ocelot_port_bridge_flags(ocelot, port, attr->u.brport_flags,
> +					 trans);
> +		break;
>  	default:
>  		err = -EOPNOTSUPP;
>  		break;
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index 2f4cd3288bcc..50514c087231 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -581,6 +581,8 @@ struct ocelot_port {
>  
>  	struct regmap			*target;
>  
> +	unsigned long			brport_flags;
> +
>  	bool				vlan_aware;
>  	/* VLAN that untagged frames are classified to, on ingress */
>  	struct ocelot_vlan		pvid_vlan;
> -- 
> 2.25.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
