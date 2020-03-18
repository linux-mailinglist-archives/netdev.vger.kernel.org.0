Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30666189824
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 10:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbgCRJoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 05:44:00 -0400
Received: from smtp-rs2-vallila1.fe.helsinki.fi ([128.214.173.73]:51656 "EHLO
        smtp-rs2-vallila1.fe.helsinki.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727602AbgCRJn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 05:43:57 -0400
Received: from whs-18.cs.helsinki.fi (whs-18.cs.helsinki.fi [128.214.166.46])
        by smtp-rs2.it.helsinki.fi (8.14.7/8.14.7) with ESMTP id 02I9hoDF012835;
        Wed, 18 Mar 2020 11:43:50 +0200
Received: by whs-18.cs.helsinki.fi (Postfix, from userid 1070048)
        id BE037360030; Wed, 18 Mar 2020 11:43:50 +0200 (EET)
From:   =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
To:     netdev@vger.kernel.org
Cc:     Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Subject: [RFC PATCH 04/28] tcp: create FLAG_TS_PROGRESS
Date:   Wed, 18 Mar 2020 11:43:08 +0200
Message-Id: <1584524612-24470-5-git-send-email-ilpo.jarvinen@helsinki.fi>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584524612-24470-1-git-send-email-ilpo.jarvinen@helsinki.fi>
References: <1584524612-24470-1-git-send-email-ilpo.jarvinen@helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>

Whenever timestamp advances, it declares progress which
can be used the other parts of the stack to decide that
the ACK is the most recent one seen so far.

AccECN will use this flag when deciding whether to update
CEP from the ACE field or not.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
---
 net/ipv4/tcp_input.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 860938e0f1b6..7c444541cefd 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -100,6 +100,7 @@ int sysctl_tcp_max_orphans __read_mostly = NR_FILE;
 #define FLAG_UPDATE_TS_RECENT	0x4000 /* tcp_replace_ts_recent() */
 #define FLAG_NO_CHALLENGE_ACK	0x8000 /* do not call tcp_send_challenge_ack()	*/
 #define FLAG_ACK_MAYBE_DELAYED	0x10000 /* Likely a delayed ACK */
+#define FLAG_TS_PROGRESS	0x20000 /* Positive timestamp delta */
 
 #define FLAG_ACKED		(FLAG_DATA_ACKED|FLAG_SYN_ACKED)
 #define FLAG_NOT_DUP		(FLAG_DATA|FLAG_WIN_UPDATE|FLAG_ACKED)
@@ -3492,8 +3493,16 @@ static void tcp_store_ts_recent(struct tcp_sock *tp)
 	tp->rx_opt.ts_recent_stamp = ktime_get_seconds();
 }
 
-static void tcp_replace_ts_recent(struct tcp_sock *tp, u32 seq)
+static int __tcp_replace_ts_recent(struct tcp_sock *tp, s32 tstamp_delta)
 {
+	tcp_store_ts_recent(tp);
+	return tstamp_delta > 0 ? FLAG_TS_PROGRESS : 0;
+}
+
+static int tcp_replace_ts_recent(struct tcp_sock *tp, u32 seq)
+{
+	s32 delta;
+
 	if (tp->rx_opt.saw_tstamp && !after(seq, tp->rcv_wup)) {
 		/* PAWS bug workaround wrt. ACK frames, the PAWS discard
 		 * extra check below makes sure this can only happen
@@ -3502,9 +3511,13 @@ static void tcp_replace_ts_recent(struct tcp_sock *tp, u32 seq)
 		 * Not only, also it occurs for expired timestamps.
 		 */
 
-		if (tcp_paws_check(&tp->rx_opt, 0))
-			tcp_store_ts_recent(tp);
+		if (tcp_paws_check(&tp->rx_opt, 0)) {
+			delta = tp->rx_opt.rcv_tsval - tp->rx_opt.ts_recent;
+			return __tcp_replace_ts_recent(tp, delta);
+		}
 	}
+
+	return 0;
 }
 
 /* This routine deals with acks during a TLP episode.
@@ -3656,7 +3669,7 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 	 * is in window.
 	 */
 	if (flag & FLAG_UPDATE_TS_RECENT)
-		tcp_replace_ts_recent(tp, TCP_SKB_CB(skb)->seq);
+		flag |= tcp_replace_ts_recent(tp, TCP_SKB_CB(skb)->seq);
 
 	if ((flag & (FLAG_SLOWPATH | FLAG_SND_UNA_ADVANCED)) ==
 	    FLAG_SND_UNA_ADVANCED) {
@@ -5608,6 +5621,8 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 	    TCP_SKB_CB(skb)->seq == tp->rcv_nxt &&
 	    !after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt)) {
 		int tcp_header_len = tp->tcp_header_len;
+		int flag = 0;
+		s32 tstamp_delta = 0;
 
 		/* Timestamp header prediction: tcp_header_len
 		 * is automatically equal to th->doff*4 due to pred_flags
@@ -5620,8 +5635,9 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 			if (!tcp_parse_aligned_timestamp(tp, th))
 				goto slow_path;
 
+			tstamp_delta = tp->rx_opt.rcv_tsval - tp->rx_opt.ts_recent;
 			/* If PAWS failed, check it more carefully in slow path */
-			if ((s32)(tp->rx_opt.rcv_tsval - tp->rx_opt.ts_recent) < 0)
+			if (tstamp_delta < 0)
 				goto slow_path;
 
 			/* DO NOT update ts_recent here, if checksum fails
@@ -5641,12 +5657,12 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 				if (tcp_header_len ==
 				    (sizeof(struct tcphdr) + TCPOLEN_TSTAMP_ALIGNED) &&
 				    tp->rcv_nxt == tp->rcv_wup)
-					tcp_store_ts_recent(tp);
+					flag |= __tcp_replace_ts_recent(tp, tstamp_delta);
 
 				/* We know that such packets are checksummed
 				 * on entry.
 				 */
-				tcp_ack(sk, skb, 0);
+				tcp_ack(sk, skb, flag);
 				__kfree_skb(skb);
 				tcp_data_snd_check(sk);
 				/* When receiving pure ack in fast path, update
@@ -5676,7 +5692,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 			if (tcp_header_len ==
 			    (sizeof(struct tcphdr) + TCPOLEN_TSTAMP_ALIGNED) &&
 			    tp->rcv_nxt == tp->rcv_wup)
-				tcp_store_ts_recent(tp);
+				flag |= __tcp_replace_ts_recent(tp, tstamp_delta);
 
 			tcp_rcv_rtt_measure_ts(sk, skb);
 
@@ -5690,7 +5706,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 
 			if (TCP_SKB_CB(skb)->ack_seq != tp->snd_una) {
 				/* Well, only one small jumplet in fast path... */
-				tcp_ack(sk, skb, FLAG_DATA);
+				tcp_ack(sk, skb, flag | FLAG_DATA);
 				tcp_data_snd_check(sk);
 				if (!inet_csk_ack_scheduled(sk))
 					goto no_ack;
-- 
2.20.1

