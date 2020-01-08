Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36086134FDF
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 00:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbgAHXRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 18:17:24 -0500
Received: from correo.us.es ([193.147.175.20]:43150 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727159AbgAHXRX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 18:17:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 067D5FF9AE
        for <netdev@vger.kernel.org>; Thu,  9 Jan 2020 00:17:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EC6BDDA716
        for <netdev@vger.kernel.org>; Thu,  9 Jan 2020 00:17:20 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E1C88DA713; Thu,  9 Jan 2020 00:17:20 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ACE9ADA701;
        Thu,  9 Jan 2020 00:17:18 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 09 Jan 2020 00:17:18 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 86526426CCB9;
        Thu,  9 Jan 2020 00:17:18 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 1/9] netfilter: arp_tables: init netns pointer in xt_tgchk_param struct
Date:   Thu,  9 Jan 2020 00:17:05 +0100
Message-Id: <20200108231713.100458-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200108231713.100458-1-pablo@netfilter.org>
References: <20200108231713.100458-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

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
Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.11.0

