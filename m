Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57F21E711C
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 02:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438019AbgE2AI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 20:08:57 -0400
Received: from mga03.intel.com ([134.134.136.65]:2084 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437979AbgE2AIg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 20:08:36 -0400
IronPort-SDR: uIsmjudtvn3FUkiDTijrF8wowhMYRjKRlTNUzu+FedKzrKMrotOl0vKmSr+plT2UeWixRejoIU
 aZVT2UhpI6kA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 17:08:34 -0700
IronPort-SDR: IoNHsagQAAHs+ppd2dwlatUCiI/4aLdiobJ+9/oOvUoks2TgP2fHP9CK78gr1QAiwANfRwdYue
 yXKyISlJ000g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,446,1583222400"; 
   d="scan'208";a="302651634"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 28 May 2020 17:08:33 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/15] ice: Simplify ice_sriov_configure
Date:   Thu, 28 May 2020 17:08:23 -0700
Message-Id: <20200529000831.2803870-8-jeffrey.t.kirsher@intel.com>
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

Add a new function for checking if SR-IOV can be configured based on
the PF and/or device's state/capabilities. Also, simplify the flow in
ice_sriov_configure().

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 72 ++++++++++++-------
 1 file changed, 48 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 621ec0cc6fff..b699ca81d8c4 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1460,6 +1460,8 @@ static bool ice_pf_state_is_nominal(struct ice_pf *pf)
  * ice_pci_sriov_ena - Enable or change number of VFs
  * @pf: pointer to the PF structure
  * @num_vfs: number of VFs to allocate
+ *
+ * Returns 0 on success and negative on failure
  */
 static int ice_pci_sriov_ena(struct ice_pf *pf, int num_vfs)
 {
@@ -1467,20 +1469,10 @@ static int ice_pci_sriov_ena(struct ice_pf *pf, int num_vfs)
 	struct device *dev = ice_pf_to_dev(pf);
 	int err;
 
-	if (!ice_pf_state_is_nominal(pf)) {
-		dev_err(dev, "Cannot enable SR-IOV, device not ready\n");
-		return -EBUSY;
-	}
-
-	if (!test_bit(ICE_FLAG_SRIOV_CAPABLE, pf->flags)) {
-		dev_err(dev, "This device is not capable of SR-IOV\n");
-		return -EOPNOTSUPP;
-	}
-
 	if (pre_existing_vfs && pre_existing_vfs != num_vfs)
 		ice_free_vfs(pf);
 	else if (pre_existing_vfs && pre_existing_vfs == num_vfs)
-		return num_vfs;
+		return 0;
 
 	if (num_vfs > pf->num_vfs_supported) {
 		dev_err(dev, "Can't enable %d VFs, max VFs supported is %d\n",
@@ -1496,37 +1488,69 @@ static int ice_pci_sriov_ena(struct ice_pf *pf, int num_vfs)
 	}
 
 	set_bit(ICE_FLAG_SRIOV_ENA, pf->flags);
-	return num_vfs;
+	return 0;
+}
+
+/**
+ * ice_check_sriov_allowed - check if SR-IOV is allowed based on various checks
+ * @pf: PF to enabled SR-IOV on
+ */
+static int ice_check_sriov_allowed(struct ice_pf *pf)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+
+	if (!test_bit(ICE_FLAG_SRIOV_CAPABLE, pf->flags)) {
+		dev_err(dev, "This device is not capable of SR-IOV\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (ice_is_safe_mode(pf)) {
+		dev_err(dev, "SR-IOV cannot be configured - Device is in Safe Mode\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (!ice_pf_state_is_nominal(pf)) {
+		dev_err(dev, "Cannot enable SR-IOV, device not ready\n");
+		return -EBUSY;
+	}
+
+	return 0;
 }
 
 /**
  * ice_sriov_configure - Enable or change number of VFs via sysfs
  * @pdev: pointer to a pci_dev structure
- * @num_vfs: number of VFs to allocate
+ * @num_vfs: number of VFs to allocate or 0 to free VFs
  *
- * This function is called when the user updates the number of VFs in sysfs.
+ * This function is called when the user updates the number of VFs in sysfs. On
+ * success return whatever num_vfs was set to by the caller. Return negative on
+ * failure.
  */
 int ice_sriov_configure(struct pci_dev *pdev, int num_vfs)
 {
 	struct ice_pf *pf = pci_get_drvdata(pdev);
 	struct device *dev = ice_pf_to_dev(pf);
+	int err;
 
-	if (ice_is_safe_mode(pf)) {
-		dev_err(dev, "SR-IOV cannot be configured - Device is in Safe Mode\n");
-		return -EOPNOTSUPP;
-	}
+	err = ice_check_sriov_allowed(pf);
+	if (err)
+		return err;
 
-	if (num_vfs)
-		return ice_pci_sriov_ena(pf, num_vfs);
+	if (!num_vfs) {
+		if (!pci_vfs_assigned(pdev)) {
+			ice_free_vfs(pf);
+			return 0;
+		}
 
-	if (!pci_vfs_assigned(pdev)) {
-		ice_free_vfs(pf);
-	} else {
 		dev_err(dev, "can't free VFs because some are assigned to VMs.\n");
 		return -EBUSY;
 	}
 
-	return 0;
+	err = ice_pci_sriov_ena(pf, num_vfs);
+	if (err)
+		return err;
+
+	return num_vfs;
 }
 
 /**
-- 
2.26.2

