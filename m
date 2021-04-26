Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B406836B7AB
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235871AbhDZRL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:11:57 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51508 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235565AbhDZRLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:11:50 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id CA32C64130;
        Mon, 26 Apr 2021 19:10:30 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 05/22] netfilter: x_tables: remove ipt_unregister_table
Date:   Mon, 26 Apr 2021 19:10:39 +0200
Message-Id: <20210426171056.345271-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210426171056.345271-1-pablo@netfilter.org>
References: <20210426171056.345271-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Its the same function as ipt_unregister_table_exit.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_ipv4/ip_tables.h  | 3 ---
 include/linux/netfilter_ipv6/ip6_tables.h | 2 --
 net/ipv4/netfilter/ip_tables.c            | 9 ---------
 net/ipv4/netfilter/iptable_nat.c          | 2 +-
 net/ipv6/netfilter/ip6_tables.c           | 9 ---------
 net/ipv6/netfilter/ip6table_nat.c         | 2 +-
 6 files changed, 2 insertions(+), 25 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index c4676d6feeff..9f440eb6cf6c 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -31,9 +31,6 @@ void ipt_unregister_table_pre_exit(struct net *net, struct xt_table *table,
 
 void ipt_unregister_table_exit(struct net *net, struct xt_table *table);
 
-void ipt_unregister_table(struct net *net, struct xt_table *table,
-			  const struct nf_hook_ops *ops);
-
 /* Standard entry. */
 struct ipt_standard {
 	struct ipt_entry entry;
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 1547d5f9ae06..b88a27ce61b0 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -27,8 +27,6 @@ extern void *ip6t_alloc_initial_table(const struct xt_table *);
 int ip6t_register_table(struct net *net, const struct xt_table *table,
 			const struct ip6t_replace *repl,
 			const struct nf_hook_ops *ops, struct xt_table **res);
-void ip6t_unregister_table(struct net *net, struct xt_table *table,
-			   const struct nf_hook_ops *ops);
 void ip6t_unregister_table_pre_exit(struct net *net, struct xt_table *table,
 				    const struct nf_hook_ops *ops);
 void ip6t_unregister_table_exit(struct net *net, struct xt_table *table);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index f77ea0dbe656..2fa7f28b88e3 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1770,14 +1770,6 @@ void ipt_unregister_table_exit(struct net *net, struct xt_table *table)
 	__ipt_unregister_table(net, table);
 }
 
-void ipt_unregister_table(struct net *net, struct xt_table *table,
-			  const struct nf_hook_ops *ops)
-{
-	if (ops)
-		ipt_unregister_table_pre_exit(net, table, ops);
-	__ipt_unregister_table(net, table);
-}
-
 /* Returns 1 if the type and code is matched by the range, 0 otherwise */
 static inline bool
 icmp_type_code_match(u_int8_t test_type, u_int8_t min_code, u_int8_t max_code,
@@ -1924,7 +1916,6 @@ static void __exit ip_tables_fini(void)
 }
 
 EXPORT_SYMBOL(ipt_register_table);
-EXPORT_SYMBOL(ipt_unregister_table);
 EXPORT_SYMBOL(ipt_unregister_table_pre_exit);
 EXPORT_SYMBOL(ipt_unregister_table_exit);
 EXPORT_SYMBOL(ipt_do_table);
diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
index b0143b109f25..a89c1b9f94c2 100644
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -105,7 +105,7 @@ static int __net_init iptable_nat_table_init(struct net *net)
 
 	ret = ipt_nat_register_lookups(net);
 	if (ret < 0) {
-		ipt_unregister_table(net, net->ipv4.nat_table, NULL);
+		ipt_unregister_table_exit(net, net->ipv4.nat_table);
 		net->ipv4.nat_table = NULL;
 	}
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index eb2b5404806c..e605c28cfed5 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1780,14 +1780,6 @@ void ip6t_unregister_table_exit(struct net *net, struct xt_table *table)
 	__ip6t_unregister_table(net, table);
 }
 
-void ip6t_unregister_table(struct net *net, struct xt_table *table,
-			   const struct nf_hook_ops *ops)
-{
-	if (ops)
-		ip6t_unregister_table_pre_exit(net, table, ops);
-	__ip6t_unregister_table(net, table);
-}
-
 /* Returns 1 if the type and code is matched by the range, 0 otherwise */
 static inline bool
 icmp6_type_code_match(u_int8_t test_type, u_int8_t min_code, u_int8_t max_code,
@@ -1935,7 +1927,6 @@ static void __exit ip6_tables_fini(void)
 }
 
 EXPORT_SYMBOL(ip6t_register_table);
-EXPORT_SYMBOL(ip6t_unregister_table);
 EXPORT_SYMBOL(ip6t_unregister_table_pre_exit);
 EXPORT_SYMBOL(ip6t_unregister_table_exit);
 EXPORT_SYMBOL(ip6t_do_table);
diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index 0a23265e3caa..4cef1b405074 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -107,7 +107,7 @@ static int __net_init ip6table_nat_table_init(struct net *net)
 
 	ret = ip6t_nat_register_lookups(net);
 	if (ret < 0) {
-		ip6t_unregister_table(net, net->ipv6.ip6table_nat, NULL);
+		ip6t_unregister_table_exit(net, net->ipv6.ip6table_nat);
 		net->ipv6.ip6table_nat = NULL;
 	}
 	kfree(repl);
-- 
2.30.2

