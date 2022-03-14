Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1214D8B6C
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 19:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243648AbiCNSLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 14:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243628AbiCNSLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 14:11:15 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD5712A86
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 11:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647281404; x=1678817404;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7U8UqCwr9imyCe+MajVcwv1jxl+14NgkVx6xH6kmuW8=;
  b=Ri4/uTtFjcdr2FsUd/CvYKMc4IjT12vwy+RCprXuBsaCHF2Z9KFGJFYU
   /LNX1azVdFPovYsmVCSBfvKDTu35dJUc8LHNm7cSjSnkM/RU/5EYQlCRC
   wu/8TSYUf3KXV1XTJXuiKKPuxMmJxXu/0jeMNaREBQ1BqTxsRb2xeZK3H
   /4/GVobSo4NNrJM2OEzrDuEAncEjiLMEQ67/Zv9ycXh5EiKkujLQcN4Nr
   PVeh1GPW5S5ZzCEConuteRukSdTh35RMxEivqOxnCnV/9JKgUwIT+QXku
   7+BY9h5WRFSOg3E8Nu/fuhK30k3fMqT21RnEd3qSvc028bhP/nUvbITR0
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="238275399"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="238275399"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 11:10:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="634297697"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Mar 2022 11:10:02 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 19/25] ice: convert ice_reset_vf to standard error codes
Date:   Mon, 14 Mar 2022 11:10:10 -0700
Message-Id: <20220314181016.1690595-20-anthony.l.nguyen@intel.com>
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

