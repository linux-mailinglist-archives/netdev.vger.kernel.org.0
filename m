Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3F8CF8371
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 00:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbfKKXaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 18:30:10 -0500
Received: from correo.us.es ([193.147.175.20]:41014 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726973AbfKKXaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 18:30:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BBAE61C439B
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:30:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AEE99FB362
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:30:05 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A22DED2B1F; Tue, 12 Nov 2019 00:30:05 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 90948DA801;
        Tue, 12 Nov 2019 00:30:03 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 12 Nov 2019 00:30:03 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2FEFE42EF4E1;
        Tue, 12 Nov 2019 00:30:03 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, paulb@mellanox.com,
        ozsh@mellanox.com, majd@mellanox.com, saeedm@mellanox.com
Subject: [PATCH net-next 3/6] netfilter: nf_flowtable: remove flow_offload_entry structure
Date:   Tue, 12 Nov 2019 00:29:53 +0100
Message-Id: <20191111232956.24898-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191111232956.24898-1-pablo@netfilter.org>
References: <20191111232956.24898-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move rcu_head to struct flow_offload, then remove the flow_offload_entry
structure definition.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h |  1 +
 net/netfilter/nf_flow_table_core.c    | 19 ++++---------------
 2 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 7f892d6c1a6d..6d33734c8fa1 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -75,6 +75,7 @@ struct flow_offload {
 	struct nf_conn				*ct;
 	u32					flags;
 	u32					timeout;
+	struct rcu_head				rcu_head;
 };
 
 #define NF_FLOW_TIMEOUT (30 * HZ)
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index aca40ccbcceb..15a5555940c7 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -14,11 +14,6 @@
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
 
-struct flow_offload_entry {
-	struct flow_offload	flow;
-	struct rcu_head		rcu_head;
-};
-
 static DEFINE_MUTEX(flowtable_lock);
 static LIST_HEAD(flowtables);
 
@@ -59,19 +54,16 @@ flow_offload_fill_dir(struct flow_offload *flow, struct nf_conn *ct,
 struct flow_offload *
 flow_offload_alloc(struct nf_conn *ct, struct nf_flow_route *route)
 {
-	struct flow_offload_entry *entry;
 	struct flow_offload *flow;
 
 	if (unlikely(nf_ct_is_dying(ct) ||
 	    !atomic_inc_not_zero(&ct->ct_general.use)))
 		return NULL;
 
-	entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
-	if (!entry)
+	flow = kzalloc(sizeof(*flow), GFP_ATOMIC);
+	if (!flow)
 		goto err_ct_refcnt;
 
-	flow = &entry->flow;
-
 	if (!dst_hold_safe(route->tuple[FLOW_OFFLOAD_DIR_ORIGINAL].dst))
 		goto err_dst_cache_original;
 
@@ -93,7 +85,7 @@ flow_offload_alloc(struct nf_conn *ct, struct nf_flow_route *route)
 err_dst_cache_reply:
 	dst_release(route->tuple[FLOW_OFFLOAD_DIR_ORIGINAL].dst);
 err_dst_cache_original:
-	kfree(entry);
+	kfree(flow);
 err_ct_refcnt:
 	nf_ct_put(ct);
 
@@ -151,15 +143,12 @@ static void flow_offload_fixup_ct(struct nf_conn *ct)
 
 void flow_offload_free(struct flow_offload *flow)
 {
-	struct flow_offload_entry *e;
-
 	dst_release(flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst_cache);
 	dst_release(flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_cache);
-	e = container_of(flow, struct flow_offload_entry, flow);
 	if (flow->flags & FLOW_OFFLOAD_DYING)
 		nf_ct_delete(flow->ct, 0, 0);
 	nf_ct_put(flow->ct);
-	kfree_rcu(e, rcu_head);
+	kfree_rcu(flow, rcu_head);
 }
 EXPORT_SYMBOL_GPL(flow_offload_free);
 
-- 
2.11.0

