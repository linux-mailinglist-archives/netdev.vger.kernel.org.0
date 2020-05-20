Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2DBB1DA60F
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 02:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728333AbgETAEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 20:04:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:15427 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726344AbgETAEa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 20:04:30 -0400
IronPort-SDR: 9gvD7+InowOQ/eIlVU40deMNdqcTVMOnSWNnrC/CX22q4uQMNcRMWPe4XeT39aRa3IodRPS6zq
 WW9Zjh1E4WKw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 17:04:21 -0700
IronPort-SDR: wmERnAFtviNl0vMM2C5DGVApAZQHUwHOSLK33tgbV+jSVMRt+ctwKgxVh/KxKuXNcHgFx4dVgt
 WRJdJbjC56Dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,411,1583222400"; 
   d="scan'208";a="466324752"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga006.fm.intel.com with ESMTP; 19 May 2020 17:04:21 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Vitaly Lifshits <vitaly.lifshits@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Sasha Neftin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 02/14] igc: remove IGC_REMOVED function
Date:   Tue, 19 May 2020 17:04:07 -0700
Message-Id: <20200520000419.1595788-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200520000419.1595788-1-jeffrey.t.kirsher@intel.com>
References: <20200520000419.1595788-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vitaly Lifshits <vitaly.lifshits@intel.com>

igc driver has leftovers from the previous device that supported
Virtualization. This can be found in the function IGC_REMOVED which
became obsolete, and can be removed.

Signed-off-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_mac.h  | 4 ----
 drivers/net/ethernet/intel/igc/igc_main.c | 3 ---
 drivers/net/ethernet/intel/igc/igc_regs.h | 3 +--
 3 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_mac.h b/drivers/net/ethernet/intel/igc/igc_mac.h
index 832cccec87cd..b5963f86defb 100644
--- a/drivers/net/ethernet/intel/igc/igc_mac.h
+++ b/drivers/net/ethernet/intel/igc/igc_mac.h
@@ -8,10 +8,6 @@
 #include "igc_phy.h"
 #include "igc_defines.h"
 
-#ifndef IGC_REMOVED
-#define IGC_REMOVED(a) (0)
-#endif /* IGC_REMOVED */
-
 /* forward declaration */
 s32 igc_disable_pcie_master(struct igc_hw *hw);
 s32 igc_check_for_copper_link(struct igc_hw *hw);
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 0ae3590a50eb..125026d053eb 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4659,9 +4659,6 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg)
 	u8 __iomem *hw_addr = READ_ONCE(hw->hw_addr);
 	u32 value = 0;
 
-	if (IGC_REMOVED(hw_addr))
-		return ~value;
-
 	value = readl(&hw_addr[reg]);
 
 	/* reads should not return all F's */
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index 0f94285ddc11..f101bfbf52e6 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -275,8 +275,7 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg);
 #define wr32(reg, val) \
 do { \
 	u8 __iomem *hw_addr = READ_ONCE((hw)->hw_addr); \
-	if (!IGC_REMOVED(hw_addr)) \
-		writel((val), &hw_addr[(reg)]); \
+	writel((val), &hw_addr[(reg)]); \
 } while (0)
 
 #define rd32(reg) (igc_rd32(hw, reg))
-- 
2.26.2

