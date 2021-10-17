Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1429F430CA1
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 00:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344781AbhJQWR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 18:17:57 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53440 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344755AbhJQWRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 18:17:55 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1B29263EE1;
        Mon, 18 Oct 2021 00:14:04 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf-next 08/15] netfilter: arp_tables: allow use of arpt_do_table as hookfn
Date:   Mon, 18 Oct 2021 00:15:15 +0200
Message-Id: <20211017221522.853838-9-pablo@netfilter.org>
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
 include/linux/netfilter_arp/arp_tables.h |  5 ++---
 net/ipv4/netfilter/arp_tables.c          |  7 ++++---
 net/ipv4/netfilter/arptable_filter.c     | 10 +---------
 3 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 4f9a4b3c5892..a40aaf645fa4 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -54,9 +54,8 @@ int arpt_register_table(struct net *net, const struct xt_table *table,
 			const struct nf_hook_ops *ops);
 void arpt_unregister_table(struct net *net, const char *name);
 void arpt_unregister_table_pre_exit(struct net *net, const char *name);
-extern unsigned int arpt_do_table(struct sk_buff *skb,
-				  const struct nf_hook_state *state,
-				  struct xt_table *table);
+extern unsigned int arpt_do_table(void *priv, struct sk_buff *skb,
+				  const struct nf_hook_state *state);
 
 #ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 #include <net/compat.h>
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index c53f14b94356..ffc0cab7cf18 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -179,10 +179,11 @@ struct arpt_entry *arpt_next_entry(const struct arpt_entry *entry)
 	return (void *)entry + entry->next_offset;
 }
 
-unsigned int arpt_do_table(struct sk_buff *skb,
-			   const struct nf_hook_state *state,
-			   struct xt_table *table)
+unsigned int arpt_do_table(void *priv,
+			   struct sk_buff *skb,
+			   const struct nf_hook_state *state)
 {
+	const struct xt_table *table = priv;
 	unsigned int hook = state->hook;
 	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long))));
 	unsigned int verdict = NF_DROP;
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 3de78416ec76..78cd5ee24448 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -26,14 +26,6 @@ static const struct xt_table packet_filter = {
 	.priority	= NF_IP_PRI_FILTER,
 };
 
-/* The work comes in here from netfilter.c */
-static unsigned int
-arptable_filter_hook(void *priv, struct sk_buff *skb,
-		     const struct nf_hook_state *state)
-{
-	return arpt_do_table(skb, state, priv);
-}
-
 static struct nf_hook_ops *arpfilter_ops __read_mostly;
 
 static int arptable_filter_table_init(struct net *net)
@@ -72,7 +64,7 @@ static int __init arptable_filter_init(void)
 	if (ret < 0)
 		return ret;
 
-	arpfilter_ops = xt_hook_ops_alloc(&packet_filter, arptable_filter_hook);
+	arpfilter_ops = xt_hook_ops_alloc(&packet_filter, arpt_do_table);
 	if (IS_ERR(arpfilter_ops)) {
 		xt_unregister_template(&packet_filter);
 		return PTR_ERR(arpfilter_ops);
-- 
2.30.2

