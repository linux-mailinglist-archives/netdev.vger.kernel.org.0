Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9485C4FF193
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 10:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbiDMIS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 04:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233682AbiDMISY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 04:18:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFDA3879F;
        Wed, 13 Apr 2022 01:16:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62A34B8214A;
        Wed, 13 Apr 2022 08:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26522C385A3;
        Wed, 13 Apr 2022 08:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649837760;
        bh=OSJL62PsVT9RuUTRNkAgpg4b2N9gEv5mm5zrUxAX4l8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=fX+DA8GJBzUsixPc0ausR8D9FeKBk5wu7bfEgPhaaxDFqoKUFAvTtJaqxAbjT2PkO
         OX8gG8uHRkVSk6kJas/5qlAyQkbn1ZLZSYCr+5eboogj3mH2yt3vArlU7mm5QBqJyV
         X9knNu54qMMdkY1U2PfHCMzrO9LlBjyvzDT48jfy1FZkLVrtnFprcdgvyi6c1VayjW
         8M2TFDImGA19Q4wEu4Y5znhH6x7DmteGbMhcESuNYfF7t6tHWezU7CgnDBa19FsmYr
         IMYSITMS0+Fm8JvJ9TN1cvMJ3W+S01iFX5/HfK2k6daU9Ood2L/1slfzQoTiVVxXOX
         T3HNUGoEzV3yw==
Message-ID: <1c893a6b-671e-de1b-5d58-65198a310573@kernel.org>
Date:   Wed, 13 Apr 2022 11:15:53 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC 13/13] net: ti: icssg-prueth: Add ICSSG ethernet driver
Content-Language: en-US
To:     Puranjay Mohan <p-mohan@ti.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org, bjorn.andersson@linaro.org,
        mathieu.poirier@linaro.org, krzysztof.kozlowski+dt@linaro.org,
        linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org,
        nm@ti.com, ssantosh@kernel.org, s-anna@ti.com,
        linux-arm-kernel@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, vigneshr@ti.com,
        kishon@ti.com, Grygorii Strashko <grygorii.strashko@ti.com>
References: <20220406094358.7895-1-p-mohan@ti.com>
 <20220406094358.7895-14-p-mohan@ti.com> <Yk2gDGN8a2xss1UO@lunn.ch>
 <543b8c11-db95-29d1-29bc-ae5cbd99b2e2@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <543b8c11-db95-29d1-29bc-ae5cbd99b2e2@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 12/04/2022 12:42, Puranjay Mohan wrote:
> + Roger, Grygorii
> 
> On 06/04/22 19:43, Andrew Lunn wrote:
>>> +static int emac_set_link_ksettings(struct net_device *ndev,
>>> +				   const struct ethtool_link_ksettings *ecmd)
>>> +{
>>> +	struct prueth_emac *emac = netdev_priv(ndev);
>>> +
>>> +	if (!emac->phydev || phy_is_pseudo_fixed_link(emac->phydev))
>>> +		return -EOPNOTSUPP;
>>> +
>>> +	return phy_ethtool_ksettings_set(emac->phydev, ecmd);
>>> +}
>>> +
>>> +static int emac_get_eee(struct net_device *ndev, struct ethtool_eee *edata)
>>> +{
>>> +	struct prueth_emac *emac = netdev_priv(ndev);
>>> +
>>> +	if (!emac->phydev || phy_is_pseudo_fixed_link(emac->phydev))
>>> +		return -EOPNOTSUPP;
>>> +
>>> +	return phy_ethtool_get_eee(emac->phydev, edata);
>>> +}
>>
>> Why do you need the phy_is_pseudo_fixed_link() calls here?

I think this is left over code from early days. It can be removed.

>>
>>> +/* called back by PHY layer if there is change in link state of hw port*/
>>> +static void emac_adjust_link(struct net_device *ndev)
>>> +{
>>
>> ...
>>
>>> +	if (emac->link) {
>>> +		/* link ON */
>>> +		netif_carrier_on(ndev);
>>> +		/* reactivate the transmit queue */
>>> +		netif_tx_wake_all_queues(ndev);
>>> +	} else {
>>> +		/* link OFF */
>>> +		netif_carrier_off(ndev);
>>> +		netif_tx_stop_all_queues(ndev);
>>> +	}
>>
>> phylib should of set the carrier for you.
>>
>>> + * emac_ndo_open - EMAC device open
>>> + * @ndev: network adapter device
>>> + *
>>> + * Called when system wants to start the interface.
>>> + *
>>> + * Returns 0 for a successful open, or appropriate error code
>>> + */
>>> +static int emac_ndo_open(struct net_device *ndev)
>>> +{
>>> +	struct prueth_emac *emac = netdev_priv(ndev);
>>> +	int ret, i, num_data_chn = emac->tx_ch_num;
>>> +	struct prueth *prueth = emac->prueth;
>>> +	int slice = prueth_emac_slice(emac);
>>> +	struct device *dev = prueth->dev;
>>> +	int max_rx_flows;
>>> +	int rx_flow;
>>> +
>>> +	/* clear SMEM and MSMC settings for all slices */
>>> +	if (!prueth->emacs_initialized) {
>>> +		memset_io(prueth->msmcram.va, 0, prueth->msmcram.size);
>>> +		memset_io(prueth->shram.va, 0, ICSSG_CONFIG_OFFSET_SLICE1 * PRUETH_NUM_MACS);
>>> +	}
>>> +
>>> +	/* set h/w MAC as user might have re-configured */
>>> +	ether_addr_copy(emac->mac_addr, ndev->dev_addr);
>>> +
>>> +	icssg_class_set_mac_addr(prueth->miig_rt, slice, emac->mac_addr);
>>> +	icssg_ft1_set_mac_addr(prueth->miig_rt, slice, emac->mac_addr);
>>> +
>>> +	icssg_class_default(prueth->miig_rt, slice, 0);
>>> +
>>> +	netif_carrier_off(ndev);
>>
>> phylib should take care of this.
>>
>>> +
>>> +	/* Notify the stack of the actual queue counts. */
>>> +	ret = netif_set_real_num_tx_queues(ndev, num_data_chn);
>>> +	if (ret) {
>>> +		dev_err(dev, "cannot set real number of tx queues\n");
>>> +		return ret;
>>> +	}
>>> +
>>> +	init_completion(&emac->cmd_complete);
>>> +	ret = prueth_init_tx_chns(emac);
>>> +	if (ret) {
>>> +		dev_err(dev, "failed to init tx channel: %d\n", ret);
>>> +		return ret;
>>> +	}
>>> +
>>> +	max_rx_flows = PRUETH_MAX_RX_FLOWS;
>>> +	ret = prueth_init_rx_chns(emac, &emac->rx_chns, "rx",
>>> +				  max_rx_flows, PRUETH_MAX_RX_DESC);
>>> +	if (ret) {
>>> +		dev_err(dev, "failed to init rx channel: %d\n", ret);
>>> +		goto cleanup_tx;
>>> +	}
>>> +
>>> +	ret = prueth_ndev_add_tx_napi(emac);
>>> +	if (ret)
>>> +		goto cleanup_rx;
>>> +
>>> +	/* we use only the highest priority flow for now i.e. @irq[3] */
>>> +	rx_flow = PRUETH_RX_FLOW_DATA;
>>> +	ret = request_irq(emac->rx_chns.irq[rx_flow], prueth_rx_irq,
>>> +			  IRQF_TRIGGER_HIGH, dev_name(dev), emac);
>>> +	if (ret) {
>>> +		dev_err(dev, "unable to request RX IRQ\n");
>>> +		goto cleanup_napi;
>>> +	}
>>> +
>>> +	/* reset and start PRU firmware */
>>> +	ret = prueth_emac_start(prueth, emac);
>>> +	if (ret)
>>> +		goto free_rx_irq;
>>> +
>>> +	/* Prepare RX */
>>> +	ret = prueth_prepare_rx_chan(emac, &emac->rx_chns, PRUETH_MAX_PKT_SIZE);
>>> +	if (ret)
>>> +		goto stop;
>>> +
>>> +	ret = k3_udma_glue_enable_rx_chn(emac->rx_chns.rx_chn);
>>> +	if (ret)
>>> +		goto reset_rx_chn;
>>> +
>>> +	for (i = 0; i < emac->tx_ch_num; i++) {
>>> +		ret = k3_udma_glue_enable_tx_chn(emac->tx_chns[i].tx_chn);
>>> +		if (ret)
>>> +			goto reset_tx_chan;
>>> +	}
>>> +
>>> +	/* Enable NAPI in Tx and Rx direction */
>>> +	for (i = 0; i < emac->tx_ch_num; i++)
>>> +		napi_enable(&emac->tx_chns[i].napi_tx);
>>> +	napi_enable(&emac->napi_rx);
>>> +
>>> +	emac_phy_connect(emac);
>>
>> Why don't you check the error code?
>>
>>> +static int prueth_config_rgmiidelay(struct prueth *prueth,
>>> +				    struct device_node *eth_np,
>>> +				    phy_interface_t phy_if)
>>> +{
>>> +	struct device *dev = prueth->dev;
>>> +	struct regmap *ctrl_mmr;
>>> +	u32 rgmii_tx_id = 0;
>>> +	u32 icssgctrl_reg;
>>> +
>>> +	if (!phy_interface_mode_is_rgmii(phy_if))
>>> +		return 0;
>>> +
>>> +	ctrl_mmr = syscon_regmap_lookup_by_phandle(eth_np, "ti,syscon-rgmii-delay");
>>> +	if (IS_ERR(ctrl_mmr)) {
>>> +		dev_err(dev, "couldn't get ti,syscon-rgmii-delay\n");
>>> +		return -ENODEV;
>>> +	}
>>> +
>>> +	if (of_property_read_u32_index(eth_np, "ti,syscon-rgmii-delay", 1,
>>> +				       &icssgctrl_reg)) {
>>> +		dev_err(dev, "couldn't get ti,rgmii-delay reg. offset\n");
>>> +		return -ENODEV;
>>> +	}
>>> +
>>> +	if (phy_if == PHY_INTERFACE_MODE_RGMII_ID ||
>>> +	    phy_if == PHY_INTERFACE_MODE_RGMII_TXID)
>>> +		rgmii_tx_id |= ICSSG_CTRL_RGMII_ID_MODE;
>>> +
>>> +	regmap_update_bits(ctrl_mmr, icssgctrl_reg, ICSSG_CTRL_RGMII_ID_MODE, rgmii_tx_id);
>>
>> Do you need to do a units conversion here, or does the register
>> already take pico seconds?

I think Grygorii already answered this. It is just a fixed delay enable/disable bit.

cheers,
-roger
