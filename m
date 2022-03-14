Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3624D8B76
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 19:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237061AbiCNSLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 14:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243652AbiCNSLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 14:11:18 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE70E3ED28
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 11:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647281407; x=1678817407;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ucquTWqUShg5C5LxZ2/e79GouLKzGACADvimidp37Rk=;
  b=oG7J46tXkyBRHf43pkjWXutVHQ8d0dewoGdg767LuJfNSdcOB+G9TXmp
   Bu0eKprEWYSM3XYMtVeSIIwHBZAqLNgC94CUayVY2P6vmTPdhSap3+Oab
   djtpgjFuVV/L677Y13O2QH27He7KpNtdBPquznj6F/PX8BR4g+D6RjPqB
   KvxibdyPqCKjq+ZO5Sj8UF1opqpdI4PjWbtMLBmbN126d8RVc72dh8szL
   q6YpZ7NwSv/PMceu16dfpNkLzGh3p2A5BQxYa9HI/egBM0KMWYlz5nI/r
   Hwn9j+nYTqEA17GypgnTBLb34chatkjy8cSqPiQlsnZIEpDCg1y2TM5pG
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="238275404"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="238275404"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 11:10:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="634297711"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Mar 2022 11:10:03 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 21/25] ice: introduce ICE_VF_RESET_NOTIFY flag
Date:   Mon, 14 Mar 2022 11:10:12 -0700
Message-Id: <20220314181016.1690595-22-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220314181016.1690595-1-anthony.l.nguyen@intel.com>
References: <20220314181016.1690595-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

In some cases of resetting a VF, the PF would like to first notify the
VF that a reset is impending. This is currently done via
ice_vc_notify_vf_reset. A wrapper to ice_reset_vf, ice_vf_reset_vf, is
used to call this function first before calling ice_reset_vf.

In fact, every single call to ice_vc_notify_vf_reset occurs just prior
to a call to ice_vc_reset_vf.

Now that ice_reset_vf has flags, replace this separate call with an
ICE_VF_RESET_NOTIFY flag. This removes an unnecessary exported function
of ice_vc_notify_vf_reset, and also makes there be a single function to
reset VFs (ice_reset_vf).

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c  | 44 +++------------------
 drivers/net/ethernet/intel/ice/ice_vf_lib.c | 28 +++++++++++++
 drivers/net/ethernet/intel/ice/ice_vf_lib.h |  1 +
 3 files changed, 34 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index c234e4edc7f0..46d656d385c4 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -829,30 +829,6 @@ void ice_vc_notify_reset(struct ice_pf *pf)
 			    (u8 *)&pfe, sizeof(struct virtchnl_pf_event));
 }
 
-/**
- * ice_vc_notify_vf_reset - Notify VF of a reset event
- * @vf: pointer to the VF structure
- */
-static void ice_vc_notify_vf_reset(struct ice_vf *vf)
-{
-	struct virtchnl_pf_event pfe;
-	struct ice_pf *pf = vf->pf;
-
-	/* Bail out if VF is in disabled state, neither initialized, nor active
-	 * state - otherwise proceed with notifications
-	 */
-	if ((!test_bit(ICE_VF_STATE_INIT, vf->vf_states) &&
-	     !test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) ||
-	    test_bit(ICE_VF_STATE_DIS, vf->vf_states))
-		return;
-
-	pfe.event = VIRTCHNL_EVENT_RESET_IMPENDING;
-	pfe.severity = PF_EVENT_SEVERITY_CERTAIN_DOOM;
-	ice_aq_send_msg_to_vf(&pf->hw, vf->vf_id, VIRTCHNL_OP_EVENT,
-			      VIRTCHNL_STATUS_SUCCESS, (u8 *)&pfe, sizeof(pfe),
-			      NULL);
-}
-
 /**
  * ice_init_vf_vsi_res - initialize/setup VF VSI resources
  * @vf: VF to initialize/setup the VSI for
@@ -1400,16 +1376,6 @@ void ice_process_vflr_event(struct ice_pf *pf)
 	mutex_unlock(&pf->vfs.table_lock);
 }
 
-/**
- * ice_vc_reset_vf - Perform software reset on the VF after informing the AVF
- * @vf: pointer to the VF info
- */
-static void ice_vc_reset_vf(struct ice_vf *vf)
-{
-	ice_vc_notify_vf_reset(vf);
-	ice_reset_vf(vf, 0);
-}
-
 /**
  * ice_get_vf_from_pfq - get the VF who owns the PF space queue passed in
  * @pf: PF used to index all VFs
@@ -1488,7 +1454,7 @@ ice_vf_lan_overflow_event(struct ice_pf *pf, struct ice_rq_event_info *event)
 		return;
 
 	mutex_lock(&vf->cfg_lock);
-	ice_vc_reset_vf(vf);
+	ice_reset_vf(vf, ICE_VF_RESET_NOTIFY);
 	mutex_unlock(&vf->cfg_lock);
 
 	ice_put_vf(vf);
@@ -3311,7 +3277,7 @@ static int ice_vc_request_qs_msg(struct ice_vf *vf, u8 *msg)
 	} else {
 		/* request is successful, then reset VF */
 		vf->num_req_qs = req_queues;
-		ice_vc_reset_vf(vf);
+		ice_reset_vf(vf, ICE_VF_RESET_NOTIFY);
 		dev_info(dev, "VF %d granted request of %u queues.\n",
 			 vf->vf_id, req_queues);
 		return 0;
@@ -5183,7 +5149,7 @@ int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 			    mac, vf_id);
 	}
 
-	ice_vc_reset_vf(vf);
+	ice_reset_vf(vf, ICE_VF_RESET_NOTIFY);
 	mutex_unlock(&vf->cfg_lock);
 
 out_put_vf:
@@ -5227,7 +5193,7 @@ int ice_set_vf_trust(struct net_device *netdev, int vf_id, bool trusted)
 	mutex_lock(&vf->cfg_lock);
 
 	vf->trusted = trusted;
-	ice_vc_reset_vf(vf);
+	ice_reset_vf(vf, ICE_VF_RESET_NOTIFY);
 	dev_info(ice_pf_to_dev(pf), "VF %u is now %strusted\n",
 		 vf_id, trusted ? "" : "un");
 
@@ -5549,7 +5515,7 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 	else
 		dev_info(dev, "Clearing port VLAN on VF %d\n", vf_id);
 
-	ice_vc_reset_vf(vf);
+	ice_reset_vf(vf, ICE_VF_RESET_NOTIFY);
 	mutex_unlock(&vf->cfg_lock);
 
 out_put_vf:
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 3b4e55c62786..dce32bc194a0 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -441,6 +441,30 @@ void ice_reset_all_vfs(struct ice_pf *pf)
 	mutex_unlock(&pf->vfs.table_lock);
 }
 
+/**
+ * ice_notify_vf_reset - Notify VF of a reset event
+ * @vf: pointer to the VF structure
+ */
+static void ice_notify_vf_reset(struct ice_vf *vf)
+{
+	struct ice_hw *hw = &vf->pf->hw;
+	struct virtchnl_pf_event pfe;
+
+	/* Bail out if VF is in disabled state, neither initialized, nor active
+	 * state - otherwise proceed with notifications
+	 */
+	if ((!test_bit(ICE_VF_STATE_INIT, vf->vf_states) &&
+	     !test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) ||
+	    test_bit(ICE_VF_STATE_DIS, vf->vf_states))
+		return;
+
+	pfe.event = VIRTCHNL_EVENT_RESET_IMPENDING;
+	pfe.severity = PF_EVENT_SEVERITY_CERTAIN_DOOM;
+	ice_aq_send_msg_to_vf(hw, vf->vf_id, VIRTCHNL_OP_EVENT,
+			      VIRTCHNL_STATUS_SUCCESS, (u8 *)&pfe, sizeof(pfe),
+			      NULL);
+}
+
 /**
  * ice_reset_vf - Reset a particular VF
  * @vf: pointer to the VF structure
@@ -448,6 +472,7 @@ void ice_reset_all_vfs(struct ice_pf *pf)
  *
  * Flags:
  *   ICE_VF_RESET_VFLR - Indicates a reset is due to VFLR event
+ *   ICE_VF_RESET_NOTIFY - Send VF a notification prior to reset
  *
  * Returns 0 if the VF is currently in reset, if the resets are disabled, or
  * if the VF resets successfully. Returns an error code if the VF fails to
@@ -467,6 +492,9 @@ int ice_reset_vf(struct ice_vf *vf, u32 flags)
 	dev = ice_pf_to_dev(pf);
 	hw = &pf->hw;
 
+	if (flags & ICE_VF_RESET_NOTIFY)
+		ice_notify_vf_reset(vf);
+
 	if (test_bit(ICE_VF_RESETS_DISABLED, pf->state)) {
 		dev_dbg(dev, "Trying to reset VF %d, but all VF resets are disabled\n",
 			vf->vf_id);
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.h b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
index 071b7f99e2d9..efa523b25bf8 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
@@ -136,6 +136,7 @@ struct ice_vf {
 /* Flags for controlling behavior of ice_reset_vf */
 enum ice_vf_reset_flags {
 	ICE_VF_RESET_VFLR = BIT(0), /* Indicate a VFLR reset */
+	ICE_VF_RESET_NOTIFY = BIT(1), /* Notify VF prior to reset */
 };
 
 static inline u16 ice_vf_get_port_vlan_id(struct ice_vf *vf)
-- 
2.31.1

