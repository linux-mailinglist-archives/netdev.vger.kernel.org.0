Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1538F5A1D92
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 02:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243919AbiHZAIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 20:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242873AbiHZAIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 20:08:16 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC12C7FAD;
        Thu, 25 Aug 2022 17:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661472495; x=1693008495;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jvA6rXQ4x1824Pdsdu1jyLqM8NOA9+teC+8Pnvq+334=;
  b=PURFlA/XnOE4mg2Rv00a7giqWGArxAEAeBrBdnsO1U2v1y14rujbGEW1
   Xx0N2F7biOjqwKaN/sywbL9qkd/Zxunlc14iTkL+sAcyEQlrt9bSwR2Al
   Di2kYV/AjdnncvSAW3IKsplOfWlFP0izmdn5jp3tvhVJaRjJkCpBo3JtN
   I=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-e6c05252.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 00:08:12 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-e6c05252.us-west-2.amazon.com (Postfix) with ESMTPS id 1CAF444EF4;
        Fri, 26 Aug 2022 00:08:07 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 26 Aug 2022 00:08:06 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.140) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Fri, 26 Aug 2022 00:08:03 +0000
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
Subject: [PATCH v1 net-next 10/13] udp: Set NULL to sk->sk_prot->h.udp_table.
Date:   Thu, 25 Aug 2022 17:04:42 -0700
Message-ID: <20220826000445.46552-11-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220826000445.46552-1-kuniyu@amazon.com>
References: <20220826000445.46552-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.140]
X-ClientProxiedBy: EX13D10UWB001.ant.amazon.com (10.43.161.111) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
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
index 6d9c01879027..c367da5d61e2 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -42,6 +42,7 @@ struct tcp_fastopen_context;
 
 struct netns_ipv4 {
 	struct inet_timewait_death_row *tcp_death_row;
+	struct udp_table *udp_table;
 
 #ifdef CONFIG_SYSCTL
 	struct ctl_table_header	*forw_hdr;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index c073304e60bb..1bfae1fbe682 100644
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
@@ -2004,7 +2009,7 @@ EXPORT_SYMBOL(udp_disconnect);
 void udp_lib_unhash(struct sock *sk)
 {
 	if (sk_hashed(sk)) {
-		struct udp_table *udptable = sk->sk_prot->h.udp_table;
+		struct udp_table *udptable = udp_get_table_prot(sk);
 		struct udp_hslot *hslot, *hslot2;
 
 		hslot  = udp_hashslot(udptable, sock_net(sk),
@@ -2035,7 +2040,7 @@ EXPORT_SYMBOL(udp_lib_unhash);
 void udp_lib_rehash(struct sock *sk, u16 newhash)
 {
 	if (sk_hashed(sk)) {
-		struct udp_table *udptable = sk->sk_prot->h.udp_table;
+		struct udp_table *udptable = udp_get_table_prot(sk);
 		struct udp_hslot *hslot, *hslot2, *nhslot2;
 
 		hslot2 = udp_hashslot2(udptable, udp_sk(sk)->udp_portaddr_hash);
@@ -2960,7 +2965,7 @@ struct proto udp_prot = {
 	.sysctl_wmem_offset	= offsetof(struct net, ipv4.sysctl_udp_wmem_min),
 	.sysctl_rmem_offset	= offsetof(struct net, ipv4.sysctl_udp_rmem_min),
 	.obj_size		= sizeof(struct udp_sock),
-	.h.udp_table		= &udp_table,
+	.h.udp_table		= NULL,
 	.diag_destroy		= udp_abort,
 };
 EXPORT_SYMBOL(udp_prot);
@@ -3273,6 +3278,8 @@ EXPORT_SYMBOL(udp_flow_hashrnd);
 
 static int __net_init udp_sysctl_init(struct net *net)
 {
+	net->ipv4.udp_table = &udp_table;
+
 	net->ipv4.sysctl_udp_rmem_min = PAGE_SIZE;
 	net->ipv4.sysctl_udp_wmem_min = PAGE_SIZE;
 
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index f7e0248a00bc..5dc069d5ad1e 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1747,7 +1747,7 @@ struct proto udpv6_prot = {
 	.sysctl_wmem_offset     = offsetof(struct net, ipv4.sysctl_udp_wmem_min),
 	.sysctl_rmem_offset     = offsetof(struct net, ipv4.sysctl_udp_rmem_min),
 	.obj_size		= sizeof(struct udp6_sock),
-	.h.udp_table		= &udp_table,
+	.h.udp_table		= NULL,
 	.diag_destroy		= udp_abort,
 };
 
-- 
2.30.2

