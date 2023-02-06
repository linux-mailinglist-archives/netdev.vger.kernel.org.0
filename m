Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21FE968C8F1
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 22:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjBFVtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 16:49:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjBFVs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 16:48:58 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430B22DE5C
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:48:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675720137; x=1707256137;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MDgKyy7PLtwC7en4Kl4yNXQe4GDZH5AE/p0uWrcgmzI=;
  b=gx/tCFMQ3J0pS3bhQfRIIzw8l9YiCoIRMjw6veCVyE1Z4bHMHHDweFdq
   IDOQLY+JQSx8pbZ3xJeNqfrvJLtYFGpQScwMbY8yRgq+M+F9r8AuHRos0
   LhXMm/UWpqhwMagIXYeuAWQsipJzewtjyy1b3BKpSIGQdOhYKQwO7DKcN
   93Ums7dNHJmz5VBOAoMb33CoCPda5yOI2IiuQ8zNY3Trl7A5aq3D3T/Fg
   ySxu297YWs+iQllh1ml9jgUapYJkV/AQBF4OQkdTBf6v6pjGbShQjuyoV
   Lz2RE3ivLdvKgUsjLrJTS/AnrXXvRn6/qLuF9M/J30CYttMtFAzC4Kszm
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="317338141"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="317338141"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 13:48:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="616576209"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="616576209"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga003.jf.intel.com with ESMTP; 06 Feb 2023 13:48:33 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net-next 10/13] ice: convert vf_ops .vsi_rebuild to .create_vsi
Date:   Mon,  6 Feb 2023 13:48:10 -0800
Message-Id: <20230206214813.20107-11-anthony.l.nguyen@intel.com>
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

The .vsi_rebuild function exists for ice_reset_vf. It is used to release
and re-create the VSI during a single-VF reset.

This function is only called when we need to re-create the VSI, and not
when rebuilding an existing VSI. This makes the single-VF reset process
different from the process used to restore functionality after a
hardware reset such as the PF reset or EMP reset.

When we add support for Scalable IOV VFs, the implementation will be very
similar. The primary difference will be in the fact that each VF type uses
a different underlying VSI type in hardware.

Move the common functionality into a new ice_vf_recreate VSI function. This
will allow the two IOV paths to share this functionality. Rework the
.vsi_rebuild vf_op into .create_vsi, only performing the task of creating a
new VSI.

This creates a nice dichotomy between the ice_vf_rebuild_vsi and
ice_vf_recreate_vsi, and should make it more clear why the two flows atre
distinct.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c  | 22 ++++++---------
 drivers/net/ethernet/intel/ice/ice_vf_lib.c | 31 ++++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_vf_lib.h |  2 +-
 3 files changed, 40 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 5450fa122729..46088c05d485 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -757,23 +757,19 @@ static void ice_sriov_clear_reset_trigger(struct ice_vf *vf)
 }
 
 /**
- * ice_sriov_vsi_rebuild - release and rebuild VF's VSI
- * @vf: VF to release and setup the VSI for
+ * ice_sriov_create_vsi - Create a new VSI for a VF
+ * @vf: VF to create the VSI for
  *
- * This is only called when a single VF is being reset (i.e. VFR, VFLR, host VF
- * configuration change, etc.).
+ * This is called by ice_vf_recreate_vsi to create the new VSI after the old
+ * VSI has been released.
  */
-static int ice_sriov_vsi_rebuild(struct ice_vf *vf)
+static int ice_sriov_create_vsi(struct ice_vf *vf)
 {
-	struct ice_pf *pf = vf->pf;
+	struct ice_vsi *vsi;
 
-	ice_vf_vsi_release(vf);
-	if (!ice_vf_vsi_setup(vf)) {
-		dev_err(ice_pf_to_dev(pf),
-			"Failed to release and setup the VF%u's VSI\n",
-			vf->vf_id);
+	vsi = ice_vf_vsi_setup(vf);
+	if (!vsi)
 		return -ENOMEM;
-	}
 
 	return 0;
 }
@@ -795,7 +791,7 @@ static const struct ice_vf_ops ice_sriov_vf_ops = {
 	.trigger_reset_register = ice_sriov_trigger_reset_register,
 	.poll_reset_status = ice_sriov_poll_reset_status,
 	.clear_reset_trigger = ice_sriov_clear_reset_trigger,
-	.vsi_rebuild = ice_sriov_vsi_rebuild,
+	.create_vsi = ice_sriov_create_vsi,
 	.post_vsi_rebuild = ice_sriov_post_vsi_rebuild,
 };
 
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index c93d24fee60d..1a5d64454f99 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -241,12 +241,41 @@ static void ice_vf_pre_vsi_rebuild(struct ice_vf *vf)
 	vf->vf_ops->clear_reset_trigger(vf);
 }
 
+/**
+ * ice_vf_recreate_vsi - Release and re-create the VF's VSI
+ * @vf: VF to recreate the VSI for
+ *
+ * This is only called when a single VF is being reset (i.e. VVF, VFLR, host
+ * VF configuration change, etc)
+ *
+ * It releases and then re-creates a new VSI.
+ */
+static int ice_vf_recreate_vsi(struct ice_vf *vf)
+{
+	struct ice_pf *pf = vf->pf;
+	int err;
+
+	ice_vf_vsi_release(vf);
+
+	err = vf->vf_ops->create_vsi(vf);
+	if (err) {
+		dev_err(ice_pf_to_dev(pf),
+			"Failed to recreate the VF%u's VSI, error %d\n",
+			vf->vf_id, err);
+		return err;
+	}
+
+	return 0;
+}
+
 /**
  * ice_vf_rebuild_vsi - rebuild the VF's VSI
  * @vf: VF to rebuild the VSI for
  *
  * This is only called when all VF(s) are being reset (i.e. PCIe Reset on the
  * host, PFR, CORER, etc.).
+ *
+ * It reprograms the VSI configuration back into hardware.
  */
 static int ice_vf_rebuild_vsi(struct ice_vf *vf)
 {
@@ -654,7 +683,7 @@ int ice_reset_vf(struct ice_vf *vf, u32 flags)
 
 	ice_vf_pre_vsi_rebuild(vf);
 
-	if (vf->vf_ops->vsi_rebuild(vf)) {
+	if (ice_vf_recreate_vsi(vf)) {
 		dev_err(dev, "Failed to release and setup the VF%u's VSI\n",
 			vf->vf_id);
 		err = -EFAULT;
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.h b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
index 52bd9a3816bf..e3d94f3ca40d 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
@@ -60,7 +60,7 @@ struct ice_vf_ops {
 	void (*trigger_reset_register)(struct ice_vf *vf, bool is_vflr);
 	bool (*poll_reset_status)(struct ice_vf *vf);
 	void (*clear_reset_trigger)(struct ice_vf *vf);
-	int (*vsi_rebuild)(struct ice_vf *vf);
+	int (*create_vsi)(struct ice_vf *vf);
 	void (*post_vsi_rebuild)(struct ice_vf *vf);
 };
 
-- 
2.38.1

