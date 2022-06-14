Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F068654B6D4
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 18:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344747AbiFNQvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 12:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354873AbiFNQvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 12:51:19 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265E6403E9
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 09:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655225479; x=1686761479;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VTiTzd312fii6Mc1co7h8zSsQcenJ4CQlUKbp550B2k=;
  b=deOGA7MKMZl9JqWicQG3mTCOSQPVXeUWrpCHy4gOjpAt8hluaJiIY/M+
   56rHOr9Yik9+f+mvA6+sGEKe/OaEHLZNkvs50eQBsVVVpRNwcNuPhcTAw
   YnG5GRo3d8hdfMywKbimQm1uSTAqf4gfLM3fjPQNaz1zlq4ftfU95LPeO
   fnmUKAQCP75txyouT0zH0CqtIIfznPiLnDOOT8XxYuOdbDcN3d7vyJA4R
   T6IF+8Oaar4njm7jKonYVBdXYyeO2ZJ1ouEATYLbrieFBtXgZSqq9JIej
   vdWH25+/5ztgA88B9yRY5YGacazByCHs4zPjQnfvt7Sg9Gt2/OcPDTGX6
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="278715017"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="278715017"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 09:51:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="582775192"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 14 Jun 2022 09:51:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Slawomir Laba <slawomirx.laba@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 3/4] ice: Fix queue config fail handling
Date:   Tue, 14 Jun 2022 09:48:05 -0700
Message-Id: <20220614164806.1184030-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614164806.1184030-1-anthony.l.nguyen@intel.com>
References: <20220614164806.1184030-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>

Disable VF's RX/TX queues, when VIRTCHNL_OP_CONFIG_VSI_QUEUES fail.
Not disabling them might lead to scenario, where PF driver leaves VF
queues enabled, when VF's VSI failed queue config.
In this scenario VF should not have RX/TX queues enabled. If PF failed
to set up VF's queues, VF will reset due to TX timeouts in VF driver.
Initialize iterator 'i' to -1, so if error happens prior to configuring
queues then error path code will not disable queue 0. Loop that
configures queues will is using same iterator, so error path code will
only disable queues that were configured.

Fixes: 77ca27c41705 ("ice: add support for virtchnl_queue_select.[tx|rx]_queues bitmap")
Suggested-by: Slawomir Laba <slawomirx.laba@intel.com>
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 53 +++++++++----------
 1 file changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index 1d9b84c3937a..4547bc1f7cee 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -1569,35 +1569,27 @@ static int ice_vc_cfg_irq_map_msg(struct ice_vf *vf, u8 *msg)
  */
 static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 {
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
 	struct virtchnl_vsi_queue_config_info *qci =
 	    (struct virtchnl_vsi_queue_config_info *)msg;
 	struct virtchnl_queue_pair_info *qpi;
 	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
-	int i, q_idx;
+	int i = -1, q_idx;
 
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states))
 		goto error_param;
-	}
 
-	if (!ice_vc_isvalid_vsi_id(vf, qci->vsi_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+	if (!ice_vc_isvalid_vsi_id(vf, qci->vsi_id))
 		goto error_param;
-	}
 
 	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+	if (!vsi)
 		goto error_param;
-	}
 
 	if (qci->num_queue_pairs > ICE_MAX_RSS_QS_PER_VF ||
 	    qci->num_queue_pairs > min_t(u16, vsi->alloc_txq, vsi->alloc_rxq)) {
 		dev_err(ice_pf_to_dev(pf), "VF-%d requesting more than supported number of queues: %d\n",
 			vf->vf_id, min_t(u16, vsi->alloc_txq, vsi->alloc_rxq));
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
 	}
 
@@ -1610,7 +1602,6 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 		    !ice_vc_isvalid_ring_len(qpi->txq.ring_len) ||
 		    !ice_vc_isvalid_ring_len(qpi->rxq.ring_len) ||
 		    !ice_vc_isvalid_q_id(vf, qci->vsi_id, qpi->txq.queue_id)) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 			goto error_param;
 		}
 
@@ -1620,7 +1611,6 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 		 * for selected "vsi"
 		 */
 		if (q_idx >= vsi->alloc_txq || q_idx >= vsi->alloc_rxq) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 			goto error_param;
 		}
 
@@ -1630,14 +1620,13 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 			vsi->tx_rings[i]->count = qpi->txq.ring_len;
 
 			/* Disable any existing queue first */
-			if (ice_vf_vsi_dis_single_txq(vf, vsi, q_idx)) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+			if (ice_vf_vsi_dis_single_txq(vf, vsi, q_idx))
 				goto error_param;
-			}
 
 			/* Configure a queue with the requested settings */
 			if (ice_vsi_cfg_single_txq(vsi, vsi->tx_rings, q_idx)) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+				dev_warn(ice_pf_to_dev(pf), "VF-%d failed to configure TX queue %d\n",
+					 vf->vf_id, i);
 				goto error_param;
 			}
 		}
@@ -1651,17 +1640,13 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 
 			if (qpi->rxq.databuffer_size != 0 &&
 			    (qpi->rxq.databuffer_size > ((16 * 1024) - 128) ||
-			     qpi->rxq.databuffer_size < 1024)) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+			     qpi->rxq.databuffer_size < 1024))
 				goto error_param;
-			}
 			vsi->rx_buf_len = qpi->rxq.databuffer_size;
 			vsi->rx_rings[i]->rx_buf_len = vsi->rx_buf_len;
 			if (qpi->rxq.max_pkt_size > max_frame_size ||
-			    qpi->rxq.max_pkt_size < 64) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+			    qpi->rxq.max_pkt_size < 64)
 				goto error_param;
-			}
 
 			vsi->max_frame = qpi->rxq.max_pkt_size;
 			/* add space for the port VLAN since the VF driver is
@@ -1672,16 +1657,30 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 				vsi->max_frame += VLAN_HLEN;
 
 			if (ice_vsi_cfg_single_rxq(vsi, q_idx)) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+				dev_warn(ice_pf_to_dev(pf), "VF-%d failed to configure RX queue %d\n",
+					 vf->vf_id, i);
 				goto error_param;
 			}
 		}
 	}
 
+	/* send the response to the VF */
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_VSI_QUEUES,
+				     VIRTCHNL_STATUS_SUCCESS, NULL, 0);
 error_param:
+	/* disable whatever we can */
+	for (; i >= 0; i--) {
+		if (ice_vsi_ctrl_one_rx_ring(vsi, false, i, true))
+			dev_err(ice_pf_to_dev(pf), "VF-%d could not disable RX queue %d\n",
+				vf->vf_id, i);
+		if (ice_vf_vsi_dis_single_txq(vf, vsi, i))
+			dev_err(ice_pf_to_dev(pf), "VF-%d could not disable TX queue %d\n",
+				vf->vf_id, i);
+	}
+
 	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_VSI_QUEUES, v_ret,
-				     NULL, 0);
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_VSI_QUEUES,
+				     VIRTCHNL_STATUS_ERR_PARAM, NULL, 0);
 }
 
 /**
-- 
2.35.1

