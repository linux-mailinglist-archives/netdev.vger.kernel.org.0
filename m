Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA98951DDCB
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 18:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443883AbiEFQsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 12:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357431AbiEFQsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 12:48:02 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229806D4E8;
        Fri,  6 May 2022 09:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=n30vsYbFzM1NpkJU4bmBEdg/LJQK//tp4Ub+PFiQApA=; b=X0kccbfapMEhKIivM34CpF25bU
        nFZJzFgRY1WCSoPwKTBfb1Flea3aiT9yTkZsqBVjVDpfXq44qiwlFc1LQ+ZxD90eTQWsBMTbUxhR8
        u/DoOX5jqzZ0kliPlloz6GpnD8qHwBlJaWBbmTrpcOtSpDGh6OfgdzL9re8PCGkBCJKg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nn13r-001Y4A-Fi; Fri, 06 May 2022 18:44:11 +0200
Date:   Fri, 6 May 2022 18:44:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Puranjay Mohan <p-mohan@ti.com>
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org, nm@ti.com,
        ssantosh@kernel.org, s-anna@ti.com,
        linux-arm-kernel@lists.infradead.org, rogerq@kernel.org,
        grygorii.strashko@ti.com, vigneshr@ti.com, kishon@ti.com,
        robh+dt@kernel.org, afd@ti.com
Subject: Re: [PATCH 2/2] net: ti: icssg-prueth: Add ICSSG ethernet driver
Message-ID: <YnVQW7xpSWEE2/HP@lunn.ch>
References: <20220506052433.28087-1-p-mohan@ti.com>
 <20220506052433.28087-3-p-mohan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506052433.28087-3-p-mohan@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +void icssg_config_ipg(struct prueth_emac *emac)
> +{
> +	struct prueth *prueth = emac->prueth;
> +	int slice = prueth_emac_slice(emac);
> +
> +	switch (emac->speed) {
> +	case SPEED_1000:
> +		icssg_mii_update_ipg(prueth->mii_rt, slice, MII_RT_TX_IPG_1G);
> +		break;
> +	case SPEED_100:
> +		icssg_mii_update_ipg(prueth->mii_rt, slice, MII_RT_TX_IPG_100M);
> +		break;
> +	default:
> +		/* Other links speeds not supported */
> +		pr_err("Unsupported link speed\n");

dev_err() or netdev_err(). You then get an idea which device somebody
is trying to configure into an unsupported mode.

checkpatch probably also warned about that?

> +static void icssg_init_emac_mode(struct prueth *prueth)
> +{
> +	u8 mac[ETH_ALEN] = { 0 };
> +
> +	if (prueth->emacs_initialized)
> +		return;
> +
> +	regmap_update_bits(prueth->miig_rt, FDB_GEN_CFG1, SMEM_VLAN_OFFSET_MASK, 0);
> +	regmap_write(prueth->miig_rt, FDB_GEN_CFG2, 0);
> +	/* Clear host MAC address */
> +	icssg_class_set_host_mac_addr(prueth->miig_rt, mac);

Seems an odd thing to do, set it to 00:00:00:00:00:00. You probably
want to add a comment why you do this odd thing.

> +int emac_set_port_state(struct prueth_emac *emac,
> +			enum icssg_port_state_cmd cmd)
> +{
> +	struct icssg_r30_cmd *p;
> +	int ret = -ETIMEDOUT;
> +	int timeout = 10;
> +	int i;
> +
> +	p = emac->dram.va + MGR_R30_CMD_OFFSET;
> +
> +	if (cmd >= ICSSG_EMAC_PORT_MAX_COMMANDS) {
> +		netdev_err(emac->ndev, "invalid port command\n");
> +		return -EINVAL;
> +	}
> +
> +	/* only one command at a time allowed to firmware */
> +	mutex_lock(&emac->cmd_lock);
> +
> +	for (i = 0; i < 4; i++)
> +		writel(emac_r32_bitmask[cmd].cmd[i], &p->cmd[i]);
> +
> +	/* wait for done */
> +	while (timeout) {
> +		if (emac_r30_is_done(emac)) {
> +			ret = 0;
> +			break;
> +		}
> +
> +		usleep_range(1000, 2000);
> +		timeout--;
> +	}

linux/iopoll.h

> +void icssg_config_set_speed(struct prueth_emac *emac)
> +{
> +	u8 fw_speed;
> +
> +	switch (emac->speed) {
> +	case SPEED_1000:
> +		fw_speed = FW_LINK_SPEED_1G;
> +		break;
> +	case SPEED_100:
> +		fw_speed = FW_LINK_SPEED_100M;
> +		break;
> +	default:
> +		/* Other links speeds not supported */
> +		pr_err("Unsupported link speed\n");

dev_err() or netdev_err().


> +static int emac_get_link_ksettings(struct net_device *ndev,
> +				   struct ethtool_link_ksettings *ecmd)
> +{
> +	struct prueth_emac *emac = netdev_priv(ndev);
> +
> +	if (!emac->phydev)
> +		return -EOPNOTSUPP;
> +
> +	phy_ethtool_ksettings_get(emac->phydev, ecmd);
> +	return 0;
> +}

phy_ethtool_get_link_ksettings().

You should keep phydev in ndev, not your priv structure.

> +
> +static int emac_set_link_ksettings(struct net_device *ndev,
> +				   const struct ethtool_link_ksettings *ecmd)
> +{
> +	struct prueth_emac *emac = netdev_priv(ndev);
> +
> +	if (!emac->phydev)
> +		return -EOPNOTSUPP;
> +
> +	return phy_ethtool_ksettings_set(emac->phydev, ecmd);

phy_ethtool_set_link_ksettings()

> +static int emac_nway_reset(struct net_device *ndev)
> +{
> +	struct prueth_emac *emac = netdev_priv(ndev);
> +
> +	if (!emac->phydev)
> +		return -EOPNOTSUPP;
> +
> +	return genphy_restart_aneg(emac->phydev);

phy_ethtool_nway_reset()

> +static void emac_get_ethtool_stats(struct net_device *ndev,
> +				   struct ethtool_stats *stats, u64 *data)
> +{
> +	struct prueth_emac *emac = netdev_priv(ndev);
> +	struct prueth *prueth = emac->prueth;
> +	int i;
> +	int slice = prueth_emac_slice(emac);
> +	u32 base = stats_base[slice];
> +	u32 val;

Reverse Christmas tree. Move i to the end. There are other places in
the driver you need to fix up as well.

> +static int debug_level = -1;
> +module_param(debug_level, int, 0644);
> +MODULE_PARM_DESC(debug_level, "PRUETH debug level (NETIF_MSG bits)");

Module parameters are not liked any more. Yes, lots of drivers have
this one, but you have the ethtool setting, so you should not need
this.

> +/* called back by PHY layer if there is change in link state of hw port*/
> +static void emac_adjust_link(struct net_device *ndev)
> +{
> +	struct prueth_emac *emac = netdev_priv(ndev);
> +	struct phy_device *phydev = emac->phydev;
> +	struct prueth *prueth = emac->prueth;
> +	bool new_state = false;
> +	unsigned long flags;
> +
> +	if (phydev->link) {
> +		/* check the mode of operation - full/half duplex */
> +		if (phydev->duplex != emac->duplex) {
> +			new_state = true;
> +			emac->duplex = phydev->duplex;
> +		}
> +		if (phydev->speed != emac->speed) {
> +			new_state = true;
> +			emac->speed = phydev->speed;
> +		}
> +		if (!emac->link) {
> +			new_state = true;
> +			emac->link = 1;
> +		}
> +	} else if (emac->link) {
> +		new_state = true;
> +		emac->link = 0;
> +		/* defaults for no link */
> +
> +		/* f/w should support 100 & 1000 */
> +		emac->speed = SPEED_1000;
> +
> +		/* half duplex may not supported by f/w */
> +		emac->duplex = DUPLEX_FULL;

Why set speed and duplex when you have just lost the link? They are
meaningless until the link comes back.

> +	}
> +
> +	if (new_state) {
> +		phy_print_status(phydev);
> +
> +		/* update RGMII and MII configuration based on PHY negotiated
> +		 * values
> +		 */
> +		if (emac->link) {
> +			/* Set the RGMII cfg for gig en and full duplex */
> +			icssg_update_rgmii_cfg(prueth->miig_rt, emac);
> +
> +			/* update the Tx IPG based on 100M/1G speed */
> +			spin_lock_irqsave(&emac->lock, flags);
> +			icssg_config_ipg(emac);
> +			spin_unlock_irqrestore(&emac->lock, flags);
> +			icssg_config_set_speed(emac);
> +			emac_set_port_state(emac, ICSSG_EMAC_PORT_FORWARD);
> +
> +		} else {
> +			emac_set_port_state(emac, ICSSG_EMAC_PORT_DISABLE);
> +		}
> +	}
> +
> +	if (emac->link) {
> +		/* link ON */
> +		netif_carrier_on(ndev);

phylib will do this for you.

> +		/* reactivate the transmit queue */
> +		netif_tx_wake_all_queues(ndev);

Not something you see other drivers do. Why is it here?

> +	} else {
> +		/* link OFF */
> +		netif_carrier_off(ndev);
> +		netif_tx_stop_all_queues(ndev);

Same as above, for both.

> +static int emac_ndo_open(struct net_device *ndev)
> +{
> +	struct prueth_emac *emac = netdev_priv(ndev);
> +	int ret, i, num_data_chn = emac->tx_ch_num;
> +	struct prueth *prueth = emac->prueth;
> +	int slice = prueth_emac_slice(emac);
> +	struct device *dev = prueth->dev;
> +	int max_rx_flows;
> +	int rx_flow;
> +
> +	/* clear SMEM and MSMC settings for all slices */
> +	if (!prueth->emacs_initialized) {
> +		memset_io(prueth->msmcram.va, 0, prueth->msmcram.size);
> +		memset_io(prueth->shram.va, 0, ICSSG_CONFIG_OFFSET_SLICE1 * PRUETH_NUM_MACS);
> +	}
> +
> +	/* set h/w MAC as user might have re-configured */
> +	ether_addr_copy(emac->mac_addr, ndev->dev_addr);
> +
> +	icssg_class_set_mac_addr(prueth->miig_rt, slice, emac->mac_addr);
> +	icssg_ft1_set_mac_addr(prueth->miig_rt, slice, emac->mac_addr);
> +
> +	icssg_class_default(prueth->miig_rt, slice, 0);
> +
> +	netif_carrier_off(ndev);

It should default to off. phylib will turn it on for you when you get
link.

> +static int emac_ndo_ioctl(struct net_device *ndev, struct ifreq *ifr, int cmd)
> +{
> +	struct prueth_emac *emac = netdev_priv(ndev);
> +
> +	if (!emac->phydev)
> +		return -EOPNOTSUPP;
> +
> +	return phy_mii_ioctl(emac->phydev, ifr, cmd);
> +}

phy_do_ioctl()

> +extern const struct ethtool_ops icssg_ethtool_ops;

Should really by in a header file.

> +static int prueth_probe(struct platform_device *pdev)
> +{
> +	struct prueth *prueth;
> +	struct device *dev = &pdev->dev;
> +	struct device_node *np = dev->of_node;
> +	struct device_node *eth_ports_node;
> +	struct device_node *eth_node;
> +	struct device_node *eth0_node, *eth1_node;
> +	const struct of_device_id *match;
> +	struct pruss *pruss;
> +	int i, ret;
> +	u32 msmc_ram_size;
> +	struct genpool_data_align gp_data = {
> +		.align = SZ_64K,
> +	};
> +
> +	match = of_match_device(prueth_dt_match, dev);
> +	if (!match)
> +		return -ENODEV;
> +
> +	prueth = devm_kzalloc(dev, sizeof(*prueth), GFP_KERNEL);
> +	if (!prueth)
> +		return -ENOMEM;
> +
> +	dev_set_drvdata(dev, prueth);
> +	prueth->pdev = pdev;
> +	prueth->pdata = *(const struct prueth_pdata *)match->data;
> +
> +	prueth->dev = dev;
> +	eth_ports_node = of_get_child_by_name(np, "ethernet-ports");
> +	if (!eth_ports_node)
> +		return -ENOENT;
> +
> +	for_each_child_of_node(eth_ports_node, eth_node) {
> +		u32 reg;
> +
> +		if (strcmp(eth_node->name, "port"))
> +			continue;
> +		ret = of_property_read_u32(eth_node, "reg", &reg);
> +		if (ret < 0) {
> +			dev_err(dev, "%pOF error reading port_id %d\n",
> +				eth_node, ret);
> +		}
> +
> +		if (reg == 0)
> +			eth0_node = eth_node;
> +		else if (reg == 1)
> +			eth1_node = eth_node;

and if reg == 42?

Or reg 0 appears twice?

   Andrew
