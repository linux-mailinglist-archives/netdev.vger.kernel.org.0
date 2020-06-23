Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052262067F7
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 01:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388577AbgFWXIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 19:08:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26544 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388563AbgFWXIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 19:08:19 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NN78iH021090
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 16:08:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=/6iyE93h2IFnEF7LoRVfTZcXnqgoQujDLQRP1eri9eA=;
 b=Q1gPUdTwOJAhKAuZ6GghypCuVefEVEPcanEOEAo9RUqs8XNYfJho9/XgynKzrDRUsmrD
 dEeOKR2cJqgakhj3Bxn9VAyX9+2okjAhk23+idO2DE90xigB9X6bDLBz3Dr7bGSUA/Ri
 gjLlT8rHMZN+74pfYbV/aXRzmBWVsZroNn0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31utrvr3qf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 16:08:18 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 16:08:16 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 5249C3704F8E; Tue, 23 Jun 2020 16:08:15 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v5 09/15] bpf: add bpf_skc_to_udp6_sock() helper
Date:   Tue, 23 Jun 2020 16:08:15 -0700
Message-ID: <20200623230815.3988481-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200623230803.3987674-1-yhs@fb.com>
References: <20200623230803.3987674-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_14:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 malwarescore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0 phishscore=0
 cotscore=-2147483648 mlxlogscore=999 mlxscore=0 priorityscore=1501
 suspectscore=9 spamscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006230153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The helper is used in tracing programs to cast a socket
pointer to a udp6_sock pointer.
The return value could be NULL if the casting is illegal.

Cc: Eric Dumazet <edumazet@google.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       |  9 ++++++++-
 kernel/trace/bpf_trace.c       |  2 ++
 net/core/filter.c              | 22 ++++++++++++++++++++++
 scripts/bpf_helpers_doc.py     |  2 ++
 tools/include/uapi/linux/bpf.h |  9 ++++++++-
 6 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c23998cf6699..3d2ade703a35 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1653,6 +1653,7 @@ extern const struct bpf_func_proto bpf_skc_to_tcp6_=
sock_proto;
 extern const struct bpf_func_proto bpf_skc_to_tcp_sock_proto;
 extern const struct bpf_func_proto bpf_skc_to_tcp_timewait_sock_proto;
 extern const struct bpf_func_proto bpf_skc_to_tcp_request_sock_proto;
+extern const struct bpf_func_proto bpf_skc_to_udp6_sock_proto;
=20
 const struct bpf_func_proto *bpf_tracing_func_proto(
 	enum bpf_func_id func_id, const struct bpf_prog *prog);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index e256417d94c2..3f4b12c5c563 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3276,6 +3276,12 @@ union bpf_attr {
  *		Dynamically cast a *sk* pointer to a *tcp_request_sock* pointer.
  *	Return
  *		*sk* if casting is valid, or NULL otherwise.
+ *
+ * struct udp6_sock *bpf_skc_to_udp6_sock(void *sk)
+ * 	Description
+ *		Dynamically cast a *sk* pointer to a *udp6_sock* pointer.
+ *	Return
+ *		*sk* if casting is valid, or NULL otherwise.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3417,7 +3423,8 @@ union bpf_attr {
 	FN(skc_to_tcp6_sock),		\
 	FN(skc_to_tcp_sock),		\
 	FN(skc_to_tcp_timewait_sock),	\
-	FN(skc_to_tcp_request_sock),
+	FN(skc_to_tcp_request_sock),	\
+	FN(skc_to_udp6_sock),
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
  * function eBPF program intends to call
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index de5fbe66e1ca..d10ab16c4a2f 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1523,6 +1523,8 @@ tracing_prog_func_proto(enum bpf_func_id func_id, c=
onst struct bpf_prog *prog)
 		return &bpf_skc_to_tcp_timewait_sock_proto;
 	case BPF_FUNC_skc_to_tcp_request_sock:
 		return &bpf_skc_to_tcp_request_sock_proto;
+	case BPF_FUNC_skc_to_udp6_sock:
+		return &bpf_skc_to_udp6_sock_proto;
 #endif
 	case BPF_FUNC_seq_printf:
 		return prog->expected_attach_type =3D=3D BPF_TRACE_ITER ?
diff --git a/net/core/filter.c b/net/core/filter.c
index a285a2d00edc..416c6b232b01 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9335,3 +9335,25 @@ const struct bpf_func_proto bpf_skc_to_tcp_request=
_sock_proto =3D {
 	.check_btf_id		=3D check_arg_btf_id,
 	.ret_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_TCP_REQ],
 };
+
+BPF_CALL_1(bpf_skc_to_udp6_sock, struct sock *, sk)
+{
+	/* udp6_sock type is not generated in dwarf and hence btf,
+	 * trigger an explicit type generation here.
+	 */
+	BTF_TYPE_EMIT(struct udp6_sock);
+	if (sk_fullsock(sk) && sk->sk_protocol =3D=3D IPPROTO_UDP &&
+	    sk->sk_type =3D=3D SOCK_DGRAM && sk->sk_family =3D=3D AF_INET6)
+		return (unsigned long)sk;
+
+	return (unsigned long)NULL;
+}
+
+const struct bpf_func_proto bpf_skc_to_udp6_sock_proto =3D {
+	.func			=3D bpf_skc_to_udp6_sock,
+	.gpl_only		=3D false,
+	.ret_type		=3D RET_PTR_TO_BTF_ID_OR_NULL,
+	.arg1_type		=3D ARG_PTR_TO_BTF_ID,
+	.check_btf_id		=3D check_arg_btf_id,
+	.ret_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_UDP6],
+};
diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
index d886657c6aaa..6bab40ff442e 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -425,6 +425,7 @@ class PrinterHelpers(Printer):
             'struct tcp_sock',
             'struct tcp_timewait_sock',
             'struct tcp_request_sock',
+            'struct udp6_sock',
=20
             'struct __sk_buff',
             'struct sk_msg_md',
@@ -466,6 +467,7 @@ class PrinterHelpers(Printer):
             'struct tcp_sock',
             'struct tcp_timewait_sock',
             'struct tcp_request_sock',
+            'struct udp6_sock',
     }
     mapped_types =3D {
             'u8': '__u8',
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index e256417d94c2..3f4b12c5c563 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3276,6 +3276,12 @@ union bpf_attr {
  *		Dynamically cast a *sk* pointer to a *tcp_request_sock* pointer.
  *	Return
  *		*sk* if casting is valid, or NULL otherwise.
+ *
+ * struct udp6_sock *bpf_skc_to_udp6_sock(void *sk)
+ * 	Description
+ *		Dynamically cast a *sk* pointer to a *udp6_sock* pointer.
+ *	Return
+ *		*sk* if casting is valid, or NULL otherwise.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3417,7 +3423,8 @@ union bpf_attr {
 	FN(skc_to_tcp6_sock),		\
 	FN(skc_to_tcp_sock),		\
 	FN(skc_to_tcp_timewait_sock),	\
-	FN(skc_to_tcp_request_sock),
+	FN(skc_to_tcp_request_sock),	\
+	FN(skc_to_udp6_sock),
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
  * function eBPF program intends to call
--=20
2.24.1

