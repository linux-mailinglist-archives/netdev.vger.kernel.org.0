Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6C25B948E
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 08:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiIOGnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 02:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiIOGns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 02:43:48 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9437CDFDF
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 23:43:47 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MSnbx314CzNmGN;
        Thu, 15 Sep 2022 14:39:09 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 15 Sep 2022 14:43:45 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 15 Sep
 2022 14:43:45 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
Subject: [PATCH -next 1/3] net: mdio: mux-meson-g12a: Switch to use dev_err_probe() helper
Date:   Thu, 15 Sep 2022 14:50:41 +0800
Message-ID: <20220915065043.665138-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
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
 drivers/net/mdio/mdio-mux-meson-g12a.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/net/mdio/mdio-mux-meson-g12a.c b/drivers/net/mdio/mdio-mux-meson-g12a.c
index b8866bc3f2e8..4a2e94faf57e 100644
--- a/drivers/net/mdio/mdio-mux-meson-g12a.c
+++ b/drivers/net/mdio/mdio-mux-meson-g12a.c
@@ -233,11 +233,9 @@ static int g12a_ephy_glue_clk_register(struct device *dev)
 
 		snprintf(in_name, sizeof(in_name), "clkin%d", i);
 		clk = devm_clk_get(dev, in_name);
-		if (IS_ERR(clk)) {
-			if (PTR_ERR(clk) != -EPROBE_DEFER)
-				dev_err(dev, "Missing clock %s\n", in_name);
-			return PTR_ERR(clk);
-		}
+		if (IS_ERR(clk))
+			return dev_err_probe(dev, PTR_ERR(clk),
+					     "Missing clock %s\n", in_name);
 
 		parent_names[i] = __clk_get_name(clk);
 	}
@@ -317,12 +315,9 @@ static int g12a_mdio_mux_probe(struct platform_device *pdev)
 		return PTR_ERR(priv->regs);
 
 	priv->pclk = devm_clk_get(dev, "pclk");
-	if (IS_ERR(priv->pclk)) {
-		ret = PTR_ERR(priv->pclk);
-		if (ret != -EPROBE_DEFER)
-			dev_err(dev, "failed to get peripheral clock\n");
-		return ret;
-	}
+	if (IS_ERR(priv->pclk))
+		return dev_err_probe(dev, PTR_ERR(priv->pclk),
+				     "failed to get peripheral clock\n");
 
 	/* Make sure the device registers are clocked */
 	ret = clk_prepare_enable(priv->pclk);
@@ -339,8 +334,7 @@ static int g12a_mdio_mux_probe(struct platform_device *pdev)
 	ret = mdio_mux_init(dev, dev->of_node, g12a_mdio_switch_fn,
 			    &priv->mux_handle, dev, NULL);
 	if (ret) {
-		if (ret != -EPROBE_DEFER)
-			dev_err(dev, "mdio multiplexer init failed: %d", ret);
+		dev_err_probe(dev, ret, "mdio multiplexer init failed\n");
 		goto err;
 	}
 
-- 
2.25.1

