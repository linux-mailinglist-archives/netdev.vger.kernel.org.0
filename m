Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216D442F839
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 18:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241384AbhJOQd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 12:33:58 -0400
Received: from mga12.intel.com ([192.55.52.136]:37917 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241380AbhJOQdy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 12:33:54 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10138"; a="208059657"
X-IronPort-AV: E=Sophos;i="5.85,376,1624345200"; 
   d="scan'208";a="208059657"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2021 09:31:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,376,1624345200"; 
   d="scan'208";a="528205599"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 15 Oct 2021 09:31:10 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kpsingh@kernel.org, kafai@fb.com, yhs@fb.com,
        songliubraving@fb.com, bpf@vger.kernel.org,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 9/9] ice: make use of ice_for_each_* macros
Date:   Fri, 15 Oct 2021 09:29:08 -0700
Message-Id: <20211015162908.145341-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211015162908.145341-1-anthony.l.nguyen@intel.com>
References: <20211015162908.145341-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Go through the code base and use ice_for_each_* macros.  While at it,
introduce ice_for_each_xdp_txq() macro that can be used for looping over
xdp_rings array.

Commit is not introducing any new functionality.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h         |  5 ++++-
 drivers/net/ethernet/intel/ice/ice_arfs.c    |  2 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c |  4 ++--
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 10 ++++-----
 drivers/net/ethernet/intel/ice/ice_lib.c     | 22 ++++++++++----------
 drivers/net/ethernet/intel/ice/ice_main.c    | 14 ++++++-------
 6 files changed, 30 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index aeac6cd0e74f..80f14886b5b1 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -125,10 +125,13 @@
 #define ice_for_each_vsi(pf, i) \
 	for ((i) = 0; (i) < (pf)->num_alloc_vsi; (i)++)
 
-/* Macros for each Tx/Rx ring in a VSI */
+/* Macros for each Tx/Xdp/Rx ring in a VSI */
 #define ice_for_each_txq(vsi, i) \
 	for ((i) = 0; (i) < (vsi)->num_txq; (i)++)
 
+#define ice_for_each_xdp_txq(vsi, i) \
+	for ((i) = 0; (i) < (vsi)->num_xdp_txq; (i)++)
+
 #define ice_for_each_rxq(vsi, i) \
 	for ((i) = 0; (i) < (vsi)->num_rxq; (i)++)
 
diff --git a/drivers/net/ethernet/intel/ice/ice_arfs.c b/drivers/net/ethernet/intel/ice/ice_arfs.c
index 3071b8e79499..5daade32ea62 100644
--- a/drivers/net/ethernet/intel/ice/ice_arfs.c
+++ b/drivers/net/ethernet/intel/ice/ice_arfs.c
@@ -614,7 +614,7 @@ int ice_set_cpu_rx_rmap(struct ice_vsi *vsi)
 		return -EINVAL;
 
 	base_idx = vsi->base_vector;
-	for (i = 0; i < vsi->num_q_vectors; i++)
+	ice_for_each_q_vector(vsi, i)
 		if (irq_cpu_rmap_add(netdev->rx_cpu_rmap,
 				     pf->msix_entries[base_idx + i].vector)) {
 			ice_free_cpu_rx_rmap(vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 4366626e0eb4..4284526e9e24 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -201,11 +201,11 @@ void ice_vsi_cfg_dcb_rings(struct ice_vsi *vsi)
 
 	if (!test_bit(ICE_FLAG_DCB_ENA, vsi->back->flags)) {
 		/* Reset the TC information */
-		for (i = 0; i < vsi->num_txq; i++) {
+		ice_for_each_txq(vsi, i) {
 			tx_ring = vsi->tx_rings[i];
 			tx_ring->dcb_tc = 0;
 		}
-		for (i = 0; i < vsi->num_rxq; i++) {
+		ice_for_each_rxq(vsi, i) {
 			rx_ring = vsi->rx_rings[i];
 			rx_ring->dcb_tc = 0;
 		}
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 19ae045b7242..6e0af72c2020 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2756,12 +2756,12 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
 
 	/* set for the next time the netdev is started */
 	if (!netif_running(vsi->netdev)) {
-		for (i = 0; i < vsi->alloc_txq; i++)
+		ice_for_each_alloc_txq(vsi, i)
 			vsi->tx_rings[i]->count = new_tx_cnt;
-		for (i = 0; i < vsi->alloc_rxq; i++)
+		ice_for_each_alloc_rxq(vsi, i)
 			vsi->rx_rings[i]->count = new_rx_cnt;
 		if (ice_is_xdp_ena_vsi(vsi))
-			for (i = 0; i < vsi->num_xdp_txq; i++)
+			ice_for_each_xdp_txq(vsi, i)
 				vsi->xdp_rings[i]->count = new_tx_cnt;
 		vsi->num_tx_desc = (u16)new_tx_cnt;
 		vsi->num_rx_desc = (u16)new_rx_cnt;
@@ -2810,7 +2810,7 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
 		goto free_tx;
 	}
 
-	for (i = 0; i < vsi->num_xdp_txq; i++) {
+	ice_for_each_xdp_txq(vsi, i) {
 		/* clone ring and setup updated count */
 		xdp_rings[i] = *vsi->xdp_rings[i];
 		xdp_rings[i].count = new_tx_cnt;
@@ -2904,7 +2904,7 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
 		}
 
 		if (xdp_rings) {
-			for (i = 0; i < vsi->num_xdp_txq; i++) {
+			ice_for_each_xdp_txq(vsi, i) {
 				ice_free_tx_ring(vsi->xdp_rings[i]);
 				*vsi->xdp_rings[i] = xdp_rings[i];
 			}
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index e4dc4435c8f5..f981e77f72ad 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -46,12 +46,12 @@ static int ice_vsi_ctrl_all_rx_rings(struct ice_vsi *vsi, bool ena)
 	int ret = 0;
 	u16 i;
 
-	for (i = 0; i < vsi->num_rxq; i++)
+	ice_for_each_rxq(vsi, i)
 		ice_vsi_ctrl_one_rx_ring(vsi, ena, i, false);
 
 	ice_flush(&vsi->back->hw);
 
-	for (i = 0; i < vsi->num_rxq; i++) {
+	ice_for_each_rxq(vsi, i) {
 		ret = ice_vsi_wait_one_rx_ring(vsi, ena, i);
 		if (ret)
 			break;
@@ -639,12 +639,12 @@ static void ice_vsi_put_qs(struct ice_vsi *vsi)
 
 	mutex_lock(&pf->avail_q_mutex);
 
-	for (i = 0; i < vsi->alloc_txq; i++) {
+	ice_for_each_alloc_txq(vsi, i) {
 		clear_bit(vsi->txq_map[i], pf->avail_txqs);
 		vsi->txq_map[i] = ICE_INVAL_Q_INDEX;
 	}
 
-	for (i = 0; i < vsi->alloc_rxq; i++) {
+	ice_for_each_alloc_rxq(vsi, i) {
 		clear_bit(vsi->rxq_map[i], pf->avail_rxqs);
 		vsi->rxq_map[i] = ICE_INVAL_Q_INDEX;
 	}
@@ -1298,7 +1298,7 @@ static void ice_vsi_clear_rings(struct ice_vsi *vsi)
 	}
 
 	if (vsi->tx_rings) {
-		for (i = 0; i < vsi->alloc_txq; i++) {
+		ice_for_each_alloc_txq(vsi, i) {
 			if (vsi->tx_rings[i]) {
 				kfree_rcu(vsi->tx_rings[i], rcu);
 				WRITE_ONCE(vsi->tx_rings[i], NULL);
@@ -1306,7 +1306,7 @@ static void ice_vsi_clear_rings(struct ice_vsi *vsi)
 		}
 	}
 	if (vsi->rx_rings) {
-		for (i = 0; i < vsi->alloc_rxq; i++) {
+		ice_for_each_alloc_rxq(vsi, i) {
 			if (vsi->rx_rings[i]) {
 				kfree_rcu(vsi->rx_rings[i], rcu);
 				WRITE_ONCE(vsi->rx_rings[i], NULL);
@@ -1327,7 +1327,7 @@ static int ice_vsi_alloc_rings(struct ice_vsi *vsi)
 
 	dev = ice_pf_to_dev(pf);
 	/* Allocate Tx rings */
-	for (i = 0; i < vsi->alloc_txq; i++) {
+	ice_for_each_alloc_txq(vsi, i) {
 		struct ice_tx_ring *ring;
 
 		/* allocate with kzalloc(), free with kfree_rcu() */
@@ -1346,7 +1346,7 @@ static int ice_vsi_alloc_rings(struct ice_vsi *vsi)
 	}
 
 	/* Allocate Rx rings */
-	for (i = 0; i < vsi->alloc_rxq; i++) {
+	ice_for_each_alloc_rxq(vsi, i) {
 		struct ice_rx_ring *ring;
 
 		/* allocate with kzalloc(), free with kfree_rcu() */
@@ -1857,7 +1857,7 @@ int ice_vsi_cfg_xdp_txqs(struct ice_vsi *vsi)
 	if (ret)
 		return ret;
 
-	for (i = 0; i < vsi->num_xdp_txq; i++)
+	ice_for_each_xdp_txq(vsi, i)
 		vsi->xdp_rings[i]->xsk_pool = ice_tx_xsk_pool(vsi->xdp_rings[i]);
 
 	return ret;
@@ -1955,7 +1955,7 @@ void ice_vsi_cfg_msix(struct ice_vsi *vsi)
 	u16 txq = 0, rxq = 0;
 	int i, q;
 
-	for (i = 0; i < vsi->num_q_vectors; i++) {
+	ice_for_each_q_vector(vsi, i) {
 		struct ice_q_vector *q_vector = vsi->q_vectors[i];
 		u16 reg_idx = q_vector->reg_idx;
 
@@ -2649,7 +2649,7 @@ static void ice_vsi_release_msix(struct ice_vsi *vsi)
 	u32 rxq = 0;
 	int i, q;
 
-	for (i = 0; i < vsi->num_q_vectors; i++) {
+	ice_for_each_q_vector(vsi, i) {
 		struct ice_q_vector *q_vector = vsi->q_vectors[i];
 
 		ice_write_intrl(q_vector, 0);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index ccd9b9514001..f531691a3e12 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -103,7 +103,7 @@ static void ice_check_for_hang_subtask(struct ice_pf *pf)
 
 	hw = &vsi->back->hw;
 
-	for (i = 0; i < vsi->num_txq; i++) {
+	ice_for_each_txq(vsi, i) {
 		struct ice_tx_ring *tx_ring = vsi->tx_rings[i];
 
 		if (tx_ring && tx_ring->desc) {
@@ -2377,7 +2377,7 @@ static int ice_xdp_alloc_setup_rings(struct ice_vsi *vsi)
 	struct ice_tx_desc *tx_desc;
 	int i, j;
 
-	for (i = 0; i < vsi->num_xdp_txq; i++) {
+	ice_for_each_xdp_txq(vsi, i) {
 		u16 xdp_q_idx = vsi->alloc_txq + i;
 		struct ice_tx_ring *xdp_ring;
 
@@ -2526,7 +2526,7 @@ int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog)
 
 	return 0;
 clear_xdp_rings:
-	for (i = 0; i < vsi->num_xdp_txq; i++)
+	ice_for_each_xdp_txq(vsi, i)
 		if (vsi->xdp_rings[i]) {
 			kfree_rcu(vsi->xdp_rings[i], rcu);
 			vsi->xdp_rings[i] = NULL;
@@ -2534,7 +2534,7 @@ int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog)
 
 err_map_xdp:
 	mutex_lock(&pf->avail_q_mutex);
-	for (i = 0; i < vsi->num_xdp_txq; i++) {
+	ice_for_each_xdp_txq(vsi, i) {
 		clear_bit(vsi->txq_map[i + vsi->alloc_txq], pf->avail_txqs);
 		vsi->txq_map[i + vsi->alloc_txq] = ICE_INVAL_Q_INDEX;
 	}
@@ -2579,13 +2579,13 @@ int ice_destroy_xdp_rings(struct ice_vsi *vsi)
 
 free_qmap:
 	mutex_lock(&pf->avail_q_mutex);
-	for (i = 0; i < vsi->num_xdp_txq; i++) {
+	ice_for_each_xdp_txq(vsi, i) {
 		clear_bit(vsi->txq_map[i + vsi->alloc_txq], pf->avail_txqs);
 		vsi->txq_map[i + vsi->alloc_txq] = ICE_INVAL_Q_INDEX;
 	}
 	mutex_unlock(&pf->avail_q_mutex);
 
-	for (i = 0; i < vsi->num_xdp_txq; i++)
+	ice_for_each_xdp_txq(vsi, i)
 		if (vsi->xdp_rings[i]) {
 			if (vsi->xdp_rings[i]->desc)
 				ice_free_tx_ring(vsi->xdp_rings[i]);
@@ -7066,7 +7066,7 @@ static void ice_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 	}
 
 	/* now that we have an index, find the tx_ring struct */
-	for (i = 0; i < vsi->num_txq; i++)
+	ice_for_each_txq(vsi, i)
 		if (vsi->tx_rings[i] && vsi->tx_rings[i]->desc)
 			if (txqueue == vsi->tx_rings[i]->q_index) {
 				tx_ring = vsi->tx_rings[i];
-- 
2.31.1

