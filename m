Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD57F58B7
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732676AbfKHUiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 15:38:17 -0500
Received: from mga12.intel.com ([192.55.52.136]:11883 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732517AbfKHUiL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 15:38:11 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Nov 2019 12:38:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,283,1569308400"; 
   d="scan'208";a="354200435"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 08 Nov 2019 12:38:08 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 07/15] ice: Check if VF is disabled for Opcode and other operations
Date:   Fri,  8 Nov 2019 12:37:58 -0800
Message-Id: <20191108203806.12109-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191108203806.12109-1-jeffrey.t.kirsher@intel.com>
References: <20191108203806.12109-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>

This patch adds code to check if PF or VF is disabled before honoring
mailbox message to configure VF - If it is disabled, and opcode is for
resetting VF, the PF driver simply tell VF that all is set. In addition,
if reset is ongoing, and Admin intend to configure VF on the host, we can
poll the VF enabling bit to make sure it is ready before continue - If
after ~250 milliseconds, VF is not in active state, we can bail out with
invalid error.

Signed-off-by: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 74 ++++++++++++++++---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  1 +
 2 files changed, 63 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index b4813ccc467d..639d1b2a9e19 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1151,6 +1151,25 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 	return true;
 }
 
+/**
+ * ice_is_vf_disabled
+ * @vf: pointer to the VF info
+ *
+ * Returns true if the PF or VF is disabled, false otherwise.
+ */
+static bool ice_is_vf_disabled(struct ice_vf *vf)
+{
+	struct ice_pf *pf = vf->pf;
+
+	/* If the PF has been disabled, there is no need resetting VF until
+	 * PF is active again. Similarly, if the VF has been disabled, this
+	 * means something else is resetting the VF, so we shouldn't continue.
+	 * Otherwise, set disable VF state bit for actual reset, and continue.
+	 */
+	return (test_bit(__ICE_VF_DIS, pf->state) ||
+		test_bit(ICE_VF_STATE_DIS, vf->vf_states));
+}
+
 /**
  * ice_reset_vf - Reset a particular VF
  * @vf: pointer to the VF structure
@@ -1168,19 +1187,15 @@ static bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 	u32 reg;
 	int i;
 
-	/* If the PF has been disabled, there is no need resetting VF until
-	 * PF is active again.
-	 */
-	if (test_bit(__ICE_VF_DIS, pf->state))
-		return false;
-
-	/* If the VF has been disabled, this means something else is
-	 * resetting the VF, so we shouldn't continue. Otherwise, set
-	 * disable VF state bit for actual reset, and continue.
-	 */
-	if (test_and_set_bit(ICE_VF_STATE_DIS, vf->vf_states))
-		return false;
+	if (ice_is_vf_disabled(vf)) {
+		dev_dbg(&pf->pdev->dev,
+			"VF is already disabled, there is no need for resetting it, telling VM, all is fine %d\n",
+			 vf->vf_id);
+		return true;
+	}
 
+	/* Set VF disable bit state here, before triggering reset */
+	set_bit(ICE_VF_STATE_DIS, vf->vf_states);
 	ice_trigger_vf_reset(vf, is_vflr, false);
 
 	vsi = pf->vsi[vf->lan_vsi_idx];
@@ -3122,6 +3137,23 @@ int ice_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool ena)
 	return ret;
 }
 
+/**
+ * ice_wait_on_vf_reset
+ * @vf: The VF being resseting
+ *
+ * Poll to make sure a given VF is ready after reset
+ */
+static void ice_wait_on_vf_reset(struct ice_vf *vf)
+{
+	int i;
+
+	for (i = 0; i < ICE_MAX_VF_RESET_WAIT; i++) {
+		if (test_bit(ICE_VF_STATE_INIT, vf->vf_states))
+			break;
+		msleep(20);
+	}
+}
+
 /**
  * ice_set_vf_mac
  * @netdev: network interface device structure
@@ -3145,6 +3177,15 @@ int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 	}
 
 	vf = &pf->vf[vf_id];
+	/* Don't set MAC on disabled VF */
+	if (ice_is_vf_disabled(vf))
+		return -EINVAL;
+
+	/* In case VF is in reset mode, wait until it is completed. Depending
+	 * on factors like queue disabling routine, this could take ~250ms
+	 */
+	ice_wait_on_vf_reset(vf);
+
 	if (!test_bit(ICE_VF_STATE_INIT, vf->vf_states)) {
 		netdev_err(netdev, "VF %d in reset. Try again.\n", vf_id);
 		return -EBUSY;
@@ -3192,6 +3233,15 @@ int ice_set_vf_trust(struct net_device *netdev, int vf_id, bool trusted)
 	}
 
 	vf = &pf->vf[vf_id];
+	/* Don't set Trusted Mode on disabled VF */
+	if (ice_is_vf_disabled(vf))
+		return -EINVAL;
+
+	/* In case VF is in reset mode, wait until it is completed. Depending
+	 * on factors like queue disabling routine, this could take ~250ms
+	 */
+	ice_wait_on_vf_reset(vf);
+
 	if (!test_bit(ICE_VF_STATE_INIT, vf->vf_states)) {
 		dev_err(&pf->pdev->dev, "VF %d in reset. Try again.\n", vf_id);
 		return -EBUSY;
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 0d9880c8bba3..2e867ad2e81d 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -38,6 +38,7 @@
 #define ICE_MAX_POLICY_INTR_PER_VF	33
 #define ICE_MIN_INTR_PER_VF		(ICE_MIN_QS_PER_VF + 1)
 #define ICE_DFLT_INTR_PER_VF		(ICE_DFLT_QS_PER_VF + 1)
+#define ICE_MAX_VF_RESET_WAIT		15
 
 /* Specific VF states */
 enum ice_vf_states {
-- 
2.21.0

