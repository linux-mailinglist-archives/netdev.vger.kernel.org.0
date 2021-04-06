Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070B13553C0
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 14:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344100AbhDFMXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 08:23:13 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34438 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343961AbhDFMWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 08:22:05 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3E21563E34;
        Tue,  6 Apr 2021 14:21:37 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 23/28] netfilter: ebtables: use net_generic infra
Date:   Tue,  6 Apr 2021 14:21:28 +0200
Message-Id: <20210406122133.1644-24-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210406122133.1644-1-pablo@netfilter.org>
References: <20210406122133.1644-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

ebtables currently uses net->xt.tables[BRIDGE], but upcoming
patch will move net->xt.tables away from struct net.

To avoid exposing x_tables internals to ebtables, use a private list
instead.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/ebtables.c | 39 ++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 5 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index ebe33b60efd6..11625d05bbbc 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -24,6 +24,7 @@
 #include <linux/cpumask.h>
 #include <linux/audit.h>
 #include <net/sock.h>
+#include <net/netns/generic.h>
 /* needed for logical [in,out]-dev filtering */
 #include "../br_private.h"
 
@@ -39,8 +40,11 @@
 #define COUNTER_BASE(c, n, cpu) ((struct ebt_counter *)(((char *)c) + \
 				 COUNTER_OFFSET(n) * cpu))
 
+struct ebt_pernet {
+	struct list_head tables;
+};
 
-
+static unsigned int ebt_pernet_id __read_mostly;
 static DEFINE_MUTEX(ebt_mutex);
 
 #ifdef CONFIG_COMPAT
@@ -336,7 +340,9 @@ static inline struct ebt_table *
 find_table_lock(struct net *net, const char *name, int *error,
 		struct mutex *mutex)
 {
-	return find_inlist_lock(&net->xt.tables[NFPROTO_BRIDGE], name,
+	struct ebt_pernet *ebt_net = net_generic(net, ebt_pernet_id);
+
+	return find_inlist_lock(&ebt_net->tables, name,
 				"ebtable_", error, mutex);
 }
 
@@ -1136,6 +1142,7 @@ static void __ebt_unregister_table(struct net *net, struct ebt_table *table)
 int ebt_register_table(struct net *net, const struct ebt_table *input_table,
 		       const struct nf_hook_ops *ops, struct ebt_table **res)
 {
+	struct ebt_pernet *ebt_net = net_generic(net, ebt_pernet_id);
 	struct ebt_table_info *newinfo;
 	struct ebt_table *t, *table;
 	struct ebt_replace_kernel *repl;
@@ -1194,7 +1201,7 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
 	table->private = newinfo;
 	rwlock_init(&table->lock);
 	mutex_lock(&ebt_mutex);
-	list_for_each_entry(t, &net->xt.tables[NFPROTO_BRIDGE], list) {
+	list_for_each_entry(t, &ebt_net->tables, list) {
 		if (strcmp(t->name, table->name) == 0) {
 			ret = -EEXIST;
 			goto free_unlock;
@@ -1206,7 +1213,7 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
 		ret = -ENOENT;
 		goto free_unlock;
 	}
-	list_add(&table->list, &net->xt.tables[NFPROTO_BRIDGE]);
+	list_add(&table->list, &ebt_net->tables);
 	mutex_unlock(&ebt_mutex);
 
 	WRITE_ONCE(*res, table);
@@ -2412,6 +2419,20 @@ static struct nf_sockopt_ops ebt_sockopts = {
 	.owner		= THIS_MODULE,
 };
 
+static int __net_init ebt_pernet_init(struct net *net)
+{
+	struct ebt_pernet *ebt_net = net_generic(net, ebt_pernet_id);
+
+	INIT_LIST_HEAD(&ebt_net->tables);
+	return 0;
+}
+
+static struct pernet_operations ebt_net_ops = {
+	.init = ebt_pernet_init,
+	.id   = &ebt_pernet_id,
+	.size = sizeof(struct ebt_pernet),
+};
+
 static int __init ebtables_init(void)
 {
 	int ret;
@@ -2425,13 +2446,21 @@ static int __init ebtables_init(void)
 		return ret;
 	}
 
+	ret = register_pernet_subsys(&ebt_net_ops);
+	if (ret < 0) {
+		nf_unregister_sockopt(&ebt_sockopts);
+		xt_unregister_target(&ebt_standard_target);
+		return ret;
+	}
+
 	return 0;
 }
 
-static void __exit ebtables_fini(void)
+static void ebtables_fini(void)
 {
 	nf_unregister_sockopt(&ebt_sockopts);
 	xt_unregister_target(&ebt_standard_target);
+	unregister_pernet_subsys(&ebt_net_ops);
 }
 
 EXPORT_SYMBOL(ebt_register_table);
-- 
2.30.2

