Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C414773D9
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 15:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237456AbhLPOAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 09:00:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:12138 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237444AbhLPOAK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 09:00:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639663210; x=1671199210;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MKhQd473uwwFtY1Oln+5trvh/SUpcgr7v/jcIBVcgG4=;
  b=WM50clSNW0iiQdch4Y0y5dHdA7S+BEnygyR3CTdtNlZCXhmUGaU/ATIV
   5L3xrCRzviB1qaivqRbcnFUJIpSaJ/jPVPuVc8wBX9N8WbTGWyP03DW+K
   MvUmOUtD2mYi3MwK9Ai1abxiuhKJ2HsDhRDrFoSY0JjABxcHsN2PoHBDV
   M8P+4megBd8nebsO0q0DnsasmOUlsmuNqa106uoR9VLvQm4aet+jMN2ra
   0kXAGxtOESEPYkwybVLuA4PJ9iKJz7AbHgLU7F8AxPNyKok3ND5udEPh2
   QFKiZWbp2ksVAxOohWkQVPbqNRdhbqXalSO1+g6SyqHDriB+iQxA7Y6xa
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="226779284"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="226779284"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 06:00:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="545988280"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga001.jf.intel.com with ESMTP; 16 Dec 2021 06:00:08 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next v2 4/4] ice: xsk: borrow xdp_tx_active logic from i40e
Date:   Thu, 16 Dec 2021 14:59:58 +0100
Message-Id: <20211216135958.3434-5-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211216135958.3434-1-maciej.fijalkowski@intel.com>
References: <20211216135958.3434-1-maciej.fijalkowski@intel.com>
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

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.h     | 1 +
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 1 +
 drivers/net/ethernet/intel/ice/ice_xsk.c      | 8 +++++++-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 9e8b4337d131..5e37d4f57bfa 100644
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
index 1dd7e84f41f8..f15c215c973c 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -299,6 +299,7 @@ int ice_xmit_xdp_ring(void *data, u16 size, struct ice_tx_ring *xdp_ring)
 	tx_desc->cmd_type_offset_bsz = ice_build_ctob(ICE_TX_DESC_CMD_EOP, 0,
 						      size, 0);
 
+	xdp_ring->xdp_tx_active++;
 	i++;
 	if (i == xdp_ring->count) {
 		i = 0;
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 563ea7e7e0b1..a81ade2b7600 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -620,6 +620,7 @@ static void
 ice_clean_xdp_tx_buf(struct ice_tx_ring *xdp_ring, struct ice_tx_buf *tx_buf)
 {
 	xdp_return_frame((struct xdp_frame *)tx_buf->raw_buf);
+	xdp_ring->xdp_tx_active--;
 	dma_unmap_single(xdp_ring->dev, dma_unmap_addr(tx_buf, dma),
 			 dma_unmap_len(tx_buf, len), DMA_TO_DEVICE);
 	dma_unmap_len_set(tx_buf, len, 0);
@@ -648,6 +649,11 @@ static u16 ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring)
 
 again:
 	cleared_dds++;
+	xsk_frames = 0;
+	if (likely(!xdp_ring->xdp_tx_active)) {
+		xsk_frames = ICE_TX_THRESH;
+		goto skip;
+	}
 
 	ntc = xdp_ring->next_to_clean;
 
@@ -665,7 +671,7 @@ static u16 ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring)
 		if (ntc >= xdp_ring->count)
 			ntc = 0;
 	}
-
+skip:
 	xdp_ring->next_to_clean += ICE_TX_THRESH;
 	if (xdp_ring->next_to_clean >= desc_cnt)
 		xdp_ring->next_to_clean -= desc_cnt;
-- 
2.33.1

