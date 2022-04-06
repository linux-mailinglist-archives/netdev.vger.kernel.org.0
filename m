Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A0D4F6603
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 18:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238271AbiDFQut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 12:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238222AbiDFQun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 12:50:43 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A35E13DDE81;
        Wed,  6 Apr 2022 07:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sd/PsPgwHRoZV9qtjZqHegQHb46ZFmljHcKA2C4yic0=; b=Og6RBUjJQQc5oScHfhAvWEjg0b
        pdfDockNNddPaV+0JeuLI2RPwGOg0Vi3CbqJQlkRATjhF44uFvZni+n9cu0VH1cDEJS2IcniVc2kN
        axdEupiU4XxGP72AjbIVkBYafc869yRG+JakKPxlQrCgw92Tll56TLNzfmnMdhAgMrYE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nc6Pc-00ESl0-US; Wed, 06 Apr 2022 16:13:32 +0200
Date:   Wed, 6 Apr 2022 16:13:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Puranjay Mohan <p-mohan@ti.com>
Cc:     linux-kernel@vger.kernel.org, bjorn.andersson@linaro.org,
        mathieu.poirier@linaro.org, krzysztof.kozlowski+dt@linaro.org,
        linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org,
        nm@ti.com, ssantosh@kernel.org, s-anna@ti.com,
        linux-arm-kernel@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, vigneshr@ti.com,
        kishon@ti.com
Subject: Re: [RFC 13/13] net: ti: icssg-prueth: Add ICSSG ethernet driver
Message-ID: <Yk2gDGN8a2xss1UO@lunn.ch>
References: <20220406094358.7895-1-p-mohan@ti.com>
 <20220406094358.7895-14-p-mohan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406094358.7895-14-p-mohan@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int emac_set_link_ksettings(struct net_device *ndev,
> +				   const struct ethtool_link_ksettings *ecmd)
> +{
> +	struct prueth_emac *emac = netdev_priv(ndev);
> +
> +	if (!emac->phydev || phy_is_pseudo_fixed_link(emac->phydev))
> +		return -EOPNOTSUPP;
> +
> +	return phy_ethtool_ksettings_set(emac->phydev, ecmd);
> +}
> +
> +static int emac_get_eee(struct net_device *ndev, struct ethtool_eee *edata)
> +{
> +	struct prueth_emac *emac = netdev_priv(ndev);
> +
> +	if (!emac->phydev || phy_is_pseudo_fixed_link(emac->phydev))
> +		return -EOPNOTSUPP;
> +
> +	return phy_ethtool_get_eee(emac->phydev, edata);
> +}

Why do you need the phy_is_pseudo_fixed_link() calls here?

> +/* called back by PHY layer if there is change in link state of hw port*/
> +static void emac_adjust_link(struct net_device *ndev)
> +{

...

> +	if (emac->link) {
> +		/* link ON */
> +		netif_carrier_on(ndev);
> +		/* reactivate the transmit queue */
> +		netif_tx_wake_all_queues(ndev);
> +	} else {
> +		/* link OFF */
> +		netif_carrier_off(ndev);
> +		netif_tx_stop_all_queues(ndev);
> +	}

phylib should of set the carrier for you.

> + * emac_ndo_open - EMAC device open
> + * @ndev: network adapter device
> + *
> + * Called when system wants to start the interface.
> + *
> + * Returns 0 for a successful open, or appropriate error code
> + */
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

phylib should take care of this.

> +
> +	/* Notify the stack of the actual queue counts. */
> +	ret = netif_set_real_num_tx_queues(ndev, num_data_chn);
> +	if (ret) {
> +		dev_err(dev, "cannot set real number of tx queues\n");
> +		return ret;
> +	}
> +
> +	init_completion(&emac->cmd_complete);
> +	ret = prueth_init_tx_chns(emac);
> +	if (ret) {
> +		dev_err(dev, "failed to init tx channel: %d\n", ret);
> +		return ret;
> +	}
> +
> +	max_rx_flows = PRUETH_MAX_RX_FLOWS;
> +	ret = prueth_init_rx_chns(emac, &emac->rx_chns, "rx",
> +				  max_rx_flows, PRUETH_MAX_RX_DESC);
> +	if (ret) {
> +		dev_err(dev, "failed to init rx channel: %d\n", ret);
> +		goto cleanup_tx;
> +	}
> +
> +	ret = prueth_ndev_add_tx_napi(emac);
> +	if (ret)
> +		goto cleanup_rx;
> +
> +	/* we use only the highest priority flow for now i.e. @irq[3] */
> +	rx_flow = PRUETH_RX_FLOW_DATA;
> +	ret = request_irq(emac->rx_chns.irq[rx_flow], prueth_rx_irq,
> +			  IRQF_TRIGGER_HIGH, dev_name(dev), emac);
> +	if (ret) {
> +		dev_err(dev, "unable to request RX IRQ\n");
> +		goto cleanup_napi;
> +	}
> +
> +	/* reset and start PRU firmware */
> +	ret = prueth_emac_start(prueth, emac);
> +	if (ret)
> +		goto free_rx_irq;
> +
> +	/* Prepare RX */
> +	ret = prueth_prepare_rx_chan(emac, &emac->rx_chns, PRUETH_MAX_PKT_SIZE);
> +	if (ret)
> +		goto stop;
> +
> +	ret = k3_udma_glue_enable_rx_chn(emac->rx_chns.rx_chn);
> +	if (ret)
> +		goto reset_rx_chn;
> +
> +	for (i = 0; i < emac->tx_ch_num; i++) {
> +		ret = k3_udma_glue_enable_tx_chn(emac->tx_chns[i].tx_chn);
> +		if (ret)
> +			goto reset_tx_chan;
> +	}
> +
> +	/* Enable NAPI in Tx and Rx direction */
> +	for (i = 0; i < emac->tx_ch_num; i++)
> +		napi_enable(&emac->tx_chns[i].napi_tx);
> +	napi_enable(&emac->napi_rx);
> +
> +	emac_phy_connect(emac);

Why don't you check the error code?

> +static int prueth_config_rgmiidelay(struct prueth *prueth,
> +				    struct device_node *eth_np,
> +				    phy_interface_t phy_if)
> +{
> +	struct device *dev = prueth->dev;
> +	struct regmap *ctrl_mmr;
> +	u32 rgmii_tx_id = 0;
> +	u32 icssgctrl_reg;
> +
> +	if (!phy_interface_mode_is_rgmii(phy_if))
> +		return 0;
> +
> +	ctrl_mmr = syscon_regmap_lookup_by_phandle(eth_np, "ti,syscon-rgmii-delay");
> +	if (IS_ERR(ctrl_mmr)) {
> +		dev_err(dev, "couldn't get ti,syscon-rgmii-delay\n");
> +		return -ENODEV;
> +	}
> +
> +	if (of_property_read_u32_index(eth_np, "ti,syscon-rgmii-delay", 1,
> +				       &icssgctrl_reg)) {
> +		dev_err(dev, "couldn't get ti,rgmii-delay reg. offset\n");
> +		return -ENODEV;
> +	}
> +
> +	if (phy_if == PHY_INTERFACE_MODE_RGMII_ID ||
> +	    phy_if == PHY_INTERFACE_MODE_RGMII_TXID)
> +		rgmii_tx_id |= ICSSG_CTRL_RGMII_ID_MODE;
> +
> +	regmap_update_bits(ctrl_mmr, icssgctrl_reg, ICSSG_CTRL_RGMII_ID_MODE, rgmii_tx_id);

Do you need to do a units conversion here, or does the register
already take pico seconds?

	Andrew
