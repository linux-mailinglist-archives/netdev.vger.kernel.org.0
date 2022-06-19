Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44815550D97
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 01:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233411AbiFSXak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 19:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbiFSXaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 19:30:39 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9300864F2
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 16:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1655681439; x=1687217439;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wlLL7cMGeQHOcV3Zwj9kCu708TAmh+QIE18D9/Zcac8=;
  b=gn1cWGa2rHEpyWpXjA6qCr9k8KcCA3/uiDN5EUu1RsWfCvVayeDcLd+o
   BTctOgY9Ip4wZCHn/mRfVhwB1yucQUAcJezPIXQjxGObH3hans3az+EUh
   4sijzD7myMibzSaFo+8hyb9LKiqNJ6EYiEE8xkqtFrH2EIEU/GxkN5S/C
   4=;
X-IronPort-AV: E=Sophos;i="5.92,306,1650931200"; 
   d="scan'208";a="229697065"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-9a235a16.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 19 Jun 2022 23:30:24 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-9a235a16.us-east-1.amazon.com (Postfix) with ESMTPS id 0799380F7A;
        Sun, 19 Jun 2022 23:30:21 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Sun, 19 Jun 2022 23:30:21 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.133) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Sun, 19 Jun 2022 23:30:19 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 2/2] raw: Use helpers for the hlist_nulls variant.
Date:   Sun, 19 Jun 2022 16:29:27 -0700
Message-ID: <20220619232927.54259-3-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220619232927.54259-1-kuniyu@amazon.com>
References: <20220619232927.54259-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.133]
X-ClientProxiedBy: EX13D05UWB003.ant.amazon.com (10.43.161.26) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hlist_nulls_add_head_rcu() and hlist_nulls_for_each_entry() have dedicated
macros for sk.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/raw.c      | 8 ++++----
 net/ipv4/raw_diag.c | 4 ++--
 net/ipv6/raw.c      | 4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index b3b255db9021..959bea12dc48 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -96,7 +96,7 @@ int raw_hash_sk(struct sock *sk)
 	hlist = &h->ht[inet_sk(sk)->inet_num & (RAW_HTABLE_SIZE - 1)];
 
 	write_lock_bh(&h->lock);
-	hlist_nulls_add_head_rcu(&sk->sk_nulls_node, hlist);
+	__sk_nulls_add_node_rcu(sk, hlist);
 	sock_set_flag(sk, SOCK_RCU_FREE);
 	write_unlock_bh(&h->lock);
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
@@ -172,7 +172,7 @@ static int raw_v4_input(struct sk_buff *skb, const struct iphdr *iph, int hash)
 
 	hlist = &raw_v4_hashinfo.ht[hash];
 	rcu_read_lock();
-	hlist_nulls_for_each_entry(sk, hnode, hlist, sk_nulls_node) {
+	sk_nulls_for_each(sk, hnode, hlist) {
 		if (!raw_v4_match(net, sk, iph->protocol,
 				  iph->saddr, iph->daddr, dif, sdif))
 			continue;
@@ -275,7 +275,7 @@ void raw_icmp_error(struct sk_buff *skb, int protocol, u32 info)
 	hlist = &raw_v4_hashinfo.ht[hash];
 
 	rcu_read_lock();
-	hlist_nulls_for_each_entry(sk, hnode, hlist, sk_nulls_node) {
+	sk_nulls_for_each(sk, hnode, hlist) {
 		iph = (const struct iphdr *)skb->data;
 		if (!raw_v4_match(net, sk, iph->protocol,
 				  iph->saddr, iph->daddr, dif, sdif))
@@ -954,7 +954,7 @@ static struct sock *raw_get_first(struct seq_file *seq, int bucket)
 	for (state->bucket = bucket; state->bucket < RAW_HTABLE_SIZE;
 			++state->bucket) {
 		hlist = &h->ht[state->bucket];
-		hlist_nulls_for_each_entry(sk, hnode, hlist, sk_nulls_node) {
+		sk_nulls_for_each(sk, hnode, hlist) {
 			if (sock_net(sk) == seq_file_net(seq))
 				return sk;
 		}
diff --git a/net/ipv4/raw_diag.c b/net/ipv4/raw_diag.c
index 5f208e840d85..ac4b6525d3c6 100644
--- a/net/ipv4/raw_diag.c
+++ b/net/ipv4/raw_diag.c
@@ -68,7 +68,7 @@ static struct sock *raw_sock_get(struct net *net, const struct inet_diag_req_v2
 	rcu_read_lock();
 	for (slot = 0; slot < RAW_HTABLE_SIZE; slot++) {
 		hlist = &hashinfo->ht[slot];
-		hlist_nulls_for_each_entry(sk, hnode, hlist, sk_nulls_node) {
+		sk_nulls_for_each(sk, hnode, hlist) {
 			if (raw_lookup(net, sk, r)) {
 				/*
 				 * Grab it and keep until we fill
@@ -161,7 +161,7 @@ static void raw_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 		num = 0;
 
 		hlist = &hashinfo->ht[slot];
-		hlist_nulls_for_each_entry(sk, hnode, hlist, sk_nulls_node) {
+		sk_nulls_for_each(sk, hnode, hlist) {
 			struct inet_sock *inet = inet_sk(sk);
 
 			if (!net_eq(sock_net(sk), net))
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index f6119998700e..46b560aacc11 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -155,7 +155,7 @@ static bool ipv6_raw_deliver(struct sk_buff *skb, int nexthdr)
 	hash = nexthdr & (RAW_HTABLE_SIZE - 1);
 	hlist = &raw_v6_hashinfo.ht[hash];
 	rcu_read_lock();
-	hlist_nulls_for_each_entry(sk, hnode, hlist, sk_nulls_node) {
+	sk_nulls_for_each(sk, hnode, hlist) {
 		int filtered;
 
 		if (!raw_v6_match(net, sk, nexthdr, daddr, saddr,
@@ -342,7 +342,7 @@ void raw6_icmp_error(struct sk_buff *skb, int nexthdr,
 	hash = nexthdr & (RAW_HTABLE_SIZE - 1);
 	hlist = &raw_v6_hashinfo.ht[hash];
 	rcu_read_lock();
-	hlist_nulls_for_each_entry(sk, hnode, hlist, sk_nulls_node) {
+	sk_nulls_for_each(sk, hnode, hlist) {
 		/* Note: ipv6_hdr(skb) != skb->data */
 		const struct ipv6hdr *ip6h = (const struct ipv6hdr *)skb->data;
 		saddr = &ip6h->saddr;
-- 
2.30.2

