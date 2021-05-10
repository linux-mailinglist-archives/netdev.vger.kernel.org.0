Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCCA537943F
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 18:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbhEJQkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 12:40:36 -0400
Received: from mga04.intel.com ([192.55.52.120]:34391 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231810AbhEJQkb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 12:40:31 -0400
IronPort-SDR: NS6W4niI6uvdDu1CFncwkJ4EiA5LFMnoZwdjkNPbTyPlei9QeXlrWnDw8Jfg1DtNac8z4FRiNp
 PiK6Xg8N0qDw==
X-IronPort-AV: E=McAfee;i="6200,9189,9980"; a="197252478"
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="197252478"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 09:39:26 -0700
IronPort-SDR: J16rGAt8EY28YYVL6wVQD++BWAWmAeB8PqqsKsU79zOGag5sBx+NI3nI0Ef0AHQIrLpzmrRMDh
 BQTvpRHLJVkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="391976138"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga006.jf.intel.com with ESMTP; 10 May 2021 09:39:24 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id BE783147; Mon, 10 May 2021 19:39:44 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Flavio Suligoi <f.suligoi@asem.it>,
        Lee Jones <lee.jones@linaro.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, kernel test robot <lkp@intel.com>
Subject: [PATCH net-next v3 3/5] net: pch_gbe: use readx_poll_timeout_atomic() variant
Date:   Mon, 10 May 2021 19:39:29 +0300
Message-Id: <20210510163931.42417-4-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210510163931.42417-1-andriy.shevchenko@linux.intel.com>
References: <20210510163931.42417-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use readx_poll_timeout_atomic() instead of open coded variants.

While at it, add __iomem attribute to the parameter of pch_gbe_wait_clr_bit().
This in particular will fix a lot of warnings detected by Sparse, e.g.

.../pch_gbe_main.c:308:26: warning: incorrect type in argument 1 (different address spaces)
.../pch_gbe_main.c:308:26:    expected void const [noderef] __iomem *
.../pch_gbe_main.c:308:26:    got void *reg

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Flavio Suligoi <f.suligoi@asem.it>
---
 .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  | 27 ++++++-------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 8adc8cfaca03..7b224745bf3e 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -11,6 +11,7 @@
 
 #include <linux/gpio/consumer.h>
 #include <linux/gpio/machine.h>
+#include <linux/iopoll.h>
 #include <linux/module.h>
 #include <linux/net_tstamp.h>
 #include <linux/ptp_classify.h>
@@ -299,15 +300,12 @@ static s32 pch_gbe_mac_read_mac_addr(struct pch_gbe_hw *hw)
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
 
@@ -491,18 +489,13 @@ u16 pch_gbe_mac_ctrl_miim(struct pch_gbe_hw *hw, u32 addr, u32 dir, u32 reg,
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
@@ -510,12 +503,8 @@ u16 pch_gbe_mac_ctrl_miim(struct pch_gbe_hw *hw, u32 addr, u32 dir, u32 reg,
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

