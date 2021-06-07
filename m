Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6118639E47C
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhFGQws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:52:48 -0400
Received: from mga14.intel.com ([192.55.52.115]:57113 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230267AbhFGQwq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:52:46 -0400
IronPort-SDR: OL4Capifa8HGLzYWm5+27QYbh/LSRlivnZYlFCAC+hamxBwZ/tPjvhmHGwPhEgJxllYCRh8zPS
 OpcjCB3Fj05w==
X-IronPort-AV: E=McAfee;i="6200,9189,10008"; a="204474552"
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="204474552"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2021 09:50:53 -0700
IronPort-SDR: AxMSbFUeEdu1YrWmPb2B2lX6Cdm7zQBZ6BZGol6vL/GkCprR8USwM8Ml+Zs++zq2inRdj3u+30
 YW4DZwHeIfLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="484841236"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 07 Jun 2021 09:50:53 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 05/15] ice: Refactor VIRTCHNL_OP_CONFIG_VSI_QUEUES handling
Date:   Mon,  7 Jun 2021 09:53:15 -0700
Message-Id: <20210607165325.182087-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
References: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently, when a VF requests queue configuration via
VIRTCHNL_OP_CONFIG_VSI_QUEUES the PF driver expects that this message
will only be called once and we always assume the queues being
configured start from 0. This is incorrect and is causing issues when
a VF tries to send this message for multiple queue blocks. Fix this by
using the queue_id specified in the virtchnl message and allowing for
individual Rx and/or Tx queues to be configured.

Also, reduce the duplicated for loops for configuring the queues by
moving all the logic into a single for loop.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c      | 27 ++++++++++
 drivers/net/ethernet/intel/ice/ice_lib.h      |  4 ++
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 51 ++++++++++---------
 3 files changed, 59 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index bd84c1f09296..135c4d9fd01c 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1681,6 +1681,33 @@ ice_write_qrxflxp_cntxt(struct ice_hw *hw, u16 pf_q, u32 rxdid, u32 prio)
 	wr32(hw, QRXFLXP_CNTXT(pf_q), regval);
 }
 
+int ice_vsi_cfg_single_rxq(struct ice_vsi *vsi, u16 q_idx)
+{
+	if (q_idx >= vsi->num_rxq)
+		return -EINVAL;
+
+	return ice_vsi_cfg_rxq(vsi->rx_rings[q_idx]);
+}
+
+int ice_vsi_cfg_single_txq(struct ice_vsi *vsi, struct ice_ring **tx_rings, u16 q_idx)
+{
+	struct ice_aqc_add_tx_qgrp *qg_buf;
+	int err;
+
+	if (q_idx >= vsi->alloc_txq || !tx_rings || !tx_rings[q_idx])
+		return -EINVAL;
+
+	qg_buf = kzalloc(struct_size(qg_buf, txqs, 1), GFP_KERNEL);
+	if (!qg_buf)
+		return -ENOMEM;
+
+	qg_buf->num_txqs = 1;
+
+	err = ice_vsi_cfg_txq(vsi, tx_rings[q_idx], qg_buf);
+	kfree(qg_buf);
+	return err;
+}
+
 /**
  * ice_vsi_cfg_rxqs - Configure the VSI for Rx
  * @vsi: the VSI being configured
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 5ec857f71459..9bd619e2399a 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -12,6 +12,10 @@ bool ice_pf_state_is_nominal(struct ice_pf *pf);
 
 void ice_update_eth_stats(struct ice_vsi *vsi);
 
+int ice_vsi_cfg_single_rxq(struct ice_vsi *vsi, u16 q_idx);
+
+int ice_vsi_cfg_single_txq(struct ice_vsi *vsi, struct ice_ring **tx_rings, u16 q_idx);
+
 int ice_vsi_cfg_rxqs(struct ice_vsi *vsi);
 
 int ice_vsi_cfg_lan_txqs(struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 677d29fd0885..5c68f11b83bb 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -3537,10 +3537,9 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 	struct virtchnl_vsi_queue_config_info *qci =
 	    (struct virtchnl_vsi_queue_config_info *)msg;
 	struct virtchnl_queue_pair_info *qpi;
-	u16 num_rxq = 0, num_txq = 0;
 	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
-	int i;
+	int i, q_idx;
 
 	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
@@ -3578,18 +3577,31 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 			goto error_param;
 		}
+
+		q_idx = qpi->rxq.queue_id;
+
+		/* make sure selected "q_idx" is in valid range of queues
+		 * for selected "vsi"
+		 */
+		if (q_idx >= vsi->alloc_txq || q_idx >= vsi->alloc_rxq) {
+			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+			goto error_param;
+		}
+
 		/* copy Tx queue info from VF into VSI */
 		if (qpi->txq.ring_len > 0) {
-			num_txq++;
 			vsi->tx_rings[i]->dma = qpi->txq.dma_ring_addr;
 			vsi->tx_rings[i]->count = qpi->txq.ring_len;
+			if (ice_vsi_cfg_single_txq(vsi, vsi->tx_rings, q_idx)) {
+				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+				goto error_param;
+			}
 		}
 
 		/* copy Rx queue info from VF into VSI */
 		if (qpi->rxq.ring_len > 0) {
 			u16 max_frame_size = ice_vc_get_max_frame_size(vf);
 
-			num_rxq++;
 			vsi->rx_rings[i]->dma = qpi->rxq.dma_ring_addr;
 			vsi->rx_rings[i]->count = qpi->rxq.ring_len;
 
@@ -3606,27 +3618,20 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 				goto error_param;
 			}
-		}
 
-		vsi->max_frame = qpi->rxq.max_pkt_size;
-		/* add space for the port VLAN since the VF driver is not
-		 * expected to account for it in the MTU calculation
-		 */
-		if (vf->port_vlan_info)
-			vsi->max_frame += VLAN_HLEN;
-	}
-
-	/* VF can request to configure less than allocated queues or default
-	 * allocated queues. So update the VSI with new number
-	 */
-	vsi->num_txq = num_txq;
-	vsi->num_rxq = num_rxq;
-	/* All queues of VF VSI are in TC 0 */
-	vsi->tc_cfg.tc_info[0].qcount_tx = num_txq;
-	vsi->tc_cfg.tc_info[0].qcount_rx = num_rxq;
+			vsi->max_frame = qpi->rxq.max_pkt_size;
+			/* add space for the port VLAN since the VF driver is not
+			 * expected to account for it in the MTU calculation
+			 */
+			if (vf->port_vlan_info)
+				vsi->max_frame += VLAN_HLEN;
 
-	if (ice_vsi_cfg_lan_txqs(vsi) || ice_vsi_cfg_rxqs(vsi))
-		v_ret = VIRTCHNL_STATUS_ERR_ADMIN_QUEUE_ERROR;
+			if (ice_vsi_cfg_single_rxq(vsi, q_idx)) {
+				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+				goto error_param;
+			}
+		}
+	}
 
 error_param:
 	/* send the response to the VF */
-- 
2.26.2

