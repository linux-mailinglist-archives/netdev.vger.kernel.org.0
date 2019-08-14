Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00DF38C890
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbfHNCc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:32:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728986AbfHNCQQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:16:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B06F8208C2;
        Wed, 14 Aug 2019 02:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748975;
        bh=UBgiw4GDo97WyEMY5pNO+B4iV952FC1swLqxRucJ8V0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NldrgWFLGldEemQ1h2PW9kbAIy+y7fSe7wed6yP1pHlbVcsKxhFLrUeoAFB5sbVwO
         VzqmNNLeQHZkfznYyB3MfZfhH3g1sX8uQHEGJBJxP3lGh6Ryqd4gjdKzUd2fI8ElF5
         grGbGHRedEAkIGknKXjQwuu4oa7vhd2ukCGtLXx4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 15/68] can: gw: Fix error path of cgw_module_init
Date:   Tue, 13 Aug 2019 22:14:53 -0400
Message-Id: <20190814021548.16001-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021548.16001-1-sashal@kernel.org>
References: <20190814021548.16001-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit b7a14297f102b6e2ce6f16feffebbb9bde1e9b55 ]

This patch add error path for cgw_module_init to avoid possible crash if
some error occurs.

Fixes: c1aabdf379bc ("can-gw: add netlink based CAN routing")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/gw.c | 48 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 15 deletions(-)

diff --git a/net/can/gw.c b/net/can/gw.c
index 53859346dc9a9..bd2161470e456 100644
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
2.20.1

