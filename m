Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0FE9272400
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 14:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgIUMgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 08:36:20 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:47232 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726496AbgIUMgU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 08:36:20 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B7AB842431A5A2AFFE0A;
        Mon, 21 Sep 2020 20:36:16 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Mon, 21 Sep 2020 20:36:06 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <jeffrey.t.kirsher@intel.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH -next] net: ixgb: Remove set but not used variable
Date:   Mon, 21 Sep 2020 20:37:02 +0800
Message-ID: <20200921123702.31802-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/ethernet/intel/ixgb/ixgb_hw.c: In function ixgb_adapter_stop:
drivers/net/ethernet/intel/ixgb/ixgb_hw.c:101:6: warning: variable ‘icr_reg’ set but not used [-Wunused-but-set-variable]

drivers/net/ethernet/intel/ixgb/ixgb_hw.c: In function ixgb_optics_reset:
drivers/net/ethernet/intel/ixgb/ixgb_hw.c:1164:7: warning: variable ‘mdio_reg’ set but not used [-Wunused-but-set-variable]

drivers/net/ethernet/intel/ixgb/ixgb_hw.c: In function ixgb_init_hw:
drivers/net/ethernet/intel/ixgb/ixgb_hw.c:277:6: warning: variable ‘ctrl_reg’ set but not used [-Wunused-but-set-variable]

these variable is never used, so remove it.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/intel/ixgb/ixgb_hw.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_hw.c b/drivers/net/ethernet/intel/ixgb/ixgb_hw.c
index cbaa933ef30d..7a5678afa7ce 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_hw.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_hw.c
@@ -98,7 +98,6 @@ bool
 ixgb_adapter_stop(struct ixgb_hw *hw)
 {
 	u32 ctrl_reg;
-	u32 icr_reg;
 
 	ENTER();
 
@@ -142,7 +141,7 @@ ixgb_adapter_stop(struct ixgb_hw *hw)
 	IXGB_WRITE_REG(hw, IMC, 0xffffffff);
 
 	/* Clear any pending interrupt events. */
-	icr_reg = IXGB_READ_REG(hw, ICR);
+	IXGB_READ_REG(hw, ICR);
 
 	return ctrl_reg & IXGB_CTRL0_RST;
 }
@@ -274,7 +273,6 @@ bool
 ixgb_init_hw(struct ixgb_hw *hw)
 {
 	u32 i;
-	u32 ctrl_reg;
 	bool status;
 
 	ENTER();
@@ -286,7 +284,7 @@ ixgb_init_hw(struct ixgb_hw *hw)
 	 */
 	pr_debug("Issuing a global reset to MAC\n");
 
-	ctrl_reg = ixgb_mac_reset(hw);
+	ixgb_mac_reset(hw);
 
 	pr_debug("Issuing an EE reset to MAC\n");
 #ifdef HP_ZX1
@@ -1161,18 +1159,16 @@ static void
 ixgb_optics_reset(struct ixgb_hw *hw)
 {
 	if (hw->phy_type == ixgb_phy_type_txn17401) {
-		u16 mdio_reg;
-
 		ixgb_write_phy_reg(hw,
 				   MDIO_CTRL1,
 				   IXGB_PHY_ADDRESS,
 				   MDIO_MMD_PMAPMD,
 				   MDIO_CTRL1_RESET);
 
-		mdio_reg = ixgb_read_phy_reg(hw,
-					     MDIO_CTRL1,
-					     IXGB_PHY_ADDRESS,
-					     MDIO_MMD_PMAPMD);
+		ixgb_read_phy_reg(hw,
+				  MDIO_CTRL1,
+				  IXGB_PHY_ADDRESS,
+				  MDIO_MMD_PMAPMD);
 	}
 }
 
-- 
2.17.1

