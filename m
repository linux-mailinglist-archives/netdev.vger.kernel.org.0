Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 115DE189870
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 10:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbgCRJrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 05:47:33 -0400
Received: from smtp-rs2-vallila1.fe.helsinki.fi ([128.214.173.73]:53282 "EHLO
        smtp-rs2-vallila1.fe.helsinki.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727547AbgCRJrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 05:47:32 -0400
Received: from whs-18.cs.helsinki.fi (whs-18.cs.helsinki.fi [128.214.166.46])
        by smtp-rs2.it.helsinki.fi (8.14.7/8.14.7) with ESMTP id 02I9cEjB006458;
        Wed, 18 Mar 2020 11:38:14 +0200
Received: by whs-18.cs.helsinki.fi (Postfix, from userid 1070048)
        id 92E11360F5A; Wed, 18 Mar 2020 11:38:14 +0200 (EET)
From:   =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
To:     netdev@vger.kernel.org
Cc:     Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Subject: [RFC PATCH 22/28] tcp: AccECN option order bit & failure handling
Date:   Wed, 18 Mar 2020 11:38:03 +0200
Message-Id: <1584524289-24187-22-git-send-email-ilpo.jarvinen@helsinki.fi>
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

AccECN option has two possible field orders. Collect the
order bit from first AccECN option that has enough length
to contain it.

AccECN option may fail in various way, handle these:
- Remove option from SYN/ACK rexmits to handle blackholes
- If no option arrives in SYN/ACK, assume Option is not usable
	- If an option arrives later, re-enabled
- If option is zeroed, disable AccECN option processing

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
---
 include/linux/tcp.h      |  2 ++
 include/net/tcp.h        | 10 +++++++++
 net/ipv4/tcp.c           |  1 +
 net/ipv4/tcp_input.c     | 46 ++++++++++++++++++++++++++++++++++------
 net/ipv4/tcp_minisocks.c | 32 ++++++++++++++++++++++++++++
 net/ipv4/tcp_output.c    |  4 +++-
 6 files changed, 88 insertions(+), 7 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index c381aea5c764..64db51e5d45e 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -151,6 +151,7 @@ struct tcp_request_sock {
 	bool				tfo_listener;
 	bool				is_mptcp;
 	u8				accecn_ok  : 1,
+					saw_accecn_opt : 3,
 					syn_ect_snt: 2,
 					syn_ect_rcv: 2;
 	u32				txhash;
@@ -252,6 +253,7 @@ struct tcp_sock {
 	u8	compressed_ack;
 	u8	syn_ect_snt:2,	/* AccECN ECT memory, only */
 		syn_ect_rcv:2,	/* ... needed durign 3WHS + first seqno */
+		saw_accecn_opt:3,    /* A valid AccECN option was seen */
 		ecn_fail:1;	/* ECN reflector detected path mangling */
 	u32	chrono_start;	/* Start time in jiffies of a TCP chrono */
 	u32	chrono_stat[3];	/* Time in jiffies for chrono_stat stats */
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 52567d8fca33..a29109fa2ce2 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -226,6 +226,14 @@ void tcp_time_wait(struct sock *sk, int state, int timeo);
 					 TCP_ACCECN_NUMCOUNTERS)
 #define TCP_ACCECN_BEACON_FREQ_SHIFT	2 /* Send option at least 2^2 times per RTT */
 
+/* tp->saw_accecn_opt states, empty seen & orderbit are overloaded */
+#define TCP_ACCECN_OPT_EMPTY_SEEN	0x1
+#define TCP_ACCECN_OPT_ORDERBIT		0x1
+#define TCP_ACCECN_OPT_COUNTER_SEEN	0x2
+#define TCP_ACCECN_OPT_SEEN		(TCP_ACCECN_OPT_COUNTER_SEEN | \
+					 TCP_ACCECN_OPT_EMPTY_SEEN)
+#define TCP_ACCECN_OPT_FAIL		0x4
+
 /* Flags in tp->nonagle */
 #define TCP_NAGLE_OFF		1	/* Nagle's algo is disabled */
 #define TCP_NAGLE_CORK		2	/* Socket is corked	    */
@@ -443,6 +451,7 @@ static inline u32 tcp_accecn_ace_deficit(const struct tcp_sock *tp)
 bool tcp_accecn_validate_syn_feedback(struct sock *sk, u8 ace, u8 sent_ect);
 void tcp_accecn_third_ack(struct sock *sk, const struct sk_buff *skb,
 			  u8 syn_ect_snt);
+u8 tcp_accecn_option_init(const struct sk_buff *skb, u8 opt_offset);
 void tcp_ecn_received_counters(struct sock *sk, const struct sk_buff *skb,
 			       u32 payload_len);
 
@@ -885,6 +894,7 @@ static inline u64 tcp_skb_timestamp_us(const struct sk_buff *skb)
  */
 #define TCP_ACCECN_CEP_INIT_OFFSET 5
 #define TCP_ACCECN_E1B_INIT_OFFSET 0
+#define TCP_ACCECN_E1B_FIRST_INIT_OFFSET 0x800001
 #define TCP_ACCECN_E0B_INIT_OFFSET 1
 #define TCP_ACCECN_CEB_INIT_OFFSET 0
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index cfbdc1468342..09f73f81e6fa 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2624,6 +2624,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	tp->window_clamp = 0;
 	tp->delivered = 0;
 	tp->delivered_ce = 0;
+	tp->saw_accecn_opt = 0;
 	tp->ecn_fail = 0;
 	tcp_accecn_init_counters(tp);
 	tp->prev_ecnfield = 0;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 504309a73de2..826dfd5bf114 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -352,7 +352,8 @@ bool tcp_accecn_validate_syn_feedback(struct sock *sk, u8 ace, u8 sent_ect)
 }
 
 /* See Table 2 of the AccECN draft */
-static void tcp_ecn_rcv_synack(struct sock *sk, const struct tcphdr *th,
+static void tcp_ecn_rcv_synack(struct sock *sk, const struct sk_buff *skb,
+			       const struct tcphdr *th,
 			       u8 ip_dsfield)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
@@ -372,7 +373,12 @@ static void tcp_ecn_rcv_synack(struct sock *sk, const struct tcphdr *th,
 	default:
 		tcp_ecn_mode_set(tp, TCP_ECN_MODE_ACCECN);
 		tp->syn_ect_rcv = ip_dsfield & INET_ECN_MASK;
-		tp->accecn_opt_demand = 2;
+		if (tp->rx_opt.accecn >= 0 &&
+		    tp->saw_accecn_opt < TCP_ACCECN_OPT_COUNTER_SEEN) {
+			tp->saw_accecn_opt = tcp_accecn_option_init(skb,
+								    tp->rx_opt.accecn);
+			tp->accecn_opt_demand = 2;
+		}
 		if (tcp_accecn_validate_syn_feedback(sk, ace, tp->syn_ect_snt) &&
 		    INET_ECN_is_ce(ip_dsfield))
 			tp->received_ce++;
@@ -436,7 +442,19 @@ static bool tcp_accecn_process_option(struct tcp_sock *tp,
 	bool first_changed = false;
 	bool res;
 
+	if (tp->saw_accecn_opt == TCP_ACCECN_OPT_FAIL)
+		return false;
+
 	if (tp->rx_opt.accecn < 0) {
+		if (!tp->saw_accecn_opt) {
+			/* Too late to enable after this point due to
+			 * potential counter wraps
+			 */
+			if (tp->bytes_sent >= (1 << 23) - 1)
+				tp->saw_accecn_opt = TCP_ACCECN_OPT_FAIL;
+			return false;
+		}
+
 		if (tp->estimate_ecnfield) {
 			tp->delivered_ecn_bytes[tp->estimate_ecnfield - 1] +=
 				delivered_bytes;
@@ -453,11 +471,20 @@ static bool tcp_accecn_process_option(struct tcp_sock *tp,
 	}
 	ptr += 2;
 
+	if (tp->saw_accecn_opt < TCP_ACCECN_OPT_COUNTER_SEEN)
+		tp->saw_accecn_opt = tcp_accecn_option_init(skb,
+							    tp->rx_opt.accecn);
+
 	res = !!tp->estimate_ecnfield;
 	for (i = 0; i < 3; i++) {
 		if (optlen >= TCPOLEN_ACCECN_PERCOUNTER) {
-			u8 ecnfield = accecn_opt_ecnfield[i];
-			u32 init_offset = i ? 0 : TCP_ACCECN_E0B_INIT_OFFSET;
+			u8 orderbit = tp->saw_accecn_opt & TCP_ACCECN_OPT_ORDERBIT;
+			int idx = orderbit ? i : 2 - i;
+			u8 ecnfield = accecn_opt_ecnfield[idx];
+			u32 init_offset = i ? 0 :
+					      !orderbit ?
+					      TCP_ACCECN_E0B_INIT_OFFSET :
+					      TCP_ACCECN_E1B_FIRST_INIT_OFFSET;
 			s32 delta;
 
 			delta = tcp_update_ecn_bytes(&(tp->delivered_ecn_bytes[ecnfield - 1]),
@@ -4188,6 +4215,7 @@ void tcp_parse_options(const struct net *net,
 				    get_unaligned_be16(ptr) ==
 				    TCPOPT_ACCECN_MAGIC)
 					opt_rx->accecn = (ptr - 2) - (unsigned char *)th;
+
 				/* Fast Open option shares code 254 using a
 				 * 16 bits magic number.
 				 */
@@ -5836,7 +5864,12 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 	if (th->syn) {
 		if (tcp_ecn_mode_accecn(tp)) {
 			send_accecn_reflector = true;
-			tp->accecn_opt_demand = max_t(u8, 1, tp->accecn_opt_demand);
+			if (tp->rx_opt.accecn >= 0 &&
+			    tp->saw_accecn_opt < TCP_ACCECN_OPT_COUNTER_SEEN) {
+				tp->saw_accecn_opt = tcp_accecn_option_init(skb,
+									    tp->rx_opt.accecn);
+				tp->accecn_opt_demand = max_t(u8, 1, tp->accecn_opt_demand);
+			}
 		}
 syn_challenge:
 		if (syn_inerr)
@@ -6279,7 +6312,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 		 */
 
 		if (tcp_ecn_mode_any(tp))
-			tcp_ecn_rcv_synack(sk, th, TCP_SKB_CB(skb)->ip_dsfield);
+			tcp_ecn_rcv_synack(sk, skb, th, TCP_SKB_CB(skb)->ip_dsfield);
 
 		tcp_init_wl(tp, TCP_SKB_CB(skb)->seq);
 		tcp_try_undo_spurious_syn(sk);
@@ -6812,6 +6845,7 @@ static void tcp_openreq_init(struct request_sock *req,
 	tcp_rsk(req)->snt_synack = 0;
 	tcp_rsk(req)->last_oow_ack_time = 0;
 	tcp_rsk(req)->accecn_ok = 0;
+	tcp_rsk(req)->saw_accecn_opt = 0;
 	tcp_rsk(req)->syn_ect_rcv = 0;
 	tcp_rsk(req)->syn_ect_snt = 0;
 	req->mss = rx_opt->mss_clamp;
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 2e532758a34a..eda3d0c3af32 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -97,6 +97,7 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
 	bool paws_reject = false;
 
 	tmp_opt.saw_tstamp = 0;
+	tmp_opt.accecn = -1;
 	if (th->doff > (sizeof(*th) >> 2) && tcptw->tw_ts_recent_stamp) {
 		tcp_parse_options(twsk_net(tw), skb, &tmp_opt, 0, NULL);
 
@@ -437,6 +438,7 @@ static void tcp_ecn_openreq_child(struct sock *sk,
 		tcp_ecn_mode_set(tp, TCP_ECN_MODE_ACCECN);
 		tp->syn_ect_snt = treq->syn_ect_snt;
 		tcp_accecn_third_ack(sk, skb, treq->syn_ect_snt);
+		tp->saw_accecn_opt = treq->saw_accecn_opt;
 		tp->prev_ecnfield = treq->syn_ect_rcv;
 		tp->accecn_opt_demand = 1;
 		tcp_ecn_received_counters(sk, skb, skb->len - th->doff * 4);
@@ -491,6 +493,32 @@ static void smc_check_reset_syn_req(struct tcp_sock *oldtp,
 #endif
 }
 
+u8 tcp_accecn_option_init(const struct sk_buff *skb, u8 opt_offset)
+{
+	unsigned char *ptr = skb_transport_header(skb) + opt_offset;
+	unsigned int optlen = ptr[1];
+
+	if (ptr[0] == TCPOPT_EXP) {
+		optlen -= 2;
+		ptr += 2;
+	}
+	ptr += 2;
+
+	if (optlen >= TCPOLEN_ACCECN_PERCOUNTER) {
+		u32 first_field = get_unaligned_be32(ptr - 1) & 0xFFFFFFU;
+		u8 orderbit = first_field >> 23;
+		/* Detect option zeroing. Check the first byte counter value,
+		 * if present, it must be != 0.
+		 */
+		if (!first_field)
+			return TCP_ACCECN_OPT_FAIL;
+
+		return TCP_ACCECN_OPT_COUNTER_SEEN + orderbit;
+	}
+
+	return TCP_ACCECN_OPT_EMPTY_SEEN;
+}
+
 /* This is not only more efficient than what we used to do, it eliminates
  * a lot of code duplication between IPv4/IPv6 SYN recv processing. -DaveM
  *
@@ -793,6 +821,10 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 	if (!(flg & TCP_FLAG_ACK))
 		return NULL;
 
+	if (tcp_rsk(req)->accecn_ok && tmp_opt.accecn >= 0 &&
+	    tcp_rsk(req)->saw_accecn_opt < TCP_ACCECN_OPT_COUNTER_SEEN)
+		tcp_rsk(req)->saw_accecn_opt = tcp_accecn_option_init(skb, tmp_opt.accecn);
+
 	/* For Fast Open no more processing is needed (sk is the
 	 * child socket).
 	 */
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index f070128b69e6..4cc590a47f43 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -841,6 +841,7 @@ static unsigned int tcp_syn_options(struct sock *sk, struct sk_buff *skb,
 	/* Simultaneous open SYN/ACK needs AccECN option but not SYN */
 	if (unlikely((TCP_SKB_CB(skb)->tcp_flags & TCPHDR_ACK) &&
 		     tcp_ecn_mode_accecn(tp) &&
+		     inet_csk(sk)->icsk_retransmits < 2 &&
 		     !(sock_net(sk)->ipv4.sysctl_tcp_ecn & TCP_ACCECN_NO_OPT) &&
 		     (remaining >= TCPOLEN_EXP_ACCECN_BASE))) {
 		opts->ecn_bytes = synack_ecn_bytes;
@@ -914,7 +915,7 @@ static unsigned int tcp_synack_options(const struct sock *sk,
 
 	smc_set_option_cond(tcp_sk(sk), ireq, opts, &remaining);
 
-	if (treq->accecn_ok &&
+	if (treq->accecn_ok && req->num_timeout < 1 &&
 	    !(sock_net(sk)->ipv4.sysctl_tcp_ecn & TCP_ACCECN_NO_OPT) &&
 	    (remaining >= TCPOLEN_EXP_ACCECN_BASE)) {
 		opts->ecn_bytes = synack_ecn_bytes;
@@ -990,6 +991,7 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
 	}
 
 	if (tcp_ecn_mode_accecn(tp) &&
+	    (tp->saw_accecn_opt & TCP_ACCECN_OPT_SEEN) &&
 	    !(sock_net(sk)->ipv4.sysctl_tcp_ecn & TCP_ACCECN_NO_OPT)) {
 		if (tp->accecn_opt_demand ||
 		    (tcp_stamp_us_delta(tp->tcp_mstamp, tp->accecn_opt_tstamp) >=
-- 
2.20.1

