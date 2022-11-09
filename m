Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26066622A60
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 12:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbiKILYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 06:24:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiKILYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 06:24:53 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B9118B33
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 03:24:51 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N6jL01537zRp3w;
        Wed,  9 Nov 2022 19:24:40 +0800 (CST)
Received: from huawei.com (10.175.112.208) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 9 Nov
 2022 19:24:48 +0800
From:   Yuan Can <yuancan@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <mqaio@linux.alibaba.com>,
        <shaozhengchao@huawei.com>, <christophe.jaillet@wanadoo.fr>,
        <gustavoars@kernel.org>, <luobin9@huawei.com>,
        <netdev@vger.kernel.org>
CC:     <yuancan@huawei.com>
Subject: [PATCH] net: hinic: Fix error handling in hinic_module_init()
Date:   Wed, 9 Nov 2022 11:23:15 +0000
Message-ID: <20221109112315.125135-1-yuancan@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A problem about hinic create debugfs failed is triggered with the
following log given:

 [  931.419023] debugfs: Directory 'hinic' with parent '/' already present!

The reason is that hinic_module_init() returns pci_register_driver()
directly without checking its return value, if pci_register_driver()
failed, it returns without destroy the newly created debugfs, resulting
the debugfs of hinic can never be created later.

 hinic_module_init()
   hinic_dbg_register_debugfs() # create debugfs directory
   pci_register_driver()
     driver_register()
       bus_add_driver()
         priv = kzalloc(...) # OOM happened
   # return without destroy debugfs directory

Fix by removing debugfs when pci_register_driver() returns error.

Fixes: 253ac3a97921 ("hinic: add support to query sq info")
Signed-off-by: Yuan Can <yuancan@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_main.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index e1f54a2f28b2..b2fcd83d58fa 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -1474,8 +1474,17 @@ static struct pci_driver hinic_driver = {
 
 static int __init hinic_module_init(void)
 {
+	int ret;
+
 	hinic_dbg_register_debugfs(HINIC_DRV_NAME);
-	return pci_register_driver(&hinic_driver);
+
+	ret = pci_register_driver(&hinic_driver);
+	if (ret) {
+		hinic_dbg_unregister_debugfs();
+		return ret;
+	}
+
+	return 0;
 }
 
 static void __exit hinic_module_exit(void)
-- 
2.17.1

