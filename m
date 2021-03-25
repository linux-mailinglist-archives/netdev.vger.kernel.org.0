Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71219349824
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 18:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhCYRec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 13:34:32 -0400
Received: from mga14.intel.com ([192.55.52.115]:12130 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230034AbhCYReP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 13:34:15 -0400
IronPort-SDR: tKLxISjmYDi2lkaWqh0O2Y8vX41wLiY+yQAN1kZuLHJVbUv70RwnG+aLn5C9vC19cJvdoAgVEM
 5w1uxq+xBa/Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="190407632"
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="190407632"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 10:34:13 -0700
IronPort-SDR: 52pirjqxnWuBDUVBdjnLW7aWwlx/ai4d8U07Rg0NESNqHbo1/gkoe44D4HFh/4VeiAK6ReVfBd
 wqHGgSXG7/cQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="409474543"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga008.fm.intel.com with ESMTP; 25 Mar 2021 10:34:09 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 540E4397; Thu, 25 Mar 2021 19:34:23 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Flavio Suligoi <f.suligoi@asem.it>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 3/5] net: pch_gbe: use readx_poll_timeout_atomic() variant
Date:   Thu, 25 Mar 2021 19:34:10 +0200
Message-Id: <20210325173412.82911-4-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325173412.82911-1-andriy.shevchenko@linux.intel.com>
References: <20210325173412.82911-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use readx_poll_timeout_atomic() instead of open coded variants.

While at it, add __iomem attribute to the parameter of pch_gbe_wait_clr_bit().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  | 27 ++++++-------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 1038947cbac8..91de7faa6dfe 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -11,6 +11,7 @@
 
 #include <linux/gpio/consumer.h>
 #include <linux/gpio/machine.h>
+#include <linux/iopoll.h>
 #include <linux/module.h>
 #include <linux/net_tstamp.h>
 #include <linux/ptp_classify.h>
@@ -297,15 +298,12 @@ static s32 pch_gbe_mac_read_mac_addr(struct pch_gbe_hw *hw)
  * @reg:	Pointer of register
  * @bit:	Busy bit
  */
-static void pch_gbe_wait_clr_bit(void *reg, u32 bit)
+static void pch_gbe_wait_clr_bit(void __iomem *reg, u32 bit)
 {
 	u32 tmp;
 
 	/* wait busy */
-	tmp = 1000;
-	while ((ioread32(reg) & bit) && --tmp)
-		cpu_relax();
-	if (!tmp)
+	if (readx_poll_timeout_atomic(ioread32, reg, tmp, !(tmp & bit), 0, 10))
 		pr_err("Error: busy bit is not cleared\n");
 }
 
@@ -489,18 +487,13 @@ u16 pch_gbe_mac_ctrl_miim(struct pch_gbe_hw *hw, u32 addr, u32 dir, u32 reg,
 			u16 data)
 {
 	struct pch_gbe_adapter *adapter = pch_gbe_hw_to_adapter(hw);
-	u32 data_out = 0;
-	unsigned int i;
 	unsigned long flags;
+	u32 data_out;
 
 	spin_lock_irqsave(&hw->miim_lock, flags);
 
-	for (i = 100; i; --i) {
-		if ((ioread32(&hw->reg->MIIM) & PCH_GBE_MIIM_OPER_READY))
-			break;
-		udelay(20);
-	}
-	if (i == 0) {
+	if (readx_poll_timeout_atomic(ioread32, &hw->reg->MIIM, data_out,
+				      data_out & PCH_GBE_MIIM_OPER_READY, 20, 2000)) {
 		netdev_err(adapter->netdev, "pch-gbe.miim won't go Ready\n");
 		spin_unlock_irqrestore(&hw->miim_lock, flags);
 		return 0;	/* No way to indicate timeout error */
@@ -508,12 +501,8 @@ u16 pch_gbe_mac_ctrl_miim(struct pch_gbe_hw *hw, u32 addr, u32 dir, u32 reg,
 	iowrite32(((reg << PCH_GBE_MIIM_REG_ADDR_SHIFT) |
 		  (addr << PCH_GBE_MIIM_PHY_ADDR_SHIFT) |
 		  dir | data), &hw->reg->MIIM);
-	for (i = 0; i < 100; i++) {
-		udelay(20);
-		data_out = ioread32(&hw->reg->MIIM);
-		if ((data_out & PCH_GBE_MIIM_OPER_READY))
-			break;
-	}
+	readx_poll_timeout_atomic(ioread32, &hw->reg->MIIM, data_out,
+				  data_out & PCH_GBE_MIIM_OPER_READY, 20, 2000);
 	spin_unlock_irqrestore(&hw->miim_lock, flags);
 
 	netdev_dbg(adapter->netdev, "PHY %s: reg=%d, data=0x%04X\n",
-- 
2.30.2

