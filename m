Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5D213C53
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 01:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbfEDXyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 19:54:41 -0400
Received: from mga05.intel.com ([192.55.52.43]:17449 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727279AbfEDXyi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 19:54:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 May 2019 16:49:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,431,1549958400"; 
   d="scan'208";a="139994653"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga008.jf.intel.com with ESMTP; 04 May 2019 16:49:30 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Michal Swiatkowski <michal.swiatkowski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/15] ice: Add more validation in ice_vc_cfg_irq_map_msg
Date:   Sat,  4 May 2019 16:49:19 -0700
Message-Id: <20190504234929.3005-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190504234929.3005-1-jeffrey.t.kirsher@intel.com>
References: <20190504234929.3005-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@intel.com>

Add few checks to validate msg from iavf driver.

Test if we have got enough q_vectors allocated in VSI connected with VF.
Add masks for itr_indx and msix_indx to avoid writing to reserved fieldi
of QINT. Clear q_vector->num_ring_rx/tx, without it we can increment this
value every time we send irq map msg from VF. So after second call this
value will be incorrect.

Decrement num_vectors from msg, because last vector in iavf msg is misc
vector (we don't set map for it).

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |  2 ++
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |  4 +++
 drivers/net/ethernet/intel/ice/ice_lib.c      | 32 +++++++++++--------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 26 +++++++--------
 4 files changed, 36 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 804d12c2f1df..6f970edf50c7 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -83,6 +83,8 @@ extern const char ice_drv_ver[];
 #define ICE_MAX_QS_PER_VF		256
 #define ICE_MIN_QS_PER_VF		1
 #define ICE_DFLT_QS_PER_VF		4
+#define ICE_NONQ_VECS_VF		1
+#define ICE_MAX_SCATTER_QS_PER_VF	16
 #define ICE_MAX_BASE_QS_PER_VF		16
 #define ICE_MAX_INTR_PER_VF		65
 #define ICE_MIN_INTR_PER_VF		(ICE_MIN_QS_PER_VF + 1)
diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index e172ca002a0a..ec25f26069b0 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -163,11 +163,15 @@
 #define PFINT_OICR_ENA				0x0016C900
 #define QINT_RQCTL(_QRX)			(0x00150000 + ((_QRX) * 4))
 #define QINT_RQCTL_MSIX_INDX_S			0
+#define QINT_RQCTL_MSIX_INDX_M			ICE_M(0x7FF, 0)
 #define QINT_RQCTL_ITR_INDX_S			11
+#define QINT_RQCTL_ITR_INDX_M			ICE_M(0x3, 11)
 #define QINT_RQCTL_CAUSE_ENA_M			BIT(30)
 #define QINT_TQCTL(_DBQM)			(0x00140000 + ((_DBQM) * 4))
 #define QINT_TQCTL_MSIX_INDX_S			0
+#define QINT_TQCTL_MSIX_INDX_M			ICE_M(0x7FF, 0)
 #define QINT_TQCTL_ITR_INDX_S			11
+#define QINT_TQCTL_ITR_INDX_M			ICE_M(0x3, 11)
 #define QINT_TQCTL_CAUSE_ENA_M			BIT(30)
 #define VPINT_ALLOC(_VF)			(0x001D1000 + ((_VF) * 4))
 #define VPINT_ALLOC_FIRST_S			0
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 83d0aef7f77e..caa00e8873ec 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1879,33 +1879,37 @@ void ice_vsi_cfg_msix(struct ice_vsi *vsi)
 		 * tracked for this PF.
 		 */
 		for (q = 0; q < q_vector->num_ring_tx; q++) {
-			int itr_idx = q_vector->tx.itr_idx;
+			int itr_idx = (q_vector->tx.itr_idx <<
+				       QINT_TQCTL_ITR_INDX_S) &
+				QINT_TQCTL_ITR_INDX_M;
 			u32 val;
 
 			if (vsi->type == ICE_VSI_VF)
-				val = QINT_TQCTL_CAUSE_ENA_M |
-				      (itr_idx << QINT_TQCTL_ITR_INDX_S)  |
-				      ((i + 1) << QINT_TQCTL_MSIX_INDX_S);
+				val = QINT_TQCTL_CAUSE_ENA_M | itr_idx |
+				      (((i + 1) << QINT_TQCTL_MSIX_INDX_S) &
+				       QINT_TQCTL_MSIX_INDX_M);
 			else
-				val = QINT_TQCTL_CAUSE_ENA_M |
-				      (itr_idx << QINT_TQCTL_ITR_INDX_S)  |
-				      (reg_idx << QINT_TQCTL_MSIX_INDX_S);
+				val = QINT_TQCTL_CAUSE_ENA_M | itr_idx |
+				      ((reg_idx << QINT_TQCTL_MSIX_INDX_S) &
+				       QINT_TQCTL_MSIX_INDX_M);
 			wr32(hw, QINT_TQCTL(vsi->txq_map[txq]), val);
 			txq++;
 		}
 
 		for (q = 0; q < q_vector->num_ring_rx; q++) {
-			int itr_idx = q_vector->rx.itr_idx;
+			int itr_idx = (q_vector->rx.itr_idx <<
+				       QINT_RQCTL_ITR_INDX_S) &
+				QINT_RQCTL_ITR_INDX_M;
 			u32 val;
 
 			if (vsi->type == ICE_VSI_VF)
-				val = QINT_RQCTL_CAUSE_ENA_M |
-				      (itr_idx << QINT_RQCTL_ITR_INDX_S)  |
-				      ((i + 1) << QINT_RQCTL_MSIX_INDX_S);
+				val = QINT_RQCTL_CAUSE_ENA_M | itr_idx |
+					(((i + 1) << QINT_RQCTL_MSIX_INDX_S) &
+					 QINT_RQCTL_MSIX_INDX_M);
 			else
-				val = QINT_RQCTL_CAUSE_ENA_M |
-				      (itr_idx << QINT_RQCTL_ITR_INDX_S)  |
-				      (reg_idx << QINT_RQCTL_MSIX_INDX_S);
+				val = QINT_RQCTL_CAUSE_ENA_M | itr_idx |
+					((reg_idx << QINT_RQCTL_MSIX_INDX_S) &
+					 QINT_RQCTL_MSIX_INDX_M);
 			wr32(hw, QINT_RQCTL(vsi->rxq_map[rxq]), val);
 			rxq++;
 		}
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index f4b466cd4b7a..a805cbdd69be 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1814,14 +1814,22 @@ static int ice_vc_cfg_irq_map_msg(struct ice_vf *vf, u8 *msg)
 	struct ice_vsi *vsi = NULL;
 	struct ice_pf *pf = vf->pf;
 	unsigned long qmap;
+	u16 num_q_vectors;
 	int i;
 
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
+	num_q_vectors = irqmap_info->num_vectors - ICE_NONQ_VECS_VF;
+	vsi = pf->vsi[vf->lan_vsi_idx];
+
+	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states) ||
+	    !vsi || vsi->num_q_vectors < num_q_vectors ||
+	    irqmap_info->num_vectors == 0) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
 	}
 
-	for (i = 0; i < irqmap_info->num_vectors; i++) {
+	for (i = 0; i < num_q_vectors; i++) {
+		struct ice_q_vector *q_vector = vsi->q_vectors[i];
+
 		map = &irqmap_info->vecmap[i];
 
 		vector_id = map->vector_id;
@@ -1833,36 +1841,26 @@ static int ice_vc_cfg_irq_map_msg(struct ice_vf *vf, u8 *msg)
 			goto error_param;
 		}
 
-		vsi = pf->vsi[vf->lan_vsi_idx];
-		if (!vsi) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			goto error_param;
-		}
-
 		/* lookout for the invalid queue index */
 		qmap = map->rxq_map;
+		q_vector->num_ring_rx = 0;
 		for_each_set_bit(vsi_q_id, &qmap, ICE_MAX_BASE_QS_PER_VF) {
-			struct ice_q_vector *q_vector;
-
 			if (!ice_vc_isvalid_q_id(vf, vsi_id, vsi_q_id)) {
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 				goto error_param;
 			}
-			q_vector = vsi->q_vectors[i];
 			q_vector->num_ring_rx++;
 			q_vector->rx.itr_idx = map->rxitr_idx;
 			vsi->rx_rings[vsi_q_id]->q_vector = q_vector;
 		}
 
 		qmap = map->txq_map;
+		q_vector->num_ring_tx = 0;
 		for_each_set_bit(vsi_q_id, &qmap, ICE_MAX_BASE_QS_PER_VF) {
-			struct ice_q_vector *q_vector;
-
 			if (!ice_vc_isvalid_q_id(vf, vsi_id, vsi_q_id)) {
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 				goto error_param;
 			}
-			q_vector = vsi->q_vectors[i];
 			q_vector->num_ring_tx++;
 			q_vector->tx.itr_idx = map->txitr_idx;
 			vsi->tx_rings[vsi_q_id]->q_vector = q_vector;
-- 
2.20.1

