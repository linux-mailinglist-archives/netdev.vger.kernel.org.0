Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DABF430C9D
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 00:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344774AbhJQWR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 18:17:56 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53402 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344760AbhJQWRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 18:17:54 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7AC89605E1;
        Mon, 18 Oct 2021 00:14:03 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf-next 07/15] netfilter: iptables: allow use of ipt_do_table as hookfn
Date:   Mon, 18 Oct 2021 00:15:14 +0200
Message-Id: <20211017221522.853838-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211017221522.853838-1-pablo@netfilter.org>
References: <20211017221522.853838-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This is possible now that the xt_table structure is passed in via *priv.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_ipv4/ip_tables.h |  6 +++---
 net/ipv4/netfilter/ip_tables.c           |  7 ++++---
 net/ipv4/netfilter/iptable_filter.c      |  9 +--------
 net/ipv4/netfilter/iptable_mangle.c      |  8 ++++----
 net/ipv4/netfilter/iptable_nat.c         | 15 ++++-----------
 net/ipv4/netfilter/iptable_raw.c         | 10 +---------
 net/ipv4/netfilter/iptable_security.c    |  9 +--------
 7 files changed, 18 insertions(+), 46 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index 8d09bfe850dc..132b0e4a6d4d 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -63,9 +63,9 @@ struct ipt_error {
 }
 
 extern void *ipt_alloc_initial_table(const struct xt_table *);
-extern unsigned int ipt_do_table(struct sk_buff *skb,
-				 const struct nf_hook_state *state,
-				 struct xt_table *table);
+extern unsigned int ipt_do_table(void *priv,
+				 struct sk_buff *skb,
+				 const struct nf_hook_state *state);
 
 #ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 #include <net/compat.h>
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 13acb687c19a..2ed7c58b471a 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -222,10 +222,11 @@ struct ipt_entry *ipt_next_entry(const struct ipt_entry *entry)
 
 /* Returns one of the generic firewall policies, like NF_ACCEPT. */
 unsigned int
-ipt_do_table(struct sk_buff *skb,
-	     const struct nf_hook_state *state,
-	     struct xt_table *table)
+ipt_do_table(void *priv,
+	     struct sk_buff *skb,
+	     const struct nf_hook_state *state)
 {
+	const struct xt_table *table = priv;
 	unsigned int hook = state->hook;
 	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long))));
 	const struct iphdr *ip;
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index 0eb0e2ab9bfc..b9062f4552ac 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -28,13 +28,6 @@ static const struct xt_table packet_filter = {
 	.priority	= NF_IP_PRI_FILTER,
 };
 
-static unsigned int
-iptable_filter_hook(void *priv, struct sk_buff *skb,
-		    const struct nf_hook_state *state)
-{
-	return ipt_do_table(skb, state, priv);
-}
-
 static struct nf_hook_ops *filter_ops __read_mostly;
 
 /* Default to forward because I got too much mail already. */
@@ -90,7 +83,7 @@ static int __init iptable_filter_init(void)
 	if (ret < 0)
 		return ret;
 
-	filter_ops = xt_hook_ops_alloc(&packet_filter, iptable_filter_hook);
+	filter_ops = xt_hook_ops_alloc(&packet_filter, ipt_do_table);
 	if (IS_ERR(filter_ops)) {
 		xt_unregister_template(&packet_filter);
 		return PTR_ERR(filter_ops);
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 40417a3f930b..3abb430af9e6 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -34,7 +34,7 @@ static const struct xt_table packet_mangler = {
 };
 
 static unsigned int
-ipt_mangle_out(struct sk_buff *skb, const struct nf_hook_state *state, void *priv)
+ipt_mangle_out(void *priv, struct sk_buff *skb, const struct nf_hook_state *state)
 {
 	unsigned int ret;
 	const struct iphdr *iph;
@@ -50,7 +50,7 @@ ipt_mangle_out(struct sk_buff *skb, const struct nf_hook_state *state, void *pri
 	daddr = iph->daddr;
 	tos = iph->tos;
 
-	ret = ipt_do_table(skb, state, priv);
+	ret = ipt_do_table(priv, skb, state);
 	/* Reroute for ANY change. */
 	if (ret != NF_DROP && ret != NF_STOLEN) {
 		iph = ip_hdr(skb);
@@ -75,8 +75,8 @@ iptable_mangle_hook(void *priv,
 		     const struct nf_hook_state *state)
 {
 	if (state->hook == NF_INET_LOCAL_OUT)
-		return ipt_mangle_out(skb, state, priv);
-	return ipt_do_table(skb, state, priv);
+		return ipt_mangle_out(priv, skb, state);
+	return ipt_do_table(priv, skb, state);
 }
 
 static struct nf_hook_ops *mangle_ops __read_mostly;
diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
index 45d7e072e6a5..56f6ecc43451 100644
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -29,34 +29,27 @@ static const struct xt_table nf_nat_ipv4_table = {
 	.af		= NFPROTO_IPV4,
 };
 
-static unsigned int iptable_nat_do_chain(void *priv,
-					 struct sk_buff *skb,
-					 const struct nf_hook_state *state)
-{
-	return ipt_do_table(skb, state, priv);
-}
-
 static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
 	{
-		.hook		= iptable_nat_do_chain,
+		.hook		= ipt_do_table,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_PRE_ROUTING,
 		.priority	= NF_IP_PRI_NAT_DST,
 	},
 	{
-		.hook		= iptable_nat_do_chain,
+		.hook		= ipt_do_table,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_POST_ROUTING,
 		.priority	= NF_IP_PRI_NAT_SRC,
 	},
 	{
-		.hook		= iptable_nat_do_chain,
+		.hook		= ipt_do_table,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP_PRI_NAT_DST,
 	},
 	{
-		.hook		= iptable_nat_do_chain,
+		.hook		= ipt_do_table,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP_PRI_NAT_SRC,
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 8265c6765705..ca5e5b21587c 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -32,14 +32,6 @@ static const struct xt_table packet_raw_before_defrag = {
 	.priority = NF_IP_PRI_RAW_BEFORE_DEFRAG,
 };
 
-/* The work comes in here from netfilter.c. */
-static unsigned int
-iptable_raw_hook(void *priv, struct sk_buff *skb,
-		 const struct nf_hook_state *state)
-{
-	return ipt_do_table(skb, state, priv);
-}
-
 static struct nf_hook_ops *rawtable_ops __read_mostly;
 
 static int iptable_raw_table_init(struct net *net)
@@ -90,7 +82,7 @@ static int __init iptable_raw_init(void)
 	if (ret < 0)
 		return ret;
 
-	rawtable_ops = xt_hook_ops_alloc(table, iptable_raw_hook);
+	rawtable_ops = xt_hook_ops_alloc(table, ipt_do_table);
 	if (IS_ERR(rawtable_ops)) {
 		xt_unregister_template(table);
 		return PTR_ERR(rawtable_ops);
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index f519162a2fa5..d885443cb267 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -33,13 +33,6 @@ static const struct xt_table security_table = {
 	.priority	= NF_IP_PRI_SECURITY,
 };
 
-static unsigned int
-iptable_security_hook(void *priv, struct sk_buff *skb,
-		      const struct nf_hook_state *state)
-{
-	return ipt_do_table(skb, state, priv);
-}
-
 static struct nf_hook_ops *sectbl_ops __read_mostly;
 
 static int iptable_security_table_init(struct net *net)
@@ -78,7 +71,7 @@ static int __init iptable_security_init(void)
 	if (ret < 0)
 		return ret;
 
-	sectbl_ops = xt_hook_ops_alloc(&security_table, iptable_security_hook);
+	sectbl_ops = xt_hook_ops_alloc(&security_table, ipt_do_table);
 	if (IS_ERR(sectbl_ops)) {
 		xt_unregister_template(&security_table);
 		return PTR_ERR(sectbl_ops);
-- 
2.30.2

