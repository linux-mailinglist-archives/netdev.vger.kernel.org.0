Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57172700F2
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 17:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgIRP26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 11:28:58 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:60005 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726306AbgIRP24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 11:28:56 -0400
X-Originating-IP: 90.65.88.165
Received: from localhost (lfbn-lyo-1-1908-165.w90-65.abo.wanadoo.fr [90.65.88.165])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 63397FF809;
        Fri, 18 Sep 2020 15:28:54 +0000 (UTC)
Date:   Fri, 18 Sep 2020 17:28:54 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, UNGLinuxDriver@microchip.com,
        claudiu.manoil@nxp.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org
Subject: Re: [PATCH v2 net 7/8] net: mscc: ocelot: unregister net devices on
 unbind
Message-ID: <20200918152854.GD9675@piout.net>
References: <20200918010730.2911234-1-olteanv@gmail.com>
 <20200918010730.2911234-8-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918010730.2911234-8-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/09/2020 04:07:29+0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This driver was not unregistering its network interfaces on unbind.
> Now it is.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Tested-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
> Changes in v2:
> No longer call mscc_ocelot_release_ports from the regular exit path of
> mscc_ocelot_init_ports, which was incorrect.
> 
>  drivers/net/ethernet/mscc/ocelot_vsc7514.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> index ff4a01424953..252c49b5f22b 100644
> --- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> +++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> @@ -896,6 +896,26 @@ static struct ptp_clock_info ocelot_ptp_clock_info = {
>  	.enable		= ocelot_ptp_enable,
>  };
>  
> +static void mscc_ocelot_release_ports(struct ocelot *ocelot)
> +{
> +	int port;
> +
> +	for (port = 0; port < ocelot->num_phys_ports; port++) {
> +		struct ocelot_port_private *priv;
> +		struct ocelot_port *ocelot_port;
> +
> +		ocelot_port = ocelot->ports[port];
> +		if (!ocelot_port)
> +			continue;
> +
> +		priv = container_of(ocelot_port, struct ocelot_port_private,
> +				    port);
> +
> +		unregister_netdev(priv->dev);
> +		free_netdev(priv->dev);
> +	}
> +}
> +
>  static int mscc_ocelot_init_ports(struct platform_device *pdev,
>  				  struct device_node *ports)
>  {
> @@ -1132,6 +1152,7 @@ static int mscc_ocelot_remove(struct platform_device *pdev)
>  	struct ocelot *ocelot = platform_get_drvdata(pdev);
>  
>  	ocelot_deinit_timestamp(ocelot);
> +	mscc_ocelot_release_ports(ocelot);
>  	ocelot_deinit(ocelot);
>  	unregister_switchdev_blocking_notifier(&ocelot_switchdev_blocking_nb);
>  	unregister_switchdev_notifier(&ocelot_switchdev_nb);
> -- 
> 2.25.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
