Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBB017E8B7
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 20:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgCITgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 15:36:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:32984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbgCITgV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 15:36:21 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45EAF2465A;
        Mon,  9 Mar 2020 19:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583782580;
        bh=Q/Y8XhuVS8zV0t8K+w7GOL7XmCYXcjEqC5LXm81Ug0I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wA10nR8ux8Vp3EKnyUgW6pGIWE22tSfpPpMB6XIIaGnSn6bro1BIr8WBipP5NmJSs
         IZK3OlycwPDU7+ecw1VROEbWe61AfYtEdiecWm6r2hY8v0Dzuh0FBW3BgnqK53QGRM
         YYahJYXTRIylzGAqDJy1vTAnxN3L7rwFk/5imxKM=
Date:   Mon, 9 Mar 2020 12:36:18 -0700
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
Message-ID: <20200309123618.5e9bfd30@kicinski-fedora-PC1C0HJN>
In-Reply-To: <76009b01-2f02-41e8-aea2-16dd1cbddd93@ti.com>
References: <20200306234734.15014-1-grygorii.strashko@ti.com>
        <20200306234734.15014-6-grygorii.strashko@ti.com>
        <20200306172027.18d88fb0@kicinski-fedora-PC1C0HJN>
        <76009b01-2f02-41e8-aea2-16dd1cbddd93@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 7 Mar 2020 07:19:17 +0200 Grygorii Strashko wrote:
> Hi Jakub,
> 
> Thank you for your review.
> 
> On 07/03/2020 03:20, Jakub Kicinski wrote:
> >> +static void am65_cpsw_get_drvinfo(struct net_device *ndev,
> >> +				  struct ethtool_drvinfo *info)
> >> +{
> >> +	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
> >> +
> >> +	strlcpy(info->driver, dev_driver_string(common->dev),
> >> +		sizeof(info->driver));
> >> +	strlcpy(info->version, AM65_CPSW_DRV_VER, sizeof(info->version));  
> > 
> > Please remove the driver version, use of driver versions is being deprecated upstream.  
> 
> Hm. I can remove it np. But how do I or anybody else can know that it's deprecated
> 
>   * @get_drvinfo: Report driver/device information.  Should only set the
>   *	@driver, @version, @fw_version and @bus_info fields.  If not
>   *	implemented, the @driver and @bus_info fields will be filled in
>   *	according to the netdev's parent device.
> 
>   * struct ethtool_drvinfo - general driver and device information
> ..
>   * @version: Driver version string; may be an empty string
> 
> It seems not marked as deprecated.

Thanks, it's _being_ deprecated, by which I mean we are slowly removing
the use, and will mark it as deprecated afterwards. I take your point
that we should have started with marking..

> >> +	psdata = cppi5_hdesc_get_psdata(desc_rx);
> >> +	csum_info = psdata[2];
> >> +	dev_dbg(dev, "%s rx csum_info:%#x\n", __func__, csum_info);
> >> +
> >> +	dma_unmap_single(dev, buf_dma, buf_dma_len, DMA_FROM_DEVICE);
> >> +
> >> +	k3_udma_desc_pool_free(rx_chn->desc_pool, desc_rx);
> >> +
> >> +	if (unlikely(!netif_running(skb->dev))) {  
> > 
> > This is strange, does am65_cpsw_nuss_ndo_slave_stop() not stop RX?  
> 
> Net core will set __LINK_STATE_START = 0 before calling .ndo_stop() and there could some time gap
> between clearing __LINK_STATE_START and actually disabling RX.
> if NAPI is in progress it will just allow to complete current NAPI cycle by discarding unwanted packets
> and without statistic update.

That's fine, let the core discard those packets if it wants to.
Disabling the interface while the traffic is flowing is a rare
occurrence, it's a waste of cycles to check for every packet.

> >> +		dev_kfree_skb_any(skb);
> >> +		return 0;
> >> +	}
> >> +
> >> +	new_skb = netdev_alloc_skb_ip_align(ndev, AM65_CPSW_MAX_PACKET_SIZE);
> >> +	if (new_skb) {
> >> +		skb_put(skb, pkt_len);
> >> +		skb->protocol = eth_type_trans(skb, ndev);
> >> +		am65_cpsw_nuss_rx_csum(skb, csum_info);
> >> +		napi_gro_receive(&common->napi_rx, skb);
> >> +
> >> +		ndev_priv = netdev_priv(ndev);
> >> +		stats = this_cpu_ptr(ndev_priv->stats);
> >> +
> >> +		u64_stats_update_begin(&stats->syncp);
> >> +		stats->rx_packets++;
> >> +		stats->rx_bytes += pkt_len;
> >> +		u64_stats_update_end(&stats->syncp);
> >> +		kmemleak_not_leak(new_skb);
> >> +	} else {
> >> +		ndev->stats.rx_dropped++;
> >> +		new_skb = skb;
> >> +	}  
> >   
> >> +static int am65_cpsw_nuss_tx_poll(struct napi_struct *napi_tx, int budget)
> >> +{
> >> +	struct am65_cpsw_tx_chn *tx_chn = am65_cpsw_napi_to_tx_chn(napi_tx);
> >> +	int num_tx;
> >> +
> >> +	num_tx = am65_cpsw_nuss_tx_compl_packets(tx_chn->common, tx_chn->id,
> >> +						 budget);
> >> +	if (num_tx < budget) {  
> > 
> > The budget is for RX, you can just complete all TX on a NAPI poll.  
> 
> Then TX will block RX. Right? this is soft IRQs which are executed one by one.

If anything completing all TX frames makes it more likely RX will have
another memory to allocate from. AFAIK live lock by TX completions is
unheard of.
> >> +	tx_chn = &common->tx_chns[q_idx];
> >> +	netif_txq = netdev_get_tx_queue(ndev, q_idx);
> >> +
> >> +	/* Map the linear buffer */
> >> +	buf_dma = dma_map_single(dev, skb->data, pkt_len,
> >> +				 DMA_TO_DEVICE);
> >> +	if (unlikely(dma_mapping_error(dev, buf_dma))) {
> >> +		dev_err(dev, "Failed to map tx skb buffer\n");  
> > 
> > You probably don't want to print errors when memory gets depleted.
> > Counter is enough  
> 
> Could you please help me understand what is the relation between "memory depletion"
> and dma_mapping_error()?

I don't know your platform, so the comment may not be accurate, but
usually DMA mappings fail if the device has some memory addressing
constraints, and all memory which can satisfy those is used. Or the
memory situation is extremely dire and IOMMU driver can't allocate
meta data.

> >> +		ret = -EINVAL;  
> > 
> > EINVAL is not a valid netdev_tx_t..  
> 
> Considering dev_xmit_complete() - this part was always "black magic" to me :(
> Will fix.
> 
> >> +		ndev->stats.tx_errors++;
> >> +		goto drop_stop_q;  
> > 
> > Why stop queue on memory mapping error? What will re-enable it?  
> 
> it will not. I'm considering it as critical - no recovery.

Oh, I see. If you're sure this can never happen (tm) on your platfrom
I'd throw in a WARN_ON_ONCE() in this path so users know what's going
on. That said it doesn't seem too hard to recover from, so normal error
handling would be best.

> >> +	}
> >> +
> >> +	first_desc = k3_udma_desc_pool_alloc(tx_chn->desc_pool);
> >> +	if (!first_desc) {
> >> +		dev_dbg(dev, "Failed to allocate descriptor\n");  
> > 
> > ret not set  
> 
> It will return NETDEV_TX_BUSY in this  case - below.
>
> >> +		dma_unmap_single(dev, buf_dma, pkt_len, DMA_TO_DEVICE);
> >> +		goto drop_stop_q_busy;
> >> +	}  

> >> +		}
> >> +	}
> >> +
> >> +err:
> >> +	return ret;
> >> +}  
> >   
> >> +	/* register devres action here, so dev will be disabled
> >> +	 * at right moment. The dev will be enabled in .remove() callback
> >> +	 * unconditionally.
> >> +	 */
> >> +	ret = devm_add_action_or_reset(dev, am65_cpsw_pm_runtime_free, dev);
> >> +	if (ret) {
> >> +		dev_err(dev, "failed to add pm put reset action %d", ret);
> >> +		return ret;
> >> +	}  
> > 
> > Could you explain why you need this? Why can't remove disable PM?
> > 
> > In general looks to me like this driver abuses devm_ infra in ways
> > which make it more complex than it needs to be :(  
> 
> Sry, can't agree here. This allows me to keep release sequence in sane way and get
> rid of mostly all goto for fail cases (which are constant source of errors for complex
> initialization sequences) by using standard framework.

As a reviewer I can tell you with absolute certainty that using devm
anywhere but in the probe function makes the driver a lot harder to
review.

IMHO the API to remove registered callbacks should be avoided like 
the plague.

> Regarding PM runtime
>   -  many Linux core framework provide devm_ APIs this and other
> drivers are happy to use them.
>   - but, there is the problem: DD release sequence is
> 
> 	drv->remove(dev);
> 
> 	devres_release_all(dev);
> 
> and there is no devm_ API for PM runtime. So, if some initialization step is done with devm_ API and
> It depends on device to be active - no way to solve it in .remove() callback easily.
> For example, devm_of_platform_populate().
> 
> With above code I ensure that:
> 
> drv->remove(dev);
>   |- pm_runtime_get()
> 
> devres_release_all(dev);
>   |- devm_of_platform_populate_release()
>   |- pm_runtime_put()
>   |- pm_runtime_disable()

Add devm_pm_* helpers for PM then?  That'd the preferred solution
upstream.
