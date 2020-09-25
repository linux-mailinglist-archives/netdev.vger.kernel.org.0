Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300BD277C99
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgIYAEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:04:04 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12720 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726807AbgIYAED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 20:04:03 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 08ONx67R013586
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 17:04:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=LU7bFKtCDSpcHI/YuDjyNxZk2+2opE+mwoXZbjnB8CA=;
 b=UhBUsK2iQQC7709uh0lQQidxQeQLnK7szvRYdvs+LSylJbWsiX7QzfEXyip5bl16HC29
 VcZKfIseRMaOSYhFJX5HsmNElvY3JBx+Zy6eqiNygdblsN6EzWxDpdIAr0f0phvK2Mdi
 HYPLw/UZSxhAodY07eT8K8RCPXzlQL77+L4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 33qsp54u69-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 17:04:01 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 24 Sep 2020 17:04:00 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 8DD562946606; Thu, 24 Sep 2020 17:03:56 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>, <netdev@vger.kernel.org>
Subject: [PATCH v4 bpf-next 03/13] bpf: Change bpf_sk_release and bpf_sk_*cgroup_id to accept ARG_PTR_TO_BTF_ID_SOCK_COMMON
Date:   Thu, 24 Sep 2020 17:03:56 -0700
Message-ID: <20200925000356.3856047-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200925000337.3853598-1-kafai@fb.com>
References: <20200925000337.3853598-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-24_18:2020-09-24,2020-09-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=13
 spamscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 mlxscore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009240174
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
 include/uapi/linux/bpf.h       |  8 ++++----
 net/core/filter.c              | 30 ++++++++++++++----------------
 tools/include/uapi/linux/bpf.h |  8 ++++----
 3 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a22812561064..c96a56d9c3be 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2512,7 +2512,7 @@ union bpf_attr {
  *		result is from *reuse*\ **->socks**\ [] using the hash of the
  *		tuple.
  *
- * long bpf_sk_release(struct bpf_sock *sock)
+ * long bpf_sk_release(void *sock)
  *	Description
  *		Release the reference held by *sock*. *sock* must be a
  *		non-**NULL** pointer that was returned from
@@ -3234,11 +3234,11 @@ union bpf_attr {
  *
  *		**-EOVERFLOW** if an overflow happened: The same object will be trie=
d again.
  *
- * u64 bpf_sk_cgroup_id(struct bpf_sock *sk)
+ * u64 bpf_sk_cgroup_id(void *sk)
  *	Description
  *		Return the cgroup v2 id of the socket *sk*.
  *
- *		*sk* must be a non-**NULL** pointer to a full socket, e.g. one
+ *		*sk* must be a non-**NULL** pointer to a socket, e.g. one
  *		returned from **bpf_sk_lookup_xxx**\ (),
  *		**bpf_sk_fullsock**\ (), etc. The format of returned id is
  *		same as in **bpf_skb_cgroup_id**\ ().
@@ -3248,7 +3248,7 @@ union bpf_attr {
  *	Return
  *		The id is returned or 0 in case the id could not be retrieved.
  *
- * u64 bpf_sk_ancestor_cgroup_id(struct bpf_sock *sk, int ancestor_level=
)
+ * u64 bpf_sk_ancestor_cgroup_id(void *sk, int ancestor_level)
  *	Description
  *		Return id of cgroup v2 that is ancestor of cgroup associated
  *		with the *sk* at the *ancestor_level*.  The root cgroup is at
diff --git a/net/core/filter.c b/net/core/filter.c
index 6d1864f2bd51..06d397eeef2a 100644
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
@@ -4151,7 +4149,7 @@ static const struct bpf_func_proto bpf_sk_cgroup_id=
_proto =3D {
 	.func           =3D bpf_sk_cgroup_id,
 	.gpl_only       =3D false,
 	.ret_type       =3D RET_INTEGER,
-	.arg1_type      =3D ARG_PTR_TO_SOCKET,
+	.arg1_type      =3D ARG_PTR_TO_BTF_ID_SOCK_COMMON,
 };
=20
 BPF_CALL_2(bpf_sk_ancestor_cgroup_id, struct sock *, sk, int, ancestor_l=
evel)
@@ -4163,7 +4161,7 @@ static const struct bpf_func_proto bpf_sk_ancestor_=
cgroup_id_proto =3D {
 	.func           =3D bpf_sk_ancestor_cgroup_id,
 	.gpl_only       =3D false,
 	.ret_type       =3D RET_INTEGER,
-	.arg1_type      =3D ARG_PTR_TO_SOCKET,
+	.arg1_type      =3D ARG_PTR_TO_BTF_ID_SOCK_COMMON,
 	.arg2_type      =3D ARG_ANYTHING,
 };
 #endif
@@ -5697,7 +5695,7 @@ static const struct bpf_func_proto bpf_sk_lookup_ud=
p_proto =3D {
=20
 BPF_CALL_1(bpf_sk_release, struct sock *, sk)
 {
-	if (sk_is_refcounted(sk))
+	if (sk && sk_is_refcounted(sk))
 		sock_gen_put(sk);
 	return 0;
 }
@@ -5706,7 +5704,7 @@ static const struct bpf_func_proto bpf_sk_release_p=
roto =3D {
 	.func		=3D bpf_sk_release,
 	.gpl_only	=3D false,
 	.ret_type	=3D RET_INTEGER,
-	.arg1_type	=3D ARG_PTR_TO_SOCK_COMMON,
+	.arg1_type	=3D ARG_PTR_TO_BTF_ID_SOCK_COMMON,
 };
=20
 BPF_CALL_5(bpf_xdp_sk_lookup_udp, struct xdp_buff *, ctx,
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index a22812561064..c96a56d9c3be 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2512,7 +2512,7 @@ union bpf_attr {
  *		result is from *reuse*\ **->socks**\ [] using the hash of the
  *		tuple.
  *
- * long bpf_sk_release(struct bpf_sock *sock)
+ * long bpf_sk_release(void *sock)
  *	Description
  *		Release the reference held by *sock*. *sock* must be a
  *		non-**NULL** pointer that was returned from
@@ -3234,11 +3234,11 @@ union bpf_attr {
  *
  *		**-EOVERFLOW** if an overflow happened: The same object will be trie=
d again.
  *
- * u64 bpf_sk_cgroup_id(struct bpf_sock *sk)
+ * u64 bpf_sk_cgroup_id(void *sk)
  *	Description
  *		Return the cgroup v2 id of the socket *sk*.
  *
- *		*sk* must be a non-**NULL** pointer to a full socket, e.g. one
+ *		*sk* must be a non-**NULL** pointer to a socket, e.g. one
  *		returned from **bpf_sk_lookup_xxx**\ (),
  *		**bpf_sk_fullsock**\ (), etc. The format of returned id is
  *		same as in **bpf_skb_cgroup_id**\ ().
@@ -3248,7 +3248,7 @@ union bpf_attr {
  *	Return
  *		The id is returned or 0 in case the id could not be retrieved.
  *
- * u64 bpf_sk_ancestor_cgroup_id(struct bpf_sock *sk, int ancestor_level=
)
+ * u64 bpf_sk_ancestor_cgroup_id(void *sk, int ancestor_level)
  *	Description
  *		Return id of cgroup v2 that is ancestor of cgroup associated
  *		with the *sk* at the *ancestor_level*.  The root cgroup is at
--=20
2.24.1

