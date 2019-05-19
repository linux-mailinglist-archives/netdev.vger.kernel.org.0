Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 256FA22773
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 19:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbfESREY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 13:04:24 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:53536 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725777AbfESREX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 May 2019 13:04:23 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6CEBF1A028E709A6FC32;
        Sun, 19 May 2019 17:13:54 +0800 (CST)
Received: from [127.0.0.1] (10.184.191.73) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Sun, 19 May 2019
 17:13:47 +0800
To:     <davem@davemloft.net>, <willemdebruijn.kernel@gmail.com>,
        <jon.maloy@ericsson.com>, <ying.xue@windriver.com>,
        <sfr@canb.auug.org.au>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        <tipc-discussion@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <mingfangsen@huawei.com>
From:   hujunwei <hujunwei4@huawei.com>
Subject: [PATCH v3] tipc: fix modprobe tipc failed after switch order of
 device registration
Message-ID: <529aff15-5f3a-1bf1-76fa-691911ff6170@huawei.com>
Date:   Sun, 19 May 2019 17:13:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.191.73]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Junwei Hu <hujunwei4@huawei.com>

Error message printed:
modprobe: ERROR: could not insert 'tipc': Address family not
supported by protocol.
when modprobe tipc after the following patch: switch order of
device registration, commit 7e27e8d6130c
("tipc: switch order of device registration to fix a crash")

Because sock_create_kern(net, AF_TIPC, ...) called by
tipc_topsrv_create_listener() in the initialization process
of tipc_init_net(), so tipc_socket_init() must be execute before that.
Meanwhile, tipc_net_id need to be initialized when sock_create()
called, and tipc_socket_init() is no need to be called for each namespace.

I add a variable tipc_topsrv_net_ops, and split the
register_pernet_subsys() of tipc into two parts, and split
tipc_socket_init() with initialization of pernet params.

By the way, I fixed resources rollback error when tipc_bcast_init()
failed in tipc_init_net().

Fixes: 7e27e8d6130c
("tipc: switch order of device registration to fix a crash")
Signed-off-by: Junwei Hu <hujunwei4@huawei.com>
Reported-by: Wang Wang <wangwang2@huawei.com>
Reported-by: syzbot+1e8114b61079bfe9cbc5@syzkaller.appspotmail.com
Reviewed-by: Kang Zhou <zhoukang7@huawei.com>
Reviewed-by: Suanming Mou <mousuanming@huawei.com>
---
V1->V2:
- split the register_pernet_subsys() of tipc into two parts
V2->V3:
- update Reported-by
---
 net/tipc/core.c   | 18 ++++++++++++------
 net/tipc/subscr.h |  5 +++--
 net/tipc/topsrv.c | 14 ++++++++++++--
 3 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/net/tipc/core.c b/net/tipc/core.c
index ddd2e0f67c07..ed536c05252a 100644
--- a/net/tipc/core.c
+++ b/net/tipc/core.c
@@ -77,9 +77,6 @@ static int __net_init tipc_init_net(struct net *net)
 		goto out_nametbl;

 	INIT_LIST_HEAD(&tn->dist_queue);
-	err = tipc_topsrv_start(net);
-	if (err)
-		goto out_subscr;

 	err = tipc_bcast_init(net);
 	if (err)
@@ -88,8 +85,6 @@ static int __net_init tipc_init_net(struct net *net)
 	return 0;

 out_bclink:
-	tipc_bcast_stop(net);
-out_subscr:
 	tipc_nametbl_stop(net);
 out_nametbl:
 	tipc_sk_rht_destroy(net);
@@ -99,7 +94,6 @@ static int __net_init tipc_init_net(struct net *net)

 static void __net_exit tipc_exit_net(struct net *net)
 {
-	tipc_topsrv_stop(net);
 	tipc_net_stop(net);
 	tipc_bcast_stop(net);
 	tipc_nametbl_stop(net);
@@ -113,6 +107,11 @@ static struct pernet_operations tipc_net_ops = {
 	.size = sizeof(struct tipc_net),
 };

+static struct pernet_operations tipc_topsrv_net_ops = {
+	.init = tipc_topsrv_init_net,
+	.exit = tipc_topsrv_exit_net,
+};
+
 static int __init tipc_init(void)
 {
 	int err;
@@ -143,6 +142,10 @@ static int __init tipc_init(void)
 	if (err)
 		goto out_socket;

+	err = register_pernet_subsys(&tipc_topsrv_net_ops);
+	if (err)
+		goto out_pernet_topsrv;
+
 	err = tipc_bearer_setup();
 	if (err)
 		goto out_bearer;
@@ -150,6 +153,8 @@ static int __init tipc_init(void)
 	pr_info("Started in single node mode\n");
 	return 0;
 out_bearer:
+	unregister_pernet_subsys(&tipc_topsrv_net_ops);
+out_pernet_topsrv:
 	tipc_socket_stop();
 out_socket:
 	unregister_pernet_subsys(&tipc_net_ops);
@@ -167,6 +172,7 @@ static int __init tipc_init(void)
 static void __exit tipc_exit(void)
 {
 	tipc_bearer_cleanup();
+	unregister_pernet_subsys(&tipc_topsrv_net_ops);
 	tipc_socket_stop();
 	unregister_pernet_subsys(&tipc_net_ops);
 	tipc_netlink_stop();
diff --git a/net/tipc/subscr.h b/net/tipc/subscr.h
index d793b4343885..aa015c233898 100644
--- a/net/tipc/subscr.h
+++ b/net/tipc/subscr.h
@@ -77,8 +77,9 @@ void tipc_sub_report_overlap(struct tipc_subscription *sub,
 			     u32 found_lower, u32 found_upper,
 			     u32 event, u32 port, u32 node,
 			     u32 scope, int must);
-int tipc_topsrv_start(struct net *net);
-void tipc_topsrv_stop(struct net *net);
+
+int __net_init tipc_topsrv_init_net(struct net *net);
+void __net_exit tipc_topsrv_exit_net(struct net *net);

 void tipc_sub_put(struct tipc_subscription *subscription);
 void tipc_sub_get(struct tipc_subscription *subscription);
diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index b45932d78004..f345662890a6 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -635,7 +635,7 @@ static void tipc_topsrv_work_stop(struct tipc_topsrv *s)
 	destroy_workqueue(s->send_wq);
 }

-int tipc_topsrv_start(struct net *net)
+static int tipc_topsrv_start(struct net *net)
 {
 	struct tipc_net *tn = tipc_net(net);
 	const char name[] = "topology_server";
@@ -668,7 +668,7 @@ int tipc_topsrv_start(struct net *net)
 	return ret;
 }

-void tipc_topsrv_stop(struct net *net)
+static void tipc_topsrv_stop(struct net *net)
 {
 	struct tipc_topsrv *srv = tipc_topsrv(net);
 	struct socket *lsock = srv->listener;
@@ -693,3 +693,13 @@ void tipc_topsrv_stop(struct net *net)
 	idr_destroy(&srv->conn_idr);
 	kfree(srv);
 }
+
+int __net_init tipc_topsrv_init_net(struct net *net)
+{
+	return tipc_topsrv_start(net);
+}
+
+void __net_exit tipc_topsrv_exit_net(struct net *net)
+{
+	tipc_topsrv_stop(net);
+}
-- 
2.21.GIT

