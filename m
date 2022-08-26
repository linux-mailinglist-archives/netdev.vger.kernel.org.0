Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6DE85A1D9A
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 02:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244364AbiHZAJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 20:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244609AbiHZAIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 20:08:48 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2043C926D;
        Thu, 25 Aug 2022 17:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661472520; x=1693008520;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W7V0jySFfeHCIADKO7KQy2sISBJJhxiYLxE6HrEK8wk=;
  b=QlYwOE90/I8jEWbQ9nV2Ezw3KDBYvmmzYmeDVMLO/LlM2ILW8gbsE4Jb
   s5XtJicKQe2jMZFV9n2JMNlSlFGoKnqBsv1PlV/pdS3VBDW5xqjU20I5A
   lPh9ely6PDk4Hv8vX0QXqMl4oESVzNau0fXGxKuLLXGNHB9ccwYuSZcV8
   o=;
X-IronPort-AV: E=Sophos;i="5.93,264,1654560000"; 
   d="scan'208";a="253012902"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-2520d768.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 00:08:38 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-2520d768.us-west-2.amazon.com (Postfix) with ESMTPS id B60D145458;
        Fri, 26 Aug 2022 00:08:37 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 26 Aug 2022 00:08:37 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.140) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Fri, 26 Aug 2022 00:08:33 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v1 net-next 12/13] udp: Access &udp_table via net.
Date:   Thu, 25 Aug 2022 17:04:44 -0700
Message-ID: <20220826000445.46552-13-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220826000445.46552-1-kuniyu@amazon.com>
References: <20220826000445.46552-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.140]
X-ClientProxiedBy: EX13D10UWB001.ant.amazon.com (10.43.161.111) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We will soon introduce an optional per-netns hash table
for UDP.

This means we cannot use udp_table directly in most places.

Instead, access it via net->ipv4.udp_table.

The access will be valid only while initialising udp_table
itself and creating/destroying each netns.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/core/filter.c      |  4 ++--
 net/ipv4/udp.c         | 23 +++++++++++++----------
 net/ipv4/udp_diag.c    |  6 +++---
 net/ipv4/udp_offload.c |  5 +++--
 net/ipv6/udp.c         | 19 +++++++++++--------
 net/ipv6/udp_offload.c |  5 +++--
 6 files changed, 35 insertions(+), 27 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index dd5844033b66..38b247f5de24 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6484,7 +6484,7 @@ static struct sock *sk_lookup(struct net *net, struct bpf_sock_tuple *tuple,
 		else
 			sk = __udp4_lib_lookup(net, src4, tuple->ipv4.sport,
 					       dst4, tuple->ipv4.dport,
-					       dif, sdif, &udp_table, NULL);
+					       dif, sdif, net->ipv4.udp_table, NULL);
 #if IS_ENABLED(CONFIG_IPV6)
 	} else {
 		struct in6_addr *src6 = (struct in6_addr *)&tuple->ipv6.saddr;
@@ -6500,7 +6500,7 @@ static struct sock *sk_lookup(struct net *net, struct bpf_sock_tuple *tuple,
 							    src6, tuple->ipv6.sport,
 							    dst6, tuple->ipv6.dport,
 							    dif, sdif,
-							    &udp_table, NULL);
+							    net->ipv4.udp_table, NULL);
 #endif
 	}
 
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 17b4b175fc67..f4825e38762a 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -478,7 +478,7 @@ static struct sock *udp4_lookup_run_bpf(struct net *net,
 	struct sock *sk, *reuse_sk;
 	bool no_reuseport;
 
-	if (udptable != &udp_table)
+	if (udptable != net->ipv4.udp_table)
 		return NULL; /* only UDP is supported */
 
 	no_reuseport = bpf_sk_lookup_run_v4(net, IPPROTO_UDP, saddr, sport,
@@ -559,10 +559,11 @@ struct sock *udp4_lib_lookup_skb(const struct sk_buff *skb,
 				 __be16 sport, __be16 dport)
 {
 	const struct iphdr *iph = ip_hdr(skb);
+	struct net *net = dev_net(skb->dev);
 
-	return __udp4_lib_lookup(dev_net(skb->dev), iph->saddr, sport,
+	return __udp4_lib_lookup(net, iph->saddr, sport,
 				 iph->daddr, dport, inet_iif(skb),
-				 inet_sdif(skb), &udp_table, NULL);
+				 inet_sdif(skb), net->ipv4.udp_table, NULL);
 }
 
 /* Must be called under rcu_read_lock().
@@ -575,7 +576,7 @@ struct sock *udp4_lib_lookup(struct net *net, __be32 saddr, __be16 sport,
 	struct sock *sk;
 
 	sk = __udp4_lib_lookup(net, saddr, sport, daddr, dport,
-			       dif, 0, &udp_table, NULL);
+			       dif, 0, net->ipv4.udp_table, NULL);
 	if (sk && !refcount_inc_not_zero(&sk->sk_refcnt))
 		sk = NULL;
 	return sk;
@@ -810,7 +811,7 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
 
 int udp_err(struct sk_buff *skb, u32 info)
 {
-	return __udp4_lib_err(skb, info, &udp_table);
+	return __udp4_lib_err(skb, info, dev_net(skb->dev)->ipv4.udp_table);
 }
 
 /*
@@ -2535,13 +2536,14 @@ static struct sock *__udp4_lib_mcast_demux_lookup(struct net *net,
 						  __be16 rmt_port, __be32 rmt_addr,
 						  int dif, int sdif)
 {
+	struct udp_table *udptable = net->ipv4.udp_table;
 	unsigned short hnum = ntohs(loc_port);
 	struct sock *sk, *result;
 	struct udp_hslot *hslot;
 	unsigned int slot;
 
-	slot = udp_hashfn(net, hnum, udp_table.mask);
-	hslot = &udp_table.hash[slot];
+	slot = udp_hashfn(net, hnum, udptable->mask);
+	hslot = &udptable->hash[slot];
 
 	/* Do not bother scanning a too big list */
 	if (hslot->count > 10)
@@ -2569,6 +2571,7 @@ static struct sock *__udp4_lib_demux_lookup(struct net *net,
 					    __be16 rmt_port, __be32 rmt_addr,
 					    int dif, int sdif)
 {
+	struct udp_table *udptable = net->ipv4.udp_table;
 	INET_ADDR_COOKIE(acookie, rmt_addr, loc_addr);
 	unsigned short hnum = ntohs(loc_port);
 	unsigned int hash2, slot2;
@@ -2577,8 +2580,8 @@ static struct sock *__udp4_lib_demux_lookup(struct net *net,
 	struct sock *sk;
 
 	hash2 = ipv4_portaddr_hash(net, loc_addr, hnum);
-	slot2 = hash2 & udp_table.mask;
-	hslot2 = &udp_table.hash2[slot2];
+	slot2 = hash2 & udptable->mask;
+	hslot2 = &udptable->hash2[slot2];
 	ports = INET_COMBINED_PORTS(rmt_port, hnum);
 
 	udp_portaddr_for_each_entry_rcu(sk, &hslot2->head) {
@@ -2660,7 +2663,7 @@ int udp_v4_early_demux(struct sk_buff *skb)
 
 int udp_rcv(struct sk_buff *skb)
 {
-	return __udp4_lib_rcv(skb, &udp_table, IPPROTO_UDP);
+	return __udp4_lib_rcv(skb, dev_net(skb->dev)->ipv4.udp_table, IPPROTO_UDP);
 }
 
 void udp_destroy_sock(struct sock *sk)
diff --git a/net/ipv4/udp_diag.c b/net/ipv4/udp_diag.c
index 1ed8c4d78e5c..de3f2d31f510 100644
--- a/net/ipv4/udp_diag.c
+++ b/net/ipv4/udp_diag.c
@@ -147,13 +147,13 @@ static void udp_dump(struct udp_table *table, struct sk_buff *skb,
 static void udp_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 			  const struct inet_diag_req_v2 *r)
 {
-	udp_dump(&udp_table, skb, cb, r);
+	udp_dump(sock_net(cb->skb->sk)->ipv4.udp_table, skb, cb, r);
 }
 
 static int udp_diag_dump_one(struct netlink_callback *cb,
 			     const struct inet_diag_req_v2 *req)
 {
-	return udp_dump_one(&udp_table, cb, req);
+	return udp_dump_one(sock_net(cb->skb->sk)->ipv4.udp_table, cb, req);
 }
 
 static void udp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
@@ -225,7 +225,7 @@ static int __udp_diag_destroy(struct sk_buff *in_skb,
 static int udp_diag_destroy(struct sk_buff *in_skb,
 			    const struct inet_diag_req_v2 *req)
 {
-	return __udp_diag_destroy(in_skb, req, &udp_table);
+	return __udp_diag_destroy(in_skb, req, sock_net(in_skb->sk)->ipv4.udp_table);
 }
 
 static int udplite_diag_destroy(struct sk_buff *in_skb,
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 6d1a4bec2614..aedde65e2268 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -600,10 +600,11 @@ static struct sock *udp4_gro_lookup_skb(struct sk_buff *skb, __be16 sport,
 					__be16 dport)
 {
 	const struct iphdr *iph = skb_gro_network_header(skb);
+	struct net *net = dev_net(skb->dev);
 
-	return __udp4_lib_lookup(dev_net(skb->dev), iph->saddr, sport,
+	return __udp4_lib_lookup(net, iph->saddr, sport,
 				 iph->daddr, dport, inet_iif(skb),
-				 inet_sdif(skb), &udp_table, NULL);
+				 inet_sdif(skb), net->ipv4.udp_table, NULL);
 }
 
 INDIRECT_CALLABLE_SCOPE
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 8abf16c5a8a1..739a8c86f0b6 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -203,7 +203,7 @@ static inline struct sock *udp6_lookup_run_bpf(struct net *net,
 	struct sock *sk, *reuse_sk;
 	bool no_reuseport;
 
-	if (udptable != &udp_table)
+	if (udptable != net->ipv4.udp_table)
 		return NULL; /* only UDP is supported */
 
 	no_reuseport = bpf_sk_lookup_run_v6(net, IPPROTO_UDP, saddr, sport,
@@ -284,10 +284,11 @@ struct sock *udp6_lib_lookup_skb(const struct sk_buff *skb,
 				 __be16 sport, __be16 dport)
 {
 	const struct ipv6hdr *iph = ipv6_hdr(skb);
+	struct net *net = dev_net(skb->dev);
 
-	return __udp6_lib_lookup(dev_net(skb->dev), &iph->saddr, sport,
+	return __udp6_lib_lookup(net, &iph->saddr, sport,
 				 &iph->daddr, dport, inet6_iif(skb),
-				 inet6_sdif(skb), &udp_table, NULL);
+				 inet6_sdif(skb), net->ipv4.udp_table, NULL);
 }
 
 /* Must be called under rcu_read_lock().
@@ -300,7 +301,7 @@ struct sock *udp6_lib_lookup(struct net *net, const struct in6_addr *saddr, __be
 	struct sock *sk;
 
 	sk =  __udp6_lib_lookup(net, saddr, sport, daddr, dport,
-				dif, 0, &udp_table, NULL);
+				dif, 0, net->ipv4.udp_table, NULL);
 	if (sk && !refcount_inc_not_zero(&sk->sk_refcnt))
 		sk = NULL;
 	return sk;
@@ -667,7 +668,8 @@ static __inline__ int udpv6_err(struct sk_buff *skb,
 				struct inet6_skb_parm *opt, u8 type,
 				u8 code, int offset, __be32 info)
 {
-	return __udp6_lib_err(skb, opt, type, code, offset, info, &udp_table);
+	return __udp6_lib_err(skb, opt, type, code, offset, info,
+			      dev_net(skb->dev)->ipv4.udp_table);
 }
 
 static int udpv6_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
@@ -1035,6 +1037,7 @@ static struct sock *__udp6_lib_demux_lookup(struct net *net,
 			__be16 rmt_port, const struct in6_addr *rmt_addr,
 			int dif, int sdif)
 {
+	struct udp_table *udptable = net->ipv4.udp_table;
 	unsigned short hnum = ntohs(loc_port);
 	unsigned int hash2, slot2;
 	struct udp_hslot *hslot2;
@@ -1042,8 +1045,8 @@ static struct sock *__udp6_lib_demux_lookup(struct net *net,
 	struct sock *sk;
 
 	hash2 = ipv6_portaddr_hash(net, loc_addr, hnum);
-	slot2 = hash2 & udp_table.mask;
-	hslot2 = &udp_table.hash2[slot2];
+	slot2 = hash2 & udptable->mask;
+	hslot2 = &udptable->hash2[slot2];
 	ports = INET_COMBINED_PORTS(rmt_port, hnum);
 
 	udp_portaddr_for_each_entry_rcu(sk, &hslot2->head) {
@@ -1099,7 +1102,7 @@ void udp_v6_early_demux(struct sk_buff *skb)
 
 INDIRECT_CALLABLE_SCOPE int udpv6_rcv(struct sk_buff *skb)
 {
-	return __udp6_lib_rcv(skb, &udp_table, IPPROTO_UDP);
+	return __udp6_lib_rcv(skb, dev_net(skb->dev)->ipv4.udp_table, IPPROTO_UDP);
 }
 
 /*
diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
index 7720d04ed396..e0e10f6bcdc1 100644
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -116,10 +116,11 @@ static struct sock *udp6_gro_lookup_skb(struct sk_buff *skb, __be16 sport,
 					__be16 dport)
 {
 	const struct ipv6hdr *iph = skb_gro_network_header(skb);
+	struct net *net = dev_net(skb->dev);
 
-	return __udp6_lib_lookup(dev_net(skb->dev), &iph->saddr, sport,
+	return __udp6_lib_lookup(net, &iph->saddr, sport,
 				 &iph->daddr, dport, inet6_iif(skb),
-				 inet6_sdif(skb), &udp_table, NULL);
+				 inet6_sdif(skb), net->ipv4.udp_table, NULL);
 }
 
 INDIRECT_CALLABLE_SCOPE
-- 
2.30.2

