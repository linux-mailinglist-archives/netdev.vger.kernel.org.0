Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDCF51DE70
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 19:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444250AbiEFRsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 13:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444246AbiEFRsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 13:48:15 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87AC5A157
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 10:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651859070; x=1683395070;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nDh7REjZ4oxUD1/TULMasYlXDcsR+Pj9dOfXz9hAIvs=;
  b=gOj2fTROojGD/1SzQKup+tK/vY8MPMb1mY1uCV1PrQTR+C5Pw8AlFfZd
   R5eMgrXSLvColJQTTHGB+mSjDc8adVnYKR84zp3j4apzajxYB/513Wo7v
   EZWkDv5BXQcHgs4lRE6YH0/YcuSYecTfg+YKTYgN6t2QXlql/y/T7G0nL
   ERLA07OFXydNl6QOZJjebF1cj1wT2RiuSY9IAaNDx0AM32aGBdil+AxFm
   RAvJAYRRVxDxuNouPftrLpuv8oHOFR4N4El9UtPfJHIkvlLgpYxpoDYHP
   RiRvMVcDM+uc19ja3BSkF/JcQ1rR2/1svDb58zg1cBrg4KJMnX4CbAzo7
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="331523434"
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="331523434"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 10:44:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="891929178"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 06 May 2022 10:44:29 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com, Jacob Keller <jacob.e.keller@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net v2 2/3] ice: clear stale Tx queue settings before configuring
Date:   Fri,  6 May 2022 10:41:28 -0700
Message-Id: <20220506174129.4976-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220506174129.4976-1-anthony.l.nguyen@intel.com>
References: <20220506174129.4976-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>

The iAVF driver uses 3 virtchnl op codes to communicate with the PF
regarding the VF Tx queues:

* VIRTCHNL_OP_CONFIG_VSI_QUEUES configures the hardware and firmware
logic for the Tx queues

* VIRTCHNL_OP_ENABLE_QUEUES configures the queue interrupts

* VIRTCHNL_OP_DISABLE_QUEUES disables the queue interrupts and Tx rings.

There is a bug in the iAVF driver due to the race condition between VF
reset request and shutdown being executed in parallel. This leads to a
break in logic and VIRTCHNL_OP_DISABLE_QUEUES is not being sent.

If this occurs, the PF driver never cleans up the Tx queues. This results
in leaving behind stale Tx queue settings in the hardware and firmware.

The most obvious outcome is that upon the next
VIRTCHNL_OP_CONFIG_VSI_QUEUES, the PF will fail to program the Tx
scheduler node due to a lack of space.

We need to protect ICE driver against such situation.

To fix this, make sure we clear existing stale settings out when
handling VIRTCHNL_OP_CONFIG_VSI_QUEUES. This ensures we remove the
previous settings.

Calling ice_vf_vsi_dis_single_txq should be safe as it will do nothing if
the queue is not configured. The function already handles the case when the
Tx queue is not currently configured and exits with a 0 return in that
case.

Fixes: 7ad15440acf8 ("ice: Refactor VIRTCHNL_OP_CONFIG_VSI_QUEUES handling")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 68 ++++++++++++++-----
 1 file changed, 50 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index b72606c9e6d0..2889e050a4c9 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -1307,13 +1307,52 @@ static int ice_vc_ena_qs_msg(struct ice_vf *vf, u8 *msg)
 				     NULL, 0);
 }
 
+/**
+ * ice_vf_vsi_dis_single_txq - disable a single Tx queue
+ * @vf: VF to disable queue for
+ * @vsi: VSI for the VF
+ * @q_id: VF relative (0-based) queue ID
+ *
+ * Attempt to disable the Tx queue passed in. If the Tx queue was successfully
+ * disabled then clear q_id bit in the enabled queues bitmap and return
+ * success. Otherwise return error.
+ */
+static int
+ice_vf_vsi_dis_single_txq(struct ice_vf *vf, struct ice_vsi *vsi, u16 q_id)
+{
+	struct ice_txq_meta txq_meta = { 0 };
+	struct ice_tx_ring *ring;
+	int err;
+
+	if (!test_bit(q_id, vf->txq_ena))
+		dev_dbg(ice_pf_to_dev(vsi->back), "Queue %u on VSI %u is not enabled, but stopping it anyway\n",
+			q_id, vsi->vsi_num);
+
+	ring = vsi->tx_rings[q_id];
+	if (!ring)
+		return -EINVAL;
+
+	ice_fill_txq_meta(vsi, ring, &txq_meta);
+
+	err = ice_vsi_stop_tx_ring(vsi, ICE_NO_RESET, vf->vf_id, ring, &txq_meta);
+	if (err) {
+		dev_err(ice_pf_to_dev(vsi->back), "Failed to stop Tx ring %d on VSI %d\n",
+			q_id, vsi->vsi_num);
+		return err;
+	}
+
+	/* Clear enabled queues flag */
+	clear_bit(q_id, vf->txq_ena);
+
+	return 0;
+}
+
 /**
  * ice_vc_dis_qs_msg
  * @vf: pointer to the VF info
  * @msg: pointer to the msg buffer
  *
- * called from the VF to disable all or specific
- * queue(s)
+ * called from the VF to disable all or specific queue(s)
  */
 static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
 {
@@ -1350,30 +1389,15 @@ static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
 		q_map = vqs->tx_queues;
 
 		for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF) {
-			struct ice_tx_ring *ring = vsi->tx_rings[vf_q_id];
-			struct ice_txq_meta txq_meta = { 0 };
-
 			if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 				goto error_param;
 			}
 
-			if (!test_bit(vf_q_id, vf->txq_ena))
-				dev_dbg(ice_pf_to_dev(vsi->back), "Queue %u on VSI %u is not enabled, but stopping it anyway\n",
-					vf_q_id, vsi->vsi_num);
-
-			ice_fill_txq_meta(vsi, ring, &txq_meta);
-
-			if (ice_vsi_stop_tx_ring(vsi, ICE_NO_RESET, vf->vf_id,
-						 ring, &txq_meta)) {
-				dev_err(ice_pf_to_dev(vsi->back), "Failed to stop Tx ring %d on VSI %d\n",
-					vf_q_id, vsi->vsi_num);
+			if (ice_vf_vsi_dis_single_txq(vf, vsi, vf_q_id)) {
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 				goto error_param;
 			}
-
-			/* Clear enabled queues flag */
-			clear_bit(vf_q_id, vf->txq_ena);
 		}
 	}
 
@@ -1622,6 +1646,14 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 		if (qpi->txq.ring_len > 0) {
 			vsi->tx_rings[i]->dma = qpi->txq.dma_ring_addr;
 			vsi->tx_rings[i]->count = qpi->txq.ring_len;
+
+			/* Disable any existing queue first */
+			if (ice_vf_vsi_dis_single_txq(vf, vsi, q_idx)) {
+				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+				goto error_param;
+			}
+
+			/* Configure a queue with the requested settings */
 			if (ice_vsi_cfg_single_txq(vsi, vsi->tx_rings, q_idx)) {
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 				goto error_param;
-- 
2.35.1

