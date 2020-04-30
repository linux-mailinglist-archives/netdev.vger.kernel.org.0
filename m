Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC811C03F3
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgD3Rfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726285AbgD3Rfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 13:35:50 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF54C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 10:35:50 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e17so2273496ybr.21
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 10:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7Ir7Tvt214p8u6cFKvkG7/kz9bniUgTJrRbFVYs6p8Y=;
        b=GN7sHTQU7GXDI0TqDSiwhyPTogUdUc3hefG/VsqGT7ywZasoZwv8ZxMo/wa8fBA/Xk
         fOG97Gw/YhV3Sgy0AGVr9ltxbGhWDwlmTtQVbhz5Rkt1/mUS+D6//RzvNM1Vfr5vFrq/
         e7aYZXPHCTMlykM7PktoAkik4SNnTvakbSJG+j0hwrqoW60knnBdv/P19svihfUbbR6U
         oL2QAVnAJqKc0HQgjEnAnpbzJZ89V+5d9jQfWK1VU7RMKQIewRJY7TAHFF4GKY640TW2
         SYQoMRm151nCzzHPNBjjuB5w4N++F40TjmzrdoS2Lx3oOEYrCGTtxFXYMwBHZSCcD5QE
         PIJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7Ir7Tvt214p8u6cFKvkG7/kz9bniUgTJrRbFVYs6p8Y=;
        b=cmK4VqKIYCPu6lVk4Uok9QtkcbqC1snXcPgFlFcAr+q2cHT6xb2iqjpUNzLdjm3Q27
         mJf7t46HMjVWGpEAmgPc+ODudGLzsMYc20S7ibj8Jvp1+wzHuPHToeGQsh/pGFfwRPqI
         N4JTOt2eYS9V1QeS3pPwepP5edRxgk70Q8fWC6kN94J9VOn+r/MDE7ybvj82KeAn4+tc
         dJN3b2vn3HK6c1lm4xK5zkXl46e9XW2d2OGg66/rGS71zVssB2Dg+R+pY1Vqmqk/CQOU
         6YKNjJ3ULRwxGpkUmMNFfDz7Asw/IAGQN2VkRWrjhVMlkXWmj5awwX24Z9H8+Y6x8b+N
         3fSA==
X-Gm-Message-State: AGi0PuZ0uSkupYY7ujQWPxDWFiLU/Ws2/6rH8Z8BaWB46JUgs7L8M4UF
        lvf5oCEBHpdkWsqC9Wz3ijfzwB6NAwQy2Q==
X-Google-Smtp-Source: APiQypK9OEIpa0frX/KNkSvavSl3PgGffVCbmjTkJbHBCbrW8XBmifIL+OP+/21bAqpAZnFw9jMfbFoVUsIL0g==
X-Received: by 2002:a25:ca17:: with SMTP id a23mr8330051ybg.271.1588268149710;
 Thu, 30 Apr 2020 10:35:49 -0700 (PDT)
Date:   Thu, 30 Apr 2020 10:35:41 -0700
In-Reply-To: <20200430173543.41026-1-edumazet@google.com>
Message-Id: <20200430173543.41026-2-edumazet@google.com>
Mime-Version: 1.0
References: <20200430173543.41026-1-edumazet@google.com>
X-Mailer: git-send-email 2.26.2.303.gf8c07b1a785-goog
Subject: [PATCH net-next 1/3] tcp: add tp->dup_ack_counter
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 86de5921a3d5 ("tcp: defer SACK compression after DupThresh")
I added a TCP_FASTRETRANS_THRESH bias to tp->compressed_ack in order
to enable sack compression only after 3 dupacks.

Since we plan to relax this rule for flows that involve
stacks not requiring this old rule, this patch adds
a distinct tp->dup_ack_counter.

This means the TCP_FASTRETRANS_THRESH value is now used
in a single location that a future patch can adjust:

	if (tp->dup_ack_counter < TCP_FASTRETRANS_THRESH) {
		tp->dup_ack_counter++;
		goto send_now;
	}

This patch also introduces tcp_sack_compress_send_ack()
helper to ease following patch comprehension.

This patch refines LINUX_MIB_TCPACKCOMPRESSED to not
count the acks that we had to send if the timer expires
or tcp_sack_compress_send_ack() is sending an ack.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
---
 include/linux/tcp.h   |  1 +
 net/ipv4/tcp_input.c  | 36 +++++++++++++++++++++++++++---------
 net/ipv4/tcp_output.c |  6 +++---
 net/ipv4/tcp_timer.c  |  8 +++++++-
 4 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 421c99c12291994ce9f023fbedbc9089c8a5690d..2c6f87e9f0cf6f50b679a2e7d70181e057645a5e 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -268,6 +268,7 @@ struct tcp_sock {
 	} rack;
 	u16	advmss;		/* Advertised MSS			*/
 	u8	compressed_ack;
+	u8	dup_ack_counter;
 	u32	chrono_start;	/* Start time in jiffies of a TCP chrono */
 	u32	chrono_stat[3];	/* Time in jiffies for chrono_stat stats */
 	u8	chrono_type:2,	/* current chronograph type */
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index bf4ced9273e8e84b95204db9bfe86867c0a3ee13..da777df0a0baefb3bef8c802c9b9b83ff38b9fc9 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4327,6 +4327,27 @@ static void tcp_sack_maybe_coalesce(struct tcp_sock *tp)
 	}
 }
 
+static void tcp_sack_compress_send_ack(struct sock *sk)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+
+	if (!tp->compressed_ack)
+		return;
+
+	if (hrtimer_try_to_cancel(&tp->compressed_ack_timer) == 1)
+		__sock_put(sk);
+
+	/* Since we have to send one ack finally,
+	 * substract one from tp->compressed_ack to keep
+	 * LINUX_MIB_TCPACKCOMPRESSED accurate.
+	 */
+	NET_ADD_STATS(sock_net(sk), LINUX_MIB_TCPACKCOMPRESSED,
+		      tp->compressed_ack - 1);
+
+	tp->compressed_ack = 0;
+	tcp_send_ack(sk);
+}
+
 static void tcp_sack_new_ofo_skb(struct sock *sk, u32 seq, u32 end_seq)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
@@ -4355,8 +4376,7 @@ static void tcp_sack_new_ofo_skb(struct sock *sk, u32 seq, u32 end_seq)
 	 * If the sack array is full, forget about the last one.
 	 */
 	if (this_sack >= TCP_NUM_SACKS) {
-		if (tp->compressed_ack > TCP_FASTRETRANS_THRESH)
-			tcp_send_ack(sk);
+		tcp_sack_compress_send_ack(sk);
 		this_sack--;
 		tp->rx_opt.num_sacks--;
 		sp--;
@@ -5275,15 +5295,13 @@ static void __tcp_ack_snd_check(struct sock *sk, int ofo_possible)
 
 	if (tp->compressed_ack_rcv_nxt != tp->rcv_nxt) {
 		tp->compressed_ack_rcv_nxt = tp->rcv_nxt;
-		if (tp->compressed_ack > TCP_FASTRETRANS_THRESH)
-			NET_ADD_STATS(sock_net(sk), LINUX_MIB_TCPACKCOMPRESSED,
-				      tp->compressed_ack - TCP_FASTRETRANS_THRESH);
-		tp->compressed_ack = 0;
+		tp->dup_ack_counter = 0;
 	}
-
-	if (++tp->compressed_ack <= TCP_FASTRETRANS_THRESH)
+	if (tp->dup_ack_counter < TCP_FASTRETRANS_THRESH) {
+		tp->dup_ack_counter++;
 		goto send_now;
-
+	}
+	tp->compressed_ack++;
 	if (hrtimer_is_queued(&tp->compressed_ack_timer))
 		return;
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index ba4482130f08ea386913bfa5de3253e9bbfa3030..c414aeb1efa927c84bd4cd6afd0c21d46f049d5b 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -184,10 +184,10 @@ static inline void tcp_event_ack_sent(struct sock *sk, unsigned int pkts,
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
-	if (unlikely(tp->compressed_ack > TCP_FASTRETRANS_THRESH)) {
+	if (unlikely(tp->compressed_ack)) {
 		NET_ADD_STATS(sock_net(sk), LINUX_MIB_TCPACKCOMPRESSED,
-			      tp->compressed_ack - TCP_FASTRETRANS_THRESH);
-		tp->compressed_ack = TCP_FASTRETRANS_THRESH;
+			      tp->compressed_ack);
+		tp->compressed_ack = 0;
 		if (hrtimer_try_to_cancel(&tp->compressed_ack_timer) == 1)
 			__sock_put(sk);
 	}
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index c3f26dcd6704ee6b160c7a59667f82bc940f8cbe..ada046f425d248446a1aa8b1271cc35cab492be7 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -753,8 +753,14 @@ static enum hrtimer_restart tcp_compressed_ack_kick(struct hrtimer *timer)
 
 	bh_lock_sock(sk);
 	if (!sock_owned_by_user(sk)) {
-		if (tp->compressed_ack > TCP_FASTRETRANS_THRESH)
+		if (tp->compressed_ack) {
+			/* Since we have to send one ack finally,
+			 * substract one from tp->compressed_ack to keep
+			 * LINUX_MIB_TCPACKCOMPRESSED accurate.
+			 */
+			tp->compressed_ack--;
 			tcp_send_ack(sk);
+		}
 	} else {
 		if (!test_and_set_bit(TCP_DELACK_TIMER_DEFERRED,
 				      &sk->sk_tsq_flags))
-- 
2.26.2.303.gf8c07b1a785-goog

