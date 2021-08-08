Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977553E3A18
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 14:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbhHHMBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 08:01:23 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:53324 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbhHHMBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 08:01:20 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1628424061; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=3E1KCDXxRD6uVx/Ep74Ktb7pO/hf/RTPaSqqSVs50p0=; b=JM5Fjeh5IE4k6OJlHL7ptspSoMRG9Hj2xFLxSbKdfmaNs4ac+Ms1VMcj8xm82SVvlZBbagZz
 ZDAaRoC2A2inLo063TfW204dJ6XiHjsamHykIQ5zk2IIj2U04CbMRK3DaOFWhHzBH+THVVR4
 X7ffQJ8wXsFpwIJBO2Bb63u8UQk=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 610fc768454b7a558fb5b9de (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 08 Aug 2021 12:00:40
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CECBBC4323A; Sun,  8 Aug 2021 12:00:39 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4415DC433D3;
        Sun,  8 Aug 2021 12:00:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4415DC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=luoj@codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [Resend v1 1/2] net: mdio: Add the reset function for IPQ MDIO driver
Date:   Sun,  8 Aug 2021 20:00:17 +0800
Message-Id: <20210808120018.2480-2-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210808120018.2480-1-luoj@codeaurora.org>
References: <20210808120018.2480-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. configure the MDIO clock source frequency.
2. the LDO resource is needed to configure the ethernet LDO available
for CMN_PLL.

Signed-off-by: Luo Jie <luoj@codeaurora.org>
---
 drivers/net/mdio/Kconfig        |  1 +
 drivers/net/mdio/mdio-ipq4019.c | 47 +++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

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
index 9cd71d896963..2b6a193f2d67 100644
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
@@ -171,10 +179,41 @@ static int ipq4019_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
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
+	if (!IS_ERR(priv->eth_ldo_rdy)) {
+		val = readl(priv->eth_ldo_rdy);
+		val |= BIT(0);
+		writel(val, priv->eth_ldo_rdy);
+		fsleep(IPQ_PHY_SET_DELAY_US);
+	}
+
+	/* Configure MDIO clock source frequency if clock is specified in the device tree */
+	if (!IS_ERR_OR_NULL(priv->mdio_clk)) {
+		ret = clk_set_rate(priv->mdio_clk, IPQ_MDIO_CLK_RATE);
+		if (ret)
+			return ret;
+
+		ret = clk_prepare_enable(priv->mdio_clk);
+		if (ret)
+			return ret;
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
@@ -182,14 +221,22 @@ static int ipq4019_mdio_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	priv = bus->priv;
+	priv->eth_ldo_rdy = IOMEM_ERR_PTR(-EINVAL);
 
 	priv->membase = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(priv->membase))
 		return PTR_ERR(priv->membase);
 
+	priv->mdio_clk = devm_clk_get_optional(&pdev->dev, "gcc_mdio_ahb_clk");
+
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

