Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 989224D8B65
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 19:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243638AbiCNSLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 14:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243607AbiCNSLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 14:11:13 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9AE28E2E
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 11:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647281399; x=1678817399;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fQ1i1BT+CQJb/jDxwNdCsdcGLnYGepjo/CSlY/IUaVU=;
  b=I5LPk1XLBfYpXhWG/We0eBGdqsrVYnu7gRJ4SB7CqO7jvDGHkU8bv/Kg
   WLsh34E0hxfAv65FnAK9iSLV5+oRgjK1Kf1zI7aPXzACvKM4ni4uwaqyL
   T0gdKX8bbQr43nZC82vTd4S/fip5T/L7sC2AR2biwV6v3zUi4sUMu7HG8
   rMOEQaWn5qBgyeDfwFE65e3ncLckje6mEuN1gwVCd/EGar/wxDxx0t8Ix
   kyIbRldyFu34rbeZY0r85CuHbx1mRDgL4sFGx0unqvbswKjjrQ8iMVIZJ
   mAz8EFMkRYjM3oMzy7/yH5J0WiHnHLjw9LOU1dOB6SS4k6TPCimuka0uI
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="238275373"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="238275373"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 11:09:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="634297584"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Mar 2022 11:09:58 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 11/25] ice: use ice_is_vf_trusted helper function
Date:   Mon, 14 Mar 2022 11:10:02 -0700
Message-Id: <20220314181016.1690595-12-anthony.l.nguyen@intel.com>
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

The ice_vc_cfg_promiscuous_mode_msg function directly checks
ICE_VIRTCHNL_VF_CAP_PRIVILEGE, instead of using the existing helper
function ice_is_vf_trusted. Switch this to use the helper function so
that all trusted checks are consistent. This aids in any potential
future refactor by ensuring consistent code.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index d41fce16ddfb..432841ab4352 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -3148,6 +3148,15 @@ int ice_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool ena)
 	return ret;
 }
 
+/**
+ * ice_is_vf_trusted
+ * @vf: pointer to the VF info
+ */
+static bool ice_is_vf_trusted(struct ice_vf *vf)
+{
+	return test_bit(ICE_VIRTCHNL_VF_CAP_PRIVILEGE, &vf->vf_caps);
+}
+
 /**
  * ice_is_any_vf_in_promisc - check if any VF(s) are in promiscuous mode
  * @pf: PF structure for accessing VF(s)
@@ -3212,7 +3221,7 @@ static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 	}
 
 	dev = ice_pf_to_dev(pf);
-	if (!test_bit(ICE_VIRTCHNL_VF_CAP_PRIVILEGE, &vf->vf_caps)) {
+	if (!ice_is_vf_trusted(vf)) {
 		dev_err(dev, "Unprivileged VF %d is attempting to configure promiscuous mode\n",
 			vf->vf_id);
 		/* Leave v_ret alone, lie to the VF on purpose. */
@@ -3862,15 +3871,6 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 				     NULL, 0);
 }
 
-/**
- * ice_is_vf_trusted
- * @vf: pointer to the VF info
- */
-static bool ice_is_vf_trusted(struct ice_vf *vf)
-{
-	return test_bit(ICE_VIRTCHNL_VF_CAP_PRIVILEGE, &vf->vf_caps);
-}
-
 /**
  * ice_can_vf_change_mac
  * @vf: pointer to the VF info
-- 
2.31.1

