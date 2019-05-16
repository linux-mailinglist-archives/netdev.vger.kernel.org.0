Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8E320A0A
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 16:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbfEPOoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 10:44:46 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7656 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726801AbfEPOop (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 10:44:45 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B4D2797CB8B754873F96;
        Thu, 16 May 2019 22:44:42 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Thu, 16 May 2019
 22:44:31 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <socketcan@hartkopp.net>,
        <mkl@pengutronix.de>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-can@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] can: Fix error path of can_init
Date:   Thu, 16 May 2019 22:36:26 +0800
Message-ID: <20190516143626.27636-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add error path for can_init to
avoid possible crash if some error occurs.

Fixes: 0d66548a10cb ("[CAN]: Add PF_CAN core module")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/can/af_can.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index 1684ba5..a1781ea 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -958,6 +958,8 @@ static void can_pernet_exit(struct net *net)
 
 static __init int can_init(void)
 {
+	int rc;
+
 	/* check for correct padding to be able to use the structs similarly */
 	BUILD_BUG_ON(offsetof(struct can_frame, can_dlc) !=
 		     offsetof(struct canfd_frame, len) ||
@@ -971,15 +973,31 @@ static __init int can_init(void)
 	if (!rcv_cache)
 		return -ENOMEM;
 
-	register_pernet_subsys(&can_pernet_ops);
+	rc = register_pernet_subsys(&can_pernet_ops);
+	if (rc)
+		goto out_pernet;
 
 	/* protocol register */
-	sock_register(&can_family_ops);
-	register_netdevice_notifier(&can_netdev_notifier);
+	rc = sock_register(&can_family_ops);
+	if (rc)
+		goto out_sock;
+	rc = register_netdevice_notifier(&can_netdev_notifier);
+	if (rc)
+		goto out_notifier;
+
 	dev_add_pack(&can_packet);
 	dev_add_pack(&canfd_packet);
 
 	return 0;
+
+out_notifier:
+	sock_unregister(PF_CAN);
+out_sock:
+	unregister_pernet_subsys(&can_pernet_ops);
+out_pernet:
+	kmem_cache_destroy(rcv_cache);
+
+	return rc;
 }
 
 static __exit void can_exit(void)
-- 
1.8.3.1


