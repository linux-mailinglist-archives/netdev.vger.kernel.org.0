Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 376D863BCEB
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 10:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbiK2J3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 04:29:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbiK2J3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 04:29:00 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2B54A04D;
        Tue, 29 Nov 2022 01:28:58 -0800 (PST)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NLxpT6Z20zmW81;
        Tue, 29 Nov 2022 17:28:17 +0800 (CST)
Received: from dggpemm500013.china.huawei.com (7.185.36.172) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 29 Nov 2022 17:28:57 +0800
Received: from ubuntu1804.huawei.com (10.67.175.36) by
 dggpemm500013.china.huawei.com (7.185.36.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 29 Nov 2022 17:28:56 +0800
From:   Chen Zhongjin <chenzhongjin@huawei.com>
To:     <linux-bluetooth@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <chenzhongjin@huawei.com>, <marcel@holtmann.org>,
        <johan.hedberg@gmail.com>, <luiz.dentz@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
Subject: [PATCH] Bluetooth: Fix not cleanup led when bt_init fails
Date:   Tue, 29 Nov 2022 17:25:56 +0800
Message-ID: <20221129092556.116222-1-chenzhongjin@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.36]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500013.china.huawei.com (7.185.36.172)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bt_init() calls bt_leds_init() to register led, but if it fails later,
bt_leds_cleanup() is not called to unregister it.

This can cause panic if the argument "bluetooth-power" in text is freed
and then another led_trigger_register() tries to access it:

BUG: unable to handle page fault for address: ffffffffc06d3bc0
RIP: 0010:strcmp+0xc/0x30
  Call Trace:
    <TASK>
    led_trigger_register+0x10d/0x4f0
    led_trigger_register_simple+0x7d/0x100
    bt_init+0x39/0xf7 [bluetooth]
    do_one_initcall+0xd0/0x4e0

Fixes: e64c97b53bc6 ("Bluetooth: Add combined LED trigger for controller power")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
---
 net/bluetooth/af_bluetooth.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
index dc65974f5adb..1c3c7ff5c3c6 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -737,7 +737,7 @@ static int __init bt_init(void)
 
 	err = bt_sysfs_init();
 	if (err < 0)
-		return err;
+		goto cleanup_led;
 
 	err = sock_register(&bt_sock_family_ops);
 	if (err)
@@ -773,6 +773,8 @@ static int __init bt_init(void)
 	sock_unregister(PF_BLUETOOTH);
 cleanup_sysfs:
 	bt_sysfs_cleanup();
+cleanup_led:
+	bt_leds_cleanup();
 	return err;
 }
 
-- 
2.17.1

