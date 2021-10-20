Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068B64350AD
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 18:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbhJTQyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 12:54:09 -0400
Received: from mga07.intel.com ([134.134.136.100]:63160 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230345AbhJTQyE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 12:54:04 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10143"; a="292294203"
X-IronPort-AV: E=Sophos;i="5.87,167,1631602800"; 
   d="scan'208";a="292294203"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2021 09:51:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,167,1631602800"; 
   d="scan'208";a="567627039"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Oct 2021 09:51:46 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, vitaly.lifshits@intel.com,
        Mark Pearson <markpearson@lenovo.com>,
        Nechama Kraus <nechamax.kraus@linux.intel.com>
Subject: [PATCH net 2/4] e1000e: Fix packet loss on Tiger Lake and later
Date:   Wed, 20 Oct 2021 09:49:55 -0700
Message-Id: <20211020164957.3371484-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211020164957.3371484-1-anthony.l.nguyen@intel.com>
References: <20211020164957.3371484-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Update the HW MAC initialization flow. Do not gate DMA clock from
the modPHY block. Keeping this clock will prevent dropped packets
sent in burst mode on the Kumeran interface.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=213651
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=213377
Fixes: fb776f5d57ee ("e1000e: Add support for Tiger Lake")
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Mark Pearson <markpearson@lenovo.com>
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 11 ++++++++++-
 drivers/net/ethernet/intel/e1000e/ich8lan.h |  3 +++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index 66d7196310e2..5e4fc9b4e2ad 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -4813,7 +4813,7 @@ static s32 e1000_reset_hw_ich8lan(struct e1000_hw *hw)
 static s32 e1000_init_hw_ich8lan(struct e1000_hw *hw)
 {
 	struct e1000_mac_info *mac = &hw->mac;
-	u32 ctrl_ext, txdctl, snoop;
+	u32 ctrl_ext, txdctl, snoop, fflt_dbg;
 	s32 ret_val;
 	u16 i;
 
@@ -4872,6 +4872,15 @@ static s32 e1000_init_hw_ich8lan(struct e1000_hw *hw)
 		snoop = (u32)~(PCIE_NO_SNOOP_ALL);
 	e1000e_set_pcie_no_snoop(hw, snoop);
 
+	/* Enable workaround for packet loss issue on TGP PCH
+	 * Do not gate DMA clock from the modPHY block
+	 */
+	if (mac->type >= e1000_pch_tgp) {
+		fflt_dbg = er32(FFLT_DBG);
+		fflt_dbg |= E1000_FFLT_DBG_DONT_GATE_WAKE_DMA_CLK;
+		ew32(FFLT_DBG, fflt_dbg);
+	}
+
 	ctrl_ext = er32(CTRL_EXT);
 	ctrl_ext |= E1000_CTRL_EXT_RO_DIS;
 	ew32(CTRL_EXT, ctrl_ext);
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.h b/drivers/net/ethernet/intel/e1000e/ich8lan.h
index d6a092e5ee74..2504b11c3169 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.h
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.h
@@ -289,6 +289,9 @@
 /* Proprietary Latency Tolerance Reporting PCI Capability */
 #define E1000_PCI_LTR_CAP_LPT		0xA8
 
+/* Don't gate wake DMA clock */
+#define E1000_FFLT_DBG_DONT_GATE_WAKE_DMA_CLK	0x1000
+
 void e1000e_write_protect_nvm_ich8lan(struct e1000_hw *hw);
 void e1000e_set_kmrn_lock_loss_workaround_ich8lan(struct e1000_hw *hw,
 						  bool state);
-- 
2.31.1

