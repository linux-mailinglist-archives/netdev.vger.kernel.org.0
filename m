Return-Path: <netdev+bounces-6203-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E48D7152DF
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 03:09:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2860C280D4A
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 01:09:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 134EB807;
	Tue, 30 May 2023 01:09:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D227ED
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 01:09:17 +0000 (UTC)
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B9A8CF
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 18:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685408956; x=1716944956;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rQniC1g0f4YHhA7JB1ANDTfVfvXaUJtGZZhHL5yqQBs=;
  b=Fk2WWvizUB9cSkYfJCzGZ2XxQgJQSod9ApbQ5E+qvZ1mWmCI4MrA/H/q
   CgFhmjsbJDZucsnSZ2wHhCy1tQxQWisNnuiKBRJHb/fQsJaClkouO+Z1z
   AZ0YvioNdJ/mgHh0lav7bEhPb5gO76ZsHEBoJHP+t/U8ZXfAiOUMZLqwu
   k=;
X-IronPort-AV: E=Sophos;i="6.00,201,1681171200"; 
   d="scan'208";a="217403825"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-3e1fab07.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 01:09:14 +0000
Received: from EX19MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
	by email-inbound-relay-iad-1e-m6i4x-3e1fab07.us-east-1.amazon.com (Postfix) with ESMTPS id 50B3D80511;
	Tue, 30 May 2023 01:09:11 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 30 May 2023 01:09:10 +0000
Received: from 88665a182662.ant.amazon.com.com (10.106.101.39) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 30 May 2023 01:09:07 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, David Ahern <dsahern@kernel.org>, Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>
CC: Kuniyuki Iwashima <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 12/14] udp: Remove udp_table in struct proto.
Date: Mon, 29 May 2023 18:03:46 -0700
Message-ID: <20230530010348.21425-13-kuniyu@amazon.com>
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
X-ClientProxiedBy: EX19D031UWC001.ant.amazon.com (10.13.139.241) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

We managed UDP-Lite sockets in a global hash table (udplite_table) that
we can get from the global per-protocol variable, sk_prot->h.udp_table.

OTOH, we use per-netns hash tables for UDP, so we set NULL to
sk_prot->h.udp_table.

When we got a hash table, we needed to check if sk_prot->h.udp_table was
NULL to get a proper one.

However, we no longer support UDP-Lite and always use the per-netns hash
table without the test.  Also, we can remove h.udp_table in struct proto.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/sock.h |  1 -
 net/ipv4/udp.c     | 16 +++++++---------
 net/ipv6/udp.c     |  1 -
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 0b6c74bdd688..52f56a01b590 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1339,7 +1339,6 @@ struct proto {
 
 	union {
 		struct inet_hashinfo	*hashinfo;
-		struct udp_table	*udp_table;
 		struct raw_hashinfo	*raw_hash;
 		struct smc_hashinfo	*smc_hash;
 	} h;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index eb968d20d5a8..8b460e0e73bc 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -132,11 +132,6 @@ EXPORT_PER_CPU_SYMBOL_GPL(udp_memory_per_cpu_fw_alloc);
 #define MAX_UDP_PORTS 65536
 #define PORTS_PER_CHAIN (MAX_UDP_PORTS / UDP_HTABLE_SIZE_MIN_PERNET)
 
-static struct udp_table *udp_get_table_prot(struct sock *sk)
-{
-	return sk->sk_prot->h.udp_table ? : sock_net(sk)->ipv4.udp_table;
-}
-
 static int udp_lib_lport_inuse(struct net *net, __u16 num,
 			       const struct udp_hslot *hslot,
 			       unsigned long *bitmap,
@@ -238,11 +233,13 @@ static int udp_reuseport_add_sock(struct sock *sk, struct udp_hslot *hslot)
 int udp_lib_get_port(struct sock *sk, unsigned short snum,
 		     unsigned int hash2_nulladdr)
 {
-	struct udp_table *udptable = udp_get_table_prot(sk);
 	struct udp_hslot *hslot, *hslot2;
 	struct net *net = sock_net(sk);
+	struct udp_table *udptable;
 	int error = -EADDRINUSE;
 
+	udptable = net->ipv4.udp_table;
+
 	if (!snum) {
 		DECLARE_BITMAP(bitmap, PORTS_PER_CHAIN);
 		unsigned short first, last;
@@ -1945,10 +1942,11 @@ EXPORT_SYMBOL(udp_disconnect);
 void udp_lib_unhash(struct sock *sk)
 {
 	if (sk_hashed(sk)) {
-		struct udp_table *udptable = udp_get_table_prot(sk);
 		struct udp_hslot *hslot, *hslot2;
 		struct net *net = sock_net(sk);
+		struct udp_table *udptable;
 
+		udptable = net->ipv4.udp_table;
 		hslot  = udp_hashslot(udptable, net, udp_sk(sk)->udp_port_hash);
 		hslot2 = udp_hashslot2(udptable, udp_sk(sk)->udp_portaddr_hash);
 
@@ -1976,10 +1974,11 @@ EXPORT_SYMBOL(udp_lib_unhash);
 void udp_lib_rehash(struct sock *sk, u16 newhash)
 {
 	if (sk_hashed(sk)) {
-		struct udp_table *udptable = udp_get_table_prot(sk);
 		struct udp_hslot *hslot, *hslot2, *nhslot2;
 		struct net *net = sock_net(sk);
+		struct udp_table *udptable;
 
+		udptable = net->ipv4.udp_table;
 		hslot2 = udp_hashslot2(udptable, udp_sk(sk)->udp_portaddr_hash);
 		nhslot2 = udp_hashslot2(udptable, newhash);
 		udp_sk(sk)->udp_portaddr_hash = newhash;
@@ -2819,7 +2818,6 @@ struct proto udp_prot = {
 	.sysctl_wmem_offset	= offsetof(struct net, ipv4.sysctl_udp_wmem_min),
 	.sysctl_rmem_offset	= offsetof(struct net, ipv4.sysctl_udp_rmem_min),
 	.obj_size		= sizeof(struct udp_sock),
-	.h.udp_table		= NULL,
 	.diag_destroy		= udp_abort,
 };
 EXPORT_SYMBOL(udp_prot);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 6f5c29af4157..23480b84ba08 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1778,7 +1778,6 @@ struct proto udpv6_prot = {
 	.sysctl_wmem_offset     = offsetof(struct net, ipv4.sysctl_udp_wmem_min),
 	.sysctl_rmem_offset     = offsetof(struct net, ipv4.sysctl_udp_rmem_min),
 	.obj_size		= sizeof(struct udp6_sock),
-	.h.udp_table		= NULL,
 	.diag_destroy		= udp_abort,
 };
 
-- 
2.30.2


