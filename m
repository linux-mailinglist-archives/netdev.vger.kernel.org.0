Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D690D740D2
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 23:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387950AbfGXV0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 17:26:30 -0400
Received: from mga18.intel.com ([134.134.136.126]:63560 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387753AbfGXV0Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 17:26:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jul 2019 14:26:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,304,1559545200"; 
   d="scan'208";a="160700667"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga007.jf.intel.com with ESMTP; 24 Jul 2019 14:26:23 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 5/5] e1000e: add workaround for possible stalled packet
Date:   Wed, 24 Jul 2019 14:26:13 -0700
Message-Id: <20190724212613.1580-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190724212613.1580-1-jeffrey.t.kirsher@intel.com>
References: <20190724212613.1580-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

This works around a possible stalled packet issue, which may occur due to
clock recovery from the PCH being too slow, when the LAN is transitioning
from K1 at 1G link speed.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204057

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 10 ++++++++++
 drivers/net/ethernet/intel/e1000e/ich8lan.h |  2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index 395b05701480..a1fab77b2096 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -1429,6 +1429,16 @@ static s32 e1000_check_for_copper_link_ich8lan(struct e1000_hw *hw)
 			else
 				phy_reg |= 0xFA;
 			e1e_wphy_locked(hw, I217_PLL_CLOCK_GATE_REG, phy_reg);
+
+			if (speed == SPEED_1000) {
+				hw->phy.ops.read_reg_locked(hw, HV_PM_CTRL,
+							    &phy_reg);
+
+				phy_reg |= HV_PM_CTRL_K1_CLK_REQ;
+
+				hw->phy.ops.write_reg_locked(hw, HV_PM_CTRL,
+							     phy_reg);
+			}
 		}
 		hw->phy.ops.release(hw);
 
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.h b/drivers/net/ethernet/intel/e1000e/ich8lan.h
index eb09c755fa17..1502895eb45d 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.h
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.h
@@ -210,7 +210,7 @@
 
 /* PHY Power Management Control */
 #define HV_PM_CTRL		PHY_REG(770, 17)
-#define HV_PM_CTRL_PLL_STOP_IN_K1_GIGA	0x100
+#define HV_PM_CTRL_K1_CLK_REQ		0x200
 #define HV_PM_CTRL_K1_ENABLE		0x4000
 
 #define I217_PLL_CLOCK_GATE_REG	PHY_REG(772, 28)
-- 
2.21.0

