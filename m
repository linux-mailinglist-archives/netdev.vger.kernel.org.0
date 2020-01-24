Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 351BE148992
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392109AbgAXOf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:35:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:39772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391640AbgAXOT2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:19:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D01C208C4;
        Fri, 24 Jan 2020 14:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875567;
        bh=fLVaVqI/k47RJMZ62O9vSB3wxuhMTT5z2izeJOJkHbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ePA6o7ws9rq99Za+P4N/MKDV12pBcGKISLiHnuN1uEr/97LuNjkK0r5uMRogz+GfJ
         KhOlNRqHBA+0ea+PjwZE65bn1aJ+UO8odMvIUmL99lcS3BMgv5iEfKrfbIMuJVfaJs
         XSHSQIuNEd+JgCsnTtWi6s0KM2bJWLSkbCZNSkuU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        syzbot+91bdd8eece0f6629ec8b@syzkaller.appspotmail.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 060/107] netfilter: arp_tables: init netns pointer in xt_tgdtor_param struct
Date:   Fri, 24 Jan 2020 09:17:30 -0500
Message-Id: <20200124141817.28793-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 212e7f56605ef9688d0846db60c6c6ec06544095 ]

An earlier commit (1b789577f655060d98d20e,
"netfilter: arp_tables: init netns pointer in xt_tgchk_param struct")
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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/arp_tables.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 069f72edb2640..f1f78a742b36a 100644
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
2.20.1

