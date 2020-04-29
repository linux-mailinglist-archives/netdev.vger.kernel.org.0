Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB5D1BD2A6
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 04:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbgD2CvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 22:51:14 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:38834 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726422AbgD2CvO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 22:51:14 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 07B796FC0641C483C356;
        Wed, 29 Apr 2020 10:51:12 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Wed, 29 Apr 2020 10:51:06 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        David Lechner <david@lechnology.com>,
        Wei Yongjun <weiyongjun1@huawei.com>
CC:     <linux-omap@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next v2] drivers: net: davinci_mdio: fix potential NULL dereference in davinci_mdio_probe()
Date:   Wed, 29 Apr 2020 02:52:20 +0000
Message-ID: <20200429025220.166415-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200427094032.181184-1-weiyongjun1@huawei.com>
References: <20200427094032.181184-1-weiyongjun1@huawei.com>
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
since devm_ioremap() does not check input parameters for null.

This is detected by Coccinelle semantic patch.

@@
expression pdev, res, n, t, e, e1, e2;
@@

res = \(platform_get_resource\|platform_get_resource_byname\)(pdev, t, n);
+ if (!res)
+   return -EINVAL;
... when != res == NULL
e = devm_ioremap(e1, res->start, e2);

Fixes: 03f66f067560 ("net: ethernet: ti: davinci_mdio: use devm_ioremap()")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
v1 -> v2: add fixes and reviewed-by
---
 drivers/net/ethernet/ti/davinci_mdio.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

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



