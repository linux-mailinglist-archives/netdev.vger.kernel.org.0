Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0B6760D90E
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 04:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiJZCGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 22:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiJZCGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 22:06:47 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C777AC4BD;
        Tue, 25 Oct 2022 19:06:45 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MxscR07cpzHv3L;
        Wed, 26 Oct 2022 10:06:31 +0800 (CST)
Received: from dggpemm500013.china.huawei.com (7.185.36.172) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 26 Oct 2022 10:06:43 +0800
Received: from ubuntu1804.huawei.com (10.67.175.36) by
 dggpemm500013.china.huawei.com (7.185.36.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 26 Oct 2022 10:06:43 +0800
From:   Chen Zhongjin <chenzhongjin@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <chenzhongjin@huawei.com>
Subject: [PATCH] net: dsa: Fix possible memory leaks in dsa_loop_init()
Date:   Wed, 26 Oct 2022 10:03:21 +0800
Message-ID: <20221026020321.58615-1-chenzhongjin@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.36]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500013.china.huawei.com (7.185.36.172)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmemleak reported memory leaks in dsa_loop_init():

kmemleak: 12 new suspected memory leaks

unreferenced object 0xffff8880138ce000 (size 2048):
  comm "modprobe", pid 390, jiffies 4295040478 (age 238.976s)
  backtrace:
    [<000000006a94f1d5>] kmalloc_trace+0x26/0x60
    [<00000000a9c44622>] phy_device_create+0x5d/0x970
    [<00000000d0ee2afc>] get_phy_device+0xf3/0x2b0
    [<00000000dca0c71f>] __fixed_phy_register.part.0+0x92/0x4e0
    [<000000008a834798>] fixed_phy_register+0x84/0xb0
    [<0000000055223fcb>] dsa_loop_init+0xa9/0x116 [dsa_loop]
    ...

There are two reasons for memleak in dsa_loop_init().

First, fixed_phy_register() create and register phy_device:

fixed_phy_register()
  get_phy_device()
    phy_device_create() # freed by phy_device_free()
  phy_device_register() # freed by phy_device_remove()

But fixed_phy_unregister() only calls phy_device_remove().
So the memory allocated in phy_device_create() is leaked.

Second, when mdio_driver_register() fail in dsa_loop_init(),
it just returns and there is no cleanup for phydevs.

Fix the problems by catching the error of mdio_driver_register()
in dsa_loop_init(), then calling both fixed_phy_unregister() and
phy_device_free() to release phydevs.
Also add a function for phydevs cleanup to avoid duplacate.

Fixes: 98cd1552ea27 ("net: dsa: Mock-up driver")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
---
 drivers/net/dsa/dsa_loop.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index b9107fe40023..5b139f2206b6 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -376,6 +376,17 @@ static struct mdio_driver dsa_loop_drv = {
 
 #define NUM_FIXED_PHYS	(DSA_LOOP_NUM_PORTS - 2)
 
+static void dsa_loop_phydevs_unregister(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < NUM_FIXED_PHYS; i++)
+		if (!IS_ERR(phydevs[i])) {
+			fixed_phy_unregister(phydevs[i]);
+			phy_device_free(phydevs[i]);
+		}
+}
+
 static int __init dsa_loop_init(void)
 {
 	struct fixed_phy_status status = {
@@ -383,23 +394,23 @@ static int __init dsa_loop_init(void)
 		.speed = SPEED_100,
 		.duplex = DUPLEX_FULL,
 	};
-	unsigned int i;
+	unsigned int i, ret;
 
 	for (i = 0; i < NUM_FIXED_PHYS; i++)
 		phydevs[i] = fixed_phy_register(PHY_POLL, &status, NULL);
 
-	return mdio_driver_register(&dsa_loop_drv);
+	ret = mdio_driver_register(&dsa_loop_drv);
+	if (ret)
+		dsa_loop_phydevs_unregister();
+
+	return ret;
 }
 module_init(dsa_loop_init);
 
 static void __exit dsa_loop_exit(void)
 {
-	unsigned int i;
-
 	mdio_driver_unregister(&dsa_loop_drv);
-	for (i = 0; i < NUM_FIXED_PHYS; i++)
-		if (!IS_ERR(phydevs[i]))
-			fixed_phy_unregister(phydevs[i]);
+	dsa_loop_phydevs_unregister();
 }
 module_exit(dsa_loop_exit);
 
-- 
2.17.1

