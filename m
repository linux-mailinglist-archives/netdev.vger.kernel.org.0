Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A152C1EB7
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 08:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729937AbgKXHO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 02:14:56 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7723 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729240AbgKXHOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 02:14:55 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CgFdC1kjRzkdG0;
        Tue, 24 Nov 2020 15:14:23 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Tue, 24 Nov 2020
 15:14:43 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net v2] ipv6: addrlabel: fix possible memory leak in ip6addrlbl_net_init
Date:   Tue, 24 Nov 2020 15:17:28 +0800
Message-ID: <20201124071728.8385-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmemleak report a memory leak as follows:

unreferenced object 0xffff8880059c6a00 (size 64):
  comm "ip", pid 23696, jiffies 4296590183 (age 1755.384s)
  hex dump (first 32 bytes):
    20 01 00 10 00 00 00 00 00 00 00 00 00 00 00 00   ...............
    1c 00 00 00 00 00 00 00 00 00 00 00 07 00 00 00  ................
  backtrace:
    [<00000000aa4e7a87>] ip6addrlbl_add+0x90/0xbb0
    [<0000000070b8d7f1>] ip6addrlbl_net_init+0x109/0x170
    [<000000006a9ca9d4>] ops_init+0xa8/0x3c0
    [<000000002da57bf2>] setup_net+0x2de/0x7e0
    [<000000004e52d573>] copy_net_ns+0x27d/0x530
    [<00000000b07ae2b4>] create_new_namespaces+0x382/0xa30
    [<000000003b76d36f>] unshare_nsproxy_namespaces+0xa1/0x1d0
    [<0000000030653721>] ksys_unshare+0x3a4/0x780
    [<0000000007e82e40>] __x64_sys_unshare+0x2d/0x40
    [<0000000031a10c08>] do_syscall_64+0x33/0x40
    [<0000000099df30e7>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

We should free all rules when we catch an error in ip6addrlbl_net_init().
otherwise a memory leak will occur.

Fixes: 2a8cc6c89039 ("[IPV6] ADDRCONF: Support RFC3484 configurable address selection policy table.")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
v1->v2: simplify this function
 net/ipv6/addrlabel.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/net/ipv6/addrlabel.c b/net/ipv6/addrlabel.c
index 642fc6ac13d2..8a22486cf270 100644
--- a/net/ipv6/addrlabel.c
+++ b/net/ipv6/addrlabel.c
@@ -306,7 +306,9 @@ static int ip6addrlbl_del(struct net *net,
 /* add default label */
 static int __net_init ip6addrlbl_net_init(struct net *net)
 {
-	int err = 0;
+	struct ip6addrlbl_entry *p = NULL;
+	struct hlist_node *n;
+	int err;
 	int i;
 
 	ADDRLABEL(KERN_DEBUG "%s\n", __func__);
@@ -315,14 +317,20 @@ static int __net_init ip6addrlbl_net_init(struct net *net)
 	INIT_HLIST_HEAD(&net->ipv6.ip6addrlbl_table.head);
 
 	for (i = 0; i < ARRAY_SIZE(ip6addrlbl_init_table); i++) {
-		int ret = ip6addrlbl_add(net,
-					 ip6addrlbl_init_table[i].prefix,
-					 ip6addrlbl_init_table[i].prefixlen,
-					 0,
-					 ip6addrlbl_init_table[i].label, 0);
-		/* XXX: should we free all rules when we catch an error? */
-		if (ret && (!err || err != -ENOMEM))
-			err = ret;
+		err = ip6addrlbl_add(net,
+				     ip6addrlbl_init_table[i].prefix,
+				     ip6addrlbl_init_table[i].prefixlen,
+				     0,
+				     ip6addrlbl_init_table[i].label, 0);
+		if (err)
+			goto err_ip6addrlbl_add;
+	}
+	return 0;
+
+err_ip6addrlbl_add:
+	hlist_for_each_entry_safe(p, n, &net->ipv6.ip6addrlbl_table.head, list) {
+		hlist_del_rcu(&p->list);
+		kfree_rcu(p, rcu);
 	}
 	return err;
 }
-- 
2.17.1

