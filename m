Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF1BB49857F
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 17:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243989AbiAXQ4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 11:56:16 -0500
Received: from mga07.intel.com ([134.134.136.100]:29692 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243996AbiAXQ4N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 11:56:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643043373; x=1674579373;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NhJNMIdjjuzZ0LIItF9/nsPHngiMSNhgWp7sMGW43e4=;
  b=E9hGZztusdQgG8ea5kDTBc7CfH4vbg8sRG7BX3eLemGiE3VKgfbGYFJL
   Qj+eGAiJvYC4gRLT1i7TlZVsRj+/L8srmEwbVeB5Mnw3UadOINIxxrrzQ
   eUJ0N/e45F2ljQKnp8wdwuUo/8fedMy/LNveMJqbw8u/2v14DV4hXfzQI
   E+O3byB6JfmvIMzG/o+T8xlm+Zk4H3whrMdPpCl7xgKESLoZKyNdC5HcF
   5bW/s1H2297f0MmBT6OloLRG15YL9LzPmphuO+zr52TXcdA3yOZ1AqyO8
   49Iw8WfnnKDLGu3UTVtF3SruJH6n6IoU2ElFnmMc+mR4DzpnkyXHnVnWJ
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="309411486"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="309411486"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 08:56:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="617312091"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Jan 2022 08:56:10 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next v4 8/8] ice: xsk: borrow xdp_tx_active logic from i40e
Date:   Mon, 24 Jan 2022 17:55:47 +0100
Message-Id: <20220124165547.74412-9-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220124165547.74412-1-maciej.fijalkowski@intel.com>
References: <20220124165547.74412-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One of the things that commit 5574ff7b7b3d ("i40e: optimize AF_XDP Tx
completion path") introduced was the @xdp_tx_active field. Its usage
from i40e can be adjusted to ice driver and give us positive performance
results.

If the descriptor that @next_dd to points has been sent by HW (its DD
bit is set), then we are sure that there are ICE_TX_THRESH count of
descriptors ready to be cleaned. If @xdp_tx_active is 0 which means that
related xdp_ring is not used for XDP_{TX, REDIRECT} workloads, then we
know how many XSK entries should placed to completion queue, IOW walking
through the ring can be skipped.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  1 +
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  1 +
 drivers/net/ethernet/intel/ice/ice_xsk.c      | 15 ++++++++++++---
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index ea6c9cc02a1a..0e4773bead93 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -333,6 +333,7 @@ struct ice_tx_ring {
 	struct ice_ptp_tx *tx_tstamps;
 	spinlock_t tx_lock;
 	u32 txq_teid;			/* Added Tx queue TEID */
+	u16 xdp_tx_active;
 #define ICE_TX_FLAGS_RING_XDP		BIT(0)
 	u8 flags;
 	u8 dcb_tc;			/* Traffic class of ring */
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 9677cf880a4b..eb21cec1d772 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -302,6 +302,7 @@ int ice_xmit_xdp_ring(void *data, u16 size, struct ice_tx_ring *xdp_ring)
 	tx_desc->cmd_type_offset_bsz = ice_build_ctob(ICE_TX_DESC_CMD_EOP, 0,
 						      size, 0);
 
+	xdp_ring->xdp_tx_active++;
 	i++;
 	if (i == xdp_ring->count) {
 		i = 0;
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 7225c3d0b6d0..d18115ea723c 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -688,6 +688,7 @@ static void
 ice_clean_xdp_tx_buf(struct ice_tx_ring *xdp_ring, struct ice_tx_buf *tx_buf)
 {
 	xdp_return_frame((struct xdp_frame *)tx_buf->raw_buf);
+	xdp_ring->xdp_tx_active--;
 	dma_unmap_single(xdp_ring->dev, dma_unmap_addr(tx_buf, dma),
 			 dma_unmap_len(tx_buf, len), DMA_TO_DEVICE);
 	dma_unmap_len_set(tx_buf, len, 0);
@@ -704,9 +705,8 @@ static u16 ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring, int napi_budget)
 {
 	u16 tx_thresh = ICE_RING_QUARTER(xdp_ring);
 	int budget = napi_budget / tx_thresh;
-	u16 ntc = xdp_ring->next_to_clean;
 	u16 next_dd = xdp_ring->next_dd;
-	u16 cleared_dds = 0;
+	u16 ntc, cleared_dds = 0;
 
 	do {
 		struct ice_tx_desc *next_dd_desc;
@@ -722,6 +722,12 @@ static u16 ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring, int napi_budget)
 
 		cleared_dds++;
 		xsk_frames = 0;
+		if (likely(!xdp_ring->xdp_tx_active)) {
+			xsk_frames = tx_thresh;
+			goto skip;
+		}
+
+		ntc = xdp_ring->next_to_clean;
 
 		for (i = 0; i < tx_thresh; i++) {
 			tx_buf = &xdp_ring->tx_buf[ntc];
@@ -737,6 +743,10 @@ static u16 ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring, int napi_budget)
 			if (ntc >= xdp_ring->count)
 				ntc = 0;
 		}
+skip:
+		xdp_ring->next_to_clean += tx_thresh;
+		if (xdp_ring->next_to_clean >= desc_cnt)
+			xdp_ring->next_to_clean -= desc_cnt;
 		if (xsk_frames)
 			xsk_tx_completed(xdp_ring->xsk_pool, xsk_frames);
 		next_dd_desc->cmd_type_offset_bsz = 0;
@@ -745,7 +755,6 @@ static u16 ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring, int napi_budget)
 			next_dd = tx_thresh - 1;
 	} while (budget--);
 
-	xdp_ring->next_to_clean = ntc;
 	xdp_ring->next_dd = next_dd;
 
 	return cleared_dds * tx_thresh;
-- 
2.33.1

