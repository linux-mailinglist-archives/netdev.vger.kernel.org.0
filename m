Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B9249F1F2
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 04:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345828AbiA1Dnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 22:43:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44442 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbiA1Dnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 22:43:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E37561E3C;
        Fri, 28 Jan 2022 03:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDEDC340E7;
        Fri, 28 Jan 2022 03:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643341420;
        bh=JIe+3zxHc652hiK2hz4NLH0pR4w+X2pBakJpnubLEWQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AZHOu8a/DkUmqJmk/ttCw43L6sXuI80w+UUH/sFapQKD0X4MdjxaH24i01YIY0Nc4
         3OnAooetJsL4umgW9gNycmfe5Oh6HrCALtFz6Ap5NG+iNskyNAPnR8sZ5T+x4XioQb
         eg5zXp5aq2F+CIcxtm+n6zqBYf6qd60ybqwvL/2SVWigbaXEkpvatE2/TQzhFDK/Nr
         EkDKwoim6BySBsvwozpJvk37XY//tAFtGC+rU80RfDnn3hS9rjGt9vrLIfv6guiEJu
         pLVPSuZ7Vrqyvd3nTr5MnkGPkiIo//ICtILXot2YteLR8X1tC3D9D4/sip+YmzJsLd
         OJkWyHZpmmIKw==
Date:   Thu, 27 Jan 2022 19:43:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Fabien Parent <fparent@baylibre.com>,
        Felix Fietkau <nbd@nbd.name>,
        "John Crispin" <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Yinghua Pan <ot_yinghua.pan@mediatek.com>,
        <srv_heupstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>
Subject: Re: [PATCH net-next v2 9/9] net: ethernet: mtk-star-emac: separate
 tx/rx handling with two NAPIs
Message-ID: <20220127194338.01722b3c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220127015857.9868-10-biao.huang@mediatek.com>
References: <20220127015857.9868-1-biao.huang@mediatek.com>
        <20220127015857.9868-10-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Jan 2022 09:58:57 +0800 Biao Huang wrote:
> Current driver may lost tx interrupts under bidirectional test with iperf3,
> which leads to some unexpected issues.
> 
> This patch let rx/tx interrupt enable/disable separately, and rx/tx are
> handled in different NAPIs.

> +/* mtk_star_handle_irq - Interrupt Handler.
> + * @irq: interrupt number.
> + * @data: pointer to a network interface device structure.

if you mean this to me a kdoc comment it needs to start with /**

> + * Description : this is the driver interrupt service routine.
> + * it mainly handles:
> + *  1. tx complete interrupt for frame transmission.
> + *  2. rx complete interrupt for frame reception.
> + *  3. MAC Management Counter interrupt to avoid counter overflow.
>   */
>  static irqreturn_t mtk_star_handle_irq(int irq, void *data)
>  {
> -	struct mtk_star_priv *priv;
> -	struct net_device *ndev;
> +	struct net_device *ndev = data;
> +	struct mtk_star_priv *priv = netdev_priv(ndev);
> +	unsigned int intr_status = mtk_star_intr_ack_all(priv);
> +	unsigned long flags = 0;
> +
> +	if (intr_status & MTK_STAR_BIT_INT_STS_FNRC) {
> +		if (napi_schedule_prep(&priv->rx_napi)) {
> +			spin_lock_irqsave(&priv->lock, flags);
> +			/* mask Rx Complete interrupt */
> +			mtk_star_disable_dma_irq(priv, true, false);
> +			spin_unlock_irqrestore(&priv->lock, flags);
> +			__napi_schedule_irqoff(&priv->rx_napi);
> +		}
> +	}
>  
> -	ndev = data;
> -	priv = netdev_priv(ndev);
> +	if (intr_status & MTK_STAR_BIT_INT_STS_TNTC) {
> +		if (napi_schedule_prep(&priv->tx_napi)) {
> +			spin_lock_irqsave(&priv->lock, flags);
> +			/* mask Tx Complete interrupt */
> +			mtk_star_disable_dma_irq(priv, false, true);
> +			spin_unlock_irqrestore(&priv->lock, flags);
> +			__napi_schedule_irqoff(&priv->tx_napi);
> +		}
> +	}

Seems a little wasteful to retake the same lock twice if two IRQ
sources fire at the same time.

> @@ -1043,6 +1085,17 @@ static int mtk_star_netdev_start_xmit(struct sk_buff *skb,
>  	struct mtk_star_ring *ring = &priv->tx_ring;
>  	struct device *dev = mtk_star_get_dev(priv);
>  	struct mtk_star_ring_desc_data desc_data;
> +	int nfrags = skb_shinfo(skb)->nr_frags;
> +
> +	if (unlikely(mtk_star_tx_ring_avail(ring) < nfrags + 1)) {
> +		if (!netif_queue_stopped(ndev)) {
> +			netif_stop_queue(ndev);
> +			/* This is a hard error, log it. */
> +			netdev_err(priv->ndev, "%s: Tx Ring full when queue awake\n",
> +				   __func__);

This needs to be rate limited. Also no point printing the function
name, unless the same message appears in multiple places.

> +		}
> +		return NETDEV_TX_BUSY;
> +	}
>  
>  	desc_data.dma_addr = mtk_star_dma_map_tx(priv, skb);
>  	if (dma_mapping_error(dev, desc_data.dma_addr))
> @@ -1050,18 +1103,10 @@ static int mtk_star_netdev_start_xmit(struct sk_buff *skb,
>  
>  	desc_data.skb = skb;
>  	desc_data.len = skb->len;
> -
> -	spin_lock_bh(&priv->lock);
> 
>  	mtk_star_ring_push_head_tx(ring, &desc_data);
>  
>  	netdev_sent_queue(ndev, skb->len);
>  
> -	if (mtk_star_ring_full(ring))
> -		netif_stop_queue(ndev);

Are you stopping the queue in advance somewhere else now? Did you only
test this with BQL enabled? Only place that stops the ring also prints
a loud warning now AFAICS..

> -static void mtk_star_tx_complete_all(struct mtk_star_priv *priv)
> +static int mtk_star_tx_poll(struct napi_struct *napi, int budget)
>  {
> -	struct mtk_star_ring *ring = &priv->tx_ring;
> -	struct net_device *ndev = priv->ndev;
> -	int ret, pkts_compl, bytes_compl;
> +	int ret, pkts_compl = 0, bytes_compl = 0, count = 0;
> +	struct mtk_star_priv *priv;
> +	struct mtk_star_ring *ring;
> +	struct net_device *ndev;
> +	unsigned long flags = 0;
> +	unsigned int entry;
>  	bool wake = false;
>  
> -	spin_lock(&priv->lock);
> +	priv = container_of(napi, struct mtk_star_priv, tx_napi);
> +	ndev = priv->ndev;
>  
> -	for (pkts_compl = 0, bytes_compl = 0;;
> +	__netif_tx_lock_bh(netdev_get_tx_queue(priv->ndev, 0));

Do you really need to lock out the Tx while cleaning?

Drivers usually manage to implement concurrent Tx and cleanup with just
a couple of memory barriers.

> +	ring = &priv->tx_ring;
> +	entry = ring->tail;
> +	for (pkts_compl = 0, bytes_compl = 0;
> +	     (entry != ring->head) && (count < budget);

budget is not really relevant for Tx, you can clean the whole ring.
netpoll will pass a budget of 0 to clean up rings.

>  	     pkts_compl++, bytes_compl += ret, wake = true) {
> -		if (!mtk_star_ring_descs_available(ring))
> -			break;
>  
>  		ret = mtk_star_tx_complete_one(priv);
>  		if (ret < 0)
>  			break;
> +		count++;
> +		entry = ring->tail;
>  	}
>  

> @@ -1196,7 +1258,7 @@ static const struct ethtool_ops mtk_star_ethtool_ops = {
>  	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
>  };
>  
> -static int mtk_star_receive_packet(struct mtk_star_priv *priv)
> +static int mtk_star_rx(struct mtk_star_priv *priv, int budget)
>  {
>  	struct mtk_star_ring *ring = &priv->rx_ring;
>  	struct device *dev = mtk_star_get_dev(priv);
> @@ -1204,107 +1266,86 @@ static int mtk_star_receive_packet(struct mtk_star_priv *priv)
>  	struct net_device *ndev = priv->ndev;
>  	struct sk_buff *curr_skb, *new_skb;
>  	dma_addr_t new_dma_addr;
> -	int ret;
> +	int ret, count = 0;
>  
> -	spin_lock(&priv->lock);
> -	ret = mtk_star_ring_pop_tail(ring, &desc_data);
> -	spin_unlock(&priv->lock);
> -	if (ret)
> -		return -1;
> +	while (count < budget) {
> +		ret = mtk_star_ring_pop_tail(ring, &desc_data);
> +		if (ret)
> +			return -1;

> -static int mtk_star_process_rx(struct mtk_star_priv *priv, int budget)
> -{
> -	int received, ret;
> +		count++;
>  
> -	for (received = 0, ret = 0; received < budget && ret == 0; received++)
> -		ret = mtk_star_receive_packet(priv);
> +		desc_data.len = skb_tailroom(new_skb);
> +		desc_data.skb = new_skb;
> +		mtk_star_ring_push_head_rx(ring, &desc_data);
> +	}
>  
>  	mtk_star_dma_resume_rx(priv);

Again you can get a call with a budget of 0, not sure if it's okay to
resume DMA in that case..

> -	return received;
> +	return count;
>  }

