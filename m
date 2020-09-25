Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC24278A09
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 15:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbgIYNxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 09:53:30 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:34759 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgIYNxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 09:53:30 -0400
X-Originating-IP: 90.65.88.165
Received: from localhost (lfbn-lyo-1-1908-165.w90-65.abo.wanadoo.fr [90.65.88.165])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 5815EE0013;
        Fri, 25 Sep 2020 13:53:27 +0000 (UTC)
Date:   Fri, 25 Sep 2020 15:53:27 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, horatiu.vultur@microchip.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [RFC PATCH net-next 07/14] net: mscc: ocelot: introduce
 conversion helpers between port and netdev
Message-ID: <20200925135327.GB9675@piout.net>
References: <20200925121855.370863-1-vladimir.oltean@nxp.com>
 <20200925121855.370863-8-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925121855.370863-8-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/09/2020 15:18:48+0300, Vladimir Oltean wrote:
> Since the mscc_ocelot_switch_lib is common between a pure switchdev and
> a DSA driver, the procedure of retrieving a net_device for a certain
> port index differs, as those are registered by their individual
> front-ends.
> 
> Up to now that has been dealt with by always passing the port index to
> the switch library, but now, we're going to need to work with net_device
> pointers from the tc-flower offload, for things like indev, or mirred.
> It is not desirable to refactor that, so let's make sure that the flower
> offload core has the ability to translate between a net_device and a
> port index properly.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
>  drivers/net/dsa/ocelot/felix.c             | 22 ++++++++++++++++
>  drivers/net/dsa/ocelot/felix.h             |  3 +++
>  drivers/net/dsa/ocelot/felix_vsc9959.c     |  2 ++
>  drivers/net/dsa/ocelot/seville_vsc9953.c   |  2 ++
>  drivers/net/ethernet/mscc/ocelot.h         |  2 ++
>  drivers/net/ethernet/mscc/ocelot_net.c     | 30 ++++++++++++++++++++++
>  drivers/net/ethernet/mscc/ocelot_vsc7514.c |  2 ++
>  include/soc/mscc/ocelot.h                  |  2 ++
>  8 files changed, 65 insertions(+)
> 
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> index 8ebdebc44c72..a0b803fdbac8 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -810,3 +810,25 @@ const struct dsa_switch_ops felix_switch_ops = {
>  	.cls_flower_stats	= felix_cls_flower_stats,
>  	.port_setup_tc		= felix_port_setup_tc,
>  };
> +
> +struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port)
> +{
> +	struct felix *felix = ocelot_to_felix(ocelot);
> +	struct dsa_switch *ds = felix->ds;
> +
> +	if (!dsa_is_user_port(ds, port))
> +		return NULL;
> +
> +	return dsa_to_port(ds, port)->slave;
> +}
> +
> +int felix_netdev_to_port(struct net_device *dev)
> +{
> +	struct dsa_port *dp;
> +
> +	dp = dsa_port_from_netdev(dev);
> +	if (IS_ERR(dp))
> +		return -EINVAL;
> +
> +	return dp->index;
> +}
> diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
> index 6f6383904cc9..83bab486c61a 100644
> --- a/drivers/net/dsa/ocelot/felix.h
> +++ b/drivers/net/dsa/ocelot/felix.h
> @@ -51,4 +51,7 @@ struct felix {
>  	resource_size_t			imdio_base;
>  };
>  
> +struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port);
> +int felix_netdev_to_port(struct net_device *dev);
> +
>  #endif
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> index 601853e05754..66e991ab9df5 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -867,6 +867,8 @@ static u16 vsc9959_wm_enc(u16 value)
>  static const struct ocelot_ops vsc9959_ops = {
>  	.reset			= vsc9959_reset,
>  	.wm_enc			= vsc9959_wm_enc,
> +	.port_to_netdev		= felix_port_to_netdev,
> +	.netdev_to_port		= felix_netdev_to_port,
>  };
>  
>  static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
> diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
> index b921ad98e90a..87ca36c77606 100644
> --- a/drivers/net/dsa/ocelot/seville_vsc9953.c
> +++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
> @@ -920,6 +920,8 @@ static u16 vsc9953_wm_enc(u16 value)
>  static const struct ocelot_ops vsc9953_ops = {
>  	.reset			= vsc9953_reset,
>  	.wm_enc			= vsc9953_wm_enc,
> +	.port_to_netdev		= felix_port_to_netdev,
> +	.netdev_to_port		= felix_netdev_to_port,
>  };
>  
>  static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
> diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
> index dc29e05103a1..abb407dff93c 100644
> --- a/drivers/net/ethernet/mscc/ocelot.h
> +++ b/drivers/net/ethernet/mscc/ocelot.h
> @@ -98,6 +98,8 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
>  			 struct net_device *bond);
>  void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
>  			   struct net_device *bond);
> +struct net_device *ocelot_port_to_netdev(struct ocelot *ocelot, int port);
> +int ocelot_netdev_to_port(struct net_device *dev);
>  
>  u32 ocelot_port_readl(struct ocelot_port *port, u32 reg);
>  void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
> diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
> index 028a0150f97d..64e619f0f5b2 100644
> --- a/drivers/net/ethernet/mscc/ocelot_net.c
> +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> @@ -656,6 +656,36 @@ static const struct net_device_ops ocelot_port_netdev_ops = {
>  	.ndo_do_ioctl			= ocelot_ioctl,
>  };
>  
> +struct net_device *ocelot_port_to_netdev(struct ocelot *ocelot, int port)
> +{
> +	struct ocelot_port *ocelot_port = ocelot->ports[port];
> +	struct ocelot_port_private *priv;
> +
> +	if (!ocelot_port)
> +		return NULL;
> +
> +	priv = container_of(ocelot_port, struct ocelot_port_private, port);
> +
> +	return priv->dev;
> +}
> +
> +static bool ocelot_port_dev_check(const struct net_device *dev)
> +{
> +	return dev->netdev_ops == &ocelot_port_netdev_ops;
> +}
> +
> +int ocelot_netdev_to_port(struct net_device *dev)
> +{
> +	struct ocelot_port_private *priv;
> +
> +	if (!dev || !ocelot_port_dev_check(dev))
> +		return -EINVAL;
> +
> +	priv = netdev_priv(dev);
> +
> +	return priv->chip_port;
> +}
> +
>  static void ocelot_port_get_strings(struct net_device *netdev, u32 sset,
>  				    u8 *data)
>  {
> diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> index 5a93f7a76ade..a7f53fc6f746 100644
> --- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> +++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> @@ -757,6 +757,8 @@ static u16 ocelot_wm_enc(u16 value)
>  static const struct ocelot_ops ocelot_ops = {
>  	.reset			= ocelot_reset,
>  	.wm_enc			= ocelot_wm_enc,
> +	.port_to_netdev		= ocelot_port_to_netdev,
> +	.netdev_to_port		= ocelot_netdev_to_port,
>  };
>  
>  static const struct vcap_field vsc7514_vcap_is2_keys[] = {
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index 45c7dc7b54b6..9706206125a7 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -546,6 +546,8 @@ enum ocelot_tag_prefix {
>  struct ocelot;
>  
>  struct ocelot_ops {
> +	struct net_device *(*port_to_netdev)(struct ocelot *ocelot, int port);
> +	int (*netdev_to_port)(struct net_device *dev);
>  	int (*reset)(struct ocelot *ocelot);
>  	u16 (*wm_enc)(u16 value);
>  };
> -- 
> 2.25.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
