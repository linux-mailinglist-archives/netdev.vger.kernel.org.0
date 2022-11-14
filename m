Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284B6628BB2
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 22:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237136AbiKNV7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 16:59:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237743AbiKNV7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 16:59:04 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C4E193D8
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 13:59:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1668463144; x=1699999144;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aJtkbBl6Y/BhI8IZIp3mfRS+q+HsblO+bd+7TU3+K4o=;
  b=fIqucwfQAt52y4ib76fH9omUGkGONwfmzH1/wqE6v26MaE/CxwMlQVin
   MBTikYUUzTlinW1Hg8TK3GO/GPoXcspYlDkAIGUakYAIlVp5jWQERAS9b
   xIFCKdX6J1Eem/JvFyvu8Jl/Yh5w8hIDvPhaI9UOA0ka1pEk+sdmKt9wv
   A=;
X-IronPort-AV: E=Sophos;i="5.96,164,1665446400"; 
   d="scan'208";a="150656918"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-6e7a78d7.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 21:59:02 +0000
Received: from EX13MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-6e7a78d7.us-east-1.amazon.com (Postfix) with ESMTPS id 1F74D81511;
        Mon, 14 Nov 2022 21:58:59 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Mon, 14 Nov 2022 21:58:59 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.178) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Mon, 14 Nov 2022 21:58:57 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v4 net-next 2/5] udp: Set NULL to sk->sk_prot->h.udp_table.
Date:   Mon, 14 Nov 2022 13:57:54 -0800
Message-ID: <20221114215757.37455-3-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221114215757.37455-1-kuniyu@amazon.com>
References: <20221114215757.37455-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.178]
X-ClientProxiedBy: EX13D30UWC001.ant.amazon.com (10.43.162.128) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We will soon introduce an optional per-netns hash table
for UDP.

This means we cannot use the global sk->sk_prot->h.udp_table
to fetch a UDP hash table.

Instead, set NULL to sk->sk_prot->h.udp_table for UDP and get
a proper table from net->ipv4.udp_table.

Note that we still need sk->sk_prot->h.udp_table for UDP LITE.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/netns/ipv4.h |  1 +
 net/ipv4/udp.c           | 15 +++++++++++----
 net/ipv6/udp.c           |  2 +-
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 25f90bba4889..e4cc4d3cacc4 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -43,6 +43,7 @@ struct tcp_fastopen_context;
 
 struct netns_ipv4 {
 	struct inet_timewait_death_row tcp_death_row;
+	struct udp_table *udp_table;
 
 #ifdef CONFIG_SYSCTL
 	struct ctl_table_header	*forw_hdr;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index a34de263e9ce..6206c27a1659 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -131,6 +131,11 @@ EXPORT_PER_CPU_SYMBOL_GPL(udp_memory_per_cpu_fw_alloc);
 #define MAX_UDP_PORTS 65536
 #define PORTS_PER_CHAIN (MAX_UDP_PORTS / UDP_HTABLE_SIZE_MIN)
 
+static struct udp_table *udp_get_table_prot(struct sock *sk)
+{
+	return sk->sk_prot->h.udp_table ? : sock_net(sk)->ipv4.udp_table;
+}
+
 static int udp_lib_lport_inuse(struct net *net, __u16 num,
 			       const struct udp_hslot *hslot,
 			       unsigned long *bitmap,
@@ -232,7 +237,7 @@ static int udp_reuseport_add_sock(struct sock *sk, struct udp_hslot *hslot)
 int udp_lib_get_port(struct sock *sk, unsigned short snum,
 		     unsigned int hash2_nulladdr)
 {
-	struct udp_table *udptable = sk->sk_prot->h.udp_table;
+	struct udp_table *udptable = udp_get_table_prot(sk);
 	struct udp_hslot *hslot, *hslot2;
 	struct net *net = sock_net(sk);
 	int error = 1;
@@ -1999,7 +2004,7 @@ EXPORT_SYMBOL(udp_disconnect);
 void udp_lib_unhash(struct sock *sk)
 {
 	if (sk_hashed(sk)) {
-		struct udp_table *udptable = sk->sk_prot->h.udp_table;
+		struct udp_table *udptable = udp_get_table_prot(sk);
 		struct udp_hslot *hslot, *hslot2;
 
 		hslot  = udp_hashslot(udptable, sock_net(sk),
@@ -2030,7 +2035,7 @@ EXPORT_SYMBOL(udp_lib_unhash);
 void udp_lib_rehash(struct sock *sk, u16 newhash)
 {
 	if (sk_hashed(sk)) {
-		struct udp_table *udptable = sk->sk_prot->h.udp_table;
+		struct udp_table *udptable = udp_get_table_prot(sk);
 		struct udp_hslot *hslot, *hslot2, *nhslot2;
 
 		hslot2 = udp_hashslot2(udptable, udp_sk(sk)->udp_portaddr_hash);
@@ -2967,7 +2972,7 @@ struct proto udp_prot = {
 	.sysctl_wmem_offset	= offsetof(struct net, ipv4.sysctl_udp_wmem_min),
 	.sysctl_rmem_offset	= offsetof(struct net, ipv4.sysctl_udp_rmem_min),
 	.obj_size		= sizeof(struct udp_sock),
-	.h.udp_table		= &udp_table,
+	.h.udp_table		= NULL,
 	.diag_destroy		= udp_abort,
 };
 EXPORT_SYMBOL(udp_prot);
@@ -3280,6 +3285,8 @@ EXPORT_SYMBOL(udp_flow_hashrnd);
 
 static int __net_init udp_sysctl_init(struct net *net)
 {
+	net->ipv4.udp_table = &udp_table;
+
 	net->ipv4.sysctl_udp_rmem_min = PAGE_SIZE;
 	net->ipv4.sysctl_udp_wmem_min = PAGE_SIZE;
 
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 727de67e4c90..bbd6dc398f3b 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1774,7 +1774,7 @@ struct proto udpv6_prot = {
 	.sysctl_wmem_offset     = offsetof(struct net, ipv4.sysctl_udp_wmem_min),
 	.sysctl_rmem_offset     = offsetof(struct net, ipv4.sysctl_udp_rmem_min),
 	.obj_size		= sizeof(struct udp6_sock),
-	.h.udp_table		= &udp_table,
+	.h.udp_table		= NULL,
 	.diag_destroy		= udp_abort,
 };
 
-- 
2.30.2

