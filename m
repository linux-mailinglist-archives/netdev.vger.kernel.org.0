Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEC85A1D99
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 02:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244490AbiHZAIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 20:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238683AbiHZAI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 20:08:28 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA3EC88A4;
        Thu, 25 Aug 2022 17:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661472507; x=1693008507;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8cBbbgxMOWbr387X8gp+E7vzk+Wem09aMViQIOnIrW8=;
  b=mYd5HyaEtYekZ4VV3TE3a2oiYrNLh7QjkD8ypQY3SLs3p81zfy5jbPOi
   HLKsM1WkkiWi2rzZ/1jicmFJkDOojzeF/EUWhBkkI0g5LabD8UdRhADIh
   3AsQTpd2Y/4Sdw4niGGARoIDkGrUmQmjP3/DFSiDV64KvVVMgdyRYfX6T
   0=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-4213ea4c.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 00:08:24 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-4213ea4c.us-west-2.amazon.com (Postfix) with ESMTPS id 9872A8233B;
        Fri, 26 Aug 2022 00:08:22 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 26 Aug 2022 00:08:22 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.140) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Fri, 26 Aug 2022 00:08:18 +0000
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
Subject: [PATCH v1 net-next 11/13] udp: Set NULL to udp_seq_afinfo.udp_table.
Date:   Thu, 25 Aug 2022 17:04:43 -0700
Message-ID: <20220826000445.46552-12-kuniyu@amazon.com>
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
index 1bfae1fbe682..17b4b175fc67 100644
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
@@ -2978,6 +2984,7 @@ static struct sock *udp_get_first(struct seq_file *seq, int start)
 	struct udp_iter_state *state = seq->private;
 	struct net *net = seq_file_net(seq);
 	struct udp_seq_afinfo *afinfo;
+	struct udp_table *udptable;
 	struct sock *sk;
 
 	if (state->bpf_seq_afinfo)
@@ -2985,9 +2992,11 @@ static struct sock *udp_get_first(struct seq_file *seq, int start)
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
@@ -3012,6 +3021,7 @@ static struct sock *udp_get_next(struct seq_file *seq, struct sock *sk)
 	struct udp_iter_state *state = seq->private;
 	struct net *net = seq_file_net(seq);
 	struct udp_seq_afinfo *afinfo;
+	struct udp_table *udptable;
 
 	if (state->bpf_seq_afinfo)
 		afinfo = state->bpf_seq_afinfo;
@@ -3025,8 +3035,11 @@ static struct sock *udp_get_next(struct seq_file *seq, struct sock *sk)
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
@@ -3069,14 +3082,17 @@ void udp_seq_stop(struct seq_file *seq, void *v)
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
 
@@ -3189,7 +3205,7 @@ EXPORT_SYMBOL(udp_seq_ops);
 
 static struct udp_seq_afinfo udp4_seq_afinfo = {
 	.family		= AF_INET,
-	.udp_table	= &udp_table,
+	.udp_table	= NULL,
 };
 
 static int __net_init udp4_proc_init_net(struct net *net)
@@ -3309,7 +3325,7 @@ static int bpf_iter_init_udp(void *priv_data, struct bpf_iter_aux_info *aux)
 		return -ENOMEM;
 
 	afinfo->family = AF_UNSPEC;
-	afinfo->udp_table = &udp_table;
+	afinfo->udp_table = NULL;
 	st->bpf_seq_afinfo = afinfo;
 	ret = bpf_iter_init_seq_net(priv_data, aux);
 	if (ret)
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 5dc069d5ad1e..8abf16c5a8a1 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1697,7 +1697,7 @@ EXPORT_SYMBOL(udp6_seq_ops);
 
 static struct udp_seq_afinfo udp6_seq_afinfo = {
 	.family		= AF_INET6,
-	.udp_table	= &udp_table,
+	.udp_table	= NULL,
 };
 
 int __net_init udp6_proc_init(struct net *net)
-- 
2.30.2

