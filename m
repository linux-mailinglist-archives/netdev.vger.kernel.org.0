Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3A7035A98E
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 02:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235293AbhDJAgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 20:36:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235215AbhDJAgT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 20:36:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28DC161029;
        Sat, 10 Apr 2021 00:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618014965;
        bh=Tn3XAOZyH1seZ040OJXO+O98FX2DMkgVb4elvyZz9y4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KvQi+1MjEeIFiWwkYpPeM7e7+IoNoruvUgYSIsBeYB0NDJaRgewgcYrV6A/UyBWS1
         wy4c0B6omLsLoFnVdFx7L1j5L0RzKTMbXxLG7wuxZtyZJ/K/TWlHb3d6rl9CzwQPHu
         OsORLD0cf6Lu2A34Ccckh/qSNEh/oRcgP8FZNN66akTyofpSAhpP0y00N2X+N9c6LL
         NEtWp3tEVFnyEZYq0zL3vWnRdtQ/tQQPG8nUnuuXG/+kr/gltoSKidWNnLYPBViF30
         nnAFq7Bj1DTP8QlzrrLfTIBD0PFf41ua3QwzaCwbeGjn/KpV7uNZB6rqWBHQsuclC7
         BMRmw/C13JU6Q==
Date:   Fri, 9 Apr 2021 17:36:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Andre Guedes <andre.guedes@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        Vedang Patel <vedang.patel@intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: Re: [PATCH net-next 8/9] igc: Enable RX via AF_XDP zero-copy
Message-ID: <20210409173604.217406b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210409164351.188953-9-anthony.l.nguyen@intel.com>
References: <20210409164351.188953-1-anthony.l.nguyen@intel.com>
        <20210409164351.188953-9-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  9 Apr 2021 09:43:50 -0700 Tony Nguyen wrote:
> From: Andre Guedes <andre.guedes@intel.com>
> 
> Add support for receiving packets via AF_XDP zero-copy mechanism.
> 
> Add a new flag to 'enum igc_ring_flags_t' to indicate the ring has
> AF_XDP zero-copy enabled so proper ring setup is carried out during ring
> configuration in igc_configure_rx_ring().
> 
> RX buffers can now be allocated via the shared pages mechanism (default
> behavior of the driver) or via xsk pool (when AF_XDP zero-copy is
> enabled) so a union is added to the 'struct igc_rx_buffer' to cover both
> cases.
> 
> When AF_XDP zero-copy is enabled, rx buffers are allocated from the xsk
> pool using the new helper igc_alloc_rx_buffers_zc() which is the
> counterpart of igc_alloc_rx_buffers().
> 
> Likewise other Intel drivers that support AF_XDP zero-copy, in igc we
> have a dedicated path for cleaning up rx irqs when zero-copy is enabled.
> This avoids adding too many checks within igc_clean_rx_irq(), resulting
> in a more readable and efficient code since this function is called from
> the hot-path of the driver.

> +static struct sk_buff *igc_construct_skb_zc(struct igc_ring *ring,
> +					    struct xdp_buff *xdp)
> +{
> +	unsigned int metasize = xdp->data - xdp->data_meta;
> +	unsigned int datasize = xdp->data_end - xdp->data;
> +	struct sk_buff *skb;
> +
> +	skb = __napi_alloc_skb(&ring->q_vector->napi,
> +			       xdp->data_end - xdp->data_hard_start,
> +			       GFP_ATOMIC | __GFP_NOWARN);
> +	if (unlikely(!skb))
> +		return NULL;
> +
> +	skb_reserve(skb, xdp->data - xdp->data_hard_start);
> +	memcpy(__skb_put(skb, datasize), xdp->data, datasize);
> +	if (metasize)
> +		skb_metadata_set(skb, metasize);

But you haven't actually copied the matadata into the skb,
the metadata is before xdp->data, right?

> +	return skb;
> +}

> +static int igc_xdp_enable_pool(struct igc_adapter *adapter,
> +			       struct xsk_buff_pool *pool, u16 queue_id)
> +{
> +	struct net_device *ndev = adapter->netdev;
> +	struct device *dev = &adapter->pdev->dev;
> +	struct igc_ring *rx_ring;
> +	struct napi_struct *napi;
> +	bool needs_reset;
> +	u32 frame_size;
> +	int err;
> +
> +	if (queue_id >= adapter->num_rx_queues)
> +		return -EINVAL;
> +
> +	frame_size = xsk_pool_get_rx_frame_size(pool);
> +	if (frame_size < ETH_FRAME_LEN + VLAN_HLEN * 2) {
> +		/* When XDP is enabled, the driver doesn't support frames that
> +		 * span over multiple buffers. To avoid that, we check if xsk
> +		 * frame size is big enough to fit the max ethernet frame size
> +		 * + vlan double tagging.
> +		 */
> +		return -EOPNOTSUPP;
> +	}
> +
> +	err = xsk_pool_dma_map(pool, dev, IGC_RX_DMA_ATTR);
> +	if (err) {
> +		netdev_err(ndev, "Failed to map xsk pool\n");
> +		return err;
> +	}
> +
> +	needs_reset = netif_running(adapter->netdev) && igc_xdp_is_enabled(adapter);
> +
> +	rx_ring = adapter->rx_ring[queue_id];
> +	napi = &rx_ring->q_vector->napi;
> +
> +	if (needs_reset) {
> +		igc_disable_rx_ring(rx_ring);
> +		napi_disable(napi);
> +	}
> +
> +	set_bit(IGC_RING_FLAG_AF_XDP_ZC, &rx_ring->flags);
> +
> +	if (needs_reset) {
> +		napi_enable(napi);
> +		igc_enable_rx_ring(rx_ring);
> +
> +		err = igc_xsk_wakeup(ndev, queue_id, XDP_WAKEUP_RX);
> +		if (err)
> +			return err;

No need for an unwind path here?
Does something call XDP_SETUP_XSK_POOL(NULL) on failure automagically?

> +	}
> +
> +	return 0;
> +}
