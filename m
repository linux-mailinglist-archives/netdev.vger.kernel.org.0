Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 720AA4706CA
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 18:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244401AbhLJRSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 12:18:54 -0500
Received: from mga04.intel.com ([192.55.52.120]:27809 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236268AbhLJRSv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 12:18:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639156516; x=1670692516;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e6lexJALqYw8XcZYTr0tfoUX7lUE+ekr3259RHeCX1E=;
  b=Udj9rJ4d0B6SnDdYFNCBKCTqF+vaKFYZxLhfXJc/IxdlA3mnmfT0hH42
   z0Z3BPXLHsmlL6mnFrVeu6EaiEoIk8k8wp+1xD6y0+dz798zJP5o5/xEM
   qry5UdaPDboMYv0fH9zGrNbdDGP0/1ynWcW/30i5pR/3XkTfv2aJAnUxR
   x++aePiFTtj/42Y3qUg6tllkJfDgMW/2vV3MPb+4uIZjvastnWDTv/etl
   +o9hDQmHyKJPOfpkAcP7t7+GIY7FCYAHPk6KhRrtAJRrd4tLEesMCEe3I
   LWDfv7Wuq8ccA7KqGBOBy//0HEAvQoraTQ6yDZoUlblv9rpz9hbcIv3q2
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10194"; a="237120439"
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="237120439"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 09:14:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="516848764"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 10 Dec 2021 09:14:38 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 3/3] ice: xsk: borrow xdp_tx_active logic from i40e
Date:   Fri, 10 Dec 2021 18:14:25 +0100
Message-Id: <20211210171425.11475-4-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210171425.11475-1-maciej.fijalkowski@intel.com>
References: <20211210171425.11475-1-maciej.fijalkowski@intel.com>
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
 drivers/net/ethernet/intel/ice/ice_txrx.h     | 1 +
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 1 +
 drivers/net/ethernet/intel/ice/ice_xsk.c      | 7 +++++++
 3 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index f2ebbe2158e7..8dd9c92662ad 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -332,6 +332,7 @@ struct ice_tx_ring {
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
index a7f866b3fcd7..8949a7be45c6 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -684,6 +684,7 @@ static void
 ice_clean_xdp_tx_buf(struct ice_tx_ring *xdp_ring, struct ice_tx_buf *tx_buf)
 {
 	xdp_return_frame((struct xdp_frame *)tx_buf->raw_buf);
+	xdp_ring->xdp_tx_active--;
 	dma_unmap_single(xdp_ring->dev, dma_unmap_addr(tx_buf, dma),
 			 dma_unmap_len(tx_buf, len), DMA_TO_DEVICE);
 	dma_unmap_len_set(tx_buf, len, 0);
@@ -713,6 +714,11 @@ bool ice_clean_tx_irq_zc(struct ice_tx_ring *xdp_ring)
 
 again:
 	xsk_frames = 0;
+	if (likely(!xdp_ring->xdp_tx_active)) {
+		xsk_frames = ICE_TX_THRESH;
+		goto skip;
+	}
+
 	ntc = xdp_ring->next_to_clean;
 
 	for (i = 0; i < ICE_TX_THRESH; i++) {
@@ -729,6 +735,7 @@ bool ice_clean_tx_irq_zc(struct ice_tx_ring *xdp_ring)
 		if (ntc >= xdp_ring->count)
 			ntc = 0;
 	}
+skip:
 	xdp_ring->next_to_clean += ICE_TX_THRESH;
 	if (xdp_ring->next_to_clean >= desc_cnt)
 		xdp_ring->next_to_clean -= desc_cnt;
-- 
2.33.1

