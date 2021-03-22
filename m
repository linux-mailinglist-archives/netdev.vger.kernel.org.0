Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E10D34537E
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 00:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbhCVX5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 19:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbhCVX4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 19:56:48 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B7333C061574;
        Mon, 22 Mar 2021 16:56:42 -0700 (PDT)
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id F3B5A6312B;
        Tue, 23 Mar 2021 00:56:34 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 07/10] netfilter: flowtable: fast NAT functions never fail
Date:   Tue, 23 Mar 2021 00:56:25 +0100
Message-Id: <20210322235628.2204-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210322235628.2204-1-pablo@netfilter.org>
References: <20210322235628.2204-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify existing fast NAT routines by returning void. After the
skb_try_make_writable() call consolidation, these routines cannot ever
fail.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h |  12 +--
 net/netfilter/nf_flow_table_core.c    |  41 +++----
 net/netfilter/nf_flow_table_ip.c      | 147 +++++++++++---------------
 3 files changed, 84 insertions(+), 116 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index ce507251b3d8..fb165697c8a1 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -229,12 +229,12 @@ void nf_flow_table_free(struct nf_flowtable *flow_table);
 
 void flow_offload_teardown(struct flow_offload *flow);
 
-int nf_flow_snat_port(const struct flow_offload *flow,
-		      struct sk_buff *skb, unsigned int thoff,
-		      u8 protocol, enum flow_offload_tuple_dir dir);
-int nf_flow_dnat_port(const struct flow_offload *flow,
-		      struct sk_buff *skb, unsigned int thoff,
-		      u8 protocol, enum flow_offload_tuple_dir dir);
+void nf_flow_snat_port(const struct flow_offload *flow,
+		       struct sk_buff *skb, unsigned int thoff,
+		       u8 protocol, enum flow_offload_tuple_dir dir);
+void nf_flow_dnat_port(const struct flow_offload *flow,
+		       struct sk_buff *skb, unsigned int thoff,
+		       u8 protocol, enum flow_offload_tuple_dir dir);
 
 struct flow_ports {
 	__be16 source, dest;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 3bdbd962a084..8ffd3f3c288c 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -389,20 +389,17 @@ static void nf_flow_offload_work_gc(struct work_struct *work)
 	queue_delayed_work(system_power_efficient_wq, &flow_table->gc_work, HZ);
 }
 
-
-static int nf_flow_nat_port_tcp(struct sk_buff *skb, unsigned int thoff,
-				__be16 port, __be16 new_port)
+static void nf_flow_nat_port_tcp(struct sk_buff *skb, unsigned int thoff,
+				 __be16 port, __be16 new_port)
 {
 	struct tcphdr *tcph;
 
 	tcph = (void *)(skb_network_header(skb) + thoff);
 	inet_proto_csum_replace2(&tcph->check, skb, port, new_port, false);
-
-	return 0;
 }
 
-static int nf_flow_nat_port_udp(struct sk_buff *skb, unsigned int thoff,
-				__be16 port, __be16 new_port)
+static void nf_flow_nat_port_udp(struct sk_buff *skb, unsigned int thoff,
+				 __be16 port, __be16 new_port)
 {
 	struct udphdr *udph;
 
@@ -413,30 +410,24 @@ static int nf_flow_nat_port_udp(struct sk_buff *skb, unsigned int thoff,
 		if (!udph->check)
 			udph->check = CSUM_MANGLED_0;
 	}
-
-	return 0;
 }
 
-static int nf_flow_nat_port(struct sk_buff *skb, unsigned int thoff,
-			    u8 protocol, __be16 port, __be16 new_port)
+static void nf_flow_nat_port(struct sk_buff *skb, unsigned int thoff,
+			     u8 protocol, __be16 port, __be16 new_port)
 {
 	switch (protocol) {
 	case IPPROTO_TCP:
-		if (nf_flow_nat_port_tcp(skb, thoff, port, new_port) < 0)
-			return NF_DROP;
+		nf_flow_nat_port_tcp(skb, thoff, port, new_port);
 		break;
 	case IPPROTO_UDP:
-		if (nf_flow_nat_port_udp(skb, thoff, port, new_port) < 0)
-			return NF_DROP;
+		nf_flow_nat_port_udp(skb, thoff, port, new_port);
 		break;
 	}
-
-	return 0;
 }
 
-int nf_flow_snat_port(const struct flow_offload *flow,
-		      struct sk_buff *skb, unsigned int thoff,
-		      u8 protocol, enum flow_offload_tuple_dir dir)
+void nf_flow_snat_port(const struct flow_offload *flow,
+		       struct sk_buff *skb, unsigned int thoff,
+		       u8 protocol, enum flow_offload_tuple_dir dir)
 {
 	struct flow_ports *hdr;
 	__be16 port, new_port;
@@ -456,13 +447,13 @@ int nf_flow_snat_port(const struct flow_offload *flow,
 		break;
 	}
 
-	return nf_flow_nat_port(skb, thoff, protocol, port, new_port);
+	nf_flow_nat_port(skb, thoff, protocol, port, new_port);
 }
 EXPORT_SYMBOL_GPL(nf_flow_snat_port);
 
-int nf_flow_dnat_port(const struct flow_offload *flow,
-		      struct sk_buff *skb, unsigned int thoff,
-		      u8 protocol, enum flow_offload_tuple_dir dir)
+void nf_flow_dnat_port(const struct flow_offload *flow, struct sk_buff *skb,
+		       unsigned int thoff, u8 protocol,
+		       enum flow_offload_tuple_dir dir)
 {
 	struct flow_ports *hdr;
 	__be16 port, new_port;
@@ -482,7 +473,7 @@ int nf_flow_dnat_port(const struct flow_offload *flow,
 		break;
 	}
 
-	return nf_flow_nat_port(skb, thoff, protocol, port, new_port);
+	nf_flow_nat_port(skb, thoff, protocol, port, new_port);
 }
 EXPORT_SYMBOL_GPL(nf_flow_dnat_port);
 
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 0579e15c4968..714dc083f093 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -34,19 +34,17 @@ static int nf_flow_state_check(struct flow_offload *flow, int proto,
 	return 0;
 }
 
-static int nf_flow_nat_ip_tcp(struct sk_buff *skb, unsigned int thoff,
-			      __be32 addr, __be32 new_addr)
+static void nf_flow_nat_ip_tcp(struct sk_buff *skb, unsigned int thoff,
+			       __be32 addr, __be32 new_addr)
 {
 	struct tcphdr *tcph;
 
 	tcph = (void *)(skb_network_header(skb) + thoff);
 	inet_proto_csum_replace4(&tcph->check, skb, addr, new_addr, true);
-
-	return 0;
 }
 
-static int nf_flow_nat_ip_udp(struct sk_buff *skb, unsigned int thoff,
-			      __be32 addr, __be32 new_addr)
+static void nf_flow_nat_ip_udp(struct sk_buff *skb, unsigned int thoff,
+			       __be32 addr, __be32 new_addr)
 {
 	struct udphdr *udph;
 
@@ -57,31 +55,25 @@ static int nf_flow_nat_ip_udp(struct sk_buff *skb, unsigned int thoff,
 		if (!udph->check)
 			udph->check = CSUM_MANGLED_0;
 	}
-
-	return 0;
 }
 
-static int nf_flow_nat_ip_l4proto(struct sk_buff *skb, struct iphdr *iph,
-				  unsigned int thoff, __be32 addr,
-				  __be32 new_addr)
+static void nf_flow_nat_ip_l4proto(struct sk_buff *skb, struct iphdr *iph,
+				   unsigned int thoff, __be32 addr,
+				   __be32 new_addr)
 {
 	switch (iph->protocol) {
 	case IPPROTO_TCP:
-		if (nf_flow_nat_ip_tcp(skb, thoff, addr, new_addr) < 0)
-			return NF_DROP;
+		nf_flow_nat_ip_tcp(skb, thoff, addr, new_addr);
 		break;
 	case IPPROTO_UDP:
-		if (nf_flow_nat_ip_udp(skb, thoff, addr, new_addr) < 0)
-			return NF_DROP;
+		nf_flow_nat_ip_udp(skb, thoff, addr, new_addr);
 		break;
 	}
-
-	return 0;
 }
 
-static int nf_flow_snat_ip(const struct flow_offload *flow, struct sk_buff *skb,
-			   struct iphdr *iph, unsigned int thoff,
-			   enum flow_offload_tuple_dir dir)
+static void nf_flow_snat_ip(const struct flow_offload *flow,
+			    struct sk_buff *skb, struct iphdr *iph,
+			    unsigned int thoff, enum flow_offload_tuple_dir dir)
 {
 	__be32 addr, new_addr;
 
@@ -99,12 +91,12 @@ static int nf_flow_snat_ip(const struct flow_offload *flow, struct sk_buff *skb,
 	}
 	csum_replace4(&iph->check, addr, new_addr);
 
-	return nf_flow_nat_ip_l4proto(skb, iph, thoff, addr, new_addr);
+	nf_flow_nat_ip_l4proto(skb, iph, thoff, addr, new_addr);
 }
 
-static int nf_flow_dnat_ip(const struct flow_offload *flow, struct sk_buff *skb,
-			   struct iphdr *iph, unsigned int thoff,
-			   enum flow_offload_tuple_dir dir)
+static void nf_flow_dnat_ip(const struct flow_offload *flow,
+			    struct sk_buff *skb, struct iphdr *iph,
+			    unsigned int thoff, enum flow_offload_tuple_dir dir)
 {
 	__be32 addr, new_addr;
 
@@ -122,24 +114,21 @@ static int nf_flow_dnat_ip(const struct flow_offload *flow, struct sk_buff *skb,
 	}
 	csum_replace4(&iph->check, addr, new_addr);
 
-	return nf_flow_nat_ip_l4proto(skb, iph, thoff, addr, new_addr);
+	nf_flow_nat_ip_l4proto(skb, iph, thoff, addr, new_addr);
 }
 
-static int nf_flow_nat_ip(const struct flow_offload *flow, struct sk_buff *skb,
+static void nf_flow_nat_ip(const struct flow_offload *flow, struct sk_buff *skb,
 			  unsigned int thoff, enum flow_offload_tuple_dir dir,
 			  struct iphdr *iph)
 {
-	if (test_bit(NF_FLOW_SNAT, &flow->flags) &&
-	    (nf_flow_snat_port(flow, skb, thoff, iph->protocol, dir) < 0 ||
-	     nf_flow_snat_ip(flow, skb, iph, thoff, dir) < 0))
-		return -1;
-
-	if (test_bit(NF_FLOW_DNAT, &flow->flags) &&
-	    (nf_flow_dnat_port(flow, skb, thoff, iph->protocol, dir) < 0 ||
-	     nf_flow_dnat_ip(flow, skb, iph, thoff, dir) < 0))
-		return -1;
-
-	return 0;
+	if (test_bit(NF_FLOW_SNAT, &flow->flags)) {
+		nf_flow_snat_port(flow, skb, thoff, iph->protocol, dir);
+		nf_flow_snat_ip(flow, skb, iph, thoff, dir);
+	}
+	if (test_bit(NF_FLOW_DNAT, &flow->flags)) {
+		nf_flow_dnat_port(flow, skb, thoff, iph->protocol, dir);
+		nf_flow_dnat_ip(flow, skb, iph, thoff, dir);
+	}
 }
 
 static bool ip_has_options(unsigned int thoff)
@@ -276,8 +265,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 		return NF_DROP;
 
 	iph = ip_hdr(skb);
-	if (nf_flow_nat_ip(flow, skb, thoff, dir, iph) < 0)
-		return NF_DROP;
+	nf_flow_nat_ip(flow, skb, thoff, dir, iph);
 
 	ip_decrease_ttl(iph);
 	skb->tstamp = 0;
@@ -301,22 +289,21 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 }
 EXPORT_SYMBOL_GPL(nf_flow_offload_ip_hook);
 
-static int nf_flow_nat_ipv6_tcp(struct sk_buff *skb, unsigned int thoff,
-				struct in6_addr *addr,
-				struct in6_addr *new_addr)
+static void nf_flow_nat_ipv6_tcp(struct sk_buff *skb, unsigned int thoff,
+				 struct in6_addr *addr,
+				 struct in6_addr *new_addr,
+				 struct ipv6hdr *ip6h)
 {
 	struct tcphdr *tcph;
 
 	tcph = (void *)(skb_network_header(skb) + thoff);
 	inet_proto_csum_replace16(&tcph->check, skb, addr->s6_addr32,
 				  new_addr->s6_addr32, true);
-
-	return 0;
 }
 
-static int nf_flow_nat_ipv6_udp(struct sk_buff *skb, unsigned int thoff,
-				struct in6_addr *addr,
-				struct in6_addr *new_addr)
+static void nf_flow_nat_ipv6_udp(struct sk_buff *skb, unsigned int thoff,
+				 struct in6_addr *addr,
+				 struct in6_addr *new_addr)
 {
 	struct udphdr *udph;
 
@@ -327,32 +314,26 @@ static int nf_flow_nat_ipv6_udp(struct sk_buff *skb, unsigned int thoff,
 		if (!udph->check)
 			udph->check = CSUM_MANGLED_0;
 	}
-
-	return 0;
 }
 
-static int nf_flow_nat_ipv6_l4proto(struct sk_buff *skb, struct ipv6hdr *ip6h,
-				    unsigned int thoff, struct in6_addr *addr,
-				    struct in6_addr *new_addr)
+static void nf_flow_nat_ipv6_l4proto(struct sk_buff *skb, struct ipv6hdr *ip6h,
+				     unsigned int thoff, struct in6_addr *addr,
+				     struct in6_addr *new_addr)
 {
 	switch (ip6h->nexthdr) {
 	case IPPROTO_TCP:
-		if (nf_flow_nat_ipv6_tcp(skb, thoff, addr, new_addr) < 0)
-			return NF_DROP;
+		nf_flow_nat_ipv6_tcp(skb, thoff, addr, new_addr, ip6h);
 		break;
 	case IPPROTO_UDP:
-		if (nf_flow_nat_ipv6_udp(skb, thoff, addr, new_addr) < 0)
-			return NF_DROP;
+		nf_flow_nat_ipv6_udp(skb, thoff, addr, new_addr);
 		break;
 	}
-
-	return 0;
 }
 
-static int nf_flow_snat_ipv6(const struct flow_offload *flow,
-			     struct sk_buff *skb, struct ipv6hdr *ip6h,
-			     unsigned int thoff,
-			     enum flow_offload_tuple_dir dir)
+static void nf_flow_snat_ipv6(const struct flow_offload *flow,
+			      struct sk_buff *skb, struct ipv6hdr *ip6h,
+			      unsigned int thoff,
+			      enum flow_offload_tuple_dir dir)
 {
 	struct in6_addr addr, new_addr;
 
@@ -369,13 +350,13 @@ static int nf_flow_snat_ipv6(const struct flow_offload *flow,
 		break;
 	}
 
-	return nf_flow_nat_ipv6_l4proto(skb, ip6h, thoff, &addr, &new_addr);
+	nf_flow_nat_ipv6_l4proto(skb, ip6h, thoff, &addr, &new_addr);
 }
 
-static int nf_flow_dnat_ipv6(const struct flow_offload *flow,
-			     struct sk_buff *skb, struct ipv6hdr *ip6h,
-			     unsigned int thoff,
-			     enum flow_offload_tuple_dir dir)
+static void nf_flow_dnat_ipv6(const struct flow_offload *flow,
+			      struct sk_buff *skb, struct ipv6hdr *ip6h,
+			      unsigned int thoff,
+			      enum flow_offload_tuple_dir dir)
 {
 	struct in6_addr addr, new_addr;
 
@@ -392,27 +373,24 @@ static int nf_flow_dnat_ipv6(const struct flow_offload *flow,
 		break;
 	}
 
-	return nf_flow_nat_ipv6_l4proto(skb, ip6h, thoff, &addr, &new_addr);
+	nf_flow_nat_ipv6_l4proto(skb, ip6h, thoff, &addr, &new_addr);
 }
 
-static int nf_flow_nat_ipv6(const struct flow_offload *flow,
-			    struct sk_buff *skb,
-			    enum flow_offload_tuple_dir dir,
-			    struct ipv6hdr *ip6h)
+static void nf_flow_nat_ipv6(const struct flow_offload *flow,
+			     struct sk_buff *skb,
+			     enum flow_offload_tuple_dir dir,
+			     struct ipv6hdr *ip6h)
 {
 	unsigned int thoff = sizeof(*ip6h);
 
-	if (test_bit(NF_FLOW_SNAT, &flow->flags) &&
-	    (nf_flow_snat_port(flow, skb, thoff, ip6h->nexthdr, dir) < 0 ||
-	     nf_flow_snat_ipv6(flow, skb, ip6h, thoff, dir) < 0))
-		return -1;
-
-	if (test_bit(NF_FLOW_DNAT, &flow->flags) &&
-	    (nf_flow_dnat_port(flow, skb, thoff, ip6h->nexthdr, dir) < 0 ||
-	     nf_flow_dnat_ipv6(flow, skb, ip6h, thoff, dir) < 0))
-		return -1;
-
-	return 0;
+	if (test_bit(NF_FLOW_SNAT, &flow->flags)) {
+		nf_flow_snat_port(flow, skb, thoff, ip6h->nexthdr, dir);
+		nf_flow_snat_ipv6(flow, skb, ip6h, thoff, dir);
+	}
+	if (test_bit(NF_FLOW_DNAT, &flow->flags)) {
+		nf_flow_dnat_port(flow, skb, thoff, ip6h->nexthdr, dir);
+		nf_flow_dnat_ipv6(flow, skb, ip6h, thoff, dir);
+	}
 }
 
 static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
@@ -507,8 +485,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 		return NF_DROP;
 
 	ip6h = ipv6_hdr(skb);
-	if (nf_flow_nat_ipv6(flow, skb, dir, ip6h) < 0)
-		return NF_DROP;
+	nf_flow_nat_ipv6(flow, skb, dir, ip6h);
 
 	ip6h->hop_limit--;
 	skb->tstamp = 0;
-- 
2.20.1

