Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1914B17A8EB
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 16:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgCEPel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 10:34:41 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:48311 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726382AbgCEPei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 10:34:38 -0500
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 5 Mar 2020 17:34:34 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 025FYYsQ010824;
        Thu, 5 Mar 2020 17:34:34 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next ct-offload 02/13] net/sched: act_ct: Instantiate flow table entry actions
Date:   Thu,  5 Mar 2020 17:34:17 +0200
Message-Id: <1583422468-8456-3-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1583422468-8456-1-git-send-email-paulb@mellanox.com>
References: <1583422468-8456-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NF flow table API associate 5-tuple rule with an action list by calling
the flow table type action() CB to fill the rule's actions.

In action CB of act_ct, populate the ct offload entry actions with a new
ct_metadata action. Initialize the ct_metadata with the ct mark, label and
zone information. If ct nat was performed, then also append the relevant
packet mangle actions (e.g. ipv4/ipv6/tcp/udp header rewrites).

Drivers that offload the ft entries may match on the 5-tuple and perform
the action list.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/flow_offload.h            |   6 ++
 include/net/netfilter/nf_flow_table.h |  23 ++++
 net/netfilter/nf_flow_table_offload.c |  23 ----
 net/sched/act_ct.c                    | 192 ++++++++++++++++++++++++++++++++++
 4 files changed, 221 insertions(+), 23 deletions(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index c6f7bd2..f7215fa 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -135,6 +135,7 @@ enum flow_action_id {
 	FLOW_ACTION_SAMPLE,
 	FLOW_ACTION_POLICE,
 	FLOW_ACTION_CT,
+	FLOW_ACTION_CT_METADATA,
 	FLOW_ACTION_MPLS_PUSH,
 	FLOW_ACTION_MPLS_POP,
 	FLOW_ACTION_MPLS_MANGLE,
@@ -197,6 +198,11 @@ struct flow_action_entry {
 			int action;
 			u16 zone;
 		} ct;
+		struct {
+			u32 mark;
+			u32 labels[4];
+			u16 zone;
+		} ct_metadata;
 		struct {				/* FLOW_ACTION_MPLS_PUSH */
 			u32		label;
 			__be16		proto;
diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index d9d0945..c2d5cdd 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -16,6 +16,29 @@
 struct flow_offload;
 enum flow_offload_tuple_dir;
 
+struct nf_flow_key {
+	struct flow_dissector_key_meta			meta;
+	struct flow_dissector_key_control		control;
+	struct flow_dissector_key_basic			basic;
+	union {
+		struct flow_dissector_key_ipv4_addrs	ipv4;
+		struct flow_dissector_key_ipv6_addrs	ipv6;
+	};
+	struct flow_dissector_key_tcp			tcp;
+	struct flow_dissector_key_ports			tp;
+} __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
+
+struct nf_flow_match {
+	struct flow_dissector	dissector;
+	struct nf_flow_key	key;
+	struct nf_flow_key	mask;
+};
+
+struct nf_flow_rule {
+	struct nf_flow_match	match;
+	struct flow_rule	*rule;
+};
+
 struct nf_flowtable_type {
 	struct list_head		list;
 	int				family;
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index c35c337..f5107f3a 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -23,29 +23,6 @@ struct flow_offload_work {
 	struct flow_offload	*flow;
 };
 
-struct nf_flow_key {
-	struct flow_dissector_key_meta			meta;
-	struct flow_dissector_key_control		control;
-	struct flow_dissector_key_basic			basic;
-	union {
-		struct flow_dissector_key_ipv4_addrs	ipv4;
-		struct flow_dissector_key_ipv6_addrs	ipv6;
-	};
-	struct flow_dissector_key_tcp			tcp;
-	struct flow_dissector_key_ports			tp;
-} __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
-
-struct nf_flow_match {
-	struct flow_dissector	dissector;
-	struct nf_flow_key	key;
-	struct nf_flow_key	mask;
-};
-
-struct nf_flow_rule {
-	struct nf_flow_match	match;
-	struct flow_rule	*rule;
-};
-
 #define NF_FLOW_DISSECTOR(__match, __type, __field)	\
 	(__match)->dissector.offset[__type] =		\
 		offsetof(struct nf_flow_key, __field)
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 23eba61..0773456 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -55,7 +55,199 @@ struct tcf_ct_flow_table {
 	.automatic_shrinking = true,
 };
 
+static inline struct flow_action_entry *
+tcf_ct_flow_table_flow_action_get_next(struct flow_action *flow_action)
+{
+	int i = flow_action->num_entries++;
+
+	return &flow_action->entries[i];
+}
+
+static void
+tcf_ct_flow_table_add_action_nat_ipv4(const struct nf_conntrack_tuple *tuple,
+				      struct nf_conntrack_tuple target,
+				      struct flow_action *action)
+{
+	struct flow_action_entry *entry;
+
+	if (memcmp(&target.src.u3, &tuple->src.u3, sizeof(target.src.u3))) {
+		entry = tcf_ct_flow_table_flow_action_get_next(action);
+		entry->id = FLOW_ACTION_MANGLE;
+		entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_IP4;
+		entry->mangle.mask = ~(0xFFFFFFFF);
+		entry->mangle.offset = offsetof(struct iphdr, saddr);
+		entry->mangle.val = htonl(target.src.u3.ip);
+	} else if (memcmp(&target.dst.u3, &tuple->dst.u3,
+			  sizeof(target.dst.u3))) {
+		entry = tcf_ct_flow_table_flow_action_get_next(action);
+		entry->id = FLOW_ACTION_MANGLE;
+		entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_IP4;
+		entry->mangle.mask = ~(0xFFFFFFFF);
+		entry->mangle.offset = offsetof(struct iphdr, daddr);
+		entry->mangle.val = htonl(target.dst.u3.ip);
+	}
+}
+
+static void
+tcf_ct_flow_table_add_action_nat_ipv6(const struct nf_conntrack_tuple *tuple,
+				      struct nf_conntrack_tuple target,
+				      struct flow_action *action)
+{
+	struct flow_action_entry *entry;
+	union nf_inet_addr *addr;
+	u32 next_offset = 0;
+	int i;
+
+	if (memcmp(&target.src.u3, &tuple->src.u3, sizeof(target.src.u3))) {
+		addr = &target.src.u3;
+		next_offset = offsetof(struct iphdr, saddr);
+	} else if (memcmp(&target.dst.u3, &tuple->dst.u3,
+			  sizeof(target.dst.u3))) {
+		addr = &target.dst.u3;
+		next_offset = offsetof(struct iphdr, daddr);
+	} else {
+		return;
+	}
+
+	for (i = 0; i < sizeof(struct in6_addr) / sizeof(u32); i++) {
+		entry = tcf_ct_flow_table_flow_action_get_next(action);
+		entry->id = FLOW_ACTION_MANGLE;
+		entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_IP6;
+		entry->mangle.mask = ~(0xFFFFFFFF);
+		entry->mangle.val = htonl(addr->ip6[i]);
+		entry->mangle.offset = next_offset;
+
+		next_offset += sizeof(u32);
+	}
+}
+
+static void
+tcf_ct_flow_table_add_action_nat_tcp(const struct nf_conntrack_tuple *tuple,
+				     struct nf_conntrack_tuple target,
+				     struct flow_action *action)
+{
+	struct flow_action_entry *entry;
+
+	if (target.src.u.tcp.port != tuple->src.u.tcp.port) {
+		entry = tcf_ct_flow_table_flow_action_get_next(action);
+		entry->id = FLOW_ACTION_MANGLE;
+		entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_TCP;
+		entry->mangle.mask = ~(0xFFFF);
+		entry->mangle.offset = offsetof(struct tcphdr, source);
+		entry->mangle.val = htons(target.src.u.tcp.port);
+	} else if (target.dst.u.tcp.port != tuple->dst.u.tcp.port) {
+		entry = tcf_ct_flow_table_flow_action_get_next(action);
+		entry->id = FLOW_ACTION_MANGLE;
+		entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_TCP;
+		entry->mangle.mask = ~(0xFFFF);
+		entry->mangle.offset = offsetof(struct tcphdr, dest);
+		entry->mangle.val = htons(target.dst.u.tcp.port);
+	}
+}
+
+static void
+tcf_ct_flow_table_add_action_nat_udp(const struct nf_conntrack_tuple *tuple,
+				     struct nf_conntrack_tuple target,
+				     struct flow_action *action)
+{
+	struct flow_action_entry *entry;
+
+	if (target.src.u.udp.port != tuple->src.u.udp.port) {
+		entry = tcf_ct_flow_table_flow_action_get_next(action);
+		entry->id = FLOW_ACTION_MANGLE;
+		entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_UDP;
+		entry->mangle.mask = ~(0xFFFF);
+		entry->mangle.offset = offsetof(struct udphdr, source);
+		entry->mangle.val = htons(target.src.u.udp.port);
+	} else if (target.dst.u.udp.port != tuple->dst.u.udp.port) {
+		entry = tcf_ct_flow_table_flow_action_get_next(action);
+		entry->id = FLOW_ACTION_MANGLE;
+		entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_UDP;
+		entry->mangle.mask = ~(0xFFFF);
+		entry->mangle.offset = offsetof(struct udphdr, dest);
+		entry->mangle.val = htons(target.dst.u.udp.port);
+	}
+}
+
+static void tcf_ct_flow_table_add_action_meta(struct nf_conn *ct,
+					      enum ip_conntrack_dir dir,
+					      struct flow_action *action)
+{
+	struct nf_conn_labels *ct_labels;
+	struct flow_action_entry *entry;
+	u32 *act_ct_labels;
+
+	entry = tcf_ct_flow_table_flow_action_get_next(action);
+	entry->id = FLOW_ACTION_CT_METADATA;
+	entry->ct_metadata.zone = nf_ct_zone(ct)->id;
+#if IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)
+	entry->ct_metadata.mark = ct->mark;
+#endif
+
+	act_ct_labels = entry->ct_metadata.labels;
+	ct_labels = nf_ct_labels_find(ct);
+	if (ct_labels)
+		memcpy(act_ct_labels, ct_labels->bits, NF_CT_LABELS_MAX_SIZE);
+	else
+		memset(act_ct_labels, 0, NF_CT_LABELS_MAX_SIZE);
+}
+
+static void tcf_ct_flow_table_add_action_nat(struct net *net,
+					     struct nf_conn *ct,
+					     enum ip_conntrack_dir dir,
+					     struct flow_action *action)
+{
+	const struct nf_conntrack_tuple *tuple = &ct->tuplehash[dir].tuple;
+	struct nf_conntrack_tuple target;
+
+	nf_ct_invert_tuple(&target, &ct->tuplehash[!dir].tuple);
+
+	tuple->src.l3num == NFPROTO_IPV4 ?
+		tcf_ct_flow_table_add_action_nat_ipv4(tuple, target, action) :
+		tcf_ct_flow_table_add_action_nat_ipv6(tuple, target, action);
+
+	nf_ct_protonum(ct) == IPPROTO_TCP ?
+		tcf_ct_flow_table_add_action_nat_tcp(tuple, target, action) :
+		tcf_ct_flow_table_add_action_nat_udp(tuple, target, action);
+}
+
+static int tcf_ct_flow_table_fill_actions(struct net *net,
+					  const struct flow_offload *flow,
+					  enum flow_offload_tuple_dir tdir,
+					  struct nf_flow_rule *flow_rule)
+{
+	struct flow_action *action = &flow_rule->rule->action;
+	const struct nf_conntrack_tuple *tuple;
+	struct nf_conn *ct = flow->ct;
+	enum ip_conntrack_dir dir;
+
+	switch (tdir) {
+	case FLOW_OFFLOAD_DIR_ORIGINAL:
+		dir = IP_CT_DIR_ORIGINAL;
+		break;
+	case FLOW_OFFLOAD_DIR_REPLY:
+		dir = IP_CT_DIR_REPLY;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	tuple = &ct->tuplehash[dir].tuple;
+	if (tuple->src.l3num != NFPROTO_IPV4 &&
+	    tuple->src.l3num != NFPROTO_IPV6)
+		return -EOPNOTSUPP;
+
+	if (nf_ct_protonum(ct) != IPPROTO_TCP &&
+	    nf_ct_protonum(ct) != IPPROTO_UDP)
+		return -EOPNOTSUPP;
+
+	tcf_ct_flow_table_add_action_meta(ct, dir, action);
+	tcf_ct_flow_table_add_action_nat(net, ct, dir, action);
+	return 0;
+}
+
 static struct nf_flowtable_type flowtable_ct = {
+	.action		= tcf_ct_flow_table_fill_actions,
 	.owner		= THIS_MODULE,
 };
 
-- 
1.8.3.1

