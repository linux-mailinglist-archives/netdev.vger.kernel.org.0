Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9BA50D2C
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731792AbfFXOBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:01:15 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:43708 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbfFXOBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 10:01:12 -0400
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id 12D6A2D4ABA;
        Mon, 24 Jun 2019 16:01:10 +0200 (CEST)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.89)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1hfPWv-0003zl-UK; Mon, 24 Jun 2019 16:01:09 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ndesaulniers@google.com,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net v2 1/2] ipv6: constify rt6_nexthop()
Date:   Mon, 24 Jun 2019 16:01:08 +0200
Message-Id: <20190624140109.14775-2-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190624140109.14775-1-nicolas.dichtel@6wind.com>
References: <20190622.170816.1879839685931480272.davem@davemloft.net>
 <20190624140109.14775-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no functional change in this patch, it only prepares the next one.

rt6_nexthop() will be used by ip6_dst_lookup_neigh(), which uses const
variables.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 drivers/net/vrf.c                | 2 +-
 include/net/ip6_route.h          | 4 ++--
 net/bluetooth/6lowpan.c          | 4 ++--
 net/ipv6/ip6_output.c            | 2 +-
 net/netfilter/nf_flow_table_ip.c | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 11b9525dff27..311b0cc6eb98 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -350,8 +350,8 @@ static int vrf_finish_output6(struct net *net, struct sock *sk,
 {
 	struct dst_entry *dst = skb_dst(skb);
 	struct net_device *dev = dst->dev;
+	const struct in6_addr *nexthop;
 	struct neighbour *neigh;
-	struct in6_addr *nexthop;
 	int ret;
 
 	nf_reset(skb);
diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 4790beaa86e0..ee7405e759ba 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -262,8 +262,8 @@ static inline bool ip6_sk_ignore_df(const struct sock *sk)
 	       inet6_sk(sk)->pmtudisc == IPV6_PMTUDISC_OMIT;
 }
 
-static inline struct in6_addr *rt6_nexthop(struct rt6_info *rt,
-					   struct in6_addr *daddr)
+static inline const struct in6_addr *rt6_nexthop(const struct rt6_info *rt,
+						 const struct in6_addr *daddr)
 {
 	if (rt->rt6i_flags & RTF_GATEWAY)
 		return &rt->rt6i_gateway;
diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 19d27bee285e..1555b0c6f7ec 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -160,10 +160,10 @@ static inline struct lowpan_peer *peer_lookup_dst(struct lowpan_btle_dev *dev,
 						  struct in6_addr *daddr,
 						  struct sk_buff *skb)
 {
-	struct lowpan_peer *peer;
-	struct in6_addr *nexthop;
 	struct rt6_info *rt = (struct rt6_info *)skb_dst(skb);
 	int count = atomic_read(&dev->peer_count);
+	const struct in6_addr *nexthop;
+	struct lowpan_peer *peer;
 
 	BT_DBG("peers %d addr %pI6c rt %p", count, daddr, rt);
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 834475717110..21efcd02f337 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -59,8 +59,8 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 {
 	struct dst_entry *dst = skb_dst(skb);
 	struct net_device *dev = dst->dev;
+	const struct in6_addr *nexthop;
 	struct neighbour *neigh;
-	struct in6_addr *nexthop;
 	int ret;
 
 	if (ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr)) {
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 241317473114..cdfc33517e85 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -439,9 +439,9 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	struct nf_flowtable *flow_table = priv;
 	struct flow_offload_tuple tuple = {};
 	enum flow_offload_tuple_dir dir;
+	const struct in6_addr *nexthop;
 	struct flow_offload *flow;
 	struct net_device *outdev;
-	struct in6_addr *nexthop;
 	struct ipv6hdr *ip6h;
 	struct rt6_info *rt;
 
-- 
2.21.0

