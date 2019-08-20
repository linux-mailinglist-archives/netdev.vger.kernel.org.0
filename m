Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4584196BCB
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 23:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730912AbfHTVvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 17:51:10 -0400
Received: from mga05.intel.com ([192.55.52.43]:28767 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730092AbfHTVuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 17:50:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 14:50:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,410,1559545200"; 
   d="scan'208";a="183330507"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 20 Aug 2019 14:50:49 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v3 03/14] ice: Restructure VFs initialization flows
Date:   Tue, 20 Aug 2019 14:50:37 -0700
Message-Id: <20190820215048.14377-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820215048.14377-1-jeffrey.t.kirsher@intel.com>
References: <20190820215048.14377-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>

This patch restructures how VFs are configured, and resources allocated.
Instead of freeing resources that were never allocated, and resetting
empty VFs that have never been created - the new flow will just allocate
resources for number of requested VFs based on the availability.

During VFs initialization process, global interrupt is disabled, and
rearmed after getting MSIX vectors for VFs. This allows immediate mailbox
communications, instead of delaying it till later and VFs.
PF communications resulted to using polling instead of actual interrupt.
The issue manifested when creating higher number of VFs (128 VFs) per PF.

Signed-off-by: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |  1 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 69 +++++++++++++------
 2 files changed, 48 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 794d97460fc7..bde0b3617d9b 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -220,6 +220,7 @@ enum ice_state {
 	__ICE_CFG_BUSY,
 	__ICE_SERVICE_SCHED,
 	__ICE_SERVICE_DIS,
+	__ICE_OICR_INTR_DIS,		/* Global OICR interrupt disabled */
 	__ICE_STATE_NBITS		/* must be last */
 };
 
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index ce01cbe70ea4..93b835a24bb1 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -974,6 +974,47 @@ ice_vf_set_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m,
 	return status;
 }
 
+/**
+ * ice_config_res_vfs - Finalize allocation of VFs resources in one go
+ * @pf: pointer to the PF structure
+ *
+ * This function is being called as last part of resetting all VFs, or when
+ * configuring VFs for the first time, where there is no resource to be freed
+ * Returns true if resources were properly allocated for all VFs, and false
+ * otherwise.
+ */
+static bool ice_config_res_vfs(struct ice_pf *pf)
+{
+	struct ice_hw *hw = &pf->hw;
+	int v;
+
+	if (ice_check_avail_res(pf)) {
+		dev_err(&pf->pdev->dev,
+			"Cannot allocate VF resources, try with fewer number of VFs\n");
+		return false;
+	}
+
+	/* rearm global interrupts */
+	if (test_and_clear_bit(__ICE_OICR_INTR_DIS, pf->state))
+		ice_irq_dynamic_ena(hw, NULL, NULL);
+
+	/* Finish resetting each VF and allocate resources */
+	for (v = 0; v < pf->num_alloc_vfs; v++) {
+		struct ice_vf *vf = &pf->vf[v];
+
+		vf->num_vf_qs = pf->num_vf_qps;
+		dev_dbg(&pf->pdev->dev,
+			"VF-id %d has %d queues configured\n",
+			vf->vf_id, vf->num_vf_qs);
+		ice_cleanup_and_realloc_vf(vf);
+	}
+
+	ice_flush(hw);
+	clear_bit(__ICE_VF_DIS, pf->state);
+
+	return true;
+}
+
 /**
  * ice_reset_all_vfs - reset all allocated VFs in one go
  * @pf: pointer to the PF structure
@@ -1066,25 +1107,8 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 		dev_err(&pf->pdev->dev,
 			"Failed to free MSIX resources used by SR-IOV\n");
 
-	if (ice_check_avail_res(pf)) {
-		dev_err(&pf->pdev->dev,
-			"Cannot allocate VF resources, try with fewer number of VFs\n");
+	if (!ice_config_res_vfs(pf))
 		return false;
-	}
-
-	/* Finish the reset on each VF */
-	for (v = 0; v < pf->num_alloc_vfs; v++) {
-		vf = &pf->vf[v];
-
-		vf->num_vf_qs = pf->num_vf_qps;
-		dev_dbg(&pf->pdev->dev,
-			"VF-id %d has %d queues configured\n",
-			vf->vf_id, vf->num_vf_qs);
-		ice_cleanup_and_realloc_vf(vf);
-	}
-
-	ice_flush(hw);
-	clear_bit(__ICE_VF_DIS, pf->state);
 
 	return true;
 }
@@ -1249,7 +1273,7 @@ static int ice_alloc_vfs(struct ice_pf *pf, u16 num_alloc_vfs)
 	/* Disable global interrupt 0 so we don't try to handle the VFLR. */
 	wr32(hw, GLINT_DYN_CTL(pf->oicr_idx),
 	     ICE_ITR_NONE << GLINT_DYN_CTL_ITR_INDX_S);
-
+	set_bit(__ICE_OICR_INTR_DIS, pf->state);
 	ice_flush(hw);
 
 	ret = pci_enable_sriov(pf->pdev, num_alloc_vfs);
@@ -1278,13 +1302,13 @@ static int ice_alloc_vfs(struct ice_pf *pf, u16 num_alloc_vfs)
 	}
 	pf->num_alloc_vfs = num_alloc_vfs;
 
-	/* VF resources get allocated during reset */
-	if (!ice_reset_all_vfs(pf, true)) {
+	/* VF resources get allocated with initialization */
+	if (!ice_config_res_vfs(pf)) {
 		ret = -EIO;
 		goto err_unroll_sriov;
 	}
 
-	goto err_unroll_intr;
+	return ret;
 
 err_unroll_sriov:
 	pf->vf = NULL;
@@ -1296,6 +1320,7 @@ static int ice_alloc_vfs(struct ice_pf *pf, u16 num_alloc_vfs)
 err_unroll_intr:
 	/* rearm interrupts here */
 	ice_irq_dynamic_ena(hw, NULL, NULL);
+	clear_bit(__ICE_OICR_INTR_DIS, pf->state);
 	return ret;
 }
 
-- 
2.21.0

