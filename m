Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE3F39F821
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 15:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbhFHNyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 09:54:09 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3800 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbhFHNyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 09:54:09 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Fzs4B21nlzWsQn;
        Tue,  8 Jun 2021 21:47:22 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 21:52:13 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 8 Jun 2021
 21:52:12 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH net-next] net: nixge: simplify code with devm platform functions
Date:   Tue, 8 Jun 2021 21:56:22 +0800
Message-ID: <20210608135622.3009485-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devm_platform_get_and_ioremap_resource() and
devm_platform_ioremap_resource_byname to simplify
code.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/ni/nixge.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index a6861df9904f..2d097dcb7bda 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -1224,7 +1224,6 @@ static int nixge_of_get_resources(struct platform_device *pdev)
 	const struct of_device_id *of_id;
 	enum nixge_version version;
 	struct resource *ctrlres;
-	struct resource *dmares;
 	struct net_device *ndev;
 	struct nixge_priv *priv;
 
@@ -1236,12 +1235,9 @@ static int nixge_of_get_resources(struct platform_device *pdev)
 
 	version = (enum nixge_version)of_id->data;
 	if (version <= NIXGE_V2)
-		dmares = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+		priv->dma_regs = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
 	else
-		dmares = platform_get_resource_byname(pdev, IORESOURCE_MEM,
-						      "dma");
-
-	priv->dma_regs = devm_ioremap_resource(&pdev->dev, dmares);
+		priv->dma_regs = devm_platform_ioremap_resource_byname(pdev, "dma");
 	if (IS_ERR(priv->dma_regs)) {
 		netdev_err(ndev, "failed to map dma regs\n");
 		return PTR_ERR(priv->dma_regs);
-- 
2.25.1

