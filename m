Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736F431B4EF
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 06:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhBOFJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 00:09:28 -0500
Received: from mo-csw1114.securemx.jp ([210.130.202.156]:48748 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhBOFJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 00:09:23 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1114) id 11F576Fl012395; Mon, 15 Feb 2021 14:07:07 +0900
X-Iguazu-Qid: 2wGrPAPDi52AIvgtuP
X-Iguazu-QSIG: v=2; s=0; t=1613365626; q=2wGrPAPDi52AIvgtuP; m=bhWv6D54ja/ABUtVbmVTzcMKGRmKq7pyXd69WYeARMI=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1110) id 11F574JV023385;
        Mon, 15 Feb 2021 14:07:05 +0900
Received: from enc01.toshiba.co.jp ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id 11F574AW014969;
        Mon, 15 Feb 2021 14:07:04 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 11F5742G032210;
        Mon, 15 Feb 2021 14:07:04 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>, leon@kernel.org,
        arnd@kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, punit1.agrawal@toshiba.co.jp,
        yuji2.ishikawa@toshiba.co.jp, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 2/4] net: stmmac: Add Toshiba Visconti SoCs glue driver
Date:   Mon, 15 Feb 2021 14:06:53 +0900
X-TSB-HOP: ON
Message-Id: <20210215050655.2532-3-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.30.0.rc2
In-Reply-To: <20210215050655.2532-1-nobuhiro1.iwamatsu@toshiba.co.jp>
References: <20210215050655.2532-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add dwmac-visconti to the stmmac driver in Toshiba Visconti ARM SoCs.
This patch contains only the basic function of the device. There is no
clock control, PM, etc. yet. These will be added in the future.

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |   8 +
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 .../ethernet/stmicro/stmmac/dwmac-visconti.c  | 285 ++++++++++++++++++
 3 files changed, 294 insertions(+)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index 53f14c5a9e02..55ba67a550b9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -219,6 +219,14 @@ config DWMAC_INTEL_PLAT
 	  This selects the Intel platform specific glue layer support for
 	  the stmmac device driver. This driver is used for the Intel Keem Bay
 	  SoC.
+
+config DWMAC_VISCONTI
+	bool "Toshiba Visconti DWMAC support"
+	def_bool y
+	depends on OF && COMMON_CLK && (ARCH_VISCONTI || COMPILE_TEST)
+	help
+	  Support for ethernet controller on Visconti SoCs.
+
 endif
 
 config DWMAC_INTEL
diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/ethernet/stmicro/stmmac/Makefile
index 24e6145d4eae..366740ab9c5a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Makefile
+++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_DWMAC_DWC_QOS_ETH)	+= dwmac-dwc-qos-eth.o
 obj-$(CONFIG_DWMAC_INTEL_PLAT)	+= dwmac-intel-plat.o
 obj-$(CONFIG_DWMAC_GENERIC)	+= dwmac-generic.o
 obj-$(CONFIG_DWMAC_IMX8)	+= dwmac-imx.o
+obj-$(CONFIG_DWMAC_VISCONTI)	+= dwmac-visconti.o
 stmmac-platform-objs:= stmmac_platform.o
 dwmac-altr-socfpga-objs := altr_tse_pcs.o dwmac-socfpga.o
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
new file mode 100644
index 000000000000..b7a0c57dfbfb
--- /dev/null
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
@@ -0,0 +1,285 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Toshiba Visconti Ethernet Support
+ *
+ * (C) Copyright 2020 TOSHIBA CORPORATION
+ * (C) Copyright 2020 Toshiba Electronic Devices & Storage Corporation
+ */
+
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/of_net.h>
+#include <linux/stmmac.h>
+
+#include "stmmac_platform.h"
+#include "dwmac4.h"
+
+#define REG_ETHER_CONTROL	0x52D4
+#define ETHER_ETH_CONTROL_RESET BIT(17)
+
+#define REG_ETHER_CLOCK_SEL	0x52D0
+#define ETHER_CLK_SEL_TX_CLK_EN BIT(0)
+#define ETHER_CLK_SEL_RX_CLK_EN BIT(1)
+#define ETHER_CLK_SEL_RMII_CLK_EN BIT(2)
+#define ETHER_CLK_SEL_RMII_CLK_RST BIT(3)
+#define ETHER_CLK_SEL_DIV_SEL_2 BIT(4)
+#define ETHER_CLK_SEL_DIV_SEL_20 BIT(0)
+#define ETHER_CLK_SEL_FREQ_SEL_125M	(BIT(9) | BIT(8))
+#define ETHER_CLK_SEL_FREQ_SEL_50M	BIT(9)
+#define ETHER_CLK_SEL_FREQ_SEL_25M	BIT(8)
+#define ETHER_CLK_SEL_FREQ_SEL_2P5M	BIT(0)
+#define ETHER_CLK_SEL_TX_CLK_EXT_SEL_IN BIT(0)
+#define ETHER_CLK_SEL_TX_CLK_EXT_SEL_TXC BIT(10)
+#define ETHER_CLK_SEL_TX_CLK_EXT_SEL_DIV BIT(11)
+#define ETHER_CLK_SEL_RX_CLK_EXT_SEL_IN  BIT(0)
+#define ETHER_CLK_SEL_RX_CLK_EXT_SEL_RXC BIT(12)
+#define ETHER_CLK_SEL_RX_CLK_EXT_SEL_DIV BIT(13)
+#define ETHER_CLK_SEL_TX_CLK_O_TX_I	 BIT(0)
+#define ETHER_CLK_SEL_TX_CLK_O_RMII_I	 BIT(14)
+#define ETHER_CLK_SEL_TX_O_E_N_IN	 BIT(15)
+#define ETHER_CLK_SEL_RMII_CLK_SEL_IN	 BIT(0)
+#define ETHER_CLK_SEL_RMII_CLK_SEL_RX_C	 BIT(16)
+
+#define ETHER_CLK_SEL_RX_TX_CLK_EN (ETHER_CLK_SEL_RX_CLK_EN | ETHER_CLK_SEL_TX_CLK_EN)
+
+#define ETHER_CONFIG_INTF_MII 0
+#define ETHER_CONFIG_INTF_RGMII BIT(0)
+#define ETHER_CONFIG_INTF_RMII BIT(2)
+
+struct visconti_eth {
+	void __iomem *reg;
+	u32 phy_intf_sel;
+	struct clk *phy_ref_clk;
+	spinlock_t lock; /* lock to protect register update */
+};
+
+static void visconti_eth_fix_mac_speed(void *priv, unsigned int speed)
+{
+	struct visconti_eth *dwmac = priv;
+	unsigned int val, clk_sel_val;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dwmac->lock, flags);
+
+	/* adjust link */
+	val = readl(dwmac->reg + MAC_CTRL_REG);
+	val &= ~(GMAC_CONFIG_PS | GMAC_CONFIG_FES);
+
+	switch (speed) {
+	case SPEED_1000:
+		if (dwmac->phy_intf_sel == ETHER_CONFIG_INTF_RGMII)
+			clk_sel_val = ETHER_CLK_SEL_FREQ_SEL_125M;
+		break;
+	case SPEED_100:
+		if (dwmac->phy_intf_sel == ETHER_CONFIG_INTF_RGMII)
+			clk_sel_val = ETHER_CLK_SEL_FREQ_SEL_25M;
+		if (dwmac->phy_intf_sel == ETHER_CONFIG_INTF_RMII)
+			clk_sel_val = ETHER_CLK_SEL_DIV_SEL_2;
+		val |= GMAC_CONFIG_PS | GMAC_CONFIG_FES;
+		break;
+	case SPEED_10:
+		if (dwmac->phy_intf_sel == ETHER_CONFIG_INTF_RGMII)
+			clk_sel_val = ETHER_CLK_SEL_FREQ_SEL_2P5M;
+		if (dwmac->phy_intf_sel == ETHER_CONFIG_INTF_RMII)
+			clk_sel_val = ETHER_CLK_SEL_DIV_SEL_20;
+		val |= GMAC_CONFIG_PS;
+		break;
+	default:
+		/* No bit control */
+		break;
+	}
+
+	writel(val, dwmac->reg + MAC_CTRL_REG);
+
+	/* Stop internal clock */
+	val = readl(dwmac->reg + REG_ETHER_CLOCK_SEL);
+	val &= ~(ETHER_CLK_SEL_RMII_CLK_EN | ETHER_CLK_SEL_RX_TX_CLK_EN);
+	val |= ETHER_CLK_SEL_TX_O_E_N_IN;
+	writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
+
+	switch (dwmac->phy_intf_sel) {
+	case ETHER_CONFIG_INTF_RGMII:
+		val = clk_sel_val | ETHER_CLK_SEL_RX_CLK_EXT_SEL_RXC;
+		break;
+	case ETHER_CONFIG_INTF_RMII:
+		val = clk_sel_val | ETHER_CLK_SEL_RX_CLK_EXT_SEL_DIV |
+			ETHER_CLK_SEL_TX_CLK_EXT_SEL_TXC | ETHER_CLK_SEL_TX_O_E_N_IN |
+			ETHER_CLK_SEL_RMII_CLK_SEL_RX_C;
+		break;
+	case ETHER_CONFIG_INTF_MII:
+	default:
+		val = clk_sel_val | ETHER_CLK_SEL_RX_CLK_EXT_SEL_RXC |
+			ETHER_CLK_SEL_TX_CLK_EXT_SEL_DIV | ETHER_CLK_SEL_TX_O_E_N_IN |
+			ETHER_CLK_SEL_RMII_CLK_EN;
+		break;
+	}
+
+	/* Start clock */
+	writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
+	val |= ETHER_CLK_SEL_RX_TX_CLK_EN;
+	writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
+
+	val &= ~ETHER_CLK_SEL_TX_O_E_N_IN;
+	writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
+
+	spin_unlock_irqrestore(&dwmac->lock, flags);
+}
+
+static int visconti_eth_init_hw(struct platform_device *pdev, struct plat_stmmacenet_data *plat_dat)
+{
+	struct visconti_eth *dwmac = plat_dat->bsp_priv;
+	unsigned int reg_val, clk_sel_val;
+
+	switch (plat_dat->phy_interface) {
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		dwmac->phy_intf_sel = ETHER_CONFIG_INTF_RGMII;
+		break;
+	case PHY_INTERFACE_MODE_MII:
+		dwmac->phy_intf_sel = ETHER_CONFIG_INTF_MII;
+		break;
+	case PHY_INTERFACE_MODE_RMII:
+		dwmac->phy_intf_sel = ETHER_CONFIG_INTF_RMII;
+		break;
+	default:
+		dev_err(&pdev->dev, "Unsupported phy-mode (%d)\n", plat_dat->phy_interface);
+		return -EOPNOTSUPP;
+	}
+
+	reg_val = dwmac->phy_intf_sel;
+	writel(reg_val, dwmac->reg + REG_ETHER_CONTROL);
+
+	/* Enable TX/RX clock */
+	clk_sel_val = ETHER_CLK_SEL_FREQ_SEL_125M;
+	writel(clk_sel_val, dwmac->reg + REG_ETHER_CLOCK_SEL);
+
+	writel((clk_sel_val | ETHER_CLK_SEL_RMII_CLK_EN | ETHER_CLK_SEL_RX_TX_CLK_EN),
+	       dwmac->reg + REG_ETHER_CLOCK_SEL);
+
+	/* release internal-reset */
+	reg_val |= ETHER_ETH_CONTROL_RESET;
+	writel(reg_val, dwmac->reg + REG_ETHER_CONTROL);
+
+	return 0;
+}
+
+static int visconti_eth_clock_probe(struct platform_device *pdev,
+				    struct plat_stmmacenet_data *plat_dat)
+{
+	struct visconti_eth *dwmac = plat_dat->bsp_priv;
+	int err;
+
+	dwmac->phy_ref_clk = devm_clk_get(&pdev->dev, "phy_ref_clk");
+	if (IS_ERR(dwmac->phy_ref_clk)) {
+		dev_err(&pdev->dev, "phy_ref_clk clock not found.\n");
+		return PTR_ERR(dwmac->phy_ref_clk);
+	}
+
+	err = clk_prepare_enable(dwmac->phy_ref_clk);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to enable phy_ref clock: %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
+static int visconti_eth_clock_remove(struct platform_device *pdev)
+{
+	struct visconti_eth *dwmac = get_stmmac_bsp_priv(&pdev->dev);
+	struct net_device *ndev = platform_get_drvdata(pdev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
+
+	clk_disable_unprepare(dwmac->phy_ref_clk);
+	clk_disable_unprepare(priv->plat->stmmac_clk);
+
+	return 0;
+}
+
+static int visconti_eth_dwmac_probe(struct platform_device *pdev)
+{
+	struct plat_stmmacenet_data *plat_dat;
+	struct stmmac_resources stmmac_res;
+	struct visconti_eth *dwmac;
+	int ret;
+
+	ret = stmmac_get_platform_resources(pdev, &stmmac_res);
+	if (ret)
+		return ret;
+
+	plat_dat = stmmac_probe_config_dt(pdev, &stmmac_res.mac);
+	if (IS_ERR(plat_dat))
+		return PTR_ERR(plat_dat);
+
+	dwmac = devm_kzalloc(&pdev->dev, sizeof(*dwmac), GFP_KERNEL);
+	if (!dwmac) {
+		ret = -ENOMEM;
+		goto remove_config;
+	}
+
+	dwmac->reg = stmmac_res.addr;
+	plat_dat->bsp_priv = dwmac;
+	plat_dat->fix_mac_speed = visconti_eth_fix_mac_speed;
+
+	ret = visconti_eth_clock_probe(pdev, plat_dat);
+	if (ret)
+		goto remove_config;
+
+	visconti_eth_init_hw(pdev, plat_dat);
+
+	plat_dat->dma_cfg->aal = 1;
+
+	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
+	if (ret)
+		goto remove;
+
+	return ret;
+
+remove:
+	visconti_eth_clock_remove(pdev);
+remove_config:
+	stmmac_remove_config_dt(pdev, plat_dat);
+
+	return ret;
+}
+
+static int visconti_eth_dwmac_remove(struct platform_device *pdev)
+{
+	struct net_device *ndev = platform_get_drvdata(pdev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
+	int err;
+
+	err = stmmac_pltfr_remove(pdev);
+	if (err < 0)
+		dev_err(&pdev->dev, "failed to remove platform: %d\n", err);
+
+	err = visconti_eth_clock_remove(pdev);
+	if (err < 0)
+		dev_err(&pdev->dev, "failed to remove clock: %d\n", err);
+
+	stmmac_remove_config_dt(pdev, priv->plat);
+
+	return err;
+}
+
+static const struct of_device_id visconti_eth_dwmac_match[] = {
+	{ .compatible = "toshiba,visconti-dwmac" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, visconti_eth_dwmac_match);
+
+static struct platform_driver visconti_eth_dwmac_driver = {
+	.probe  = visconti_eth_dwmac_probe,
+	.remove = visconti_eth_dwmac_remove,
+	.driver = {
+		.name           = "visconti-eth-dwmac",
+		.of_match_table = visconti_eth_dwmac_match,
+	},
+};
+module_platform_driver(visconti_eth_dwmac_driver);
+
+MODULE_AUTHOR("Toshiba");
+MODULE_DESCRIPTION("Toshiba Visconti Ethernet DWMAC glue driver");
+MODULE_AUTHOR("Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp");
+MODULE_LICENSE("GPL v2");
-- 
2.30.0.rc2

