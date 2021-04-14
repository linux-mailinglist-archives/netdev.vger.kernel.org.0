Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64B535F7D9
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 17:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352395AbhDNPaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 11:30:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:33262 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352327AbhDNPaM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 11:30:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6E10CB07B;
        Wed, 14 Apr 2021 15:29:50 +0000 (UTC)
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 8/9] net: korina: Get mdio input clock via common clock framework
Date:   Wed, 14 Apr 2021 17:29:44 +0200
Message-Id: <20210414152946.12517-9-tsbogend@alpha.franken.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210414152946.12517-1-tsbogend@alpha.franken.de>
References: <20210414152946.12517-1-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With device tree clock is provided via CCF. For non device tree
use a maximum clock value to not overclock the PHY. The non device
tree usage will go away after platform is converted to DT.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 drivers/net/ethernet/korina.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index c4590b2c65aa..df75dd5d1638 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -56,14 +56,13 @@
 #include <linux/ethtool.h>
 #include <linux/crc32.h>
 #include <linux/pgtable.h>
+#include <linux/clk.h>
 
 #include <asm/bootinfo.h>
 #include <asm/bitops.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 
-#include <asm/mach-rc32434/rb.h>
-#include <asm/mach-rc32434/rc32434.h>
 #include <asm/mach-rc32434/eth.h>
 #include <asm/mach-rc32434/dma_v.h>
 
@@ -145,10 +144,9 @@ struct korina_private {
 	struct work_struct restart_task;
 	struct net_device *dev;
 	struct device *dmadev;
+	int mii_clock_freq;
 };
 
-extern unsigned int idt_cpu_freq;
-
 static dma_addr_t korina_tx_dma(struct korina_private *lp, int idx)
 {
 	return lp->td_dma + (idx * sizeof(struct dma_desc));
@@ -900,8 +898,8 @@ static int korina_init(struct net_device *dev)
 
 	/* Management Clock Prescaler Divisor
 	 * Clock independent setting */
-	writel(((idt_cpu_freq) / MII_CLOCK + 1) & ~1,
-			&lp->eth_regs->ethmcp);
+	writel(((lp->mii_clock_freq) / MII_CLOCK + 1) & ~1,
+	       &lp->eth_regs->ethmcp);
 	writel(0, &lp->eth_regs->miimcfg);
 
 	/* don't transmit until fifo contains 48b */
@@ -1061,6 +1059,7 @@ static int korina_probe(struct platform_device *pdev)
 	const u8 *mac_addr = dev_get_platdata(&pdev->dev);
 	struct korina_private *lp;
 	struct net_device *dev;
+	struct clk *clk;
 	void __iomem *p;
 	int rc;
 
@@ -1081,6 +1080,14 @@ static int korina_probe(struct platform_device *pdev)
 			eth_hw_addr_random(dev);
 	}
 
+	clk = devm_clk_get(&pdev->dev, NULL);
+	if (!IS_ERR(clk)) {
+		clk_prepare_enable(clk);
+		lp->mii_clock_freq = clk_get_rate(clk);
+	} else {
+		lp->mii_clock_freq = 200000000; /* max possible input clk */
+	}
+
 	lp->rx_irq = platform_get_irq_byname(pdev, "korina_rx");
 	lp->tx_irq = platform_get_irq_byname(pdev, "korina_tx");
 
-- 
2.29.2

