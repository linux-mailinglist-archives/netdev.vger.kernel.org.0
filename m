Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88593A3DA7
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 10:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbhFKICL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 04:02:11 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:9076 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbhFKICF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 04:02:05 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G1Y8n4YZ5zYrYj;
        Fri, 11 Jun 2021 15:57:13 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 16:00:05 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 11 Jun
 2021 16:00:04 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <weiyongjun1@huawei.com>
Subject: [PATCH net-next v3] net: mdio: mscc-miim: Use devm_platform_get_and_ioremap_resource()
Date:   Fri, 11 Jun 2021 16:04:09 +0800
Message-ID: <20210611080409.3647459-1-yangyingliang@huawei.com>
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
v3:
  no need use 'res'

v2:
  only convert the first platform_get_resource()
---
 drivers/net/mdio/mdio-mscc-miim.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index b36e5ea04ddf..2d67e12c8262 100644
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
+	dev->regs = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
 	if (IS_ERR(dev->regs)) {
 		dev_err(&pdev->dev, "Unable to map MIIM registers\n");
 		return PTR_ERR(dev->regs);
-- 
2.25.1

