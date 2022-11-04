Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97A6261A085
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 20:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiKDTHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 15:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiKDTHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 15:07:48 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D944C25A
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 12:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1667588867; x=1699124867;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5IrJ/D51fVe4v3QlwG9bBeZwV2fszqng6N3adWPzzaI=;
  b=vYVFD1IIREKu+Kd+XnWoeyqqXiVqJ85PsMydtUCrXiFqd+Q3gK/PPsXB
   aynWecw9lxFyQvISd5nAiIkLCnWR0fbT7bBXUDOV4e2Z7Ce/2PIqSBEWw
   kLfeT2KTEO1cLibn+pKcYFTivBxXawuiMwKbyGU7MhP7TDrdGRaiwIXio
   s=;
X-IronPort-AV: E=Sophos;i="5.96,138,1665446400"; 
   d="scan'208";a="263329717"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-b5bd57cf.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 19:07:46 +0000
Received: from EX13MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-b5bd57cf.us-east-1.amazon.com (Postfix) with ESMTPS id 49F6B41E38;
        Fri,  4 Nov 2022 19:07:44 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Fri, 4 Nov 2022 19:07:41 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.178) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Fri, 4 Nov 2022 19:07:39 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 3/6] udp: Set NULL to udp_seq_afinfo.udp_table.
Date:   Fri, 4 Nov 2022 12:06:09 -0700
Message-ID: <20221104190612.24206-4-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221104190612.24206-1-kuniyu@amazon.com>
References: <20221104190612.24206-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.178]
X-ClientProxiedBy: EX13D48UWA001.ant.amazon.com (10.43.163.52) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

This means we cannot use the global udp_seq_afinfo.udp_table
to fetch a UDP hash table.

Instead, set NULL to udp_seq_afinfo.udp_table for UDP and get
a proper table from net->ipv4.udp_table.

Note that we still need udp_seq_afinfo.udp_table for UDP LITE.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/udp.c | 32 ++++++++++++++++++++++++--------
 net/ipv6/udp.c |  2 +-
 2 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index acf934f61e2b..30d6d13fae0e 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -136,6 +136,12 @@ static struct udp_table *udp_get_table_prot(struct sock *sk)
 	return sk->sk_prot->h.udp_table ? : sock_net(sk)->ipv4.udp_table;
 }
 
+static struct udp_table *udp_get_table_afinfo(struct udp_seq_afinfo *afinfo,
+					      struct net *net)
+{
+	return afinfo->udp_table ? : net->ipv4.udp_table;
+}
+
 static int udp_lib_lport_inuse(struct net *net, __u16 num,
 			       const struct udp_hslot *hslot,
 			       unsigned long *bitmap,
@@ -2984,6 +2990,7 @@ static struct sock *udp_get_first(struct seq_file *seq, int start)
 	struct udp_iter_state *state = seq->private;
 	struct net *net = seq_file_net(seq);
 	struct udp_seq_afinfo *afinfo;
+	struct udp_table *udptable;
 	struct sock *sk;
 
 	if (state->bpf_seq_afinfo)
@@ -2991,9 +2998,11 @@ static struct sock *udp_get_first(struct seq_file *seq, int start)
 	else
 		afinfo = pde_data(file_inode(seq->file));
 
-	for (state->bucket = start; state->bucket <= afinfo->udp_table->mask;
+	udptable = udp_get_table_afinfo(afinfo, net);
+
+	for (state->bucket = start; state->bucket <= udptable->mask;
 	     ++state->bucket) {
-		struct udp_hslot *hslot = &afinfo->udp_table->hash[state->bucket];
+		struct udp_hslot *hslot = &udptable->hash[state->bucket];
 
 		if (hlist_empty(&hslot->head))
 			continue;
@@ -3018,6 +3027,7 @@ static struct sock *udp_get_next(struct seq_file *seq, struct sock *sk)
 	struct udp_iter_state *state = seq->private;
 	struct net *net = seq_file_net(seq);
 	struct udp_seq_afinfo *afinfo;
+	struct udp_table *udptable;
 
 	if (state->bpf_seq_afinfo)
 		afinfo = state->bpf_seq_afinfo;
@@ -3031,8 +3041,11 @@ static struct sock *udp_get_next(struct seq_file *seq, struct sock *sk)
 			 sk->sk_family != afinfo->family)));
 
 	if (!sk) {
-		if (state->bucket <= afinfo->udp_table->mask)
-			spin_unlock_bh(&afinfo->udp_table->hash[state->bucket].lock);
+		udptable = udp_get_table_afinfo(afinfo, net);
+
+		if (state->bucket <= udptable->mask)
+			spin_unlock_bh(&udptable->hash[state->bucket].lock);
+
 		return udp_get_first(seq, state->bucket + 1);
 	}
 	return sk;
@@ -3075,14 +3088,17 @@ void udp_seq_stop(struct seq_file *seq, void *v)
 {
 	struct udp_iter_state *state = seq->private;
 	struct udp_seq_afinfo *afinfo;
+	struct udp_table *udptable;
 
 	if (state->bpf_seq_afinfo)
 		afinfo = state->bpf_seq_afinfo;
 	else
 		afinfo = pde_data(file_inode(seq->file));
 
-	if (state->bucket <= afinfo->udp_table->mask)
-		spin_unlock_bh(&afinfo->udp_table->hash[state->bucket].lock);
+	udptable = udp_get_table_afinfo(afinfo, seq_file_net(seq));
+
+	if (state->bucket <= udptable->mask)
+		spin_unlock_bh(&udptable->hash[state->bucket].lock);
 }
 EXPORT_SYMBOL(udp_seq_stop);
 
@@ -3195,7 +3211,7 @@ EXPORT_SYMBOL(udp_seq_ops);
 
 static struct udp_seq_afinfo udp4_seq_afinfo = {
 	.family		= AF_INET,
-	.udp_table	= &udp_table,
+	.udp_table	= NULL,
 };
 
 static int __net_init udp4_proc_init_net(struct net *net)
@@ -3315,7 +3331,7 @@ static int bpf_iter_init_udp(void *priv_data, struct bpf_iter_aux_info *aux)
 		return -ENOMEM;
 
 	afinfo->family = AF_UNSPEC;
-	afinfo->udp_table = &udp_table;
+	afinfo->udp_table = NULL;
 	st->bpf_seq_afinfo = afinfo;
 	ret = bpf_iter_init_seq_net(priv_data, aux);
 	if (ret)
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 7a877eb2a479..96cda268412e 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1722,7 +1722,7 @@ EXPORT_SYMBOL(udp6_seq_ops);
 
 static struct udp_seq_afinfo udp6_seq_afinfo = {
 	.family		= AF_INET6,
-	.udp_table	= &udp_table,
+	.udp_table	= NULL,
 };
 
 int __net_init udp6_proc_init(struct net *net)
-- 
2.30.2

