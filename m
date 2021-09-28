Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88DC41B101
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 15:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240943AbhI1NkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 09:40:12 -0400
Received: from mx24.baidu.com ([111.206.215.185]:45838 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240882AbhI1NkL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 09:40:11 -0400
Received: from BC-Mail-Ex12.internal.baidu.com (unknown [172.31.51.52])
        by Forcepoint Email with ESMTPS id 536C2E7DFD5F9B455AC8;
        Tue, 28 Sep 2021 21:22:05 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex12.internal.baidu.com (172.31.51.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Tue, 28 Sep 2021 21:22:05 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Tue, 28 Sep 2021 21:22:04 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <andrew@lunn.ch>, <horatiu.vultur@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Cai Huoqing <caihuoqing@baidu.com>
Subject: [PATCH] net: mdio-ipq4019: Fix the error for an optional regs resource
Date:   Tue, 28 Sep 2021 21:21:57 +0800
Message-ID: <20210928132157.2027-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex16.internal.baidu.com (172.31.51.56) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The second resource is optional which is only provided on the chipset
IPQ5018. But the blamed commit ignores that and if the resource is
not there it just fails.

the resource is used like this,
	if (priv->eth_ldo_rdy) {
		val = readl(priv->eth_ldo_rdy);
		val |= BIT(0);
		writel(val, priv->eth_ldo_rdy);
		fsleep(IPQ_PHY_SET_DELAY_US);
	}

This patch reverts that to still allow the second resource to be optional
because other SoC have the some MDIO controller and doesn't need to
second resource.

Fix Commit fa14d03e014a ("net: mdio-ipq4019: Make use of
devm_platform_ioremap_resource()")
Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/net/mdio/mdio-ipq4019.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/mdio/mdio-ipq4019.c b/drivers/net/mdio/mdio-ipq4019.c
index 0d7d3e15d2f0..5f4cd24a0241 100644
--- a/drivers/net/mdio/mdio-ipq4019.c
+++ b/drivers/net/mdio/mdio-ipq4019.c
@@ -207,6 +207,7 @@ static int ipq4019_mdio_probe(struct platform_device *pdev)
 {
 	struct ipq4019_mdio_data *priv;
 	struct mii_bus *bus;
+	struct resource *res;
 	int ret;
 
 	bus = devm_mdiobus_alloc_size(&pdev->dev, sizeof(*priv));
@@ -224,7 +225,10 @@ static int ipq4019_mdio_probe(struct platform_device *pdev)
 		return PTR_ERR(priv->mdio_clk);
 
 	/* The platform resource is provided on the chipset IPQ5018 */
-	priv->eth_ldo_rdy = devm_platform_ioremap_resource(pdev, 1);
+	/* This resource is optional */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (res)
+		priv->eth_ldo_rdy = devm_ioremap_resource(&pdev->dev, res);
 
 	bus->name = "ipq4019_mdio";
 	bus->read = ipq4019_mdio_read;
-- 
2.25.1

