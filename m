Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2D8512AFEB
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 01:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbfL0AdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 19:33:20 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:35180 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726193AbfL0AdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 19:33:20 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ikdZ7-0007YP-Up; Fri, 27 Dec 2019 01:33:18 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     syzbot+d7358a458d8a81aee898@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: arp_tables: init netns pointer in xt_tgchk_param struct
Date:   Fri, 27 Dec 2019 01:33:10 +0100
Message-Id: <20191227003310.16061-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <00000000000057fd27059aa1dfca@google.com>
References: <00000000000057fd27059aa1dfca@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We get crash when the targets checkentry function tries to make
use of the network namespace pointer for arptables.

When the net pointer got added back in 2010, only ip/ip6/ebtables were
changed to initialize it, so arptables has this set to NULL.

This isn't a problem for normal arptables because no existing
arptables target has a checkentry function that makes use of par->net.

However, direct users of the setsockopt interface can provide any
target they want as long as its registered for ARP or UNPSEC protocols.

syzkaller managed to send a semi-valid arptables rule for RATEEST target
which is enough to trigger NULL deref:

kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
RIP: xt_rateest_tg_checkentry+0x11d/0xb40 net/netfilter/xt_RATEEST.c:109
[..]
 xt_check_target+0x283/0x690 net/netfilter/x_tables.c:1019
 check_target net/ipv4/netfilter/arp_tables.c:399 [inline]
 find_check_entry net/ipv4/netfilter/arp_tables.c:422 [inline]
 translate_table+0x1005/0x1d70 net/ipv4/netfilter/arp_tables.c:572
 do_replace net/ipv4/netfilter/arp_tables.c:977 [inline]
 do_arpt_set_ctl+0x310/0x640 net/ipv4/netfilter/arp_tables.c:1456

Fixes: add67461240c1d ("netfilter: add struct net * to target parameters")
Reported-by: syzbot+d7358a458d8a81aee898@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/arp_tables.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 214154b47d56..069f72edb264 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -384,10 +384,11 @@ next:		;
 	return 1;
 }
 
-static inline int check_target(struct arpt_entry *e, const char *name)
+static int check_target(struct arpt_entry *e, struct net *net, const char *name)
 {
 	struct xt_entry_target *t = arpt_get_target(e);
 	struct xt_tgchk_param par = {
+		.net       = net,
 		.table     = name,
 		.entryinfo = e,
 		.target    = t->u.kernel.target,
@@ -399,8 +400,9 @@ static inline int check_target(struct arpt_entry *e, const char *name)
 	return xt_check_target(&par, t->u.target_size - sizeof(*t), 0, false);
 }
 
-static inline int
-find_check_entry(struct arpt_entry *e, const char *name, unsigned int size,
+static int
+find_check_entry(struct arpt_entry *e, struct net *net, const char *name,
+		 unsigned int size,
 		 struct xt_percpu_counter_alloc_state *alloc_state)
 {
 	struct xt_entry_target *t;
@@ -419,7 +421,7 @@ find_check_entry(struct arpt_entry *e, const char *name, unsigned int size,
 	}
 	t->u.kernel.target = target;
 
-	ret = check_target(e, name);
+	ret = check_target(e, net, name);
 	if (ret)
 		goto err;
 	return 0;
@@ -512,7 +514,9 @@ static inline void cleanup_entry(struct arpt_entry *e)
 /* Checks and translates the user-supplied table segment (held in
  * newinfo).
  */
-static int translate_table(struct xt_table_info *newinfo, void *entry0,
+static int translate_table(struct net *net,
+			   struct xt_table_info *newinfo,
+			   void *entry0,
 			   const struct arpt_replace *repl)
 {
 	struct xt_percpu_counter_alloc_state alloc_state = { 0 };
@@ -569,7 +573,7 @@ static int translate_table(struct xt_table_info *newinfo, void *entry0,
 	/* Finally, each sanity check must pass */
 	i = 0;
 	xt_entry_foreach(iter, entry0, newinfo->size) {
-		ret = find_check_entry(iter, repl->name, repl->size,
+		ret = find_check_entry(iter, net, repl->name, repl->size,
 				       &alloc_state);
 		if (ret != 0)
 			break;
@@ -974,7 +978,7 @@ static int do_replace(struct net *net, const void __user *user,
 		goto free_newinfo;
 	}
 
-	ret = translate_table(newinfo, loc_cpu_entry, &tmp);
+	ret = translate_table(net, newinfo, loc_cpu_entry, &tmp);
 	if (ret != 0)
 		goto free_newinfo;
 
@@ -1149,7 +1153,8 @@ compat_copy_entry_from_user(struct compat_arpt_entry *e, void **dstptr,
 	}
 }
 
-static int translate_compat_table(struct xt_table_info **pinfo,
+static int translate_compat_table(struct net *net,
+				  struct xt_table_info **pinfo,
 				  void **pentry0,
 				  const struct compat_arpt_replace *compatr)
 {
@@ -1217,7 +1222,7 @@ static int translate_compat_table(struct xt_table_info **pinfo,
 	repl.num_counters = 0;
 	repl.counters = NULL;
 	repl.size = newinfo->size;
-	ret = translate_table(newinfo, entry1, &repl);
+	ret = translate_table(net, newinfo, entry1, &repl);
 	if (ret)
 		goto free_newinfo;
 
@@ -1270,7 +1275,7 @@ static int compat_do_replace(struct net *net, void __user *user,
 		goto free_newinfo;
 	}
 
-	ret = translate_compat_table(&newinfo, &loc_cpu_entry, &tmp);
+	ret = translate_compat_table(net, &newinfo, &loc_cpu_entry, &tmp);
 	if (ret != 0)
 		goto free_newinfo;
 
@@ -1546,7 +1551,7 @@ int arpt_register_table(struct net *net,
 	loc_cpu_entry = newinfo->entries;
 	memcpy(loc_cpu_entry, repl->entries, repl->size);
 
-	ret = translate_table(newinfo, loc_cpu_entry, repl);
+	ret = translate_table(net, newinfo, loc_cpu_entry, repl);
 	if (ret != 0)
 		goto out_free;
 
-- 
2.24.1

