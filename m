Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28966189833
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 10:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727710AbgCRJoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 05:44:21 -0400
Received: from smtp-rs2-vallila1.fe.helsinki.fi ([128.214.173.73]:51678 "EHLO
        smtp-rs2-vallila1.fe.helsinki.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727632AbgCRJoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 05:44:01 -0400
Received: from whs-18.cs.helsinki.fi (whs-18.cs.helsinki.fi [128.214.166.46])
        by smtp-rs2.it.helsinki.fi (8.14.7/8.14.7) with ESMTP id 02I9hpqk012885;
        Wed, 18 Mar 2020 11:43:51 +0200
Received: by whs-18.cs.helsinki.fi (Postfix, from userid 1070048)
        id 06724360030; Wed, 18 Mar 2020 11:43:50 +0200 (EET)
From:   =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
To:     netdev@vger.kernel.org
Cc:     Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Subject: [RFC PATCH 17/28] tcp: AccECN needs to know delivered bytes
Date:   Wed, 18 Mar 2020 11:43:21 +0200
Message-Id: <1584524612-24470-18-git-send-email-ilpo.jarvinen@helsinki.fi>
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

AccECN byte counter estimation requires delivered bytes
which can be calculated while processing SACK blocks and
cumulative ACK.

Non-SACK calculation is quite annoying, inaccurate, and
likely bogus.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
---
 net/ipv4/tcp_input.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 3109e3199906..0a63f8a49057 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1235,6 +1235,7 @@ static bool tcp_check_dsack(struct sock *sk, const struct sk_buff *ack_skb,
 
 struct tcp_sacktag_state {
 	u32	reord;
+	u32	delivered_bytes;
 	/* Timestamps for earliest and latest never-retransmitted segment
 	 * that was SACKed. RTO needs the earliest RTT to stay conservative,
 	 * but congestion control should still get an accurate delay signal.
@@ -1306,7 +1307,7 @@ static int tcp_match_skb_to_sack(struct sock *sk, struct sk_buff *skb,
 static u8 tcp_sacktag_one(struct sock *sk,
 			  struct tcp_sacktag_state *state, u8 sacked,
 			  u32 start_seq, u32 end_seq,
-			  int dup_sack, int pcount,
+			  int dup_sack, int pcount, u32 plen,
 			  u64 xmit_time)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
@@ -1365,6 +1366,7 @@ static u8 tcp_sacktag_one(struct sock *sk,
 		state->flag |= FLAG_DATA_SACKED;
 		tp->sacked_out += pcount;
 		tp->delivered += pcount;  /* Out-of-order packets delivered */
+		state->delivered_bytes += plen;
 
 		/* Lost marker hint past SACKed? Tweak RFC3517 cnt */
 		if (tp->lost_skb_hint &&
@@ -1406,7 +1408,7 @@ static bool tcp_shifted_skb(struct sock *sk, struct sk_buff *prev,
 	 * tcp_highest_sack_seq() when skb is highest_sack.
 	 */
 	tcp_sacktag_one(sk, state, TCP_SKB_CB(skb)->sacked,
-			start_seq, end_seq, dup_sack, pcount,
+			start_seq, end_seq, dup_sack, pcount, skb->len,
 			tcp_skb_timestamp_us(skb));
 	tcp_rate_skb_delivered(sk, skb, state->rate);
 
@@ -1696,6 +1698,7 @@ static struct sk_buff *tcp_sacktag_walk(struct sk_buff *skb, struct sock *sk,
 						TCP_SKB_CB(skb)->end_seq,
 						dup_sack,
 						tcp_skb_pcount(skb),
+						skb->len,
 						tcp_skb_timestamp_us(skb));
 			tcp_rate_skb_delivered(sk, skb, state->rate);
 			if (TCP_SKB_CB(skb)->sacked & TCPCB_SACKED_ACKED)
@@ -3239,6 +3242,7 @@ static int tcp_clean_rtx_queue(struct sock *sk, u32 prior_fack,
 			tp->sacked_out -= acked_pcount;
 		} else if (tcp_is_sack(tp)) {
 			tp->delivered += acked_pcount;
+			sack->delivered_bytes += skb->len;
 			if (!tcp_skb_spurious_retrans(tp, skb))
 				tcp_rack_advance(tp, sacked, scb->end_seq,
 						 tcp_skb_timestamp_us(skb));
@@ -3325,6 +3329,10 @@ static int tcp_clean_rtx_queue(struct sock *sk, u32 prior_fack,
 			 */
 			if (flag & FLAG_RETRANS_DATA_ACKED)
 				flag &= ~FLAG_ORIG_SACK_ACKED;
+
+			sack->delivered_bytes = (skb ?
+						 TCP_SKB_CB(skb)->seq :
+						 tp->snd_una) - prior_snd_una;
 		} else {
 			int delta;
 
@@ -3742,6 +3750,7 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 	u32 ecn_count = 0; /* Did we receive ECE/an AccECN ACE update? */
 	u32 prior_fack;
 
+	sack_state.delivered_bytes = 0;
 	sack_state.first_sackt = 0;
 	sack_state.rate = &rs;
 
-- 
2.20.1

