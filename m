Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 951075B12C4
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 05:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiIHDEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 23:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiIHDEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 23:04:36 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6C33887;
        Wed,  7 Sep 2022 20:04:28 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MNP6R70hLzgYv0;
        Thu,  8 Sep 2022 11:01:51 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 8 Sep 2022 11:04:26 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <socketcan@hartkopp.net>, <mkl@pengutronix.de>,
        <edumazet@google.com>, <kuba@kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] can: bcm: registration process optimization in bcm_module_init()
Date:   Thu, 8 Sep 2022 11:04:19 +0800
Message-ID: <823cff0ebec33fa9389eeaf8b8ded3217c32cb38.1662606045.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1662606045.git.william.xuanziyang@huawei.com>
References: <cover.1662606045.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now, register_netdevice_notifier() and register_pernet_subsys() are both
after can_proto_register(). It can create CAN_BCM socket and process socket
once can_proto_register() successfully, so it is possible missing notifier
event or proc node creation because notifier or bcm proc directory is not
registered or created yet. Although this is a low probability scenario, it
is not impossible.

Move register_pernet_subsys() and register_netdevice_notifier() to the
front of can_proto_register(). In addition, register_pernet_subsys() and
register_netdevice_notifier() may fail, check their results are necessary.

Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/can/bcm.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index e60161bec850..e2783156bfd1 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -1744,15 +1744,27 @@ static int __init bcm_module_init(void)
 
 	pr_info("can: broadcast manager protocol\n");
 
+	err = register_pernet_subsys(&canbcm_pernet_ops);
+	if (err)
+		return err;
+
+	err = register_netdevice_notifier(&canbcm_notifier);
+	if (err)
+		goto register_notifier_failed;
+
 	err = can_proto_register(&bcm_can_proto);
 	if (err < 0) {
 		printk(KERN_ERR "can: registration of bcm protocol failed\n");
-		return err;
+		goto register_proto_failed;
 	}
 
-	register_pernet_subsys(&canbcm_pernet_ops);
-	register_netdevice_notifier(&canbcm_notifier);
 	return 0;
+
+register_proto_failed:
+	unregister_netdevice_notifier(&canbcm_notifier);
+register_notifier_failed:
+	unregister_pernet_subsys(&canbcm_pernet_ops);
+	return err;
 }
 
 static void __exit bcm_module_exit(void)
-- 
2.25.1

