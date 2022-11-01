Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396A66143C9
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 04:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiKADwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 23:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKADwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 23:52:38 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B52FB7F0
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 20:52:36 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id q62-20020a25d941000000b006cac1a4000cso11996940ybg.14
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 20:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=h6fjHPkiBt0fqv6yMxbM3IRF78M6zpOIQR5rxAvkBEk=;
        b=Q7pmOjz4THhLQBjA99WZwkDh5tDzK9QeE6JmvNuaTby/t3PFLjd3qnnoaO+o5vmdst
         +GO15PWh0uqbZr/sC0A/8Oz74VZQkOLqMhvkqfPkwNfceUm4/mnJv/2A1LBzbQfh6wbo
         J6UcxPVUp7M0JCZ3qUWZGCf9+M5MJ2Y9eCj9laybRWZa9IGv4TQbC0Vd1Jpn0VEriqP6
         9ZCsTJb+49Oa86l1CWHivLjVEYL3/enTmxy1OjQcAB2lqXU9s8j77jzoZ4UdLNx1jIr6
         jHrgVGdE8gLhBzYi3IuhcagZbwFGlfJr0EG1z1ec1rjgdeRBiFDoqWDhi1ZPumcjAwQw
         vFJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h6fjHPkiBt0fqv6yMxbM3IRF78M6zpOIQR5rxAvkBEk=;
        b=2zf99VE+T6FHZREDdjXhayLXCclMn9nAfl4DU8LQAO3vhWsAu5SVmkYgEPQe69HRZU
         SgHWgAdRj0CnnI2e2/C/XZA2BK+ASXnvXAPJZhUMDiGT1jhCuVfCGleJuZwhZs+eM3sK
         /RquyhAPqyDacpVEHiRp22VlDNDjrKqSvLiv6SU+n40coDKrcwI90KF2dSUXhVx1v+vG
         E4xRMzffDv3Ieq8US1G1cSpfxB4xoMBOqnWB3vWrO7J0T8G/FQCQhEgerpwvoiSPTZ40
         aBOJxUS1ll3P01OTxCaKKtRX/uLisSs1OhEHUzCkxM2cUiobGLm6D+oi3rPc1QHCln6Y
         79aQ==
X-Gm-Message-State: ACrzQf0P3lWGk0iXM3Hv7VX0bnyiKKxutmmedRY51ZCv59LIPFzV2CGf
        AXvbufRtNnIt2d3QuBOwL055Ya7nsxDaaw==
X-Google-Smtp-Source: AMsMyM6wheIaD+ypCBmLvthqZ2VaesvH91bWEyugEvaZN2nTkRBJ4Z4qZwI2+UvCEIWn1upqjwEqCXZCCjuQQg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:7c07:0:b0:6cb:a925:8c02 with SMTP id
 x7-20020a257c07000000b006cba9258c02mr16412108ybc.70.1667274755653; Mon, 31
 Oct 2022 20:52:35 -0700 (PDT)
Date:   Tue,  1 Nov 2022 03:52:34 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221101035234.3910189-1-edumazet@google.com>
Subject: [PATCH net-next] tcp: refine tcp_prune_ofo_queue() logic
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Neal Cardwell <ncardwell@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commits 36a6503fedda ("tcp: refine tcp_prune_ofo_queue()
to not drop all packets") and 72cd43ba64fc1
("tcp: free batches of packets in tcp_prune_ofo_queue()")
tcp_prune_ofo_queue() drops a fraction of ooo queue,
to make room for incoming packet.

However it makes no sense to drop packets that are
before the incoming packet, in sequence space.

In order to recover from packet losses faster,
it makes more sense to only drop ooo packets
which are after the incoming packet.

Tested:
packetdrill test:
   0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
   +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
   +0 setsockopt(3, SOL_SOCKET, SO_RCVBUF, [3800], 4) = 0
   +0 bind(3, ..., ...) = 0
   +0 listen(3, 1) = 0

   +0 < S 0:0(0) win 32792 <mss 1000,sackOK,nop,nop,nop,wscale 7>
   +0 > S. 0:0(0) ack 1 <mss 1460,nop,nop,sackOK,nop,wscale 0>
  +.1 < . 1:1(0) ack 1 win 1024
   +0 accept(3, ..., ...) = 4

 +.01 < . 200:300(100) ack 1 win 1024
   +0 > . 1:1(0) ack 1 <nop,nop, sack 200:300>

 +.01 < . 400:500(100) ack 1 win 1024
   +0 > . 1:1(0) ack 1 <nop,nop, sack 400:500 200:300>

 +.01 < . 600:700(100) ack 1 win 1024
   +0 > . 1:1(0) ack 1 <nop,nop, sack 600:700 400:500 200:300>

 +.01 < . 800:900(100) ack 1 win 1024
   +0 > . 1:1(0) ack 1 <nop,nop, sack 800:900 600:700 400:500 200:300>

 +.01 < . 1000:1100(100) ack 1 win 1024
   +0 > . 1:1(0) ack 1 <nop,nop, sack 1000:1100 800:900 600:700 400:500>

 +.01 < . 1200:1300(100) ack 1 win 1024
   +0 > . 1:1(0) ack 1 <nop,nop, sack 1200:1300 1000:1100 800:900 600:700>

// this packet is dropped because we have no room left.
 +.01 < . 1400:1500(100) ack 1 win 1024

 +.01 < . 1:200(199) ack 1 win 1024
// Make sure kernel did not drop 200:300 sequence
   +0 > . 1:1(0) ack 300 <nop,nop, sack 1200:1300 1000:1100 800:900 600:700>
// Make room, since our RCVBUF is very small
   +0 read(4, ..., 299) = 299

 +.01 < . 300:400(100) ack 1 win 1024
   +0 > . 1:1(0) ack 500 <nop,nop, sack 1200:1300 1000:1100 800:900 600:700>

 +.01 < . 500:600(100) ack 1 win 1024
   +0 > . 1:1(0) ack 700 <nop,nop, sack 1200:1300 1000:1100 800:900>

   +0 read(4, ..., 400) = 400

 +.01 < . 700:800(100) ack 1 win 1024
   +0 > . 1:1(0) ack 900 <nop,nop, sack 1200:1300 1000:1100>

 +.01 < . 900:1000(100) ack 1 win 1024
   +0 > . 1:1(0) ack 1100 <nop,nop, sack 1200:1300>

 +.01 < . 1100:1200(100) ack 1 win 1024
// This checks that 1200:1300 has not been removed from ooo queue
   +0 > . 1:1(0) ack 1300

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c | 51 +++++++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 0640453fce54b6daae0861d948f3db075830daf6..d764b5854dfcc865207b5eb749c29013ef18bdbc 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4764,8 +4764,8 @@ static void tcp_ofo_queue(struct sock *sk)
 	}
 }
 
-static bool tcp_prune_ofo_queue(struct sock *sk);
-static int tcp_prune_queue(struct sock *sk);
+static bool tcp_prune_ofo_queue(struct sock *sk, const struct sk_buff *in_skb);
+static int tcp_prune_queue(struct sock *sk, const struct sk_buff *in_skb);
 
 static int tcp_try_rmem_schedule(struct sock *sk, struct sk_buff *skb,
 				 unsigned int size)
@@ -4773,11 +4773,11 @@ static int tcp_try_rmem_schedule(struct sock *sk, struct sk_buff *skb,
 	if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf ||
 	    !sk_rmem_schedule(sk, skb, size)) {
 
-		if (tcp_prune_queue(sk) < 0)
+		if (tcp_prune_queue(sk, skb) < 0)
 			return -1;
 
 		while (!sk_rmem_schedule(sk, skb, size)) {
-			if (!tcp_prune_ofo_queue(sk))
+			if (!tcp_prune_ofo_queue(sk, skb))
 				return -1;
 		}
 	}
@@ -5329,6 +5329,8 @@ static void tcp_collapse_ofo_queue(struct sock *sk)
  * Clean the out-of-order queue to make room.
  * We drop high sequences packets to :
  * 1) Let a chance for holes to be filled.
+ *    This means we do not drop packets from ooo queue if their sequence
+ *    is before incoming packet sequence.
  * 2) not add too big latencies if thousands of packets sit there.
  *    (But if application shrinks SO_RCVBUF, we could still end up
  *     freeing whole queue here)
@@ -5336,24 +5338,31 @@ static void tcp_collapse_ofo_queue(struct sock *sk)
  *
  * Return true if queue has shrunk.
  */
-static bool tcp_prune_ofo_queue(struct sock *sk)
+static bool tcp_prune_ofo_queue(struct sock *sk, const struct sk_buff *in_skb)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct rb_node *node, *prev;
+	bool pruned = false;
 	int goal;
 
 	if (RB_EMPTY_ROOT(&tp->out_of_order_queue))
 		return false;
 
-	NET_INC_STATS(sock_net(sk), LINUX_MIB_OFOPRUNED);
 	goal = sk->sk_rcvbuf >> 3;
 	node = &tp->ooo_last_skb->rbnode;
+
 	do {
+		struct sk_buff *skb = rb_to_skb(node);
+
+		/* If incoming skb would land last in ofo queue, stop pruning. */
+		if (after(TCP_SKB_CB(in_skb)->seq, TCP_SKB_CB(skb)->seq))
+			break;
+		pruned = true;
 		prev = rb_prev(node);
 		rb_erase(node, &tp->out_of_order_queue);
-		goal -= rb_to_skb(node)->truesize;
-		tcp_drop_reason(sk, rb_to_skb(node),
-				SKB_DROP_REASON_TCP_OFO_QUEUE_PRUNE);
+		goal -= skb->truesize;
+		tcp_drop_reason(sk, skb, SKB_DROP_REASON_TCP_OFO_QUEUE_PRUNE);
+		tp->ooo_last_skb = rb_to_skb(prev);
 		if (!prev || goal <= 0) {
 			if (atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf &&
 			    !tcp_under_memory_pressure(sk))
@@ -5362,16 +5371,18 @@ static bool tcp_prune_ofo_queue(struct sock *sk)
 		}
 		node = prev;
 	} while (node);
-	tp->ooo_last_skb = rb_to_skb(prev);
 
-	/* Reset SACK state.  A conforming SACK implementation will
-	 * do the same at a timeout based retransmit.  When a connection
-	 * is in a sad state like this, we care only about integrity
-	 * of the connection not performance.
-	 */
-	if (tp->rx_opt.sack_ok)
-		tcp_sack_reset(&tp->rx_opt);
-	return true;
+	if (pruned) {
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_OFOPRUNED);
+		/* Reset SACK state.  A conforming SACK implementation will
+		 * do the same at a timeout based retransmit.  When a connection
+		 * is in a sad state like this, we care only about integrity
+		 * of the connection not performance.
+		 */
+		if (tp->rx_opt.sack_ok)
+			tcp_sack_reset(&tp->rx_opt);
+	}
+	return pruned;
 }
 
 /* Reduce allocated memory if we can, trying to get
@@ -5381,7 +5392,7 @@ static bool tcp_prune_ofo_queue(struct sock *sk)
  * until the socket owning process reads some of the data
  * to stabilize the situation.
  */
-static int tcp_prune_queue(struct sock *sk)
+static int tcp_prune_queue(struct sock *sk, const struct sk_buff *in_skb)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
@@ -5408,7 +5419,7 @@ static int tcp_prune_queue(struct sock *sk)
 	/* Collapsing did not help, destructive actions follow.
 	 * This must not ever occur. */
 
-	tcp_prune_ofo_queue(sk);
+	tcp_prune_ofo_queue(sk, in_skb);
 
 	if (atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf)
 		return 0;
-- 
2.38.1.273.g43a17bfeac-goog

