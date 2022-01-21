Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F54495EBF
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 13:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350282AbiAUMAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 07:00:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:36380 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349955AbiAUMAl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 07:00:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642766441; x=1674302441;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u02c98VQ7tPgPoUF7rBoAfDv8cxp2gpG3ggPtAFWy+A=;
  b=Yt8JzFJrzgRCoac/7HyDKC+RWAXSEodppp4RxK1XfyeU45LidPzKPGJw
   8GsV5b2IAvGZ20z2MEqRbIRWMDQOnrGxeKU6241ejq3ajr9utn5t6Jbu5
   kboITMHAvF80BXktfxcJIBPHGspsI5+QQNUIOQn4YIfAigLY+3Y7OAv2Q
   RD6uMpfy2VqUZ3zYndAsaPN3/62Q5eG3vUQ1inLKOjfBoP/s80VO1HjaO
   5WBag88vxq7R/TvQmNGnGGQBt2CS6khpKvFfr4XmmqZflvzvyqhizo2wP
   4pfJHRD8OUB/CTsyQLSX6seMLc33kM+W/8o4/9WKNn3LGXxEP02AN7K54
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10233"; a="270058964"
X-IronPort-AV: E=Sophos;i="5.88,304,1635231600"; 
   d="scan'208";a="270058964"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2022 04:00:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,304,1635231600"; 
   d="scan'208";a="475924954"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga003.jf.intel.com with ESMTP; 21 Jan 2022 04:00:31 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next v3 2/7] ice: xsk: handle SW XDP ring wrap and bump tail more often
Date:   Fri, 21 Jan 2022 13:00:06 +0100
Message-Id: <20220121120011.49316-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220121120011.49316-1-maciej.fijalkowski@intel.com>
References: <20220121120011.49316-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, if ice_clean_rx_irq_zc() processed the whole ring and
next_to_use != 0, then ice_alloc_rx_buf_zc() would not refill the whole
ring even if the XSK buffer pool would have enough free entries (either
from fill ring or the internal recycle mechanism) - it is because ring
wrap is not handled.

Improve the logic in ice_alloc_rx_buf_zc() to address the problem above.
Do not clamp the count of buffers that is passed to
xsk_buff_alloc_batch() in case when next_to_use + buffer count >=
rx_ring->count,  but rather split it and have two calls to the mentioned
function - one for the part up until the wrap and one for the part after
the wrap.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.h |  2 +
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 99 ++++++++++++++++++-----
 2 files changed, 81 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index b7b3bd4816f0..94a46e0e5ed0 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -111,6 +111,8 @@ static inline int ice_skb_pad(void)
 	(u16)((((R)->next_to_clean > (R)->next_to_use) ? 0 : (R)->count) + \
 	      (R)->next_to_clean - (R)->next_to_use - 1)
 
+#define ICE_RING_QUARTER(R) ((R)->count / 4)
+
 #define ICE_TX_FLAGS_TSO	BIT(0)
 #define ICE_TX_FLAGS_HW_VLAN	BIT(1)
 #define ICE_TX_FLAGS_SW_VLAN	BIT(2)
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 2388837d6d6c..0463fc594d08 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -359,33 +359,28 @@ int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
 }
 
 /**
- * ice_alloc_rx_bufs_zc - allocate a number of Rx buffers
- * @rx_ring: Rx ring
+ * ice_fill_rx_descs - pick buffers from XSK buffer pool and use it
+ * @pool: XSK Buffer pool to pull the buffers from
+ * @xdp: SW ring of xdp_buff that will hold the buffers
+ * @rx_desc: Pointer to Rx descriptors that will be filled
  * @count: The number of buffers to allocate
  *
  * This function allocates a number of Rx buffers from the fill ring
  * or the internal recycle mechanism and places them on the Rx ring.
  *
- * Returns true if all allocations were successful, false if any fail.
+ * Note that ring wrap should be handled by caller of this function.
+ *
+ * Returns the amount of allocated Rx descriptors
  */
-bool ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count)
+static u16 ice_fill_rx_descs(struct xsk_buff_pool *pool, struct xdp_buff **xdp,
+			     union ice_32b_rx_flex_desc *rx_desc, u16 count)
 {
-	union ice_32b_rx_flex_desc *rx_desc;
-	u16 ntu = rx_ring->next_to_use;
-	struct xdp_buff **xdp;
-	u32 nb_buffs, i;
 	dma_addr_t dma;
+	u16 buffs;
+	int i;
 
-	rx_desc = ICE_RX_DESC(rx_ring, ntu);
-	xdp = ice_xdp_buf(rx_ring, ntu);
-
-	nb_buffs = min_t(u16, count, rx_ring->count - ntu);
-	nb_buffs = xsk_buff_alloc_batch(rx_ring->xsk_pool, xdp, nb_buffs);
-	if (!nb_buffs)
-		return false;
-
-	i = nb_buffs;
-	while (i--) {
+	buffs = xsk_buff_alloc_batch(pool, xdp, count);
+	for (i = 0; i < buffs; i++) {
 		dma = xsk_buff_xdp_get_dma(*xdp);
 		rx_desc->read.pkt_addr = cpu_to_le64(dma);
 		rx_desc->wb.status_error0 = 0;
@@ -394,13 +389,77 @@ bool ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count)
 		xdp++;
 	}
 
+	return buffs;
+}
+
+/**
+ * __ice_alloc_rx_bufs_zc - allocate a number of Rx buffers
+ * @rx_ring: Rx ring
+ * @count: The number of buffers to allocate
+ *
+ * Place the @count of descriptors onto Rx ring. Handle the ring wrap
+ * for case where space from next_to_use up to the end of ring is less
+ * than @count. Finally do a tail bump.
+ *
+ * Returns true if all allocations were successful, false if any fail.
+ */
+static bool __ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count)
+{
+	union ice_32b_rx_flex_desc *rx_desc;
+	u32 nb_buffs_extra = 0, nb_buffs;
+	u16 ntu = rx_ring->next_to_use;
+	u16 total_count = count;
+	struct xdp_buff **xdp;
+
+	rx_desc = ICE_RX_DESC(rx_ring, ntu);
+	xdp = ice_xdp_buf(rx_ring, ntu);
+
+	if (ntu + count >= rx_ring->count) {
+		nb_buffs_extra = ice_fill_rx_descs(rx_ring->xsk_pool, xdp,
+						   rx_desc,
+						   rx_ring->count - ntu);
+		rx_desc = ICE_RX_DESC(rx_ring, 0);
+		xdp = ice_xdp_buf(rx_ring, 0);
+		ntu = 0;
+		count -= nb_buffs_extra;
+		ice_release_rx_desc(rx_ring, 0);
+	}
+
+	nb_buffs = ice_fill_rx_descs(rx_ring->xsk_pool, xdp, rx_desc, count);
+
 	ntu += nb_buffs;
 	if (ntu == rx_ring->count)
 		ntu = 0;
 
-	ice_release_rx_desc(rx_ring, ntu);
+	if (rx_ring->next_to_use != ntu)
+		ice_release_rx_desc(rx_ring, ntu);
+
+	return total_count == (nb_buffs_extra + nb_buffs);
+}
+
+/**
+ * ice_alloc_rx_bufs_zc - allocate a number of Rx buffers
+ * @rx_ring: Rx ring
+ * @count: The number of buffers to allocate
+ *
+ * Wrapper for internal allocation routine; figure out how many tail
+ * bumps should take place based on the given threshold
+ *
+ * Returns true if all calls to internal alloc routine succeeded
+ */
+bool ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count)
+{
+	u16 rx_thresh = ICE_RING_QUARTER(rx_ring);
+	u16 batched, leftover, i, tail_bumps;
+
+	batched = count & ~(rx_thresh - 1);
+	tail_bumps = batched / rx_thresh;
+	leftover = count & (rx_thresh - 1);
 
-	return count == nb_buffs;
+	for (i = 0; i < tail_bumps; i++)
+		if (!__ice_alloc_rx_bufs_zc(rx_ring, rx_thresh))
+			return false;
+	return __ice_alloc_rx_bufs_zc(rx_ring, leftover);
 }
 
 /**
-- 
2.33.1

