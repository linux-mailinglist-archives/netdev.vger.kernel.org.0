Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6AA833CAA0
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 02:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbhCPBO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 21:14:26 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19018 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234144AbhCPBN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 21:13:58 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12G1AoY7016477
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 18:13:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=59fQ5njcR1hbcPrWhwOrgktk6EH+diM/6uSSKnN6b9M=;
 b=K+9CSrYVYOSZOvF++0+2+eZCIRzW12zyy0kkHF8gDMv38AgZcSQBxw7wuvu5eNYEpwEF
 lpvU2M/tfujyONbvxMxZ6P4JePAJ+Fx96KzAQe0kQsBgG8TRVbBeNJL5DsYwYWFXj1jh
 kr7il6+uxUp/eSYofpuC9G3FjIHarrAoflw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 379e3ursre-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 18:13:58 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 15 Mar 2021 18:13:55 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 1C1EF2942B57; Mon, 15 Mar 2021 18:13:55 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 03/15] bpf: Refactor btf_check_func_arg_match
Date:   Mon, 15 Mar 2021 18:13:55 -0700
Message-ID: <20210316011355.4176313-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210316011336.4173585-1-kafai@fb.com>
References: <20210316011336.4173585-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-15_15:2021-03-15,2021-03-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 impostorscore=0
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 spamscore=0 mlxscore=0
 mlxlogscore=723 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103160005
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch refactors the core logic of "btf_check_func_arg_match()"
into a new function "do_btf_check_func_arg_match()".
"do_btf_check_func_arg_match()" will be reused later to check
the kernel function call.

The "if (!btf_type_is_ptr(t))" is checked first to improve the indentatio=
n
which will be useful for a later patch.

Some of the "btf_kind_str[]" usages is replaced with the shortcut
"btf_type_str(t)".

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/btf.h |   5 ++
 kernel/bpf/btf.c    | 159 ++++++++++++++++++++++++--------------------
 2 files changed, 91 insertions(+), 73 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 7fabf1428093..93bf2e5225f5 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -140,6 +140,11 @@ static inline bool btf_type_is_enum(const struct btf=
_type *t)
 	return BTF_INFO_KIND(t->info) =3D=3D BTF_KIND_ENUM;
 }
=20
+static inline bool btf_type_is_scalar(const struct btf_type *t)
+{
+	return btf_type_is_int(t) || btf_type_is_enum(t);
+}
+
 static inline bool btf_type_is_typedef(const struct btf_type *t)
 {
 	return BTF_INFO_KIND(t->info) =3D=3D BTF_KIND_TYPEDEF;
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 96cd24020a38..529b94b601c6 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4381,7 +4381,7 @@ static u8 bpf_ctx_convert_map[] =3D {
 #undef BPF_LINK_TYPE
=20
 static const struct btf_member *
-btf_get_prog_ctx_type(struct bpf_verifier_log *log, struct btf *btf,
+btf_get_prog_ctx_type(struct bpf_verifier_log *log, const struct btf *bt=
f,
 		      const struct btf_type *t, enum bpf_prog_type prog_type,
 		      int arg)
 {
@@ -5366,122 +5366,135 @@ int btf_check_type_match(struct bpf_verifier_lo=
g *log, const struct bpf_prog *pr
 	return btf_check_func_type_match(log, btf1, t1, btf2, t2);
 }
=20
-/* Compare BTF of a function with given bpf_reg_state.
- * Returns:
- * EFAULT - there is a verifier bug. Abort verification.
- * EINVAL - there is a type mismatch or BTF is not available.
- * 0 - BTF matches with what bpf_reg_state expects.
- * Only PTR_TO_CTX and SCALAR_VALUE states are recognized.
- */
-int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog,
-			     struct bpf_reg_state *regs)
+static int do_btf_check_func_arg_match(struct bpf_verifier_env *env,
+				       const struct btf *btf, u32 func_id,
+				       struct bpf_reg_state *regs,
+				       bool ptr_to_mem_ok)
 {
 	struct bpf_verifier_log *log =3D &env->log;
-	struct bpf_prog *prog =3D env->prog;
-	struct btf *btf =3D prog->aux->btf;
-	const struct btf_param *args;
+	const char *func_name, *ref_tname;
 	const struct btf_type *t, *ref_t;
-	u32 i, nargs, btf_id, type_size;
-	const char *tname;
-	bool is_global;
-
-	if (!prog->aux->func_info)
-		return -EINVAL;
-
-	btf_id =3D prog->aux->func_info[subprog].type_id;
-	if (!btf_id)
-		return -EFAULT;
-
-	if (prog->aux->func_info_aux[subprog].unreliable)
-		return -EINVAL;
+	const struct btf_param *args;
+	u32 i, nargs;
=20
-	t =3D btf_type_by_id(btf, btf_id);
+	t =3D btf_type_by_id(btf, func_id);
 	if (!t || !btf_type_is_func(t)) {
 		/* These checks were already done by the verifier while loading
 		 * struct bpf_func_info
 		 */
-		bpf_log(log, "BTF of func#%d doesn't point to KIND_FUNC\n",
-			subprog);
+		bpf_log(log, "BTF of func_id %u doesn't point to KIND_FUNC\n",
+			func_id);
 		return -EFAULT;
 	}
-	tname =3D btf_name_by_offset(btf, t->name_off);
+	func_name =3D btf_name_by_offset(btf, t->name_off);
=20
 	t =3D btf_type_by_id(btf, t->type);
 	if (!t || !btf_type_is_func_proto(t)) {
-		bpf_log(log, "Invalid BTF of func %s\n", tname);
+		bpf_log(log, "Invalid BTF of func %s\n", func_name);
 		return -EFAULT;
 	}
 	args =3D (const struct btf_param *)(t + 1);
 	nargs =3D btf_type_vlen(t);
 	if (nargs > MAX_BPF_FUNC_REG_ARGS) {
-		bpf_log(log, "Function %s has %d > %d args\n", tname, nargs,
+		bpf_log(log, "Function %s has %d > %d args\n", func_name, nargs,
 			MAX_BPF_FUNC_REG_ARGS);
-		goto out;
+		return -EINVAL;
 	}
=20
-	is_global =3D prog->aux->func_info_aux[subprog].linkage =3D=3D BTF_FUNC=
_GLOBAL;
 	/* check that BTF function arguments match actual types that the
 	 * verifier sees.
 	 */
 	for (i =3D 0; i < nargs; i++) {
-		struct bpf_reg_state *reg =3D &regs[i + 1];
+		u32 regno =3D i + 1;
+		struct bpf_reg_state *reg =3D &regs[regno];
=20
-		t =3D btf_type_by_id(btf, args[i].type);
-		while (btf_type_is_modifier(t))
-			t =3D btf_type_by_id(btf, t->type);
-		if (btf_type_is_int(t) || btf_type_is_enum(t)) {
+		t =3D btf_type_skip_modifiers(btf, args[i].type, NULL);
+		if (btf_type_is_scalar(t)) {
 			if (reg->type =3D=3D SCALAR_VALUE)
 				continue;
-			bpf_log(log, "R%d is not a scalar\n", i + 1);
-			goto out;
+			bpf_log(log, "R%d is not a scalar\n", regno);
+			return -EINVAL;
 		}
-		if (btf_type_is_ptr(t)) {
+
+		if (!btf_type_is_ptr(t)) {
+			bpf_log(log, "Unrecognized arg#%d type %s\n",
+				i, btf_type_str(t));
+			return -EINVAL;
+		}
+
+		ref_t =3D btf_type_skip_modifiers(btf, t->type, NULL);
+		ref_tname =3D btf_name_by_offset(btf, ref_t->name_off);
+		if (btf_get_prog_ctx_type(log, btf, t, env->prog->type, i)) {
 			/* If function expects ctx type in BTF check that caller
 			 * is passing PTR_TO_CTX.
 			 */
-			if (btf_get_prog_ctx_type(log, btf, t, prog->type, i)) {
-				if (reg->type !=3D PTR_TO_CTX) {
-					bpf_log(log,
-						"arg#%d expected pointer to ctx, but got %s\n",
-						i, btf_kind_str[BTF_INFO_KIND(t->info)]);
-					goto out;
-				}
-				if (check_ctx_reg(env, reg, i + 1))
-					goto out;
-				continue;
+			if (reg->type !=3D PTR_TO_CTX) {
+				bpf_log(log,
+					"arg#%d expected pointer to ctx, but got %s\n",
+					i, btf_type_str(t));
+				return -EINVAL;
 			}
+			if (check_ctx_reg(env, reg, regno))
+				return -EINVAL;
+		} else if (ptr_to_mem_ok) {
+			const struct btf_type *resolve_ret;
+			u32 type_size;
=20
-			if (!is_global)
-				goto out;
-
-			t =3D btf_type_skip_modifiers(btf, t->type, NULL);
-
-			ref_t =3D btf_resolve_size(btf, t, &type_size);
-			if (IS_ERR(ref_t)) {
+			resolve_ret =3D btf_resolve_size(btf, ref_t, &type_size);
+			if (IS_ERR(resolve_ret)) {
 				bpf_log(log,
-				    "arg#%d reference type('%s %s') size cannot be determined: %ld\n=
",
-				    i, btf_type_str(t), btf_name_by_offset(btf, t->name_off),
-					PTR_ERR(ref_t));
-				goto out;
+					"arg#%d reference type('%s %s') size cannot be determined: %ld\n",
+					i, btf_type_str(ref_t), ref_tname,
+					PTR_ERR(resolve_ret));
+				return -EINVAL;
 			}
=20
-			if (check_mem_reg(env, reg, i + 1, type_size))
-				goto out;
-
-			continue;
+			if (check_mem_reg(env, reg, regno, type_size))
+				return -EINVAL;
+		} else {
+			return -EINVAL;
 		}
-		bpf_log(log, "Unrecognized arg#%d type %s\n",
-			i, btf_kind_str[BTF_INFO_KIND(t->info)]);
-		goto out;
 	}
+
 	return 0;
-out:
+}
+
+/* Compare BTF of a function with given bpf_reg_state.
+ * Returns:
+ * EFAULT - there is a verifier bug. Abort verification.
+ * EINVAL - there is a type mismatch or BTF is not available.
+ * 0 - BTF matches with what bpf_reg_state expects.
+ * Only PTR_TO_CTX and SCALAR_VALUE states are recognized.
+ */
+int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog,
+			     struct bpf_reg_state *regs)
+{
+	struct bpf_prog *prog =3D env->prog;
+	struct btf *btf =3D prog->aux->btf;
+	bool is_global;
+	u32 btf_id;
+	int err;
+
+	if (!prog->aux->func_info)
+		return -EINVAL;
+
+	btf_id =3D prog->aux->func_info[subprog].type_id;
+	if (!btf_id)
+		return -EFAULT;
+
+	if (prog->aux->func_info_aux[subprog].unreliable)
+		return -EINVAL;
+
+	is_global =3D prog->aux->func_info_aux[subprog].linkage =3D=3D BTF_FUNC=
_GLOBAL;
+	err =3D do_btf_check_func_arg_match(env, btf, btf_id, regs, is_global);
+
 	/* Compiler optimizations can remove arguments from static functions
 	 * or mismatched type can be passed into a global function.
 	 * In such cases mark the function as unreliable from BTF point of view=
.
 	 */
-	prog->aux->func_info_aux[subprog].unreliable =3D true;
-	return -EINVAL;
+	if (err =3D=3D -EINVAL)
+		prog->aux->func_info_aux[subprog].unreliable =3D true;
+	return err;
 }
=20
 /* Convert BTF of a function into bpf_reg_state if possible
--=20
2.30.2

