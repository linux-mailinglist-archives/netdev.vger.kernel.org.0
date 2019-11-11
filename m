Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66B26F836E
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 00:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfKKXaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 18:30:08 -0500
Received: from correo.us.es ([193.147.175.20]:40976 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726903AbfKKXaI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 18:30:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EBF261C43A1
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:30:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DDED1BAACC
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:30:03 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D558AD1929; Tue, 12 Nov 2019 00:30:03 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BC0D5DA840;
        Tue, 12 Nov 2019 00:30:01 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 12 Nov 2019 00:30:01 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5947D42EF4E0;
        Tue, 12 Nov 2019 00:30:01 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, paulb@mellanox.com,
        ozsh@mellanox.com, majd@mellanox.com, saeedm@mellanox.com
Subject: [PATCH net-next 1/6] netfilter: nf_flow_table: move conntrack object to struct flow_offload
Date:   Tue, 12 Nov 2019 00:29:51 +0100
Message-Id: <20191111232956.24898-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191111232956.24898-1-pablo@netfilter.org>
References: <20191111232956.24898-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify this code by storing the pointer to conntrack object in the
flow_offload structure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h |  1 +
 net/netfilter/nf_flow_table_core.c    | 35 +++++++++++------------------------
 2 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 158514281a75..88c8cd248213 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -72,6 +72,7 @@ struct flow_offload_tuple_rhash {
 
 struct flow_offload {
 	struct flow_offload_tuple_rhash		tuplehash[FLOW_OFFLOAD_DIR_MAX];
+	struct nf_conn				*ct;
 	u32					flags;
 	union {
 		/* Your private driver data here. */
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 128245efe84a..aca40ccbcceb 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -16,7 +16,6 @@
 
 struct flow_offload_entry {
 	struct flow_offload	flow;
-	struct nf_conn		*ct;
 	struct rcu_head		rcu_head;
 };
 
@@ -79,7 +78,7 @@ flow_offload_alloc(struct nf_conn *ct, struct nf_flow_route *route)
 	if (!dst_hold_safe(route->tuple[FLOW_OFFLOAD_DIR_REPLY].dst))
 		goto err_dst_cache_reply;
 
-	entry->ct = ct;
+	flow->ct = ct;
 
 	flow_offload_fill_dir(flow, ct, route, FLOW_OFFLOAD_DIR_ORIGINAL);
 	flow_offload_fill_dir(flow, ct, route, FLOW_OFFLOAD_DIR_REPLY);
@@ -158,8 +157,8 @@ void flow_offload_free(struct flow_offload *flow)
 	dst_release(flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_cache);
 	e = container_of(flow, struct flow_offload_entry, flow);
 	if (flow->flags & FLOW_OFFLOAD_DYING)
-		nf_ct_delete(e->ct, 0, 0);
-	nf_ct_put(e->ct);
+		nf_ct_delete(flow->ct, 0, 0);
+	nf_ct_put(flow->ct);
 	kfree_rcu(e, rcu_head);
 }
 EXPORT_SYMBOL_GPL(flow_offload_free);
@@ -232,8 +231,6 @@ static inline bool nf_flow_has_expired(const struct flow_offload *flow)
 static void flow_offload_del(struct nf_flowtable *flow_table,
 			     struct flow_offload *flow)
 {
-	struct flow_offload_entry *e;
-
 	rhashtable_remove_fast(&flow_table->rhashtable,
 			       &flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].node,
 			       nf_flow_offload_rhash_params);
@@ -241,25 +238,21 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 			       &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
 			       nf_flow_offload_rhash_params);
 
-	e = container_of(flow, struct flow_offload_entry, flow);
-	clear_bit(IPS_OFFLOAD_BIT, &e->ct->status);
+	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
 
 	if (nf_flow_has_expired(flow))
-		flow_offload_fixup_ct(e->ct);
+		flow_offload_fixup_ct(flow->ct);
 	else if (flow->flags & FLOW_OFFLOAD_TEARDOWN)
-		flow_offload_fixup_ct_timeout(e->ct);
+		flow_offload_fixup_ct_timeout(flow->ct);
 
 	flow_offload_free(flow);
 }
 
 void flow_offload_teardown(struct flow_offload *flow)
 {
-	struct flow_offload_entry *e;
-
 	flow->flags |= FLOW_OFFLOAD_TEARDOWN;
 
-	e = container_of(flow, struct flow_offload_entry, flow);
-	flow_offload_fixup_ct_state(e->ct);
+	flow_offload_fixup_ct_state(flow->ct);
 }
 EXPORT_SYMBOL_GPL(flow_offload_teardown);
 
@@ -269,7 +262,6 @@ flow_offload_lookup(struct nf_flowtable *flow_table,
 {
 	struct flow_offload_tuple_rhash *tuplehash;
 	struct flow_offload *flow;
-	struct flow_offload_entry *e;
 	int dir;
 
 	tuplehash = rhashtable_lookup(&flow_table->rhashtable, tuple,
@@ -282,8 +274,7 @@ flow_offload_lookup(struct nf_flowtable *flow_table,
 	if (flow->flags & (FLOW_OFFLOAD_DYING | FLOW_OFFLOAD_TEARDOWN))
 		return NULL;
 
-	e = container_of(flow, struct flow_offload_entry, flow);
-	if (unlikely(nf_ct_is_dying(e->ct)))
+	if (unlikely(nf_ct_is_dying(flow->ct)))
 		return NULL;
 
 	return tuplehash;
@@ -327,10 +318,8 @@ nf_flow_table_iterate(struct nf_flowtable *flow_table,
 static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
 {
 	struct nf_flowtable *flow_table = data;
-	struct flow_offload_entry *e;
 
-	e = container_of(flow, struct flow_offload_entry, flow);
-	if (nf_flow_has_expired(flow) || nf_ct_is_dying(e->ct) ||
+	if (nf_flow_has_expired(flow) || nf_ct_is_dying(flow->ct) ||
 	    (flow->flags & (FLOW_OFFLOAD_DYING | FLOW_OFFLOAD_TEARDOWN)))
 		flow_offload_del(flow_table, flow);
 }
@@ -485,15 +474,13 @@ EXPORT_SYMBOL_GPL(nf_flow_table_init);
 static void nf_flow_table_do_cleanup(struct flow_offload *flow, void *data)
 {
 	struct net_device *dev = data;
-	struct flow_offload_entry *e;
-
-	e = container_of(flow, struct flow_offload_entry, flow);
 
 	if (!dev) {
 		flow_offload_teardown(flow);
 		return;
 	}
-	if (net_eq(nf_ct_net(e->ct), dev_net(dev)) &&
+
+	if (net_eq(nf_ct_net(flow->ct), dev_net(dev)) &&
 	    (flow->tuplehash[0].tuple.iifidx == dev->ifindex ||
 	     flow->tuplehash[1].tuple.iifidx == dev->ifindex))
 		flow_offload_dead(flow);
-- 
2.11.0

