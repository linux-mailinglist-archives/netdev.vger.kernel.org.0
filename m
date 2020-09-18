Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA942700ED
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 17:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgIRP2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 11:28:45 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:50957 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgIRP2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 11:28:45 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2020 11:28:43 EDT
X-Originating-IP: 90.65.88.165
Received: from localhost (lfbn-lyo-1-1908-165.w90-65.abo.wanadoo.fr [90.65.88.165])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 2C70E6000F;
        Fri, 18 Sep 2020 15:28:41 +0000 (UTC)
Date:   Fri, 18 Sep 2020 17:28:40 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, UNGLinuxDriver@microchip.com,
        claudiu.manoil@nxp.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org
Subject: Re: [PATCH v2 net 6/8] net: mscc: ocelot: refactor ports parsing
 code into a dedicated function
Message-ID: <20200918152840.GC9675@piout.net>
References: <20200918010730.2911234-1-olteanv@gmail.com>
 <20200918010730.2911234-7-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918010730.2911234-7-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/09/2020 04:07:28+0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> mscc_ocelot_probe() is already pretty large and hard to follow. So move
> the code for parsing ports in a separate function.
> 
> This makes it easier for the next patch to just call
> mscc_ocelot_release_ports from the error path of mscc_ocelot_init_ports.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Tested-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
> Changes in v2:
> Keep a reference to the 'ports' OF node at caller side, in
> mscc_ocelot_probe, because we need to populate ocelot->num_phys_ports
> early. The ocelot_init() function depends on it being set correctly.
> 
>  drivers/net/ethernet/mscc/ocelot_vsc7514.c | 209 +++++++++++----------
>  1 file changed, 110 insertions(+), 99 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> index a1cbb20a7757..ff4a01424953 100644
> --- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> +++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> @@ -896,11 +896,115 @@ static struct ptp_clock_info ocelot_ptp_clock_info = {
>  	.enable		= ocelot_ptp_enable,
>  };
>  
> +static int mscc_ocelot_init_ports(struct platform_device *pdev,
> +				  struct device_node *ports)
> +{
> +	struct ocelot *ocelot = platform_get_drvdata(pdev);
> +	struct device_node *portnp;
> +	int err;
> +
> +	ocelot->ports = devm_kcalloc(ocelot->dev, ocelot->num_phys_ports,
> +				     sizeof(struct ocelot_port *), GFP_KERNEL);
> +	if (!ocelot->ports)
> +		return -ENOMEM;
> +
> +	/* No NPI port */
> +	ocelot_configure_cpu(ocelot, -1, OCELOT_TAG_PREFIX_NONE,
> +			     OCELOT_TAG_PREFIX_NONE);
> +
> +	for_each_available_child_of_node(ports, portnp) {
> +		struct ocelot_port_private *priv;
> +		struct ocelot_port *ocelot_port;
> +		struct device_node *phy_node;
> +		phy_interface_t phy_mode;
> +		struct phy_device *phy;
> +		struct regmap *target;
> +		struct resource *res;
> +		struct phy *serdes;
> +		char res_name[8];
> +		u32 port;
> +
> +		if (of_property_read_u32(portnp, "reg", &port))
> +			continue;
> +
> +		snprintf(res_name, sizeof(res_name), "port%d", port);
> +
> +		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> +						   res_name);
> +		target = ocelot_regmap_init(ocelot, res);
> +		if (IS_ERR(target))
> +			continue;
> +
> +		phy_node = of_parse_phandle(portnp, "phy-handle", 0);
> +		if (!phy_node)
> +			continue;
> +
> +		phy = of_phy_find_device(phy_node);
> +		of_node_put(phy_node);
> +		if (!phy)
> +			continue;
> +
> +		err = ocelot_probe_port(ocelot, port, target, phy);
> +		if (err) {
> +			of_node_put(portnp);
> +			return err;
> +		}
> +
> +		ocelot_port = ocelot->ports[port];
> +		priv = container_of(ocelot_port, struct ocelot_port_private,
> +				    port);
> +
> +		of_get_phy_mode(portnp, &phy_mode);
> +
> +		ocelot_port->phy_mode = phy_mode;
> +
> +		switch (ocelot_port->phy_mode) {
> +		case PHY_INTERFACE_MODE_NA:
> +			continue;
> +		case PHY_INTERFACE_MODE_SGMII:
> +			break;
> +		case PHY_INTERFACE_MODE_QSGMII:
> +			/* Ensure clock signals and speed is set on all
> +			 * QSGMII links
> +			 */
> +			ocelot_port_writel(ocelot_port,
> +					   DEV_CLOCK_CFG_LINK_SPEED
> +					   (OCELOT_SPEED_1000),
> +					   DEV_CLOCK_CFG);
> +			break;
> +		default:
> +			dev_err(ocelot->dev,
> +				"invalid phy mode for port%d, (Q)SGMII only\n",
> +				port);
> +			of_node_put(portnp);
> +			return -EINVAL;
> +		}
> +
> +		serdes = devm_of_phy_get(ocelot->dev, portnp, NULL);
> +		if (IS_ERR(serdes)) {
> +			err = PTR_ERR(serdes);
> +			if (err == -EPROBE_DEFER)
> +				dev_dbg(ocelot->dev, "deferring probe\n");
> +			else
> +				dev_err(ocelot->dev,
> +					"missing SerDes phys for port%d\n",
> +					port);
> +
> +			of_node_put(portnp);
> +			return err;
> +		}
> +
> +		priv->serdes = serdes;
> +	}
> +
> +	return 0;
> +}
> +
>  static int mscc_ocelot_probe(struct platform_device *pdev)
>  {
>  	struct device_node *np = pdev->dev.of_node;
> -	struct device_node *ports, *portnp;
>  	int err, irq_xtr, irq_ptp_rdy;
> +	struct device_node *ports;
>  	struct ocelot *ocelot;
>  	struct regmap *hsio;
>  	unsigned int i;
> @@ -985,19 +1089,12 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
>  
>  	ports = of_get_child_by_name(np, "ethernet-ports");
>  	if (!ports) {
> -		dev_err(&pdev->dev, "no ethernet-ports child node found\n");
> +		dev_err(ocelot->dev, "no ethernet-ports child node found\n");
>  		return -ENODEV;
>  	}
>  
>  	ocelot->num_phys_ports = of_get_child_count(ports);
>  
> -	ocelot->ports = devm_kcalloc(&pdev->dev, ocelot->num_phys_ports,
> -				     sizeof(struct ocelot_port *), GFP_KERNEL);
> -	if (!ocelot->ports) {
> -		err = -ENOMEM;
> -		goto out_put_ports;
> -	}
> -
>  	ocelot->vcap_is2_keys = vsc7514_vcap_is2_keys;
>  	ocelot->vcap_is2_actions = vsc7514_vcap_is2_actions;
>  	ocelot->vcap = vsc7514_vcap_props;
> @@ -1006,6 +1103,10 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
>  	if (err)
>  		goto out_put_ports;
>  
> +	err = mscc_ocelot_init_ports(pdev, ports);
> +	if (err)
> +		goto out_put_ports;
> +
>  	if (ocelot->ptp) {
>  		err = ocelot_init_timestamp(ocelot, &ocelot_ptp_clock_info);
>  		if (err) {
> @@ -1015,96 +1116,6 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
>  		}
>  	}
>  
> -	/* No NPI port */
> -	ocelot_configure_cpu(ocelot, -1, OCELOT_TAG_PREFIX_NONE,
> -			     OCELOT_TAG_PREFIX_NONE);
> -
> -	for_each_available_child_of_node(ports, portnp) {
> -		struct ocelot_port_private *priv;
> -		struct ocelot_port *ocelot_port;
> -		struct device_node *phy_node;
> -		phy_interface_t phy_mode;
> -		struct phy_device *phy;
> -		struct regmap *target;
> -		struct resource *res;
> -		struct phy *serdes;
> -		char res_name[8];
> -		u32 port;
> -
> -		if (of_property_read_u32(portnp, "reg", &port))
> -			continue;
> -
> -		snprintf(res_name, sizeof(res_name), "port%d", port);
> -
> -		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> -						   res_name);
> -		target = ocelot_regmap_init(ocelot, res);
> -		if (IS_ERR(target))
> -			continue;
> -
> -		phy_node = of_parse_phandle(portnp, "phy-handle", 0);
> -		if (!phy_node)
> -			continue;
> -
> -		phy = of_phy_find_device(phy_node);
> -		of_node_put(phy_node);
> -		if (!phy)
> -			continue;
> -
> -		err = ocelot_probe_port(ocelot, port, target, phy);
> -		if (err) {
> -			of_node_put(portnp);
> -			goto out_put_ports;
> -		}
> -
> -		ocelot_port = ocelot->ports[port];
> -		priv = container_of(ocelot_port, struct ocelot_port_private,
> -				    port);
> -
> -		of_get_phy_mode(portnp, &phy_mode);
> -
> -		ocelot_port->phy_mode = phy_mode;
> -
> -		switch (ocelot_port->phy_mode) {
> -		case PHY_INTERFACE_MODE_NA:
> -			continue;
> -		case PHY_INTERFACE_MODE_SGMII:
> -			break;
> -		case PHY_INTERFACE_MODE_QSGMII:
> -			/* Ensure clock signals and speed is set on all
> -			 * QSGMII links
> -			 */
> -			ocelot_port_writel(ocelot_port,
> -					   DEV_CLOCK_CFG_LINK_SPEED
> -					   (OCELOT_SPEED_1000),
> -					   DEV_CLOCK_CFG);
> -			break;
> -		default:
> -			dev_err(ocelot->dev,
> -				"invalid phy mode for port%d, (Q)SGMII only\n",
> -				port);
> -			of_node_put(portnp);
> -			err = -EINVAL;
> -			goto out_put_ports;
> -		}
> -
> -		serdes = devm_of_phy_get(ocelot->dev, portnp, NULL);
> -		if (IS_ERR(serdes)) {
> -			err = PTR_ERR(serdes);
> -			if (err == -EPROBE_DEFER)
> -				dev_dbg(ocelot->dev, "deferring probe\n");
> -			else
> -				dev_err(ocelot->dev,
> -					"missing SerDes phys for port%d\n",
> -					port);
> -
> -			of_node_put(portnp);
> -			goto out_put_ports;
> -		}
> -
> -		priv->serdes = serdes;
> -	}
> -
>  	register_netdevice_notifier(&ocelot_netdevice_nb);
>  	register_switchdev_notifier(&ocelot_switchdev_nb);
>  	register_switchdev_blocking_notifier(&ocelot_switchdev_blocking_nb);
> -- 
> 2.25.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
