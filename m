Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF38D6B8074
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjCMS0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbjCMSZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:25:28 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE7517CD2
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 11:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678731925; x=1710267925;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=urRK4+Wx6o6RTIuxYtc7Ebs/eEygAd2agSaprZMHwx0=;
  b=IFo4axtRQDWdUpxuJJHnW88/cdWEKYokEvLJHUz/eihQt+hr0PM/BXv4
   eZfeC6Ewimnvaz678wyxZgiBzApPE+/oT7xnTa+/iI/46VHBDim3OmAUX
   0rn7BEwaMVznlJSAciXGYiXWf4BrPgBUjZNS2E6Wu/H6QM1nlyDXpfaYO
   QyLlO+WDsFpu1trkDXz2/zm/H0AEMebZR/K3/ao4SL1IYI6/yJPLSyu1H
   uZT2Rab2HaRV9/XKduVLWpb+jh+FmppsCzJCNOM70n084uMyNbl8cp3nZ
   /vRMkc8tSJo3Cphy3KCYVXRHG8Zy4IpWt0fFiZmVPX2/B4t+2yQhfELI4
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="338772431"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="338772431"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 11:23:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="767809136"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="767809136"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Mar 2023 11:23:11 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        anthony.l.nguyen@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net-next 14/14] ice: call ice_is_malicious_vf() from ice_vc_process_vf_msg()
Date:   Mon, 13 Mar 2023 11:21:23 -0700
Message-Id: <20230313182123.483057-15-anthony.l.nguyen@intel.com>
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

The main loop in __ice_clean_ctrlq first checks if a VF might be malicious
before calling ice_vc_process_vf_msg(). This results in duplicate code in
both functions to obtain a reference to the VF, and exports the
ice_is_malicious_vf() from ice_virtchnl.c unnecessarily.

Refactor ice_is_malicious_vf() to be a static function that takes a pointer
to the VF. Call this in ice_vc_process_vf_msg() just after we obtain a
reference to the VF by calling ice_get_vf_by_id.

Pass the mailbox data from the __ice_clean_ctrlq function into
ice_vc_process_vf_msg() instead of calling ice_is_malicious_vf().

This reduces the number of exported functions and avoids the need to obtain
the VF reference twice for every mailbox message.

Note that the state check for ICE_VF_STATE_DIS is kept in
ice_is_malicious_vf() and we call this before checking that state in
ice_vc_process_vf_msg. This is intentional, as we stop responding to VF
messages from a VF once we detect that it may be overflowing the mailbox.
This ensures that we continue to silently ignore the message as before
without responding via ice_vc_send_msg_to_vf().

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c     |  3 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 36 ++++++++++---------
 drivers/net/ethernet/intel/ice/ice_virtchnl.h | 17 +++------
 3 files changed, 24 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a7e7a186009e..20b3f3e6eda1 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1517,8 +1517,7 @@ static int __ice_clean_ctrlq(struct ice_pf *pf, enum ice_ctl_q q_type)
 			data.max_num_msgs_mbx = hw->mailboxq.num_rq_entries;
 			data.async_watermark_val = ICE_MBX_OVERFLOW_WATERMARK;
 
-			if (!ice_is_malicious_vf(pf, &event, &data))
-				ice_vc_process_vf_msg(pf, &event);
+			ice_vc_process_vf_msg(pf, &event, &data);
 			break;
 		case ice_aqc_opc_fw_logging:
 			ice_output_fw_log(hw, &event.desc, event.msg_buf);
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index e0c573d9d1b9..97243c616d5d 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -3834,27 +3834,26 @@ void ice_virtchnl_set_repr_ops(struct ice_vf *vf)
 }
 
 /**
- * ice_is_malicious_vf - helper function to detect a malicious VF
- * @pf: ptr to struct ice_pf
- * @event: pointer to the AQ event
+ * ice_is_malicious_vf - check if this vf might be overflowing mailbox
+ * @vf: the VF to check
  * @mbxdata: data about the state of the mailbox
+ *
+ * Detect if a given VF might be malicious and attempting to overflow the PF
+ * mailbox. If so, log a warning message and ignore this event.
  */
-bool
-ice_is_malicious_vf(struct ice_pf *pf, struct ice_rq_event_info *event,
-		    struct ice_mbx_data *mbxdata)
+static bool
+ice_is_malicious_vf(struct ice_vf *vf, struct ice_mbx_data *mbxdata)
 {
-	s16 vf_id = le16_to_cpu(event->desc.retval);
-	struct device *dev = ice_pf_to_dev(pf);
 	bool report_malvf = false;
-	struct ice_vf *vf;
+	struct device *dev;
+	struct ice_pf *pf;
 	int status;
 
-	vf = ice_get_vf_by_id(pf, vf_id);
-	if (!vf)
-		return false;
+	pf = vf->pf;
+	dev = ice_pf_to_dev(pf);
 
 	if (test_bit(ICE_VF_STATE_DIS, vf->vf_states))
-		goto out_put_vf;
+		return vf->mbx_info.malicious;
 
 	/* check to see if we have a newly malicious VF */
 	status = ice_mbx_vf_state_handler(&pf->hw, mbxdata, &vf->mbx_info,
@@ -3872,9 +3871,6 @@ ice_is_malicious_vf(struct ice_pf *pf, struct ice_rq_event_info *event,
 			 pf_vsi ? pf_vsi->netdev->dev_addr : zero_addr);
 	}
 
-out_put_vf:
-	ice_put_vf(vf);
-
 	return vf->mbx_info.malicious;
 }
 
@@ -3882,11 +3878,13 @@ ice_is_malicious_vf(struct ice_pf *pf, struct ice_rq_event_info *event,
  * ice_vc_process_vf_msg - Process request from VF
  * @pf: pointer to the PF structure
  * @event: pointer to the AQ event
+ * @mbxdata: information used to detect VF attempting mailbox overflow
  *
  * called from the common asq/arq handler to
  * process request from VF
  */
-void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
+void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event,
+			   struct ice_mbx_data *mbxdata)
 {
 	u32 v_opcode = le32_to_cpu(event->desc.cookie_high);
 	s16 vf_id = le16_to_cpu(event->desc.retval);
@@ -3908,6 +3906,10 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 
 	mutex_lock(&vf->cfg_lock);
 
+	/* Check if the VF is trying to overflow the mailbox */
+	if (ice_is_malicious_vf(vf, mbxdata))
+		goto finish;
+
 	/* Check if VF is disabled. */
 	if (test_bit(ICE_VF_STATE_DIS, vf->vf_states)) {
 		err = -EPERM;
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.h b/drivers/net/ethernet/intel/ice/ice_virtchnl.h
index 648a383fad85..cd747718de73 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.h
@@ -63,10 +63,8 @@ int
 ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
 		      enum virtchnl_status_code v_retval, u8 *msg, u16 msglen);
 bool ice_vc_isvalid_vsi_id(struct ice_vf *vf, u16 vsi_id);
-bool
-ice_is_malicious_vf(struct ice_pf *pf, struct ice_rq_event_info *event,
-		    struct ice_mbx_data *mbxdata);
-void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event);
+void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event,
+			   struct ice_mbx_data *mbxdata);
 #else /* CONFIG_PCI_IOV */
 static inline void ice_virtchnl_set_dflt_ops(struct ice_vf *vf) { }
 static inline void ice_virtchnl_set_repr_ops(struct ice_vf *vf) { }
@@ -86,16 +84,9 @@ static inline bool ice_vc_isvalid_vsi_id(struct ice_vf *vf, u16 vsi_id)
 	return false;
 }
 
-static inline bool
-ice_is_malicious_vf(struct ice_pf __always_unused *pf,
-		    struct ice_rq_event_info __always_unused *event,
-		    struct ice_mbx_data *mbxdata)
-{
-	return false;
-}
-
 static inline void
-ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
+ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event,
+		      struct ice_mbx_data *mbxdata)
 {
 }
 #endif /* !CONFIG_PCI_IOV */
-- 
2.38.1

