Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12082189873
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 10:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbgCRJro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 05:47:44 -0400
Received: from smtp-rs2-vallila1.fe.helsinki.fi ([128.214.173.73]:53282 "EHLO
        smtp-rs2-vallila1.fe.helsinki.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727739AbgCRJrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 05:47:43 -0400
Received: from whs-18.cs.helsinki.fi (whs-18.cs.helsinki.fi [128.214.166.46])
        by smtp-rs2.it.helsinki.fi (8.14.7/8.14.7) with ESMTP id 02I9cEj9006458;
        Wed, 18 Mar 2020 11:38:14 +0200
Received: by whs-18.cs.helsinki.fi (Postfix, from userid 1070048)
        id 617B7360F52; Wed, 18 Mar 2020 11:38:14 +0200 (EET)
From:   =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
To:     netdev@vger.kernel.org
Cc:     Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Subject: [RFC PATCH 14/28] tcp: AccECN negotiation
Date:   Wed, 18 Mar 2020 11:37:55 +0200
Message-Id: <1584524289-24187-14-git-send-email-ilpo.jarvinen@helsinki.fi>
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

Signed-off-by: Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
---
 include/linux/tcp.h      |   6 ++
 include/net/tcp.h        |  40 ++++++++++++-
 net/ipv4/syncookies.c    |  12 ++++
 net/ipv4/tcp.c           |   1 +
 net/ipv4/tcp_input.c     | 126 +++++++++++++++++++++++++++++++++++----
 net/ipv4/tcp_ipv4.c      |   3 +-
 net/ipv4/tcp_minisocks.c |  51 ++++++++++++++--
 net/ipv4/tcp_output.c    |  68 ++++++++++++++++-----
 net/ipv6/syncookies.c    |   1 +
 net/ipv6/tcp_ipv6.c      |   1 +
 10 files changed, 272 insertions(+), 37 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 9bdf67dd0d1d..a6b1d150cb05 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -149,6 +149,9 @@ struct tcp_request_sock {
 	u64				snt_synack; /* first SYNACK sent time */
 	bool				tfo_listener;
 	bool				is_mptcp;
+	u8				accecn_ok  : 1,
+					syn_ect_snt: 2,
+					syn_ect_rcv: 2;
 	u32				txhash;
 	u32				rcv_isn;
 	u32				snt_isn;
@@ -246,6 +249,9 @@ struct tcp_sock {
 	} rack;
 	u16	advmss;		/* Advertised MSS			*/
 	u8	compressed_ack;
+	u8	syn_ect_snt:2,	/* AccECN ECT memory, only */
+		syn_ect_rcv:2,	/* ... needed durign 3WHS + first seqno */
+		ecn_fail:1;	/* ECN reflector detected path mangling */
 	u32	chrono_start;	/* Start time in jiffies of a TCP chrono */
 	u32	chrono_stat[3];	/* Time in jiffies for chrono_stat stats */
 	u8	chrono_type:2,	/* current chronograph type */
diff --git a/include/net/tcp.h b/include/net/tcp.h
index ddeb11c01faa..e1dd06bbb472 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -409,11 +409,28 @@ static inline u8 tcp_accecn_ace(const struct tcphdr *th)
 	return (th->ae << 2) | (th->cwr << 1) | th->ece;
 }
 
+/* Infer the ECT value our SYN arrived with from the echoed ACE field */
+static inline int tcp_accecn_extract_syn_ect(u8 ace)
+{
+	if (ace & 0x1)
+		return INET_ECN_ECT_1;
+	if (!(ace & 0x2))
+		return INET_ECN_ECT_0;
+	if (ace & 0x4)
+		return INET_ECN_CE;
+	return INET_ECN_NOT_ECT;
+}
+
 static inline u32 tcp_accecn_ace_deficit(const struct tcp_sock *tp)
 {
 	return tp->received_ce - tp->received_ce_tx;
 }
 
+bool tcp_accecn_validate_syn_feedback(struct sock *sk, u8 ace, u8 sent_ect);
+void tcp_accecn_third_ack(struct sock *sk, const struct sk_buff *skb,
+			  u8 syn_ect_snt);
+void tcp_ecn_received_counters(struct sock *sk, const struct sk_buff *skb);
+
 enum tcp_tw_status {
 	TCP_TW_SUCCESS = 0,
 	TCP_TW_RST = 1,
@@ -604,6 +621,7 @@ bool cookie_timestamp_decode(const struct net *net,
 			     struct tcp_options_received *opt);
 bool cookie_ecn_ok(const struct tcp_options_received *opt,
 		   const struct net *net, const struct dst_entry *dst);
+bool cookie_accecn_ok(const struct tcphdr *th);
 
 /* From net/ipv6/syncookies.c */
 int __cookie_v6_check(const struct ipv6hdr *iph, const struct tcphdr *th,
@@ -842,6 +860,7 @@ static inline u64 tcp_skb_timestamp_us(const struct sk_buff *skb)
 
 #define TCPHDR_ACE (TCPHDR_ECE | TCPHDR_CWR | TCPHDR_AE)
 #define TCPHDR_SYN_ECN	(TCPHDR_SYN | TCPHDR_ECE | TCPHDR_CWR)
+#define TCPHDR_SYNACK_ACCECN (TCPHDR_SYN | TCPHDR_ACK | TCPHDR_CWR)
 
 #define TCP_ACCECN_CEP_ACE_MASK 0x7
 #define TCP_ACCECN_ACE_MAX_DELTA 6
@@ -926,6 +945,15 @@ struct tcp_skb_cb {
 
 #define TCP_SKB_CB(__skb)	((struct tcp_skb_cb *)&((__skb)->cb[0]))
 
+static inline u16 tcp_accecn_reflector_flags(u8 ect)
+{
+	u32 flags = ect + 2;
+
+	if (ect == 3)
+		flags++;
+	return flags * TCPHDR_ECE;
+}
+
 static inline void bpf_compute_data_end_sk_skb(struct sk_buff *skb)
 {
 	TCP_SKB_CB(skb)->bpf.data_end = skb->data + skb_headlen(skb);
@@ -1059,7 +1087,10 @@ enum tcp_ca_ack_event_flags {
 #define TCP_CONG_NON_RESTRICTED 0x1
 /* Requires ECN/ECT set on all packets */
 #define TCP_CONG_NEEDS_ECN	0x2
-#define TCP_CONG_MASK	(TCP_CONG_NON_RESTRICTED | TCP_CONG_NEEDS_ECN)
+/* Require successfully negotiated AccECN capability */
+#define TCP_CONG_NEEDS_ACCECN	0x4
+#define TCP_CONG_MASK	(TCP_CONG_NON_RESTRICTED | TCP_CONG_NEEDS_ECN | \
+			 TCP_CONG_NEEDS_ACCECN)
 
 union tcp_cc_info;
 
@@ -1173,6 +1204,13 @@ static inline bool tcp_ca_needs_ecn(const struct sock *sk)
 	return icsk->icsk_ca_ops->flags & TCP_CONG_NEEDS_ECN;
 }
 
+static inline bool tcp_ca_needs_accecn(const struct sock *sk)
+{
+	const struct inet_connection_sock *icsk = inet_csk(sk);
+
+	return icsk->icsk_ca_ops->flags & TCP_CONG_NEEDS_ACCECN;
+}
+
 static inline void tcp_set_ca_state(struct sock *sk, const u8 ca_state)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 9a4f6b16c9bc..1d1ded175042 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -276,6 +276,17 @@ bool cookie_ecn_ok(const struct tcp_options_received *tcp_opt,
 }
 EXPORT_SYMBOL(cookie_ecn_ok);
 
+/* §4.1 [...] a server can determine that it negotiated AccECN as
+ * [...] if the ACK contains an ACE field with the value 0b010 to
+ * 0b111 (decimal 2 to 7).
+ */
+/* We don't need to check for > 7 as ACE is on 3 bits */
+bool cookie_accecn_ok(const struct tcphdr *th)
+{
+	return tcp_accecn_ace(th) > 0x1;
+}
+EXPORT_SYMBOL(cookie_accecn_ok);
+
 /* On input, sk is a listener.
  * Output is listener if incoming packet would not create a child
  *           NULL if memory could not be allocated.
@@ -398,6 +409,7 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 
 	ireq->rcv_wscale  = rcv_wscale;
 	ireq->ecn_ok = cookie_ecn_ok(&tcp_opt, sock_net(sk), &rt->dst);
+	treq->accecn_ok = ireq->ecn_ok && cookie_accecn_ok(th);
 
 	ret = tcp_get_cookie_sock(sk, skb, req, &rt->dst, tsoff);
 	/* ip_queue_xmit() depends on our flow being setup
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index edc03a1bf704..624dff543301 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2624,6 +2624,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	tp->window_clamp = 0;
 	tp->delivered = 0;
 	tp->delivered_ce = 0;
+	tp->ecn_fail = 0;
 	tcp_accecn_init_counters(tp);
 	tcp_set_ca_state(sk, TCP_CA_Open);
 	tp->is_sack_reneg = 0;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index dbe70a114b1d..bf307be4c659 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -308,14 +308,89 @@ static void tcp_data_ecn_check(struct sock *sk, const struct sk_buff *skb)
 	}
 }
 
-static void tcp_ecn_rcv_synack(struct tcp_sock *tp, const struct tcphdr *th)
+/* §3.1.2 If a TCP server that implements AccECN receives a SYN with the three
+ * TCP header flags (AE, CWR and ECE) set to any combination other than 000,
+ * 011 or 111, it MUST negotiate the use of AccECN as if they had been set to
+ * 111.
+ */
+static inline bool tcp_accecn_syn_requested(const struct tcphdr *th)
+{
+	u8 ace = tcp_accecn_ace(th);
+
+	return ace && ace != 0x3;
+}
+
+/* Check ECN field transition to detect invalid transitions */
+static bool tcp_ect_transition_valid(u8 snt, u8 rcv)
+{
+	if (rcv == snt)
+		return true;
+
+	/* Non-ECT altered to something or something became non-ECT */
+	if ((snt == INET_ECN_NOT_ECT) || (rcv == INET_ECN_NOT_ECT))
+		return false;
+	/* CE -> ECT(0/1)? */
+	if (snt == INET_ECN_CE)
+		return false;
+	return true;
+}
+
+bool tcp_accecn_validate_syn_feedback(struct sock *sk, u8 ace, u8 sent_ect)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	u8 ect = tcp_accecn_extract_syn_ect(ace);
+
+	if (!sock_net(sk)->ipv4.sysctl_tcp_ecn_fallback)
+		return true;
+
+	if (!tcp_ect_transition_valid(sent_ect, ect)) {
+		tp->ecn_fail = 1;
+		return false;
+	}
+
+	return true;
+}
+
+/* See Table 2 of the AccECN draft */
+static void tcp_ecn_rcv_synack(struct sock *sk, const struct tcphdr *th,
+			       u8 ip_dsfield)
 {
-	if (tcp_ecn_mode_rfc3168(tp) && (!th->ece || th->cwr))
+	struct tcp_sock *tp = tcp_sk(sk);
+	u8 ace = tcp_accecn_ace(th);
+
+	switch (ace) {
+	case 0x0:
+	case 0x7:
 		tcp_ecn_mode_set(tp, TCP_ECN_DISABLED);
+		break;
+	case 0x1:
+	case 0x5:
+		if (tcp_ecn_mode_pending(tp))
+			/* Downgrade from AccECN, or requested initially */
+			tcp_ecn_mode_set(tp, TCP_ECN_MODE_RFC3168);
+		break;
+	default:
+		tcp_ecn_mode_set(tp, TCP_ECN_MODE_ACCECN);
+		tp->syn_ect_rcv = ip_dsfield & INET_ECN_MASK;
+		if (tcp_accecn_validate_syn_feedback(sk, ace, tp->syn_ect_snt) &&
+		    INET_ECN_is_ce(ip_dsfield))
+			tp->received_ce++;
+		break;
+	}
 }
 
-static void tcp_ecn_rcv_syn(struct tcp_sock *tp, const struct tcphdr *th)
+static void tcp_ecn_rcv_syn(struct tcp_sock *tp, const struct tcphdr *th,
+			    const struct sk_buff *skb)
 {
+	if (tcp_ecn_mode_pending(tp)) {
+		if (!tcp_accecn_syn_requested(th)) {
+			/* Downgrade to classic ECN feedback */
+			tcp_ecn_mode_set(tp, TCP_ECN_MODE_RFC3168);
+		} else {
+			tp->syn_ect_rcv = TCP_SKB_CB(skb)->ip_dsfield & INET_ECN_MASK;
+			tcp_ecn_mode_set(tp, TCP_ECN_MODE_ACCECN);
+		}
+	}
 	if (tcp_ecn_mode_rfc3168(tp) && (!th->ece || !th->cwr))
 		tcp_ecn_mode_set(tp, TCP_ECN_DISABLED);
 }
@@ -3484,7 +3559,8 @@ bool tcp_oow_rate_limited(struct net *net, const struct sk_buff *skb,
 }
 
 /* RFC 5961 7 [ACK Throttling] */
-static void tcp_send_challenge_ack(struct sock *sk, const struct sk_buff *skb)
+static void tcp_send_challenge_ack(struct sock *sk, const struct sk_buff *skb,
+				   bool accecn_reflector)
 {
 	/* unprotected vars, we dont care of overwrites */
 	static u32 challenge_timestamp;
@@ -3512,7 +3588,8 @@ static void tcp_send_challenge_ack(struct sock *sk, const struct sk_buff *skb)
 	if (count > 0) {
 		WRITE_ONCE(challenge_count, count - 1);
 		NET_INC_STATS(net, LINUX_MIB_TCPCHALLENGEACK);
-		tcp_send_ack(sk, 0);
+		tcp_send_ack(sk, !accecn_reflector ? 0 :
+				 tcp_accecn_reflector_flags(tp->syn_ect_rcv));
 	}
 }
 
@@ -3678,7 +3755,7 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 		/* RFC 5961 5.2 [Blind Data Injection Attack].[Mitigation] */
 		if (before(ack, prior_snd_una - tp->max_window)) {
 			if (!(flag & FLAG_NO_CHALLENGE_ACK))
-				tcp_send_challenge_ack(sk, skb);
+				tcp_send_challenge_ack(sk, skb, false);
 			return -1;
 		}
 		goto old_ack;
@@ -5482,7 +5559,7 @@ static void tcp_urg(struct sock *sk, struct sk_buff *skb, const struct tcphdr *t
 }
 
 /* Updates Accurate ECN received counters from the received IP ECN field */
-static void tcp_ecn_received_counters(struct sock *sk, const struct sk_buff *skb)
+void tcp_ecn_received_counters(struct sock *sk, const struct sk_buff *skb)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	u8 ecnfield = TCP_SKB_CB(skb)->ip_dsfield & INET_ECN_MASK;
@@ -5521,6 +5598,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	bool rst_seq_match = false;
+	bool send_accecn_reflector = false;
 
 	/* RFC1323: H1. Apply PAWS check first. */
 	if (tcp_fast_parse_options(sock_net(sk), skb, th, tp) &&
@@ -5598,7 +5676,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 			if (tp->syn_fastopen && !tp->data_segs_in &&
 			    sk->sk_state == TCP_ESTABLISHED)
 				tcp_fastopen_active_disable(sk);
-			tcp_send_challenge_ack(sk, skb);
+			tcp_send_challenge_ack(sk, skb, false);
 		}
 		goto discard;
 	}
@@ -5609,11 +5687,14 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 	 * RFC 5961 4.2 : Send a challenge ack
 	 */
 	if (th->syn) {
+		if (tcp_ecn_mode_accecn(tp)) {
+			send_accecn_reflector = true;
+		}
 syn_challenge:
 		if (syn_inerr)
 			TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNCHALLENGE);
-		tcp_send_challenge_ack(sk, skb);
+		tcp_send_challenge_ack(sk, skb, send_accecn_reflector);
 		goto discard;
 	}
 
@@ -6049,7 +6130,8 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 		 *    state to ESTABLISHED..."
 		 */
 
-		tcp_ecn_rcv_synack(tp, th);
+		if (tcp_ecn_mode_any(tp))
+			tcp_ecn_rcv_synack(sk, th, TCP_SKB_CB(skb)->ip_dsfield);
 
 		tcp_init_wl(tp, TCP_SKB_CB(skb)->seq);
 		tcp_try_undo_spurious_syn(sk);
@@ -6126,7 +6208,8 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 			tcp_drop(sk, skb);
 			return 0;
 		} else {
-			tcp_send_ack(sk, 0);
+			tcp_send_ack(sk, !tcp_ecn_mode_accecn(tp) ? 0 :
+					 tcp_accecn_reflector_flags(tp->syn_ect_rcv));
 		}
 		return -1;
 	}
@@ -6175,7 +6258,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 		tp->snd_wl1    = TCP_SKB_CB(skb)->seq;
 		tp->max_window = tp->snd_wnd;
 
-		tcp_ecn_rcv_syn(tp, th);
+		tcp_ecn_rcv_syn(tp, th, skb);
 
 		tcp_mtup_init(sk);
 		tcp_sync_mss(sk, icsk->icsk_pmtu_cookie);
@@ -6334,7 +6417,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 	if (!acceptable) {
 		if (sk->sk_state == TCP_SYN_RECV)
 			return 1;	/* send one RST */
-		tcp_send_challenge_ack(sk, skb);
+		tcp_send_challenge_ack(sk, skb, false);
 		goto discard;
 	}
 	switch (sk->sk_state) {
@@ -6376,6 +6459,8 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		tp->lsndtime = tcp_jiffies32;
 
 		tcp_initialize_rcv_mss(sk);
+		if (tcp_ecn_mode_accecn(tp))
+			tcp_accecn_third_ack(sk, skb, tp->syn_ect_snt);
 		tcp_fast_path_on(tp);
 		break;
 
@@ -6539,6 +6624,18 @@ static void tcp_ecn_create_request(struct request_sock *req,
 	bool ect, ecn_ok;
 	u32 ecn_ok_dst;
 
+	if (tcp_accecn_syn_requested(th) &&
+	    (net->ipv4.sysctl_tcp_ecn || tcp_ca_needs_accecn(listen_sk))) {
+		inet_rsk(req)->ecn_ok = 1;
+		if ((net->ipv4.sysctl_tcp_ecn >= 2) ||
+		    tcp_ca_needs_accecn(listen_sk)) {
+			tcp_rsk(req)->accecn_ok = 1;
+			tcp_rsk(req)->syn_ect_rcv =
+				TCP_SKB_CB(skb)->ip_dsfield & INET_ECN_MASK;
+		}
+		return;
+	}
+
 	if (!th_ecn)
 		return;
 
@@ -6565,6 +6662,9 @@ static void tcp_openreq_init(struct request_sock *req,
 	tcp_rsk(req)->rcv_nxt = TCP_SKB_CB(skb)->seq + 1;
 	tcp_rsk(req)->snt_synack = 0;
 	tcp_rsk(req)->last_oow_ack_time = 0;
+	tcp_rsk(req)->accecn_ok = 0;
+	tcp_rsk(req)->syn_ect_rcv = 0;
+	tcp_rsk(req)->syn_ect_snt = 0;
 	req->mss = rx_opt->mss_clamp;
 	req->ts_recent = rx_opt->saw_tstamp ? rx_opt->rcv_tsval : 0;
 	ireq->tstamp_ok = rx_opt->tstamp_ok;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index dab0c1b85e95..d3b3e4d011b1 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -958,7 +958,7 @@ static int tcp_v4_send_synack(const struct sock *sk, struct dst_entry *dst,
 			      struct tcp_fastopen_cookie *foc,
 			      enum tcp_synack_type synack_type)
 {
-	const struct inet_request_sock *ireq = inet_rsk(req);
+	struct inet_request_sock *ireq = inet_rsk(req);
 	struct flowi4 fl4;
 	int err = -1;
 	struct sk_buff *skb;
@@ -970,6 +970,7 @@ static int tcp_v4_send_synack(const struct sock *sk, struct dst_entry *dst,
 	skb = tcp_make_synack(sk, dst, req, foc, synack_type);
 
 	if (skb) {
+		tcp_rsk(req)->syn_ect_snt = inet_sk(sk)->tos & INET_ECN_MASK;
 		__tcp_v4_send_check(skb, ireq->ir_loc_addr, ireq->ir_rmt_addr);
 
 		rcu_read_lock();
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 3b5a137e416c..57b7cf4658fc 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -397,12 +397,51 @@ void tcp_openreq_init_rwin(struct request_sock *req,
 }
 EXPORT_SYMBOL(tcp_openreq_init_rwin);
 
-static void tcp_ecn_openreq_child(struct tcp_sock *tp,
-				  const struct request_sock *req)
+void tcp_accecn_third_ack(struct sock *sk, const struct sk_buff *skb,
+			  u8 syn_ect_snt)
 {
-	tcp_ecn_mode_set(tp, inet_rsk(req)->ecn_ok ?
-			     TCP_ECN_MODE_RFC3168 :
-			     TCP_ECN_DISABLED);
+	struct tcp_sock *tp = tcp_sk(sk);
+	u8 ace = tcp_accecn_ace(tcp_hdr(skb));
+
+	switch (ace) {
+	case 0x0:
+		tp->ecn_fail = 1;
+		break;
+	case 0x7:
+	case 0x5:
+	case 0x1:
+		/* Unused but legal values */
+		break;
+	default:
+		/* Validation only applies to first non-data packet */
+		if (TCP_SKB_CB(skb)->seq == TCP_SKB_CB(skb)->end_seq &&
+		    !TCP_SKB_CB(skb)->sacked &&
+		    tcp_accecn_validate_syn_feedback(sk, ace, syn_ect_snt)) {
+			if ((tcp_accecn_extract_syn_ect(ace) == INET_ECN_CE) &&
+			    !tp->delivered_ce)
+				tp->delivered_ce++;
+		}
+		break;
+	}
+}
+
+static void tcp_ecn_openreq_child(struct sock *sk,
+				  const struct request_sock *req,
+				  const struct sk_buff *skb)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	const struct tcp_request_sock *treq = tcp_rsk(req);
+
+	if (treq->accecn_ok) {
+		tcp_ecn_mode_set(tp, TCP_ECN_MODE_ACCECN);
+		tp->syn_ect_snt = treq->syn_ect_snt;
+		tcp_accecn_third_ack(sk, skb, treq->syn_ect_snt);
+		tcp_ecn_received_counters(sk, skb);
+	} else {
+		tcp_ecn_mode_set(tp, inet_rsk(req)->ecn_ok ?
+				     TCP_ECN_MODE_RFC3168 :
+				     TCP_ECN_DISABLED);
+	}
 }
 
 void tcp_ca_openreq_child(struct sock *sk, const struct dst_entry *dst)
@@ -546,7 +585,7 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
 	if (skb->len >= TCP_MSS_DEFAULT + newtp->tcp_header_len)
 		newicsk->icsk_ack.last_seg_size = skb->len - newtp->tcp_header_len;
 	newtp->rx_opt.mss_clamp = req->mss;
-	tcp_ecn_openreq_child(newtp, req);
+	tcp_ecn_openreq_child(newsk, req, skb);
 	newtp->fastopen_req = NULL;
 	RCU_INIT_POINTER(newtp->fastopen_rsk, NULL);
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index c8d0a7baf2d4..adc22d0d75fd 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -308,7 +308,7 @@ static u16 tcp_select_window(struct sock *sk)
 /* Packet ECN state for a SYN-ACK */
 static void tcp_ecn_send_synack(struct sock *sk, struct sk_buff *skb)
 {
-	const struct tcp_sock *tp = tcp_sk(sk);
+	struct tcp_sock *tp = tcp_sk(sk);
 
 	TCP_SKB_CB(skb)->tcp_flags &= ~TCPHDR_CWR;
 	if (tcp_ecn_disabled(tp))
@@ -316,6 +316,13 @@ static void tcp_ecn_send_synack(struct sock *sk, struct sk_buff *skb)
 	else if (tcp_ca_needs_ecn(sk) ||
 		 tcp_bpf_ca_needs_ecn(sk))
 		INET_ECN_xmit(sk);
+
+	if (tp->ecn_flags & TCP_ECN_MODE_ACCECN) {
+		TCP_SKB_CB(skb)->tcp_flags &= ~TCPHDR_ACE;
+		TCP_SKB_CB(skb)->tcp_flags |=
+			tcp_accecn_reflector_flags(tp->syn_ect_rcv);
+		tp->syn_ect_snt = inet_sk(sk)->tos & INET_ECN_MASK;
+	}
 }
 
 /* Packet ECN state for a SYN.  */
@@ -323,8 +330,10 @@ static void tcp_ecn_send_syn(struct sock *sk, struct sk_buff *skb)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	bool bpf_needs_ecn = tcp_bpf_ca_needs_ecn(sk);
+	bool use_accecn = sock_net(sk)->ipv4.sysctl_tcp_ecn == 3 ||
+		tcp_ca_needs_accecn(sk);
 	bool use_ecn = sock_net(sk)->ipv4.sysctl_tcp_ecn == 1 ||
-		tcp_ca_needs_ecn(sk) || bpf_needs_ecn;
+		tcp_ca_needs_ecn(sk) || bpf_needs_ecn || use_accecn;
 
 	if (!use_ecn) {
 		const struct dst_entry *dst = __sk_dst_get(sk);
@@ -340,36 +349,59 @@ static void tcp_ecn_send_syn(struct sock *sk, struct sk_buff *skb)
 			INET_ECN_xmit(sk);
 
 		TCP_SKB_CB(skb)->tcp_flags |= TCPHDR_ECE | TCPHDR_CWR;
-		tcp_ecn_mode_set(tp, TCP_ECN_MODE_RFC3168);
+		if (use_accecn) {
+			TCP_SKB_CB(skb)->tcp_flags |= TCPHDR_AE;
+			tcp_ecn_mode_set(tp, TCP_ECN_MODE_PENDING);
+			tp->syn_ect_snt = inet_sk(sk)->tos & INET_ECN_MASK;
+		} else {
+			tcp_ecn_mode_set(tp, TCP_ECN_MODE_RFC3168);
+		}
 	}
 }
 
 static void tcp_ecn_clear_syn(struct sock *sk, struct sk_buff *skb)
 {
-	if (sock_net(sk)->ipv4.sysctl_tcp_ecn_fallback)
+	if (sock_net(sk)->ipv4.sysctl_tcp_ecn_fallback) {
 		/* tp->ecn_flags are cleared at a later point in time when
 		 * SYN ACK is ultimatively being received.
 		 */
-		TCP_SKB_CB(skb)->tcp_flags &= ~(TCPHDR_ECE | TCPHDR_CWR);
+		TCP_SKB_CB(skb)->tcp_flags &= ~TCPHDR_ACE;
+	}
+}
+
+static void tcp_accecn_echo_syn_ect(struct tcphdr *th, u8 ect)
+{
+	th->ae = !!(ect & 2);
+	th->cwr = ect != INET_ECN_ECT_0;
+	th->ece = ect == INET_ECN_ECT_1;
 }
 
 static void
 tcp_ecn_make_synack(const struct request_sock *req, struct tcphdr *th)
 {
-	if (inet_rsk(req)->ecn_ok)
+	if (tcp_rsk(req)->accecn_ok)
+		tcp_accecn_echo_syn_ect(th, tcp_rsk(req)->syn_ect_rcv);
+	else if (inet_rsk(req)->ecn_ok)
 		th->ece = 1;
 }
 
-static void tcp_accecn_set_ace(struct tcphdr *th, struct tcp_sock *tp)
+static void tcp_accecn_set_ace(struct tcp_sock *tp, struct sk_buff *skb,
+			       struct tcphdr *th)
 {
 	u32 wire_ace;
 
-	tp->received_ce_tx += min_t(u32, tcp_accecn_ace_deficit(tp),
-				    TCP_ACCECN_ACE_MAX_DELTA);
-	wire_ace = tp->received_ce_tx + TCP_ACCECN_CEP_INIT_OFFSET;
-	th->ece = !!(wire_ace & 0x1);
-	th->cwr = !!(wire_ace & 0x2);
-	th->ae = !!(wire_ace & 0x4);
+	/* The final packet of the 3WHS or anything like it must reflect
+	 * the SYN/ACK ECT instead of putting CEP into ACE field, such
+	 * case show up in tcp_flags.
+	 */
+	if (likely(!(TCP_SKB_CB(skb)->tcp_flags & TCPHDR_ACE))) {
+		tp->received_ce_tx += min_t(u32, tcp_accecn_ace_deficit(tp),
+					    TCP_ACCECN_ACE_MAX_DELTA);
+		wire_ace = tp->received_ce_tx + TCP_ACCECN_CEP_INIT_OFFSET;
+		th->ece = !!(wire_ace & 0x1);
+		th->cwr = !!(wire_ace & 0x2);
+		th->ae = !!(wire_ace & 0x4);
+	}
 }
 
 /* Set up ECN state for a packet on a ESTABLISHED socket that is about to
@@ -383,9 +415,10 @@ static void tcp_ecn_send(struct sock *sk, struct sk_buff *skb,
 	if (!tcp_ecn_mode_any(tp))
 		return;
 
-	INET_ECN_xmit(sk);
+	if (!tp->ecn_fail)
+		INET_ECN_xmit(sk);
 	if (tcp_ecn_mode_accecn(tp)) {
-		tcp_accecn_set_ace(th, tp);
+		tcp_accecn_set_ace(tp, skb, th);
 		skb_shinfo(skb)->gso_type |= SKB_GSO_TCP_ACCECN;
 	} else {
 		/* Not-retransmitted data segment: set ECT and inject CWR. */
@@ -3034,7 +3067,10 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
 			tcp_retrans_try_collapse(sk, skb, cur_mss);
 	}
 
-	/* RFC3168, section 6.1.1.1. ECN fallback */
+	/* RFC3168, section 6.1.1.1. ECN fallback
+	 * As AccECN uses the same SYN flags (+ AE), this check covers both
+	 * cases.
+	 */
 	if ((TCP_SKB_CB(skb)->tcp_flags & TCPHDR_SYN_ECN) == TCPHDR_SYN_ECN)
 		tcp_ecn_clear_syn(sk, skb);
 
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index 13235a012388..6e859d8fa489 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -251,6 +251,7 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 
 	ireq->rcv_wscale = rcv_wscale;
 	ireq->ecn_ok = cookie_ecn_ok(&tcp_opt, sock_net(sk), dst);
+	tcp_rsk(req)->accecn_ok = ireq->ecn_ok && cookie_accecn_ok(th);
 
 	ret = tcp_get_cookie_sock(sk, skb, req, dst, tsoff);
 out:
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 73032cd261ea..ecbab28c98cf 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -507,6 +507,7 @@ static int tcp_v6_send_synack(const struct sock *sk, struct dst_entry *dst,
 	skb = tcp_make_synack(sk, dst, req, foc, synack_type);
 
 	if (skb) {
+		tcp_rsk(req)->syn_ect_snt = np->tclass & INET_ECN_MASK;
 		__tcp_v6_send_check(skb, &ireq->ir_v6_loc_addr,
 				    &ireq->ir_v6_rmt_addr);
 
-- 
2.20.1

