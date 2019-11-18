Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C343E100E43
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 22:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbfKRVth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 16:49:37 -0500
Received: from correo.us.es ([193.147.175.20]:45750 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727174AbfKRVth (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 16:49:37 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D3D6FEB49D
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 22:49:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C2AA7D1911
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 22:49:31 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B82FEDA4CA; Mon, 18 Nov 2019 22:49:31 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B89D9B7FF6;
        Mon, 18 Nov 2019 22:49:26 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 18 Nov 2019 22:49:26 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 89CF442EE38F;
        Mon, 18 Nov 2019 22:49:26 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 09/18] netfilter: nf_flow_table_offload: add flow_action_entry_next() and use it
Date:   Mon, 18 Nov 2019 22:49:05 +0100
Message-Id: <20191118214914.142794-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191118214914.142794-1-pablo@netfilter.org>
References: <20191118214914.142794-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function retrieves a spare action entry from the array of actions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 76 +++++++++++++++++------------------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 9be61f47303a..b9f669c80713 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -112,13 +112,22 @@ static void flow_offload_mangle(struct flow_action_entry *entry,
 	memcpy(&entry->mangle.val, value, sizeof(u32));
 }
 
+static inline struct flow_action_entry *
+flow_action_entry_next(struct nf_flow_rule *flow_rule)
+{
+	int i = flow_rule->rule->action.num_entries++;
+
+	return &flow_rule->rule->action.entries[i];
+}
+
 static int flow_offload_eth_src(struct net *net,
 				const struct flow_offload *flow,
 				enum flow_offload_tuple_dir dir,
-				struct flow_action_entry *entry0,
-				struct flow_action_entry *entry1)
+				struct nf_flow_rule *flow_rule)
 {
 	const struct flow_offload_tuple *tuple = &flow->tuplehash[!dir].tuple;
+	struct flow_action_entry *entry0 = flow_action_entry_next(flow_rule);
+	struct flow_action_entry *entry1 = flow_action_entry_next(flow_rule);
 	struct net_device *dev;
 	u32 mask, val;
 	u16 val16;
@@ -145,10 +154,11 @@ static int flow_offload_eth_src(struct net *net,
 static int flow_offload_eth_dst(struct net *net,
 				const struct flow_offload *flow,
 				enum flow_offload_tuple_dir dir,
-				struct flow_action_entry *entry0,
-				struct flow_action_entry *entry1)
+				struct nf_flow_rule *flow_rule)
 {
 	const struct flow_offload_tuple *tuple = &flow->tuplehash[dir].tuple;
+	struct flow_action_entry *entry0 = flow_action_entry_next(flow_rule);
+	struct flow_action_entry *entry1 = flow_action_entry_next(flow_rule);
 	struct neighbour *n;
 	u32 mask, val;
 	u16 val16;
@@ -175,8 +185,9 @@ static int flow_offload_eth_dst(struct net *net,
 static void flow_offload_ipv4_snat(struct net *net,
 				   const struct flow_offload *flow,
 				   enum flow_offload_tuple_dir dir,
-				   struct flow_action_entry *entry)
+				   struct nf_flow_rule *flow_rule)
 {
+	struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
 	u32 mask = ~htonl(0xffffffff);
 	__be32 addr;
 	u32 offset;
@@ -201,8 +212,9 @@ static void flow_offload_ipv4_snat(struct net *net,
 static void flow_offload_ipv4_dnat(struct net *net,
 				   const struct flow_offload *flow,
 				   enum flow_offload_tuple_dir dir,
-				   struct flow_action_entry *entry)
+				   struct nf_flow_rule *flow_rule)
 {
+	struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
 	u32 mask = ~htonl(0xffffffff);
 	__be32 addr;
 	u32 offset;
@@ -246,8 +258,9 @@ static int flow_offload_l4proto(const struct flow_offload *flow)
 static void flow_offload_port_snat(struct net *net,
 				   const struct flow_offload *flow,
 				   enum flow_offload_tuple_dir dir,
-				   struct flow_action_entry *entry)
+				   struct nf_flow_rule *flow_rule)
 {
+	struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
 	u32 mask = ~htonl(0xffff0000);
 	__be16 port;
 	u32 offset;
@@ -272,8 +285,9 @@ static void flow_offload_port_snat(struct net *net,
 static void flow_offload_port_dnat(struct net *net,
 				   const struct flow_offload *flow,
 				   enum flow_offload_tuple_dir dir,
-				   struct flow_action_entry *entry)
+				   struct nf_flow_rule *flow_rule)
 {
+	struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
 	u32 mask = ~htonl(0xffff);
 	__be16 port;
 	u32 offset;
@@ -297,9 +311,10 @@ static void flow_offload_port_dnat(struct net *net,
 
 static void flow_offload_ipv4_checksum(struct net *net,
 				       const struct flow_offload *flow,
-				       struct flow_action_entry *entry)
+				       struct nf_flow_rule *flow_rule)
 {
 	u8 protonum = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.l4proto;
+	struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
 
 	entry->id = FLOW_ACTION_CSUM;
 	entry->csum_flags = TCA_CSUM_UPDATE_FLAG_IPV4HDR;
@@ -316,8 +331,9 @@ static void flow_offload_ipv4_checksum(struct net *net,
 
 static void flow_offload_redirect(const struct flow_offload *flow,
 				  enum flow_offload_tuple_dir dir,
-				  struct flow_action_entry *entry)
+				  struct nf_flow_rule *flow_rule)
 {
+	struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
 	struct rtable *rt;
 
 	rt = (struct rtable *)flow->tuplehash[dir].tuple.dst_cache;
@@ -330,39 +346,25 @@ int nf_flow_rule_route(struct net *net, const struct flow_offload *flow,
 		       enum flow_offload_tuple_dir dir,
 		       struct nf_flow_rule *flow_rule)
 {
-	int i;
-
-	if (flow_offload_eth_src(net, flow, dir,
-				 &flow_rule->rule->action.entries[0],
-				 &flow_rule->rule->action.entries[1]) < 0)
+	if (flow_offload_eth_src(net, flow, dir, flow_rule) < 0 ||
+	    flow_offload_eth_dst(net, flow, dir, flow_rule) < 0)
 		return -1;
 
-	if (flow_offload_eth_dst(net, flow, dir,
-				 &flow_rule->rule->action.entries[2],
-				 &flow_rule->rule->action.entries[3]) < 0)
-		return -1;
-
-	i = 4;
 	if (flow->flags & FLOW_OFFLOAD_SNAT) {
-		flow_offload_ipv4_snat(net, flow, dir,
-				       &flow_rule->rule->action.entries[i++]);
-		flow_offload_port_snat(net, flow, dir,
-				       &flow_rule->rule->action.entries[i++]);
+		flow_offload_ipv4_snat(net, flow, dir, flow_rule);
+		flow_offload_port_snat(net, flow, dir, flow_rule);
 	}
 	if (flow->flags & FLOW_OFFLOAD_DNAT) {
-		flow_offload_ipv4_dnat(net, flow, dir,
-				       &flow_rule->rule->action.entries[i++]);
-		flow_offload_port_dnat(net, flow, dir,
-				       &flow_rule->rule->action.entries[i++]);
+		flow_offload_ipv4_dnat(net, flow, dir, flow_rule);
+		flow_offload_port_dnat(net, flow, dir, flow_rule);
 	}
 	if (flow->flags & FLOW_OFFLOAD_SNAT ||
 	    flow->flags & FLOW_OFFLOAD_DNAT)
-		flow_offload_ipv4_checksum(net, flow,
-					   &flow_rule->rule->action.entries[i++]);
+		flow_offload_ipv4_checksum(net, flow, flow_rule);
 
-	flow_offload_redirect(flow, dir, &flow_rule->rule->action.entries[i++]);
+	flow_offload_redirect(flow, dir, flow_rule);
 
-	return i;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(nf_flow_rule_route);
 
@@ -375,7 +377,7 @@ nf_flow_offload_rule_alloc(struct net *net,
 	const struct flow_offload *flow = offload->flow;
 	const struct flow_offload_tuple *tuple;
 	struct nf_flow_rule *flow_rule;
-	int err = -ENOMEM, num_actions;
+	int err = -ENOMEM;
 
 	flow_rule = kzalloc(sizeof(*flow_rule), GFP_KERNEL);
 	if (!flow_rule)
@@ -394,12 +396,10 @@ nf_flow_offload_rule_alloc(struct net *net,
 	if (err < 0)
 		goto err_flow_match;
 
-	num_actions = flowtable->type->action(net, flow, dir, flow_rule);
-	if (num_actions < 0)
+	flow_rule->rule->action.num_entries = 0;
+	if (flowtable->type->action(net, flow, dir, flow_rule) < 0)
 		goto err_flow_match;
 
-	flow_rule->rule->action.num_entries = num_actions;
-
 	return flow_rule;
 
 err_flow_match:
-- 
2.11.0

