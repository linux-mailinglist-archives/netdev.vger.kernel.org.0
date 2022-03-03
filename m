Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B364CC7B1
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 22:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236436AbiCCVP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 16:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236439AbiCCVP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 16:15:27 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B286E36C
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 13:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646342081; x=1677878081;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=91agjJLW9JJkgfh7BrfzqXzUbK9FPgl6pCyorL4ryiI=;
  b=WEmMQ2bUh6bCaJLEB+8K4my0r5ArV4oU5QkkdoJICDV3aMmHgGkqLAsh
   2gfVHD+tfgyqzWe3yoPjogC6dLtGkrqUE9IzRZB8hy63JtKwLn+Huq3Ln
   LdQW2Tai6OvjZ8rVxF13DGcNWpxoZqoX+w5xMJdvoSqWd2dt9xtM8un8k
   yBDO/jpGpHsJNodagN4xzOoxCkFOSLr446jPzNm0CzV6Wt+0v7DU9xpkQ
   I7UQ4/wwlA1XMmC5N2FnMDmtJKQGQ30CTlI3MIH/nknKwA20di8Wzphy+
   N5cqSNdGVR0qITxMQ/i9LlgW7Jr4JNCTIbk2LB3jBFAriICOyxnabQeQe
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="340245708"
X-IronPort-AV: E=Sophos;i="5.90,153,1643702400"; 
   d="scan'208";a="340245708"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 13:14:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,153,1643702400"; 
   d="scan'208";a="640347693"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 03 Mar 2022 13:14:39 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 03/11] ice: pass num_vfs to ice_set_per_vf_res()
Date:   Thu,  3 Mar 2022 13:14:41 -0800
Message-Id: <20220303211449.899956-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220303211449.899956-1-anthony.l.nguyen@intel.com>
References: <20220303211449.899956-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

We are planning to replace the simple array structure tracking VFs with
a hash table. This change will also remove the "num_alloc_vfs" variable.

Instead, new access functions to use the hash table as the source of
truth will be introduced. These will generally be equivalent to existing
checks, except during VF initialization.

Specifically, ice_set_per_vf_res() cannot use the hash table as it will
be operating prior to VF structures being inserted into the hash table.

Instead of using pf->num_alloc_vfs, simply pass the num_vfs value in
from the caller.

Note that a sub-function of ice_set_per_vf_res, ice_determine_res, also
implicitly depends on pf->num_alloc_vfs. Replace ice_determine_res with
a simpler inline implementation based on rounddown_pow_of_two. Note that
we must explicitly check that the argument is non-zero since it does not
play well with zero as a value.

Instead of using the function and while loop, simply calculate the
number of queues we have available by dividing by num_vfs. Check if the
desired queues are available. If not, round down to the nearest power of
2 that fits within our available queues.

This matches the behavior of ice_determine_res but is easier to follow
as simple in-line logic. Remove ice_determine_res entirely.

With this change, we no longer depend on the pf->num_alloc_vfs during
the initialization phase of VFs. This will allow us to safely remove it
in a future planned refactor of the VF data structures.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 87 ++++++-------------
 1 file changed, 26 insertions(+), 61 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 8955a2873d57..9ee2b3ebe486 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1069,45 +1069,6 @@ static void ice_ena_vf_mappings(struct ice_vf *vf)
 	ice_ena_vf_q_mappings(vf, vsi->alloc_txq, vsi->alloc_rxq);
 }
 
-/**
- * ice_determine_res
- * @pf: pointer to the PF structure
- * @avail_res: available resources in the PF structure
- * @max_res: maximum resources that can be given per VF
- * @min_res: minimum resources that can be given per VF
- *
- * Returns non-zero value if resources (queues/vectors) are available or
- * returns zero if PF cannot accommodate for all num_alloc_vfs.
- */
-static int
-ice_determine_res(struct ice_pf *pf, u16 avail_res, u16 max_res, u16 min_res)
-{
-	bool checked_min_res = false;
-	int res;
-
-	/* start by checking if PF can assign max number of resources for
-	 * all num_alloc_vfs.
-	 * if yes, return number per VF
-	 * If no, divide by 2 and roundup, check again
-	 * repeat the loop till we reach a point where even minimum resources
-	 * are not available, in that case return 0
-	 */
-	res = max_res;
-	while ((res >= min_res) && !checked_min_res) {
-		int num_all_res;
-
-		num_all_res = pf->num_alloc_vfs * res;
-		if (num_all_res <= avail_res)
-			return res;
-
-		if (res == min_res)
-			checked_min_res = true;
-
-		res = DIV_ROUND_UP(res, 2);
-	}
-	return 0;
-}
-
 /**
  * ice_calc_vf_reg_idx - Calculate the VF's register index in the PF space
  * @vf: VF to calculate the register index for
@@ -1187,6 +1148,7 @@ static int ice_sriov_set_msix_res(struct ice_pf *pf, u16 num_msix_needed)
 /**
  * ice_set_per_vf_res - check if vectors and queues are available
  * @pf: pointer to the PF structure
+ * @num_vfs: the number of SR-IOV VFs being configured
  *
  * First, determine HW interrupts from common pool. If we allocate fewer VFs, we
  * get more vectors and can enable more queues per VF. Note that this does not
@@ -1205,20 +1167,20 @@ static int ice_sriov_set_msix_res(struct ice_pf *pf, u16 num_msix_needed)
  * Lastly, set queue and MSI-X VF variables tracked by the PF so it can be used
  * by each VF during VF initialization and reset.
  */
-static int ice_set_per_vf_res(struct ice_pf *pf)
+static int ice_set_per_vf_res(struct ice_pf *pf, u16 num_vfs)
 {
 	int max_valid_res_idx = ice_get_max_valid_res_idx(pf->irq_tracker);
+	u16 num_msix_per_vf, num_txq, num_rxq, avail_qs;
 	int msix_avail_per_vf, msix_avail_for_sriov;
 	struct device *dev = ice_pf_to_dev(pf);
-	u16 num_msix_per_vf, num_txq, num_rxq;
 
-	if (!pf->num_alloc_vfs || max_valid_res_idx < 0)
+	if (!num_vfs || max_valid_res_idx < 0)
 		return -EINVAL;
 
 	/* determine MSI-X resources per VF */
 	msix_avail_for_sriov = pf->hw.func_caps.common_cap.num_msix_vectors -
 		pf->irq_tracker->num_entries;
-	msix_avail_per_vf = msix_avail_for_sriov / pf->num_alloc_vfs;
+	msix_avail_per_vf = msix_avail_for_sriov / num_vfs;
 	if (msix_avail_per_vf >= ICE_NUM_VF_MSIX_MED) {
 		num_msix_per_vf = ICE_NUM_VF_MSIX_MED;
 	} else if (msix_avail_per_vf >= ICE_NUM_VF_MSIX_SMALL) {
@@ -1230,32 +1192,35 @@ static int ice_set_per_vf_res(struct ice_pf *pf)
 	} else {
 		dev_err(dev, "Only %d MSI-X interrupts available for SR-IOV. Not enough to support minimum of %d MSI-X interrupts per VF for %d VFs\n",
 			msix_avail_for_sriov, ICE_MIN_INTR_PER_VF,
-			pf->num_alloc_vfs);
+			num_vfs);
 		return -EIO;
 	}
 
-	/* determine queue resources per VF */
-	num_txq = ice_determine_res(pf, ice_get_avail_txq_count(pf),
-				    min_t(u16,
-					  num_msix_per_vf - ICE_NONQ_VECS_VF,
-					  ICE_MAX_RSS_QS_PER_VF),
-				    ICE_MIN_QS_PER_VF);
+	num_txq = min_t(u16, num_msix_per_vf - ICE_NONQ_VECS_VF,
+			ICE_MAX_RSS_QS_PER_VF);
+	avail_qs = ice_get_avail_txq_count(pf) / num_vfs;
+	if (!avail_qs)
+		num_txq = 0;
+	else if (num_txq > avail_qs)
+		num_txq = rounddown_pow_of_two(avail_qs);
 
-	num_rxq = ice_determine_res(pf, ice_get_avail_rxq_count(pf),
-				    min_t(u16,
-					  num_msix_per_vf - ICE_NONQ_VECS_VF,
-					  ICE_MAX_RSS_QS_PER_VF),
-				    ICE_MIN_QS_PER_VF);
+	num_rxq = min_t(u16, num_msix_per_vf - ICE_NONQ_VECS_VF,
+			ICE_MAX_RSS_QS_PER_VF);
+	avail_qs = ice_get_avail_rxq_count(pf) / num_vfs;
+	if (!avail_qs)
+		num_rxq = 0;
+	else if (num_rxq > avail_qs)
+		num_rxq = rounddown_pow_of_two(avail_qs);
 
-	if (!num_txq || !num_rxq) {
+	if (num_txq < ICE_MIN_QS_PER_VF || num_rxq < ICE_MIN_QS_PER_VF) {
 		dev_err(dev, "Not enough queues to support minimum of %d queue pairs per VF for %d VFs\n",
-			ICE_MIN_QS_PER_VF, pf->num_alloc_vfs);
+			ICE_MIN_QS_PER_VF, num_vfs);
 		return -EIO;
 	}
 
-	if (ice_sriov_set_msix_res(pf, num_msix_per_vf * pf->num_alloc_vfs)) {
+	if (ice_sriov_set_msix_res(pf, num_msix_per_vf * num_vfs)) {
 		dev_err(dev, "Unable to set MSI-X resources for %d VFs\n",
-			pf->num_alloc_vfs);
+			num_vfs);
 		return -EINVAL;
 	}
 
@@ -1263,7 +1228,7 @@ static int ice_set_per_vf_res(struct ice_pf *pf)
 	pf->num_qps_per_vf = min_t(int, num_txq, num_rxq);
 	pf->num_msix_per_vf = num_msix_per_vf;
 	dev_info(dev, "Enabling %d VFs with %d vectors and %d queues per VF\n",
-		 pf->num_alloc_vfs, pf->num_msix_per_vf, pf->num_qps_per_vf);
+		 num_vfs, pf->num_msix_per_vf, pf->num_qps_per_vf);
 
 	return 0;
 }
@@ -1977,7 +1942,7 @@ static int ice_ena_vfs(struct ice_pf *pf, u16 num_vfs)
 	if (ret)
 		goto err_pci_disable_sriov;
 
-	if (ice_set_per_vf_res(pf)) {
+	if (ice_set_per_vf_res(pf, num_vfs)) {
 		dev_err(dev, "Not enough resources for %d VFs, try with fewer number of VFs\n",
 			num_vfs);
 		ret = -ENOSPC;
-- 
2.31.1

