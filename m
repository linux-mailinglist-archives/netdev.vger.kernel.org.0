Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2E9761572C
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 02:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiKBB66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 21:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiKBB64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 21:58:56 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC33D1400C
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 18:58:54 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N296L24vkz15MJ9;
        Wed,  2 Nov 2022 09:58:50 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 2 Nov
 2022 09:58:52 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <dlezcano@fr.ibm.com>, <benjamin.thery@bull.net>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net] ipv6: fix WARNING in ip6_route_net_exit_late()
Date:   Wed, 2 Nov 2022 10:06:10 +0800
Message-ID: <20221102020610.351330-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During the initialization of ip6_route_net_init_late(), if file
ipv6_route or rt6_stats fails to be created, the initialization is
successful by default. Therefore, the ipv6_route or rt6_stats file
doesn't be found during the remove in ip6_route_net_exit_late(). It
will cause WRNING.

The following is the stack information:
name 'rt6_stats'
WARNING: CPU: 0 PID: 9 at fs/proc/generic.c:712 remove_proc_entry+0x389/0x460
Modules linked in:
Workqueue: netns cleanup_net
RIP: 0010:remove_proc_entry+0x389/0x460
PKRU: 55555554
Call Trace:
<TASK>
ops_exit_list+0xb0/0x170
cleanup_net+0x4ea/0xb00
process_one_work+0x9bf/0x1710
worker_thread+0x665/0x1080
kthread+0x2e4/0x3a0
ret_from_fork+0x1f/0x30
</TASK>

Fixes: cdb1876192db ("[NETNS][IPV6] route6 - create route6 proc files for the namespace")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/ipv6/route.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 69252eb462b2..2f355f0ec32a 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6555,10 +6555,16 @@ static void __net_exit ip6_route_net_exit(struct net *net)
 static int __net_init ip6_route_net_init_late(struct net *net)
 {
 #ifdef CONFIG_PROC_FS
-	proc_create_net("ipv6_route", 0, net->proc_net, &ipv6_route_seq_ops,
-			sizeof(struct ipv6_route_iter));
-	proc_create_net_single("rt6_stats", 0444, net->proc_net,
-			rt6_stats_seq_show, NULL);
+	if (!proc_create_net("ipv6_route", 0, net->proc_net,
+			     &ipv6_route_seq_ops,
+			     sizeof(struct ipv6_route_iter)))
+		return -ENOMEM;
+
+	if (!proc_create_net_single("rt6_stats", 0444, net->proc_net,
+				    rt6_stats_seq_show, NULL)) {
+		remove_proc_entry("ipv6_route", net->proc_net);
+		return -ENOMEM;
+	}
 #endif
 	return 0;
 }
-- 
2.17.1

