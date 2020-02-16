Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6060160191
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 04:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgBPDo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 22:44:58 -0500
Received: from mga02.intel.com ([134.134.136.20]:33370 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727755AbgBPDo6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Feb 2020 22:44:58 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Feb 2020 19:44:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,447,1574150400"; 
   d="scan'208";a="257916602"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga004.fm.intel.com with ESMTP; 15 Feb 2020 19:44:57 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 09/15] ice: Fix and refactor Rx queue disable for VFs
Date:   Sat, 15 Feb 2020 19:44:46 -0800
Message-Id: <20200216034452.1251706-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200216034452.1251706-1-jeffrey.t.kirsher@intel.com>
References: <20200216034452.1251706-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently when a VF driver sends the PF a request to disable Rx queues
we will disable them one at a time, even if the VF driver sent us a
batch of queues to disable. This is causing issues where the Rx queue
disable times out with LFC enabled. This can be improved by detecting
when the VF is trying to disable all of its queues.

Also remove the variable num_qs_ena from the ice_vf structure as it was
only used to see if there were no Rx and no Tx queues active. Instead
add a function that checks if both the vf->rxq_ena and vf->txq_ena
bitmaps are empty.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 36 ++++++++++++++-----
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  1 -
 2 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 53a9e09c8f21..7c8ec4fee25b 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -90,6 +90,19 @@ ice_set_pfe_link(struct ice_vf *vf, struct virtchnl_pf_event *pfe,
 	}
 }
 
+/**
+ * ice_vf_has_no_qs_ena - check if the VF has any Rx or Tx queues enabled
+ * @vf: the VF to check
+ *
+ * Returns true if the VF has no Rx and no Tx queues enabled and returns false
+ * otherwise
+ */
+static bool ice_vf_has_no_qs_ena(struct ice_vf *vf)
+{
+	return (!bitmap_weight(vf->rxq_ena, ICE_MAX_BASE_QS_PER_VF) &&
+		!bitmap_weight(vf->txq_ena, ICE_MAX_BASE_QS_PER_VF));
+}
+
 /**
  * ice_is_vf_link_up - check if the VF's link is up
  * @vf: VF to check if link is up
@@ -101,7 +114,7 @@ static bool ice_is_vf_link_up(struct ice_vf *vf)
 	if (ice_check_vf_init(pf, vf))
 		return false;
 
-	if (!vf->num_qs_ena)
+	if (ice_vf_has_no_qs_ena(vf))
 		return false;
 	else if (vf->link_forced)
 		return vf->link_up;
@@ -255,7 +268,6 @@ void ice_set_vf_state_qs_dis(struct ice_vf *vf)
 	/* Clear Rx/Tx enabled queues flag */
 	bitmap_zero(vf->txq_ena, ICE_MAX_BASE_QS_PER_VF);
 	bitmap_zero(vf->rxq_ena, ICE_MAX_BASE_QS_PER_VF);
-	vf->num_qs_ena = 0;
 	clear_bit(ICE_VF_STATE_QS_ENA, vf->vf_states);
 }
 
@@ -2125,7 +2137,6 @@ static int ice_vc_ena_qs_msg(struct ice_vf *vf, u8 *msg)
 		}
 
 		set_bit(vf_q_id, vf->rxq_ena);
-		vf->num_qs_ena++;
 	}
 
 	vsi = pf->vsi[vf->lan_vsi_idx];
@@ -2141,7 +2152,6 @@ static int ice_vc_ena_qs_msg(struct ice_vf *vf, u8 *msg)
 			continue;
 
 		set_bit(vf_q_id, vf->txq_ena);
-		vf->num_qs_ena++;
 	}
 
 	/* Set flag to indicate that queues are enabled */
@@ -2228,13 +2238,22 @@ static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
 
 			/* Clear enabled queues flag */
 			clear_bit(vf_q_id, vf->txq_ena);
-			vf->num_qs_ena--;
 		}
 	}
 
-	if (vqs->rx_queues) {
-		q_map = vqs->rx_queues;
+	q_map = vqs->rx_queues;
+	/* speed up Rx queue disable by batching them if possible */
+	if (q_map &&
+	    bitmap_equal(&q_map, vf->rxq_ena, ICE_MAX_BASE_QS_PER_VF)) {
+		if (ice_vsi_stop_all_rx_rings(vsi)) {
+			dev_err(ice_pf_to_dev(vsi->back), "Failed to stop all Rx rings on VSI %d\n",
+				vsi->vsi_num);
+			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+			goto error_param;
+		}
 
+		bitmap_zero(vf->rxq_ena, ICE_MAX_BASE_QS_PER_VF);
+	} else if (q_map) {
 		for_each_set_bit(vf_q_id, &q_map, ICE_MAX_BASE_QS_PER_VF) {
 			if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
@@ -2255,12 +2274,11 @@ static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
 
 			/* Clear enabled queues flag */
 			clear_bit(vf_q_id, vf->rxq_ena);
-			vf->num_qs_ena--;
 		}
 	}
 
 	/* Clear enabled queues flag */
-	if (v_ret == VIRTCHNL_STATUS_SUCCESS && !vf->num_qs_ena)
+	if (v_ret == VIRTCHNL_STATUS_SUCCESS && ice_vf_has_no_qs_ena(vf))
 		clear_bit(ICE_VF_STATE_QS_ENA, vf->vf_states);
 
 error_param:
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index c65269c15dfc..474b2613f09c 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -90,7 +90,6 @@ struct ice_vf {
 	u8 num_req_qs;			/* num of queue pairs requested by VF */
 	u16 num_mac;
 	u16 num_vf_qs;			/* num of queue configured per VF */
-	u16 num_qs_ena;			/* total num of Tx/Rx queue enabled */
 };
 
 #ifdef CONFIG_PCI_IOV
-- 
2.24.1

