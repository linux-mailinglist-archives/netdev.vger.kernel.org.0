Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B48FB69154D
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 01:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjBJAWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 19:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjBJAWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 19:22:44 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6C35FE5F
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 16:22:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1675988564; x=1707524564;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y60shk4m74PZQTdTIbDPOSADnNuZpjEfERsvgHgFlWo=;
  b=hklUTmuUc6Xue2Cp1bdzkD+gnWWBg7KpgiA4v2AtglmRlF4F6BCoOoCN
   Ta4kdhU2nFir4BOnajpEgS2Ef92/ZZS4ufiYFy+GgSJKR5L/7jBlgLTDe
   wTnBdeOYqmkoGNAVCICqnOcs5VyR0Vi5P/gfE5m7QHQjFOuU5cWA/ltMa
   k=;
X-IronPort-AV: E=Sophos;i="5.97,285,1669075200"; 
   d="scan'208";a="297234904"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 00:22:42 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com (Postfix) with ESMTPS id D22C4C3036;
        Fri, 10 Feb 2023 00:22:40 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Fri, 10 Feb 2023 00:22:39 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.198) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.24;
 Fri, 10 Feb 2023 00:22:37 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, Andrii <tulup@mail.ru>,
        Arnaldo Carvalho de Melo <acme@mandriva.com>
Subject: [PATCH v3 net 1/2] dccp/tcp: Avoid negative sk_forward_alloc by ipv6_pinfo.pktoptions.
Date:   Thu, 9 Feb 2023 16:22:01 -0800
Message-ID: <20230210002202.81442-2-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230210002202.81442-1-kuniyu@amazon.com>
References: <20230210002202.81442-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.198]
X-ClientProxiedBy: EX13D37UWC003.ant.amazon.com (10.43.162.183) To
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

We add a new helper which clones a skb and sets its owner only
when sk_rmem_schedule() succeeds.

Note that we move skb_set_owner_r() forward in (dccp|tcp)_v6_do_rcv()
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
 include/net/sock.h  | 13 +++++++++++++
 net/dccp/ipv6.c     |  7 ++-----
 net/ipv6/tcp_ipv6.c | 10 +++-------
 3 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index dcd72e6285b2..556209727633 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2434,6 +2434,19 @@ static inline __must_check bool skb_set_owner_sk_safe(struct sk_buff *skb, struc
 	return false;
 }
 
+static inline struct sk_buff *skb_clone_and_charge_r(struct sk_buff *skb, struct sock *sk)
+{
+	skb = skb_clone(skb, sk_gfp_mask(sk, GFP_ATOMIC));
+	if (skb) {
+		if (sk_rmem_schedule(sk, skb, skb->truesize)) {
+			skb_set_owner_r(skb, sk);
+			return skb;
+		}
+		__kfree_skb(skb);
+	}
+	return NULL;
+}
+
 static inline void skb_prepare_for_gro(struct sk_buff *skb)
 {
 	if (skb->destructor != sock_wfree) {
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 4260fe466993..b9d7c3dd1cb3 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -551,11 +551,9 @@ static struct sock *dccp_v6_request_recv_sock(const struct sock *sk,
 	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash), NULL);
 	/* Clone pktoptions received with SYN, if we own the req */
 	if (*own_req && ireq->pktopts) {
-		newnp->pktoptions = skb_clone(ireq->pktopts, GFP_ATOMIC);
+		newnp->pktoptions = skb_clone_and_charge_r(ireq->pktopts, newsk);
 		consume_skb(ireq->pktopts);
 		ireq->pktopts = NULL;
-		if (newnp->pktoptions)
-			skb_set_owner_r(newnp->pktoptions, newsk);
 	}
 
 	return newsk;
@@ -615,7 +613,7 @@ static int dccp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 					       --ANK (980728)
 	 */
 	if (np->rxopt.all)
-		opt_skb = skb_clone(skb, GFP_ATOMIC);
+		opt_skb = skb_clone_and_charge_r(skb, sk);
 
 	if (sk->sk_state == DCCP_OPEN) { /* Fast path */
 		if (dccp_rcv_established(sk, skb, dccp_hdr(skb), skb->len))
@@ -679,7 +677,6 @@ static int dccp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 			np->flow_label = ip6_flowlabel(ipv6_hdr(opt_skb));
 		if (ipv6_opt_accepted(sk, opt_skb,
 				      &DCCP_SKB_CB(opt_skb)->header.h6)) {
-			skb_set_owner_r(opt_skb, sk);
 			memmove(IP6CB(opt_skb),
 				&DCCP_SKB_CB(opt_skb)->header.h6,
 				sizeof(struct inet6_skb_parm));
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 11b736a76bd7..b681644547d0 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1387,14 +1387,11 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 
 		/* Clone pktoptions received with SYN, if we own the req */
 		if (ireq->pktopts) {
-			newnp->pktoptions = skb_clone(ireq->pktopts,
-						      sk_gfp_mask(sk, GFP_ATOMIC));
+			newnp->pktoptions = skb_clone_and_charge_r(ireq->pktopts, newsk);
 			consume_skb(ireq->pktopts);
 			ireq->pktopts = NULL;
-			if (newnp->pktoptions) {
+			if (newnp->pktoptions)
 				tcp_v6_restore_cb(newnp->pktoptions);
-				skb_set_owner_r(newnp->pktoptions, newsk);
-			}
 		}
 	} else {
 		if (!req_unhash && found_dup_sk) {
@@ -1466,7 +1463,7 @@ int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 					       --ANK (980728)
 	 */
 	if (np->rxopt.all)
-		opt_skb = skb_clone(skb, sk_gfp_mask(sk, GFP_ATOMIC));
+		opt_skb = skb_clone_and_charge_r(skb, sk);
 
 	reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	if (sk->sk_state == TCP_ESTABLISHED) { /* Fast path */
@@ -1552,7 +1549,6 @@ int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 		if (np->repflow)
 			np->flow_label = ip6_flowlabel(ipv6_hdr(opt_skb));
 		if (ipv6_opt_accepted(sk, opt_skb, &TCP_SKB_CB(opt_skb)->header.h6)) {
-			skb_set_owner_r(opt_skb, sk);
 			tcp_v6_restore_cb(opt_skb);
 			opt_skb = xchg(&np->pktoptions, opt_skb);
 		} else {
-- 
2.30.2

