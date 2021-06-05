Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA5139C6DA
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 10:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbhFEIrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 04:47:09 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7114 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbhFEIrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 04:47:09 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FxtRr53lTzYnLj;
        Sat,  5 Jun 2021 16:42:32 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 16:45:19 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Sat, 5 Jun 2021
 16:45:18 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ulli.kroll@googlemail.com>, <linus.walleij@linaro.org>,
        <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH net-next] net: gemini: Use devm_platform_get_and_ioremap_resource()
Date:   Sat, 5 Jun 2021 16:49:35 +0800
Message-ID: <20210605084935.2078812-1-yangyingliang@huawei.com>
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
 drivers/net/ethernet/cortina/gemini.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 8df6f081f244..bc921bb42b34 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2390,22 +2390,12 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 	port->msg_enable = netif_msg_init(debug, DEFAULT_MSG_ENABLE);
 
 	/* DMA memory */
-	dmares = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!dmares) {
-		dev_err(dev, "no DMA resource\n");
-		return -ENODEV;
-	}
-	port->dma_base = devm_ioremap_resource(dev, dmares);
+	port->dma_base = devm_platform_get_and_ioremap_resource(pdev, 0, &dmares);
 	if (IS_ERR(port->dma_base))
 		return PTR_ERR(port->dma_base);
 
 	/* GMAC config memory */
-	gmacres = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	if (!gmacres) {
-		dev_err(dev, "no GMAC resource\n");
-		return -ENODEV;
-	}
-	port->gmac_base = devm_ioremap_resource(dev, gmacres);
+	port->gmac_base = devm_platform_get_and_ioremap_resource(pdev, 1, &gmacres);
 	if (IS_ERR(port->gmac_base))
 		return PTR_ERR(port->gmac_base);
 
-- 
2.25.1

