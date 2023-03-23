Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE7086C682E
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 13:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbjCWMZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 08:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbjCWMYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 08:24:55 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B061D93C
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 05:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679574291; x=1711110291;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BiKWK+J5z1UJnmnkO5UzwlDwumzI3imIdU0SWeqs0Kk=;
  b=aJGLPwqyXOGU9Bbeq7t7YQ8iG+MUqw+4FYmDfGWjGZ0iH97W+wgVUYDA
   xY1v7I1/UZpSgvWR1PVjT81jcY1caTUi3A0b74TK9F2LO56y3r3GyqKa9
   JmrVE41zadQ/6ZszF9qa1PXSeO3Mid6/IrOuDRhjffkVLrToYSON3x5y2
   mkdhkpWZT5JbCW80RAeXVoSXYn5oda/BpDSwO4Qg9utUKMopmovSJmsri
   38G8V2NUp7RRzMKfPNCkW4jUiixrvx8ZjhaMXqcxOGwGXDOYiDW6brA8e
   09DXLXH9FGO/tobwce7wtYHziAQa0xGDbQr9zN4LWE5ddSmZnOdaF6fz5
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="319125453"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="319125453"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 05:24:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="751473491"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="751473491"
Received: from nimitz.igk.intel.com ([10.102.21.231])
  by fmsmga004.fm.intel.com with ESMTP; 23 Mar 2023 05:24:49 -0700
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, michal.swiatkowski@intel.com,
        shiraz.saleem@intel.com, jacob.e.keller@intel.com,
        sridhar.samudrala@intel.com, jesse.brandeburg@intel.com,
        aleksander.lobakin@intel.com, lukasz.czapnik@intel.com,
        Piotr Raczynski <piotr.raczynski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH net-next v3 5/8] ice: remove redundant SRIOV code
Date:   Thu, 23 Mar 2023 13:24:37 +0100
Message-Id: <20230323122440.3419214-6-piotr.raczynski@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230323122440.3419214-1-piotr.raczynski@intel.com>
References: <20230323122440.3419214-1-piotr.raczynski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove redundant code from ice_get_max_valid_res_idx that has no effect.
ice_pf::irq_tracker is initialized during driver probe, there is no reason
to check it again. Also it is not possible for pf::sriov_base_vector to be
lower than the tracker length, remove WARN_ON that will never happen.

Get rid of ice_get_max_valid_res_idx helper function completely since it
can never return negative value.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c | 36 ----------------------
 1 file changed, 36 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index f1dca59bd844..65f971b74717 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -135,18 +135,9 @@ static void ice_dis_vf_mappings(struct ice_vf *vf)
  */
 static int ice_sriov_free_msix_res(struct ice_pf *pf)
 {
-	struct ice_res_tracker *res;
-
 	if (!pf)
 		return -EINVAL;
 
-	res = pf->irq_tracker;
-	if (!res)
-		return -EINVAL;
-
-	/* give back irq_tracker resources used */
-	WARN_ON(pf->sriov_base_vector < res->num_entries);
-
 	pf->sriov_base_vector = 0;
 
 	return 0;
@@ -409,29 +400,6 @@ int ice_calc_vf_reg_idx(struct ice_vf *vf, struct ice_q_vector *q_vector)
 		q_vector->v_idx + 1;
 }
 
-/**
- * ice_get_max_valid_res_idx - Get the max valid resource index
- * @res: pointer to the resource to find the max valid index for
- *
- * Start from the end of the ice_res_tracker and return right when we find the
- * first res->list entry with the ICE_RES_VALID_BIT set. This function is only
- * valid for SR-IOV because it is the only consumer that manipulates the
- * res->end and this is always called when res->end is set to res->num_entries.
- */
-static int ice_get_max_valid_res_idx(struct ice_res_tracker *res)
-{
-	int i;
-
-	if (!res)
-		return -EINVAL;
-
-	for (i = res->num_entries - 1; i >= 0; i--)
-		if (res->list[i] & ICE_RES_VALID_BIT)
-			return i;
-
-	return 0;
-}
-
 /**
  * ice_sriov_set_msix_res - Set any used MSIX resources
  * @pf: pointer to PF structure
@@ -490,7 +458,6 @@ static int ice_sriov_set_msix_res(struct ice_pf *pf, u16 num_msix_needed)
  */
 static int ice_set_per_vf_res(struct ice_pf *pf, u16 num_vfs)
 {
-	int max_valid_res_idx = ice_get_max_valid_res_idx(pf->irq_tracker);
 	u16 num_msix_per_vf, num_txq, num_rxq, avail_qs;
 	int msix_avail_per_vf, msix_avail_for_sriov;
 	struct device *dev = ice_pf_to_dev(pf);
@@ -501,9 +468,6 @@ static int ice_set_per_vf_res(struct ice_pf *pf, u16 num_vfs)
 	if (!num_vfs)
 		return -EINVAL;
 
-	if (max_valid_res_idx < 0)
-		return -ENOSPC;
-
 	/* determine MSI-X resources per VF */
 	msix_avail_for_sriov = pf->hw.func_caps.common_cap.num_msix_vectors -
 		pf->irq_tracker->num_entries;
-- 
2.38.1

