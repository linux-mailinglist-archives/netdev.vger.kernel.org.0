Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4F74CC7B5
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 22:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236452AbiCCVPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 16:15:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236443AbiCCVP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 16:15:28 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B144F9D6
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 13:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646342082; x=1677878082;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=17X9WzRS8iOVJwmgFV3s8cTgGa0NwMgYvC+ieVuIBkc=;
  b=ISp/BVDGEpiJx66NimdjO6aaesNiZz1zIbjv7FoYDqsjRdNcU/m92Et6
   Fs33lBEZClDoAsNZWWZQDPY2Vn+Aq+pQ0w3EZqUk3mzbvA4+4QHUCqLiW
   cLco7Ww5Ts2c7e12FL0SJV78b/mwKiIXVk94zIaltA4iYhJ29UYTeI9Kr
   gfAgqkhdaSi+ilsHi//NbES6alxc4w+Bn4reCtuXE3mlZjlFhbVQkJciU
   cPUCbGLj6x/X5l7W6/RCelAj1rkNyvthozIVZnDjCvHkB0Ea7QzQBhKIa
   vB3Pm3tmJvu1rD4CBIFY/Oo+VlCO82NywEXXZNUHwt8MwLyzrnQcqUAU7
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="340245716"
X-IronPort-AV: E=Sophos;i="5.90,153,1643702400"; 
   d="scan'208";a="340245716"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 13:14:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,153,1643702400"; 
   d="scan'208";a="640347705"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 03 Mar 2022 13:14:40 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 05/11] ice: move VFLR acknowledge during ice_free_vfs
Date:   Thu,  3 Mar 2022 13:14:43 -0800
Message-Id: <20220303211449.899956-6-anthony.l.nguyen@intel.com>
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

After removing all VFs, the driver clears the VFLR indication for VFs.
This has been in ice since the beginning of SR-IOV support in the ice
driver.

The implementation was copied from i40e, and the motivation for the VFLR
indication clearing is described in the commit f7414531a0cf ("i40e:
acknowledge VFLR when disabling SR-IOV")

The commit explains that we need to clear the VFLR indication because
the virtual function undergoes a VFLR event. If we don't indicate that
it is complete it can cause an issue when VFs are re-enabled due to
a "phantom" VFLR.

The register block read was added under a pci_vfs_assigned check
originally. This was done because we added the check after calling
pci_disable_sriov. This was later moved to disable SRIOV earlier in the
flow so that the VF drivers could be torn down before we removed
functionality.

Move the VFLR acknowledge into the main loop that tears down VF
resources. This avoids using the tmp value for iterating over VFs
multiple times. The result will make it easier to refactor the VF array
in a future change.

It's possible we might want to modify this flow to also stop checking
pci_vfs_assigned. However, it seems reasonable to keep this change: we
should only clear the VFLR if we actually disabled SR-IOV.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 27 ++++++-------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index d46f7579c650..885de0675d2a 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -536,6 +536,14 @@ void ice_free_vfs(struct ice_pf *pf)
 			ice_free_vf_res(vf);
 		}
 
+		if (!pci_vfs_assigned(pf->pdev)) {
+			u32 reg_idx, bit_idx;
+
+			reg_idx = (hw->func_caps.vf_base_id + vf->vf_id) / 32;
+			bit_idx = (hw->func_caps.vf_base_id + vf->vf_id) % 32;
+			wr32(hw, GLGEN_VFLRSTAT(reg_idx), BIT(bit_idx));
+		}
+
 		/* clear malicious info since the VF is getting released */
 		if (ice_mbx_clear_malvf(&hw->mbx_snapshot, pf->malvfs,
 					ICE_MAX_VF_COUNT, vf->vf_id))
@@ -553,25 +561,6 @@ void ice_free_vfs(struct ice_pf *pf)
 	devm_kfree(dev, pf->vf);
 	pf->vf = NULL;
 
-	/* This check is for when the driver is unloaded while VFs are
-	 * assigned. Setting the number of VFs to 0 through sysfs is caught
-	 * before this function ever gets called.
-	 */
-	if (!pci_vfs_assigned(pf->pdev)) {
-		unsigned int vf_id;
-
-		/* Acknowledge VFLR for all VFs. Without this, VFs will fail to
-		 * work correctly when SR-IOV gets re-enabled.
-		 */
-		for (vf_id = 0; vf_id < tmp; vf_id++) {
-			u32 reg_idx, bit_idx;
-
-			reg_idx = (hw->func_caps.vf_base_id + vf_id) / 32;
-			bit_idx = (hw->func_caps.vf_base_id + vf_id) % 32;
-			wr32(hw, GLGEN_VFLRSTAT(reg_idx), BIT(bit_idx));
-		}
-	}
-
 	clear_bit(ICE_VF_DIS, pf->state);
 	clear_bit(ICE_FLAG_SRIOV_ENA, pf->flags);
 }
-- 
2.31.1

