Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 831D4222F2
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 11:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729785AbfERJ5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 05:57:36 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8206 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728654AbfERJ5g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 May 2019 05:57:36 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C449A285E9918B8D2269;
        Sat, 18 May 2019 17:57:33 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Sat, 18 May 2019
 17:57:24 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <socketcan@hartkopp.net>, <mkl@pengutronix.de>,
        <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-can@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH v2] can: gw: Fix error path of cgw_module_init
Date:   Sat, 18 May 2019 17:35:43 +0800
Message-ID: <20190518093543.11016-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
In-Reply-To: <80ca1430-da86-42c3-75c7-eadf91b20220@pengutronix.de>
References: <80ca1430-da86-42c3-75c7-eadf91b20220@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add error path for cgw_module_init
to avoid possible crash if some error occurs.

Fixes: c1aabdf379bc ("can-gw: add netlink based CAN routing")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/can/gw.c | 48 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 15 deletions(-)

diff --git a/net/can/gw.c b/net/can/gw.c
index 53859346..bd21614 100644
--- a/net/can/gw.c
+++ b/net/can/gw.c
@@ -1046,32 +1046,50 @@ static __init int cgw_module_init(void)
 	pr_info("can: netlink gateway (rev " CAN_GW_VERSION ") max_hops=%d\n",
 		max_hops);
 
-	register_pernet_subsys(&cangw_pernet_ops);
+	ret = register_pernet_subsys(&cangw_pernet_ops);
+	if (ret)
+		return ret;
+
+	ret = -ENOMEM;
 	cgw_cache = kmem_cache_create("can_gw", sizeof(struct cgw_job),
 				      0, 0, NULL);
-
 	if (!cgw_cache)
-		return -ENOMEM;
+		goto out_cache_create;
 
 	/* set notifier */
 	notifier.notifier_call = cgw_notifier;
-	register_netdevice_notifier(&notifier);
+	ret = register_netdevice_notifier(&notifier);
+	if (ret)
+		goto out_register_notifier;
 
 	ret = rtnl_register_module(THIS_MODULE, PF_CAN, RTM_GETROUTE,
 				   NULL, cgw_dump_jobs, 0);
-	if (ret) {
-		unregister_netdevice_notifier(&notifier);
-		kmem_cache_destroy(cgw_cache);
-		return -ENOBUFS;
-	}
-
-	/* Only the first call to rtnl_register_module can fail */
-	rtnl_register_module(THIS_MODULE, PF_CAN, RTM_NEWROUTE,
-			     cgw_create_job, NULL, 0);
-	rtnl_register_module(THIS_MODULE, PF_CAN, RTM_DELROUTE,
-			     cgw_remove_job, NULL, 0);
+	if (ret)
+		goto out_rtnl_register1;
+
+	ret = rtnl_register_module(THIS_MODULE, PF_CAN, RTM_NEWROUTE,
+				   cgw_create_job, NULL, 0);
+	if (ret)
+		goto out_rtnl_register2;
+	ret = rtnl_register_module(THIS_MODULE, PF_CAN, RTM_DELROUTE,
+				   cgw_remove_job, NULL, 0);
+	if (ret)
+		goto out_rtnl_register3;
 
 	return 0;
+
+out_rtnl_register3:
+	rtnl_unregister(PF_CAN, RTM_NEWROUTE);
+out_rtnl_register2:
+	rtnl_unregister(PF_CAN, RTM_GETROUTE);
+out_rtnl_register1:
+	unregister_netdevice_notifier(&notifier);
+out_register_notifier:
+	kmem_cache_destroy(cgw_cache);
+out_cache_create:
+	unregister_pernet_subsys(&cangw_pernet_ops);
+
+	return ret;
 }
 
 static __exit void cgw_module_exit(void)
-- 
1.8.3.1


