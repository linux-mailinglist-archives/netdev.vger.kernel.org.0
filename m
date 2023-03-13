Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9119A6B8066
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbjCMSZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbjCMSZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:25:23 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D63B7FD4D
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 11:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678731918; x=1710267918;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ruZQAxoRvSlq+A7XeeYOn+3CDKklExKSAlr2X+eYnn8=;
  b=HTAeM1RRtHRjVS3Toj5/HJSa82En6lg74iKmV5NIHwi5Ddyp0sxX4o5A
   Rz2SR3farF/UimMHNUoPvxyqcOyjtn/0kbxSk4FcTg09MuhaiUgHq0/1X
   Az0EI5WgbZVcbgexJmAu++YRiNgBHVw2svL5Fr997fbtFvqbVon6kkxdc
   iystLxz2xfheaKcqOmQwJqTAUKgLzLEC0Y70B3NH2BTlQE65a2ODJG1Qg
   ERH5q5hR+Mmfxs1GBDV84moVsjF6MXRXvOp45DbUrQiRZhJzBqyy5rGyX
   6WHythzeFN5hmxhp0kpM6W89fIdHn2yXQfFDEE/PAI+IHV2rpCGTh+Y8s
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="338772329"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="338772329"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 11:22:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="767809012"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="767809012"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Mar 2023 11:22:53 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        anthony.l.nguyen@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net-next 01/14] ice: re-order ice_mbx_reset_snapshot function
Date:   Mon, 13 Mar 2023 11:21:10 -0700
Message-Id: <20230313182123.483057-2-anthony.l.nguyen@intel.com>
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

A future change is going to refactor the VF mailbox overflow detection
logic, including modifying ice_mbx_reset_snapshot and its callers. To make
this change easier to review, first move the ice_mbx_reset_snapshot
function higher in the ice_vf_mbx.c file.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_vf_mbx.c | 48 ++++++++++-----------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_vf_mbx.c b/drivers/net/ethernet/intel/ice/ice_vf_mbx.c
index f56fa94ff3d0..2fe9a9504914 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_mbx.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_mbx.c
@@ -130,6 +130,30 @@ u32 ice_conv_link_speed_to_virtchnl(bool adv_link_support, u16 link_speed)
  */
 #define ICE_IGNORE_MAX_MSG_CNT	0xFFFF
 
+/**
+ * ice_mbx_reset_snapshot - Reset mailbox snapshot structure
+ * @snap: pointer to mailbox snapshot structure in the ice_hw struct
+ *
+ * Reset the mailbox snapshot structure and clear VF counter array.
+ */
+static void ice_mbx_reset_snapshot(struct ice_mbx_snapshot *snap)
+{
+	u32 vfcntr_len;
+
+	if (!snap || !snap->mbx_vf.vf_cntr)
+		return;
+
+	/* Clear VF counters. */
+	vfcntr_len = snap->mbx_vf.vfcntr_len;
+	if (vfcntr_len)
+		memset(snap->mbx_vf.vf_cntr, 0,
+		       (vfcntr_len * sizeof(*snap->mbx_vf.vf_cntr)));
+
+	/* Reset mailbox snapshot for a new capture. */
+	memset(&snap->mbx_buf, 0, sizeof(snap->mbx_buf));
+	snap->mbx_buf.state = ICE_MAL_VF_DETECT_STATE_NEW_SNAPSHOT;
+}
+
 /**
  * ice_mbx_traverse - Pass through mailbox snapshot
  * @hw: pointer to the HW struct
@@ -201,30 +225,6 @@ ice_mbx_detect_malvf(struct ice_hw *hw, u16 vf_id,
 	return 0;
 }
 
-/**
- * ice_mbx_reset_snapshot - Reset mailbox snapshot structure
- * @snap: pointer to mailbox snapshot structure in the ice_hw struct
- *
- * Reset the mailbox snapshot structure and clear VF counter array.
- */
-static void ice_mbx_reset_snapshot(struct ice_mbx_snapshot *snap)
-{
-	u32 vfcntr_len;
-
-	if (!snap || !snap->mbx_vf.vf_cntr)
-		return;
-
-	/* Clear VF counters. */
-	vfcntr_len = snap->mbx_vf.vfcntr_len;
-	if (vfcntr_len)
-		memset(snap->mbx_vf.vf_cntr, 0,
-		       (vfcntr_len * sizeof(*snap->mbx_vf.vf_cntr)));
-
-	/* Reset mailbox snapshot for a new capture. */
-	memset(&snap->mbx_buf, 0, sizeof(snap->mbx_buf));
-	snap->mbx_buf.state = ICE_MAL_VF_DETECT_STATE_NEW_SNAPSHOT;
-}
-
 /**
  * ice_mbx_vf_state_handler - Handle states of the overflow algorithm
  * @hw: pointer to the HW struct
-- 
2.38.1

