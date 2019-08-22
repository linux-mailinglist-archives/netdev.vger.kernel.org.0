Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE419A127
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 22:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393195AbfHVUa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 16:30:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:17467 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389435AbfHVUam (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 16:30:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 13:30:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,418,1559545200"; 
   d="scan'208";a="169907274"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga007.jf.intel.com with ESMTP; 22 Aug 2019 13:30:40 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Adrian Podlawski <adrian.podlawski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 06/13] i40e: check_recovery_mode had wrong if statement
Date:   Thu, 22 Aug 2019 13:30:32 -0700
Message-Id: <20190822203039.15668-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190822203039.15668-1-jeffrey.t.kirsher@intel.com>
References: <20190822203039.15668-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Adrian Podlawski <adrian.podlawski@intel.com>

Function check_recovery_mode had wrong if statement.
Now we check proper FWS1B register values, which are responsible for
the recovery mode. Recovery mode has 4 values for x710 and 2 for x722.
That's why we need 6 different flags which are defined in the code.
Now in the if statement, we recognize type of mac address
and register value.
Without those changes driver could show wrong state.

Signed-off-by: Adrian Podlawski <adrian.podlawski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c     | 17 ++++++++++++++---
 drivers/net/ethernet/intel/i40e/i40e_register.h |  6 ++++++
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index b807dd6b1417..4551d97771c9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -14578,9 +14578,20 @@ void i40e_set_fec_in_flags(u8 fec_cfg, u32 *flags)
  **/
 static bool i40e_check_recovery_mode(struct i40e_pf *pf)
 {
-	u32 val = rd32(&pf->hw, I40E_GL_FWSTS);
-
-	if (val & I40E_GL_FWSTS_FWS1B_MASK) {
+	u32 val = rd32(&pf->hw, I40E_GL_FWSTS) & I40E_GL_FWSTS_FWS1B_MASK;
+	bool is_recovery_mode = false;
+
+	if (pf->hw.mac.type == I40E_MAC_XL710)
+		is_recovery_mode =
+		val == I40E_XL710_GL_FWSTS_FWS1B_REC_MOD_CORER_MASK ||
+		val == I40E_XL710_GL_FWSTS_FWS1B_REC_MOD_GLOBR_MASK ||
+		val == I40E_XL710_GL_FWSTS_FWS1B_REC_MOD_TRANSITION_MASK ||
+		val == I40E_XL710_GL_FWSTS_FWS1B_REC_MOD_NVM_MASK;
+	if (pf->hw.mac.type == I40E_MAC_X722)
+		is_recovery_mode =
+		val == I40E_X722_GL_FWSTS_FWS1B_REC_MOD_CORER_MASK ||
+		val == I40E_X722_GL_FWSTS_FWS1B_REC_MOD_GLOBR_MASK;
+	if (is_recovery_mode) {
 		dev_notice(&pf->pdev->dev, "Firmware recovery mode detected. Limiting functionality.\n");
 		dev_notice(&pf->pdev->dev, "Refer to the Intel(R) Ethernet Adapters and Devices User Guide for details on firmware recovery mode.\n");
 		set_bit(__I40E_RECOVERY_MODE, pf->state);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_register.h b/drivers/net/ethernet/intel/i40e/i40e_register.h
index 330ac19a5dae..d35d690ca10f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_register.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_register.h
@@ -363,6 +363,12 @@
 #define I40E_GL_FWSTS_FWRI_MASK I40E_MASK(0x1, I40E_GL_FWSTS_FWRI_SHIFT)
 #define I40E_GL_FWSTS_FWS1B_SHIFT 16
 #define I40E_GL_FWSTS_FWS1B_MASK I40E_MASK(0xFF, I40E_GL_FWSTS_FWS1B_SHIFT)
+#define I40E_XL710_GL_FWSTS_FWS1B_REC_MOD_CORER_MASK I40E_MASK(0x30, I40E_GL_FWSTS_FWS1B_SHIFT)
+#define I40E_XL710_GL_FWSTS_FWS1B_REC_MOD_GLOBR_MASK I40E_MASK(0x31, I40E_GL_FWSTS_FWS1B_SHIFT)
+#define I40E_XL710_GL_FWSTS_FWS1B_REC_MOD_TRANSITION_MASK I40E_MASK(0x32, I40E_GL_FWSTS_FWS1B_SHIFT)
+#define I40E_XL710_GL_FWSTS_FWS1B_REC_MOD_NVM_MASK I40E_MASK(0x33, I40E_GL_FWSTS_FWS1B_SHIFT)
+#define I40E_X722_GL_FWSTS_FWS1B_REC_MOD_CORER_MASK I40E_MASK(0xB, I40E_GL_FWSTS_FWS1B_SHIFT)
+#define I40E_X722_GL_FWSTS_FWS1B_REC_MOD_GLOBR_MASK I40E_MASK(0xC, I40E_GL_FWSTS_FWS1B_SHIFT)
 #define I40E_GLGEN_CLKSTAT 0x000B8184 /* Reset: POR */
 #define I40E_GLGEN_CLKSTAT_CLKMODE_SHIFT 0
 #define I40E_GLGEN_CLKSTAT_CLKMODE_MASK I40E_MASK(0x1, I40E_GLGEN_CLKSTAT_CLKMODE_SHIFT)
-- 
2.21.0

