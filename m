Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B21DD1449F6
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 03:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgAVCkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 21:40:21 -0500
Received: from ma1-aaemail-dr-lapp03.apple.com ([17.171.2.72]:46340 "EHLO
        ma1-aaemail-dr-lapp03.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728809AbgAVCkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 21:40:21 -0500
Received: from pps.filterd (ma1-aaemail-dr-lapp03.apple.com [127.0.0.1])
        by ma1-aaemail-dr-lapp03.apple.com (8.16.0.27/8.16.0.27) with SMTP id 00M0uwKM005654;
        Tue, 21 Jan 2020 16:57:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=sender : from : to :
 cc : subject : date : message-id : in-reply-to : references : mime-version
 : content-transfer-encoding; s=20180706;
 bh=jHbtYPKB02MDk+pZNa5Dv3MTI48aEjsOJLrfLpW7Be0=;
 b=PghATJ3u9imfdmg/mFLvZoL4TPRyXUIOt5ZK9I2Xm9UNk14LK2LZQWB7YT7iVQ8bu7/2
 8GULynEI19Ty6lL88dXP1ZswHbLNcFaK6Nr6GiYCMbZnZTo1aefQaxjm3cvJDpPljNSz
 MyxegpNIAs0xr/cfS4PFuavCPUxbjunLKVuOdeUh9luOMWaujvG6Soir9tLscJ5d5W/O
 Oo/9BZ3Q++Ielpw3wVeJhavGvCt1NAPBwerrf39IJrZjl8VWzhpecy+NBf93XbnGifKX
 pSWQFrToNxWUg1emPP0zx7bv6gokfMilBK4zFol/YkMFdtHVpYwH032RVM2gjuw/p7bK WA== 
Received: from ma1-mtap-s02.corp.apple.com (ma1-mtap-s02.corp.apple.com [17.40.76.6])
        by ma1-aaemail-dr-lapp03.apple.com with ESMTP id 2xm1w0q03h-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 21 Jan 2020 16:57:10 -0800
Received: from nwk-mmpp-sz13.apple.com
 (nwk-mmpp-sz13.apple.com [17.128.115.216]) by ma1-mtap-s02.corp.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPS id <0Q4H0018HHB4F030@ma1-mtap-s02.corp.apple.com>; Tue,
 21 Jan 2020 16:57:05 -0800 (PST)
Received: from process_milters-daemon.nwk-mmpp-sz13.apple.com by
 nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) id <0Q4H00F00F5G4K00@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:57:05 -0800 (PST)
X-Va-A: 
X-Va-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-Va-E-CD: f18f4596b6dc374f82180780baaa769d
X-Va-R-CD: 66696f38f2e4b6d938193453d7cca073
X-Va-CD: 0
X-Va-ID: a3f0620d-6318-4a19-8ca2-bdaf196f6b8d
X-V-A:  
X-V-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-V-E-CD: f18f4596b6dc374f82180780baaa769d
X-V-R-CD: 66696f38f2e4b6d938193453d7cca073
X-V-CD: 0
X-V-ID: cdf826c6-bf5c-474d-a051-a9ebc3155ec5
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,,
 definitions=2020-01-17_05:,, signatures=0
Received: from localhost ([17.192.155.241]) by nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPSA id <0Q4H0012HHB14Y50@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:57:01 -0800 (PST)
From:   Christoph Paasch <cpaasch@apple.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org
Subject: [PATCH net-next v3 17/19] mptcp: parse and emit MP_CAPABLE option
 according to v1 spec
Date:   Tue, 21 Jan 2020 16:56:31 -0800
Message-id: <20200122005633.21229-18-cpaasch@apple.com>
X-Mailer: git-send-email 2.23.0
In-reply-to: <20200122005633.21229-1-cpaasch@apple.com>
References: <20200122005633.21229-1-cpaasch@apple.com>
MIME-version: 1.0
Content-transfer-encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2020-01-17_05:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This implements MP_CAPABLE options parsing and writing according
to RFC 6824 bis / RFC 8684: MPTCP v1.

Local key is sent on syn/ack, and both keys are sent on 3rd ack.
MP_CAPABLE messages len are updated accordingly. We need the skbuff to
correctly emit the above, so we push the skbuff struct as an argument
all the way from tcp code to the relevant mptcp callbacks.

When processing incoming MP_CAPABLE + data, build a full blown DSS-like
map info, to simplify later processing.  On child socket creation, we
need to record the remote key, if available.

Signed-off-by: Christoph Paasch <cpaasch@apple.com>
---
 include/linux/tcp.h   |   3 +-
 include/net/mptcp.h   |  17 +++--
 net/ipv4/tcp_input.c  |   2 +-
 net/ipv4/tcp_output.c |   2 +-
 net/mptcp/options.c   | 162 +++++++++++++++++++++++++++++++++---------
 net/mptcp/protocol.h  |   6 +-
 net/mptcp/subflow.c   |  14 +++-
 7 files changed, 160 insertions(+), 46 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 0d00dad4b85d..4e2124607d32 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -94,7 +94,8 @@ struct mptcp_options_received {
 		data_fin:1,
 		use_ack:1,
 		ack64:1,
-		__unused:3;
+		mpc_map:1,
+		__unused:2;
 };
 #endif
 
diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 8619c1fca741..27627e2d1bc2 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -23,7 +23,8 @@ struct mptcp_ext {
 			data_fin:1,
 			use_ack:1,
 			ack64:1,
-			__unused:3;
+			mpc_map:1,
+			__unused:2;
 	/* one byte hole */
 };
 
@@ -50,10 +51,10 @@ static inline bool rsk_is_mptcp(const struct request_sock *req)
 	return tcp_rsk(req)->is_mptcp;
 }
 
-void mptcp_parse_option(const unsigned char *ptr, int opsize,
-			struct tcp_options_received *opt_rx);
-bool mptcp_syn_options(struct sock *sk, unsigned int *size,
-		       struct mptcp_out_options *opts);
+void mptcp_parse_option(const struct sk_buff *skb, const unsigned char *ptr,
+			int opsize, struct tcp_options_received *opt_rx);
+bool mptcp_syn_options(struct sock *sk, const struct sk_buff *skb,
+		       unsigned int *size, struct mptcp_out_options *opts);
 void mptcp_rcv_synsent(struct sock *sk);
 bool mptcp_synack_options(const struct request_sock *req, unsigned int *size,
 			  struct mptcp_out_options *opts);
@@ -121,12 +122,14 @@ static inline bool rsk_is_mptcp(const struct request_sock *req)
 	return false;
 }
 
-static inline void mptcp_parse_option(const unsigned char *ptr, int opsize,
+static inline void mptcp_parse_option(const struct sk_buff *skb,
+				      const unsigned char *ptr, int opsize,
 				      struct tcp_options_received *opt_rx)
 {
 }
 
-static inline bool mptcp_syn_options(struct sock *sk, unsigned int *size,
+static inline bool mptcp_syn_options(struct sock *sk, const struct sk_buff *skb,
+				     unsigned int *size,
 				     struct mptcp_out_options *opts)
 {
 	return false;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 28d31f2c1422..2f475b897c11 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3926,7 +3926,7 @@ void tcp_parse_options(const struct net *net,
 				break;
 #endif
 			case TCPOPT_MPTCP:
-				mptcp_parse_option(ptr, opsize, opt_rx);
+				mptcp_parse_option(skb, ptr, opsize, opt_rx);
 				break;
 
 			case TCPOPT_FASTOPEN:
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index c6797a388921..213729ebf323 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -685,7 +685,7 @@ static unsigned int tcp_syn_options(struct sock *sk, struct sk_buff *skb,
 	if (sk_is_mptcp(sk)) {
 		unsigned int size;
 
-		if (mptcp_syn_options(sk, &size, &opts->mptcp)) {
+		if (mptcp_syn_options(sk, skb, &size, &opts->mptcp)) {
 			opts->options |= OPTION_MPTCP;
 			remaining -= size;
 		}
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 1aec742ca8e1..8f82ff9a5a8e 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -14,8 +14,8 @@ static bool mptcp_cap_flag_sha256(u8 flags)
 	return (flags & MPTCP_CAP_FLAG_MASK) == MPTCP_CAP_HMAC_SHA256;
 }
 
-void mptcp_parse_option(const unsigned char *ptr, int opsize,
-			struct tcp_options_received *opt_rx)
+void mptcp_parse_option(const struct sk_buff *skb, const unsigned char *ptr,
+			int opsize, struct tcp_options_received *opt_rx)
 {
 	struct mptcp_options_received *mp_opt = &opt_rx->mptcp;
 	u8 subtype = *ptr >> 4;
@@ -25,13 +25,29 @@ void mptcp_parse_option(const unsigned char *ptr, int opsize,
 
 	switch (subtype) {
 	case MPTCPOPT_MP_CAPABLE:
-		if (opsize != TCPOLEN_MPTCP_MPC_SYN &&
-		    opsize != TCPOLEN_MPTCP_MPC_ACK)
+		/* strict size checking */
+		if (!(TCP_SKB_CB(skb)->tcp_flags & TCPHDR_SYN)) {
+			if (skb->len > tcp_hdr(skb)->doff << 2)
+				expected_opsize = TCPOLEN_MPTCP_MPC_ACK_DATA;
+			else
+				expected_opsize = TCPOLEN_MPTCP_MPC_ACK;
+		} else {
+			if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_ACK)
+				expected_opsize = TCPOLEN_MPTCP_MPC_SYNACK;
+			else
+				expected_opsize = TCPOLEN_MPTCP_MPC_SYN;
+		}
+		if (opsize != expected_opsize)
 			break;
 
+		/* try to be gentle vs future versions on the initial syn */
 		version = *ptr++ & MPTCP_VERSION_MASK;
-		if (version != MPTCP_SUPPORTED_VERSION)
+		if (opsize != TCPOLEN_MPTCP_MPC_SYN) {
+			if (version != MPTCP_SUPPORTED_VERSION)
+				break;
+		} else if (version < MPTCP_SUPPORTED_VERSION) {
 			break;
+		}
 
 		flags = *ptr++;
 		if (!mptcp_cap_flag_sha256(flags) ||
@@ -55,23 +71,40 @@ void mptcp_parse_option(const unsigned char *ptr, int opsize,
 			break;
 
 		mp_opt->mp_capable = 1;
-		mp_opt->sndr_key = get_unaligned_be64(ptr);
-		ptr += 8;
-
-		if (opsize == TCPOLEN_MPTCP_MPC_ACK) {
+		if (opsize >= TCPOLEN_MPTCP_MPC_SYNACK) {
+			mp_opt->sndr_key = get_unaligned_be64(ptr);
+			ptr += 8;
+		}
+		if (opsize >= TCPOLEN_MPTCP_MPC_ACK) {
 			mp_opt->rcvr_key = get_unaligned_be64(ptr);
 			ptr += 8;
-			pr_debug("MP_CAPABLE sndr=%llu, rcvr=%llu",
-				 mp_opt->sndr_key, mp_opt->rcvr_key);
-		} else {
-			pr_debug("MP_CAPABLE sndr=%llu", mp_opt->sndr_key);
 		}
+		if (opsize == TCPOLEN_MPTCP_MPC_ACK_DATA) {
+			/* Section 3.1.:
+			 * "the data parameters in a MP_CAPABLE are semantically
+			 * equivalent to those in a DSS option and can be used
+			 * interchangeably."
+			 */
+			mp_opt->dss = 1;
+			mp_opt->use_map = 1;
+			mp_opt->mpc_map = 1;
+			mp_opt->data_len = get_unaligned_be16(ptr);
+			ptr += 2;
+		}
+		pr_debug("MP_CAPABLE version=%x, flags=%x, optlen=%d sndr=%llu, rcvr=%llu len=%d",
+			 version, flags, opsize, mp_opt->sndr_key,
+			 mp_opt->rcvr_key, mp_opt->data_len);
 		break;
 
 	case MPTCPOPT_DSS:
 		pr_debug("DSS");
 		ptr++;
 
+		/* we must clear 'mpc_map' be able to detect MP_CAPABLE
+		 * map vs DSS map in mptcp_incoming_options(), and reconstruct
+		 * map info accordingly
+		 */
+		mp_opt->mpc_map = 0;
 		flags = (*ptr++) & MPTCP_DSS_FLAG_MASK;
 		mp_opt->data_fin = (flags & MPTCP_DSS_DATA_FIN) != 0;
 		mp_opt->dsn64 = (flags & MPTCP_DSS_DSN64) != 0;
@@ -176,18 +209,22 @@ void mptcp_get_options(const struct sk_buff *skb,
 			if (opsize > length)
 				return;	/* don't parse partial options */
 			if (opcode == TCPOPT_MPTCP)
-				mptcp_parse_option(ptr, opsize, opt_rx);
+				mptcp_parse_option(skb, ptr, opsize, opt_rx);
 			ptr += opsize - 2;
 			length -= opsize;
 		}
 	}
 }
 
-bool mptcp_syn_options(struct sock *sk, unsigned int *size,
-		       struct mptcp_out_options *opts)
+bool mptcp_syn_options(struct sock *sk, const struct sk_buff *skb,
+		       unsigned int *size, struct mptcp_out_options *opts)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 
+	/* we will use snd_isn to detect first pkt [re]transmission
+	 * in mptcp_established_options_mp()
+	 */
+	subflow->snd_isn = TCP_SKB_CB(skb)->end_seq;
 	if (subflow->request_mptcp) {
 		pr_debug("local_key=%llu", subflow->local_key);
 		opts->suboptions = OPTION_MPTCP_MPC_SYN;
@@ -212,20 +249,52 @@ void mptcp_rcv_synsent(struct sock *sk)
 	}
 }
 
-static bool mptcp_established_options_mp(struct sock *sk, unsigned int *size,
+static bool mptcp_established_options_mp(struct sock *sk, struct sk_buff *skb,
+					 unsigned int *size,
 					 unsigned int remaining,
 					 struct mptcp_out_options *opts)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	struct mptcp_ext *mpext;
+	unsigned int data_len;
+
+	pr_debug("subflow=%p fourth_ack=%d seq=%x:%x remaining=%d", subflow,
+		 subflow->fourth_ack, subflow->snd_isn,
+		 skb ? TCP_SKB_CB(skb)->seq : 0, remaining);
+
+	if (subflow->mp_capable && !subflow->fourth_ack && skb &&
+	    subflow->snd_isn == TCP_SKB_CB(skb)->seq) {
+		/* When skb is not available, we better over-estimate the
+		 * emitted options len. A full DSS option is longer than
+		 * TCPOLEN_MPTCP_MPC_ACK_DATA, so let's the caller try to fit
+		 * that.
+		 */
+		mpext = mptcp_get_ext(skb);
+		data_len = mpext ? mpext->data_len : 0;
 
-	if (!subflow->fourth_ack) {
+		/* we will check ext_copy.data_len in mptcp_write_options() to
+		 * discriminate between TCPOLEN_MPTCP_MPC_ACK_DATA and
+		 * TCPOLEN_MPTCP_MPC_ACK
+		 */
+		opts->ext_copy.data_len = data_len;
 		opts->suboptions = OPTION_MPTCP_MPC_ACK;
 		opts->sndr_key = subflow->local_key;
 		opts->rcvr_key = subflow->remote_key;
-		*size = TCPOLEN_MPTCP_MPC_ACK;
-		subflow->fourth_ack = 1;
-		pr_debug("subflow=%p, local_key=%llu, remote_key=%llu",
-			 subflow, subflow->local_key, subflow->remote_key);
+
+		/* Section 3.1.
+		 * The MP_CAPABLE option is carried on the SYN, SYN/ACK, and ACK
+		 * packets that start the first subflow of an MPTCP connection,
+		 * as well as the first packet that carries data
+		 */
+		if (data_len > 0)
+			*size = ALIGN(TCPOLEN_MPTCP_MPC_ACK_DATA, 4);
+		else
+			*size = TCPOLEN_MPTCP_MPC_ACK;
+
+		pr_debug("subflow=%p, local_key=%llu, remote_key=%llu map_len=%d",
+			 subflow, subflow->local_key, subflow->remote_key,
+			 data_len);
+
 		return true;
 	}
 	return false;
@@ -319,7 +388,7 @@ bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 	unsigned int opt_size = 0;
 	bool ret = false;
 
-	if (mptcp_established_options_mp(sk, &opt_size, remaining, opts))
+	if (mptcp_established_options_mp(sk, skb, &opt_size, remaining, opts))
 		ret = true;
 	else if (mptcp_established_options_dss(sk, skb, &opt_size, remaining,
 					       opts))
@@ -371,11 +440,26 @@ void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb,
 	memset(mpext, 0, sizeof(*mpext));
 
 	if (mp_opt->use_map) {
-		mpext->data_seq = mp_opt->data_seq;
-		mpext->subflow_seq = mp_opt->subflow_seq;
+		if (mp_opt->mpc_map) {
+			struct mptcp_subflow_context *subflow =
+				mptcp_subflow_ctx(sk);
+
+			/* this is an MP_CAPABLE carrying MPTCP data
+			 * we know this map the first chunk of data
+			 */
+			mptcp_crypto_key_sha(subflow->remote_key, NULL,
+					     &mpext->data_seq);
+			mpext->data_seq++;
+			mpext->subflow_seq = 1;
+			mpext->dsn64 = 1;
+			mpext->mpc_map = 1;
+		} else {
+			mpext->data_seq = mp_opt->data_seq;
+			mpext->subflow_seq = mp_opt->subflow_seq;
+			mpext->dsn64 = mp_opt->dsn64;
+		}
 		mpext->data_len = mp_opt->data_len;
 		mpext->use_map = 1;
-		mpext->dsn64 = mp_opt->dsn64;
 	}
 
 	if (mp_opt->use_ack) {
@@ -389,8 +473,7 @@ void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb,
 
 void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
 {
-	if ((OPTION_MPTCP_MPC_SYN |
-	     OPTION_MPTCP_MPC_SYNACK |
+	if ((OPTION_MPTCP_MPC_SYN | OPTION_MPTCP_MPC_SYNACK |
 	     OPTION_MPTCP_MPC_ACK) & opts->suboptions) {
 		u8 len;
 
@@ -398,6 +481,8 @@ void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
 			len = TCPOLEN_MPTCP_MPC_SYN;
 		else if (OPTION_MPTCP_MPC_SYNACK & opts->suboptions)
 			len = TCPOLEN_MPTCP_MPC_SYNACK;
+		else if (opts->ext_copy.data_len)
+			len = TCPOLEN_MPTCP_MPC_ACK_DATA;
 		else
 			len = TCPOLEN_MPTCP_MPC_ACK;
 
@@ -405,14 +490,27 @@ void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
 			       (MPTCPOPT_MP_CAPABLE << 12) |
 			       (MPTCP_SUPPORTED_VERSION << 8) |
 			       MPTCP_CAP_HMAC_SHA256);
+
+		if (!((OPTION_MPTCP_MPC_SYNACK | OPTION_MPTCP_MPC_ACK) &
+		    opts->suboptions))
+			goto mp_capable_done;
+
 		put_unaligned_be64(opts->sndr_key, ptr);
 		ptr += 2;
-		if (OPTION_MPTCP_MPC_ACK & opts->suboptions) {
-			put_unaligned_be64(opts->rcvr_key, ptr);
-			ptr += 2;
-		}
+		if (!((OPTION_MPTCP_MPC_ACK) & opts->suboptions))
+			goto mp_capable_done;
+
+		put_unaligned_be64(opts->rcvr_key, ptr);
+		ptr += 2;
+		if (!opts->ext_copy.data_len)
+			goto mp_capable_done;
+
+		put_unaligned_be32(opts->ext_copy.data_len << 16 |
+				   TCPOPT_NOP << 8 | TCPOPT_NOP, ptr);
+		ptr += 1;
 	}
 
+mp_capable_done:
 	if (opts->ext_copy.use_ack || opts->ext_copy.use_map) {
 		struct mptcp_ext *mpext = &opts->ext_copy;
 		u8 len = TCPOLEN_MPTCP_DSS_BASE;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index a355bb1cf31b..36b90024d34d 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -11,7 +11,7 @@
 #include <net/tcp.h>
 #include <net/inet_connection_sock.h>
 
-#define MPTCP_SUPPORTED_VERSION	0
+#define MPTCP_SUPPORTED_VERSION	1
 
 /* MPTCP option bits */
 #define OPTION_MPTCP_MPC_SYN	BIT(0)
@@ -29,9 +29,10 @@
 #define MPTCPOPT_MP_FASTCLOSE	7
 
 /* MPTCP suboption lengths */
-#define TCPOLEN_MPTCP_MPC_SYN		12
+#define TCPOLEN_MPTCP_MPC_SYN		4
 #define TCPOLEN_MPTCP_MPC_SYNACK	12
 #define TCPOLEN_MPTCP_MPC_ACK		20
+#define TCPOLEN_MPTCP_MPC_ACK_DATA	22
 #define TCPOLEN_MPTCP_DSS_BASE		4
 #define TCPOLEN_MPTCP_DSS_ACK32		4
 #define TCPOLEN_MPTCP_DSS_ACK64		8
@@ -106,6 +107,7 @@ struct mptcp_subflow_context {
 	u64	remote_key;
 	u64	idsn;
 	u64	map_seq;
+	u32	snd_isn;
 	u32	token;
 	u32	rel_write_seq;
 	u32	map_subflow_seq;
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 9fb3eb87a20f..8892855f4f52 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -77,7 +77,6 @@ static void subflow_init_req(struct request_sock *req,
 		if (err == 0)
 			subflow_req->mp_capable = 1;
 
-		subflow_req->remote_key = rx_opt.mptcp.sndr_key;
 		subflow_req->ssn_offset = TCP_SKB_CB(skb)->seq;
 	}
 }
@@ -180,11 +179,22 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 					  bool *own_req)
 {
 	struct mptcp_subflow_context *listener = mptcp_subflow_ctx(sk);
+	struct mptcp_subflow_request_sock *subflow_req;
+	struct tcp_options_received opt_rx;
 	struct sock *child;
 
 	pr_debug("listener=%p, req=%p, conn=%p", listener, req, listener->conn);
 
-	/* if the sk is MP_CAPABLE, we already received the client key */
+	/* if the sk is MP_CAPABLE, we need to fetch the client key */
+	subflow_req = mptcp_subflow_rsk(req);
+	if (subflow_req->mp_capable) {
+		opt_rx.mptcp.mp_capable = 0;
+		mptcp_get_options(skb, &opt_rx);
+		if (!opt_rx.mptcp.mp_capable)
+			subflow_req->mp_capable = 0;
+		else
+			subflow_req->remote_key = opt_rx.mptcp.sndr_key;
+	}
 
 	child = listener->icsk_af_ops->syn_recv_sock(sk, skb, req, dst,
 						     req_unhash, own_req);
-- 
2.23.0

