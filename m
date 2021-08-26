Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D39CC3F8423
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 11:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240784AbhHZJIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 05:08:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:31447 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240657AbhHZJIh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 05:08:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10087"; a="204904326"
X-IronPort-AV: E=Sophos;i="5.84,353,1620716400"; 
   d="scan'208";a="204904326"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2021 02:07:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,353,1620716400"; 
   d="scan'208";a="598418702"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga001.fm.intel.com with ESMTP; 26 Aug 2021 02:07:44 -0700
Date:   Thu, 26 Aug 2021 10:51:48 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     kerneljasonxing@gmail.com
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Jason Xing <xingwanli@kuaishou.com>,
        Shujin Li <lishujin@kuaishou.com>
Subject: Re: [PATCH v2] ixgbe: let the xdpdrv work with more than 64 cpus
Message-ID: <20210826085148.GB26792@ranger.igk.intel.com>
References: <CAL+tcoDUhZfy3NTx4TOv3wa1f8SMkNhzNpVS5qyySaVOm6L-qQ@mail.gmail.com>
 <20210825120241.7389-1-kerneljasonxing@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825120241.7389-1-kerneljasonxing@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 08:02:41PM +0800, kerneljasonxing@gmail.com wrote:
> From: Jason Xing <xingwanli@kuaishou.com>
> 
> Originally, ixgbe driver doesn't allow the mounting of xdpdrv if the
> server is equipped with more than 64 cpus online. So it turns out that
> the loading of xdpdrv causes the "NOMEM" failure.
> 
> Actually, we can adjust the algorithm and then make it work through
> mapping the current cpu to some xdp ring with the protect of @tx_lock.
> 
> Considering the performance of xdpdrv mode, I add another limit like ice
> driver where the number of cpus should be within the twice of
> MAX_XDP_QUEUES.

Have you measured the impact on perf that this patch yields? On ice XDP
ring pointers are propagated to Rx ring on setup path whereas you
currently retrieve it per each xmitted frame.

> 
> v2:
> - Adjust cpu id in ixgbe_xdp_xmit(). (Jesper)
> - Add a fallback path. (Maciej)
> - Adjust other parts related to xdp ring.
> 
> Fixes: 33fdc82f08 ("ixgbe: add support for XDP_TX action")
> Co-developed-by: Shujin Li <lishujin@kuaishou.com>
> Signed-off-by: Shujin Li <lishujin@kuaishou.com>
> Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe.h      | 11 +++++
>  drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  |  6 ++-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 63 ++++++++++++++++++++-------
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 15 ++++---
>  4 files changed, 72 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
> index a604552..466b2b0 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
> @@ -82,6 +82,8 @@
>  #define IXGBE_2K_TOO_SMALL_WITH_PADDING \
>  ((NET_SKB_PAD + IXGBE_RXBUFFER_1536) > SKB_WITH_OVERHEAD(IXGBE_RXBUFFER_2K))
>  
> +DECLARE_STATIC_KEY_FALSE(ixgbe_xdp_locking_key);
> +
>  static inline int ixgbe_compute_pad(int rx_buf_len)
>  {
>  	int page_size, pad_size;
> @@ -351,6 +353,7 @@ struct ixgbe_ring {
>  	};
>  	u16 rx_offset;
>  	struct xdp_rxq_info xdp_rxq;
> +	spinlock_t tx_lock;	/* used in XDP mode */
>  	struct xsk_buff_pool *xsk_pool;
>  	u16 ring_idx;		/* {rx,tx,xdp}_ring back reference idx */
>  	u16 rx_buf_len;
> @@ -772,6 +775,14 @@ struct ixgbe_adapter {
>  #endif /* CONFIG_IXGBE_IPSEC */
>  };
>  
> +static inline int ixgbe_determine_xdp_cpu(int cpu)
> +{
> +	if (static_key_enabled(&ixgbe_xdp_locking_key))
> +		return cpu % MAX_XDP_QUEUES;
> +	else
> +		return cpu;
> +}
> +
>  static inline u8 ixgbe_max_rss_indices(struct ixgbe_adapter *adapter)
>  {
>  	switch (adapter->hw.mac.type) {
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> index 0218f6c..d6b58e1 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> @@ -299,7 +299,7 @@ static void ixgbe_cache_ring_register(struct ixgbe_adapter *adapter)
>  
>  static int ixgbe_xdp_queues(struct ixgbe_adapter *adapter)
>  {
> -	return adapter->xdp_prog ? nr_cpu_ids : 0;
> +	return adapter->xdp_prog ? min_t(int, MAX_XDP_QUEUES, nr_cpu_ids) : 0;

AFAIK nr_cpu_ids will give you the max possible cpus on the underlying
system, maybe we should stick to num_online_cpus() instead?

>  }
>  
>  #define IXGBE_RSS_64Q_MASK	0x3F
> @@ -947,6 +947,7 @@ static int ixgbe_alloc_q_vector(struct ixgbe_adapter *adapter,
>  		ring->count = adapter->tx_ring_count;
>  		ring->queue_index = xdp_idx;
>  		set_ring_xdp(ring);
> +		spin_lock_init(&ring->tx_lock);
>  
>  		/* assign ring to adapter */
>  		WRITE_ONCE(adapter->xdp_ring[xdp_idx], ring);
> @@ -1032,6 +1033,9 @@ static void ixgbe_free_q_vector(struct ixgbe_adapter *adapter, int v_idx)
>  	adapter->q_vector[v_idx] = NULL;
>  	__netif_napi_del(&q_vector->napi);
>  
> +	if (static_key_enabled(&ixgbe_xdp_locking_key))
> +		static_branch_dec(&ixgbe_xdp_locking_key);
> +
>  	/*
>  	 * after a call to __netif_napi_del() napi may still be used and
>  	 * ixgbe_get_stats64() might access the rings on this vector,
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index 14aea40..4c94577 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -165,6 +165,9 @@ static int ixgbe_notify_dca(struct notifier_block *, unsigned long event,
>  MODULE_DESCRIPTION("Intel(R) 10 Gigabit PCI Express Network Driver");
>  MODULE_LICENSE("GPL v2");
>  
> +DEFINE_STATIC_KEY_FALSE(ixgbe_xdp_locking_key);
> +EXPORT_SYMBOL(ixgbe_xdp_locking_key);
> +
>  static struct workqueue_struct *ixgbe_wq;
>  
>  static bool ixgbe_check_cfg_remove(struct ixgbe_hw *hw, struct pci_dev *pdev);
> @@ -2422,13 +2425,14 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
>  		xdp_do_flush_map();
>  
>  	if (xdp_xmit & IXGBE_XDP_TX) {
> -		struct ixgbe_ring *ring = adapter->xdp_ring[smp_processor_id()];
> +		int cpu = ixgbe_determine_xdp_cpu(smp_processor_id());
> +		struct ixgbe_ring *ring = adapter->xdp_ring[cpu];
>  
> -		/* Force memory writes to complete before letting h/w
> -		 * know there are new descriptors to fetch.
> -		 */
> -		wmb();
> -		writel(ring->next_to_use, ring->tail);
> +		if (static_branch_unlikely(&ixgbe_xdp_locking_key))
> +			spin_lock(&ring->tx_lock);
> +		ixgbe_xdp_ring_update_tail(ring);
> +		if (static_branch_unlikely(&ixgbe_xdp_locking_key))
> +			spin_unlock(&ring->tx_lock);
>  	}
>  
>  	u64_stats_update_begin(&rx_ring->syncp);
> @@ -8539,21 +8543,33 @@ static u16 ixgbe_select_queue(struct net_device *dev, struct sk_buff *skb,
>  int ixgbe_xmit_xdp_ring(struct ixgbe_adapter *adapter,
>  			struct xdp_frame *xdpf)
>  {
> -	struct ixgbe_ring *ring = adapter->xdp_ring[smp_processor_id()];
> +	struct ixgbe_ring *ring;

RCT is being broken in here

>  	struct ixgbe_tx_buffer *tx_buffer;
>  	union ixgbe_adv_tx_desc *tx_desc;
>  	u32 len, cmd_type;
>  	dma_addr_t dma;
>  	u16 i;
> +	int cpu;
> +	int ret;

Ditto

>  
>  	len = xdpf->len;
>  
> -	if (unlikely(!ixgbe_desc_unused(ring)))
> -		return IXGBE_XDP_CONSUMED;
> +	cpu = ixgbe_determine_xdp_cpu(smp_processor_id());
> +	ring = adapter->xdp_ring[cpu];
> +
> +	if (static_branch_unlikely(&ixgbe_xdp_locking_key))
> +		spin_lock(&ring->tx_lock);
> +
> +	if (unlikely(!ixgbe_desc_unused(ring))) {
> +		ret = IXGBE_XDP_CONSUMED;
> +		goto out;
> +	}
>  
>  	dma = dma_map_single(ring->dev, xdpf->data, len, DMA_TO_DEVICE);
> -	if (dma_mapping_error(ring->dev, dma))
> -		return IXGBE_XDP_CONSUMED;
> +	if (dma_mapping_error(ring->dev, dma)) {
> +		ret = IXGBE_XDP_CONSUMED;
> +		goto out;
> +	}
>  
>  	/* record the location of the first descriptor for this packet */
>  	tx_buffer = &ring->tx_buffer_info[ring->next_to_use];
> @@ -8590,7 +8606,11 @@ int ixgbe_xmit_xdp_ring(struct ixgbe_adapter *adapter,
>  	tx_buffer->next_to_watch = tx_desc;
>  	ring->next_to_use = i;
>  
> -	return IXGBE_XDP_TX;
> +	ret = IXGBE_XDP_TX;
> +out:
> +	if (static_branch_unlikely(&ixgbe_xdp_locking_key))
> +		spin_unlock(&ring->tx_lock);
> +	return ret;
>  }
>  
>  netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff *skb,
> @@ -10130,8 +10150,13 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
>  			return -EINVAL;
>  	}
>  
> -	if (nr_cpu_ids > MAX_XDP_QUEUES)
> +	/* if the number of cpus is much larger than the maximum of queues,
> +	 * we should stop it and then return with NOMEM like before!
> +	 */
> +	if (nr_cpu_ids > MAX_XDP_QUEUES * 2)

I realized this macro is a bit confusing, maybe it would be better to
prefix it with the driver name, so IXGBE_MAX_XDP_QS would make it clear
what's the scope of it.

>  		return -ENOMEM;
> +	else if (nr_cpu_ids > MAX_XDP_QUEUES)
> +		static_branch_inc(&ixgbe_xdp_locking_key);
>  
>  	old_prog = xchg(&adapter->xdp_prog, prog);
>  	need_reset = (!!prog != !!old_prog);
> @@ -10201,6 +10226,7 @@ static int ixgbe_xdp_xmit(struct net_device *dev, int n,
>  	struct ixgbe_adapter *adapter = netdev_priv(dev);
>  	struct ixgbe_ring *ring;
>  	int nxmit = 0;
> +	int cpu;
>  	int i;
>  
>  	if (unlikely(test_bit(__IXGBE_DOWN, &adapter->state)))
> @@ -10209,10 +10235,12 @@ static int ixgbe_xdp_xmit(struct net_device *dev, int n,
>  	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
>  		return -EINVAL;
>  
> +	cpu = ixgbe_determine_xdp_cpu(smp_processor_id());

Actually it's not the cpu that you're determining, just a queue index in
the xdp_rings array.

Say that your running napi on cpu 72, so your function above will return
you the 8 probably and that's the queue number you will pick and share
with cpu 8.

Can you rename this to ixgbe_determine_xdp_q_idx ?

> +
>  	/* During program transitions its possible adapter->xdp_prog is assigned
>  	 * but ring has not been configured yet. In this case simply abort xmit.
>  	 */
> -	ring = adapter->xdp_prog ? adapter->xdp_ring[smp_processor_id()] : NULL;
> +	ring = adapter->xdp_prog ? adapter->xdp_ring[cpu] : NULL;
>  	if (unlikely(!ring))
>  		return -ENXIO;
>  
> @@ -10229,8 +10257,13 @@ static int ixgbe_xdp_xmit(struct net_device *dev, int n,
>  		nxmit++;
>  	}
>  
> -	if (unlikely(flags & XDP_XMIT_FLUSH))
> +	if (unlikely(flags & XDP_XMIT_FLUSH)) {
> +		if (static_branch_unlikely(&ixgbe_xdp_locking_key))
> +			spin_lock(&ring->tx_lock);
>  		ixgbe_xdp_ring_update_tail(ring);
> +		if (static_branch_unlikely(&ixgbe_xdp_locking_key))
> +			spin_unlock(&ring->tx_lock);
> +	}
>  
>  	return nxmit;
>  }
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> index b1d22e4..e9ce6c1 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> @@ -334,13 +334,14 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
>  		xdp_do_flush_map();
>  
>  	if (xdp_xmit & IXGBE_XDP_TX) {
> -		struct ixgbe_ring *ring = adapter->xdp_ring[smp_processor_id()];
> -
> -		/* Force memory writes to complete before letting h/w
> -		 * know there are new descriptors to fetch.
> -		 */
> -		wmb();
> -		writel(ring->next_to_use, ring->tail);
> +		int cpu = ixgbe_determine_xdp_cpu(smp_processor_id());
> +		struct ixgbe_ring *ring = adapter->xdp_ring[cpu];
> +
> +		if (static_branch_unlikely(&ixgbe_xdp_locking_key))
> +			spin_lock(&ring->tx_lock);
> +		ixgbe_xdp_ring_update_tail(ring);

Good that ixgbe_xdp_ring_update_tail is reused, but probably this could be
a common inlined function that is called on both normal and zc variants of
clean rx irq routine.

> +		if (static_branch_unlikely(&ixgbe_xdp_locking_key))
> +			spin_unlock(&ring->tx_lock);
>  	}
>  
>  	u64_stats_update_begin(&rx_ring->syncp);
> -- 
> 1.8.3.1
> 
