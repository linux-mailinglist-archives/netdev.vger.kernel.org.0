Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A7B36B7C5
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236678AbhDZRMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:12:55 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51572 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235850AbhDZRL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:11:58 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id F0ABF6413D;
        Mon, 26 Apr 2021 19:10:34 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 13/22] netfilter: arp_tables: pass table pointer via nf_hook_ops
Date:   Mon, 26 Apr 2021 19:10:47 +0200
Message-Id: <20210426171056.345271-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210426171056.345271-1-pablo@netfilter.org>
References: <20210426171056.345271-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Same change as previous patch.  Only difference:
no need to handle NULL template_ops parameter, the only caller
(arptable_filter) always passes non-NULL argument.

This removes all remaining accesses to net->ipv4.arptable_filter.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_arp/arp_tables.h |  2 +-
 net/ipv4/netfilter/arp_tables.c          | 43 ++++++++++++++++--------
 net/ipv4/netfilter/arptable_filter.c     |  6 ++--
 3 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 9ec73dcc8fd6..a0474b4e7782 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -51,7 +51,7 @@ struct arpt_error {
 extern void *arpt_alloc_initial_table(const struct xt_table *);
 int arpt_register_table(struct net *net, const struct xt_table *table,
 			const struct arpt_replace *repl,
-			const struct nf_hook_ops *ops, struct xt_table **res);
+			const struct nf_hook_ops *ops);
 void arpt_unregister_table(struct net *net, const char *name);
 void arpt_unregister_table_pre_exit(struct net *net, const char *name,
 				    const struct nf_hook_ops *ops);
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 8a16b0dc5271..b1bb6a7e2dd7 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1499,10 +1499,11 @@ static void __arpt_unregister_table(struct net *net, struct xt_table *table)
 int arpt_register_table(struct net *net,
 			const struct xt_table *table,
 			const struct arpt_replace *repl,
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
@@ -1516,28 +1517,42 @@ int arpt_register_table(struct net *net,
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
+	num_ops = hweight32(table->valid_hooks);
+	if (num_ops == 0) {
+		ret = -EINVAL;
+		goto out_free;
+	}
 
-	ret = nf_register_net_hooks(net, ops, hweight32(table->valid_hooks));
-	if (ret != 0) {
-		__arpt_unregister_table(net, new_table);
-		*res = NULL;
+	ops = kmemdup(template_ops, sizeof(*ops) * num_ops, GFP_KERNEL);
+	if (!ops) {
+		ret = -ENOMEM;
+		goto out_free;
 	}
 
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
+	__arpt_unregister_table(net, new_table);
 	return ret;
 }
 
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 924f096a6d89..b8f45e9bbec8 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -34,7 +34,7 @@ static unsigned int
 arptable_filter_hook(void *priv, struct sk_buff *skb,
 		     const struct nf_hook_state *state)
 {
-	return arpt_do_table(skb, state, state->net->ipv4.arptable_filter);
+	return arpt_do_table(skb, state, priv);
 }
 
 static struct nf_hook_ops *arpfilter_ops __read_mostly;
@@ -47,8 +47,7 @@ static int __net_init arptable_filter_table_init(struct net *net)
 	repl = arpt_alloc_initial_table(&packet_filter);
 	if (repl == NULL)
 		return -ENOMEM;
-	err = arpt_register_table(net, &packet_filter, repl, arpfilter_ops,
-				  &net->ipv4.arptable_filter);
+	err = arpt_register_table(net, &packet_filter, repl, arpfilter_ops);
 	kfree(repl);
 	return err;
 }
@@ -61,7 +60,6 @@ static void __net_exit arptable_filter_net_pre_exit(struct net *net)
 static void __net_exit arptable_filter_net_exit(struct net *net)
 {
 	arpt_unregister_table(net, "filter");
-	net->ipv4.arptable_filter = NULL;
 }
 
 static struct pernet_operations arptable_filter_net_ops = {
-- 
2.30.2

