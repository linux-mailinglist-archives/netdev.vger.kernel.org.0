Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0F0273BC4
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 09:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729901AbgIVH0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 03:26:42 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38338 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729748AbgIVH0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 03:26:41 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08M71MlP025782
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:04:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ZFwgdL5Rn4+8Dp1i92WScd8mvmnt9RcB5gxi9akNFFU=;
 b=Uo2GsOHqe7SXFT7sbJ72a6xO2uZB+2qKFkTdzW1oL1DpW1bIWA+rs+G1cq5tLt43SWna
 nJssW/+qryJfyQQmcxQm43H1fvvF806r4JGKmL1CXwEGkNqGHPteuqw+T0vseIVhEztN
 IuIn0kGf4m2sVBLyRRtjHMLkWjQpsu7n2Yk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33p226hbqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:04:39 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 22 Sep 2020 00:04:37 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 9B34E294641C; Tue, 22 Sep 2020 00:04:34 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>, <netdev@vger.kernel.org>
Subject: [PATCH v3 bpf-next 04/11] bpf: Change bpf_sk_storage_*() to accept ARG_PTR_TO_BTF_ID_SOCK_COMMON
Date:   Tue, 22 Sep 2020 00:04:34 -0700
Message-ID: <20200922070434.1919082-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200922070409.1914988-1-kafai@fb.com>
References: <20200922070409.1914988-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-22_05:2020-09-21,2020-09-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 mlxscore=0
 phishscore=0 priorityscore=1501 adultscore=0 malwarescore=0
 suspectscore=38 spamscore=0 impostorscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220056
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch changes the bpf_sk_storage_*() to take
ARG_PTR_TO_BTF_ID_SOCK_COMMON such that they will work with the pointer
returned by the bpf_skc_to_*() helpers also.

A micro benchmark has been done on a "cgroup_skb/egress" bpf program
which does a bpf_sk_storage_get().  It was driven by netperf doing
a 4096 connected UDP_STREAM test with 64bytes packet.
The stats from "kernel.bpf_stats_enabled" shows no meaningful difference.

The sk_storage_get_btf_proto, sk_storage_delete_btf_proto,
btf_sk_storage_get_proto, and btf_sk_storage_delete_proto are
no longer needed, so they are removed.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/net/bpf_sk_storage.h   |  2 --
 include/uapi/linux/bpf.h       |  1 +
 kernel/bpf/bpf_lsm.c           |  4 ++--
 net/core/bpf_sk_storage.c      | 31 ++++++++-----------------------
 net/ipv4/bpf_tcp_ca.c          | 23 ++---------------------
 tools/include/uapi/linux/bpf.h |  1 +
 6 files changed, 14 insertions(+), 48 deletions(-)

diff --git a/include/net/bpf_sk_storage.h b/include/net/bpf_sk_storage.h
index 119f4c9c3a9c..3c516dd07caf 100644
--- a/include/net/bpf_sk_storage.h
+++ b/include/net/bpf_sk_storage.h
@@ -20,8 +20,6 @@ void bpf_sk_storage_free(struct sock *sk);
=20
 extern const struct bpf_func_proto bpf_sk_storage_get_proto;
 extern const struct bpf_func_proto bpf_sk_storage_delete_proto;
-extern const struct bpf_func_proto sk_storage_get_btf_proto;
-extern const struct bpf_func_proto sk_storage_delete_btf_proto;
=20
 struct bpf_local_storage_elem;
 struct bpf_sk_storage_diag;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a22812561064..1634ca9b752a 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2861,6 +2861,7 @@ union bpf_attr {
  *		0 on success.
  *
  *		**-ENOENT** if the bpf-local-storage cannot be found.
+ *		**-EINVAL** if sk is not a fullsock (e.g. a request_sock).
  *
  * long bpf_send_signal(u32 sig)
  *	Description
diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 9cd1428c7199..78ea8a7bd27f 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -56,9 +56,9 @@ bpf_lsm_func_proto(enum bpf_func_id func_id, const stru=
ct bpf_prog *prog)
 	case BPF_FUNC_inode_storage_delete:
 		return &bpf_inode_storage_delete_proto;
 	case BPF_FUNC_sk_storage_get:
-		return &sk_storage_get_btf_proto;
+		return &bpf_sk_storage_get_proto;
 	case BPF_FUNC_sk_storage_delete:
-		return &sk_storage_delete_btf_proto;
+		return &bpf_sk_storage_delete_proto;
 	default:
 		return tracing_prog_func_proto(func_id, prog);
 	}
diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index 838efc682cff..aa39e9676050 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -269,7 +269,7 @@ BPF_CALL_4(bpf_sk_storage_get, struct bpf_map *, map,=
 struct sock *, sk,
 {
 	struct bpf_local_storage_data *sdata;
=20
-	if (flags > BPF_SK_STORAGE_GET_F_CREATE)
+	if (!sk || !sk_fullsock(sk) || flags > BPF_SK_STORAGE_GET_F_CREATE)
 		return (unsigned long)NULL;
=20
 	sdata =3D sk_storage_lookup(sk, map, true);
@@ -299,6 +299,9 @@ BPF_CALL_4(bpf_sk_storage_get, struct bpf_map *, map,=
 struct sock *, sk,
=20
 BPF_CALL_2(bpf_sk_storage_delete, struct bpf_map *, map, struct sock *, =
sk)
 {
+	if (!sk || !sk_fullsock(sk))
+		return -EINVAL;
+
 	if (refcount_inc_not_zero(&sk->sk_refcnt)) {
 		int err;
=20
@@ -355,7 +358,8 @@ const struct bpf_func_proto bpf_sk_storage_get_proto =
=3D {
 	.gpl_only	=3D false,
 	.ret_type	=3D RET_PTR_TO_MAP_VALUE_OR_NULL,
 	.arg1_type	=3D ARG_CONST_MAP_PTR,
-	.arg2_type	=3D ARG_PTR_TO_SOCKET,
+	.arg2_type	=3D ARG_PTR_TO_BTF_ID_SOCK_COMMON,
+	.arg2_btf_id	=3D &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
 	.arg3_type	=3D ARG_PTR_TO_MAP_VALUE_OR_NULL,
 	.arg4_type	=3D ARG_ANYTHING,
 };
@@ -375,27 +379,8 @@ const struct bpf_func_proto bpf_sk_storage_delete_pr=
oto =3D {
 	.gpl_only	=3D false,
 	.ret_type	=3D RET_INTEGER,
 	.arg1_type	=3D ARG_CONST_MAP_PTR,
-	.arg2_type	=3D ARG_PTR_TO_SOCKET,
-};
-
-const struct bpf_func_proto sk_storage_get_btf_proto =3D {
-	.func		=3D bpf_sk_storage_get,
-	.gpl_only	=3D false,
-	.ret_type	=3D RET_PTR_TO_MAP_VALUE_OR_NULL,
-	.arg1_type	=3D ARG_CONST_MAP_PTR,
-	.arg2_type	=3D ARG_PTR_TO_BTF_ID,
-	.arg2_btf_id	=3D &btf_sock_ids[BTF_SOCK_TYPE_SOCK],
-	.arg3_type	=3D ARG_PTR_TO_MAP_VALUE_OR_NULL,
-	.arg4_type	=3D ARG_ANYTHING,
-};
-
-const struct bpf_func_proto sk_storage_delete_btf_proto =3D {
-	.func		=3D bpf_sk_storage_delete,
-	.gpl_only	=3D false,
-	.ret_type	=3D RET_INTEGER,
-	.arg1_type	=3D ARG_CONST_MAP_PTR,
-	.arg2_type	=3D ARG_PTR_TO_BTF_ID,
-	.arg2_btf_id	=3D &btf_sock_ids[BTF_SOCK_TYPE_SOCK],
+	.arg2_type	=3D ARG_PTR_TO_BTF_ID_SOCK_COMMON,
+	.arg2_btf_id	=3D &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
 };
=20
 struct bpf_sk_storage_diag {
diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index 74a2ef598c31..618954f82764 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -28,22 +28,6 @@ static u32 unsupported_ops[] =3D {
 static const struct btf_type *tcp_sock_type;
 static u32 tcp_sock_id, sock_id;
=20
-static struct bpf_func_proto btf_sk_storage_get_proto __read_mostly;
-static struct bpf_func_proto btf_sk_storage_delete_proto __read_mostly;
-
-static void convert_sk_func_proto(struct bpf_func_proto *to, const struc=
t bpf_func_proto *from)
-{
-	int i;
-
-	*to =3D *from;
-	for (i =3D 0; i < ARRAY_SIZE(to->arg_type); i++) {
-		if (to->arg_type[i] =3D=3D ARG_PTR_TO_SOCKET) {
-			to->arg_type[i] =3D ARG_PTR_TO_BTF_ID;
-			to->arg_btf_id[i] =3D &tcp_sock_id;
-		}
-	}
-}
-
 static int bpf_tcp_ca_init(struct btf *btf)
 {
 	s32 type_id;
@@ -59,9 +43,6 @@ static int bpf_tcp_ca_init(struct btf *btf)
 	tcp_sock_id =3D type_id;
 	tcp_sock_type =3D btf_type_by_id(btf, tcp_sock_id);
=20
-	convert_sk_func_proto(&btf_sk_storage_get_proto, &bpf_sk_storage_get_pr=
oto);
-	convert_sk_func_proto(&btf_sk_storage_delete_proto, &bpf_sk_storage_del=
ete_proto);
-
 	return 0;
 }
=20
@@ -188,9 +169,9 @@ bpf_tcp_ca_get_func_proto(enum bpf_func_id func_id,
 	case BPF_FUNC_tcp_send_ack:
 		return &bpf_tcp_send_ack_proto;
 	case BPF_FUNC_sk_storage_get:
-		return &btf_sk_storage_get_proto;
+		return &bpf_sk_storage_get_proto;
 	case BPF_FUNC_sk_storage_delete:
-		return &btf_sk_storage_delete_proto;
+		return &bpf_sk_storage_delete_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index a22812561064..1634ca9b752a 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2861,6 +2861,7 @@ union bpf_attr {
  *		0 on success.
  *
  *		**-ENOENT** if the bpf-local-storage cannot be found.
+ *		**-EINVAL** if sk is not a fullsock (e.g. a request_sock).
  *
  * long bpf_send_signal(u32 sig)
  *	Description
--=20
2.24.1

