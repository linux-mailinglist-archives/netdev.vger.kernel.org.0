Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E0B495EC8
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 13:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349955AbiAUMAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 07:00:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:36384 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350270AbiAUMAp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 07:00:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642766445; x=1674302445;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9MhiYPqwraAWp7miHiQUITK+Gal+GcBB6r013Y05EP8=;
  b=VLbrcbdSwSrjZJ8s2oHxdhcU0yCaUpkWaodoYg39tFyQ5vnAuWYeLlm0
   NKAKYrh/m25A8/db9W/EhzWvy8hHoqiIdGCQjNp01qn9E2TQUGL+du2mu
   yULCmNpsYeQP0PGIMENsqfQuBGbviiwdQMekr94xOJ9/MaZS0h4x5QkTv
   QV6fk9+5D4UONi+uRorCL1I67oCSvkrhh1n9jOugubpkSzPG/vTLXSo/H
   TDnPjtHwSNvk4afMVAziXihiqrbXLFdmuTiJpkinGjmzJiru7S4D+tPuG
   dQ33Ej1Hhrb8wl5bDIbJD1UlNozytQGDmq89Wt2jbkMRae66K+HEy0DT7
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10233"; a="270059012"
X-IronPort-AV: E=Sophos;i="5.88,304,1635231600"; 
   d="scan'208";a="270059012"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2022 04:00:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,304,1635231600"; 
   d="scan'208";a="475925028"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga003.jf.intel.com with ESMTP; 21 Jan 2022 04:00:42 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next v3 7/7] ice: xsk: borrow xdp_tx_active logic from i40e
Date:   Fri, 21 Jan 2022 13:00:11 +0100
Message-Id: <20220121120011.49316-8-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220121120011.49316-1-maciej.fijalkowski@intel.com>
References: <20220121120011.49316-1-maciej.fijalkowski@intel.com>
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
index 191f9b8c50ee..5c1d38ba5275 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -334,6 +334,7 @@ struct ice_tx_ring {
 	spinlock_t tx_lock;
 	u16 tx_thresh;
 	u32 txq_teid;			/* Added Tx queue TEID */
+	u16 xdp_tx_active;
 #define ICE_TX_FLAGS_RING_XDP		BIT(0)
 	u8 flags;
 	u8 dcb_tc;			/* Traffic class of ring */
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 5706b5405373..93c61c7feed8 100644
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
index 4b6e54f75af6..adf246e05c41 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -679,6 +679,7 @@ static void
 ice_clean_xdp_tx_buf(struct ice_tx_ring *xdp_ring, struct ice_tx_buf *tx_buf)
 {
 	xdp_return_frame((struct xdp_frame *)tx_buf->raw_buf);
+	xdp_ring->xdp_tx_active--;
 	dma_unmap_single(xdp_ring->dev, dma_unmap_addr(tx_buf, dma),
 			 dma_unmap_len(tx_buf, len), DMA_TO_DEVICE);
 	dma_unmap_len_set(tx_buf, len, 0);
@@ -695,12 +696,11 @@ static u16 ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring, int napi_budget)
 {
 	u16 tx_thresh = xdp_ring->tx_thresh;
 	int budget = napi_budget / tx_thresh;
-	u16 ntc = xdp_ring->next_to_clean;
 	struct ice_tx_desc *next_dd_desc;
 	u16 next_dd = xdp_ring->next_dd;
 	u16 desc_cnt = xdp_ring->count;
 	struct ice_tx_buf *tx_buf;
-	u16 cleared_dds = 0;
+	u16 ntc, cleared_dds = 0;
 	u32 xsk_frames = 0;
 	u16 i;
 
@@ -712,6 +712,12 @@ static u16 ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring, int napi_budget)
 
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
@@ -727,6 +733,10 @@ static u16 ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring, int napi_budget)
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
@@ -735,7 +745,6 @@ static u16 ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring, int napi_budget)
 			next_dd = tx_thresh - 1;
 	} while (budget--);
 
-	xdp_ring->next_to_clean = ntc;
 	xdp_ring->next_dd = next_dd;
 
 	return cleared_dds * tx_thresh;
-- 
2.33.1

