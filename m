Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 224CC4D9211
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 02:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344192AbiCOBNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 21:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344155AbiCOBMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 21:12:53 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627C446673
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 18:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647306700; x=1678842700;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4pe8wDXFNXfhoouRAeKCXYG6x+GOcflfFxKbd2yq6PE=;
  b=Xkg99oR99L/eIGyL2KF936edkBvTfOoeYGYctZ1s2bL+0QZiM/mQziqS
   mQfFJAV0ylKX8ah3WzvlqaZYkIqgS8tWZJHHC1hrvOs6Q4Ey3J7tPq1Sz
   dX7AcW3pNEtD8+ANgvzwmAljeqPl0rbAAd0LXEmTlnLDe+T8CMyBy5KAD
   nbUAmc/l0bWF9h0z3VP/XTbd3taNP9wknVWCBR8/e9d3G1N8f1KE0sVt1
   RUI+te2xGoZ4lt8MXTID4X4lOUbO1zVlPeLChlmAqPf16BPV5bAjOHm6T
   +ahh/iwrxRHyb1lPlEv7TM7IuIZSDXDnXgTjaRHiopc/GmluuXCN7G/K8
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="236790469"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="236790469"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 18:11:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="540222902"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 14 Mar 2022 18:11:33 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next v2 09/11] ice: cleanup error logging for ice_ena_vfs
Date:   Mon, 14 Mar 2022 18:11:53 -0700
Message-Id: <20220315011155.2166817-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220315011155.2166817-1-anthony.l.nguyen@intel.com>
References: <20220315011155.2166817-1-anthony.l.nguyen@intel.com>
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

The ice_ena_vfs function and some of its sub-functions like
ice_set_per_vf_res use a "if (<function>) { <print error> ; <exit> }"
flow. This flow discards specialized errors reported by the called
function.

This style is generally not preferred as it makes tracing error sources
more difficult. It also means we cannot log the actual error received
properly.

Refactor several calls in the ice_ena_vfs function that do this to catch
the error in the 'ret' variable. Report this in the messages, and then
return the more precise error value.

Doing this reveals that ice_set_per_vf_res returns -EINVAL or -EIO in
places where -ENOSPC makes more sense. Fix these calls up to return the
more appropriate value.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c | 32 +++++++++++++---------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index eebff1824be2..b695d479dfb1 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -1275,12 +1275,16 @@ static int ice_set_per_vf_res(struct ice_pf *pf, u16 num_vfs)
 	u16 num_msix_per_vf, num_txq, num_rxq, avail_qs;
 	int msix_avail_per_vf, msix_avail_for_sriov;
 	struct device *dev = ice_pf_to_dev(pf);
+	int err;
 
 	lockdep_assert_held(&pf->vfs.table_lock);
 
-	if (!num_vfs || max_valid_res_idx < 0)
+	if (!num_vfs)
 		return -EINVAL;
 
+	if (max_valid_res_idx < 0)
+		return -ENOSPC;
+
 	/* determine MSI-X resources per VF */
 	msix_avail_for_sriov = pf->hw.func_caps.common_cap.num_msix_vectors -
 		pf->irq_tracker->num_entries;
@@ -1297,7 +1301,7 @@ static int ice_set_per_vf_res(struct ice_pf *pf, u16 num_vfs)
 		dev_err(dev, "Only %d MSI-X interrupts available for SR-IOV. Not enough to support minimum of %d MSI-X interrupts per VF for %d VFs\n",
 			msix_avail_for_sriov, ICE_MIN_INTR_PER_VF,
 			num_vfs);
-		return -EIO;
+		return -ENOSPC;
 	}
 
 	num_txq = min_t(u16, num_msix_per_vf - ICE_NONQ_VECS_VF,
@@ -1319,13 +1323,14 @@ static int ice_set_per_vf_res(struct ice_pf *pf, u16 num_vfs)
 	if (num_txq < ICE_MIN_QS_PER_VF || num_rxq < ICE_MIN_QS_PER_VF) {
 		dev_err(dev, "Not enough queues to support minimum of %d queue pairs per VF for %d VFs\n",
 			ICE_MIN_QS_PER_VF, num_vfs);
-		return -EIO;
+		return -ENOSPC;
 	}
 
-	if (ice_sriov_set_msix_res(pf, num_msix_per_vf * num_vfs)) {
-		dev_err(dev, "Unable to set MSI-X resources for %d VFs\n",
-			num_vfs);
-		return -EINVAL;
+	err = ice_sriov_set_msix_res(pf, num_msix_per_vf * num_vfs);
+	if (err) {
+		dev_err(dev, "Unable to set MSI-X resources for %d VFs, err %d\n",
+			num_vfs, err);
+		return err;
 	}
 
 	/* only allow equal Tx/Rx queue count (i.e. queue pairs) */
@@ -2058,10 +2063,10 @@ static int ice_ena_vfs(struct ice_pf *pf, u16 num_vfs)
 
 	mutex_lock(&pf->vfs.table_lock);
 
-	if (ice_set_per_vf_res(pf, num_vfs)) {
-		dev_err(dev, "Not enough resources for %d VFs, try with fewer number of VFs\n",
-			num_vfs);
-		ret = -ENOSPC;
+	ret = ice_set_per_vf_res(pf, num_vfs);
+	if (ret) {
+		dev_err(dev, "Not enough resources for %d VFs, err %d. Try with fewer number of VFs\n",
+			num_vfs, ret);
 		goto err_unroll_sriov;
 	}
 
@@ -2072,8 +2077,9 @@ static int ice_ena_vfs(struct ice_pf *pf, u16 num_vfs)
 		goto err_unroll_sriov;
 	}
 
-	if (ice_start_vfs(pf)) {
-		dev_err(dev, "Failed to start VF(s)\n");
+	ret = ice_start_vfs(pf);
+	if (ret) {
+		dev_err(dev, "Failed to start %d VFs, err %d\n", num_vfs, ret);
 		ret = -EAGAIN;
 		goto err_unroll_vf_entries;
 	}
-- 
2.31.1

