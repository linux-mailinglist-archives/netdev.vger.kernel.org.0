Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33D039C811
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 14:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbhFEMTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 08:19:08 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7119 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbhFEMTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 08:19:07 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Fxz8Q0SjJzYp0t;
        Sat,  5 Jun 2021 20:14:30 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 20:17:16 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Sat, 5 Jun 2021
 20:17:10 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <hauke@hauke-m.de>, <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH net-next v2] net: lantiq: Use devm_platform_get_and_ioremap_resource()
Date:   Sat, 5 Jun 2021 20:21:27 +0800
Message-ID: <20210605122127.2469235-1-yangyingliang@huawei.com>
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
code.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
v2:
  remove 'res'
---
 drivers/net/ethernet/lantiq_xrx200.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 36dc3e5f6218..27df06ed355e 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -436,7 +436,6 @@ static int xrx200_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct device_node *np = dev->of_node;
-	struct resource *res;
 	struct xrx200_priv *priv;
 	struct net_device *net_dev;
 	int err;
@@ -456,13 +455,7 @@ static int xrx200_probe(struct platform_device *pdev)
 	net_dev->max_mtu = XRX200_DMA_DATA_LEN;
 
 	/* load the memory ranges */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(dev, "failed to get resources\n");
-		return -ENOENT;
-	}
-
-	priv->pmac_reg = devm_ioremap_resource(dev, res);
+	priv->pmac_reg = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
 	if (IS_ERR(priv->pmac_reg))
 		return PTR_ERR(priv->pmac_reg);
 
-- 
2.25.1

