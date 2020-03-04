Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5425F179C51
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 00:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388643AbgCDXWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 18:22:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:48332 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388548AbgCDXVk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 18:21:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 15:21:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,515,1574150400"; 
   d="scan'208";a="244094615"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga006.jf.intel.com with ESMTP; 04 Mar 2020 15:21:37 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Mitch Williams <mitch.a.williams@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Brett Creeley <brett.creeley@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 03/16] ice: allow bigger VFs
Date:   Wed,  4 Mar 2020 15:21:23 -0800
Message-Id: <20200304232136.4172118-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304232136.4172118-1-jeffrey.t.kirsher@intel.com>
References: <20200304232136.4172118-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mitch Williams <mitch.a.williams@intel.com>

Unlike the XL710 series, 800-series hardware can allocate more than 4
MSI-X vectors per VF. This patch enables that functionality. We
dynamically allocate vectors and queues depending on how many VFs are
enabled. Allocating the maximum number of VFs replicates XL710
behavior with 4 queues and 4 vectors. But allocating a smaller number
of VFs will give you 16 queues and 16 vectors.

Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |   1 -
 drivers/net/ethernet/intel/ice/ice_lib.c      |   9 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 279 +++++++++---------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  15 +-
 4 files changed, 146 insertions(+), 158 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 2d51ceaa2c8c..fac8c14ecc55 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -70,7 +70,6 @@ extern const char ice_drv_ver[];
 #define ICE_Q_WAIT_RETRY_LIMIT	10
 #define ICE_Q_WAIT_MAX_RETRY	(5 * ICE_Q_WAIT_RETRY_LIMIT)
 #define ICE_MAX_LG_RSS_QS	256
-#define ICE_MAX_SMALL_RSS_QS	8
 #define ICE_RES_VALID_BIT	0x8000
 #define ICE_RES_MISC_VEC_ID	(ICE_RES_VALID_BIT - 1)
 #define ICE_INVAL_Q_INDEX	0xffff
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index ff72a6d1c978..16ec7483dcc0 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -571,12 +571,11 @@ static void ice_vsi_set_rss_params(struct ice_vsi *vsi)
 		vsi->rss_lut_type = ICE_AQC_GSET_RSS_LUT_TABLE_TYPE_PF;
 		break;
 	case ICE_VSI_VF:
-		/* VF VSI will gets a small RSS table
-		 * For VSI_LUT, LUT size should be set to 64 bytes
+		/* VF VSI will get a small RSS table.
+		 * For VSI_LUT, LUT size should be set to 64 bytes.
 		 */
 		vsi->rss_table_size = ICE_VSIQF_HLUT_ARRAY_SIZE;
-		vsi->rss_size = min_t(int, num_online_cpus(),
-				      BIT(cap->rss_table_entry_width));
+		vsi->rss_size = ICE_MAX_RSS_QS_PER_VF;
 		vsi->rss_lut_type = ICE_AQC_GSET_RSS_LUT_TABLE_TYPE_VSI;
 		break;
 	case ICE_VSI_LB:
@@ -684,7 +683,7 @@ static void ice_vsi_setup_q_map(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt)
 			if (vsi->type == ICE_VSI_PF)
 				max_rss = ICE_MAX_LG_RSS_QS;
 			else
-				max_rss = ICE_MAX_SMALL_RSS_QS;
+				max_rss = ICE_MAX_RSS_QS_PER_VF;
 			qcount_rx = min_t(int, rx_numq_tc, max_rss);
 			if (!vsi->req_rxq)
 				qcount_rx = min_t(int, qcount_rx,
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 6bedfa4676ae..e6426f38db0b 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -99,8 +99,8 @@ ice_set_pfe_link(struct ice_vf *vf, struct virtchnl_pf_event *pfe,
  */
 static bool ice_vf_has_no_qs_ena(struct ice_vf *vf)
 {
-	return (!bitmap_weight(vf->rxq_ena, ICE_MAX_BASE_QS_PER_VF) &&
-		!bitmap_weight(vf->txq_ena, ICE_MAX_BASE_QS_PER_VF));
+	return (!bitmap_weight(vf->rxq_ena, ICE_MAX_RSS_QS_PER_VF) &&
+		!bitmap_weight(vf->txq_ena, ICE_MAX_RSS_QS_PER_VF));
 }
 
 /**
@@ -232,11 +232,7 @@ static void ice_dis_vf_mappings(struct ice_vf *vf)
  * ice_sriov_free_msix_res - Reset/free any used MSIX resources
  * @pf: pointer to the PF structure
  *
- * If MSIX entries from the pf->irq_tracker were needed then we need to
- * reset the irq_tracker->end and give back the entries we needed to
- * num_avail_sw_msix.
- *
- * If no MSIX entries were taken from the pf->irq_tracker then just clear
+ * Since no MSIX entries are taken from the pf->irq_tracker then just clear
  * the pf->sriov_base_vector.
  *
  * Returns 0 on success, and -EINVAL on error.
@@ -253,11 +249,7 @@ static int ice_sriov_free_msix_res(struct ice_pf *pf)
 		return -EINVAL;
 
 	/* give back irq_tracker resources used */
-	if (pf->sriov_base_vector < res->num_entries) {
-		res->end = res->num_entries;
-		pf->num_avail_sw_msix +=
-			res->num_entries - pf->sriov_base_vector;
-	}
+	WARN_ON(pf->sriov_base_vector < res->num_entries);
 
 	pf->sriov_base_vector = 0;
 
@@ -271,8 +263,8 @@ static int ice_sriov_free_msix_res(struct ice_pf *pf)
 void ice_set_vf_state_qs_dis(struct ice_vf *vf)
 {
 	/* Clear Rx/Tx enabled queues flag */
-	bitmap_zero(vf->txq_ena, ICE_MAX_BASE_QS_PER_VF);
-	bitmap_zero(vf->rxq_ena, ICE_MAX_BASE_QS_PER_VF);
+	bitmap_zero(vf->txq_ena, ICE_MAX_RSS_QS_PER_VF);
+	bitmap_zero(vf->rxq_ena, ICE_MAX_RSS_QS_PER_VF);
 	clear_bit(ICE_VF_STATE_QS_ENA, vf->vf_states);
 }
 
@@ -604,7 +596,7 @@ static int ice_alloc_vf_res(struct ice_vf *vf)
 	 */
 	tx_rx_queue_left = min_t(int, ice_get_avail_txq_count(pf),
 				 ice_get_avail_rxq_count(pf));
-	tx_rx_queue_left += ICE_DFLT_QS_PER_VF;
+	tx_rx_queue_left += pf->num_vf_qps;
 	if (vf->num_req_qs && vf->num_req_qs <= tx_rx_queue_left &&
 	    vf->num_req_qs != vf->num_vf_qs)
 		vf->num_vf_qs = vf->num_req_qs;
@@ -803,127 +795,108 @@ static int ice_get_max_valid_res_idx(struct ice_res_tracker *res)
  * @num_msix_needed: number of MSIX vectors needed for all SR-IOV VFs
  *
  * This function allows SR-IOV resources to be taken from the end of the PF's
- * allowed HW MSIX vectors so in many cases the irq_tracker will not
- * be needed. In these cases we just set the pf->sriov_base_vector and return
- * success.
+ * allowed HW MSIX vectors so that the irq_tracker will not be affected. We
+ * just set the pf->sriov_base_vector and return success.
  *
- * If SR-IOV needs to use any pf->irq_tracker entries it updates the
- * irq_tracker->end based on the first entry needed for SR-IOV. This makes it
- * so any calls to ice_get_res() using the irq_tracker will not try to use
- * resources at or beyond the newly set value.
+ * If there are not enough resources available, return an error. This should
+ * always be caught by ice_set_per_vf_res().
  *
  * Return 0 on success, and -EINVAL when there are not enough MSIX vectors in
  * in the PF's space available for SR-IOV.
  */
 static int ice_sriov_set_msix_res(struct ice_pf *pf, u16 num_msix_needed)
 {
-	int max_valid_res_idx = ice_get_max_valid_res_idx(pf->irq_tracker);
-	u16 pf_total_msix_vectors =
-		pf->hw.func_caps.common_cap.num_msix_vectors;
-	struct ice_res_tracker *res = pf->irq_tracker;
+	u16 total_vectors = pf->hw.func_caps.common_cap.num_msix_vectors;
+	int vectors_used = pf->irq_tracker->num_entries;
 	int sriov_base_vector;
 
-	if (max_valid_res_idx < 0)
-		return max_valid_res_idx;
-
-	sriov_base_vector = pf_total_msix_vectors - num_msix_needed;
+	sriov_base_vector = total_vectors - num_msix_needed;
 
 	/* make sure we only grab irq_tracker entries from the list end and
 	 * that we have enough available MSIX vectors
 	 */
-	if (sriov_base_vector <= max_valid_res_idx)
+	if (sriov_base_vector < vectors_used)
 		return -EINVAL;
 
 	pf->sriov_base_vector = sriov_base_vector;
 
-	/* dip into irq_tracker entries and update used resources */
-	if (num_msix_needed > (pf_total_msix_vectors - res->num_entries)) {
-		pf->num_avail_sw_msix -=
-			res->num_entries - pf->sriov_base_vector;
-		res->end = pf->sriov_base_vector;
-	}
-
 	return 0;
 }
 
 /**
- * ice_check_avail_res - check if vectors and queues are available
+ * ice_set_per_vf_res - check if vectors and queues are available
  * @pf: pointer to the PF structure
  *
- * This function is where we calculate actual number of resources for VF VSIs,
- * we don't reserve ahead of time during probe. Returns success if vectors and
- * queues resources are available, otherwise returns error code
+ * First, determine HW interrupts from common pool. If we allocate fewer VFs, we
+ * get more vectors and can enable more queues per VF. Note that this does not
+ * grab any vectors from the SW pool already allocated. Also note, that all
+ * vector counts include one for each VF's miscellaneous interrupt vector
+ * (i.e. OICR).
+ *
+ * Minimum VFs - 2 vectors, 1 queue pair
+ * Small VFs - 5 vectors, 4 queue pairs
+ * Medium VFs - 17 vectors, 16 queue pairs
+ *
+ * Second, determine number of queue pairs per VF by starting with a pre-defined
+ * maximum each VF supports. If this is not possible, then we adjust based on
+ * queue pairs available on the device.
+ *
+ * Lastly, set queue and MSI-X VF variables tracked by the PF so it can be used
+ * by each VF during VF initialization and reset.
  */
-static int ice_check_avail_res(struct ice_pf *pf)
+static int ice_set_per_vf_res(struct ice_pf *pf)
 {
 	int max_valid_res_idx = ice_get_max_valid_res_idx(pf->irq_tracker);
-	u16 num_msix, num_txq, num_rxq, num_avail_msix;
 	struct device *dev = ice_pf_to_dev(pf);
+	u16 num_msix, num_txq, num_rxq;
+	int v;
 
 	if (!pf->num_alloc_vfs || max_valid_res_idx < 0)
 		return -EINVAL;
 
-	/* add 1 to max_valid_res_idx to account for it being 0-based */
-	num_avail_msix = pf->hw.func_caps.common_cap.num_msix_vectors -
-		(max_valid_res_idx + 1);
-
-	/* Grab from HW interrupts common pool
-	 * Note: By the time the user decides it needs more vectors in a VF
-	 * its already too late since one must decide this prior to creating the
-	 * VF interface. So the best we can do is take a guess as to what the
-	 * user might want.
-	 *
-	 * We have two policies for vector allocation:
-	 * 1. if num_alloc_vfs is from 1 to 16, then we consider this as small
-	 * number of NFV VFs used for NFV appliances, since this is a special
-	 * case, we try to assign maximum vectors per VF (65) as much as
-	 * possible, based on determine_resources algorithm.
-	 * 2. if num_alloc_vfs is from 17 to 256, then its large number of
-	 * regular VFs which are not used for any special purpose. Hence try to
-	 * grab default interrupt vectors (5 as supported by AVF driver).
-	 */
-	if (pf->num_alloc_vfs <= 16) {
-		num_msix = ice_determine_res(pf, num_avail_msix,
-					     ICE_MAX_INTR_PER_VF,
-					     ICE_MIN_INTR_PER_VF);
-	} else if (pf->num_alloc_vfs <= ICE_MAX_VF_COUNT) {
-		num_msix = ice_determine_res(pf, num_avail_msix,
-					     ICE_DFLT_INTR_PER_VF,
-					     ICE_MIN_INTR_PER_VF);
+	/* determine MSI-X resources per VF */
+	v = (pf->hw.func_caps.common_cap.num_msix_vectors -
+	     pf->irq_tracker->num_entries) / pf->num_alloc_vfs;
+	if (v >= ICE_NUM_VF_MSIX_MED) {
+		num_msix = ICE_NUM_VF_MSIX_MED;
+	} else if (v >= ICE_NUM_VF_MSIX_SMALL) {
+		num_msix = ICE_NUM_VF_MSIX_SMALL;
+	} else if (v >= ICE_MIN_INTR_PER_VF) {
+		num_msix = ICE_MIN_INTR_PER_VF;
 	} else {
-		dev_err(dev, "Number of VFs %d exceeds max VF count %d\n",
-			pf->num_alloc_vfs, ICE_MAX_VF_COUNT);
+		dev_err(dev, "Not enough vectors to support %d VFs\n",
+			pf->num_alloc_vfs);
 		return -EIO;
 	}
 
-	if (!num_msix)
-		return -EIO;
-
-	/* Grab from the common pool
-	 * start by requesting Default queues (4 as supported by AVF driver),
-	 * Note that, the main difference between queues and vectors is, latter
-	 * can only be reserved at init time but queues can be requested by VF
-	 * at runtime through Virtchnl, that is the reason we start by reserving
-	 * few queues.
-	 */
+	/* determine queue resources per VF */
 	num_txq = ice_determine_res(pf, ice_get_avail_txq_count(pf),
-				    ICE_DFLT_QS_PER_VF, ICE_MIN_QS_PER_VF);
+				    min_t(u16, num_msix - 1,
+					  ICE_MAX_RSS_QS_PER_VF),
+				    ICE_MIN_QS_PER_VF);
 
 	num_rxq = ice_determine_res(pf, ice_get_avail_rxq_count(pf),
-				    ICE_DFLT_QS_PER_VF, ICE_MIN_QS_PER_VF);
+				    min_t(u16, num_msix - 1,
+					  ICE_MAX_RSS_QS_PER_VF),
+				    ICE_MIN_QS_PER_VF);
 
-	if (!num_txq || !num_rxq)
+	if (!num_txq || !num_rxq) {
+		dev_err(dev, "Not enough queues to support %d VFs\n",
+			pf->num_alloc_vfs);
 		return -EIO;
+	}
 
-	if (ice_sriov_set_msix_res(pf, num_msix * pf->num_alloc_vfs))
+	if (ice_sriov_set_msix_res(pf, num_msix * pf->num_alloc_vfs)) {
+		dev_err(dev, "Unable to set MSI-X resources for %d VFs\n",
+			pf->num_alloc_vfs);
 		return -EINVAL;
+	}
 
-	/* since AVF driver works with only queue pairs which means, it expects
-	 * to have equal number of Rx and Tx queues, so take the minimum of
-	 * available Tx or Rx queues
-	 */
+	/* only allow equal Tx/Rx queue count (i.e. queue pairs) */
 	pf->num_vf_qps = min_t(int, num_txq, num_rxq);
 	pf->num_vf_msix = num_msix;
+	dev_info(dev, "Enabling %d VFs with %d vectors and %d queues per VF\n",
+		 pf->num_alloc_vfs, num_msix, pf->num_vf_qps);
 
 	return 0;
 }
@@ -1032,7 +1005,7 @@ static bool ice_config_res_vfs(struct ice_pf *pf)
 	struct ice_hw *hw = &pf->hw;
 	int v;
 
-	if (ice_check_avail_res(pf)) {
+	if (ice_set_per_vf_res(pf)) {
 		dev_err(dev, "Cannot allocate VF resources, try with fewer number of VFs\n");
 		return false;
 	}
@@ -2126,8 +2099,8 @@ static int ice_vc_get_stats_msg(struct ice_vf *vf, u8 *msg)
 static bool ice_vc_validate_vqs_bitmaps(struct virtchnl_queue_select *vqs)
 {
 	if ((!vqs->rx_queues && !vqs->tx_queues) ||
-	    vqs->rx_queues >= BIT(ICE_MAX_BASE_QS_PER_VF) ||
-	    vqs->tx_queues >= BIT(ICE_MAX_BASE_QS_PER_VF))
+	    vqs->rx_queues >= BIT(ICE_MAX_RSS_QS_PER_VF) ||
+	    vqs->tx_queues >= BIT(ICE_MAX_RSS_QS_PER_VF))
 		return false;
 
 	return true;
@@ -2176,7 +2149,7 @@ static int ice_vc_ena_qs_msg(struct ice_vf *vf, u8 *msg)
 	 * programmed using ice_vsi_cfg_txqs
 	 */
 	q_map = vqs->rx_queues;
-	for_each_set_bit(vf_q_id, &q_map, ICE_MAX_BASE_QS_PER_VF) {
+	for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF) {
 		if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
 			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 			goto error_param;
@@ -2198,7 +2171,7 @@ static int ice_vc_ena_qs_msg(struct ice_vf *vf, u8 *msg)
 
 	vsi = pf->vsi[vf->lan_vsi_idx];
 	q_map = vqs->tx_queues;
-	for_each_set_bit(vf_q_id, &q_map, ICE_MAX_BASE_QS_PER_VF) {
+	for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF) {
 		if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
 			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 			goto error_param;
@@ -2255,12 +2228,6 @@ static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
 		goto error_param;
 	}
 
-	if (vqs->rx_queues > ICE_MAX_BASE_QS_PER_VF ||
-	    vqs->tx_queues > ICE_MAX_BASE_QS_PER_VF) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
 	vsi = pf->vsi[vf->lan_vsi_idx];
 	if (!vsi) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
@@ -2270,7 +2237,7 @@ static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
 	if (vqs->tx_queues) {
 		q_map = vqs->tx_queues;
 
-		for_each_set_bit(vf_q_id, &q_map, ICE_MAX_BASE_QS_PER_VF) {
+		for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF) {
 			struct ice_ring *ring = vsi->tx_rings[vf_q_id];
 			struct ice_txq_meta txq_meta = { 0 };
 
@@ -2301,7 +2268,7 @@ static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
 	q_map = vqs->rx_queues;
 	/* speed up Rx queue disable by batching them if possible */
 	if (q_map &&
-	    bitmap_equal(&q_map, vf->rxq_ena, ICE_MAX_BASE_QS_PER_VF)) {
+	    bitmap_equal(&q_map, vf->rxq_ena, ICE_MAX_RSS_QS_PER_VF)) {
 		if (ice_vsi_stop_all_rx_rings(vsi)) {
 			dev_err(ice_pf_to_dev(vsi->back), "Failed to stop all Rx rings on VSI %d\n",
 				vsi->vsi_num);
@@ -2309,9 +2276,9 @@ static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
 			goto error_param;
 		}
 
-		bitmap_zero(vf->rxq_ena, ICE_MAX_BASE_QS_PER_VF);
+		bitmap_zero(vf->rxq_ena, ICE_MAX_RSS_QS_PER_VF);
 	} else if (q_map) {
-		for_each_set_bit(vf_q_id, &q_map, ICE_MAX_BASE_QS_PER_VF) {
+		for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF) {
 			if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 				goto error_param;
@@ -2344,6 +2311,57 @@ static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
 				     NULL, 0);
 }
 
+/**
+ * ice_cfg_interrupt
+ * @vf: pointer to the VF info
+ * @vsi: the VSI being configured
+ * @vector_id: vector ID
+ * @map: vector map for mapping vectors to queues
+ * @q_vector: structure for interrupt vector
+ * configure the IRQ to queue map
+ */
+static int
+ice_cfg_interrupt(struct ice_vf *vf, struct ice_vsi *vsi, u16 vector_id,
+		  struct virtchnl_vector_map *map,
+		  struct ice_q_vector *q_vector)
+{
+	u16 vsi_q_id, vsi_q_id_idx;
+	unsigned long qmap;
+
+	q_vector->num_ring_rx = 0;
+	q_vector->num_ring_tx = 0;
+
+	qmap = map->rxq_map;
+	for_each_set_bit(vsi_q_id_idx, &qmap, ICE_MAX_RSS_QS_PER_VF) {
+		vsi_q_id = vsi_q_id_idx;
+
+		if (!ice_vc_isvalid_q_id(vf, vsi->vsi_num, vsi_q_id))
+			return VIRTCHNL_STATUS_ERR_PARAM;
+
+		q_vector->num_ring_rx++;
+		q_vector->rx.itr_idx = map->rxitr_idx;
+		vsi->rx_rings[vsi_q_id]->q_vector = q_vector;
+		ice_cfg_rxq_interrupt(vsi, vsi_q_id, vector_id,
+				      q_vector->rx.itr_idx);
+	}
+
+	qmap = map->txq_map;
+	for_each_set_bit(vsi_q_id_idx, &qmap, ICE_MAX_RSS_QS_PER_VF) {
+		vsi_q_id = vsi_q_id_idx;
+
+		if (!ice_vc_isvalid_q_id(vf, vsi->vsi_num, vsi_q_id))
+			return VIRTCHNL_STATUS_ERR_PARAM;
+
+		q_vector->num_ring_tx++;
+		q_vector->tx.itr_idx = map->txitr_idx;
+		vsi->tx_rings[vsi_q_id]->q_vector = q_vector;
+		ice_cfg_txq_interrupt(vsi, vsi_q_id, vector_id,
+				      q_vector->tx.itr_idx);
+	}
+
+	return VIRTCHNL_STATUS_SUCCESS;
+}
+
 /**
  * ice_vc_cfg_irq_map_msg
  * @vf: pointer to the VF info
@@ -2354,13 +2372,11 @@ static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
 static int ice_vc_cfg_irq_map_msg(struct ice_vf *vf, u8 *msg)
 {
 	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
+	u16 num_q_vectors_mapped, vsi_id, vector_id;
 	struct virtchnl_irq_map_info *irqmap_info;
-	u16 vsi_id, vsi_q_id, vector_id;
 	struct virtchnl_vector_map *map;
 	struct ice_pf *pf = vf->pf;
-	u16 num_q_vectors_mapped;
 	struct ice_vsi *vsi;
-	unsigned long qmap;
 	int i;
 
 	irqmap_info = (struct virtchnl_irq_map_info *)msg;
@@ -2372,7 +2388,7 @@ static int ice_vc_cfg_irq_map_msg(struct ice_vf *vf, u8 *msg)
 	 */
 	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states) ||
 	    pf->num_vf_msix < num_q_vectors_mapped ||
-	    !irqmap_info->num_vectors) {
+	    !num_q_vectors_mapped) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
 	}
@@ -2393,7 +2409,7 @@ static int ice_vc_cfg_irq_map_msg(struct ice_vf *vf, u8 *msg)
 		/* vector_id is always 0-based for each VF, and can never be
 		 * larger than or equal to the max allowed interrupts per VF
 		 */
-		if (!(vector_id < ICE_MAX_INTR_PER_VF) ||
+		if (!(vector_id < pf->num_vf_msix) ||
 		    !ice_vc_isvalid_vsi_id(vf, vsi_id) ||
 		    (!vector_id && (map->rxq_map || map->txq_map))) {
 			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
@@ -2414,33 +2430,10 @@ static int ice_vc_cfg_irq_map_msg(struct ice_vf *vf, u8 *msg)
 		}
 
 		/* lookout for the invalid queue index */
-		qmap = map->rxq_map;
-		q_vector->num_ring_rx = 0;
-		for_each_set_bit(vsi_q_id, &qmap, ICE_MAX_BASE_QS_PER_VF) {
-			if (!ice_vc_isvalid_q_id(vf, vsi_id, vsi_q_id)) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-				goto error_param;
-			}
-			q_vector->num_ring_rx++;
-			q_vector->rx.itr_idx = map->rxitr_idx;
-			vsi->rx_rings[vsi_q_id]->q_vector = q_vector;
-			ice_cfg_rxq_interrupt(vsi, vsi_q_id, vector_id,
-					      q_vector->rx.itr_idx);
-		}
-
-		qmap = map->txq_map;
-		q_vector->num_ring_tx = 0;
-		for_each_set_bit(vsi_q_id, &qmap, ICE_MAX_BASE_QS_PER_VF) {
-			if (!ice_vc_isvalid_q_id(vf, vsi_id, vsi_q_id)) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-				goto error_param;
-			}
-			q_vector->num_ring_tx++;
-			q_vector->tx.itr_idx = map->txitr_idx;
-			vsi->tx_rings[vsi_q_id]->q_vector = q_vector;
-			ice_cfg_txq_interrupt(vsi, vsi_q_id, vector_id,
-					      q_vector->tx.itr_idx);
-		}
+		v_ret = (enum virtchnl_status_code)
+			ice_cfg_interrupt(vf, vsi, vector_id, map, q_vector);
+		if (v_ret)
+			goto error_param;
 	}
 
 error_param:
@@ -2483,7 +2476,7 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 		goto error_param;
 	}
 
-	if (qci->num_queue_pairs > ICE_MAX_BASE_QS_PER_VF ||
+	if (qci->num_queue_pairs > ICE_MAX_RSS_QS_PER_VF ||
 	    qci->num_queue_pairs > min_t(u16, vsi->alloc_txq, vsi->alloc_rxq)) {
 		dev_err(ice_pf_to_dev(pf), "VF-%d requesting more than supported number of queues: %d\n",
 			vf->vf_id, min_t(u16, vsi->alloc_txq, vsi->alloc_rxq));
@@ -2790,16 +2783,16 @@ static int ice_vc_request_qs_msg(struct ice_vf *vf, u8 *msg)
 	if (!req_queues) {
 		dev_err(dev, "VF %d tried to request 0 queues. Ignoring.\n",
 			vf->vf_id);
-	} else if (req_queues > ICE_MAX_BASE_QS_PER_VF) {
+	} else if (req_queues > ICE_MAX_RSS_QS_PER_VF) {
 		dev_err(dev, "VF %d tried to request more than %d queues.\n",
-			vf->vf_id, ICE_MAX_BASE_QS_PER_VF);
-		vfres->num_queue_pairs = ICE_MAX_BASE_QS_PER_VF;
+			vf->vf_id, ICE_MAX_RSS_QS_PER_VF);
+		vfres->num_queue_pairs = ICE_MAX_RSS_QS_PER_VF;
 	} else if (req_queues > cur_queues &&
 		   req_queues - cur_queues > tx_rx_queue_left) {
 		dev_warn(dev, "VF %d requested %u more queues, but only %u left.\n",
 			 vf->vf_id, req_queues - cur_queues, tx_rx_queue_left);
 		vfres->num_queue_pairs = min_t(u16, max_allowed_vf_queues,
-					       ICE_MAX_BASE_QS_PER_VF);
+					       ICE_MAX_RSS_QS_PER_VF);
 	} else {
 		/* request is successful, then reset VF */
 		vf->num_req_qs = req_queues;
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 36dad0eba3db..3f9464269bd2 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -21,18 +21,15 @@
 #define ICE_PCI_CIAD_WAIT_COUNT		100
 #define ICE_PCI_CIAD_WAIT_DELAY_US	1
 
-/* VF resources default values and limitation */
+/* VF resource constraints */
 #define ICE_MAX_VF_COUNT		256
-#define ICE_MAX_QS_PER_VF		256
 #define ICE_MIN_QS_PER_VF		1
-#define ICE_DFLT_QS_PER_VF		4
 #define ICE_NONQ_VECS_VF		1
 #define ICE_MAX_SCATTER_QS_PER_VF	16
-#define ICE_MAX_BASE_QS_PER_VF		16
-#define ICE_MAX_INTR_PER_VF		65
-#define ICE_MAX_POLICY_INTR_PER_VF	33
+#define ICE_MAX_RSS_QS_PER_VF		16
+#define ICE_NUM_VF_MSIX_MED		17
+#define ICE_NUM_VF_MSIX_SMALL		5
 #define ICE_MIN_INTR_PER_VF		(ICE_MIN_QS_PER_VF + 1)
-#define ICE_DFLT_INTR_PER_VF		(ICE_DFLT_QS_PER_VF + 1)
 #define ICE_MAX_VF_RESET_TRIES		40
 #define ICE_MAX_VF_RESET_SLEEP_MS	20
 
@@ -75,8 +72,8 @@ struct ice_vf {
 	struct virtchnl_version_info vf_ver;
 	u32 driver_caps;		/* reported by VF driver */
 	struct virtchnl_ether_addr dflt_lan_addr;
-	DECLARE_BITMAP(txq_ena, ICE_MAX_BASE_QS_PER_VF);
-	DECLARE_BITMAP(rxq_ena, ICE_MAX_BASE_QS_PER_VF);
+	DECLARE_BITMAP(txq_ena, ICE_MAX_RSS_QS_PER_VF);
+	DECLARE_BITMAP(rxq_ena, ICE_MAX_RSS_QS_PER_VF);
 	u16 port_vlan_info;		/* Port VLAN ID and QoS */
 	u8 pf_set_mac:1;		/* VF MAC address set by VMM admin */
 	u8 trusted:1;
-- 
2.24.1

