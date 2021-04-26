Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAFD136B7A8
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235673AbhDZRLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:11:51 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51496 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235534AbhDZRLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:11:49 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 46D976412E;
        Mon, 26 Apr 2021 19:10:30 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 04/22] netfilter: ebtables: remove the 3 ebtables pointers from struct net
Date:   Mon, 26 Apr 2021 19:10:38 +0200
Message-Id: <20210426171056.345271-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210426171056.345271-1-pablo@netfilter.org>
References: <20210426171056.345271-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

ebtables stores the table internal data (what gets passed to the
ebt_do_table() interpreter) in struct net.

nftables keeps the internal interpreter format in pernet lists
and passes it via the netfilter core infrastructure (priv pointer).

Do the same for ebtables: the nf_hook_ops are duplicated via kmemdup,
then the ops->priv pointer is set to the table that is being registered.

After that, the netfilter core passes this table info to the hookfn.

This allows to remove the pointers from struct net.

Same pattern can be applied to ip/ip6/arptables.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_bridge/ebtables.h |  9 +++--
 include/net/netns/x_tables.h              |  8 -----
 net/bridge/netfilter/ebtable_broute.c     | 10 +++---
 net/bridge/netfilter/ebtable_filter.c     | 26 +++++---------
 net/bridge/netfilter/ebtable_nat.c        | 27 +++++----------
 net/bridge/netfilter/ebtables.c           | 42 +++++++++++++++++------
 6 files changed, 58 insertions(+), 64 deletions(-)

diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index 3a956145a25c..a8178253ce53 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -100,6 +100,7 @@ struct ebt_table {
 	   unsigned int valid_hooks);
 	/* the data used by the kernel */
 	struct ebt_table_info *private;
+	struct nf_hook_ops *ops;
 	struct module *me;
 };
 
@@ -108,11 +109,9 @@ struct ebt_table {
 
 extern int ebt_register_table(struct net *net,
 			      const struct ebt_table *table,
-			      const struct nf_hook_ops *ops,
-			      struct ebt_table **res);
-extern void ebt_unregister_table(struct net *net, struct ebt_table *table);
-void ebt_unregister_table_pre_exit(struct net *net, const char *tablename,
-				   const struct nf_hook_ops *ops);
+			      const struct nf_hook_ops *ops);
+extern void ebt_unregister_table(struct net *net, const char *tablename);
+void ebt_unregister_table_pre_exit(struct net *net, const char *tablename);
 extern unsigned int ebt_do_table(struct sk_buff *skb,
 				 const struct nf_hook_state *state,
 				 struct ebt_table *table);
diff --git a/include/net/netns/x_tables.h b/include/net/netns/x_tables.h
index 83c8ea2e87a6..d02316ec2906 100644
--- a/include/net/netns/x_tables.h
+++ b/include/net/netns/x_tables.h
@@ -5,16 +5,8 @@
 #include <linux/list.h>
 #include <linux/netfilter_defs.h>
 
-struct ebt_table;
-
 struct netns_xt {
 	bool notrack_deprecated_warning;
 	bool clusterip_deprecated_warning;
-#if defined(CONFIG_BRIDGE_NF_EBTABLES) || \
-    defined(CONFIG_BRIDGE_NF_EBTABLES_MODULE)
-	struct ebt_table *broute_table;
-	struct ebt_table *frame_filter;
-	struct ebt_table *frame_nat;
-#endif
 };
 #endif
diff --git a/net/bridge/netfilter/ebtable_broute.c b/net/bridge/netfilter/ebtable_broute.c
index 32bc2821027f..020b1487ee0c 100644
--- a/net/bridge/netfilter/ebtable_broute.c
+++ b/net/bridge/netfilter/ebtable_broute.c
@@ -66,8 +66,7 @@ static unsigned int ebt_broute(void *priv, struct sk_buff *skb,
 			   NFPROTO_BRIDGE, s->in, NULL, NULL,
 			   s->net, NULL);
 
-	ret = ebt_do_table(skb, &state, state.net->xt.broute_table);
-
+	ret = ebt_do_table(skb, &state, priv);
 	if (ret != NF_DROP)
 		return ret;
 
@@ -101,18 +100,17 @@ static const struct nf_hook_ops ebt_ops_broute = {
 
 static int __net_init broute_net_init(struct net *net)
 {
-	return ebt_register_table(net, &broute_table, &ebt_ops_broute,
-				  &net->xt.broute_table);
+	return ebt_register_table(net, &broute_table, &ebt_ops_broute);
 }
 
 static void __net_exit broute_net_pre_exit(struct net *net)
 {
-	ebt_unregister_table_pre_exit(net, "broute", &ebt_ops_broute);
+	ebt_unregister_table_pre_exit(net, "broute");
 }
 
 static void __net_exit broute_net_exit(struct net *net)
 {
-	ebt_unregister_table(net, net->xt.broute_table);
+	ebt_unregister_table(net, "broute");
 }
 
 static struct pernet_operations broute_net_ops = {
diff --git a/net/bridge/netfilter/ebtable_filter.c b/net/bridge/netfilter/ebtable_filter.c
index bcf982e12f16..8ec0b3736803 100644
--- a/net/bridge/netfilter/ebtable_filter.c
+++ b/net/bridge/netfilter/ebtable_filter.c
@@ -59,34 +59,27 @@ static const struct ebt_table frame_filter = {
 };
 
 static unsigned int
-ebt_in_hook(void *priv, struct sk_buff *skb,
-	    const struct nf_hook_state *state)
+ebt_filter_hook(void *priv, struct sk_buff *skb,
+		const struct nf_hook_state *state)
 {
-	return ebt_do_table(skb, state, state->net->xt.frame_filter);
-}
-
-static unsigned int
-ebt_out_hook(void *priv, struct sk_buff *skb,
-	     const struct nf_hook_state *state)
-{
-	return ebt_do_table(skb, state, state->net->xt.frame_filter);
+	return ebt_do_table(skb, state, priv);
 }
 
 static const struct nf_hook_ops ebt_ops_filter[] = {
 	{
-		.hook		= ebt_in_hook,
+		.hook		= ebt_filter_hook,
 		.pf		= NFPROTO_BRIDGE,
 		.hooknum	= NF_BR_LOCAL_IN,
 		.priority	= NF_BR_PRI_FILTER_BRIDGED,
 	},
 	{
-		.hook		= ebt_in_hook,
+		.hook		= ebt_filter_hook,
 		.pf		= NFPROTO_BRIDGE,
 		.hooknum	= NF_BR_FORWARD,
 		.priority	= NF_BR_PRI_FILTER_BRIDGED,
 	},
 	{
-		.hook		= ebt_out_hook,
+		.hook		= ebt_filter_hook,
 		.pf		= NFPROTO_BRIDGE,
 		.hooknum	= NF_BR_LOCAL_OUT,
 		.priority	= NF_BR_PRI_FILTER_OTHER,
@@ -95,18 +88,17 @@ static const struct nf_hook_ops ebt_ops_filter[] = {
 
 static int __net_init frame_filter_net_init(struct net *net)
 {
-	return ebt_register_table(net, &frame_filter, ebt_ops_filter,
-				  &net->xt.frame_filter);
+	return ebt_register_table(net, &frame_filter, ebt_ops_filter);
 }
 
 static void __net_exit frame_filter_net_pre_exit(struct net *net)
 {
-	ebt_unregister_table_pre_exit(net, "filter", ebt_ops_filter);
+	ebt_unregister_table_pre_exit(net, "filter");
 }
 
 static void __net_exit frame_filter_net_exit(struct net *net)
 {
-	ebt_unregister_table(net, net->xt.frame_filter);
+	ebt_unregister_table(net, "filter");
 }
 
 static struct pernet_operations frame_filter_net_ops = {
diff --git a/net/bridge/netfilter/ebtable_nat.c b/net/bridge/netfilter/ebtable_nat.c
index 0d092773f816..7c8a1064a531 100644
--- a/net/bridge/netfilter/ebtable_nat.c
+++ b/net/bridge/netfilter/ebtable_nat.c
@@ -58,35 +58,27 @@ static const struct ebt_table frame_nat = {
 	.me		= THIS_MODULE,
 };
 
-static unsigned int
-ebt_nat_in(void *priv, struct sk_buff *skb,
-	   const struct nf_hook_state *state)
+static unsigned int ebt_nat_hook(void *priv, struct sk_buff *skb,
+				 const struct nf_hook_state *state)
 {
-	return ebt_do_table(skb, state, state->net->xt.frame_nat);
-}
-
-static unsigned int
-ebt_nat_out(void *priv, struct sk_buff *skb,
-	    const struct nf_hook_state *state)
-{
-	return ebt_do_table(skb, state, state->net->xt.frame_nat);
+	return ebt_do_table(skb, state, priv);
 }
 
 static const struct nf_hook_ops ebt_ops_nat[] = {
 	{
-		.hook		= ebt_nat_out,
+		.hook		= ebt_nat_hook,
 		.pf		= NFPROTO_BRIDGE,
 		.hooknum	= NF_BR_LOCAL_OUT,
 		.priority	= NF_BR_PRI_NAT_DST_OTHER,
 	},
 	{
-		.hook		= ebt_nat_out,
+		.hook		= ebt_nat_hook,
 		.pf		= NFPROTO_BRIDGE,
 		.hooknum	= NF_BR_POST_ROUTING,
 		.priority	= NF_BR_PRI_NAT_SRC,
 	},
 	{
-		.hook		= ebt_nat_in,
+		.hook		= ebt_nat_hook,
 		.pf		= NFPROTO_BRIDGE,
 		.hooknum	= NF_BR_PRE_ROUTING,
 		.priority	= NF_BR_PRI_NAT_DST_BRIDGED,
@@ -95,18 +87,17 @@ static const struct nf_hook_ops ebt_ops_nat[] = {
 
 static int __net_init frame_nat_net_init(struct net *net)
 {
-	return ebt_register_table(net, &frame_nat, ebt_ops_nat,
-				  &net->xt.frame_nat);
+	return ebt_register_table(net, &frame_nat, ebt_ops_nat);
 }
 
 static void __net_exit frame_nat_net_pre_exit(struct net *net)
 {
-	ebt_unregister_table_pre_exit(net, "nat", ebt_ops_nat);
+	ebt_unregister_table_pre_exit(net, "nat");
 }
 
 static void __net_exit frame_nat_net_exit(struct net *net)
 {
-	ebt_unregister_table(net, net->xt.frame_nat);
+	ebt_unregister_table(net, "nat");
 }
 
 static struct pernet_operations frame_nat_net_ops = {
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 96d789c8d1c7..a04596bb2a6e 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1136,15 +1136,18 @@ static void __ebt_unregister_table(struct net *net, struct ebt_table *table)
 	vfree(table->private->entries);
 	ebt_free_table_info(table->private);
 	vfree(table->private);
+	kfree(table->ops);
 	kfree(table);
 }
 
 int ebt_register_table(struct net *net, const struct ebt_table *input_table,
-		       const struct nf_hook_ops *ops, struct ebt_table **res)
+		       const struct nf_hook_ops *template_ops)
 {
 	struct ebt_pernet *ebt_net = net_generic(net, ebt_pernet_id);
 	struct ebt_table_info *newinfo;
 	struct ebt_table *t, *table;
+	struct nf_hook_ops *ops;
+	unsigned int num_ops;
 	struct ebt_replace_kernel *repl;
 	int ret, i, countersize;
 	void *p;
@@ -1213,15 +1216,31 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
 		ret = -ENOENT;
 		goto free_unlock;
 	}
+
+	num_ops = hweight32(table->valid_hooks);
+	if (num_ops == 0) {
+		ret = -EINVAL;
+		goto free_unlock;
+	}
+
+	ops = kmemdup(template_ops, sizeof(*ops) * num_ops, GFP_KERNEL);
+	if (!ops) {
+		ret = -ENOMEM;
+		if (newinfo->nentries)
+			module_put(table->me);
+		goto free_unlock;
+	}
+
+	for (i = 0; i < num_ops; i++)
+		ops[i].priv = table;
+
 	list_add(&table->list, &ebt_net->tables);
 	mutex_unlock(&ebt_mutex);
 
-	WRITE_ONCE(*res, table);
-	ret = nf_register_net_hooks(net, ops, hweight32(table->valid_hooks));
-	if (ret) {
+	table->ops = ops;
+	ret = nf_register_net_hooks(net, ops, num_ops);
+	if (ret)
 		__ebt_unregister_table(net, table);
-		*res = NULL;
-	}
 
 	audit_log_nfcfg(repl->name, AF_BRIDGE, repl->nentries,
 			AUDIT_XT_OP_REGISTER, GFP_KERNEL);
@@ -1257,18 +1276,21 @@ static struct ebt_table *__ebt_find_table(struct net *net, const char *name)
 	return NULL;
 }
 
-void ebt_unregister_table_pre_exit(struct net *net, const char *name, const struct nf_hook_ops *ops)
+void ebt_unregister_table_pre_exit(struct net *net, const char *name)
 {
 	struct ebt_table *table = __ebt_find_table(net, name);
 
 	if (table)
-		nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
+		nf_unregister_net_hooks(net, table->ops, hweight32(table->valid_hooks));
 }
 EXPORT_SYMBOL(ebt_unregister_table_pre_exit);
 
-void ebt_unregister_table(struct net *net, struct ebt_table *table)
+void ebt_unregister_table(struct net *net, const char *name)
 {
-	__ebt_unregister_table(net, table);
+	struct ebt_table *table = __ebt_find_table(net, name);
+
+	if (table)
+		__ebt_unregister_table(net, table);
 }
 
 /* userspace just supplied us with counters */
-- 
2.30.2

