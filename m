Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93040426038
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 01:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241164AbhJGXKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 19:10:37 -0400
Received: from mga03.intel.com ([134.134.136.65]:15520 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234114AbhJGXKX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 19:10:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10130"; a="226340361"
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="226340361"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 16:08:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="590344345"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 07 Oct 2021 16:08:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Grzegorz Nitka <grzegorz.nitka@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, jiri@resnulli.us, ivecera@redhat.com,
        michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 08/12] ice: introduce new type of VSI for switchdev
Date:   Thu,  7 Oct 2021 16:06:16 -0700
Message-Id: <20211007230620.3413290-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007230620.3413290-1-anthony.l.nguyen@intel.com>
References: <20211007230620.3413290-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grzegorz Nitka <grzegorz.nitka@intel.com>

New type of VSI has to be defined for switchdev control plane
VSI. Number of allocated Tx and Rx queue has to be equal to
amount of VFs, because each port representor should have one
Tx and Rx queue.

Also to not increase number of used irqs too much, control plane
VSI uses only one q_vector and handle all queues in one irq.
To allow handling all queues in one irq , new function to clean
msix for eswitch was introduced. This function will schedule napi
for each representor instead of scheduling it only for one like in
normal clean irq function.

Only one additional msix has to be requested. Always try to request
it in ice_ena_msix_range function.

Signed-off-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h         |  1 +
 drivers/net/ethernet/intel/ice/ice_base.c    | 36 ++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_eswitch.c |  2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c     | 48 +++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_main.c    |  7 +++
 drivers/net/ethernet/intel/ice/ice_type.h    |  1 +
 6 files changed, 92 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index c4d216140043..3399eb777d68 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -85,6 +85,7 @@
 #define ICE_FDIR_MSIX		2
 #define ICE_RDMA_NUM_AEQ_MSIX	4
 #define ICE_MIN_RDMA_MSIX	2
+#define ICE_ESWITCH_MSIX	1
 #define ICE_NO_VSI		0xffff
 #define ICE_VSI_MAP_CONTIG	0
 #define ICE_VSI_MAP_SCATTER	1
diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index c36057efc7ae..d7a5ac9346bc 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -217,6 +217,30 @@ static u16 ice_calc_q_handle(struct ice_vsi *vsi, struct ice_ring *ring, u8 tc)
 	return ring->q_index - vsi->tc_cfg.tc_info[tc].qoffset;
 }
 
+/**
+ * ice_eswitch_calc_q_handle
+ * @ring: pointer to ring which unique index is needed
+ *
+ * To correctly work with many netdevs ring->q_index of Tx rings on switchdev
+ * VSI can repeat. Hardware ring setup requires unique q_index. Calculate it
+ * here by finding index in vsi->tx_rings of this ring.
+ *
+ * Return ICE_INVAL_Q_INDEX when index wasn't found. Should never happen,
+ * because VSI is get from ring->vsi, so it has to be present in this VSI.
+ */
+static u16 ice_eswitch_calc_q_handle(struct ice_ring *ring)
+{
+	struct ice_vsi *vsi = ring->vsi;
+	int i;
+
+	ice_for_each_txq(vsi, i) {
+		if (vsi->tx_rings[i] == ring)
+			return i;
+	}
+
+	return ICE_INVAL_Q_INDEX;
+}
+
 /**
  * ice_cfg_xps_tx_ring - Configure XPS for a Tx ring
  * @ring: The Tx ring to configure
@@ -280,6 +304,9 @@ ice_setup_tx_ctx(struct ice_ring *ring, struct ice_tlan_ctx *tlan_ctx, u16 pf_q)
 		tlan_ctx->vmvf_num = hw->func_caps.vf_base_id + vsi->vf_id;
 		tlan_ctx->vmvf_type = ICE_TLAN_CTX_VMVF_TYPE_VF;
 		break;
+	case ICE_VSI_SWITCHDEV_CTRL:
+		tlan_ctx->vmvf_type = ICE_TLAN_CTX_VMVF_TYPE_VMQ;
+		break;
 	default:
 		return;
 	}
@@ -746,7 +773,14 @@ ice_vsi_cfg_txq(struct ice_vsi *vsi, struct ice_ring *ring,
 	/* Add unique software queue handle of the Tx queue per
 	 * TC into the VSI Tx ring
 	 */
-	ring->q_handle = ice_calc_q_handle(vsi, ring, tc);
+	if (vsi->type == ICE_VSI_SWITCHDEV_CTRL) {
+		ring->q_handle = ice_eswitch_calc_q_handle(ring);
+
+		if (ring->q_handle == ICE_INVAL_Q_INDEX)
+			return -ENODEV;
+	} else {
+		ring->q_handle = ice_calc_q_handle(vsi, ring, tc);
+	}
 
 	status = ice_ena_vsi_txq(vsi->port_info, vsi->idx, tc, ring->q_handle,
 				 1, qg_buf, buf_len, NULL);
diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index 242cdbbce61c..8d8f80f45788 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -261,7 +261,7 @@ static void ice_eswitch_release_env(struct ice_pf *pf)
 static struct ice_vsi *
 ice_eswitch_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi)
 {
-	return NULL;
+	return ice_vsi_setup(pf, pi, ICE_VSI_SWITCHDEV_CTRL, ICE_INVAL_VFID);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index a689d9bec32e..93565f597266 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -24,6 +24,8 @@ const char *ice_vsi_type_str(enum ice_vsi_type vsi_type)
 		return "ICE_VSI_CTRL";
 	case ICE_VSI_LB:
 		return "ICE_VSI_LB";
+	case ICE_VSI_SWITCHDEV_CTRL:
+		return "ICE_VSI_SWITCHDEV_CTRL";
 	default:
 		return "unknown";
 	}
@@ -132,6 +134,7 @@ static void ice_vsi_set_num_desc(struct ice_vsi *vsi)
 {
 	switch (vsi->type) {
 	case ICE_VSI_PF:
+	case ICE_VSI_SWITCHDEV_CTRL:
 	case ICE_VSI_CTRL:
 	case ICE_VSI_LB:
 		/* a user could change the values of num_[tr]x_desc using
@@ -200,6 +203,14 @@ static void ice_vsi_set_num_qs(struct ice_vsi *vsi, u16 vf_id)
 					   max_t(int, vsi->alloc_rxq,
 						 vsi->alloc_txq));
 		break;
+	case ICE_VSI_SWITCHDEV_CTRL:
+		/* The number of queues for ctrl VSI is equal to number of VFs.
+		 * Each ring is associated to the corresponding VF_PR netdev.
+		 */
+		vsi->alloc_txq = pf->num_alloc_vfs;
+		vsi->alloc_rxq = pf->num_alloc_vfs;
+		vsi->num_q_vectors = 1;
+		break;
 	case ICE_VSI_VF:
 		vf = &pf->vf[vsi->vf_id];
 		if (vf->num_req_qs)
@@ -408,6 +419,21 @@ static irqreturn_t ice_msix_clean_rings(int __always_unused irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t ice_eswitch_msix_clean_rings(int __always_unused irq, void *data)
+{
+	struct ice_q_vector *q_vector = (struct ice_q_vector *)data;
+	struct ice_pf *pf = q_vector->vsi->back;
+	int i;
+
+	if (!q_vector->tx.ring && !q_vector->rx.ring)
+		return IRQ_HANDLED;
+
+	ice_for_each_vf(pf, i)
+		napi_schedule(&pf->vf[i].repr->q_vector->napi);
+
+	return IRQ_HANDLED;
+}
+
 /**
  * ice_vsi_alloc - Allocates the next available struct VSI in the PF
  * @pf: board private structure
@@ -448,6 +474,13 @@ ice_vsi_alloc(struct ice_pf *pf, enum ice_vsi_type vsi_type, u16 vf_id)
 		ice_vsi_set_num_qs(vsi, ICE_INVAL_VFID);
 
 	switch (vsi->type) {
+	case ICE_VSI_SWITCHDEV_CTRL:
+		if (ice_vsi_alloc_arrays(vsi))
+			goto err_rings;
+
+		/* Setup eswitch MSIX irq handler for VSI */
+		vsi->irq_handler = ice_eswitch_msix_clean_rings;
+		break;
 	case ICE_VSI_PF:
 		if (ice_vsi_alloc_arrays(vsi))
 			goto err_rings;
@@ -707,6 +740,12 @@ static void ice_vsi_set_rss_params(struct ice_vsi *vsi)
 				      BIT(cap->rss_table_entry_width));
 		vsi->rss_lut_type = ICE_AQC_GSET_RSS_LUT_TABLE_TYPE_PF;
 		break;
+	case ICE_VSI_SWITCHDEV_CTRL:
+		vsi->rss_table_size = ICE_VSIQF_HLUT_ARRAY_SIZE;
+		vsi->rss_size = min_t(u16, num_online_cpus(),
+				      BIT(cap->rss_table_entry_width));
+		vsi->rss_lut_type = ICE_AQC_GSET_RSS_LUT_TABLE_TYPE_VSI;
+		break;
 	case ICE_VSI_VF:
 		/* VF VSI will get a small RSS table.
 		 * For VSI_LUT, LUT size should be set to 64 bytes.
@@ -980,6 +1019,9 @@ static int ice_vsi_init(struct ice_vsi *vsi, bool init_vsi)
 	case ICE_VSI_PF:
 		ctxt->flags = ICE_AQ_VSI_TYPE_PF;
 		break;
+	case ICE_VSI_SWITCHDEV_CTRL:
+		ctxt->flags = ICE_AQ_VSI_TYPE_VMDQ2;
+		break;
 	case ICE_VSI_VF:
 		ctxt->flags = ICE_AQ_VSI_TYPE_VF;
 		/* VF number here is the absolute VF number (0-255) */
@@ -2297,6 +2339,7 @@ static void ice_set_agg_vsi(struct ice_vsi *vsi)
 	case ICE_VSI_CTRL:
 	case ICE_VSI_LB:
 	case ICE_VSI_PF:
+	case ICE_VSI_SWITCHDEV_CTRL:
 		max_agg_nodes = ICE_MAX_PF_AGG_NODES;
 		agg_node_id_start = ICE_PF_AGG_NODE_ID_START;
 		agg_node_iter = &pf->pf_agg_node[0];
@@ -2448,6 +2491,7 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 
 	switch (vsi->type) {
 	case ICE_VSI_CTRL:
+	case ICE_VSI_SWITCHDEV_CTRL:
 	case ICE_VSI_PF:
 		ret = ice_vsi_alloc_q_vectors(vsi);
 		if (ret)
@@ -2757,7 +2801,8 @@ void ice_dis_vsi(struct ice_vsi *vsi, bool locked)
 		} else {
 			ice_vsi_close(vsi);
 		}
-	} else if (vsi->type == ICE_VSI_CTRL) {
+	} else if (vsi->type == ICE_VSI_CTRL ||
+		   vsi->type == ICE_VSI_SWITCHDEV_CTRL) {
 		ice_vsi_close(vsi);
 	}
 }
@@ -3136,6 +3181,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 
 	switch (vtype) {
 	case ICE_VSI_CTRL:
+	case ICE_VSI_SWITCHDEV_CTRL:
 	case ICE_VSI_PF:
 		ret = ice_vsi_alloc_q_vectors(vsi);
 		if (ret)
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 9277f87bcb02..819d4912d84e 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3541,6 +3541,13 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 		v_left -= needed;
 	}
 
+	/* reserve for switchdev */
+	needed = ICE_ESWITCH_MSIX;
+	if (v_left < needed)
+		goto no_hw_vecs_left_err;
+	v_budget += needed;
+	v_left -= needed;
+
 	/* total used for non-traffic vectors */
 	v_other = v_budget;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 6705f56be020..e064439fc1a9 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -139,6 +139,7 @@ enum ice_vsi_type {
 	ICE_VSI_VF = 1,
 	ICE_VSI_CTRL = 3,	/* equates to ICE_VSI_PF with 1 queue pair */
 	ICE_VSI_LB = 6,
+	ICE_VSI_SWITCHDEV_CTRL = 7,
 };
 
 struct ice_link_status {
-- 
2.31.1

