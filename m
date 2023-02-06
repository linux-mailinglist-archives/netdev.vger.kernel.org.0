Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7C868C8EC
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 22:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbjBFVs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 16:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbjBFVs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 16:48:56 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76833298D8
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675720135; x=1707256135;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3xCHqHVqGAIJqdu9sJLJmixGb78RDUT2oeJZs+kVpZQ=;
  b=ntlG8BaKEo3npjc6PjJkWNuHvfSjrGv5EyVuCsKT4L8+W48tsZ0TCiPF
   THxIu94QJ2iQmXIL2bQwPCMEMQYKRkJy0fKyVI+qHVRKQM6GABPbwuym2
   spz/IOLfV+I0BmymrdKTCmYq0oxHHtDYRaYUrwkF5R2LEySaCD7AAZSbZ
   AFYq1eV1zk/BdPPkhdqPIZTfGF6HOGwxr9nqOObbbLvRlutMrQHUFGz2a
   UQpIFVXhD6AlgaESLULw5yTSagxQ+IX03gFNopbGW0D6Xg7VTc/tJaULs
   wLkSmvKKDl2SNCbZFhI0S9IFG9UkgDsaRldWN1s9E6lYFAtv+0uT8txMa
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="317338117"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="317338117"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 13:48:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="616576196"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="616576196"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga003.jf.intel.com with ESMTP; 06 Feb 2023 13:48:33 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net-next 06/13] ice: move ice_vf_vsi_release into ice_vf_lib.c
Date:   Mon,  6 Feb 2023 13:48:06 -0800
Message-Id: <20230206214813.20107-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230206214813.20107-1-anthony.l.nguyen@intel.com>
References: <20230206214813.20107-1-anthony.l.nguyen@intel.com>
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

The ice_vf_vsi_release function will be used in a future change to
refactor the .vsi_rebuild function. Move this over to ice_vf_lib.c so
that it can be used there.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c     | 15 ---------------
 drivers/net/ethernet/intel/ice/ice_vf_lib.c    | 18 ++++++++++++++++++
 .../ethernet/intel/ice/ice_vf_lib_private.h    |  1 +
 3 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index a101768b1cc5..de20e50623d7 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -40,21 +40,6 @@ static void ice_free_vf_entries(struct ice_pf *pf)
 	}
 }
 
-/**
- * ice_vf_vsi_release - invalidate the VF's VSI after freeing it
- * @vf: invalidate this VF's VSI after freeing it
- */
-static void ice_vf_vsi_release(struct ice_vf *vf)
-{
-	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
-
-	if (WARN_ON(!vsi))
-		return;
-
-	ice_vsi_release(vsi);
-	ice_vf_invalidate_vsi(vf);
-}
-
 /**
  * ice_free_vf_res - Free a VF's resources
  * @vf: pointer to the VF info
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 1b7e919b9275..5fecbec55f54 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -1143,6 +1143,24 @@ void ice_vf_invalidate_vsi(struct ice_vf *vf)
 	vf->lan_vsi_num = ICE_NO_VSI;
 }
 
+/**
+ * ice_vf_vsi_release - Release the VF VSI and invalidate indexes
+ * @vf: pointer to the VF structure
+ *
+ * Release the VF associated with this VSI and then invalidate the VSI
+ * indexes.
+ */
+void ice_vf_vsi_release(struct ice_vf *vf)
+{
+	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
+
+	if (WARN_ON(!vsi))
+		return;
+
+	ice_vsi_release(vsi);
+	ice_vf_invalidate_vsi(vf);
+}
+
 /**
  * ice_vf_set_initialized - VF is ready for VIRTCHNL communication
  * @vf: VF to set in initialized state
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib_private.h b/drivers/net/ethernet/intel/ice/ice_vf_lib_private.h
index 9c8ef2b01f0f..a0f204746f4e 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib_private.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib_private.h
@@ -36,6 +36,7 @@ void ice_vf_ctrl_invalidate_vsi(struct ice_vf *vf);
 void ice_vf_ctrl_vsi_release(struct ice_vf *vf);
 struct ice_vsi *ice_vf_ctrl_vsi_setup(struct ice_vf *vf);
 void ice_vf_invalidate_vsi(struct ice_vf *vf);
+void ice_vf_vsi_release(struct ice_vf *vf);
 void ice_vf_set_initialized(struct ice_vf *vf);
 
 #endif /* _ICE_VF_LIB_PRIVATE_H_ */
-- 
2.38.1

