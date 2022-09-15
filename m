Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B49105B99AD
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 13:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiIOLf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 07:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiIOLfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 07:35:25 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A2115FF0
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 04:35:23 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MSw7L4s2kzBsLy;
        Thu, 15 Sep 2022 19:33:18 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 15 Sep 2022 19:35:21 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 15 Sep
 2022 19:35:21 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <hauke@hauke-m.de>,
        <andrew@lunn.ch>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@foss.st.com>
Subject: [PATCH -next 1/7] net: ethernet: ti: am65-cpts: Switch to use dev_err_probe() helper
Date:   Thu, 15 Sep 2022 19:42:08 +0800
Message-ID: <20220915114214.3145427-2-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220915114214.3145427-1-yangyingliang@huawei.com>
References: <20220915114214.3145427-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dev_err() can be replace with dev_err_probe() which will check if error
code is -EPROBE_DEFER.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/ti/am65-cpts.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
index c30a6e510aa3..e2f0fb286143 100644
--- a/drivers/net/ethernet/ti/am65-cpts.c
+++ b/drivers/net/ethernet/ti/am65-cpts.c
@@ -943,9 +943,7 @@ struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
 	cpts->irq = of_irq_get_byname(node, "cpts");
 	if (cpts->irq <= 0) {
 		ret = cpts->irq ?: -ENXIO;
-		if (ret != -EPROBE_DEFER)
-			dev_err(dev, "Failed to get IRQ number (err = %d)\n",
-				ret);
+		dev_err_probe(dev, ret, "Failed to get IRQ number\n");
 		return ERR_PTR(ret);
 	}
 
@@ -965,8 +963,7 @@ struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
 	cpts->refclk = devm_get_clk_from_child(dev, node, "cpts");
 	if (IS_ERR(cpts->refclk)) {
 		ret = PTR_ERR(cpts->refclk);
-		if (ret != -EPROBE_DEFER)
-			dev_err(dev, "Failed to get refclk %d\n", ret);
+		dev_err_probe(dev, ret, "Failed to get refclk\n");
 		return ERR_PTR(ret);
 	}
 
-- 
2.25.1

