Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40EA82068F4
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 02:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388080AbgFXAW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 20:22:58 -0400
Received: from mga05.intel.com ([192.55.52.43]:3728 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387693AbgFXAW4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 20:22:56 -0400
IronPort-SDR: rRV0qwNTnLrx2de+/ewpP8Tr2cStvPK3iwEdU7pcEGjouB3uDerZoL2sHjsyspMqFUdgAG/lHH
 zl7gCx6FZEjA==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="228962048"
X-IronPort-AV: E=Sophos;i="5.75,273,1589266800"; 
   d="scan'208";a="228962048"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 17:22:55 -0700
IronPort-SDR: PzDLHwYgxRBhS+f+hZCV/+uMIajSejbpqjuZ3EK/72ugWFwIy7ioPuKZHqz1pxrSS1YuIwbEWX
 wPPUEzyYBcXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,273,1589266800"; 
   d="scan'208";a="293374244"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga002.jf.intel.com with ESMTP; 23 Jun 2020 17:22:54 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Piotr Kwapulinski <piotr.kwapulinski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 4/8] i40e: detect and log info about pre-recovery mode
Date:   Tue, 23 Jun 2020 17:22:48 -0700
Message-Id: <20200624002252.942257-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624002252.942257-1-jeffrey.t.kirsher@intel.com>
References: <20200624002252.942257-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Piotr Kwapulinski <piotr.kwapulinski@intel.com>

Detect and log information about pre-recovery mode when firmware
transitions to a recovery mode.
When a firmware transitions to a recovery mode it stores a number
of unexpected EMP resets in one of its registers. The number of EMP
resets ranging from 0x21 to 0x2A indicates that FW transitions
to recovery mode. Use these values to emit log entry about transition
process. Previously the pre-recovery mode may not have been detected
and there was no log entry when NIC was in pre-recovery mode.

Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Piotr Kwapulinski <piotr.kwapulinski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 72 +++++++++++++------
 .../net/ethernet/intel/i40e/i40e_register.h   |  2 +
 2 files changed, 52 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 3978b66dcffd..841e49e1e091 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -14557,28 +14557,17 @@ void i40e_set_fec_in_flags(u8 fec_cfg, u32 *flags)
  **/
 static bool i40e_check_recovery_mode(struct i40e_pf *pf)
 {
-	u32 val = rd32(&pf->hw, I40E_GL_FWSTS) & I40E_GL_FWSTS_FWS1B_MASK;
-	bool is_recovery_mode = false;
-
-	if (pf->hw.mac.type == I40E_MAC_XL710)
-		is_recovery_mode =
-		val == I40E_XL710_GL_FWSTS_FWS1B_REC_MOD_CORER_MASK ||
-		val == I40E_XL710_GL_FWSTS_FWS1B_REC_MOD_GLOBR_MASK ||
-		val == I40E_XL710_GL_FWSTS_FWS1B_REC_MOD_TRANSITION_MASK ||
-		val == I40E_XL710_GL_FWSTS_FWS1B_REC_MOD_NVM_MASK;
-	if (pf->hw.mac.type == I40E_MAC_X722)
-		is_recovery_mode =
-		val == I40E_X722_GL_FWSTS_FWS1B_REC_MOD_CORER_MASK ||
-		val == I40E_X722_GL_FWSTS_FWS1B_REC_MOD_GLOBR_MASK;
-	if (is_recovery_mode) {
-		dev_notice(&pf->pdev->dev, "Firmware recovery mode detected. Limiting functionality.\n");
-		dev_notice(&pf->pdev->dev, "Refer to the Intel(R) Ethernet Adapters and Devices User Guide for details on firmware recovery mode.\n");
+	u32 val = rd32(&pf->hw, I40E_GL_FWSTS);
+
+	if (val & I40E_GL_FWSTS_FWS1B_MASK) {
+		dev_crit(&pf->pdev->dev, "Firmware recovery mode detected. Limiting functionality.\n");
+		dev_crit(&pf->pdev->dev, "Refer to the Intel(R) Ethernet Adapters and Devices User Guide for details on firmware recovery mode.\n");
 		set_bit(__I40E_RECOVERY_MODE, pf->state);
 
 		return true;
 	}
-	if (test_and_clear_bit(__I40E_RECOVERY_MODE, pf->state))
-		dev_info(&pf->pdev->dev, "Reinitializing in normal mode with full functionality.\n");
+	if (test_bit(__I40E_RECOVERY_MODE, pf->state))
+		dev_info(&pf->pdev->dev, "Please do Power-On Reset to initialize adapter in normal mode with full functionality.\n");
 
 	return false;
 }
@@ -14626,6 +14615,47 @@ static i40e_status i40e_pf_loop_reset(struct i40e_pf *pf)
 	return ret;
 }
 
+/**
+ * i40e_check_fw_empr - check if FW issued unexpected EMP Reset
+ * @pf: board private structure
+ *
+ * Check FW registers to determine if FW issued unexpected EMP Reset.
+ * Every time when unexpected EMP Reset occurs the FW increments
+ * a counter of unexpected EMP Resets. When the counter reaches 10
+ * the FW should enter the Recovery mode
+ *
+ * Returns true if FW issued unexpected EMP Reset
+ **/
+static bool i40e_check_fw_empr(struct i40e_pf *pf)
+{
+	const u32 fw_sts = rd32(&pf->hw, I40E_GL_FWSTS) &
+			   I40E_GL_FWSTS_FWS1B_MASK;
+	return (fw_sts > I40E_GL_FWSTS_FWS1B_EMPR_0) &&
+	       (fw_sts <= I40E_GL_FWSTS_FWS1B_EMPR_10);
+}
+
+/**
+ * i40e_handle_resets - handle EMP resets and PF resets
+ * @pf: board private structure
+ *
+ * Handle both EMP resets and PF resets and conclude whether there are
+ * any issues regarding these resets. If there are any issues then
+ * generate log entry.
+ *
+ * Return 0 if NIC is healthy or negative value when there are issues
+ * with resets
+ **/
+static i40e_status i40e_handle_resets(struct i40e_pf *pf)
+{
+	const i40e_status pfr = i40e_pf_loop_reset(pf);
+	const bool is_empr = i40e_check_fw_empr(pf);
+
+	if (is_empr || pfr != I40E_SUCCESS)
+		dev_crit(&pf->pdev->dev, "Entering recovery mode due to repeated FW resets. This may take several minutes. Refer to the Intel(R) Ethernet Adapters and Devices User Guide.\n");
+
+	return is_empr ? I40E_ERR_RESET_FAILED : pfr;
+}
+
 /**
  * i40e_init_recovery_mode - initialize subsystems needed in recovery mode
  * @pf: board private structure
@@ -14862,11 +14892,9 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_pf_reset;
 	}
 
-	err = i40e_pf_loop_reset(pf);
-	if (err) {
-		dev_info(&pdev->dev, "Initial pf_reset failed: %d\n", err);
+	err = i40e_handle_resets(pf);
+	if (err)
 		goto err_pf_reset;
-	}
 
 	i40e_check_recovery_mode(pf);
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_register.h b/drivers/net/ethernet/intel/i40e/i40e_register.h
index 7cd3a08a1891..564df22f3f46 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_register.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_register.h
@@ -43,6 +43,8 @@
 #define I40E_GL_FWSTS 0x00083048 /* Reset: POR */
 #define I40E_GL_FWSTS_FWS1B_SHIFT 16
 #define I40E_GL_FWSTS_FWS1B_MASK I40E_MASK(0xFF, I40E_GL_FWSTS_FWS1B_SHIFT)
+#define I40E_GL_FWSTS_FWS1B_EMPR_0 I40E_MASK(0x20, I40E_GL_FWSTS_FWS1B_SHIFT)
+#define I40E_GL_FWSTS_FWS1B_EMPR_10 I40E_MASK(0x2A, I40E_GL_FWSTS_FWS1B_SHIFT)
 #define I40E_XL710_GL_FWSTS_FWS1B_REC_MOD_CORER_MASK I40E_MASK(0x30, I40E_GL_FWSTS_FWS1B_SHIFT)
 #define I40E_XL710_GL_FWSTS_FWS1B_REC_MOD_GLOBR_MASK I40E_MASK(0x31, I40E_GL_FWSTS_FWS1B_SHIFT)
 #define I40E_XL710_GL_FWSTS_FWS1B_REC_MOD_TRANSITION_MASK I40E_MASK(0x32, I40E_GL_FWSTS_FWS1B_SHIFT)
-- 
2.26.2

