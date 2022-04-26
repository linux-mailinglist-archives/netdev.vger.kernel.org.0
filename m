Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED300510A88
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 22:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355000AbiDZUgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 16:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354995AbiDZUgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 16:36:07 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A441A8632
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 13:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651005178; x=1682541178;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f19TZv8aSBYR47lo50W/wGfEqyoNjT0KcIKt+p4EhCI=;
  b=j7bgqUfbzsl5QOrAtBWkaRGMXKE56+tKBocGXj5/5LOxPcBkYOR4t9Re
   gN3D9nf961yGDNv+iHNRYYXciGEga3VVLN+a//hWrpXoRqcWcoAvirL8D
   PZnyplygCdPwvjRhUboq0aJKWv/PslMnfNEznPekxayOCOOn1C6IaQYQ9
   97zXeWQzcVf54stmdLBxLKjvtcoh2hLowvNhXI33lNTXkSkBo9ip+5q2O
   ht1Um0HK0loPULxAIh3UwZxOl9wQY0frGEdmBqSOqyjvoS4O/08XQ4IrI
   UlPi9HfcphM9cDra/db0xqXGypuA/CSApCN9VUzAlYvmPtxkIpqFSc0u1
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="253090822"
X-IronPort-AV: E=Sophos;i="5.90,291,1643702400"; 
   d="scan'208";a="253090822"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 13:32:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,291,1643702400"; 
   d="scan'208";a="617174550"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 26 Apr 2022 13:32:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 1/4] ice: Fix incorrect locking in ice_vc_process_vf_msg()
Date:   Tue, 26 Apr 2022 13:30:15 -0700
Message-Id: <20220426203018.3790378-2-anthony.l.nguyen@intel.com>
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

Usage of mutex_trylock() in ice_vc_process_vf_msg() is incorrect
because message sent from VF is ignored and never processed.

Use mutex_lock() instead to fix the issue. It is safe because this
mutex is used to prevent races between VF related NDOs and
handlers processing request messages from VF and these handlers
are running in ice_service_task() context. Additionally move this
mutex lock prior ice_vc_is_opcode_allowed() call to avoid potential
races during allowlist access.

Fixes: e6ba5273d4ed ("ice: Fix race conditions between virtchnl handling and VF ndo ops")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 21 +++++++------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index 69ff4b929772..5612c032f15a 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -3642,14 +3642,6 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 			err = -EINVAL;
 	}
 
-	if (!ice_vc_is_opcode_allowed(vf, v_opcode)) {
-		ice_vc_send_msg_to_vf(vf, v_opcode,
-				      VIRTCHNL_STATUS_ERR_NOT_SUPPORTED, NULL,
-				      0);
-		ice_put_vf(vf);
-		return;
-	}
-
 error_handler:
 	if (err) {
 		ice_vc_send_msg_to_vf(vf, v_opcode, VIRTCHNL_STATUS_ERR_PARAM,
@@ -3660,12 +3652,13 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 		return;
 	}
 
-	/* VF is being configured in another context that triggers a VFR, so no
-	 * need to process this message
-	 */
-	if (!mutex_trylock(&vf->cfg_lock)) {
-		dev_info(dev, "VF %u is being configured in another context that will trigger a VFR, so there is no need to handle this message\n",
-			 vf->vf_id);
+	mutex_lock(&vf->cfg_lock);
+
+	if (!ice_vc_is_opcode_allowed(vf, v_opcode)) {
+		ice_vc_send_msg_to_vf(vf, v_opcode,
+				      VIRTCHNL_STATUS_ERR_NOT_SUPPORTED, NULL,
+				      0);
+		mutex_unlock(&vf->cfg_lock);
 		ice_put_vf(vf);
 		return;
 	}
-- 
2.31.1

