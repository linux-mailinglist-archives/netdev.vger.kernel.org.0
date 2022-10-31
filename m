Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F45461309B
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 07:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiJaGmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 02:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiJaGmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 02:42:37 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB08BCAF;
        Sun, 30 Oct 2022 23:42:35 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N13Nt0Z1zz15MFj;
        Mon, 31 Oct 2022 14:37:34 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 31 Oct
 2022 14:42:32 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <lvs-devel@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <horms@verge.net.au>, <ja@ssi.bg>, <pablo@netfilter.org>,
        <kadlec@netfilter.org>, <fw@strlen.de>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <hans.schillstrom@ericsson.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net] ipvs: fix WARNING in __ip_vs_cleanup_batch()
Date:   Mon, 31 Oct 2022 14:49:56 +0800
Message-ID: <20221031064956.332614-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During the initialization of ip_vs_conn_net_init(), if file ip_vs_conn
or ip_vs_conn_sync fails to be created, the initialization is successful
by default. Therefore, the ip_vs_conn or ip_vs_conn_sync file doesn't
be found during the remove.

The following is the stack information:
name 'ip_vs_conn_sync'
WARNING: CPU: 3 PID: 9 at fs/proc/generic.c:712
remove_proc_entry+0x389/0x460
Modules linked in:
Workqueue: netns cleanup_net
RIP: 0010:remove_proc_entry+0x389/0x460
Call Trace:
<TASK>
__ip_vs_cleanup_batch+0x7d/0x120
ops_exit_list+0x125/0x170
cleanup_net+0x4ea/0xb00
process_one_work+0x9bf/0x1710
worker_thread+0x665/0x1080
kthread+0x2e4/0x3a0
ret_from_fork+0x1f/0x30
</TASK>

Fixes: 61b1ab4583e2 ("IPVS: netns, add basic init per netns.")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/netfilter/ipvs/ip_vs_conn.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 8c04bb57dd6f..b126bd7df321 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1447,12 +1447,22 @@ int __net_init ip_vs_conn_net_init(struct netns_ipvs *ipvs)
 {
 	atomic_set(&ipvs->conn_count, 0);
 
-	proc_create_net("ip_vs_conn", 0, ipvs->net->proc_net,
-			&ip_vs_conn_seq_ops, sizeof(struct ip_vs_iter_state));
-	proc_create_net("ip_vs_conn_sync", 0, ipvs->net->proc_net,
-			&ip_vs_conn_sync_seq_ops,
-			sizeof(struct ip_vs_iter_state));
+	if (!proc_create_net("ip_vs_conn", 0, ipvs->net->proc_net,
+			     &ip_vs_conn_seq_ops,
+			     sizeof(struct ip_vs_iter_state)))
+		goto err_conn;
+
+	if (!proc_create_net("ip_vs_conn_sync", 0, ipvs->net->proc_net,
+			     &ip_vs_conn_sync_seq_ops,
+			     sizeof(struct ip_vs_iter_state)))
+		goto err_conn_sync;
+
 	return 0;
+
+err_conn_sync:
+	remove_proc_entry("ip_vs_conn", ipvs->net->proc_net);
+err_conn:
+	return -ENOMEM;
 }
 
 void __net_exit ip_vs_conn_net_cleanup(struct netns_ipvs *ipvs)
-- 
2.17.1

