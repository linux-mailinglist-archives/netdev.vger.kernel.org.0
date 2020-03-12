Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F638182D62
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 11:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgCLKXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 06:23:33 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:56601 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725268AbgCLKXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 06:23:32 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 12 Mar 2020 12:23:28 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02CANSTc017875;
        Thu, 12 Mar 2020 12:23:28 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next ct-offload v4 04/15] net/sched: act_ct: Instantiate flow table entry actions
Date:   Thu, 12 Mar 2020 12:23:06 +0200
Message-Id: <1584008597-15875-5-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1584008597-15875-1-git-send-email-paulb@mellanox.com>
References: <1584008597-15875-1-git-send-email-paulb@mellanox.com>
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
Reviewed-by: Edward Cree <ecree@solarflare.com>
---
Changelog:
   v3->v4:
     Added reviewed by "Reviewed-by: Edward Cree <ecree@solarflare.com>", thanks!
   v2->v3:
     Fix nat masks and conversions
     Moved comment above nat helpers
   v1->v2:
     Remove zone from metadata
     Add add mangle helper func (removes the unneccasry () and correct the mask there)
     Remove "abuse" of ? operator and use switch case
     Check protocol and ports in relevant function and return err
     On error restore action entries (on the topic, validaiting num of action isn't available)
     Add comment expalining nat
     Remove Inlinie from tcf_ct_flow_table_flow_action_get_next
     Refactor tcf_ct_flow_table_add_action_nat_ipv6 with helper
     On nats, allow both src and dst mangles

 include/net/flow_offload.h            |   5 +
 include/net/netfilter/nf_flow_table.h |  23 ++++
 net/netfilter/nf_flow_table_offload.c |  23 ----
 net/sched/act_ct.c                    | 207 ++++++++++++++++++++++++++++++++++
 4 files changed, 235 insertions(+), 23 deletions(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index d1b1e4a..ba43349 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -136,6 +136,7 @@ enum flow_action_id {
 	FLOW_ACTION_SAMPLE,
 	FLOW_ACTION_POLICE,
 	FLOW_ACTION_CT,
+	FLOW_ACTION_CT_METADATA,
 	FLOW_ACTION_MPLS_PUSH,
 	FLOW_ACTION_MPLS_POP,
 	FLOW_ACTION_MPLS_MANGLE,
@@ -225,6 +226,10 @@ struct flow_action_entry {
 			int action;
 			u16 zone;
 		} ct;
+		struct {
+			u32 mark;
+			u32 labels[4];
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
index f5afdf0..42b73a0 100644
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
index 3d9e678..9c522bc 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -55,7 +55,214 @@ struct tcf_ct_flow_table {
 	.automatic_shrinking = true,
 };
 
+static struct flow_action_entry *
+tcf_ct_flow_table_flow_action_get_next(struct flow_action *flow_action)
+{
+	int i = flow_action->num_entries++;
+
+	return &flow_action->entries[i];
+}
+
+static void tcf_ct_add_mangle_action(struct flow_action *action,
+				     enum flow_action_mangle_base htype,
+				     u32 offset,
+				     u32 mask,
+				     u32 val)
+{
+	struct flow_action_entry *entry;
+
+	entry = tcf_ct_flow_table_flow_action_get_next(action);
+	entry->id = FLOW_ACTION_MANGLE;
+	entry->mangle.htype = htype;
+	entry->mangle.mask = ~mask;
+	entry->mangle.offset = offset;
+	entry->mangle.val = val;
+}
+
+/* The following nat helper functions check if the inverted reverse tuple
+ * (target) is different then the current dir tuple - meaning nat for ports
+ * and/or ip is needed, and add the relevant mangle actions.
+ */
+static void
+tcf_ct_flow_table_add_action_nat_ipv4(const struct nf_conntrack_tuple *tuple,
+				      struct nf_conntrack_tuple target,
+				      struct flow_action *action)
+{
+	if (memcmp(&target.src.u3, &tuple->src.u3, sizeof(target.src.u3)))
+		tcf_ct_add_mangle_action(action, FLOW_ACT_MANGLE_HDR_TYPE_IP4,
+					 offsetof(struct iphdr, saddr),
+					 0xFFFFFFFF,
+					 be32_to_cpu(target.src.u3.ip));
+	if (memcmp(&target.dst.u3, &tuple->dst.u3, sizeof(target.dst.u3)))
+		tcf_ct_add_mangle_action(action, FLOW_ACT_MANGLE_HDR_TYPE_IP4,
+					 offsetof(struct iphdr, daddr),
+					 0xFFFFFFFF,
+					 be32_to_cpu(target.dst.u3.ip));
+}
+
+static void
+tcf_ct_add_ipv6_addr_mangle_action(struct flow_action *action,
+				   union nf_inet_addr *addr,
+				   u32 offset)
+{
+	int i;
+
+	for (i = 0; i < sizeof(struct in6_addr) / sizeof(u32); i++)
+		tcf_ct_add_mangle_action(action, FLOW_ACT_MANGLE_HDR_TYPE_IP6,
+					 i * sizeof(u32) + offset,
+					 0xFFFFFFFF, be32_to_cpu(addr->ip6[i]));
+}
+
+static void
+tcf_ct_flow_table_add_action_nat_ipv6(const struct nf_conntrack_tuple *tuple,
+				      struct nf_conntrack_tuple target,
+				      struct flow_action *action)
+{
+	if (memcmp(&target.src.u3, &tuple->src.u3, sizeof(target.src.u3)))
+		tcf_ct_add_ipv6_addr_mangle_action(action, &target.src.u3,
+						   offsetof(struct ipv6hdr,
+							    saddr));
+	if (memcmp(&target.dst.u3, &tuple->dst.u3, sizeof(target.dst.u3)))
+		tcf_ct_add_ipv6_addr_mangle_action(action, &target.dst.u3,
+						   offsetof(struct ipv6hdr,
+							    daddr));
+}
+
+static void
+tcf_ct_flow_table_add_action_nat_tcp(const struct nf_conntrack_tuple *tuple,
+				     struct nf_conntrack_tuple target,
+				     struct flow_action *action)
+{
+	__be16 target_src = target.src.u.tcp.port;
+	__be16 target_dst = target.dst.u.tcp.port;
+
+	if (target_src != tuple->src.u.tcp.port)
+		tcf_ct_add_mangle_action(action, FLOW_ACT_MANGLE_HDR_TYPE_TCP,
+					 offsetof(struct tcphdr, source),
+					 0xFFFF, be16_to_cpu(target_src));
+	if (target_dst != tuple->dst.u.tcp.port)
+		tcf_ct_add_mangle_action(action, FLOW_ACT_MANGLE_HDR_TYPE_TCP,
+					 offsetof(struct tcphdr, dest),
+					 0xFFFF, be16_to_cpu(target_dst));
+}
+
+static void
+tcf_ct_flow_table_add_action_nat_udp(const struct nf_conntrack_tuple *tuple,
+				     struct nf_conntrack_tuple target,
+				     struct flow_action *action)
+{
+	__be16 target_src = target.src.u.udp.port;
+	__be16 target_dst = target.dst.u.udp.port;
+
+	if (target_src != tuple->src.u.udp.port)
+		tcf_ct_add_mangle_action(action, FLOW_ACT_MANGLE_HDR_TYPE_TCP,
+					 offsetof(struct udphdr, source),
+					 0xFFFF, be16_to_cpu(target_src));
+	if (target_dst != tuple->dst.u.udp.port)
+		tcf_ct_add_mangle_action(action, FLOW_ACT_MANGLE_HDR_TYPE_TCP,
+					 offsetof(struct udphdr, dest),
+					 0xFFFF, be16_to_cpu(target_dst));
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
+static int tcf_ct_flow_table_add_action_nat(struct net *net,
+					    struct nf_conn *ct,
+					    enum ip_conntrack_dir dir,
+					    struct flow_action *action)
+{
+	const struct nf_conntrack_tuple *tuple = &ct->tuplehash[dir].tuple;
+	struct nf_conntrack_tuple target;
+
+	nf_ct_invert_tuple(&target, &ct->tuplehash[!dir].tuple);
+
+	switch (tuple->src.l3num) {
+	case NFPROTO_IPV4:
+		tcf_ct_flow_table_add_action_nat_ipv4(tuple, target,
+						      action);
+		break;
+	case NFPROTO_IPV6:
+		tcf_ct_flow_table_add_action_nat_ipv6(tuple, target,
+						      action);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	switch (nf_ct_protonum(ct)) {
+	case IPPROTO_TCP:
+		tcf_ct_flow_table_add_action_nat_tcp(tuple, target, action);
+		break;
+	case IPPROTO_UDP:
+		tcf_ct_flow_table_add_action_nat_udp(tuple, target, action);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int tcf_ct_flow_table_fill_actions(struct net *net,
+					  const struct flow_offload *flow,
+					  enum flow_offload_tuple_dir tdir,
+					  struct nf_flow_rule *flow_rule)
+{
+	struct flow_action *action = &flow_rule->rule->action;
+	int num_entries = action->num_entries;
+	struct nf_conn *ct = flow->ct;
+	enum ip_conntrack_dir dir;
+	int i, err;
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
+	err = tcf_ct_flow_table_add_action_nat(net, ct, dir, action);
+	if (err)
+		goto err_nat;
+
+	tcf_ct_flow_table_add_action_meta(ct, dir, action);
+	return 0;
+
+err_nat:
+	/* Clear filled actions */
+	for (i = num_entries; i < action->num_entries; i++)
+		memset(&action->entries[i], 0, sizeof(action->entries[i]));
+	action->num_entries = num_entries;
+
+	return err;
+}
+
 static struct nf_flowtable_type flowtable_ct = {
+	.action		= tcf_ct_flow_table_fill_actions,
 	.owner		= THIS_MODULE,
 };
 
-- 
1.8.3.1

