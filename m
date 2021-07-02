Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A6F3B9BAA
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 06:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbhGBEyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 00:54:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49543 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhGBEyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 00:54:18 -0400
Received: from [222.129.38.159] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <aaron.ma@canonical.com>)
        id 1lzB9P-0005Ri-4u; Fri, 02 Jul 2021 04:51:39 +0000
From:   Aaron Ma <aaron.ma@canonical.com>
To:     jesse.brandeburg@intel.com, aaron.ma@canonical.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] igc: don't rd/wr iomem when PCI is removed
Date:   Fri,  2 Jul 2021 12:51:19 +0800
Message-Id: <20210702045120.22855-1-aaron.ma@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check PCI state when rd/wr iomem.
Implement wr32 function as rd32 too.

When unplug TBT dock with i225, rd/wr PCI iomem will cause error log:
Trace:
BUG: unable to handle page fault for address: 000000000000b604
Oops: 0000 [#1] SMP NOPTI
RIP: 0010:igc_rd32+0x1c/0x90 [igc]
Call Trace:
igc_ptp_suspend+0x6c/0xa0 [igc]
igc_ptp_stop+0x12/0x50 [igc]
igc_remove+0x7f/0x1c0 [igc]
pci_device_remove+0x3e/0xb0
__device_release_driver+0x181/0x240

Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 16 ++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_regs.h |  7 ++-----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index f1adf154ec4a..606b72cb6193 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5292,6 +5292,10 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg)
 	u8 __iomem *hw_addr = READ_ONCE(hw->hw_addr);
 	u32 value = 0;
 
+	if (igc->pdev &&
+		igc->pdev->error_state == pci_channel_io_perm_failure)
+		return 0;
+
 	value = readl(&hw_addr[reg]);
 
 	/* reads should not return all F's */
@@ -5308,6 +5312,18 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg)
 	return value;
 }
 
+void igc_wr32(struct igc_hw *hw, u32 reg, u32 val)
+{
+	struct igc_adapter *igc = container_of(hw, struct igc_adapter, hw);
+	u8 __iomem *hw_addr = READ_ONCE(hw->hw_addr);
+
+	if (igc->pdev &&
+		igc->pdev->error_state == pci_channel_io_perm_failure)
+		return;
+
+	writel((val), &hw_addr[(reg)]);
+}
+
 int igc_set_spd_dplx(struct igc_adapter *adapter, u32 spd, u8 dplx)
 {
 	struct igc_mac_info *mac = &adapter->hw.mac;
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index cc174853554b..eb4be87d0e8b 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -260,13 +260,10 @@ struct igc_hw;
 u32 igc_rd32(struct igc_hw *hw, u32 reg);
 
 /* write operations, indexed using DWORDS */
-#define wr32(reg, val) \
-do { \
-	u8 __iomem *hw_addr = READ_ONCE((hw)->hw_addr); \
-	writel((val), &hw_addr[(reg)]); \
-} while (0)
+void igc_wr32(struct igc_hw *hw, u32 reg, u32 val);
 
 #define rd32(reg) (igc_rd32(hw, reg))
+#define wr32(reg, val) (igc_wr32(hw, reg, val))
 
 #define wrfl() ((void)rd32(IGC_STATUS))
 
-- 
2.30.2

