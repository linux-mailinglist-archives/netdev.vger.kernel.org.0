Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7BB756947F
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 23:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234703AbiGFVdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 17:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234670AbiGFVd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 17:33:26 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEB62AE0E;
        Wed,  6 Jul 2022 14:33:20 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id j7so9550282wmp.2;
        Wed, 06 Jul 2022 14:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qKcHwD7mAVe9vw148b10Hk52k7+B0j3FvXtghoey17U=;
        b=aNjAub4g2oDQn9sBDND85pNJ8asLKlZJBeNtyLG61p1Gt9rgKqu43pEqHNWHWUfo8l
         DBRwuFFm/PAVG0spzRGuwJLABx+HTJoObi0JYhv0D8JMdhoS3VU4pOmR2xy4oAd68nah
         dZCkkj8fpYTBimAEIBFu2GiqMqRbB844uszFKhsahIttw8tNXzvwID4kYKjpb5cWUqAX
         l+uwr8B8kFdjqPr2ZtVIZARETFAuo415T6iCK5P/UGk3v3pSVNiYzp+GyLSSNVSURfyD
         rRQhJ4IGI7Hd14jv7hh5D40uzOtDLc3LOvn+2ub+GLxqIZK/16B8JOc2TWIbxnU73TeX
         LXxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qKcHwD7mAVe9vw148b10Hk52k7+B0j3FvXtghoey17U=;
        b=ANkKKT8l4qUrnGqlFt1oH5j7nTktPhCVGCN2TyYiuR//ufdY1MyH+9/CzTM63wd6jn
         3y6jdefpwiVLh2XNVEmkq1x6XCw/e06BV8wbUhABuf5H6LbcwJBN3Aiah8i5c/WTGEjd
         osfL7BmEgAIhTyvuFr35nN6a9fldg86TBPcsdX7AMv3z5WuysHo15WVoFSiaJi9xbgQr
         Ya+4xmSebw2FO984dpZKfWDnGMCFgx2rAjcLYC41TP+sF1PJOj1hmK3iFHvcOdnu+EHm
         fsfv95+gMfnXKvD7oMXRzfayKzztHbcnzTcOaDGDKeae+WHbrhVicrkKceGLZk1H3z3j
         wHbA==
X-Gm-Message-State: AJIora934rilMRUZ9JiqgbgYoDOO4gYbFvBHfDQKAMeugHvs7BsgcZ2x
        wp1zQL7LBY1CZx2SxuERPxw=
X-Google-Smtp-Source: AGRyM1sPJ75icTuopJlekyV60dTNFcAK+qngl5FpdqhBL4KPs/HxD3Qjk/8a3pqz8AWgbN7gRIyQpQ==
X-Received: by 2002:a05:600c:3593:b0:3a1:8909:b5b2 with SMTP id p19-20020a05600c359300b003a18909b5b2mr643800wmq.77.1657143199989;
        Wed, 06 Jul 2022 14:33:19 -0700 (PDT)
Received: from localhost (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id g14-20020a05600c4ece00b0039c99f61e5bsm26391573wmq.5.2022.07.06.14.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 14:33:19 -0700 (PDT)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Thierry Reding <thierry.reding@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Bhadram Varka <vbhadram@nvidia.com>,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next v3 9/9] stmmac: tegra: Add MGBE support
Date:   Wed,  6 Jul 2022 23:32:55 +0200
Message-Id: <20220706213255.1473069-10-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220706213255.1473069-1-thierry.reding@gmail.com>
References: <20220706213255.1473069-1-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bhadram Varka <vbhadram@nvidia.com>

Add support for the Multi-Gigabit Ethernet (MGBE/XPCS) IP found on
NVIDIA Tegra234 SoCs.

Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |   6 +
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-tegra.c | 290 ++++++++++++++++++
 3 files changed, 297 insertions(+)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index 31ff35174034..e9f61bdaf7c4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -235,6 +235,12 @@ config DWMAC_INTEL_PLAT
 	  the stmmac device driver. This driver is used for the Intel Keem Bay
 	  SoC.
 
+config DWMAC_TEGRA
+	tristate "NVIDIA Tegra MGBE support"
+	depends on ARCH_TEGRA || COMPILE_TEST
+	help
+	  Support for the MGBE controller found on Tegra SoCs.
+
 config DWMAC_VISCONTI
 	tristate "Toshiba Visconti DWMAC support"
 	default ARCH_VISCONTI
diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/ethernet/stmicro/stmmac/Makefile
index d4e12e9ace4f..057e4bab5c08 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Makefile
+++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_DWMAC_DWC_QOS_ETH)	+= dwmac-dwc-qos-eth.o
 obj-$(CONFIG_DWMAC_INTEL_PLAT)	+= dwmac-intel-plat.o
 obj-$(CONFIG_DWMAC_GENERIC)	+= dwmac-generic.o
 obj-$(CONFIG_DWMAC_IMX8)	+= dwmac-imx.o
+obj-$(CONFIG_DWMAC_TEGRA)	+= dwmac-tegra.o
 obj-$(CONFIG_DWMAC_VISCONTI)	+= dwmac-visconti.o
 stmmac-platform-objs:= stmmac_platform.o
 dwmac-altr-socfpga-objs := altr_tse_pcs.o dwmac-socfpga.o
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c
new file mode 100644
index 000000000000..bb4b540820fa
--- /dev/null
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c
@@ -0,0 +1,290 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/platform_device.h>
+#include <linux/of_device.h>
+#include <linux/module.h>
+#include <linux/stmmac.h>
+#include <linux/clk.h>
+
+#include "stmmac_platform.h"
+
+static const char *const mgbe_clks[] = {
+	"rx-pcs", "tx", "tx-pcs", "mac-divider", "mac", "mgbe", "ptp-ref", "mac"
+};
+
+struct tegra_mgbe {
+	struct device *dev;
+
+	struct clk_bulk_data *clks;
+
+	struct reset_control *rst_mac;
+	struct reset_control *rst_pcs;
+
+	void __iomem *hv;
+	void __iomem *regs;
+	void __iomem *xpcs;
+
+	struct mii_bus *mii;
+};
+
+#define XPCS_WRAP_UPHY_RX_CONTROL 0x801c
+#define XPCS_WRAP_UPHY_RX_CONTROL_RX_SW_OVRD BIT(31)
+#define XPCS_WRAP_UPHY_RX_CONTROL_RX_PCS_PHY_RDY BIT(10)
+#define XPCS_WRAP_UPHY_RX_CONTROL_RX_CDR_RESET BIT(9)
+#define XPCS_WRAP_UPHY_RX_CONTROL_RX_CAL_EN BIT(8)
+#define XPCS_WRAP_UPHY_RX_CONTROL_RX_SLEEP (BIT(7) | BIT(6))
+#define XPCS_WRAP_UPHY_RX_CONTROL_AUX_RX_IDDQ BIT(5)
+#define XPCS_WRAP_UPHY_RX_CONTROL_RX_IDDQ BIT(4)
+#define XPCS_WRAP_UPHY_RX_CONTROL_RX_DATA_EN BIT(0)
+#define XPCS_WRAP_UPHY_HW_INIT_CTRL 0x8020
+#define XPCS_WRAP_UPHY_HW_INIT_CTRL_TX_EN BIT(0)
+#define XPCS_WRAP_UPHY_HW_INIT_CTRL_RX_EN BIT(2)
+#define XPCS_WRAP_UPHY_STATUS 0x8044
+#define XPCS_WRAP_UPHY_STATUS_TX_P_UP BIT(0)
+#define XPCS_WRAP_IRQ_STATUS 0x8050
+#define XPCS_WRAP_IRQ_STATUS_PCS_LINK_STS BIT(6)
+
+#define XPCS_REG_ADDR_SHIFT 10
+#define XPCS_REG_ADDR_MASK 0x1fff
+#define XPCS_ADDR 0x3fc
+
+#define MGBE_WRAP_COMMON_INTR_ENABLE	0x8704
+#define MAC_SBD_INTR			BIT(2)
+#define MGBE_WRAP_AXI_ASID0_CTRL	0x8400
+#define MGBE_SID			0x6
+
+static void mgbe_uphy_lane_bringup(struct tegra_mgbe *mgbe)
+{
+	unsigned int retry = 300;
+	u32 value;
+	int err;
+
+	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_STATUS);
+	if ((value & XPCS_WRAP_UPHY_STATUS_TX_P_UP) == 0) {
+		value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_HW_INIT_CTRL);
+		value |= XPCS_WRAP_UPHY_HW_INIT_CTRL_TX_EN;
+		writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_HW_INIT_CTRL);
+	}
+
+	err = readl_poll_timeout(mgbe->xpcs + XPCS_WRAP_UPHY_HW_INIT_CTRL, value,
+				 (value & XPCS_WRAP_UPHY_HW_INIT_CTRL_TX_EN) == 0,
+				 500, 500 * 2000);
+	if (err < 0)
+		dev_err(mgbe->dev, "timeout waiting for TX lane to become enabled\n");
+
+	usleep_range(10000, 20000);
+
+	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+	value |= XPCS_WRAP_UPHY_RX_CONTROL_RX_SW_OVRD;
+	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+
+	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+	value &= ~XPCS_WRAP_UPHY_RX_CONTROL_RX_IDDQ;
+	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+
+	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+	value &= ~XPCS_WRAP_UPHY_RX_CONTROL_AUX_RX_IDDQ;
+	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+
+	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+	value &= ~XPCS_WRAP_UPHY_RX_CONTROL_RX_SLEEP;
+	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+
+	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+	value |= XPCS_WRAP_UPHY_RX_CONTROL_RX_CAL_EN;
+	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+
+	err = readl_poll_timeout(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL, value,
+				 (value & XPCS_WRAP_UPHY_RX_CONTROL_RX_CAL_EN) == 0,
+				 1000, 1000 * 2000);
+	if (err < 0)
+		dev_err(mgbe->dev, "timeout waiting for RX calibration to become enabled\n");
+
+	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+	value |= XPCS_WRAP_UPHY_RX_CONTROL_RX_DATA_EN;
+	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+
+	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+	value |= XPCS_WRAP_UPHY_RX_CONTROL_RX_CDR_RESET;
+	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+
+	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+	value &= ~XPCS_WRAP_UPHY_RX_CONTROL_RX_CDR_RESET;
+	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+
+	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+	value |= XPCS_WRAP_UPHY_RX_CONTROL_RX_PCS_PHY_RDY;
+	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+
+	while (--retry) {
+		err = readl_poll_timeout(mgbe->xpcs + XPCS_WRAP_IRQ_STATUS, value,
+					 value & XPCS_WRAP_IRQ_STATUS_PCS_LINK_STS,
+					 500, 500 * 2000);
+		if (err < 0) {
+			dev_err(mgbe->dev, "timeout waiting for link to become ready\n");
+			usleep_range(10000, 20000);
+			continue;
+		}
+		break;
+	}
+
+	/* clear status */
+	writel(value, mgbe->xpcs + XPCS_WRAP_IRQ_STATUS);
+}
+
+static int tegra_mgbe_probe(struct platform_device *pdev)
+{
+	struct plat_stmmacenet_data *plat;
+	struct stmmac_resources res;
+	struct tegra_mgbe *mgbe;
+	int irq, err, i;
+
+	mgbe = devm_kzalloc(&pdev->dev, sizeof(*mgbe), GFP_KERNEL);
+	if (!mgbe)
+		return -ENOMEM;
+
+	mgbe->dev = &pdev->dev;
+
+	memset(&res, 0, sizeof(res));
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
+	mgbe->hv = devm_platform_ioremap_resource_byname(pdev, "hypervisor");
+	if (IS_ERR(mgbe->hv))
+		return PTR_ERR(mgbe->hv);
+
+	mgbe->regs = devm_platform_ioremap_resource_byname(pdev, "mac");
+	if (IS_ERR(mgbe->regs))
+		return PTR_ERR(mgbe->regs);
+
+	mgbe->xpcs = devm_platform_ioremap_resource_byname(pdev, "xpcs");
+	if (IS_ERR(mgbe->xpcs))
+		return PTR_ERR(mgbe->xpcs);
+
+	res.addr = mgbe->regs;
+	res.irq = irq;
+
+	mgbe->clks = devm_kzalloc(&pdev->dev, sizeof(*mgbe->clks), GFP_KERNEL);
+	if (!mgbe->clks)
+		return -ENOMEM;
+
+	for (i = 0; i <  ARRAY_SIZE(mgbe_clks); i++)
+		mgbe->clks[i].id = mgbe_clks[i];
+
+	err = devm_clk_bulk_get(mgbe->dev, ARRAY_SIZE(mgbe_clks), mgbe->clks);
+	if (err < 0)
+		return err;
+
+	err = clk_bulk_prepare_enable(ARRAY_SIZE(mgbe_clks), mgbe->clks);
+	if (err < 0)
+		return err;
+
+	/* Perform MAC reset */
+	mgbe->rst_mac = devm_reset_control_get(&pdev->dev, "mac");
+	if (IS_ERR(mgbe->rst_mac))
+		return PTR_ERR(mgbe->rst_mac);
+
+	err = reset_control_assert(mgbe->rst_mac);
+	if (err < 0)
+		return err;
+
+	usleep_range(2000, 4000);
+
+	err = reset_control_deassert(mgbe->rst_mac);
+	if (err < 0)
+		return err;
+
+	/* Perform PCS reset */
+	mgbe->rst_pcs = devm_reset_control_get(&pdev->dev, "pcs");
+	if (IS_ERR(mgbe->rst_pcs))
+		return PTR_ERR(mgbe->rst_pcs);
+
+	err = reset_control_assert(mgbe->rst_pcs);
+	if (err < 0)
+		return err;
+
+	usleep_range(2000, 4000);
+
+	err = reset_control_deassert(mgbe->rst_pcs);
+	if (err < 0)
+		return err;
+
+	plat = stmmac_probe_config_dt(pdev, res.mac);
+	if (IS_ERR(plat))
+		return PTR_ERR(plat);
+
+	plat->has_xgmac = 1;
+	plat->tso_en = 1;
+	plat->pmt = 1;
+	plat->bsp_priv = mgbe;
+
+	if (!plat->mdio_node)
+		plat->mdio_node = of_get_child_by_name(pdev->dev.of_node, "mdio");
+
+	if (!plat->mdio_bus_data) {
+		plat->mdio_bus_data = devm_kzalloc(&pdev->dev, sizeof(*plat->mdio_bus_data),
+						   GFP_KERNEL);
+		if (!plat->mdio_bus_data) {
+			err = -ENOMEM;
+			goto remove;
+		}
+	}
+
+	plat->mdio_bus_data->needs_reset = true;
+
+	mgbe_uphy_lane_bringup(mgbe);
+
+	/* Tx FIFO Size - 128KB */
+	plat->tx_fifo_size = 131072;
+	/* Rx FIFO Size - 192KB */
+	plat->rx_fifo_size = 196608;
+
+	/* Enable common interrupt at wrapper level */
+	writel(MAC_SBD_INTR, mgbe->regs + MGBE_WRAP_COMMON_INTR_ENABLE);
+
+	/* Program SID */
+	writel(MGBE_SID, mgbe->hv + MGBE_WRAP_AXI_ASID0_CTRL);
+
+	err = stmmac_dvr_probe(&pdev->dev, plat, &res);
+	if (err < 0)
+		goto remove;
+
+	return 0;
+
+remove:
+	stmmac_remove_config_dt(pdev, plat);
+	return err;
+}
+
+static int tegra_mgbe_remove(struct platform_device *pdev)
+{
+	struct tegra_mgbe *mgbe = get_stmmac_bsp_priv(&pdev->dev);
+
+	clk_bulk_disable_unprepare(ARRAY_SIZE(mgbe_clks), mgbe->clks);
+
+	stmmac_pltfr_remove(pdev);
+
+	return 0;
+}
+
+static const struct of_device_id tegra_mgbe_match[] = {
+	{ .compatible = "nvidia,tegra234-mgbe", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, tegra_mgbe_match);
+
+static struct platform_driver tegra_mgbe_driver = {
+	.probe = tegra_mgbe_probe,
+	.remove = tegra_mgbe_remove,
+	.driver = {
+		.name = "tegra-mgbe",
+		.pm		= &stmmac_pltfr_pm_ops,
+		.of_match_table = tegra_mgbe_match,
+	},
+};
+module_platform_driver(tegra_mgbe_driver);
+
+MODULE_AUTHOR("Thierry Reding <treding@nvidia.com>");
+MODULE_DESCRIPTION("NVIDIA Tegra MGBE driver");
+MODULE_LICENSE("GPL");
-- 
2.36.1

