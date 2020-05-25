Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC9C1E0BE3
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 12:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389812AbgEYKes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 06:34:48 -0400
Received: from mail-eopbgr20046.outbound.protection.outlook.com ([40.107.2.46]:60839
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389745AbgEYKes (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 06:34:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lBVPfblvG88WrQNLrLz7EubOfyfe1yfOHJV0tO1bzpXakjgtUghfFaYyKdNDhPX4E5c3x3eBRJ32W1TamZWWwgAmtjIFRu99OQPjKX1L3H9c4OjjcTnSHuak7gBLgSstqgePGIgFKngpOJXdudekJ6mGeu8ePFmWNSRDivpx5+0XndsyO3wJmYl5AyaEQRsBG9kZt7YN2uRINWApH3RcbpZBlnZQYbuebMKtBx6UyBt8uLd1GAd49rtKO0HiMCU5mqu/V1gMWLXduMO1vIBVIQWB3zA1TfJ28Hbfhh0RkxXcXySRmU8zOX1uS5ztwZaU8DKUg+ljilAG9IDoitUAWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JTXvsxOLQNV8dYPQERy/pNUCg8epk6zyxzJH0zxOkuQ=;
 b=AHATfGPALWlbK02IXSkYNfkIPzp34KGocGfc0OJcyKwP3UZp+p0bZ+8a0JPF0BedPpEZAG1N0hAlhLAe+3qSjcpahkaOlp0Ij+WOFxDj2fIp0WH7Itnlb9cH9iAHZQmrXwZpbq9hTH47eWd5NyDboQNJO2kMRtQL0mMBTuFLdd27SpMyROvrIZJMFmVOC4EAVEOY5uqRtFoyw8rVDj8cpEAJM0XIA4tVyeaWNEIYOK0YIMIZapPjJqmbXf8+Vh5gQf20LklxGI+ii4SFEuzkWKWoyQglUEDnlCl95YjNtDiG0Mzw509KPbzXoyKQV7QW+JtlJ2AfGoBf2vaDBuyAWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JTXvsxOLQNV8dYPQERy/pNUCg8epk6zyxzJH0zxOkuQ=;
 b=Ytn8vPNaE2R1ofszt/uvEvz2X+ix1e8BTrPoxNtZ2ntJAZ+iRw4xCWlAGFn2VGsAsqdivgSQo9rPyGqVVnBe2NTFN/i6LjnTiYxXkf9+7pEvpADJTNeMPsJF9fMSi4a2LrNs8IKx/980kbqM0la0weuxcCrV+4BQxKXx1lSl92c=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3383.eurprd04.prod.outlook.com
 (2603:10a6:209:a::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 10:34:43 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 10:34:43 +0000
From:   Fugang Duan <fugang.duan@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, mcoquelin.stm32@gmail.com,
        p.zabel@pengutronix.de, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, fugang.duan@nxp.com
Subject: [PATCH net 1/2] net: ethernet: dwmac: add Ethernet glue logic for NXP imx8 chip
Date:   Mon, 25 May 2020 18:29:13 +0800
Message-Id: <1590402554-13175-2-git-send-email-fugang.duan@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590402554-13175-1-git-send-email-fugang.duan@nxp.com>
References: <1590402554-13175-1-git-send-email-fugang.duan@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0180.apcprd06.prod.outlook.com
 (2603:1096:1:1e::34) To AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b38611.ap.freescale.net (119.31.174.66) by SG2PR06CA0180.apcprd06.prod.outlook.com (2603:1096:1:1e::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3021.23 via Frontend Transport; Mon, 25 May 2020 10:34:39 +0000
X-Mailer: git-send-email 2.7.4
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 664e3f7e-51af-4c03-2cf5-08d800973c8f
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3383:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB33834FC1E6857373811EC413FFB30@AM6PR0402MB3383.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-Forefront-PRVS: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FexM/yUcDNf2seFJdz8tEAfsBCThvCGfY85XL6ctwByQ5AUfcf67Ba0dAJhuodaDjWsxzIiEwRUJ2j9DaGNCl7p3Wu0sOJC3svP5RQK8uQOHszeR4S0D63JiUSq19G2RvzJ/8jeiEhaohzYnsY4G5BXywvuOeDhHmVfh+nDiPph7Z5RIflnmEk6A/XPt3k3n8/vF/CybZoJIeTH1g8MwN90/cDA/5ssOnqpImMUUPuGQxQgxOUMR2AVDMAc1Drda3D8FcNM8G+Nm9ZdRO+pTNkjnBd5moJJLGinVSl84lnseKfOXJBLZCOZpE0aw52XG3hn08hpjs6+jVrwI2MQD/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(346002)(39860400002)(366004)(376002)(2906002)(4326008)(6486002)(2616005)(36756003)(956004)(44832011)(8676002)(5660300002)(8936002)(186003)(16526019)(6512007)(478600001)(66476007)(66556008)(52116002)(66946007)(26005)(6506007)(316002)(7416002)(6666004)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: SKm0zRJa8TkreSMJi3KCLEZoqgRkryTV9tLKVVav4yXOG6OXMFNa3PmVaSoPJttPCpDagKzHXiY63OovxN2fyuh9Hd1b2SYSSicribNXuh41FXSaAvfHrGjC47W7ZaNW5Q+Tz6sO2ZP8C69fo1a3MRaWTo3mppEIwXOXmnu3BD8eJmY5CfFAol6IJhM3/amoRBjhsBl60CaI3LZj4XVIwpbZU4TlZ4DDT87g1VkQMzBvipTBDB/oTw4kje7vidrJ8oCQOXBKewr5HPXTr/r5uKiLEjapx4GqRD31r7LrEZ9Xr8gHehl2DdmcHSsxQWdXrUpCsK2StFCtHltH2zmzEIByJ23UVU3Dcjk4BLABkOr7MYa6LZpzSL5XKcNGYfdLpjqJWbDU4dVKvm6aM1WV5QVkNYtcqsjEL0nDa+ADdX/cGjzXW1hn5+NW5RdVHyyq6AiS7SMFMbd1zMaaVtbY6v999Grf4P/ho/MZSq0Z3LqCHYr0EZs/8Qq/hi8DyLp7
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 664e3f7e-51af-4c03-2cf5-08d800973c8f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 10:34:43.2910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I6HTHjk+CYkvCzYe69B9s3LprwZVbTPfhs37NnPWLI2kRMVakyyKq/0HzQmVU0I4FiJITS5csW4p/mXaJgDxEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3383
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NXP imx8 family like imx8mp/imx8dxl chips support Synopsys MAC 5.10a IP.
This patch adds settings for NXP imx8 glue layer:
- clocks
- dwmac address width
- phy interface mode selection
- adjust rgmii txclk rate

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig     |  13 +
 drivers/net/ethernet/stmicro/stmmac/Makefile    |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c | 311 ++++++++++++++++++++++++
 3 files changed, 325 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index b46f8d2..36bd2e1 100644
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
index f9d024d..295615a 100644
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
index 0000000..647879a
--- /dev/null
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
@@ -0,0 +1,311 @@
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
+	struct imx_priv_data *dwmac = priv;
+	struct plat_stmmacenet_data *plat_dat = dwmac->plat_dat;
+	int ret;
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
+	struct imx_priv_data *dwmac = priv;
+	struct plat_stmmacenet_data *plat_dat = dwmac->plat_dat;
+	unsigned long rate;
+	int err;
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
2.7.4

