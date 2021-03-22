Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1C53450D4
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbhCVUbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:31:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:5504 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231860AbhCVUbV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:31:21 -0400
IronPort-SDR: /GGCKY3aVjZy0g61klPHhATs/pHO+6waKILug93q6skqrulMVpcfmka/IS5U6xHlgiHRR+feK7
 FgOtTQw+6yVg==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="190438215"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="190438215"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 13:31:18 -0700
IronPort-SDR: 2bA4aVlQXZ+F/5GFwyutXYR9TLUQdD6GoTR5Qf2HAAHxfHP0YtPt5qy5QMWt9b7gjXlar6WZ1I
 8t3S5mRSVHwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="375810594"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 22 Mar 2021 13:31:17 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Qi Zhang <qi.z.zhang@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        haiyue.wang@intel.com, Xiaoyun Li <xiaoyun.li@intel.com>,
        Yahui Cao <yahui.cao@intel.com>, Chen Bo <BoX.C.Chen@intel.com>
Subject: [PATCH net-next 06/18] ice: Add support for per VF ctrl VSI enabling
Date:   Mon, 22 Mar 2021 13:32:32 -0700
Message-Id: <20210322203244.2525310-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210322203244.2525310-1-anthony.l.nguyen@intel.com>
References: <20210322203244.2525310-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qi Zhang <qi.z.zhang@intel.com>

We are going to enable FDIR configure for AVF through virtual channel.
The first step is to add helper functions to support control VSI setup.
A control VSI will be allocated for a VF when AVF creates its
first FDIR rule through ice_vf_ctrl_vsi_setup().
The patch will also allocate FDIR rule space for VF's control VSI.
If a VF asks for flow director rules, then those should come entirely
from the best effort pool and not from the guaranteed pool. The patch
allow a VF VSI to have only space in the best effort rules.

Signed-off-by: Xiaoyun Li <xiaoyun.li@intel.com>
Signed-off-by: Yahui Cao <yahui.cao@intel.com>
Signed-off-by: Qi Zhang <qi.z.zhang@intel.com>
Tested-by: Chen Bo <BoX.C.Chen@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |  4 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      | 64 ++++++++++++++++---
 drivers/net/ethernet/intel/ice/ice_main.c     |  9 ++-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 61 ++++++++++++++++++
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  2 +
 5 files changed, 129 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 357706444dd5..7b45f2ab4036 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -73,7 +73,7 @@
 #define ICE_MIN_LAN_TXRX_MSIX	1
 #define ICE_MIN_LAN_OICR_MSIX	1
 #define ICE_MIN_MSIX		(ICE_MIN_LAN_TXRX_MSIX + ICE_MIN_LAN_OICR_MSIX)
-#define ICE_FDIR_MSIX		1
+#define ICE_FDIR_MSIX		2
 #define ICE_NO_VSI		0xffff
 #define ICE_VSI_MAP_CONTIG	0
 #define ICE_VSI_MAP_SCATTER	1
@@ -84,6 +84,8 @@
 #define ICE_MAX_LG_RSS_QS	256
 #define ICE_RES_VALID_BIT	0x8000
 #define ICE_RES_MISC_VEC_ID	(ICE_RES_VALID_BIT - 1)
+/* All VF control VSIs share the same IRQ, so assign a unique ID for them */
+#define ICE_RES_VF_CTRL_VEC_ID	(ICE_RES_MISC_VEC_ID - 1)
 #define ICE_INVAL_Q_INDEX	0xffff
 #define ICE_INVAL_VFID		256
 
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 8d4e2ad4328d..c345432fac72 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -343,6 +343,9 @@ static int ice_vsi_clear(struct ice_vsi *vsi)
 	pf->vsi[vsi->idx] = NULL;
 	if (vsi->idx < pf->next_vsi && vsi->type != ICE_VSI_CTRL)
 		pf->next_vsi = vsi->idx;
+	if (vsi->idx < pf->next_vsi && vsi->type == ICE_VSI_CTRL &&
+	    vsi->vf_id != ICE_INVAL_VFID)
+		pf->next_vsi = vsi->idx;
 
 	ice_vsi_free_arrays(vsi);
 	mutex_unlock(&pf->sw_mutex);
@@ -454,8 +457,8 @@ ice_vsi_alloc(struct ice_pf *pf, enum ice_vsi_type vsi_type, u16 vf_id)
 		goto unlock_pf;
 	}
 
-	if (vsi->type == ICE_VSI_CTRL) {
-		/* Use the last VSI slot as the index for the control VSI */
+	if (vsi->type == ICE_VSI_CTRL && vf_id == ICE_INVAL_VFID) {
+		/* Use the last VSI slot as the index for PF control VSI */
 		vsi->idx = pf->num_alloc_vsi - 1;
 		pf->ctrl_vsi_idx = vsi->idx;
 		pf->vsi[vsi->idx] = vsi;
@@ -468,6 +471,9 @@ ice_vsi_alloc(struct ice_pf *pf, enum ice_vsi_type vsi_type, u16 vf_id)
 		pf->next_vsi = ice_get_free_slot(pf->vsi, pf->num_alloc_vsi,
 						 pf->next_vsi);
 	}
+
+	if (vsi->type == ICE_VSI_CTRL && vf_id != ICE_INVAL_VFID)
+		pf->vf[vf_id].ctrl_vsi_idx = vsi->idx;
 	goto unlock_pf;
 
 err_rings:
@@ -506,7 +512,7 @@ static int ice_alloc_fd_res(struct ice_vsi *vsi)
 	if (!b_val)
 		return -EPERM;
 
-	if (vsi->type != ICE_VSI_PF)
+	if (!(vsi->type == ICE_VSI_PF || vsi->type == ICE_VSI_VF))
 		return -EPERM;
 
 	if (!test_bit(ICE_FLAG_FD_ENA, pf->flags))
@@ -517,6 +523,13 @@ static int ice_alloc_fd_res(struct ice_vsi *vsi)
 	/* each VSI gets same "best_effort" quota */
 	vsi->num_bfltr = b_val;
 
+	if (vsi->type == ICE_VSI_VF) {
+		vsi->num_gfltr = 0;
+
+		/* each VSI gets same "best_effort" quota */
+		vsi->num_bfltr = b_val;
+	}
+
 	return 0;
 }
 
@@ -856,7 +869,8 @@ static void ice_set_fd_vsi_ctx(struct ice_vsi_ctx *ctxt, struct ice_vsi *vsi)
 	u8 dflt_q_group, dflt_q_prio;
 	u16 dflt_q, report_q, val;
 
-	if (vsi->type != ICE_VSI_PF && vsi->type != ICE_VSI_CTRL)
+	if (vsi->type != ICE_VSI_PF && vsi->type != ICE_VSI_CTRL &&
+	    vsi->type != ICE_VSI_VF)
 		return;
 
 	val = ICE_AQ_VSI_PROP_FLOW_DIR_VALID;
@@ -1179,7 +1193,24 @@ static int ice_vsi_setup_vector_base(struct ice_vsi *vsi)
 
 	num_q_vectors = vsi->num_q_vectors;
 	/* reserve slots from OS requested IRQs */
-	base = ice_get_res(pf, pf->irq_tracker, num_q_vectors, vsi->idx);
+	if (vsi->type == ICE_VSI_CTRL && vsi->vf_id != ICE_INVAL_VFID) {
+		struct ice_vf *vf;
+		int i;
+
+		ice_for_each_vf(pf, i) {
+			vf = &pf->vf[i];
+			if (i != vsi->vf_id && vf->ctrl_vsi_idx != ICE_NO_VSI) {
+				base = pf->vsi[vf->ctrl_vsi_idx]->base_vector;
+				break;
+			}
+		}
+		if (i == pf->num_alloc_vfs)
+			base = ice_get_res(pf, pf->irq_tracker, num_q_vectors,
+					   ICE_RES_VF_CTRL_VEC_ID);
+	} else {
+		base = ice_get_res(pf, pf->irq_tracker, num_q_vectors,
+				   vsi->idx);
+	}
 
 	if (base < 0) {
 		dev_err(dev, "%d MSI-X interrupts available. %s %d failed to get %d MSI-X vectors\n",
@@ -2308,7 +2339,7 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 	struct ice_vsi *vsi;
 	int ret, i;
 
-	if (vsi_type == ICE_VSI_VF)
+	if (vsi_type == ICE_VSI_VF || vsi_type == ICE_VSI_CTRL)
 		vsi = ice_vsi_alloc(pf, vsi_type, vf_id);
 	else
 		vsi = ice_vsi_alloc(pf, vsi_type, ICE_INVAL_VFID);
@@ -2323,7 +2354,7 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 	if (vsi->type == ICE_VSI_PF)
 		vsi->ethtype = ETH_P_PAUSE;
 
-	if (vsi->type == ICE_VSI_VF)
+	if (vsi->type == ICE_VSI_VF || vsi->type == ICE_VSI_CTRL)
 		vsi->vf_id = vf_id;
 
 	ice_alloc_fd_res(vsi);
@@ -2770,7 +2801,24 @@ int ice_vsi_release(struct ice_vsi *vsi)
 	 * many interrupts each VF needs. SR-IOV MSIX resources are also
 	 * cleared in the same manner.
 	 */
-	if (vsi->type != ICE_VSI_VF) {
+	if (vsi->type == ICE_VSI_CTRL && vsi->vf_id != ICE_INVAL_VFID) {
+		struct ice_vf *vf;
+		int i;
+
+		ice_for_each_vf(pf, i) {
+			vf = &pf->vf[i];
+			if (i != vsi->vf_id && vf->ctrl_vsi_idx != ICE_NO_VSI)
+				break;
+		}
+		if (i == pf->num_alloc_vfs) {
+			/* No other VFs left that have control VSI, reclaim SW
+			 * interrupts back to the common pool
+			 */
+			ice_free_res(pf->irq_tracker, vsi->base_vector,
+				     ICE_RES_VF_CTRL_VEC_ID);
+			pf->num_avail_sw_msix += vsi->num_q_vectors;
+		}
+	} else if (vsi->type != ICE_VSI_VF) {
 		/* reclaim SW interrupts back to the common pool */
 		ice_free_res(pf->irq_tracker, vsi->base_vector, vsi->idx);
 		pf->num_avail_sw_msix += vsi->num_q_vectors;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 2c23c8f468a5..9cb5e653b38d 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2220,8 +2220,13 @@ static int ice_vsi_req_irq_msix(struct ice_vsi *vsi, char *basename)
 			/* skip this unused q_vector */
 			continue;
 		}
-		err = devm_request_irq(dev, irq_num, vsi->irq_handler, 0,
-				       q_vector->name, q_vector);
+		if (vsi->type == ICE_VSI_CTRL && vsi->vf_id != ICE_INVAL_VFID)
+			err = devm_request_irq(dev, irq_num, vsi->irq_handler,
+					       IRQF_SHARED, q_vector->name,
+					       q_vector);
+		else
+			err = devm_request_irq(dev, irq_num, vsi->irq_handler,
+					       0, q_vector->name, q_vector);
 		if (err) {
 			netdev_err(vsi->netdev, "MSIX request_irq failed, error: %d\n",
 				   err);
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 1f38a8d0c525..fa72b7e2e433 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -201,6 +201,25 @@ static void ice_vf_vsi_release(struct ice_vf *vf)
 	ice_vf_invalidate_vsi(vf);
 }
 
+/**
+ * ice_vf_ctrl_invalidate_vsi - invalidate ctrl_vsi_idx to remove VSI access
+ * @vf: VF that control VSI is being invalidated on
+ */
+static void ice_vf_ctrl_invalidate_vsi(struct ice_vf *vf)
+{
+	vf->ctrl_vsi_idx = ICE_NO_VSI;
+}
+
+/**
+ * ice_vf_ctrl_vsi_release - invalidate the VF's control VSI after freeing it
+ * @vf: VF that control VSI is being released on
+ */
+static void ice_vf_ctrl_vsi_release(struct ice_vf *vf)
+{
+	ice_vsi_release(vf->pf->vsi[vf->ctrl_vsi_idx]);
+	ice_vf_ctrl_invalidate_vsi(vf);
+}
+
 /**
  * ice_free_vf_res - Free a VF's resources
  * @vf: pointer to the VF info
@@ -214,6 +233,9 @@ static void ice_free_vf_res(struct ice_vf *vf)
 	 * accessing the VF's VSI after it's freed or invalidated.
 	 */
 	clear_bit(ICE_VF_STATE_INIT, vf->vf_states);
+	/* free VF control VSI */
+	if (vf->ctrl_vsi_idx != ICE_NO_VSI)
+		ice_vf_ctrl_vsi_release(vf);
 
 	/* free VSI and disconnect it from the parent uplink */
 	if (vf->lan_vsi_idx != ICE_NO_VSI) {
@@ -559,6 +581,28 @@ static struct ice_vsi *ice_vf_vsi_setup(struct ice_vf *vf)
 	return vsi;
 }
 
+/**
+ * ice_vf_ctrl_vsi_setup - Set up a VF control VSI
+ * @vf: VF to setup control VSI for
+ *
+ * Returns pointer to the successfully allocated VSI struct on success,
+ * otherwise returns NULL on failure.
+ */
+struct ice_vsi *ice_vf_ctrl_vsi_setup(struct ice_vf *vf)
+{
+	struct ice_port_info *pi = ice_vf_get_port_info(vf);
+	struct ice_pf *pf = vf->pf;
+	struct ice_vsi *vsi;
+
+	vsi = ice_vsi_setup(pf, pi, ICE_VSI_CTRL, vf->vf_id);
+	if (!vsi) {
+		dev_err(ice_pf_to_dev(pf), "Failed to create VF control VSI\n");
+		ice_vf_ctrl_invalidate_vsi(vf);
+	}
+
+	return vsi;
+}
+
 /**
  * ice_calc_vf_first_vector_idx - Calculate MSIX vector index in the PF space
  * @pf: pointer to PF structure
@@ -1256,6 +1300,12 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 	ice_for_each_vf(pf, v) {
 		vf = &pf->vf[v];
 
+		/* clean VF control VSI when resetting VFs since it should be
+		 * setup only when VF creates its first FDIR rule.
+		 */
+		if (vf->ctrl_vsi_idx != ICE_NO_VSI)
+			ice_vf_ctrl_invalidate_vsi(vf);
+
 		ice_vf_pre_vsi_rebuild(vf);
 		ice_vf_rebuild_vsi(vf);
 		ice_vf_post_vsi_rebuild(vf);
@@ -1374,6 +1424,12 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 			dev_err(dev, "disabling promiscuous mode failed\n");
 	}
 
+	/* clean VF control VSI when resetting VF since it should be setup
+	 * only when VF creates its first FDIR rule.
+	 */
+	if (vf->ctrl_vsi_idx != ICE_NO_VSI)
+		ice_vf_ctrl_vsi_release(vf);
+
 	ice_vf_pre_vsi_rebuild(vf);
 	ice_vf_rebuild_vsi_with_release(vf);
 	ice_vf_post_vsi_rebuild(vf);
@@ -1549,6 +1605,11 @@ static void ice_set_dflt_settings_vfs(struct ice_pf *pf)
 		set_bit(ICE_VIRTCHNL_VF_CAP_L2, &vf->vf_caps);
 		vf->spoofchk = true;
 		vf->num_vf_qs = pf->num_qps_per_vf;
+
+		/* ctrl_vsi_idx will be set to a valid value only when VF
+		 * creates its first fdir rule.
+		 */
+		ice_vf_ctrl_invalidate_vsi(vf);
 	}
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 0f519fba3770..faa879d744a1 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -70,6 +70,7 @@ struct ice_vf {
 
 	u16 vf_id;			/* VF ID in the PF space */
 	u16 lan_vsi_idx;		/* index into PF struct */
+	u16 ctrl_vsi_idx;
 	/* first vector index of this VF in the PF space */
 	int first_vector_idx;
 	struct ice_sw *vf_sw_id;	/* switch ID the VF VSIs connect to */
@@ -138,6 +139,7 @@ void
 ice_vf_lan_overflow_event(struct ice_pf *pf, struct ice_rq_event_info *event);
 void ice_print_vfs_mdd_events(struct ice_pf *pf);
 void ice_print_vf_rx_mdd_event(struct ice_vf *vf);
+struct ice_vsi *ice_vf_ctrl_vsi_setup(struct ice_vf *vf);
 #else /* CONFIG_PCI_IOV */
 #define ice_process_vflr_event(pf) do {} while (0)
 #define ice_free_vfs(pf) do {} while (0)
-- 
2.26.2

