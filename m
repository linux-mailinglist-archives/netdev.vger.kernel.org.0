Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CADD4D2398
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 22:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350541AbiCHVsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 16:48:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350534AbiCHVsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 16:48:16 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4188554A3
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 13:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646776039; x=1678312039;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=upZnuL9o5gbwESwldHYTCi8wS/m5269IkZ2mDCgxPjE=;
  b=G3rBlbN0Qfc2DwLWe9inGT36XM2Sgm9TzaMAS9EIdP1AscP7TD6oZdGG
   BDUFpfPfGoeXkQ66w6bX2EI+0bM9GVXUbc8Tq1eI/fhRwWOdbwIaLXWrH
   kscoBFejWOr6f/6OV5jG0LcBGdi/gxFgKgYxpFu0tHWxAoL4m5cVKank1
   L7ZtKMCkyLJcPf251rUeQ8yjY9EOZYViPIkbjd810jSOXWxoPj5Z4eOMf
   vtQqsjiHMnj+LZ3UDIeVLsua6yk+oJbIlMTLdtg6CxQOh+X6PYCctLi9u
   xxNcTMRBbwGVemdPnoYj/MsUHMUqKDUA9oRtrnAt5pt1qFDZRGUitGPcs
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="318050844"
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="318050844"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 13:47:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="553811434"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 08 Mar 2022 13:47:17 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 4/7] ice: stop disabling VFs due to PF error responses
Date:   Tue,  8 Mar 2022 13:47:33 -0800
Message-Id: <20220308214736.884443-5-anthony.l.nguyen@intel.com>
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

The ice_vc_send_msg_to_vf function has logic to detect "failure"
responses being sent to a VF. If a VF is sent more than
ICE_DFLT_NUM_INVAL_MSGS_ALLOWED then the VF is marked as disabled.
Almost identical logic also existed in the i40e driver.

This logic was added to the ice driver in commit 1071a8358a28 ("ice:
Implement virtchnl commands for AVF support") which itself copied from
the i40e implementation in commit 5c3c48ac6bf5 ("i40e: implement virtual
device interface").

Neither commit provides a proper explanation or justification of the
check. In fact, later commits to i40e changed the logic to allow
bypassing the check in some specific instances.

The "logic" for this seems to be that error responses somehow indicate a
malicious VF. This is not really true. The PF might be sending an error
for any number of reasons such as lack of resources, etc.

Additionally, this causes the PF to log an info message for every failed
VF response which may confuse users, and can spam the kernel log.

This behavior is not documented as part of any requirement for our
products and other operating system drivers such as the FreeBSD
implementation of our drivers do not include this type of check.

In fact, the change from dev_err to dev_info in i40e commit 18b7af57d9c1
("i40e: Lower some message levels") explains that these messages
typically don't actually indicate a real issue. It is quite likely that
a user who hits this in practice will be very confused as the VF will be
disabled without an obvious way to recover.

We already have robust malicious driver detection logic using actual
hardware detection mechanisms that detect and prevent invalid device
usage. Remove the logic since its not a documented requirement and the
behavior is not intuitive.

Fixes: 1071a8358a28 ("ice: Implement virtchnl commands for AVF support")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c   | 18 ------------------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h   |  3 ---
 2 files changed, 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 408f78e3eb13..1be3cd4b2bef 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -2182,24 +2182,6 @@ ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
 
 	dev = ice_pf_to_dev(pf);
 
-	/* single place to detect unsuccessful return values */
-	if (v_retval) {
-		vf->num_inval_msgs++;
-		dev_info(dev, "VF %d failed opcode %d, retval: %d\n", vf->vf_id,
-			 v_opcode, v_retval);
-		if (vf->num_inval_msgs > ICE_DFLT_NUM_INVAL_MSGS_ALLOWED) {
-			dev_err(dev, "Number of invalid messages exceeded for VF %d\n",
-				vf->vf_id);
-			dev_err(dev, "Use PF Control I/F to enable the VF\n");
-			set_bit(ICE_VF_STATE_DIS, vf->vf_states);
-			return -EIO;
-		}
-	} else {
-		vf->num_valid_msgs++;
-		/* reset the invalid counter, if a valid message is received. */
-		vf->num_inval_msgs = 0;
-	}
-
 	aq_ret = ice_aq_send_msg_to_vf(&pf->hw, vf->vf_id, v_opcode, v_retval,
 				       msg, msglen, NULL);
 	if (aq_ret && pf->hw.mailboxq.sq_last_status != ICE_AQ_RC_ENOSYS) {
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 752487a1bdd6..8f27255cc0cc 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -14,7 +14,6 @@
 #define ICE_MAX_MACADDR_PER_VF		18
 
 /* Malicious Driver Detection */
-#define ICE_DFLT_NUM_INVAL_MSGS_ALLOWED		10
 #define ICE_MDD_EVENTS_THRESHOLD		30
 
 /* Static VF transaction/status register def */
@@ -134,8 +133,6 @@ struct ice_vf {
 	unsigned int max_tx_rate;	/* Maximum Tx bandwidth limit in Mbps */
 	DECLARE_BITMAP(vf_states, ICE_VF_STATES_NBITS);	/* VF runtime states */
 
-	u64 num_inval_msgs;		/* number of continuous invalid msgs */
-	u64 num_valid_msgs;		/* number of valid msgs detected */
 	unsigned long vf_caps;		/* VF's adv. capabilities */
 	u8 num_req_qs;			/* num of queue pairs requested by VF */
 	u16 num_mac;
-- 
2.31.1

