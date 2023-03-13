Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A266B806B
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbjCMS0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbjCMSZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:25:25 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16E360A95
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 11:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678731921; x=1710267921;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SIU5x4bxcI3m7AJCX/7SNp45i4HoIkZPQ/2fTZ374Ek=;
  b=NIjpCcXVFLhXjyEY103CD7wDm3Yikiz9K8WU4G/AuZQMK8hhktBF9aiF
   Ld7unaoPsvQQ7AQlCI1EXfLaX6m69wXLbgDue2nL++g//QPssNwfg+VQv
   6TAChY/fizBEfm3qa2O8poMDgcPzeEIfNv/Vp8jfxJEo2O80Y0llwh6WB
   iqa2hRxfLB7tY8ZGrJhxN3sstT5d8LV/boHWkvsHxw4sXG/Zfu8jOoIrc
   XkBBaI4hK11NWCvYlUWJxM21Uc6rEeDi+1o6JFAO/FYli9zs6CIdPwFJL
   Ladg3KBeUCZsSQUdiu2xjuXfc/H8zlU7OUazNvhwyyvMx50N916QQqMw1
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="338772369"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="338772369"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 11:23:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="767809058"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="767809058"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Mar 2023 11:23:00 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        anthony.l.nguyen@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net-next 06/14] ice: merge ice_mbx_report_malvf with ice_mbx_vf_state_handler
Date:   Mon, 13 Mar 2023 11:21:15 -0700
Message-Id: <20230313182123.483057-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230313182123.483057-1-anthony.l.nguyen@intel.com>
References: <20230313182123.483057-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ice_mbx_report_malvf function is used to update the
ice_mbx_vf_info.malicious member after we detect a malicious VF. This is
done by calling ice_mbx_report_malvf after ice_mbx_vf_state_handler sets
its "is_malvf" return parameter true.

Instead of requiring two steps, directly update the malicious bit in the
state handler, and remove the need for separately calling
ice_mbx_report_malvf.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c  | 34 +++++---------
 drivers/net/ethernet/intel/ice/ice_vf_mbx.c | 51 ++++++---------------
 drivers/net/ethernet/intel/ice/ice_vf_mbx.h |  5 +-
 3 files changed, 28 insertions(+), 62 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index b65025b51526..6152c90d7286 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -1794,7 +1794,7 @@ ice_is_malicious_vf(struct ice_pf *pf, struct ice_rq_event_info *event,
 	s16 vf_id = le16_to_cpu(event->desc.retval);
 	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_mbx_data mbxdata;
-	bool malvf = false;
+	bool report_malvf = false;
 	struct ice_vf *vf;
 	int status;
 
@@ -1811,33 +1811,23 @@ ice_is_malicious_vf(struct ice_pf *pf, struct ice_rq_event_info *event,
 #define ICE_MBX_OVERFLOW_WATERMARK 64
 	mbxdata.async_watermark_val = ICE_MBX_OVERFLOW_WATERMARK;
 
-	/* check to see if we have a malicious VF */
-	status = ice_mbx_vf_state_handler(&pf->hw, &mbxdata, &vf->mbx_info, &malvf);
+	/* check to see if we have a newly malicious VF */
+	status = ice_mbx_vf_state_handler(&pf->hw, &mbxdata, &vf->mbx_info,
+					  &report_malvf);
 	if (status)
 		goto out_put_vf;
 
-	if (malvf) {
-		bool report_vf = false;
+	if (report_malvf) {
+		struct ice_vsi *pf_vsi = ice_get_main_vsi(pf);
 
-		/* if the VF is malicious and we haven't let the user
-		 * know about it, then let them know now
-		 */
-		status = ice_mbx_report_malvf(&pf->hw, &vf->mbx_info,
-					      &report_vf);
-		if (status)
-			dev_dbg(dev, "Error reporting malicious VF\n");
-
-		if (report_vf) {
-			struct ice_vsi *pf_vsi = ice_get_main_vsi(pf);
-
-			if (pf_vsi)
-				dev_warn(dev, "VF MAC %pM on PF MAC %pM is generating asynchronous messages and may be overflowing the PF message queue. Please see the Adapter User Guide for more information\n",
-					 &vf->dev_lan_addr[0],
-					 pf_vsi->netdev->dev_addr);
-		}
+		if (pf_vsi)
+			dev_warn(dev, "VF MAC %pM on PF MAC %pM is generating asynchronous messages and may be overflowing the PF message queue. Please see the Adapter User Guide for more information\n",
+				 &vf->dev_lan_addr[0],
+				 pf_vsi->netdev->dev_addr);
 	}
 
 out_put_vf:
 	ice_put_vf(vf);
-	return malvf;
+
+	return vf->mbx_info.malicious;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_mbx.c b/drivers/net/ethernet/intel/ice/ice_vf_mbx.c
index 1f332ab43b00..40cb4ba0789c 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_mbx.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_mbx.c
@@ -215,7 +215,7 @@ ice_mbx_detect_malvf(struct ice_hw *hw, struct ice_mbx_vf_info *vf_info,
  * @hw: pointer to the HW struct
  * @mbx_data: pointer to structure containing mailbox data
  * @vf_info: mailbox tracking structure for the VF in question
- * @is_malvf: boolean output to indicate if VF is malicious
+ * @report_malvf: boolean output to indicate whether VF should be reported
  *
  * The function serves as an entry point for the malicious VF
  * detection algorithm by handling the different states and state
@@ -234,25 +234,24 @@ ice_mbx_detect_malvf(struct ice_hw *hw, struct ice_mbx_vf_info *vf_info,
  * the static snapshot and look for a malicious VF.
  */
 int
-ice_mbx_vf_state_handler(struct ice_hw *hw,
-			 struct ice_mbx_data *mbx_data,
-			 struct ice_mbx_vf_info *vf_info,
-			 bool *is_malvf)
+ice_mbx_vf_state_handler(struct ice_hw *hw, struct ice_mbx_data *mbx_data,
+			 struct ice_mbx_vf_info *vf_info, bool *report_malvf)
 {
 	struct ice_mbx_snapshot *snap = &hw->mbx_snapshot;
 	struct ice_mbx_snap_buffer_data *snap_buf;
 	struct ice_ctl_q_info *cq = &hw->mailboxq;
 	enum ice_mbx_snapshot_state new_state;
+	bool is_malvf = false;
 	int status = 0;
 
-	if (!is_malvf || !mbx_data)
+	if (!report_malvf || !mbx_data || !vf_info)
 		return -EINVAL;
 
+	*report_malvf = false;
+
 	/* When entering the mailbox state machine assume that the VF
 	 * is not malicious until detected.
 	 */
-	*is_malvf = false;
-
 	 /* Checking if max messages allowed to be processed while servicing current
 	  * interrupt is not less than the defined AVF message threshold.
 	  */
@@ -301,8 +300,7 @@ ice_mbx_vf_state_handler(struct ice_hw *hw,
 		if (snap_buf->num_pending_arq >=
 		    mbx_data->async_watermark_val) {
 			new_state = ICE_MAL_VF_DETECT_STATE_DETECT;
-			status = ice_mbx_detect_malvf(hw, vf_info, &new_state,
-						      is_malvf);
+			status = ice_mbx_detect_malvf(hw, vf_info, &new_state, &is_malvf);
 		} else {
 			new_state = ICE_MAL_VF_DETECT_STATE_TRAVERSE;
 			ice_mbx_traverse(hw, &new_state);
@@ -316,8 +314,7 @@ ice_mbx_vf_state_handler(struct ice_hw *hw,
 
 	case ICE_MAL_VF_DETECT_STATE_DETECT:
 		new_state = ICE_MAL_VF_DETECT_STATE_DETECT;
-		status = ice_mbx_detect_malvf(hw, vf_info, &new_state,
-					      is_malvf);
+		status = ice_mbx_detect_malvf(hw, vf_info, &new_state, &is_malvf);
 		break;
 
 	default:
@@ -327,31 +324,13 @@ ice_mbx_vf_state_handler(struct ice_hw *hw,
 
 	snap_buf->state = new_state;
 
-	return status;
-}
-
-/**
- * ice_mbx_report_malvf - Track and note malicious VF
- * @hw: pointer to the HW struct
- * @vf_info: the mailbox tracking info structure for a VF
- * @report_malvf: boolean to indicate if malicious VF must be reported
- *
- * This function updates the malicious indicator bit in the VF mailbox
- * tracking structure. A malicious VF must be reported only once if discovered
- * between VF resets or loading so the function first checks if the VF has
- * already been detected in any previous mailbox iterations.
- */
-int
-ice_mbx_report_malvf(struct ice_hw *hw, struct ice_mbx_vf_info *vf_info,
-		     bool *report_malvf)
-{
-	if (!report_malvf)
-		return -EINVAL;
-
-	*report_malvf = !vf_info->malicious;
-	vf_info->malicious = 1;
+	/* Only report VFs as malicious the first time we detect it */
+	if (is_malvf && !vf_info->malicious) {
+		vf_info->malicious = 1;
+		*report_malvf = true;
+	}
 
-	return 0;
+	return status;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_mbx.h b/drivers/net/ethernet/intel/ice/ice_vf_mbx.h
index e4bdd93ccef1..41250519bc56 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_mbx.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_mbx.h
@@ -21,13 +21,10 @@ ice_aq_send_msg_to_vf(struct ice_hw *hw, u16 vfid, u32 v_opcode, u32 v_retval,
 u32 ice_conv_link_speed_to_virtchnl(bool adv_link_support, u16 link_speed);
 int
 ice_mbx_vf_state_handler(struct ice_hw *hw, struct ice_mbx_data *mbx_data,
-			 struct ice_mbx_vf_info *vf_info, bool *is_mal_vf);
+			 struct ice_mbx_vf_info *vf_info, bool *report_malvf);
 void ice_mbx_clear_malvf(struct ice_mbx_vf_info *vf_info);
 void ice_mbx_init_vf_info(struct ice_hw *hw, struct ice_mbx_vf_info *vf_info);
 void ice_mbx_init_snapshot(struct ice_hw *hw);
-int
-ice_mbx_report_malvf(struct ice_hw *hw, struct ice_mbx_vf_info *vf_info,
-		     bool *report_malvf);
 #else /* CONFIG_PCI_IOV */
 static inline int
 ice_aq_send_msg_to_vf(struct ice_hw __always_unused *hw,
-- 
2.38.1

