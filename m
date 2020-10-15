Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8045528E9C2
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 03:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387741AbgJOBR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 21:17:26 -0400
Received: from correo.us.es ([193.147.175.20]:38754 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387621AbgJOBQ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 21:16:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CB507DA7F2
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 03:16:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B1655DA78A
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 03:16:46 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A6BF0DA73D; Thu, 15 Oct 2020 03:16:46 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5032CDA704;
        Thu, 15 Oct 2020 03:16:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 15 Oct 2020 03:16:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 2651441FF201;
        Thu, 15 Oct 2020 03:16:44 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 9/9] netfilter: flowtable: add vlan support
Date:   Thu, 15 Oct 2020 03:16:30 +0200
Message-Id: <20201015011630.2399-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201015011630.2399-1-pablo@netfilter.org>
References: <20201015011630.2399-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the vlan id and proto to the flow tuple to uniquely identify flows
from the receive path. Store the vlan id and proto to set it accordingly
from the transmit path. This patch includes support for two VLAN headers
(Q-in-Q).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h |  21 +++-
 net/netfilter/nf_flow_table_core.c    |  13 +++
 net/netfilter/nf_flow_table_ip.c      | 148 ++++++++++++++++++++++----
 net/netfilter/nft_flow_offload.c      |  23 +++-
 4 files changed, 184 insertions(+), 21 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 4ec3f9bb2f32..ed7a610d10bc 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -95,6 +95,8 @@ enum flow_offload_xmit_type {
 	FLOW_OFFLOAD_XMIT_DIRECT,
 };
 
+#define NF_FLOW_TABLE_VLAN_MAX	2
+
 struct flow_offload_tuple {
 	union {
 		struct in_addr		src_v4;
@@ -113,13 +115,24 @@ struct flow_offload_tuple {
 
 	u8				l3proto;
 	u8				l4proto;
+	struct {
+		u16			id;
+		__be16			proto;
+	} in_vlan[NF_FLOW_TABLE_VLAN_MAX];
 
 	/* All members above are keys for lookups, see flow_offload_hash(). */
 	u8				dir;
-	enum flow_offload_xmit_type	xmit_type:8;
+	enum flow_offload_xmit_type	xmit_type:6,
+					in_vlan_num:2;
 	u16				mtu;
 	u32				oifidx;
 
+	struct {
+		u16			id;
+		__be16			proto;
+	} out_vlan[NF_FLOW_TABLE_VLAN_MAX];
+	u8				out_vlan_num;
+
 	u8				h_source[ETH_ALEN];
 	u8				h_dest[ETH_ALEN];
 	struct dst_entry		*dst_cache;
@@ -167,11 +180,17 @@ struct nf_flow_route {
 	struct {
 		struct {
 			u32		ifindex;
+			u16		vid[NF_FLOW_TABLE_VLAN_MAX];
+			__be16		vproto[NF_FLOW_TABLE_VLAN_MAX];
+			u8		num_vlans;
 		} in;
 		struct {
 			u32		ifindex;
 			u8		h_source[ETH_ALEN];
 			u8		h_dest[ETH_ALEN];
+			u16		vid[NF_FLOW_TABLE_VLAN_MAX];
+			__be16		vproto[NF_FLOW_TABLE_VLAN_MAX];
+			u8		num_vlans;
 			enum flow_offload_xmit_type xmit_type;
 		} out;
 		struct dst_entry	*dst;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index e80dcabe3668..c486c9b489e0 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -80,6 +80,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 {
 	struct flow_offload_tuple *flow_tuple = &flow->tuplehash[dir].tuple;
 	struct dst_entry *dst = route->tuple[dir].dst;
+	int i;
 
 	if (!dst_hold_safe(route->tuple[dir].dst))
 		return -1;
@@ -98,6 +99,18 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 	memcpy(flow_tuple->h_source, route->tuple[dir].out.h_source, ETH_ALEN);
 	flow_tuple->oifidx = route->tuple[dir].out.ifindex;
 
+	for (i = 0; i < route->tuple[dir].in.num_vlans; i++) {
+		flow_tuple->in_vlan[i].id = route->tuple[dir].in.vid[i];
+		flow_tuple->in_vlan[i].proto = route->tuple[dir].in.vproto[i];
+	}
+	flow_tuple->in_vlan_num = route->tuple[dir].in.num_vlans;
+
+	for (i = 0; i < route->tuple[dir].out.num_vlans; i++) {
+		flow_tuple->out_vlan[i].id = route->tuple[dir].out.vid[i];
+		flow_tuple->out_vlan[i].proto = route->tuple[dir].out.vproto[i];
+	}
+	flow_tuple->out_vlan_num = route->tuple[dir].out.num_vlans;
+
 	if (dst_xfrm(dst))
 		flow_tuple->xmit_type = FLOW_OFFLOAD_XMIT_XFRM;
 	else
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 1fa5c67cd914..f2d7ba6aad3c 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -159,17 +159,35 @@ static bool ip_has_options(unsigned int thoff)
 	return thoff != sizeof(struct iphdr);
 }
 
+static void nf_flow_tuple_vlan(struct sk_buff *skb,
+			       struct flow_offload_tuple *tuple)
+{
+	if (skb_vlan_tag_present(skb)) {
+		tuple->in_vlan[0].id = skb_vlan_tag_get(skb);
+		tuple->in_vlan[0].proto = skb->vlan_proto;
+	}
+	if (skb->protocol == ntohs(ETH_P_8021Q)) {
+		struct vlan_ethhdr *veth = (struct vlan_ethhdr *)skb_mac_header(skb);
+
+		tuple->in_vlan[1].id = ntohs(veth->h_vlan_TCI);
+		tuple->in_vlan[1].proto = skb->protocol;
+	}
+}
+
 static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
 			    struct flow_offload_tuple *tuple)
 {
-	unsigned int thoff, hdrsize;
+	unsigned int thoff, hdrsize, offset = 0;
 	struct flow_ports *ports;
 	struct iphdr *iph;
 
-	if (!pskb_may_pull(skb, sizeof(*iph)))
+	if (skb->protocol == ntohs(ETH_P_8021Q))
+		offset += VLAN_HLEN;
+
+	if (!pskb_may_pull(skb, sizeof(*iph) + offset))
 		return -1;
 
-	iph = ip_hdr(skb);
+	iph = (struct iphdr *)(skb_network_header(skb) + offset);
 	thoff = iph->ihl * 4;
 
 	if (ip_is_fragment(iph) ||
@@ -191,11 +209,11 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
 		return -1;
 
 	thoff = iph->ihl * 4;
-	if (!pskb_may_pull(skb, thoff + hdrsize))
+	if (!pskb_may_pull(skb, thoff + hdrsize + offset))
 		return -1;
 
-	iph = ip_hdr(skb);
-	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
+	iph = (struct iphdr *)(skb_network_header(skb) + offset);
+	ports = (struct flow_ports *)(skb_network_header(skb) + thoff + offset);
 
 	tuple->src_v4.s_addr	= iph->saddr;
 	tuple->dst_v4.s_addr	= iph->daddr;
@@ -204,6 +222,7 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
 	tuple->l3proto		= AF_INET;
 	tuple->l4proto		= iph->protocol;
 	tuple->iifidx		= dev->ifindex;
+	nf_flow_tuple_vlan(skb, tuple);
 
 	return 0;
 }
@@ -247,6 +266,67 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 	return NF_STOLEN;
 }
 
+static bool nf_flow_skb_vlan_protocol(const struct sk_buff *skb, __be16 proto)
+{
+	if (skb->protocol == htons(ETH_P_8021Q)) {
+		struct vlan_ethhdr *veth;
+
+		veth = (struct vlan_ethhdr *)skb_mac_header(skb);
+		if (veth->h_vlan_encapsulated_proto == proto)
+			return true;
+	}
+
+	return false;
+}
+
+static void nf_flow_vlan_pop(struct sk_buff *skb,
+			     struct flow_offload_tuple_rhash *tuplehash)
+{
+	struct vlan_hdr *vlan_hdr;
+	int i;
+
+	for (i = 0; i < tuplehash->tuple.in_vlan_num; i++) {
+		if (skb_vlan_tag_present(skb)) {
+			__vlan_hwaccel_clear_tag(skb);
+			continue;
+		}
+		vlan_hdr = (struct vlan_hdr *)skb->data;
+		__skb_pull(skb, VLAN_HLEN);
+		vlan_set_encap_proto(skb, vlan_hdr);
+		skb_reset_network_header(skb);
+	}
+}
+
+static int __nf_flow_vlan_push(struct sk_buff *skb,
+			       const struct flow_offload_tuple *tuple)
+{
+	int i;
+
+	for (i = tuple->out_vlan_num - 1; i >= 0; i--) {
+		if (skb_vlan_push(skb, tuple->out_vlan[i].proto,
+				  tuple->out_vlan[i].id) < 0)
+			return -1;
+	}
+
+	return 0;
+}
+
+static int nf_flow_vlan_push(struct sk_buff *skb,
+			     const struct flow_offload_tuple *tuple)
+{
+	if (tuple->out_vlan_num > 1)
+		skb_push(skb, skb->mac_len);
+
+	__nf_flow_vlan_push(skb, tuple);
+
+	if (tuple->out_vlan_num > 1) {
+		__skb_pull(skb, skb->mac_len - VLAN_HLEN);
+		skb_reset_network_header(skb);
+	}
+
+	return 0;
+}
+
 static unsigned int nf_flow_queue_xmit(struct sk_buff *skb,
 				       struct net_device *outdev,
 				       const struct flow_offload_tuple *tuple)
@@ -257,6 +337,10 @@ static unsigned int nf_flow_queue_xmit(struct sk_buff *skb,
 	skb_push(skb, skb->mac_len);
 	skb_reset_mac_header(skb);
 
+	if (tuple->out_vlan_num > 0 &&
+	    __nf_flow_vlan_push(skb, tuple) < 0)
+		return NF_DROP;
+
 	eth = eth_hdr(skb);
 	memcpy(eth->h_source, tuple->h_source, ETH_ALEN);
 	memcpy(eth->h_dest, tuple->h_dest, ETH_ALEN);
@@ -279,9 +363,11 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	unsigned int thoff;
 	struct iphdr *iph;
 	__be32 nexthop;
+	u32 offset = 0;
 	int ret;
 
-	if (skb->protocol != htons(ETH_P_IP))
+	if (skb->protocol != htons(ETH_P_IP) &&
+	    !nf_flow_skb_vlan_protocol(skb, htons(ETH_P_IP)))
 		return NF_ACCEPT;
 
 	if (nf_flow_tuple_ip(skb, state->in, &tuple) < 0)
@@ -298,11 +384,15 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)))
 		return NF_ACCEPT;
 
-	if (skb_try_make_writable(skb, sizeof(*iph)))
+	if (skb->protocol == ntohs(ETH_P_8021Q))
+		offset += VLAN_HLEN;
+
+	if (skb_try_make_writable(skb, sizeof(*iph) + offset))
 		return NF_DROP;
 
-	thoff = ip_hdr(skb)->ihl * 4;
-	if (nf_flow_state_check(flow, ip_hdr(skb)->protocol, skb, thoff))
+	iph = (struct iphdr *)(skb_network_header(skb) + offset);
+	thoff = (iph->ihl * 4) + offset;
+	if (nf_flow_state_check(flow, iph->protocol, skb, thoff))
 		return NF_ACCEPT;
 
 	flow_offload_refresh(flow_table, flow);
@@ -319,6 +409,9 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 		return NF_ACCEPT;
 	}
 
+	nf_flow_vlan_pop(skb, tuplehash);
+	thoff -= offset;
+
 	if (nf_flow_nat_ip(flow, skb, thoff, dir) < 0)
 		return NF_DROP;
 
@@ -331,6 +424,9 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 
 	switch (tuplehash->tuple.xmit_type) {
 	case FLOW_OFFLOAD_XMIT_NEIGH:
+		if (nf_flow_vlan_push(skb, &tuplehash->tuple) < 0)
+			return NF_DROP;
+
 		skb->dev = outdev;
 		nexthop = rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr);
 		skb_dst_set_noref(skb, &rt->dst);
@@ -484,14 +580,17 @@ static int nf_flow_nat_ipv6(const struct flow_offload *flow,
 static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 			      struct flow_offload_tuple *tuple)
 {
-	unsigned int thoff, hdrsize;
+	unsigned int thoff, hdrsize, offset = 0;
 	struct flow_ports *ports;
 	struct ipv6hdr *ip6h;
 
-	if (!pskb_may_pull(skb, sizeof(*ip6h)))
+	if (skb->protocol == ntohs(ETH_P_8021Q))
+		offset += VLAN_HLEN;
+
+	if (!pskb_may_pull(skb, sizeof(*ip6h) + offset))
 		return -1;
 
-	ip6h = ipv6_hdr(skb);
+	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
 
 	switch (ip6h->nexthdr) {
 	case IPPROTO_TCP:
@@ -508,11 +607,11 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 		return -1;
 
 	thoff = sizeof(*ip6h);
-	if (!pskb_may_pull(skb, thoff + hdrsize))
+	if (!pskb_may_pull(skb, thoff + hdrsize + offset))
 		return -1;
 
-	ip6h = ipv6_hdr(skb);
-	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
+	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
+	ports = (struct flow_ports *)(skb_network_header(skb) + thoff + offset);
 
 	tuple->src_v6		= ip6h->saddr;
 	tuple->dst_v6		= ip6h->daddr;
@@ -521,6 +620,7 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 	tuple->l3proto		= AF_INET6;
 	tuple->l4proto		= ip6h->nexthdr;
 	tuple->iifidx		= dev->ifindex;
+	nf_flow_tuple_vlan(skb, tuple);
 
 	return 0;
 }
@@ -538,9 +638,11 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	struct net_device *outdev;
 	struct ipv6hdr *ip6h;
 	struct rt6_info *rt;
+	u32 offset = 0;
 	int ret;
 
-	if (skb->protocol != htons(ETH_P_IPV6))
+	if (skb->protocol != htons(ETH_P_IPV6) &&
+	    !nf_flow_skb_vlan_protocol(skb, htons(ETH_P_IPV6)))
 		return NF_ACCEPT;
 
 	if (nf_flow_tuple_ipv6(skb, state->in, &tuple) < 0)
@@ -557,8 +659,11 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)))
 		return NF_ACCEPT;
 
-	if (nf_flow_state_check(flow, ipv6_hdr(skb)->nexthdr, skb,
-				sizeof(*ip6h)))
+	if (skb->protocol == ntohs(ETH_P_8021Q))
+		offset += VLAN_HLEN;
+
+	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
+	if (nf_flow_state_check(flow, ip6h->nexthdr, skb, sizeof(*ip6h)))
 		return NF_ACCEPT;
 
 	flow_offload_refresh(flow_table, flow);
@@ -575,6 +680,8 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 		return NF_ACCEPT;
 	}
 
+	nf_flow_vlan_pop(skb, tuplehash);
+
 	if (skb_try_make_writable(skb, sizeof(*ip6h)))
 		return NF_DROP;
 
@@ -590,6 +697,9 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 
 	switch (tuplehash->tuple.xmit_type) {
 	case FLOW_OFFLOAD_XMIT_NEIGH:
+		if (nf_flow_vlan_push(skb, &tuplehash->tuple) < 0)
+			return NF_DROP;
+
 		skb->dev = outdev;
 		nexthop = rt6_nexthop(rt, &flow->tuplehash[!dir].tuple.src_v6);
 		skb_dst_set_noref(skb, &rt->dst);
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 9efb5d584290..17117893cb8c 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -51,6 +51,9 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 }
 
 struct nft_forward_info {
+	__be16 vid[NF_FLOW_TABLE_VLAN_MAX];
+	__be16 vproto[NF_FLOW_TABLE_VLAN_MAX];
+	u8 num_vlans;
 	u32 iifindex;
 	u8 h_source[ETH_ALEN];
 	u8 h_dest[ETH_ALEN];
@@ -82,7 +85,13 @@ static int nft_dev_forward_path(struct nf_flow_route *route,
 			info.iifindex = path->dev->ifindex;
 			break;
 		case DEV_PATH_VLAN:
-			return -1;
+			if (info.num_vlans >= NF_FLOW_TABLE_VLAN_MAX)
+				return -1;
+
+			info.vid[info.num_vlans] = path->vlan.id;
+			info.vproto[info.num_vlans] = path->vlan.proto;
+			info.num_vlans++;
+			break;
 		case DEV_PATH_BRIDGE:
 			memcpy(info.h_dest, path->dev->dev_addr, ETH_ALEN);
 			info.xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
@@ -96,6 +105,18 @@ static int nft_dev_forward_path(struct nf_flow_route *route,
 	route->tuple[dir].out.ifindex = info.iifindex;
 	route->tuple[dir].out.xmit_type = info.xmit_type;
 
+	for (i = 0; i < info.num_vlans; i++) {
+		route->tuple[!dir].in.vid[i] = info.vid[i];
+		route->tuple[!dir].in.vproto[i] = info.vproto[i];
+	}
+	route->tuple[!dir].in.num_vlans = info.num_vlans;
+
+	for (i = 0; i < info.num_vlans; i++) {
+		route->tuple[dir].out.vid[i] = info.vid[i];
+		route->tuple[dir].out.vproto[i] = info.vproto[i];
+	}
+	route->tuple[dir].out.num_vlans = info.num_vlans;
+
 	return 0;
 }
 
-- 
2.20.1

