Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34FF15A1D90
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 02:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244394AbiHZAHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 20:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242532AbiHZAHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 20:07:54 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E625C876E;
        Thu, 25 Aug 2022 17:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661472473; x=1693008473;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QG8/xaeHJQ4qgHGmjgsXS9m7tqs3JRVyjg7b7hW6y/c=;
  b=JBnWWy1rMa6GLfezidJXSRtc3UTRW3ewhKUahSrwcJsRm0zXrkRMD5B+
   ezOgPKunjFa71pPBc+bqZhOzNP2geFo64eDwnWtczE1CBrhNi5Ewi/s7L
   cX8CGm/TU+NvXdk+5fsnkCqj3VrO6WYCc/jliCdJEvrALoWn6AgAEbUOM
   M=;
X-IronPort-AV: E=Sophos;i="5.93,264,1654560000"; 
   d="scan'208";a="123539416"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-4213ea4c.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 00:07:53 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-4213ea4c.us-west-2.amazon.com (Postfix) with ESMTPS id 7B32D8231F;
        Fri, 26 Aug 2022 00:07:52 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 26 Aug 2022 00:07:51 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.140) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Fri, 26 Aug 2022 00:07:48 +0000
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
Subject: [PATCH v1 net-next 09/13] udp: Clean up some functions.
Date:   Thu, 25 Aug 2022 17:04:41 -0700
Message-ID: <20220826000445.46552-10-kuniyu@amazon.com>
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
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds no functional change and cleans up some functions
that the following patches touch around so that we make them tidy
and easy to review/revert.  The change is

  - Keep reverse christmas tree order

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/udp.c | 35 +++++++++++++++++++++--------------
 net/ipv6/udp.c | 12 ++++++++----
 2 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 34eda973bbf1..c073304e60bb 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -232,10 +232,10 @@ static int udp_reuseport_add_sock(struct sock *sk, struct udp_hslot *hslot)
 int udp_lib_get_port(struct sock *sk, unsigned short snum,
 		     unsigned int hash2_nulladdr)
 {
-	struct udp_hslot *hslot, *hslot2;
 	struct udp_table *udptable = sk->sk_prot->h.udp_table;
-	int    error = 1;
+	struct udp_hslot *hslot, *hslot2;
 	struct net *net = sock_net(sk);
+	int error = 1;
 
 	if (!snum) {
 		int low, high, remaining;
@@ -2524,10 +2524,13 @@ static struct sock *__udp4_lib_mcast_demux_lookup(struct net *net,
 						  __be16 rmt_port, __be32 rmt_addr,
 						  int dif, int sdif)
 {
-	struct sock *sk, *result;
 	unsigned short hnum = ntohs(loc_port);
-	unsigned int slot = udp_hashfn(net, hnum, udp_table.mask);
-	struct udp_hslot *hslot = &udp_table.hash[slot];
+	struct sock *sk, *result;
+	struct udp_hslot *hslot;
+	unsigned int slot;
+
+	slot = udp_hashfn(net, hnum, udp_table.mask);
+	hslot = &udp_table.hash[slot];
 
 	/* Do not bother scanning a too big list */
 	if (hslot->count > 10)
@@ -2555,14 +2558,18 @@ static struct sock *__udp4_lib_demux_lookup(struct net *net,
 					    __be16 rmt_port, __be32 rmt_addr,
 					    int dif, int sdif)
 {
-	unsigned short hnum = ntohs(loc_port);
-	unsigned int hash2 = ipv4_portaddr_hash(net, loc_addr, hnum);
-	unsigned int slot2 = hash2 & udp_table.mask;
-	struct udp_hslot *hslot2 = &udp_table.hash2[slot2];
 	INET_ADDR_COOKIE(acookie, rmt_addr, loc_addr);
-	const __portpair ports = INET_COMBINED_PORTS(rmt_port, hnum);
+	unsigned short hnum = ntohs(loc_port);
+	unsigned int hash2, slot2;
+	struct udp_hslot *hslot2;
+	__portpair ports;
 	struct sock *sk;
 
+	hash2 = ipv4_portaddr_hash(net, loc_addr, hnum);
+	slot2 = hash2 & udp_table.mask;
+	hslot2 = &udp_table.hash2[slot2];
+	ports = INET_COMBINED_PORTS(rmt_port, hnum);
+
 	udp_portaddr_for_each_entry_rcu(sk, &hslot2->head) {
 		if (inet_match(net, sk, acookie, ports, dif, sdif))
 			return sk;
@@ -2963,10 +2970,10 @@ EXPORT_SYMBOL(udp_prot);
 
 static struct sock *udp_get_first(struct seq_file *seq, int start)
 {
-	struct sock *sk;
-	struct udp_seq_afinfo *afinfo;
 	struct udp_iter_state *state = seq->private;
 	struct net *net = seq_file_net(seq);
+	struct udp_seq_afinfo *afinfo;
+	struct sock *sk;
 
 	if (state->bpf_seq_afinfo)
 		afinfo = state->bpf_seq_afinfo;
@@ -2997,9 +3004,9 @@ static struct sock *udp_get_first(struct seq_file *seq, int start)
 
 static struct sock *udp_get_next(struct seq_file *seq, struct sock *sk)
 {
-	struct udp_seq_afinfo *afinfo;
 	struct udp_iter_state *state = seq->private;
 	struct net *net = seq_file_net(seq);
+	struct udp_seq_afinfo *afinfo;
 
 	if (state->bpf_seq_afinfo)
 		afinfo = state->bpf_seq_afinfo;
@@ -3055,8 +3062,8 @@ EXPORT_SYMBOL(udp_seq_next);
 
 void udp_seq_stop(struct seq_file *seq, void *v)
 {
-	struct udp_seq_afinfo *afinfo;
 	struct udp_iter_state *state = seq->private;
+	struct udp_seq_afinfo *afinfo;
 
 	if (state->bpf_seq_afinfo)
 		afinfo = state->bpf_seq_afinfo;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 16c176e7c69a..f7e0248a00bc 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1036,12 +1036,16 @@ static struct sock *__udp6_lib_demux_lookup(struct net *net,
 			int dif, int sdif)
 {
 	unsigned short hnum = ntohs(loc_port);
-	unsigned int hash2 = ipv6_portaddr_hash(net, loc_addr, hnum);
-	unsigned int slot2 = hash2 & udp_table.mask;
-	struct udp_hslot *hslot2 = &udp_table.hash2[slot2];
-	const __portpair ports = INET_COMBINED_PORTS(rmt_port, hnum);
+	unsigned int hash2, slot2;
+	struct udp_hslot *hslot2;
+	__portpair ports;
 	struct sock *sk;
 
+	hash2 = ipv6_portaddr_hash(net, loc_addr, hnum);
+	slot2 = hash2 & udp_table.mask;
+	hslot2 = &udp_table.hash2[slot2];
+	ports = INET_COMBINED_PORTS(rmt_port, hnum);
+
 	udp_portaddr_for_each_entry_rcu(sk, &hslot2->head) {
 		if (sk->sk_state == TCP_ESTABLISHED &&
 		    inet6_match(net, sk, rmt_addr, loc_addr, ports, dif, sdif))
-- 
2.30.2

