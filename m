Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 756C667EE0A
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 20:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233844AbjA0TTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 14:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233802AbjA0TTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 14:19:01 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8957D6C0
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 11:18:39 -0800 (PST)
Received: by devvm15675.prn0.facebook.com (Postfix, from userid 115148)
        id 0F1C34CC6237; Fri, 27 Jan 2023 11:18:25 -0800 (PST)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, memxor@gmail.com,
        kernel-team@fb.com, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH v9 bpf-next 2/5] bpf: Allow initializing dynptrs in kfuncs
Date:   Fri, 27 Jan 2023 11:17:00 -0800
Message-Id: <20230127191703.3864860-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230127191703.3864860-1-joannelkoong@gmail.com>
References: <20230127191703.3864860-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,RDNS_DYNAMIC,
        SPF_HELO_PASS,SPF_SOFTFAIL,TVD_RCVD_IP autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change allows kfuncs to take in an uninitialized dynptr as a
parameter. Before this change, only helper functions could successfully
use uninitialized dynptrs. This change moves the memory access check
(and stack state growing) into process_dynptr_func(), which both helpers
and kfuncs call.

This change also includes some light tidying up of existing code (eg
remove unused parameter, move spi checking logic, remove unneeded checks)

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/bpf_verifier.h |   3 -
 kernel/bpf/verifier.c        | 135 +++++++++++++----------------------
 2 files changed, 50 insertions(+), 88 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index aa83de1fe755..bee10101222d 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -618,9 +618,6 @@ int check_func_arg_reg_off(struct bpf_verifier_env *e=
nv,
 			   enum bpf_arg_type arg_type);
 int check_mem_reg(struct bpf_verifier_env *env, struct bpf_reg_state *re=
g,
 		   u32 regno, u32 mem_size);
-struct bpf_call_arg_meta;
-int process_dynptr_func(struct bpf_verifier_env *env, int regno,
-			enum bpf_arg_type arg_type, struct bpf_call_arg_meta *meta);
=20
 /* this lives here instead of in bpf.h because it needs to dereference t=
gt_prog */
 static inline u64 bpf_trampoline_compute_key(const struct bpf_prog *tgt_=
prog,
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6bd097e0d45f..853ab671be0b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -264,7 +264,6 @@ struct bpf_call_arg_meta {
 	u32 ret_btf_id;
 	u32 subprogno;
 	struct btf_field *kptr_field;
-	u8 uninit_dynptr_regno;
 };
=20
 struct btf *btf_vmlinux;
@@ -946,41 +945,24 @@ static int destroy_if_dynptr_stack_slot(struct bpf_=
verifier_env *env,
 	return 0;
 }
=20
-static bool is_dynptr_reg_valid_uninit(struct bpf_verifier_env *env, str=
uct bpf_reg_state *reg,
-				       int spi)
-{
-	if (reg->type =3D=3D CONST_PTR_TO_DYNPTR)
-		return false;
-
-	/* For -ERANGE (i.e. spi not falling into allocated stack slots), we
-	 * will do check_mem_access to check and update stack bounds later, so
-	 * return true for that case.
-	 */
-	if (spi < 0)
-		return spi =3D=3D -ERANGE;
-	/* We allow overwriting existing unreferenced STACK_DYNPTR slots, see
-	 * mark_stack_slots_dynptr which calls destroy_if_dynptr_stack_slot to
-	 * ensure dynptr objects at the slots we are touching are completely
-	 * destructed before we reinitialize them for a new one. For referenced
-	 * ones, destroy_if_dynptr_stack_slot returns an error early instead of
-	 * delaying it until the end where the user will get "Unreleased
-	 * reference" error.
-	 */
-	return true;
-}
-
-static bool is_dynptr_reg_valid_init(struct bpf_verifier_env *env, struc=
t bpf_reg_state *reg,
-				     int spi)
+static bool is_dynptr_reg_valid_init(struct bpf_verifier_env *env, struc=
t bpf_reg_state *reg)
 {
 	struct bpf_func_state *state =3D func(env, reg);
-	int i;
+	int i, spi;
=20
-	/* This already represents first slot of initialized bpf_dynptr */
+	/* This already represents first slot of initialized bpf_dynptr.
+	 *
+	 * Please also note that CONST_PTR_TO_DYNPTR already has fixed and
+	 * var_off as 0 due to check_func_arg_reg_off's logic, so we don't
+	 * need to check its offset and alignment.
+	 */
 	if (reg->type =3D=3D CONST_PTR_TO_DYNPTR)
 		return true;
=20
+	spi =3D dynptr_get_spi(env, reg);
 	if (spi < 0)
 		return false;
+
 	if (!state->stack[spi].spilled_ptr.dynptr.first_slot)
 		return false;
=20
@@ -6165,11 +6147,11 @@ static int process_kptr_func(struct bpf_verifier_=
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
-	int spi =3D 0;
+	int err;
=20
 	/* MEM_UNINIT and MEM_RDONLY are exclusive, when applied to an
 	 * ARG_PTR_TO_DYNPTR (or ARG_PTR_TO_DYNPTR | DYNPTR_TYPE_*):
@@ -6178,15 +6160,6 @@ int process_dynptr_func(struct bpf_verifier_env *e=
nv, int regno,
 		verbose(env, "verifier internal error: misconfigured dynptr helper typ=
e flags\n");
 		return -EFAULT;
 	}
-	/* CONST_PTR_TO_DYNPTR already has fixed and var_off as 0 due to
-	 * check_func_arg_reg_off's logic. We only need to check offset
-	 * and its alignment for PTR_TO_STACK.
-	 */
-	if (reg->type =3D=3D PTR_TO_STACK) {
-		spi =3D dynptr_get_spi(env, reg);
-		if (spi < 0 && spi !=3D -ERANGE)
-			return spi;
-	}
=20
 	/*  MEM_UNINIT - Points to memory that is an appropriate candidate for
 	 *		 constructing a mutable bpf_dynptr object.
@@ -6204,32 +6177,47 @@ int process_dynptr_func(struct bpf_verifier_env *=
env, int regno,
 	 *		 to.
 	 */
 	if (arg_type & MEM_UNINIT) {
-		if (!is_dynptr_reg_valid_uninit(env, reg, spi)) {
+		int i, spi;
+
+		if (base_type(reg->type) =3D=3D CONST_PTR_TO_DYNPTR) {
 			verbose(env, "Dynptr has to be an uninitialized dynptr\n");
 			return -EINVAL;
 		}
=20
-		/* We only support one dynptr being uninitialized at the moment,
-		 * which is sufficient for the helper functions we have right now.
+		/* For -ERANGE (i.e. spi not falling into allocated stack slots),
+		 * check_mem_access will check and update stack bounds, so this
+		 * is okay.
 		 */
-		if (meta->uninit_dynptr_regno) {
-			verbose(env, "verifier internal error: multiple uninitialized dynptr =
args\n");
-			return -EFAULT;
+		spi =3D dynptr_get_spi(env, reg);
+		if (spi < 0 && spi !=3D -ERANGE)
+			return spi;
+
+		/* we write BPF_DW bits (8 bytes) at a time */
+		for (i =3D 0; i < BPF_DYNPTR_SIZE; i +=3D 8) {
+			err =3D check_mem_access(env, insn_idx, regno,
+					       i, BPF_DW, BPF_WRITE, -1, false);
+			if (err)
+				return err;
 		}
=20
-		meta->uninit_dynptr_regno =3D regno;
+		/* Please note that we allow overwriting existing unreferenced STACK_D=
YNPTR
+		 * slots (mark_stack_slots_dynptr calls destroy_if_dynptr_stack_slot
+		 * to ensure dynptr objects at the slots we are touching are completel=
y
+		 * destructed before we reinitialize them for a new one). For referenc=
ed
+		 * ones, destroy_if_dynptr_stack_slot returns an error early instead o=
f
+		 * delaying it until the end where the user will get "Unreleased
+		 * reference" error.
+		 */
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
 			return -EINVAL;
 		}
=20
-		if (!is_dynptr_reg_valid_init(env, reg, spi)) {
-			verbose(env,
-				"Expected an initialized dynptr as arg #%d\n",
+		if (!is_dynptr_reg_valid_init(env, reg)) {
+			verbose(env, "Expected an initialized dynptr as arg #%d\n",
 				regno);
 			return -EINVAL;
 		}
@@ -6256,10 +6244,8 @@ int process_dynptr_func(struct bpf_verifier_env *e=
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
@@ -6623,7 +6609,8 @@ static int dynptr_ref_obj_id(struct bpf_verifier_en=
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
@@ -6832,7 +6819,7 @@ static int check_func_arg(struct bpf_verifier_env *=
env, u32 arg,
 		err =3D check_mem_size_reg(env, reg, regno, true, meta);
 		break;
 	case ARG_PTR_TO_DYNPTR:
-		err =3D process_dynptr_func(env, regno, arg_type, meta);
+		err =3D process_dynptr_func(env, regno, insn_idx, arg_type);
 		if (err)
 			return err;
 		break;
@@ -8044,7 +8031,7 @@ static int check_helper_call(struct bpf_verifier_en=
v *env, struct bpf_insn *insn
 	meta.func_id =3D func_id;
 	/* check args */
 	for (i =3D 0; i < MAX_BPF_FUNC_REG_ARGS; i++) {
-		err =3D check_func_arg(env, i, &meta, fn);
+		err =3D check_func_arg(env, i, &meta, fn, insn_idx);
 		if (err)
 			return err;
 	}
@@ -8069,30 +8056,6 @@ static int check_helper_call(struct bpf_verifier_e=
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
@@ -9111,7 +9074,8 @@ static int process_kf_arg_ptr_to_list_node(struct b=
pf_verifier_env *env,
 	return ref_set_release_on_unlock(env, reg->ref_obj_id);
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
@@ -9305,7 +9269,8 @@ static int check_kfunc_args(struct bpf_verifier_env=
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
@@ -9471,7 +9436,7 @@ static int check_kfunc_call(struct bpf_verifier_env=
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

