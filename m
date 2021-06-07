Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386B039E47B
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbhFGQwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:52:47 -0400
Received: from mga14.intel.com ([192.55.52.115]:57113 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230197AbhFGQwp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:52:45 -0400
IronPort-SDR: FrrUFKo6efipi6BbiQ4eXeaReuOhNxWKnswGNScpQOXh1V60wWgct8mQEAENQHw8MjsM7+jvVN
 dRMcSeS8si0g==
X-IronPort-AV: E=McAfee;i="6200,9189,10008"; a="204474547"
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="204474547"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2021 09:50:53 -0700
IronPort-SDR: eL0YKK8/z44CcWiYAjt5gwuXJuh8VAOPNbLMbVfKQXVLHBm3O07lozRZR9XV4mIP2xdr5STL/M
 BNkhYONhE5Bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="484841231"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 07 Jun 2021 09:50:53 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com,
        Kiran Bhandare <kiranx.bhandare@intel.com>
Subject: [PATCH net-next 04/15] ice: Refactor ice_setup_rx_ctx
Date:   Mon,  7 Jun 2021 09:53:14 -0700
Message-Id: <20210607165325.182087-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
References: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>

Move AF_XDP logic and buffer allocation out of ice_setup_rx_ctx() to a
new function ice_vsi_cfg_rxq(), so the function actually sets up the Rx
context.

Signed-off-by: Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>
Co-developed-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c | 120 +++++++++++++---------
 drivers/net/ethernet/intel/ice/ice_base.h |   2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c  |  10 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c  |   2 +-
 4 files changed, 78 insertions(+), 56 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 5985a7e5ca8a..142d660010c6 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -319,11 +319,9 @@ static unsigned int ice_rx_offset(struct ice_ring *rx_ring)
  *
  * Configure the Rx descriptor ring in RLAN context.
  */
-int ice_setup_rx_ctx(struct ice_ring *ring)
+static int ice_setup_rx_ctx(struct ice_ring *ring)
 {
-	struct device *dev = ice_pf_to_dev(ring->vsi->back);
 	int chain_len = ICE_MAX_CHAINED_RX_BUFS;
-	u16 num_bufs = ICE_DESC_UNUSED(ring);
 	struct ice_vsi *vsi = ring->vsi;
 	u32 rxdid = ICE_RXDID_FLEX_NIC;
 	struct ice_rlan_ctx rlan_ctx;
@@ -339,48 +337,6 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 	/* clear the context structure first */
 	memset(&rlan_ctx, 0, sizeof(rlan_ctx));
 
-	ring->rx_buf_len = vsi->rx_buf_len;
-
-	if (ring->vsi->type == ICE_VSI_PF) {
-		if (!xdp_rxq_info_is_reg(&ring->xdp_rxq))
-			/* coverity[check_return] */
-			xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
-					 ring->q_index, ring->q_vector->napi.napi_id);
-
-		ring->xsk_pool = ice_xsk_pool(ring);
-		if (ring->xsk_pool) {
-			xdp_rxq_info_unreg_mem_model(&ring->xdp_rxq);
-
-			ring->rx_buf_len =
-				xsk_pool_get_rx_frame_size(ring->xsk_pool);
-			/* For AF_XDP ZC, we disallow packets to span on
-			 * multiple buffers, thus letting us skip that
-			 * handling in the fast-path.
-			 */
-			chain_len = 1;
-			err = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
-							 MEM_TYPE_XSK_BUFF_POOL,
-							 NULL);
-			if (err)
-				return err;
-			xsk_pool_set_rxq_info(ring->xsk_pool, &ring->xdp_rxq);
-
-			dev_info(dev, "Registered XDP mem model MEM_TYPE_XSK_BUFF_POOL on Rx ring %d\n",
-				 ring->q_index);
-		} else {
-			if (!xdp_rxq_info_is_reg(&ring->xdp_rxq))
-				/* coverity[check_return] */
-				xdp_rxq_info_reg(&ring->xdp_rxq,
-						 ring->netdev,
-						 ring->q_index, ring->q_vector->napi.napi_id);
-
-			err = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
-							 MEM_TYPE_PAGE_SHARED,
-							 NULL);
-			if (err)
-				return err;
-		}
-	}
 	/* Receive Queue Base Address.
 	 * Indicates the starting address of the descriptor queue defined in
 	 * 128 Byte units.
@@ -415,6 +371,12 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 	 */
 	rlan_ctx.showiv = 0;
 
+	/* For AF_XDP ZC, we disallow packets to span on
+	 * multiple buffers, thus letting us skip that
+	 * handling in the fast-path.
+	 */
+	if (ring->xsk_pool)
+		chain_len = 1;
 	/* Max packet size for this queue - must not be set to a larger value
 	 * than 5 x DBUF
 	 */
@@ -438,7 +400,7 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 	/* Absolute queue number out of 2K needs to be passed */
 	err = ice_write_rxq_ctx(hw, &rlan_ctx, pf_q);
 	if (err) {
-		dev_err(dev, "Failed to set LAN Rx queue context for absolute Rx queue %d error: %d\n",
+		dev_err(ice_pf_to_dev(vsi->back), "Failed to set LAN Rx queue context for absolute Rx queue %d error: %d\n",
 			pf_q, err);
 		return -EIO;
 	}
@@ -458,6 +420,66 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 	ring->tail = hw->hw_addr + QRX_TAIL(pf_q);
 	writel(0, ring->tail);
 
+	return 0;
+}
+
+/**
+ * ice_vsi_cfg_rxq - Configure an Rx queue
+ * @ring: the ring being configured
+ *
+ * Return 0 on success and a negative value on error.
+ */
+int ice_vsi_cfg_rxq(struct ice_ring *ring)
+{
+	struct device *dev = ice_pf_to_dev(ring->vsi->back);
+	u16 num_bufs = ICE_DESC_UNUSED(ring);
+	int err;
+
+	ring->rx_buf_len = ring->vsi->rx_buf_len;
+
+	if (ring->vsi->type == ICE_VSI_PF) {
+		if (!xdp_rxq_info_is_reg(&ring->xdp_rxq))
+			/* coverity[check_return] */
+			xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
+					 ring->q_index, ring->q_vector->napi.napi_id);
+
+		ring->xsk_pool = ice_xsk_pool(ring);
+		if (ring->xsk_pool) {
+			xdp_rxq_info_unreg_mem_model(&ring->xdp_rxq);
+
+			ring->rx_buf_len =
+				xsk_pool_get_rx_frame_size(ring->xsk_pool);
+			err = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
+							 MEM_TYPE_XSK_BUFF_POOL,
+							 NULL);
+			if (err)
+				return err;
+			xsk_pool_set_rxq_info(ring->xsk_pool, &ring->xdp_rxq);
+
+			dev_info(dev, "Registered XDP mem model MEM_TYPE_XSK_BUFF_POOL on Rx ring %d\n",
+				 ring->q_index);
+		} else {
+			if (!xdp_rxq_info_is_reg(&ring->xdp_rxq))
+				/* coverity[check_return] */
+				xdp_rxq_info_reg(&ring->xdp_rxq,
+						 ring->netdev,
+						 ring->q_index, ring->q_vector->napi.napi_id);
+
+			err = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
+							 MEM_TYPE_PAGE_SHARED,
+							 NULL);
+			if (err)
+				return err;
+		}
+	}
+
+	err = ice_setup_rx_ctx(ring);
+	if (err) {
+		dev_err(dev, "ice_setup_rx_ctx failed for RxQ %d, err %d\n",
+			ring->q_index, err);
+		return err;
+	}
+
 	if (ring->xsk_pool) {
 		bool ok;
 
@@ -470,9 +492,13 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 		}
 
 		ok = ice_alloc_rx_bufs_zc(ring, num_bufs);
-		if (!ok)
+		if (!ok) {
+			u16 pf_q = ring->vsi->rxq_map[ring->q_index];
+
 			dev_info(dev, "Failed to allocate some buffers on XSK buffer pool enabled Rx ring %d (pf_q %d)\n",
 				 ring->q_index, pf_q);
+		}
+
 		return 0;
 	}
 
diff --git a/drivers/net/ethernet/intel/ice/ice_base.h b/drivers/net/ethernet/intel/ice/ice_base.h
index 44efdb627043..20e1c29aa68a 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.h
+++ b/drivers/net/ethernet/intel/ice/ice_base.h
@@ -6,7 +6,7 @@
 
 #include "ice.h"
 
-int ice_setup_rx_ctx(struct ice_ring *ring);
+int ice_vsi_cfg_rxq(struct ice_ring *ring);
 int __ice_vsi_get_qs(struct ice_qs_cfg *qs_cfg);
 int
 ice_vsi_ctrl_one_rx_ring(struct ice_vsi *vsi, bool ena, u16 rxq_idx, bool wait);
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 56e1ae558761..bd84c1f09296 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1698,15 +1698,11 @@ int ice_vsi_cfg_rxqs(struct ice_vsi *vsi)
 	ice_vsi_cfg_frame_size(vsi);
 setup_rings:
 	/* set up individual rings */
-	for (i = 0; i < vsi->num_rxq; i++) {
-		int err;
+	ice_for_each_rxq(vsi, i) {
+		int err = ice_vsi_cfg_rxq(vsi->rx_rings[i]);
 
-		err = ice_setup_rx_ctx(vsi->rx_rings[i]);
-		if (err) {
-			dev_err(ice_pf_to_dev(vsi->back), "ice_setup_rx_ctx failed for RxQ %d, err %d\n",
-				i, err);
+		if (err)
 			return err;
-		}
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index faa7b8d96adb..b0576415ffdb 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -236,7 +236,7 @@ static int ice_qp_ena(struct ice_vsi *vsi, u16 q_idx)
 		xdp_ring->xsk_pool = ice_xsk_pool(xdp_ring);
 	}
 
-	err = ice_setup_rx_ctx(rx_ring);
+	err = ice_vsi_cfg_rxq(rx_ring);
 	if (err)
 		goto free_buf;
 
-- 
2.26.2

