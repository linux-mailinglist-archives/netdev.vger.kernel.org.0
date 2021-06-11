Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23493A3B28
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 06:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbhFKEsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 00:48:47 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:5499 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbhFKEsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 00:48:46 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G1Ssm1BFxzZf48;
        Fri, 11 Jun 2021 12:43:56 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 12:46:46 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 11 Jun
 2021 12:46:46 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>
Subject: [PATCH net-next v2] net: mdio: mscc-miim: Use devm_platform_get_and_ioremap_resource()
Date:   Fri, 11 Jun 2021 12:50:49 +0800
Message-ID: <20210611045049.3905429-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devm_platform_get_and_ioremap_resource() to simplify
code.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
v2:
  only convert the first platform_get_resource()
---
 drivers/net/mdio/mdio-mscc-miim.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index b36e5ea04ddf..071c654bab29 100644
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
@@ -155,7 +151,7 @@ static int mscc_miim_probe(struct platform_device *pdev)
 	bus->parent = &pdev->dev;
 
 	dev = bus->priv;
-	dev->regs = devm_ioremap_resource(&pdev->dev, res);
+	dev->regs = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(dev->regs)) {
 		dev_err(&pdev->dev, "Unable to map MIIM registers\n");
 		return PTR_ERR(dev->regs);
-- 
2.25.1

