Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766845B8935
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 15:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiINNd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 09:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiINNdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 09:33:25 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7984DB2A;
        Wed, 14 Sep 2022 06:33:24 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MSLlm5GJRz14QM8;
        Wed, 14 Sep 2022 21:29:24 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 14 Sep 2022 21:33:22 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 14 Sep
 2022 21:33:22 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <wg@grandegger.com>, <mkl@pengutronix.de>
Subject: [PATCH -next] can: flexcan: Switch to use dev_err_probe() helper
Date:   Wed, 14 Sep 2022 21:40:30 +0800
Message-ID: <20220914134030.3782754-1-yangyingliang@huawei.com>
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
 drivers/net/can/flexcan/flexcan-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/can/flexcan/flexcan-core.c b/drivers/net/can/flexcan/flexcan-core.c
index f857968efed7..ac881394e3b4 100644
--- a/drivers/net/can/flexcan/flexcan-core.c
+++ b/drivers/net/can/flexcan/flexcan-core.c
@@ -2177,8 +2177,7 @@ static int flexcan_probe(struct platform_device *pdev)
 
 	err = flexcan_setup_stop_mode(pdev);
 	if (err < 0) {
-		if (err != -EPROBE_DEFER)
-			dev_err(&pdev->dev, "setup stop mode failed\n");
+		dev_err_probe(&pdev->dev, err, "setup stop mode failed\n");
 		goto failed_setup_stop_mode;
 	}
 
-- 
2.25.1

