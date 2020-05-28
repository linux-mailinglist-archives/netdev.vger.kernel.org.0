Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C044B1E5ADF
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 10:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgE1IeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 04:34:11 -0400
Received: from mail-db8eur05on2067.outbound.protection.outlook.com ([40.107.20.67]:57029
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727056AbgE1IeJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 04:34:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VDlgoehj2AgoyFGTGWWvVYLJYZrQDQWizbK5qORlU6a0tAoUzUqisWoF1Jdx+jgCDlQQV7kcV1ByslRNSA3Cnpb8+4pwQvn/xrcVOCPyAgo9tBQzMTnyedflEBRTJhNWyVnueBp1cL/l2bGm0Gue9vvDErlbyIYWD8VBrp7dZ93pIckM+OtwHQoMmZ72ZGRD0AJtVt6ctQtL5X0SDmU5Ph3MD9YhyY6sUP+sOckWTfT1AlQEo9MN7n1H7IJRhSudv1Maj9MgIWjs4LToSOGAw/GXGr0iFZy3RmEYbUN2Y9+TCPlJQTjna1OF8ukcSajk5g9e4i/xoS6cOzUVcx35nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJBt9uSyfJ7K+Az22o0dYOr8K6yYcuh/YiCVFbvcUmo=;
 b=if6b19qvQNw+e35943GtwleMgWL1RtZ2NmoO1xoKY5ykQFz14vA4tmCF89TGQqrJR5WDJCPH9a5wNetwMNR8sEUUBBgfM+wpf2CqwTmCFAWumljOS48PXax5x0+ZbvcE17yujxqVAIHDB9mgi3g07aCopQpvuB7p3ZjOODYRU/7ajHdw7/wquf7NXsngGELChih8BRvT6O3cerwPR8/X0Nwl9j+BrnVkE4g+OuqHRKeK1HClicV91rEU28fUbKbXGN882FUOrFSwdSp+KiCfx4AjrSWKBOjzQR0IuT12eACdkPbYWQfg8LJK78eZgUM5XJ4lH8xKNc36rDehvzxidA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJBt9uSyfJ7K+Az22o0dYOr8K6yYcuh/YiCVFbvcUmo=;
 b=Ed7M7UXby4vNMdnv/+LeFhtWkHbfZuNRVDkp43A+zkHP6JTMP+2PAGKZgqMvajvDg1hai6nASnBjt0JzRN4x022+qjFuavgXdMgIM9c7x106lc8FNQOZX3VPyWfpZRfKY+e34roPP0OIYSHa9SO4pMYRo3WlV6Ejvx7mIPA8xpc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3768.eurprd04.prod.outlook.com
 (2603:10a6:209:1c::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Thu, 28 May
 2020 08:34:05 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3045.018; Thu, 28 May 2020
 08:34:05 +0000
From:   fugang.duan@nxp.com
To:     davem@davemloft.net, andrew@lunn.ch, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, mcoquelin.stm32@gmail.com,
        p.zabel@pengutronix.de, fugang.duan@nxp.com
Subject: [PATCH v2 net 2/3] net: ethernet: dwmac: add ethernet glue logic for NXP imx8 chip
Date:   Thu, 28 May 2020 16:26:24 +0800
Message-Id: <20200528082625.27218-3-fugang.duan@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200528082625.27218-1-fugang.duan@nxp.com>
References: <20200528082625.27218-1-fugang.duan@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR0401CA0014.apcprd04.prod.outlook.com
 (2603:1096:3:1::24) To AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b38611-OptiPlex-7040.ap.freescale.net (119.31.174.66) by SG2PR0401CA0014.apcprd04.prod.outlook.com (2603:1096:3:1::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Thu, 28 May 2020 08:33:59 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 31668c71-2f12-444c-d204-08d802e1e040
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3768:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB376816950D2530F166F01EB2FF8E0@AM6PR0402MB3768.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X3d0iQ6uWdiUHrErIwSpppc3o73T6U9mRrZcScY/lZriCDq3mMRkpGhDphlSA3ThWmGmmY5O82BO8oFTfoPT1MaAHlXZlqah7ewHMrYnfRvu68GW/uPbzq4f4cO28nKQgUEulCAMXGBFMSp4DkOF8GNBY624xiTxlkatzhF+fiU54u2URpvOe4lmYN0t6DyT4Bn7H5grRNh2XS0d7nJWg8KDSk7SLBXZxeiZyIvbEl81pT386/JYcyCXpI1nFoZh1Om/jxHcODdhRTBcs6Ft4DlhszlRUVS8JfoldFeKs0V15aeBafxFGMY5y5p88+SrHHDQ/g43AXvUo4i7GKcY6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(376002)(346002)(136003)(39860400002)(5660300002)(8676002)(36756003)(26005)(86362001)(16526019)(186003)(1076003)(6486002)(52116002)(6506007)(478600001)(8936002)(66476007)(66946007)(316002)(66556008)(9686003)(6512007)(2616005)(2906002)(956004)(83380400001)(6666004)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: GX/6+z3wRx1QD+TqKxE7rchLKcygKD3G5enp+zqt9muvrezIfCXgaUh6dGf4ubEwXx0kbZq796rzlRa71tDmUT6/+ObAbpKqdx96K3OV3xSaqD9NCjZ8Aau+VhQqEoN3j2MyXSsZpf4juvpRYW/uxpuZEMNfBXWPMsBZLQJSJXLxsXvTKXd92Va5/hUxtOziC2RG/dQv1Wjt/VBNCvyCETujopEKc0jRLSN/pYYzfN8447eoYaeM7qJRrMYwHowlD0PCfeidsAi0E7+e236sak1W1oBbRiakyjlwTk1xTweA/cfeCBzLFWS2nxIXupaMAPB22iF7CCvZTrI/Djpsv/owYRlgTiuVhAbf/JeNLXeLX2hazP3B9YPkzWEBx9J8j+BEt+GTGbBvYtpZyvCsEUJD3aLOxW8sekTsUNJ8kBe5rPuo7bH1a+ovk9InfsiP/EIeZiYF0I13O1x386LPrWAs8kzsNfa4SAF6qZ9Z3wryT86pbGU1ZfqA5DNc5AgR
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31668c71-2f12-444c-d204-08d802e1e040
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 08:34:05.3640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: olHFBJbXvG37A9+VGMDIxE48PdVpzYH/f+HC45MeHbzBpg70AqcmKsRJu0NzfHQCbtFJE5wgX6YcOoJg6Oi7lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3768
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

NXP imx8 family like imx8mp/imx8dxl chips support Synopsys MAC 5.10a IP.
This patch adds settings for NXP imx8 glue layer:
- clocks
- dwmac address width
- phy interface mode selection
- adjust rgmii txclk rate

v2:
- adjust code sequences in order to have reverse christmas
  tree local variable ordering.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |  13 +
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-imx.c   | 315 ++++++++++++++++++
 3 files changed, 329 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index b46f8d2ae6d7..36bd2e18f23b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -196,6 +196,19 @@ config DWMAC_SUN8I
 	  This selects Allwinner SoC glue layer support for the
 	  stmmac device driver. This driver is used for H3/A83T/A64
 	  EMAC ethernet controller.
+
+config DWMAC_IMX8
+	tristate "NXP IMX8 DWMAC support"
+	default ARCH_MXC
+	depends on OF && (ARCH_MXC || COMPILE_TEST)
+	select MFD_SYSCON
+	---help---
+	  Support for ethernet controller on NXP i.MX8 SOCs.
+
+	  This selects NXP SoC glue layer support for the stmmac
+	  device driver. This driver is used for i.MX8 series like
+	  iMX8MP/iMX8DXL GMAC ethernet controller.
+
 endif
 
 config DWMAC_INTEL
diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/ethernet/stmicro/stmmac/Makefile
index f9d024d6b69b..295615ab36a7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Makefile
+++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_DWMAC_SUNXI)	+= dwmac-sunxi.o
 obj-$(CONFIG_DWMAC_SUN8I)	+= dwmac-sun8i.o
 obj-$(CONFIG_DWMAC_DWC_QOS_ETH)	+= dwmac-dwc-qos-eth.o
 obj-$(CONFIG_DWMAC_GENERIC)	+= dwmac-generic.o
+obj-$(CONFIG_DWMAC_IMX8)	+= dwmac-imx.o
 stmmac-platform-objs:= stmmac_platform.o
 dwmac-altr-socfpga-objs := altr_tse_pcs.o dwmac-socfpga.o
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
new file mode 100644
index 000000000000..5010af7dab4a
--- /dev/null
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
@@ -0,0 +1,315 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * dwmac-imx.c - DWMAC Specific Glue layer for NXP imx8
+ *
+ * Copyright 2020 NXP
+ *
+ */
+
+#include <linux/clk.h>
+#include <linux/gpio/consumer.h>
+#include <linux/kernel.h>
+#include <linux/mfd/syscon.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_net.h>
+#include <linux/phy.h>
+#include <linux/platform_device.h>
+#include <linux/pm_wakeirq.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+#include <linux/stmmac.h>
+
+#include "stmmac_platform.h"
+
+#define GPR_ENET_QOS_INTF_MODE_MASK	GENMASK(21, 16)
+#define GPR_ENET_QOS_INTF_SEL_MII	(0x0 << 16)
+#define GPR_ENET_QOS_INTF_SEL_RMII	(0x4 << 16)
+#define GPR_ENET_QOS_INTF_SEL_RGMII	(0x1 << 16)
+#define GPR_ENET_QOS_CLK_GEN_EN		(0x1 << 19)
+#define GPR_ENET_QOS_CLK_TX_CLK_SEL	(0x1 << 20)
+#define GPR_ENET_QOS_RGMII_EN		(0x1 << 21)
+
+struct imx_dwmac_ops {
+	u32 addr_width;
+	bool mac_rgmii_txclk_auto_adj;
+
+	int (*set_intf_mode)(struct plat_stmmacenet_data *plat_dat);
+};
+
+struct imx_priv_data {
+	struct device *dev;
+	struct clk *clk_tx;
+	struct clk *clk_mem;
+	struct regmap *intf_regmap;
+	u32 intf_reg_off;
+	bool rmii_refclk_ext;
+
+	const struct imx_dwmac_ops *ops;
+	struct plat_stmmacenet_data *plat_dat;
+};
+
+static int imx8mp_set_intf_mode(struct plat_stmmacenet_data *plat_dat)
+{
+	struct imx_priv_data *dwmac = plat_dat->bsp_priv;
+	int val;
+
+	switch (plat_dat->interface) {
+	case PHY_INTERFACE_MODE_MII:
+		val = GPR_ENET_QOS_INTF_SEL_MII;
+		break;
+	case PHY_INTERFACE_MODE_RMII:
+		val = GPR_ENET_QOS_INTF_SEL_RMII;
+		val |= (dwmac->rmii_refclk_ext ? 0 : GPR_ENET_QOS_CLK_TX_CLK_SEL);
+		break;
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		val = GPR_ENET_QOS_INTF_SEL_RGMII |
+		      GPR_ENET_QOS_RGMII_EN;
+		break;
+	default:
+		pr_debug("imx dwmac doesn't support %d interface\n",
+			 plat_dat->interface);
+		return -EINVAL;
+	}
+
+	val |= GPR_ENET_QOS_CLK_GEN_EN;
+	return regmap_update_bits(dwmac->intf_regmap, dwmac->intf_reg_off,
+				  GPR_ENET_QOS_INTF_MODE_MASK, val);
+};
+
+static int
+imx8dxl_set_intf_mode(struct plat_stmmacenet_data *plat_dat)
+{
+	int ret = 0;
+
+	/* TBD: depends on imx8dxl scu interfaces to be upstreamed */
+	return ret;
+}
+
+static int imx_dwmac_init(struct platform_device *pdev, void *priv)
+{
+	struct plat_stmmacenet_data *plat_dat;
+	struct imx_priv_data *dwmac = priv;
+	int ret;
+
+	plat_dat = dwmac->plat_dat;
+
+	ret = clk_prepare_enable(dwmac->clk_mem);
+	if (ret) {
+		dev_err(&pdev->dev, "mem clock enable failed\n");
+		return ret;
+	}
+
+	ret = clk_prepare_enable(dwmac->clk_tx);
+	if (ret) {
+		dev_err(&pdev->dev, "tx clock enable failed\n");
+		goto clk_tx_en_failed;
+	}
+
+	if (dwmac->ops->set_intf_mode) {
+		ret = dwmac->ops->set_intf_mode(plat_dat);
+		if (ret)
+			goto intf_mode_failed;
+	}
+
+	return 0;
+
+intf_mode_failed:
+	clk_disable_unprepare(dwmac->clk_tx);
+clk_tx_en_failed:
+	clk_disable_unprepare(dwmac->clk_mem);
+	return ret;
+}
+
+static void imx_dwmac_exit(struct platform_device *pdev, void *priv)
+{
+	struct imx_priv_data *dwmac = priv;
+
+	if (dwmac->clk_tx)
+		clk_disable_unprepare(dwmac->clk_tx);
+	clk_disable_unprepare(dwmac->clk_mem);
+}
+
+static void imx_dwmac_fix_speed(void *priv, unsigned int speed)
+{
+	struct plat_stmmacenet_data *plat_dat;
+	struct imx_priv_data *dwmac = priv;
+	unsigned long rate;
+	int err;
+
+	plat_dat = dwmac->plat_dat;
+
+	if (dwmac->ops->mac_rgmii_txclk_auto_adj ||
+	    (plat_dat->interface == PHY_INTERFACE_MODE_RMII) ||
+	    (plat_dat->interface == PHY_INTERFACE_MODE_MII))
+		return;
+
+	switch (speed) {
+	case SPEED_1000:
+		rate = 125000000;
+		break;
+	case SPEED_100:
+		rate = 25000000;
+		break;
+	case SPEED_10:
+		rate = 2500000;
+		break;
+	default:
+		dev_err(dwmac->dev, "invalid speed %u\n", speed);
+		return;
+	}
+
+	err = clk_set_rate(dwmac->clk_tx, rate);
+	if (err < 0)
+		dev_err(dwmac->dev, "failed to set tx rate %lu\n", rate);
+}
+
+static int
+imx_dwmac_parse_dt(struct imx_priv_data *dwmac, struct device *dev)
+{
+	struct device_node *np = dev->of_node;
+	int err = 0;
+
+	if (of_get_property(np, "snps,rmii_refclk_ext", NULL))
+		dwmac->rmii_refclk_ext = true;
+
+	dwmac->clk_tx = devm_clk_get(dev, "tx");
+	if (IS_ERR(dwmac->clk_tx)) {
+		dev_err(dev, "failed to get tx clock\n");
+		return PTR_ERR(dwmac->clk_tx);
+	}
+
+	dwmac->clk_mem = NULL;
+	if (of_machine_is_compatible("fsl,imx8dxl")) {
+		dwmac->clk_mem = devm_clk_get(dev, "mem");
+		if (IS_ERR(dwmac->clk_mem)) {
+			dev_err(dev, "failed to get mem clock\n");
+			return PTR_ERR(dwmac->clk_mem);
+		}
+	}
+
+	if (of_machine_is_compatible("fsl,imx8mp")) {
+		/* Binding doc describes the propety:
+		   is required by i.MX8MP.
+		   is optinoal for i.MX8DXL.
+		 */
+		dwmac->intf_regmap = syscon_regmap_lookup_by_phandle(np, "intf_mode");
+		if (IS_ERR(dwmac->intf_regmap))
+			return PTR_ERR(dwmac->intf_regmap);
+
+		err = of_property_read_u32_index(np, "intf_mode", 1, &dwmac->intf_reg_off);
+		if (err) {
+			dev_err(dev, "Can't get intf mode reg offset (%d)\n", err);
+			return err;
+		}
+	}
+
+	return err;
+}
+
+static int imx_dwmac_probe(struct platform_device *pdev)
+{
+	struct plat_stmmacenet_data *plat_dat;
+	struct stmmac_resources stmmac_res;
+	struct imx_priv_data *dwmac;
+	const struct imx_dwmac_ops *data;
+	int ret;
+
+	ret = stmmac_get_platform_resources(pdev, &stmmac_res);
+	if (ret)
+		return ret;
+
+	dwmac = devm_kzalloc(&pdev->dev, sizeof(*dwmac), GFP_KERNEL);
+	if (!dwmac)
+		return PTR_ERR(dwmac);
+
+	plat_dat = stmmac_probe_config_dt(pdev, &stmmac_res.mac);
+	if (IS_ERR(plat_dat))
+		return PTR_ERR(plat_dat);
+
+	data = of_device_get_match_data(&pdev->dev);
+	if (!data) {
+		dev_err(&pdev->dev, "failed to get match data\n");
+		ret = -EINVAL;
+		goto err_match_data;
+	}
+
+	dwmac->ops = data;
+	dwmac->dev = &pdev->dev;
+
+	ret = imx_dwmac_parse_dt(dwmac, &pdev->dev);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to parse OF data\n");
+		goto err_parse_dt;
+	}
+
+	ret = dma_set_mask_and_coherent(&pdev->dev,
+					DMA_BIT_MASK(dwmac->ops->addr_width));
+	if (ret) {
+		dev_err(&pdev->dev, "DMA mask set failed\n");
+		goto err_dma_mask;
+	}
+
+	plat_dat->init = imx_dwmac_init;
+	plat_dat->exit = imx_dwmac_exit;
+	plat_dat->fix_mac_speed = imx_dwmac_fix_speed;
+	plat_dat->bsp_priv = dwmac;
+	dwmac->plat_dat = plat_dat;
+
+	ret = imx_dwmac_init(pdev, dwmac);
+	if (ret)
+		goto err_dwmac_init;
+
+	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
+	if (ret)
+		goto err_drv_probe;
+
+	return 0;
+
+err_dwmac_init:
+err_drv_probe:
+	imx_dwmac_exit(pdev, plat_dat->bsp_priv);
+err_dma_mask:
+err_parse_dt:
+err_match_data:
+	stmmac_remove_config_dt(pdev, plat_dat);
+	return ret;
+}
+
+static struct imx_dwmac_ops imx8mp_dwmac_data = {
+	.addr_width = 34,
+	.mac_rgmii_txclk_auto_adj = false,
+	.set_intf_mode = imx8mp_set_intf_mode,
+};
+
+static struct imx_dwmac_ops imx8dxl_dwmac_data = {
+	.addr_width = 32,
+	.mac_rgmii_txclk_auto_adj = true,
+	.set_intf_mode = imx8dxl_set_intf_mode,
+};
+
+static const struct of_device_id imx_dwmac_match[] = {
+	{ .compatible = "nxp,imx8mp-dwmac-eqos", .data = &imx8mp_dwmac_data },
+	{ .compatible = "nxp,imx8dxl-dwmac-eqos", .data = &imx8dxl_dwmac_data },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, imx_dwmac_match);
+
+static struct platform_driver imx_dwmac_driver = {
+	.probe  = imx_dwmac_probe,
+	.remove = stmmac_pltfr_remove,
+	.driver = {
+		.name           = "imx-dwmac",
+		.pm		= &stmmac_pltfr_pm_ops,
+		.of_match_table = imx_dwmac_match,
+	},
+};
+module_platform_driver(imx_dwmac_driver);
+
+MODULE_AUTHOR("NXP");
+MODULE_DESCRIPTION("NXP imx8 DWMAC Specific Glue layer");
+MODULE_LICENSE("GPL v2");
-- 
2.17.1

