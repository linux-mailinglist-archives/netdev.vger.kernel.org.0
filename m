Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6206B1BA011
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 11:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgD0JjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 05:39:24 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2915 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726349AbgD0JjX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 05:39:23 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 45D47A311F6C411A0EA6;
        Mon, 27 Apr 2020 17:39:21 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Mon, 27 Apr 2020 17:39:12 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Wei Yongjun <weiyongjun1@huawei.com>
CC:     <linux-omap@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] drivers: net: davinci_mdio: fix potential NULL dereference in davinci_mdio_probe()
Date:   Mon, 27 Apr 2020 09:40:32 +0000
Message-ID: <20200427094032.181184-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

platform_get_resource() may fail and return NULL, so we should
better check it's return value to avoid a NULL pointer dereference
a bit later in the code.

This is detected by Coccinelle semantic patch.

@@
expression pdev, res, n, t, e, e1, e2;
@@

res = \(platform_get_resource\|platform_get_resource_byname\)(pdev, t, n);
+ if (!res)
+   return -EINVAL;
... when != res == NULL
e = devm_ioremap(e1, res->start, e2);

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/ti/davinci_mdio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/ti/davinci_mdio.c b/drivers/net/ethernet/ti/davinci_mdio.c
index 38b7f6d35759..702fdc393da0 100644
--- a/drivers/net/ethernet/ti/davinci_mdio.c
+++ b/drivers/net/ethernet/ti/davinci_mdio.c
@@ -397,6 +397,8 @@ static int davinci_mdio_probe(struct platform_device *pdev)
 	data->dev = dev;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EINVAL;
 	data->regs = devm_ioremap(dev, res->start, resource_size(res));
 	if (!data->regs)
 		return -ENOMEM;





