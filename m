Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 699085B99AC
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 13:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiIOLfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 07:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiIOLf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 07:35:26 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C7A95AF5
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 04:35:25 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MSw6d209sznVG7;
        Thu, 15 Sep 2022 19:32:41 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 15 Sep 2022 19:35:23 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 15 Sep
 2022 19:35:23 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <hauke@hauke-m.de>,
        <andrew@lunn.ch>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@foss.st.com>
Subject: [PATCH -next 5/7] net: ibm: emac: Switch to use dev_err_probe() helper
Date:   Thu, 15 Sep 2022 19:42:12 +0800
Message-ID: <20220915114214.3145427-6-yangyingliang@huawei.com>
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
 drivers/net/ethernet/ibm/emac/core.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index 0a4d04a8825d..9b08e41ccc29 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -2979,11 +2979,9 @@ static int emac_init_config(struct emac_instance *dev)
 
 	/* Read MAC-address */
 	err = of_get_ethdev_address(np, dev->ndev);
-	if (err) {
-		if (err != -EPROBE_DEFER)
-			dev_err(&dev->ofdev->dev, "Can't get valid [local-]mac-address from OF !\n");
-		return err;
-	}
+	if (err)
+		return dev_err_probe(&dev->ofdev->dev, err,
+				     "Can't get valid [local-]mac-address from OF !\n");
 
 	/* IAHT and GAHT filter parameterization */
 	if (emac_has_feature(dev, EMAC_FTR_EMAC4SYNC)) {
-- 
2.25.1

