Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFB4AAD1B
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 22:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391690AbfIEUe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 16:34:28 -0400
Received: from mga06.intel.com ([134.134.136.31]:45332 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391650AbfIEUeP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 16:34:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 13:34:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,471,1559545200"; 
   d="scan'208";a="267136569"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga001.jf.intel.com with ESMTP; 05 Sep 2019 13:34:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 14/16] ice: Minor refactor in queue management
Date:   Thu,  5 Sep 2019 13:34:04 -0700
Message-Id: <20190905203406.4152-15-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190905203406.4152-1-jeffrey.t.kirsher@intel.com>
References: <20190905203406.4152-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

Remove q_left_tx and q_left_rx from the PF struct as these can be
obtained by calling ice_get_avail_txq_count and ice_get_avail_rxq_count
respectively.

The function ice_determine_q_usage is only setting num_lan_tx and
num_lan_rx in the PF structure, and these are later assigned to
vsi->alloc_txq and vsi->alloc_rxq respectively. This is an unnecessary
indirection, so remove ice_determine_q_usage and just assign values
for vsi->alloc_txq and vsi->alloc_rxq in ice_vsi_set_num_qs and use
these to set num_lan_tx and num_lan_rx respectively.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |  4 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      | 25 ++++++----
 drivers/net/ethernet/intel/ice/ice_main.c     | 50 +++++++++++--------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 14 +++---
 4 files changed, 54 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index c7f234688499..6c4faf7551f6 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -368,8 +368,6 @@ struct ice_pf {
 	u32 num_lan_msix;	/* Total MSIX vectors for base driver */
 	u16 num_lan_tx;		/* num LAN Tx queues setup */
 	u16 num_lan_rx;		/* num LAN Rx queues setup */
-	u16 q_left_tx;		/* remaining num Tx queues left unclaimed */
-	u16 q_left_rx;		/* remaining num Rx queues left unclaimed */
 	u16 next_vsi;		/* Next free slot in pf->vsi[] - 0-based! */
 	u16 num_alloc_vsi;
 	u16 corer_count;	/* Core reset count */
@@ -438,6 +436,8 @@ static inline struct ice_vsi *ice_get_main_vsi(struct ice_pf *pf)
 int ice_vsi_setup_tx_rings(struct ice_vsi *vsi);
 int ice_vsi_setup_rx_rings(struct ice_vsi *vsi);
 void ice_set_ethtool_ops(struct net_device *netdev);
+u16 ice_get_avail_txq_count(struct ice_pf *pf);
+u16 ice_get_avail_rxq_count(struct ice_pf *pf);
 void ice_update_vsi_stats(struct ice_vsi *vsi);
 void ice_update_pf_stats(struct ice_pf *pf);
 int ice_up(struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 5f7c75c3b24b..7cd8c5d13bcc 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -343,8 +343,20 @@ static void ice_vsi_set_num_qs(struct ice_vsi *vsi, u16 vf_id)
 
 	switch (vsi->type) {
 	case ICE_VSI_PF:
-		vsi->alloc_txq = pf->num_lan_tx;
-		vsi->alloc_rxq = pf->num_lan_rx;
+		vsi->alloc_txq = min_t(int, ice_get_avail_txq_count(pf),
+				       num_online_cpus());
+
+		pf->num_lan_tx = vsi->alloc_txq;
+
+		/* only 1 Rx queue unless RSS is enabled */
+		if (!test_bit(ICE_FLAG_RSS_ENA, pf->flags))
+			vsi->alloc_rxq = 1;
+		else
+			vsi->alloc_rxq = min_t(int, ice_get_avail_rxq_count(pf),
+					       num_online_cpus());
+
+		pf->num_lan_rx = vsi->alloc_rxq;
+
 		vsi->num_q_vectors = max_t(int, vsi->alloc_rxq, vsi->alloc_txq);
 		break;
 	case ICE_VSI_VF:
@@ -2577,9 +2589,6 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 		if (ret)
 			goto unroll_vector_base;
 
-		pf->q_left_tx -= vsi->alloc_txq;
-		pf->q_left_rx -= vsi->alloc_rxq;
-
 		/* Do not exit if configuring RSS had an issue, at least
 		 * receive traffic on first queue. Hence no need to capture
 		 * return value
@@ -2643,8 +2652,6 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 	ice_vsi_delete(vsi);
 unroll_get_qs:
 	ice_vsi_put_qs(vsi);
-	pf->q_left_tx += vsi->alloc_txq;
-	pf->q_left_rx += vsi->alloc_rxq;
 	ice_vsi_clear(vsi);
 
 	return NULL;
@@ -2992,8 +2999,6 @@ int ice_vsi_release(struct ice_vsi *vsi)
 	ice_vsi_clear_rings(vsi);
 
 	ice_vsi_put_qs(vsi);
-	pf->q_left_tx += vsi->alloc_txq;
-	pf->q_left_rx += vsi->alloc_rxq;
 
 	/* retain SW VSI data structure since it is needed to unregister and
 	 * free VSI netdev when PF is not in reset recovery pending state,\
@@ -3102,8 +3107,6 @@ int ice_vsi_rebuild(struct ice_vsi *vsi)
 		if (ret)
 			goto err_vectors;
 
-		pf->q_left_tx -= vsi->alloc_txq;
-		pf->q_left_rx -= vsi->alloc_rxq;
 		break;
 	default:
 		break;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 2d92d8591a8a..f8be9ada2447 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2192,36 +2192,48 @@ static int ice_setup_pf_sw(struct ice_pf *pf)
 		ice_vsi_free_q_vectors(vsi);
 		ice_vsi_delete(vsi);
 		ice_vsi_put_qs(vsi);
-		pf->q_left_tx += vsi->alloc_txq;
-		pf->q_left_rx += vsi->alloc_rxq;
 		ice_vsi_clear(vsi);
 	}
 	return status;
 }
 
 /**
- * ice_determine_q_usage - Calculate queue distribution
- * @pf: board private structure
- *
- * Return -ENOMEM if we don't get enough queues for all ports
+ * ice_get_avail_q_count - Get count of queues in use
+ * @pf_qmap: bitmap to get queue use count from
+ * @lock: pointer to a mutex that protects access to pf_qmap
+ * @size: size of the bitmap
  */
-static void ice_determine_q_usage(struct ice_pf *pf)
+static u16
+ice_get_avail_q_count(unsigned long *pf_qmap, struct mutex *lock, u16 size)
 {
-	u16 q_left_tx, q_left_rx;
+	u16 count = 0, bit;
 
-	q_left_tx = pf->hw.func_caps.common_cap.num_txq;
-	q_left_rx = pf->hw.func_caps.common_cap.num_rxq;
+	mutex_lock(lock);
+	for_each_clear_bit(bit, pf_qmap, size)
+		count++;
+	mutex_unlock(lock);
 
-	pf->num_lan_tx = min_t(int, q_left_tx, num_online_cpus());
+	return count;
+}
 
-	/* only 1 Rx queue unless RSS is enabled */
-	if (!test_bit(ICE_FLAG_RSS_ENA, pf->flags))
-		pf->num_lan_rx = 1;
-	else
-		pf->num_lan_rx = min_t(int, q_left_rx, num_online_cpus());
+/**
+ * ice_get_avail_txq_count - Get count of Tx queues in use
+ * @pf: pointer to an ice_pf instance
+ */
+u16 ice_get_avail_txq_count(struct ice_pf *pf)
+{
+	return ice_get_avail_q_count(pf->avail_txqs, &pf->avail_q_mutex,
+				     pf->max_pf_txqs);
+}
 
-	pf->q_left_tx = q_left_tx - pf->num_lan_tx;
-	pf->q_left_rx = q_left_rx - pf->num_lan_rx;
+/**
+ * ice_get_avail_rxq_count - Get count of Rx queues in use
+ * @pf: pointer to an ice_pf instance
+ */
+u16 ice_get_avail_rxq_count(struct ice_pf *pf)
+{
+	return ice_get_avail_q_count(pf->avail_rxqs, &pf->avail_q_mutex,
+				     pf->max_pf_rxqs);
 }
 
 /**
@@ -2541,8 +2553,6 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		}
 	}
 
-	ice_determine_q_usage(pf);
-
 	pf->num_alloc_vsi = hw->func_caps.guar_num_vsi;
 	if (!pf->num_alloc_vsi) {
 		err = -EIO;
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 30e8e6166a59..64de05ccbc47 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -595,7 +595,8 @@ static int ice_alloc_vf_res(struct ice_vf *vf)
 	/* Update number of VF queues, in case VF had requested for queue
 	 * changes
 	 */
-	tx_rx_queue_left = min_t(int, pf->q_left_tx, pf->q_left_rx);
+	tx_rx_queue_left = min_t(int, ice_get_avail_txq_count(pf),
+				 ice_get_avail_rxq_count(pf));
 	tx_rx_queue_left += ICE_DFLT_QS_PER_VF;
 	if (vf->num_req_qs && vf->num_req_qs <= tx_rx_queue_left &&
 	    vf->num_req_qs != vf->num_vf_qs)
@@ -898,11 +899,11 @@ static int ice_check_avail_res(struct ice_pf *pf)
 	 * at runtime through Virtchnl, that is the reason we start by reserving
 	 * few queues.
 	 */
-	num_txq = ice_determine_res(pf, pf->q_left_tx, ICE_DFLT_QS_PER_VF,
-				    ICE_MIN_QS_PER_VF);
+	num_txq = ice_determine_res(pf, ice_get_avail_txq_count(pf),
+				    ICE_DFLT_QS_PER_VF, ICE_MIN_QS_PER_VF);
 
-	num_rxq = ice_determine_res(pf, pf->q_left_rx, ICE_DFLT_QS_PER_VF,
-				    ICE_MIN_QS_PER_VF);
+	num_rxq = ice_determine_res(pf, ice_get_avail_rxq_count(pf),
+				    ICE_DFLT_QS_PER_VF, ICE_MIN_QS_PER_VF);
 
 	if (!num_txq || !num_rxq)
 		return -EIO;
@@ -2511,7 +2512,8 @@ static int ice_vc_request_qs_msg(struct ice_vf *vf, u8 *msg)
 	}
 
 	cur_queues = vf->num_vf_qs;
-	tx_rx_queue_left = min_t(u16, pf->q_left_tx, pf->q_left_rx);
+	tx_rx_queue_left = min_t(u16, ice_get_avail_txq_count(pf),
+				 ice_get_avail_rxq_count(pf));
 	max_allowed_vf_queues = tx_rx_queue_left + cur_queues;
 	if (!req_queues) {
 		dev_err(&pf->pdev->dev,
-- 
2.21.0

