Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30CF83A27C9
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 11:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbhFJJJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 05:09:51 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3827 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbhFJJJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 05:09:50 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G0yg6652PzWtLX;
        Thu, 10 Jun 2021 17:02:58 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 17:07:52 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 10 Jun
 2021 17:07:51 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>
Subject: [PATCH net-next] net: mdio: mscc-miim: Use devm_platform_get_and_ioremap_resource()
Date:   Thu, 10 Jun 2021 17:11:54 +0800
Message-ID: <20210610091154.4141911-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devm_platform_get_and_ioremap_resource() to simplify
code.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/mdio/mdio-mscc-miim.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index b36e5ea04ddf..b8491efbd330 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -139,10 +139,6 @@ static int mscc_miim_probe(struct platform_device *pdev)
 	struct mscc_miim_dev *dev;
 	int ret;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
-
 	bus = devm_mdiobus_alloc_size(&pdev->dev, sizeof(*dev));
 	if (!bus)
 		return -ENOMEM;
@@ -155,19 +151,16 @@ static int mscc_miim_probe(struct platform_device *pdev)
 	bus->parent = &pdev->dev;
 
 	dev = bus->priv;
-	dev->regs = devm_ioremap_resource(&pdev->dev, res);
+	dev->regs = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(dev->regs)) {
 		dev_err(&pdev->dev, "Unable to map MIIM registers\n");
 		return PTR_ERR(dev->regs);
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	if (res) {
-		dev->phy_regs = devm_ioremap_resource(&pdev->dev, res);
-		if (IS_ERR(dev->phy_regs)) {
-			dev_err(&pdev->dev, "Unable to map internal phy registers\n");
-			return PTR_ERR(dev->phy_regs);
-		}
+	dev->phy_regs = devm_platform_get_and_ioremap_resource(pdev, 1, &res);
+	if (res && IS_ERR(dev->phy_regs)) {
+		dev_err(&pdev->dev, "Unable to map internal phy registers\n");
+		return PTR_ERR(dev->phy_regs);
 	}
 
 	ret = of_mdiobus_register(bus, pdev->dev.of_node);
-- 
2.25.1

