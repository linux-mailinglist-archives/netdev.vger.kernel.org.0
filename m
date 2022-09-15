Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE815B950D
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 09:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiIOHG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 03:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiIOHG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 03:06:26 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD42D40E29;
        Thu, 15 Sep 2022 00:06:24 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MSp7c69FsznVHP;
        Thu, 15 Sep 2022 15:03:08 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 15 Sep 2022 15:05:51 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 15 Sep
 2022 15:05:50 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-wpan@vger.kernel.org>
CC:     <liuxuenetmail@gmail.com>, <alex.aring@gmail.com>,
        <stefan@datenfreihafen.org>, <davem@davemloft.net>
Subject: [PATCH -next] net: ieee802154: mcr20a: Switch to use dev_err_probe() helper
Date:   Thu, 15 Sep 2022 15:12:58 +0800
Message-ID: <20220915071258.678536-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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

dev_err() can be replace with dev_err_probe() which will check if error
code is -EPROBE_DEFER.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ieee802154/mcr20a.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ieee802154/mcr20a.c b/drivers/net/ieee802154/mcr20a.c
index 2fe0e4a0a0c4..f53d185e0568 100644
--- a/drivers/net/ieee802154/mcr20a.c
+++ b/drivers/net/ieee802154/mcr20a.c
@@ -1233,12 +1233,9 @@ mcr20a_probe(struct spi_device *spi)
 	}
 
 	rst_b = devm_gpiod_get(&spi->dev, "rst_b", GPIOD_OUT_HIGH);
-	if (IS_ERR(rst_b)) {
-		ret = PTR_ERR(rst_b);
-		if (ret != -EPROBE_DEFER)
-			dev_err(&spi->dev, "Failed to get 'rst_b' gpio: %d", ret);
-		return ret;
-	}
+	if (IS_ERR(rst_b))
+		return dev_err_probe(&spi->dev, PTR_ERR(rst_b),
+				     "Failed to get 'rst_b' gpio");
 
 	/* reset mcr20a */
 	usleep_range(10, 20);
-- 
2.25.1

