Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075F7314576
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 02:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhBIBQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 20:16:45 -0500
Received: from mga07.intel.com ([134.134.136.100]:36361 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229968AbhBIBQo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 20:16:44 -0500
IronPort-SDR: CmyouXm3L/zdR7+EDYJrFrpUZPHs+dJWNye4tyd2PukjZJKTK9xLdw62ummcD/NNPk2Y5YXPEG
 BTqkznNg/g8Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="245879731"
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="245879731"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 17:15:47 -0800
IronPort-SDR: ts79EONVpE0qu9gzyY441xEVBBYMe8Rt9rtjga0wv8/UJlUReFlGy1zMn4yasiDeb6W+ahMkXG
 TOQ+jB7sytjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="487669597"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 08 Feb 2021 17:15:46 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Michal Swiatkowski <michal.swiatkowski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        Kiran Bhandare <kiranx.bhandare@intel.com>
Subject: [PATCH net-next 03/12] ice: Remove xsk_buff_pool from VSI structure
Date:   Mon,  8 Feb 2021 17:16:27 -0800
Message-Id: <20210209011636.1989093-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210209011636.1989093-1-anthony.l.nguyen@intel.com>
References: <20210209011636.1989093-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@intel.com>

Current implementation of netdev already contains xsk_buff_pools.
We no longer have to contain these structures in ice_vsi.

Refactor the code to operate on netdev-provided xsk_buff_pools.

Move scheduling napi on each queue to a separate function to
simplify setup function.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      | 10 +---
 drivers/net/ethernet/intel/ice/ice_main.c | 28 +++++----
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 71 +++--------------------
 3 files changed, 30 insertions(+), 79 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index fca428c879ec..d38f8e8e7e0e 100644
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
@@ -326,9 +327,6 @@ struct ice_vsi {
 	struct ice_ring **xdp_rings;	 /* XDP ring array */
 	u16 num_xdp_txq;		 /* Used XDP queues */
 	u8 xdp_mapping_mode;		 /* ICE_MAP_MODE_[CONTIG|SCATTER] */
-	struct xsk_buff_pool **xsk_pools;
-	u16 num_xsk_pools_used;
-	u16 num_xsk_pools;
 } ____cacheline_internodealigned_in_smp;
 
 /* struct that defines an interrupt vector */
@@ -517,17 +515,15 @@ static inline void ice_set_ring_xdp(struct ice_ring *ring)
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
index 98cd44a3ccf7..c22f8a5c8cdf 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2475,6 +2475,22 @@ int ice_destroy_xdp_rings(struct ice_vsi *vsi)
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
@@ -2519,16 +2535,8 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
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
index 1782146db644..875fa0cbef56 100644
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
2.26.2

