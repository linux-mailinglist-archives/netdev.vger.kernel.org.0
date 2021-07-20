Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A326A3D052D
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 01:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233901AbhGTWhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 18:37:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:50230 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231981AbhGTWhX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 18:37:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10051"; a="211341474"
X-IronPort-AV: E=Sophos;i="5.84,256,1620716400"; 
   d="scan'208";a="211341474"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2021 16:17:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,256,1620716400"; 
   d="scan'208";a="415407127"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 20 Jul 2021 16:17:54 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, vitaly.lifshits@intel.com,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next 02/12] e1000e: Add polling mechanism to indicate CSME DPG exit
Date:   Tue, 20 Jul 2021 16:20:51 -0700
Message-Id: <20210720232101.3087589-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210720232101.3087589-1-anthony.l.nguyen@intel.com>
References: <20210720232101.3087589-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Per guidance from the CSME architecture team, it may take
up to 1 second for unconfiguring dynamic power gating mode.
Practically it can take more time. Wait up to 2.5 seconds to indicate
dynamic power gating exit from the S0ix configuration. Detect
scenarios that take more than 1 second but less than 2.5 seconds
will emit warning message.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.h |  1 +
 drivers/net/ethernet/intel/e1000e/netdev.c  | 24 +++++++++++++++++++++
 drivers/net/ethernet/intel/e1000e/regs.h    |  1 +
 3 files changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.h b/drivers/net/ethernet/intel/e1000e/ich8lan.h
index e59456d867db..9b145f6248a8 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.h
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.h
@@ -41,6 +41,7 @@
 #define E1000_FWSM_WLOCK_MAC_MASK	0x0380
 #define E1000_FWSM_WLOCK_MAC_SHIFT	7
 #define E1000_FWSM_ULP_CFG_DONE		0x00000400	/* Low power cfg done */
+#define E1000_EXFWSM_DPG_EXIT_DONE	0x00000001
 
 /* Shared Receive Address Registers */
 #define E1000_SHRAL_PCH_LPT(_i)		(0x05408 + ((_i) * 8))
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 4fa6f9f7d199..27107a927455 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6481,8 +6481,10 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
 static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
 {
 	struct e1000_hw *hw = &adapter->hw;
+	bool firmware_bug = false;
 	u32 mac_data;
 	u16 phy_data;
+	u32 i = 0;
 
 	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID) {
 		/* Request ME unconfigure the device from S0ix */
@@ -6490,6 +6492,28 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
 		mac_data &= ~E1000_H2ME_START_DPG;
 		mac_data |= E1000_H2ME_EXIT_DPG;
 		ew32(H2ME, mac_data);
+
+		/* Poll up to 2.5 seconds for ME to unconfigure DPG.
+		 * If this takes more than 1 second, show a warning indicating a
+		 * firmware bug
+		 */
+		while (!(er32(EXFWSM) & E1000_EXFWSM_DPG_EXIT_DONE)) {
+			if (i > 100 && !firmware_bug)
+				firmware_bug = true;
+
+			if (i++ == 250) {
+				e_dbg("Timeout (firmware bug): %d msec\n",
+				      i * 10);
+				break;
+			}
+
+			usleep_range(10000, 11000);
+		}
+		if (firmware_bug)
+			e_warn("DPG_EXIT_DONE took %d msec. This is a firmware bug\n",
+			       i * 10);
+		else
+			e_dbg("DPG_EXIT_DONE cleared after %d msec\n", i * 10);
 	} else {
 		/* Request driver unconfigure the device from S0ix */
 
diff --git a/drivers/net/ethernet/intel/e1000e/regs.h b/drivers/net/ethernet/intel/e1000e/regs.h
index 8165ba2619a4..6c0cd8cab3ef 100644
--- a/drivers/net/ethernet/intel/e1000e/regs.h
+++ b/drivers/net/ethernet/intel/e1000e/regs.h
@@ -213,6 +213,7 @@
 #define E1000_FACTPS	0x05B30	/* Function Active and Power State to MNG */
 #define E1000_SWSM	0x05B50	/* SW Semaphore */
 #define E1000_FWSM	0x05B54	/* FW Semaphore */
+#define E1000_EXFWSM	0x05B58	/* Extended FW Semaphore */
 /* Driver-only SW semaphore (not used by BOOT agents) */
 #define E1000_SWSM2	0x05B58
 #define E1000_FFLT_DBG	0x05F04	/* Debug Register */
-- 
2.26.2

