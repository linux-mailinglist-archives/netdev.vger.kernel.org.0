Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA85A430CA6
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 00:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344786AbhJQWSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 18:18:01 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53450 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344766AbhJQWR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 18:17:56 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id ADB2163F19;
        Mon, 18 Oct 2021 00:14:04 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf-next 09/15] netfilter: ip6tables: allow use of ip6t_do_table as hookfn
Date:   Mon, 18 Oct 2021 00:15:16 +0200
Message-Id: <20211017221522.853838-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211017221522.853838-1-pablo@netfilter.org>
References: <20211017221522.853838-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This is possible now that the xt_table structure is passed via *priv.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_ipv6/ip6_tables.h |  5 ++---
 net/ipv6/netfilter/ip6_tables.c           |  6 +++---
 net/ipv6/netfilter/ip6table_filter.c      | 10 +---------
 net/ipv6/netfilter/ip6table_mangle.c      |  8 ++++----
 net/ipv6/netfilter/ip6table_nat.c         | 15 ++++-----------
 net/ipv6/netfilter/ip6table_raw.c         | 10 +---------
 net/ipv6/netfilter/ip6table_security.c    |  9 +--------
 7 files changed, 16 insertions(+), 47 deletions(-)

diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 79e73fd7d965..8b8885a73c76 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -29,9 +29,8 @@ int ip6t_register_table(struct net *net, const struct xt_table *table,
 			const struct nf_hook_ops *ops);
 void ip6t_unregister_table_pre_exit(struct net *net, const char *name);
 void ip6t_unregister_table_exit(struct net *net, const char *name);
-extern unsigned int ip6t_do_table(struct sk_buff *skb,
-				  const struct nf_hook_state *state,
-				  struct xt_table *table);
+extern unsigned int ip6t_do_table(void *priv, struct sk_buff *skb,
+				  const struct nf_hook_state *state);
 
 #ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 #include <net/compat.h>
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index a579ea14a69b..2d816277f2c5 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -247,10 +247,10 @@ ip6t_next_entry(const struct ip6t_entry *entry)
 
 /* Returns one of the generic firewall policies, like NF_ACCEPT. */
 unsigned int
-ip6t_do_table(struct sk_buff *skb,
-	      const struct nf_hook_state *state,
-	      struct xt_table *table)
+ip6t_do_table(void *priv, struct sk_buff *skb,
+	      const struct nf_hook_state *state)
 {
+	const struct xt_table *table = priv;
 	unsigned int hook = state->hook;
 	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long))));
 	/* Initializing verdict to NF_DROP keeps gcc happy. */
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index 727ee8097012..df785ebda0ca 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -27,14 +27,6 @@ static const struct xt_table packet_filter = {
 	.priority	= NF_IP6_PRI_FILTER,
 };
 
-/* The work comes in here from netfilter.c. */
-static unsigned int
-ip6table_filter_hook(void *priv, struct sk_buff *skb,
-		     const struct nf_hook_state *state)
-{
-	return ip6t_do_table(skb, state, priv);
-}
-
 static struct nf_hook_ops *filter_ops __read_mostly;
 
 /* Default to forward because I got too much mail already. */
@@ -90,7 +82,7 @@ static int __init ip6table_filter_init(void)
 	if (ret < 0)
 		return ret;
 
-	filter_ops = xt_hook_ops_alloc(&packet_filter, ip6table_filter_hook);
+	filter_ops = xt_hook_ops_alloc(&packet_filter, ip6t_do_table);
 	if (IS_ERR(filter_ops)) {
 		xt_unregister_template(&packet_filter);
 		return PTR_ERR(filter_ops);
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 9b518ce37d6a..a88b2ce4a3cb 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -29,7 +29,7 @@ static const struct xt_table packet_mangler = {
 };
 
 static unsigned int
-ip6t_mangle_out(struct sk_buff *skb, const struct nf_hook_state *state, void *priv)
+ip6t_mangle_out(void *priv, struct sk_buff *skb, const struct nf_hook_state *state)
 {
 	unsigned int ret;
 	struct in6_addr saddr, daddr;
@@ -46,7 +46,7 @@ ip6t_mangle_out(struct sk_buff *skb, const struct nf_hook_state *state, void *pr
 	/* flowlabel and prio (includes version, which shouldn't change either */
 	flowlabel = *((u_int32_t *)ipv6_hdr(skb));
 
-	ret = ip6t_do_table(skb, state, priv);
+	ret = ip6t_do_table(priv, skb, state);
 
 	if (ret != NF_DROP && ret != NF_STOLEN &&
 	    (!ipv6_addr_equal(&ipv6_hdr(skb)->saddr, &saddr) ||
@@ -68,8 +68,8 @@ ip6table_mangle_hook(void *priv, struct sk_buff *skb,
 		     const struct nf_hook_state *state)
 {
 	if (state->hook == NF_INET_LOCAL_OUT)
-		return ip6t_mangle_out(skb, state, priv);
-	return ip6t_do_table(skb, state, priv);
+		return ip6t_mangle_out(priv, skb, state);
+	return ip6t_do_table(priv, skb, state);
 }
 
 static struct nf_hook_ops *mangle_ops __read_mostly;
diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index 921c1723a01e..bf3cb3a13600 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -31,34 +31,27 @@ static const struct xt_table nf_nat_ipv6_table = {
 	.af		= NFPROTO_IPV6,
 };
 
-static unsigned int ip6table_nat_do_chain(void *priv,
-					  struct sk_buff *skb,
-					  const struct nf_hook_state *state)
-{
-	return ip6t_do_table(skb, state, priv);
-}
-
 static const struct nf_hook_ops nf_nat_ipv6_ops[] = {
 	{
-		.hook		= ip6table_nat_do_chain,
+		.hook		= ip6t_do_table,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_PRE_ROUTING,
 		.priority	= NF_IP6_PRI_NAT_DST,
 	},
 	{
-		.hook		= ip6table_nat_do_chain,
+		.hook		= ip6t_do_table,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_POST_ROUTING,
 		.priority	= NF_IP6_PRI_NAT_SRC,
 	},
 	{
-		.hook		= ip6table_nat_do_chain,
+		.hook		= ip6t_do_table,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP6_PRI_NAT_DST,
 	},
 	{
-		.hook		= ip6table_nat_do_chain,
+		.hook		= ip6t_do_table,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP6_PRI_NAT_SRC,
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index 4f2a04af71d3..08861d5d1f4d 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -31,14 +31,6 @@ static const struct xt_table packet_raw_before_defrag = {
 	.priority = NF_IP6_PRI_RAW_BEFORE_DEFRAG,
 };
 
-/* The work comes in here from netfilter.c. */
-static unsigned int
-ip6table_raw_hook(void *priv, struct sk_buff *skb,
-		  const struct nf_hook_state *state)
-{
-	return ip6t_do_table(skb, state, priv);
-}
-
 static struct nf_hook_ops *rawtable_ops __read_mostly;
 
 static int ip6table_raw_table_init(struct net *net)
@@ -88,7 +80,7 @@ static int __init ip6table_raw_init(void)
 		return ret;
 
 	/* Register hooks */
-	rawtable_ops = xt_hook_ops_alloc(table, ip6table_raw_hook);
+	rawtable_ops = xt_hook_ops_alloc(table, ip6t_do_table);
 	if (IS_ERR(rawtable_ops)) {
 		xt_unregister_template(table);
 		return PTR_ERR(rawtable_ops);
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index 931674034d8b..4df14a9bae78 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -32,13 +32,6 @@ static const struct xt_table security_table = {
 	.priority	= NF_IP6_PRI_SECURITY,
 };
 
-static unsigned int
-ip6table_security_hook(void *priv, struct sk_buff *skb,
-		       const struct nf_hook_state *state)
-{
-	return ip6t_do_table(skb, state, priv);
-}
-
 static struct nf_hook_ops *sectbl_ops __read_mostly;
 
 static int ip6table_security_table_init(struct net *net)
@@ -77,7 +70,7 @@ static int __init ip6table_security_init(void)
 	if (ret < 0)
 		return ret;
 
-	sectbl_ops = xt_hook_ops_alloc(&security_table, ip6table_security_hook);
+	sectbl_ops = xt_hook_ops_alloc(&security_table, ip6t_do_table);
 	if (IS_ERR(sectbl_ops)) {
 		xt_unregister_template(&security_table);
 		return PTR_ERR(sectbl_ops);
-- 
2.30.2

