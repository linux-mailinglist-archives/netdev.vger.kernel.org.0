Return-Path: <netdev+bounces-6204-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D2C47152E0
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 03:09:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B5FA71C20B0B
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 01:09:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C70380E;
	Tue, 30 May 2023 01:09:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00338803
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 01:09:40 +0000 (UTC)
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1D8DE
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 18:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685408978; x=1716944978;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gZOpQZmYt1RVgtTysHCYENwMUz2aLy99+Qno+r2YECY=;
  b=uiXLry1yqN3SIRlNH11FpRGhpERk/t6T6m4ZiVn1MvPndfhrQG3sxDIZ
   eSXXO78Xrksk0Zqnm6zA7+S15CGCDmfPfySeShoSJSYd8KRjXbQlR6nhi
   ZW6nycJ5bUPmsED6X68N8amgXyfZ3Dh6YdMOpuzlQAUkw3HGlvzOZUaUH
   c=;
X-IronPort-AV: E=Sophos;i="6.00,201,1681171200"; 
   d="scan'208";a="6648352"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-f7c754c9.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 01:09:37 +0000
Received: from EX19MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
	by email-inbound-relay-pdx-2c-m6i4x-f7c754c9.us-west-2.amazon.com (Postfix) with ESMTPS id 9FD7E40D9A;
	Tue, 30 May 2023 01:09:36 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 30 May 2023 01:09:35 +0000
Received: from 88665a182662.ant.amazon.com.com (10.106.101.39) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 30 May 2023 01:09:32 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, David Ahern <dsahern@kernel.org>, Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>
CC: Kuniyuki Iwashima <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 13/14] udp: Remove udp_table in struct udp_seq_afinfo.
Date: Mon, 29 May 2023 18:03:47 -0700
Message-ID: <20230530010348.21425-14-kuniyu@amazon.com>
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
X-ClientProxiedBy: EX19D044UWB003.ant.amazon.com (10.13.139.168) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

We managed UDP-Lite sockets in a global hash table (udplite_table) that
we can get from a per-protocol variable, udp_seq_afinfo.udp_table.

OTOH, we use per-netns hash tables for UDP, so we set NULL to
udp_seq_afinfo.udp_table.

When we got a hash table, we needed to check if udp_seq_afinfo.udp_table
was NULL to get a proper one.

However, we no longer support UDP-Lite and always use the per-netns
hash table without the test.  Also, we can remove udp_table in struct
udp_seq_afinfo.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/udp.h |  1 -
 net/ipv4/udp.c    | 22 ++++------------------
 net/ipv6/udp.c    |  1 -
 3 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/include/net/udp.h b/include/net/udp.h
index 902ee75bd25e..ea2308989dc7 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -414,7 +414,6 @@ static inline int copy_linear_skb(struct sk_buff *skb, int len, int off,
 #ifdef CONFIG_PROC_FS
 struct udp_seq_afinfo {
 	sa_family_t			family;
-	struct udp_table		*udp_table;
 };
 
 struct udp_iter_state {
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 8b460e0e73bc..7eddf88dfce6 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2837,21 +2837,8 @@ static bool seq_sk_match(struct seq_file *seq, const struct sock *sk)
 
 #ifdef CONFIG_BPF_SYSCALL
 static const struct seq_operations bpf_iter_udp_seq_ops;
-#endif
-static struct udp_table *udp_get_table_seq(struct seq_file *seq,
-					   struct net *net)
-{
-	const struct udp_seq_afinfo *afinfo;
-
-#ifdef CONFIG_BPF_SYSCALL
-	if (seq->op == &bpf_iter_udp_seq_ops)
-		return net->ipv4.udp_table;
 #endif
 
-	afinfo = pde_data(file_inode(seq->file));
-	return afinfo->udp_table ? : net->ipv4.udp_table;
-}
-
 static struct sock *udp_get_first(struct seq_file *seq, int start)
 {
 	struct udp_iter_state *state = seq->private;
@@ -2859,7 +2846,7 @@ static struct sock *udp_get_first(struct seq_file *seq, int start)
 	struct udp_table *udptable;
 	struct sock *sk;
 
-	udptable = udp_get_table_seq(seq, net);
+	udptable = net->ipv4.udp_table;
 
 	for (state->bucket = start; state->bucket <= udptable->mask;
 	     ++state->bucket) {
@@ -2891,7 +2878,7 @@ static struct sock *udp_get_next(struct seq_file *seq, struct sock *sk)
 	} while (sk && !seq_sk_match(seq, sk));
 
 	if (!sk) {
-		udptable = udp_get_table_seq(seq, net);
+		udptable = net->ipv4.udp_table;
 
 		if (state->bucket <= udptable->mask)
 			spin_unlock_bh(&udptable->hash[state->bucket].lock);
@@ -2939,7 +2926,7 @@ void udp_seq_stop(struct seq_file *seq, void *v)
 	struct udp_iter_state *state = seq->private;
 	struct udp_table *udptable;
 
-	udptable = udp_get_table_seq(seq, seq_file_net(seq));
+	udptable = seq_file_net(seq)->ipv4.udp_table;
 
 	if (state->bucket <= udptable->mask)
 		spin_unlock_bh(&udptable->hash[state->bucket].lock);
@@ -3020,7 +3007,7 @@ static struct sock *bpf_iter_udp_batch(struct seq_file *seq)
 		iter->offset = 0;
 	}
 
-	udptable = udp_get_table_seq(seq, net);
+	udptable = net->ipv4.udp_table;
 
 again:
 	/* New batch for the next bucket.
@@ -3229,7 +3216,6 @@ EXPORT_SYMBOL(udp_seq_ops);
 
 static struct udp_seq_afinfo udp4_seq_afinfo = {
 	.family		= AF_INET,
-	.udp_table	= NULL,
 };
 
 static int __net_init udp4_proc_init_net(struct net *net)
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 23480b84ba08..066e9b9ae5f0 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1728,7 +1728,6 @@ EXPORT_SYMBOL(udp6_seq_ops);
 
 static struct udp_seq_afinfo udp6_seq_afinfo = {
 	.family		= AF_INET6,
-	.udp_table	= NULL,
 };
 
 int __net_init udp6_proc_init(struct net *net)
-- 
2.30.2


