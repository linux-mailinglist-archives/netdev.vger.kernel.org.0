Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDCB1510A85
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 22:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354989AbiDZUgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 16:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354996AbiDZUgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 16:36:07 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6BF1A863E
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 13:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651005178; x=1682541178;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y/BTQY3r/o4cv1h3saCYo8IqE3G6X+o238EQc5B8Ldw=;
  b=PpTJPF9unbYJEiwodY3RzAv6kUgIgTZ+yThqAlpWiPIqcELbjoQFA87U
   B1BoOWG0K2vDKbSmFXXZSknELKJFLBkQgu9x4ntcQMj0OpzqAAW6bya/D
   3xfH0MNeLXbyq1I6/K3heT3unpArJAoLyOq/izoS2+4/mGLrD1su0IK37
   3dSBFvdlzAevffJJbDKRRx/nqSFW9GgMKCGVgH6DqF22QoGO6bjDqhDv5
   2kVkCdbL1yHiJeNjSurW0OzX0gxJMEkr3NMoz7jxgbN9K5k6pydPsttyC
   aSYAmKQh1OjxuC0TfnsxE1R45G0zWC2kg+eFRmhOB6XSDJT7r3zyaXFmU
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="253090824"
X-IronPort-AV: E=Sophos;i="5.90,291,1643702400"; 
   d="scan'208";a="253090824"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 13:32:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,291,1643702400"; 
   d="scan'208";a="617174555"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 26 Apr 2022 13:32:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Fei Liu <feliu@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 2/4] ice: Protect vf_state check by cfg_lock in ice_vc_process_vf_msg()
Date:   Tue, 26 Apr 2022 13:30:16 -0700
Message-Id: <20220426203018.3790378-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220426203018.3790378-1-anthony.l.nguyen@intel.com>
References: <20220426203018.3790378-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Vecera <ivecera@redhat.com>

Previous patch labelled "ice: Fix incorrect locking in
ice_vc_process_vf_msg()"  fixed an issue with ignored messages
sent by VF driver but a small race window still left.

Recently caught trace during 'ip link set ... vf 0 vlan ...' operation:

[ 7332.995625] ice 0000:3b:00.0: Clearing port VLAN on VF 0
[ 7333.001023] iavf 0000:3b:01.0: Reset indication received from the PF
[ 7333.007391] iavf 0000:3b:01.0: Scheduling reset task
[ 7333.059575] iavf 0000:3b:01.0: PF returned error -5 (IAVF_ERR_PARAM) to our request 3
[ 7333.059626] ice 0000:3b:00.0: Invalid message from VF 0, opcode 3, len 4, error -1

Setting of VLAN for VF causes a reset of the affected VF using
ice_reset_vf() function that runs with cfg_lock taken:

1. ice_notify_vf_reset() informs IAVF driver that reset is needed and
   IAVF schedules its own reset procedure
2. Bit ICE_VF_STATE_DIS is set in vf->vf_state
3. Misc initialization steps
4. ice_sriov_post_vsi_rebuild() -> ice_vf_set_initialized() and that
   clears ICE_VF_STATE_DIS in vf->vf_state

Step 3 is mentioned race window because IAVF reset procedure runs in
parallel and one of its step is sending of VIRTCHNL_OP_GET_VF_RESOURCES
message (opcode==3). This message is handled in ice_vc_process_vf_msg()
and if it is received during the mentioned race window then it's
marked as invalid and error is returned to VF driver.

Protect vf_state check in ice_vc_process_vf_msg() by cfg_lock to avoid
this race condition.

Fixes: e6ba5273d4ed ("ice: Fix race conditions between virtchnl handling and VF ndo ops")
Tested-by: Fei Liu <feliu@redhat.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index 5612c032f15a..b72606c9e6d0 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -3625,6 +3625,8 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 		return;
 	}
 
+	mutex_lock(&vf->cfg_lock);
+
 	/* Check if VF is disabled. */
 	if (test_bit(ICE_VF_STATE_DIS, vf->vf_states)) {
 		err = -EPERM;
@@ -3648,19 +3650,14 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 				      NULL, 0);
 		dev_err(dev, "Invalid message from VF %d, opcode %d, len %d, error %d\n",
 			vf_id, v_opcode, msglen, err);
-		ice_put_vf(vf);
-		return;
+		goto finish;
 	}
 
-	mutex_lock(&vf->cfg_lock);
-
 	if (!ice_vc_is_opcode_allowed(vf, v_opcode)) {
 		ice_vc_send_msg_to_vf(vf, v_opcode,
 				      VIRTCHNL_STATUS_ERR_NOT_SUPPORTED, NULL,
 				      0);
-		mutex_unlock(&vf->cfg_lock);
-		ice_put_vf(vf);
-		return;
+		goto finish;
 	}
 
 	switch (v_opcode) {
@@ -3773,6 +3770,7 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 			 vf_id, v_opcode, err);
 	}
 
+finish:
 	mutex_unlock(&vf->cfg_lock);
 	ice_put_vf(vf);
 }
-- 
2.31.1

