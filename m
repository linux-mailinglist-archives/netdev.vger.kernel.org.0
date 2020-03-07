Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDDAA17CA3F
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 02:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgCGBUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 20:20:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:47374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbgCGBUb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 20:20:31 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AB40206CC;
        Sat,  7 Mar 2020 01:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583544030;
        bh=tKs0d9Kq0Y/zSX5jcC5OD9ImyGddCv9D1ncrA85uCUc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q+NkS8vRoVTkd9rU2ut9EXjn+06UBked/9OiXI/5EdijyHZhV+JoUTiMge6cDyVQH
         tsMuXFU18tlU7E1QPkOERGXZOaPuFRr7Or0mJYJ/ZGG9OH3cwz9cGI1J6yyJyM5c0R
         S7aHn+XwVz1AxVdaLuGiZnkh1cqauKHatr4kaU7U=
Date:   Fri, 6 Mar 2020 17:20:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Rob Herring <robh+dt@kernel.org>, Tero Kristo <t-kristo@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        <devicetree@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 5/9] net: ethernet: ti: introduce
 am65x/j721e gigabit eth subsystem driver
Message-ID: <20200306172027.18d88fb0@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200306234734.15014-6-grygorii.strashko@ti.com>
References: <20200306234734.15014-1-grygorii.strashko@ti.com>
        <20200306234734.15014-6-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void am65_cpsw_get_drvinfo(struct net_device *ndev,
> +				  struct ethtool_drvinfo *info)
> +{
> +	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
> +
> +	strlcpy(info->driver, dev_driver_string(common->dev),
> +		sizeof(info->driver));
> +	strlcpy(info->version, AM65_CPSW_DRV_VER, sizeof(info->version));

Please remove the driver version, use of driver versions is being deprecated upstream.

> +	strlcpy(info->bus_info, dev_name(common->dev), sizeof(info->bus_info));
> +}

> +static void am65_cpsw_get_channels(struct net_device *ndev,
> +				   struct ethtool_channels *ch)
> +{
> +	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
> +
> +	ch->max_combined = 0;

no need to zero fields

> +	ch->max_rx = AM65_CPSW_MAX_RX_QUEUES;
> +	ch->max_tx = AM65_CPSW_MAX_TX_QUEUES;
> +	ch->max_other = 0;
> +	ch->other_count = 0;
> +	ch->rx_count = AM65_CPSW_MAX_RX_QUEUES;
> +	ch->tx_count = common->tx_ch_num;
> +	ch->combined_count = 0;
> +}
> +
> +static int am65_cpsw_set_channels(struct net_device *ndev,
> +				  struct ethtool_channels *chs)
> +{
> +	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
> +
> +	if (chs->combined_count)
> +		return -EINVAL;

core will check if its larger than max_combined

> +	if (!chs->rx_count || !chs->tx_count)
> +		return -EINVAL;
> +
> +	if (chs->rx_count != 1 ||
> +	    chs->tx_count > AM65_CPSW_MAX_TX_QUEUES)
> +		return -EINVAL;

ditto

> +	/* Check if interface is up. Can change the num queues when
> +	 * the interface is down.
> +	 */
> +	if (netif_running(ndev))
> +		return -EBUSY;
> +
> +	am65_cpsw_nuss_remove_tx_chns(common);
> +
> +	return am65_cpsw_nuss_update_tx_chns(common, chs->tx_count);
> +}
> +
> +static void am65_cpsw_get_ringparam(struct net_device *ndev,
> +				    struct ethtool_ringparam *ering)
> +{
> +	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
> +
> +	/* not supported */
> +	ering->tx_max_pending = 0;

no need to zero fields

> +	ering->tx_pending = common->tx_chns[0].descs_num;
> +	ering->rx_max_pending = 0;
> +	ering->rx_pending = common->rx_chns.descs_num;
> +}

> +EXPORT_SYMBOL_GPL(am65_cpsw_nuss_adjust_link);

Why does this need to be exported?

> +	psdata = cppi5_hdesc_get_psdata(desc_rx);
> +	csum_info = psdata[2];
> +	dev_dbg(dev, "%s rx csum_info:%#x\n", __func__, csum_info);
> +
> +	dma_unmap_single(dev, buf_dma, buf_dma_len, DMA_FROM_DEVICE);
> +
> +	k3_udma_desc_pool_free(rx_chn->desc_pool, desc_rx);
> +
> +	if (unlikely(!netif_running(skb->dev))) {

This is strange, does am65_cpsw_nuss_ndo_slave_stop() not stop RX?

> +		dev_kfree_skb_any(skb);
> +		return 0;
> +	}
> +
> +	new_skb = netdev_alloc_skb_ip_align(ndev, AM65_CPSW_MAX_PACKET_SIZE);
> +	if (new_skb) {
> +		skb_put(skb, pkt_len);
> +		skb->protocol = eth_type_trans(skb, ndev);
> +		am65_cpsw_nuss_rx_csum(skb, csum_info);
> +		napi_gro_receive(&common->napi_rx, skb);
> +
> +		ndev_priv = netdev_priv(ndev);
> +		stats = this_cpu_ptr(ndev_priv->stats);
> +
> +		u64_stats_update_begin(&stats->syncp);
> +		stats->rx_packets++;
> +		stats->rx_bytes += pkt_len;
> +		u64_stats_update_end(&stats->syncp);
> +		kmemleak_not_leak(new_skb);
> +	} else {
> +		ndev->stats.rx_dropped++;
> +		new_skb = skb;
> +	}

> +static int am65_cpsw_nuss_tx_poll(struct napi_struct *napi_tx, int budget)
> +{
> +	struct am65_cpsw_tx_chn *tx_chn = am65_cpsw_napi_to_tx_chn(napi_tx);
> +	int num_tx;
> +
> +	num_tx = am65_cpsw_nuss_tx_compl_packets(tx_chn->common, tx_chn->id,
> +						 budget);
> +	if (num_tx < budget) {

The budget is for RX, you can just complete all TX on a NAPI poll.

> +		napi_complete(napi_tx);
> +		enable_irq(tx_chn->irq);
> +	}
> +
> +	return num_tx;
> +}

> +static netdev_tx_t am65_cpsw_nuss_ndo_slave_xmit(struct sk_buff *skb,
> +						 struct net_device *ndev)
> +{
> +	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
> +	struct cppi5_host_desc_t *first_desc, *next_desc, *cur_desc;
> +	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
> +	struct device *dev = common->dev;
> +	struct am65_cpsw_tx_chn *tx_chn;
> +	struct netdev_queue *netif_txq;
> +	dma_addr_t desc_dma, buf_dma;
> +	int ret, q_idx, i;
> +	void **swdata;
> +	u32 *psdata;
> +	u32 pkt_len;
> +
> +	/* frag list based linkage is not supported for now. */
> +	if (skb_shinfo(skb)->frag_list) {
> +		dev_err_ratelimited(dev, "NETIF_F_FRAGLIST not supported\n");
> +		ret = -EINVAL;
> +		goto drop_free_skb;
> +	}

You don't advertise the feature, there is no need for this check.

> +	/* padding enabled in hw */
> +	pkt_len = skb_headlen(skb);
> +
> +	q_idx = skb_get_queue_mapping(skb);
> +	dev_dbg(dev, "%s skb_queue:%d\n", __func__, q_idx);
> +	q_idx = q_idx % common->tx_ch_num;

You should never see a packet for ring above your ring count, this
modulo is unnecessary.

> +	tx_chn = &common->tx_chns[q_idx];
> +	netif_txq = netdev_get_tx_queue(ndev, q_idx);
> +
> +	/* Map the linear buffer */
> +	buf_dma = dma_map_single(dev, skb->data, pkt_len,
> +				 DMA_TO_DEVICE);
> +	if (unlikely(dma_mapping_error(dev, buf_dma))) {
> +		dev_err(dev, "Failed to map tx skb buffer\n");

You probably don't want to print errors when memory gets depleted.
Counter is enough

> +		ret = -EINVAL;

EINVAL is not a valid netdev_tx_t..

> +		ndev->stats.tx_errors++;
> +		goto drop_stop_q;

Why stop queue on memory mapping error? What will re-enable it?

> +	}
> +
> +	first_desc = k3_udma_desc_pool_alloc(tx_chn->desc_pool);
> +	if (!first_desc) {
> +		dev_dbg(dev, "Failed to allocate descriptor\n");

ret not set

> +		dma_unmap_single(dev, buf_dma, pkt_len, DMA_TO_DEVICE);
> +		goto drop_stop_q_busy;
> +	}

> +done_tx:
> +	skb_tx_timestamp(skb);
> +
> +	/* report bql before sending packet */
> +	netdev_tx_sent_queue(netif_txq, pkt_len);
> +
> +	cppi5_hdesc_set_pktlen(first_desc, pkt_len);
> +	desc_dma = k3_udma_desc_pool_virt2dma(tx_chn->desc_pool, first_desc);
> +	ret = k3_udma_glue_push_tx_chn(tx_chn->tx_chn, first_desc, desc_dma);
> +	if (ret) {
> +		dev_err(dev, "can't push desc %d\n", ret);
> +		ndev->stats.tx_errors++;
> +		goto drop_free_descs;

BQL already counted this frame.

> +	}
> +
> +	if (k3_udma_desc_pool_avail(tx_chn->desc_pool) < MAX_SKB_FRAGS) {
> +		netif_tx_stop_queue(netif_txq);
> +		/* Barrier, so that stop_queue visible to other cpus */
> +		smp_mb__after_atomic();
> +		dev_err(dev, "netif_tx_stop_queue %d\n", q_idx);

How many descriptors are there if it's okay to print an error when
descriptors run out? :o

> +		/* re-check for smp */
> +		if (k3_udma_desc_pool_avail(tx_chn->desc_pool) >=
> +		    MAX_SKB_FRAGS) {
> +			netif_tx_wake_queue(netif_txq);
> +			dev_err(dev, "netif_tx_wake_queue %d\n", q_idx);
> +		}
> +	}
> +
> +	return NETDEV_TX_OK;
> +
> +drop_free_descs:
> +	am65_cpsw_nuss_xmit_free(tx_chn, dev, first_desc);
> +drop_stop_q:
> +	netif_tx_stop_queue(netif_txq);
> +drop_free_skb:
> +	ndev->stats.tx_dropped++;
> +	dev_kfree_skb_any(skb);
> +	return ret;

return NETDEV_TX_OK;

> +
> +drop_stop_q_busy:
> +	netif_tx_stop_queue(netif_txq);
> +	return NETDEV_TX_BUSY;
> +}

> +static int am65_cpsw_nuss_ndev_add_napi_2g(struct am65_cpsw_common *common)
> +{
> +	struct device *dev = common->dev;
> +	struct am65_cpsw_port *port;
> +	int i, ret = 0;
> +
> +	port = am65_common_get_port(common, 1);
> +
> +	for (i = 0; i < common->tx_ch_num; i++) {
> +		struct am65_cpsw_tx_chn	*tx_chn = &common->tx_chns[i];
> +
> +		netif_tx_napi_add(port->ndev, &tx_chn->napi_tx,
> +				  am65_cpsw_nuss_tx_poll, NAPI_POLL_WEIGHT);
> +
> +		ret = devm_request_irq(dev, tx_chn->irq,
> +				       am65_cpsw_nuss_tx_irq,
> +				       0, tx_chn->tx_chn_name, tx_chn);
> +		if (ret) {
> +			dev_err(dev, "failure requesting tx%u irq %u, %d\n",
> +				tx_chn->id, tx_chn->irq, ret);
> +			goto err;

If this fails half way through the loop is there something that'd call 
netif_tx_napi_del()?

> +		}
> +	}
> +
> +err:
> +	return ret;
> +}

> +	/* register devres action here, so dev will be disabled
> +	 * at right moment. The dev will be enabled in .remove() callback
> +	 * unconditionally.
> +	 */
> +	ret = devm_add_action_or_reset(dev, am65_cpsw_pm_runtime_free, dev);
> +	if (ret) {
> +		dev_err(dev, "failed to add pm put reset action %d", ret);
> +		return ret;
> +	}

Could you explain why you need this? Why can't remove disable PM?

In general looks to me like this driver abuses devm_ infra in ways
which make it more complex than it needs to be :(

> +	ret = devm_of_platform_populate(dev);
> +	/* We do not want to force this, as in some cases may not have child */
> +	if (ret)
> +		dev_warn(dev, "populating child nodes err:%d\n", ret);
> +
> +	am65_cpsw_nuss_get_ver(common);
