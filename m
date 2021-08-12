Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D9B3EA2C8
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 12:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236064AbhHLKIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 06:08:31 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:58992 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235500AbhHLKIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 06:08:19 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1628762874; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=mObOJ321JgsaHD8SBYg+UqOI67gOGpxj+gk/NROE8Q8=; b=GWKRciNPYKp3ilDNp5U1xnDk8scYHZrujUxA0JTj95A3qwgeBn5Lxlxxxyuofeg37y4sRjk8
 9UQtLOx67nzR+MlyYuo/NFo1D4ybdQ8kpCLqZSG9TTJsJN/BXoIvSGjyuzP5GaUIGh7sABV8
 r0oZpxdkwrRJPPTSxsHmwbDr9Bo=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 6114f2cb7ee6040977487085 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 12 Aug 2021 10:07:07
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id ACCFAC43460; Thu, 12 Aug 2021 10:07:06 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E00BEC43460;
        Thu, 12 Aug 2021 10:06:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E00BEC43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=luoj@codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, agross@kernel.org, bjorn.andersson@linaro.org,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        robert.marko@sartura.hr
Cc:     linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v3 1/3] net: mdio: Add the reset function for IPQ MDIO driver
Date:   Thu, 12 Aug 2021 18:06:40 +0800
Message-Id: <20210812100642.1800-2-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210812100642.1800-1-luoj@codeaurora.org>
References: <20210812100642.1800-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. configure the MDIO clock source frequency.
2. the LDO resource is needed to configure the ethernet LDO available
for CMN_PLL.

Signed-off-by: Luo Jie <luoj@codeaurora.org>
---
 drivers/net/mdio/Kconfig        |  1 +
 drivers/net/mdio/mdio-ipq4019.c | 43 +++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
index 99a6c13a11af..a94d34cc7dc1 100644
--- a/drivers/net/mdio/Kconfig
+++ b/drivers/net/mdio/Kconfig
@@ -169,6 +169,7 @@ config MDIO_OCTEON
 config MDIO_IPQ4019
 	tristate "Qualcomm IPQ4019 MDIO interface support"
 	depends on HAS_IOMEM && OF_MDIO
+	depends on COMMON_CLK
 	help
 	  This driver supports the MDIO interface found in Qualcomm
 	  IPQ40xx series Soc-s.
diff --git a/drivers/net/mdio/mdio-ipq4019.c b/drivers/net/mdio/mdio-ipq4019.c
index 9cd71d896963..e14d437e42a8 100644
--- a/drivers/net/mdio/mdio-ipq4019.c
+++ b/drivers/net/mdio/mdio-ipq4019.c
@@ -11,6 +11,7 @@
 #include <linux/of_mdio.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
+#include <linux/clk.h>
 
 #define MDIO_MODE_REG				0x40
 #define MDIO_ADDR_REG				0x44
@@ -31,8 +32,15 @@
 #define IPQ4019_MDIO_TIMEOUT	10000
 #define IPQ4019_MDIO_SLEEP		10
 
+/* MDIO clock source frequency is fixed to 100M */
+#define IPQ_MDIO_CLK_RATE	100000000
+
+#define IPQ_PHY_SET_DELAY_US	100000
+
 struct ipq4019_mdio_data {
 	void __iomem	*membase;
+	void __iomem *eth_ldo_rdy;
+	struct clk *mdio_clk;
 };
 
 static int ipq4019_mdio_wait_busy(struct mii_bus *bus)
@@ -171,10 +179,35 @@ static int ipq4019_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 	return 0;
 }
 
+static int ipq_mdio_reset(struct mii_bus *bus)
+{
+	struct ipq4019_mdio_data *priv = bus->priv;
+	u32 val;
+	int ret;
+
+	/* To indicate CMN_PLL that ethernet_ldo has been ready if platform resource 1
+	 * is specified in the device tree.
+	 */
+	if (priv->eth_ldo_rdy) {
+		val = readl(priv->eth_ldo_rdy);
+		val |= BIT(0);
+		writel(val, priv->eth_ldo_rdy);
+		fsleep(IPQ_PHY_SET_DELAY_US);
+	}
+
+	/* Configure MDIO clock source frequency if clock is specified in the device tree */
+	ret = clk_set_rate(priv->mdio_clk, IPQ_MDIO_CLK_RATE);
+	if (ret)
+		return ret;
+
+	return clk_prepare_enable(priv->mdio_clk);
+}
+
 static int ipq4019_mdio_probe(struct platform_device *pdev)
 {
 	struct ipq4019_mdio_data *priv;
 	struct mii_bus *bus;
+	struct resource *res;
 	int ret;
 
 	bus = devm_mdiobus_alloc_size(&pdev->dev, sizeof(*priv));
@@ -187,9 +220,19 @@ static int ipq4019_mdio_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->membase))
 		return PTR_ERR(priv->membase);
 
+	priv->mdio_clk = devm_clk_get_optional(&pdev->dev, "gcc_mdio_ahb_clk");
+	if (IS_ERR(priv->mdio_clk))
+		return PTR_ERR(priv->mdio_clk);
+
+	/* The platform resource is provided on the chipset IPQ5018 */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (res)
+		priv->eth_ldo_rdy = devm_ioremap_resource(&pdev->dev, res);
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

