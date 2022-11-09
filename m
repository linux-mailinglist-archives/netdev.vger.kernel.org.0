Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD69B62261C
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 10:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiKIJB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 04:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbiKIJBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 04:01:52 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D72192A8;
        Wed,  9 Nov 2022 01:01:51 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N6f4w1rlBzpWCG;
        Wed,  9 Nov 2022 16:58:08 +0800 (CST)
Received: from dggpemm500013.china.huawei.com (7.185.36.172) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 17:01:48 +0800
Received: from ubuntu1804.huawei.com (10.67.175.36) by
 dggpemm500013.china.huawei.com (7.185.36.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 17:01:48 +0800
From:   Chen Zhongjin <chenzhongjin@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <tudor.ambarus@microchip.com>, <chenzhongjin@huawei.com>
Subject: [PATCH] Bluetooth: selftest: Fix memleak in test_ecdh()
Date:   Wed, 9 Nov 2022 16:58:35 +0800
Message-ID: <20221109085835.213252-1-chenzhongjin@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.36]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500013.china.huawei.com (7.185.36.172)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmemleak reported:
 Bluetooth: ECDH sample 1 failed
 kmemleak: 2 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
 unreferenced object 0xffff888102149100 (size 96):
  comm "modprobe", pid 418, jiffies 4295082093 (age 610.644s)
  ...
  backtrace:
    [<00000000c8e4e5a6>] __kmalloc_node+0x4c/0x1c0
    [<000000006cdcfddc>] crypto_create_tfm_node+0x89/0x320
    [<00000000e222ad46>] crypto_alloc_tfm_node+0xfd/0x2f0
    [<00000000871fc045>] 0xffffffffc05c94ab
    [<00000000e889f45e>] 0xffffffffc05c8024
    [<000000001ff0c346>] do_one_initcall+0xd0/0x4e0
  ...

In test_ecdh(), when test sample fails, crypto_free_kpp(tfm) is not
called, which makes tfm memory leaked. Fix it by moving crypto_free_kpp
behind done label.

Fixes: 47eb2ac80918 ("Bluetooth: move ecdh allocation outside of ecdh_helper")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
---
 net/bluetooth/selftest.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/selftest.c b/net/bluetooth/selftest.c
index f49604d44b87..586125a611dd 100644
--- a/net/bluetooth/selftest.c
+++ b/net/bluetooth/selftest.c
@@ -233,8 +233,6 @@ static int __init test_ecdh(void)
 		goto done;
 	}
 
-	crypto_free_kpp(tfm);
-
 	rettime = ktime_get();
 	delta = ktime_sub(rettime, calltime);
 	duration = (unsigned long long) ktime_to_ns(delta) >> 10;
@@ -248,6 +246,8 @@ static int __init test_ecdh(void)
 	else
 		snprintf(test_ecdh_buffer, sizeof(test_ecdh_buffer), "FAIL\n");
 
+	crypto_free_kpp(tfm);
+
 	debugfs_create_file("selftest_ecdh", 0444, bt_debugfs, NULL,
 			    &test_ecdh_fops);
 
-- 
2.17.1

