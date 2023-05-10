Return-Path: <netdev+bounces-1592-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0652E6FE67D
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 23:55:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE9D81C20E35
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 21:55:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63E411E504;
	Wed, 10 May 2023 21:55:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED3E21CC1
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 21:55:04 +0000 (UTC)
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7705746A5
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1683755702; x=1715291702;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Dquc9u+G7iHnozNVqmkbwRoZh984uh9oqEfHPSTx6cU=;
  b=WYtNECnM5n3zbeItNe+xxpjRfjNWtu5Hn5gWLlDmKLartQBhtZGzW8bb
   sEcFts1JP38KRJeAUZKq6JqrYPp1CatSMvU8fO5asaz9jdxTlF6csWieb
   3aovLOwncfJdxnB38q3NnGPHFy9T1HsAegwqI0v+ZXEb9GLTTWQ4fVAPP
   U=;
X-IronPort-AV: E=Sophos;i="5.99,265,1677542400"; 
   d="scan'208";a="330441500"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-fa5fe5fb.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 21:54:59 +0000
Received: from EX19MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
	by email-inbound-relay-pdx-2c-m6i4x-fa5fe5fb.us-west-2.amazon.com (Postfix) with ESMTPS id 5222041578;
	Wed, 10 May 2023 21:54:58 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 10 May 2023 21:54:56 +0000
Received: from 88665a182662.ant.amazon.com (10.106.101.26) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 10 May 2023 21:54:54 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>
CC: Kuniyuki Iwashima <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next] ping: Convert hlist_nulls to plain hlist.
Date: Wed, 10 May 2023 14:54:43 -0700
Message-ID: <20230510215443.67017-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.101.26]
X-ClientProxiedBy: EX19D031UWC001.ant.amazon.com (10.13.139.241) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
	T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Since introduced in commit c319b4d76b9e ("net: ipv4: add IPPROTO_ICMP
socket kind"), ping socket does not use SLAB_TYPESAFE_BY_RCU nor check
nulls marker in loops.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/ping.c | 41 +++++++++++++++--------------------------
 1 file changed, 15 insertions(+), 26 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 5178a3f3cb53..3793c81bda8a 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -49,13 +49,8 @@
 #include <net/transp_v6.h>
 #endif
 
-#define ping_portaddr_for_each_entry(__sk, node, list) \
-	hlist_nulls_for_each_entry(__sk, node, list, sk_nulls_node)
-#define ping_portaddr_for_each_entry_rcu(__sk, node, list) \
-	hlist_nulls_for_each_entry_rcu(__sk, node, list, sk_nulls_node)
-
 struct ping_table {
-	struct hlist_nulls_head	hash[PING_HTABLE_SIZE];
+	struct hlist_head	hash[PING_HTABLE_SIZE];
 	spinlock_t		lock;
 };
 
@@ -74,17 +69,16 @@ static inline u32 ping_hashfn(const struct net *net, u32 num, u32 mask)
 }
 EXPORT_SYMBOL_GPL(ping_hash);
 
-static inline struct hlist_nulls_head *ping_hashslot(struct ping_table *table,
-					     struct net *net, unsigned int num)
+static inline struct hlist_head *ping_hashslot(struct ping_table *table,
+					       struct net *net, unsigned int num)
 {
 	return &table->hash[ping_hashfn(net, num, PING_HTABLE_MASK)];
 }
 
 int ping_get_port(struct sock *sk, unsigned short ident)
 {
-	struct hlist_nulls_node *node;
-	struct hlist_nulls_head *hlist;
 	struct inet_sock *isk, *isk2;
+	struct hlist_head *hlist;
 	struct sock *sk2 = NULL;
 
 	isk = inet_sk(sk);
@@ -98,7 +92,7 @@ int ping_get_port(struct sock *sk, unsigned short ident)
 				result++; /* avoid zero */
 			hlist = ping_hashslot(&ping_table, sock_net(sk),
 					    result);
-			ping_portaddr_for_each_entry(sk2, node, hlist) {
+			sk_for_each(sk2, hlist) {
 				isk2 = inet_sk(sk2);
 
 				if (isk2->inet_num == result)
@@ -115,7 +109,7 @@ int ping_get_port(struct sock *sk, unsigned short ident)
 			goto fail;
 	} else {
 		hlist = ping_hashslot(&ping_table, sock_net(sk), ident);
-		ping_portaddr_for_each_entry(sk2, node, hlist) {
+		sk_for_each(sk2, hlist) {
 			isk2 = inet_sk(sk2);
 
 			/* BUG? Why is this reuse and not reuseaddr? ping.c
@@ -133,9 +127,8 @@ int ping_get_port(struct sock *sk, unsigned short ident)
 	isk->inet_num = ident;
 	if (sk_unhashed(sk)) {
 		pr_debug("was not hashed\n");
-		sock_hold(sk);
+		sk_add_node_rcu(sk, hlist);
 		sock_set_flag(sk, SOCK_RCU_FREE);
-		hlist_nulls_add_head_rcu(&sk->sk_nulls_node, hlist);
 		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
 	}
 	spin_unlock(&ping_table.lock);
@@ -161,9 +154,7 @@ void ping_unhash(struct sock *sk)
 
 	pr_debug("ping_unhash(isk=%p,isk->num=%u)\n", isk, isk->inet_num);
 	spin_lock(&ping_table.lock);
-	if (sk_hashed(sk)) {
-		hlist_nulls_del_init_rcu(&sk->sk_nulls_node);
-		sock_put(sk);
+	if (sk_del_node_init_rcu(sk)) {
 		isk->inet_num = 0;
 		isk->inet_sport = 0;
 		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
@@ -175,10 +166,9 @@ EXPORT_SYMBOL_GPL(ping_unhash);
 /* Called under rcu_read_lock() */
 static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 {
-	struct hlist_nulls_head *hslot = ping_hashslot(&ping_table, net, ident);
+	struct hlist_head *hslot = ping_hashslot(&ping_table, net, ident);
 	struct sock *sk = NULL;
 	struct inet_sock *isk;
-	struct hlist_nulls_node *hnode;
 	int dif, sdif;
 
 	if (skb->protocol == htons(ETH_P_IP)) {
@@ -197,7 +187,7 @@ static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 		return NULL;
 	}
 
-	ping_portaddr_for_each_entry_rcu(sk, hnode, hslot) {
+	sk_for_each_rcu(sk, hslot) {
 		isk = inet_sk(sk);
 
 		pr_debug("iterate\n");
@@ -1045,15 +1035,14 @@ static struct sock *ping_get_first(struct seq_file *seq, int start)
 
 	for (state->bucket = start; state->bucket < PING_HTABLE_SIZE;
 	     ++state->bucket) {
-		struct hlist_nulls_node *node;
-		struct hlist_nulls_head *hslot;
+		struct hlist_head *hslot;
 
 		hslot = &ping_table.hash[state->bucket];
 
-		if (hlist_nulls_empty(hslot))
+		if (hlist_empty(hslot))
 			continue;
 
-		sk_nulls_for_each(sk, node, hslot) {
+		sk_for_each(sk, hslot) {
 			if (net_eq(sock_net(sk), net) &&
 			    sk->sk_family == state->family)
 				goto found;
@@ -1070,7 +1059,7 @@ static struct sock *ping_get_next(struct seq_file *seq, struct sock *sk)
 	struct net *net = seq_file_net(seq);
 
 	do {
-		sk = sk_nulls_next(sk);
+		sk = sk_next(sk);
 	} while (sk && (!net_eq(sock_net(sk), net)));
 
 	if (!sk)
@@ -1206,6 +1195,6 @@ void __init ping_init(void)
 	int i;
 
 	for (i = 0; i < PING_HTABLE_SIZE; i++)
-		INIT_HLIST_NULLS_HEAD(&ping_table.hash[i], i);
+		INIT_HLIST_HEAD(&ping_table.hash[i]);
 	spin_lock_init(&ping_table.lock);
 }
-- 
2.30.2


