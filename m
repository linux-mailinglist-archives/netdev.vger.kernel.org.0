Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C9E2AF929
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 20:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbgKKTiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 14:38:16 -0500
Received: from correo.us.es ([193.147.175.20]:45198 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbgKKTiK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 14:38:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C244D1878CC
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 20:38:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B061BDA72F
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 20:38:05 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A5E3FDA852; Wed, 11 Nov 2020 20:38:05 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0DFBCDA844;
        Wed, 11 Nov 2020 20:38:03 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 11 Nov 2020 20:38:03 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id C1CE542EF9E1;
        Wed, 11 Nov 2020 20:38:02 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        razor@blackwall.org, jeremy@azazel.net
Subject: [PATCH net-next,v3 8/9] netfilter: flowtable: add vlan support
Date:   Wed, 11 Nov 2020 20:37:36 +0100
Message-Id: <20201111193737.1793-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201111193737.1793-1-pablo@netfilter.org>
References: <20201111193737.1793-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the vlan id and protocol to the flow tuple to uniquely identify
flows from the receive path. For the transmit path, dev_hard_header() on
the vlan device push the headers. This patch includes support for two
VLAN headers (QinQ) from the ingress path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h |  15 +++-
 net/netfilter/nf_flow_table_core.c    |   6 ++
 net/netfilter/nf_flow_table_ip.c      | 108 +++++++++++++++++++++-----
 net/netfilter/nft_flow_offload.c      |  25 +++++-
 4 files changed, 131 insertions(+), 23 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 83110e4705c0..e65bbbd982cb 100644
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
@@ -113,13 +115,17 @@ struct flow_offload_tuple {
 
 	u8				l3proto;
 	u8				l4proto;
+	struct {
+		u16			id;
+		__be16			proto;
+	} in_vlan[NF_FLOW_TABLE_VLAN_MAX];
 
 	/* All members above are keys for lookups, see flow_offload_hash(). */
 	struct { }			__hash;
 
-	u8				dir:6,
-					xmit_type:2;
-
+	u8				dir:4,
+					xmit_type:2,
+					in_vlan_num:2;
 	u16				mtu;
 	union {
 		struct dst_entry	*dst_cache;
@@ -174,6 +180,9 @@ struct nf_flow_route {
 		struct dst_entry		*dst;
 		struct {
 			u32			ifindex;
+			u16			vid[NF_FLOW_TABLE_VLAN_MAX];
+			__be16			vproto[NF_FLOW_TABLE_VLAN_MAX];
+			u8			num_vlans;
 		} in;
 		struct {
 			u32			ifindex;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 751bc1c27c16..c4322aeb3557 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -80,6 +80,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 {
 	struct flow_offload_tuple *flow_tuple = &flow->tuplehash[dir].tuple;
 	struct dst_entry *dst = route->tuple[dir].dst;
+	int i;
 
 	switch (flow_tuple->l3proto) {
 	case NFPROTO_IPV4:
@@ -91,6 +92,11 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 	}
 
 	flow_tuple->iifidx = route->tuple[dir].in.ifindex;
+	for (i = 0; i < route->tuple[dir].in.num_vlans; i++) {
+		flow_tuple->in_vlan[i].id = route->tuple[dir].in.vid[i];
+		flow_tuple->in_vlan[i].proto = route->tuple[dir].in.vproto[i];
+	}
+	flow_tuple->in_vlan_num = route->tuple[dir].in.num_vlans;
 
 	switch (route->tuple[dir].xmit_type) {
 	case FLOW_OFFLOAD_XMIT_DIRECT:
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index d10ba09a41b5..c1604de1612c 100644
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
+	if (skb->protocol == htons(ETH_P_8021Q)) {
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
+	if (skb->protocol == htons(ETH_P_8021Q))
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
@@ -248,6 +267,37 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
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
 static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
 				       const struct flow_offload_tuple_rhash *tuplehash,
 				       unsigned short type)
@@ -280,9 +330,11 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
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
@@ -298,11 +350,15 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)))
 		return NF_ACCEPT;
 
-	if (skb_try_make_writable(skb, sizeof(*iph)))
+	if (skb->protocol == htons(ETH_P_8021Q))
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
@@ -312,6 +368,9 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 		return NF_ACCEPT;
 	}
 
+	nf_flow_vlan_pop(skb, tuplehash);
+	thoff -= offset;
+
 	if (nf_flow_nat_ip(flow, skb, thoff, dir) < 0)
 		return NF_DROP;
 
@@ -479,14 +538,17 @@ static int nf_flow_nat_ipv6(const struct flow_offload *flow,
 static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 			      struct flow_offload_tuple *tuple)
 {
-	unsigned int thoff, hdrsize;
+	unsigned int thoff, hdrsize, offset = 0;
 	struct flow_ports *ports;
 	struct ipv6hdr *ip6h;
 
-	if (!pskb_may_pull(skb, sizeof(*ip6h)))
+	if (skb->protocol == htons(ETH_P_8021Q))
+		offset += VLAN_HLEN;
+
+	if (!pskb_may_pull(skb, sizeof(*ip6h) + offset))
 		return -1;
 
-	ip6h = ipv6_hdr(skb);
+	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
 
 	switch (ip6h->nexthdr) {
 	case IPPROTO_TCP:
@@ -503,11 +565,11 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
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
@@ -516,6 +578,7 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 	tuple->l3proto		= AF_INET6;
 	tuple->l4proto		= ip6h->nexthdr;
 	tuple->iifidx		= dev->ifindex;
+	nf_flow_tuple_vlan(skb, tuple);
 
 	return 0;
 }
@@ -533,9 +596,11 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
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
@@ -551,8 +616,11 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)))
 		return NF_ACCEPT;
 
-	if (nf_flow_state_check(flow, ipv6_hdr(skb)->nexthdr, skb,
-				sizeof(*ip6h)))
+	if (skb->protocol == htons(ETH_P_8021Q))
+		offset += VLAN_HLEN;
+
+	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
+	if (nf_flow_state_check(flow, ip6h->nexthdr, skb, sizeof(*ip6h)))
 		return NF_ACCEPT;
 
 	flow_offload_refresh(flow_table, flow);
@@ -562,6 +630,8 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 		return NF_ACCEPT;
 	}
 
+	nf_flow_vlan_pop(skb, tuplehash);
+
 	if (skb_try_make_writable(skb, sizeof(*ip6h)))
 		return NF_DROP;
 
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 849fc40786cf..60c250384106 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -65,6 +65,10 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 
 struct nft_forward_info {
 	const struct net_device *indev;
+	const struct net_device *vlandev;
+	__u16 vid[NF_FLOW_TABLE_VLAN_MAX];
+	__be16 vproto[NF_FLOW_TABLE_VLAN_MAX];
+	u8 num_vlans;
 	u8 h_source[ETH_ALEN];
 	u8 h_dest[ETH_ALEN];
 	enum flow_offload_xmit_type xmit_type;
@@ -86,6 +90,16 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 			memcpy(info->h_source, ha, ETH_ALEN);
 			break;
 		case DEV_PATH_VLAN:
+			if (info->num_vlans >= NF_FLOW_TABLE_VLAN_MAX) {
+				info->indev = NULL;
+				break;
+			}
+			if (!info->vlandev)
+				info->vlandev = path->dev;
+
+			info->vid[info->num_vlans] = path->vlan.id;
+			info->vproto[info->num_vlans] = path->vlan.proto;
+			info->num_vlans++;
 			break;
 		case DEV_PATH_BRIDGE:
 			memcpy(info->h_dest, path->dev->dev_addr, ETH_ALEN);
@@ -121,6 +135,7 @@ static void nft_dev_forward_path(struct nf_flow_route *route,
 	struct net_device_path_stack stack = {};
 	struct nft_forward_info info = {};
 	unsigned char ha[ETH_ALEN];
+	int i;
 
 	if (nft_dev_fill_forward_path(route, dst, ct, dir, ha, &stack) >= 0)
 		nft_dev_path_info(&stack, &info, ha);
@@ -129,11 +144,19 @@ static void nft_dev_forward_path(struct nf_flow_route *route,
 		return;
 
 	route->tuple[!dir].in.ifindex = info.indev->ifindex;
+	for (i = 0; i < info.num_vlans; i++) {
+		route->tuple[!dir].in.vid[i] = info.vid[i];
+		route->tuple[!dir].in.vproto[i] = info.vproto[i];
+	}
+	route->tuple[!dir].in.num_vlans = info.num_vlans;
 
 	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT) {
 		memcpy(route->tuple[dir].out.h_dest, info.h_source, ETH_ALEN);
 		memcpy(route->tuple[dir].out.h_source, info.h_dest, ETH_ALEN);
-		route->tuple[dir].out.ifindex = info.indev->ifindex;
+		if (info.vlandev)
+			route->tuple[dir].out.ifindex = info.vlandev->ifindex;
+		else
+			route->tuple[dir].out.ifindex = info.indev->ifindex;
 		route->tuple[dir].xmit_type = info.xmit_type;
 	}
 }
-- 
2.20.1

