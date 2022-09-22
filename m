Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5AD85E6FFE
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 00:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbiIVW5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 18:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbiIVW47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 18:56:59 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDB21138F8
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 15:56:56 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MKiT0g013235
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 15:56:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=I6mE5Nuvw1CCKlFjYO5v8nXq6zIBUNfcRxIn1vznMQA=;
 b=djeLTeuLwo9JehQCGslUUR2VHyTAw6QT2iYbqwdxWwPJxYO+Kwjz+B5jfxs/UP7+DOJk
 Ya5hE8ISgUxN3JsVng8EHkjbHmwvoopYSvzIFxjDrqrO67mYtoUfe8WEa/swH0WpHcgC
 GCJ16i8Xtp7XM2o9fIfFSoYJ+GmJYZ4bsrs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jr6s3twre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 15:56:55 -0700
Received: from twshared20273.14.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 15:56:54 -0700
Received: by devbig933.frc1.facebook.com (Postfix, from userid 6611)
        id C35B5999DE97; Thu, 22 Sep 2022 15:56:42 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Martin KaFai Lau <martin.lau@kernel.org>
Subject: [PATCH bpf-next 4/5] bpf: Stop bpf_setsockopt(TCP_CONGESTION) in init ops to recur itself
Date:   Thu, 22 Sep 2022 15:56:42 -0700
Message-ID: <20220922225642.3058176-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220922225616.3054840-1-kafai@fb.com>
References: <20220922225616.3054840-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: jyF6ZMna8JMqItWBbAB9AFQx7wNRWgF9
X-Proofpoint-GUID: jyF6ZMna8JMqItWBbAB9AFQx7wNRWgF9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_15,2022-09-22_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <martin.lau@kernel.org>

When a bad bpf prog '.init' calls
bpf_setsockopt(TCP_CONGESTION, "itself"), it will trigger this loop:

.init =3D> bpf_setsockopt(tcp_cc) =3D> .init =3D> bpf_setsockopt(tcp_cc) =
...
... =3D> .init =3D> bpf_setsockopt(tcp_cc).

It was prevented by the prog->active counter before but the prog->active
detection cannot be used in struct_ops as explained in the earlier
patch of the set.

In this patch, the second bpf_setsockopt(tcp_cc) is not allowed
in order to break the loop.  This is done by checking the
previous bpf_run_ctx has saved the same sk pointer in the
bpf_cookie.

Note that this essentially limits only the first '.init' can
call bpf_setsockopt(TCP_CONGESTION) to pick a fallback cc (eg. peer
does not support ECN) and the second '.init' cannot fallback to
another cc.  This applies even the second
bpf_setsockopt(TCP_CONGESTION) will not cause a loop.

Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
---
 include/linux/filter.h |  3 +++
 net/core/filter.c      |  4 ++--
 net/ipv4/bpf_tcp_ca.c  | 54 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 98e28126c24b..9942ecc68a45 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -911,6 +911,9 @@ int sk_get_filter(struct sock *sk, sockptr_t optval, =
unsigned int len);
 bool sk_filter_charge(struct sock *sk, struct sk_filter *fp);
 void sk_filter_uncharge(struct sock *sk, struct sk_filter *fp);
=20
+int _bpf_setsockopt(struct sock *sk, int level, int optname,
+		    char *optval, int optlen);
+
 u64 __bpf_call_base(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
 #define __bpf_call_base_args \
 	((u64 (*)(u64, u64, u64, u64, u64, const struct bpf_insn *)) \
diff --git a/net/core/filter.c b/net/core/filter.c
index f4cea3ff994a..e56a1ebcf1bc 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5244,8 +5244,8 @@ static int __bpf_setsockopt(struct sock *sk, int le=
vel, int optname,
 	return -EINVAL;
 }
=20
-static int _bpf_setsockopt(struct sock *sk, int level, int optname,
-			   char *optval, int optlen)
+int _bpf_setsockopt(struct sock *sk, int level, int optname,
+		    char *optval, int optlen)
 {
 	if (sk_fullsock(sk))
 		sock_owned_by_me(sk);
diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index 6da16ae6a962..a9f2cab5ffbc 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -144,6 +144,57 @@ static const struct bpf_func_proto bpf_tcp_send_ack_=
proto =3D {
 	.arg2_type	=3D ARG_ANYTHING,
 };
=20
+BPF_CALL_5(bpf_init_ops_setsockopt, struct sock *, sk, int, level,
+	   int, optname, char *, optval, int, optlen)
+{
+	struct bpf_tramp_run_ctx *run_ctx, *saved_run_ctx;
+	int ret;
+
+	if (optname !=3D TCP_CONGESTION)
+		return _bpf_setsockopt(sk, level, optname, optval, optlen);
+
+	run_ctx =3D (struct bpf_tramp_run_ctx *)current->bpf_ctx;
+	if (unlikely(run_ctx->saved_run_ctx &&
+		     run_ctx->saved_run_ctx->type =3D=3D BPF_RUN_CTX_TYPE_STRUCT_OPS))=
 {
+		saved_run_ctx =3D (struct bpf_tramp_run_ctx *)run_ctx->saved_run_ctx;
+		/* It stops this looping
+		 *
+		 * .init =3D> bpf_setsockopt(tcp_cc) =3D> .init =3D>
+		 * bpf_setsockopt(tcp_cc)" =3D> .init =3D> ....
+		 *
+		 * The second bpf_setsockopt(tcp_cc) is not allowed
+		 * in order to break the loop when both .init
+		 * are the same bpf prog.
+		 *
+		 * This applies even the second bpf_setsockopt(tcp_cc)
+		 * does not cause a loop.  This limits only the first
+		 * '.init' can call bpf_setsockopt(TCP_CONGESTION) to
+		 * pick a fallback cc (eg. peer does not support ECN)
+		 * and the second '.init' cannot fallback to
+		 * another cc.
+		 */
+		if (saved_run_ctx->bpf_cookie =3D=3D (uintptr_t)sk)
+			return -EBUSY;
+	}
+
+	run_ctx->bpf_cookie =3D (uintptr_t)sk;
+	ret =3D _bpf_setsockopt(sk, level, optname, optval, optlen);
+	run_ctx->bpf_cookie =3D 0;
+
+	return ret;
+}
+
+static const struct bpf_func_proto bpf_init_ops_setsockopt_proto =3D {
+	.func		=3D bpf_init_ops_setsockopt,
+	.gpl_only	=3D false,
+	.ret_type	=3D RET_INTEGER,
+	.arg1_type	=3D ARG_PTR_TO_BTF_ID_SOCK_COMMON,
+	.arg2_type	=3D ARG_ANYTHING,
+	.arg3_type	=3D ARG_ANYTHING,
+	.arg4_type	=3D ARG_PTR_TO_MEM | MEM_RDONLY,
+	.arg5_type	=3D ARG_CONST_SIZE,
+};
+
 static u32 prog_ops_moff(const struct bpf_prog *prog)
 {
 	const struct btf_member *m;
@@ -169,6 +220,9 @@ bpf_tcp_ca_get_func_proto(enum bpf_func_id func_id,
 	case BPF_FUNC_sk_storage_delete:
 		return &bpf_sk_storage_delete_proto;
 	case BPF_FUNC_setsockopt:
+		if (prog_ops_moff(prog) =3D=3D
+		    offsetof(struct tcp_congestion_ops, init))
+			return &bpf_init_ops_setsockopt_proto;
 		/* Does not allow release() to call setsockopt.
 		 * release() is called when the current bpf-tcp-cc
 		 * is retiring.  It is not allowed to call
--=20
2.30.2

