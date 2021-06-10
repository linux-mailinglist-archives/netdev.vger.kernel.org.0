Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3AC3A2800
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 11:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhFJJPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 05:15:06 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3828 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbhFJJPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 05:15:05 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G0ynB1qdJzWstd;
        Thu, 10 Jun 2021 17:08:14 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 17:13:06 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 10 Jun
 2021 17:13:05 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>
Subject: [PATCH net-next] net: mido: mdio-mux-bcm-iproc: Use devm_platform_get_and_ioremap_resource()
Date:   Thu, 10 Jun 2021 17:17:12 +0800
Message-ID: <20210610091712.4146291-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devm_platform_get_and_ioremap_resource() to simplify
code and avoid a null-ptr-deref by checking 'res' in it.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/mdio/mdio-mux-bcm-iproc.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/mdio/mdio-mux-bcm-iproc.c b/drivers/net/mdio/mdio-mux-bcm-iproc.c
index 239e88c7a272..014c0baedbd2 100644
--- a/drivers/net/mdio/mdio-mux-bcm-iproc.c
+++ b/drivers/net/mdio/mdio-mux-bcm-iproc.c
@@ -187,7 +187,9 @@ static int mdio_mux_iproc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	md->dev = &pdev->dev;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	md->base = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
+	if (IS_ERR(md->base))
+		return PTR_ERR(md->base);
 	if (res->start & 0xfff) {
 		/* For backward compatibility in case the
 		 * base address is specified with an offset.
@@ -196,9 +198,6 @@ static int mdio_mux_iproc_probe(struct platform_device *pdev)
 		res->start &= ~0xfff;
 		res->end = res->start + MDIO_REG_ADDR_SPACE_SIZE - 1;
 	}
-	md->base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(md->base))
-		return PTR_ERR(md->base);
 
 	md->mii_bus = devm_mdiobus_alloc(&pdev->dev);
 	if (!md->mii_bus) {
-- 
2.25.1

