Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB17C363829
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 00:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237225AbhDRWUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 18:20:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:38328 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235680AbhDRWUX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Apr 2021 18:20:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DD996B15F;
        Sun, 18 Apr 2021 22:19:53 +0000 (UTC)
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: [PATCH v6 net-next 08/10] net: korina: Get mdio input clock via common clock framework
Date:   Mon, 19 Apr 2021 00:19:46 +0200
Message-Id: <20210418221949.130779-9-tsbogend@alpha.franken.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210418221949.130779-1-tsbogend@alpha.franken.de>
References: <20210418221949.130779-1-tsbogend@alpha.franken.de>
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
 drivers/net/ethernet/korina.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index a1f53d7753ae..19f226428f89 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -57,14 +57,13 @@
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
 
@@ -146,10 +145,9 @@ struct korina_private {
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
@@ -899,8 +897,8 @@ static int korina_init(struct net_device *dev)
 
 	/* Management Clock Prescaler Divisor
 	 * Clock independent setting */
-	writel(((idt_cpu_freq) / MII_CLOCK + 1) & ~1,
-			&lp->eth_regs->ethmcp);
+	writel(((lp->mii_clock_freq) / MII_CLOCK + 1) & ~1,
+	       &lp->eth_regs->ethmcp);
 	writel(0, &lp->eth_regs->miimcfg);
 
 	/* don't transmit until fifo contains 48b */
@@ -1060,6 +1058,7 @@ static int korina_probe(struct platform_device *pdev)
 	u8 *mac_addr = dev_get_platdata(&pdev->dev);
 	struct korina_private *lp;
 	struct net_device *dev;
+	struct clk *clk;
 	void __iomem *p;
 	int rc;
 
@@ -1075,6 +1074,16 @@ static int korina_probe(struct platform_device *pdev)
 	else if (of_get_mac_address(pdev->dev.of_node, dev->dev_addr) < 0)
 		eth_hw_addr_random(dev);
 
+	clk = devm_clk_get_optional(&pdev->dev, "mdioclk");
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+	if (clk) {
+		clk_prepare_enable(clk);
+		lp->mii_clock_freq = clk_get_rate(clk);
+	} else {
+		lp->mii_clock_freq = 200000000; /* max possible input clk */
+	}
+
 	lp->rx_irq = platform_get_irq_byname(pdev, "rx");
 	lp->tx_irq = platform_get_irq_byname(pdev, "tx");
 
-- 
2.29.2

