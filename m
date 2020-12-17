Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0112DDB8A
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 23:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732133AbgLQWfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 17:35:33 -0500
Received: from mga03.intel.com ([134.134.136.65]:25112 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731953AbgLQWfd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 17:35:33 -0500
IronPort-SDR: FhX1xeGM8CRAoHGR7sd3/xA0D7OYJPBlxGy3ez/Whz1XVf9/9dpe5wuirrQJO8NQZTke/Y1jXo
 jOo0abm9skEA==
X-IronPort-AV: E=McAfee;i="6000,8403,9838"; a="175444101"
X-IronPort-AV: E=Sophos;i="5.78,428,1599548400"; 
   d="scan'208";a="175444101"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2020 14:34:21 -0800
IronPort-SDR: OAn+TXlvHL3ABvotrnsnBOCxrwGgUYjEW6+LacMQYsGpUADIWksbPyzRkgaXToxqDzW6f+XAaP
 XmmTwTmeeRwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,428,1599548400"; 
   d="scan'208";a="370133354"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 17 Dec 2020 14:34:16 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [net 1/2] i40e: Fix Error I40E_AQ_RC_EINVAL when removing VFs
Date:   Thu, 17 Dec 2020 14:34:17 -0800
Message-Id: <20201217223418.3134992-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201217223418.3134992-1-anthony.l.nguyen@intel.com>
References: <20201217223418.3134992-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>

When removing VFs for PF added to bridge there was
an error I40E_AQ_RC_EINVAL. It was caused by not properly
resetting and reinitializing PF when adding/removing VFs.
Changed how reset is performed when adding/removing VFs
to properly reinitialize PFs VSI.

Fixes: fc60861e9b00 ("i40e: start up in VEPA mode by default")
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h             |  3 +++
 drivers/net/ethernet/intel/i40e/i40e_main.c        | 10 ++++++++++
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  4 ++--
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index d231a2cdd98f..118473dfdcbd 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -120,6 +120,7 @@ enum i40e_state_t {
 	__I40E_RESET_INTR_RECEIVED,
 	__I40E_REINIT_REQUESTED,
 	__I40E_PF_RESET_REQUESTED,
+	__I40E_PF_RESET_AND_REBUILD_REQUESTED,
 	__I40E_CORE_RESET_REQUESTED,
 	__I40E_GLOBAL_RESET_REQUESTED,
 	__I40E_EMP_RESET_INTR_RECEIVED,
@@ -146,6 +147,8 @@ enum i40e_state_t {
 };
 
 #define I40E_PF_RESET_FLAG	BIT_ULL(__I40E_PF_RESET_REQUESTED)
+#define I40E_PF_RESET_AND_REBUILD_FLAG	\
+	BIT_ULL(__I40E_PF_RESET_AND_REBUILD_REQUESTED)
 
 /* VSI state flags */
 enum i40e_vsi_state_t {
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 1337686bd099..1db482d310c2 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -36,6 +36,8 @@ static int i40e_setup_misc_vector(struct i40e_pf *pf);
 static void i40e_determine_queue_usage(struct i40e_pf *pf);
 static int i40e_setup_pf_filter_control(struct i40e_pf *pf);
 static void i40e_prep_for_reset(struct i40e_pf *pf, bool lock_acquired);
+static void i40e_reset_and_rebuild(struct i40e_pf *pf, bool reinit,
+				   bool lock_acquired);
 static int i40e_reset(struct i40e_pf *pf);
 static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired);
 static int i40e_setup_misc_vector_for_recovery_mode(struct i40e_pf *pf);
@@ -8536,6 +8538,14 @@ void i40e_do_reset(struct i40e_pf *pf, u32 reset_flags, bool lock_acquired)
 			 "FW LLDP is disabled\n" :
 			 "FW LLDP is enabled\n");
 
+	} else if (reset_flags & I40E_PF_RESET_AND_REBUILD_FLAG) {
+		/* Request a PF Reset
+		 *
+		 * Resets PF and reinitializes PFs VSI.
+		 */
+		i40e_prep_for_reset(pf, lock_acquired);
+		i40e_reset_and_rebuild(pf, true, lock_acquired);
+
 	} else if (reset_flags & BIT_ULL(__I40E_REINIT_REQUESTED)) {
 		int v;
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 729c4f0d5ac5..21ee56420c3a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1772,7 +1772,7 @@ int i40e_pci_sriov_configure(struct pci_dev *pdev, int num_vfs)
 	if (num_vfs) {
 		if (!(pf->flags & I40E_FLAG_VEB_MODE_ENABLED)) {
 			pf->flags |= I40E_FLAG_VEB_MODE_ENABLED;
-			i40e_do_reset_safe(pf, I40E_PF_RESET_FLAG);
+			i40e_do_reset_safe(pf, I40E_PF_RESET_AND_REBUILD_FLAG);
 		}
 		ret = i40e_pci_sriov_enable(pdev, num_vfs);
 		goto sriov_configure_out;
@@ -1781,7 +1781,7 @@ int i40e_pci_sriov_configure(struct pci_dev *pdev, int num_vfs)
 	if (!pci_vfs_assigned(pf->pdev)) {
 		i40e_free_vfs(pf);
 		pf->flags &= ~I40E_FLAG_VEB_MODE_ENABLED;
-		i40e_do_reset_safe(pf, I40E_PF_RESET_FLAG);
+		i40e_do_reset_safe(pf, I40E_PF_RESET_AND_REBUILD_FLAG);
 	} else {
 		dev_warn(&pdev->dev, "Unable to free VFs because some are assigned to VMs.\n");
 		ret = -EINVAL;
-- 
2.26.2

