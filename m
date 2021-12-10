Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F07B470352
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 15:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242483AbhLJPDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 10:03:30 -0500
Received: from mga04.intel.com ([192.55.52.120]:14344 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239381AbhLJPD2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 10:03:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639148393; x=1670684393;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D0f3fADiHKvMV3FFg8jmasqSGkJ7/WlrZBtkE6a2TnM=;
  b=V+FdTI10p1ihlBZStWmcbtKsqJdxSteDBWkGYnH4iUradgBcKrD22lNA
   9Vgn/f50ZPsF7um0Fn9OENruj9xvwqkBXC8Zm2wyjj4MdgBVN9FJ79pAR
   1ABoocEs3bAWIDpIAmOVMwndiNFw/fDsUGFN2/gAxfZLJi19X92efPTh/
   opEm0eJSzSdU7EJCqoBoaG1ZyWcCqdCPywoNBxt9MUQAo81aKltwjmXw/
   xSbOff8iEsIEV11WZL3LngND+OsIz7pJGLEnZRF4rNo6ytXSoZXWYS792
   YPYvG2c6KQ86V6+/qqikYb4Np8VTfUH2UrO326Lep9KCE8Uuf9C7KfnGl
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10193"; a="237093260"
X-IronPort-AV: E=Sophos;i="5.88,195,1635231600"; 
   d="scan'208";a="237093260"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 06:59:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,195,1635231600"; 
   d="scan'208";a="680763713"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga005.jf.intel.com with ESMTP; 10 Dec 2021 06:59:51 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, davem@davemloft.net,
        magnus.karlsson@intel.com, elza.mathew@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH intel-net 2/5] ice: xsk: allocate separate memory for XDP SW ring
Date:   Fri, 10 Dec 2021 15:59:38 +0100
Message-Id: <20211210145941.5865-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210145941.5865-1-maciej.fijalkowski@intel.com>
References: <20211210145941.5865-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the zero-copy data path is reusing the memory region that was
initially allocated for an array of struct ice_rx_buf for its own
purposes. This is error prone as it is based on the ice_rx_buf struct
always being the same size or bigger than what the zero-copy path needs.
There can also be old values present in that array giving rise to errors
when the zero-copy path uses it.

Fix this by freeing the ice_rx_buf region and allocating a new array for
the zero-copy path that has the right length and is initialized to zero.

Fixes: 57f7f8b6bc0b ("ice: Use xdp_buf instead of rx_buf for xsk zero-copy")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c | 19 +++++++++++++++
 drivers/net/ethernet/intel/ice/ice_txrx.c | 19 ++++++++++-----
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 29 ++++++++++++-----------
 3 files changed, 47 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 1efc635cc0f5..56606d477f05 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -6,6 +6,18 @@
 #include "ice_lib.h"
 #include "ice_dcb_lib.h"
 
+static int ice_alloc_rx_buf_zc(struct ice_rx_ring *rx_ring)
+{
+	rx_ring->xdp_buf = kcalloc(rx_ring->count, sizeof(*rx_ring->xdp_buf), GFP_KERNEL);
+	return rx_ring->xdp_buf ? 0 : -ENOMEM;
+}
+
+static int ice_alloc_rx_buf(struct ice_rx_ring *rx_ring)
+{
+	rx_ring->rx_buf = kcalloc(rx_ring->count, sizeof(*rx_ring->rx_buf), GFP_KERNEL);
+	return rx_ring->rx_buf ? 0 : -ENOMEM;
+}
+
 /**
  * __ice_vsi_get_qs_contig - Assign a contiguous chunk of queues to VSI
  * @qs_cfg: gathered variables needed for PF->VSI queues assignment
@@ -492,8 +504,12 @@ int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 			xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
 					 ring->q_index, ring->q_vector->napi.napi_id);
 
+		kfree(ring->rx_buf);
 		ring->xsk_pool = ice_xsk_pool(ring);
 		if (ring->xsk_pool) {
+			err = ice_alloc_rx_buf_zc(ring);
+			if (err)
+				return err;
 			xdp_rxq_info_unreg_mem_model(&ring->xdp_rxq);
 
 			ring->rx_buf_len =
@@ -508,6 +524,9 @@ int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 			dev_info(dev, "Registered XDP mem model MEM_TYPE_XSK_BUFF_POOL on Rx ring %d\n",
 				 ring->q_index);
 		} else {
+			err = ice_alloc_rx_buf(ring);
+			if (err)
+				return err;
 			if (!xdp_rxq_info_is_reg(&ring->xdp_rxq))
 				/* coverity[check_return] */
 				xdp_rxq_info_reg(&ring->xdp_rxq,
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index bc3ba19dc88f..227513b687b9 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -419,7 +419,10 @@ void ice_clean_rx_ring(struct ice_rx_ring *rx_ring)
 	}
 
 rx_skip_free:
-	memset(rx_ring->rx_buf, 0, sizeof(*rx_ring->rx_buf) * rx_ring->count);
+	if (rx_ring->xsk_pool)
+		memset(rx_ring->xdp_buf, 0, sizeof(*rx_ring->xdp_buf) * rx_ring->count);
+	else
+		memset(rx_ring->rx_buf, 0, sizeof(*rx_ring->rx_buf) * rx_ring->count);
 
 	/* Zero out the descriptor ring */
 	size = ALIGN(rx_ring->count * sizeof(union ice_32byte_rx_desc),
@@ -446,8 +449,13 @@ void ice_free_rx_ring(struct ice_rx_ring *rx_ring)
 		if (xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
 			xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
 	rx_ring->xdp_prog = NULL;
-	devm_kfree(rx_ring->dev, rx_ring->rx_buf);
-	rx_ring->rx_buf = NULL;
+	if (rx_ring->xsk_pool) {
+		kfree(rx_ring->xdp_buf);
+		rx_ring->xdp_buf = NULL;
+	} else {
+		kfree(rx_ring->rx_buf);
+		rx_ring->rx_buf = NULL;
+	}
 
 	if (rx_ring->desc) {
 		size = ALIGN(rx_ring->count * sizeof(union ice_32byte_rx_desc),
@@ -475,8 +483,7 @@ int ice_setup_rx_ring(struct ice_rx_ring *rx_ring)
 	/* warn if we are about to overwrite the pointer */
 	WARN_ON(rx_ring->rx_buf);
 	rx_ring->rx_buf =
-		devm_kcalloc(dev, sizeof(*rx_ring->rx_buf), rx_ring->count,
-			     GFP_KERNEL);
+		kcalloc(rx_ring->count, sizeof(*rx_ring->rx_buf), GFP_KERNEL);
 	if (!rx_ring->rx_buf)
 		return -ENOMEM;
 
@@ -505,7 +512,7 @@ int ice_setup_rx_ring(struct ice_rx_ring *rx_ring)
 	return 0;
 
 err:
-	devm_kfree(dev, rx_ring->rx_buf);
+	kfree(rx_ring->rx_buf);
 	rx_ring->rx_buf = NULL;
 	return -ENOMEM;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 75c3e98241e0..5cb61955c1f3 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -12,6 +12,11 @@
 #include "ice_txrx_lib.h"
 #include "ice_lib.h"
 
+static struct xdp_buff **ice_xdp_buf(struct ice_rx_ring *rx_ring, u32 idx)
+{
+	return &rx_ring->xdp_buf[idx];
+}
+
 /**
  * ice_qp_reset_stats - Resets all stats for rings of given index
  * @vsi: VSI that contains rings of interest
@@ -372,7 +377,7 @@ bool ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count)
 	dma_addr_t dma;
 
 	rx_desc = ICE_RX_DESC(rx_ring, ntu);
-	xdp = &rx_ring->xdp_buf[ntu];
+	xdp = ice_xdp_buf(rx_ring, ntu);
 
 	nb_buffs = min_t(u16, count, rx_ring->count - ntu);
 	nb_buffs = xsk_buff_alloc_batch(rx_ring->xsk_pool, xdp, nb_buffs);
@@ -425,9 +430,8 @@ static void ice_bump_ntc(struct ice_rx_ring *rx_ring)
  * Returns the skb on success, NULL on failure.
  */
 static struct sk_buff *
-ice_construct_skb_zc(struct ice_rx_ring *rx_ring, struct xdp_buff **xdp_arr)
+ice_construct_skb_zc(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp)
 {
-	struct xdp_buff *xdp = *xdp_arr;
 	unsigned int metasize = xdp->data - xdp->data_meta;
 	unsigned int datasize = xdp->data_end - xdp->data;
 	unsigned int datasize_hard = xdp->data_end - xdp->data_hard_start;
@@ -444,7 +448,6 @@ ice_construct_skb_zc(struct ice_rx_ring *rx_ring, struct xdp_buff **xdp_arr)
 		skb_metadata_set(skb, metasize);
 
 	xsk_buff_free(xdp);
-	*xdp_arr = NULL;
 	return skb;
 }
 
@@ -521,7 +524,7 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 	while (likely(total_rx_packets < (unsigned int)budget)) {
 		union ice_32b_rx_flex_desc *rx_desc;
 		unsigned int size, xdp_res = 0;
-		struct xdp_buff **xdp;
+		struct xdp_buff *xdp;
 		struct sk_buff *skb;
 		u16 stat_err_bits;
 		u16 vlan_tag = 0;
@@ -544,18 +547,17 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 		if (!size)
 			break;
 
-		xdp = &rx_ring->xdp_buf[rx_ring->next_to_clean];
-		xsk_buff_set_size(*xdp, size);
-		xsk_buff_dma_sync_for_cpu(*xdp, rx_ring->xsk_pool);
+		xdp = *ice_xdp_buf(rx_ring, rx_ring->next_to_clean);
+		xsk_buff_set_size(xdp, size);
+		xsk_buff_dma_sync_for_cpu(xdp, rx_ring->xsk_pool);
 
-		xdp_res = ice_run_xdp_zc(rx_ring, *xdp, xdp_prog, xdp_ring);
+		xdp_res = ice_run_xdp_zc(rx_ring, xdp, xdp_prog, xdp_ring);
 		if (xdp_res) {
 			if (xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR))
 				xdp_xmit |= xdp_res;
 			else
-				xsk_buff_free(*xdp);
+				xsk_buff_free(xdp);
 
-			*xdp = NULL;
 			total_rx_bytes += size;
 			total_rx_packets++;
 			cleaned_count++;
@@ -815,10 +817,9 @@ void ice_xsk_clean_rx_ring(struct ice_rx_ring *rx_ring)
 	u16 ntu = rx_ring->next_to_use;
 
 	for ( ; ntc != ntu; ntc = (ntc + 1) & count_mask) {
-		struct xdp_buff **xdp = &rx_ring->xdp_buf[ntc];
+		struct xdp_buff *xdp = *ice_xdp_buf(rx_ring, ntc);
 
-		xsk_buff_free(*xdp);
-		*xdp = NULL;
+		xsk_buff_free(xdp);
 	}
 }
 
-- 
2.33.1

