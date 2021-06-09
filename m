Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5283A1BE9
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 19:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbhFIRhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 13:37:35 -0400
Received: from out28-123.mail.aliyun.com ([115.124.28.123]:54252 "EHLO
        out28-123.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbhFIRhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 13:37:31 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07436282|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0239554-0.000423683-0.975621;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047206;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=20;RT=20;SR=0;TI=SMTPD_---.KQ26pE3_1623260120;
Received: from localhost.localdomain(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.KQ26pE3_1623260120)
          by smtp.aliyun-inc.com(10.147.41.138);
          Thu, 10 Jun 2021 01:35:32 +0800
From:   =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20=28Zhou=20Yanjie=29?= 
        <zhouyanjie@wanyeetech.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com
Cc:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, dongsheng.qiu@ingenic.com,
        aric.pzqi@ingenic.com, rick.tyliu@ingenic.com,
        sihui.liu@ingenic.com, jun.jiang@ingenic.com,
        sernia.zhou@foxmail.com, paul@crapouillou.net
Subject: [PATCH v2 2/2] net: stmmac: Add Ingenic SoCs MAC support.
Date:   Thu, 10 Jun 2021 01:35:10 +0800
Message-Id: <1623260110-25842-3-git-send-email-zhouyanjie@wanyeetech.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623260110-25842-1-git-send-email-zhouyanjie@wanyeetech.com>
References: <1623260110-25842-1-git-send-email-zhouyanjie@wanyeetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for Ingenic SoC MAC glue layer support for the stmmac
device driver. This driver is used on for the MAC ethernet controller
found in the JZ4775 SoC, the X1000 SoC, the X1600 SoC, the X1830 SoC,
and the X2000 SoC.

Signed-off-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
---

Notes:
    v1->v2:
    1.Fix uninitialized variable.
    2.Add missing RGMII-ID, RGMII-RXID, and RGMII-TXID.
    3.Change variable val from int to unsinged int.
    4.Get tx clock delay and rx clock delay from devicetree.

 drivers/net/ethernet/stmicro/stmmac/Kconfig        |  12 +
 drivers/net/ethernet/stmicro/stmmac/Makefile       |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-ingenic.c    | 434 +++++++++++++++++++++
 3 files changed, 447 insertions(+)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index 7737e4d0..9a19e4d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -66,6 +66,18 @@ config DWMAC_ANARION
 
 	  This selects the Anarion SoC glue layer support for the stmmac driver.
 
+config DWMAC_INGENIC
+	tristate "Ingenic MAC support"
+	default MACH_INGENIC
+	depends on OF && HAS_IOMEM && (MACH_INGENIC || COMPILE_TEST)
+	select MFD_SYSCON
+	help
+	  Support for ethernet controller on Ingenic SoCs.
+
+	  This selects Ingenic SoCs glue layer support for the stmmac
+	  device driver. This driver is used on for the Ingenic SoCs
+	  MAC ethernet controller.
+
 config DWMAC_IPQ806X
 	tristate "QCA IPQ806x DWMAC support"
 	default ARCH_QCOM
diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/ethernet/stmicro/stmmac/Makefile
index f2e478b..6471f93 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Makefile
+++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
@@ -14,6 +14,7 @@ stmmac-$(CONFIG_STMMAC_SELFTESTS) += stmmac_selftests.o
 # Ordering matters. Generic driver must be last.
 obj-$(CONFIG_STMMAC_PLATFORM)	+= stmmac-platform.o
 obj-$(CONFIG_DWMAC_ANARION)	+= dwmac-anarion.o
+obj-$(CONFIG_DWMAC_INGENIC)	+= dwmac-ingenic.o
 obj-$(CONFIG_DWMAC_IPQ806X)	+= dwmac-ipq806x.o
 obj-$(CONFIG_DWMAC_LPC18XX)	+= dwmac-lpc18xx.o
 obj-$(CONFIG_DWMAC_MEDIATEK)	+= dwmac-mediatek.o
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c
new file mode 100644
index 00000000..fbe2727
--- /dev/null
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c
@@ -0,0 +1,434 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * dwmac-ingenic.c - Ingenic SoCs DWMAC specific glue layer
+ *
+ * Copyright (c) 2021 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
+ */
+
+#include <linux/bitfield.h>
+#include <linux/clk.h>
+#include <linux/kernel.h>
+#include <linux/mfd/syscon.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_net.h>
+#include <linux/phy.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+#include <linux/stmmac.h>
+
+#include "stmmac_platform.h"
+
+#define MACPHYC_TXCLK_SEL_MASK		GENMASK(31, 31)
+#define MACPHYC_TXCLK_SEL_OUTPUT	0x1
+#define MACPHYC_TXCLK_SEL_INPUT		0x0
+#define MACPHYC_MODE_SEL_MASK		GENMASK(31, 31)
+#define MACPHYC_MODE_SEL_RMII		0x0
+#define MACPHYC_TX_SEL_MASK			GENMASK(19, 19)
+#define MACPHYC_TX_SEL_ORIGIN		0x0
+#define MACPHYC_TX_SEL_DELAY		0x1
+#define MACPHYC_TX_DELAY_MASK		GENMASK(18, 12)
+#define MACPHYC_TX_DELAY_MAX		0x80
+#define MACPHYC_RX_SEL_MASK			GENMASK(11, 11)
+#define MACPHYC_RX_SEL_ORIGIN		0x0
+#define MACPHYC_RX_SEL_DELAY		0x1
+#define MACPHYC_RX_DELAY_MASK		GENMASK(10, 4)
+#define MACPHYC_RX_DELAY_MAX		0x80
+#define MACPHYC_SOFT_RST_MASK		GENMASK(3, 3)
+#define MACPHYC_PHY_INFT_MASK		GENMASK(2, 0)
+#define MACPHYC_PHY_INFT_RMII		0x4
+#define MACPHYC_PHY_INFT_RGMII		0x1
+#define MACPHYC_PHY_INFT_GMII		0x0
+#define MACPHYC_PHY_INFT_MII		0x0
+
+enum ingenic_mac_version {
+	ID_JZ4775,
+	ID_X1000,
+	ID_X1600,
+	ID_X1830,
+	ID_X2000,
+};
+
+struct ingenic_mac {
+	const struct ingenic_soc_info *soc_info;
+	struct device *dev;
+	struct regmap *regmap;
+
+	int rx_delay;
+	int tx_delay;
+};
+
+struct ingenic_soc_info {
+	enum ingenic_mac_version version;
+	u32 mask;
+
+	int (*set_mode)(struct plat_stmmacenet_data *plat_dat);
+};
+
+static int ingenic_mac_init(struct plat_stmmacenet_data *plat_dat)
+{
+	struct ingenic_mac *mac = plat_dat->bsp_priv;
+	int ret;
+
+	if (mac->soc_info->set_mode) {
+		ret = mac->soc_info->set_mode(plat_dat);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int jz4775_mac_set_mode(struct plat_stmmacenet_data *plat_dat)
+{
+	struct ingenic_mac *mac = plat_dat->bsp_priv;
+	unsigned int val;
+
+	switch (plat_dat->interface) {
+	case PHY_INTERFACE_MODE_MII:
+		val = FIELD_PREP(MACPHYC_TXCLK_SEL_MASK, MACPHYC_TXCLK_SEL_INPUT) |
+			  FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_MII);
+		dev_dbg(mac->dev, "MAC PHY Control Register: PHY_INTERFACE_MODE_MII\n");
+		break;
+
+	case PHY_INTERFACE_MODE_GMII:
+		val = FIELD_PREP(MACPHYC_TXCLK_SEL_MASK, MACPHYC_TXCLK_SEL_INPUT) |
+			  FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_GMII);
+		dev_dbg(mac->dev, "MAC PHY Control Register: PHY_INTERFACE_MODE_GMII\n");
+		break;
+
+	case PHY_INTERFACE_MODE_RMII:
+		val = FIELD_PREP(MACPHYC_TXCLK_SEL_MASK, MACPHYC_TXCLK_SEL_INPUT) |
+			  FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_RMII);
+		dev_dbg(mac->dev, "MAC PHY Control Register: PHY_INTERFACE_MODE_RMII\n");
+		break;
+
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		val = FIELD_PREP(MACPHYC_TXCLK_SEL_MASK, MACPHYC_TXCLK_SEL_INPUT) |
+			  FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_RGMII);
+		dev_dbg(mac->dev, "MAC PHY Control Register: PHY_INTERFACE_MODE_RGMII\n");
+		break;
+
+	default:
+		dev_err(mac->dev, "unsupported interface %d", plat_dat->interface);
+		return -EINVAL;
+	}
+
+	/* Update MAC PHY control register */
+	return regmap_update_bits(mac->regmap, 0, mac->soc_info->mask, val);
+}
+
+static int x1000_mac_set_mode(struct plat_stmmacenet_data *plat_dat)
+{
+	struct ingenic_mac *mac = plat_dat->bsp_priv;
+
+	switch (plat_dat->interface) {
+	case PHY_INTERFACE_MODE_RMII:
+		dev_dbg(mac->dev, "MAC PHY Control Register: PHY_INTERFACE_MODE_RMII\n");
+		break;
+
+	default:
+		dev_err(mac->dev, "unsupported interface %d", plat_dat->interface);
+		return -EINVAL;
+	}
+
+	/* Update MAC PHY control register */
+	return regmap_update_bits(mac->regmap, 0, mac->soc_info->mask, 0);
+}
+
+static int x1600_mac_set_mode(struct plat_stmmacenet_data *plat_dat)
+{
+	struct ingenic_mac *mac = plat_dat->bsp_priv;
+	unsigned int val;
+
+	switch (plat_dat->interface) {
+	case PHY_INTERFACE_MODE_RMII:
+		val = FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_RMII);
+		dev_dbg(mac->dev, "MAC PHY Control Register: PHY_INTERFACE_MODE_RMII\n");
+		break;
+
+	default:
+		dev_err(mac->dev, "unsupported interface %d", plat_dat->interface);
+		return -EINVAL;
+	}
+
+	/* Update MAC PHY control register */
+	return regmap_update_bits(mac->regmap, 0, mac->soc_info->mask, val);
+}
+
+static int x1830_mac_set_mode(struct plat_stmmacenet_data *plat_dat)
+{
+	struct ingenic_mac *mac = plat_dat->bsp_priv;
+	unsigned int val;
+
+	switch (plat_dat->interface) {
+	case PHY_INTERFACE_MODE_RMII:
+		val = FIELD_PREP(MACPHYC_MODE_SEL_MASK, MACPHYC_MODE_SEL_RMII) |
+			  FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_RMII);
+		dev_dbg(mac->dev, "MAC PHY Control Register: PHY_INTERFACE_MODE_RMII\n");
+		break;
+
+	default:
+		dev_err(mac->dev, "unsupported interface %d", plat_dat->interface);
+		return -EINVAL;
+	}
+
+	/* Update MAC PHY control register */
+	return regmap_update_bits(mac->regmap, 0, mac->soc_info->mask, val);
+}
+
+static int x2000_mac_set_mode(struct plat_stmmacenet_data *plat_dat)
+{
+	struct ingenic_mac *mac = plat_dat->bsp_priv;
+	unsigned int val;
+
+	switch (plat_dat->interface) {
+	case PHY_INTERFACE_MODE_RMII:
+		val = FIELD_PREP(MACPHYC_TX_SEL_MASK, MACPHYC_TX_SEL_ORIGIN) |
+			  FIELD_PREP(MACPHYC_RX_SEL_MASK, MACPHYC_RX_SEL_ORIGIN) |
+			  FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_RMII);
+		dev_dbg(mac->dev, "MAC PHY Control Register: PHY_INTERFACE_MODE_RMII\n");
+		break;
+
+	case PHY_INTERFACE_MODE_RGMII:
+		val = FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_RGMII);
+
+		if (mac->tx_delay == 0) {
+			val |= FIELD_PREP(MACPHYC_TX_SEL_MASK, MACPHYC_TX_SEL_ORIGIN);
+		} else {
+			val |= FIELD_PREP(MACPHYC_TX_SEL_MASK, MACPHYC_TX_SEL_DELAY);
+
+			if (mac->tx_delay > MACPHYC_TX_DELAY_MAX)
+				val |= FIELD_PREP(MACPHYC_TX_DELAY_MASK, MACPHYC_TX_DELAY_MAX - 1);
+			else
+				val |= FIELD_PREP(MACPHYC_TX_DELAY_MASK, mac->tx_delay - 1);
+		}
+
+		if (mac->rx_delay == 0) {
+			val |= FIELD_PREP(MACPHYC_RX_SEL_MASK, MACPHYC_RX_SEL_ORIGIN);
+		} else {
+			val |= FIELD_PREP(MACPHYC_RX_SEL_MASK, MACPHYC_RX_SEL_DELAY);
+
+			if (mac->rx_delay > MACPHYC_RX_DELAY_MAX)
+				val |= FIELD_PREP(MACPHYC_RX_DELAY_MASK, MACPHYC_RX_DELAY_MAX - 1);
+			else
+				val |= FIELD_PREP(MACPHYC_RX_DELAY_MASK, mac->rx_delay - 1);
+		}
+
+		dev_dbg(mac->dev, "MAC PHY Control Register: PHY_INTERFACE_MODE_RGMII\n");
+		break;
+
+	case PHY_INTERFACE_MODE_RGMII_ID:
+		val = FIELD_PREP(MACPHYC_TX_SEL_MASK, MACPHYC_TX_SEL_ORIGIN) |
+			  FIELD_PREP(MACPHYC_RX_SEL_MASK, MACPHYC_RX_SEL_ORIGIN) |
+			  FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_RGMII);
+		dev_dbg(mac->dev, "MAC PHY Control Register: PHY_INTERFACE_MODE_RGMII_ID\n");
+		break;
+
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+		val = FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_RGMII) |
+			  FIELD_PREP(MACPHYC_RX_SEL_MASK, MACPHYC_RX_SEL_ORIGIN);
+
+		if (mac->tx_delay == 0) {
+			val |= FIELD_PREP(MACPHYC_TX_SEL_MASK, MACPHYC_TX_SEL_ORIGIN);
+		} else {
+			val |= FIELD_PREP(MACPHYC_TX_SEL_MASK, MACPHYC_TX_SEL_DELAY);
+
+			if (mac->tx_delay > MACPHYC_TX_DELAY_MAX)
+				val |= FIELD_PREP(MACPHYC_TX_DELAY_MASK, MACPHYC_TX_DELAY_MAX - 1);
+			else
+				val |= FIELD_PREP(MACPHYC_TX_DELAY_MASK, mac->tx_delay - 1);
+		}
+
+		dev_dbg(mac->dev, "MAC PHY Control Register: PHY_INTERFACE_MODE_RGMII_RXID\n");
+		break;
+
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		val = FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_RGMII) |
+			  FIELD_PREP(MACPHYC_TX_SEL_MASK, MACPHYC_TX_SEL_ORIGIN);
+
+		if (mac->rx_delay == 0) {
+			val |= FIELD_PREP(MACPHYC_RX_SEL_MASK, MACPHYC_RX_SEL_ORIGIN);
+		} else {
+			val |= FIELD_PREP(MACPHYC_RX_SEL_MASK, MACPHYC_RX_SEL_DELAY);
+
+			if (mac->rx_delay > MACPHYC_RX_DELAY_MAX)
+				val |= FIELD_PREP(MACPHYC_RX_DELAY_MASK, MACPHYC_RX_DELAY_MAX - 1);
+			else
+				val |= FIELD_PREP(MACPHYC_RX_DELAY_MASK, mac->rx_delay - 1);
+		}
+
+		dev_dbg(mac->dev, "MAC PHY Control Register: PHY_INTERFACE_MODE_RGMII_TXID\n");
+		break;
+
+	default:
+		dev_err(mac->dev, "unsupported interface %d", plat_dat->interface);
+		return -EINVAL;
+	}
+
+	/* Update MAC PHY control register */
+	return regmap_update_bits(mac->regmap, 0, mac->soc_info->mask, val);
+}
+
+static int ingenic_mac_probe(struct platform_device *pdev)
+{
+	struct plat_stmmacenet_data *plat_dat;
+	struct stmmac_resources stmmac_res;
+	struct ingenic_mac *mac;
+	const struct ingenic_soc_info *data;
+	int ret;
+
+	ret = stmmac_get_platform_resources(pdev, &stmmac_res);
+	if (ret)
+		return ret;
+
+	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
+	if (IS_ERR(plat_dat))
+		return PTR_ERR(plat_dat);
+
+	mac = devm_kzalloc(&pdev->dev, sizeof(*mac), GFP_KERNEL);
+	if (!mac) {
+		ret = -ENOMEM;
+		goto err_remove_config_dt;
+	}
+
+	data = of_device_get_match_data(&pdev->dev);
+	if (!data) {
+		dev_err(&pdev->dev, "no of match data provided\n");
+		ret = -EINVAL;
+		goto err_remove_config_dt;
+	}
+
+	/* Get MAC PHY control register */
+	mac->regmap = syscon_regmap_lookup_by_phandle(pdev->dev.of_node, "mode-reg");
+	if (IS_ERR(mac->regmap)) {
+		dev_err(&pdev->dev, "%s: failed to get syscon regmap\n", __func__);
+		goto err_remove_config_dt;
+	}
+
+	ret = of_property_read_u32(pdev->dev.of_node, "rx-clk-delay", &mac->rx_delay);
+	if (ret)
+		mac->rx_delay = 0;
+
+	ret = of_property_read_u32(pdev->dev.of_node, "tx-clk-delay", &mac->tx_delay);
+	if (ret)
+		mac->tx_delay = 0;
+
+	mac->soc_info = data;
+	mac->dev = &pdev->dev;
+
+	plat_dat->bsp_priv = mac;
+
+	ret = ingenic_mac_init(plat_dat);
+	if (ret)
+		goto err_remove_config_dt;
+
+	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
+	if (ret)
+		goto err_remove_config_dt;
+
+	return 0;
+
+err_remove_config_dt:
+	stmmac_remove_config_dt(pdev, plat_dat);
+
+	return ret;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int ingenic_mac_suspend(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
+	struct ingenic_mac *mac = priv->plat->bsp_priv;
+	int ret;
+
+	ret = stmmac_suspend(dev);
+
+	return ret;
+}
+
+static int ingenic_mac_resume(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
+	struct ingenic_mac *mac = priv->plat->bsp_priv;
+	int ret;
+
+	ret = ingenic_mac_init(priv->plat);
+	if (ret)
+		return ret;
+
+	ret = stmmac_resume(dev);
+
+	return ret;
+}
+#endif /* CONFIG_PM_SLEEP */
+
+static SIMPLE_DEV_PM_OPS(ingenic_mac_pm_ops, ingenic_mac_suspend, ingenic_mac_resume);
+
+static struct ingenic_soc_info jz4775_soc_info = {
+	.version = ID_JZ4775,
+	.mask = MACPHYC_TXCLK_SEL_MASK | MACPHYC_SOFT_RST_MASK | MACPHYC_PHY_INFT_MASK,
+
+	.set_mode = jz4775_mac_set_mode,
+};
+
+static struct ingenic_soc_info x1000_soc_info = {
+	.version = ID_X1000,
+	.mask = MACPHYC_SOFT_RST_MASK,
+
+	.set_mode = x1000_mac_set_mode,
+};
+
+static struct ingenic_soc_info x1600_soc_info = {
+	.version = ID_X1600,
+	.mask = MACPHYC_SOFT_RST_MASK | MACPHYC_PHY_INFT_MASK,
+
+	.set_mode = x1600_mac_set_mode,
+};
+
+static struct ingenic_soc_info x1830_soc_info = {
+	.version = ID_X1830,
+	.mask = MACPHYC_MODE_SEL_MASK | MACPHYC_SOFT_RST_MASK | MACPHYC_PHY_INFT_MASK,
+
+	.set_mode = x1830_mac_set_mode,
+};
+
+static struct ingenic_soc_info x2000_soc_info = {
+	.version = ID_X2000,
+	.mask = MACPHYC_TX_SEL_MASK | MACPHYC_TX_DELAY_MASK | MACPHYC_RX_SEL_MASK |
+			MACPHYC_RX_DELAY_MASK | MACPHYC_SOFT_RST_MASK | MACPHYC_PHY_INFT_MASK,
+
+	.set_mode = x2000_mac_set_mode,
+};
+
+static const struct of_device_id ingenic_mac_of_matches[] = {
+	{ .compatible = "ingenic,jz4775-mac", .data = &jz4775_soc_info },
+	{ .compatible = "ingenic,x1000-mac", .data = &x1000_soc_info },
+	{ .compatible = "ingenic,x1600-mac", .data = &x1600_soc_info },
+	{ .compatible = "ingenic,x1830-mac", .data = &x1830_soc_info },
+	{ .compatible = "ingenic,x2000-mac", .data = &x2000_soc_info },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, ingenic_mac_of_matches);
+
+static struct platform_driver ingenic_mac_driver = {
+	.probe		= ingenic_mac_probe,
+	.remove		= stmmac_pltfr_remove,
+	.driver		= {
+		.name	= "ingenic-mac",
+		.pm		= pm_ptr(&ingenic_mac_pm_ops),
+		.of_match_table = ingenic_mac_of_matches,
+	},
+};
+module_platform_driver(ingenic_mac_driver);
+
+MODULE_AUTHOR("周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>");
+MODULE_DESCRIPTION("Ingenic SoCs DWMAC specific glue layer");
+MODULE_LICENSE("GPL v2");
-- 
2.7.4

