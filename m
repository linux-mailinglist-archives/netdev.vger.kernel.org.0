Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF3F28E9B6
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 03:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731800AbgJOBQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 21:16:57 -0400
Received: from correo.us.es ([193.147.175.20]:38752 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387422AbgJOBQy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 21:16:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 90074DA805
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 03:16:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7C30CDA78C
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 03:16:45 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7111FDA73F; Thu, 15 Oct 2020 03:16:45 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 54D14DA722;
        Thu, 15 Oct 2020 03:16:43 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 15 Oct 2020 03:16:43 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 2BD0741FF201;
        Thu, 15 Oct 2020 03:16:43 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 7/9] netfilter: flowtable: add direct xmit path
Date:   Thu, 15 Oct 2020 03:16:28 +0200
Message-Id: <20201015011630.2399-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201015011630.2399-1-pablo@netfilter.org>
References: <20201015011630.2399-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add FLOW_OFFLOAD_XMIT_DIRECT to turn on the direct dev_queue_xmit() path
to transmit ethernet frames. Cache the source and destination hardware
address for flow to use dev_queue_xmit() to transfer packets.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h |  5 +++++
 net/netfilter/nf_flow_table_core.c    |  2 ++
 net/netfilter/nf_flow_table_ip.c      | 24 ++++++++++++++++++++++++
 net/netfilter/nft_flow_offload.c      | 16 +++++++++++-----
 4 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index fe225e881cc7..1b57d1d1270d 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -92,6 +92,7 @@ enum flow_offload_tuple_dir {
 enum flow_offload_xmit_type {
 	FLOW_OFFLOAD_XMIT_NEIGH		= 0,
 	FLOW_OFFLOAD_XMIT_XFRM,
+	FLOW_OFFLOAD_XMIT_DIRECT,
 };
 
 struct flow_offload_tuple {
@@ -119,6 +120,8 @@ struct flow_offload_tuple {
 	u16				mtu;
 	u32				oifidx;
 
+	u8				h_source[ETH_ALEN];
+	u8				h_dest[ETH_ALEN];
 	struct dst_entry		*dst_cache;
 };
 
@@ -167,6 +170,8 @@ struct nf_flow_route {
 		} in;
 		struct {
 			u32		ifindex;
+			u8		h_source[ETH_ALEN];
+			u8		h_dest[ETH_ALEN];
 		} out;
 		struct dst_entry	*dst;
 	} tuple[FLOW_OFFLOAD_DIR_MAX];
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 99f01f08c550..725366339b85 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -94,6 +94,8 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 	}
 
 	flow_tuple->iifidx = route->tuple[dir].in.ifindex;
+	memcpy(flow_tuple->h_dest, route->tuple[dir].out.h_dest, ETH_ALEN);
+	memcpy(flow_tuple->h_source, route->tuple[dir].out.h_source, ETH_ALEN);
 	flow_tuple->oifidx = route->tuple[dir].out.ifindex;
 
 	if (dst_xfrm(dst))
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 92f444db8d9f..1fa5c67cd914 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -247,6 +247,24 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 	return NF_STOLEN;
 }
 
+static unsigned int nf_flow_queue_xmit(struct sk_buff *skb,
+				       struct net_device *outdev,
+				       const struct flow_offload_tuple *tuple)
+{
+	struct ethhdr *eth;
+
+	skb->dev = outdev;
+	skb_push(skb, skb->mac_len);
+	skb_reset_mac_header(skb);
+
+	eth = eth_hdr(skb);
+	memcpy(eth->h_source, tuple->h_source, ETH_ALEN);
+	memcpy(eth->h_dest, tuple->h_dest, ETH_ALEN);
+	dev_queue_xmit(skb);
+
+	return NF_STOLEN;
+}
+
 unsigned int
 nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 			const struct nf_hook_state *state)
@@ -325,6 +343,9 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 		IPCB(skb)->flags = IPSKB_FORWARDED;
 		ret = nf_flow_xmit_xfrm(skb, state, &rt->dst);
 		break;
+	case FLOW_OFFLOAD_XMIT_DIRECT:
+		ret = nf_flow_queue_xmit(skb, outdev, &tuplehash->tuple);
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		ret = NF_DROP;
@@ -581,6 +602,9 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 		IP6CB(skb)->flags = IP6SKB_FORWARDED;
 		ret = nf_flow_xmit_xfrm(skb, state, &rt->dst);
 		break;
+	case FLOW_OFFLOAD_XMIT_DIRECT:
+		ret = nf_flow_queue_xmit(skb, outdev, &tuplehash->tuple);
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		ret = NF_DROP;
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 6a6633e2ceeb..d440e436cb16 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -21,12 +21,11 @@ struct nft_flow_offload {
 
 static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 				     const struct nf_conn *ct,
-				     enum ip_conntrack_dir dir,
+				     enum ip_conntrack_dir dir, u8 *dst,
 				     struct net_device_path_stack *stack)
 {
 	const struct dst_entry *dst_cache = route->tuple[dir].dst;
 	const void *daddr = &ct->tuplehash[!dir].tuple.src.u3;
-	unsigned char ha[ETH_ALEN];
 	struct net_device *dev;
 	struct neighbour *n;
 	struct rtable *rt;
@@ -41,18 +40,20 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 
 	read_lock_bh(&n->lock);
 	nud_state = n->nud_state;
-	ether_addr_copy(ha, n->ha);
+	ether_addr_copy(dst, n->ha);
 	read_unlock_bh(&n->lock);
 	neigh_release(n);
 
 	if (!(nud_state & NUD_VALID))
 		return -1;
 
-	return dev_fill_forward_path(dev, ha, stack);
+	return dev_fill_forward_path(dev, dst, stack);
 }
 
 struct nft_forward_info {
 	u32 iifindex;
+	u8 h_source[ETH_ALEN];
+	u8 h_dest[ETH_ALEN];
 };
 
 static int nft_dev_forward_path(struct nf_flow_route *route,
@@ -62,11 +63,12 @@ static int nft_dev_forward_path(struct nf_flow_route *route,
 	struct net_device_path_stack stack = {};
 	struct nft_forward_info info = {};
 	struct net_device_path *path;
+	unsigned char dst[ETH_ALEN];
 	int i, ret;
 
 	memset(&stack, 0, sizeof(stack));
 
-	ret = nft_dev_fill_forward_path(route, ct, dir, &stack);
+	ret = nft_dev_fill_forward_path(route, ct, dir, dst, &stack);
 	if (ret < 0)
 		return -1;
 
@@ -74,6 +76,8 @@ static int nft_dev_forward_path(struct nf_flow_route *route,
 		path = &stack.path[i];
 		switch (path->type) {
 		case DEV_PATH_ETHERNET:
+			memcpy(info.h_dest, path->dev->dev_addr, ETH_ALEN);
+			memcpy(info.h_source, dst, ETH_ALEN);
 			info.iifindex = path->dev->ifindex;
 			break;
 		case DEV_PATH_VLAN:
@@ -84,6 +88,8 @@ static int nft_dev_forward_path(struct nf_flow_route *route,
 	}
 
 	route->tuple[!dir].in.ifindex = info.iifindex;
+	memcpy(route->tuple[dir].out.h_dest, info.h_source, ETH_ALEN);
+	memcpy(route->tuple[dir].out.h_source, info.h_dest, ETH_ALEN);
 	route->tuple[dir].out.ifindex = info.iifindex;
 
 	return 0;
-- 
2.20.1

