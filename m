Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9D964D8B60
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 19:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243641AbiCNSLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 14:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243597AbiCNSLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 14:11:08 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1431612A86
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 11:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647281398; x=1678817398;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qf5/J/BzXf1sJCnXPOqxDJIz0db3JOqoQgeSM83DioI=;
  b=AdEjsSsabtU/6cM1YpXcaxWqMftJU6rVCNWY30T34JG+gRhUR0FRuJH4
   /CbvVAYrPAEljRKCa0zqaGoqiL2xq49nApJOblUwUl2yw2gSqVmusukoG
   y2o4Ja8isL7W9Qo3I3qvDHW/QOiVai/EFxq5k8D03ABuuUywea52PcClS
   grwhFRhvmd3f3Mf18AENu3nmPs7Zu2xKJUip21zRYegZsArbxvHlwYyX1
   hEyuVV2Dm5Qc0/6IUXtK+Ny8oMEjztbIGzx5Uo4mWlVD0jl/xjTbTN8MT
   6Am9LuBh4W1bVWqIwTyn2A0d0sgBsnpeEnlAX7LwWbtmsVfkL3F/QtDNg
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="238275357"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="238275357"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 11:09:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="634297535"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Mar 2022 11:09:56 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 07/25] ice: refactor spoofchk control code in ice_sriov.c
Date:   Mon, 14 Mar 2022 11:09:58 -0700
Message-Id: <20220314181016.1690595-8-anthony.l.nguyen@intel.com>
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

The API to control the VSI spoof checking for a VF VSI has three
functions: enable, disable, and set. The set function takes the VSI and
the VF and decides whether to call enable or disable based on the
vf->spoofchk field.

In some flows, vf->spoofchk is not yet set, such as the function used to
control the setting for a VF. (vf->spoofchk is only updated after a
success).

Simplify this API by refactoring ice_vf_set_spoofchk_cfg to be
"ice_vsi_apply_spoofchk" which takes the boolean and allows all callers
to avoid having to determine whether to call enable or disable
themselves.

This matches the expected callers better, and will prevent the need to
export more than one function when this code must be called from another
file.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 7cd910bb7a7a..8d22b5d94706 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -985,16 +985,15 @@ static int ice_vsi_dis_spoofchk(struct ice_vsi *vsi)
 }
 
 /**
- * ice_vf_set_spoofchk_cfg - apply Tx spoof checking setting
- * @vf: VF set spoofchk for
+ * ice_vsi_apply_spoofchk - Apply Tx spoof checking setting to a VSI
  * @vsi: VSI associated to the VF
+ * @enable: whether to enable or disable the spoof checking
  */
-static int
-ice_vf_set_spoofchk_cfg(struct ice_vf *vf, struct ice_vsi *vsi)
+static int ice_vsi_apply_spoofchk(struct ice_vsi *vsi, bool enable)
 {
 	int err;
 
-	if (vf->spoofchk)
+	if (enable)
 		err = ice_vsi_ena_spoofchk(vsi);
 	else
 		err = ice_vsi_dis_spoofchk(vsi);
@@ -1478,7 +1477,7 @@ static void ice_vf_rebuild_host_cfg(struct ice_vf *vf)
 		dev_err(dev, "failed to rebuild Tx rate limiting configuration for VF %u\n",
 			vf->vf_id);
 
-	if (ice_vf_set_spoofchk_cfg(vf, vsi))
+	if (ice_vsi_apply_spoofchk(vsi, vf->spoofchk))
 		dev_err(dev, "failed to rebuild spoofchk configuration for VF %d\n",
 			vf->vf_id);
 
@@ -1915,7 +1914,7 @@ static int ice_init_vf_vsi_res(struct ice_vf *vf)
 		goto release_vsi;
 	}
 
-	err = ice_vf_set_spoofchk_cfg(vf, vsi);
+	err = ice_vsi_apply_spoofchk(vsi, vf->spoofchk);
 	if (err) {
 		dev_warn(dev, "Failed to initialize spoofchk setting for VF %d\n",
 			 vf->vf_id);
@@ -3129,10 +3128,7 @@ int ice_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool ena)
 		goto out_put_vf;
 	}
 
-	if (ena)
-		ret = ice_vsi_ena_spoofchk(vf_vsi);
-	else
-		ret = ice_vsi_dis_spoofchk(vf_vsi);
+	ret = ice_vsi_apply_spoofchk(vf_vsi, ena);
 	if (ret)
 		dev_err(dev, "Failed to set spoofchk %s for VF %d VSI %d\n error %d\n",
 			ena ? "ON" : "OFF", vf->vf_id, vf_vsi->vsi_num, ret);
-- 
2.31.1

