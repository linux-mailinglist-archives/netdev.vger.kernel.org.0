Return-Path: <netdev+bounces-6715-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69DF271796A
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 10:02:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A263A28135E
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 08:02:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDBE4BA30;
	Wed, 31 May 2023 08:02:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0789A945
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 08:02:04 +0000 (UTC)
Received: from mx5.didiglobal.com (mx5.didiglobal.com [111.202.70.122])
	by lindbergh.monkeyblade.net (Postfix) with SMTP id D9B11E42
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 01:01:58 -0700 (PDT)
Received: from mail.didiglobal.com (unknown [10.79.65.12])
	by mx5.didiglobal.com (Maildata Gateway V2.8) with ESMTPS id 33767B008843E;
	Wed, 31 May 2023 16:01:55 +0800 (CST)
Received: from didi-ThinkCentre-M920t-N000 (10.79.64.101) by
 ZJY02-ACTMBX-02.didichuxing.com (10.79.65.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 31 May 2023 16:01:54 +0800
Date: Wed, 31 May 2023 16:01:50 +0800
X-MD-Sfrom: fuyuanli@didiglobal.com
X-MD-SrcIP: 10.79.65.12
From: fuyuanli <fuyuanli@didiglobal.com>
To: Eric Dumazet <edumazet@google.com>
CC: "David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Neal
 Cardwell <ncardwell@google.com>, ycheng <ycheng@google.com>, toke
	<toke@toke.dk>, fuyuanli <fuyuanli@didiglobal.com>, <netdev@vger.kernel.org>,
	Weiping Zhang <zhangweiping@didiglobal.com>, Tio Zhang
	<tiozhang@didiglobal.com>, Jason Xing <kerneljasonxing@gmail.com>
Subject: [PATCH net v4] tcp: fix mishandling when the sack compression is
 deferred.
Message-ID: <20230531080150.GA20424@didi-ThinkCentre-M920t-N000>
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

In this patch, we mainly try to handle sending a compressed ack
correctly if it's deferred.

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
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
v4:
nit: move tcp_sack_compress_send_ack() in the right place suggested by Eric.

v3:
1) remove the flag which is newly added in v2 patch.
2) adjust the commit message.

v2:
1) change the commit title and message
2) reuse the delayed ack logic when handling the sack compression
as suggested by Eric.
3) "merge" another related patch into this one. See the second link.
---
 include/net/tcp.h    |  1 +
 net/ipv4/tcp_input.c |  2 +-
 net/ipv4/tcp_timer.c | 16 +++++++++++++---
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 18a038d16434..5066e4586cf0 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -632,6 +632,7 @@ void tcp_reset(struct sock *sk, struct sk_buff *skb);
 void tcp_skb_mark_lost_uncond_verify(struct tcp_sock *tp, struct sk_buff *skb);
 void tcp_fin(struct sock *sk);
 void tcp_check_space(struct sock *sk);
+void tcp_sack_compress_send_ack(struct sock *sk);
 
 /* tcp_timer.c */
 void tcp_init_xmit_timers(struct sock *);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 61b6710f337a..bf8b22218dd4 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4530,7 +4530,7 @@ static void tcp_sack_maybe_coalesce(struct tcp_sock *tp)
 	}
 }
 
-static void tcp_sack_compress_send_ack(struct sock *sk)
+void tcp_sack_compress_send_ack(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index b839c2f91292..39eb947fe392 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -290,9 +290,19 @@ static int tcp_write_timeout(struct sock *sk)
 void tcp_delack_timer_handler(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
+	struct tcp_sock *tp = tcp_sk(sk);
 
-	if (((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)) ||
-	    !(icsk->icsk_ack.pending & ICSK_ACK_TIMER))
+	if ((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN))
+		return;
+
+	/* Handling the sack compression case */
+	if (tp->compressed_ack) {
+		tcp_mstamp_refresh(tp);
+		tcp_sack_compress_send_ack(sk);
+		return;
+	}
+
+	if (!(icsk->icsk_ack.pending & ICSK_ACK_TIMER))
 		return;
 
 	if (time_after(icsk->icsk_ack.timeout, jiffies)) {
@@ -312,7 +322,7 @@ void tcp_delack_timer_handler(struct sock *sk)
 			inet_csk_exit_pingpong_mode(sk);
 			icsk->icsk_ack.ato      = TCP_ATO_MIN;
 		}
-		tcp_mstamp_refresh(tcp_sk(sk));
+		tcp_mstamp_refresh(tp);
 		tcp_send_ack(sk);
 		__NET_INC_STATS(sock_net(sk), LINUX_MIB_DELAYEDACKS);
 	}
-- 
2.17.1


