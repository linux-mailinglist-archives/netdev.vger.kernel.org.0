Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 450A21383C6
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 23:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731531AbgAKWUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 17:20:07 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:38680 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731486AbgAKWUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 17:20:06 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1iqP6y-0004fv-H5; Sat, 11 Jan 2020 23:20:04 +0100
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel@vger.kernel.org
Cc:     netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Florian Westphal <fw@strlen.de>,
        syzbot+91bdd8eece0f6629ec8b@syzkaller.appspotmail.com
Subject: [PATCH nf] netfilter: arp_tables: init netns pointer in xt_tgdtor_param struct
Date:   Sat, 11 Jan 2020 23:19:53 +0100
Message-Id: <20200111221953.17759-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <000000000000af1c5b059be111e5@google.com>
References: <000000000000af1c5b059be111e5@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An earlier commit (1b789577f655060d98d20e,
"netfilter: arp_tables: init netns pointer in xt_tgchk_param struct"
fixed missing net initialization for arptables, but turns out it was
incomplete.  We can get a very similar struct net NULL deref during
error unwinding:

general protection fault: 0000 [#1] PREEMPT SMP KASAN
RIP: 0010:xt_rateest_put+0xa1/0x440 net/netfilter/xt_RATEEST.c:77
 xt_rateest_tg_destroy+0x72/0xa0 net/netfilter/xt_RATEEST.c:175
 cleanup_entry net/ipv4/netfilter/arp_tables.c:509 [inline]
 translate_table+0x11f4/0x1d80 net/ipv4/netfilter/arp_tables.c:587
 do_replace net/ipv4/netfilter/arp_tables.c:981 [inline]
 do_arpt_set_ctl+0x317/0x650 net/ipv4/netfilter/arp_tables.c:1461

Also init the netns pointer in xt_tgdtor_param struct.

Fixes: add67461240c1d ("netfilter: add struct net * to target parameters")
Reported-by: syzbot+91bdd8eece0f6629ec8b@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/arp_tables.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 069f72edb264..f1f78a742b36 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -496,12 +496,13 @@ static inline int check_entry_size_and_hooks(struct arpt_entry *e,
 	return 0;
 }
 
-static inline void cleanup_entry(struct arpt_entry *e)
+static void cleanup_entry(struct arpt_entry *e, struct net *net)
 {
 	struct xt_tgdtor_param par;
 	struct xt_entry_target *t;
 
 	t = arpt_get_target(e);
+	par.net      = net;
 	par.target   = t->u.kernel.target;
 	par.targinfo = t->data;
 	par.family   = NFPROTO_ARP;
@@ -584,7 +585,7 @@ static int translate_table(struct net *net,
 		xt_entry_foreach(iter, entry0, newinfo->size) {
 			if (i-- == 0)
 				break;
-			cleanup_entry(iter);
+			cleanup_entry(iter, net);
 		}
 		return ret;
 	}
@@ -927,7 +928,7 @@ static int __do_replace(struct net *net, const char *name,
 	/* Decrease module usage counts and free resource */
 	loc_cpu_old_entry = oldinfo->entries;
 	xt_entry_foreach(iter, loc_cpu_old_entry, oldinfo->size)
-		cleanup_entry(iter);
+		cleanup_entry(iter, net);
 
 	xt_free_table_info(oldinfo);
 	if (copy_to_user(counters_ptr, counters,
@@ -990,7 +991,7 @@ static int do_replace(struct net *net, const void __user *user,
 
  free_newinfo_untrans:
 	xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
-		cleanup_entry(iter);
+		cleanup_entry(iter, net);
  free_newinfo:
 	xt_free_table_info(newinfo);
 	return ret;
@@ -1287,7 +1288,7 @@ static int compat_do_replace(struct net *net, void __user *user,
 
  free_newinfo_untrans:
 	xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
-		cleanup_entry(iter);
+		cleanup_entry(iter, net);
  free_newinfo:
 	xt_free_table_info(newinfo);
 	return ret;
@@ -1514,7 +1515,7 @@ static int do_arpt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len
 	return ret;
 }
 
-static void __arpt_unregister_table(struct xt_table *table)
+static void __arpt_unregister_table(struct net *net, struct xt_table *table)
 {
 	struct xt_table_info *private;
 	void *loc_cpu_entry;
@@ -1526,7 +1527,7 @@ static void __arpt_unregister_table(struct xt_table *table)
 	/* Decrease module usage counts and free resources */
 	loc_cpu_entry = private->entries;
 	xt_entry_foreach(iter, loc_cpu_entry, private->size)
-		cleanup_entry(iter);
+		cleanup_entry(iter, net);
 	if (private->number > private->initial_entries)
 		module_put(table_owner);
 	xt_free_table_info(private);
@@ -1566,7 +1567,7 @@ int arpt_register_table(struct net *net,
 
 	ret = nf_register_net_hooks(net, ops, hweight32(table->valid_hooks));
 	if (ret != 0) {
-		__arpt_unregister_table(new_table);
+		__arpt_unregister_table(net, new_table);
 		*res = NULL;
 	}
 
@@ -1581,7 +1582,7 @@ void arpt_unregister_table(struct net *net, struct xt_table *table,
 			   const struct nf_hook_ops *ops)
 {
 	nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
-	__arpt_unregister_table(table);
+	__arpt_unregister_table(net, table);
 }
 
 /* The built-in targets: standard (NULL) and error. */
-- 
2.24.1

