Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEEA43368F2
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 01:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhCKAgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 19:36:54 -0500
Received: from correo.us.es ([193.147.175.20]:50148 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230034AbhCKAg0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 19:36:26 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 58C8612E832
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 01:36:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4BE8CDA791
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 01:36:25 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 413CCDA78D; Thu, 11 Mar 2021 01:36:25 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BC943DA704;
        Thu, 11 Mar 2021 01:36:22 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 11 Mar 2021 01:36:22 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 83C3E42DC6E2;
        Thu, 11 Mar 2021 01:36:22 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH net-next 15/23] netfilter: flowtable: add offload support for xmit path types
Date:   Thu, 11 Mar 2021 01:35:56 +0100
Message-Id: <20210311003604.22199-16-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210311003604.22199-1-pablo@netfilter.org>
References: <20210311003604.22199-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the flow tuple xmit_type is set to FLOW_OFFLOAD_XMIT_DIRECT, the
dst_cache pointer is not valid, and the h_source/h_dest/ifidx out fields
need to be used.

This patch also adds the FLOW_ACTION_VLAN_PUSH action to pass the VLAN
tag to the driver.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 166 +++++++++++++++++++-------
 1 file changed, 124 insertions(+), 42 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 2a6993fa40d7..aa2a0919a4a2 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -175,28 +175,45 @@ static int flow_offload_eth_src(struct net *net,
 				enum flow_offload_tuple_dir dir,
 				struct nf_flow_rule *flow_rule)
 {
-	const struct flow_offload_tuple *tuple = &flow->tuplehash[!dir].tuple;
 	struct flow_action_entry *entry0 = flow_action_entry_next(flow_rule);
 	struct flow_action_entry *entry1 = flow_action_entry_next(flow_rule);
-	struct net_device *dev;
+	const struct flow_offload_tuple *other_tuple, *this_tuple;
+	struct net_device *dev = NULL;
+	const unsigned char *addr;
 	u32 mask, val;
 	u16 val16;
 
-	dev = dev_get_by_index(net, tuple->iifidx);
-	if (!dev)
-		return -ENOENT;
+	this_tuple = &flow->tuplehash[dir].tuple;
+
+	switch (this_tuple->xmit_type) {
+	case FLOW_OFFLOAD_XMIT_DIRECT:
+		addr = this_tuple->out.h_source;
+		break;
+	case FLOW_OFFLOAD_XMIT_NEIGH:
+		other_tuple = &flow->tuplehash[!dir].tuple;
+		dev = dev_get_by_index(net, other_tuple->iifidx);
+		if (!dev)
+			return -ENOENT;
+
+		addr = dev->dev_addr;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
 
 	mask = ~0xffff0000;
-	memcpy(&val16, dev->dev_addr, 2);
+	memcpy(&val16, addr, 2);
 	val = val16 << 16;
 	flow_offload_mangle(entry0, FLOW_ACT_MANGLE_HDR_TYPE_ETH, 4,
 			    &val, &mask);
 
 	mask = ~0xffffffff;
-	memcpy(&val, dev->dev_addr + 2, 4);
+	memcpy(&val, addr + 2, 4);
 	flow_offload_mangle(entry1, FLOW_ACT_MANGLE_HDR_TYPE_ETH, 8,
 			    &val, &mask);
-	dev_put(dev);
+
+	if (dev)
+		dev_put(dev);
 
 	return 0;
 }
@@ -208,27 +225,40 @@ static int flow_offload_eth_dst(struct net *net,
 {
 	struct flow_action_entry *entry0 = flow_action_entry_next(flow_rule);
 	struct flow_action_entry *entry1 = flow_action_entry_next(flow_rule);
-	const void *daddr = &flow->tuplehash[!dir].tuple.src_v4;
+	const struct flow_offload_tuple *other_tuple, *this_tuple;
 	const struct dst_entry *dst_cache;
 	unsigned char ha[ETH_ALEN];
 	struct neighbour *n;
+	const void *daddr;
 	u32 mask, val;
 	u8 nud_state;
 	u16 val16;
 
-	dst_cache = flow->tuplehash[dir].tuple.dst_cache;
-	n = dst_neigh_lookup(dst_cache, daddr);
-	if (!n)
-		return -ENOENT;
+	this_tuple = &flow->tuplehash[dir].tuple;
 
-	read_lock_bh(&n->lock);
-	nud_state = n->nud_state;
-	ether_addr_copy(ha, n->ha);
-	read_unlock_bh(&n->lock);
-
-	if (!(nud_state & NUD_VALID)) {
+	switch (this_tuple->xmit_type) {
+	case FLOW_OFFLOAD_XMIT_DIRECT:
+		ether_addr_copy(ha, this_tuple->out.h_dest);
+		break;
+	case FLOW_OFFLOAD_XMIT_NEIGH:
+		other_tuple = &flow->tuplehash[!dir].tuple;
+		daddr = &other_tuple->src_v4;
+		dst_cache = this_tuple->dst_cache;
+		n = dst_neigh_lookup(dst_cache, daddr);
+		if (!n)
+			return -ENOENT;
+
+		read_lock_bh(&n->lock);
+		nud_state = n->nud_state;
+		ether_addr_copy(ha, n->ha);
+		read_unlock_bh(&n->lock);
 		neigh_release(n);
-		return -ENOENT;
+
+		if (!(nud_state & NUD_VALID))
+			return -ENOENT;
+		break;
+	default:
+		return -EOPNOTSUPP;
 	}
 
 	mask = ~0xffffffff;
@@ -241,7 +271,6 @@ static int flow_offload_eth_dst(struct net *net,
 	val = val16;
 	flow_offload_mangle(entry1, FLOW_ACT_MANGLE_HDR_TYPE_ETH, 4,
 			    &val, &mask);
-	neigh_release(n);
 
 	return 0;
 }
@@ -463,27 +492,52 @@ static void flow_offload_ipv4_checksum(struct net *net,
 	}
 }
 
-static void flow_offload_redirect(const struct flow_offload *flow,
+static void flow_offload_redirect(struct net *net,
+				  const struct flow_offload *flow,
 				  enum flow_offload_tuple_dir dir,
 				  struct nf_flow_rule *flow_rule)
 {
-	struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
-	struct rtable *rt;
+	const struct flow_offload_tuple *this_tuple, *other_tuple;
+	struct flow_action_entry *entry;
+	struct net_device *dev;
+	int ifindex;
 
-	rt = (struct rtable *)flow->tuplehash[dir].tuple.dst_cache;
+	this_tuple = &flow->tuplehash[dir].tuple;
+	switch (this_tuple->xmit_type) {
+	case FLOW_OFFLOAD_XMIT_DIRECT:
+		this_tuple = &flow->tuplehash[dir].tuple;
+		ifindex = this_tuple->out.ifidx;
+		break;
+	case FLOW_OFFLOAD_XMIT_NEIGH:
+		other_tuple = &flow->tuplehash[!dir].tuple;
+		ifindex = other_tuple->iifidx;
+		break;
+	default:
+		return;
+	}
+
+	dev = dev_get_by_index(net, ifindex);
+	if (!dev)
+		return;
+
+	entry = flow_action_entry_next(flow_rule);
 	entry->id = FLOW_ACTION_REDIRECT;
-	entry->dev = rt->dst.dev;
-	dev_hold(rt->dst.dev);
+	entry->dev = dev;
 }
 
 static void flow_offload_encap_tunnel(const struct flow_offload *flow,
 				      enum flow_offload_tuple_dir dir,
 				      struct nf_flow_rule *flow_rule)
 {
+	const struct flow_offload_tuple *this_tuple;
 	struct flow_action_entry *entry;
 	struct dst_entry *dst;
 
-	dst = flow->tuplehash[dir].tuple.dst_cache;
+	this_tuple = &flow->tuplehash[dir].tuple;
+	if (this_tuple->xmit_type == FLOW_OFFLOAD_XMIT_DIRECT)
+		return;
+
+	dst = this_tuple->dst_cache;
 	if (dst && dst->lwtstate) {
 		struct ip_tunnel_info *tun_info;
 
@@ -500,10 +554,15 @@ static void flow_offload_decap_tunnel(const struct flow_offload *flow,
 				      enum flow_offload_tuple_dir dir,
 				      struct nf_flow_rule *flow_rule)
 {
+	const struct flow_offload_tuple *other_tuple;
 	struct flow_action_entry *entry;
 	struct dst_entry *dst;
 
-	dst = flow->tuplehash[!dir].tuple.dst_cache;
+	other_tuple = &flow->tuplehash[!dir].tuple;
+	if (other_tuple->xmit_type == FLOW_OFFLOAD_XMIT_DIRECT)
+		return;
+
+	dst = other_tuple->dst_cache;
 	if (dst && dst->lwtstate) {
 		struct ip_tunnel_info *tun_info;
 
@@ -515,10 +574,14 @@ static void flow_offload_decap_tunnel(const struct flow_offload *flow,
 	}
 }
 
-int nf_flow_rule_route_ipv4(struct net *net, const struct flow_offload *flow,
-			    enum flow_offload_tuple_dir dir,
-			    struct nf_flow_rule *flow_rule)
+static int
+nf_flow_rule_route_common(struct net *net, const struct flow_offload *flow,
+			  enum flow_offload_tuple_dir dir,
+			  struct nf_flow_rule *flow_rule)
 {
+	const struct flow_offload_tuple *other_tuple;
+	int i;
+
 	flow_offload_decap_tunnel(flow, dir, flow_rule);
 	flow_offload_encap_tunnel(flow, dir, flow_rule);
 
@@ -526,6 +589,26 @@ int nf_flow_rule_route_ipv4(struct net *net, const struct flow_offload *flow,
 	    flow_offload_eth_dst(net, flow, dir, flow_rule) < 0)
 		return -1;
 
+	other_tuple = &flow->tuplehash[!dir].tuple;
+
+	for (i = 0; i < other_tuple->encap_num; i++) {
+		struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
+
+		entry->id = FLOW_ACTION_VLAN_PUSH;
+		entry->vlan.vid = other_tuple->encap[i].id;
+		entry->vlan.proto = other_tuple->encap[i].proto;
+	}
+
+	return 0;
+}
+
+int nf_flow_rule_route_ipv4(struct net *net, const struct flow_offload *flow,
+			    enum flow_offload_tuple_dir dir,
+			    struct nf_flow_rule *flow_rule)
+{
+	if (nf_flow_rule_route_common(net, flow, dir, flow_rule) < 0)
+		return -1;
+
 	if (test_bit(NF_FLOW_SNAT, &flow->flags)) {
 		flow_offload_ipv4_snat(net, flow, dir, flow_rule);
 		flow_offload_port_snat(net, flow, dir, flow_rule);
@@ -538,7 +621,7 @@ int nf_flow_rule_route_ipv4(struct net *net, const struct flow_offload *flow,
 	    test_bit(NF_FLOW_DNAT, &flow->flags))
 		flow_offload_ipv4_checksum(net, flow, flow_rule);
 
-	flow_offload_redirect(flow, dir, flow_rule);
+	flow_offload_redirect(net, flow, dir, flow_rule);
 
 	return 0;
 }
@@ -548,11 +631,7 @@ int nf_flow_rule_route_ipv6(struct net *net, const struct flow_offload *flow,
 			    enum flow_offload_tuple_dir dir,
 			    struct nf_flow_rule *flow_rule)
 {
-	flow_offload_decap_tunnel(flow, dir, flow_rule);
-	flow_offload_encap_tunnel(flow, dir, flow_rule);
-
-	if (flow_offload_eth_src(net, flow, dir, flow_rule) < 0 ||
-	    flow_offload_eth_dst(net, flow, dir, flow_rule) < 0)
+	if (nf_flow_rule_route_common(net, flow, dir, flow_rule) < 0)
 		return -1;
 
 	if (test_bit(NF_FLOW_SNAT, &flow->flags)) {
@@ -564,7 +643,7 @@ int nf_flow_rule_route_ipv6(struct net *net, const struct flow_offload *flow,
 		flow_offload_port_dnat(net, flow, dir, flow_rule);
 	}
 
-	flow_offload_redirect(flow, dir, flow_rule);
+	flow_offload_redirect(net, flow, dir, flow_rule);
 
 	return 0;
 }
@@ -578,10 +657,10 @@ nf_flow_offload_rule_alloc(struct net *net,
 			   enum flow_offload_tuple_dir dir)
 {
 	const struct nf_flowtable *flowtable = offload->flowtable;
+	const struct flow_offload_tuple *tuple, *other_tuple;
 	const struct flow_offload *flow = offload->flow;
-	const struct flow_offload_tuple *tuple;
+	struct dst_entry *other_dst = NULL;
 	struct nf_flow_rule *flow_rule;
-	struct dst_entry *other_dst;
 	int err = -ENOMEM;
 
 	flow_rule = kzalloc(sizeof(*flow_rule), GFP_KERNEL);
@@ -597,7 +676,10 @@ nf_flow_offload_rule_alloc(struct net *net,
 	flow_rule->rule->match.key = &flow_rule->match.key;
 
 	tuple = &flow->tuplehash[dir].tuple;
-	other_dst = flow->tuplehash[!dir].tuple.dst_cache;
+	other_tuple = &flow->tuplehash[!dir].tuple;
+	if (other_tuple->xmit_type == FLOW_OFFLOAD_XMIT_NEIGH)
+		other_dst = other_tuple->dst_cache;
+
 	err = nf_flow_rule_match(&flow_rule->match, tuple, other_dst);
 	if (err < 0)
 		goto err_flow_match;
-- 
2.20.1

