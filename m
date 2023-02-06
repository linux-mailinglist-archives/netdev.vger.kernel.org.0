Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEA1168C8F0
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 22:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjBFVtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 16:49:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbjBFVs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 16:48:58 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3D92DE58
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:48:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675720137; x=1707256137;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kMU5oZKtWBy7q0kPSyjBq8ZOAmjJkMvS7wJv1UIZCI0=;
  b=Uudic4piX1LCfL90y2M8kqVS2bXu17Rpx5RS8xsX1811cLTO6pu+ywHG
   F8Zi9lMtQmZw4J+3px7mCHdAApfZmLbbn61RcrhjPy8d3X+D3hYzkFePF
   6mr2XcYnJ6w3Sz3f2Pmfw8CP1yCYNcOyWq6OarReGwVwImJK6b5bZ99CL
   61y0VgqMRgc8TEjMNU6QTeM9dOxv6htKKtJJ/BhX5JKtcRDrPvcuKuslE
   Z9mNtEJrtlSnkdyl3kxOd2+lfyCC+ppR9OaxgXPhVVCSuHNJO1X2gBEik
   KB397FQveoTJATzJ2tXkm6BzJsHqWzKGFMU3jtrhZr36yp3uHKC+c9pLR
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="317338131"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="317338131"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 13:48:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="616576203"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="616576203"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga003.jf.intel.com with ESMTP; 06 Feb 2023 13:48:33 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net-next 08/13] ice: add a function to initialize vf entry
Date:   Mon,  6 Feb 2023 13:48:08 -0800
Message-Id: <20230206214813.20107-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230206214813.20107-1-anthony.l.nguyen@intel.com>
References: <20230206214813.20107-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Some of the initialization code for Single Root IOV VFs will need to be
reused when we introduce Scalable IOV. Pull this code out into a new
ice_initialize_vf_entry helper function.

Co-developed-by: Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>
Signed-off-by: Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c    | 16 ++----------
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   | 26 +++++++++++++++++++
 .../ethernet/intel/ice/ice_vf_lib_private.h   |  1 +
 3 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 6ff29be974c5..6c07f661d44c 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -867,21 +867,9 @@ static int ice_create_vf_entries(struct ice_pf *pf, u16 num_vfs)
 		/* set sriov vf ops for VFs created during SRIOV flow */
 		vf->vf_ops = &ice_sriov_vf_ops;
 
-		vf->vf_sw_id = pf->first_sw;
-		/* assign default capabilities */
-		vf->spoofchk = true;
-		vf->num_vf_qs = pf->vfs.num_qps_per;
-		ice_vc_set_default_allowlist(vf);
-
-		/* ctrl_vsi_idx will be set to a valid value only when VF
-		 * creates its first fdir rule.
-		 */
-		ice_vf_ctrl_invalidate_vsi(vf);
-		ice_vf_fdir_init(vf);
+		ice_initialize_vf_entry(vf);
 
-		ice_virtchnl_set_dflt_ops(vf);
-
-		mutex_init(&vf->cfg_lock);
+		vf->vf_sw_id = pf->first_sw;
 
 		hash_add_rcu(vfs->table, &vf->entry, vf_id);
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 624c7de8b205..b6fd1e852968 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -698,6 +698,32 @@ void ice_set_vf_state_qs_dis(struct ice_vf *vf)
 
 /* Private functions only accessed from other virtualization files */
 
+/**
+ * ice_initialize_vf_entry - Initialize a VF entry
+ * @vf: pointer to the VF structure
+ */
+void ice_initialize_vf_entry(struct ice_vf *vf)
+{
+	struct ice_pf *pf = vf->pf;
+	struct ice_vfs *vfs;
+
+	vfs = &pf->vfs;
+
+	/* assign default capabilities */
+	vf->spoofchk = true;
+	vf->num_vf_qs = vfs->num_qps_per;
+	ice_vc_set_default_allowlist(vf);
+	ice_virtchnl_set_dflt_ops(vf);
+
+	/* ctrl_vsi_idx will be set to a valid value only when iAVF
+	 * creates its first fdir rule.
+	 */
+	ice_vf_ctrl_invalidate_vsi(vf);
+	ice_vf_fdir_init(vf);
+
+	mutex_init(&vf->cfg_lock);
+}
+
 /**
  * ice_dis_vf_qs - Disable the VF queues
  * @vf: pointer to the VF structure
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib_private.h b/drivers/net/ethernet/intel/ice/ice_vf_lib_private.h
index a0f204746f4e..552d1d02982d 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib_private.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib_private.h
@@ -23,6 +23,7 @@
 #warning "Only include ice_vf_lib_private.h in CONFIG_PCI_IOV virtualization files"
 #endif
 
+void ice_initialize_vf_entry(struct ice_vf *vf);
 void ice_dis_vf_qs(struct ice_vf *vf);
 int ice_check_vf_init(struct ice_vf *vf);
 enum virtchnl_status_code ice_err_to_virt_err(int err);
-- 
2.38.1

