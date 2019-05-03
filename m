Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2C112C05
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 13:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbfECLJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 07:09:20 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:58076 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726396AbfECLJT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 07:09:19 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 12FD75CB04A129E301F5;
        Fri,  3 May 2019 19:09:17 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Fri, 3 May 2019 19:09:10 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Andrew Lunn <andrew@lunn.ch>,
        Sekhar Nori <nsekhar@ti.com>, Fugang Duan <fugang.duan@nxp.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <linux-omap@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] drivers: net: davinci_mdio: fix return value check in davinci_mdio_probe()
Date:   Fri, 3 May 2019 11:18:59 +0000
Message-ID: <20190503111859.1023-1-weiyongjun1@huawei.com>
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

In case of error, the function devm_ioremap() returns NULL pointer not
ERR_PTR(). The IS_ERR() test in the return value check should be
replaced with NULL test.

Fixes: 03f66f067560 ("net: ethernet: ti: davinci_mdio: use devm_ioremap()")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/ti/davinci_mdio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_mdio.c b/drivers/net/ethernet/ti/davinci_mdio.c
index 11642721c123..38b7f6d35759 100644
--- a/drivers/net/ethernet/ti/davinci_mdio.c
+++ b/drivers/net/ethernet/ti/davinci_mdio.c
@@ -398,8 +398,8 @@ static int davinci_mdio_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	data->regs = devm_ioremap(dev, res->start, resource_size(res));
-	if (IS_ERR(data->regs))
-		return PTR_ERR(data->regs);
+	if (!data->regs)
+		return -ENOMEM;
 
 	davinci_mdio_init_clk(data);



