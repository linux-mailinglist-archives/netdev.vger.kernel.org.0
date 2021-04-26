Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E459D36B7CB
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235456AbhDZRNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:13:04 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51576 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235883AbhDZRL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:11:58 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 704216412C;
        Mon, 26 Apr 2021 19:10:35 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 14/22] netfilter: ip6_tables: pass table pointer via nf_hook_ops
Date:   Mon, 26 Apr 2021 19:10:48 +0200
Message-Id: <20210426171056.345271-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210426171056.345271-1-pablo@netfilter.org>
References: <20210426171056.345271-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Same patch as the ip_tables one: removal of all accesses to ip6_tables
xt_table pointers.  After this patch the struct net xt_table anchors
can be removed.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_ipv6/ip6_tables.h |  5 +--
 net/ipv6/netfilter/ip6_tables.c           | 51 +++++++++++++++--------
 net/ipv6/netfilter/ip6table_filter.c      |  9 ++--
 net/ipv6/netfilter/ip6table_mangle.c      | 14 +++----
 net/ipv6/netfilter/ip6table_nat.c         | 24 ++++++-----
 net/ipv6/netfilter/ip6table_raw.c         |  9 ++--
 net/ipv6/netfilter/ip6table_security.c    |  8 ++--
 7 files changed, 63 insertions(+), 57 deletions(-)

diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 8c07426e18a8..11d0e725fe79 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -26,9 +26,8 @@ extern void *ip6t_alloc_initial_table(const struct xt_table *);
 
 int ip6t_register_table(struct net *net, const struct xt_table *table,
 			const struct ip6t_replace *repl,
-			const struct nf_hook_ops *ops, struct xt_table **res);
-void ip6t_unregister_table_pre_exit(struct net *net, const char *name,
-				    const struct nf_hook_ops *ops);
+			const struct nf_hook_ops *ops);
+void ip6t_unregister_table_pre_exit(struct net *net, const char *name);
 void ip6t_unregister_table_exit(struct net *net, const char *name);
 extern unsigned int ip6t_do_table(struct sk_buff *skb,
 				  const struct nf_hook_state *state,
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 11c80da12ee3..e763716ffa25 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1725,10 +1725,11 @@ static void __ip6t_unregister_table(struct net *net, struct xt_table *table)
 
 int ip6t_register_table(struct net *net, const struct xt_table *table,
 			const struct ip6t_replace *repl,
-			const struct nf_hook_ops *ops,
-			struct xt_table **res)
+			const struct nf_hook_ops *template_ops)
 {
-	int ret;
+	struct nf_hook_ops *ops;
+	unsigned int num_ops;
+	int ret, i;
 	struct xt_table_info *newinfo;
 	struct xt_table_info bootstrap = {0};
 	void *loc_cpu_entry;
@@ -1742,40 +1743,54 @@ int ip6t_register_table(struct net *net, const struct xt_table *table,
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
+	if (!template_ops)
 		return 0;
 
-	ret = nf_register_net_hooks(net, ops, hweight32(table->valid_hooks));
-	if (ret != 0) {
-		__ip6t_unregister_table(net, new_table);
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
+	__ip6t_unregister_table(net, new_table);
 	return ret;
 }
 
-void ip6t_unregister_table_pre_exit(struct net *net, const char *name,
-				    const struct nf_hook_ops *ops)
+void ip6t_unregister_table_pre_exit(struct net *net, const char *name)
 {
 	struct xt_table *table = xt_find_table(net, NFPROTO_IPV6, name);
 
 	if (table)
-		nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
+		nf_unregister_net_hooks(net, table->ops, hweight32(table->valid_hooks));
 }
 
 void ip6t_unregister_table_exit(struct net *net, const char *name)
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index 2bcafa3e2d35..bb784ea7bbd3 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -35,7 +35,7 @@ static unsigned int
 ip6table_filter_hook(void *priv, struct sk_buff *skb,
 		     const struct nf_hook_state *state)
 {
-	return ip6t_do_table(skb, state, state->net->ipv6.ip6table_filter);
+	return ip6t_do_table(skb, state, priv);
 }
 
 static struct nf_hook_ops *filter_ops __read_mostly;
@@ -56,8 +56,7 @@ static int __net_init ip6table_filter_table_init(struct net *net)
 	((struct ip6t_standard *)repl->entries)[1].target.verdict =
 		forward ? -NF_ACCEPT - 1 : -NF_DROP - 1;
 
-	err = ip6t_register_table(net, &packet_filter, repl, filter_ops,
-				  &net->ipv6.ip6table_filter);
+	err = ip6t_register_table(net, &packet_filter, repl, filter_ops);
 	kfree(repl);
 	return err;
 }
@@ -72,14 +71,12 @@ static int __net_init ip6table_filter_net_init(struct net *net)
 
 static void __net_exit ip6table_filter_net_pre_exit(struct net *net)
 {
-	ip6t_unregister_table_pre_exit(net, "filter",
-				       filter_ops);
+	ip6t_unregister_table_pre_exit(net, "filter");
 }
 
 static void __net_exit ip6table_filter_net_exit(struct net *net)
 {
 	ip6t_unregister_table_exit(net, "filter");
-	net->ipv6.ip6table_filter = NULL;
 }
 
 static struct pernet_operations ip6table_filter_net_ops = {
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 14e22022bf41..c76cffd63041 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -32,7 +32,7 @@ static const struct xt_table packet_mangler = {
 };
 
 static unsigned int
-ip6t_mangle_out(struct sk_buff *skb, const struct nf_hook_state *state)
+ip6t_mangle_out(struct sk_buff *skb, const struct nf_hook_state *state, void *priv)
 {
 	unsigned int ret;
 	struct in6_addr saddr, daddr;
@@ -49,7 +49,7 @@ ip6t_mangle_out(struct sk_buff *skb, const struct nf_hook_state *state)
 	/* flowlabel and prio (includes version, which shouldn't change either */
 	flowlabel = *((u_int32_t *)ipv6_hdr(skb));
 
-	ret = ip6t_do_table(skb, state, state->net->ipv6.ip6table_mangle);
+	ret = ip6t_do_table(skb, state, priv);
 
 	if (ret != NF_DROP && ret != NF_STOLEN &&
 	    (!ipv6_addr_equal(&ipv6_hdr(skb)->saddr, &saddr) ||
@@ -71,8 +71,8 @@ ip6table_mangle_hook(void *priv, struct sk_buff *skb,
 		     const struct nf_hook_state *state)
 {
 	if (state->hook == NF_INET_LOCAL_OUT)
-		return ip6t_mangle_out(skb, state);
-	return ip6t_do_table(skb, state, state->net->ipv6.ip6table_mangle);
+		return ip6t_mangle_out(skb, state, priv);
+	return ip6t_do_table(skb, state, priv);
 }
 
 static struct nf_hook_ops *mangle_ops __read_mostly;
@@ -84,21 +84,19 @@ static int __net_init ip6table_mangle_table_init(struct net *net)
 	repl = ip6t_alloc_initial_table(&packet_mangler);
 	if (repl == NULL)
 		return -ENOMEM;
-	ret = ip6t_register_table(net, &packet_mangler, repl, mangle_ops,
-				  &net->ipv6.ip6table_mangle);
+	ret = ip6t_register_table(net, &packet_mangler, repl, mangle_ops);
 	kfree(repl);
 	return ret;
 }
 
 static void __net_exit ip6table_mangle_net_pre_exit(struct net *net)
 {
-	ip6t_unregister_table_pre_exit(net, "mangle", mangle_ops);
+	ip6t_unregister_table_pre_exit(net, "mangle");
 }
 
 static void __net_exit ip6table_mangle_net_exit(struct net *net)
 {
 	ip6t_unregister_table_exit(net, "mangle");
-	net->ipv6.ip6table_mangle = NULL;
 }
 
 static struct pernet_operations ip6table_mangle_net_ops = {
diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index 69b7f9601d03..b0292251e655 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -68,12 +68,19 @@ static const struct nf_hook_ops nf_nat_ipv6_ops[] = {
 	},
 };
 
-static int ip6t_nat_register_lookups(struct net *net, struct xt_table *table)
+static int ip6t_nat_register_lookups(struct net *net)
 {
-	struct nf_hook_ops *ops = kmemdup(nf_nat_ipv6_ops, sizeof(nf_nat_ipv6_ops), GFP_KERNEL);
-	struct ip6table_nat_pernet *xt_nat_net = net_generic(net, ip6table_nat_net_id);
+	struct ip6table_nat_pernet *xt_nat_net;
+	struct nf_hook_ops *ops;
+	struct xt_table *table;
 	int i, ret;
 
+	table = xt_find_table(net, NFPROTO_IPV6, "nat");
+	if (WARN_ON_ONCE(!table))
+		return -ENOENT;
+
+	xt_nat_net = net_generic(net, ip6table_nat_net_id);
+	ops = kmemdup(nf_nat_ipv6_ops, sizeof(nf_nat_ipv6_ops), GFP_KERNEL);
 	if (!ops)
 		return -ENOMEM;
 
@@ -111,25 +118,21 @@ static void ip6t_nat_unregister_lookups(struct net *net)
 static int __net_init ip6table_nat_table_init(struct net *net)
 {
 	struct ip6t_replace *repl;
-	struct xt_table *table;
 	int ret;
 
 	repl = ip6t_alloc_initial_table(&nf_nat_ipv6_table);
 	if (repl == NULL)
 		return -ENOMEM;
 	ret = ip6t_register_table(net, &nf_nat_ipv6_table, repl,
-				  NULL, &table);
+				  NULL);
 	if (ret < 0) {
 		kfree(repl);
 		return ret;
 	}
 
-	ret = ip6t_nat_register_lookups(net, table);
-	if (ret < 0) {
+	ret = ip6t_nat_register_lookups(net);
+	if (ret < 0)
 		ip6t_unregister_table_exit(net, "nat");
-	} else {
-		net->ipv6.ip6table_nat = table;
-	}
 
 	kfree(repl);
 	return ret;
@@ -143,7 +146,6 @@ static void __net_exit ip6table_nat_net_pre_exit(struct net *net)
 static void __net_exit ip6table_nat_net_exit(struct net *net)
 {
 	ip6t_unregister_table_exit(net, "nat");
-	net->ipv6.ip6table_nat = NULL;
 }
 
 static struct pernet_operations ip6table_nat_net_ops = {
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index ae3df59f0350..f63c106c521e 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -40,7 +40,7 @@ static unsigned int
 ip6table_raw_hook(void *priv, struct sk_buff *skb,
 		  const struct nf_hook_state *state)
 {
-	return ip6t_do_table(skb, state, state->net->ipv6.ip6table_raw);
+	return ip6t_do_table(skb, state, priv);
 }
 
 static struct nf_hook_ops *rawtable_ops __read_mostly;
@@ -57,22 +57,19 @@ static int __net_init ip6table_raw_table_init(struct net *net)
 	repl = ip6t_alloc_initial_table(table);
 	if (repl == NULL)
 		return -ENOMEM;
-	ret = ip6t_register_table(net, table, repl, rawtable_ops,
-				  &net->ipv6.ip6table_raw);
+	ret = ip6t_register_table(net, table, repl, rawtable_ops);
 	kfree(repl);
 	return ret;
 }
 
 static void __net_exit ip6table_raw_net_pre_exit(struct net *net)
 {
-	ip6t_unregister_table_pre_exit(net, "raw",
-				       rawtable_ops);
+	ip6t_unregister_table_pre_exit(net, "raw");
 }
 
 static void __net_exit ip6table_raw_net_exit(struct net *net)
 {
 	ip6t_unregister_table_exit(net, "raw");
-	net->ipv6.ip6table_raw = NULL;
 }
 
 static struct pernet_operations ip6table_raw_net_ops = {
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index 83ca632cbf88..8dc335cf450b 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -39,7 +39,7 @@ static unsigned int
 ip6table_security_hook(void *priv, struct sk_buff *skb,
 		       const struct nf_hook_state *state)
 {
-	return ip6t_do_table(skb, state, state->net->ipv6.ip6table_security);
+	return ip6t_do_table(skb, state, priv);
 }
 
 static struct nf_hook_ops *sectbl_ops __read_mostly;
@@ -52,21 +52,19 @@ static int __net_init ip6table_security_table_init(struct net *net)
 	repl = ip6t_alloc_initial_table(&security_table);
 	if (repl == NULL)
 		return -ENOMEM;
-	ret = ip6t_register_table(net, &security_table, repl, sectbl_ops,
-				  &net->ipv6.ip6table_security);
+	ret = ip6t_register_table(net, &security_table, repl, sectbl_ops);
 	kfree(repl);
 	return ret;
 }
 
 static void __net_exit ip6table_security_net_pre_exit(struct net *net)
 {
-	ip6t_unregister_table_pre_exit(net, "security", sectbl_ops);
+	ip6t_unregister_table_pre_exit(net, "security");
 }
 
 static void __net_exit ip6table_security_net_exit(struct net *net)
 {
 	ip6t_unregister_table_exit(net, "security");
-	net->ipv6.ip6table_security = NULL;
 }
 
 static struct pernet_operations ip6table_security_net_ops = {
-- 
2.30.2

