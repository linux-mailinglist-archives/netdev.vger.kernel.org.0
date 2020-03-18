Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 929F1189826
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 10:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727667AbgCRJoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 05:44:02 -0400
Received: from smtp-rs2-vallila1.fe.helsinki.fi ([128.214.173.73]:51534 "EHLO
        smtp-rs2-vallila1.fe.helsinki.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727558AbgCRJn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 05:43:58 -0400
Received: from whs-18.cs.helsinki.fi (whs-18.cs.helsinki.fi [128.214.166.46])
        by smtp-rs2.it.helsinki.fi (8.14.7/8.14.7) with ESMTP id 02I9hpI8012893;
        Wed, 18 Mar 2020 11:43:51 +0200
Received: by whs-18.cs.helsinki.fi (Postfix, from userid 1070048)
        id 0F3E8360030; Wed, 18 Mar 2020 11:43:51 +0200 (EET)
From:   =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
To:     netdev@vger.kernel.org
Cc:     Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Subject: [RFC PATCH 19/28] tcp: AccECN option
Date:   Wed, 18 Mar 2020 11:43:23 +0200
Message-Id: <1584524612-24470-20-git-send-email-ilpo.jarvinen@helsinki.fi>
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

AccECN option tx & rx side without option send control
related features that are added in a later change.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
---
 include/linux/tcp.h   |   4 ++
 include/net/tcp.h     |  16 ++++++
 net/ipv4/tcp_input.c  | 126 +++++++++++++++++++++++++++++++++++++++---
 net/ipv4/tcp_output.c | 112 ++++++++++++++++++++++++++++++++++++-
 4 files changed, 246 insertions(+), 12 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 6b81d7eb0117..fd232bb7fae9 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -114,6 +114,7 @@ struct tcp_options_received {
 		snd_wscale : 4,	/* Window scaling received from sender	*/
 		rcv_wscale : 4;	/* Window scaling to send to receiver	*/
 	u8	num_sacks;	/* Number of SACK blocks		*/
+	s8	accecn;		/* AccECN index in header, -1=no option	*/
 	u16	user_mss;	/* mss requested by user in ioctl	*/
 	u16	mss_clamp;	/* Maximal mss, negotiated at connection setup */
 #if IS_ENABLED(CONFIG_MPTCP)
@@ -321,9 +322,12 @@ struct tcp_sock {
 	u32	prr_out;	/* Total number of pkts sent during Recovery. */
 	u32	delivered;	/* Total data packets delivered incl. rexmits */
 	u32	delivered_ce;	/* Like the above but only ECE marked packets */
+	u32	delivered_ecn_bytes[3];
 	u32	received_ce;	/* Like the above but for received CE marked packets */
 	u32	received_ce_tx; /* Like the above but max transmitted value */
 	u32	received_ecn_bytes[3];
+	u8	accecn_minlen:2,/* Minimum length of AccECN option sent */
+		estimate_ecnfield:2;/* ECN field for AccECN delivered estimates */
 	u32	lost;		/* Total data packets lost incl. rexmits */
 	u32	app_limited;	/* limited until "delivered" reaches this val */
 	u64	first_tx_mstamp;  /* start of window send phase */
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 5824447b1fc5..54471c2dedd5 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -189,6 +189,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo);
 /* Magic number to be after the option value for sharing TCP
  * experimental options. See draft-ietf-tcpm-experimental-options-00.txt
  */
+#define TCPOPT_ACCECN_MAGIC	0xACCE
 #define TCPOPT_FASTOPEN_MAGIC	0xF989
 #define TCPOPT_SMC_MAGIC	0xE2D4C3D9
 
@@ -204,6 +205,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo);
 #define TCPOLEN_FASTOPEN_BASE  2
 #define TCPOLEN_EXP_FASTOPEN_BASE  4
 #define TCPOLEN_EXP_SMC_BASE   6
+#define TCPOLEN_EXP_ACCECN_BASE 4
 
 /* But this is what stacks really send out. */
 #define TCPOLEN_TSTAMP_ALIGNED		12
@@ -215,6 +217,13 @@ void tcp_time_wait(struct sock *sk, int state, int timeo);
 #define TCPOLEN_MD5SIG_ALIGNED		20
 #define TCPOLEN_MSS_ALIGNED		4
 #define TCPOLEN_EXP_SMC_BASE_ALIGNED	8
+#define TCPOLEN_ACCECN_PERCOUNTER	3
+
+/* Maximum number of byte counters in AccECN option + size */
+#define TCP_ACCECN_NUMCOUNTERS		3
+#define TCP_ACCECN_MAXSIZE		(TCPOLEN_EXP_ACCECN_BASE + \
+					 TCPOLEN_ACCECN_PERCOUNTER * \
+					 TCP_ACCECN_NUMCOUNTERS)
 
 /* Flags in tp->nonagle */
 #define TCP_NAGLE_OFF		1	/* Nagle's algo is disabled */
@@ -363,6 +372,10 @@ static inline void tcp_dec_quickack_mode(struct sock *sk,
 	}
 }
 
+/* sysctl_tcp_ecn value */
+#define TCP_ECN_ENABLE_MASK	0x3
+#define TCP_ACCECN_NO_OPT	0x100
+
 #define	TCP_ECN_MODE_RFC3168	0x1
 #define	TCP_ECN_QUEUE_CWR	0x2
 #define	TCP_ECN_DEMAND_CWR	0x4
@@ -890,6 +903,9 @@ static inline void tcp_accecn_init_counters(struct tcp_sock *tp)
 	tp->received_ce = 0;
 	tp->received_ce_tx = 0;
 	__tcp_accecn_init_bytes_counters(tp->received_ecn_bytes);
+	__tcp_accecn_init_bytes_counters(tp->delivered_ecn_bytes);
+	tp->accecn_minlen = 0;
+	tp->estimate_ecnfield = 0;
 }
 
 /* This is what the send packet queuing engine uses to pass
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 0a63f8a49057..d34b50f73652 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -402,9 +402,92 @@ static u32 tcp_ecn_rcv_ecn_echo(const struct tcp_sock *tp, const struct tcphdr *
 	return 0;
 }
 
+/* Handles AccECN option ECT and CE 24-bit byte counters update into
+ * the u32 value in tcp_sock. As we're processing TCP options, it is
+ * safe to access from - 1.
+ */
+static s32 tcp_update_ecn_bytes(u32 *cnt, const char *from, u32 init_offset)
+{
+	u32 truncated = (get_unaligned_be32(from - 1) - init_offset) & 0xFFFFFFU;
+	u32 delta = (truncated - *cnt) & 0xFFFFFFU;
+	/* If delta has the highest bit set (24th bit) indicating negative,
+	 * sign extend to correct an estimation error in the ecn_bytes
+	 */
+	delta = delta & 0x800000 ? delta | 0xFF000000 : delta;
+	*cnt += delta;
+	return (s32)delta;
+}
+
+static u8 accecn_opt_ecnfield[3] = {
+	INET_ECN_ECT_0, INET_ECN_CE, INET_ECN_ECT_1,
+};
+
+/* Returns true if the byte counters can be used */
+static bool tcp_accecn_process_option(struct tcp_sock *tp,
+				      const struct sk_buff *skb,
+				      u32 delivered_bytes)
+{
+	unsigned char *ptr;
+	unsigned int optlen;
+	int i;
+	bool ambiguous_ecn_bytes_incr = false;
+	bool first_changed = false;
+	bool res;
+
+	if (tp->rx_opt.accecn < 0) {
+		if (tp->estimate_ecnfield) {
+			tp->delivered_ecn_bytes[tp->estimate_ecnfield - 1] +=
+				delivered_bytes;
+			return true;
+		}
+		return false;
+	}
+
+	ptr = skb_transport_header(skb) + tp->rx_opt.accecn;
+	optlen = ptr[1];
+	if (ptr[0] == TCPOPT_EXP) {
+		optlen -= 2;
+		ptr += 2;
+	}
+	ptr += 2;
+
+	res = !!tp->estimate_ecnfield;
+	for (i = 0; i < 3; i++) {
+		if (optlen >= TCPOLEN_ACCECN_PERCOUNTER) {
+			u8 ecnfield = accecn_opt_ecnfield[i];
+			u32 init_offset = i ? 0 : TCP_ACCECN_E0B_INIT_OFFSET;
+			s32 delta;
+
+			delta = tcp_update_ecn_bytes(&(tp->delivered_ecn_bytes[ecnfield - 1]),
+						     ptr, init_offset);
+			if (delta) {
+				if (delta < 0) {
+					res = false;
+					ambiguous_ecn_bytes_incr = true;
+				}
+				if (ecnfield != tp->estimate_ecnfield) {
+					if (!first_changed) {
+						tp->estimate_ecnfield = ecnfield;
+						first_changed = true;
+					} else {
+						res = false;
+						ambiguous_ecn_bytes_incr = true;
+					}
+				}
+			}
+
+			optlen -= TCPOLEN_ACCECN_PERCOUNTER;
+		}
+	}
+	if (ambiguous_ecn_bytes_incr)
+		tp->estimate_ecnfield = 0;
+
+	return res;
+}
+
 /* Returns the ECN CE delta */
 static u32 tcp_accecn_process(struct tcp_sock *tp, const struct sk_buff *skb,
-			      u32 delivered_pkts, int flag)
+			      u32 delivered_pkts, u32 delivered_bytes, int flag)
 {
 	u32 delta, safe_delta;
 	u32 corrected_ace;
@@ -413,6 +496,8 @@ static u32 tcp_accecn_process(struct tcp_sock *tp, const struct sk_buff *skb,
 	if (!(flag & (FLAG_FORWARD_PROGRESS|FLAG_TS_PROGRESS)))
 		return 0;
 
+	tcp_accecn_process_option(tp, skb, delivered_bytes);
+
 	if (!(flag & FLAG_SLOWPATH)) {
 		/* AccECN counter might overflow on large ACKs */
 		if (delivered_pkts <= TCP_ACCECN_CEP_ACE_MASK)
@@ -3839,7 +3924,8 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 
 	if (tcp_ecn_mode_accecn(tp)) {
 		ecn_count = tcp_accecn_process(tp, skb,
-					       tp->delivered - delivered, flag);
+					       tp->delivered - delivered,
+					       sack_state.delivered_bytes, flag);
 		if (ecn_count > 0)
 			flag |= FLAG_ECE;
 	}
@@ -3878,7 +3964,8 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 no_queue:
 	if (tcp_ecn_mode_accecn(tp)) {
 		ecn_count = tcp_accecn_process(tp, skb,
-					       tp->delivered - delivered, flag);
+					       tp->delivered - delivered,
+					       sack_state.delivered_bytes, flag);
 		if (ecn_count > 0)
 			flag |= FLAG_ECE;
 	}
@@ -4005,6 +4092,7 @@ void tcp_parse_options(const struct net *net,
 
 	ptr = (const unsigned char *)(th + 1);
 	opt_rx->saw_tstamp = 0;
+	opt_rx->accecn = -1;
 
 	while (length > 0) {
 		int opcode = *ptr++;
@@ -4094,12 +4182,16 @@ void tcp_parse_options(const struct net *net,
 				break;
 
 			case TCPOPT_EXP:
+				if (opsize >= TCPOLEN_EXP_ACCECN_BASE &&
+				    get_unaligned_be16(ptr) ==
+				    TCPOPT_ACCECN_MAGIC)
+					opt_rx->accecn = (ptr - 2) - (unsigned char *)th;
 				/* Fast Open option shares code 254 using a
 				 * 16 bits magic number.
 				 */
-				if (opsize >= TCPOLEN_EXP_FASTOPEN_BASE &&
-				    get_unaligned_be16(ptr) ==
-				    TCPOPT_FASTOPEN_MAGIC)
+				else if (opsize >= TCPOLEN_EXP_FASTOPEN_BASE &&
+					 get_unaligned_be16(ptr) ==
+					 TCPOPT_FASTOPEN_MAGIC)
 					tcp_parse_fastopen_option(opsize -
 						TCPOLEN_EXP_FASTOPEN_BASE,
 						ptr + 2, th->syn, foc, true);
@@ -5567,6 +5659,19 @@ static void tcp_urg(struct sock *sk, struct sk_buff *skb, const struct tcphdr *t
 	}
 }
 
+/* Maps ECT/CE bits to minimum length of AccECN option */
+static inline unsigned int tcp_ecn_field_to_accecn_len(u8 ecnfield)
+{
+	unsigned int opt;
+
+	opt = (ecnfield - 2) & INET_ECN_MASK;
+	/* Shift+XOR for 11 -> 10 */
+	opt = (opt ^ (opt >> 1)) + 1;
+
+	return opt;
+}
+
+
 /* Updates Accurate ECN received counters from the received IP ECN field */
 void tcp_ecn_received_counters(struct sock *sk, const struct sk_buff *skb,
 			       u32 payload_len)
@@ -5582,7 +5687,9 @@ void tcp_ecn_received_counters(struct sock *sk, const struct sk_buff *skb,
 		tp->received_ce += is_ce * max_t(u16, 1, skb_shinfo(skb)->gso_segs);
 
 		if (payload_len > 0) {
+			u8 minlen = tcp_ecn_field_to_accecn_len(ecnfield);
 			tp->received_ecn_bytes[ecnfield - 1] += payload_len;
+			tp->accecn_minlen = max_t(u8, tp->accecn_minlen, minlen);
 		}
 	}
 }
@@ -6639,9 +6746,10 @@ static void tcp_ecn_create_request(struct request_sock *req,
 	u32 ecn_ok_dst;
 
 	if (tcp_accecn_syn_requested(th) &&
-	    (net->ipv4.sysctl_tcp_ecn || tcp_ca_needs_accecn(listen_sk))) {
+	    ((net->ipv4.sysctl_tcp_ecn & TCP_ECN_ENABLE_MASK) ||
+	     tcp_ca_needs_accecn(listen_sk))) {
 		inet_rsk(req)->ecn_ok = 1;
-		if ((net->ipv4.sysctl_tcp_ecn >= 2) ||
+		if (((net->ipv4.sysctl_tcp_ecn & TCP_ECN_ENABLE_MASK) >= 2) ||
 		    tcp_ca_needs_accecn(listen_sk)) {
 			tcp_rsk(req)->accecn_ok = 1;
 			tcp_rsk(req)->syn_ect_rcv =
@@ -6655,7 +6763,7 @@ static void tcp_ecn_create_request(struct request_sock *req,
 
 	ect = !INET_ECN_is_not_ect(TCP_SKB_CB(skb)->ip_dsfield);
 	ecn_ok_dst = dst_feature(dst, DST_FEATURE_ECN_MASK);
-	ecn_ok = net->ipv4.sysctl_tcp_ecn || ecn_ok_dst;
+	ecn_ok = (net->ipv4.sysctl_tcp_ecn & TCP_ECN_ENABLE_MASK) || ecn_ok_dst;
 
 	if (((!ect || th->res1 || th->ae) && ecn_ok) ||
 	    tcp_ca_needs_ecn(listen_sk) ||
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 084ebd2e725f..7bce1a73ac8f 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -330,9 +330,11 @@ static void tcp_ecn_send_syn(struct sock *sk, struct sk_buff *skb)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	bool bpf_needs_ecn = tcp_bpf_ca_needs_ecn(sk);
-	bool use_accecn = sock_net(sk)->ipv4.sysctl_tcp_ecn == 3 ||
+	bool use_accecn =
+		(sock_net(sk)->ipv4.sysctl_tcp_ecn & TCP_ECN_ENABLE_MASK) == 3 ||
 		tcp_ca_needs_accecn(sk);
-	bool use_ecn = sock_net(sk)->ipv4.sysctl_tcp_ecn == 1 ||
+	bool use_ecn =
+		(sock_net(sk)->ipv4.sysctl_tcp_ecn & TCP_ECN_ENABLE_MASK) == 1 ||
 		tcp_ca_needs_ecn(sk) || bpf_needs_ecn || use_accecn;
 
 	if (!use_ecn) {
@@ -468,6 +470,7 @@ static inline bool tcp_urg_mode(const struct tcp_sock *tp)
 #define OPTION_FAST_OPEN_COOKIE	(1 << 8)
 #define OPTION_SMC		(1 << 9)
 #define OPTION_MPTCP		(1 << 10)
+#define OPTION_ACCECN		(1 << 11)
 
 static void smc_options_write(__be32 *ptr, u16 *options)
 {
@@ -488,12 +491,14 @@ struct tcp_out_options {
 	u16 options;		/* bit field of OPTION_* */
 	u16 mss;		/* 0 to disable */
 	u8 ws;			/* window scale, 0 to disable */
-	u8 num_sack_blocks;	/* number of SACK blocks to include */
+	u8 num_sack_blocks:3,	/* number of SACK blocks to include */
+	   num_ecn_bytes:2;	/* number of AccECN fields needed */
 	u8 hash_size;		/* bytes in hash_location */
 	__u8 *hash_location;	/* temporary pointer, overloaded */
 	__u32 tsval, tsecr;	/* need to include OPTION_TS */
 	struct tcp_fastopen_cookie *fastopen_cookie;	/* Fast open cookie */
 	struct mptcp_out_options mptcp;
+	u32 *ecn_bytes;		/* AccECN ECT/CE byte counters */
 };
 
 static void mptcp_options_write(__be32 *ptr, struct tcp_out_options *opts)
@@ -557,6 +562,33 @@ static void tcp_options_write(__be32 *ptr, struct tcp_sock *tp,
 		*ptr++ = htonl(opts->tsecr);
 	}
 
+	if (unlikely(OPTION_ACCECN & options)) {
+		u32 e0b = opts->ecn_bytes[INET_ECN_ECT_0 - 1] + TCP_ACCECN_E0B_INIT_OFFSET;
+		u32 ceb = opts->ecn_bytes[INET_ECN_CE - 1] + TCP_ACCECN_CEB_INIT_OFFSET;
+		u32 e1b = opts->ecn_bytes[INET_ECN_ECT_1 - 1] + TCP_ACCECN_E1B_INIT_OFFSET;
+		u8 len = TCPOLEN_EXP_ACCECN_BASE +
+			 opts->num_ecn_bytes * TCPOLEN_ACCECN_PERCOUNTER;
+
+		*ptr++ = htonl((TCPOPT_EXP << 24) | (len << 16) |
+			       TCPOPT_ACCECN_MAGIC);
+		if (opts->num_ecn_bytes > 0) {
+			*ptr++ = htonl((e0b << 8) |
+				       (opts->num_ecn_bytes > 1 ?
+					(ceb >> 16) & 0xff :
+					TCPOPT_NOP));
+			if (opts->num_ecn_bytes == 2) {
+				leftover_bytes = (ceb >> 8) & 0xffff;
+			} else {
+				*ptr++ = htonl((ceb << 16) |
+					       ((e1b >> 8) & 0xffff));
+				leftover_bytes = ((e1b & 0xff) << 8) |
+						TCPOPT_NOP;
+				leftover_size = 1;
+			}
+		}
+		if (tp != NULL)
+			tp->accecn_minlen = 0;
+	}
 	if (unlikely(OPTION_SACK_ADVERTISE & options)) {
 		*ptr++ = htonl((leftover_bytes << 16) |
 			       (TCPOPT_SACK_PERM << 8) |
@@ -677,6 +709,53 @@ static void mptcp_set_option_cond(const struct request_sock *req,
 	}
 }
 
+/* Initial values for AccECN option, ordered is based on ECN field bits
+ * similar to received_ecn_bytes. Used for SYN/ACK AccECN option.
+ */
+u32 synack_ecn_bytes[3] = { 0, 0, 0 };
+
+static u32 tcp_synack_options_combine_saving(struct tcp_out_options *opts)
+{
+	/* How much there's room for combining with the alignment padding? */
+	if ((opts->options & (OPTION_SACK_ADVERTISE|OPTION_TS)) ==
+	    OPTION_SACK_ADVERTISE)
+		return 2;
+	else if (opts->options & OPTION_WSCALE)
+		return 1;
+	return 0;
+}
+
+/* AccECN can take here and there take advantage of NOPs for alignment of
+ * other options
+ */
+static int tcp_options_fit_accecn(struct tcp_out_options *opts, int required,
+				  int remaining, int max_combine_saving)
+{
+	int size = TCP_ACCECN_MAXSIZE;
+
+	opts->num_ecn_bytes = TCP_ACCECN_NUMCOUNTERS;
+
+	while (opts->num_ecn_bytes >= required) {
+		int leftover_size = size & 0x3;
+		/* Pad to dword if cannot combine */
+		if (leftover_size > max_combine_saving)
+			leftover_size = -((4 - leftover_size) & 0x3);
+
+		if (remaining >= size - leftover_size) {
+			size -= leftover_size;
+			break;
+		}
+
+		opts->num_ecn_bytes--;
+		size -= TCPOLEN_ACCECN_PERCOUNTER;
+	}
+	if (opts->num_ecn_bytes < required)
+		return 0;
+
+	opts->options |= OPTION_ACCECN;
+	return size;
+}
+
 /* Compute TCP options for SYN packets. This is not the final
  * network wire format yet.
  */
@@ -755,6 +834,16 @@ static unsigned int tcp_syn_options(struct sock *sk, struct sk_buff *skb,
 		}
 	}
 
+	/* Simultaneous open SYN/ACK needs AccECN option but not SYN */
+	if (unlikely((TCP_SKB_CB(skb)->tcp_flags & TCPHDR_ACK) &&
+		     tcp_ecn_mode_accecn(tp) &&
+		     !(sock_net(sk)->ipv4.sysctl_tcp_ecn & TCP_ACCECN_NO_OPT) &&
+		     (remaining >= TCPOLEN_EXP_ACCECN_BASE))) {
+		opts->ecn_bytes = synack_ecn_bytes;
+		remaining -= tcp_options_fit_accecn(opts, 0, remaining,
+						    tcp_synack_options_combine_saving(opts));
+	}
+
 	return MAX_TCP_OPTION_SPACE - remaining;
 }
 
@@ -767,6 +856,7 @@ static unsigned int tcp_synack_options(const struct sock *sk,
 				       struct tcp_fastopen_cookie *foc)
 {
 	struct inet_request_sock *ireq = inet_rsk(req);
+	struct tcp_request_sock *treq = tcp_rsk(req);
 	unsigned int remaining = MAX_TCP_OPTION_SPACE;
 
 #ifdef CONFIG_TCP_MD5SIG
@@ -820,6 +910,14 @@ static unsigned int tcp_synack_options(const struct sock *sk,
 
 	smc_set_option_cond(tcp_sk(sk), ireq, opts, &remaining);
 
+	if (treq->accecn_ok &&
+	    !(sock_net(sk)->ipv4.sysctl_tcp_ecn & TCP_ACCECN_NO_OPT) &&
+	    (remaining >= TCPOLEN_EXP_ACCECN_BASE)) {
+		opts->ecn_bytes = synack_ecn_bytes;
+		remaining -= tcp_options_fit_accecn(opts, 0, remaining,
+						    tcp_synack_options_combine_saving(opts));
+	}
+
 	return MAX_TCP_OPTION_SPACE - remaining;
 }
 
@@ -887,6 +985,14 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
 		}
 	}
 
+	if (tcp_ecn_mode_accecn(tp) &&
+	    !(sock_net(sk)->ipv4.sysctl_tcp_ecn & TCP_ACCECN_NO_OPT)) {
+		opts->ecn_bytes = tp->received_ecn_bytes;
+		size += tcp_options_fit_accecn(opts, tp->accecn_minlen,
+					       MAX_TCP_OPTION_SPACE - size,
+					       opts->num_sack_blocks > 0 ? 2 : 0);
+	}
+
 	return size;
 }
 
-- 
2.20.1

