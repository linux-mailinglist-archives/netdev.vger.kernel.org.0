Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B633E5B9490
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 08:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiIOGoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 02:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiIOGoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 02:44:00 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477D195E4B
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 23:43:55 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MSnc53lS3zNmHC;
        Thu, 15 Sep 2022 14:39:17 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 15 Sep 2022 14:43:46 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 15 Sep
 2022 14:43:46 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
Subject: [PATCH -next 3/3] net: mdio: mux-multiplexer: Switch to use dev_err_probe() helper
Date:   Thu, 15 Sep 2022 14:50:43 +0800
Message-ID: <20220915065043.665138-3-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220915065043.665138-1-yangyingliang@huawei.com>
References: <20220915065043.665138-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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
 drivers/net/mdio/mdio-mux-multiplexer.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/mdio/mdio-mux-multiplexer.c b/drivers/net/mdio/mdio-mux-multiplexer.c
index 527acfc3c045..bfa5af577b0a 100644
--- a/drivers/net/mdio/mdio-mux-multiplexer.c
+++ b/drivers/net/mdio/mdio-mux-multiplexer.c
@@ -72,12 +72,9 @@ static int mdio_mux_multiplexer_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	s->muxc = devm_mux_control_get(dev, NULL);
-	if (IS_ERR(s->muxc)) {
-		ret = PTR_ERR(s->muxc);
-		if (ret != -EPROBE_DEFER)
-			dev_err(&pdev->dev, "Failed to get mux: %d\n", ret);
-		return ret;
-	}
+	if (IS_ERR(s->muxc))
+		return dev_err_probe(&pdev->dev, PTR_ERR(s->muxc),
+				     "Failed to get mux\n");
 
 	platform_set_drvdata(pdev, s);
 
-- 
2.25.1

