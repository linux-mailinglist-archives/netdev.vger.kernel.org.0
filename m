Return-Path: <netdev+bounces-6205-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B1FA7152E2
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 03:10:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F22A91C20B27
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 01:10:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46231819;
	Tue, 30 May 2023 01:10:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35376802
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 01:10:07 +0000 (UTC)
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8AB9D
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 18:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685409004; x=1716945004;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K7KFCuY+HUZEllEzJsUB3Rzq1ksZ0EYJeuuMqRf5HU0=;
  b=ZmXRHQmXW2gdE7Csj5ad24PuD8GR+5TBQGsaU+gVhxSTCQ47qfTPThZJ
   QiDYLLRXqgEGOe5G5ZiVWtB9syQcSvjSp1+LkP5nixRa8bWvnXD7jOGhr
   iOz3r29yqulfOolgD5IjfMbj6AGTeeZhbk1/1wOHYtVMVi4Z3gi8inO4e
   k=;
X-IronPort-AV: E=Sophos;i="6.00,201,1681171200"; 
   d="scan'208";a="334634367"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-366646a6.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 01:10:03 +0000
Received: from EX19MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
	by email-inbound-relay-iad-1a-m6i4x-366646a6.us-east-1.amazon.com (Postfix) with ESMTPS id 91ED3A0BB0;
	Tue, 30 May 2023 01:10:01 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 30 May 2023 01:10:00 +0000
Received: from 88665a182662.ant.amazon.com.com (10.106.101.39) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 30 May 2023 01:09:57 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, David Ahern <dsahern@kernel.org>, Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>
CC: Kuniyuki Iwashima <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 14/14] udp: Don't pass udp_table to __udp[46]_lib_lookup().
Date: Mon, 29 May 2023 18:03:48 -0700
Message-ID: <20230530010348.21425-15-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230530010348.21425-1-kuniyu@amazon.com>
References: <20230530010348.21425-1-kuniyu@amazon.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.101.39]
X-ClientProxiedBy: EX19D041UWB001.ant.amazon.com (10.13.139.132) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

We use the same socket lookup function for UDP and UDP-Lite.

However, we managed UDP-Lite sockets in a global hash table and
UDP sockets in per-netns hash tables.

To use a proper table in __udp6_lib_lookup(), we needed to add an
argument for udp_table in many functions.

However, we no longer support UDP-Lite and need not pass udp_table
again and again.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/ipv6_stubs.h |  3 +-
 include/net/udp.h        |  5 ++--
 net/core/filter.c        |  5 ++--
 net/ipv4/udp.c           | 61 +++++++++++++---------------------------
 net/ipv4/udp_diag.c      | 38 ++++++++++++-------------
 net/ipv4/udp_offload.c   |  5 ++--
 net/ipv6/udp.c           | 55 +++++++++++-------------------------
 net/ipv6/udp_offload.c   |  5 ++--
 8 files changed, 65 insertions(+), 112 deletions(-)

diff --git a/include/net/ipv6_stubs.h b/include/net/ipv6_stubs.h
index c48186bf4737..ff6ac49b02f5 100644
--- a/include/net/ipv6_stubs.h
+++ b/include/net/ipv6_stubs.h
@@ -79,8 +79,7 @@ struct ipv6_bpf_stub {
 	struct sock *(*udp6_lib_lookup)(struct net *net,
 				     const struct in6_addr *saddr, __be16 sport,
 				     const struct in6_addr *daddr, __be16 dport,
-				     int dif, int sdif, struct udp_table *tbl,
-				     struct sk_buff *skb);
+				     int dif, int sdif, struct sk_buff *skb);
 	int (*ipv6_setsockopt)(struct sock *sk, int level, int optname,
 			       sockptr_t optval, unsigned int optlen);
 	int (*ipv6_getsockopt)(struct sock *sk, int level, int optname,
diff --git a/include/net/udp.h b/include/net/udp.h
index ea2308989dc7..31bcf12c8b20 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -293,7 +293,7 @@ struct sock *udp4_lib_lookup(struct net *net, __be32 saddr, __be16 sport,
 			     __be32 daddr, __be16 dport, int dif);
 struct sock *__udp4_lib_lookup(struct net *net, __be32 saddr, __be16 sport,
 			       __be32 daddr, __be16 dport, int dif, int sdif,
-			       struct udp_table *tbl, struct sk_buff *skb);
+			       struct sk_buff *skb);
 struct sock *udp4_lib_lookup_skb(const struct sk_buff *skb,
 				 __be16 sport, __be16 dport);
 struct sock *udp6_lib_lookup(struct net *net,
@@ -303,8 +303,7 @@ struct sock *udp6_lib_lookup(struct net *net,
 struct sock *__udp6_lib_lookup(struct net *net,
 			       const struct in6_addr *saddr, __be16 sport,
 			       const struct in6_addr *daddr, __be16 dport,
-			       int dif, int sdif, struct udp_table *tbl,
-			       struct sk_buff *skb);
+			       int dif, int sdif, struct sk_buff *skb);
 struct sock *udp6_lib_lookup_skb(const struct sk_buff *skb,
 				 __be16 sport, __be16 dport);
 int udp_read_skb(struct sock *sk, skb_read_actor_t recv_actor);
diff --git a/net/core/filter.c b/net/core/filter.c
index 968139f4a1ac..32e3a0677f99 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6522,7 +6522,7 @@ static struct sock *sk_lookup(struct net *net, struct bpf_sock_tuple *tuple,
 		else
 			sk = __udp4_lib_lookup(net, src4, tuple->ipv4.sport,
 					       dst4, tuple->ipv4.dport,
-					       dif, sdif, net->ipv4.udp_table, NULL);
+					       dif, sdif, NULL);
 #if IS_ENABLED(CONFIG_IPV6)
 	} else {
 		struct in6_addr *src6 = (struct in6_addr *)&tuple->ipv6.saddr;
@@ -6537,8 +6537,7 @@ static struct sock *sk_lookup(struct net *net, struct bpf_sock_tuple *tuple,
 			sk = ipv6_bpf_stub->udp6_lib_lookup(net,
 							    src6, tuple->ipv6.sport,
 							    dst6, tuple->ipv6.dport,
-							    dif, sdif,
-							    net->ipv4.udp_table, NULL);
+							    dif, sdif, NULL);
 #endif
 	}
 
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 7eddf88dfce6..e6d7b830929d 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -462,7 +462,6 @@ static struct sock *udp4_lib_lookup2(struct net *net,
 }
 
 static struct sock *udp4_lookup_run_bpf(struct net *net,
-					struct udp_table *udptable,
 					struct sk_buff *skb,
 					__be32 saddr, __be16 sport,
 					__be32 daddr, u16 hnum, const int dif)
@@ -470,9 +469,6 @@ static struct sock *udp4_lookup_run_bpf(struct net *net,
 	struct sock *sk, *reuse_sk;
 	bool no_reuseport;
 
-	if (udptable != net->ipv4.udp_table)
-		return NULL; /* only UDP is supported */
-
 	no_reuseport = bpf_sk_lookup_run_v4(net, IPPROTO_UDP, saddr, sport,
 					    daddr, hnum, dif, &sk);
 	if (no_reuseport || IS_ERR_OR_NULL(sk))
@@ -487,10 +483,11 @@ static struct sock *udp4_lookup_run_bpf(struct net *net,
 /* UDP is nearly always wildcards out the wazoo, it makes no sense to try
  * harder than this. -DaveM
  */
-struct sock *__udp4_lib_lookup(struct net *net, __be32 saddr,
-		__be16 sport, __be32 daddr, __be16 dport, int dif,
-		int sdif, struct udp_table *udptable, struct sk_buff *skb)
+struct sock *__udp4_lib_lookup(struct net *net, __be32 saddr, __be16 sport,
+			       __be32 daddr, __be16 dport, int dif, int sdif,
+			       struct sk_buff *skb)
 {
+	struct udp_table *udptable = net->ipv4.udp_table;
 	unsigned short hnum = ntohs(dport);
 	unsigned int hash2, slot2;
 	struct udp_hslot *hslot2;
@@ -509,8 +506,7 @@ struct sock *__udp4_lib_lookup(struct net *net, __be32 saddr,
 
 	/* Lookup redirect from BPF */
 	if (static_branch_unlikely(&bpf_sk_lookup_enabled)) {
-		sk = udp4_lookup_run_bpf(net, udptable, skb,
-					 saddr, sport, daddr, hnum, dif);
+		sk = udp4_lookup_run_bpf(net, skb, saddr, sport, daddr, hnum, dif);
 		if (sk) {
 			result = sk;
 			goto done;
@@ -537,25 +533,23 @@ struct sock *__udp4_lib_lookup(struct net *net, __be32 saddr,
 EXPORT_SYMBOL_GPL(__udp4_lib_lookup);
 
 static inline struct sock *__udp4_lib_lookup_skb(struct sk_buff *skb,
-						 __be16 sport, __be16 dport,
-						 struct udp_table *udptable)
+						 __be16 sport, __be16 dport)
 {
 	const struct iphdr *iph = ip_hdr(skb);
 
 	return __udp4_lib_lookup(dev_net(skb->dev), iph->saddr, sport,
 				 iph->daddr, dport, inet_iif(skb),
-				 inet_sdif(skb), udptable, skb);
+				 inet_sdif(skb), skb);
 }
 
 struct sock *udp4_lib_lookup_skb(const struct sk_buff *skb,
 				 __be16 sport, __be16 dport)
 {
 	const struct iphdr *iph = ip_hdr(skb);
-	struct net *net = dev_net(skb->dev);
 
-	return __udp4_lib_lookup(net, iph->saddr, sport,
+	return __udp4_lib_lookup(dev_net(skb->dev), iph->saddr, sport,
 				 iph->daddr, dport, inet_iif(skb),
-				 inet_sdif(skb), net->ipv4.udp_table, NULL);
+				 inet_sdif(skb), NULL);
 }
 
 /* Must be called under rcu_read_lock().
@@ -567,8 +561,7 @@ struct sock *udp4_lib_lookup(struct net *net, __be32 saddr, __be16 sport,
 {
 	struct sock *sk;
 
-	sk = __udp4_lib_lookup(net, saddr, sport, daddr, dport,
-			       dif, 0, net->ipv4.udp_table, NULL);
+	sk = __udp4_lib_lookup(net, saddr, sport, daddr, dport, dif, 0, NULL);
 	if (sk && !refcount_inc_not_zero(&sk->sk_refcnt))
 		sk = NULL;
 	return sk;
@@ -651,7 +644,6 @@ static int __udp4_lib_err_encap_no_sk(struct sk_buff *skb, u32 info)
 static struct sock *__udp4_lib_err_encap(struct net *net,
 					 const struct iphdr *iph,
 					 struct udphdr *uh,
-					 struct udp_table *udptable,
 					 struct sock *sk,
 					 struct sk_buff *skb, u32 info)
 {
@@ -678,9 +670,8 @@ static struct sock *__udp4_lib_err_encap(struct net *net,
 		goto out;
 	}
 
-	sk = __udp4_lib_lookup(net, iph->daddr, uh->source,
-			       iph->saddr, uh->dest, skb->dev->ifindex, 0,
-			       udptable, NULL);
+	sk = __udp4_lib_lookup(net, iph->daddr, uh->source, iph->saddr, uh->dest,
+			       skb->dev->ifindex, 0, NULL);
 	if (sk) {
 		up = udp_sk(sk);
 
@@ -710,7 +701,7 @@ static struct sock *__udp4_lib_err_encap(struct net *net,
  * to find the appropriate port.
  */
 
-static int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
+int udp_err(struct sk_buff *skb, u32 info)
 {
 	struct inet_sock *inet;
 	const struct iphdr *iph = (const struct iphdr *)skb->data;
@@ -725,13 +716,12 @@ static int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udpta
 
 	sk = __udp4_lib_lookup(net, iph->daddr, uh->dest,
 			       iph->saddr, uh->source, skb->dev->ifindex,
-			       inet_sdif(skb), udptable, NULL);
+			       inet_sdif(skb), NULL);
 
 	if (!sk || udp_sk(sk)->encap_type) {
 		/* No socket for error: try tunnels before discarding */
 		if (static_branch_unlikely(&udp_encap_needed_key)) {
-			sk = __udp4_lib_err_encap(net, iph, uh, udptable, sk, skb,
-						  info);
+			sk = __udp4_lib_err_encap(net, iph, uh, sk, skb, info);
 			if (!sk)
 				return 0;
 		} else
@@ -804,11 +794,6 @@ static int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udpta
 	return 0;
 }
 
-int udp_err(struct sk_buff *skb, u32 info)
-{
-	return __udp4_lib_err(skb, info, dev_net(skb->dev)->ipv4.udp_table);
-}
-
 /*
  * Throw away all pending data and cancel the corking. Socket is locked.
  */
@@ -2178,10 +2163,10 @@ EXPORT_SYMBOL(udp_sk_rx_dst_set);
  */
 static int __udp4_lib_mcast_deliver(struct net *net, struct sk_buff *skb,
 				    struct udphdr  *uh,
-				    __be32 saddr, __be32 daddr,
-				    struct udp_table *udptable)
+				    __be32 saddr, __be32 daddr)
 {
 	int dif = skb->dev->ifindex, sdif = inet_sdif(skb);
+	struct udp_table *udptable = net->ipv4.udp_table;
 	unsigned int offset, hash2 = 0, hash2_any = 0;
 	unsigned short hnum = ntohs(uh->dest);
 	struct sock *sk, *first = NULL;
@@ -2297,7 +2282,7 @@ static int udp_unicast_rcv_skb(struct sock *sk, struct sk_buff *skb,
  *	All we need to do is get the socket, and then do a checksum.
  */
 
-static int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable)
+int udp_rcv(struct sk_buff *skb)
 {
 	struct sock *sk;
 	struct udphdr *uh;
@@ -2349,10 +2334,9 @@ static int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable)
 	}
 
 	if (rt->rt_flags & (RTCF_BROADCAST|RTCF_MULTICAST))
-		return __udp4_lib_mcast_deliver(net, skb, uh,
-						saddr, daddr, udptable);
+		return __udp4_lib_mcast_deliver(net, skb, uh, saddr, daddr);
 
-	sk = __udp4_lib_lookup_skb(skb, uh->source, uh->dest, udptable);
+	sk = __udp4_lib_lookup_skb(skb, uh->source, uh->dest);
 	if (sk)
 		return udp_unicast_rcv_skb(sk, skb, uh);
 
@@ -2532,11 +2516,6 @@ int udp_v4_early_demux(struct sk_buff *skb)
 	return 0;
 }
 
-int udp_rcv(struct sk_buff *skb)
-{
-	return __udp4_lib_rcv(skb, dev_net(skb->dev)->ipv4.udp_table);
-}
-
 static void udp_destroy_sock(struct sock *sk)
 {
 	struct udp_sock *up = udp_sk(sk);
diff --git a/net/ipv4/udp_diag.c b/net/ipv4/udp_diag.c
index b8de2babfb0c..0f4ffd516efb 100644
--- a/net/ipv4/udp_diag.c
+++ b/net/ipv4/udp_diag.c
@@ -38,17 +38,17 @@ static int udp_dump_one(struct udp_table *tbl,
 	if (req->sdiag_family == AF_INET)
 		/* src and dst are swapped for historical reasons */
 		sk = __udp4_lib_lookup(net,
-				req->id.idiag_src[0], req->id.idiag_sport,
-				req->id.idiag_dst[0], req->id.idiag_dport,
-				req->id.idiag_if, 0, tbl, NULL);
+				       req->id.idiag_src[0], req->id.idiag_sport,
+				       req->id.idiag_dst[0], req->id.idiag_dport,
+				       req->id.idiag_if, 0, NULL);
 #if IS_ENABLED(CONFIG_IPV6)
 	else if (req->sdiag_family == AF_INET6)
 		sk = __udp6_lib_lookup(net,
-				(struct in6_addr *)req->id.idiag_src,
-				req->id.idiag_sport,
-				(struct in6_addr *)req->id.idiag_dst,
-				req->id.idiag_dport,
-				req->id.idiag_if, 0, tbl, NULL);
+				       (struct in6_addr *)req->id.idiag_src,
+				       req->id.idiag_sport,
+				       (struct in6_addr *)req->id.idiag_dst,
+				       req->id.idiag_dport,
+				       req->id.idiag_if, 0, NULL);
 #endif
 	if (sk && !refcount_inc_not_zero(&sk->sk_refcnt))
 		sk = NULL;
@@ -175,25 +175,25 @@ static int __udp_diag_destroy(struct sk_buff *in_skb,
 
 	if (req->sdiag_family == AF_INET)
 		sk = __udp4_lib_lookup(net,
-				req->id.idiag_dst[0], req->id.idiag_dport,
-				req->id.idiag_src[0], req->id.idiag_sport,
-				req->id.idiag_if, 0, tbl, NULL);
+				       req->id.idiag_dst[0], req->id.idiag_dport,
+				       req->id.idiag_src[0], req->id.idiag_sport,
+				       req->id.idiag_if, 0, NULL);
 #if IS_ENABLED(CONFIG_IPV6)
 	else if (req->sdiag_family == AF_INET6) {
 		if (ipv6_addr_v4mapped((struct in6_addr *)req->id.idiag_dst) &&
 		    ipv6_addr_v4mapped((struct in6_addr *)req->id.idiag_src))
 			sk = __udp4_lib_lookup(net,
-					req->id.idiag_dst[3], req->id.idiag_dport,
-					req->id.idiag_src[3], req->id.idiag_sport,
-					req->id.idiag_if, 0, tbl, NULL);
+					       req->id.idiag_dst[3], req->id.idiag_dport,
+					       req->id.idiag_src[3], req->id.idiag_sport,
+					       req->id.idiag_if, 0, NULL);
 
 		else
 			sk = __udp6_lib_lookup(net,
-					(struct in6_addr *)req->id.idiag_dst,
-					req->id.idiag_dport,
-					(struct in6_addr *)req->id.idiag_src,
-					req->id.idiag_sport,
-					req->id.idiag_if, 0, tbl, NULL);
+					       (struct in6_addr *)req->id.idiag_dst,
+					       req->id.idiag_dport,
+					       (struct in6_addr *)req->id.idiag_src,
+					       req->id.idiag_sport,
+					       req->id.idiag_if, 0, NULL);
 	}
 #endif
 	else {
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 1f01e15ca24f..fd1a002b99d3 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -601,11 +601,10 @@ static struct sock *udp4_gro_lookup_skb(struct sk_buff *skb, __be16 sport,
 					__be16 dport)
 {
 	const struct iphdr *iph = skb_gro_network_header(skb);
-	struct net *net = dev_net(skb->dev);
 
-	return __udp4_lib_lookup(net, iph->saddr, sport,
+	return __udp4_lib_lookup(dev_net(skb->dev), iph->saddr, sport,
 				 iph->daddr, dport, inet_iif(skb),
-				 inet_sdif(skb), net->ipv4.udp_table, NULL);
+				 inet_sdif(skb), NULL);
 }
 
 INDIRECT_CALLABLE_SCOPE
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 066e9b9ae5f0..f04bf69d13ea 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -207,7 +207,6 @@ static struct sock *udp6_lib_lookup2(struct net *net,
 }
 
 static inline struct sock *udp6_lookup_run_bpf(struct net *net,
-					       struct udp_table *udptable,
 					       struct sk_buff *skb,
 					       const struct in6_addr *saddr,
 					       __be16 sport,
@@ -217,9 +216,6 @@ static inline struct sock *udp6_lookup_run_bpf(struct net *net,
 	struct sock *sk, *reuse_sk;
 	bool no_reuseport;
 
-	if (udptable != net->ipv4.udp_table)
-		return NULL; /* only UDP is supported */
-
 	no_reuseport = bpf_sk_lookup_run_v6(net, IPPROTO_UDP, saddr, sport,
 					    daddr, hnum, dif, &sk);
 	if (no_reuseport || IS_ERR_OR_NULL(sk))
@@ -235,9 +231,9 @@ static inline struct sock *udp6_lookup_run_bpf(struct net *net,
 struct sock *__udp6_lib_lookup(struct net *net,
 			       const struct in6_addr *saddr, __be16 sport,
 			       const struct in6_addr *daddr, __be16 dport,
-			       int dif, int sdif, struct udp_table *udptable,
-			       struct sk_buff *skb)
+			       int dif, int sdif, struct sk_buff *skb)
 {
+	struct udp_table *udptable = net->ipv4.udp_table;
 	unsigned short hnum = ntohs(dport);
 	unsigned int hash2, slot2;
 	struct udp_hslot *hslot2;
@@ -256,8 +252,7 @@ struct sock *__udp6_lib_lookup(struct net *net,
 
 	/* Lookup redirect from BPF */
 	if (static_branch_unlikely(&bpf_sk_lookup_enabled)) {
-		sk = udp6_lookup_run_bpf(net, udptable, skb,
-					 saddr, sport, daddr, hnum, dif);
+		sk = udp6_lookup_run_bpf(net, skb, saddr, sport, daddr, hnum, dif);
 		if (sk) {
 			result = sk;
 			goto done;
@@ -284,25 +279,23 @@ struct sock *__udp6_lib_lookup(struct net *net,
 EXPORT_SYMBOL_GPL(__udp6_lib_lookup);
 
 static struct sock *__udp6_lib_lookup_skb(struct sk_buff *skb,
-					  __be16 sport, __be16 dport,
-					  struct udp_table *udptable)
+					  __be16 sport, __be16 dport)
 {
 	const struct ipv6hdr *iph = ipv6_hdr(skb);
 
 	return __udp6_lib_lookup(dev_net(skb->dev), &iph->saddr, sport,
 				 &iph->daddr, dport, inet6_iif(skb),
-				 inet6_sdif(skb), udptable, skb);
+				 inet6_sdif(skb), skb);
 }
 
 struct sock *udp6_lib_lookup_skb(const struct sk_buff *skb,
 				 __be16 sport, __be16 dport)
 {
 	const struct ipv6hdr *iph = ipv6_hdr(skb);
-	struct net *net = dev_net(skb->dev);
 
-	return __udp6_lib_lookup(net, &iph->saddr, sport,
+	return __udp6_lib_lookup(dev_net(skb->dev), &iph->saddr, sport,
 				 &iph->daddr, dport, inet6_iif(skb),
-				 inet6_sdif(skb), net->ipv4.udp_table, NULL);
+				 inet6_sdif(skb), NULL);
 }
 
 /* Must be called under rcu_read_lock().
@@ -314,8 +307,7 @@ struct sock *udp6_lib_lookup(struct net *net, const struct in6_addr *saddr, __be
 {
 	struct sock *sk;
 
-	sk =  __udp6_lib_lookup(net, saddr, sport, daddr, dport,
-				dif, 0, net->ipv4.udp_table, NULL);
+	sk =  __udp6_lib_lookup(net, saddr, sport, daddr, dport, dif, 0, NULL);
 	if (sk && !refcount_inc_not_zero(&sk->sk_refcnt))
 		sk = NULL;
 	return sk;
@@ -515,7 +507,6 @@ static int __udp6_lib_err_encap_no_sk(struct sk_buff *skb,
 static struct sock *__udp6_lib_err_encap(struct net *net,
 					 const struct ipv6hdr *hdr, int offset,
 					 struct udphdr *uh,
-					 struct udp_table *udptable,
 					 struct sock *sk,
 					 struct sk_buff *skb,
 					 struct inet6_skb_parm *opt,
@@ -545,8 +536,7 @@ static struct sock *__udp6_lib_err_encap(struct net *net,
 	}
 
 	sk = __udp6_lib_lookup(net, &hdr->daddr, uh->source,
-			       &hdr->saddr, uh->dest,
-			       inet6_iif(skb), 0, udptable, skb);
+			       &hdr->saddr, uh->dest, inet6_iif(skb), 0, skb);
 	if (sk) {
 		up = udp_sk(sk);
 
@@ -567,9 +557,8 @@ static struct sock *__udp6_lib_err_encap(struct net *net,
 	return sk;
 }
 
-static int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
-			  u8 type, u8 code, int offset, __be32 info,
-			  struct udp_table *udptable)
+static int udpv6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
+		     u8 type, u8 code, int offset, __be32 info)
 {
 	struct ipv6_pinfo *np;
 	const struct ipv6hdr *hdr = (const struct ipv6hdr *)skb->data;
@@ -583,14 +572,13 @@ static int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	struct net *net = dev_net(skb->dev);
 
 	sk = __udp6_lib_lookup(net, daddr, uh->dest, saddr, uh->source,
-			       inet6_iif(skb), inet6_sdif(skb), udptable, NULL);
+			       inet6_iif(skb), inet6_sdif(skb), NULL);
 
 	if (!sk || udp_sk(sk)->encap_type) {
 		/* No socket for error: try tunnels before discarding */
 		if (static_branch_unlikely(&udpv6_encap_needed_key)) {
 			sk = __udp6_lib_err_encap(net, hdr, offset, uh,
-						  udptable, sk, skb,
-						  opt, type, code, info);
+						  sk, skb, opt, type, code, info);
 			if (!sk)
 				return 0;
 		} else
@@ -679,14 +667,6 @@ static int __udpv6_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	return 0;
 }
 
-static __inline__ int udpv6_err(struct sk_buff *skb,
-				struct inet6_skb_parm *opt, u8 type,
-				u8 code, int offset, __be32 info)
-{
-	return __udp6_lib_err(skb, opt, type, code, offset, info,
-			      dev_net(skb->dev)->ipv4.udp_table);
-}
-
 static int udpv6_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 {
 	enum skb_drop_reason drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
@@ -820,9 +800,9 @@ static void udp6_csum_zero_error(struct sk_buff *skb)
  */
 static int __udp6_lib_mcast_deliver(struct net *net, struct sk_buff *skb,
 				    const struct in6_addr *saddr,
-				    const struct in6_addr *daddr,
-				    struct udp_table *udptable)
+				    const struct in6_addr *daddr)
 {
+	struct udp_table *udptable = net->ipv4.udp_table;
 	int dif = inet6_iif(skb), sdif = inet6_sdif(skb);
 	unsigned int offset, hash2 = 0, hash2_any = 0;
 	const struct udphdr *uh = udp_hdr(skb);
@@ -1017,11 +997,10 @@ static int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable)
 	 *	Multicast receive code
 	 */
 	if (ipv6_addr_is_multicast(daddr))
-		return __udp6_lib_mcast_deliver(net, skb,
-						saddr, daddr, udptable);
+		return __udp6_lib_mcast_deliver(net, skb, saddr, daddr);
 
 	/* Unicast */
-	sk = __udp6_lib_lookup_skb(skb, uh->source, uh->dest, udptable);
+	sk = __udp6_lib_lookup_skb(skb, uh->source, uh->dest);
 	if (sk) {
 		if (!uh->check && !udp_sk(sk)->no_check6_rx)
 			goto report_csum_error;
diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
index c39c1e32f980..2195ac83f077 100644
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -117,11 +117,10 @@ static struct sock *udp6_gro_lookup_skb(struct sk_buff *skb, __be16 sport,
 					__be16 dport)
 {
 	const struct ipv6hdr *iph = skb_gro_network_header(skb);
-	struct net *net = dev_net(skb->dev);
 
-	return __udp6_lib_lookup(net, &iph->saddr, sport,
+	return __udp6_lib_lookup(dev_net(skb->dev), &iph->saddr, sport,
 				 &iph->daddr, dport, inet6_iif(skb),
-				 inet6_sdif(skb), net->ipv4.udp_table, NULL);
+				 inet6_sdif(skb), NULL);
 }
 
 INDIRECT_CALLABLE_SCOPE
-- 
2.30.2


