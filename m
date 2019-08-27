Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8C39EA21
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 15:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729223AbfH0NvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 09:51:25 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5674 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726170AbfH0NvZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 09:51:25 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0D7BA7EEEE9F0493118C;
        Tue, 27 Aug 2019 21:51:06 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Tue, 27 Aug 2019
 21:50:58 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <mripard@kernel.org>, <wens@csie.org>
CC:     <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] phy: mdio-sun4i: use devm_platform_ioremap_resource() to simplify code
Date:   Tue, 27 Aug 2019 21:50:32 +0800
Message-ID: <20190827135032.14620-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devm_platform_ioremap_resource() to simplify the code a bit.
This is detected by coccinelle.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/phy/mdio-sun4i.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/phy/mdio-sun4i.c b/drivers/net/phy/mdio-sun4i.c
index 20ffd8f..58d6504 100644
--- a/drivers/net/phy/mdio-sun4i.c
+++ b/drivers/net/phy/mdio-sun4i.c
@@ -92,7 +92,6 @@ static int sun4i_mdio_probe(struct platform_device *pdev)
 	struct device_node *np = pdev->dev.of_node;
 	struct mii_bus *bus;
 	struct sun4i_mdio_data *data;
-	struct resource *res;
 	int ret;
 
 	bus = mdiobus_alloc_size(sizeof(*data));
@@ -106,8 +105,7 @@ static int sun4i_mdio_probe(struct platform_device *pdev)
 	bus->parent = &pdev->dev;
 
 	data = bus->priv;
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	data->membase = devm_ioremap_resource(&pdev->dev, res);
+	data->membase = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(data->membase)) {
 		ret = PTR_ERR(data->membase);
 		goto err_out_free_mdiobus;
-- 
2.7.4


