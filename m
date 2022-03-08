Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26724D2392
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 22:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350538AbiCHVsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 16:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349249AbiCHVsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 16:48:16 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36678554B2
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 13:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646776039; x=1678312039;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4VRbInQ3i15We44enCbYegPmhUy309Xnz/EOOJiOaEU=;
  b=XBJ6cjL+jsQkvq9G8VLd33cqgoliJdh/IGCe+H5K7BVGkrS1OmxqijDJ
   NTcitWSMlt1UGS3AT5cFDSV9meLETit/oxz/t2+yOWKMWgZHivykA3woJ
   /ajIyZdTdvSJrOT7SX/UKts/dVV1g9/6ewZmbaPusleJkgYz+V3k6KqZP
   0hJCHxvsLcs7vfaxyN2jNZQ5ntX8fLok9gIonaalqJ8d7JaXV6JlntRfO
   r6RCl3BwysN9gLe7kyBMEEkGDdZ7/UrVDDEu+m7wDSmjhQ6zs6WiLTwmx
   Y8F79vyC3yzeuvLFf6XCgjZ1fe2RmhBne8iQ2wN8Mzj3EWcgqKhxR3fb7
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="318050842"
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="318050842"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 13:47:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="553811431"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 08 Mar 2022 13:47:17 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 3/7] i40e: stop disabling VFs due to PF error responses
Date:   Tue,  8 Mar 2022 13:47:32 -0800
Message-Id: <20220308214736.884443-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220308214736.884443-1-anthony.l.nguyen@intel.com>
References: <20220308214736.884443-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The i40e_vc_send_msg_to_vf_ex (and its wrapper i40e_vc_send_msg_to_vf)
function has logic to detect "failure" responses sent to the VF. If a VF
is sent more than I40E_DEFAULT_NUM_INVALID_MSGS_ALLOWED, then the VF is
marked as disabled. In either case, a dev_info message is printed
stating that a VF opcode failed.

This logic originates from the early implementation of VF support in
commit 5c3c48ac6bf5 ("i40e: implement virtual device interface").

That commit did not go far enough. The "logic" for this behavior seems
to be that error responses somehow indicate a malicious VF. This is not
really true. The PF might be sending an error for any number of reasons
such as lacking resources, an unsupported operation, etc. This does not
indicate a malicious VF. We already have a separate robust malicious VF
detection which relies on hardware logic to detect and prevent a variety
of behaviors.

There is no justification for this behavior in the original
implementation. In fact, a later commit 18b7af57d9c1 ("i40e: Lower some
message levels") reduced the opcode failure message from a dev_err to a
dev_info. In addition, recent commit 01cbf50877e6 ("i40e: Fix to not
show opcode msg on unsuccessful VF MAC change") changed the logic to
allow quieting it for expected failures.

That commit prevented this logic from kicking in for specific
circumstances. This change did not go far enough. The behavior is not
documented nor is it part of any requirement for our products. Other
operating systems such as the FreeBSD implementation of our driver do
not include this logic.

It is clear this check does not make sense, and causes problems which
led to ugly workarounds.

Fix this by just removing the entire logic and the need for the
i40e_vc_send_msg_to_vf_ex function.

Fixes: 01cbf50877e6 ("i40e: Fix to not show opcode msg on unsuccessful VF MAC change")
Fixes: 5c3c48ac6bf5 ("i40e: implement virtual device interface")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/i40e/i40e_debugfs.c    |  6 +-
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 57 +++----------------
 .../ethernet/intel/i40e/i40e_virtchnl_pf.h    |  5 --
 3 files changed, 9 insertions(+), 59 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
index 1e57cc8c47d7..9db5001297c7 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
@@ -742,10 +742,8 @@ static void i40e_dbg_dump_vf(struct i40e_pf *pf, int vf_id)
 		vsi = pf->vsi[vf->lan_vsi_idx];
 		dev_info(&pf->pdev->dev, "vf %2d: VSI id=%d, seid=%d, qps=%d\n",
 			 vf_id, vf->lan_vsi_id, vsi->seid, vf->num_queue_pairs);
-		dev_info(&pf->pdev->dev, "       num MDD=%lld, invalid msg=%lld, valid msg=%lld\n",
-			 vf->num_mdd_events,
-			 vf->num_invalid_msgs,
-			 vf->num_valid_msgs);
+		dev_info(&pf->pdev->dev, "       num MDD=%lld\n",
+			 vf->num_mdd_events);
 	} else {
 		dev_info(&pf->pdev->dev, "invalid VF id %d\n", vf_id);
 	}
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index dfdb6e786461..2606e8f0f19b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1917,19 +1917,17 @@ int i40e_pci_sriov_configure(struct pci_dev *pdev, int num_vfs)
 /***********************virtual channel routines******************/
 
 /**
- * i40e_vc_send_msg_to_vf_ex
+ * i40e_vc_send_msg_to_vf
  * @vf: pointer to the VF info
  * @v_opcode: virtual channel opcode
  * @v_retval: virtual channel return value
  * @msg: pointer to the msg buffer
  * @msglen: msg length
- * @is_quiet: true for not printing unsuccessful return values, false otherwise
  *
  * send msg to VF
  **/
-static int i40e_vc_send_msg_to_vf_ex(struct i40e_vf *vf, u32 v_opcode,
-				     u32 v_retval, u8 *msg, u16 msglen,
-				     bool is_quiet)
+static int i40e_vc_send_msg_to_vf(struct i40e_vf *vf, u32 v_opcode,
+				  u32 v_retval, u8 *msg, u16 msglen)
 {
 	struct i40e_pf *pf;
 	struct i40e_hw *hw;
@@ -1944,25 +1942,6 @@ static int i40e_vc_send_msg_to_vf_ex(struct i40e_vf *vf, u32 v_opcode,
 	hw = &pf->hw;
 	abs_vf_id = vf->vf_id + hw->func_caps.vf_base_id;
 
-	/* single place to detect unsuccessful return values */
-	if (v_retval && !is_quiet) {
-		vf->num_invalid_msgs++;
-		dev_info(&pf->pdev->dev, "VF %d failed opcode %d, retval: %d\n",
-			 vf->vf_id, v_opcode, v_retval);
-		if (vf->num_invalid_msgs >
-		    I40E_DEFAULT_NUM_INVALID_MSGS_ALLOWED) {
-			dev_err(&pf->pdev->dev,
-				"Number of invalid messages exceeded for VF %d\n",
-				vf->vf_id);
-			dev_err(&pf->pdev->dev, "Use PF Control I/F to enable the VF\n");
-			set_bit(I40E_VF_STATE_DISABLED, &vf->vf_states);
-		}
-	} else {
-		vf->num_valid_msgs++;
-		/* reset the invalid counter, if a valid message is received. */
-		vf->num_invalid_msgs = 0;
-	}
-
 	aq_ret = i40e_aq_send_msg_to_vf(hw, abs_vf_id,	v_opcode, v_retval,
 					msg, msglen, NULL);
 	if (aq_ret) {
@@ -1975,23 +1954,6 @@ static int i40e_vc_send_msg_to_vf_ex(struct i40e_vf *vf, u32 v_opcode,
 	return 0;
 }
 
-/**
- * i40e_vc_send_msg_to_vf
- * @vf: pointer to the VF info
- * @v_opcode: virtual channel opcode
- * @v_retval: virtual channel return value
- * @msg: pointer to the msg buffer
- * @msglen: msg length
- *
- * send msg to VF
- **/
-static int i40e_vc_send_msg_to_vf(struct i40e_vf *vf, u32 v_opcode,
-				  u32 v_retval, u8 *msg, u16 msglen)
-{
-	return i40e_vc_send_msg_to_vf_ex(vf, v_opcode, v_retval,
-					 msg, msglen, false);
-}
-
 /**
  * i40e_vc_send_resp_to_vf
  * @vf: pointer to the VF info
@@ -2822,7 +2784,6 @@ static int i40e_vc_get_stats_msg(struct i40e_vf *vf, u8 *msg)
  * i40e_check_vf_permission
  * @vf: pointer to the VF info
  * @al: MAC address list from virtchnl
- * @is_quiet: set true for printing msg without opcode info, false otherwise
  *
  * Check that the given list of MAC addresses is allowed. Will return -EPERM
  * if any address in the list is not valid. Checks the following conditions:
@@ -2837,8 +2798,7 @@ static int i40e_vc_get_stats_msg(struct i40e_vf *vf, u8 *msg)
  * addresses might not be accurate.
  **/
 static inline int i40e_check_vf_permission(struct i40e_vf *vf,
-					   struct virtchnl_ether_addr_list *al,
-					   bool *is_quiet)
+					   struct virtchnl_ether_addr_list *al)
 {
 	struct i40e_pf *pf = vf->pf;
 	struct i40e_vsi *vsi = pf->vsi[vf->lan_vsi_idx];
@@ -2846,7 +2806,6 @@ static inline int i40e_check_vf_permission(struct i40e_vf *vf,
 	int mac2add_cnt = 0;
 	int i;
 
-	*is_quiet = false;
 	for (i = 0; i < al->num_elements; i++) {
 		struct i40e_mac_filter *f;
 		u8 *addr = al->list[i].addr;
@@ -2870,7 +2829,6 @@ static inline int i40e_check_vf_permission(struct i40e_vf *vf,
 		    !ether_addr_equal(addr, vf->default_lan_addr.addr)) {
 			dev_err(&pf->pdev->dev,
 				"VF attempting to override administratively set MAC address, bring down and up the VF interface to resume normal operation\n");
-			*is_quiet = true;
 			return -EPERM;
 		}
 
@@ -2921,7 +2879,6 @@ static int i40e_vc_add_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
 	    (struct virtchnl_ether_addr_list *)msg;
 	struct i40e_pf *pf = vf->pf;
 	struct i40e_vsi *vsi = NULL;
-	bool is_quiet = false;
 	i40e_status ret = 0;
 	int i;
 
@@ -2938,7 +2895,7 @@ static int i40e_vc_add_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
 	 */
 	spin_lock_bh(&vsi->mac_filter_hash_lock);
 
-	ret = i40e_check_vf_permission(vf, al, &is_quiet);
+	ret = i40e_check_vf_permission(vf, al);
 	if (ret) {
 		spin_unlock_bh(&vsi->mac_filter_hash_lock);
 		goto error_param;
@@ -2976,8 +2933,8 @@ static int i40e_vc_add_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
 
 error_param:
 	/* send the response to the VF */
-	return i40e_vc_send_msg_to_vf_ex(vf, VIRTCHNL_OP_ADD_ETH_ADDR,
-				       ret, NULL, 0, is_quiet);
+	return i40e_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_ETH_ADDR,
+				      ret, NULL, 0);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
index 03c42fd0fea1..a554d0a0b09b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
@@ -10,8 +10,6 @@
 
 #define I40E_VIRTCHNL_SUPPORTED_QTYPES 2
 
-#define I40E_DEFAULT_NUM_INVALID_MSGS_ALLOWED	10
-
 #define I40E_VLAN_PRIORITY_SHIFT	13
 #define I40E_VLAN_MASK			0xFFF
 #define I40E_PRIORITY_MASK		0xE000
@@ -92,9 +90,6 @@ struct i40e_vf {
 	u8 num_queue_pairs;	/* num of qps assigned to VF vsis */
 	u8 num_req_queues;	/* num of requested qps */
 	u64 num_mdd_events;	/* num of mdd events detected */
-	/* num of continuous malformed or invalid msgs detected */
-	u64 num_invalid_msgs;
-	u64 num_valid_msgs;	/* num of valid msgs detected */
 
 	unsigned long vf_caps;	/* vf's adv. capabilities */
 	unsigned long vf_states;	/* vf's runtime states */
-- 
2.31.1

