Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49AC292EAD
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 21:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731343AbgJSTop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 15:44:45 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4338 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731325AbgJSTnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 15:43:07 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09JJh5xG013084
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 12:43:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=nRTRnVV23/hgDHMf8uKxDVRGLfawh+dD8m9mZng5Yl0=;
 b=p5UT42tSYyLpLJUnGcQU7XjNlzgsJOioIsysFr2KYGCHH4h4ENUGz4iNyyasFq+zoK3D
 m2n7rM4jkNvhHNYbC6gARZp/RQWWurxs4NrJrCuEocEIimjrAXq6BpLnZsWMonoIZI9i
 yAMSubyFAykR6kZr4QPzwnkQsPQfMrIkers= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 348gekprg4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 12:43:06 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 19 Oct 2020 12:42:27 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id E51DB2946269; Mon, 19 Oct 2020 12:42:12 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hao Luo <haoluo@google.com>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf 1/3] bpf: Enforce id generation for all may-be-null register type
Date:   Mon, 19 Oct 2020 12:42:12 -0700
Message-ID: <20201019194212.1050855-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201019194206.1050591-1-kafai@fb.com>
References: <20201019194206.1050591-1-kafai@fb.com>
MIME-Version: 1.0
X-FB-Internal: Safe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-19_10:2020-10-16,2020-10-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 phishscore=0 spamscore=0 bulkscore=0 priorityscore=1501 suspectscore=13
 mlxscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=872 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010190133
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit af7ec1383361 ("bpf: Add bpf_skc_to_tcp6_sock() helper")
introduces RET_PTR_TO_BTF_ID_OR_NULL and
the commit eaa6bcb71ef6 ("bpf: Introduce bpf_per_cpu_ptr()")
introduces RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL.
Note that for RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL, the reg0->type
could become PTR_TO_MEM_OR_NULL which is not covered by
BPF_PROBE_MEM.

The BPF_REG_0 will then hold a _OR_NULL pointer type. This _OR_NULL
pointer type requires the bpf program to explicitly do a NULL check first=
.
After NULL check, the verifier will mark all registers having
the same reg->id as safe to use.  However, the reg->id
is not set for those new _OR_NULL return types.  One of the ways
that may be wrong is, checking NULL for one btf_id typed pointer will
end up validating all other btf_id typed pointers because
all of them have id =3D=3D 0.  The later tests will exercise
this path.

To fix it and also avoid similar issue in the future, this patch
moves the id generation logic out of each individual RET type
test in check_helper_call().  Instead, it does one
reg_type_may_be_null() test and then do the id generation
if needed.

This patch also adds a WARN_ON_ONCE in mark_ptr_or_null_reg()
to catch future breakage.

The _OR_NULL pointer usage in the bpf_iter_reg.ctx_arg_info is
fine because it just happens that the existing id generation after
check_ctx_access() has covered it.  It is also using the
reg_type_may_be_null() to decide if id generation is needed or not.

Fixes: af7ec1383361 ("bpf: Add bpf_skc_to_tcp6_sock() helper")
Fixes: eaa6bcb71ef6 ("bpf: Introduce bpf_per_cpu_ptr()")
Cc: Yonghong Song <yhs@fb.com>
Cc: Hao Luo <haoluo@google.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 kernel/bpf/verifier.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 39d7f44e7c92..6200519582a6 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5133,24 +5133,19 @@ static int check_helper_call(struct bpf_verifier_=
env *env, int func_id, int insn
 				regs[BPF_REG_0].id =3D ++env->id_gen;
 		} else {
 			regs[BPF_REG_0].type =3D PTR_TO_MAP_VALUE_OR_NULL;
-			regs[BPF_REG_0].id =3D ++env->id_gen;
 		}
 	} else if (fn->ret_type =3D=3D RET_PTR_TO_SOCKET_OR_NULL) {
 		mark_reg_known_zero(env, regs, BPF_REG_0);
 		regs[BPF_REG_0].type =3D PTR_TO_SOCKET_OR_NULL;
-		regs[BPF_REG_0].id =3D ++env->id_gen;
 	} else if (fn->ret_type =3D=3D RET_PTR_TO_SOCK_COMMON_OR_NULL) {
 		mark_reg_known_zero(env, regs, BPF_REG_0);
 		regs[BPF_REG_0].type =3D PTR_TO_SOCK_COMMON_OR_NULL;
-		regs[BPF_REG_0].id =3D ++env->id_gen;
 	} else if (fn->ret_type =3D=3D RET_PTR_TO_TCP_SOCK_OR_NULL) {
 		mark_reg_known_zero(env, regs, BPF_REG_0);
 		regs[BPF_REG_0].type =3D PTR_TO_TCP_SOCK_OR_NULL;
-		regs[BPF_REG_0].id =3D ++env->id_gen;
 	} else if (fn->ret_type =3D=3D RET_PTR_TO_ALLOC_MEM_OR_NULL) {
 		mark_reg_known_zero(env, regs, BPF_REG_0);
 		regs[BPF_REG_0].type =3D PTR_TO_MEM_OR_NULL;
-		regs[BPF_REG_0].id =3D ++env->id_gen;
 		regs[BPF_REG_0].mem_size =3D meta.mem_size;
 	} else if (fn->ret_type =3D=3D RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL ||
 		   fn->ret_type =3D=3D RET_PTR_TO_MEM_OR_BTF_ID) {
@@ -5199,6 +5194,9 @@ static int check_helper_call(struct bpf_verifier_en=
v *env, int func_id, int insn
 		return -EINVAL;
 	}
=20
+	if (reg_type_may_be_null(regs[BPF_REG_0].type))
+		regs[BPF_REG_0].id =3D ++env->id_gen;
+
 	if (is_ptr_cast_function(func_id)) {
 		/* For release_reference() */
 		regs[BPF_REG_0].ref_obj_id =3D meta.ref_obj_id;
@@ -7212,7 +7210,8 @@ static void mark_ptr_or_null_reg(struct bpf_func_st=
ate *state,
 				 struct bpf_reg_state *reg, u32 id,
 				 bool is_null)
 {
-	if (reg_type_may_be_null(reg->type) && reg->id =3D=3D id) {
+	if (reg_type_may_be_null(reg->type) && reg->id =3D=3D id &&
+	    !WARN_ON_ONCE(!reg->id)) {
 		/* Old offset (both fixed and variable parts) should
 		 * have been known-zero, because we don't allow pointer
 		 * arithmetic on pointers that might be NULL.
--=20
2.24.1

