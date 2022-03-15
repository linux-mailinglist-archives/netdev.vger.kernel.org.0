Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31AB74D920F
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 02:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344181AbiCOBNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 21:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344178AbiCOBMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 21:12:54 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E17746B0F
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 18:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647306701; x=1678842701;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fQ1i1BT+CQJb/jDxwNdCsdcGLnYGepjo/CSlY/IUaVU=;
  b=DdgVw924JQvWRJ5TmoZ3Qli44Frz7q2hiVoRKWBYKLchjhoLjRQLgbWC
   41fk+QePMz2dpd8jwHRyEAEt2XxNGb0mmmIL0zQcQ6Bllzcz4fuSxyAQ9
   fqwZP08x0YygupUklvazIifu0AvDn/11NJM3P/3API2pCscMVtz9qxDX3
   pA4q+g+G7eW8lvt3kMXxVrFeUDg78Szo3i+NoEGoVNSu+K+vvrGdXeVOq
   8wMFLsOKt9cyfJMrzhEOpvHPzwiLBGJ4gZ3HDBKrTj4f96T7tOoEg+oFU
   oc1ub2nqBo3PL05wUtjiFuABhWSG0HsfBXaoKB33JPRa6/NLJee6MSUwh
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="236790473"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="236790473"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 18:11:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="540222908"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 14 Mar 2022 18:11:34 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next v2 11/11] ice: use ice_is_vf_trusted helper function
Date:   Mon, 14 Mar 2022 18:11:55 -0700
Message-Id: <20220315011155.2166817-12-anthony.l.nguyen@intel.com>
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

