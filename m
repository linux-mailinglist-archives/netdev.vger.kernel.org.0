Return-Path: <netdev+bounces-3737-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B37D708793
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 20:11:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5755E280E87
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 18:11:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54D00134CB;
	Thu, 18 May 2023 18:06:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469E7134A3;
	Thu, 18 May 2023 18:06:54 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8919E8F;
	Thu, 18 May 2023 11:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684433212; x=1715969212;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aToO0/P/ZU91nnEI/iiSVVTAbt6SZF0tokSZtJLAf3Q=;
  b=UGtvVgmnRLL2kq83yUJzjZXPSdlr3jkAfhUcTsDzJ//bvtgSmexKTado
   x9kXp3a2C9QtgIMU0Dine+u4BAkbJAGsMLk0Qlricz9ujsfVLEICYipWs
   SSLsTczPhaBUjgTZ5ULG+b2CW3g7L5EMUA58Ot9M1t+k9/hIiw7PA+5y0
   fzddErpK4cyVpLChkknWFYAhP/QqEruSUvzboQ2wXgvsCQsjdmFvgaUQo
   nGWWJUHMIN11cMcG8CPtDLjXl3GvQ1qwzRCTuFd98tMVdGhiUM9PUPSjU
   EdQe0Su4fa4sWxUc2tMYT/ZWkFTcgVncrF7p8aSsiVRxHusAQH2wWI74/
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="350984954"
X-IronPort-AV: E=Sophos;i="6.00,174,1681196400"; 
   d="scan'208";a="350984954"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 11:06:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="948780462"
X-IronPort-AV: E=Sophos;i="6.00,174,1681196400"; 
   d="scan'208";a="948780462"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga006.fm.intel.com with ESMTP; 18 May 2023 11:06:18 -0700
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: bpf@vger.kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org
Cc: netdev@vger.kernel.org,
	magnus.karlsson@intel.com,
	tirthendu.sarkar@intel.com,
	maciej.fijalkowski@intel.com,
	bjorn@kernel.org
Subject: [PATCH bpf-next 11/21] ice: xsk: add RX multi-buffer support
Date: Thu, 18 May 2023 20:05:35 +0200
Message-Id: <20230518180545.159100-12-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230518180545.159100-1-maciej.fijalkowski@intel.com>
References: <20230518180545.159100-1-maciej.fijalkowski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This support is strongly inspired by work that introduced multi-buffer
support to regular Rx data path in ice. There are some differences,
though. When adding a frag, besides adding it to skb_shared_info, use
also fresh xsk_buff_add_frag() helper. Reason for doing both things is
that we can not rule out the fact that AF_XDP pipeline could use XDP
program that needs to access frame fragments. Without them being in
skb_shared_info it will not be possible. Another difference is that
XDP_PASS has to allocate a new pages for each frags and copy contents
from memory backed by xsk_buff_pool.

chain_len that is used for programming HW Rx descriptors no longer has
to be limited to 1 when xsk_pool is present - remove this restriction.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c |   9 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 136 ++++++++++++++++------
 2 files changed, 102 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 1911d644dfa8..b790e3d6be6f 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -366,7 +366,6 @@ static unsigned int ice_rx_offset(struct ice_rx_ring *rx_ring)
  */
 static int ice_setup_rx_ctx(struct ice_rx_ring *ring)
 {
-	int chain_len = ICE_MAX_CHAINED_RX_BUFS;
 	struct ice_vsi *vsi = ring->vsi;
 	u32 rxdid = ICE_RXDID_FLEX_NIC;
 	struct ice_rlan_ctx rlan_ctx;
@@ -430,17 +429,11 @@ static int ice_setup_rx_ctx(struct ice_rx_ring *ring)
 	 */
 	rlan_ctx.showiv = 0;
 
-	/* For AF_XDP ZC, we disallow packets to span on
-	 * multiple buffers, thus letting us skip that
-	 * handling in the fast-path.
-	 */
-	if (ring->xsk_pool)
-		chain_len = 1;
 	/* Max packet size for this queue - must not be set to a larger value
 	 * than 5 x DBUF
 	 */
 	rlan_ctx.rxmax = min_t(u32, vsi->max_frame,
-			       chain_len * ring->rx_buf_len);
+			       ICE_MAX_CHAINED_RX_BUFS * ring->rx_buf_len);
 
 	/* Rx queue threshold in units of 64 */
 	rlan_ctx.lrxqthresh = 1;
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index d1e489da7363..920cf2b16836 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -548,19 +548,6 @@ bool ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count)
 	return __ice_alloc_rx_bufs_zc(rx_ring, leftover);
 }
 
-/**
- * ice_bump_ntc - Bump the next_to_clean counter of an Rx ring
- * @rx_ring: Rx ring
- */
-static void ice_bump_ntc(struct ice_rx_ring *rx_ring)
-{
-	int ntc = rx_ring->next_to_clean + 1;
-
-	ntc = (ntc < rx_ring->count) ? ntc : 0;
-	rx_ring->next_to_clean = ntc;
-	prefetch(ICE_RX_DESC(rx_ring, ntc));
-}
-
 /**
  * ice_construct_skb_zc - Create an sk_buff from zero-copy buffer
  * @rx_ring: Rx ring
@@ -575,8 +562,14 @@ ice_construct_skb_zc(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp)
 {
 	unsigned int totalsize = xdp->data_end - xdp->data_meta;
 	unsigned int metasize = xdp->data - xdp->data_meta;
+	struct skb_shared_info *sinfo = NULL;
 	struct sk_buff *skb;
+	u32 nr_frags = 0;
 
+	if (unlikely(xdp_buff_has_frags(xdp))) {
+		sinfo = xdp_get_shared_info_from_buff(xdp);
+		nr_frags = sinfo->nr_frags;
+	}
 	net_prefetch(xdp->data_meta);
 
 	skb = __napi_alloc_skb(&rx_ring->q_vector->napi, totalsize,
@@ -592,6 +585,29 @@ ice_construct_skb_zc(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp)
 		__skb_pull(skb, metasize);
 	}
 
+	if (likely(!xdp_buff_has_frags(xdp)))
+		goto out;
+
+	for (int i = 0; i < nr_frags; i++) {
+		struct skb_shared_info *skinfo = skb_shinfo(skb);
+		skb_frag_t *frag = &sinfo->frags[i];
+		struct page *page;
+		void *addr;
+
+		page = dev_alloc_page();
+		if (!page) {
+			dev_kfree_skb(skb);
+			return NULL;
+		}
+		addr = page_to_virt(page);
+
+		memcpy(addr, skb_frag_page(frag), skb_frag_size(frag));
+
+		__skb_fill_page_desc_noacc(skinfo, skinfo->nr_frags++,
+					   addr, 0, skb_frag_size(frag));
+	}
+
+out:
 	xsk_buff_free(xdp);
 	return skb;
 }
@@ -755,6 +771,34 @@ ice_run_xdp_zc(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
 	return result;
 }
 
+static int
+ice_add_xsk_frag(struct ice_rx_ring *rx_ring, struct xdp_buff *first,
+		 struct xdp_buff *xdp, const unsigned int size)
+{
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(first);
+
+	if (!size)
+		return 0;
+
+	if (!xdp_buff_has_frags(first)) {
+		sinfo->nr_frags = 0;
+		sinfo->xdp_frags_size = 0;
+		xdp_buff_set_frags_flag(first);
+	}
+
+	if (unlikely(sinfo->nr_frags == MAX_SKB_FRAGS)) {
+		xsk_buff_free(first);
+		return -ENOMEM;
+	}
+
+	__skb_fill_page_desc_noacc(sinfo, sinfo->nr_frags++,
+				   virt_to_page(xdp->data_hard_start), 0, size);
+	sinfo->xdp_frags_size += size;
+	xsk_buff_add_frag(first, xdp);
+
+	return 0;
+}
+
 /**
  * ice_clean_rx_irq_zc - consumes packets from the hardware ring
  * @rx_ring: AF_XDP Rx ring
@@ -765,9 +809,14 @@ ice_run_xdp_zc(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
 int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 {
 	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
+	struct xsk_buff_pool *xsk_pool = rx_ring->xsk_pool;
+	u32 ntc = rx_ring->next_to_clean;
+	u32 ntu = rx_ring->next_to_use;
+	struct xdp_buff *first = NULL;
 	struct ice_tx_ring *xdp_ring;
 	unsigned int xdp_xmit = 0;
 	struct bpf_prog *xdp_prog;
+	u32 cnt = rx_ring->count;
 	bool failure = false;
 	int entries_to_alloc;
 
@@ -777,6 +826,9 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
 	xdp_ring = rx_ring->xdp_ring;
 
+	if (ntc != rx_ring->first_desc)
+		first = *ice_xdp_buf(rx_ring, rx_ring->first_desc);
+
 	while (likely(total_rx_packets < (unsigned int)budget)) {
 		union ice_32b_rx_flex_desc *rx_desc;
 		unsigned int size, xdp_res = 0;
@@ -786,7 +838,7 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 		u16 vlan_tag = 0;
 		u16 rx_ptype;
 
-		rx_desc = ICE_RX_DESC(rx_ring, rx_ring->next_to_clean);
+		rx_desc = ICE_RX_DESC(rx_ring, ntc);
 
 		stat_err_bits = BIT(ICE_RX_FLEX_DESC_STATUS0_DD_S);
 		if (!ice_test_staterr(rx_desc->wb.status_error0, stat_err_bits))
@@ -798,51 +850,61 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 		 */
 		dma_rmb();
 
-		if (unlikely(rx_ring->next_to_clean == rx_ring->next_to_use))
+		if (unlikely(ntc == ntu))
 			break;
 
-		xdp = *ice_xdp_buf(rx_ring, rx_ring->next_to_clean);
+		xdp = *ice_xdp_buf(rx_ring, ntc);
 
 		size = le16_to_cpu(rx_desc->wb.pkt_len) &
 				   ICE_RX_FLX_DESC_PKT_LEN_M;
-		if (!size) {
-			xdp->data = NULL;
-			xdp->data_end = NULL;
-			xdp->data_hard_start = NULL;
-			xdp->data_meta = NULL;
-			goto construct_skb;
-		}
 
 		xsk_buff_set_size(xdp, size);
-		xsk_buff_dma_sync_for_cpu(xdp, rx_ring->xsk_pool);
+		xsk_buff_dma_sync_for_cpu(xdp, xsk_pool);
+
+		if (!first) {
+			first = xdp;
+			xdp_buff_clear_frags_flag(first);
+		} else if (ice_add_xsk_frag(rx_ring, first, xdp, size)) {
+			break;
+		}
+
+		if (++ntc == cnt)
+			ntc = 0;
+
+		if (ice_is_non_eop(rx_ring, rx_desc))
+			continue;
 
-		xdp_res = ice_run_xdp_zc(rx_ring, xdp, xdp_prog, xdp_ring);
+		xdp_res = ice_run_xdp_zc(rx_ring, first, xdp_prog, xdp_ring);
 		if (likely(xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR))) {
 			xdp_xmit |= xdp_res;
 		} else if (xdp_res == ICE_XDP_EXIT) {
 			failure = true;
+			first = NULL;
+			rx_ring->first_desc = ntc;
 			break;
 		} else if (xdp_res == ICE_XDP_CONSUMED) {
-			xsk_buff_free(xdp);
+			xsk_buff_free(first);
 		} else if (xdp_res == ICE_XDP_PASS) {
 			goto construct_skb;
 		}
 
-		total_rx_bytes += size;
+		total_rx_bytes += xdp_get_buff_len(first);
 		total_rx_packets++;
 
-		ice_bump_ntc(rx_ring);
+		first = NULL;
+		rx_ring->first_desc = ntc;
 		continue;
 
 construct_skb:
 		/* XDP_PASS path */
-		skb = ice_construct_skb_zc(rx_ring, xdp);
+		skb = ice_construct_skb_zc(rx_ring, first);
 		if (!skb) {
 			rx_ring->ring_stats->rx_stats.alloc_buf_failed++;
 			break;
 		}
 
-		ice_bump_ntc(rx_ring);
+		first = NULL;
+		rx_ring->first_desc = ntc;
 
 		if (eth_skb_pad(skb)) {
 			skb = NULL;
@@ -861,18 +923,22 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 		ice_receive_skb(rx_ring, skb, vlan_tag);
 	}
 
-	entries_to_alloc = ICE_DESC_UNUSED(rx_ring);
+	rx_ring->next_to_clean = ntc;
+	entries_to_alloc = ICE_RX_DESC_UNUSED(rx_ring);
 	if (entries_to_alloc > ICE_RING_QUARTER(rx_ring))
 		failure |= !ice_alloc_rx_bufs_zc(rx_ring, entries_to_alloc);
 
 	ice_finalize_xdp_rx(xdp_ring, xdp_xmit, 0);
 	ice_update_rx_ring_stats(rx_ring, total_rx_packets, total_rx_bytes);
 
-	if (xsk_uses_need_wakeup(rx_ring->xsk_pool)) {
-		if (failure || rx_ring->next_to_clean == rx_ring->next_to_use)
-			xsk_set_rx_need_wakeup(rx_ring->xsk_pool);
+	if (xsk_uses_need_wakeup(xsk_pool)) {
+		/* ntu could have changed when allocating entries above, so
+		 * use rx_ring value instead of stack based one
+		 */
+		if (failure || ntc == rx_ring->next_to_use)
+			xsk_set_rx_need_wakeup(xsk_pool);
 		else
-			xsk_clear_rx_need_wakeup(rx_ring->xsk_pool);
+			xsk_clear_rx_need_wakeup(xsk_pool);
 
 		return (int)total_rx_packets;
 	}
-- 
2.34.1


