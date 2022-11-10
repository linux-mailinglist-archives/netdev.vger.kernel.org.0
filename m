Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDB346239B2
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 03:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbiKJCSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 21:18:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiKJCSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 21:18:21 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435161C920
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 18:18:20 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N758s1jvNz15MPT;
        Thu, 10 Nov 2022 10:18:05 +0800 (CST)
Received: from huawei.com (10.175.112.208) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 10 Nov
 2022 10:18:17 +0800
From:   Yuan Can <yuancan@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <mqaio@linux.alibaba.com>,
        <shaozhengchao@huawei.com>, <christophe.jaillet@wanadoo.fr>,
        <gustavoars@kernel.org>, <luobin9@huawei.com>,
        <netdev@vger.kernel.org>
CC:     <yuancan@huawei.com>
Subject: [PATCH v2] net: hinic: Fix error handling in hinic_module_init()
Date:   Thu, 10 Nov 2022 02:16:42 +0000
Message-ID: <20221110021642.80378-1-yuancan@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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
Changes in v2:
- Change to simpler error handling style

 drivers/net/ethernet/huawei/hinic/hinic_main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index e1f54a2f28b2..2d6906aba2a2 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -1474,8 +1474,15 @@ static struct pci_driver hinic_driver = {
 
 static int __init hinic_module_init(void)
 {
+	int ret;
+
 	hinic_dbg_register_debugfs(HINIC_DRV_NAME);
-	return pci_register_driver(&hinic_driver);
+
+	ret = pci_register_driver(&hinic_driver);
+	if (ret)
+		hinic_dbg_unregister_debugfs();
+
+	return ret;
 }
 
 static void __exit hinic_module_exit(void)
-- 
2.17.1

