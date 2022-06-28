Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAE555C8A9
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344876AbiF1L7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 07:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbiF1L67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 07:58:59 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F90AA446;
        Tue, 28 Jun 2022 04:58:57 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4LXNQb5DPfz9srD;
        Tue, 28 Jun 2022 19:58:15 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 28 Jun 2022 19:58:55 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 28 Jun
 2022 19:58:54 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-renesas-soc@vger.kernel.org>
CC:     <clement.leger@bootlin.com>, <olteanv@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>
Subject: [PATCH -next] net: pcs-rzn1-miic: fix return value check in miic_probe()
Date:   Tue, 28 Jun 2022 20:08:50 +0800
Message-ID: <20220628120850.3425568-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If devm_platform_ioremap_resource() fails, it never return
NULL pointer, replace NULL test with IS_ERR().

Fixes: 7dc54d3b8d91 ("net: pcs: add Renesas MII converter driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/pcs/pcs-rzn1-miic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/pcs/pcs-rzn1-miic.c b/drivers/net/pcs/pcs-rzn1-miic.c
index 8f5e910f443d..d896961e48cc 100644
--- a/drivers/net/pcs/pcs-rzn1-miic.c
+++ b/drivers/net/pcs/pcs-rzn1-miic.c
@@ -461,8 +461,8 @@ static int miic_probe(struct platform_device *pdev)
 	spin_lock_init(&miic->lock);
 	miic->dev = dev;
 	miic->base = devm_platform_ioremap_resource(pdev, 0);
-	if (!miic->base)
-		return -EINVAL;
+	if (IS_ERR(miic->base))
+		return PTR_ERR(miic->base);
 
 	ret = devm_pm_runtime_enable(dev);
 	if (ret < 0)
-- 
2.25.1

