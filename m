Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F0524C606
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 21:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgHTTBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 15:01:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28826 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727943AbgHTTBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 15:01:15 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07KJ0awE018349
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 12:01:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=wrpUOYoiPqn551V2VxX5v0pfatdoO7UCIONkYyQzjFw=;
 b=fyv/BqZ4CEU1XkN7LkDbv54IyQTlZkW4OvvuRKiVWiUXq5dDwCyfeBToA6Q8Xb2mJ7bY
 FmMCBmTw0ShDcltLNsjWssKgd6+bprC5ZHywwuZUmxLNoZFJ1Oxcz47dGgL7crL7Xn0u
 cpUJfsTcJApuKjKDf+BJSUAOgMtz6aJBx8g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 331d50my6s-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 12:01:15 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 12:00:52 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 618C02945825; Thu, 20 Aug 2020 12:00:52 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v5 bpf-next 07/12] bpf: tcp: Add bpf_skops_hdr_opt_len() and bpf_skops_write_hdr_opt()
Date:   Thu, 20 Aug 2020 12:00:52 -0700
Message-ID: <20200820190052.2885316-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200820190008.2883500-1-kafai@fb.com>
References: <20200820190008.2883500-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_03:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 clxscore=1015 phishscore=0 suspectscore=38 adultscore=0 bulkscore=0
 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008200151
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf prog needs to parse the SYN header to learn what options have
been sent by the peer's bpf-prog before writing its options into SYNACK.
This patch adds a "syn_skb" arg to tcp_make_synack() and send_synack().
This syn_skb will eventually be made available (as read-only) to the
bpf prog.  This will be the only SYN packet available to the bpf
prog during syncookie.  For other regular cases, the bpf prog can
also use the saved_syn.

When writing options, the bpf prog will first be called to tell the
kernel its required number of bytes.  It is done by the new
bpf_skops_hdr_opt_len().  The bpf prog will only be called when the new
BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG is set in tp->bpf_sock_ops_cb_flags.
When the bpf prog returns, the kernel will know how many bytes are needed
and then update the "*remaining" arg accordingly.  4 byte alignment will
be included in the "*remaining" before this function returns.  The 4 byte
aligned number of bytes will also be stored into the opts->bpf_opt_len.
"bpf_opt_len" is a newly added member to the struct tcp_out_options.

Then the new bpf_skops_write_hdr_opt() will call the bpf prog to write th=
e
header options.  The bpf prog is only called if it has reserved spaces
before (opts->bpf_opt_len > 0).

The bpf prog is the last one getting a chance to reserve header space
and writing the header option.

These two functions are half implemented to highlight the changes in
TCP stack.  The actual codes preparing the bpf running context and
invoking the bpf prog will be added in the later patch with other
necessary bpf pieces.

Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/net/tcp.h              |   6 +-
 include/uapi/linux/bpf.h       |   3 +-
 net/ipv4/tcp_input.c           |   5 +-
 net/ipv4/tcp_ipv4.c            |   5 +-
 net/ipv4/tcp_output.c          | 105 +++++++++++++++++++++++++++++----
 net/ipv6/tcp_ipv6.c            |   5 +-
 tools/include/uapi/linux/bpf.h |   3 +-
 7 files changed, 109 insertions(+), 23 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index c186dbf731e1..3e768a6b8264 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -455,7 +455,8 @@ enum tcp_synack_type {
 struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry =
*dst,
 				struct request_sock *req,
 				struct tcp_fastopen_cookie *foc,
-				enum tcp_synack_type synack_type);
+				enum tcp_synack_type synack_type,
+				struct sk_buff *syn_skb);
 int tcp_disconnect(struct sock *sk, int flags);
=20
 void tcp_finish_connect(struct sock *sk, struct sk_buff *skb);
@@ -2035,7 +2036,8 @@ struct tcp_request_sock_ops {
 	int (*send_synack)(const struct sock *sk, struct dst_entry *dst,
 			   struct flowi *fl, struct request_sock *req,
 			   struct tcp_fastopen_cookie *foc,
-			   enum tcp_synack_type synack_type);
+			   enum tcp_synack_type synack_type,
+			   struct sk_buff *syn_skb);
 };
=20
 extern const struct tcp_request_sock_ops tcp_request_sock_ipv4_ops;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4a95aa9e3d50..6770d00d5781 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4168,8 +4168,9 @@ enum {
 	BPF_SOCK_OPS_RTT_CB_FLAG	=3D (1<<3),
 	BPF_SOCK_OPS_PARSE_ALL_HDR_OPT_CB_FLAG  =3D (1<<4),
 	BPF_SOCK_OPS_PARSE_UNKNOWN_HDR_OPT_CB_FLAG =3D (1<<5),
+	BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG =3D (1<<6),
 /* Mask of all currently supported cb flags */
-	BPF_SOCK_OPS_ALL_CB_FLAGS       =3D 0x3F,
+	BPF_SOCK_OPS_ALL_CB_FLAGS       =3D 0x7F,
 };
=20
 /* List of known BPF sock_ops operators.
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index b520450170d1..8c9da4b65dae 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6824,7 +6824,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_o=
ps,
 	}
 	if (fastopen_sk) {
 		af_ops->send_synack(fastopen_sk, dst, &fl, req,
-				    &foc, TCP_SYNACK_FASTOPEN);
+				    &foc, TCP_SYNACK_FASTOPEN, skb);
 		/* Add the child socket directly into the accept queue */
 		if (!inet_csk_reqsk_queue_add(sk, req, fastopen_sk)) {
 			reqsk_fastopen_remove(fastopen_sk, req, false);
@@ -6842,7 +6842,8 @@ int tcp_conn_request(struct request_sock_ops *rsk_o=
ps,
 				tcp_timeout_init((struct sock *)req));
 		af_ops->send_synack(sk, dst, &fl, req, &foc,
 				    !want_cookie ? TCP_SYNACK_NORMAL :
-						   TCP_SYNACK_COOKIE);
+						   TCP_SYNACK_COOKIE,
+				    skb);
 		if (want_cookie) {
 			reqsk_free(req);
 			return 0;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 5084333b5ab6..631a5ee0dd4e 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -965,7 +965,8 @@ static int tcp_v4_send_synack(const struct sock *sk, =
struct dst_entry *dst,
 			      struct flowi *fl,
 			      struct request_sock *req,
 			      struct tcp_fastopen_cookie *foc,
-			      enum tcp_synack_type synack_type)
+			      enum tcp_synack_type synack_type,
+			      struct sk_buff *syn_skb)
 {
 	const struct inet_request_sock *ireq =3D inet_rsk(req);
 	struct flowi4 fl4;
@@ -976,7 +977,7 @@ static int tcp_v4_send_synack(const struct sock *sk, =
struct dst_entry *dst,
 	if (!dst && (dst =3D inet_csk_route_req(sk, &fl4, req)) =3D=3D NULL)
 		return -1;
=20
-	skb =3D tcp_make_synack(sk, dst, req, foc, synack_type);
+	skb =3D tcp_make_synack(sk, dst, req, foc, synack_type, syn_skb);
=20
 	if (skb) {
 		__tcp_v4_send_check(skb, ireq->ir_loc_addr, ireq->ir_rmt_addr);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 44ffa4891beb..673db6879e46 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -438,6 +438,7 @@ struct tcp_out_options {
 	u8 ws;			/* window scale, 0 to disable */
 	u8 num_sack_blocks;	/* number of SACK blocks to include */
 	u8 hash_size;		/* bytes in hash_location */
+	u8 bpf_opt_len;		/* length of BPF hdr option */
 	__u8 *hash_location;	/* temporary pointer, overloaded */
 	__u32 tsval, tsecr;	/* need to include OPTION_TS */
 	struct tcp_fastopen_cookie *fastopen_cookie;	/* Fast open cookie */
@@ -452,6 +453,59 @@ static void mptcp_options_write(__be32 *ptr, struct =
tcp_out_options *opts)
 #endif
 }
=20
+#ifdef CONFIG_CGROUP_BPF
+/* req, syn_skb and synack_type are used when writing synack */
+static void bpf_skops_hdr_opt_len(struct sock *sk, struct sk_buff *skb,
+				  struct request_sock *req,
+				  struct sk_buff *syn_skb,
+				  enum tcp_synack_type synack_type,
+				  struct tcp_out_options *opts,
+				  unsigned int *remaining)
+{
+	if (likely(!BPF_SOCK_OPS_TEST_FLAG(tcp_sk(sk),
+					   BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG)) ||
+	    !*remaining)
+		return;
+
+	/* The bpf running context preparation and the actual bpf prog
+	 * calling will be implemented in a later PATCH together with
+	 * other bpf pieces.
+	 */
+}
+
+static void bpf_skops_write_hdr_opt(struct sock *sk, struct sk_buff *skb=
,
+				    struct request_sock *req,
+				    struct sk_buff *syn_skb,
+				    enum tcp_synack_type synack_type,
+				    struct tcp_out_options *opts)
+{
+	if (likely(!opts->bpf_opt_len))
+		return;
+
+	/* The bpf running context preparation and the actual bpf prog
+	 * calling will be implemented in a later PATCH together with
+	 * other bpf pieces.
+	 */
+}
+#else
+static void bpf_skops_hdr_opt_len(struct sock *sk, struct sk_buff *skb,
+				  struct request_sock *req,
+				  struct sk_buff *syn_skb,
+				  enum tcp_synack_type synack_type,
+				  struct tcp_out_options *opts,
+				  unsigned int *remaining)
+{
+}
+
+static void bpf_skops_write_hdr_opt(struct sock *sk, struct sk_buff *skb=
,
+				    struct request_sock *req,
+				    struct sk_buff *syn_skb,
+				    enum tcp_synack_type synack_type,
+				    struct tcp_out_options *opts)
+{
+}
+#endif
+
 /* Write previously computed TCP options to the packet.
  *
  * Beware: Something in the Internet is very sensitive to the ordering o=
f
@@ -691,6 +745,8 @@ static unsigned int tcp_syn_options(struct sock *sk, =
struct sk_buff *skb,
 		}
 	}
=20
+	bpf_skops_hdr_opt_len(sk, skb, NULL, NULL, 0, opts, &remaining);
+
 	return MAX_TCP_OPTION_SPACE - remaining;
 }
=20
@@ -701,7 +757,8 @@ static unsigned int tcp_synack_options(const struct s=
ock *sk,
 				       struct tcp_out_options *opts,
 				       const struct tcp_md5sig_key *md5,
 				       struct tcp_fastopen_cookie *foc,
-				       enum tcp_synack_type synack_type)
+				       enum tcp_synack_type synack_type,
+				       struct sk_buff *syn_skb)
 {
 	struct inet_request_sock *ireq =3D inet_rsk(req);
 	unsigned int remaining =3D MAX_TCP_OPTION_SPACE;
@@ -758,6 +815,9 @@ static unsigned int tcp_synack_options(const struct s=
ock *sk,
=20
 	smc_set_option_cond(tcp_sk(sk), ireq, opts, &remaining);
=20
+	bpf_skops_hdr_opt_len((struct sock *)sk, skb, req, syn_skb,
+			      synack_type, opts, &remaining);
+
 	return MAX_TCP_OPTION_SPACE - remaining;
 }
=20
@@ -826,6 +886,15 @@ static unsigned int tcp_established_options(struct s=
ock *sk, struct sk_buff *skb
 			opts->num_sack_blocks * TCPOLEN_SACK_PERBLOCK;
 	}
=20
+	if (unlikely(BPF_SOCK_OPS_TEST_FLAG(tp,
+					    BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG))) {
+		unsigned int remaining =3D MAX_TCP_OPTION_SPACE - size;
+
+		bpf_skops_hdr_opt_len(sk, skb, NULL, NULL, 0, opts, &remaining);
+
+		size =3D MAX_TCP_OPTION_SPACE - remaining;
+	}
+
 	return size;
 }
=20
@@ -1213,6 +1282,9 @@ static int __tcp_transmit_skb(struct sock *sk, stru=
ct sk_buff *skb,
 	}
 #endif
=20
+	/* BPF prog is the last one writing header option */
+	bpf_skops_write_hdr_opt(sk, skb, NULL, NULL, 0, &opts);
+
 	INDIRECT_CALL_INET(icsk->icsk_af_ops->send_check,
 			   tcp_v6_send_check, tcp_v4_send_check,
 			   sk, skb);
@@ -3336,20 +3408,20 @@ int tcp_send_synack(struct sock *sk)
 }
=20
 /**
- * tcp_make_synack - Prepare a SYN-ACK.
- * sk: listener socket
- * dst: dst entry attached to the SYNACK
- * req: request_sock pointer
- * foc: cookie for tcp fast open
- * synack_type: Type of synback to prepare
- *
- * Allocate one skb and build a SYNACK packet.
- * @dst is consumed : Caller should not use it again.
+ * tcp_make_synack - Allocate one skb and build a SYNACK packet.
+ * @sk: listener socket
+ * @dst: dst entry attached to the SYNACK. It is consumed and caller
+ *       should not use it again.
+ * @req: request_sock pointer
+ * @foc: cookie for tcp fast open
+ * @synack_type: Type of synack to prepare
+ * @syn_skb: SYN packet just received.  It could be NULL for rtx case.
  */
 struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry =
*dst,
 				struct request_sock *req,
 				struct tcp_fastopen_cookie *foc,
-				enum tcp_synack_type synack_type)
+				enum tcp_synack_type synack_type,
+				struct sk_buff *syn_skb)
 {
 	struct inet_request_sock *ireq =3D inet_rsk(req);
 	const struct tcp_sock *tp =3D tcp_sk(sk);
@@ -3408,8 +3480,11 @@ struct sk_buff *tcp_make_synack(const struct sock =
*sk, struct dst_entry *dst,
 	md5 =3D tcp_rsk(req)->af_specific->req_md5_lookup(sk, req_to_sk(req));
 #endif
 	skb_set_hash(skb, tcp_rsk(req)->txhash, PKT_HASH_TYPE_L4);
+	/* bpf program will be interested in the tcp_flags */
+	TCP_SKB_CB(skb)->tcp_flags =3D TCPHDR_SYN | TCPHDR_ACK;
 	tcp_header_size =3D tcp_synack_options(sk, req, mss, skb, &opts, md5,
-					     foc, synack_type) + sizeof(*th);
+					     foc, synack_type,
+					     syn_skb) + sizeof(*th);
=20
 	skb_push(skb, tcp_header_size);
 	skb_reset_transport_header(skb);
@@ -3441,6 +3516,9 @@ struct sk_buff *tcp_make_synack(const struct sock *=
sk, struct dst_entry *dst,
 	rcu_read_unlock();
 #endif
=20
+	bpf_skops_write_hdr_opt((struct sock *)sk, skb, req, syn_skb,
+				synack_type, &opts);
+
 	skb->skb_mstamp_ns =3D now;
 	tcp_add_tx_delay(skb, tp);
=20
@@ -3936,7 +4014,8 @@ int tcp_rtx_synack(const struct sock *sk, struct re=
quest_sock *req)
 	int res;
=20
 	tcp_rsk(req)->txhash =3D net_tx_rndhash();
-	res =3D af_ops->send_synack(sk, NULL, &fl, req, NULL, TCP_SYNACK_NORMAL=
);
+	res =3D af_ops->send_synack(sk, NULL, &fl, req, NULL, TCP_SYNACK_NORMAL=
,
+				  NULL);
 	if (!res) {
 		__TCP_INC_STATS(sock_net(sk), TCP_MIB_RETRANSSEGS);
 		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNRETRANS);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 305870a72352..87a633e1fbef 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -501,7 +501,8 @@ static int tcp_v6_send_synack(const struct sock *sk, =
struct dst_entry *dst,
 			      struct flowi *fl,
 			      struct request_sock *req,
 			      struct tcp_fastopen_cookie *foc,
-			      enum tcp_synack_type synack_type)
+			      enum tcp_synack_type synack_type,
+			      struct sk_buff *syn_skb)
 {
 	struct inet_request_sock *ireq =3D inet_rsk(req);
 	struct ipv6_pinfo *np =3D tcp_inet6_sk(sk);
@@ -515,7 +516,7 @@ static int tcp_v6_send_synack(const struct sock *sk, =
struct dst_entry *dst,
 					       IPPROTO_TCP)) =3D=3D NULL)
 		goto done;
=20
-	skb =3D tcp_make_synack(sk, dst, req, foc, synack_type);
+	skb =3D tcp_make_synack(sk, dst, req, foc, synack_type, syn_skb);
=20
 	if (skb) {
 		__tcp_v6_send_check(skb, &ireq->ir_v6_loc_addr,
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 4a95aa9e3d50..6770d00d5781 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4168,8 +4168,9 @@ enum {
 	BPF_SOCK_OPS_RTT_CB_FLAG	=3D (1<<3),
 	BPF_SOCK_OPS_PARSE_ALL_HDR_OPT_CB_FLAG  =3D (1<<4),
 	BPF_SOCK_OPS_PARSE_UNKNOWN_HDR_OPT_CB_FLAG =3D (1<<5),
+	BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG =3D (1<<6),
 /* Mask of all currently supported cb flags */
-	BPF_SOCK_OPS_ALL_CB_FLAGS       =3D 0x3F,
+	BPF_SOCK_OPS_ALL_CB_FLAGS       =3D 0x7F,
 };
=20
 /* List of known BPF sock_ops operators.
--=20
2.24.1

