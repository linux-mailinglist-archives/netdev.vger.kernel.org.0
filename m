Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E2035D326
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 00:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343784AbhDLWb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 18:31:29 -0400
Received: from mail.netfilter.org ([217.70.188.207]:50484 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343750AbhDLWb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 18:31:27 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 56E0663E6A;
        Tue, 13 Apr 2021 00:30:43 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 4/7] netfilter: bridge: add pre_exit hooks for ebtable unregistration
Date:   Tue, 13 Apr 2021 00:30:56 +0200
Message-Id: <20210412223059.20841-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210412223059.20841-1-pablo@netfilter.org>
References: <20210412223059.20841-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Just like ip/ip6/arptables, the hooks have to be removed, then
synchronize_rcu() has to be called to make sure no more packets are being
processed before the ruleset data is released.

Place the hook unregistration in the pre_exit hook, then call the new
ebtables pre_exit function from there.

Years ago, when first netns support got added for netfilter+ebtables,
this used an older (now removed) netfilter hook unregister API, that did
a unconditional synchronize_rcu().

Now that all is done with call_rcu, ebtable_{filter,nat,broute} pernet exit
handlers may free the ebtable ruleset while packets are still in flight.

This can only happens on module removal, not during netns exit.

The new function expects the table name, not the table struct.

This is because upcoming patch set (targeting -next) will remove all
net->xt.{nat,filter,broute}_table instances, this makes it necessary
to avoid external references to those member variables.

The existing APIs will be converted, so follow the upcoming scheme of
passing name + hook type instead.

Fixes: aee12a0a3727e ("ebtables: remove nf_hook_register usage")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_bridge/ebtables.h |  5 ++--
 net/bridge/netfilter/ebtable_broute.c     |  8 +++++-
 net/bridge/netfilter/ebtable_filter.c     |  8 +++++-
 net/bridge/netfilter/ebtable_nat.c        |  8 +++++-
 net/bridge/netfilter/ebtables.c           | 30 ++++++++++++++++++++---
 5 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index 2f5c4e6ecd8a..3a956145a25c 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -110,8 +110,9 @@ extern int ebt_register_table(struct net *net,
 			      const struct ebt_table *table,
 			      const struct nf_hook_ops *ops,
 			      struct ebt_table **res);
-extern void ebt_unregister_table(struct net *net, struct ebt_table *table,
-				 const struct nf_hook_ops *);
+extern void ebt_unregister_table(struct net *net, struct ebt_table *table);
+void ebt_unregister_table_pre_exit(struct net *net, const char *tablename,
+				   const struct nf_hook_ops *ops);
 extern unsigned int ebt_do_table(struct sk_buff *skb,
 				 const struct nf_hook_state *state,
 				 struct ebt_table *table);
diff --git a/net/bridge/netfilter/ebtable_broute.c b/net/bridge/netfilter/ebtable_broute.c
index 66e7af165494..32bc2821027f 100644
--- a/net/bridge/netfilter/ebtable_broute.c
+++ b/net/bridge/netfilter/ebtable_broute.c
@@ -105,14 +105,20 @@ static int __net_init broute_net_init(struct net *net)
 				  &net->xt.broute_table);
 }
 
+static void __net_exit broute_net_pre_exit(struct net *net)
+{
+	ebt_unregister_table_pre_exit(net, "broute", &ebt_ops_broute);
+}
+
 static void __net_exit broute_net_exit(struct net *net)
 {
-	ebt_unregister_table(net, net->xt.broute_table, &ebt_ops_broute);
+	ebt_unregister_table(net, net->xt.broute_table);
 }
 
 static struct pernet_operations broute_net_ops = {
 	.init = broute_net_init,
 	.exit = broute_net_exit,
+	.pre_exit = broute_net_pre_exit,
 };
 
 static int __init ebtable_broute_init(void)
diff --git a/net/bridge/netfilter/ebtable_filter.c b/net/bridge/netfilter/ebtable_filter.c
index 78cb9b21022d..bcf982e12f16 100644
--- a/net/bridge/netfilter/ebtable_filter.c
+++ b/net/bridge/netfilter/ebtable_filter.c
@@ -99,14 +99,20 @@ static int __net_init frame_filter_net_init(struct net *net)
 				  &net->xt.frame_filter);
 }
 
+static void __net_exit frame_filter_net_pre_exit(struct net *net)
+{
+	ebt_unregister_table_pre_exit(net, "filter", ebt_ops_filter);
+}
+
 static void __net_exit frame_filter_net_exit(struct net *net)
 {
-	ebt_unregister_table(net, net->xt.frame_filter, ebt_ops_filter);
+	ebt_unregister_table(net, net->xt.frame_filter);
 }
 
 static struct pernet_operations frame_filter_net_ops = {
 	.init = frame_filter_net_init,
 	.exit = frame_filter_net_exit,
+	.pre_exit = frame_filter_net_pre_exit,
 };
 
 static int __init ebtable_filter_init(void)
diff --git a/net/bridge/netfilter/ebtable_nat.c b/net/bridge/netfilter/ebtable_nat.c
index 0888936ef853..0d092773f816 100644
--- a/net/bridge/netfilter/ebtable_nat.c
+++ b/net/bridge/netfilter/ebtable_nat.c
@@ -99,14 +99,20 @@ static int __net_init frame_nat_net_init(struct net *net)
 				  &net->xt.frame_nat);
 }
 
+static void __net_exit frame_nat_net_pre_exit(struct net *net)
+{
+	ebt_unregister_table_pre_exit(net, "nat", ebt_ops_nat);
+}
+
 static void __net_exit frame_nat_net_exit(struct net *net)
 {
-	ebt_unregister_table(net, net->xt.frame_nat, ebt_ops_nat);
+	ebt_unregister_table(net, net->xt.frame_nat);
 }
 
 static struct pernet_operations frame_nat_net_ops = {
 	.init = frame_nat_net_init,
 	.exit = frame_nat_net_exit,
+	.pre_exit = frame_nat_net_pre_exit,
 };
 
 static int __init ebtable_nat_init(void)
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index ebe33b60efd6..d481ff24a150 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1232,10 +1232,34 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
 	return ret;
 }
 
-void ebt_unregister_table(struct net *net, struct ebt_table *table,
-			  const struct nf_hook_ops *ops)
+static struct ebt_table *__ebt_find_table(struct net *net, const char *name)
+{
+	struct ebt_table *t;
+
+	mutex_lock(&ebt_mutex);
+
+	list_for_each_entry(t, &net->xt.tables[NFPROTO_BRIDGE], list) {
+		if (strcmp(t->name, name) == 0) {
+			mutex_unlock(&ebt_mutex);
+			return t;
+		}
+	}
+
+	mutex_unlock(&ebt_mutex);
+	return NULL;
+}
+
+void ebt_unregister_table_pre_exit(struct net *net, const char *name, const struct nf_hook_ops *ops)
+{
+	struct ebt_table *table = __ebt_find_table(net, name);
+
+	if (table)
+		nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
+}
+EXPORT_SYMBOL(ebt_unregister_table_pre_exit);
+
+void ebt_unregister_table(struct net *net, struct ebt_table *table)
 {
-	nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
 	__ebt_unregister_table(net, table);
 }
 
-- 
2.20.1

