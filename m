Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45640495FAD
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 14:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380677AbiAUNTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 08:19:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:30498 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350722AbiAUNTR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 08:19:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642771157; x=1674307157;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=81kYj8Q3Bp9oksI0jvdgUP4BIl1FKvCtcelJN1Doyxo=;
  b=fcn+e7JJlsxCFeXiw7e4ZB+e0n7NIUSdDC79OrrNl+0IUT4OSpVGdnyB
   U8m0fx6mRvfMajhGeEOufhdwSDPAqKSzYdnyObkEQmUsF6r2R5O0GPI17
   qwcNWU5zyXxiavoG3NeLR2fhLWxZGYvhRMXb2DlcEIvbRKgRlckPgQTxs
   OfnhNXjuKTKz8QdSdARyfkJPOqONVeEQU/xEEbPvdb64f6LO2QCUrmKc6
   r9YUeOdlEUY3OVoxcrSD3g/W7GUXroBRhtCDP0NZ8ebtd9EMd+b4tsd3j
   28fA/n4Cb1y6W0Xm2rd/fQiwRzEuJ8vPdRtGBvbUtxdftreZbKReLC09/
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10233"; a="243244256"
X-IronPort-AV: E=Sophos;i="5.88,304,1635231600"; 
   d="scan'208";a="243244256"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2022 05:19:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,304,1635231600"; 
   d="scan'208";a="533271353"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga008.jf.intel.com with ESMTP; 21 Jan 2022 05:19:14 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 20LDJDNU004960;
        Fri, 21 Jan 2022 13:19:13 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, magnus.karlsson@intel.com
Subject: Re: [PATCH bpf-next v3 6/7] ice: xsk: improve AF_XDP ZC Tx and use batching API
Date:   Fri, 21 Jan 2022 14:17:42 +0100
Message-Id: <20220121131742.24424-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220121125447.24039-1-alexandr.lobakin@intel.com>
References: <20220121120011.49316-1-maciej.fijalkowski@intel.com> <20220121120011.49316-7-maciej.fijalkowski@intel.com> <20220121125447.24039-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alexandr.lobakin@intel.com>
Date: Fri, 21 Jan 2022 13:54:47 +0100

> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Date: Fri, 21 Jan 2022 13:00:10 +0100
> 
> > Apply the logic that was done for regular XDP from commit 9610bd988df9
> > ("ice: optimize XDP_TX workloads") to the ZC side of the driver. On top
> > of that, introduce batching to Tx that is inspired by i40e's
> > implementation with adjustments to the cleaning logic - take into the
> > account NAPI budget in ice_clean_xdp_irq_zc().
> > 
> > Separating the stats structs onto separate cache lines seemed to improve
> > the performance.
> > 
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
> >  drivers/net/ethernet/intel/ice/ice_txrx.c |   2 +-
> >  drivers/net/ethernet/intel/ice/ice_txrx.h |   2 +-
> >  drivers/net/ethernet/intel/ice/ice_xsk.c  | 256 ++++++++++++++--------
> >  drivers/net/ethernet/intel/ice/ice_xsk.h  |  27 ++-
> >  4 files changed, 186 insertions(+), 101 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
> > index bfb9158b10a4..7ab8c700c884 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_txrx.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
> > @@ -1463,7 +1463,7 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
> >  		bool wd;
> >  
> >  		if (tx_ring->xsk_pool)
> > -			wd = ice_clean_tx_irq_zc(tx_ring, budget);
> > +			wd = ice_xmit_zc(tx_ring, ICE_DESC_UNUSED(tx_ring), budget);
> >  		else if (ice_ring_is_xdp(tx_ring))
> >  			wd = true;
> >  		else
> > diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
> > index 09c8ad2f7403..191f9b8c50ee 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_txrx.h
> > +++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
> > @@ -322,9 +322,9 @@ struct ice_tx_ring {
> >  	u16 count;			/* Number of descriptors */
> >  	u16 q_index;			/* Queue number of ring */
> >  	/* stats structs */
> > +	struct ice_txq_stats tx_stats;
> >  	struct ice_q_stats	stats;
> >  	struct u64_stats_sync syncp;
> > -	struct ice_txq_stats tx_stats;
> >  
> >  	/* CL3 - 3rd cacheline starts here */
> >  	struct rcu_head rcu;		/* to avoid race on free */
> > diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
> > index 0463fc594d08..4b6e54f75af6 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_xsk.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
> > @@ -671,134 +671,208 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
> >  }
> >  
> >  /**
> > - * ice_xmit_zc - Completes AF_XDP entries, and cleans XDP entries
> > + * ice_clean_xdp_tx_buf - Free and unmap XDP Tx buffer
> >   * @xdp_ring: XDP Tx ring
> > - * @budget: max number of frames to xmit
> > - *
> > - * Returns true if cleanup/transmission is done.
> > + * @tx_buf: Tx buffer to clean
> >   */
> > -static bool ice_xmit_zc(struct ice_tx_ring *xdp_ring, int budget)
> > +static void
> > +ice_clean_xdp_tx_buf(struct ice_tx_ring *xdp_ring, struct ice_tx_buf *tx_buf)
> >  {
> > -	struct ice_tx_desc *tx_desc = NULL;
> > -	bool work_done = true;
> > -	struct xdp_desc desc;
> > -	dma_addr_t dma;
> > -
> > -	while (likely(budget-- > 0)) {
> > -		struct ice_tx_buf *tx_buf;
> > -
> > -		if (unlikely(!ICE_DESC_UNUSED(xdp_ring))) {
> > -			xdp_ring->tx_stats.tx_busy++;
> > -			work_done = false;
> > -			break;
> > -		}
> > +	xdp_return_frame((struct xdp_frame *)tx_buf->raw_buf);
> > +	dma_unmap_single(xdp_ring->dev, dma_unmap_addr(tx_buf, dma),
> > +			 dma_unmap_len(tx_buf, len), DMA_TO_DEVICE);
> > +	dma_unmap_len_set(tx_buf, len, 0);
> > +}
> >  
> > -		tx_buf = &xdp_ring->tx_buf[xdp_ring->next_to_use];
> > +/**
> > + * ice_clean_xdp_irq_zc - Reclaim resources after transmit completes on XDP ring
> > + * @xdp_ring: XDP ring to clean
> > + * @napi_budget: amount of descriptors that NAPI allows us to clean
> > + *
> > + * Returns count of cleaned descriptors
> > + */
> > +static u16 ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring, int napi_budget)
> > +{
> > +	u16 tx_thresh = xdp_ring->tx_thresh;
> > +	int budget = napi_budget / tx_thresh;
> > +	u16 ntc = xdp_ring->next_to_clean;
> > +	struct ice_tx_desc *next_dd_desc;
> 
> @next_dd_desc is used only inside the `do { } while`, can be moved
> there the reduce the scope.
> 
> > +	u16 next_dd = xdp_ring->next_dd;
> > +	u16 desc_cnt = xdp_ring->count;
> > +	struct ice_tx_buf *tx_buf;
> > +	u16 cleared_dds = 0;
> > +	u32 xsk_frames = 0;
> > +	u16 i;
> 
> Same with these 5, from @desc_cnt to @i.
> 
> >  
> > -		if (!xsk_tx_peek_desc(xdp_ring->xsk_pool, &desc))
> > +	do {
> > +		next_dd_desc = ICE_TX_DESC(xdp_ring, next_dd);
> > +		if (!(next_dd_desc->cmd_type_offset_bsz &
> > +		    cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE)))
> >  			break;
> >  
> > -		dma = xsk_buff_raw_get_dma(xdp_ring->xsk_pool, desc.addr);
> > -		xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_pool, dma,
> > -						 desc.len);
> > +		cleared_dds++;
> > +		xsk_frames = 0;
> >  
> > -		tx_buf->bytecount = desc.len;
> > +		for (i = 0; i < tx_thresh; i++) {
> > +			tx_buf = &xdp_ring->tx_buf[ntc];
> >  
> > -		tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_to_use);
> > -		tx_desc->buf_addr = cpu_to_le64(dma);
> > -		tx_desc->cmd_type_offset_bsz =
> > -			ice_build_ctob(ICE_TXD_LAST_DESC_CMD, 0, desc.len, 0);
> > +			if (tx_buf->raw_buf) {
> > +				ice_clean_xdp_tx_buf(xdp_ring, tx_buf);
> > +				tx_buf->raw_buf = NULL;
> > +			} else {
> > +				xsk_frames++;
> > +			}
> >  
> > -		xdp_ring->next_to_use++;
> > -		if (xdp_ring->next_to_use == xdp_ring->count)
> > -			xdp_ring->next_to_use = 0;
> > -	}
> > +			ntc++;
> > +			if (ntc >= xdp_ring->count)
> > +				ntc = 0;
> > +		}
> > +		if (xsk_frames)
> > +			xsk_tx_completed(xdp_ring->xsk_pool, xsk_frames);
> > +		next_dd_desc->cmd_type_offset_bsz = 0;
> > +		next_dd = next_dd + tx_thresh;
> > +		if (next_dd >= desc_cnt)
> > +			next_dd = tx_thresh - 1;
> > +	} while (budget--);
> >  
> > -	if (tx_desc) {
> > -		ice_xdp_ring_update_tail(xdp_ring);
> > -		xsk_tx_release(xdp_ring->xsk_pool);
> > -	}
> > +	xdp_ring->next_to_clean = ntc;
> > +	xdp_ring->next_dd = next_dd;
> >  
> > -	return budget > 0 && work_done;
> > +	return cleared_dds * tx_thresh;
> >  }
> >  
> >  /**
> > - * ice_clean_xdp_tx_buf - Free and unmap XDP Tx buffer
> > - * @xdp_ring: XDP Tx ring
> > - * @tx_buf: Tx buffer to clean
> > + * ice_xmit_pkt - produce a single HW Tx descriptor out of AF_XDP descriptor
> > + * @xdp_ring: XDP ring to produce the HW Tx descriptor on
> > + * @desc: AF_XDP descriptor to pull the DMA address and length from
> > + * @total_bytes: bytes accumulator that will be used for stats update
> >   */
> > -static void
> > -ice_clean_xdp_tx_buf(struct ice_tx_ring *xdp_ring, struct ice_tx_buf *tx_buf)
> > +static void ice_xmit_pkt(struct ice_tx_ring *xdp_ring, struct xdp_desc *desc,
> > +			 unsigned int *total_bytes)
> >  {
> > -	xdp_return_frame((struct xdp_frame *)tx_buf->raw_buf);
> > -	dma_unmap_single(xdp_ring->dev, dma_unmap_addr(tx_buf, dma),
> > -			 dma_unmap_len(tx_buf, len), DMA_TO_DEVICE);
> > -	dma_unmap_len_set(tx_buf, len, 0);
> > +	struct ice_tx_desc *tx_desc;
> > +	dma_addr_t dma;
> > +
> > +	dma = xsk_buff_raw_get_dma(xdp_ring->xsk_pool, desc->addr);
> > +	xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_pool, dma, desc->len);
> > +
> > +	tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_to_use++);
> > +	tx_desc->buf_addr = cpu_to_le64(dma);
> > +	tx_desc->cmd_type_offset_bsz = ice_build_ctob(ICE_TX_DESC_CMD_EOP,
> > +						      0, desc->len, 0);
> > +
> > +	*total_bytes += desc->len;
> >  }
> >  
> >  /**
> > - * ice_clean_tx_irq_zc - Completes AF_XDP entries, and cleans XDP entries
> > - * @xdp_ring: XDP Tx ring
> > - * @budget: NAPI budget
> > - *
> > - * Returns true if cleanup/tranmission is done.
> > + * ice_xmit_pkt_batch - produce a batch of HW Tx descriptors out of AF_XDP descriptors
> > + * @xdp_ring: XDP ring to produce the HW Tx descriptors on
> > + * @descs: AF_XDP descriptors to pull the DMA addresses and lengths from
> > + * @total_bytes: bytes accumulator that will be used for stats update
> >   */
> > -bool ice_clean_tx_irq_zc(struct ice_tx_ring *xdp_ring, int budget)
> > +static void ice_xmit_pkt_batch(struct ice_tx_ring *xdp_ring, struct xdp_desc *descs,
> > +			       unsigned int *total_bytes)
> >  {
> > -	int total_packets = 0, total_bytes = 0;
> > -	s16 ntc = xdp_ring->next_to_clean;
> > +	u16 tx_thresh = xdp_ring->tx_thresh;
> > +	u16 ntu = xdp_ring->next_to_use;
> >  	struct ice_tx_desc *tx_desc;
> > -	struct ice_tx_buf *tx_buf;
> > -	u32 xsk_frames = 0;
> > -	bool xmit_done;
> > +	dma_addr_t dma;
> 
> Same with @dma here.
> 
> > +	u32 i;
> >  
> > -	tx_desc = ICE_TX_DESC(xdp_ring, ntc);
> > -	tx_buf = &xdp_ring->tx_buf[ntc];
> > -	ntc -= xdp_ring->count;
> > +	loop_unrolled_for(i = 0; i < PKTS_PER_BATCH; i++) {
> > +		dma = xsk_buff_raw_get_dma(xdp_ring->xsk_pool, descs[i].addr);
> > +		xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_pool, dma, descs[i].len);
> >  
> > -	do {
> > -		if (!(tx_desc->cmd_type_offset_bsz &
> > -		      cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE)))
> > -			break;
> > +		tx_desc = ICE_TX_DESC(xdp_ring, ntu++);
> > +		tx_desc->buf_addr = cpu_to_le64(dma);
> > +		tx_desc->cmd_type_offset_bsz = ice_build_ctob(ICE_TX_DESC_CMD_EOP,
> > +							      0, descs[i].len, 0);
> >  
> > -		total_bytes += tx_buf->bytecount;
> > -		total_packets++;
> > +		*total_bytes += descs[i].len;
> > +	}
> >  
> > -		if (tx_buf->raw_buf) {
> > -			ice_clean_xdp_tx_buf(xdp_ring, tx_buf);
> > -			tx_buf->raw_buf = NULL;
> > -		} else {
> > -			xsk_frames++;
> > -		}
> > +	xdp_ring->next_to_use = ntu;
> >  
> > -		tx_desc->cmd_type_offset_bsz = 0;
> > -		tx_buf++;
> > -		tx_desc++;
> > -		ntc++;
> > +	if (xdp_ring->next_to_use > xdp_ring->next_rs) {
> > +		tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_rs);
> > +		tx_desc->cmd_type_offset_bsz |=
> > +			cpu_to_le64(ICE_TX_DESC_CMD_RS << ICE_TXD_QW1_CMD_S);
> > +		xdp_ring->next_rs += tx_thresh;
> > +	}
> > +}
> >  
> > -		if (unlikely(!ntc)) {
> > -			ntc -= xdp_ring->count;
> > -			tx_buf = xdp_ring->tx_buf;
> > -			tx_desc = ICE_TX_DESC(xdp_ring, 0);
> > -		}
> > +/**
> > + * ice_fill_tx_hw_ring - produce the number of Tx descriptors onto ring
> > + * @xdp_ring: XDP ring to produce the HW Tx descriptors on
> > + * @descs: AF_XDP descriptors to pull the DMA addresses and lengths from
> > + * @nb_pkts: count of packets to be send
> > + * @total_bytes: bytes accumulator that will be used for stats update
> > + */
> > +static void ice_fill_tx_hw_ring(struct ice_tx_ring *xdp_ring, struct xdp_desc *descs,
> > +				u32 nb_pkts, unsigned int *total_bytes)
> > +{
> > +	u16 tx_thresh = xdp_ring->tx_thresh;
> > +	struct ice_tx_desc *tx_desc;
> 
> And @tx_desc as well.
> 
> > +	u32 batched, leftover, i;
> > +
> > +	batched = nb_pkts & ~(PKTS_PER_BATCH - 1);
> > +	leftover = nb_pkts & (PKTS_PER_BATCH - 1);
> > +	for (i = 0; i < batched; i += PKTS_PER_BATCH)
> > +		ice_xmit_pkt_batch(xdp_ring, &descs[i], total_bytes);
> > +	for (i = batched; i < batched + leftover; i++)

Breh, I overlooked that. @i will equal @batched after exiting the
first loop, so the assignment here is redundant (probably harmless
tho if the compilers are smart enough).

> > +		ice_xmit_pkt(xdp_ring, &descs[i], total_bytes);
> > +
> > +	if (xdp_ring->next_to_use > xdp_ring->next_rs) {
> > +		tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_rs);
> > +		tx_desc->cmd_type_offset_bsz |=
> > +			cpu_to_le64(ICE_TX_DESC_CMD_RS << ICE_TXD_QW1_CMD_S);
> > +		xdp_ring->next_rs += tx_thresh;
> > +	}
> > +}
> >  
> > -		prefetch(tx_desc);
> > +/**
> > + * ice_xmit_zc - take entries from XSK Tx ring and place them onto HW Tx ring
> > + * @xdp_ring: XDP ring to produce the HW Tx descriptors on
> > + * @budget: number of free descriptors on HW Tx ring that can be used
> > + * @napi_budget: amount of descriptors that NAPI allows us to clean
> > + *
> > + * Returns true if there is no more work that needs to be done, false otherwise
> > + */
> > +bool ice_xmit_zc(struct ice_tx_ring *xdp_ring, u32 budget, int napi_budget)
> > +{
> > +	struct xdp_desc *descs = xdp_ring->xsk_pool->tx_descs;
> > +	u16 tx_thresh = xdp_ring->tx_thresh;
> > +	u32 nb_pkts, nb_processed = 0;
> > +	unsigned int total_bytes = 0;
> > +	struct ice_tx_desc *tx_desc;
> 
> And this @tx_desc.
> 
> >  
> > -	} while (likely(--budget));
> > +	if (budget < tx_thresh)
> > +		budget += ice_clean_xdp_irq_zc(xdp_ring, napi_budget);
> > +
> > +	nb_pkts = xsk_tx_peek_release_desc_batch(xdp_ring->xsk_pool, budget);
> > +	if (!nb_pkts)
> > +		return true;
> > +
> > +	if (xdp_ring->next_to_use + nb_pkts >= xdp_ring->count) {
> > +		nb_processed = xdp_ring->count - xdp_ring->next_to_use;
> > +		ice_fill_tx_hw_ring(xdp_ring, descs, nb_processed, &total_bytes);
> > +		tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_rs);
> > +		tx_desc->cmd_type_offset_bsz |=
> > +			cpu_to_le64(ICE_TX_DESC_CMD_RS << ICE_TXD_QW1_CMD_S);
> > +		xdp_ring->next_rs = tx_thresh - 1;
> > +		xdp_ring->next_to_use = 0;
> > +	}
> >  
> > -	ntc += xdp_ring->count;
> > -	xdp_ring->next_to_clean = ntc;
> > +	ice_fill_tx_hw_ring(xdp_ring, &descs[nb_processed], nb_pkts - nb_processed,
> > +			    &total_bytes);
> >  
> > -	if (xsk_frames)
> > -		xsk_tx_completed(xdp_ring->xsk_pool, xsk_frames);
> > +	ice_xdp_ring_update_tail(xdp_ring);
> > +	ice_update_tx_ring_stats(xdp_ring, nb_pkts, total_bytes);
> >  
> >  	if (xsk_uses_need_wakeup(xdp_ring->xsk_pool))
> >  		xsk_set_tx_need_wakeup(xdp_ring->xsk_pool);
> >  
> > -	ice_update_tx_ring_stats(xdp_ring, total_packets, total_bytes);
> > -	xmit_done = ice_xmit_zc(xdp_ring, ICE_DFLT_IRQ_WORK);
> > -
> > -	return budget > 0 && xmit_done;
> > +	return nb_pkts < budget;
> >  }
> >  
> >  /**
> > diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.h b/drivers/net/ethernet/intel/ice/ice_xsk.h
> > index 4c7bd8e9dfc4..0cbb5793b5b8 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_xsk.h
> > +++ b/drivers/net/ethernet/intel/ice/ice_xsk.h
> > @@ -6,19 +6,37 @@
> >  #include "ice_txrx.h"
> >  #include "ice.h"
> >  
> > +#define PKTS_PER_BATCH 8
> > +
> > +#ifdef __clang__
> > +#define loop_unrolled_for _Pragma("clang loop unroll_count(8)") for
> > +#elif __GNUC__ >= 4
> > +#define loop_unrolled_for _Pragma("GCC unroll 8") for
> > +#else
> > +#define loop_unrolled_for for
> > +#endif
> > +
> >  struct ice_vsi;
> >  
> >  #ifdef CONFIG_XDP_SOCKETS
> >  int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool,
> >  		       u16 qid);
> >  int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget);
> > -bool ice_clean_tx_irq_zc(struct ice_tx_ring *xdp_ring, int budget);
> >  int ice_xsk_wakeup(struct net_device *netdev, u32 queue_id, u32 flags);
> >  bool ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count);
> >  bool ice_xsk_any_rx_ring_ena(struct ice_vsi *vsi);
> >  void ice_xsk_clean_rx_ring(struct ice_rx_ring *rx_ring);
> >  void ice_xsk_clean_xdp_ring(struct ice_tx_ring *xdp_ring);
> > +bool ice_xmit_zc(struct ice_tx_ring *xdp_ring, u32 budget, int napi_budget);
> >  #else
> > +static inline bool
> > +ice_xmit_zc(struct ice_tx_ring __always_unused *xdp_ring,
> > +	    u32 __always_unused budget,
> > +	    int __always_unused napi_budget)
> > +{
> > +	return false;
> > +}
> > +
> >  static inline int
> >  ice_xsk_pool_setup(struct ice_vsi __always_unused *vsi,
> >  		   struct xsk_buff_pool __always_unused *pool,
> > @@ -34,13 +52,6 @@ ice_clean_rx_irq_zc(struct ice_rx_ring __always_unused *rx_ring,
> >  	return 0;
> >  }
> >  
> > -static inline bool
> > -ice_clean_tx_irq_zc(struct ice_tx_ring __always_unused *xdp_ring,
> > -		    int __always_unused budget)
> > -{
> > -	return false;
> > -}
> > -
> >  static inline bool
> >  ice_alloc_rx_bufs_zc(struct ice_rx_ring __always_unused *rx_ring,
> >  		     u16 __always_unused count)
> > -- 
> > 2.33.1
> 
> Thanks,
> Al

Al
