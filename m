Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D3953DCF7
	for <lists+netdev@lfdr.de>; Sun,  5 Jun 2022 18:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351212AbiFEQYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 12:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238762AbiFEQYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 12:24:50 -0400
Received: from smtp.smtpout.orange.fr (smtp05.smtpout.orange.fr [80.12.242.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE62049F13
        for <netdev@vger.kernel.org>; Sun,  5 Jun 2022 09:24:48 -0700 (PDT)
Received: from [192.168.1.18] ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id xt3OnV5YAE80Kxt3OnoLAV; Sun, 05 Jun 2022 18:24:45 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 05 Jun 2022 18:24:45 +0200
X-ME-IP: 90.11.190.129
Message-ID: <3874cac9-cf3c-aa31-ecba-e2ae33935286@wanadoo.fr>
Date:   Sun, 5 Jun 2022 18:24:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2 2/2] net: ti: icssg-prueth: Add ICSSG ethernet driver
Content-Language: fr
To:     p-mohan@ti.com
Cc:     afd@ti.com, andrew@lunn.ch, davem@davemloft.net,
        devicetree@vger.kernel.org, edumazet@google.com,
        grygorii.strashko@ti.com, kishon@ti.com,
        krzysztof.kozlowski+dt@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, nm@ti.com, robh+dt@kernel.org,
        rogerq@kernel.org, s-anna@ti.com, ssantosh@kernel.org,
        vigneshr@ti.com
References: <20220531095108.21757-1-p-mohan@ti.com>
 <20220531095108.21757-3-p-mohan@ti.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20220531095108.21757-3-p-mohan@ti.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Just a few comments below, for what they worth.

Le 31/05/2022 à 11:51, Puranjay Mohan a écrit :
> From: Roger Quadros <rogerq-l0cyMroinI0@public.gmane.org>
> 
> This is the Ethernet driver for TI AM654 Silicon rev. 2
> with the ICSSG PRU Sub-system running dual-EMAC firmware.
> 

[...]

> +static int prueth_netdev_init(struct prueth *prueth,
> +			      struct device_node *eth_node)
> +{
> +	int ret, num_tx_chn = PRUETH_MAX_TX_QUEUES;
> +	struct prueth_emac *emac;
> +	struct net_device *ndev;
> +	enum prueth_port port;
> +	enum prueth_mac mac;
> +
> +	port = prueth_node_port(eth_node);
> +	if (port < 0)
> +		return -EINVAL;
> +
> +	mac = prueth_node_mac(eth_node);
> +	if (mac < 0)
> +		return -EINVAL;
> +
> +	ndev = alloc_etherdev_mq(sizeof(*emac), num_tx_chn);
> +	if (!ndev)
> +		return -ENOMEM;
> +
> +	emac = netdev_priv(ndev);
> +	prueth->emac[mac] = emac;
> +	emac->prueth = prueth;
> +	emac->ndev = ndev;
> +	emac->port_id = port;
> +	emac->cmd_wq = create_singlethread_workqueue("icssg_cmd_wq");
> +	if (!emac->cmd_wq) {
> +		ret = -ENOMEM;
> +		goto free_ndev;
> +	}
> +	INIT_WORK(&emac->rx_mode_work, emac_ndo_set_rx_mode_work);
> +
> +	ret = pruss_request_mem_region(prueth->pruss,
> +				       port == PRUETH_PORT_MII0 ?
> +				       PRUSS_MEM_DRAM0 : PRUSS_MEM_DRAM1,
> +				       &emac->dram);
> +	if (ret) {
> +		dev_err(prueth->dev, "unable to get DRAM: %d\n", ret);
> +		return -ENOMEM;

goto free_wq; ?

> +	}
> +
> +	emac->tx_ch_num = 1;
> +
> +	SET_NETDEV_DEV(ndev, prueth->dev);
> +	spin_lock_init(&emac->lock);
> +	mutex_init(&emac->cmd_lock);
> +
> +	emac->phy_node = of_parse_phandle(eth_node, "phy-handle", 0);
> +	if (!emac->phy_node && !of_phy_is_fixed_link(eth_node)) {
> +		dev_err(prueth->dev, "couldn't find phy-handle\n");
> +		ret = -ENODEV;
> +		goto free;
> +	} else if (of_phy_is_fixed_link(eth_node)) {
> +		ret = of_phy_register_fixed_link(eth_node);
> +		if (ret) {
> +			ret = dev_err_probe(prueth->dev, ret,
> +					    "failed to register fixed-link phy\n");
> +			goto free;
> +		}
> +
> +		emac->phy_node = eth_node;
> +	}
> +
> +	ret = of_get_phy_mode(eth_node, &emac->phy_if);
> +	if (ret) {
> +		dev_err(prueth->dev, "could not get phy-mode property\n");
> +		goto free;
> +	}
> +
> +	if (emac->phy_if != PHY_INTERFACE_MODE_MII &&
> +	    !phy_interface_mode_is_rgmii(emac->phy_if)) {
> +		dev_err(prueth->dev, "PHY mode unsupported %s\n", phy_modes(emac->phy_if));
> +		goto free;
> +	}
> +
> +	ret = prueth_config_rgmiidelay(prueth, eth_node, emac->phy_if);
> +	if (ret)
> +		goto free;
> +
> +	/* get mac address from DT and set private and netdev addr */
> +	ret = of_get_ethdev_address(eth_node, ndev);
> +	if (!is_valid_ether_addr(ndev->dev_addr)) {
> +		eth_hw_addr_random(ndev);
> +		dev_warn(prueth->dev, "port %d: using random MAC addr: %pM\n",
> +			 port, ndev->dev_addr);
> +	}
> +	ether_addr_copy(emac->mac_addr, ndev->dev_addr);
> +
> +	ndev->netdev_ops = &emac_netdev_ops;
> +	ndev->ethtool_ops = &icssg_ethtool_ops;
> +	ndev->hw_features = NETIF_F_SG;
> +	ndev->features = ndev->hw_features;
> +
> +	netif_napi_add(ndev, &emac->napi_rx,
> +		       emac_napi_rx_poll, NAPI_POLL_WEIGHT);
> +
> +	return 0;
> +
> +free:
> +	pruss_release_mem_region(prueth->pruss, &emac->dram);

free_wq:

> +	destroy_workqueue(emac->cmd_wq);
> +free_ndev:
> +	free_netdev(ndev);
> +	prueth->emac[mac] = NULL;
> +
> +	return ret;
> +}
> +
> +static void prueth_netdev_exit(struct prueth *prueth,
> +			       struct device_node *eth_node)
> +{
> +	struct prueth_emac *emac;
> +	enum prueth_mac mac;
> +
> +	mac = prueth_node_mac(eth_node);
> +	if (mac < 0)
> +		return;
> +
> +	emac = prueth->emac[mac];
> +	if (!emac)
> +		return;
> +
> +	if (of_phy_is_fixed_link(emac->phy_node))
> +		of_phy_deregister_fixed_link(emac->phy_node);
> +
> +	netif_napi_del(&emac->napi_rx);
> +
> +	pruss_release_mem_region(prueth->pruss, &emac->dram);
> +	destroy_workqueue(emac->cmd_wq);
> +	free_netdev(emac->ndev);
> +	prueth->emac[mac] = NULL;
> +}
> +
> +static int prueth_get_cores(struct prueth *prueth, int slice)
> +{
> +	enum pruss_pru_id pruss_id;
> +	struct device *dev = prueth->dev;
> +	struct device_node *np = dev->of_node;
> +	int idx = -1, ret;
> +
> +	switch (slice) {
> +	case ICSS_SLICE0:
> +		idx = 0;
> +		break;
> +	case ICSS_SLICE1:
> +		idx = 3;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	prueth->pru[slice] = pru_rproc_get(np, idx, &pruss_id);
> +	if (IS_ERR(prueth->pru[slice])) {
> +		ret = PTR_ERR(prueth->pru[slice]);
> +		prueth->pru[slice] = NULL;
> +		if (ret != -EPROBE_DEFER)
> +			dev_err(dev, "unable to get PRU%d: %d\n", slice, ret);

return dev_err_probe()?

> +		return ret;
> +	}
> +	prueth->pru_id[slice] = pruss_id;
> +
> +	idx++;
> +	prueth->rtu[slice] = pru_rproc_get(np, idx, NULL);
> +	if (IS_ERR(prueth->rtu[slice])) {
> +		ret = PTR_ERR(prueth->rtu[slice]);
> +		prueth->rtu[slice] = NULL;
> +		if (ret != -EPROBE_DEFER)
> +			dev_err(dev, "unable to get RTU%d: %d\n", slice, ret);

Same.

> +		return ret;
> +	}
> +
> +	idx++;
> +	prueth->txpru[slice] = pru_rproc_get(np, idx, NULL);
> +	if (IS_ERR(prueth->txpru[slice])) {
> +		ret = PTR_ERR(prueth->txpru[slice]);
> +		prueth->txpru[slice] = NULL;
> +		if (ret != -EPROBE_DEFER)
> +			dev_err(dev, "unable to get TX_PRU%d: %d\n",
> +				slice, ret);

Same.

> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static void prueth_put_cores(struct prueth *prueth, int slice)
> +{
> +	if (prueth->txpru[slice])
> +		pru_rproc_put(prueth->txpru[slice]);
> +
> +	if (prueth->rtu[slice])
> +		pru_rproc_put(prueth->rtu[slice]);
> +
> +	if (prueth->pru[slice])
> +		pru_rproc_put(prueth->pru[slice]);
> +}
> +
> +static const struct of_device_id prueth_dt_match[];
> +
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
> +		of_node_get(eth_node);
> +
> +		if (reg == 0)
> +			eth0_node = eth_node;
> +		else if (reg == 1)
> +			eth1_node = eth_node;
> +		else
> +			dev_err(dev, "port reg should be 0 or 1\n");
> +	}
> +
> +	of_node_put(eth_ports_node);
> +
> +	/* At least one node must be present and available else we fail */
> +	if (!eth0_node && !eth1_node) {
> +		dev_err(dev, "neither port0 nor port1 node available\n");
> +		return -ENODEV;
> +	}
> +
> +	if (eth0_node == eth1_node) {
> +		dev_err(dev, "port0 and port1 can't have same reg\n");
> +		of_node_put(eth0_node);
> +		return -ENODEV;
> +	}
> +
> +	prueth->eth_node[PRUETH_MAC0] = eth0_node;
> +	prueth->eth_node[PRUETH_MAC1] = eth1_node;
> +
> +	prueth->miig_rt = syscon_regmap_lookup_by_phandle(np, "ti,mii-g-rt");
> +	if (IS_ERR(prueth->miig_rt)) {
> +		dev_err(dev, "couldn't get ti,mii-g-rt syscon regmap\n");
> +		return -ENODEV;
> +	}
> +
> +	prueth->mii_rt = syscon_regmap_lookup_by_phandle(np, "ti,mii-rt");
> +	if (IS_ERR(prueth->mii_rt)) {
> +		dev_err(dev, "couldn't get ti,mii-rt syscon regmap\n");
> +		return -ENODEV;
> +	}
> +
> +	if (eth0_node) {
> +		ret = prueth_get_cores(prueth, ICSS_SLICE0);
> +		if (ret)
> +			goto put_cores;
> +	}
> +
> +	if (eth1_node) {
> +		ret = prueth_get_cores(prueth, ICSS_SLICE1);
> +		if (ret)
> +			goto put_cores;
> +	}
> +
> +	pruss = pruss_get(eth0_node ?
> +			  prueth->pru[ICSS_SLICE0] : prueth->pru[ICSS_SLICE1]);
> +	if (IS_ERR(pruss)) {
> +		ret = PTR_ERR(pruss);
> +		dev_err(dev, "unable to get pruss handle\n");
> +		goto put_cores;
> +	}
> +
> +	prueth->pruss = pruss;
> +
> +	ret = pruss_request_mem_region(pruss, PRUSS_MEM_SHRD_RAM2,
> +				       &prueth->shram);
> +	if (ret) {
> +		dev_err(dev, "unable to get PRUSS SHRD RAM2: %d\n", ret);
> +		goto put_mem;

Is it safe to call pruss_release_mem_region() if 
pruss_request_mem_region() has failed?

The other place where it is called it is not done the same way.

> +	}
> +
> +	prueth->sram_pool = of_gen_pool_get(np, "sram", 0);
> +	if (!prueth->sram_pool) {
> +		dev_err(dev, "unable to get SRAM pool\n");
> +		ret = -ENODEV;
> +
> +		goto put_mem;
> +	}
> +
> +	msmc_ram_size = MSMC_RAM_SIZE;
> +
> +	/* NOTE: FW bug needs buffer base to be 64KB aligned */
> +	prueth->msmcram.va =
> +		(void __iomem *)gen_pool_alloc_algo(prueth->sram_pool,
> +						    msmc_ram_size,
> +						    gen_pool_first_fit_align,
> +						    &gp_data);
> +
> +	if (!prueth->msmcram.va) {
> +		ret = -ENOMEM;
> +		dev_err(dev, "unable to allocate MSMC resource\n");
> +		goto put_mem;
> +	}
> +	prueth->msmcram.pa = gen_pool_virt_to_phys(prueth->sram_pool,
> +						   (unsigned long)prueth->msmcram.va);
> +	prueth->msmcram.size = msmc_ram_size;
> +	memset(prueth->msmcram.va, 0, msmc_ram_size);
> +	dev_dbg(dev, "sram: pa %llx va %p size %zx\n", prueth->msmcram.pa,
> +		prueth->msmcram.va, prueth->msmcram.size);
> +
> +	/* setup netdev interfaces */
> +	if (eth0_node) {
> +		ret = prueth_netdev_init(prueth, eth0_node);
> +		if (ret) {
> +			if (ret != -EPROBE_DEFER) {
> +				dev_err(dev, "netdev init %s failed: %d\n",
> +					eth0_node->name, ret);

dev_err_probe()?

> +			}
> +			goto netdev_exit;
> +		}
> +	}
> +
> +	if (eth1_node) {
> +		ret = prueth_netdev_init(prueth, eth1_node);
> +		if (ret) {
> +			if (ret != -EPROBE_DEFER) {
> +				dev_err(dev, "netdev init %s failed: %d\n",
> +					eth1_node->name, ret);

dev_err_probe()?

> +			}
> +			goto netdev_exit;
> +		}
> +	}
> +
> +	/* register the network devices */
> +	if (eth0_node) {
> +		ret = register_netdev(prueth->emac[PRUETH_MAC0]->ndev);
> +		if (ret) {
> +			dev_err(dev, "can't register netdev for port MII0");
> +			goto netdev_exit;
> +		}
> +
> +		prueth->registered_netdevs[PRUETH_MAC0] = prueth->emac[PRUETH_MAC0]->ndev;
> +
> +		emac_phy_connect(prueth->emac[PRUETH_MAC0]);
> +		phy_attached_info(prueth->emac[PRUETH_MAC0]->ndev->phydev);
> +	}
> +
> +	if (eth1_node) {
> +		ret = register_netdev(prueth->emac[PRUETH_MAC1]->ndev);
> +		if (ret) {
> +			dev_err(dev, "can't register netdev for port MII1");
> +			goto netdev_unregister;
> +		}
> +
> +		prueth->registered_netdevs[PRUETH_MAC1] = prueth->emac[PRUETH_MAC1]->ndev;
> +		emac_phy_connect(prueth->emac[PRUETH_MAC1]);
> +		phy_attached_info(prueth->emac[PRUETH_MAC1]->ndev->phydev);
> +	}
> +
> +	dev_info(dev, "TI PRU ethernet driver initialized: %s EMAC mode\n",
> +		 (!eth0_node || !eth1_node) ? "single" : "dual");
> +
> +	if (eth1_node)
> +		of_node_put(eth1_node);
> +	if (eth0_node)
> +		of_node_put(eth0_node);
> +	return 0;
> +
> +netdev_unregister:
> +	for (i = 0; i < PRUETH_NUM_MACS; i++) {
> +		if (!prueth->registered_netdevs[i])
> +			continue;
> +		if (prueth->emac[i]->ndev->phydev) {
> +			phy_disconnect(prueth->emac[i]->ndev->phydev);
> +			prueth->emac[i]->ndev->phydev = NULL;
> +		}
> +		unregister_netdev(prueth->registered_netdevs[i]);
> +	}
> +
> +netdev_exit:
> +	for (i = 0; i < PRUETH_NUM_MACS; i++) {
> +		struct device_node *eth_node;
> +
> +		eth_node = prueth->eth_node[i];
> +		if (!eth_node)
> +			continue;
> +
> +		prueth_netdev_exit(prueth, eth_node);
> +	}
> +
> +gen_pool_free(prueth->sram_pool,

1 tab missing.

> +	      (unsigned long)prueth->msmcram.va, msmc_ram_size);
> +
> +put_mem:
> +	pruss_release_mem_region(prueth->pruss, &prueth->shram);
> +	pruss_put(prueth->pruss);
> +
> +put_cores:
> +	if (eth1_node) {
> +		prueth_put_cores(prueth, ICSS_SLICE1);
> +		of_node_put(eth1_node);
> +	}
> +
> +	if (eth0_node) {
> +		prueth_put_cores(prueth, ICSS_SLICE0);
> +		of_node_put(eth0_node);
> +	}
> +
> +	return ret;
> +}

[...]
