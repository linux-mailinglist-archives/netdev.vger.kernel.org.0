Return-Path: <netdev+bounces-6425-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D75D7163D4
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:22:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3A7D1C20B9A
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40D0F23C79;
	Tue, 30 May 2023 14:20:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FE121076
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:20:59 +0000 (UTC)
Received: from mx6.didiglobal.com (mx6.didiglobal.com [111.202.70.123])
	by lindbergh.monkeyblade.net (Postfix) with SMTP id EDC1910F5
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:20:32 -0700 (PDT)
Received: from mail.didiglobal.com (unknown [10.79.65.12])
	by mx6.didiglobal.com (Maildata Gateway V2.8) with ESMTPS id 761A11100B6004;
	Tue, 30 May 2023 22:19:41 +0800 (CST)
Received: from didi-ThinkCentre-M920t-N000 (10.79.64.101) by
 ZJY02-ACTMBX-02.didichuxing.com (10.79.65.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 30 May 2023 22:19:40 +0800
Date: Tue, 30 May 2023 22:19:35 +0800
X-MD-Sfrom: fuyuanli@didiglobal.com
X-MD-SrcIP: 10.79.65.12
From: fuyuanli <fuyuanli@didiglobal.com>
To: Eric Dumazet <edumazet@google.com>
CC: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Neal Cardwell <ncardwell@google.com>, ycheng
	<ycheng@google.com>, toke <toke@toke.dk>, fuyuanli <fuyuanli@didiglobal.com>,
	<netdev@vger.kernel.org>, Weiping Zhang <zhangweiping@didiglobal.com>, Tio
 Zhang <tiozhang@didiglobal.com>, Jason Xing <kerneljasonxing@gmail.com>
Subject: [PATCH net v2] tcp: fix mishandling when the sack compression is
 deferred
Message-ID: <20230530141935.GA21936@didi-ThinkCentre-M920t-N000>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.79.64.101]
X-ClientProxiedBy: ZJY01-PUBMBX-01.didichuxing.com (10.79.64.32) To
 ZJY02-ACTMBX-02.didichuxing.com (10.79.65.12)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In this patch, we mainly do two things which could be separately
found as the following links:
1) fix not sending a compressed ack if it's deferred.
2) use the ICSK_ACK_TIMER flag in tcp_sack_compress_send_ack() and
tcp_event_ack_sent() in order we can cancel it if it's deferred.

Here are more details in the old logic:
When sack compression is triggered in the tcp_compressed_ack_kick(),
if the sock is owned by user, it will set TCP_DELACK_TIMER_DEFERRED
and then defer to the release cb phrase. Later once user releases
the sock, tcp_delack_timer_handler() should send a ack as expected,
which, however, cannot happen due to lack of ICSK_ACK_TIMER flag.
Therefore, the receiver would not sent an ack until the sender's
retransmission timeout. It definitely increases unnecessary latency.

Fixes: 5d9f4262b7ea ("tcp: add SACK compression")
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: fuyuanli <fuyuanli@didiglobal.com>
Signed-off-by: Jason Xing <kerneljasonxing@gmail.com>
Link: https://lore.kernel.org/netdev/20230529113804.GA20300@didi-ThinkCentre-M920t-N000/
Link: https://lore.kernel.org/netdev/20230530023737.584-1-kerneljasonxing@gmail.com/
---
v2:
1) change the commit title and message
2) reuse the delayed ack logic when handling the sack compression
as suggested by Eric.
3) "merge" another related patch into this one. See the second link.
---
 include/net/tcp.h     |  1 +
 net/ipv4/tcp_input.c  | 11 +++++++++--
 net/ipv4/tcp_output.c |  3 +++
 net/ipv4/tcp_timer.c  | 12 +++++++++++-
 4 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 18a038d16434..6e1cd583a899 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -480,6 +480,7 @@ int tcp_disconnect(struct sock *sk, int flags);
 
 void tcp_finish_connect(struct sock *sk, struct sk_buff *skb);
 int tcp_send_rcvq(struct sock *sk, struct msghdr *msg, size_t size);
+void tcp_sack_compress_send_ack(struct sock *sk);
 void inet_sk_rx_dst_set(struct sock *sk, const struct sk_buff *skb);
 
 /* From syncookies.c */
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 61b6710f337a..5ad3839ce54f 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4530,7 +4530,7 @@ static void tcp_sack_maybe_coalesce(struct tcp_sock *tp)
 	}
 }
 
-static void tcp_sack_compress_send_ack(struct sock *sk)
+void tcp_sack_compress_send_ack(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
@@ -4540,6 +4540,9 @@ static void tcp_sack_compress_send_ack(struct sock *sk)
 	if (hrtimer_try_to_cancel(&tp->compressed_ack_timer) == 1)
 		__sock_put(sk);
 
+	/* It also deals with the case where the sack compression is deferred */
+	inet_csk(sk)->icsk_ack.pending &= ~ICSK_ACK_TIMER;
+
 	/* Since we have to send one ack finally,
 	 * substract one from tp->compressed_ack to keep
 	 * LINUX_MIB_TCPACKCOMPRESSED accurate.
@@ -5555,7 +5558,10 @@ static void __tcp_ack_snd_check(struct sock *sk, int ofo_possible)
 		goto send_now;
 	}
 	tp->compressed_ack++;
-	if (hrtimer_is_queued(&tp->compressed_ack_timer))
+	/* If we already started the timer or deferred sending a compressed
+	 * sack, then return immediately.
+	 */
+	if (inet_csk(sk)->icsk_ack.pending & ICSK_ACK_TIMER)
 		return;
 
 	/* compress ack timer : 5 % of rtt, but no more than tcp_comp_sack_delay_ns */
@@ -5568,6 +5574,7 @@ static void __tcp_ack_snd_check(struct sock *sk, int ofo_possible)
 		      READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_comp_sack_delay_ns),
 		      rtt * (NSEC_PER_USEC >> 3)/20);
 	sock_hold(sk);
+	inet_csk(sk)->icsk_ack.pending |= ICSK_ACK_TIMER;
 	hrtimer_start_range_ns(&tp->compressed_ack_timer, ns_to_ktime(delay),
 			       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_comp_sack_slack_ns),
 			       HRTIMER_MODE_REL_PINNED_SOFT);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index cfe128b81a01..156514760461 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -188,6 +188,9 @@ static inline void tcp_event_ack_sent(struct sock *sk, unsigned int pkts,
 		tp->compressed_ack = 0;
 		if (hrtimer_try_to_cancel(&tp->compressed_ack_timer) == 1)
 			__sock_put(sk);
+
+		/* It also deals with the case where the sack compression is deferred */
+		inet_csk(sk)->icsk_ack.pending &= ~ICSK_ACK_TIMER;
 	}
 
 	if (unlikely(rcv_nxt != tp->rcv_nxt))
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index b839c2f91292..82336e45026e 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -290,15 +290,24 @@ static int tcp_write_timeout(struct sock *sk)
 void tcp_delack_timer_handler(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
+	struct tcp_sock *tp = tcp_sk(sk);
 
 	if (((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)) ||
 	    !(icsk->icsk_ack.pending & ICSK_ACK_TIMER))
 		return;
 
+	/* Handling the sack compression case */
+	if (tp->compressed_ack) {
+		tcp_mstamp_refresh(tp);
+		tcp_sack_compress_send_ack(sk);
+		return;
+	}
+
 	if (time_after(icsk->icsk_ack.timeout, jiffies)) {
 		sk_reset_timer(sk, &icsk->icsk_delack_timer, icsk->icsk_ack.timeout);
 		return;
 	}
+
 	icsk->icsk_ack.pending &= ~ICSK_ACK_TIMER;
 
 	if (inet_csk_ack_scheduled(sk)) {
@@ -312,7 +321,7 @@ void tcp_delack_timer_handler(struct sock *sk)
 			inet_csk_exit_pingpong_mode(sk);
 			icsk->icsk_ack.ato      = TCP_ATO_MIN;
 		}
-		tcp_mstamp_refresh(tcp_sk(sk));
+		tcp_mstamp_refresh(tp);
 		tcp_send_ack(sk);
 		__NET_INC_STATS(sock_net(sk), LINUX_MIB_DELAYEDACKS);
 	}
@@ -757,6 +766,7 @@ static enum hrtimer_restart tcp_compressed_ack_kick(struct hrtimer *timer)
 
 	bh_lock_sock(sk);
 	if (!sock_owned_by_user(sk)) {
+		inet_csk(sk)->icsk_ack.pending &= ~ICSK_ACK_TIMER;
 		if (tp->compressed_ack) {
 			/* Since we have to send one ack finally,
 			 * subtract one from tp->compressed_ack to keep
-- 
2.17.1


