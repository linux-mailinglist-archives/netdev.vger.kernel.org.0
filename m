Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1657849C596
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 09:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238599AbiAZIyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 03:54:05 -0500
Received: from air.basealt.ru ([194.107.17.39]:47547 "EHLO air.basealt.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231156AbiAZIyE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 03:54:04 -0500
Received: by air.basealt.ru (Postfix, from userid 490)
        id 9D4EA5895B6; Wed, 26 Jan 2022 08:45:19 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on
        sa.local.altlinux.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.1
Received: from asheplyakov-rocket.smb.basealt.ru (unknown [193.43.9.4])
        by air.basealt.ru (Postfix) with ESMTPSA id D981558942B;
        Wed, 26 Jan 2022 08:45:16 +0000 (UTC)
From:   Alexey Sheplyakov <asheplyakov@basealt.ru>
To:     netdev@vger.kernel.org
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Alexey Sheplyakov <asheplyakov@basealt.ru>,
        Dmitry Dunaev <dmitry.dunaev@baikalelectronics.ru>
Subject: [PATCH 1/2] net: stmmac: added Baikal-T1/M SoCs glue layer
Date:   Wed, 26 Jan 2022 12:44:55 +0400
Message-Id: <20220126084456.1122873-1-asheplyakov@basealt.ru>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The gigabit Ethernet controller available in Baikal-T1 and Baikal-M
SoCs is a Synopsys DesignWare MAC IP core, already supported by
the stmmac driver.

This patch implements some SoC specific operations (DMA reset and
speed fixup) necessary for Baikal-T1/M variants.

Signed-off-by: Alexey Sheplyakov <asheplyakov@basealt.ru>
Signed-off-by: Dmitry Dunaev <dmitry.dunaev@baikalelectronics.ru>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |  11 +
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 .../ethernet/stmicro/stmmac/dwmac-baikal.c    | 199 ++++++++++++++++++
 .../ethernet/stmicro/stmmac/dwmac1000_core.c  |   1 +
 .../ethernet/stmicro/stmmac/dwmac1000_dma.c   |  46 ++--
 .../ethernet/stmicro/stmmac/dwmac1000_dma.h   |  26 +++
 .../net/ethernet/stmicro/stmmac/dwmac_lib.c   |   8 +
 7 files changed, 274 insertions(+), 18 deletions(-)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-baikal.c
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.h

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index 929cfc22cd0c..d8e6dcb98e6c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -66,6 +66,17 @@ config DWMAC_ANARION
 
 	  This selects the Anarion SoC glue layer support for the stmmac driver.
 
+config DWMAC_BAIKAL
+	tristate "Baikal Electronics GMAC support"
+	default MIPS_BAIKAL_T1
+	depends on OF && (MIPS || ARM64 || COMPILE_TEST)
+	help
+	  Support for gigabit ethernet controller on Baikal Electronics SoCs.
+
+	  This selects the Baikal Electronics SoCs glue layer support for
+	  the stmmac driver. This driver is used for Baikal-T1 and Baikal-M
+	  SoCs gigabit ethernet controller.
+
 config DWMAC_INGENIC
 	tristate "Ingenic MAC support"
 	default MACH_INGENIC
diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/ethernet/stmicro/stmmac/Makefile
index d4e12e9ace4f..ad138062e199 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Makefile
+++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
@@ -14,6 +14,7 @@ stmmac-$(CONFIG_STMMAC_SELFTESTS) += stmmac_selftests.o
 # Ordering matters. Generic driver must be last.
 obj-$(CONFIG_STMMAC_PLATFORM)	+= stmmac-platform.o
 obj-$(CONFIG_DWMAC_ANARION)	+= dwmac-anarion.o
+obj-$(CONFIG_DWMAC_BAIKAL)	+= dwmac-baikal.o
 obj-$(CONFIG_DWMAC_INGENIC)	+= dwmac-ingenic.o
 obj-$(CONFIG_DWMAC_IPQ806X)	+= dwmac-ipq806x.o
 obj-$(CONFIG_DWMAC_LPC18XX)	+= dwmac-lpc18xx.o
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-baikal.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-baikal.c
new file mode 100644
index 000000000000..9133188a5d1b
--- /dev/null
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-baikal.c
@@ -0,0 +1,199 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Baikal-T1/M SoCs DWMAC glue layer
+ *
+ * Copyright (C) 2015,2016,2021 Baikal Electronics JSC
+ * Copyright (C) 2020-2022 BaseALT Ltd
+ * Authors: Dmitry Dunaev <dmitry.dunaev@baikalelectronics.ru>
+ *          Alexey Sheplyakov <asheplyakov@basealt.ru>
+ */
+
+#include <linux/clk.h>
+#include <linux/iopoll.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+
+#include "stmmac.h"
+#include "stmmac_platform.h"
+#include "common.h"
+#include "dwmac_dma.h"
+#include "dwmac1000_dma.h"
+
+#define MAC_GPIO	0x00e0	/* GPIO register */
+#define MAC_GPIO_GPO	BIT(8)	/* Output port */
+
+struct baikal_dwmac {
+	struct device	*dev;
+	struct clk	*tx2_clk;
+};
+
+static int baikal_dwmac_dma_reset(void __iomem *ioaddr)
+{
+	int err;
+	u32 value;
+
+	/* DMA SW reset */
+	value = readl(ioaddr + DMA_BUS_MODE);
+	value |= DMA_BUS_MODE_SFT_RESET;
+	writel(value, ioaddr + DMA_BUS_MODE);
+
+	usleep_range(100, 120);
+
+	/* Clear PHY reset */
+	value = readl(ioaddr + MAC_GPIO);
+	value |= MAC_GPIO_GPO;
+	writel(value, ioaddr + MAC_GPIO);
+
+	return readl_poll_timeout(ioaddr + DMA_BUS_MODE, value,
+				  !(value & DMA_BUS_MODE_SFT_RESET),
+				  10000, 1000000);
+}
+
+static const struct stmmac_dma_ops baikal_dwmac_dma_ops = {
+	.reset = baikal_dwmac_dma_reset,
+	.init = dwmac1000_dma_init,
+	.init_rx_chan = dwmac1000_dma_init_rx,
+	.init_tx_chan = dwmac1000_dma_init_tx,
+	.axi = dwmac1000_dma_axi,
+	.dump_regs = dwmac1000_dump_dma_regs,
+	.dma_rx_mode = dwmac1000_dma_operation_mode_rx,
+	.dma_tx_mode = dwmac1000_dma_operation_mode_tx,
+	.enable_dma_transmission = dwmac_enable_dma_transmission,
+	.enable_dma_irq = dwmac_enable_dma_irq,
+	.disable_dma_irq = dwmac_disable_dma_irq,
+	.start_tx = dwmac_dma_start_tx,
+	.stop_tx = dwmac_dma_stop_tx,
+	.start_rx = dwmac_dma_start_rx,
+	.stop_rx = dwmac_dma_stop_rx,
+	.dma_interrupt = dwmac_dma_interrupt,
+	.get_hw_feature = dwmac1000_get_hw_feature,
+	.rx_watchdog = dwmac1000_rx_watchdog
+};
+
+static struct mac_device_info *baikal_dwmac_setup(void *ppriv)
+{
+	struct mac_device_info *mac;
+	struct stmmac_priv *priv = ppriv;
+	int ret;
+	u32 value;
+
+	mac = devm_kzalloc(priv->device, sizeof(*mac), GFP_KERNEL);
+	if (!mac)
+		return NULL;
+
+	/* Clear PHY reset */
+	value = readl(priv->ioaddr + MAC_GPIO);
+	value |= MAC_GPIO_GPO;
+	writel(value, priv->ioaddr + MAC_GPIO);
+
+	mac->dma = &baikal_dwmac_dma_ops;
+	priv->hw = mac;
+	ret = dwmac1000_setup(priv);
+	if (ret) {
+		dev_err(priv->device, "dwmac1000_setup: error %d", ret);
+		return NULL;
+	}
+
+	return mac;
+}
+
+static void baikal_dwmac_fix_mac_speed(void *priv, unsigned int speed)
+{
+	struct baikal_dwmac *dwmac = priv;
+	unsigned long tx2_clk_freq;
+
+	switch (speed) {
+	case SPEED_1000:
+		tx2_clk_freq = 250000000;
+		break;
+	case SPEED_100:
+		tx2_clk_freq = 50000000;
+		break;
+	case SPEED_10:
+		tx2_clk_freq = 5000000;
+		break;
+	default:
+		dev_warn(dwmac->dev, "invalid speed: %u\n", speed);
+		return;
+	}
+	dev_dbg(dwmac->dev, "speed %u, setting TX2 clock frequency to %lu\n",
+		speed, tx2_clk_freq);
+	clk_set_rate(dwmac->tx2_clk, tx2_clk_freq);
+}
+
+static int dwmac_baikal_probe(struct platform_device *pdev)
+{
+	struct plat_stmmacenet_data *plat_dat;
+	struct stmmac_resources stmmac_res;
+	struct baikal_dwmac *dwmac;
+	int ret;
+
+	dwmac = devm_kzalloc(&pdev->dev, sizeof(*dwmac), GFP_KERNEL);
+	if (!dwmac)
+		return -ENOMEM;
+
+	ret = stmmac_get_platform_resources(pdev, &stmmac_res);
+	if (ret)
+		return ret;
+
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+	if (ret) {
+		dev_err(&pdev->dev, "no suitable DMA available\n");
+		return ret;
+	}
+
+	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
+	if (IS_ERR(plat_dat)) {
+		dev_err(&pdev->dev, "dt configuration failed\n");
+		return PTR_ERR(plat_dat);
+	}
+
+	dwmac->dev = &pdev->dev;
+	dwmac->tx2_clk = devm_clk_get_optional(dwmac->dev, "tx2_clk");
+	if (IS_ERR(dwmac->tx2_clk)) {
+		ret = PTR_ERR(dwmac->tx2_clk);
+		dev_err(&pdev->dev, "couldn't get TX2 clock: %d\n", ret);
+		goto err_remove_config_dt;
+	}
+
+	if (dwmac->tx2_clk)
+		plat_dat->fix_mac_speed = baikal_dwmac_fix_mac_speed;
+	plat_dat->bsp_priv = dwmac;
+	plat_dat->has_gmac = 1;
+	plat_dat->enh_desc = 1;
+	plat_dat->tx_coe = 1;
+	plat_dat->rx_coe = 1;
+	plat_dat->clk_csr = 3;
+	plat_dat->setup = baikal_dwmac_setup;
+
+	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
+	if (ret)
+		goto err_remove_config_dt;
+
+	return 0;
+
+err_remove_config_dt:
+	stmmac_remove_config_dt(pdev, plat_dat);
+	return ret;
+}
+
+static const struct of_device_id dwmac_baikal_match[] = {
+	{ .compatible = "baikal,dwmac" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, dwmac_baikal_match);
+
+static struct platform_driver dwmac_baikal_driver = {
+	.probe	= dwmac_baikal_probe,
+	.remove	= stmmac_pltfr_remove,
+	.driver	= {
+		.name = "baikal-dwmac",
+		.pm = &stmmac_pltfr_pm_ops,
+		.of_match_table = of_match_ptr(dwmac_baikal_match)
+	}
+};
+module_platform_driver(dwmac_baikal_driver);
+
+MODULE_DESCRIPTION("Baikal-T1/M DWMAC driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index 76edb9b72675..7b8a955d98a9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -563,3 +563,4 @@ int dwmac1000_setup(struct stmmac_priv *priv)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(dwmac1000_setup);
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c
index f5581db0ba9b..1782a65cc9af 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c
@@ -15,8 +15,9 @@
 #include <asm/io.h>
 #include "dwmac1000.h"
 #include "dwmac_dma.h"
+#include "dwmac1000_dma.h"
 
-static void dwmac1000_dma_axi(void __iomem *ioaddr, struct stmmac_axi *axi)
+void dwmac1000_dma_axi(void __iomem *ioaddr, struct stmmac_axi *axi)
 {
 	u32 value = readl(ioaddr + DMA_AXI_BUS_MODE);
 	int i;
@@ -69,9 +70,10 @@ static void dwmac1000_dma_axi(void __iomem *ioaddr, struct stmmac_axi *axi)
 
 	writel(value, ioaddr + DMA_AXI_BUS_MODE);
 }
+EXPORT_SYMBOL_GPL(dwmac1000_dma_axi);
 
-static void dwmac1000_dma_init(void __iomem *ioaddr,
-			       struct stmmac_dma_cfg *dma_cfg, int atds)
+void dwmac1000_dma_init(void __iomem *ioaddr,
+			struct stmmac_dma_cfg *dma_cfg, int atds)
 {
 	u32 value = readl(ioaddr + DMA_BUS_MODE);
 	int txpbl = dma_cfg->txpbl ?: dma_cfg->pbl;
@@ -109,22 +111,25 @@ static void dwmac1000_dma_init(void __iomem *ioaddr,
 	/* Mask interrupts by writing to CSR7 */
 	writel(DMA_INTR_DEFAULT_MASK, ioaddr + DMA_INTR_ENA);
 }
+EXPORT_SYMBOL_GPL(dwmac1000_dma_init);
 
-static void dwmac1000_dma_init_rx(void __iomem *ioaddr,
-				  struct stmmac_dma_cfg *dma_cfg,
-				  dma_addr_t dma_rx_phy, u32 chan)
+void dwmac1000_dma_init_rx(void __iomem *ioaddr,
+			   struct stmmac_dma_cfg *dma_cfg,
+			   dma_addr_t dma_rx_phy, u32 chan)
 {
 	/* RX descriptor base address list must be written into DMA CSR3 */
 	writel(lower_32_bits(dma_rx_phy), ioaddr + DMA_RCV_BASE_ADDR);
 }
+EXPORT_SYMBOL_GPL(dwmac1000_dma_init_rx);
 
-static void dwmac1000_dma_init_tx(void __iomem *ioaddr,
-				  struct stmmac_dma_cfg *dma_cfg,
-				  dma_addr_t dma_tx_phy, u32 chan)
+void dwmac1000_dma_init_tx(void __iomem *ioaddr,
+			   struct stmmac_dma_cfg *dma_cfg,
+			   dma_addr_t dma_tx_phy, u32 chan)
 {
 	/* TX descriptor base address list must be written into DMA CSR4 */
 	writel(lower_32_bits(dma_tx_phy), ioaddr + DMA_TX_BASE_ADDR);
 }
+EXPORT_SYMBOL_GPL(dwmac1000_dma_init_tx);
 
 static u32 dwmac1000_configure_fc(u32 csr6, int rxfifosz)
 {
@@ -147,8 +152,8 @@ static u32 dwmac1000_configure_fc(u32 csr6, int rxfifosz)
 	return csr6;
 }
 
-static void dwmac1000_dma_operation_mode_rx(void __iomem *ioaddr, int mode,
-					    u32 channel, int fifosz, u8 qmode)
+void dwmac1000_dma_operation_mode_rx(void __iomem *ioaddr, int mode,
+				     u32 channel, int fifosz, u8 qmode)
 {
 	u32 csr6 = readl(ioaddr + DMA_CONTROL);
 
@@ -174,9 +179,10 @@ static void dwmac1000_dma_operation_mode_rx(void __iomem *ioaddr, int mode,
 
 	writel(csr6, ioaddr + DMA_CONTROL);
 }
+EXPORT_SYMBOL_GPL(dwmac1000_dma_operation_mode_rx);
 
-static void dwmac1000_dma_operation_mode_tx(void __iomem *ioaddr, int mode,
-					    u32 channel, int fifosz, u8 qmode)
+void dwmac1000_dma_operation_mode_tx(void __iomem *ioaddr, int mode,
+				     u32 channel, int fifosz, u8 qmode)
 {
 	u32 csr6 = readl(ioaddr + DMA_CONTROL);
 
@@ -207,8 +213,9 @@ static void dwmac1000_dma_operation_mode_tx(void __iomem *ioaddr, int mode,
 
 	writel(csr6, ioaddr + DMA_CONTROL);
 }
+EXPORT_SYMBOL_GPL(dwmac1000_dma_operation_mode_tx);
 
-static void dwmac1000_dump_dma_regs(void __iomem *ioaddr, u32 *reg_space)
+void dwmac1000_dump_dma_regs(void __iomem *ioaddr, u32 *reg_space)
 {
 	int i;
 
@@ -217,9 +224,10 @@ static void dwmac1000_dump_dma_regs(void __iomem *ioaddr, u32 *reg_space)
 			reg_space[DMA_BUS_MODE / 4 + i] =
 				readl(ioaddr + DMA_BUS_MODE + i * 4);
 }
+EXPORT_SYMBOL_GPL(dwmac1000_dump_dma_regs);
 
-static int dwmac1000_get_hw_feature(void __iomem *ioaddr,
-				    struct dma_features *dma_cap)
+int dwmac1000_get_hw_feature(void __iomem *ioaddr,
+			     struct dma_features *dma_cap)
 {
 	u32 hw_cap = readl(ioaddr + DMA_HW_FEATURE);
 
@@ -262,12 +270,14 @@ static int dwmac1000_get_hw_feature(void __iomem *ioaddr,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(dwmac1000_get_hw_feature);
 
-static void dwmac1000_rx_watchdog(void __iomem *ioaddr, u32 riwt,
-				  u32 queue)
+void dwmac1000_rx_watchdog(void __iomem *ioaddr, u32 riwt,
+			   u32 queue)
 {
 	writel(riwt, ioaddr + DMA_RX_WATCHDOG);
 }
+EXPORT_SYMBOL_GPL(dwmac1000_rx_watchdog);
 
 const struct stmmac_dma_ops dwmac1000_dma_ops = {
 	.reset = dwmac_dma_reset,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.h b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.h
new file mode 100644
index 000000000000..b254a0734447
--- /dev/null
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef __DWMAC1000_DMA_H__
+#define __DWMAC1000_DMA_H__
+#include "dwmac1000.h"
+
+void dwmac1000_dma_axi(void __iomem *ioaddr, struct stmmac_axi *axi);
+void dwmac1000_dma_init(void __iomem *ioaddr,
+			struct stmmac_dma_cfg *dma_cfg, int atds);
+void dwmac1000_dma_init_rx(void __iomem *ioaddr,
+			   struct stmmac_dma_cfg *dma_cfg,
+			   dma_addr_t dma_rx_phy, u32 chan);
+void dwmac1000_dma_init_tx(void __iomem *ioaddr,
+			   struct stmmac_dma_cfg *dma_cfg,
+			   dma_addr_t dma_tx_phy, u32 chan);
+void dwmac1000_dma_operation_mode_rx(void __iomem *ioaddr, int mode,
+				     u32 channel, int fifosz, u8 qmode);
+void dwmac1000_dma_operation_mode_tx(void __iomem *ioaddr, int mode,
+				     u32 channel, int fifosz, u8 qmode);
+void dwmac1000_dump_dma_regs(void __iomem *ioaddr, u32 *reg_space);
+
+int  dwmac1000_get_hw_feature(void __iomem *ioaddr,
+			      struct dma_features *dma_cap);
+
+void dwmac1000_rx_watchdog(void __iomem *ioaddr, u32 riwt, u32 number_chan);
+#endif /* __DWMAC1000_DMA_H__ */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
index caa4bfc4c1d6..2d8d1b0e2b98 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
@@ -31,6 +31,7 @@ void dwmac_enable_dma_transmission(void __iomem *ioaddr)
 {
 	writel(1, ioaddr + DMA_XMT_POLL_DEMAND);
 }
+EXPORT_SYMBOL_GPL(dwmac_enable_dma_transmission);
 
 void dwmac_enable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
 {
@@ -43,6 +44,7 @@ void dwmac_enable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
 
 	writel(value, ioaddr + DMA_INTR_ENA);
 }
+EXPORT_SYMBOL_GPL(dwmac_enable_dma_irq);
 
 void dwmac_disable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
 {
@@ -55,6 +57,7 @@ void dwmac_disable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
 
 	writel(value, ioaddr + DMA_INTR_ENA);
 }
+EXPORT_SYMBOL_GPL(dwmac_disable_dma_irq);
 
 void dwmac_dma_start_tx(void __iomem *ioaddr, u32 chan)
 {
@@ -62,6 +65,7 @@ void dwmac_dma_start_tx(void __iomem *ioaddr, u32 chan)
 	value |= DMA_CONTROL_ST;
 	writel(value, ioaddr + DMA_CONTROL);
 }
+EXPORT_SYMBOL_GPL(dwmac_dma_start_tx);
 
 void dwmac_dma_stop_tx(void __iomem *ioaddr, u32 chan)
 {
@@ -69,6 +73,7 @@ void dwmac_dma_stop_tx(void __iomem *ioaddr, u32 chan)
 	value &= ~DMA_CONTROL_ST;
 	writel(value, ioaddr + DMA_CONTROL);
 }
+EXPORT_SYMBOL_GPL(dwmac_dma_stop_tx);
 
 void dwmac_dma_start_rx(void __iomem *ioaddr, u32 chan)
 {
@@ -76,6 +81,7 @@ void dwmac_dma_start_rx(void __iomem *ioaddr, u32 chan)
 	value |= DMA_CONTROL_SR;
 	writel(value, ioaddr + DMA_CONTROL);
 }
+EXPORT_SYMBOL_GPL(dwmac_dma_start_rx);
 
 void dwmac_dma_stop_rx(void __iomem *ioaddr, u32 chan)
 {
@@ -83,6 +89,7 @@ void dwmac_dma_stop_rx(void __iomem *ioaddr, u32 chan)
 	value &= ~DMA_CONTROL_SR;
 	writel(value, ioaddr + DMA_CONTROL);
 }
+EXPORT_SYMBOL_GPL(dwmac_dma_stop_rx);
 
 #ifdef DWMAC_DMA_DEBUG
 static void show_tx_process_state(unsigned int status)
@@ -230,6 +237,7 @@ int dwmac_dma_interrupt(void __iomem *ioaddr,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(dwmac_dma_interrupt);
 
 void dwmac_dma_flush_tx_fifo(void __iomem *ioaddr)
 {
-- 
2.32.0

