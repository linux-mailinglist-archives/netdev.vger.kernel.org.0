Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5619A6B8068
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbjCMSZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbjCMSZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:25:24 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B627FD58
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 11:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678731918; x=1710267918;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dx+tkx9n0e3r6EWfSwdu5Gj0g+3vVH5dqfIDV3tscnU=;
  b=XyZBA1IycmDCrCmdwGLaFHQWZRobznKgwH7HiHtiiC4KNlhktEJmpBIz
   0+KVcFj4+d2xr3LoT09aS4cTv1BOW/AzOqDpaaKAedym/HnBE2CtqnBPD
   Fafjaf3jmdBz+449uMDcTYEf4dBBErNOmmH2scVhPyf9UqQEJkzk+1184
   M93XFmy2zmhUF6DUrBSDbxXNhsKppY1S5Xi2uHl7FDtycBnRzlunrfxD/
   KFdlTDDE46Tod0nJYQnJviwSwxlAR+dW2956juwaxUdbRaZ0Zuvjgkb65
   6FXVMRcRkX+u25EjV+YTeILpVm3TkMMgtwlIo26vz/1Sc3Qw0Kl/hwor7
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="338772343"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="338772343"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 11:22:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="767809028"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="767809028"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Mar 2023 11:22:56 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        anthony.l.nguyen@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net-next 03/14] ice: track malicious VFs in new ice_mbx_vf_info structure
Date:   Mon, 13 Mar 2023 11:21:12 -0700
Message-Id: <20230313182123.483057-4-anthony.l.nguyen@intel.com>
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

Currently the PF tracks malicious VFs in a malvfs bitmap which is used by
the ice_mbx_clear_malvf and ice_mbx_report_malvf functions. This bitmap is
used to ensure that we only report a VF as malicious once rather than
continuously spamming the event log.

This mechanism of storage for the malicious indication works well enough
for SR-IOV. However, it will not work with Scalable IOV. This is because
Scalable IOV VFs can be allocated dynamically and might change VF ID when
their underlying VSI changes.

To support this, the mailbox overflow logic will need to be refactored.
First, introduce a new ice_mbx_vf_info structure which will be used to
store data about a VF. Embed this structure in the struct ice_vf, and
ensure it gets initialized when a new VF is created.

For now this only stores the malicious indicator bit. Pass a pointer to the
VF's mbx_info structure instead of using a bitmap to keep track of these
bits.

A future change will extend this structure and the rest of the logic
associated with the overflow detection.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c  |  7 +-
 drivers/net/ethernet/intel/ice/ice_type.h   |  7 ++
 drivers/net/ethernet/intel/ice/ice_vf_lib.c | 10 +--
 drivers/net/ethernet/intel/ice/ice_vf_lib.h |  2 +-
 drivers/net/ethernet/intel/ice/ice_vf_mbx.c | 71 +++++++++------------
 drivers/net/ethernet/intel/ice/ice_vf_mbx.h |  9 +--
 6 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 7107c279752a..44b94276df91 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -204,8 +204,8 @@ void ice_free_vfs(struct ice_pf *pf)
 		}
 
 		/* clear malicious info since the VF is getting released */
-		ice_mbx_clear_malvf(&hw->mbx_snapshot, pf->vfs.malvfs,
-				    ICE_MAX_SRIOV_VFS, vf->vf_id);
+		ice_mbx_clear_malvf(&hw->mbx_snapshot, vf->vf_id,
+				    &vf->mbx_info);
 
 		mutex_unlock(&vf->cfg_lock);
 	}
@@ -1828,8 +1828,7 @@ ice_is_malicious_vf(struct ice_pf *pf, struct ice_rq_event_info *event,
 		/* if the VF is malicious and we haven't let the user
 		 * know about it, then let them know now
 		 */
-		status = ice_mbx_report_malvf(&pf->hw, pf->vfs.malvfs,
-					      ICE_MAX_SRIOV_VFS, vf_id,
+		status = ice_mbx_report_malvf(&pf->hw, &vf->mbx_info,
 					      &report_vf);
 		if (status)
 			dev_dbg(dev, "Error reporting malicious VF\n");
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index e3f622cad425..d243a0c59ea4 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -794,6 +794,13 @@ struct ice_mbx_vf_counter {
 	u32 vfcntr_len;
 };
 
+/* Structure used to track a single VF's messages on the mailbox:
+ * 1. malicious: whether this VF has been detected as malicious before
+ */
+struct ice_mbx_vf_info {
+	u8 malicious : 1;
+};
+
 /* Structure to hold data relevant to the captured static snapshot
  * of the PF-VF mailbox.
  */
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 116b43588389..69e89e960950 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -496,8 +496,8 @@ void ice_reset_all_vfs(struct ice_pf *pf)
 
 	/* clear all malicious info if the VFs are getting reset */
 	ice_for_each_vf(pf, bkt, vf)
-		ice_mbx_clear_malvf(&hw->mbx_snapshot, pf->vfs.malvfs,
-				    ICE_MAX_SRIOV_VFS, vf->vf_id);
+		ice_mbx_clear_malvf(&hw->mbx_snapshot, vf->vf_id,
+				    &vf->mbx_info);
 
 	/* If VFs have been disabled, there is no need to reset */
 	if (test_and_set_bit(ICE_VF_DIS, pf->state)) {
@@ -703,8 +703,7 @@ int ice_reset_vf(struct ice_vf *vf, u32 flags)
 	ice_eswitch_replay_vf_mac_rule(vf);
 
 	/* if the VF has been reset allow it to come up again */
-	ice_mbx_clear_malvf(&hw->mbx_snapshot, pf->vfs.malvfs,
-			    ICE_MAX_SRIOV_VFS, vf->vf_id);
+	ice_mbx_clear_malvf(&hw->mbx_snapshot, vf->vf_id, &vf->mbx_info);
 
 out_unlock:
 	if (flags & ICE_VF_RESET_LOCK)
@@ -760,6 +759,9 @@ void ice_initialize_vf_entry(struct ice_vf *vf)
 	ice_vf_ctrl_invalidate_vsi(vf);
 	ice_vf_fdir_init(vf);
 
+	/* Initialize mailbox info for this VF */
+	ice_mbx_init_vf_info(&pf->hw, &vf->mbx_info);
+
 	mutex_init(&vf->cfg_lock);
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.h b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
index ef30f05b5d02..e3cda6fb71ab 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
@@ -74,7 +74,6 @@ struct ice_vfs {
 	u16 num_qps_per;		/* number of queue pairs per VF */
 	u16 num_msix_per;		/* number of MSI-X vectors per VF */
 	unsigned long last_printed_mdd_jiffies;	/* MDD message rate limit */
-	DECLARE_BITMAP(malvfs, ICE_MAX_SRIOV_VFS); /* malicious VF indicator */
 };
 
 /* VF information structure */
@@ -105,6 +104,7 @@ struct ice_vf {
 	DECLARE_BITMAP(rxq_ena, ICE_MAX_RSS_QS_PER_VF);
 	struct ice_vlan port_vlan_info;	/* Port VLAN ID, QoS, and TPID */
 	struct virtchnl_vlan_caps vlan_v2_caps;
+	struct ice_mbx_vf_info mbx_info;
 	u8 pf_set_mac:1;		/* VF MAC address set by VMM admin */
 	u8 trusted:1;
 	u8 spoofchk:1;
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_mbx.c b/drivers/net/ethernet/intel/ice/ice_vf_mbx.c
index 9f6acfeb0fc6..2e769bd0bf7e 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_mbx.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_mbx.c
@@ -345,35 +345,23 @@ ice_mbx_vf_state_handler(struct ice_hw *hw,
 /**
  * ice_mbx_report_malvf - Track and note malicious VF
  * @hw: pointer to the HW struct
- * @all_malvfs: all malicious VFs tracked by PF
- * @bitmap_len: length of bitmap in bits
- * @vf_id: relative virtual function ID of the malicious VF
+ * @vf_info: the mailbox tracking info structure for a VF
  * @report_malvf: boolean to indicate if malicious VF must be reported
  *
- * This function will update a bitmap that keeps track of the malicious
- * VFs attached to the PF. A malicious VF must be reported only once if
- * discovered between VF resets or loading so the function checks
- * the input vf_id against the bitmap to verify if the VF has been
- * detected in any previous mailbox iterations.
+ * This function updates the malicious indicator bit in the VF mailbox
+ * tracking structure. A malicious VF must be reported only once if discovered
+ * between VF resets or loading so the function first checks if the VF has
+ * already been detected in any previous mailbox iterations.
  */
 int
-ice_mbx_report_malvf(struct ice_hw *hw, unsigned long *all_malvfs,
-		     u16 bitmap_len, u16 vf_id, bool *report_malvf)
+ice_mbx_report_malvf(struct ice_hw *hw, struct ice_mbx_vf_info *vf_info,
+		     bool *report_malvf)
 {
-	if (!all_malvfs || !report_malvf)
-		return -EINVAL;
-
-	*report_malvf = false;
-
-	if (bitmap_len < hw->mbx_snapshot.mbx_vf.vfcntr_len)
+	if (!report_malvf)
 		return -EINVAL;
 
-	if (vf_id >= bitmap_len)
-		return -EIO;
-
-	/* If the vf_id is found in the bitmap set bit and boolean to true */
-	if (!test_and_set_bit(vf_id, all_malvfs))
-		*report_malvf = true;
+	*report_malvf = !vf_info->malicious;
+	vf_info->malicious = 1;
 
 	return 0;
 }
@@ -381,33 +369,24 @@ ice_mbx_report_malvf(struct ice_hw *hw, unsigned long *all_malvfs,
 /**
  * ice_mbx_clear_malvf - Clear VF bitmap and counter for VF ID
  * @snap: pointer to the mailbox snapshot structure
- * @all_malvfs: all malicious VFs tracked by PF
- * @bitmap_len: length of bitmap in bits
  * @vf_id: relative virtual function ID of the malicious VF
+ * @vf_info: mailbox tracking structure for this VF
  *
- * In case of a VF reset, this function can be called to clear
- * the bit corresponding to the VF ID in the bitmap tracking all
- * malicious VFs attached to the PF. The function also clears the
- * VF counter array at the index of the VF ID. This is to ensure
- * that the new VF loaded is not considered malicious before going
- * through the overflow detection algorithm.
- */
+* In case of a VF reset, this function shall be called to clear the VF's
+* current mailbox tracking state.
+*/
 void
-ice_mbx_clear_malvf(struct ice_mbx_snapshot *snap, unsigned long *all_malvfs,
-		    u16 bitmap_len, u16 vf_id)
+ice_mbx_clear_malvf(struct ice_mbx_snapshot *snap, u16 vf_id,
+		    struct ice_mbx_vf_info *vf_info)
 {
-	if (WARN_ON(!snap || !all_malvfs))
-		return;
-
-	if (WARN_ON(bitmap_len < snap->mbx_vf.vfcntr_len))
+	if (WARN_ON(!snap))
 		return;
 
 	/* Ensure VF ID value is not larger than bitmap or VF counter length */
-	if (WARN_ON(vf_id >= bitmap_len || vf_id >= snap->mbx_vf.vfcntr_len))
+	if (WARN_ON(vf_id >= snap->mbx_vf.vfcntr_len))
 		return;
 
-	/* Clear VF ID bit in the bitmap tracking malicious VFs attached to PF */
-	clear_bit(vf_id, all_malvfs);
+	vf_info->malicious = 0;
 
 	/* Clear the VF counter in the mailbox snapshot structure for that VF ID.
 	 * This is to ensure that if a VF is unloaded and a new one brought back
@@ -418,6 +397,18 @@ ice_mbx_clear_malvf(struct ice_mbx_snapshot *snap, unsigned long *all_malvfs,
 	snap->mbx_vf.vf_cntr[vf_id] = 0;
 }
 
+/**
+ * ice_mbx_init_vf_info - Initialize a new VF mailbox tracking info
+ * @hw: pointer to the hardware structure
+ * @vf_info: the mailbox tracking info structure for a VF
+ *
+ * Initialize a VF mailbox tracking info structure.
+ */
+void ice_mbx_init_vf_info(struct ice_hw *hw, struct ice_mbx_vf_info *vf_info)
+{
+	vf_info->malicious = 0;
+}
+
 /**
  * ice_mbx_init_snapshot - Initialize mailbox snapshot structure
  * @hw: pointer to the hardware structure
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_mbx.h b/drivers/net/ethernet/intel/ice/ice_vf_mbx.h
index be593b951642..2613cba61ac7 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_mbx.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_mbx.h
@@ -23,13 +23,14 @@ int
 ice_mbx_vf_state_handler(struct ice_hw *hw, struct ice_mbx_data *mbx_data,
 			 u16 vf_id, bool *is_mal_vf);
 void
-ice_mbx_clear_malvf(struct ice_mbx_snapshot *snap, unsigned long *all_malvfs,
-		    u16 bitmap_len, u16 vf_id);
+ice_mbx_clear_malvf(struct ice_mbx_snapshot *snap, u16 vf_id,
+		    struct ice_mbx_vf_info *vf_info);
+void ice_mbx_init_vf_info(struct ice_hw *hw, struct ice_mbx_vf_info *vf_info);
 int ice_mbx_init_snapshot(struct ice_hw *hw, u16 vf_count);
 void ice_mbx_deinit_snapshot(struct ice_hw *hw);
 int
-ice_mbx_report_malvf(struct ice_hw *hw, unsigned long *all_malvfs,
-		     u16 bitmap_len, u16 vf_id, bool *report_malvf);
+ice_mbx_report_malvf(struct ice_hw *hw, struct ice_mbx_vf_info *vf_info,
+		     bool *report_malvf);
 #else /* CONFIG_PCI_IOV */
 static inline int
 ice_aq_send_msg_to_vf(struct ice_hw __always_unused *hw,
-- 
2.38.1

