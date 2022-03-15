Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B93E14DA54E
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 23:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352216AbiCOWXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 18:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352196AbiCOWXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 18:23:17 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB3E5C678
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 15:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647382922; x=1678918922;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7U8UqCwr9imyCe+MajVcwv1jxl+14NgkVx6xH6kmuW8=;
  b=NmgiIeYXdmu8n5VtnDl3+JPa2Y2MPo+91H0ZTxs+dwYOHQScwpWWJVDi
   3Hm4fycPj4U42ooujEMLfpKZd8hHkzJoR4k7FeiEx1HEyr3u84uwvdNLR
   knfolpOMvrhKc8oB+FchetKF9n3HM8xPczRty/ePXlZ+4wdVMICWbxHiK
   NixypAjLCxRkDLzCN0bzK9Y/Fv5iDSe9abvRzrjEu3pS5Kh5jkMbE9gms
   4PO2PZhNiI+7tMhJGtyqcXIVlCgjKn2iO8cw9Gn3R0waxblCFEyHZ8m0S
   aMLUMuKm7rfa8EkN13QGXkXpHVSco77LRWTuNOqBzDZr8AAN8FgSDhp0b
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="255264555"
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="255264555"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 15:22:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="690362227"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 15 Mar 2022 15:22:00 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 08/14] ice: convert ice_reset_vf to standard error codes
Date:   Tue, 15 Mar 2022 15:22:14 -0700
Message-Id: <20220315222220.2925324-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220315222220.2925324-1-anthony.l.nguyen@intel.com>
References: <20220315222220.2925324-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ice_reset_vf function returns a boolean value indicating whether or
not the VF reset. This is a bit confusing since it means that callers
need to know how to interpret the return value when needing to indicate
an error.

Refactor the function and call sites to report a regular error code. We
still report success (i.e. return 0) in cases where the reset is in
progress or is disabled.

Existing callers don't care because they do not check the return value.
We keep the error code anyways instead of a void return because we
expect future code which may care about or at least report the error
value.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_vf_lib.c | 15 ++++++++-------
 drivers/net/ethernet/intel/ice/ice_vf_lib.h |  6 +++---
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 6f9e8383c69b..d37232197bde 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -446,10 +446,11 @@ void ice_reset_all_vfs(struct ice_pf *pf)
  * @vf: pointer to the VF structure
  * @is_vflr: true if VFLR was issued, false if not
  *
- * Returns true if the VF is currently in reset, resets successfully, or resets
- * are disabled and false otherwise.
+ * Returns 0 if the VF is currently in reset, if the resets are disabled, or
+ * if the VF resets successfully. Returns an error code if the VF fails to
+ * rebuild.
  */
-bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
+int ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 {
 	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
@@ -466,13 +467,13 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 	if (test_bit(ICE_VF_RESETS_DISABLED, pf->state)) {
 		dev_dbg(dev, "Trying to reset VF %d, but all VF resets are disabled\n",
 			vf->vf_id);
-		return true;
+		return 0;
 	}
 
 	if (ice_is_vf_disabled(vf)) {
 		dev_dbg(dev, "VF is already disabled, there is no need for resetting it, telling VM, all is fine %d\n",
 			vf->vf_id);
-		return true;
+		return 0;
 	}
 
 	/* Set VF disable bit state here, before triggering reset */
@@ -532,7 +533,7 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 	if (vf->vf_ops->vsi_rebuild(vf)) {
 		dev_err(dev, "Failed to release and setup the VF%u's VSI\n",
 			vf->vf_id);
-		return false;
+		return -EFAULT;
 	}
 
 	vf->vf_ops->post_vsi_rebuild(vf);
@@ -546,7 +547,7 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 		dev_dbg(dev, "failed to clear malicious VF state for VF %u\n",
 			vf->vf_id);
 
-	return true;
+	return 0;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.h b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
index f7906111aeb3..811b6cc8ad67 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
@@ -212,7 +212,7 @@ int
 ice_vf_set_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m);
 int
 ice_vf_clear_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m);
-bool ice_reset_vf(struct ice_vf *vf, bool is_vflr);
+int ice_reset_vf(struct ice_vf *vf, bool is_vflr);
 void ice_reset_all_vfs(struct ice_pf *pf);
 #else /* CONFIG_PCI_IOV */
 static inline struct ice_vf *ice_get_vf_by_id(struct ice_pf *pf, u16 vf_id)
@@ -270,9 +270,9 @@ ice_vf_clear_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m)
 	return -EOPNOTSUPP;
 }
 
-static inline bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
+static inline int ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 {
-	return true;
+	return 0;
 }
 
 static inline void ice_reset_all_vfs(struct ice_pf *pf)
-- 
2.31.1

