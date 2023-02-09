Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D16168FCA8
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 02:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbjBIBeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 20:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjBIBeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 20:34:20 -0500
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E3221A29
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 17:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1675906460; x=1707442460;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F9V+IpLBdXpKunFdHkg28X7ZjkxBYgMLhpvTdEEYXf8=;
  b=cIGmegpe8wouIosdeFZB3NCMRAwjoI4jZLlm6URXoUXAfDi9Uhu5q0AI
   g+3R/oSzqfNrqu0cx7YW3bMjxjAG2Z9cQhpuoczHNmmYIoq4RVra1EglT
   uTK7RsTW3GFalkwhfbpGxQtzZ8cr/wLeAdEnnHLLTgEk21eZy2Beh1v3R
   c=;
X-IronPort-AV: E=Sophos;i="5.97,281,1669075200"; 
   d="scan'208";a="179932228"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-e7094f15.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 01:34:18 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-e7094f15.us-west-2.amazon.com (Postfix) with ESMTPS id EA719414F7;
        Thu,  9 Feb 2023 01:34:15 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Thu, 9 Feb 2023 01:34:15 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.198) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.24;
 Thu, 9 Feb 2023 01:34:12 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, Andrii <tulup@mail.ru>,
        Arnaldo Carvalho de Melo <acme@mandriva.com>
Subject: [PATCH v2 net 1/2] dccp/tcp: Avoid negative sk_forward_alloc by ipv6_pinfo.pktoptions.
Date:   Wed, 8 Feb 2023 17:33:28 -0800
Message-ID: <20230209013329.87879-2-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230209013329.87879-1-kuniyu@amazon.com>
References: <20230209013329.87879-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.198]
X-ClientProxiedBy: EX13D37UWC001.ant.amazon.com (10.43.162.33) To
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

Eric Dumazet pointed out [0] that when we call skb_set_owner_r()
for ipv6_pinfo.pktoptions, sk_rmem_schedule() has not been called,
resulting in a negative sk_forward_alloc.

Note that in (dccp|tcp)_v6_do_rcv(), we call sk_rmem_schedule()
just after skb_clone() instead of after ipv6_opt_accepted().  This is
because tcp_send_synack() can make sk_forward_alloc negative before
ipv6_opt_accepted() in the crossed SYN-ACK or self-connect() cases.

[0]: https://lore.kernel.org/netdev/CANn89iK9oc20Jdi_41jb9URdF210r7d1Y-+uypbMSbOfY6jqrg@mail.gmail.com/

Fixes: 323fbd0edf3f ("net: dccp: Add handling of IPV6_PKTOPTIONS to dccp_v6_do_rcv()")
Fixes: 3df80d9320bc ("[DCCP]: Introduce DCCPv6")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
Cc: Andrii <tulup@mail.ru>
Cc: Arnaldo Carvalho de Melo <acme@mandriva.com>
---
 net/dccp/ipv6.c     | 23 +++++++++++++++++++----
 net/ipv6/tcp_ipv6.c | 22 ++++++++++++++++++----
 2 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 4260fe466993..2687e7ef5b5d 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -554,8 +554,15 @@ static struct sock *dccp_v6_request_recv_sock(const struct sock *sk,
 		newnp->pktoptions = skb_clone(ireq->pktopts, GFP_ATOMIC);
 		consume_skb(ireq->pktopts);
 		ireq->pktopts = NULL;
-		if (newnp->pktoptions)
-			skb_set_owner_r(newnp->pktoptions, newsk);
+		if (newnp->pktoptions) {
+			if (sk_rmem_schedule(newsk, newnp->pktoptions,
+					     newnp->pktoptions->truesize)) {
+				skb_set_owner_r(newnp->pktoptions, newsk);
+			} else {
+				__kfree_skb(newnp->pktoptions);
+				newnp->pktoptions = NULL;
+			}
+		}
 	}
 
 	return newsk;
@@ -614,8 +621,17 @@ static int dccp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 	   by tcp. Feel free to propose better solution.
 					       --ANK (980728)
 	 */
-	if (np->rxopt.all)
+	if (np->rxopt.all) {
 		opt_skb = skb_clone(skb, GFP_ATOMIC);
+		if (opt_skb) {
+			if (sk_rmem_schedule(sk, opt_skb, opt_skb->truesize)) {
+				skb_set_owner_r(opt_skb, sk);
+			} else {
+				__kfree_skb(opt_skb);
+				opt_skb = NULL;
+			}
+		}
+	}
 
 	if (sk->sk_state == DCCP_OPEN) { /* Fast path */
 		if (dccp_rcv_established(sk, skb, dccp_hdr(skb), skb->len))
@@ -679,7 +695,6 @@ static int dccp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 			np->flow_label = ip6_flowlabel(ipv6_hdr(opt_skb));
 		if (ipv6_opt_accepted(sk, opt_skb,
 				      &DCCP_SKB_CB(opt_skb)->header.h6)) {
-			skb_set_owner_r(opt_skb, sk);
 			memmove(IP6CB(opt_skb),
 				&DCCP_SKB_CB(opt_skb)->header.h6,
 				sizeof(struct inet6_skb_parm));
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 11b736a76bd7..95c1078aba5a 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1392,8 +1392,14 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 			consume_skb(ireq->pktopts);
 			ireq->pktopts = NULL;
 			if (newnp->pktoptions) {
-				tcp_v6_restore_cb(newnp->pktoptions);
-				skb_set_owner_r(newnp->pktoptions, newsk);
+				if (sk_rmem_schedule(newsk, newnp->pktoptions,
+						     newnp->pktoptions->truesize)) {
+					tcp_v6_restore_cb(newnp->pktoptions);
+					skb_set_owner_r(newnp->pktoptions, newsk);
+				} else {
+					__kfree_skb(newnp->pktoptions);
+					newnp->pktoptions = NULL;
+				}
 			}
 		}
 	} else {
@@ -1465,8 +1471,17 @@ int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 	   by tcp. Feel free to propose better solution.
 					       --ANK (980728)
 	 */
-	if (np->rxopt.all)
+	if (np->rxopt.all) {
 		opt_skb = skb_clone(skb, sk_gfp_mask(sk, GFP_ATOMIC));
+		if (opt_skb) {
+			if (sk_rmem_schedule(sk, opt_skb, opt_skb->truesize)) {
+				skb_set_owner_r(opt_skb, sk);
+			} else {
+				__kfree_skb(opt_skb);
+				opt_skb = NULL;
+			}
+		}
+	}
 
 	reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	if (sk->sk_state == TCP_ESTABLISHED) { /* Fast path */
@@ -1552,7 +1567,6 @@ int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 		if (np->repflow)
 			np->flow_label = ip6_flowlabel(ipv6_hdr(opt_skb));
 		if (ipv6_opt_accepted(sk, opt_skb, &TCP_SKB_CB(opt_skb)->header.h6)) {
-			skb_set_owner_r(opt_skb, sk);
 			tcp_v6_restore_cb(opt_skb);
 			opt_skb = xchg(&np->pktoptions, opt_skb);
 		} else {
-- 
2.30.2

