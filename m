Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9687E3EC33E
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 16:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238623AbhHNOYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 10:24:05 -0400
Received: from mga07.intel.com ([134.134.136.100]:45183 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238634AbhHNOXc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 10:23:32 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10075"; a="279426313"
X-IronPort-AV: E=Sophos;i="5.84,321,1620716400"; 
   d="scan'208";a="279426313"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2021 07:23:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,321,1620716400"; 
   d="scan'208";a="447568453"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga007.fm.intel.com with ESMTP; 14 Aug 2021 07:22:59 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com, jesse.brandeburg@intel.com,
        alexandr.lobakin@intel.com, joamaki@gmail.com, toke@redhat.com,
        brett.creeley@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v5 intel-next 3/9] ice: split ice_ring onto Tx/Rx separate structs
Date:   Sat, 14 Aug 2021 16:08:06 +0200
Message-Id: <20210814140812.46632-4-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210814140812.46632-1-maciej.fijalkowski@intel.com>
References: <20210814140812.46632-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While it was convenient to have a generic ring structure that served
both Tx and Rx sides, next commits are going to introduce several
Tx-specific fields, so in order to avoid hurting the Rx side, let's
pull out the Tx ring onto new ice_tx_ring and ice_rx_ring structs.

Rx ring could be handled by the old ice_ring which would reduce the code
churn within this patch, but this would make things asymmetric.

Make the union out of the ring container within ice_q_vector so that it
is possible to iterate over newly introduced ice_tx_ring.

Remove the @size as it's only accessed from control path and it can be
calculated pretty easily.

Change definitions of ice_update_ring_stats and
ice_fetch_u64_stats_per_ring so that they are ring agnostic and can be
used for both Rx and Tx rings.

Sizes of Rx and Tx ring structs are 256 and 192 bytes, respectively. In
Rx ring xdp_rxq_info occupies its own cacheline, so it's the major
difference now.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |  33 +++--
 drivers/net/ethernet/intel/ice/ice_base.c     |  49 +++----
 drivers/net/ethernet/intel/ice/ice_base.h     |   8 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   5 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |  10 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  49 ++++---
 drivers/net/ethernet/intel/ice/ice_lib.c      |  60 +++++---
 drivers/net/ethernet/intel/ice/ice_lib.h      |   6 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |  66 +++++----
 drivers/net/ethernet/intel/ice/ice_ptp.c      |   2 +-
 drivers/net/ethernet/intel/ice/ice_ptp.h      |   4 +-
 drivers/net/ethernet/intel/ice/ice_trace.h    |  28 ++--
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 131 ++++++++++--------
 drivers/net/ethernet/intel/ice/ice_txrx.h     | 114 +++++++++------
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  18 +--
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h |  14 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |   2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c      |  49 ++++---
 drivers/net/ethernet/intel/ice/ice_xsk.h      |  20 +--
 19 files changed, 375 insertions(+), 293 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index eadcb9958346..191bb8e97aad 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -266,8 +266,8 @@ struct ice_vsi {
 	struct ice_sw *vsw;		 /* switch this VSI is on */
 	struct ice_pf *back;		 /* back pointer to PF */
 	struct ice_port_info *port_info; /* back pointer to port_info */
-	struct ice_ring **rx_rings;	 /* Rx ring array */
-	struct ice_ring **tx_rings;	 /* Tx ring array */
+	struct ice_rx_ring **rx_rings;	 /* Rx ring array */
+	struct ice_tx_ring **tx_rings;	 /* Tx ring array */
 	struct ice_q_vector **q_vectors; /* q_vector array */
 
 	irqreturn_t (*irq_handler)(int irq, void *data);
@@ -344,7 +344,7 @@ struct ice_vsi {
 	u16 qset_handle[ICE_MAX_TRAFFIC_CLASS];
 	struct ice_tc_cfg tc_cfg;
 	struct bpf_prog *xdp_prog;
-	struct ice_ring **xdp_rings;	 /* XDP ring array */
+	struct ice_tx_ring **xdp_rings;	 /* XDP ring array */
 	unsigned long *af_xdp_zc_qps;	 /* tracks AF_XDP ZC enabled qps */
 	u16 num_xdp_txq;		 /* Used XDP queues */
 	u8 xdp_mapping_mode;		 /* ICE_MAP_MODE_[CONTIG|SCATTER] */
@@ -556,25 +556,42 @@ static inline bool ice_is_xdp_ena_vsi(struct ice_vsi *vsi)
 	return !!vsi->xdp_prog;
 }
 
-static inline void ice_set_ring_xdp(struct ice_ring *ring)
+static inline void ice_set_ring_xdp(struct ice_tx_ring *ring)
 {
 	ring->flags |= ICE_TX_FLAGS_RING_XDP;
 }
 
 /**
  * ice_xsk_pool - get XSK buffer pool bound to a ring
- * @ring: ring to use
+ * @ring: Rx ring to use
  *
  * Returns a pointer to xdp_umem structure if there is a buffer pool present,
  * NULL otherwise.
  */
-static inline struct xsk_buff_pool *ice_xsk_pool(struct ice_ring *ring)
+static inline struct xsk_buff_pool *ice_xsk_pool(struct ice_rx_ring *ring)
 {
 	struct ice_vsi *vsi = ring->vsi;
 	u16 qid = ring->q_index;
 
-	if (ice_ring_is_xdp(ring))
-		qid -= vsi->num_xdp_txq;
+	if (!ice_is_xdp_ena_vsi(vsi) || !test_bit(qid, vsi->af_xdp_zc_qps))
+		return NULL;
+
+	return xsk_get_pool_from_qid(vsi->netdev, qid);
+}
+
+/**
+ * ice_tx_xsk_pool - get XSK buffer pool bound to a ring
+ * @ring: Tx ring to use
+ *
+ * Returns a pointer to xdp_umem structure if there is a buffer pool present,
+ * NULL otherwise. Tx equivalent of ice_xsk_pool.
+ */
+static inline struct xsk_buff_pool *ice_tx_xsk_pool(struct ice_tx_ring *ring)
+{
+	struct ice_vsi *vsi = ring->vsi;
+	u16 qid;
+
+	qid = ring->q_index - vsi->num_xdp_txq;
 
 	if (!ice_is_xdp_ena_vsi(vsi) || !test_bit(qid, vsi->af_xdp_zc_qps))
 		return NULL;
diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index ab1f88a2af2c..5841616d3c39 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -148,7 +148,8 @@ static void ice_free_q_vector(struct ice_vsi *vsi, int v_idx)
 {
 	struct ice_q_vector *q_vector;
 	struct ice_pf *pf = vsi->back;
-	struct ice_ring *ring;
+	struct ice_tx_ring *tx_ring;
+	struct ice_rx_ring *rx_ring;
 	struct device *dev;
 
 	dev = ice_pf_to_dev(pf);
@@ -158,10 +159,10 @@ static void ice_free_q_vector(struct ice_vsi *vsi, int v_idx)
 	}
 	q_vector = vsi->q_vectors[v_idx];
 
-	ice_for_each_ring(ring, q_vector->tx)
-		ring->q_vector = NULL;
-	ice_for_each_ring(ring, q_vector->rx)
-		ring->q_vector = NULL;
+	ice_for_each_tx_ring(tx_ring, q_vector->tx)
+		tx_ring->q_vector = NULL;
+	ice_for_each_rx_ring(rx_ring, q_vector->rx)
+		rx_ring->q_vector = NULL;
 
 	/* only VSI with an associated netdev is set up with NAPI */
 	if (vsi->netdev)
@@ -208,7 +209,7 @@ static void ice_cfg_itr_gran(struct ice_hw *hw)
  * @ring: ring to get the absolute queue index
  * @tc: traffic class number
  */
-static u16 ice_calc_q_handle(struct ice_vsi *vsi, struct ice_ring *ring, u8 tc)
+static u16 ice_calc_txq_handle(struct ice_vsi *vsi, struct ice_tx_ring *ring, u8 tc)
 {
 	WARN_ONCE(ice_ring_is_xdp(ring) && tc, "XDP ring can't belong to TC other than 0\n");
 
@@ -226,7 +227,7 @@ static u16 ice_calc_q_handle(struct ice_vsi *vsi, struct ice_ring *ring, u8 tc)
  * This enables/disables XPS for a given Tx descriptor ring
  * based on the TCs enabled for the VSI that ring belongs to.
  */
-static void ice_cfg_xps_tx_ring(struct ice_ring *ring)
+static void ice_cfg_xps_tx_ring(struct ice_tx_ring *ring)
 {
 	if (!ring->q_vector || !ring->netdev)
 		return;
@@ -248,7 +249,7 @@ static void ice_cfg_xps_tx_ring(struct ice_ring *ring)
  * Configure the Tx descriptor ring in TLAN context.
  */
 static void
-ice_setup_tx_ctx(struct ice_ring *ring, struct ice_tlan_ctx *tlan_ctx, u16 pf_q)
+ice_setup_tx_ctx(struct ice_tx_ring *ring, struct ice_tlan_ctx *tlan_ctx, u16 pf_q)
 {
 	struct ice_vsi *vsi = ring->vsi;
 	struct ice_hw *hw = &vsi->back->hw;
@@ -260,7 +261,7 @@ ice_setup_tx_ctx(struct ice_ring *ring, struct ice_tlan_ctx *tlan_ctx, u16 pf_q)
 	/* Transmit Queue Length */
 	tlan_ctx->qlen = ring->count;
 
-	ice_set_cgd_num(tlan_ctx, ring);
+	ice_set_cgd_num(tlan_ctx, ring->dcb_tc);
 
 	/* PF number */
 	tlan_ctx->pf_num = hw->pf_id;
@@ -314,7 +315,7 @@ ice_setup_tx_ctx(struct ice_ring *ring, struct ice_tlan_ctx *tlan_ctx, u16 pf_q)
  *
  * Returns the offset value for ring into the data buffer.
  */
-static unsigned int ice_rx_offset(struct ice_ring *rx_ring)
+static unsigned int ice_rx_offset(struct ice_rx_ring *rx_ring)
 {
 	if (ice_ring_uses_build_skb(rx_ring))
 		return ICE_SKB_PAD;
@@ -330,7 +331,7 @@ static unsigned int ice_rx_offset(struct ice_ring *rx_ring)
  *
  * Configure the Rx descriptor ring in RLAN context.
  */
-static int ice_setup_rx_ctx(struct ice_ring *ring)
+static int ice_setup_rx_ctx(struct ice_rx_ring *ring)
 {
 	int chain_len = ICE_MAX_CHAINED_RX_BUFS;
 	struct ice_vsi *vsi = ring->vsi;
@@ -441,7 +442,7 @@ static int ice_setup_rx_ctx(struct ice_ring *ring)
  *
  * Return 0 on success and a negative value on error.
  */
-int ice_vsi_cfg_rxq(struct ice_ring *ring)
+int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 {
 	struct device *dev = ice_pf_to_dev(ring->vsi->back);
 	u16 num_bufs = ICE_DESC_UNUSED(ring);
@@ -662,16 +663,16 @@ void ice_vsi_map_rings_to_vectors(struct ice_vsi *vsi)
 		tx_rings_per_v = (u8)DIV_ROUND_UP(tx_rings_rem,
 						  q_vectors - v_id);
 		q_vector->num_ring_tx = tx_rings_per_v;
-		q_vector->tx.ring = NULL;
+		q_vector->tx.tx_ring = NULL;
 		q_vector->tx.itr_idx = ICE_TX_ITR;
 		q_base = vsi->num_txq - tx_rings_rem;
 
 		for (q_id = q_base; q_id < (q_base + tx_rings_per_v); q_id++) {
-			struct ice_ring *tx_ring = vsi->tx_rings[q_id];
+			struct ice_tx_ring *tx_ring = vsi->tx_rings[q_id];
 
 			tx_ring->q_vector = q_vector;
-			tx_ring->next = q_vector->tx.ring;
-			q_vector->tx.ring = tx_ring;
+			tx_ring->next = q_vector->tx.tx_ring;
+			q_vector->tx.tx_ring = tx_ring;
 		}
 		tx_rings_rem -= tx_rings_per_v;
 
@@ -679,16 +680,16 @@ void ice_vsi_map_rings_to_vectors(struct ice_vsi *vsi)
 		rx_rings_per_v = (u8)DIV_ROUND_UP(rx_rings_rem,
 						  q_vectors - v_id);
 		q_vector->num_ring_rx = rx_rings_per_v;
-		q_vector->rx.ring = NULL;
+		q_vector->rx.rx_ring = NULL;
 		q_vector->rx.itr_idx = ICE_RX_ITR;
 		q_base = vsi->num_rxq - rx_rings_rem;
 
 		for (q_id = q_base; q_id < (q_base + rx_rings_per_v); q_id++) {
-			struct ice_ring *rx_ring = vsi->rx_rings[q_id];
+			struct ice_rx_ring *rx_ring = vsi->rx_rings[q_id];
 
 			rx_ring->q_vector = q_vector;
-			rx_ring->next = q_vector->rx.ring;
-			q_vector->rx.ring = rx_ring;
+			rx_ring->next = q_vector->rx.rx_ring;
+			q_vector->rx.rx_ring = rx_ring;
 		}
 		rx_rings_rem -= rx_rings_per_v;
 	}
@@ -713,7 +714,7 @@ void ice_vsi_free_q_vectors(struct ice_vsi *vsi)
  * @qg_buf: queue group buffer
  */
 int
-ice_vsi_cfg_txq(struct ice_vsi *vsi, struct ice_ring *ring,
+ice_vsi_cfg_txq(struct ice_vsi *vsi, struct ice_tx_ring *ring,
 		struct ice_aqc_add_tx_qgrp *qg_buf)
 {
 	u8 buf_len = struct_size(qg_buf, txqs, 1);
@@ -748,7 +749,7 @@ ice_vsi_cfg_txq(struct ice_vsi *vsi, struct ice_ring *ring,
 	/* Add unique software queue handle of the Tx queue per
 	 * TC into the VSI Tx ring
 	 */
-	ring->q_handle = ice_calc_q_handle(vsi, ring, tc);
+	ring->q_handle = ice_calc_txq_handle(vsi, ring, tc);
 
 	status = ice_ena_vsi_txq(vsi->port_info, vsi->idx, tc, ring->q_handle,
 				 1, qg_buf, buf_len, NULL);
@@ -872,7 +873,7 @@ void ice_trigger_sw_intr(struct ice_hw *hw, struct ice_q_vector *q_vector)
  */
 int
 ice_vsi_stop_tx_ring(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
-		     u16 rel_vmvf_num, struct ice_ring *ring,
+		     u16 rel_vmvf_num, struct ice_tx_ring *ring,
 		     struct ice_txq_meta *txq_meta)
 {
 	struct ice_pf *pf = vsi->back;
@@ -929,7 +930,7 @@ ice_vsi_stop_tx_ring(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
  * are needed for stopping Tx queue
  */
 void
-ice_fill_txq_meta(struct ice_vsi *vsi, struct ice_ring *ring,
+ice_fill_txq_meta(struct ice_vsi *vsi, struct ice_tx_ring *ring,
 		  struct ice_txq_meta *txq_meta)
 {
 	u8 tc;
diff --git a/drivers/net/ethernet/intel/ice/ice_base.h b/drivers/net/ethernet/intel/ice/ice_base.h
index 20e1c29aa68a..b67dca417acb 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.h
+++ b/drivers/net/ethernet/intel/ice/ice_base.h
@@ -6,7 +6,7 @@
 
 #include "ice.h"
 
-int ice_vsi_cfg_rxq(struct ice_ring *ring);
+int ice_vsi_cfg_rxq(struct ice_rx_ring *ring);
 int __ice_vsi_get_qs(struct ice_qs_cfg *qs_cfg);
 int
 ice_vsi_ctrl_one_rx_ring(struct ice_vsi *vsi, bool ena, u16 rxq_idx, bool wait);
@@ -15,7 +15,7 @@ int ice_vsi_alloc_q_vectors(struct ice_vsi *vsi);
 void ice_vsi_map_rings_to_vectors(struct ice_vsi *vsi);
 void ice_vsi_free_q_vectors(struct ice_vsi *vsi);
 int
-ice_vsi_cfg_txq(struct ice_vsi *vsi, struct ice_ring *ring,
+ice_vsi_cfg_txq(struct ice_vsi *vsi, struct ice_tx_ring *ring,
 		struct ice_aqc_add_tx_qgrp *qg_buf);
 void ice_cfg_itr(struct ice_hw *hw, struct ice_q_vector *q_vector);
 void
@@ -25,9 +25,9 @@ ice_cfg_rxq_interrupt(struct ice_vsi *vsi, u16 rxq, u16 msix_idx, u16 itr_idx);
 void ice_trigger_sw_intr(struct ice_hw *hw, struct ice_q_vector *q_vector);
 int
 ice_vsi_stop_tx_ring(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
-		     u16 rel_vmvf_num, struct ice_ring *ring,
+		     u16 rel_vmvf_num, struct ice_tx_ring *ring,
 		     struct ice_txq_meta *txq_meta);
 void
-ice_fill_txq_meta(struct ice_vsi *vsi, struct ice_ring *ring,
+ice_fill_txq_meta(struct ice_vsi *vsi, struct ice_tx_ring *ring,
 		  struct ice_txq_meta *txq_meta);
 #endif /* _ICE_BASE_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 926cf748c5ec..b7519dde4e0d 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -194,7 +194,8 @@ u8 ice_dcb_get_tc(struct ice_vsi *vsi, int queue_index)
  */
 void ice_vsi_cfg_dcb_rings(struct ice_vsi *vsi)
 {
-	struct ice_ring *tx_ring, *rx_ring;
+	struct ice_tx_ring *tx_ring;
+	struct ice_rx_ring *rx_ring;
 	u16 qoffset, qcount;
 	int i, n;
 
@@ -814,7 +815,7 @@ void ice_update_dcb_stats(struct ice_pf *pf)
  * tag will already be configured with the correct ID and priority bits
  */
 void
-ice_tx_prepare_vlan_flags_dcb(struct ice_ring *tx_ring,
+ice_tx_prepare_vlan_flags_dcb(struct ice_tx_ring *tx_ring,
 			      struct ice_tx_buf *first)
 {
 	struct sk_buff *skb = first->skb;
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
index 261b6e2ed7bc..5358bdb5f8ea 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
@@ -28,7 +28,7 @@ void ice_vsi_cfg_dcb_rings(struct ice_vsi *vsi);
 int ice_init_pf_dcb(struct ice_pf *pf, bool locked);
 void ice_update_dcb_stats(struct ice_pf *pf);
 void
-ice_tx_prepare_vlan_flags_dcb(struct ice_ring *tx_ring,
+ice_tx_prepare_vlan_flags_dcb(struct ice_tx_ring *tx_ring,
 			      struct ice_tx_buf *first);
 void
 ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
@@ -49,9 +49,9 @@ static inline bool ice_find_q_in_range(u16 low, u16 high, unsigned int tx_q)
 }
 
 static inline void
-ice_set_cgd_num(struct ice_tlan_ctx *tlan_ctx, struct ice_ring *ring)
+ice_set_cgd_num(struct ice_tlan_ctx *tlan_ctx, u8 dcb_tc)
 {
-	tlan_ctx->cgd_num = ring->dcb_tc;
+	tlan_ctx->cgd_num = dcb_tc;
 }
 
 static inline bool ice_is_dcb_active(struct ice_pf *pf)
@@ -95,7 +95,7 @@ ice_pf_dcb_cfg(struct ice_pf __always_unused *pf,
 }
 
 static inline int
-ice_tx_prepare_vlan_flags_dcb(struct ice_ring __always_unused *tx_ring,
+ice_tx_prepare_vlan_flags_dcb(struct ice_tx_ring __always_unused *tx_ring,
 			      struct ice_tx_buf __always_unused *first)
 {
 	return 0;
@@ -119,6 +119,6 @@ static inline void ice_update_dcb_stats(struct ice_pf *pf) { }
 static inline void
 ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf, struct ice_rq_event_info *event) { }
 static inline void ice_vsi_cfg_netdev_tc(struct ice_vsi *vsi, u8 ena_tc) { }
-static inline void ice_set_cgd_num(struct ice_tlan_ctx *tlan_ctx, struct ice_ring *ring) { }
+static inline void ice_set_cgd_num(struct ice_tlan_ctx *tlan_ctx, u8 dcb_tc) { }
 #endif /* CONFIG_DCB */
 #endif /* _ICE_DCB_LIB_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 45b94e4205eb..c1fac0ebf246 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -584,7 +584,7 @@ static bool ice_lbtest_check_frame(u8 *frame)
  *
  * Function sends loopback packets on a test Tx ring.
  */
-static int ice_diag_send(struct ice_ring *tx_ring, u8 *data, u16 size)
+static int ice_diag_send(struct ice_tx_ring *tx_ring, u8 *data, u16 size)
 {
 	struct ice_tx_desc *tx_desc;
 	struct ice_tx_buf *tx_buf;
@@ -637,7 +637,7 @@ static int ice_diag_send(struct ice_ring *tx_ring, u8 *data, u16 size)
  * Function receives loopback packets and verify their correctness.
  * Returns number of received valid frames.
  */
-static int ice_lbtest_receive_frames(struct ice_ring *rx_ring)
+static int ice_lbtest_receive_frames(struct ice_rx_ring *rx_ring)
 {
 	struct ice_rx_buf *rx_buf;
 	int valid_frames, i;
@@ -676,9 +676,10 @@ static u64 ice_loopback_test(struct net_device *netdev)
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *orig_vsi = np->vsi, *test_vsi;
 	struct ice_pf *pf = orig_vsi->back;
-	struct ice_ring *tx_ring, *rx_ring;
 	u8 broadcast[ETH_ALEN], ret = 0;
 	int num_frames, valid_frames;
+	struct ice_tx_ring *tx_ring;
+	struct ice_rx_ring *rx_ring;
 	struct device *dev;
 	u8 *tx_frame;
 	int i;
@@ -1318,7 +1319,8 @@ ice_get_ethtool_stats(struct net_device *netdev,
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
-	struct ice_ring *ring;
+	struct ice_tx_ring *tx_ring;
+	struct ice_rx_ring *rx_ring;
 	unsigned int j;
 	int i = 0;
 	char *p;
@@ -1336,10 +1338,10 @@ ice_get_ethtool_stats(struct net_device *netdev,
 	rcu_read_lock();
 
 	ice_for_each_alloc_txq(vsi, j) {
-		ring = READ_ONCE(vsi->tx_rings[j]);
-		if (ring) {
-			data[i++] = ring->stats.pkts;
-			data[i++] = ring->stats.bytes;
+		tx_ring = READ_ONCE(vsi->tx_rings[j]);
+		if (tx_ring) {
+			data[i++] = tx_ring->stats.pkts;
+			data[i++] = tx_ring->stats.bytes;
 		} else {
 			data[i++] = 0;
 			data[i++] = 0;
@@ -1347,10 +1349,10 @@ ice_get_ethtool_stats(struct net_device *netdev,
 	}
 
 	ice_for_each_alloc_rxq(vsi, j) {
-		ring = READ_ONCE(vsi->rx_rings[j]);
-		if (ring) {
-			data[i++] = ring->stats.pkts;
-			data[i++] = ring->stats.bytes;
+		rx_ring = READ_ONCE(vsi->rx_rings[j]);
+		if (rx_ring) {
+			data[i++] = rx_ring->stats.pkts;
+			data[i++] = rx_ring->stats.bytes;
 		} else {
 			data[i++] = 0;
 			data[i++] = 0;
@@ -2667,9 +2669,10 @@ ice_get_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
 static int
 ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
 {
-	struct ice_ring *tx_rings = NULL, *rx_rings = NULL;
 	struct ice_netdev_priv *np = netdev_priv(netdev);
-	struct ice_ring *xdp_rings = NULL;
+	struct ice_tx_ring *xdp_rings = NULL;
+	struct ice_tx_ring *tx_rings = NULL;
+	struct ice_rx_ring *rx_rings = NULL;
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
 	int i, timeout = 50, err = 0;
@@ -3255,7 +3258,7 @@ static u32 ice_get_combined_cnt(struct ice_vsi *vsi)
 	ice_for_each_q_vector(vsi, q_idx) {
 		struct ice_q_vector *q_vector = vsi->q_vectors[q_idx];
 
-		if (q_vector->rx.ring && q_vector->tx.ring)
+		if (q_vector->rx.rx_ring && q_vector->tx.tx_ring)
 			combined++;
 	}
 
@@ -3481,21 +3484,21 @@ static int ice_set_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
 static int
 ice_get_rc_coalesce(struct ethtool_coalesce *ec, struct ice_ring_container *rc)
 {
-	if (!rc->ring)
+	if (!rc->rx_ring)
 		return -EINVAL;
 
 	switch (rc->type) {
 	case ICE_RX_CONTAINER:
 		ec->use_adaptive_rx_coalesce = ITR_IS_DYNAMIC(rc);
 		ec->rx_coalesce_usecs = rc->itr_setting;
-		ec->rx_coalesce_usecs_high = rc->ring->q_vector->intrl;
+		ec->rx_coalesce_usecs_high = rc->rx_ring->q_vector->intrl;
 		break;
 	case ICE_TX_CONTAINER:
 		ec->use_adaptive_tx_coalesce = ITR_IS_DYNAMIC(rc);
 		ec->tx_coalesce_usecs = rc->itr_setting;
 		break;
 	default:
-		dev_dbg(ice_pf_to_dev(rc->ring->vsi->back), "Invalid c_type %d\n", rc->type);
+		dev_dbg(ice_pf_to_dev(rc->rx_ring->vsi->back), "Invalid c_type %d\n", rc->type);
 		return -EINVAL;
 	}
 
@@ -3597,7 +3600,7 @@ ice_set_rc_coalesce(struct ethtool_coalesce *ec,
 	struct ice_pf *pf = vsi->back;
 	u16 itr_setting;
 
-	if (!rc->ring)
+	if (!rc->rx_ring)
 		return -EINVAL;
 
 	switch (rc->type) {
@@ -3610,15 +3613,15 @@ ice_set_rc_coalesce(struct ethtool_coalesce *ec,
 				    ICE_MAX_INTRL);
 			return -EINVAL;
 		}
-		if (ec->rx_coalesce_usecs_high != rc->ring->q_vector->intrl &&
+		if (ec->rx_coalesce_usecs_high != rc->rx_ring->q_vector->intrl &&
 		    (ec->use_adaptive_rx_coalesce || ec->use_adaptive_tx_coalesce)) {
 			netdev_info(vsi->netdev, "Invalid value, %s-usecs-high cannot be changed if adaptive-tx or adaptive-rx is enabled\n",
 				    c_type_str);
 			return -EINVAL;
 		}
-		if (ec->rx_coalesce_usecs_high != rc->ring->q_vector->intrl) {
-			rc->ring->q_vector->intrl = ec->rx_coalesce_usecs_high;
-			ice_write_intrl(rc->ring->q_vector,
+		if (ec->rx_coalesce_usecs_high != rc->rx_ring->q_vector->intrl) {
+			rc->rx_ring->q_vector->intrl = ec->rx_coalesce_usecs_high;
+			ice_write_intrl(rc->rx_ring->q_vector,
 					ec->rx_coalesce_usecs_high);
 		}
 
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 12790f07370e..271999e21631 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -379,12 +379,12 @@ static irqreturn_t ice_msix_clean_ctrl_vsi(int __always_unused irq, void *data)
 {
 	struct ice_q_vector *q_vector = (struct ice_q_vector *)data;
 
-	if (!q_vector->tx.ring)
+	if (!q_vector->tx.tx_ring)
 		return IRQ_HANDLED;
 
 #define FDIR_RX_DESC_CLEAN_BUDGET 64
-	ice_clean_rx_irq(q_vector->rx.ring, FDIR_RX_DESC_CLEAN_BUDGET);
-	ice_clean_ctrl_tx_irq(q_vector->tx.ring);
+	ice_clean_rx_irq(q_vector->rx.rx_ring, FDIR_RX_DESC_CLEAN_BUDGET);
+	ice_clean_ctrl_tx_irq(q_vector->tx.tx_ring);
 
 	return IRQ_HANDLED;
 }
@@ -398,7 +398,7 @@ static irqreturn_t ice_msix_clean_rings(int __always_unused irq, void *data)
 {
 	struct ice_q_vector *q_vector = (struct ice_q_vector *)data;
 
-	if (!q_vector->tx.ring && !q_vector->rx.ring)
+	if (!q_vector->tx.tx_ring && !q_vector->rx.rx_ring)
 		return IRQ_HANDLED;
 
 	q_vector->total_events++;
@@ -1249,8 +1249,8 @@ static void ice_vsi_clear_rings(struct ice_vsi *vsi)
 			struct ice_q_vector *q_vector = vsi->q_vectors[i];
 
 			if (q_vector) {
-				q_vector->tx.ring = NULL;
-				q_vector->rx.ring = NULL;
+				q_vector->tx.tx_ring = NULL;
+				q_vector->rx.rx_ring = NULL;
 			}
 		}
 	}
@@ -1286,7 +1286,7 @@ static int ice_vsi_alloc_rings(struct ice_vsi *vsi)
 	dev = ice_pf_to_dev(pf);
 	/* Allocate Tx rings */
 	for (i = 0; i < vsi->alloc_txq; i++) {
-		struct ice_ring *ring;
+		struct ice_tx_ring *ring;
 
 		/* allocate with kzalloc(), free with kfree_rcu() */
 		ring = kzalloc(sizeof(*ring), GFP_KERNEL);
@@ -1305,7 +1305,7 @@ static int ice_vsi_alloc_rings(struct ice_vsi *vsi)
 
 	/* Allocate Rx rings */
 	for (i = 0; i < vsi->alloc_rxq; i++) {
-		struct ice_ring *ring;
+		struct ice_rx_ring *ring;
 
 		/* allocate with kzalloc(), free with kfree_rcu() */
 		ring = kzalloc(sizeof(*ring), GFP_KERNEL);
@@ -1708,7 +1708,7 @@ int ice_vsi_cfg_single_rxq(struct ice_vsi *vsi, u16 q_idx)
 	return ice_vsi_cfg_rxq(vsi->rx_rings[q_idx]);
 }
 
-int ice_vsi_cfg_single_txq(struct ice_vsi *vsi, struct ice_ring **tx_rings, u16 q_idx)
+int ice_vsi_cfg_single_txq(struct ice_vsi *vsi, struct ice_tx_ring **tx_rings, u16 q_idx)
 {
 	struct ice_aqc_add_tx_qgrp *qg_buf;
 	int err;
@@ -1764,7 +1764,7 @@ int ice_vsi_cfg_rxqs(struct ice_vsi *vsi)
  * Configure the Tx VSI for operation.
  */
 static int
-ice_vsi_cfg_txqs(struct ice_vsi *vsi, struct ice_ring **rings, u16 count)
+ice_vsi_cfg_txqs(struct ice_vsi *vsi, struct ice_tx_ring **rings, u16 count)
 {
 	struct ice_aqc_add_tx_qgrp *qg_buf;
 	u16 q_idx = 0;
@@ -1816,7 +1816,7 @@ int ice_vsi_cfg_xdp_txqs(struct ice_vsi *vsi)
 		return ret;
 
 	for (i = 0; i < vsi->num_xdp_txq; i++)
-		vsi->xdp_rings[i]->xsk_pool = ice_xsk_pool(vsi->xdp_rings[i]);
+		vsi->xdp_rings[i]->xsk_pool = ice_tx_xsk_pool(vsi->xdp_rings[i]);
 
 	return ret;
 }
@@ -1851,6 +1851,23 @@ void ice_write_intrl(struct ice_q_vector *q_vector, u8 intrl)
 	     ice_intrl_usec_to_reg(intrl, ICE_INTRL_GRAN_ABOVE_25));
 }
 
+static struct ice_q_vector *ice_pull_qvec_from_rc(struct ice_ring_container *rc)
+{
+	switch (rc->type) {
+	case ICE_RX_CONTAINER:
+		if (rc->rx_ring)
+			return rc->rx_ring->q_vector;
+		break;
+	case ICE_TX_CONTAINER:
+		if (rc->tx_ring)
+			return rc->tx_ring->q_vector;
+	default:
+		break;
+	}
+
+	return NULL;
+}
+
 /**
  * __ice_write_itr - write throttle rate to register
  * @q_vector: pointer to interrupt data structure
@@ -1875,11 +1892,10 @@ void ice_write_itr(struct ice_ring_container *rc, u16 itr)
 {
 	struct ice_q_vector *q_vector;
 
-	if (!rc->ring)
+	q_vector = ice_pull_qvec_from_rc(rc);
+	if (!q_vector)
 		return;
 
-	q_vector = rc->ring->q_vector;
-
 	__ice_write_itr(q_vector, rc, itr);
 }
 
@@ -2055,7 +2071,7 @@ int ice_vsi_stop_all_rx_rings(struct ice_vsi *vsi)
  */
 static int
 ice_vsi_stop_tx_rings(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
-		      u16 rel_vmvf_num, struct ice_ring **rings, u16 count)
+		      u16 rel_vmvf_num, struct ice_tx_ring **rings, u16 count)
 {
 	u16 q_idx;
 
@@ -3355,10 +3371,10 @@ int ice_vsi_cfg_tc(struct ice_vsi *vsi, u8 ena_tc)
  *
  * This function assumes that caller has acquired a u64_stats_sync lock.
  */
-static void ice_update_ring_stats(struct ice_ring *ring, u64 pkts, u64 bytes)
+static void ice_update_ring_stats(struct ice_q_stats *stats, u64 pkts, u64 bytes)
 {
-	ring->stats.bytes += bytes;
-	ring->stats.pkts += pkts;
+	stats->bytes += bytes;
+	stats->pkts += pkts;
 }
 
 /**
@@ -3367,10 +3383,10 @@ static void ice_update_ring_stats(struct ice_ring *ring, u64 pkts, u64 bytes)
  * @pkts: number of processed packets
  * @bytes: number of processed bytes
  */
-void ice_update_tx_ring_stats(struct ice_ring *tx_ring, u64 pkts, u64 bytes)
+void ice_update_tx_ring_stats(struct ice_tx_ring *tx_ring, u64 pkts, u64 bytes)
 {
 	u64_stats_update_begin(&tx_ring->syncp);
-	ice_update_ring_stats(tx_ring, pkts, bytes);
+	ice_update_ring_stats(&tx_ring->stats, pkts, bytes);
 	u64_stats_update_end(&tx_ring->syncp);
 }
 
@@ -3380,10 +3396,10 @@ void ice_update_tx_ring_stats(struct ice_ring *tx_ring, u64 pkts, u64 bytes)
  * @pkts: number of processed packets
  * @bytes: number of processed bytes
  */
-void ice_update_rx_ring_stats(struct ice_ring *rx_ring, u64 pkts, u64 bytes)
+void ice_update_rx_ring_stats(struct ice_rx_ring *rx_ring, u64 pkts, u64 bytes)
 {
 	u64_stats_update_begin(&rx_ring->syncp);
-	ice_update_ring_stats(rx_ring, pkts, bytes);
+	ice_update_ring_stats(&rx_ring->stats, pkts, bytes);
 	u64_stats_update_end(&rx_ring->syncp);
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index d5a28bf0fc2c..ae2b25f8b337 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -14,7 +14,7 @@ void ice_update_eth_stats(struct ice_vsi *vsi);
 
 int ice_vsi_cfg_single_rxq(struct ice_vsi *vsi, u16 q_idx);
 
-int ice_vsi_cfg_single_txq(struct ice_vsi *vsi, struct ice_ring **tx_rings, u16 q_idx);
+int ice_vsi_cfg_single_txq(struct ice_vsi *vsi, struct ice_tx_ring **tx_rings, u16 q_idx);
 
 int ice_vsi_cfg_rxqs(struct ice_vsi *vsi);
 
@@ -93,9 +93,9 @@ void ice_vsi_free_tx_rings(struct ice_vsi *vsi);
 
 void ice_vsi_manage_rss_lut(struct ice_vsi *vsi, bool ena);
 
-void ice_update_tx_ring_stats(struct ice_ring *ring, u64 pkts, u64 bytes);
+void ice_update_tx_ring_stats(struct ice_tx_ring *ring, u64 pkts, u64 bytes);
 
-void ice_update_rx_ring_stats(struct ice_ring *ring, u64 pkts, u64 bytes);
+void ice_update_rx_ring_stats(struct ice_rx_ring *ring, u64 pkts, u64 bytes);
 
 void ice_vsi_cfg_frame_size(struct ice_vsi *vsi);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index b8364710f8fb..30df25862ea7 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -61,7 +61,7 @@ bool netif_is_ice(struct net_device *dev)
  * ice_get_tx_pending - returns number of Tx descriptors not processed
  * @ring: the ring of descriptors
  */
-static u16 ice_get_tx_pending(struct ice_ring *ring)
+static u16 ice_get_tx_pending(struct ice_tx_ring *ring)
 {
 	u16 head, tail;
 
@@ -101,7 +101,7 @@ static void ice_check_for_hang_subtask(struct ice_pf *pf)
 	hw = &vsi->back->hw;
 
 	for (i = 0; i < vsi->num_txq; i++) {
-		struct ice_ring *tx_ring = vsi->tx_rings[i];
+		struct ice_tx_ring *tx_ring = vsi->tx_rings[i];
 
 		if (tx_ring && tx_ring->desc) {
 			/* If packet counter has not changed the queue is
@@ -2302,14 +2302,14 @@ static int ice_vsi_req_irq_msix(struct ice_vsi *vsi, char *basename)
 
 		irq_num = pf->msix_entries[base + vector].vector;
 
-		if (q_vector->tx.ring && q_vector->rx.ring) {
+		if (q_vector->tx.tx_ring && q_vector->rx.rx_ring) {
 			snprintf(q_vector->name, sizeof(q_vector->name) - 1,
 				 "%s-%s-%d", basename, "TxRx", rx_int_idx++);
 			tx_int_idx++;
-		} else if (q_vector->rx.ring) {
+		} else if (q_vector->rx.rx_ring) {
 			snprintf(q_vector->name, sizeof(q_vector->name) - 1,
 				 "%s-%s-%d", basename, "rx", rx_int_idx++);
-		} else if (q_vector->tx.ring) {
+		} else if (q_vector->tx.tx_ring) {
 			snprintf(q_vector->name, sizeof(q_vector->name) - 1,
 				 "%s-%s-%d", basename, "tx", tx_int_idx++);
 		} else {
@@ -2371,7 +2371,7 @@ static int ice_xdp_alloc_setup_rings(struct ice_vsi *vsi)
 
 	for (i = 0; i < vsi->num_xdp_txq; i++) {
 		u16 xdp_q_idx = vsi->alloc_txq + i;
-		struct ice_ring *xdp_ring;
+		struct ice_tx_ring *xdp_ring;
 
 		xdp_ring = kzalloc(sizeof(*xdp_ring), GFP_KERNEL);
 
@@ -2388,7 +2388,7 @@ static int ice_xdp_alloc_setup_rings(struct ice_vsi *vsi)
 		if (ice_setup_tx_ring(xdp_ring))
 			goto free_xdp_rings;
 		ice_set_ring_xdp(xdp_ring);
-		xdp_ring->xsk_pool = ice_xsk_pool(xdp_ring);
+		xdp_ring->xsk_pool = ice_tx_xsk_pool(xdp_ring);
 	}
 
 	return 0;
@@ -2467,11 +2467,11 @@ int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog)
 		q_base = vsi->num_xdp_txq - xdp_rings_rem;
 
 		for (q_id = q_base; q_id < (q_base + xdp_rings_per_v); q_id++) {
-			struct ice_ring *xdp_ring = vsi->xdp_rings[q_id];
+			struct ice_tx_ring *xdp_ring = vsi->xdp_rings[q_id];
 
 			xdp_ring->q_vector = q_vector;
-			xdp_ring->next = q_vector->tx.ring;
-			q_vector->tx.ring = xdp_ring;
+			xdp_ring->next = q_vector->tx.tx_ring;
+			q_vector->tx.tx_ring = xdp_ring;
 		}
 		xdp_rings_rem -= xdp_rings_per_v;
 	}
@@ -2541,14 +2541,14 @@ int ice_destroy_xdp_rings(struct ice_vsi *vsi)
 
 	ice_for_each_q_vector(vsi, v_idx) {
 		struct ice_q_vector *q_vector = vsi->q_vectors[v_idx];
-		struct ice_ring *ring;
+		struct ice_tx_ring *ring;
 
-		ice_for_each_ring(ring, q_vector->tx)
+		ice_for_each_tx_ring(ring, q_vector->tx)
 			if (!ring->tx_buf || !ice_ring_is_xdp(ring))
 				break;
 
 		/* restore the value of last node prior to XDP setup */
-		q_vector->tx.ring = ring;
+		q_vector->tx.tx_ring = ring;
 	}
 
 free_qmap:
@@ -2597,7 +2597,7 @@ static void ice_vsi_rx_napi_schedule(struct ice_vsi *vsi)
 	int i;
 
 	ice_for_each_rxq(vsi, i) {
-		struct ice_ring *rx_ring = vsi->rx_rings[i];
+		struct ice_rx_ring *rx_ring = vsi->rx_rings[i];
 
 		if (rx_ring->xsk_pool)
 			napi_schedule(&rx_ring->q_vector->napi);
@@ -5558,7 +5558,7 @@ static void ice_napi_enable_all(struct ice_vsi *vsi)
 		INIT_WORK(&q_vector->rx.dim.work, ice_rx_dim_work);
 		q_vector->rx.dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
 
-		if (q_vector->rx.ring || q_vector->tx.ring)
+		if (q_vector->rx.rx_ring || q_vector->tx.tx_ring)
 			napi_enable(&q_vector->napi);
 	}
 }
@@ -5626,19 +5626,16 @@ int ice_up(struct ice_vsi *vsi)
  * that needs to be performed to read u64 values in 32 bit machine.
  */
 static void
-ice_fetch_u64_stats_per_ring(struct ice_ring *ring, u64 *pkts, u64 *bytes)
+ice_fetch_u64_stats_per_ring(struct u64_stats_sync *syncp, struct ice_q_stats stats,
+			     u64 *pkts, u64 *bytes)
 {
 	unsigned int start;
-	*pkts = 0;
-	*bytes = 0;
 
-	if (!ring)
-		return;
 	do {
-		start = u64_stats_fetch_begin_irq(&ring->syncp);
-		*pkts = ring->stats.pkts;
-		*bytes = ring->stats.bytes;
-	} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+		start = u64_stats_fetch_begin_irq(syncp);
+		*pkts = stats.pkts;
+		*bytes = stats.bytes;
+	} while (u64_stats_fetch_retry_irq(syncp, start));
 }
 
 /**
@@ -5648,18 +5645,19 @@ ice_fetch_u64_stats_per_ring(struct ice_ring *ring, u64 *pkts, u64 *bytes)
  * @count: number of rings
  */
 static void
-ice_update_vsi_tx_ring_stats(struct ice_vsi *vsi, struct ice_ring **rings,
+ice_update_vsi_tx_ring_stats(struct ice_vsi *vsi, struct ice_tx_ring **rings,
 			     u16 count)
 {
 	struct rtnl_link_stats64 *vsi_stats = &vsi->net_stats;
 	u16 i;
 
 	for (i = 0; i < count; i++) {
-		struct ice_ring *ring;
-		u64 pkts, bytes;
+		struct ice_tx_ring *ring;
+		u64 pkts = 0, bytes = 0;
 
 		ring = READ_ONCE(rings[i]);
-		ice_fetch_u64_stats_per_ring(ring, &pkts, &bytes);
+		if (ring)
+			ice_fetch_u64_stats_per_ring(&ring->syncp, ring->stats, &pkts, &bytes);
 		vsi_stats->tx_packets += pkts;
 		vsi_stats->tx_bytes += bytes;
 		vsi->tx_restart += ring->tx_stats.restart_q;
@@ -5698,9 +5696,9 @@ static void ice_update_vsi_ring_stats(struct ice_vsi *vsi)
 
 	/* update Rx rings counters */
 	ice_for_each_rxq(vsi, i) {
-		struct ice_ring *ring = READ_ONCE(vsi->rx_rings[i]);
+		struct ice_rx_ring *ring = READ_ONCE(vsi->rx_rings[i]);
 
-		ice_fetch_u64_stats_per_ring(ring, &pkts, &bytes);
+		ice_fetch_u64_stats_per_ring(&ring->syncp, ring->stats, &pkts, &bytes);
 		vsi_stats->rx_packets += pkts;
 		vsi_stats->rx_bytes += bytes;
 		vsi->rx_buf_failed += ring->rx_stats.alloc_buf_failed;
@@ -5964,7 +5962,7 @@ static void ice_napi_disable_all(struct ice_vsi *vsi)
 	ice_for_each_q_vector(vsi, q_idx) {
 		struct ice_q_vector *q_vector = vsi->q_vectors[q_idx];
 
-		if (q_vector->rx.ring || q_vector->tx.ring)
+		if (q_vector->rx.rx_ring || q_vector->tx.tx_ring)
 			napi_disable(&q_vector->napi);
 
 		cancel_work_sync(&q_vector->tx.dim.work);
@@ -6047,7 +6045,7 @@ int ice_vsi_setup_tx_rings(struct ice_vsi *vsi)
 	}
 
 	ice_for_each_txq(vsi, i) {
-		struct ice_ring *ring = vsi->tx_rings[i];
+		struct ice_tx_ring *ring = vsi->tx_rings[i];
 
 		if (!ring)
 			return -EINVAL;
@@ -6078,7 +6076,7 @@ int ice_vsi_setup_rx_rings(struct ice_vsi *vsi)
 	}
 
 	ice_for_each_rxq(vsi, i) {
-		struct ice_ring *ring = vsi->rx_rings[i];
+		struct ice_rx_ring *ring = vsi->rx_rings[i];
 
 		if (!ring)
 			return -EINVAL;
@@ -6973,7 +6971,7 @@ ice_bridge_setlink(struct net_device *dev, struct nlmsghdr *nlh,
 static void ice_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
-	struct ice_ring *tx_ring = NULL;
+	struct ice_tx_ring *tx_ring = NULL;
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
 	u32 i;
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 5d5207b56ca9..11794986bb02 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -966,7 +966,7 @@ int ice_ptp_set_ts_config(struct ice_pf *pf, struct ifreq *ifr)
  * The timestamp is in ns, so we must convert the result first.
  */
 void
-ice_ptp_rx_hwtstamp(struct ice_ring *rx_ring,
+ice_ptp_rx_hwtstamp(struct ice_rx_ring *rx_ring,
 		    union ice_32b_rx_flex_desc *rx_desc, struct sk_buff *skb)
 {
 	u32 ts_high;
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index e1c787bd5b96..ace7cde31d3e 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -168,7 +168,7 @@ s8 ice_ptp_request_ts(struct ice_ptp_tx *tx, struct sk_buff *skb);
 void ice_ptp_process_ts(struct ice_pf *pf);
 
 void
-ice_ptp_rx_hwtstamp(struct ice_ring *rx_ring,
+ice_ptp_rx_hwtstamp(struct ice_rx_ring *rx_ring,
 		    union ice_32b_rx_flex_desc *rx_desc, struct sk_buff *skb);
 void ice_ptp_init(struct ice_pf *pf);
 void ice_ptp_release(struct ice_pf *pf);
@@ -196,7 +196,7 @@ ice_ptp_request_ts(struct ice_ptp_tx *tx, struct sk_buff *skb)
 
 static inline void ice_ptp_process_ts(struct ice_pf *pf) { }
 static inline void
-ice_ptp_rx_hwtstamp(struct ice_ring *rx_ring,
+ice_ptp_rx_hwtstamp(struct ice_rx_ring *rx_ring,
 		    union ice_32b_rx_flex_desc *rx_desc, struct sk_buff *skb) { }
 static inline void ice_ptp_init(struct ice_pf *pf) { }
 static inline void ice_ptp_release(struct ice_pf *pf) { }
diff --git a/drivers/net/ethernet/intel/ice/ice_trace.h b/drivers/net/ethernet/intel/ice/ice_trace.h
index 9bc0b8fdfc77..cf685247c07a 100644
--- a/drivers/net/ethernet/intel/ice/ice_trace.h
+++ b/drivers/net/ethernet/intel/ice/ice_trace.h
@@ -64,15 +64,15 @@ DECLARE_EVENT_CLASS(ice_rx_dim_template,
 		    TP_ARGS(q_vector, dim),
 		    TP_STRUCT__entry(__field(struct ice_q_vector *, q_vector)
 				     __field(struct dim *, dim)
-				     __string(devname, q_vector->rx.ring->netdev->name)),
+				     __string(devname, q_vector->rx.rx_ring->netdev->name)),
 
 		    TP_fast_assign(__entry->q_vector = q_vector;
 				   __entry->dim = dim;
-				   __assign_str(devname, q_vector->rx.ring->netdev->name);),
+				   __assign_str(devname, q_vector->rx.rx_ring->netdev->name);),
 
 		    TP_printk("netdev: %s Rx-Q: %d dim-state: %d dim-profile: %d dim-tune: %d dim-st-right: %d dim-st-left: %d dim-tired: %d",
 			      __get_str(devname),
-			      __entry->q_vector->rx.ring->q_index,
+			      __entry->q_vector->rx.rx_ring->q_index,
 			      __entry->dim->state,
 			      __entry->dim->profile_ix,
 			      __entry->dim->tune_state,
@@ -91,15 +91,15 @@ DECLARE_EVENT_CLASS(ice_tx_dim_template,
 		    TP_ARGS(q_vector, dim),
 		    TP_STRUCT__entry(__field(struct ice_q_vector *, q_vector)
 				     __field(struct dim *, dim)
-				     __string(devname, q_vector->tx.ring->netdev->name)),
+				     __string(devname, q_vector->tx.tx_ring->netdev->name)),
 
 		    TP_fast_assign(__entry->q_vector = q_vector;
 				   __entry->dim = dim;
-				   __assign_str(devname, q_vector->tx.ring->netdev->name);),
+				   __assign_str(devname, q_vector->tx.tx_ring->netdev->name);),
 
 		    TP_printk("netdev: %s Tx-Q: %d dim-state: %d dim-profile: %d dim-tune: %d dim-st-right: %d dim-st-left: %d dim-tired: %d",
 			      __get_str(devname),
-			      __entry->q_vector->tx.ring->q_index,
+			      __entry->q_vector->tx.tx_ring->q_index,
 			      __entry->dim->state,
 			      __entry->dim->profile_ix,
 			      __entry->dim->tune_state,
@@ -115,7 +115,7 @@ DEFINE_EVENT(ice_tx_dim_template, ice_tx_dim_work,
 
 /* Events related to a vsi & ring */
 DECLARE_EVENT_CLASS(ice_tx_template,
-		    TP_PROTO(struct ice_ring *ring, struct ice_tx_desc *desc,
+		    TP_PROTO(struct ice_tx_ring *ring, struct ice_tx_desc *desc,
 			     struct ice_tx_buf *buf),
 
 		    TP_ARGS(ring, desc, buf),
@@ -135,7 +135,7 @@ DECLARE_EVENT_CLASS(ice_tx_template,
 
 #define DEFINE_TX_TEMPLATE_OP_EVENT(name) \
 DEFINE_EVENT(ice_tx_template, name, \
-	     TP_PROTO(struct ice_ring *ring, \
+	     TP_PROTO(struct ice_tx_ring *ring, \
 		      struct ice_tx_desc *desc, \
 		      struct ice_tx_buf *buf), \
 	     TP_ARGS(ring, desc, buf))
@@ -145,7 +145,7 @@ DEFINE_TX_TEMPLATE_OP_EVENT(ice_clean_tx_irq_unmap);
 DEFINE_TX_TEMPLATE_OP_EVENT(ice_clean_tx_irq_unmap_eop);
 
 DECLARE_EVENT_CLASS(ice_rx_template,
-		    TP_PROTO(struct ice_ring *ring, union ice_32b_rx_flex_desc *desc),
+		    TP_PROTO(struct ice_rx_ring *ring, union ice_32b_rx_flex_desc *desc),
 
 		    TP_ARGS(ring, desc),
 
@@ -161,12 +161,12 @@ DECLARE_EVENT_CLASS(ice_rx_template,
 			      __entry->ring, __entry->desc)
 );
 DEFINE_EVENT(ice_rx_template, ice_clean_rx_irq,
-	     TP_PROTO(struct ice_ring *ring, union ice_32b_rx_flex_desc *desc),
+	     TP_PROTO(struct ice_rx_ring *ring, union ice_32b_rx_flex_desc *desc),
 	     TP_ARGS(ring, desc)
 );
 
 DECLARE_EVENT_CLASS(ice_rx_indicate_template,
-		    TP_PROTO(struct ice_ring *ring, union ice_32b_rx_flex_desc *desc,
+		    TP_PROTO(struct ice_rx_ring *ring, union ice_32b_rx_flex_desc *desc,
 			     struct sk_buff *skb),
 
 		    TP_ARGS(ring, desc, skb),
@@ -186,13 +186,13 @@ DECLARE_EVENT_CLASS(ice_rx_indicate_template,
 );
 
 DEFINE_EVENT(ice_rx_indicate_template, ice_clean_rx_irq_indicate,
-	     TP_PROTO(struct ice_ring *ring, union ice_32b_rx_flex_desc *desc,
+	     TP_PROTO(struct ice_rx_ring *ring, union ice_32b_rx_flex_desc *desc,
 		      struct sk_buff *skb),
 	     TP_ARGS(ring, desc, skb)
 );
 
 DECLARE_EVENT_CLASS(ice_xmit_template,
-		    TP_PROTO(struct ice_ring *ring, struct sk_buff *skb),
+		    TP_PROTO(struct ice_tx_ring *ring, struct sk_buff *skb),
 
 		    TP_ARGS(ring, skb),
 
@@ -210,7 +210,7 @@ DECLARE_EVENT_CLASS(ice_xmit_template,
 
 #define DEFINE_XMIT_TEMPLATE_OP_EVENT(name) \
 DEFINE_EVENT(ice_xmit_template, name, \
-	     TP_PROTO(struct ice_ring *ring, struct sk_buff *skb), \
+	     TP_PROTO(struct ice_tx_ring *ring, struct sk_buff *skb), \
 	     TP_ARGS(ring, skb))
 
 DEFINE_XMIT_TEMPLATE_OP_EVENT(ice_xmit_frame_ring);
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 6ee8e0032d52..851a6e68aedf 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -32,7 +32,7 @@ ice_prgm_fdir_fltr(struct ice_vsi *vsi, struct ice_fltr_desc *fdir_desc,
 	struct ice_tx_buf *tx_buf, *first;
 	struct ice_fltr_desc *f_desc;
 	struct ice_tx_desc *tx_desc;
-	struct ice_ring *tx_ring;
+	struct ice_tx_ring *tx_ring;
 	struct device *dev;
 	dma_addr_t dma;
 	u32 td_cmd;
@@ -106,7 +106,7 @@ ice_prgm_fdir_fltr(struct ice_vsi *vsi, struct ice_fltr_desc *fdir_desc,
  * @tx_buf: the buffer to free
  */
 static void
-ice_unmap_and_free_tx_buf(struct ice_ring *ring, struct ice_tx_buf *tx_buf)
+ice_unmap_and_free_tx_buf(struct ice_tx_ring *ring, struct ice_tx_buf *tx_buf)
 {
 	if (tx_buf->skb) {
 		if (tx_buf->tx_flags & ICE_TX_FLAGS_DUMMY_PKT)
@@ -133,7 +133,7 @@ ice_unmap_and_free_tx_buf(struct ice_ring *ring, struct ice_tx_buf *tx_buf)
 	/* tx_buf must be completely set up in the transmit path */
 }
 
-static struct netdev_queue *txring_txq(const struct ice_ring *ring)
+static struct netdev_queue *txring_txq(const struct ice_tx_ring *ring)
 {
 	return netdev_get_tx_queue(ring->netdev, ring->q_index);
 }
@@ -142,8 +142,9 @@ static struct netdev_queue *txring_txq(const struct ice_ring *ring)
  * ice_clean_tx_ring - Free any empty Tx buffers
  * @tx_ring: ring to be cleaned
  */
-void ice_clean_tx_ring(struct ice_ring *tx_ring)
+void ice_clean_tx_ring(struct ice_tx_ring *tx_ring)
 {
+	u32 size;
 	u16 i;
 
 	if (ice_ring_is_xdp(tx_ring) && tx_ring->xsk_pool) {
@@ -162,8 +163,10 @@ void ice_clean_tx_ring(struct ice_ring *tx_ring)
 tx_skip_free:
 	memset(tx_ring->tx_buf, 0, sizeof(*tx_ring->tx_buf) * tx_ring->count);
 
+	size = ALIGN(tx_ring->count * sizeof(struct ice_tx_desc),
+		     PAGE_SIZE);
 	/* Zero out the descriptor ring */
-	memset(tx_ring->desc, 0, tx_ring->size);
+	memset(tx_ring->desc, 0, size);
 
 	tx_ring->next_to_use = 0;
 	tx_ring->next_to_clean = 0;
@@ -181,14 +184,18 @@ void ice_clean_tx_ring(struct ice_ring *tx_ring)
  *
  * Free all transmit software resources
  */
-void ice_free_tx_ring(struct ice_ring *tx_ring)
+void ice_free_tx_ring(struct ice_tx_ring *tx_ring)
 {
+	u32 size;
+
 	ice_clean_tx_ring(tx_ring);
 	devm_kfree(tx_ring->dev, tx_ring->tx_buf);
 	tx_ring->tx_buf = NULL;
 
 	if (tx_ring->desc) {
-		dmam_free_coherent(tx_ring->dev, tx_ring->size,
+		size = ALIGN(tx_ring->count * sizeof(struct ice_tx_desc),
+			     PAGE_SIZE);
+		dmam_free_coherent(tx_ring->dev, size,
 				   tx_ring->desc, tx_ring->dma);
 		tx_ring->desc = NULL;
 	}
@@ -201,7 +208,7 @@ void ice_free_tx_ring(struct ice_ring *tx_ring)
  *
  * Returns true if there's any budget left (e.g. the clean is finished)
  */
-static bool ice_clean_tx_irq(struct ice_ring *tx_ring, int napi_budget)
+static bool ice_clean_tx_irq(struct ice_tx_ring *tx_ring, int napi_budget)
 {
 	unsigned int total_bytes = 0, total_pkts = 0;
 	unsigned int budget = ICE_DFLT_IRQ_WORK;
@@ -329,9 +336,10 @@ static bool ice_clean_tx_irq(struct ice_ring *tx_ring, int napi_budget)
  *
  * Return 0 on success, negative on error
  */
-int ice_setup_tx_ring(struct ice_ring *tx_ring)
+int ice_setup_tx_ring(struct ice_tx_ring *tx_ring)
 {
 	struct device *dev = tx_ring->dev;
+	u32 size;
 
 	if (!dev)
 		return -ENOMEM;
@@ -345,13 +353,13 @@ int ice_setup_tx_ring(struct ice_ring *tx_ring)
 		return -ENOMEM;
 
 	/* round up to nearest page */
-	tx_ring->size = ALIGN(tx_ring->count * sizeof(struct ice_tx_desc),
-			      PAGE_SIZE);
-	tx_ring->desc = dmam_alloc_coherent(dev, tx_ring->size, &tx_ring->dma,
+	size = ALIGN(tx_ring->count * sizeof(struct ice_tx_desc),
+		     PAGE_SIZE);
+	tx_ring->desc = dmam_alloc_coherent(dev, size, &tx_ring->dma,
 					    GFP_KERNEL);
 	if (!tx_ring->desc) {
 		dev_err(dev, "Unable to allocate memory for the Tx descriptor ring, size=%d\n",
-			tx_ring->size);
+			size);
 		goto err;
 	}
 
@@ -370,9 +378,10 @@ int ice_setup_tx_ring(struct ice_ring *tx_ring)
  * ice_clean_rx_ring - Free Rx buffers
  * @rx_ring: ring to be cleaned
  */
-void ice_clean_rx_ring(struct ice_ring *rx_ring)
+void ice_clean_rx_ring(struct ice_rx_ring *rx_ring)
 {
 	struct device *dev = rx_ring->dev;
+	u32 size;
 	u16 i;
 
 	/* ring already cleared, nothing to do */
@@ -417,7 +426,9 @@ void ice_clean_rx_ring(struct ice_ring *rx_ring)
 	memset(rx_ring->rx_buf, 0, sizeof(*rx_ring->rx_buf) * rx_ring->count);
 
 	/* Zero out the descriptor ring */
-	memset(rx_ring->desc, 0, rx_ring->size);
+	size = ALIGN(rx_ring->count * sizeof(union ice_32byte_rx_desc),
+		     PAGE_SIZE);
+	memset(rx_ring->desc, 0, size);
 
 	rx_ring->next_to_alloc = 0;
 	rx_ring->next_to_clean = 0;
@@ -430,8 +441,10 @@ void ice_clean_rx_ring(struct ice_ring *rx_ring)
  *
  * Free all receive software resources
  */
-void ice_free_rx_ring(struct ice_ring *rx_ring)
+void ice_free_rx_ring(struct ice_rx_ring *rx_ring)
 {
+	u32 size;
+
 	ice_clean_rx_ring(rx_ring);
 	if (rx_ring->vsi->type == ICE_VSI_PF)
 		if (xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
@@ -441,7 +454,9 @@ void ice_free_rx_ring(struct ice_ring *rx_ring)
 	rx_ring->rx_buf = NULL;
 
 	if (rx_ring->desc) {
-		dmam_free_coherent(rx_ring->dev, rx_ring->size,
+		size = ALIGN(rx_ring->count * sizeof(union ice_32byte_rx_desc),
+			     PAGE_SIZE);
+		dmam_free_coherent(rx_ring->dev, size,
 				   rx_ring->desc, rx_ring->dma);
 		rx_ring->desc = NULL;
 	}
@@ -453,9 +468,10 @@ void ice_free_rx_ring(struct ice_ring *rx_ring)
  *
  * Return 0 on success, negative on error
  */
-int ice_setup_rx_ring(struct ice_ring *rx_ring)
+int ice_setup_rx_ring(struct ice_rx_ring *rx_ring)
 {
 	struct device *dev = rx_ring->dev;
+	u32 size;
 
 	if (!dev)
 		return -ENOMEM;
@@ -469,13 +485,13 @@ int ice_setup_rx_ring(struct ice_ring *rx_ring)
 		return -ENOMEM;
 
 	/* round up to nearest page */
-	rx_ring->size = ALIGN(rx_ring->count * sizeof(union ice_32byte_rx_desc),
-			      PAGE_SIZE);
-	rx_ring->desc = dmam_alloc_coherent(dev, rx_ring->size, &rx_ring->dma,
+	size = ALIGN(rx_ring->count * sizeof(union ice_32byte_rx_desc),
+		     PAGE_SIZE);
+	rx_ring->desc = dmam_alloc_coherent(dev, size, &rx_ring->dma,
 					    GFP_KERNEL);
 	if (!rx_ring->desc) {
 		dev_err(dev, "Unable to allocate memory for the Rx descriptor ring, size=%d\n",
-			rx_ring->size);
+			size);
 		goto err;
 	}
 
@@ -499,7 +515,7 @@ int ice_setup_rx_ring(struct ice_ring *rx_ring)
 }
 
 static unsigned int
-ice_rx_frame_truesize(struct ice_ring *rx_ring, unsigned int __maybe_unused size)
+ice_rx_frame_truesize(struct ice_rx_ring *rx_ring, unsigned int __maybe_unused size)
 {
 	unsigned int truesize;
 
@@ -523,10 +539,10 @@ ice_rx_frame_truesize(struct ice_ring *rx_ring, unsigned int __maybe_unused size
  * Returns any of ICE_XDP_{PASS, CONSUMED, TX, REDIR}
  */
 static int
-ice_run_xdp(struct ice_ring *rx_ring, struct xdp_buff *xdp,
+ice_run_xdp(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
 	    struct bpf_prog *xdp_prog)
 {
-	struct ice_ring *xdp_ring;
+	struct ice_tx_ring *xdp_ring;
 	int err, result;
 	u32 act;
 
@@ -576,7 +592,7 @@ ice_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 	struct ice_netdev_priv *np = netdev_priv(dev);
 	unsigned int queue_index = smp_processor_id();
 	struct ice_vsi *vsi = np->vsi;
-	struct ice_ring *xdp_ring;
+	struct ice_tx_ring *xdp_ring;
 	int nxmit = 0, i;
 
 	if (test_bit(ICE_VSI_DOWN, vsi->state))
@@ -614,7 +630,7 @@ ice_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
  * reused.
  */
 static bool
-ice_alloc_mapped_page(struct ice_ring *rx_ring, struct ice_rx_buf *bi)
+ice_alloc_mapped_page(struct ice_rx_ring *rx_ring, struct ice_rx_buf *bi)
 {
 	struct page *page = bi->page;
 	dma_addr_t dma;
@@ -665,7 +681,7 @@ ice_alloc_mapped_page(struct ice_ring *rx_ring, struct ice_rx_buf *bi)
  * buffers. Then bump tail at most one time. Grouping like this lets us avoid
  * multiple tail writes per call.
  */
-bool ice_alloc_rx_bufs(struct ice_ring *rx_ring, u16 cleaned_count)
+bool ice_alloc_rx_bufs(struct ice_rx_ring *rx_ring, u16 cleaned_count)
 {
 	union ice_32b_rx_flex_desc *rx_desc;
 	u16 ntu = rx_ring->next_to_use;
@@ -794,7 +810,7 @@ ice_can_reuse_rx_page(struct ice_rx_buf *rx_buf, int rx_buf_pgcnt)
  * The function will then update the page offset.
  */
 static void
-ice_add_rx_frag(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
+ice_add_rx_frag(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
 		struct sk_buff *skb, unsigned int size)
 {
 #if (PAGE_SIZE >= 8192)
@@ -820,7 +836,7 @@ ice_add_rx_frag(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
  * Synchronizes page for reuse by the adapter
  */
 static void
-ice_reuse_rx_page(struct ice_ring *rx_ring, struct ice_rx_buf *old_buf)
+ice_reuse_rx_page(struct ice_rx_ring *rx_ring, struct ice_rx_buf *old_buf)
 {
 	u16 nta = rx_ring->next_to_alloc;
 	struct ice_rx_buf *new_buf;
@@ -851,7 +867,7 @@ ice_reuse_rx_page(struct ice_ring *rx_ring, struct ice_rx_buf *old_buf)
  * for use by the CPU.
  */
 static struct ice_rx_buf *
-ice_get_rx_buf(struct ice_ring *rx_ring, const unsigned int size,
+ice_get_rx_buf(struct ice_rx_ring *rx_ring, const unsigned int size,
 	       int *rx_buf_pgcnt)
 {
 	struct ice_rx_buf *rx_buf;
@@ -888,7 +904,7 @@ ice_get_rx_buf(struct ice_ring *rx_ring, const unsigned int size,
  * to set up the skb correctly and avoid any memcpy overhead.
  */
 static struct sk_buff *
-ice_build_skb(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
+ice_build_skb(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
 	      struct xdp_buff *xdp)
 {
 	u8 metasize = xdp->data - xdp->data_meta;
@@ -940,7 +956,7 @@ ice_build_skb(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
  * skb correctly.
  */
 static struct sk_buff *
-ice_construct_skb(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
+ice_construct_skb(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
 		  struct xdp_buff *xdp)
 {
 	unsigned int size = xdp->data_end - xdp->data;
@@ -1000,7 +1016,7 @@ ice_construct_skb(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
  * the associated resources.
  */
 static void
-ice_put_rx_buf(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
+ice_put_rx_buf(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
 	       int rx_buf_pgcnt)
 {
 	u16 ntc = rx_ring->next_to_clean + 1;
@@ -1036,7 +1052,7 @@ ice_put_rx_buf(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
  * otherwise return true indicating that this is in fact a non-EOP buffer.
  */
 static bool
-ice_is_non_eop(struct ice_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc)
+ice_is_non_eop(struct ice_rx_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc)
 {
 	/* if we are the last buffer then there is nothing else to do */
 #define ICE_RXD_EOF BIT(ICE_RX_FLEX_DESC_STATUS0_EOF_S)
@@ -1060,7 +1076,7 @@ ice_is_non_eop(struct ice_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc)
  *
  * Returns amount of work completed
  */
-int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
+int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 {
 	unsigned int total_rx_bytes = 0, total_rx_pkts = 0, frame_sz = 0;
 	u16 cleaned_count = ICE_DESC_UNUSED(rx_ring);
@@ -1247,9 +1263,9 @@ static void ice_net_dim(struct ice_q_vector *q_vector)
 	if (ITR_IS_DYNAMIC(tx)) {
 		struct dim_sample dim_sample = {};
 		u64 packets = 0, bytes = 0;
-		struct ice_ring *ring;
+		struct ice_tx_ring *ring;
 
-		ice_for_each_ring(ring, q_vector->tx) {
+		ice_for_each_tx_ring(ring, q_vector->tx) {
 			packets += ring->stats.pkts;
 			bytes += ring->stats.bytes;
 		}
@@ -1263,9 +1279,9 @@ static void ice_net_dim(struct ice_q_vector *q_vector)
 	if (ITR_IS_DYNAMIC(rx)) {
 		struct dim_sample dim_sample = {};
 		u64 packets = 0, bytes = 0;
-		struct ice_ring *ring;
+		struct ice_rx_ring *ring;
 
-		ice_for_each_ring(ring, q_vector->rx) {
+		ice_for_each_rx_ring(ring, q_vector->rx) {
 			packets += ring->stats.pkts;
 			bytes += ring->stats.bytes;
 		}
@@ -1387,18 +1403,19 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
 {
 	struct ice_q_vector *q_vector =
 				container_of(napi, struct ice_q_vector, napi);
+	struct ice_tx_ring *tx_ring;
+	struct ice_rx_ring *rx_ring;
 	bool clean_complete = true;
-	struct ice_ring *ring;
 	int budget_per_ring;
 	int work_done = 0;
 
 	/* Since the actual Tx work is minimal, we can give the Tx a larger
 	 * budget and be more aggressive about cleaning up the Tx descriptors.
 	 */
-	ice_for_each_ring(ring, q_vector->tx) {
-		bool wd = ring->xsk_pool ?
-			  ice_clean_tx_irq_zc(ring, budget) :
-			  ice_clean_tx_irq(ring, budget);
+	ice_for_each_tx_ring(tx_ring, q_vector->tx) {
+		bool wd = tx_ring->xsk_pool ?
+			  ice_clean_tx_irq_zc(tx_ring, budget) :
+			  ice_clean_tx_irq(tx_ring, budget);
 
 		if (!wd)
 			clean_complete = false;
@@ -1419,16 +1436,16 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
 		/* Max of 1 Rx ring in this q_vector so give it the budget */
 		budget_per_ring = budget;
 
-	ice_for_each_ring(ring, q_vector->rx) {
+	ice_for_each_rx_ring(rx_ring, q_vector->rx) {
 		int cleaned;
 
 		/* A dedicated path for zero-copy allows making a single
 		 * comparison in the irq context instead of many inside the
 		 * ice_clean_rx_irq function and makes the codebase cleaner.
 		 */
-		cleaned = ring->xsk_pool ?
-			  ice_clean_rx_irq_zc(ring, budget_per_ring) :
-			  ice_clean_rx_irq(ring, budget_per_ring);
+		cleaned = rx_ring->xsk_pool ?
+			  ice_clean_rx_irq_zc(rx_ring, budget_per_ring) :
+			  ice_clean_rx_irq(rx_ring, budget_per_ring);
 		work_done += cleaned;
 		/* if we clean as many as budgeted, we must not be done */
 		if (cleaned >= budget_per_ring)
@@ -1462,7 +1479,7 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
  *
  * Returns -EBUSY if a stop is needed, else 0
  */
-static int __ice_maybe_stop_tx(struct ice_ring *tx_ring, unsigned int size)
+static int __ice_maybe_stop_tx(struct ice_tx_ring *tx_ring, unsigned int size)
 {
 	netif_stop_subqueue(tx_ring->netdev, tx_ring->q_index);
 	/* Memory barrier before checking head and tail */
@@ -1485,7 +1502,7 @@ static int __ice_maybe_stop_tx(struct ice_ring *tx_ring, unsigned int size)
  *
  * Returns 0 if stop is not needed
  */
-static int ice_maybe_stop_tx(struct ice_ring *tx_ring, unsigned int size)
+static int ice_maybe_stop_tx(struct ice_tx_ring *tx_ring, unsigned int size)
 {
 	if (likely(ICE_DESC_UNUSED(tx_ring) >= size))
 		return 0;
@@ -1504,7 +1521,7 @@ static int ice_maybe_stop_tx(struct ice_ring *tx_ring, unsigned int size)
  * it and the length into the transmit descriptor.
  */
 static void
-ice_tx_map(struct ice_ring *tx_ring, struct ice_tx_buf *first,
+ice_tx_map(struct ice_tx_ring *tx_ring, struct ice_tx_buf *first,
 	   struct ice_tx_offload_params *off)
 {
 	u64 td_offset, td_tag, td_cmd;
@@ -1840,7 +1857,7 @@ int ice_tx_csum(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
  * related to VLAN tagging for the HW, such as VLAN, DCB, etc.
  */
 static void
-ice_tx_prepare_vlan_flags(struct ice_ring *tx_ring, struct ice_tx_buf *first)
+ice_tx_prepare_vlan_flags(struct ice_tx_ring *tx_ring, struct ice_tx_buf *first)
 {
 	struct sk_buff *skb = first->skb;
 
@@ -2146,7 +2163,7 @@ static bool ice_chk_linearize(struct sk_buff *skb, unsigned int count)
  * @off: Tx offload parameters
  */
 static void
-ice_tstamp(struct ice_ring *tx_ring, struct sk_buff *skb,
+ice_tstamp(struct ice_tx_ring *tx_ring, struct sk_buff *skb,
 	   struct ice_tx_buf *first, struct ice_tx_offload_params *off)
 {
 	s8 idx;
@@ -2181,7 +2198,7 @@ ice_tstamp(struct ice_ring *tx_ring, struct sk_buff *skb,
  * Returns NETDEV_TX_OK if sent, else an error code
  */
 static netdev_tx_t
-ice_xmit_frame_ring(struct sk_buff *skb, struct ice_ring *tx_ring)
+ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 {
 	struct ice_tx_offload_params offload = { 0 };
 	struct ice_vsi *vsi = tx_ring->vsi;
@@ -2282,7 +2299,7 @@ netdev_tx_t ice_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
-	struct ice_ring *tx_ring;
+	struct ice_tx_ring *tx_ring;
 
 	tx_ring = vsi->tx_rings[skb->queue_mapping];
 
@@ -2299,7 +2316,7 @@ netdev_tx_t ice_start_xmit(struct sk_buff *skb, struct net_device *netdev)
  * ice_clean_ctrl_tx_irq - interrupt handler for flow director Tx queue
  * @tx_ring: tx_ring to clean
  */
-void ice_clean_ctrl_tx_irq(struct ice_ring *tx_ring)
+void ice_clean_ctrl_tx_irq(struct ice_tx_ring *tx_ring)
 {
 	struct ice_vsi *vsi = tx_ring->vsi;
 	s16 i = tx_ring->next_to_clean;
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 270c00536eee..57d4dfc78760 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -154,7 +154,7 @@ struct ice_tx_buf {
 
 struct ice_tx_offload_params {
 	u64 cd_qw1;
-	struct ice_ring *tx_ring;
+	struct ice_tx_ring *tx_ring;
 	u32 td_cmd;
 	u32 td_offset;
 	u32 td_l2tag1;
@@ -258,23 +258,20 @@ enum ice_dynamic_itr {
 #define ICE_TX_LEGACY	1
 
 /* descriptor ring, associated with a VSI */
-struct ice_ring {
+struct ice_rx_ring {
 	/* CL1 - 1st cacheline starts here */
-	struct ice_ring *next;		/* pointer to next ring in q_vector */
+	struct ice_rx_ring *next;		/* pointer to next ring in q_vector */
 	void *desc;			/* Descriptor ring memory */
 	struct device *dev;		/* Used for DMA mapping */
 	struct net_device *netdev;	/* netdev ring maps to */
 	struct ice_vsi *vsi;		/* Backreference to associated VSI */
 	struct ice_q_vector *q_vector;	/* Backreference to associated vector */
 	u8 __iomem *tail;
-	union {
-		struct ice_tx_buf *tx_buf;
-		struct ice_rx_buf *rx_buf;
-	};
+	struct ice_rx_buf *rx_buf;
 	/* CL2 - 2nd cacheline starts here */
+	struct xdp_rxq_info xdp_rxq;
+	/* CL3 - 3rd cacheline starts here */
 	u16 q_index;			/* Queue number of ring */
-	u16 q_handle;			/* Queue handle per TC */
-
 	u16 count;			/* Number of descriptors */
 	u16 reg_idx;			/* HW register index of the ring */
 
@@ -282,56 +279,79 @@ struct ice_ring {
 	u16 next_to_use;
 	u16 next_to_clean;
 	u16 next_to_alloc;
+	u16 rx_offset;
+	u16 rx_buf_len;
 
 	/* stats structs */
+	struct ice_rxq_stats rx_stats;
 	struct ice_q_stats	stats;
 	struct u64_stats_sync syncp;
-	union {
-		struct ice_txq_stats tx_stats;
-		struct ice_rxq_stats rx_stats;
-	};
 
 	struct rcu_head rcu;		/* to avoid race on free */
-	DECLARE_BITMAP(xps_state, ICE_TX_NBITS);	/* XPS Config State */
+	/* CL4 - 3rd cacheline starts here */
 	struct bpf_prog *xdp_prog;
 	struct xsk_buff_pool *xsk_pool;
-	u16 rx_offset;
-	/* CL3 - 3rd cacheline starts here */
-	struct xdp_rxq_info xdp_rxq;
 	struct sk_buff *skb;
-	/* CLX - the below items are only accessed infrequently and should be
-	 * in their own cache line if possible
-	 */
-#define ICE_TX_FLAGS_RING_XDP		BIT(0)
+	dma_addr_t dma;			/* physical address of ring */
 #define ICE_RX_FLAGS_RING_BUILD_SKB	BIT(1)
+	u64 cached_phctime;
+	u8 dcb_tc;			/* Traffic class of ring */
+	u8 ptp_rx;
 	u8 flags;
+} ____cacheline_internodealigned_in_smp;
+
+struct ice_tx_ring {
+	/* CL1 - 1st cacheline starts here */
+	struct ice_tx_ring *next;	/* pointer to next ring in q_vector */
+	void *desc;			/* Descriptor ring memory */
+	struct device *dev;		/* Used for DMA mapping */
+	u8 __iomem *tail;
+	struct ice_tx_buf *tx_buf;
+	struct ice_q_vector *q_vector;	/* Backreference to associated vector */
+	struct net_device *netdev;	/* netdev ring maps to */
+	struct ice_vsi *vsi;		/* Backreference to associated VSI */
+	/* CL2 - 2nd cacheline starts here */
 	dma_addr_t dma;			/* physical address of ring */
-	unsigned int size;		/* length of descriptor ring in bytes */
+	u16 next_to_use;
+	u16 next_to_clean;
+	u16 count;			/* Number of descriptors */
+	u16 q_index;			/* Queue number of ring */
+	struct xsk_buff_pool *xsk_pool;
+
+	/* stats structs */
+	struct ice_q_stats	stats;
+	struct u64_stats_sync syncp;
+	struct ice_txq_stats tx_stats;
+
+	/* CL3 - 3rd cacheline starts here */
+	struct rcu_head rcu;		/* to avoid race on free */
+	DECLARE_BITMAP(xps_state, ICE_TX_NBITS);	/* XPS Config State */
+	struct ice_ptp_tx *tx_tstamps;
 	u32 txq_teid;			/* Added Tx queue TEID */
-	u16 rx_buf_len;
+	u16 q_handle;			/* Queue handle per TC */
+	u16 reg_idx;			/* HW register index of the ring */
+#define ICE_TX_FLAGS_RING_XDP		BIT(0)
+	u8 flags;
 	u8 dcb_tc;			/* Traffic class of ring */
-	struct ice_ptp_tx *tx_tstamps;
-	u64 cached_phctime;
-	u8 ptp_rx:1;
-	u8 ptp_tx:1;
+	u8 ptp_tx;
 } ____cacheline_internodealigned_in_smp;
 
-static inline bool ice_ring_uses_build_skb(struct ice_ring *ring)
+static inline bool ice_ring_uses_build_skb(struct ice_rx_ring *ring)
 {
 	return !!(ring->flags & ICE_RX_FLAGS_RING_BUILD_SKB);
 }
 
-static inline void ice_set_ring_build_skb_ena(struct ice_ring *ring)
+static inline void ice_set_ring_build_skb_ena(struct ice_rx_ring *ring)
 {
 	ring->flags |= ICE_RX_FLAGS_RING_BUILD_SKB;
 }
 
-static inline void ice_clear_ring_build_skb_ena(struct ice_ring *ring)
+static inline void ice_clear_ring_build_skb_ena(struct ice_rx_ring *ring)
 {
 	ring->flags &= ~ICE_RX_FLAGS_RING_BUILD_SKB;
 }
 
-static inline bool ice_ring_is_xdp(struct ice_ring *ring)
+static inline bool ice_ring_is_xdp(struct ice_tx_ring *ring)
 {
 	return !!(ring->flags & ICE_TX_FLAGS_RING_XDP);
 }
@@ -343,7 +363,10 @@ enum ice_container_type {
 
 struct ice_ring_container {
 	/* head of linked-list of rings */
-	struct ice_ring *ring;
+	union {
+		struct ice_rx_ring *rx_ring;
+		struct ice_tx_ring *tx_ring;
+	};
 	struct dim dim;		/* data for net_dim algorithm */
 	u16 itr_idx;		/* index in the interrupt vector */
 	/* this matches the maximum number of ITR bits, but in usec
@@ -364,10 +387,13 @@ struct ice_coalesce_stored {
 };
 
 /* iterator for handling rings in ring container */
-#define ice_for_each_ring(pos, head) \
-	for (pos = (head).ring; pos; pos = pos->next)
+#define ice_for_each_rx_ring(pos, head) \
+	for (pos = (head).rx_ring; pos; pos = pos->next)
+
+#define ice_for_each_tx_ring(pos, head) \
+	for (pos = (head).tx_ring; pos; pos = pos->next)
 
-static inline unsigned int ice_rx_pg_order(struct ice_ring *ring)
+static inline unsigned int ice_rx_pg_order(struct ice_rx_ring *ring)
 {
 #if (PAGE_SIZE < 8192)
 	if (ring->rx_buf_len > (PAGE_SIZE / 2))
@@ -380,18 +406,18 @@ static inline unsigned int ice_rx_pg_order(struct ice_ring *ring)
 
 union ice_32b_rx_flex_desc;
 
-bool ice_alloc_rx_bufs(struct ice_ring *rxr, u16 cleaned_count);
+bool ice_alloc_rx_bufs(struct ice_rx_ring *rxr, u16 cleaned_count);
 netdev_tx_t ice_start_xmit(struct sk_buff *skb, struct net_device *netdev);
-void ice_clean_tx_ring(struct ice_ring *tx_ring);
-void ice_clean_rx_ring(struct ice_ring *rx_ring);
-int ice_setup_tx_ring(struct ice_ring *tx_ring);
-int ice_setup_rx_ring(struct ice_ring *rx_ring);
-void ice_free_tx_ring(struct ice_ring *tx_ring);
-void ice_free_rx_ring(struct ice_ring *rx_ring);
+void ice_clean_tx_ring(struct ice_tx_ring *tx_ring);
+void ice_clean_rx_ring(struct ice_rx_ring *rx_ring);
+int ice_setup_tx_ring(struct ice_tx_ring *tx_ring);
+int ice_setup_rx_ring(struct ice_rx_ring *rx_ring);
+void ice_free_tx_ring(struct ice_tx_ring *tx_ring);
+void ice_free_rx_ring(struct ice_rx_ring *rx_ring);
 int ice_napi_poll(struct napi_struct *napi, int budget);
 int
 ice_prgm_fdir_fltr(struct ice_vsi *vsi, struct ice_fltr_desc *fdir_desc,
 		   u8 *raw_packet);
-int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget);
-void ice_clean_ctrl_tx_irq(struct ice_ring *tx_ring);
+int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget);
+void ice_clean_ctrl_tx_irq(struct ice_tx_ring *tx_ring);
 #endif /* _ICE_TXRX_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 171397dcf00a..8ed489420823 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -8,7 +8,7 @@
  * @rx_ring: ring to bump
  * @val: new head index
  */
-void ice_release_rx_desc(struct ice_ring *rx_ring, u16 val)
+void ice_release_rx_desc(struct ice_rx_ring *rx_ring, u16 val)
 {
 	u16 prev_ntu = rx_ring->next_to_use & ~0x7;
 
@@ -66,7 +66,7 @@ static enum pkt_hash_types ice_ptype_to_htype(u16 ptype)
  * @rx_ptype: the ptype value from the descriptor
  */
 static void
-ice_rx_hash(struct ice_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc,
+ice_rx_hash(struct ice_rx_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc,
 	    struct sk_buff *skb, u16 rx_ptype)
 {
 	struct ice_32b_rx_flex_desc_nic *nic_mdid;
@@ -93,7 +93,7 @@ ice_rx_hash(struct ice_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc,
  * skb->protocol must be set before this function is called
  */
 static void
-ice_rx_csum(struct ice_ring *ring, struct sk_buff *skb,
+ice_rx_csum(struct ice_rx_ring *ring, struct sk_buff *skb,
 	    union ice_32b_rx_flex_desc *rx_desc, u16 ptype)
 {
 	struct ice_rx_ptype_decoded decoded;
@@ -178,7 +178,7 @@ ice_rx_csum(struct ice_ring *ring, struct sk_buff *skb,
  * other fields within the skb.
  */
 void
-ice_process_skb_fields(struct ice_ring *rx_ring,
+ice_process_skb_fields(struct ice_rx_ring *rx_ring,
 		       union ice_32b_rx_flex_desc *rx_desc,
 		       struct sk_buff *skb, u16 ptype)
 {
@@ -203,7 +203,7 @@ ice_process_skb_fields(struct ice_ring *rx_ring,
  * gro receive functions (with/without VLAN tag)
  */
 void
-ice_receive_skb(struct ice_ring *rx_ring, struct sk_buff *skb, u16 vlan_tag)
+ice_receive_skb(struct ice_rx_ring *rx_ring, struct sk_buff *skb, u16 vlan_tag)
 {
 	if ((rx_ring->netdev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
 	    (vlan_tag & VLAN_VID_MASK))
@@ -217,7 +217,7 @@ ice_receive_skb(struct ice_ring *rx_ring, struct sk_buff *skb, u16 vlan_tag)
  * @size: packet data size
  * @xdp_ring: XDP ring for transmission
  */
-int ice_xmit_xdp_ring(void *data, u16 size, struct ice_ring *xdp_ring)
+int ice_xmit_xdp_ring(void *data, u16 size, struct ice_tx_ring *xdp_ring)
 {
 	u16 i = xdp_ring->next_to_use;
 	struct ice_tx_desc *tx_desc;
@@ -269,7 +269,7 @@ int ice_xmit_xdp_ring(void *data, u16 size, struct ice_ring *xdp_ring)
  *
  * Returns negative on failure, 0 on success.
  */
-int ice_xmit_xdp_buff(struct xdp_buff *xdp, struct ice_ring *xdp_ring)
+int ice_xmit_xdp_buff(struct xdp_buff *xdp, struct ice_tx_ring *xdp_ring)
 {
 	struct xdp_frame *xdpf = xdp_convert_buff_to_frame(xdp);
 
@@ -288,13 +288,13 @@ int ice_xmit_xdp_buff(struct xdp_buff *xdp, struct ice_ring *xdp_ring)
  * should be called when a batch of packets has been processed in the
  * napi loop.
  */
-void ice_finalize_xdp_rx(struct ice_ring *rx_ring, unsigned int xdp_res)
+void ice_finalize_xdp_rx(struct ice_rx_ring *rx_ring, unsigned int xdp_res)
 {
 	if (xdp_res & ICE_XDP_REDIR)
 		xdp_do_flush_map();
 
 	if (xdp_res & ICE_XDP_TX) {
-		struct ice_ring *xdp_ring =
+		struct ice_tx_ring *xdp_ring =
 			rx_ring->vsi->xdp_rings[rx_ring->q_index];
 
 		ice_xdp_ring_update_tail(xdp_ring);
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
index 05ac30752902..4e56e8e321a8 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
@@ -37,7 +37,7 @@ ice_build_ctob(u64 td_cmd, u64 td_offset, unsigned int size, u64 td_tag)
  *
  * This function updates the XDP Tx ring tail register.
  */
-static inline void ice_xdp_ring_update_tail(struct ice_ring *xdp_ring)
+static inline void ice_xdp_ring_update_tail(struct ice_tx_ring *xdp_ring)
 {
 	/* Force memory writes to complete before letting h/w
 	 * know there are new descriptors to fetch.
@@ -46,14 +46,14 @@ static inline void ice_xdp_ring_update_tail(struct ice_ring *xdp_ring)
 	writel_relaxed(xdp_ring->next_to_use, xdp_ring->tail);
 }
 
-void ice_finalize_xdp_rx(struct ice_ring *rx_ring, unsigned int xdp_res);
-int ice_xmit_xdp_buff(struct xdp_buff *xdp, struct ice_ring *xdp_ring);
-int ice_xmit_xdp_ring(void *data, u16 size, struct ice_ring *xdp_ring);
-void ice_release_rx_desc(struct ice_ring *rx_ring, u16 val);
+void ice_finalize_xdp_rx(struct ice_rx_ring *xdp_ring, unsigned int xdp_res);
+int ice_xmit_xdp_buff(struct xdp_buff *xdp, struct ice_tx_ring *xdp_ring);
+int ice_xmit_xdp_ring(void *data, u16 size, struct ice_tx_ring *xdp_ring);
+void ice_release_rx_desc(struct ice_rx_ring *rx_ring, u16 val);
 void
-ice_process_skb_fields(struct ice_ring *rx_ring,
+ice_process_skb_fields(struct ice_rx_ring *rx_ring,
 		       union ice_32b_rx_flex_desc *rx_desc,
 		       struct sk_buff *skb, u16 ptype);
 void
-ice_receive_skb(struct ice_ring *rx_ring, struct sk_buff *skb, u16 vlan_tag);
+ice_receive_skb(struct ice_rx_ring *rx_ring, struct sk_buff *skb, u16 vlan_tag);
 #endif /* !_ICE_TXRX_LIB_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index e93430ab37f1..9db97daa3391 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -3329,7 +3329,7 @@ static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
 		q_map = vqs->tx_queues;
 
 		for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF) {
-			struct ice_ring *ring = vsi->tx_rings[vf_q_id];
+			struct ice_tx_ring *ring = vsi->tx_rings[vf_q_id];
 			struct ice_txq_meta txq_meta = { 0 };
 
 			if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 5a9f61deeb38..7664358ec18e 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -67,7 +67,7 @@ ice_qvec_toggle_napi(struct ice_vsi *vsi, struct ice_q_vector *q_vector,
  * @q_vector: queue vector
  */
 static void
-ice_qvec_dis_irq(struct ice_vsi *vsi, struct ice_ring *rx_ring,
+ice_qvec_dis_irq(struct ice_vsi *vsi, struct ice_rx_ring *rx_ring,
 		 struct ice_q_vector *q_vector)
 {
 	struct ice_pf *pf = vsi->back;
@@ -104,16 +104,17 @@ ice_qvec_cfg_msix(struct ice_vsi *vsi, struct ice_q_vector *q_vector)
 	u16 reg_idx = q_vector->reg_idx;
 	struct ice_pf *pf = vsi->back;
 	struct ice_hw *hw = &pf->hw;
-	struct ice_ring *ring;
+	struct ice_tx_ring *tx_ring;
+	struct ice_rx_ring *rx_ring;
 
 	ice_cfg_itr(hw, q_vector);
 
-	ice_for_each_ring(ring, q_vector->tx)
-		ice_cfg_txq_interrupt(vsi, ring->reg_idx, reg_idx,
+	ice_for_each_tx_ring(tx_ring, q_vector->tx)
+		ice_cfg_txq_interrupt(vsi, tx_ring->reg_idx, reg_idx,
 				      q_vector->tx.itr_idx);
 
-	ice_for_each_ring(ring, q_vector->rx)
-		ice_cfg_rxq_interrupt(vsi, ring->reg_idx, reg_idx,
+	ice_for_each_rx_ring(rx_ring, q_vector->rx)
+		ice_cfg_rxq_interrupt(vsi, rx_ring->reg_idx, reg_idx,
 				      q_vector->rx.itr_idx);
 
 	ice_flush(hw);
@@ -144,8 +145,9 @@ static void ice_qvec_ena_irq(struct ice_vsi *vsi, struct ice_q_vector *q_vector)
 static int ice_qp_dis(struct ice_vsi *vsi, u16 q_idx)
 {
 	struct ice_txq_meta txq_meta = { };
-	struct ice_ring *tx_ring, *rx_ring;
 	struct ice_q_vector *q_vector;
+	struct ice_tx_ring *tx_ring;
+	struct ice_rx_ring *rx_ring;
 	int timeout = 50;
 	int err;
 
@@ -171,7 +173,7 @@ static int ice_qp_dis(struct ice_vsi *vsi, u16 q_idx)
 	if (err)
 		return err;
 	if (ice_is_xdp_ena_vsi(vsi)) {
-		struct ice_ring *xdp_ring = vsi->xdp_rings[q_idx];
+		struct ice_tx_ring *xdp_ring = vsi->xdp_rings[q_idx];
 
 		memset(&txq_meta, 0, sizeof(txq_meta));
 		ice_fill_txq_meta(vsi, xdp_ring, &txq_meta);
@@ -201,8 +203,9 @@ static int ice_qp_dis(struct ice_vsi *vsi, u16 q_idx)
 static int ice_qp_ena(struct ice_vsi *vsi, u16 q_idx)
 {
 	struct ice_aqc_add_tx_qgrp *qg_buf;
-	struct ice_ring *tx_ring, *rx_ring;
 	struct ice_q_vector *q_vector;
+	struct ice_tx_ring *tx_ring;
+	struct ice_rx_ring *rx_ring;
 	u16 size;
 	int err;
 
@@ -225,7 +228,7 @@ static int ice_qp_ena(struct ice_vsi *vsi, u16 q_idx)
 		goto free_buf;
 
 	if (ice_is_xdp_ena_vsi(vsi)) {
-		struct ice_ring *xdp_ring = vsi->xdp_rings[q_idx];
+		struct ice_tx_ring *xdp_ring = vsi->xdp_rings[q_idx];
 
 		memset(qg_buf, 0, size);
 		qg_buf->num_txqs = 1;
@@ -233,7 +236,7 @@ static int ice_qp_ena(struct ice_vsi *vsi, u16 q_idx)
 		if (err)
 			goto free_buf;
 		ice_set_ring_xdp(xdp_ring);
-		xdp_ring->xsk_pool = ice_xsk_pool(xdp_ring);
+		xdp_ring->xsk_pool = ice_tx_xsk_pool(xdp_ring);
 	}
 
 	err = ice_vsi_cfg_rxq(rx_ring);
@@ -360,7 +363,7 @@ int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
  *
  * Returns true if all allocations were successful, false if any fail.
  */
-bool ice_alloc_rx_bufs_zc(struct ice_ring *rx_ring, u16 count)
+bool ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count)
 {
 	union ice_32b_rx_flex_desc *rx_desc;
 	u16 ntu = rx_ring->next_to_use;
@@ -409,7 +412,7 @@ bool ice_alloc_rx_bufs_zc(struct ice_ring *rx_ring, u16 count)
  * ice_bump_ntc - Bump the next_to_clean counter of an Rx ring
  * @rx_ring: Rx ring
  */
-static void ice_bump_ntc(struct ice_ring *rx_ring)
+static void ice_bump_ntc(struct ice_rx_ring *rx_ring)
 {
 	int ntc = rx_ring->next_to_clean + 1;
 
@@ -428,7 +431,7 @@ static void ice_bump_ntc(struct ice_ring *rx_ring)
  * Returns the skb on success, NULL on failure.
  */
 static struct sk_buff *
-ice_construct_skb_zc(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
+ice_construct_skb_zc(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf)
 {
 	unsigned int metasize = rx_buf->xdp->data - rx_buf->xdp->data_meta;
 	unsigned int datasize = rx_buf->xdp->data_end - rx_buf->xdp->data;
@@ -459,11 +462,11 @@ ice_construct_skb_zc(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
  * Returns any of ICE_XDP_{PASS, CONSUMED, TX, REDIR}
  */
 static int
-ice_run_xdp_zc(struct ice_ring *rx_ring, struct xdp_buff *xdp)
+ice_run_xdp_zc(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp)
 {
 	int err, result = ICE_XDP_PASS;
+	struct ice_tx_ring *xdp_ring;
 	struct bpf_prog *xdp_prog;
-	struct ice_ring *xdp_ring;
 	u32 act;
 
 	/* ZC patch is enabled only when XDP program is set,
@@ -511,7 +514,7 @@ ice_run_xdp_zc(struct ice_ring *rx_ring, struct xdp_buff *xdp)
  *
  * Returns number of processed packets on success, remaining budget on failure.
  */
-int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget)
+int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 {
 	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
 	u16 cleaned_count = ICE_DESC_UNUSED(rx_ring);
@@ -618,7 +621,7 @@ int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget)
  *
  * Returns true if cleanup/transmission is done.
  */
-static bool ice_xmit_zc(struct ice_ring *xdp_ring, int budget)
+static bool ice_xmit_zc(struct ice_tx_ring *xdp_ring, int budget)
 {
 	struct ice_tx_desc *tx_desc = NULL;
 	bool work_done = true;
@@ -669,7 +672,7 @@ static bool ice_xmit_zc(struct ice_ring *xdp_ring, int budget)
  * @tx_buf: Tx buffer to clean
  */
 static void
-ice_clean_xdp_tx_buf(struct ice_ring *xdp_ring, struct ice_tx_buf *tx_buf)
+ice_clean_xdp_tx_buf(struct ice_tx_ring *xdp_ring, struct ice_tx_buf *tx_buf)
 {
 	xdp_return_frame((struct xdp_frame *)tx_buf->raw_buf);
 	dma_unmap_single(xdp_ring->dev, dma_unmap_addr(tx_buf, dma),
@@ -684,7 +687,7 @@ ice_clean_xdp_tx_buf(struct ice_ring *xdp_ring, struct ice_tx_buf *tx_buf)
  *
  * Returns true if cleanup/tranmission is done.
  */
-bool ice_clean_tx_irq_zc(struct ice_ring *xdp_ring, int budget)
+bool ice_clean_tx_irq_zc(struct ice_tx_ring *xdp_ring, int budget)
 {
 	int total_packets = 0, total_bytes = 0;
 	s16 ntc = xdp_ring->next_to_clean;
@@ -757,7 +760,7 @@ ice_xsk_wakeup(struct net_device *netdev, u32 queue_id,
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_q_vector *q_vector;
 	struct ice_vsi *vsi = np->vsi;
-	struct ice_ring *ring;
+	struct ice_tx_ring *ring;
 
 	if (test_bit(ICE_DOWN, vsi->state))
 		return -ENETDOWN;
@@ -808,7 +811,7 @@ bool ice_xsk_any_rx_ring_ena(struct ice_vsi *vsi)
  * ice_xsk_clean_rx_ring - clean buffer pool queues connected to a given Rx ring
  * @rx_ring: ring to be cleaned
  */
-void ice_xsk_clean_rx_ring(struct ice_ring *rx_ring)
+void ice_xsk_clean_rx_ring(struct ice_rx_ring *rx_ring)
 {
 	u16 i;
 
@@ -826,7 +829,7 @@ void ice_xsk_clean_rx_ring(struct ice_ring *rx_ring)
  * ice_xsk_clean_xdp_ring - Clean the XDP Tx ring and its buffer pool queues
  * @xdp_ring: XDP_Tx ring
  */
-void ice_xsk_clean_xdp_ring(struct ice_ring *xdp_ring)
+void ice_xsk_clean_xdp_ring(struct ice_tx_ring *xdp_ring)
 {
 	u16 ntc = xdp_ring->next_to_clean, ntu = xdp_ring->next_to_use;
 	u32 xsk_frames = 0;
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.h b/drivers/net/ethernet/intel/ice/ice_xsk.h
index ea208808623a..4c7bd8e9dfc4 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.h
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.h
@@ -11,13 +11,13 @@ struct ice_vsi;
 #ifdef CONFIG_XDP_SOCKETS
 int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool,
 		       u16 qid);
-int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget);
-bool ice_clean_tx_irq_zc(struct ice_ring *xdp_ring, int budget);
+int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget);
+bool ice_clean_tx_irq_zc(struct ice_tx_ring *xdp_ring, int budget);
 int ice_xsk_wakeup(struct net_device *netdev, u32 queue_id, u32 flags);
-bool ice_alloc_rx_bufs_zc(struct ice_ring *rx_ring, u16 count);
+bool ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count);
 bool ice_xsk_any_rx_ring_ena(struct ice_vsi *vsi);
-void ice_xsk_clean_rx_ring(struct ice_ring *rx_ring);
-void ice_xsk_clean_xdp_ring(struct ice_ring *xdp_ring);
+void ice_xsk_clean_rx_ring(struct ice_rx_ring *rx_ring);
+void ice_xsk_clean_xdp_ring(struct ice_tx_ring *xdp_ring);
 #else
 static inline int
 ice_xsk_pool_setup(struct ice_vsi __always_unused *vsi,
@@ -28,21 +28,21 @@ ice_xsk_pool_setup(struct ice_vsi __always_unused *vsi,
 }
 
 static inline int
-ice_clean_rx_irq_zc(struct ice_ring __always_unused *rx_ring,
+ice_clean_rx_irq_zc(struct ice_rx_ring __always_unused *rx_ring,
 		    int __always_unused budget)
 {
 	return 0;
 }
 
 static inline bool
-ice_clean_tx_irq_zc(struct ice_ring __always_unused *xdp_ring,
+ice_clean_tx_irq_zc(struct ice_tx_ring __always_unused *xdp_ring,
 		    int __always_unused budget)
 {
 	return false;
 }
 
 static inline bool
-ice_alloc_rx_bufs_zc(struct ice_ring __always_unused *rx_ring,
+ice_alloc_rx_bufs_zc(struct ice_rx_ring __always_unused *rx_ring,
 		     u16 __always_unused count)
 {
 	return false;
@@ -60,7 +60,7 @@ ice_xsk_wakeup(struct net_device __always_unused *netdev,
 	return -EOPNOTSUPP;
 }
 
-static inline void ice_xsk_clean_rx_ring(struct ice_ring *rx_ring) { }
-static inline void ice_xsk_clean_xdp_ring(struct ice_ring *xdp_ring) { }
+static inline void ice_xsk_clean_rx_ring(struct ice_rx_ring *rx_ring) { }
+static inline void ice_xsk_clean_xdp_ring(struct ice_tx_ring *xdp_ring) { }
 #endif /* CONFIG_XDP_SOCKETS */
 #endif /* !_ICE_XSK_H_ */
-- 
2.20.1

