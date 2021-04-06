Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1175E3553C4
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 14:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344214AbhDFMX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 08:23:26 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34440 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343995AbhDFMWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 08:22:06 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 393F663E62;
        Tue,  6 Apr 2021 14:21:38 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 25/28] netfilter: x_tables: move known table lists to net_generic infra
Date:   Tue,  6 Apr 2021 14:21:30 +0200
Message-Id: <20210406122133.1644-26-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210406122133.1644-1-pablo@netfilter.org>
References: <20210406122133.1644-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Will reduce struct net size by 208 bytes.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/x_tables.c | 46 ++++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 6bd31a7a27fc..8e23ef2673e4 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -24,6 +24,7 @@
 #include <linux/audit.h>
 #include <linux/user_namespace.h>
 #include <net/net_namespace.h>
+#include <net/netns/generic.h>
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_arp.h>
@@ -38,6 +39,10 @@ MODULE_DESCRIPTION("{ip,ip6,arp,eb}_tables backend module");
 #define XT_PCPU_BLOCK_SIZE 4096
 #define XT_MAX_TABLE_SIZE	(512 * 1024 * 1024)
 
+struct xt_pernet {
+	struct list_head tables[NFPROTO_NUMPROTO];
+};
+
 struct compat_delta {
 	unsigned int offset; /* offset in kernel */
 	int delta; /* delta in 32bit user land */
@@ -55,7 +60,8 @@ struct xt_af {
 #endif
 };
 
-static struct xt_af *xt;
+static unsigned int xt_pernet_id __read_mostly;
+static struct xt_af *xt __read_mostly;
 
 static const char *const xt_prefix[NFPROTO_NUMPROTO] = {
 	[NFPROTO_UNSPEC] = "x",
@@ -1203,10 +1209,11 @@ EXPORT_SYMBOL(xt_free_table_info);
 struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
 				    const char *name)
 {
+	struct xt_pernet *xt_net = net_generic(net, xt_pernet_id);
 	struct xt_table *t, *found = NULL;
 
 	mutex_lock(&xt[af].mutex);
-	list_for_each_entry(t, &net->xt.tables[af], list)
+	list_for_each_entry(t, &xt_net->tables[af], list)
 		if (strcmp(t->name, name) == 0 && try_module_get(t->me))
 			return t;
 
@@ -1214,7 +1221,8 @@ struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
 		goto out;
 
 	/* Table doesn't exist in this netns, re-try init */
-	list_for_each_entry(t, &init_net.xt.tables[af], list) {
+	xt_net = net_generic(&init_net, xt_pernet_id);
+	list_for_each_entry(t, &xt_net->tables[af], list) {
 		int err;
 
 		if (strcmp(t->name, name))
@@ -1237,8 +1245,9 @@ struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
 	if (!found)
 		goto out;
 
+	xt_net = net_generic(net, xt_pernet_id);
 	/* and once again: */
-	list_for_each_entry(t, &net->xt.tables[af], list)
+	list_for_each_entry(t, &xt_net->tables[af], list)
 		if (strcmp(t->name, name) == 0)
 			return t;
 
@@ -1423,9 +1432,10 @@ struct xt_table *xt_register_table(struct net *net,
 				   struct xt_table_info *bootstrap,
 				   struct xt_table_info *newinfo)
 {
-	int ret;
+	struct xt_pernet *xt_net = net_generic(net, xt_pernet_id);
 	struct xt_table_info *private;
 	struct xt_table *t, *table;
+	int ret;
 
 	/* Don't add one object to multiple lists. */
 	table = kmemdup(input_table, sizeof(struct xt_table), GFP_KERNEL);
@@ -1436,7 +1446,7 @@ struct xt_table *xt_register_table(struct net *net,
 
 	mutex_lock(&xt[table->af].mutex);
 	/* Don't autoload: we'd eat our tail... */
-	list_for_each_entry(t, &net->xt.tables[table->af], list) {
+	list_for_each_entry(t, &xt_net->tables[table->af], list) {
 		if (strcmp(t->name, table->name) == 0) {
 			ret = -EEXIST;
 			goto unlock;
@@ -1455,7 +1465,7 @@ struct xt_table *xt_register_table(struct net *net,
 	/* save number of initial entries */
 	private->initial_entries = private->number;
 
-	list_add(&table->list, &net->xt.tables[table->af]);
+	list_add(&table->list, &xt_net->tables[table->af]);
 	mutex_unlock(&xt[table->af].mutex);
 	return table;
 
@@ -1486,19 +1496,25 @@ EXPORT_SYMBOL_GPL(xt_unregister_table);
 #ifdef CONFIG_PROC_FS
 static void *xt_table_seq_start(struct seq_file *seq, loff_t *pos)
 {
+	u8 af = (unsigned long)PDE_DATA(file_inode(seq->file));
 	struct net *net = seq_file_net(seq);
-	u_int8_t af = (unsigned long)PDE_DATA(file_inode(seq->file));
+	struct xt_pernet *xt_net;
+
+	xt_net = net_generic(net, xt_pernet_id);
 
 	mutex_lock(&xt[af].mutex);
-	return seq_list_start(&net->xt.tables[af], *pos);
+	return seq_list_start(&xt_net->tables[af], *pos);
 }
 
 static void *xt_table_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
+	u8 af = (unsigned long)PDE_DATA(file_inode(seq->file));
 	struct net *net = seq_file_net(seq);
-	u_int8_t af = (unsigned long)PDE_DATA(file_inode(seq->file));
+	struct xt_pernet *xt_net;
+
+	xt_net = net_generic(net, xt_pernet_id);
 
-	return seq_list_next(v, &net->xt.tables[af], pos);
+	return seq_list_next(v, &xt_net->tables[af], pos);
 }
 
 static void xt_table_seq_stop(struct seq_file *seq, void *v)
@@ -1864,24 +1880,28 @@ EXPORT_SYMBOL_GPL(xt_percpu_counter_free);
 
 static int __net_init xt_net_init(struct net *net)
 {
+	struct xt_pernet *xt_net = net_generic(net, xt_pernet_id);
 	int i;
 
 	for (i = 0; i < NFPROTO_NUMPROTO; i++)
-		INIT_LIST_HEAD(&net->xt.tables[i]);
+		INIT_LIST_HEAD(&xt_net->tables[i]);
 	return 0;
 }
 
 static void __net_exit xt_net_exit(struct net *net)
 {
+	struct xt_pernet *xt_net = net_generic(net, xt_pernet_id);
 	int i;
 
 	for (i = 0; i < NFPROTO_NUMPROTO; i++)
-		WARN_ON_ONCE(!list_empty(&net->xt.tables[i]));
+		WARN_ON_ONCE(!list_empty(&xt_net->tables[i]));
 }
 
 static struct pernet_operations xt_net_ops = {
 	.init = xt_net_init,
 	.exit = xt_net_exit,
+	.id   = &xt_pernet_id,
+	.size = sizeof(struct xt_pernet),
 };
 
 static int __init xt_init(void)
-- 
2.30.2

