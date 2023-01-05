Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5689865EA6F
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 13:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbjAEMJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 07:09:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbjAEMJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 07:09:08 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868D358F91
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 04:09:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672920547; x=1704456547;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tEdtkacBWgPOX605RJin9EqOtDc84r190wA88mhrugc=;
  b=VeY/+JwZTQK353QnpeBZ+qH+Gzei9UuuFwO8RlhAcayDymNn4NdsPM8D
   KjBrLuWRd6SPsIf4qCI9NVrCtLVKRRzE4PK4pc9V9Lc6BUGAjC4hXh38T
   5NygZCGy7SJ9xSRyLW0Q/dycSh4yhEKyTuUlP5zZKsWaRA3RaruM0EWfN
   0vfxi3+lQpKVsYO05eSzswwb5Uf8GUl0Xl0fCpX29abxk5NkyJWg3o2+S
   U6CWn4hn4f7L9mmAIG89gZJ6OO3KovDjERoUkWldg3iRl9TqUoyLQEuvJ
   hm/LzQbt4DIB8kPEwUbnooRgxofCUoVIXWW6+SGyFm17tNqUAY80Ysh2z
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="320896279"
X-IronPort-AV: E=Sophos;i="5.96,302,1665471600"; 
   d="scan'208";a="320896279"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2023 04:09:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="763109126"
X-IronPort-AV: E=Sophos;i="5.96,302,1665471600"; 
   d="scan'208";a="763109126"
Received: from amlin-018-068.igk.intel.com ([10.102.18.68])
  by fmsmga002.fm.intel.com with ESMTP; 05 Jan 2023 04:09:05 -0800
From:   Mateusz Palczewski <mateusz.palczewski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, leon@kernel.org,
        Mateusz Palczewski <mateusz.palczewski@intel.com>
Subject: [PATCH net v2] ice: Fix deadlock on the rtnl_mutex
Date:   Thu,  5 Jan 2023 07:05:18 -0500
Message-Id: <20230105120518.29776-1-mateusz.palczewski@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a deadlock on rtnl_mutex when attempting to take the lock
in unregister_netdev() after it has already been taken by
ethnl_set_channels(). This happened when unregister_netdev() was
called inside of ice_vsi_rebuild().
Fix that by removing the unregister_netdev() usage and replace it with
ice_vsi_clear_rings() that deallocates the tx and rx rings for the VSI.

Fixes: df0f847915b4 ("ice: Move common functions out of ice_main.c part 6/7")
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
---
 v2: Fixed goto unwind to remove code redundancy
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 35 ++++++++++++------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 94aa834cd9a6..e5e96dad3563 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3479,8 +3479,10 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 		ice_vsi_set_num_qs(vsi, NULL);
 
 	ret = ice_vsi_alloc_arrays(vsi);
-	if (ret < 0)
-		goto err_vsi;
+	if (ret < 0){
+		ice_vsi_clear(vsi);
+		goto err_reset;
+	}
 
 	ice_vsi_get_qs(vsi);
 
@@ -3489,16 +3491,19 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 
 	/* Initialize VSI struct elements and create VSI in FW */
 	ret = ice_vsi_init(vsi, init_vsi);
-	if (ret < 0)
-		goto err_vsi;
-
+	if (ret < 0){
+		ice_vsi_clear(vsi);
+		goto err_reset;
+	}
 	switch (vtype) {
 	case ICE_VSI_CTRL:
 	case ICE_VSI_SWITCHDEV_CTRL:
 	case ICE_VSI_PF:
 		ret = ice_vsi_alloc_q_vectors(vsi);
-		if (ret)
-			goto err_rings;
+		if (ret){
+			ice_vsi_clear_rings(vsi);
+			goto err_reset;
+		}
 
 		ret = ice_vsi_setup_vector_base(vsi);
 		if (ret)
@@ -3544,8 +3549,10 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 		break;
 	case ICE_VSI_VF:
 		ret = ice_vsi_alloc_q_vectors(vsi);
-		if (ret)
-			goto err_rings;
+		if (ret){
+			ice_vsi_clear_rings(vsi);
+			goto err_reset;
+		}
 
 		ret = ice_vsi_set_q_vectors_reg_idx(vsi);
 		if (ret)
@@ -3618,15 +3625,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 
 err_vectors:
 	ice_vsi_free_q_vectors(vsi);
-err_rings:
-	if (vsi->netdev) {
-		vsi->current_netdev_flags = 0;
-		unregister_netdev(vsi->netdev);
-		free_netdev(vsi->netdev);
-		vsi->netdev = NULL;
-	}
-err_vsi:
-	ice_vsi_clear(vsi);
+err_reset:
 	set_bit(ICE_RESET_FAILED, pf->state);
 	kfree(coalesce);
 	return ret;
-- 
2.31.1

