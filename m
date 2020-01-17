Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 805C7141132
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 19:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729456AbgAQS4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 13:56:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:5303 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729414AbgAQS4U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jan 2020 13:56:20 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jan 2020 10:56:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,331,1574150400"; 
   d="scan'208";a="220819573"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jan 2020 10:56:19 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 5/9] igc: Add PHY power management control
Date:   Fri, 17 Jan 2020 10:56:13 -0800
Message-Id: <20200117185617.1585693-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200117185617.1585693-1-jeffrey.t.kirsher@intel.com>
References: <20200117185617.1585693-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

PHY power management control should provide a reliable and accurate
indication of PHY reset completion and decrease the delay time
after a PHY reset

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h |  1 +
 drivers/net/ethernet/intel/igc/igc_phy.c     | 16 +++++++++++++++-
 drivers/net/ethernet/intel/igc/igc_regs.h    |  1 +
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 9e34b0969322..58efa7a02c68 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -464,6 +464,7 @@
 /* PHY Status Register */
 #define MII_SR_LINK_STATUS	0x0004 /* Link Status 1 = link */
 #define MII_SR_AUTONEG_COMPLETE	0x0020 /* Auto Neg Complete */
+#define IGC_PHY_RST_COMP	0x0100 /* Internal PHY reset completion */
 
 /* PHY 1000 MII Register/Bit Definitions */
 /* PHY Registers defined by IEEE */
diff --git a/drivers/net/ethernet/intel/igc/igc_phy.c b/drivers/net/ethernet/intel/igc/igc_phy.c
index f4b05af0dd2f..8e1799508edc 100644
--- a/drivers/net/ethernet/intel/igc/igc_phy.c
+++ b/drivers/net/ethernet/intel/igc/igc_phy.c
@@ -173,6 +173,7 @@ s32 igc_check_downshift(struct igc_hw *hw)
 s32 igc_phy_hw_reset(struct igc_hw *hw)
 {
 	struct igc_phy_info *phy = &hw->phy;
+	u32 phpm = 0, timeout = 10000;
 	s32  ret_val;
 	u32 ctrl;
 
@@ -186,6 +187,8 @@ s32 igc_phy_hw_reset(struct igc_hw *hw)
 	if (ret_val)
 		goto out;
 
+	phpm = rd32(IGC_I225_PHPM);
+
 	ctrl = rd32(IGC_CTRL);
 	wr32(IGC_CTRL, ctrl | IGC_CTRL_PHY_RST);
 	wrfl();
@@ -195,7 +198,18 @@ s32 igc_phy_hw_reset(struct igc_hw *hw)
 	wr32(IGC_CTRL, ctrl);
 	wrfl();
 
-	usleep_range(1500, 2000);
+	/* SW should guarantee 100us for the completion of the PHY reset */
+	usleep_range(100, 150);
+	do {
+		phpm = rd32(IGC_I225_PHPM);
+		timeout--;
+		udelay(1);
+	} while (!(phpm & IGC_PHY_RST_COMP) && timeout);
+
+	if (!timeout)
+		hw_dbg("Timeout is expired after a phy reset\n");
+
+	usleep_range(100, 150);
 
 	phy->ops.release(hw);
 
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index c82111051898..c9029b549b90 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -12,6 +12,7 @@
 #define IGC_MDIC		0x00020  /* MDI Control - RW */
 #define IGC_MDICNFG		0x00E04  /* MDC/MDIO Configuration - RW */
 #define IGC_CONNSW		0x00034  /* Copper/Fiber switch control - RW */
+#define IGC_I225_PHPM		0x00E14  /* I225 PHY Power Management */
 
 /* Internal Packet Buffer Size Registers */
 #define IGC_RXPBS		0x02404  /* Rx Packet Buffer Size - RW */
-- 
2.24.1

