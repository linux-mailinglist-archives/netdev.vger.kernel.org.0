Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAE0B626EC5
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 10:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235259AbiKMJjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 04:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiKMJjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 04:39:05 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7270DCE1B
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 01:39:03 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4N96kg4fRQzJnfZ;
        Sun, 13 Nov 2022 17:35:55 +0800 (CST)
Received: from huawei.com (10.175.112.208) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 13 Nov
 2022 17:39:00 +0800
From:   Yuan Can <yuancan@huawei.com>
To:     <mlindner@marvell.com>, <stephen@networkplumber.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jeff@garzik.org>, <netdev@vger.kernel.org>
CC:     <yuancan@huawei.com>
Subject: [PATCH 1/2] net: skge: Fix error handling in skge_init_module()
Date:   Sun, 13 Nov 2022 09:37:18 +0000
Message-ID: <20221113093719.23687-2-yuancan@huawei.com>
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

A problem about modprobe skge failed is triggered with the following log
given:

 debugfs: Directory 'skge' with parent '/' already present!
 ------------[ cut here ]------------
 notifier callback skge_device_event [skge] already registered
 WARNING: CPU: 1 PID: 236 at kernel/notifier.c:29 notifier_chain_register+0x168/0x230
 ...

The reason is that skge_init_module() returns pci_register_driver()
directly without checking its return value, if pci_register_driver()
failed, it returns without removing skge debugfs and unregister
skge_notifier, resulting the debugfs of skge can never be created later
and triggers the WARNING of notifier registered.

 skge_init_module()
   skge_debug_init() # create debugfs and register skge_notifier
   pci_register_driver()
     driver_register()
       bus_add_driver()
         priv = kzalloc(...) # OOM happened
   # return without destroy debugfs and unregister skge_notifier

Fix by calling skge_debug_cleanup() when pci_register_driver() returns
error.

Fixes: 678aa1f6ac86 ("skge: add a debug interface")
Signed-off-by: Yuan Can <yuancan@huawei.com>
---
 drivers/net/ethernet/marvell/skge.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index 1b43704baceb..01d141369b3e 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -3776,7 +3776,7 @@ static __init void skge_debug_init(void)
 	register_netdevice_notifier(&skge_notifier);
 }
 
-static __exit void skge_debug_cleanup(void)
+static void skge_debug_cleanup(void)
 {
 	if (skge_debug) {
 		unregister_netdevice_notifier(&skge_notifier);
@@ -4179,10 +4179,16 @@ static const struct dmi_system_id skge_32bit_dma_boards[] = {
 
 static int __init skge_init_module(void)
 {
+	int ret;
+
 	if (dmi_check_system(skge_32bit_dma_boards))
 		only_32bit_dma = 1;
 	skge_debug_init();
-	return pci_register_driver(&skge_driver);
+	ret = pci_register_driver(&skge_driver);
+	if (ret)
+		skge_debug_cleanup();
+
+	return ret;
 }
 
 static void __exit skge_cleanup_module(void)
-- 
2.17.1

