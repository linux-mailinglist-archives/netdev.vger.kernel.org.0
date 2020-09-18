Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34E62700F8
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 17:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgIRP3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 11:29:19 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:57099 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbgIRP3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 11:29:17 -0400
X-Originating-IP: 90.65.88.165
Received: from localhost (lfbn-lyo-1-1908-165.w90-65.abo.wanadoo.fr [90.65.88.165])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 59F7260004;
        Fri, 18 Sep 2020 15:29:15 +0000 (UTC)
Date:   Fri, 18 Sep 2020 17:29:15 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, UNGLinuxDriver@microchip.com,
        claudiu.manoil@nxp.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org
Subject: Re: [PATCH v2 net 8/8] net: mscc: ocelot: deinitialize only
 initialized ports
Message-ID: <20200918152915.GE9675@piout.net>
References: <20200918010730.2911234-1-olteanv@gmail.com>
 <20200918010730.2911234-9-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918010730.2911234-9-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/09/2020 04:07:30+0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Currently mscc_ocelot_init_ports() will skip initializing a port when it
> doesn't have a phy-handle, so the ocelot->ports[port] pointer will be
> NULL. Take this into consideration when tearing down the driver, and add
> a new function ocelot_deinit_port() to the switch library, mirror of
> ocelot_init_port(), which needs to be called by the driver for all ports
> it has initialized.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Tested-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
> Changes in v2:
> Patch is new.
> 
>  drivers/net/dsa/ocelot/felix.c             |  3 +++
>  drivers/net/ethernet/mscc/ocelot.c         | 16 ++++++++--------
>  drivers/net/ethernet/mscc/ocelot_vsc7514.c |  2 ++
>  include/soc/mscc/ocelot.h                  |  1 +
>  4 files changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> index f7b43f8d56ed..64939ee14648 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -624,10 +624,13 @@ static void felix_teardown(struct dsa_switch *ds)
>  {
>  	struct ocelot *ocelot = ds->priv;
>  	struct felix *felix = ocelot_to_felix(ocelot);
> +	int port;
>  
>  	if (felix->info->mdio_bus_free)
>  		felix->info->mdio_bus_free(ocelot);
>  
> +	for (port = 0; port < ocelot->num_phys_ports; port++)
> +		ocelot_deinit_port(ocelot, port);
>  	ocelot_deinit_timestamp(ocelot);
>  	/* stop workqueue thread */
>  	ocelot_deinit(ocelot);
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index 83eb7c325061..8518e1d60da4 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -1550,18 +1550,18 @@ EXPORT_SYMBOL(ocelot_init);
>  
>  void ocelot_deinit(struct ocelot *ocelot)
>  {
> -	struct ocelot_port *port;
> -	int i;
> -
>  	cancel_delayed_work(&ocelot->stats_work);
>  	destroy_workqueue(ocelot->stats_queue);
>  	mutex_destroy(&ocelot->stats_lock);
> -
> -	for (i = 0; i < ocelot->num_phys_ports; i++) {
> -		port = ocelot->ports[i];
> -		skb_queue_purge(&port->tx_skbs);
> -	}
>  }
>  EXPORT_SYMBOL(ocelot_deinit);
>  
> +void ocelot_deinit_port(struct ocelot *ocelot, int port)
> +{
> +	struct ocelot_port *ocelot_port = ocelot->ports[port];
> +
> +	skb_queue_purge(&ocelot_port->tx_skbs);
> +}
> +EXPORT_SYMBOL(ocelot_deinit_port);
> +
>  MODULE_LICENSE("Dual MIT/GPL");
> diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> index 252c49b5f22b..e02fb8bfab63 100644
> --- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> +++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> @@ -908,6 +908,8 @@ static void mscc_ocelot_release_ports(struct ocelot *ocelot)
>  		if (!ocelot_port)
>  			continue;
>  
> +		ocelot_deinit_port(ocelot, port);
> +
>  		priv = container_of(ocelot_port, struct ocelot_port_private,
>  				    port);
>  
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index 4521dd602ddc..0ac4e7fba086 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -678,6 +678,7 @@ void ocelot_configure_cpu(struct ocelot *ocelot, int npi,
>  int ocelot_init(struct ocelot *ocelot);
>  void ocelot_deinit(struct ocelot *ocelot);
>  void ocelot_init_port(struct ocelot *ocelot, int port);
> +void ocelot_deinit_port(struct ocelot *ocelot, int port);
>  
>  /* DSA callbacks */
>  void ocelot_port_enable(struct ocelot *ocelot, int port,
> -- 
> 2.25.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
