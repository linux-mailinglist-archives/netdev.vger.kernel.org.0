Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE783DA379
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 14:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237424AbhG2MzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 08:55:12 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:49995 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237361AbhG2MzE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 08:55:04 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1627563301; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=6KbRnv1WSKDO9nbls2nTXvR0S1bslILj0H/eogKAD+I=; b=tcy4x2iMoAGkfSmziuPtJIWP8IK43fwpS2tsQ2BqQPOHcc1hpsQvw2xXKpr971PxyR7e/Foq
 gnCEr9z8hF78TUMaEK09ZyuU3jlyWAfjhzMwoLtPfRPcyqYyFcbVvoyurK/syvkS7kh7zECW
 kKb2v064j/8+n1zFV+9/1a9zdMU=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 6102a50417c2b4047d449662 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 29 Jul 2021 12:54:28
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0428CC433D3; Thu, 29 Jul 2021 12:54:27 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9E341C433D3;
        Thu, 29 Jul 2021 12:54:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9E341C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=luoj@codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, p.zabel@pengutronix.de, agross@kernel.org,
        bjorn.andersson@linaro.org, robh+dt@kernel.org,
        robert.marko@sartura.hr
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH 1/3] net: mdio-ipq4019: Add mdio reset function
Date:   Thu, 29 Jul 2021 20:53:56 +0800
Message-Id: <20210729125358.5227-1-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support PHY reset function and MDIO clock frequency configuration.

Signed-off-by: Luo Jie <luoj@codeaurora.org>
---
 drivers/net/mdio/Kconfig        |  1 +
 drivers/net/mdio/mdio-ipq4019.c | 71 +++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
index 99a6c13a11af..06a605ffb950 100644
--- a/drivers/net/mdio/Kconfig
+++ b/drivers/net/mdio/Kconfig
@@ -169,6 +169,7 @@ config MDIO_OCTEON
 config MDIO_IPQ4019
 	tristate "Qualcomm IPQ4019 MDIO interface support"
 	depends on HAS_IOMEM && OF_MDIO
+	depends on GPIOLIB && COMMON_CLK && RESET_CONTROLLER
 	help
 	  This driver supports the MDIO interface found in Qualcomm
 	  IPQ40xx series Soc-s.
diff --git a/drivers/net/mdio/mdio-ipq4019.c b/drivers/net/mdio/mdio-ipq4019.c
index 9cd71d896963..01f5b9393537 100644
--- a/drivers/net/mdio/mdio-ipq4019.c
+++ b/drivers/net/mdio/mdio-ipq4019.c
@@ -11,6 +11,9 @@
 #include <linux/of_mdio.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
+#include <linux/gpio/consumer.h>
+#include <linux/reset.h>
+#include <linux/clk.h>
 
 #define MDIO_MODE_REG				0x40
 #define MDIO_ADDR_REG				0x44
@@ -31,8 +34,16 @@
 #define IPQ4019_MDIO_TIMEOUT	10000
 #define IPQ4019_MDIO_SLEEP		10
 
+/* MDIO clock source frequency is fixed to 100M */
+#define QCA_MDIO_CLK_RATE	100000000
+
+#define QCA_PHY_SET_DELAY_US	100000
+
 struct ipq4019_mdio_data {
 	void __iomem	*membase;
+	void __iomem *eth_ldo_rdy;
+	struct reset_control *reset_ctrl;
+	struct clk *mdio_clk;
 };
 
 static int ipq4019_mdio_wait_busy(struct mii_bus *bus)
@@ -171,10 +182,61 @@ static int ipq4019_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 	return 0;
 }
 
+static int ipq_mdio_reset(struct mii_bus *bus)
+{
+	struct ipq4019_mdio_data *priv = bus->priv;
+	struct device *dev = bus->parent;
+	struct gpio_desc *reset_gpio;
+	u32 val;
+	int i, ret;
+
+	/* To indicate CMN_PLL that ethernet_ldo has been ready if needed */
+	if (!IS_ERR(priv->eth_ldo_rdy)) {
+		val = readl(priv->eth_ldo_rdy);
+		val |= BIT(0);
+		writel(val, priv->eth_ldo_rdy);
+		fsleep(QCA_PHY_SET_DELAY_US);
+	}
+
+	/* Reset GEPHY if need */
+	if (!IS_ERR(priv->reset_ctrl)) {
+		reset_control_assert(priv->reset_ctrl);
+		fsleep(QCA_PHY_SET_DELAY_US);
+		reset_control_deassert(priv->reset_ctrl);
+		fsleep(QCA_PHY_SET_DELAY_US);
+	}
+
+	/* Configure MDIO clock frequency */
+	if (!IS_ERR(priv->mdio_clk)) {
+		ret = clk_set_rate(priv->mdio_clk, QCA_MDIO_CLK_RATE);
+		if (ret)
+			return ret;
+
+		ret = clk_prepare_enable(priv->mdio_clk);
+		if (ret)
+			return ret;
+	}
+
+	/* Reset PHYs by gpio pins */
+	for (i = 0; i < gpiod_count(dev, "phy-reset"); i++) {
+		reset_gpio = gpiod_get_index_optional(dev, "phy-reset", i, GPIOD_OUT_HIGH);
+		if (IS_ERR(reset_gpio))
+			continue;
+		gpiod_set_value_cansleep(reset_gpio, 0);
+		fsleep(QCA_PHY_SET_DELAY_US);
+		gpiod_set_value_cansleep(reset_gpio, 1);
+		fsleep(QCA_PHY_SET_DELAY_US);
+		gpiod_put(reset_gpio);
+	}
+
+	return 0;
+}
+
 static int ipq4019_mdio_probe(struct platform_device *pdev)
 {
 	struct ipq4019_mdio_data *priv;
 	struct mii_bus *bus;
+	struct resource *res;
 	int ret;
 
 	bus = devm_mdiobus_alloc_size(&pdev->dev, sizeof(*priv));
@@ -182,14 +244,23 @@ static int ipq4019_mdio_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	priv = bus->priv;
+	priv->eth_ldo_rdy = IOMEM_ERR_PTR(-EINVAL);
 
 	priv->membase = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(priv->membase))
 		return PTR_ERR(priv->membase);
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (res)
+		priv->eth_ldo_rdy = devm_ioremap_resource(&pdev->dev, res);
+
+	priv->reset_ctrl = devm_reset_control_get_exclusive(&pdev->dev, "gephy_mdc_rst");
+	priv->mdio_clk = devm_clk_get(&pdev->dev, "gcc_mdio_ahb_clk");
+
 	bus->name = "ipq4019_mdio";
 	bus->read = ipq4019_mdio_read;
 	bus->write = ipq4019_mdio_write;
+	bus->reset = ipq_mdio_reset;
 	bus->parent = &pdev->dev;
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%s%d", pdev->name, pdev->id);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

