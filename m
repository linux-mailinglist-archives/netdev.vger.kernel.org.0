Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E69EA65C33E
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 16:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237465AbjACPqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 10:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233299AbjACPqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 10:46:08 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB542E6
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 07:46:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672760764; x=1704296764;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pHDZpRJBsKyiiBvOjy78jwT6SIV+1h8zBzLocK6uXmQ=;
  b=IdfSPnudDUBNF/X3oQf/jted+K7qCWcDnUXcgFmfAjRYgzPhKueOXT6s
   WcvwlZjvWTTNQJw8aTFn5IZLVb40NDYQ3TgNyGLpR0Wus5eZWMpSKz/vs
   ryCEN+oD1dV3b59r3iHhr+A++BeZcH9+fPvwbwP6lo8iMDHmPOgK5sACW
   jvAIE0KqYNb9I0MqYFjdSEH/64irbiuIf/gj50c3zd6yv33f8LgAZtTTD
   2PhjfwO0U7dat+8HM9kdpULeIWYe3toSrQ+XIDbV3ZOY4Qtt+Z454yM4s
   KCDq7Aa1eKsmDG8FZ1BoQugVab0QhTMgEBT6IOQvIrhqdD5ZbZ2TMkJjx
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="348903348"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="348903348"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2023 07:46:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="685438915"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="685438915"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga008.jf.intel.com with ESMTP; 03 Jan 2023 07:46:01 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 303FjxWc019846;
        Tue, 3 Jan 2023 15:45:59 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     William Tu <u9012063@gmail.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, tuc@vmware.com, gyang@vmware.com,
        doshir@vmware.com, alexander.duyck@gmail.com,
        gerhard@engleder-embedded.com
Subject: Re: [PATCH v8] vmxnet3: Add XDP support.
Date:   Tue,  3 Jan 2023 16:45:46 +0100
Message-Id: <20230103154546.3914544-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103022232.52412-1-u9012063@gmail.com>
References: <20230103022232.52412-1-u9012063@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: William Tu <u9012063@gmail.com>
Date: Mon,  2 Jan 2023 18:22:32 -0800

> The patch adds native-mode XDP support: XDP DROP, PASS, TX, and REDIRECT.

[...]

> @@ -332,9 +333,12 @@ vmxnet3_unmap_tx_buf(struct vmxnet3_tx_buf_info *tbi,
>  	else if (tbi->map_type == VMXNET3_MAP_PAGE)
>  		dma_unmap_page(&pdev->dev, tbi->dma_addr, tbi->len,
>  			       DMA_TO_DEVICE);
> +	else if (tbi->map_type == VMXNET3_MAP_PP_PAGE && tbi->xdpf)
> +		xdp_return_frame(tbi->xdpf);
> +	else if (tbi->map_type == VMXNET3_MAP_XDP_NDO && tbi->xdpf)
> +		xdp_return_frame(tbi->xdpf);

Have you looked at xdp_return_frame_bulk()? It flushes frames in
bulks of 16, so it can be faster here.

Also, those 2 branches do the same stuff, so just squash them into
one with ||.

>  	else
>  		BUG_ON(tbi->map_type != VMXNET3_MAP_NONE);
> -
>  	tbi->map_type = VMXNET3_MAP_NONE; /* to help debugging */
>  }

[...]

> @@ -1253,6 +1266,46 @@ vmxnet3_tq_xmit(struct sk_buff *skb, struct vmxnet3_tx_queue *tq,
>  	return NETDEV_TX_OK;
>  }
>  
> +static int
> +vmxnet3_create_pp(struct vmxnet3_adapter *adapter,
> +		  struct vmxnet3_rx_queue *rq, int size)
> +{
> +	struct page_pool_params pp_params = {

const?

> +		.order = 0,
> +		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
> +		.pool_size = size,
> +		.nid = NUMA_NO_NODE,
> +		.dev = &adapter->pdev->dev,
> +		.offset = XDP_PACKET_HEADROOM,
> +		.max_len = VMXNET3_XDP_MAX_MTU,
> +		.dma_dir = DMA_BIDIRECTIONAL,
> +	};
> +	struct page_pool *pp;
> +	int err;
> +
> +	pp = page_pool_create(&pp_params);
> +	if (IS_ERR(pp))
> +		return PTR_ERR(pp);

[...]

> +static void
> +vmxnet3_pp_put_buff(struct vmxnet3_rx_queue *rq, struct page *page)
> +{
> +	if (rq->page_pool)
> +		page_pool_put_full_page(rq->page_pool, page,
> +					rq->napi.napi_id);

Wait, ::napi_id as `bool allow_direct`? Is that intentional (if so,
a short comment would be useful here)?

> +}
>  
>  static void
>  vmxnet3_rx_csum(struct vmxnet3_adapter *adapter,

[...]

> @@ -1485,9 +1586,7 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
>  
>  			if (rxDataRingUsed) {
>  				size_t sz;
> -
>  				BUG_ON(rcd->len > rq->data_ring.desc_size);
> -

??? Why are those 2 nl removals here? The code looks prettier with
them and they are not related to the patch subject.

>  				ctx->skb = new_skb;
>  				sz = rcd->rxdIdx * rq->data_ring.desc_size;
>  				memcpy(new_skb->data,

[...]

> @@ -1730,6 +1829,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
>  		vmxnet3_getRxComp(rcd,
>  				  &rq->comp_ring.base[rq->comp_ring.next2proc].rcd, &rxComp);
>  	}
> +	if (need_flush)
> +		xdp_do_flush_map();

From [0]:

"do not use xdp_do_flush_map() in new code!"
"#define xdp_do_flush_map xdp_do_flush"

>  
>  	return num_pkts;
>  }
> @@ -1753,8 +1854,14 @@ vmxnet3_rq_cleanup(struct vmxnet3_rx_queue *rq,
>  #endif
>  			vmxnet3_getRxDesc(rxd,
>  				&rq->rx_ring[ring_idx].base[i].rxd, &rxDesc);
> -

Also '???'.

>  			if (rxd->btype == VMXNET3_RXD_BTYPE_HEAD &&
> +			    rq->buf_info[ring_idx][i].pp_page &&
> +			    rq->buf_info[ring_idx][i].buf_type ==
> +							VMXNET3_RX_BUF_XDP) {

Please align that line to the opening brace, just like the previous
ones.

> +				vmxnet3_pp_put_buff(rq,
> +						    rq->buf_info[ring_idx][i].pp_page);
> +				rq->buf_info[ring_idx][i].pp_page = NULL;
> +			} else if (rxd->btype == VMXNET3_RXD_BTYPE_HEAD &&
>  					rq->buf_info[ring_idx][i].skb) {

Could you maybe align that one too while at it?

>  				dma_unmap_single(&adapter->pdev->dev, rxd->addr,
>  						 rxd->len, DMA_FROM_DEVICE);

[...]

> @@ -1858,14 +1972,15 @@ static int
>  vmxnet3_rq_init(struct vmxnet3_rx_queue *rq,
>  		struct vmxnet3_adapter  *adapter)
>  {
> -	int i;
> +	int i, err = 0;

That assignment to zero is redundant I believe, you use that var
only to store the return value of vmxnet3_create_pp() and return
it in place, so there are no ways to use that zero value.

>  
>  	/* initialize buf_info */
>  	for (i = 0; i < rq->rx_ring[0].size; i++) {

[...]

> @@ -2585,7 +2707,8 @@ vmxnet3_setup_driver_shared(struct vmxnet3_adapter *adapter)
>  	if (adapter->netdev->features & NETIF_F_RXCSUM)
>  		devRead->misc.uptFeatures |= UPT1_F_RXCSUM;
>  
> -	if (adapter->netdev->features & NETIF_F_LRO) {
> +	if (adapter->netdev->features & NETIF_F_LRO &&

I'd recommend to enclose bitwise ops in their own set of braces ()
when there are logical ops nearby, some compilers even warn about
that in some cases.

> +	    !adapter->xdp_enabled) {
>  		devRead->misc.uptFeatures |= UPT1_F_LRO;
>  		devRead->misc.maxNumRxSG = cpu_to_le16(1 + MAX_SKB_FRAGS);
>  	}

[...]

> @@ -3900,6 +4025,7 @@ vmxnet3_probe_device(struct pci_dev *pdev,
>  		goto err_register;
>  	}
>  
> +	adapter->xdp_enabled = false;

alloc_etherdev_mq() (-> alloc_netdev_mqs()) allocates a zeroed
memory chunk, so this is redundant.

>  	vmxnet3_check_link(adapter, false);
>  	return 0;

[...]

> @@ -201,6 +206,7 @@ struct vmxnet3_tx_buf_info {
>  	u16      sop_idx;
>  	dma_addr_t  dma_addr;
>  	struct sk_buff *skb;
> +	struct xdp_frame *xdpf;

How about a union with those two? They're mutually exclusive, aren't
they?

>  };
>  
>  struct vmxnet3_tq_driver_stats {

[...]

> @@ -307,6 +324,8 @@ struct vmxnet3_rx_queue {
>  	struct vmxnet3_rx_buf_info     *buf_info[2];
>  	struct Vmxnet3_RxQueueCtrl            *shared;
>  	struct vmxnet3_rq_driver_stats  stats;
> +	struct xdp_rxq_info xdp_rxq;

&xdp_rxq_info is cacheline-aligned and is big enough, they are
usually placed at the end of a queue structure.

> +	struct page_pool *page_pool;
>  } __attribute__((__aligned__(SMP_CACHE_BYTES)));

(unrelated) -> ____cacheline_aligned

>  
>  #define VMXNET3_DEVICE_MAX_TX_QUEUES 32
> @@ -415,6 +434,8 @@ struct vmxnet3_adapter {
>  	u16    tx_prod_offset;
>  	u16    rx_prod_offset;
>  	u16    rx_prod2_offset;
> +	bool   xdp_enabled;

Nit: consider introducing something like

	u32 xdp_enabled:1;

or

	u32 flags;
#define VMXNET3_XDP_ENABLED BIT(0)

or whatever prefer. bools are slippery to use in structures (you'd
also save 31 bits for more flags in future instead of occupying 8-32
bits for just one flag).

> +	struct bpf_prog __rcu *xdp_bpf_prog;

Or maybe you could omit the flag above completely and check whether
XDP is enabled via `!!rcu_access_pointer(ring->xdp_bpf_prog)`?

>  };
>  
>  #define VMXNET3_WRITE_BAR0_REG(adapter, reg, val)  \

[...]

> +static void
> +vmxnet3_xdp_exchange_program(struct vmxnet3_adapter *adapter,
> +			     struct bpf_prog *prog)
> +{
> +	rcu_assign_pointer(adapter->xdp_bpf_prog, prog);
> +	if (prog)
> +		adapter->xdp_enabled = true;
> +	else
> +		adapter->xdp_enabled = false;

	adapter->xdp_enabled = !!prog;

> +}
> +
> +static int
> +vmxnet3_xdp_set(struct net_device *netdev, struct netdev_bpf *bpf,
> +		struct netlink_ext_ack *extack)
> +{
> +	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
> +	struct bpf_prog *new_bpf_prog = bpf->prog;
> +	struct bpf_prog *old_bpf_prog;
> +	bool need_update;
> +	bool running;
> +	int err = 0;
> +
> +	if (new_bpf_prog && netdev->mtu > VMXNET3_XDP_MAX_MTU) {
> +		NL_SET_ERR_MSG_MOD(extack, "MTU too large for XDP");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	old_bpf_prog = READ_ONCE(adapter->rx_queue[0].adapter->xdp_bpf_prog);

Doesn't the @adapter variable above points to the same struct you
are accessing here?

> +	if (!new_bpf_prog && !old_bpf_prog) {
> +		adapter->xdp_enabled = false;
> +		return 0;
> +	}
> +	running = netif_running(netdev);
> +	need_update = !!old_bpf_prog != !!new_bpf_prog;
> +
> +	if (running && need_update)
> +		vmxnet3_quiesce_dev(adapter);
> +
> +	vmxnet3_xdp_exchange_program(adapter, new_bpf_prog);
> +	if (old_bpf_prog)
> +		bpf_prog_put(old_bpf_prog);
> +
> +	if (running && need_update) {

	if (!running || !need_update)
		return 0;

-1 indent level.

> +		vmxnet3_reset_dev(adapter);
> +		vmxnet3_rq_destroy_all(adapter);
> +		vmxnet3_adjust_rx_ring_size(adapter);
> +		err = vmxnet3_rq_create_all(adapter);
> +		if (err) {
> +			NL_SET_ERR_MSG_MOD(extack,
> +				"failed to re-create rx queues for XDP.");
> +			err = -EOPNOTSUPP;
> +			goto out;
> +		}
> +		err = vmxnet3_activate_dev(adapter);
> +		if (err) {
> +			NL_SET_ERR_MSG_MOD(extack,
> +				"failed to activate device for XDP.");
> +			err = -EOPNOTSUPP;
> +			goto out;
> +		}
> +		clear_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state);
> +	}
> +out:
> +	return err;

Please avoid oneliner labels, you can do `return err` right where
you goto here.

> +}
> +
> +/* This is the main xdp call used by kernel to set/unset eBPF program. */
> +int
> +vmxnet3_xdp(struct net_device *netdev, struct netdev_bpf *bpf)
> +{
> +	switch (bpf->command) {
> +	case XDP_SETUP_PROG:
> +		netdev_dbg(netdev, "XDP: set program to ");

Is it still relevant?

> +		return vmxnet3_xdp_set(netdev, bpf, bpf->extack);
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +int
> +vmxnet3_xdp_headroom(struct vmxnet3_adapter *adapter)
> +{
> +	if (adapter->xdp_enabled)
> +		return VMXNET3_XDP_ROOM;

This is confusing. %VMXNET3_XDP_ROOM includes &skb_shared_info's
size. So the function returns not a headroom, rather kernel (XDP +
skb) overhead.

> +	else
> +		return 0;

	return adapter->xdp_enabled ? VMXNET3_XDP_ROOM : 0;

> +}
> +

Those two functions:

/start

> +void
> +vmxnet3_unregister_xdp_rxq(struct vmxnet3_rx_queue *rq)
> +{
> +	xdp_rxq_info_unreg_mem_model(&rq->xdp_rxq);
> +	xdp_rxq_info_unreg(&rq->xdp_rxq);
> +}
> +
> +int
> +vmxnet3_register_xdp_rxq(struct vmxnet3_rx_queue *rq,
> +			 struct vmxnet3_adapter *adapter)
> +{
> +	int err;
> +
> +	err = xdp_rxq_info_reg(&rq->xdp_rxq, adapter->netdev, rq->qid, 0);
> +	if (err < 0)
> +		return err;
> +
> +	err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq, MEM_TYPE_PAGE_SHARED,
> +					 NULL);
> +	if (err < 0) {
> +		xdp_rxq_info_unreg(&rq->xdp_rxq);
> +		return err;
> +	}
> +	return 0;
> +}

/end

are not used anywhere, probably leftovers.

> +
> +static int
> +vmxnet3_xdp_xmit_frame(struct vmxnet3_adapter *adapter,
> +		       struct xdp_frame *xdpf,
> +		       struct vmxnet3_tx_queue *tq, bool dma_map)
> +{
> +	struct vmxnet3_tx_buf_info *tbi = NULL;
> +	union Vmxnet3_GenericDesc *gdesc;
> +	struct vmxnet3_tx_ctx ctx;
> +	int tx_num_deferred;
> +	struct page *page;
> +	u32 buf_size;
> +	int ret = 0;
> +	u32 dw2;
> +
> +	dw2 = (tq->tx_ring.gen ^ 0x1) << VMXNET3_TXD_GEN_SHIFT;
> +	dw2 |= xdpf->len;

Consider using FIELD_{GET,PREP}() in future for bitfields.

> +	ctx.sop_txd = tq->tx_ring.base + tq->tx_ring.next2fill;
> +	gdesc = ctx.sop_txd;
> +
> +	buf_size = xdpf->len;
> +	tbi = tq->buf_info + tq->tx_ring.next2fill;
> +
> +	if (vmxnet3_cmd_ring_desc_avail(&tq->tx_ring) == 0) {
> +		tq->stats.tx_ring_full++;
> +		ret = -ENOSPC;
> +		goto exit;
> +	}
> +
> +	if (dma_map) { /* ndo_xdp_xmit */
> +		tbi->map_type = VMXNET3_MAP_XDP_NDO;
> +		tbi->dma_addr = dma_map_single(&adapter->pdev->dev,
> +				       xdpf->data, buf_size,
> +				       DMA_TO_DEVICE);

Bad indent, pls align to the opening braces.

> +		if (dma_mapping_error(&adapter->pdev->dev, tbi->dma_addr)) {
> +			ret = -EFAULT;
> +			goto exit;
> +		}
> +		tbi->xdpf = xdpf;
> +	} else { /* XDP buffer from page pool */
> +		tbi->map_type = VMXNET3_MAP_PP_PAGE;
> +		page = virt_to_head_page(xdpf->data);
> +		tbi->dma_addr = page_pool_get_dma_addr(page) +
> +				XDP_PACKET_HEADROOM;
> +		dma_sync_single_for_device(&adapter->pdev->dev,
> +					   tbi->dma_addr, buf_size,
> +					   DMA_BIDIRECTIONAL);
> +		tbi->skb = NULL;
> +		tbi->xdpf = xdpf;
> +	}
> +	tbi->len = buf_size;
> +
> +	gdesc = tq->tx_ring.base + tq->tx_ring.next2fill;
> +	WARN_ON_ONCE(gdesc->txd.gen == tq->tx_ring.gen);
> +
> +	gdesc->txd.addr = cpu_to_le64(tbi->dma_addr);
> +	gdesc->dword[2] = cpu_to_le32(dw2);
> +
> +	/* Setup the EOP desc */
> +	gdesc->dword[3] = cpu_to_le32(VMXNET3_TXD_CQ | VMXNET3_TXD_EOP);
> +
> +	gdesc->txd.om = 0;
> +	gdesc->txd.msscof = 0;
> +	gdesc->txd.hlen = 0;
> +	gdesc->txd.ti = 0;
> +
> +	tx_num_deferred = le32_to_cpu(tq->shared->txNumDeferred);
> +	tq->shared->txNumDeferred += 1;

::txNum_Deferred is __le32, are you sure you can just do += 1
without any conversion?

> +	tx_num_deferred++;
> +
> +	vmxnet3_cmd_ring_adv_next2fill(&tq->tx_ring);
> +
> +	/* set the last buf_info for the pkt */
> +	tbi->sop_idx = ctx.sop_txd - tq->tx_ring.base;
> +
> +	dma_wmb();
> +	gdesc->dword[2] = cpu_to_le32(le32_to_cpu(gdesc->dword[2]) ^
> +						  VMXNET3_TXD_GEN);

le32_replace_bits()

(it's generated by a macro, so Elixir doesn't index it. Just look at
 the end of <linux/bitfield.h> if you'd like to use it)

> +	if (tx_num_deferred >= le32_to_cpu(tq->shared->txThreshold)) {
> +		tq->shared->txNumDeferred = 0;
> +		VMXNET3_WRITE_BAR0_REG(adapter,
> +				       VMXNET3_REG_TXPROD + tq->qid * 8,
> +				       tq->tx_ring.next2fill);
> +	}
> +exit:
> +	return ret;

Same as a bunch of lines above for oneliner labels.

> +}
> +
> +static int
> +vmxnet3_xdp_xmit_back(struct vmxnet3_adapter *adapter,
> +		      struct xdp_frame *xdpf)
> +{
> +	struct vmxnet3_tx_queue *tq;
> +	struct netdev_queue *nq;
> +	int err = 0, cpu;
> +	int tq_number;
> +
> +	tq_number = adapter->num_tx_queues;
> +	cpu = smp_processor_id();
> +	tq = &adapter->tx_queue[cpu % tq_number];
> +	if (tq->stopped)
> +		return -ENETDOWN;
> +
> +	nq = netdev_get_tx_queue(adapter->netdev, tq->qid);
> +
> +	__netif_tx_lock(nq, cpu);
> +	err = vmxnet3_xdp_xmit_frame(adapter, xdpf, tq, false);
> +	__netif_tx_unlock(nq);
> +	return err;
> +}
> +
> +/* ndo_xdp_xmit */
> +int
> +vmxnet3_xdp_xmit(struct net_device *dev,
> +		 int n, struct xdp_frame **frames, u32 flags)
> +{
> +	struct vmxnet3_adapter *adapter;
> +	struct vmxnet3_tx_queue *tq;
> +	struct netdev_queue *nq;
> +	int i, err, cpu;
> +	int tq_number;
> +
> +	adapter = netdev_priv(dev);
> +
> +	if (unlikely(test_bit(VMXNET3_STATE_BIT_QUIESCED, &adapter->state)))
> +		return -ENETDOWN;
> +	if (unlikely(test_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state)))
> +		return -EINVAL;
> +
> +	tq_number = adapter->num_tx_queues;
> +	cpu = smp_processor_id();
> +	tq = &adapter->tx_queue[cpu % tq_number];
> +	if (tq->stopped)
> +		return -ENETDOWN;
> +
> +	nq = netdev_get_tx_queue(adapter->netdev, tq->qid);
> +
> +	for (i = 0; i < n; i++) {
> +		err = vmxnet3_xdp_xmit_frame(adapter, frames[i], tq, true);
> +		if (err) {
> +			tq->stats.xdp_xmit_err++;
> +			break;
> +		}
> +	}
> +	tq->stats.xdp_xmit += i;
> +
> +	return i;
> +}
> +
> +static int
> +vmxnet3_run_xdp(struct vmxnet3_rx_queue *rq, struct xdp_buff *xdp)
> +{
> +	struct xdp_frame *xdpf;
> +	int err;
> +	u32 act;
> +
> +	act = bpf_prog_run_xdp(rq->adapter->xdp_bpf_prog, xdp);
> +	rq->stats.xdp_packets++;
> +
> +	switch (act) {
> +	case XDP_PASS:
> +		goto out;

Same. Just `return act` here.

> +	case XDP_REDIRECT:
> +		err = xdp_do_redirect(rq->adapter->netdev, xdp,
> +				      rq->adapter->xdp_bpf_prog);
> +		if (!err)
> +			rq->stats.xdp_redirects++;
> +		else
> +			rq->stats.xdp_drops++;
> +		goto out;

Same here and probably a couple times below as well.

> +	case XDP_TX:
> +		xdpf = xdp_convert_buff_to_frame(xdp);
> +		if (!xdpf || vmxnet3_xdp_xmit_back(rq->adapter, xdpf)) {
> +			rq->stats.xdp_drops++;
> +			goto out_recycle;

So that label is used only once and you could probably inline it
into here.

> +		}
> +		rq->stats.xdp_tx++;
> +		goto out;
> +	default:
> +		bpf_warn_invalid_xdp_action(rq->adapter->netdev,
> +					    rq->adapter->xdp_bpf_prog, act);
> +		fallthrough;
> +	case XDP_ABORTED:
> +		trace_xdp_exception(rq->adapter->netdev,
> +				    rq->adapter->xdp_bpf_prog, act);
> +		rq->stats.xdp_aborted++;
> +		break;
> +	case XDP_DROP:
> +		rq->stats.xdp_drops++;
> +		break;
> +	}
> +
> +out_recycle:
> +	page_pool_recycle_direct(rq->page_pool,
> +				 virt_to_head_page(xdp->data_hard_start));
> +out:
> +	return act;
> +}
> +
> +static struct sk_buff *
> +vmxnet3_build_skb(struct vmxnet3_rx_queue *rq, struct page *page)
> +{
> +	struct sk_buff *skb;
> +
> +	if (!page)
> +		return NULL;
> +
> +	skb = build_skb(page_address(page), PAGE_SIZE);
> +	if (unlikely(!skb)) {
> +		page_pool_put_full_page(rq->page_pool, page, true);
> +		rq->stats.rx_buf_alloc_failure++;
> +		return NULL;
> +	}
> +	return skb;
> +}
> +
> +int
> +vmxnet3_process_xdp(struct vmxnet3_adapter *adapter,
> +		    struct vmxnet3_rx_queue *rq,
> +		    struct Vmxnet3_RxCompDesc *rcd,
> +		    struct vmxnet3_rx_buf_info *rbi,
> +		    struct Vmxnet3_RxDesc *rxd,
> +		    struct sk_buff **skb_xdp_pass)
> +{
> +	struct bpf_prog *xdp_prog;
> +	dma_addr_t new_dma_addr;
> +	struct sk_buff *skb;
> +	struct xdp_buff xdp;
> +	struct page *page;
> +	void *new_data;
> +	int act;
> +
> +	act = XDP_DROP;
> +	if (unlikely(rcd->len == 0))
> +		goto refill;
> +
> +	page = rbi->pp_page;
> +	if (!page)
> +		goto refill;
> +
> +	dma_sync_single_for_cpu(&adapter->pdev->dev,
> +				page_pool_get_dma_addr(page) +
> +				XDP_PACKET_HEADROOM,
> +				rcd->len,

Can fit into the previous line.

> +				page_pool_get_dma_dir(rq->page_pool));
> +
> +	xdp_init_buff(&xdp, rbi->len, &rq->xdp_rxq);
> +	xdp_prepare_buff(&xdp, page_address(page), XDP_PACKET_HEADROOM,
> +			 rcd->len, false);
> +	xdp_buff_clear_frags_flag(&xdp);
> +
> +	rcu_read_lock();
> +	xdp_prog = rcu_dereference(rq->adapter->xdp_bpf_prog);
> +	if (!xdp_prog) {
> +		rcu_read_unlock();
> +		act = XDP_PASS;
> +		goto refill;
> +	}
> +	act = vmxnet3_run_xdp(rq, &xdp);
> +	rcu_read_unlock();
> +
> +	if (act == XDP_PASS) {
> +		skb = vmxnet3_build_skb(rq, page);
> +		if (!skb) {
> +			rq->stats.rx_buf_alloc_failure++;
> +			page_pool_recycle_direct(rq->page_pool, page);
> +			goto refill;
> +		}
> +
> +		/* bpf prog might change len and data position. */
> +		skb_reserve(skb, xdp.data - xdp.data_hard_start);
> +		skb_put(skb, xdp.data_end - xdp.data);
> +		skb_mark_for_recycle(skb);
> +		/* Pass this skb to the main rx loop. */
> +		*skb_xdp_pass = skb;
> +	}
> +
> +refill:
> +	new_data = vmxnet3_pp_get_buff(rq->page_pool, &new_dma_addr,
> +				       GFP_KERNEL);

This code is being run in the softirq context, you can't use
%GFP_KERNEL here, only %GFP_ATOMIC.

> +	if (!new_data) {
> +		rq->stats.rx_buf_alloc_failure++;
> +		return XDP_DROP;
> +	}
> +	rbi->pp_page = virt_to_head_page(new_data);
> +	rbi->dma_addr = new_dma_addr;
> +	rxd->addr = cpu_to_le64(rbi->dma_addr);
> +	rxd->len = rbi->len;
> +	return act;
> +}
> diff --git a/drivers/net/vmxnet3/vmxnet3_xdp.h b/drivers/net/vmxnet3/vmxnet3_xdp.h
> new file mode 100644
> index 000000000000..cac4c9b82c93
> --- /dev/null
> +++ b/drivers/net/vmxnet3/vmxnet3_xdp.h
> @@ -0,0 +1,39 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later
> + *
> + * Linux driver for VMware's vmxnet3 ethernet NIC.
> + * Copyright (C) 2008-2023, VMware, Inc. All Rights Reserved.
> + * Maintained by: pv-drivers@vmware.com
> + *
> + */
> +
> +#ifndef _VMXNET3_XDP_H
> +#define _VMXNET3_XDP_H
> +
> +#include <linux/filter.h>
> +#include <linux/bpf_trace.h>
> +#include <linux/netlink.h>
> +#include <net/page_pool.h>
> +#include <net/xdp.h>
> +
> +#include "vmxnet3_int.h"
> +
> +#define VMXNET3_XDP_ROOM (SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) + \
> +				XDP_PACKET_HEADROOM)

Please aling to the opening braces.

> +#define VMXNET3_XDP_MAX_MTU (PAGE_SIZE - VMXNET3_XDP_ROOM)
> +
> +int vmxnet3_xdp(struct net_device *netdev, struct netdev_bpf *bpf);
> +void vmxnet3_unregister_xdp_rxq(struct vmxnet3_rx_queue *rq);
> +int vmxnet3_register_xdp_rxq(struct vmxnet3_rx_queue *rq,
> +			     struct vmxnet3_adapter *adapter);
> +int vmxnet3_xdp_headroom(struct vmxnet3_adapter *adapter);
> +int vmxnet3_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
> +		     u32 flags);
> +int vmxnet3_process_xdp(struct vmxnet3_adapter *adapter,
> +			struct vmxnet3_rx_queue *rq,
> +			struct Vmxnet3_RxCompDesc *rcd,
> +			struct vmxnet3_rx_buf_info *rbi,
> +			struct Vmxnet3_RxDesc *rxd,
> +			struct sk_buff **skb_xdp_pass);
> +void *vmxnet3_pp_get_buff(struct page_pool *pp, dma_addr_t *dma_addr,
> +			  gfp_t gfp_mask);
> +#endif
> -- 
> 2.25.1

[0] https://elixir.bootlin.com/linux/v6.2-rc2/source/include/linux/filter.h#L992

Thanks,
Olek
