Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC572A2B53
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 14:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbgKBNSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 08:18:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:37117 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbgKBNSg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 08:18:36 -0500
IronPort-SDR: 0GjzbbETSwf2UXBxXTtx23d5vIScxDYrjlLxat1H9mWGJqL6p99sMaCufqhX8TEcv4nzLhbvFq
 RdeyieWhTs2g==
X-IronPort-AV: E=McAfee;i="6000,8403,9792"; a="169014002"
X-IronPort-AV: E=Sophos;i="5.77,445,1596524400"; 
   d="scan'208";a="169014002"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 05:18:35 -0800
IronPort-SDR: gXs2cRatzNWLtI1Kc93gxLyk5eZYzv6rjauVohxwDpwa51yIVRrhc2sN9aYH87I29DZ1vrObmi
 j7AG2yaEj4aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,445,1596524400"; 
   d="scan'208";a="538016734"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.63])
  by orsmga005.jf.intel.com with ESMTP; 02 Nov 2020 05:18:33 -0800
From:   Michal Swiatkowski <michal.swiatkowski@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, bjorn.topel@intel.com,
        anthony.l.nguyen@intel.com,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH net-next] ice: Remove xsk_buff_pool from VSI structure
Date:   Mon,  2 Nov 2020 04:37:27 -0500
Message-Id: <20201102093727.15388-1-michal.swiatkowski@intel.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current implementation of netdev already contains xsk_buff_pools.
We no longer have to contain these structures in ice_vsi.

Refactor the code to operate on netdev-provided xsk_buff_pools.

Move scheduling napi on each queue to a separate function to
simplify setup function.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      | 10 +---
 drivers/net/ethernet/intel/ice/ice_main.c | 28 +++++----
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 71 +++--------------------
 3 files changed, 30 insertions(+), 79 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index a0723831c4e4..c53cd2e84ef6 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -39,6 +39,7 @@
 #include <net/devlink.h>
 #include <net/ipv6.h>
 #include <net/xdp_sock.h>
+#include <net/xdp_sock_drv.h>
 #include <net/geneve.h>
 #include <net/gre.h>
 #include <net/udp_tunnel.h>
@@ -325,9 +326,6 @@ struct ice_vsi {
 	struct ice_ring **xdp_rings;	 /* XDP ring array */
 	u16 num_xdp_txq;		 /* Used XDP queues */
 	u8 xdp_mapping_mode;		 /* ICE_MAP_MODE_[CONTIG|SCATTER] */
-	struct xsk_buff_pool **xsk_pools;
-	u16 num_xsk_pools_used;
-	u16 num_xsk_pools;
 } ____cacheline_internodealigned_in_smp;
 
 /* struct that defines an interrupt vector */
@@ -516,17 +514,15 @@ static inline void ice_set_ring_xdp(struct ice_ring *ring)
  */
 static inline struct xsk_buff_pool *ice_xsk_pool(struct ice_ring *ring)
 {
-	struct xsk_buff_pool **pools = ring->vsi->xsk_pools;
 	u16 qid = ring->q_index;
 
 	if (ice_ring_is_xdp(ring))
 		qid -= ring->vsi->num_xdp_txq;
 
-	if (qid >= ring->vsi->num_xsk_pools || !pools || !pools[qid] ||
-	    !ice_is_xdp_ena_vsi(ring->vsi))
+	if (!ice_is_xdp_ena_vsi(ring->vsi))
 		return NULL;
 
-	return pools[qid];
+	return xsk_get_pool_from_qid(ring->vsi->netdev, qid);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 2dea4d0e9415..997bc37f7d2b 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2481,6 +2481,22 @@ int ice_destroy_xdp_rings(struct ice_vsi *vsi)
 			       max_txqs);
 }
 
+/**
+ * ice_vsi_rx_napi_schedule - Schedule napi on RX queues from VSI
+ * @vsi: VSI to schedule napi on
+ */
+static void ice_vsi_rx_napi_schedule(struct ice_vsi *vsi)
+{
+	int i;
+
+	ice_for_each_rxq(vsi, i) {
+		struct ice_ring *rx_ring = vsi->rx_rings[i];
+
+		if (rx_ring->xsk_pool)
+			napi_schedule(&rx_ring->q_vector->napi);
+	}
+}
+
 /**
  * ice_xdp_setup_prog - Add or remove XDP eBPF program
  * @vsi: VSI to setup XDP for
@@ -2525,16 +2541,8 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 	if (if_running)
 		ret = ice_up(vsi);
 
-	if (!ret && prog && vsi->xsk_pools) {
-		int i;
-
-		ice_for_each_rxq(vsi, i) {
-			struct ice_ring *rx_ring = vsi->rx_rings[i];
-
-			if (rx_ring->xsk_pool)
-				napi_schedule(&rx_ring->q_vector->napi);
-		}
-	}
+	if (!ret && prog)
+		ice_vsi_rx_napi_schedule(vsi);
 
 	return (ret || xdp_ring_err) ? -ENOMEM : 0;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 797886524054..4d44431c71a0 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -259,45 +259,6 @@ static int ice_qp_ena(struct ice_vsi *vsi, u16 q_idx)
 	return err;
 }
 
-/**
- * ice_xsk_alloc_pools - allocate a buffer pool for an XDP socket
- * @vsi: VSI to allocate the buffer pool on
- *
- * Returns 0 on success, negative on error
- */
-static int ice_xsk_alloc_pools(struct ice_vsi *vsi)
-{
-	if (vsi->xsk_pools)
-		return 0;
-
-	vsi->xsk_pools = kcalloc(vsi->num_xsk_pools, sizeof(*vsi->xsk_pools),
-				 GFP_KERNEL);
-
-	if (!vsi->xsk_pools) {
-		vsi->num_xsk_pools = 0;
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
-/**
- * ice_xsk_remove_pool - Remove an buffer pool for a certain ring/qid
- * @vsi: VSI from which the VSI will be removed
- * @qid: Ring/qid associated with the buffer pool
- */
-static void ice_xsk_remove_pool(struct ice_vsi *vsi, u16 qid)
-{
-	vsi->xsk_pools[qid] = NULL;
-	vsi->num_xsk_pools_used--;
-
-	if (vsi->num_xsk_pools_used == 0) {
-		kfree(vsi->xsk_pools);
-		vsi->xsk_pools = NULL;
-		vsi->num_xsk_pools = 0;
-	}
-}
-
 /**
  * ice_xsk_pool_disable - disable a buffer pool region
  * @vsi: Current VSI
@@ -307,12 +268,12 @@ static void ice_xsk_remove_pool(struct ice_vsi *vsi, u16 qid)
  */
 static int ice_xsk_pool_disable(struct ice_vsi *vsi, u16 qid)
 {
-	if (!vsi->xsk_pools || qid >= vsi->num_xsk_pools ||
-	    !vsi->xsk_pools[qid])
+	struct xsk_buff_pool *pool = xsk_get_pool_from_qid(vsi->netdev, qid);
+
+	if (!pool)
 		return -EINVAL;
 
-	xsk_pool_dma_unmap(vsi->xsk_pools[qid], ICE_RX_DMA_ATTR);
-	ice_xsk_remove_pool(vsi, qid);
+	xsk_pool_dma_unmap(pool, ICE_RX_DMA_ATTR);
 
 	return 0;
 }
@@ -333,22 +294,11 @@ ice_xsk_pool_enable(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
 	if (vsi->type != ICE_VSI_PF)
 		return -EINVAL;
 
-	if (!vsi->num_xsk_pools)
-		vsi->num_xsk_pools = min_t(u16, vsi->num_rxq, vsi->num_txq);
-	if (qid >= vsi->num_xsk_pools)
+	if (qid >= vsi->netdev->real_num_rx_queues ||
+	    qid >= vsi->netdev->real_num_tx_queues)
 		return -EINVAL;
 
-	err = ice_xsk_alloc_pools(vsi);
-	if (err)
-		return err;
-
-	if (vsi->xsk_pools && vsi->xsk_pools[qid])
-		return -EBUSY;
-
-	vsi->xsk_pools[qid] = pool;
-	vsi->num_xsk_pools_used++;
-
-	err = xsk_pool_dma_map(vsi->xsk_pools[qid], ice_pf_to_dev(vsi->back),
+	err = xsk_pool_dma_map(pool, ice_pf_to_dev(vsi->back),
 			       ICE_RX_DMA_ATTR);
 	if (err)
 		return err;
@@ -842,11 +792,8 @@ bool ice_xsk_any_rx_ring_ena(struct ice_vsi *vsi)
 {
 	int i;
 
-	if (!vsi->xsk_pools)
-		return false;
-
-	for (i = 0; i < vsi->num_xsk_pools; i++) {
-		if (vsi->xsk_pools[i])
+	ice_for_each_rxq(vsi, i) {
+		if (xsk_get_pool_from_qid(vsi->netdev, i))
 			return true;
 	}
 
-- 
2.21.3

