Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F389068C8F2
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 22:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjBFVtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 16:49:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjBFVs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 16:48:59 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001C62DE59
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:48:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675720138; x=1707256138;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ma4tOXmmWbmm7p7m1g7FCKXWYe5kGtA01gfufizNgvw=;
  b=RtQLcuthrGjjD4E3VvLJYTqALZZPxjbVbTzwS/3VENvKTfMSLiAE0Woi
   bDD1KxRIVruuIKgfQ8saV0CT33mFdXrvjobkigQ3qeNlfGzqHWH0aT8cY
   g555vHvnEpacqNM7Dld9EsSOUBa4K1gQSehBa6OnuWa6geMRqYNG008My
   hSimoH9nMGwcGXk/0XYKsDtNcjv/pBV8bVK1Yt3bf0EV+uV0vDCfe1SIc
   sxogDWM0eYx0Q0fOu8qnRtnD5ChTDd5MjwcKouB4RnWWJFvS4vdwXpCg4
   5GWwTVVFGN4Kbd/Q06WGmoDHDwTz/1rjlwEYTRiTABq8VuVnHhGEVgeNx
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="317338135"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="317338135"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 13:48:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="616576206"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="616576206"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga003.jf.intel.com with ESMTP; 06 Feb 2023 13:48:33 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net-next 09/13] ice: introduce ice_vf_init_host_cfg function
Date:   Mon,  6 Feb 2023 13:48:09 -0800
Message-Id: <20230206214813.20107-10-anthony.l.nguyen@intel.com>
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

Introduce a new generic helper ice_vf_init_host_cfg which performs common
host configuration initialization tasks that will need to be done for both
Single Root IOV and the new Scalable IOV implementation.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c    | 36 +------------
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   | 54 +++++++++++++++++++
 .../ethernet/intel/ice/ice_vf_lib_private.h   |  1 +
 3 files changed, 57 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 6c07f661d44c..5450fa122729 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -573,51 +573,19 @@ static int ice_set_per_vf_res(struct ice_pf *pf, u16 num_vfs)
  */
 static int ice_init_vf_vsi_res(struct ice_vf *vf)
 {
-	struct ice_vsi_vlan_ops *vlan_ops;
 	struct ice_pf *pf = vf->pf;
-	u8 broadcast[ETH_ALEN];
 	struct ice_vsi *vsi;
-	struct device *dev;
 	int err;
 
 	vf->first_vector_idx = ice_calc_vf_first_vector_idx(pf, vf);
 
-	dev = ice_pf_to_dev(pf);
 	vsi = ice_vf_vsi_setup(vf);
 	if (!vsi)
 		return -ENOMEM;
 
-	err = ice_vsi_add_vlan_zero(vsi);
-	if (err) {
-		dev_warn(dev, "Failed to add VLAN 0 filter for VF %d\n",
-			 vf->vf_id);
-		goto release_vsi;
-	}
-
-	vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
-	err = vlan_ops->ena_rx_filtering(vsi);
-	if (err) {
-		dev_warn(dev, "Failed to enable Rx VLAN filtering for VF %d\n",
-			 vf->vf_id);
-		goto release_vsi;
-	}
-
-	eth_broadcast_addr(broadcast);
-	err = ice_fltr_add_mac(vsi, broadcast, ICE_FWD_TO_VSI);
-	if (err) {
-		dev_err(dev, "Failed to add broadcast MAC filter for VF %d, error %d\n",
-			vf->vf_id, err);
-		goto release_vsi;
-	}
-
-	err = ice_vsi_apply_spoofchk(vsi, vf->spoofchk);
-	if (err) {
-		dev_warn(dev, "Failed to initialize spoofchk setting for VF %d\n",
-			 vf->vf_id);
+	err = ice_vf_init_host_cfg(vf, vsi);
+	if (err)
 		goto release_vsi;
-	}
-
-	vf->num_mac = 1;
 
 	return 0;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index b6fd1e852968..c93d24fee60d 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -1174,6 +1174,60 @@ struct ice_vsi *ice_vf_ctrl_vsi_setup(struct ice_vf *vf)
 	return vsi;
 }
 
+/**
+ * ice_vf_init_host_cfg - Initialize host admin configuration
+ * @vf: VF to initialize
+ * @vsi: the VSI created at initialization
+ *
+ * Initialize the VF host configuration. Called during VF creation to setup
+ * VLAN 0, add the VF VSI broadcast filter, and setup spoof checking. It
+ * should only be called during VF creation.
+ */
+int ice_vf_init_host_cfg(struct ice_vf *vf, struct ice_vsi *vsi)
+{
+	struct ice_vsi_vlan_ops *vlan_ops;
+	struct ice_pf *pf = vf->pf;
+	u8 broadcast[ETH_ALEN];
+	struct device *dev;
+	int err;
+
+	dev = ice_pf_to_dev(pf);
+
+	err = ice_vsi_add_vlan_zero(vsi);
+	if (err) {
+		dev_warn(dev, "Failed to add VLAN 0 filter for VF %d\n",
+			 vf->vf_id);
+		return err;
+	}
+
+	vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
+	err = vlan_ops->ena_rx_filtering(vsi);
+	if (err) {
+		dev_warn(dev, "Failed to enable Rx VLAN filtering for VF %d\n",
+			 vf->vf_id);
+		return err;
+	}
+
+	eth_broadcast_addr(broadcast);
+	err = ice_fltr_add_mac(vsi, broadcast, ICE_FWD_TO_VSI);
+	if (err) {
+		dev_err(dev, "Failed to add broadcast MAC filter for VF %d, status %d\n",
+			vf->vf_id, err);
+		return err;
+	}
+
+	vf->num_mac = 1;
+
+	err = ice_vsi_apply_spoofchk(vsi, vf->spoofchk);
+	if (err) {
+		dev_warn(dev, "Failed to initialize spoofchk setting for VF %d\n",
+			 vf->vf_id);
+		return err;
+	}
+
+	return 0;
+}
+
 /**
  * ice_vf_invalidate_vsi - invalidate vsi_idx/vsi_num to remove VSI access
  * @vf: VF to remove access to VSI for
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib_private.h b/drivers/net/ethernet/intel/ice/ice_vf_lib_private.h
index 552d1d02982d..6f3293b793b5 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib_private.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib_private.h
@@ -36,6 +36,7 @@ void ice_vf_rebuild_host_cfg(struct ice_vf *vf);
 void ice_vf_ctrl_invalidate_vsi(struct ice_vf *vf);
 void ice_vf_ctrl_vsi_release(struct ice_vf *vf);
 struct ice_vsi *ice_vf_ctrl_vsi_setup(struct ice_vf *vf);
+int ice_vf_init_host_cfg(struct ice_vf *vf, struct ice_vsi *vsi);
 void ice_vf_invalidate_vsi(struct ice_vf *vf);
 void ice_vf_vsi_release(struct ice_vf *vf);
 void ice_vf_set_initialized(struct ice_vf *vf);
-- 
2.38.1

