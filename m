Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBC018986A
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 10:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbgCRJrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 05:47:20 -0400
Received: from smtp-rs2-vallila1.fe.helsinki.fi ([128.214.173.73]:53282 "EHLO
        smtp-rs2-vallila1.fe.helsinki.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727405AbgCRJrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 05:47:19 -0400
Received: from whs-18.cs.helsinki.fi (whs-18.cs.helsinki.fi [128.214.166.46])
        by smtp-rs2.it.helsinki.fi (8.14.7/8.14.7) with ESMTP id 02I9cE9T006445;
        Wed, 18 Mar 2020 11:38:14 +0200
Received: by whs-18.cs.helsinki.fi (Postfix, from userid 1070048)
        id 6C91E360F55; Wed, 18 Mar 2020 11:38:14 +0200 (EET)
From:   =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
To:     netdev@vger.kernel.org
Cc:     Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Subject: [RFC PATCH 15/28] tcp: add AccECN rx byte counters
Date:   Wed, 18 Mar 2020 11:37:56 +0200
Message-Id: <1584524289-24187-15-git-send-email-ilpo.jarvinen@helsinki.fi>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584524289-24187-2-git-send-email-ilpo.jarvinen@helsinki.fi>
References: <1584524289-24187-2-git-send-email-ilpo.jarvinen@helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
---
 include/linux/tcp.h      |  1 +
 include/net/tcp.h        | 18 +++++++++++++++++-
 net/ipv4/tcp_input.c     | 13 +++++++++----
 net/ipv4/tcp_minisocks.c |  3 ++-
 4 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index a6b1d150cb05..6b81d7eb0117 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -323,6 +323,7 @@ struct tcp_sock {
 	u32	delivered_ce;	/* Like the above but only ECE marked packets */
 	u32	received_ce;	/* Like the above but for received CE marked packets */
 	u32	received_ce_tx; /* Like the above but max transmitted value */
+	u32	received_ecn_bytes[3];
 	u32	lost;		/* Total data packets lost incl. rexmits */
 	u32	app_limited;	/* limited until "delivered" reaches this val */
 	u64	first_tx_mstamp;  /* start of window send phase */
diff --git a/include/net/tcp.h b/include/net/tcp.h
index e1dd06bbb472..5824447b1fc5 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -429,7 +429,8 @@ static inline u32 tcp_accecn_ace_deficit(const struct tcp_sock *tp)
 bool tcp_accecn_validate_syn_feedback(struct sock *sk, u8 ace, u8 sent_ect);
 void tcp_accecn_third_ack(struct sock *sk, const struct sk_buff *skb,
 			  u8 syn_ect_snt);
-void tcp_ecn_received_counters(struct sock *sk, const struct sk_buff *skb);
+void tcp_ecn_received_counters(struct sock *sk, const struct sk_buff *skb,
+			       u32 payload_len);
 
 enum tcp_tw_status {
 	TCP_TW_SUCCESS = 0,
@@ -869,11 +870,26 @@ static inline u64 tcp_skb_timestamp_us(const struct sk_buff *skb)
  * See draft-ietf-tcpm-accurate-ecn for the latest values.
  */
 #define TCP_ACCECN_CEP_INIT_OFFSET 5
+#define TCP_ACCECN_E1B_INIT_OFFSET 0
+#define TCP_ACCECN_E0B_INIT_OFFSET 1
+#define TCP_ACCECN_CEB_INIT_OFFSET 0
+
+static inline void __tcp_accecn_init_bytes_counters(int *counter_array)
+{
+	BUILD_BUG_ON(INET_ECN_ECT_1 != 0x1);
+	BUILD_BUG_ON(INET_ECN_ECT_0 != 0x2);
+	BUILD_BUG_ON(INET_ECN_CE != 0x3);
+
+	counter_array[INET_ECN_ECT_1 - 1] = 0;
+	counter_array[INET_ECN_ECT_0 - 1] = 0;
+	counter_array[INET_ECN_CE - 1] = 0;
+}
 
 static inline void tcp_accecn_init_counters(struct tcp_sock *tp)
 {
 	tp->received_ce = 0;
 	tp->received_ce_tx = 0;
+	__tcp_accecn_init_bytes_counters(tp->received_ecn_bytes);
 }
 
 /* This is what the send packet queuing engine uses to pass
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index bf307be4c659..3109e3199906 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5559,7 +5559,8 @@ static void tcp_urg(struct sock *sk, struct sk_buff *skb, const struct tcphdr *t
 }
 
 /* Updates Accurate ECN received counters from the received IP ECN field */
-void tcp_ecn_received_counters(struct sock *sk, const struct sk_buff *skb)
+void tcp_ecn_received_counters(struct sock *sk, const struct sk_buff *skb,
+			       u32 payload_len)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	u8 ecnfield = TCP_SKB_CB(skb)->ip_dsfield & INET_ECN_MASK;
@@ -5570,6 +5571,10 @@ void tcp_ecn_received_counters(struct sock *sk, const struct sk_buff *skb)
 
 		/* ACE counter tracks *all* segments including pure acks */
 		tp->received_ce += is_ce * max_t(u16, 1, skb_shinfo(skb)->gso_segs);
+
+		if (payload_len > 0) {
+			tp->received_ecn_bytes[ecnfield - 1] += payload_len;
+		}
 	}
 }
 
@@ -5808,7 +5813,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 				    tp->rcv_nxt == tp->rcv_wup)
 					flag |= __tcp_replace_ts_recent(tp, tstamp_delta);
 
-				tcp_ecn_received_counters(sk, skb);
+				tcp_ecn_received_counters(sk, skb, 0);
 
 				/* We know that such packets are checksummed
 				 * on entry.
@@ -5851,7 +5856,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 
 			/* Bulk data transfer: receiver */
 			__skb_pull(skb, tcp_header_len);
-			tcp_ecn_received_counters(sk, skb);
+			tcp_ecn_received_counters(sk, skb, len - tcp_header_len);
 			eaten = tcp_queue_rcv(sk, skb, &fragstolen);
 
 			tcp_event_data_recv(sk, skb);
@@ -5888,7 +5893,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 		return;
 
 step5:
-	tcp_ecn_received_counters(sk, skb);
+	tcp_ecn_received_counters(sk, skb, len - th->doff * 4);
 
 	if (tcp_ack(sk, skb, FLAG_SLOWPATH | FLAG_UPDATE_TS_RECENT) < 0)
 		goto discard;
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 57b7cf4658fc..668edd00e377 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -433,10 +433,11 @@ static void tcp_ecn_openreq_child(struct sock *sk,
 	const struct tcp_request_sock *treq = tcp_rsk(req);
 
 	if (treq->accecn_ok) {
+		const struct tcphdr *th = (const struct tcphdr *)skb->data;
 		tcp_ecn_mode_set(tp, TCP_ECN_MODE_ACCECN);
 		tp->syn_ect_snt = treq->syn_ect_snt;
 		tcp_accecn_third_ack(sk, skb, treq->syn_ect_snt);
-		tcp_ecn_received_counters(sk, skb);
+		tcp_ecn_received_counters(sk, skb, skb->len - th->doff * 4);
 	} else {
 		tcp_ecn_mode_set(tp, inet_rsk(req)->ecn_ok ?
 				     TCP_ECN_MODE_RFC3168 :
-- 
2.20.1

