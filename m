Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72A0F2BC32A
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 03:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgKVCcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 21:32:14 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7664 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726544AbgKVCcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 21:32:13 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CdvS72x0Xz15PqB;
        Sun, 22 Nov 2020 10:31:51 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Sun, 22 Nov 2020
 10:32:07 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] ipv6: addrlabel: fix possible memory leak in ip6addrlbl_net_init
Date:   Sun, 22 Nov 2020 10:34:56 +0800
Message-ID: <20201122023456.71100-1-wanghai38@huawei.com>
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
 net/ipv6/addrlabel.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/addrlabel.c b/net/ipv6/addrlabel.c
index 642fc6ac13d2..637e323a0224 100644
--- a/net/ipv6/addrlabel.c
+++ b/net/ipv6/addrlabel.c
@@ -306,6 +306,8 @@ static int ip6addrlbl_del(struct net *net,
 /* add default label */
 static int __net_init ip6addrlbl_net_init(struct net *net)
 {
+	struct ip6addrlbl_entry *p = NULL;
+	struct hlist_node *n;
 	int err = 0;
 	int i;
 
@@ -320,9 +322,17 @@ static int __net_init ip6addrlbl_net_init(struct net *net)
 					 ip6addrlbl_init_table[i].prefixlen,
 					 0,
 					 ip6addrlbl_init_table[i].label, 0);
-		/* XXX: should we free all rules when we catch an error? */
-		if (ret && (!err || err != -ENOMEM))
+		if (ret && (!err || err != -ENOMEM)) {
 			err = ret;
+			goto err_ip6addrlbl_add;
+		}
+	}
+	return err;
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

