Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEFB23B0BF
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 01:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbgHCXK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 19:10:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11520 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729185AbgHCXK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 19:10:57 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 073MtBI1013158
        for <netdev@vger.kernel.org>; Mon, 3 Aug 2020 16:10:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=GbNspzCKUO6lSZzBigfQVlWK4gdRi/hTWJIYDi/s62M=;
 b=Rnq/rR0owvU9n88Jy8DyowhGLac9rWJ4mhOxKwPEl0DbR64eNcs+Fbtfp/0Of06htlZ/
 7cmCnJ6Ya3jHfdvDjOLWFOZaMpypVvATQZd+AFd8Jo0kmBupoBB2sicOB3f2+8wu3uqf
 idi+/SnxEkUU97CLQQ6cs4C487mDh/sqpmE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 32n81y9jjs-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 16:10:56 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 3 Aug 2020 16:10:55 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 14CA62943872; Mon,  3 Aug 2020 16:10:51 -0700 (PDT)
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
Subject: [RFC PATCH v4 bpf-next 06/12] bpf: tcp: Add bpf_skops_parse_hdr()
Date:   Mon, 3 Aug 2020 16:10:51 -0700
Message-ID: <20200803231051.2683561-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200803231013.2681560-1-kafai@fb.com>
References: <20200803231013.2681560-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-03_15:2020-08-03,2020-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 priorityscore=1501 mlxlogscore=995 bulkscore=0
 suspectscore=13 impostorscore=0 adultscore=0 clxscore=1015 mlxscore=0
 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008030158
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch adds a function bpf_skops_parse_hdr().
It will call the bpf prog to parse the TCP header received at
a tcp_sock that has at least reached the ESTABLISHED state.

For the packets received during the 3WHS (SYN, SYNACK and ACK),
the received skb will be available to the bpf prog during the callback
in bpf_skops_established() introduced in the previous patch and
in the bpf_skops_write_hdr_opt() that will be added in the
next patch.

Calling bpf prog to parse header is controlled by two new flags in
tp->bpf_sock_ops_cb_flags:
BPF_SOCK_OPS_PARSE_UNKNOWN_HDR_OPT_CB_FLAG and
BPF_SOCK_OPS_PARSE_ALL_HDR_OPT_CB_FLAG.

When BPF_SOCK_OPS_PARSE_UNKNOWN_HDR_OPT_CB_FLAG is set,
the bpf prog will only be called when there is unknown
option in the TCP header.

When BPF_SOCK_OPS_PARSE_ALL_HDR_OPT_CB_FLAG is set,
the bpf prog will be called on all received TCP header.

This function is half implemented to highlight the changes in
TCP stack.  The actual codes preparing the bpf running context and
invoking the bpf prog will be added in the later patch with other
necessary bpf pieces.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/uapi/linux/bpf.h       |  4 +++-
 net/ipv4/tcp_input.c           | 36 ++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  4 +++-
 3 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index d77b7df71784..355cb97ec891 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4160,8 +4160,10 @@ enum {
 	BPF_SOCK_OPS_RETRANS_CB_FLAG	=3D (1<<1),
 	BPF_SOCK_OPS_STATE_CB_FLAG	=3D (1<<2),
 	BPF_SOCK_OPS_RTT_CB_FLAG	=3D (1<<3),
+	BPF_SOCK_OPS_PARSE_ALL_HDR_OPT_CB_FLAG  =3D (1<<4),
+	BPF_SOCK_OPS_PARSE_UNKNOWN_HDR_OPT_CB_FLAG =3D (1<<5),
 /* Mask of all currently supported cb flags */
-	BPF_SOCK_OPS_ALL_CB_FLAGS       =3D 0xF,
+	BPF_SOCK_OPS_ALL_CB_FLAGS       =3D 0x3F,
 };
=20
 /* List of known BPF sock_ops operators.
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 9a8fb41676bc..ec49f6a9b68b 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -139,6 +139,36 @@ EXPORT_SYMBOL_GPL(clean_acked_data_flush);
 #endif
=20
 #ifdef CONFIG_CGROUP_BPF
+static void bpf_skops_parse_hdr(struct sock *sk, struct sk_buff *skb)
+{
+	bool unknown_opt =3D tcp_sk(sk)->rx_opt.saw_unknown &&
+		BPF_SOCK_OPS_TEST_FLAG(tcp_sk(sk),
+				       BPF_SOCK_OPS_PARSE_UNKNOWN_HDR_OPT_CB_FLAG);
+	bool parse_all_opt =3D BPF_SOCK_OPS_TEST_FLAG(tcp_sk(sk),
+						    BPF_SOCK_OPS_PARSE_ALL_HDR_OPT_CB_FLAG);
+
+	if (likely(!unknown_opt && !parse_all_opt))
+		return;
+
+	/* The skb will be handled in the
+	 * bpf_skops_established() or
+	 * bpf_skops_write_hdr_opt().
+	 */
+	switch (sk->sk_state) {
+	case TCP_SYN_RECV:
+	case TCP_SYN_SENT:
+	case TCP_LISTEN:
+		return;
+	}
+
+	/* BPF prog will have access to the sk and skb.
+	 *
+	 * The bpf running context preparation and the actual bpf prog
+	 * calling will be implemented in a later PATCH together with
+	 * other bpf pieces.
+	 */
+}
+
 static void bpf_skops_established(struct sock *sk, int bpf_op,
 				  struct sk_buff *skb)
 {
@@ -155,6 +185,10 @@ static void bpf_skops_established(struct sock *sk, i=
nt bpf_op,
 	BPF_CGROUP_RUN_PROG_SOCK_OPS(&sock_ops);
 }
 #else
+static void bpf_skops_parse_hdr(struct sock *sk, struct sk_buff *skb)
+{
+}
+
 static void bpf_skops_established(struct sock *sk, int bpf_op,
 				  struct sk_buff *skb)
 {
@@ -5621,6 +5655,8 @@ static bool tcp_validate_incoming(struct sock *sk, =
struct sk_buff *skb,
 		goto discard;
 	}
=20
+	bpf_skops_parse_hdr(sk, skb);
+
 	return true;
=20
 discard:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index d77b7df71784..355cb97ec891 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4160,8 +4160,10 @@ enum {
 	BPF_SOCK_OPS_RETRANS_CB_FLAG	=3D (1<<1),
 	BPF_SOCK_OPS_STATE_CB_FLAG	=3D (1<<2),
 	BPF_SOCK_OPS_RTT_CB_FLAG	=3D (1<<3),
+	BPF_SOCK_OPS_PARSE_ALL_HDR_OPT_CB_FLAG  =3D (1<<4),
+	BPF_SOCK_OPS_PARSE_UNKNOWN_HDR_OPT_CB_FLAG =3D (1<<5),
 /* Mask of all currently supported cb flags */
-	BPF_SOCK_OPS_ALL_CB_FLAGS       =3D 0xF,
+	BPF_SOCK_OPS_ALL_CB_FLAGS       =3D 0x3F,
 };
=20
 /* List of known BPF sock_ops operators.
--=20
2.24.1

