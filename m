Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDEB362D551
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 09:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239371AbiKQIoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 03:44:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239270AbiKQIoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 03:44:30 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B3A69DE6;
        Thu, 17 Nov 2022 00:43:49 -0800 (PST)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NCYN427WvzHw2L;
        Thu, 17 Nov 2022 16:43:16 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (7.193.23.191) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 17 Nov 2022 16:43:43 +0800
Received: from ubuntu1804.huawei.com (10.67.175.30) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 17 Nov 2022 16:43:42 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <mw@semihalf.com>, <linux@armlinux.org.uk>, <leon@kernel.org>,
        <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yusongping@huawei.com>
Subject: [PATCH net v5] net: mvpp2: fix possible invalid pointer dereference
Date:   Thu, 17 Nov 2022 16:40:32 +0800
Message-ID: <20221117084032.101144-1-tanghui20@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.30]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600005.china.huawei.com (7.193.23.191)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It will cause invalid pointer dereference to priv->cm3_base behind,
if PTR_ERR(priv->cm3_base) in mvpp2_get_sram().

Fixes: a59d354208a7 ("net: mvpp2: enable global flow control")
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
v1 -> v2: patch title include target
v2 -> v3: keep priv->cm3_base NULL if devm_ioremap_resource() failed
v3 -> v4: change if (priv->cm3_base) to if (base)
v4 -> v5: use the idiomatic error handling, keep success path un-indented
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index d98f7e9a480e..4f3c1757620c 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -7349,6 +7349,7 @@ static int mvpp2_get_sram(struct platform_device *pdev,
 			  struct mvpp2 *priv)
 {
 	struct resource *res;
+	void __iomem *base;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
 	if (!res) {
@@ -7359,9 +7360,12 @@ static int mvpp2_get_sram(struct platform_device *pdev,
 		return 0;
 	}
 
-	priv->cm3_base = devm_ioremap_resource(&pdev->dev, res);
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
 
-	return PTR_ERR_OR_ZERO(priv->cm3_base);
+	priv->cm3_base = base;
+	return 0;
 }
 
 static int mvpp2_probe(struct platform_device *pdev)
-- 
2.17.1

