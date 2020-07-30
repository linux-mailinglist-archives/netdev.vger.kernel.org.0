Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE4F233A28
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 22:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730479AbgG3U52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 16:57:28 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:65342 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730024AbgG3U51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 16:57:27 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06UKrSRj012197
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 13:57:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=HYsb4P4MjGuYj+mkHp/3CnVkBG0HrlF35oWt1RHU0iU=;
 b=O3KLyecKS30mM1KUfs2HB/1oxGIyFpNhdSiKiN0n+BbHLci2qiwiC6xXHdEI7cTXxnZD
 kZk1lMg/Vfzwu/9f4VSuTG+ww4mLU2VRiiaRZIJSgWLU6MqvK0HLZ48cbi7rZOpg8Nj0
 yGnOEaJfrGWQcZnq8yIpVdkxyEORFl0Wiug= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32kxekap52-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 13:57:26 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 30 Jul 2020 13:57:24 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id C0AD12943DF6; Thu, 30 Jul 2020 13:57:23 -0700 (PDT)
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
Subject: [PATCH v3 bpf-next 4/9] tcp: Add unknown_opt arg to tcp_parse_options
Date:   Thu, 30 Jul 2020 13:57:23 -0700
Message-ID: <20200730205723.3353838-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200730205657.3351905-1-kafai@fb.com>
References: <20200730205657.3351905-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-30_15:2020-07-30,2020-07-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 bulkscore=0
 phishscore=0 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 adultscore=0 suspectscore=13 mlxscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007300147
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the latter patch, the bpf prog only wants to be called to handle
a header option if that particular header option cannot be handled by
the kernel.  This unknown option could be written by the peer's bpf-prog.
It could also be a new standard option that the running kernel does not
support it while a bpf-prog can handle it.

In a latter patch, the bpf prog will be called from tcp_validate_incoming=
()
if there is unknown option and a flag is set in tp->bpf_sock_ops_cb_flags=
.

Instead of using skb->cb[] in an earlier attempt, this patch
adds an optional arg "bool *unknown_opt" to tcp_parse_options().
The bool will be set to true if it has encountered an option
that the kernel does not recognize.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 drivers/infiniband/hw/cxgb4/cm.c |  2 +-
 include/net/tcp.h                |  3 ++-
 net/ipv4/syncookies.c            |  2 +-
 net/ipv4/tcp_input.c             | 40 +++++++++++++++++++++-----------
 net/ipv4/tcp_minisocks.c         |  4 ++--
 net/ipv6/syncookies.c            |  2 +-
 6 files changed, 34 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxg=
b4/cm.c
index 30e08bcc9afb..dedca6576bb9 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -3949,7 +3949,7 @@ static void build_cpl_pass_accept_req(struct sk_buf=
f *skb, int stid , u8 tos)
 	 */
 	memset(&tmp_opt, 0, sizeof(tmp_opt));
 	tcp_clear_options(&tmp_opt);
-	tcp_parse_options(&init_net, skb, &tmp_opt, 0, NULL);
+	tcp_parse_options(&init_net, skb, &tmp_opt, 0, NULL, NULL);
=20
 	req =3D __skb_push(skb, sizeof(*req));
 	memset(req, 0, sizeof(*req));
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 895e7aabf136..d49d8f1c961a 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -413,7 +413,8 @@ int tcp_mmap(struct file *file, struct socket *sock,
 #endif
 void tcp_parse_options(const struct net *net, const struct sk_buff *skb,
 		       struct tcp_options_received *opt_rx,
-		       int estab, struct tcp_fastopen_cookie *foc);
+		       int estab, struct tcp_fastopen_cookie *foc,
+		       bool *unknown_opt);
 const u8 *tcp_parse_md5sig_option(const struct tcphdr *th);
=20
 /*
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 9a4f6b16c9bc..fd39aed4fcd3 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -313,7 +313,7 @@ struct sock *cookie_v4_check(struct sock *sk, struct =
sk_buff *skb)
=20
 	/* check for timestamp cookie support */
 	memset(&tcp_opt, 0, sizeof(tcp_opt));
-	tcp_parse_options(sock_net(sk), skb, &tcp_opt, 0, NULL);
+	tcp_parse_options(sock_net(sk), skb, &tcp_opt, 0, NULL, NULL);
=20
 	if (tcp_opt.saw_tstamp && tcp_opt.rcv_tsecr) {
 		tsoff =3D secure_tcp_ts_off(sock_net(sk),
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 6c38ca9de17e..d9c878001be2 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3799,7 +3799,7 @@ static void tcp_parse_fastopen_option(int len, cons=
t unsigned char *cookie,
 	foc->exp =3D exp_opt;
 }
=20
-static void smc_parse_options(const struct tcphdr *th,
+static bool smc_parse_options(const struct tcphdr *th,
 			      struct tcp_options_received *opt_rx,
 			      const unsigned char *ptr,
 			      int opsize)
@@ -3808,10 +3808,13 @@ static void smc_parse_options(const struct tcphdr=
 *th,
 	if (static_branch_unlikely(&tcp_have_smc)) {
 		if (th->syn && !(opsize & 1) &&
 		    opsize >=3D TCPOLEN_EXP_SMC_BASE &&
-		    get_unaligned_be32(ptr) =3D=3D TCPOPT_SMC_MAGIC)
+		    get_unaligned_be32(ptr) =3D=3D TCPOPT_SMC_MAGIC) {
 			opt_rx->smc_ok =3D 1;
+			return true;
+		}
 	}
 #endif
+	return false;
 }
=20
 /* Try to parse the MSS option from the TCP header. Return 0 on failure,=
 clamped
@@ -3864,7 +3867,8 @@ static u16 tcp_parse_mss_option(const struct tcphdr=
 *th, u16 user_mss)
 void tcp_parse_options(const struct net *net,
 		       const struct sk_buff *skb,
 		       struct tcp_options_received *opt_rx, int estab,
-		       struct tcp_fastopen_cookie *foc)
+		       struct tcp_fastopen_cookie *foc,
+		       bool *unknown_opt)
 {
 	const unsigned char *ptr;
 	const struct tcphdr *th =3D tcp_hdr(skb);
@@ -3962,15 +3966,23 @@ void tcp_parse_options(const struct net *net,
 				 */
 				if (opsize >=3D TCPOLEN_EXP_FASTOPEN_BASE &&
 				    get_unaligned_be16(ptr) =3D=3D
-				    TCPOPT_FASTOPEN_MAGIC)
+				    TCPOPT_FASTOPEN_MAGIC) {
 					tcp_parse_fastopen_option(opsize -
 						TCPOLEN_EXP_FASTOPEN_BASE,
 						ptr + 2, th->syn, foc, true);
-				else
-					smc_parse_options(th, opt_rx, ptr,
-							  opsize);
+					break;
+				}
+
+				if (smc_parse_options(th, opt_rx, ptr, opsize))
+					break;
+
+				if (unknown_opt)
+					*unknown_opt =3D true;
 				break;
=20
+			default:
+				if (unknown_opt)
+					*unknown_opt =3D true;
 			}
 			ptr +=3D opsize-2;
 			length -=3D opsize;
@@ -4003,7 +4015,8 @@ static bool tcp_parse_aligned_timestamp(struct tcp_=
sock *tp, const struct tcphdr
  */
 static bool tcp_fast_parse_options(const struct net *net,
 				   const struct sk_buff *skb,
-				   const struct tcphdr *th, struct tcp_sock *tp)
+				   const struct tcphdr *th, struct tcp_sock *tp,
+				   bool *unknown_opt)
 {
 	/* In the spirit of fast parsing, compare doff directly to constant
 	 * values.  Because equality is used, short doff can be ignored here.
@@ -4017,7 +4030,7 @@ static bool tcp_fast_parse_options(const struct net=
 *net,
 			return true;
 	}
=20
-	tcp_parse_options(net, skb, &tp->rx_opt, 1, NULL);
+	tcp_parse_options(net, skb, &tp->rx_opt, 1, NULL, unknown_opt);
 	if (tp->rx_opt.saw_tstamp && tp->rx_opt.rcv_tsecr)
 		tp->rx_opt.rcv_tsecr -=3D tp->tsoffset;
=20
@@ -5492,9 +5505,10 @@ static bool tcp_validate_incoming(struct sock *sk,=
 struct sk_buff *skb,
 {
 	struct tcp_sock *tp =3D tcp_sk(sk);
 	bool rst_seq_match =3D false;
+	bool unknown_opt =3D false;
=20
 	/* RFC1323: H1. Apply PAWS check first. */
-	if (tcp_fast_parse_options(sock_net(sk), skb, th, tp) &&
+	if (tcp_fast_parse_options(sock_net(sk), skb, th, tp, &unknown_opt) &&
 	    tp->rx_opt.saw_tstamp &&
 	    tcp_paws_discard(sk, skb)) {
 		if (!th->rst) {
@@ -5866,7 +5880,7 @@ static bool tcp_rcv_fastopen_synack(struct sock *sk=
, struct sk_buff *synack,
 		/* Get original SYNACK MSS value if user MSS sets mss_clamp */
 		tcp_clear_options(&opt);
 		opt.user_mss =3D opt.mss_clamp =3D 0;
-		tcp_parse_options(sock_net(sk), synack, &opt, 0, NULL);
+		tcp_parse_options(sock_net(sk), synack, &opt, 0, NULL, NULL);
 		mss =3D opt.mss_clamp;
 	}
=20
@@ -5951,7 +5965,7 @@ static int tcp_rcv_synsent_state_process(struct soc=
k *sk, struct sk_buff *skb,
 	int saved_clamp =3D tp->rx_opt.mss_clamp;
 	bool fastopen_fail;
=20
-	tcp_parse_options(sock_net(sk), skb, &tp->rx_opt, 0, &foc);
+	tcp_parse_options(sock_net(sk), skb, &tp->rx_opt, 0, &foc, NULL);
 	if (tp->rx_opt.saw_tstamp && tp->rx_opt.rcv_tsecr)
 		tp->rx_opt.rcv_tsecr -=3D tp->tsoffset;
=20
@@ -6685,7 +6699,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_o=
ps,
 	tmp_opt.mss_clamp =3D af_ops->mss_clamp;
 	tmp_opt.user_mss  =3D tp->rx_opt.user_mss;
 	tcp_parse_options(sock_net(sk), skb, &tmp_opt, 0,
-			  want_cookie ? NULL : &foc);
+			  want_cookie ? NULL : &foc, NULL);
=20
 	if (want_cookie && !tmp_opt.saw_tstamp)
 		tcp_clear_options(&tmp_opt);
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 495dda2449fe..61f9194802c4 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -98,7 +98,7 @@ tcp_timewait_state_process(struct inet_timewait_sock *t=
w, struct sk_buff *skb,
=20
 	tmp_opt.saw_tstamp =3D 0;
 	if (th->doff > (sizeof(*th) >> 2) && tcptw->tw_ts_recent_stamp) {
-		tcp_parse_options(twsk_net(tw), skb, &tmp_opt, 0, NULL);
+		tcp_parse_options(twsk_net(tw), skb, &tmp_opt, 0, NULL, NULL);
=20
 		if (tmp_opt.saw_tstamp) {
 			if (tmp_opt.rcv_tsecr)
@@ -580,7 +580,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk=
_buff *skb,
=20
 	tmp_opt.saw_tstamp =3D 0;
 	if (th->doff > (sizeof(struct tcphdr)>>2)) {
-		tcp_parse_options(sock_net(sk), skb, &tmp_opt, 0, NULL);
+		tcp_parse_options(sock_net(sk), skb, &tmp_opt, 0, NULL, NULL);
=20
 		if (tmp_opt.saw_tstamp) {
 			tmp_opt.ts_recent =3D req->ts_recent;
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index 13235a012388..f22961a73c2b 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -157,7 +157,7 @@ struct sock *cookie_v6_check(struct sock *sk, struct =
sk_buff *skb)
=20
 	/* check for timestamp cookie support */
 	memset(&tcp_opt, 0, sizeof(tcp_opt));
-	tcp_parse_options(sock_net(sk), skb, &tcp_opt, 0, NULL);
+	tcp_parse_options(sock_net(sk), skb, &tcp_opt, 0, NULL, NULL);
=20
 	if (tcp_opt.saw_tstamp && tcp_opt.rcv_tsecr) {
 		tsoff =3D secure_tcpv6_ts_off(sock_net(sk),
--=20
2.24.1

