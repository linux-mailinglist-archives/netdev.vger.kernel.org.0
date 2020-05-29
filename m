Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3EF1E7120
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 02:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438035AbgE2AJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 20:09:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:47400 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437974AbgE2AIf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 20:08:35 -0400
IronPort-SDR: OVNP0Db0mNiVQtYJco5ULrCITm9NkdJeBbGprDm4w92DzUHxZGwGELGSLydstb61xW5tdC1HdU
 EVDGUrED0NAg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 17:08:34 -0700
IronPort-SDR: GOHl3jA1GUYH4jKQdAnZ1HKpLfWEYjCaNv99Xd0JQXwQCawzHQ8lAV9djymUIoD3ymhTtjMKmD
 vJ1lhjB7/lpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,446,1583222400"; 
   d="scan'208";a="302651645"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 28 May 2020 17:08:34 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 10/15] ice: Renaming and simplification in VF init path
Date:   Thu, 28 May 2020 17:08:26 -0700
Message-Id: <20200529000831.2803870-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529000831.2803870-1-jeffrey.t.kirsher@intel.com>
References: <20200529000831.2803870-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Some function names weren't very clear and some portions of VF creation
could be moved into functions for clarity. Fix this by renaming some
functions and move pieces of code into clearly name functions.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 83 ++++++++++++-------
 1 file changed, 54 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 72a9da3164d9..92a442ec7314 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1469,16 +1469,56 @@ static int ice_start_vfs(struct ice_pf *pf)
 }
 
 /**
- * ice_alloc_vfs - Allocate and set up VFs resources
+ * ice_set_dflt_settings - set VF defaults during initialization/creation
+ * @pf: PF holding reference to all VFs for default configuration
+ */
+static void ice_set_dflt_settings_vfs(struct ice_pf *pf)
+{
+	int i;
+
+	ice_for_each_vf(pf, i) {
+		struct ice_vf *vf = &pf->vf[i];
+
+		vf->pf = pf;
+		vf->vf_id = i;
+		vf->vf_sw_id = pf->first_sw;
+		/* assign default capabilities */
+		set_bit(ICE_VIRTCHNL_VF_CAP_L2, &vf->vf_caps);
+		vf->spoofchk = true;
+		vf->num_vf_qs = pf->num_qps_per_vf;
+	}
+}
+
+/**
+ * ice_alloc_vfs - allocate num_vfs in the PF structure
+ * @pf: PF to store the allocated VFs in
+ * @num_vfs: number of VFs to allocate
+ */
+static int ice_alloc_vfs(struct ice_pf *pf, int num_vfs)
+{
+	struct ice_vf *vfs;
+
+	vfs = devm_kcalloc(ice_pf_to_dev(pf), num_vfs, sizeof(*vfs),
+			   GFP_KERNEL);
+	if (!vfs)
+		return -ENOMEM;
+
+	pf->vf = vfs;
+	pf->num_alloc_vfs = num_vfs;
+
+	return 0;
+}
+
+/**
+ * ice_ena_vfs - enable VFs so they are ready to be used
  * @pf: pointer to the PF structure
- * @num_alloc_vfs: number of VFs to allocate
+ * @num_vfs: number of VFs to enable
  */
-static int ice_alloc_vfs(struct ice_pf *pf, u16 num_alloc_vfs)
+static int ice_ena_vfs(struct ice_pf *pf, u16 num_vfs)
 {
 	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_hw *hw = &pf->hw;
-	struct ice_vf *vfs;
-	int i, ret;
+	int ret;
 
 	/* Disable global interrupt 0 so we don't try to handle the VFLR. */
 	wr32(hw, GLINT_DYN_CTL(pf->oicr_idx),
@@ -1486,38 +1526,24 @@ static int ice_alloc_vfs(struct ice_pf *pf, u16 num_alloc_vfs)
 	set_bit(__ICE_OICR_INTR_DIS, pf->state);
 	ice_flush(hw);
 
-	ret = pci_enable_sriov(pf->pdev, num_alloc_vfs);
+	ret = pci_enable_sriov(pf->pdev, num_vfs);
 	if (ret) {
 		pf->num_alloc_vfs = 0;
 		goto err_unroll_intr;
 	}
-	/* allocate memory */
-	vfs = devm_kcalloc(dev, num_alloc_vfs, sizeof(*vfs), GFP_KERNEL);
-	if (!vfs) {
-		ret = -ENOMEM;
+
+	ret = ice_alloc_vfs(pf, num_vfs);
+	if (ret)
 		goto err_pci_disable_sriov;
-	}
-	pf->vf = vfs;
-	pf->num_alloc_vfs = num_alloc_vfs;
 
 	if (ice_set_per_vf_res(pf)) {
 		dev_err(dev, "Not enough resources for %d VFs, try with fewer number of VFs\n",
-			num_alloc_vfs);
+			num_vfs);
 		ret = -ENOSPC;
 		goto err_unroll_sriov;
 	}
 
-	/* apply default profile */
-	ice_for_each_vf(pf, i) {
-		vfs[i].pf = pf;
-		vfs[i].vf_sw_id = pf->first_sw;
-		vfs[i].vf_id = i;
-
-		/* assign default capabilities */
-		set_bit(ICE_VIRTCHNL_VF_CAP_L2, &vfs[i].vf_caps);
-		vfs[i].spoofchk = true;
-		vfs[i].num_vf_qs = pf->num_qps_per_vf;
-	}
+	ice_set_dflt_settings_vfs(pf);
 
 	if (ice_start_vfs(pf)) {
 		dev_err(dev, "Failed to start VF(s)\n");
@@ -1529,9 +1555,8 @@ static int ice_alloc_vfs(struct ice_pf *pf, u16 num_alloc_vfs)
 	return 0;
 
 err_unroll_sriov:
+	devm_kfree(dev, pf->vf);
 	pf->vf = NULL;
-	devm_kfree(dev, vfs);
-	vfs = NULL;
 	pf->num_alloc_vfs = 0;
 err_pci_disable_sriov:
 	pci_disable_sriov(pf->pdev);
@@ -1591,8 +1616,8 @@ static int ice_pci_sriov_ena(struct ice_pf *pf, int num_vfs)
 		return -EOPNOTSUPP;
 	}
 
-	dev_info(dev, "Allocating %d VFs\n", num_vfs);
-	err = ice_alloc_vfs(pf, num_vfs);
+	dev_info(dev, "Enabling %d VFs\n", num_vfs);
+	err = ice_ena_vfs(pf, num_vfs);
 	if (err) {
 		dev_err(dev, "Failed to enable SR-IOV: %d\n", err);
 		return err;
-- 
2.26.2

