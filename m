Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD6A5179C49
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 00:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388573AbgCDXVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 18:21:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:48332 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388560AbgCDXVk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 18:21:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 15:21:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,515,1574150400"; 
   d="scan'208";a="244094619"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga006.jf.intel.com with ESMTP; 04 Mar 2020 15:21:37 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 04/16] ice: Improve clarity of prints and variables
Date:   Wed,  4 Mar 2020 15:21:24 -0800
Message-Id: <20200304232136.4172118-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304232136.4172118-1-jeffrey.t.kirsher@intel.com>
References: <20200304232136.4172118-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently when the device runs out of MSI-X interrupts a cryptic and
unhelpful message is printed. This will cause confusion when hitting this
case. Fix this by clearing up the error message for both SR-IOV and non
SR-IOV use cases.

Also, make a few minor changes to increase clarity of variables.
1. Change per VF MSI-X and queue pair variables in the PF structure.
2. Use ICE_NONQ_VECS_VF when determining pf->num_msix_per_vf instead of
the magic number "1". This vector is reserved for the OICR.

All of the resource tracking functions were moved to avoid adding
any forward declaration function prototypes.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |   4 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      | 200 ++++++++++--------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  66 +++---
 3 files changed, 145 insertions(+), 125 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index fac8c14ecc55..aed3ff31e064 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -362,8 +362,8 @@ struct ice_pf {
 	struct ice_vf *vf;
 	int num_alloc_vfs;		/* actual number of VFs allocated */
 	u16 num_vfs_supported;		/* num VFs supported for this PF */
-	u16 num_vf_qps;			/* num queue pairs per VF */
-	u16 num_vf_msix;		/* num vectors per VF */
+	u16 num_qps_per_vf;
+	u16 num_msix_per_vf;
 	/* used to ratelimit the MDD event logging */
 	unsigned long last_printed_mdd_jiffies;
 	DECLARE_BITMAP(state, __ICE_STATE_NBITS);
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 16ec7483dcc0..9230abdb4ee8 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -178,12 +178,12 @@ static void ice_vsi_set_num_qs(struct ice_vsi *vsi, u16 vf_id)
 		vf = &pf->vf[vsi->vf_id];
 		vsi->alloc_txq = vf->num_vf_qs;
 		vsi->alloc_rxq = vf->num_vf_qs;
-		/* pf->num_vf_msix includes (VF miscellaneous vector +
+		/* pf->num_msix_per_vf includes (VF miscellaneous vector +
 		 * data queue interrupts). Since vsi->num_q_vectors is number
 		 * of queues vectors, subtract 1 (ICE_NONQ_VECS_VF) from the
 		 * original vector count
 		 */
-		vsi->num_q_vectors = pf->num_vf_msix - ICE_NONQ_VECS_VF;
+		vsi->num_q_vectors = pf->num_msix_per_vf - ICE_NONQ_VECS_VF;
 		break;
 	case ICE_VSI_LB:
 		vsi->alloc_txq = 1;
@@ -906,6 +906,109 @@ static int ice_vsi_init(struct ice_vsi *vsi, bool init_vsi)
 	return ret;
 }
 
+/**
+ * ice_free_res - free a block of resources
+ * @res: pointer to the resource
+ * @index: starting index previously returned by ice_get_res
+ * @id: identifier to track owner
+ *
+ * Returns number of resources freed
+ */
+int ice_free_res(struct ice_res_tracker *res, u16 index, u16 id)
+{
+	int count = 0;
+	int i;
+
+	if (!res || index >= res->end)
+		return -EINVAL;
+
+	id |= ICE_RES_VALID_BIT;
+	for (i = index; i < res->end && res->list[i] == id; i++) {
+		res->list[i] = 0;
+		count++;
+	}
+
+	return count;
+}
+
+/**
+ * ice_search_res - Search the tracker for a block of resources
+ * @res: pointer to the resource
+ * @needed: size of the block needed
+ * @id: identifier to track owner
+ *
+ * Returns the base item index of the block, or -ENOMEM for error
+ */
+static int ice_search_res(struct ice_res_tracker *res, u16 needed, u16 id)
+{
+	int start = 0, end = 0;
+
+	if (needed > res->end)
+		return -ENOMEM;
+
+	id |= ICE_RES_VALID_BIT;
+
+	do {
+		/* skip already allocated entries */
+		if (res->list[end++] & ICE_RES_VALID_BIT) {
+			start = end;
+			if ((start + needed) > res->end)
+				break;
+		}
+
+		if (end == (start + needed)) {
+			int i = start;
+
+			/* there was enough, so assign it to the requestor */
+			while (i != end)
+				res->list[i++] = id;
+
+			return start;
+		}
+	} while (end < res->end);
+
+	return -ENOMEM;
+}
+
+/**
+ * ice_get_free_res_count - Get free count from a resource tracker
+ * @res: Resource tracker instance
+ */
+static u16 ice_get_free_res_count(struct ice_res_tracker *res)
+{
+	u16 i, count = 0;
+
+	for (i = 0; i < res->end; i++)
+		if (!(res->list[i] & ICE_RES_VALID_BIT))
+			count++;
+
+	return count;
+}
+
+/**
+ * ice_get_res - get a block of resources
+ * @pf: board private structure
+ * @res: pointer to the resource
+ * @needed: size of the block needed
+ * @id: identifier to track owner
+ *
+ * Returns the base item index of the block, or negative for error
+ */
+int
+ice_get_res(struct ice_pf *pf, struct ice_res_tracker *res, u16 needed, u16 id)
+{
+	if (!res || !pf)
+		return -EINVAL;
+
+	if (!needed || needed > res->num_entries || id >= ICE_RES_VALID_BIT) {
+		dev_err(ice_pf_to_dev(pf), "param err: needed=%d, num_entries = %d id=0x%04x\n",
+			needed, res->num_entries, id);
+		return -EINVAL;
+	}
+
+	return ice_search_res(res, needed, id);
+}
+
 /**
  * ice_vsi_setup_vector_base - Set up the base vector for the given VSI
  * @vsi: ptr to the VSI
@@ -938,8 +1041,9 @@ static int ice_vsi_setup_vector_base(struct ice_vsi *vsi)
 	vsi->base_vector = ice_get_res(pf, pf->irq_tracker, num_q_vectors,
 				       vsi->idx);
 	if (vsi->base_vector < 0) {
-		dev_err(dev, "Failed to get tracking for %d vectors for VSI %d, err=%d\n",
-			num_q_vectors, vsi->vsi_num, vsi->base_vector);
+		dev_err(dev, "%d MSI-X interrupts available. %s %d failed to get %d MSI-X vectors\n",
+			ice_get_free_res_count(pf->irq_tracker),
+			ice_vsi_type_str(vsi->type), vsi->idx, num_q_vectors);
 		return -ENOENT;
 	}
 	pf->num_avail_sw_msix -= num_q_vectors;
@@ -2345,94 +2449,6 @@ void ice_dis_vsi(struct ice_vsi *vsi, bool locked)
 	}
 }
 
-/**
- * ice_free_res - free a block of resources
- * @res: pointer to the resource
- * @index: starting index previously returned by ice_get_res
- * @id: identifier to track owner
- *
- * Returns number of resources freed
- */
-int ice_free_res(struct ice_res_tracker *res, u16 index, u16 id)
-{
-	int count = 0;
-	int i;
-
-	if (!res || index >= res->end)
-		return -EINVAL;
-
-	id |= ICE_RES_VALID_BIT;
-	for (i = index; i < res->end && res->list[i] == id; i++) {
-		res->list[i] = 0;
-		count++;
-	}
-
-	return count;
-}
-
-/**
- * ice_search_res - Search the tracker for a block of resources
- * @res: pointer to the resource
- * @needed: size of the block needed
- * @id: identifier to track owner
- *
- * Returns the base item index of the block, or -ENOMEM for error
- */
-static int ice_search_res(struct ice_res_tracker *res, u16 needed, u16 id)
-{
-	int start = 0, end = 0;
-
-	if (needed > res->end)
-		return -ENOMEM;
-
-	id |= ICE_RES_VALID_BIT;
-
-	do {
-		/* skip already allocated entries */
-		if (res->list[end++] & ICE_RES_VALID_BIT) {
-			start = end;
-			if ((start + needed) > res->end)
-				break;
-		}
-
-		if (end == (start + needed)) {
-			int i = start;
-
-			/* there was enough, so assign it to the requestor */
-			while (i != end)
-				res->list[i++] = id;
-
-			return start;
-		}
-	} while (end < res->end);
-
-	return -ENOMEM;
-}
-
-/**
- * ice_get_res - get a block of resources
- * @pf: board private structure
- * @res: pointer to the resource
- * @needed: size of the block needed
- * @id: identifier to track owner
- *
- * Returns the base item index of the block, or negative for error
- */
-int
-ice_get_res(struct ice_pf *pf, struct ice_res_tracker *res, u16 needed, u16 id)
-{
-	if (!res || !pf)
-		return -EINVAL;
-
-	if (!needed || needed > res->num_entries || id >= ICE_RES_VALID_BIT) {
-		dev_err(ice_pf_to_dev(pf), "param err: needed=%d, num_entries = %d id=0x%04x\n",
-			needed, res->num_entries, id);
-		return -EINVAL;
-	}
-
-	return ice_search_res(res, needed, id);
-}
-
 /**
  * ice_vsi_dis_irq - Mask off queue interrupt generation on the VSI
  * @vsi: the VSI being un-configured
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index e6426f38db0b..e0277b49439f 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -170,7 +170,7 @@ static void ice_free_vf_res(struct ice_vf *vf)
 		vf->num_mac = 0;
 	}
 
-	last_vector_idx = vf->first_vector_idx + pf->num_vf_msix - 1;
+	last_vector_idx = vf->first_vector_idx + pf->num_msix_per_vf - 1;
 
 	/* clear VF MDD event information */
 	memset(&vf->mdd_tx_events, 0, sizeof(vf->mdd_tx_events));
@@ -206,7 +206,7 @@ static void ice_dis_vf_mappings(struct ice_vf *vf)
 	wr32(hw, VPINT_ALLOC_PCI(vf->vf_id), 0);
 
 	first = vf->first_vector_idx;
-	last = first + pf->num_vf_msix - 1;
+	last = first + pf->num_msix_per_vf - 1;
 	for (v = first; v <= last; v++) {
 		u32 reg;
 
@@ -315,7 +315,7 @@ void ice_free_vfs(struct ice_pf *pf)
 		dev_warn(dev, "VFs are assigned - not disabling SR-IOV\n");
 
 	tmp = pf->num_alloc_vfs;
-	pf->num_vf_qps = 0;
+	pf->num_qps_per_vf = 0;
 	pf->num_alloc_vfs = 0;
 	for (i = 0; i < tmp; i++) {
 		if (test_bit(ICE_VF_STATE_INIT, pf->vf[i].vf_states)) {
@@ -503,7 +503,7 @@ ice_vf_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi, u16 vf_id)
  */
 static int ice_calc_vf_first_vector_idx(struct ice_pf *pf, struct ice_vf *vf)
 {
-	return pf->sriov_base_vector + vf->vf_id * pf->num_vf_msix;
+	return pf->sriov_base_vector + vf->vf_id * pf->num_msix_per_vf;
 }
 
 /**
@@ -596,7 +596,7 @@ static int ice_alloc_vf_res(struct ice_vf *vf)
 	 */
 	tx_rx_queue_left = min_t(int, ice_get_avail_txq_count(pf),
 				 ice_get_avail_rxq_count(pf));
-	tx_rx_queue_left += pf->num_vf_qps;
+	tx_rx_queue_left += pf->num_qps_per_vf;
 	if (vf->num_req_qs && vf->num_req_qs <= tx_rx_queue_left &&
 	    vf->num_req_qs != vf->num_vf_qs)
 		vf->num_vf_qs = vf->num_req_qs;
@@ -642,9 +642,9 @@ static void ice_ena_vf_mappings(struct ice_vf *vf)
 	hw = &pf->hw;
 	vsi = pf->vsi[vf->lan_vsi_idx];
 	first = vf->first_vector_idx;
-	last = (first + pf->num_vf_msix) - 1;
+	last = (first + pf->num_msix_per_vf) - 1;
 	abs_first = first + pf->hw.func_caps.common_cap.msix_vector_first_id;
-	abs_last = (abs_first + pf->num_vf_msix) - 1;
+	abs_last = (abs_first + pf->num_msix_per_vf) - 1;
 	abs_vf_id = vf->vf_id + hw->func_caps.vf_base_id;
 
 	/* VF Vector allocation */
@@ -762,7 +762,7 @@ int ice_calc_vf_reg_idx(struct ice_vf *vf, struct ice_q_vector *q_vector)
 	pf = vf->pf;
 
 	/* always add one to account for the OICR being the first MSIX */
-	return pf->sriov_base_vector + pf->num_vf_msix * vf->vf_id +
+	return pf->sriov_base_vector + pf->num_msix_per_vf * vf->vf_id +
 		q_vector->v_idx + 1;
 }
 
@@ -847,56 +847,60 @@ static int ice_sriov_set_msix_res(struct ice_pf *pf, u16 num_msix_needed)
 static int ice_set_per_vf_res(struct ice_pf *pf)
 {
 	int max_valid_res_idx = ice_get_max_valid_res_idx(pf->irq_tracker);
+	int msix_avail_per_vf, msix_avail_for_sriov;
 	struct device *dev = ice_pf_to_dev(pf);
-	u16 num_msix, num_txq, num_rxq;
-	int v;
+	u16 num_msix_per_vf, num_txq, num_rxq;
 
 	if (!pf->num_alloc_vfs || max_valid_res_idx < 0)
 		return -EINVAL;
 
 	/* determine MSI-X resources per VF */
-	v = (pf->hw.func_caps.common_cap.num_msix_vectors -
-	     pf->irq_tracker->num_entries) / pf->num_alloc_vfs;
-	if (v >= ICE_NUM_VF_MSIX_MED) {
-		num_msix = ICE_NUM_VF_MSIX_MED;
-	} else if (v >= ICE_NUM_VF_MSIX_SMALL) {
-		num_msix = ICE_NUM_VF_MSIX_SMALL;
-	} else if (v >= ICE_MIN_INTR_PER_VF) {
-		num_msix = ICE_MIN_INTR_PER_VF;
+	msix_avail_for_sriov = pf->hw.func_caps.common_cap.num_msix_vectors -
+		pf->irq_tracker->num_entries;
+	msix_avail_per_vf = msix_avail_for_sriov / pf->num_alloc_vfs;
+	if (msix_avail_per_vf >= ICE_NUM_VF_MSIX_MED) {
+		num_msix_per_vf = ICE_NUM_VF_MSIX_MED;
+	} else if (msix_avail_per_vf >= ICE_NUM_VF_MSIX_SMALL) {
+		num_msix_per_vf = ICE_NUM_VF_MSIX_SMALL;
+	} else if (msix_avail_per_vf >= ICE_MIN_INTR_PER_VF) {
+		num_msix_per_vf = ICE_MIN_INTR_PER_VF;
 	} else {
-		dev_err(dev, "Not enough vectors to support %d VFs\n",
+		dev_err(dev, "Only %d MSI-X interrupts available for SR-IOV. Not enough to support minimum of %d MSI-X interrupts per VF for %d VFs\n",
+			msix_avail_for_sriov, ICE_MIN_INTR_PER_VF,
 			pf->num_alloc_vfs);
 		return -EIO;
 	}
 
 	/* determine queue resources per VF */
 	num_txq = ice_determine_res(pf, ice_get_avail_txq_count(pf),
-				    min_t(u16, num_msix - 1,
+				    min_t(u16,
+					  num_msix_per_vf - ICE_NONQ_VECS_VF,
 					  ICE_MAX_RSS_QS_PER_VF),
 				    ICE_MIN_QS_PER_VF);
 
 	num_rxq = ice_determine_res(pf, ice_get_avail_rxq_count(pf),
-				    min_t(u16, num_msix - 1,
+				    min_t(u16,
+					  num_msix_per_vf - ICE_NONQ_VECS_VF,
 					  ICE_MAX_RSS_QS_PER_VF),
 				    ICE_MIN_QS_PER_VF);
 
 	if (!num_txq || !num_rxq) {
-		dev_err(dev, "Not enough queues to support %d VFs\n",
-			pf->num_alloc_vfs);
+		dev_err(dev, "Not enough queues to support minimum of %d queue pairs per VF for %d VFs\n",
+			ICE_MIN_QS_PER_VF, pf->num_alloc_vfs);
 		return -EIO;
 	}
 
-	if (ice_sriov_set_msix_res(pf, num_msix * pf->num_alloc_vfs)) {
+	if (ice_sriov_set_msix_res(pf, num_msix_per_vf * pf->num_alloc_vfs)) {
 		dev_err(dev, "Unable to set MSI-X resources for %d VFs\n",
 			pf->num_alloc_vfs);
 		return -EINVAL;
 	}
 
 	/* only allow equal Tx/Rx queue count (i.e. queue pairs) */
-	pf->num_vf_qps = min_t(int, num_txq, num_rxq);
-	pf->num_vf_msix = num_msix;
+	pf->num_qps_per_vf = min_t(int, num_txq, num_rxq);
+	pf->num_msix_per_vf = num_msix_per_vf;
 	dev_info(dev, "Enabling %d VFs with %d vectors and %d queues per VF\n",
-		 pf->num_alloc_vfs, num_msix, pf->num_vf_qps);
+		 pf->num_alloc_vfs, pf->num_msix_per_vf, pf->num_qps_per_vf);
 
 	return 0;
 }
@@ -1018,7 +1022,7 @@ static bool ice_config_res_vfs(struct ice_pf *pf)
 	ice_for_each_vf(pf, v) {
 		struct ice_vf *vf = &pf->vf[v];
 
-		vf->num_vf_qs = pf->num_vf_qps;
+		vf->num_vf_qs = pf->num_qps_per_vf;
 		dev_dbg(dev, "VF-id %d has %d queues configured\n", vf->vf_id,
 			vf->num_vf_qs);
 		ice_cleanup_and_realloc_vf(vf);
@@ -1727,7 +1731,7 @@ static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
 	vfres->num_vsis = 1;
 	/* Tx and Rx queue are equal for VF */
 	vfres->num_queue_pairs = vsi->num_txq;
-	vfres->max_vectors = pf->num_vf_msix;
+	vfres->max_vectors = pf->num_msix_per_vf;
 	vfres->rss_key_size = ICE_VSIQF_HKEY_ARRAY_SIZE;
 	vfres->rss_lut_size = ICE_VSIQF_HLUT_ARRAY_SIZE;
 
@@ -2387,7 +2391,7 @@ static int ice_vc_cfg_irq_map_msg(struct ice_vf *vf, u8 *msg)
 	 * there is actually at least a single VF queue vector mapped
 	 */
 	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states) ||
-	    pf->num_vf_msix < num_q_vectors_mapped ||
+	    pf->num_msix_per_vf < num_q_vectors_mapped ||
 	    !num_q_vectors_mapped) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
@@ -2409,7 +2413,7 @@ static int ice_vc_cfg_irq_map_msg(struct ice_vf *vf, u8 *msg)
 		/* vector_id is always 0-based for each VF, and can never be
 		 * larger than or equal to the max allowed interrupts per VF
 		 */
-		if (!(vector_id < pf->num_vf_msix) ||
+		if (!(vector_id < pf->num_msix_per_vf) ||
 		    !ice_vc_isvalid_vsi_id(vf, vsi_id) ||
 		    (!vector_id && (map->rxq_map || map->txq_map))) {
 			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-- 
2.24.1

