Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0153A256C
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 09:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbhFJH1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 03:27:37 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:5317 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbhFJH1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 03:27:24 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G0wNy05dCz1BKwX;
        Thu, 10 Jun 2021 15:20:34 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 15:25:25 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 10 Jun
 2021 15:25:25 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH net-next] net: w5100: Use devm_platform_get_and_ioremap_resource()
Date:   Thu, 10 Jun 2021 15:29:33 +0800
Message-ID: <20210610072933.4074571-1-yangyingliang@huawei.com>
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
 drivers/net/ethernet/wiznet/w5100.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/wiznet/w5100.c b/drivers/net/ethernet/wiznet/w5100.c
index ec5db481c9cd..811815f8cd3b 100644
--- a/drivers/net/ethernet/wiznet/w5100.c
+++ b/drivers/net/ethernet/wiznet/w5100.c
@@ -263,19 +263,14 @@ static int w5100_writebulk_direct(struct net_device *ndev, u32 addr,
 static int w5100_mmio_init(struct net_device *ndev)
 {
 	struct platform_device *pdev = to_platform_device(ndev->dev.parent);
-	struct w5100_priv *priv = netdev_priv(ndev);
 	struct w5100_mmio_priv *mmio_priv = w5100_mmio_priv(ndev);
-	struct resource *mem;
 
 	spin_lock_init(&mmio_priv->reg_lock);
 
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	mmio_priv->base = devm_ioremap_resource(&pdev->dev, mem);
+	mmio_priv->base = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
 	if (IS_ERR(mmio_priv->base))
 		return PTR_ERR(mmio_priv->base);
 
-	netdev_info(ndev, "at 0x%llx irq %d\n", (u64)mem->start, priv->irq);
-
 	return 0;
 }
 
-- 
2.25.1

