Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B40549FCF3
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 16:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237957AbiA1Pgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 10:36:55 -0500
Received: from smtp2.axis.com ([195.60.68.18]:49468 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231994AbiA1Pgz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 10:36:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1643384215;
  x=1674920215;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QRa1Eccx+diOP5X9GiLVxGI3Jr2Yst13CY1xK607F/4=;
  b=A9XtqF67HePwlIPYNlgeLyrvimfu01CEJNkOtQ0L6spX1it9pfK8CZFR
   tADJcRr0Mjsru1E0b4Bt2q6dTwIsESwx7DYv1h+tHIyn9uE8Dvmm9xUA2
   CE11f1Py8JyyMCGhYc8PRD1ukunDSx5D/gA7wWSRRFQw1YRWhcsiOgfRX
   TSePbYRFz9KKkz/cruLvLA9KTFG+zlEhP5hDurnddq+1XFgYMuLY0AP5D
   zL2cTiiYiBfuyl8sXVhcPSHcPkvRE9P8avvNJODat0L5zuoonn/GlFo6i
   r6dkj4TzucxIrrU5lo4OVioItvi4CnrJfkeoIB5uZL0ZacqkYVoRvF8zN
   Q==;
From:   Camel Guo <camel.guo@axis.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     <kernel@axis.com>, Camel Guo <camelg@axis.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: stmmac: dump gmac4 DMA registers correctly
Date:   Fri, 28 Jan 2022 16:36:42 +0100
Message-ID: <20220128153642.3129922-1-camel.guo@axis.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Camel Guo <camelg@axis.com>

Unlike gmac100, gmac1000, gmac4 has 27 DMA registers and they are
located at DMA_CHAN_BASE_ADDR (0x1100). In order for ethtool to dump
gmac4 DMA registers correctly, this commit checks if a net_device has
gmac4 and uses different logic to dump its DMA registers.

This fixes the following KASAN warning, which can normally be triggered
by a command similar like "ethtool -d eth0":

BUG: KASAN: vmalloc-out-of-bounds in dwmac4_dump_dma_regs+0x6d4/0xb30
Write of size 4 at addr ffffffc010177100 by task ethtool/1839
 kasan_report+0x200/0x21c
 __asan_report_store4_noabort+0x34/0x60
 dwmac4_dump_dma_regs+0x6d4/0xb30
 stmmac_ethtool_gregs+0x110/0x204
 ethtool_get_regs+0x200/0x4b0
 dev_ethtool+0x1dac/0x3800
 dev_ioctl+0x7c0/0xb50
 sock_ioctl+0x298/0x6c4
 ...

Signed-off-by: Camel Guo <camelg@axis.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac_dma.h   |  1 +
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  | 19 +++++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h b/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h
index 1914ad698cab..acd70b9a3173 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h
@@ -150,6 +150,7 @@
 
 #define NUM_DWMAC100_DMA_REGS	9
 #define NUM_DWMAC1000_DMA_REGS	23
+#define NUM_DWMAC4_DMA_REGS	27
 
 void dwmac_enable_dma_transmission(void __iomem *ioaddr);
 void dwmac_enable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 164dff5ec32e..abfb3cd5958d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -21,10 +21,18 @@
 #include "dwxgmac2.h"
 
 #define REG_SPACE_SIZE	0x1060
+#define GMAC4_REG_SPACE_SIZE	0x116C
 #define MAC100_ETHTOOL_NAME	"st_mac100"
 #define GMAC_ETHTOOL_NAME	"st_gmac"
 #define XGMAC_ETHTOOL_NAME	"st_xgmac"
 
+/* Same as DMA_CHAN_BASE_ADDR defined in dwmac4_dma.h
+ *
+ * It is here because dwmac_dma.h and dwmac4_dam.h can not be included at the
+ * same time due to the conflicting macro names.
+ */
+#define GMAC4_DMA_CHAN_BASE_ADDR  0x00001100
+
 #define ETHTOOL_DMA_OFFSET	55
 
 struct stmmac_stats {
@@ -434,6 +442,8 @@ static int stmmac_ethtool_get_regs_len(struct net_device *dev)
 
 	if (priv->plat->has_xgmac)
 		return XGMAC_REGSIZE * 4;
+	else if (priv->plat->has_gmac4)
+		return GMAC4_REG_SPACE_SIZE;
 	return REG_SPACE_SIZE;
 }
 
@@ -446,8 +456,13 @@ static void stmmac_ethtool_gregs(struct net_device *dev,
 	stmmac_dump_mac_regs(priv, priv->hw, reg_space);
 	stmmac_dump_dma_regs(priv, priv->ioaddr, reg_space);
 
-	if (!priv->plat->has_xgmac) {
-		/* Copy DMA registers to where ethtool expects them */
+	/* Copy DMA registers to where ethtool expects them */
+	if (priv->plat->has_gmac4) {
+		/* GMAC4 dumps its DMA registers at its DMA_CHAN_BASE_ADDR */
+		memcpy(&reg_space[ETHTOOL_DMA_OFFSET],
+		       &reg_space[GMAC4_DMA_CHAN_BASE_ADDR / 4],
+		       NUM_DWMAC4_DMA_REGS * 4);
+	} else if (!priv->plat->has_xgmac) {
 		memcpy(&reg_space[ETHTOOL_DMA_OFFSET],
 		       &reg_space[DMA_BUS_MODE / 4],
 		       NUM_DWMAC1000_DMA_REGS * 4);
-- 
2.30.2

