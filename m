Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31EFF50A0FE
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 15:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387149AbiDUNnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 09:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385954AbiDUNmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 09:42:33 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEE536E37;
        Thu, 21 Apr 2022 06:39:43 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Kkdr566VNzFqGZ;
        Thu, 21 Apr 2022 21:37:09 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 21 Apr 2022 21:39:41 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 21 Apr
 2022 21:39:41 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH] ethernet: broadcom/sb1250-mac: remove BUG_ON in sbmac_probe()
Date:   Thu, 21 Apr 2022 21:51:48 +0800
Message-ID: <20220421135148.2890823-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
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

Replace the BUG_ON() with returning error code to handle
the fault more gracefully.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/broadcom/sb1250-mac.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/sb1250-mac.c b/drivers/net/ethernet/broadcom/sb1250-mac.c
index a1a38456c9a3..5d5f10180158 100644
--- a/drivers/net/ethernet/broadcom/sb1250-mac.c
+++ b/drivers/net/ethernet/broadcom/sb1250-mac.c
@@ -2534,7 +2534,12 @@ static int sbmac_probe(struct platform_device *pldev)
 	int err;
 
 	res = platform_get_resource(pldev, IORESOURCE_MEM, 0);
-	BUG_ON(!res);
+	if (!res) {
+		printk(KERN_ERR "%s: failed to get resource\n",
+		       dev_name(&pldev->dev));
+		err = -EINVAL;
+		goto out_out;
+	}
 	sbm_base = ioremap(res->start, resource_size(res));
 	if (!sbm_base) {
 		printk(KERN_ERR "%s: unable to map device registers\n",
-- 
2.25.1

