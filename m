Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176552701C6
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 18:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgIRQO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 12:14:26 -0400
Received: from mslow2.mail.gandi.net ([217.70.178.242]:40946 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbgIRQOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 12:14:18 -0400
Received: from relay5-d.mail.gandi.net (unknown [217.70.183.197])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 785303A53BB
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 15:26:24 +0000 (UTC)
X-Originating-IP: 90.65.88.165
Received: from localhost (lfbn-lyo-1-1908-165.w90-65.abo.wanadoo.fr [90.65.88.165])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id A5FB91C0008;
        Fri, 18 Sep 2020 15:26:02 +0000 (UTC)
Date:   Fri, 18 Sep 2020 17:26:02 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, UNGLinuxDriver@microchip.com,
        claudiu.manoil@nxp.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org
Subject: Re: [PATCH v2 net 1/8] net: mscc: ocelot: fix race condition with TX
 timestamping
Message-ID: <20200918152602.GW9675@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918010730.2911234-9-olteanv@gmail.com>
 <20200918010730.2911234-8-olteanv@gmail.com>
 <20200918010730.2911234-7-olteanv@gmail.com>
 <20200918010730.2911234-6-olteanv@gmail.com>
 <20200918010730.2911234-5-olteanv@gmail.com>
 <20200918010730.2911234-4-olteanv@gmail.com>
 <20200918010730.2911234-3-olteanv@gmail.com>
 <20200918010730.2911234-2-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/09/2020 04:07:23+0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The TX-timestampable skb is added late to the ocelot_port->tx_skbs. It
> is in a race with the TX timestamp IRQ, which checks that queue trying
> to match the timestamp with the skb by the ts_id. The skb should be
> added to the queue before the IRQ can fire.
> 
> Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Tested-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
> Changes in v2:
> None.
> 
>  drivers/net/ethernet/mscc/ocelot_net.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
> index 0668d23cdbfa..cacabc23215a 100644
> --- a/drivers/net/ethernet/mscc/ocelot_net.c
> +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> @@ -330,6 +330,7 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
>  	u8 grp = 0; /* Send everything on CPU group 0 */
>  	unsigned int i, count, last;
>  	int port = priv->chip_port;
> +	bool do_tstamp;
>  
>  	val = ocelot_read(ocelot, QS_INJ_STATUS);
>  	if (!(val & QS_INJ_STATUS_FIFO_RDY(BIT(grp))) ||
> @@ -344,10 +345,14 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
>  	info.vid = skb_vlan_tag_get(skb);
>  
>  	/* Check if timestamping is needed */
> +	do_tstamp = (ocelot_port_add_txtstamp_skb(ocelot_port, skb) == 0);
> +
>  	if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP) {
>  		info.rew_op = ocelot_port->ptp_cmd;
> -		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP)
> +		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
>  			info.rew_op |= (ocelot_port->ts_id  % 4) << 3;
> +			ocelot_port->ts_id++;
> +		}
>  	}
>  
>  	ocelot_gen_ifh(ifh, &info);
> @@ -380,12 +385,9 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
>  	dev->stats.tx_packets++;
>  	dev->stats.tx_bytes += skb->len;
>  
> -	if (!ocelot_port_add_txtstamp_skb(ocelot_port, skb)) {
> -		ocelot_port->ts_id++;
> -		return NETDEV_TX_OK;
> -	}
> +	if (!do_tstamp)
> +		dev_kfree_skb_any(skb);
>  
> -	dev_kfree_skb_any(skb);
>  	return NETDEV_TX_OK;
>  }
>  
> -- 
> 2.25.1
> 

On 18/09/2020 04:07:24+0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The ocelot_port->ts_id is used to:
> (a) populate skb->cb[0] for matching the TX timestamp in the PTP IRQ
>     with an skb.
> (b) populate the REW_OP from the injection header of the ongoing skb.
> Only then is ocelot_port->ts_id incremented.
> 
> This is a problem because, at least theoretically, another timestampable
> skb might use the same ocelot_port->ts_id before that is incremented.
> Normally all transmit calls are serialized by the netdev transmit
> spinlock, but in this case, ocelot_port_add_txtstamp_skb() is also
> called by DSA, which has started declaring the NETIF_F_LLTX feature
> since commit 2b86cb829976 ("net: dsa: declare lockless TX feature for
> slave ports").  So the logic of using and incrementing the timestamp id
> should be atomic per port.
> 
> The solution is to use the global ocelot_port->ts_id only while
> protected by the associated ocelot_port->ts_id_lock. That's where we
> populate skb->cb[0]. Note that for ocelot, ocelot_port_add_txtstamp_skb
> is called for the actual skb, but for felix, it is called for the skb's
> clone. That is something which will also be changed in the future.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
> Changes in v2:
> Added an extra explanation about NETIF_F_LLTX in commit message.
> 
>  drivers/net/ethernet/mscc/ocelot.c     |  8 +++++++-
>  drivers/net/ethernet/mscc/ocelot_net.c |  6 ++----
>  include/soc/mscc/ocelot.h              |  1 +
>  net/dsa/tag_ocelot.c                   | 11 +++++++----
>  4 files changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index 5abb7d2b0a9e..83eb7c325061 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -421,10 +421,15 @@ int ocelot_port_add_txtstamp_skb(struct ocelot_port *ocelot_port,
>  
>  	if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP &&
>  	    ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
> +		spin_lock(&ocelot_port->ts_id_lock);
> +
>  		shinfo->tx_flags |= SKBTX_IN_PROGRESS;
>  		/* Store timestamp ID in cb[0] of sk_buff */
> -		skb->cb[0] = ocelot_port->ts_id % 4;
> +		skb->cb[0] = ocelot_port->ts_id;
> +		ocelot_port->ts_id = (ocelot_port->ts_id + 1) % 4;
>  		skb_queue_tail(&ocelot_port->tx_skbs, skb);
> +
> +		spin_unlock(&ocelot_port->ts_id_lock);
>  		return 0;
>  	}
>  	return -ENODATA;
> @@ -1300,6 +1305,7 @@ void ocelot_init_port(struct ocelot *ocelot, int port)
>  	struct ocelot_port *ocelot_port = ocelot->ports[port];
>  
>  	skb_queue_head_init(&ocelot_port->tx_skbs);
> +	spin_lock_init(&ocelot_port->ts_id_lock);
>  
>  	/* Basic L2 initialization */
>  
> diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
> index cacabc23215a..8490e42e9e2d 100644
> --- a/drivers/net/ethernet/mscc/ocelot_net.c
> +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> @@ -349,10 +349,8 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
>  
>  	if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP) {
>  		info.rew_op = ocelot_port->ptp_cmd;
> -		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
> -			info.rew_op |= (ocelot_port->ts_id  % 4) << 3;
> -			ocelot_port->ts_id++;
> -		}
> +		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP)
> +			info.rew_op |= skb->cb[0] << 3;
>  	}
>  
>  	ocelot_gen_ifh(ifh, &info);
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index da369b12005f..4521dd602ddc 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -566,6 +566,7 @@ struct ocelot_port {
>  	u8				ptp_cmd;
>  	struct sk_buff_head		tx_skbs;
>  	u8				ts_id;
> +	spinlock_t			ts_id_lock;
>  
>  	phy_interface_t			phy_mode;
>  
> diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
> index 42f327c06dca..b4fc05cafaa6 100644
> --- a/net/dsa/tag_ocelot.c
> +++ b/net/dsa/tag_ocelot.c
> @@ -160,11 +160,14 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
>  	packing(injection, &qos_class, 19,  17, OCELOT_TAG_LEN, PACK, 0);
>  
>  	if (ocelot->ptp && (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
> +		struct sk_buff *clone = DSA_SKB_CB(skb)->clone;
> +
>  		rew_op = ocelot_port->ptp_cmd;
> -		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
> -			rew_op |= (ocelot_port->ts_id  % 4) << 3;
> -			ocelot_port->ts_id++;
> -		}
> +		/* Retrieve timestamp ID populated inside skb->cb[0] of the
> +		 * clone by ocelot_port_add_txtstamp_skb
> +		 */
> +		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP)
> +			rew_op |= clone->cb[0] << 3;
>  
>  		packing(injection, &rew_op, 125, 117, OCELOT_TAG_LEN, PACK, 0);
>  	}
> -- 
> 2.25.1
> 

On 18/09/2020 04:07:25+0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The VSC9953 Seville switch has 2 megabits of buffer split into 4360
> words of 60 bytes each.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
> Changes in v2:
> None.
> 
>  drivers/net/dsa/ocelot/seville_vsc9953.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
> index 2d6a5f5758f8..83a1ab9393e9 100644
> --- a/drivers/net/dsa/ocelot/seville_vsc9953.c
> +++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
> @@ -1018,7 +1018,7 @@ static const struct felix_info seville_info_vsc9953 = {
>  	.vcap_is2_keys		= vsc9953_vcap_is2_keys,
>  	.vcap_is2_actions	= vsc9953_vcap_is2_actions,
>  	.vcap			= vsc9953_vcap_props,
> -	.shared_queue_sz	= 128 * 1024,
> +	.shared_queue_sz	= 2048 * 1024,
>  	.num_mact_rows		= 2048,
>  	.num_ports		= 10,
>  	.mdio_bus_alloc		= vsc9953_mdio_bus_alloc,
> -- 
> 2.25.1
> 

On 18/09/2020 04:07:26+0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Do not proceed probing if we couldn't allocate memory for the ports
> array, just error out.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
> Changes in v2:
> Stopped leaking the 'ports' OF node.
> 
>  drivers/net/ethernet/mscc/ocelot_vsc7514.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> index 65408bc994c4..904ea299a5e8 100644
> --- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> +++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> @@ -993,6 +993,10 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
>  
>  	ocelot->ports = devm_kcalloc(&pdev->dev, ocelot->num_phys_ports,
>  				     sizeof(struct ocelot_port *), GFP_KERNEL);
> +	if (!ocelot->ports) {
> +		err = -ENOMEM;
> +		goto out_put_ports;
> +	}
>  
>  	ocelot->vcap_is2_keys = vsc7514_vcap_is2_keys;
>  	ocelot->vcap_is2_actions = vsc7514_vcap_is2_actions;
> -- 
> 2.25.1
> 

On 18/09/2020 04:07:27+0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> ocelot_init() allocates memory, resets the switch and polls for a status
> register, things which can fail. Stop probing the driver in that case,
> and propagate the error result.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
> Changes in v2:
> Stopped leaking the 'ports' OF node in the VSC7514 driver.
> 
>  drivers/net/dsa/ocelot/felix.c             | 5 ++++-
>  drivers/net/ethernet/mscc/ocelot_vsc7514.c | 5 ++++-
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> index a1e1d3824110..f7b43f8d56ed 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -571,7 +571,10 @@ static int felix_setup(struct dsa_switch *ds)
>  	if (err)
>  		return err;
>  
> -	ocelot_init(ocelot);
> +	err = ocelot_init(ocelot);
> +	if (err)
> +		return err;
> +
>  	if (ocelot->ptp) {
>  		err = ocelot_init_timestamp(ocelot, &ocelot_ptp_clock_info);
>  		if (err) {
> diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> index 904ea299a5e8..a1cbb20a7757 100644
> --- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> +++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> @@ -1002,7 +1002,10 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
>  	ocelot->vcap_is2_actions = vsc7514_vcap_is2_actions;
>  	ocelot->vcap = vsc7514_vcap_props;
>  
> -	ocelot_init(ocelot);
> +	err = ocelot_init(ocelot);
> +	if (err)
> +		goto out_put_ports;
> +
>  	if (ocelot->ptp) {
>  		err = ocelot_init_timestamp(ocelot, &ocelot_ptp_clock_info);
>  		if (err) {
> -- 
> 2.25.1
> 

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

On 18/09/2020 04:07:29+0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This driver was not unregistering its network interfaces on unbind.
> Now it is.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
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
