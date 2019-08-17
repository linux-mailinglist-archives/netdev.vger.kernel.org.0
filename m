Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1841891289
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 20:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfHQS4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 14:56:00 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:53868 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726087AbfHQSy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 14:54:58 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 09872C0E45;
        Sat, 17 Aug 2019 18:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1566068097; bh=A415JeVvlVaO0aRYrNFBAKLZFukQy0W2oShhA2ztv2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=GvzmWVpcK/pr90ZenRijW+zSeI8fnpuTpFUwAKQh3Z1FMF71BdOO/9sXXw4uydt69
         vcUrqg9x0iN+XIxy8pQ4Jh8GahuxGSw5aD7X6PmAYJgYveTdU0TQpscD3m1FyAAMZ7
         3+B8huH6Cg57fxFxp9wWIKbNHuKcAChKvza+p2JRtuoSZTe60nlg/fZ8pDgm2irzPX
         uP8YUYJ23auvewbmYxasEdN+GgEPpKcZ6KKRmZ8ETxfwyGW/EFCPbtob5Dh+QeZiow
         GcXSYwLuj7niJMFUE3OrTKr93Tkn6+ChYBgcUhlwt3XwQq6Ti8V6hWtmQI58HW4Crr
         J/aPu+3/HRiWA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id C5845A0073;
        Sat, 17 Aug 2019 18:54:55 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 07/12] net: stmmac: Add ethtool register dump for XGMAC cores
Date:   Sat, 17 Aug 2019 20:54:46 +0200
Message-Id: <1c5d3261459364eee2399218193d265bd5a0d9a0.1566067803.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1566067802.git.joabreu@synopsys.com>
References: <cover.1566067802.git.joabreu@synopsys.com>
In-Reply-To: <cover.1566067802.git.joabreu@synopsys.com>
References: <cover.1566067802.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the ethtool interface to dump the register map in XGMAC cores.

Changes from v2:
	- Remove uneeded memset (Jakub)

Signed-off-by: Jose Abreu <joabreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |  2 ++
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    | 11 ++++++++++-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c | 10 +++++++++-
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   | 23 +++++++++++++++-------
 4 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
index dbac63972faf..7fed3d2d4a95 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -244,6 +244,7 @@
 #define XGMAC_RXOVFIS			BIT(16)
 #define XGMAC_ABPSIS			BIT(1)
 #define XGMAC_TXUNFIS			BIT(0)
+#define XGMAC_MAC_REGSIZE		(XGMAC_MTL_QINT_STATUS(15) / 4)
 
 /* DMA Registers */
 #define XGMAC_DMA_MODE			0x00003000
@@ -321,6 +322,7 @@
 #define XGMAC_TBU			BIT(2)
 #define XGMAC_TPS			BIT(1)
 #define XGMAC_TI			BIT(0)
+#define XGMAC_REGSIZE			((0x0000317c + (0x80 * 15)) / 4)
 
 /* Descriptors */
 #define XGMAC_TDES2_IOC			BIT(31)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index f843e3640f50..a161285340c6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -239,6 +239,15 @@ static void dwxgmac2_config_cbs(struct mac_device_info *hw,
 	writel(value, ioaddr + XGMAC_MTL_TCx_ETS_CONTROL(queue));
 }
 
+static void dwxgmac2_dump_regs(struct mac_device_info *hw, u32 *reg_space)
+{
+	void __iomem *ioaddr = hw->pcsr;
+	int i;
+
+	for (i = 0; i < XGMAC_MAC_REGSIZE; i++)
+		reg_space[i] = readl(ioaddr + i * 4);
+}
+
 static int dwxgmac2_host_irq_status(struct mac_device_info *hw,
 				    struct stmmac_extra_stats *x)
 {
@@ -1079,7 +1088,7 @@ const struct stmmac_ops dwxgmac210_ops = {
 	.set_mtl_tx_queue_weight = dwxgmac2_set_mtl_tx_queue_weight,
 	.map_mtl_to_dma = dwxgmac2_map_mtl_to_dma,
 	.config_cbs = dwxgmac2_config_cbs,
-	.dump_regs = NULL,
+	.dump_regs = dwxgmac2_dump_regs,
 	.host_irq_status = dwxgmac2_host_irq_status,
 	.host_mtl_irq_status = dwxgmac2_host_mtl_irq_status,
 	.flow_ctrl = dwxgmac2_flow_ctrl,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index 0f3de4895cf7..42c13d144203 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -128,6 +128,14 @@ static void dwxgmac2_dma_axi(void __iomem *ioaddr, struct stmmac_axi *axi)
 	writel(XGMAC_RDPS, ioaddr + XGMAC_RX_EDMA_CTRL);
 }
 
+static void dwxgmac2_dma_dump_regs(void __iomem *ioaddr, u32 *reg_space)
+{
+	int i;
+
+	for (i = (XGMAC_DMA_MODE / 4); i < XGMAC_REGSIZE; i++)
+		reg_space[i] = readl(ioaddr + i * 4);
+}
+
 static void dwxgmac2_dma_rx_mode(void __iomem *ioaddr, int mode,
 				 u32 channel, int fifosz, u8 qmode)
 {
@@ -496,7 +504,7 @@ const struct stmmac_dma_ops dwxgmac210_dma_ops = {
 	.init_rx_chan = dwxgmac2_dma_init_rx_chan,
 	.init_tx_chan = dwxgmac2_dma_init_tx_chan,
 	.axi = dwxgmac2_dma_axi,
-	.dump_regs = NULL,
+	.dump_regs = dwxgmac2_dma_dump_regs,
 	.dma_rx_mode = dwxgmac2_dma_rx_mode,
 	.dma_tx_mode = dwxgmac2_dma_tx_mode,
 	.enable_dma_irq = dwxgmac2_enable_dma_irq,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index eb784fdb6d32..1c450105e5a6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -18,10 +18,12 @@
 
 #include "stmmac.h"
 #include "dwmac_dma.h"
+#include "dwxgmac2.h"
 
 #define REG_SPACE_SIZE	0x1060
 #define MAC100_ETHTOOL_NAME	"st_mac100"
 #define GMAC_ETHTOOL_NAME	"st_gmac"
+#define XGMAC_ETHTOOL_NAME	"st_xgmac"
 
 #define ETHTOOL_DMA_OFFSET	55
 
@@ -260,6 +262,8 @@ static void stmmac_ethtool_getdrvinfo(struct net_device *dev,
 
 	if (priv->plat->has_gmac || priv->plat->has_gmac4)
 		strlcpy(info->driver, GMAC_ETHTOOL_NAME, sizeof(info->driver));
+	else if (priv->plat->has_xgmac)
+		strlcpy(info->driver, XGMAC_ETHTOOL_NAME, sizeof(info->driver));
 	else
 		strlcpy(info->driver, MAC100_ETHTOOL_NAME,
 			sizeof(info->driver));
@@ -405,23 +409,28 @@ static int stmmac_check_if_running(struct net_device *dev)
 
 static int stmmac_ethtool_get_regs_len(struct net_device *dev)
 {
+	struct stmmac_priv *priv = netdev_priv(dev);
+
+	if (priv->plat->has_xgmac)
+		return XGMAC_REGSIZE * 4;
 	return REG_SPACE_SIZE;
 }
 
 static void stmmac_ethtool_gregs(struct net_device *dev,
 			  struct ethtool_regs *regs, void *space)
 {
-	u32 *reg_space = (u32 *) space;
-
 	struct stmmac_priv *priv = netdev_priv(dev);
-
-	memset(reg_space, 0x0, REG_SPACE_SIZE);
+	u32 *reg_space = (u32 *) space;
 
 	stmmac_dump_mac_regs(priv, priv->hw, reg_space);
 	stmmac_dump_dma_regs(priv, priv->ioaddr, reg_space);
-	/* Copy DMA registers to where ethtool expects them */
-	memcpy(&reg_space[ETHTOOL_DMA_OFFSET], &reg_space[DMA_BUS_MODE / 4],
-	       NUM_DWMAC1000_DMA_REGS * 4);
+
+	if (!priv->plat->has_xgmac) {
+		/* Copy DMA registers to where ethtool expects them */
+		memcpy(&reg_space[ETHTOOL_DMA_OFFSET],
+		       &reg_space[DMA_BUS_MODE / 4],
+		       NUM_DWMAC1000_DMA_REGS * 4);
+	}
 }
 
 static int stmmac_nway_reset(struct net_device *dev)
-- 
2.7.4

