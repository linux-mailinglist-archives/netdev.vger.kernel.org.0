Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C0C36B7C1
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236654AbhDZRMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:12:52 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51574 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235857AbhDZRL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:11:58 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7718A6412D;
        Mon, 26 Apr 2021 19:10:34 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 12/22] netfilter: ip_tables: pass table pointer via nf_hook_ops
Date:   Mon, 26 Apr 2021 19:10:46 +0200
Message-Id: <20210426171056.345271-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210426171056.345271-1-pablo@netfilter.org>
References: <20210426171056.345271-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

iptable_x modules rely on 'struct net' to contain a pointer to the
table that should be evaluated.

In order to remove these pointers from struct net, pass them via
the 'priv' pointer in a similar fashion as nf_tables passes the
rule data.

To do that, duplicate the nf_hook_info array passed in from the
iptable_x modules, update the ops->priv pointers of the copy to
refer to the table and then change the hookfn implementations to
just pass the 'priv' argument to the traverser.

After this patch, the xt_table pointers can already be removed
from struct net.

However, changes to struct net result in re-compile of the entire
network stack, so do the removal after arptables and ip6tables
have been converted as well.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/x_tables.h       |  3 ++
 include/linux/netfilter_ipv4/ip_tables.h |  6 +--
 net/ipv4/netfilter/ip_tables.c           | 53 ++++++++++++++++--------
 net/ipv4/netfilter/iptable_filter.c      |  8 ++--
 net/ipv4/netfilter/iptable_mangle.c      | 14 +++----
 net/ipv4/netfilter/iptable_nat.c         | 26 ++++++------
 net/ipv4/netfilter/iptable_raw.c         |  8 ++--
 net/ipv4/netfilter/iptable_security.c    |  8 ++--
 net/netfilter/x_tables.c                 |  1 +
 9 files changed, 71 insertions(+), 56 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index b2eec7de5280..a52cc22f806a 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -229,6 +229,9 @@ struct xt_table {
 	/* Man behind the curtain... */
 	struct xt_table_info *private;
 
+	/* hook ops that register the table with the netfilter core */
+	struct nf_hook_ops *ops;
+
 	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
 	struct module *me;
 
diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index 73bcf7f261d2..0fdab3246ef5 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -24,11 +24,9 @@
 
 int ipt_register_table(struct net *net, const struct xt_table *table,
 		       const struct ipt_replace *repl,
-		       const struct nf_hook_ops *ops, struct xt_table **res);
-
-void ipt_unregister_table_pre_exit(struct net *net, const char *name,
-				   const struct nf_hook_ops *ops);
+		       const struct nf_hook_ops *ops);
 
+void ipt_unregister_table_pre_exit(struct net *net, const char *name);
 void ipt_unregister_table_exit(struct net *net, const char *name);
 
 /* Standard entry. */
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 0b859ec2d3f8..d6caaed5dd45 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1716,9 +1716,11 @@ static void __ipt_unregister_table(struct net *net, struct xt_table *table)
 
 int ipt_register_table(struct net *net, const struct xt_table *table,
 		       const struct ipt_replace *repl,
-		       const struct nf_hook_ops *ops, struct xt_table **res)
+		       const struct nf_hook_ops *template_ops)
 {
-	int ret;
+	struct nf_hook_ops *ops;
+	unsigned int num_ops;
+	int ret, i;
 	struct xt_table_info *newinfo;
 	struct xt_table_info bootstrap = {0};
 	void *loc_cpu_entry;
@@ -1732,40 +1734,57 @@ int ipt_register_table(struct net *net, const struct xt_table *table,
 	memcpy(loc_cpu_entry, repl->entries, repl->size);
 
 	ret = translate_table(net, newinfo, loc_cpu_entry, repl);
-	if (ret != 0)
-		goto out_free;
+	if (ret != 0) {
+		xt_free_table_info(newinfo);
+		return ret;
+	}
 
 	new_table = xt_register_table(net, table, &bootstrap, newinfo);
 	if (IS_ERR(new_table)) {
-		ret = PTR_ERR(new_table);
-		goto out_free;
+		xt_free_table_info(newinfo);
+		return PTR_ERR(new_table);
 	}
 
-	/* set res now, will see skbs right after nf_register_net_hooks */
-	WRITE_ONCE(*res, new_table);
-	if (!ops)
+	/* No template? No need to do anything. This is used by 'nat' table, it registers
+	 * with the nat core instead of the netfilter core.
+	 */
+	if (!template_ops)
 		return 0;
 
-	ret = nf_register_net_hooks(net, ops, hweight32(table->valid_hooks));
-	if (ret != 0) {
-		__ipt_unregister_table(net, new_table);
-		*res = NULL;
+	num_ops = hweight32(table->valid_hooks);
+	if (num_ops == 0) {
+		ret = -EINVAL;
+		goto out_free;
 	}
 
+	ops = kmemdup(template_ops, sizeof(*ops) * num_ops, GFP_KERNEL);
+	if (!ops) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	for (i = 0; i < num_ops; i++)
+		ops[i].priv = new_table;
+
+	new_table->ops = ops;
+
+	ret = nf_register_net_hooks(net, ops, num_ops);
+	if (ret != 0)
+		goto out_free;
+
 	return ret;
 
 out_free:
-	xt_free_table_info(newinfo);
+	__ipt_unregister_table(net, new_table);
 	return ret;
 }
 
-void ipt_unregister_table_pre_exit(struct net *net, const char *name,
-				   const struct nf_hook_ops *ops)
+void ipt_unregister_table_pre_exit(struct net *net, const char *name)
 {
 	struct xt_table *table = xt_find_table(net, NFPROTO_IPV4, name);
 
 	if (table)
-		nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
+		nf_unregister_net_hooks(net, table->ops, hweight32(table->valid_hooks));
 }
 
 void ipt_unregister_table_exit(struct net *net, const char *name)
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index 84573fa78d1e..8272df7c6ad5 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -34,7 +34,7 @@ static unsigned int
 iptable_filter_hook(void *priv, struct sk_buff *skb,
 		    const struct nf_hook_state *state)
 {
-	return ipt_do_table(skb, state, state->net->ipv4.iptable_filter);
+	return ipt_do_table(skb, state, priv);
 }
 
 static struct nf_hook_ops *filter_ops __read_mostly;
@@ -55,8 +55,7 @@ static int __net_init iptable_filter_table_init(struct net *net)
 	((struct ipt_standard *)repl->entries)[1].target.verdict =
 		forward ? -NF_ACCEPT - 1 : -NF_DROP - 1;
 
-	err = ipt_register_table(net, &packet_filter, repl, filter_ops,
-				 &net->ipv4.iptable_filter);
+	err = ipt_register_table(net, &packet_filter, repl, filter_ops);
 	kfree(repl);
 	return err;
 }
@@ -71,13 +70,12 @@ static int __net_init iptable_filter_net_init(struct net *net)
 
 static void __net_exit iptable_filter_net_pre_exit(struct net *net)
 {
-	ipt_unregister_table_pre_exit(net, "filter", filter_ops);
+	ipt_unregister_table_pre_exit(net, "filter");
 }
 
 static void __net_exit iptable_filter_net_exit(struct net *net)
 {
 	ipt_unregister_table_exit(net, "filter");
-	net->ipv4.iptable_filter = NULL;
 }
 
 static struct pernet_operations iptable_filter_net_ops = {
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 98e9e9053d85..2abc3836f391 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -37,7 +37,7 @@ static const struct xt_table packet_mangler = {
 };
 
 static unsigned int
-ipt_mangle_out(struct sk_buff *skb, const struct nf_hook_state *state)
+ipt_mangle_out(struct sk_buff *skb, const struct nf_hook_state *state, void *priv)
 {
 	unsigned int ret;
 	const struct iphdr *iph;
@@ -53,7 +53,7 @@ ipt_mangle_out(struct sk_buff *skb, const struct nf_hook_state *state)
 	daddr = iph->daddr;
 	tos = iph->tos;
 
-	ret = ipt_do_table(skb, state, state->net->ipv4.iptable_mangle);
+	ret = ipt_do_table(skb, state, priv);
 	/* Reroute for ANY change. */
 	if (ret != NF_DROP && ret != NF_STOLEN) {
 		iph = ip_hdr(skb);
@@ -78,8 +78,8 @@ iptable_mangle_hook(void *priv,
 		     const struct nf_hook_state *state)
 {
 	if (state->hook == NF_INET_LOCAL_OUT)
-		return ipt_mangle_out(skb, state);
-	return ipt_do_table(skb, state, state->net->ipv4.iptable_mangle);
+		return ipt_mangle_out(skb, state, priv);
+	return ipt_do_table(skb, state, priv);
 }
 
 static struct nf_hook_ops *mangle_ops __read_mostly;
@@ -91,21 +91,19 @@ static int __net_init iptable_mangle_table_init(struct net *net)
 	repl = ipt_alloc_initial_table(&packet_mangler);
 	if (repl == NULL)
 		return -ENOMEM;
-	ret = ipt_register_table(net, &packet_mangler, repl, mangle_ops,
-				 &net->ipv4.iptable_mangle);
+	ret = ipt_register_table(net, &packet_mangler, repl, mangle_ops);
 	kfree(repl);
 	return ret;
 }
 
 static void __net_exit iptable_mangle_net_pre_exit(struct net *net)
 {
-	ipt_unregister_table_pre_exit(net, "mangle", mangle_ops);
+	ipt_unregister_table_pre_exit(net, "mangle");
 }
 
 static void __net_exit iptable_mangle_net_exit(struct net *net)
 {
 	ipt_unregister_table_exit(net, "mangle");
-	net->ipv4.iptable_mangle = NULL;
 }
 
 static struct pernet_operations iptable_mangle_net_ops = {
diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
index dfa9dc63a7b5..a9913842ef18 100644
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -66,12 +66,19 @@ static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
 	},
 };
 
-static int ipt_nat_register_lookups(struct net *net, struct xt_table *table)
+static int ipt_nat_register_lookups(struct net *net)
 {
-	struct nf_hook_ops *ops = kmemdup(nf_nat_ipv4_ops, sizeof(nf_nat_ipv4_ops), GFP_KERNEL);
-	struct iptable_nat_pernet *xt_nat_net = net_generic(net, iptable_nat_net_id);
+	struct iptable_nat_pernet *xt_nat_net;
+	struct nf_hook_ops *ops;
+	struct xt_table *table;
 	int i, ret;
 
+	xt_nat_net = net_generic(net, iptable_nat_net_id);
+	table = xt_find_table(net, NFPROTO_IPV4, "nat");
+	if (WARN_ON_ONCE(!table))
+		return -ENOENT;
+
+	ops = kmemdup(nf_nat_ipv4_ops, sizeof(nf_nat_ipv4_ops), GFP_KERNEL);
 	if (!ops)
 		return -ENOMEM;
 
@@ -109,25 +116,21 @@ static void ipt_nat_unregister_lookups(struct net *net)
 static int __net_init iptable_nat_table_init(struct net *net)
 {
 	struct ipt_replace *repl;
-	struct xt_table *table;
 	int ret;
 
 	repl = ipt_alloc_initial_table(&nf_nat_ipv4_table);
 	if (repl == NULL)
 		return -ENOMEM;
-	ret = ipt_register_table(net, &nf_nat_ipv4_table, repl,
-				 NULL, &table);
+
+	ret = ipt_register_table(net, &nf_nat_ipv4_table, repl, NULL);
 	if (ret < 0) {
 		kfree(repl);
 		return ret;
 	}
 
-	ret = ipt_nat_register_lookups(net, table);
-	if (ret < 0) {
+	ret = ipt_nat_register_lookups(net);
+	if (ret < 0)
 		ipt_unregister_table_exit(net, "nat");
-	} else {
-		net->ipv4.nat_table = table;
-	}
 
 	kfree(repl);
 	return ret;
@@ -141,7 +144,6 @@ static void __net_exit iptable_nat_net_pre_exit(struct net *net)
 static void __net_exit iptable_nat_net_exit(struct net *net)
 {
 	ipt_unregister_table_exit(net, "nat");
-	net->ipv4.nat_table = NULL;
 }
 
 static struct pernet_operations iptable_nat_net_ops = {
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 18776f5a4055..ceef397c1f5f 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -41,7 +41,7 @@ static unsigned int
 iptable_raw_hook(void *priv, struct sk_buff *skb,
 		 const struct nf_hook_state *state)
 {
-	return ipt_do_table(skb, state, state->net->ipv4.iptable_raw);
+	return ipt_do_table(skb, state, priv);
 }
 
 static struct nf_hook_ops *rawtable_ops __read_mostly;
@@ -58,21 +58,19 @@ static int __net_init iptable_raw_table_init(struct net *net)
 	repl = ipt_alloc_initial_table(table);
 	if (repl == NULL)
 		return -ENOMEM;
-	ret = ipt_register_table(net, table, repl, rawtable_ops,
-				 &net->ipv4.iptable_raw);
+	ret = ipt_register_table(net, table, repl, rawtable_ops);
 	kfree(repl);
 	return ret;
 }
 
 static void __net_exit iptable_raw_net_pre_exit(struct net *net)
 {
-	ipt_unregister_table_pre_exit(net, "raw", rawtable_ops);
+	ipt_unregister_table_pre_exit(net, "raw");
 }
 
 static void __net_exit iptable_raw_net_exit(struct net *net)
 {
 	ipt_unregister_table_exit(net, "raw");
-	net->ipv4.iptable_raw = NULL;
 }
 
 static struct pernet_operations iptable_raw_net_ops = {
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index 3df92fb394c5..77973f5fd8f6 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -40,7 +40,7 @@ static unsigned int
 iptable_security_hook(void *priv, struct sk_buff *skb,
 		      const struct nf_hook_state *state)
 {
-	return ipt_do_table(skb, state, state->net->ipv4.iptable_security);
+	return ipt_do_table(skb, state, priv);
 }
 
 static struct nf_hook_ops *sectbl_ops __read_mostly;
@@ -53,21 +53,19 @@ static int __net_init iptable_security_table_init(struct net *net)
 	repl = ipt_alloc_initial_table(&security_table);
 	if (repl == NULL)
 		return -ENOMEM;
-	ret = ipt_register_table(net, &security_table, repl, sectbl_ops,
-				 &net->ipv4.iptable_security);
+	ret = ipt_register_table(net, &security_table, repl, sectbl_ops);
 	kfree(repl);
 	return ret;
 }
 
 static void __net_exit iptable_security_net_pre_exit(struct net *net)
 {
-	ipt_unregister_table_pre_exit(net, "security", sectbl_ops);
+	ipt_unregister_table_pre_exit(net, "security");
 }
 
 static void __net_exit iptable_security_net_exit(struct net *net)
 {
 	ipt_unregister_table_exit(net, "security");
-	net->ipv4.iptable_security = NULL;
 }
 
 static struct pernet_operations iptable_security_net_ops = {
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 1caba9507228..ef37deff8405 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1498,6 +1498,7 @@ void *xt_unregister_table(struct xt_table *table)
 	mutex_unlock(&xt[table->af].mutex);
 	audit_log_nfcfg(table->name, table->af, private->number,
 			AUDIT_XT_OP_UNREGISTER, GFP_KERNEL);
+	kfree(table->ops);
 	kfree(table);
 
 	return private;
-- 
2.30.2

