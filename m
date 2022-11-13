Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B946626EC4
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 10:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbiKMJjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 04:39:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235233AbiKMJjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 04:39:04 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733ADCE1F
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 01:39:03 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N96nv27wqzmVt8;
        Sun, 13 Nov 2022 17:38:43 +0800 (CST)
Received: from huawei.com (10.175.112.208) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 13 Nov
 2022 17:39:01 +0800
From:   Yuan Can <yuancan@huawei.com>
To:     <mlindner@marvell.com>, <stephen@networkplumber.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jeff@garzik.org>, <netdev@vger.kernel.org>
CC:     <yuancan@huawei.com>
Subject: [PATCH 2/2] net: sky2: Fix error handling in sky2_init_module()
Date:   Sun, 13 Nov 2022 09:37:19 +0000
Message-ID: <20221113093719.23687-3-yuancan@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221113093719.23687-1-yuancan@huawei.com>
References: <20221113093719.23687-1-yuancan@huawei.com>
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

A problem about modprobe sky2 failed is triggered with the following log
given:

 sky2: driver version 1.30
 debugfs: Directory 'sky2' with parent '/' already present!

The reason is that sky2_init_module() returns pci_register_driver()
directly without checking its return value, if pci_register_driver()
failed, it returns without removing sky2 debugfs and unregister
sky2_notifier, resulting the debugfs of sky2 can never be created later.

 sky2_init_module()
   sky2_debug_init() # create debugfs and register sky2_notifier
   pci_register_driver()
     driver_register()
       bus_add_driver()
         priv = kzalloc(...) # OOM happened
   # return without destroy debugfs and unregister sky2_notifier

Fix by calling sky2_debug_cleanup() when pci_register_driver() returns
error.

Fixes: 3cf267539f1f ("sky2: debug interface")
Signed-off-by: Yuan Can <yuancan@huawei.com>
---
 drivers/net/ethernet/marvell/sky2.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index ab33ba1c3023..6996169b7ddd 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4536,7 +4536,7 @@ static __init void sky2_debug_init(void)
 	register_netdevice_notifier(&sky2_notifier);
 }
 
-static __exit void sky2_debug_cleanup(void)
+static void sky2_debug_cleanup(void)
 {
 	if (sky2_debug) {
 		unregister_netdevice_notifier(&sky2_notifier);
@@ -5144,10 +5144,16 @@ static struct pci_driver sky2_driver = {
 
 static int __init sky2_init_module(void)
 {
+	int ret;
+
 	pr_info("driver version " DRV_VERSION "\n");
 
 	sky2_debug_init();
-	return pci_register_driver(&sky2_driver);
+	ret = pci_register_driver(&sky2_driver);
+	if (ret)
+		sky2_debug_cleanup();
+
+	return ret;
 }
 
 static void __exit sky2_cleanup_module(void)
-- 
2.17.1

