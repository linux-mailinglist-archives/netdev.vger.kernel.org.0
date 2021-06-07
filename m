Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C83839DE78
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 16:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhFGOS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 10:18:57 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3453 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbhFGOSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 10:18:55 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FzFjL1hgGz6x4J;
        Mon,  7 Jun 2021 22:13:58 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 22:16:57 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 7 Jun 2021
 22:16:56 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <rafal@milecki.pl>, <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH net-next] net: ethernet: bgmac: Use devm_platform_ioremap_resource_byname
Date:   Mon, 7 Jun 2021 22:21:09 +0800
Message-ID: <20210607142109.3992446-1-yangyingliang@huawei.com>
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

Use the devm_platform_ioremap_resource_byname() helper instead of
calling platform_get_resource_byname() and devm_ioremap_resource()
separately.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 .../net/ethernet/broadcom/bgmac-platform.c    | 21 +++++++------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bgmac-platform.c b/drivers/net/ethernet/broadcom/bgmac-platform.c
index 9834b77cf4b6..4ab5bf64d353 100644
--- a/drivers/net/ethernet/broadcom/bgmac-platform.c
+++ b/drivers/net/ethernet/broadcom/bgmac-platform.c
@@ -172,7 +172,6 @@ static int bgmac_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct bgmac *bgmac;
-	struct resource *regs;
 	int ret;
 
 	bgmac = bgmac_alloc(&pdev->dev);
@@ -206,21 +205,15 @@ static int bgmac_probe(struct platform_device *pdev)
 	if (IS_ERR(bgmac->plat.base))
 		return PTR_ERR(bgmac->plat.base);
 
-	regs = platform_get_resource_byname(pdev, IORESOURCE_MEM, "idm_base");
-	if (regs) {
-		bgmac->plat.idm_base = devm_ioremap_resource(&pdev->dev, regs);
-		if (IS_ERR(bgmac->plat.idm_base))
-			return PTR_ERR(bgmac->plat.idm_base);
+	bgmac->plat.idm_base = devm_platform_ioremap_resource_byname(pdev, "idm_base");
+	if (IS_ERR(bgmac->plat.idm_base))
+		return PTR_ERR(bgmac->plat.idm_base);
+	else
 		bgmac->feature_flags &= ~BGMAC_FEAT_IDM_MASK;
-	}
 
-	regs = platform_get_resource_byname(pdev, IORESOURCE_MEM, "nicpm_base");
-	if (regs) {
-		bgmac->plat.nicpm_base = devm_ioremap_resource(&pdev->dev,
-							       regs);
-		if (IS_ERR(bgmac->plat.nicpm_base))
-			return PTR_ERR(bgmac->plat.nicpm_base);
-	}
+	bgmac->plat.nicpm_base = devm_platform_ioremap_resource_byname(pdev, "nicpm_base");
+	if (IS_ERR(bgmac->plat.nicpm_base))
+		return PTR_ERR(bgmac->plat.nicpm_base);
 
 	bgmac->read = platform_bgmac_read;
 	bgmac->write = platform_bgmac_write;
-- 
2.25.1

