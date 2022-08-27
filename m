Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3FC5A358C
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 09:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbiH0HUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 03:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232922AbiH0HUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 03:20:23 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C807CA9A;
        Sat, 27 Aug 2022 00:20:21 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MF7L5435vz1N7H4;
        Sat, 27 Aug 2022 15:16:45 +0800 (CST)
Received: from ubuntu-82.huawei.com (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 27 Aug 2022 15:20:18 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <socketcan@hartkopp.net>, <mkl@pengutronix.de>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 1/2] can: raw: process optimization in raw_init()
Date:   Sat, 27 Aug 2022 15:20:10 +0800
Message-ID: <7af9401f0d2d9fed36c1667b5ac9b8df8f8b87ee.1661584485.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1661584485.git.william.xuanziyang@huawei.com>
References: <cover.1661584485.git.william.xuanziyang@huawei.com>
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

Now, register notifier after register proto successfully. It can create
raw socket and set socket options once register proto successfully, so it
is possible missing notifier event before register notifier successfully
although this is a low probability scenario.

Move notifier registration to the front of proto registration like done
in j1939. In addition, register_netdevice_notifier() may fail, check its
result is necessary.

Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/can/raw.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/can/raw.c b/net/can/raw.c
index d1bd9cc51ebe..9ae7c4206b9a 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -942,12 +942,20 @@ static __init int raw_module_init(void)
 
 	pr_info("can: raw protocol\n");
 
+	err = register_netdevice_notifier(&canraw_notifier);
+	if (err)
+		return err;
+
 	err = can_proto_register(&raw_can_proto);
-	if (err < 0)
+	if (err < 0) {
 		pr_err("can: registration of raw protocol failed\n");
-	else
-		register_netdevice_notifier(&canraw_notifier);
+		goto register_proto_failed;
+	}
 
+	return 0;
+
+register_proto_failed:
+	unregister_netdevice_notifier(&canraw_notifier);
 	return err;
 }
 
-- 
2.25.1

