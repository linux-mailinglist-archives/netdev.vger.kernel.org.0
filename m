Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E541273BDF
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 09:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729928AbgIVHag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 03:30:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3254 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729634AbgIVHag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 03:30:36 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08M70Ssg027093
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:04:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=b87LFKB9oXD1o+48K/Vts7Vqt8hDS99xVwCbZz5b+rE=;
 b=W0BytDzuLDq/ozYXafnTCLBF92/oq9RPLe96AVYy/8l++A0URtxusLaK/9gOtSSPxZiX
 3LcTYH2njsSq0y8ZZ6/6sGnHKwMDvF7IyDdqrAlhhWrkjwZNuary9hFY55w2+c3vf/6/
 HUG2NqK7SW+40D1xMhmv5xAZAZSw0Z3/8Po= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33p1g9sc9u-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:04:33 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 22 Sep 2020 00:04:31 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 5D778294641C; Tue, 22 Sep 2020 00:04:28 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>, <netdev@vger.kernel.org>
Subject: [PATCH v3 bpf-next 03/11] bpf: Change bpf_sk_release and bpf_sk_*cgroup_id to accept ARG_PTR_TO_BTF_ID_SOCK_COMMON
Date:   Tue, 22 Sep 2020 00:04:28 -0700
Message-ID: <20200922070428.1917972-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200922070409.1914988-1-kafai@fb.com>
References: <20200922070409.1914988-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-22_05:2020-09-21,2020-09-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 suspectscore=13 clxscore=1015 phishscore=0 mlxlogscore=933 adultscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009220056
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous patch allows the networking bpf prog to use the
bpf_skc_to_*() helpers to get a PTR_TO_BTF_ID socket pointer,
e.g. "struct tcp_sock *".  It allows the bpf prog to read all the
fields of the tcp_sock.

This patch changes the bpf_sk_release() and bpf_sk_*cgroup_id()
to take ARG_PTR_TO_BTF_ID_SOCK_COMMON such that they will
work with the pointer returned by the bpf_skc_to_*() helpers
also.  For example, the following will work:

	sk =3D bpf_skc_lookup_tcp(skb, tuple, tuplen, BPF_F_CURRENT_NETNS, 0);
	if (!sk)
		return;
	tp =3D bpf_skc_to_tcp_sock(sk);
	if (!tp) {
		bpf_sk_release(sk);
		return;
	}
	lsndtime =3D tp->lsndtime;
	/* Pass tp to bpf_sk_release() will also work */
	bpf_sk_release(tp);

Since PTR_TO_BTF_ID could be NULL, the helper taking
ARG_PTR_TO_BTF_ID_SOCK_COMMON has to check for NULL at runtime.

A btf_id of "struct sock" may not always mean a fullsock.  Regardless
the helper's running context may get a non-fullsock or not,
considering fullsock check/handling is pretty cheap, it is better to
keep the same verifier expectation on helper that takes ARG_PTR_TO_BTF_ID=
*
will be able to handle the minisock situation.  In the bpf_sk_*cgroup_id(=
)
case,  it will try to get a fullsock by using sk_to_full_sk() as its
skb variant bpf_sk"b"_*cgroup_id() has already been doing.

bpf_sk_release can already handle minisock, so nothing special has to
be done.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/core/filter.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 54b338de4bb8..532a85894ce0 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4088,18 +4088,17 @@ static inline u64 __bpf_sk_cgroup_id(struct sock =
*sk)
 {
 	struct cgroup *cgrp;
=20
+	sk =3D sk_to_full_sk(sk);
+	if (!sk || !sk_fullsock(sk))
+		return 0;
+
 	cgrp =3D sock_cgroup_ptr(&sk->sk_cgrp_data);
 	return cgroup_id(cgrp);
 }
=20
 BPF_CALL_1(bpf_skb_cgroup_id, const struct sk_buff *, skb)
 {
-	struct sock *sk =3D skb_to_full_sk(skb);
-
-	if (!sk || !sk_fullsock(sk))
-		return 0;
-
-	return __bpf_sk_cgroup_id(sk);
+	return __bpf_sk_cgroup_id(skb->sk);
 }
=20
 static const struct bpf_func_proto bpf_skb_cgroup_id_proto =3D {
@@ -4115,6 +4114,10 @@ static inline u64 __bpf_sk_ancestor_cgroup_id(stru=
ct sock *sk,
 	struct cgroup *ancestor;
 	struct cgroup *cgrp;
=20
+	sk =3D sk_to_full_sk(sk);
+	if (!sk || !sk_fullsock(sk))
+		return 0;
+
 	cgrp =3D sock_cgroup_ptr(&sk->sk_cgrp_data);
 	ancestor =3D cgroup_ancestor(cgrp, ancestor_level);
 	if (!ancestor)
@@ -4126,12 +4129,7 @@ static inline u64 __bpf_sk_ancestor_cgroup_id(stru=
ct sock *sk,
 BPF_CALL_2(bpf_skb_ancestor_cgroup_id, const struct sk_buff *, skb, int,
 	   ancestor_level)
 {
-	struct sock *sk =3D skb_to_full_sk(skb);
-
-	if (!sk || !sk_fullsock(sk))
-		return 0;
-
-	return __bpf_sk_ancestor_cgroup_id(sk, ancestor_level);
+	return __bpf_sk_ancestor_cgroup_id(skb->sk, ancestor_level);
 }
=20
 static const struct bpf_func_proto bpf_skb_ancestor_cgroup_id_proto =3D =
{
@@ -4151,7 +4149,8 @@ static const struct bpf_func_proto bpf_sk_cgroup_id=
_proto =3D {
 	.func           =3D bpf_sk_cgroup_id,
 	.gpl_only       =3D false,
 	.ret_type       =3D RET_INTEGER,
-	.arg1_type      =3D ARG_PTR_TO_SOCKET,
+	.arg1_type      =3D ARG_PTR_TO_BTF_ID_SOCK_COMMON,
+	.arg1_btf_id	=3D &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
 };
=20
 BPF_CALL_2(bpf_sk_ancestor_cgroup_id, struct sock *, sk, int, ancestor_l=
evel)
@@ -4163,7 +4162,8 @@ static const struct bpf_func_proto bpf_sk_ancestor_=
cgroup_id_proto =3D {
 	.func           =3D bpf_sk_ancestor_cgroup_id,
 	.gpl_only       =3D false,
 	.ret_type       =3D RET_INTEGER,
-	.arg1_type      =3D ARG_PTR_TO_SOCKET,
+	.arg1_type      =3D ARG_PTR_TO_BTF_ID_SOCK_COMMON,
+	.arg1_btf_id	=3D &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
 	.arg2_type      =3D ARG_ANYTHING,
 };
 #endif
@@ -5696,7 +5696,7 @@ static const struct bpf_func_proto bpf_sk_lookup_ud=
p_proto =3D {
=20
 BPF_CALL_1(bpf_sk_release, struct sock *, sk)
 {
-	if (sk_is_refcounted(sk))
+	if (sk && sk_is_refcounted(sk))
 		sock_gen_put(sk);
 	return 0;
 }
@@ -5705,7 +5705,8 @@ static const struct bpf_func_proto bpf_sk_release_p=
roto =3D {
 	.func		=3D bpf_sk_release,
 	.gpl_only	=3D false,
 	.ret_type	=3D RET_INTEGER,
-	.arg1_type	=3D ARG_PTR_TO_SOCK_COMMON,
+	.arg1_type	=3D ARG_PTR_TO_BTF_ID_SOCK_COMMON,
+	.arg1_btf_id	=3D &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
 };
=20
 BPF_CALL_5(bpf_xdp_sk_lookup_udp, struct xdp_buff *, ctx,
--=20
2.24.1

