Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9181D5EC9C4
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 18:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbiI0QmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 12:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbiI0Ql3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 12:41:29 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7E91BBEF7;
        Tue, 27 Sep 2022 09:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664296882; x=1695832882;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0REACdjQ3f5V4cr+flT11p0dxZ/G0RmcH478LdtDMxM=;
  b=aomlgFL1+byEBqJai21aE9xpwkD36y5OYAhp7HvJGFnjWSLYoPBtAztL
   F7sCZq8eg1TvKwfCCCwx2SWGnx4QBLb3NgY3zwJbWWQeWiVr1O+GNBOkn
   Ovz7zvtEzmZ9R6Cr8S01qwO+OaZh/8ZFHah39o3WHaHrNhZCpb27il4nx
   PdE296GAKGTyXQAXm3ToMGVuh3fyNHSMSQMneX0WgYf26rm47mUIW+q3P
   R/E0BmC1Ph0KqX07k24JWozZPvixUkC6GXaTZSdOd+Es4kgqMWw8xEbKV
   Bh1suzH4/zrbKDa3uhCMGNktjSrksVplu2KFrSCDTAcnSoCbXif8N4QB5
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="281085137"
X-IronPort-AV: E=Sophos;i="5.93,349,1654585200"; 
   d="scan'208";a="281085137"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 09:41:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="616893060"
X-IronPort-AV: E=Sophos;i="5.93,349,1654585200"; 
   d="scan'208";a="616893060"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 27 Sep 2022 09:41:17 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Subject: [PATCH net 1/2] ice: xsk: change batched Tx descriptor cleaning
Date:   Tue, 27 Sep 2022 09:41:11 -0700
Message-Id: <20220927164112.4011983-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220927164112.4011983-1-anthony.l.nguyen@intel.com>
References: <20220927164112.4011983-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

AF_XDP Tx descriptor cleaning in ice driver currently works in a "lazy"
way - descriptors are not cleaned immediately after send. We rather hold
on with cleaning until we see that free space in ring drops below
particular threshold. This was supposed to reduce the amount of
unnecessary work related to cleaning and instead of keeping the ring
empty, ring was rather saturated.

In AF_XDP realm cleaning Tx descriptors implies producing them to CQ.
This is a way of letting know user space that particular descriptor has
been sent, as John points out in [0].

We tried to implement serial descriptor cleaning which would be used in
conjunction with batched cleaning but it made code base more convoluted
and probably harder to maintain in future. Therefore we step away from
batched cleaning in a current form in favor of an approach where we set
RS bit on every last descriptor from a batch and clean always at the
beginning of ice_xmit_zc().

This means that we give up a bit of Tx performance, but this doesn't
hurt l2fwd scenario which is way more meaningful than txonly as this can
be treaten as AF_XDP based packet generator. l2fwd is not hurt due to
the fact that Tx side is much faster than Rx and Rx is the one that has
to catch Tx up.

FWIW Tx descriptors are still produced in a batched way.

[0]: https://lore.kernel.org/bpf/62b0a20232920_3573208ab@john.notmuch/

Fixes: 126cdfe1007a ("ice: xsk: Improve AF_XDP ZC Tx and use batching API")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c |   2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 143 +++++++++-------------
 drivers/net/ethernet/intel/ice/ice_xsk.h  |   7 +-
 3 files changed, 64 insertions(+), 88 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 97453d1dfafe..dd2285d4bef4 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1467,7 +1467,7 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
 		bool wd;
 
 		if (tx_ring->xsk_pool)
-			wd = ice_xmit_zc(tx_ring, ICE_DESC_UNUSED(tx_ring), budget);
+			wd = ice_xmit_zc(tx_ring);
 		else if (ice_ring_is_xdp(tx_ring))
 			wd = true;
 		else
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 03ce85f6e6df..8833b66b4e54 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -788,69 +788,57 @@ ice_clean_xdp_tx_buf(struct ice_tx_ring *xdp_ring, struct ice_tx_buf *tx_buf)
 }
 
 /**
- * ice_clean_xdp_irq_zc - Reclaim resources after transmit completes on XDP ring
- * @xdp_ring: XDP ring to clean
- * @napi_budget: amount of descriptors that NAPI allows us to clean
- *
- * Returns count of cleaned descriptors
+ * ice_clean_xdp_irq_zc - produce AF_XDP descriptors to CQ
+ * @xdp_ring: XDP Tx ring
  */
-static u16 ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring, int napi_budget)
+static void ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring)
 {
-	u16 tx_thresh = ICE_RING_QUARTER(xdp_ring);
-	int budget = napi_budget / tx_thresh;
-	u16 next_dd = xdp_ring->next_dd;
-	u16 ntc, cleared_dds = 0;
-
-	do {
-		struct ice_tx_desc *next_dd_desc;
-		u16 desc_cnt = xdp_ring->count;
-		struct ice_tx_buf *tx_buf;
-		u32 xsk_frames;
-		u16 i;
-
-		next_dd_desc = ICE_TX_DESC(xdp_ring, next_dd);
-		if (!(next_dd_desc->cmd_type_offset_bsz &
-		    cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE)))
-			break;
+	u16 ntc = xdp_ring->next_to_clean;
+	struct ice_tx_desc *tx_desc;
+	u16 cnt = xdp_ring->count;
+	struct ice_tx_buf *tx_buf;
+	u16 xsk_frames = 0;
+	u16 last_rs;
+	int i;
 
-		cleared_dds++;
-		xsk_frames = 0;
-		if (likely(!xdp_ring->xdp_tx_active)) {
-			xsk_frames = tx_thresh;
-			goto skip;
-		}
+	last_rs = xdp_ring->next_to_use ? xdp_ring->next_to_use - 1 : cnt - 1;
+	tx_desc = ICE_TX_DESC(xdp_ring, last_rs);
+	if ((tx_desc->cmd_type_offset_bsz &
+	    cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE))) {
+		if (last_rs >= ntc)
+			xsk_frames = last_rs - ntc + 1;
+		else
+			xsk_frames = last_rs + cnt - ntc + 1;
+	}
 
-		ntc = xdp_ring->next_to_clean;
+	if (!xsk_frames)
+		return;
 
-		for (i = 0; i < tx_thresh; i++) {
-			tx_buf = &xdp_ring->tx_buf[ntc];
+	if (likely(!xdp_ring->xdp_tx_active))
+		goto skip;
 
-			if (tx_buf->raw_buf) {
-				ice_clean_xdp_tx_buf(xdp_ring, tx_buf);
-				tx_buf->raw_buf = NULL;
-			} else {
-				xsk_frames++;
-			}
+	ntc = xdp_ring->next_to_clean;
+	for (i = 0; i < xsk_frames; i++) {
+		tx_buf = &xdp_ring->tx_buf[ntc];
 
-			ntc++;
-			if (ntc >= xdp_ring->count)
-				ntc = 0;
+		if (tx_buf->raw_buf) {
+			ice_clean_xdp_tx_buf(xdp_ring, tx_buf);
+			tx_buf->raw_buf = NULL;
+		} else {
+			xsk_frames++;
 		}
+
+		ntc++;
+		if (ntc >= xdp_ring->count)
+			ntc = 0;
+	}
 skip:
-		xdp_ring->next_to_clean += tx_thresh;
-		if (xdp_ring->next_to_clean >= desc_cnt)
-			xdp_ring->next_to_clean -= desc_cnt;
-		if (xsk_frames)
-			xsk_tx_completed(xdp_ring->xsk_pool, xsk_frames);
-		next_dd_desc->cmd_type_offset_bsz = 0;
-		next_dd = next_dd + tx_thresh;
-		if (next_dd >= desc_cnt)
-			next_dd = tx_thresh - 1;
-	} while (--budget);
-
-	xdp_ring->next_dd = next_dd;
-
-	return cleared_dds * tx_thresh;
+	tx_desc->cmd_type_offset_bsz = 0;
+	xdp_ring->next_to_clean += xsk_frames;
+	if (xdp_ring->next_to_clean >= cnt)
+		xdp_ring->next_to_clean -= cnt;
+	if (xsk_frames)
+		xsk_tx_completed(xdp_ring->xsk_pool, xsk_frames);
 }
 
 /**
@@ -885,7 +873,6 @@ static void ice_xmit_pkt(struct ice_tx_ring *xdp_ring, struct xdp_desc *desc,
 static void ice_xmit_pkt_batch(struct ice_tx_ring *xdp_ring, struct xdp_desc *descs,
 			       unsigned int *total_bytes)
 {
-	u16 tx_thresh = ICE_RING_QUARTER(xdp_ring);
 	u16 ntu = xdp_ring->next_to_use;
 	struct ice_tx_desc *tx_desc;
 	u32 i;
@@ -905,13 +892,6 @@ static void ice_xmit_pkt_batch(struct ice_tx_ring *xdp_ring, struct xdp_desc *de
 	}
 
 	xdp_ring->next_to_use = ntu;
-
-	if (xdp_ring->next_to_use > xdp_ring->next_rs) {
-		tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_rs);
-		tx_desc->cmd_type_offset_bsz |=
-			cpu_to_le64(ICE_TX_DESC_CMD_RS << ICE_TXD_QW1_CMD_S);
-		xdp_ring->next_rs += tx_thresh;
-	}
 }
 
 /**
@@ -924,7 +904,6 @@ static void ice_xmit_pkt_batch(struct ice_tx_ring *xdp_ring, struct xdp_desc *de
 static void ice_fill_tx_hw_ring(struct ice_tx_ring *xdp_ring, struct xdp_desc *descs,
 				u32 nb_pkts, unsigned int *total_bytes)
 {
-	u16 tx_thresh = ICE_RING_QUARTER(xdp_ring);
 	u32 batched, leftover, i;
 
 	batched = ALIGN_DOWN(nb_pkts, PKTS_PER_BATCH);
@@ -933,54 +912,54 @@ static void ice_fill_tx_hw_ring(struct ice_tx_ring *xdp_ring, struct xdp_desc *d
 		ice_xmit_pkt_batch(xdp_ring, &descs[i], total_bytes);
 	for (; i < batched + leftover; i++)
 		ice_xmit_pkt(xdp_ring, &descs[i], total_bytes);
+}
 
-	if (xdp_ring->next_to_use > xdp_ring->next_rs) {
-		struct ice_tx_desc *tx_desc;
+/**
+ * ice_set_rs_bit - set RS bit on last produced descriptor (one behind current NTU)
+ * @xdp_ring: XDP ring to produce the HW Tx descriptors on
+ */
+static void ice_set_rs_bit(struct ice_tx_ring *xdp_ring)
+{
+	u16 ntu = xdp_ring->next_to_use ? xdp_ring->next_to_use - 1 : xdp_ring->count - 1;
+	struct ice_tx_desc *tx_desc;
 
-		tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_rs);
-		tx_desc->cmd_type_offset_bsz |=
-			cpu_to_le64(ICE_TX_DESC_CMD_RS << ICE_TXD_QW1_CMD_S);
-		xdp_ring->next_rs += tx_thresh;
-	}
+	tx_desc = ICE_TX_DESC(xdp_ring, ntu);
+	tx_desc->cmd_type_offset_bsz |=
+		cpu_to_le64(ICE_TX_DESC_CMD_RS << ICE_TXD_QW1_CMD_S);
 }
 
 /**
  * ice_xmit_zc - take entries from XSK Tx ring and place them onto HW Tx ring
  * @xdp_ring: XDP ring to produce the HW Tx descriptors on
- * @budget: number of free descriptors on HW Tx ring that can be used
- * @napi_budget: amount of descriptors that NAPI allows us to clean
  *
  * Returns true if there is no more work that needs to be done, false otherwise
  */
-bool ice_xmit_zc(struct ice_tx_ring *xdp_ring, u32 budget, int napi_budget)
+bool ice_xmit_zc(struct ice_tx_ring *xdp_ring)
 {
 	struct xdp_desc *descs = xdp_ring->xsk_pool->tx_descs;
-	u16 tx_thresh = ICE_RING_QUARTER(xdp_ring);
 	u32 nb_pkts, nb_processed = 0;
 	unsigned int total_bytes = 0;
+	int budget;
+
+	ice_clean_xdp_irq_zc(xdp_ring);
 
-	if (budget < tx_thresh)
-		budget += ice_clean_xdp_irq_zc(xdp_ring, napi_budget);
+	budget = ICE_DESC_UNUSED(xdp_ring);
+	budget = min_t(u16, budget, ICE_RING_QUARTER(xdp_ring));
 
 	nb_pkts = xsk_tx_peek_release_desc_batch(xdp_ring->xsk_pool, budget);
 	if (!nb_pkts)
 		return true;
 
 	if (xdp_ring->next_to_use + nb_pkts >= xdp_ring->count) {
-		struct ice_tx_desc *tx_desc;
-
 		nb_processed = xdp_ring->count - xdp_ring->next_to_use;
 		ice_fill_tx_hw_ring(xdp_ring, descs, nb_processed, &total_bytes);
-		tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_rs);
-		tx_desc->cmd_type_offset_bsz |=
-			cpu_to_le64(ICE_TX_DESC_CMD_RS << ICE_TXD_QW1_CMD_S);
-		xdp_ring->next_rs = tx_thresh - 1;
 		xdp_ring->next_to_use = 0;
 	}
 
 	ice_fill_tx_hw_ring(xdp_ring, &descs[nb_processed], nb_pkts - nb_processed,
 			    &total_bytes);
 
+	ice_set_rs_bit(xdp_ring);
 	ice_xdp_ring_update_tail(xdp_ring);
 	ice_update_tx_ring_stats(xdp_ring, nb_pkts, total_bytes);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.h b/drivers/net/ethernet/intel/ice/ice_xsk.h
index 4edbe81eb646..6fa181f080ef 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.h
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.h
@@ -26,13 +26,10 @@ bool ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count);
 bool ice_xsk_any_rx_ring_ena(struct ice_vsi *vsi);
 void ice_xsk_clean_rx_ring(struct ice_rx_ring *rx_ring);
 void ice_xsk_clean_xdp_ring(struct ice_tx_ring *xdp_ring);
-bool ice_xmit_zc(struct ice_tx_ring *xdp_ring, u32 budget, int napi_budget);
+bool ice_xmit_zc(struct ice_tx_ring *xdp_ring);
 int ice_realloc_zc_buf(struct ice_vsi *vsi, bool zc);
 #else
-static inline bool
-ice_xmit_zc(struct ice_tx_ring __always_unused *xdp_ring,
-	    u32 __always_unused budget,
-	    int __always_unused napi_budget)
+static inline bool ice_xmit_zc(struct ice_tx_ring __always_unused *xdp_ring)
 {
 	return false;
 }
-- 
2.35.1

