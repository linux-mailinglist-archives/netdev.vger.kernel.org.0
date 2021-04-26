Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABF536B7B4
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236335AbhDZRMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:12:19 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51532 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235669AbhDZRLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:11:51 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id BFA1964136;
        Mon, 26 Apr 2021 19:10:32 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 09/22] netfilter: arptables: unregister the tables by name
Date:   Mon, 26 Apr 2021 19:10:43 +0200
Message-Id: <20210426171056.345271-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210426171056.345271-1-pablo@netfilter.org>
References: <20210426171056.345271-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

and again, this time for arptables.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_arp/arp_tables.h |  4 ++--
 net/ipv4/netfilter/arp_tables.c          | 14 ++++++++++----
 net/ipv4/netfilter/arptable_filter.c     |  8 ++------
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 26a13294318c..9ec73dcc8fd6 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -52,8 +52,8 @@ extern void *arpt_alloc_initial_table(const struct xt_table *);
 int arpt_register_table(struct net *net, const struct xt_table *table,
 			const struct arpt_replace *repl,
 			const struct nf_hook_ops *ops, struct xt_table **res);
-void arpt_unregister_table(struct net *net, struct xt_table *table);
-void arpt_unregister_table_pre_exit(struct net *net, struct xt_table *table,
+void arpt_unregister_table(struct net *net, const char *name);
+void arpt_unregister_table_pre_exit(struct net *net, const char *name,
 				    const struct nf_hook_ops *ops);
 extern unsigned int arpt_do_table(struct sk_buff *skb,
 				  const struct nf_hook_state *state,
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index d6d45d820d79..8a16b0dc5271 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1541,16 +1541,22 @@ int arpt_register_table(struct net *net,
 	return ret;
 }
 
-void arpt_unregister_table_pre_exit(struct net *net, struct xt_table *table,
+void arpt_unregister_table_pre_exit(struct net *net, const char *name,
 				    const struct nf_hook_ops *ops)
 {
-	nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
+	struct xt_table *table = xt_find_table(net, NFPROTO_ARP, name);
+
+	if (table)
+		nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
 }
 EXPORT_SYMBOL(arpt_unregister_table_pre_exit);
 
-void arpt_unregister_table(struct net *net, struct xt_table *table)
+void arpt_unregister_table(struct net *net, const char *name)
 {
-	__arpt_unregister_table(net, table);
+	struct xt_table *table = xt_find_table(net, NFPROTO_ARP, name);
+
+	if (table)
+		__arpt_unregister_table(net, table);
 }
 
 /* The built-in targets: standard (NULL) and error. */
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 6c300ba5634e..c121e13dc78c 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -58,16 +58,12 @@ static int __net_init arptable_filter_table_init(struct net *net)
 
 static void __net_exit arptable_filter_net_pre_exit(struct net *net)
 {
-	if (net->ipv4.arptable_filter)
-		arpt_unregister_table_pre_exit(net, net->ipv4.arptable_filter,
-					       arpfilter_ops);
+	arpt_unregister_table_pre_exit(net, "filter", arpfilter_ops);
 }
 
 static void __net_exit arptable_filter_net_exit(struct net *net)
 {
-	if (!net->ipv4.arptable_filter)
-		return;
-	arpt_unregister_table(net, net->ipv4.arptable_filter);
+	arpt_unregister_table(net, "filter");
 	net->ipv4.arptable_filter = NULL;
 }
 
-- 
2.30.2

