Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49E2318986C
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 10:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbgCRJrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 05:47:25 -0400
Received: from smtp-rs2-vallila1.fe.helsinki.fi ([128.214.173.73]:53282 "EHLO
        smtp-rs2-vallila1.fe.helsinki.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727673AbgCRJrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 05:47:25 -0400
Received: from whs-18.cs.helsinki.fi (whs-18.cs.helsinki.fi [128.214.166.46])
        by smtp-rs2.it.helsinki.fi (8.14.7/8.14.7) with ESMTP id 02I9cElv006449;
        Wed, 18 Mar 2020 11:38:14 +0200
Received: by whs-18.cs.helsinki.fi (Postfix, from userid 1070048)
        id 89D11360F57; Wed, 18 Mar 2020 11:38:14 +0200 (EET)
From:   =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
To:     netdev@vger.kernel.org
Cc:     Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Subject: [RFC PATCH 20/28] tcp: AccECN option send control
Date:   Wed, 18 Mar 2020 11:38:01 +0200
Message-Id: <1584524289-24187-20-git-send-email-ilpo.jarvinen@helsinki.fi>
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

Instead of sending the option in every ACK, limit sending to
those ACKs where the option is necessary:
- Handshake
- First data (only an approximation to avoid extra state)
- "Change-triggered ACK" + the ACK following it. The
  2nd ACK is necessary to unambiguously indicate which
  of the ECN byte counters in increasing. The first
  ACK has two counters increasing due to the ecnfield
  edge.
- ACKs with CE to allow CEP delta calculations to take
  advantage of the option
- Force option to be sent every at least once per 2^22
  bytes. The check is done using bytes_received to avoid
  adding another var into tcp_sock and may demand option
  even if one was recently sent but that is not a big
  deal.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
---
 include/linux/tcp.h      |  2 ++
 include/net/tcp.h        |  1 +
 net/ipv4/tcp.c           |  1 +
 net/ipv4/tcp_input.c     | 27 +++++++++++++++++++++++++++
 net/ipv4/tcp_minisocks.c |  2 ++
 net/ipv4/tcp_output.c    |  7 +++++--
 6 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index fd232bb7fae9..b3cf33af3eb0 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -327,6 +327,8 @@ struct tcp_sock {
 	u32	received_ce_tx; /* Like the above but max transmitted value */
 	u32	received_ecn_bytes[3];
 	u8	accecn_minlen:2,/* Minimum length of AccECN option sent */
+		prev_ecnfield:2,/* ECN bits from the previous segment */
+		accecn_opt_demand:2,/* Demand AccECN option for n next ACKs */
 		estimate_ecnfield:2;/* ECN field for AccECN delivered estimates */
 	u32	lost;		/* Total data packets lost incl. rexmits */
 	u32	app_limited;	/* limited until "delivered" reaches this val */
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 54471c2dedd5..4367e21b4521 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -905,6 +905,7 @@ static inline void tcp_accecn_init_counters(struct tcp_sock *tp)
 	__tcp_accecn_init_bytes_counters(tp->received_ecn_bytes);
 	__tcp_accecn_init_bytes_counters(tp->delivered_ecn_bytes);
 	tp->accecn_minlen = 0;
+	tp->accecn_opt_demand = 0;
 	tp->estimate_ecnfield = 0;
 }
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 624dff543301..a966cfc0214e 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2626,6 +2626,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	tp->delivered_ce = 0;
 	tp->ecn_fail = 0;
 	tcp_accecn_init_counters(tp);
+	tp->prev_ecnfield = 0;
 	tcp_set_ca_state(sk, TCP_CA_Open);
 	tp->is_sack_reneg = 0;
 	tcp_clear_retrans(tp);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index d34b50f73652..504309a73de2 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -372,6 +372,7 @@ static void tcp_ecn_rcv_synack(struct sock *sk, const struct tcphdr *th,
 	default:
 		tcp_ecn_mode_set(tp, TCP_ECN_MODE_ACCECN);
 		tp->syn_ect_rcv = ip_dsfield & INET_ECN_MASK;
+		tp->accecn_opt_demand = 2;
 		if (tcp_accecn_validate_syn_feedback(sk, ace, tp->syn_ect_snt) &&
 		    INET_ECN_is_ce(ip_dsfield))
 			tp->received_ce++;
@@ -388,6 +389,7 @@ static void tcp_ecn_rcv_syn(struct tcp_sock *tp, const struct tcphdr *th,
 			tcp_ecn_mode_set(tp, TCP_ECN_MODE_RFC3168);
 		} else {
 			tp->syn_ect_rcv = TCP_SKB_CB(skb)->ip_dsfield & INET_ECN_MASK;
+			tp->prev_ecnfield = tp->syn_ect_rcv;
 			tcp_ecn_mode_set(tp, TCP_ECN_MODE_ACCECN);
 		}
 	}
@@ -5679,6 +5681,7 @@ void tcp_ecn_received_counters(struct sock *sk, const struct sk_buff *skb,
 	struct tcp_sock *tp = tcp_sk(sk);
 	u8 ecnfield = TCP_SKB_CB(skb)->ip_dsfield & INET_ECN_MASK;
 	u8 is_ce = INET_ECN_is_ce(ecnfield);
+	u8 ecn_edge = tp->prev_ecnfield != ecnfield;
 
 	if (!INET_ECN_is_not_ect(ecnfield)) {
 		tp->ecn_flags |= TCP_ECN_SEEN;
@@ -5688,8 +5691,31 @@ void tcp_ecn_received_counters(struct sock *sk, const struct sk_buff *skb,
 
 		if (payload_len > 0) {
 			u8 minlen = tcp_ecn_field_to_accecn_len(ecnfield);
+			u32 oldbytes = tp->received_ecn_bytes[ecnfield - 1];
+
 			tp->received_ecn_bytes[ecnfield - 1] += payload_len;
 			tp->accecn_minlen = max_t(u8, tp->accecn_minlen, minlen);
+
+			/* Demand AccECN option at least every 2^22 bytes to
+			 * avoid overflowing the ECN byte counters.
+			 */
+			if ((tp->received_ecn_bytes[ecnfield - 1] ^ oldbytes) &
+			    ~((1 << 22) - 1))
+				tp->accecn_opt_demand = max_t(u8, 1,
+							      tp->accecn_opt_demand);
+		}
+	}
+
+	if (ecn_edge || is_ce) {
+		tp->prev_ecnfield = ecnfield;
+		/* Demand Accurate ECN change-triggered ACKs. Two ACK are
+		 * demanded to indicate unambiguously the ecnfield value
+		 * in the latter ACK.
+		 */
+		if (tcp_ecn_mode_accecn(tp)) {
+			if (ecn_edge)
+				inet_csk(sk)->icsk_ack.pending |= ICSK_ACK_NOW;
+			tp->accecn_opt_demand = 2;
 		}
 	}
 }
@@ -5810,6 +5836,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 	if (th->syn) {
 		if (tcp_ecn_mode_accecn(tp)) {
 			send_accecn_reflector = true;
+			tp->accecn_opt_demand = max_t(u8, 1, tp->accecn_opt_demand);
 		}
 syn_challenge:
 		if (syn_inerr)
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 668edd00e377..2e532758a34a 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -437,6 +437,8 @@ static void tcp_ecn_openreq_child(struct sock *sk,
 		tcp_ecn_mode_set(tp, TCP_ECN_MODE_ACCECN);
 		tp->syn_ect_snt = treq->syn_ect_snt;
 		tcp_accecn_third_ack(sk, skb, treq->syn_ect_snt);
+		tp->prev_ecnfield = treq->syn_ect_rcv;
+		tp->accecn_opt_demand = 1;
 		tcp_ecn_received_counters(sk, skb, skb->len - th->doff * 4);
 	} else {
 		tcp_ecn_mode_set(tp, inet_rsk(req)->ecn_ok ?
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 7bce1a73ac8f..118d5c73bcb9 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -586,8 +586,11 @@ static void tcp_options_write(__be32 *ptr, struct tcp_sock *tp,
 				leftover_size = 1;
 			}
 		}
-		if (tp != NULL)
+		if (tp != NULL) {
 			tp->accecn_minlen = 0;
+			if (tp->accecn_opt_demand)
+				tp->accecn_opt_demand--;
+		}
 	}
 	if (unlikely(OPTION_SACK_ADVERTISE & options)) {
 		*ptr++ = htonl((leftover_bytes << 16) |
@@ -985,7 +988,7 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
 		}
 	}
 
-	if (tcp_ecn_mode_accecn(tp) &&
+	if (tcp_ecn_mode_accecn(tp) && tp->accecn_opt_demand &&
 	    !(sock_net(sk)->ipv4.sysctl_tcp_ecn & TCP_ACCECN_NO_OPT)) {
 		opts->ecn_bytes = tp->received_ecn_bytes;
 		size += tcp_options_fit_accecn(opts, tp->accecn_minlen,
-- 
2.20.1

