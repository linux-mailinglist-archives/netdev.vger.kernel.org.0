Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEDBF69A01F
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 23:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjBPW40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 17:56:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjBPW4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 17:56:23 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA314FAA9
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 14:56:21 -0800 (PST)
Received: by devvm15675.prn0.facebook.com (Postfix, from userid 115148)
        id 17C176A5C837; Thu, 16 Feb 2023 14:56:07 -0800 (PST)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     martin.lau@kernel.org, andrii@kernel.org, memxor@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        kernel-team@fb.com, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH v10 bpf-next 3/9] bpf: Allow initializing dynptrs in kfuncs
Date:   Thu, 16 Feb 2023 14:55:18 -0800
Message-Id: <20230216225524.1192789-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230216225524.1192789-1-joannelkoong@gmail.com>
References: <20230216225524.1192789-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,HELO_MISC_IP,NML_ADSP_CUSTOM_MED,
        RDNS_DYNAMIC,SPF_HELO_PASS,SPF_SOFTFAIL,TVD_RCVD_IP autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change allows kfuncs to take in an uninitialized dynptr as a
parameter. Before this change, only helper functions could successfully
use uninitialized dynptrs. This change moves the memory access check
(including stack state growing and slot marking) into
process_dynptr_func(), which both helpers and kfuncs call into.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 kernel/bpf/verifier.c | 67 ++++++++++++++-----------------------------
 1 file changed, 22 insertions(+), 45 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 23a7749e8463..de99fa02b8d8 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -268,7 +268,6 @@ struct bpf_call_arg_meta {
 	u32 ret_btf_id;
 	u32 subprogno;
 	struct btf_field *kptr_field;
-	u8 uninit_dynptr_regno;
 };
=20
 struct btf *btf_vmlinux;
@@ -6216,10 +6215,11 @@ static int process_kptr_func(struct bpf_verifier_=
env *env, int regno,
  * Helpers which do not mutate the bpf_dynptr set MEM_RDONLY in their ar=
gument
  * type, and declare it as 'const struct bpf_dynptr *' in their prototyp=
e.
  */
-int process_dynptr_func(struct bpf_verifier_env *env, int regno,
-			enum bpf_arg_type arg_type, struct bpf_call_arg_meta *meta)
+int process_dynptr_func(struct bpf_verifier_env *env, int regno, int ins=
n_idx,
+			enum bpf_arg_type arg_type)
 {
 	struct bpf_reg_state *regs =3D cur_regs(env), *reg =3D &regs[regno];
+	int err;
=20
 	/* MEM_UNINIT and MEM_RDONLY are exclusive, when applied to an
 	 * ARG_PTR_TO_DYNPTR (or ARG_PTR_TO_DYNPTR | DYNPTR_TYPE_*):
@@ -6245,23 +6245,23 @@ int process_dynptr_func(struct bpf_verifier_env *=
env, int regno,
 	 *		 to.
 	 */
 	if (arg_type & MEM_UNINIT) {
+		int i;
+
 		if (!is_dynptr_reg_valid_uninit(env, reg)) {
 			verbose(env, "Dynptr has to be an uninitialized dynptr\n");
 			return -EINVAL;
 		}
=20
-		/* We only support one dynptr being uninitialized at the moment,
-		 * which is sufficient for the helper functions we have right now.
-		 */
-		if (meta->uninit_dynptr_regno) {
-			verbose(env, "verifier internal error: multiple uninitialized dynptr =
args\n");
-			return -EFAULT;
+		/* we write BPF_DW bits (8 bytes) at a time */
+		for (i =3D 0; i < BPF_DYNPTR_SIZE; i +=3D 8) {
+			err =3D check_mem_access(env, insn_idx, regno,
+					       i, BPF_DW, BPF_WRITE, -1, false);
+			if (err)
+				return err;
 		}
=20
-		meta->uninit_dynptr_regno =3D regno;
+		err =3D mark_stack_slots_dynptr(env, reg, arg_type, insn_idx);
 	} else /* MEM_RDONLY and None case from above */ {
-		int err;
-
 		/* For the reg->type =3D=3D PTR_TO_STACK case, bpf_dynptr is never con=
st */
 		if (reg->type =3D=3D CONST_PTR_TO_DYNPTR && !(arg_type & MEM_RDONLY)) =
{
 			verbose(env, "cannot pass pointer to const bpf_dynptr, the helper mut=
ates it\n");
@@ -6297,10 +6297,8 @@ int process_dynptr_func(struct bpf_verifier_env *e=
nv, int regno,
 		}
=20
 		err =3D mark_dynptr_read(env, reg);
-		if (err)
-			return err;
 	}
-	return 0;
+	return err;
 }
=20
 static bool arg_type_is_mem_size(enum bpf_arg_type type)
@@ -6694,7 +6692,8 @@ static int dynptr_ref_obj_id(struct bpf_verifier_en=
v *env, struct bpf_reg_state
=20
 static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 			  struct bpf_call_arg_meta *meta,
-			  const struct bpf_func_proto *fn)
+			  const struct bpf_func_proto *fn,
+			  int insn_idx)
 {
 	u32 regno =3D BPF_REG_1 + arg;
 	struct bpf_reg_state *regs =3D cur_regs(env), *reg =3D &regs[regno];
@@ -6907,7 +6906,7 @@ static int check_func_arg(struct bpf_verifier_env *=
env, u32 arg,
 		err =3D check_mem_size_reg(env, reg, regno, true, meta);
 		break;
 	case ARG_PTR_TO_DYNPTR:
-		err =3D process_dynptr_func(env, regno, arg_type, meta);
+		err =3D process_dynptr_func(env, regno, insn_idx, arg_type);
 		if (err)
 			return err;
 		break;
@@ -8197,7 +8196,7 @@ static int check_helper_call(struct bpf_verifier_en=
v *env, struct bpf_insn *insn
 	meta.func_id =3D func_id;
 	/* check args */
 	for (i =3D 0; i < MAX_BPF_FUNC_REG_ARGS; i++) {
-		err =3D check_func_arg(env, i, &meta, fn);
+		err =3D check_func_arg(env, i, &meta, fn, insn_idx);
 		if (err)
 			return err;
 	}
@@ -8222,30 +8221,6 @@ static int check_helper_call(struct bpf_verifier_e=
nv *env, struct bpf_insn *insn
=20
 	regs =3D cur_regs(env);
=20
-	/* This can only be set for PTR_TO_STACK, as CONST_PTR_TO_DYNPTR cannot
-	 * be reinitialized by any dynptr helper. Hence, mark_stack_slots_dynpt=
r
-	 * is safe to do directly.
-	 */
-	if (meta.uninit_dynptr_regno) {
-		if (regs[meta.uninit_dynptr_regno].type =3D=3D CONST_PTR_TO_DYNPTR) {
-			verbose(env, "verifier internal error: CONST_PTR_TO_DYNPTR cannot be =
initialized\n");
-			return -EFAULT;
-		}
-		/* we write BPF_DW bits (8 bytes) at a time */
-		for (i =3D 0; i < BPF_DYNPTR_SIZE; i +=3D 8) {
-			err =3D check_mem_access(env, insn_idx, meta.uninit_dynptr_regno,
-					       i, BPF_DW, BPF_WRITE, -1, false);
-			if (err)
-				return err;
-		}
-
-		err =3D mark_stack_slots_dynptr(env, &regs[meta.uninit_dynptr_regno],
-					      fn->arg_type[meta.uninit_dynptr_regno - BPF_REG_1],
-					      insn_idx);
-		if (err)
-			return err;
-	}
-
 	if (meta.release_regno) {
 		err =3D -EINVAL;
 		/* This can only be set for PTR_TO_STACK, as CONST_PTR_TO_DYNPTR canno=
t
@@ -9455,7 +9430,8 @@ static int process_kf_arg_ptr_to_rbtree_node(struct=
 bpf_verifier_env *env,
 						  &meta->arg_rbtree_root.field);
 }
=20
-static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfu=
nc_call_arg_meta *meta)
+static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfu=
nc_call_arg_meta *meta,
+			    int insn_idx)
 {
 	const char *func_name =3D meta->func_name, *ref_tname;
 	const struct btf *btf =3D meta->btf;
@@ -9652,7 +9628,8 @@ static int check_kfunc_args(struct bpf_verifier_env=
 *env, struct bpf_kfunc_call_
 				return -EINVAL;
 			}
=20
-			ret =3D process_dynptr_func(env, regno, ARG_PTR_TO_DYNPTR | MEM_RDONL=
Y, NULL);
+			ret =3D process_dynptr_func(env, regno, insn_idx,
+						  ARG_PTR_TO_DYNPTR | MEM_RDONLY);
 			if (ret < 0)
 				return ret;
 			break;
@@ -9860,7 +9837,7 @@ static int check_kfunc_call(struct bpf_verifier_env=
 *env, struct bpf_insn *insn,
 	}
=20
 	/* Check the arguments */
-	err =3D check_kfunc_args(env, &meta);
+	err =3D check_kfunc_args(env, &meta, insn_idx);
 	if (err < 0)
 		return err;
 	/* In case of release function, we get register number of refcounted
--=20
2.30.2

