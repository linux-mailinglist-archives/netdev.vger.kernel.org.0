Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE5588984E
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 09:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbfHLHwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 03:52:44 -0400
Received: from mail.windriver.com ([147.11.1.11]:57714 "EHLO
        mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727015AbfHLHwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 03:52:43 -0400
Received: from ALA-HCA.corp.ad.wrs.com ([147.11.189.40])
        by mail.windriver.com (8.15.2/8.15.1) with ESMTPS id x7C7iioS025414
        (version=TLSv1 cipher=AES128-SHA bits=128 verify=FAIL);
        Mon, 12 Aug 2019 00:44:44 -0700 (PDT)
Received: from pek-yxue-d1.wrs.com (128.224.155.90) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.40) with Microsoft SMTP Server id 14.3.468.0; Mon, 12 Aug 2019
 00:44:44 -0700
From:   Ying Xue <ying.xue@windriver.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <jon.maloy@ericsson.com>, <hdanton@sina.com>,
        <tipc-discussion@lists.sourceforge.net>,
        <syzkaller-bugs@googlegroups.com>, <jakub.kicinski@netronome.com>
Subject: [PATCH v2 2/3] tipc: fix memory leak issue
Date:   Mon, 12 Aug 2019 15:32:41 +0800
Message-ID: <1565595162-1383-3-git-send-email-ying.xue@windriver.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565595162-1383-1-git-send-email-ying.xue@windriver.com>
References: <1565595162-1383-1-git-send-email-ying.xue@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot found the following memory leak issue:

[   72.286706][ T7064] kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
BUG: memory leak
unreferenced object 0xffff888122bca200 (size 128):
  comm "syz-executor232", pid 7065, jiffies 4294943817 (age 8.880s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 18 a2 bc 22 81 88 ff ff  ..........."....
  backtrace:
    [<000000005bada299>] kmem_cache_alloc_trace+0x145/0x2c0
    [<00000000e7bcdc9f>] tipc_group_create_member+0x3c/0x190
    [<0000000005f56f40>] tipc_group_add_member+0x34/0x40
    [<0000000044406683>] tipc_nametbl_build_group+0x9b/0xf0
    [<000000009f71e803>] tipc_setsockopt+0x170/0x490
    [<000000007f61cbc2>] __sys_setsockopt+0x10f/0x220
    [<00000000cc630372>] __x64_sys_setsockopt+0x26/0x30
    [<00000000ec30be33>] do_syscall_64+0x76/0x1a0
    [<00000000271be3e6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported-by: syzbot+f95d90c454864b3b5bc9@syzkaller.appspotmail.com
Signed-off-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: Ying Xue <ying.xue@windriver.com>
---
 net/tipc/group.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/tipc/group.c b/net/tipc/group.c
index 5f98d38..cbc540a 100644
--- a/net/tipc/group.c
+++ b/net/tipc/group.c
@@ -273,8 +273,8 @@ static struct tipc_member *tipc_group_find_node(struct tipc_group *grp,
 	return NULL;
 }
 
-static void tipc_group_add_to_tree(struct tipc_group *grp,
-				   struct tipc_member *m)
+struct tipc_member *tipc_group_add_to_tree(struct tipc_group *grp,
+					   struct tipc_member *m)
 {
 	u64 nkey, key = (u64)m->node << 32 | m->port;
 	struct rb_node **n, *parent = NULL;
@@ -282,7 +282,6 @@ static void tipc_group_add_to_tree(struct tipc_group *grp,
 
 	n = &grp->members.rb_node;
 	while (*n) {
-		tmp = container_of(*n, struct tipc_member, tree_node);
 		parent = *n;
 		tmp = container_of(parent, struct tipc_member, tree_node);
 		nkey = (u64)tmp->node << 32 | tmp->port;
@@ -291,17 +290,18 @@ static void tipc_group_add_to_tree(struct tipc_group *grp,
 		else if (key > nkey)
 			n = &(*n)->rb_right;
 		else
-			return;
+			return tmp;
 	}
 	rb_link_node(&m->tree_node, parent, n);
 	rb_insert_color(&m->tree_node, &grp->members);
+	return m;
 }
 
 static struct tipc_member *tipc_group_create_member(struct tipc_group *grp,
 						    u32 node, u32 port,
 						    u32 instance, int state)
 {
-	struct tipc_member *m;
+	struct tipc_member *m, *n;
 
 	m = kzalloc(sizeof(*m), GFP_ATOMIC);
 	if (!m)
@@ -315,10 +315,14 @@ static struct tipc_member *tipc_group_create_member(struct tipc_group *grp,
 	m->instance = instance;
 	m->bc_acked = grp->bc_snd_nxt - 1;
 	grp->member_cnt++;
-	tipc_group_add_to_tree(grp, m);
-	tipc_nlist_add(&grp->dests, m->node);
-	m->state = state;
-	return m;
+	n = tipc_group_add_to_tree(grp, m);
+	if (n == m) {
+		tipc_nlist_add(&grp->dests, m->node);
+		m->state = state;
+	} else {
+		kfree(m);
+	}
+	return n;
 }
 
 void tipc_group_add_member(struct tipc_group *grp, u32 node,
-- 
2.7.4

