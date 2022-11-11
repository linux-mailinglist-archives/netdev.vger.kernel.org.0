Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DECA0625220
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 05:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbiKKEEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 23:04:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232170AbiKKEDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 23:03:48 -0500
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52F068293
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 20:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1668139326; x=1699675326;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6U40a0ZcOlL4ErV6ZnGSie/PacpI0Am6I5DZhol5pHg=;
  b=QOsB8FIR3A5PTNFyTL1GmUqk8+3ix2w5J56aBK3zLkoTsbHXlHYDrRvk
   j04OfNi8io9ENzCHsmLxSs2FH39o2d93d+T6BqXggA3DGqf19w+Zrl7Lz
   qNvK5elMRkFTLzHXmqFM32oFt0z3lMSlpxULP16kpdxU7C97JodXCoOtV
   o=;
X-IronPort-AV: E=Sophos;i="5.96,155,1665446400"; 
   d="scan'208";a="261983488"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-54a853e6.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2022 04:02:05 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-54a853e6.us-east-1.amazon.com (Postfix) with ESMTPS id 7986D41EA2;
        Fri, 11 Nov 2022 04:02:03 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Fri, 11 Nov 2022 04:02:02 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.178) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Fri, 11 Nov 2022 04:02:00 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 net-next 3/6] udp: Set NULL to udp_seq_afinfo.udp_table.
Date:   Thu, 10 Nov 2022 20:00:31 -0800
Message-ID: <20221111040034.29736-4-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221111040034.29736-1-kuniyu@amazon.com>
References: <20221111040034.29736-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.178]
X-ClientProxiedBy: EX13D21UWA004.ant.amazon.com (10.43.160.252) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index 6206c27a1659..a1a15eb76304 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2980,11 +2980,18 @@ EXPORT_SYMBOL(udp_prot);
 /* ------------------------------------------------------------------------ */
 #ifdef CONFIG_PROC_FS
 
+static struct udp_table *udp_get_table_afinfo(struct udp_seq_afinfo *afinfo,
+					      struct net *net)
+{
+	return afinfo->udp_table ? : net->ipv4.udp_table;
+}
+
 static struct sock *udp_get_first(struct seq_file *seq, int start)
 {
 	struct udp_iter_state *state = seq->private;
 	struct net *net = seq_file_net(seq);
 	struct udp_seq_afinfo *afinfo;
+	struct udp_table *udptable;
 	struct sock *sk;
 
 	if (state->bpf_seq_afinfo)
@@ -2992,9 +2999,11 @@ static struct sock *udp_get_first(struct seq_file *seq, int start)
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
@@ -3019,6 +3028,7 @@ static struct sock *udp_get_next(struct seq_file *seq, struct sock *sk)
 	struct udp_iter_state *state = seq->private;
 	struct net *net = seq_file_net(seq);
 	struct udp_seq_afinfo *afinfo;
+	struct udp_table *udptable;
 
 	if (state->bpf_seq_afinfo)
 		afinfo = state->bpf_seq_afinfo;
@@ -3032,8 +3042,11 @@ static struct sock *udp_get_next(struct seq_file *seq, struct sock *sk)
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
@@ -3076,14 +3089,17 @@ void udp_seq_stop(struct seq_file *seq, void *v)
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
 
@@ -3196,7 +3212,7 @@ EXPORT_SYMBOL(udp_seq_ops);
 
 static struct udp_seq_afinfo udp4_seq_afinfo = {
 	.family		= AF_INET,
-	.udp_table	= &udp_table,
+	.udp_table	= NULL,
 };
 
 static int __net_init udp4_proc_init_net(struct net *net)
@@ -3316,7 +3332,7 @@ static int bpf_iter_init_udp(void *priv_data, struct bpf_iter_aux_info *aux)
 		return -ENOMEM;
 
 	afinfo->family = AF_UNSPEC;
-	afinfo->udp_table = &udp_table;
+	afinfo->udp_table = NULL;
 	st->bpf_seq_afinfo = afinfo;
 	ret = bpf_iter_init_seq_net(priv_data, aux);
 	if (ret)
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index bbd6dc398f3b..c3dee1f8d3bd 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1724,7 +1724,7 @@ EXPORT_SYMBOL(udp6_seq_ops);
 
 static struct udp_seq_afinfo udp6_seq_afinfo = {
 	.family		= AF_INET6,
-	.udp_table	= &udp_table,
+	.udp_table	= NULL,
 };
 
 int __net_init udp6_proc_init(struct net *net)
-- 
2.30.2

