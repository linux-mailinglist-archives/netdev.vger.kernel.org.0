Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8980A69A021
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 23:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjBPW41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 17:56:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjBPW4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 17:56:25 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A17E4CCBA
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 14:56:23 -0800 (PST)
Received: by devvm15675.prn0.facebook.com (Postfix, from userid 115148)
        id 35E8A6A5C821; Thu, 16 Feb 2023 14:56:06 -0800 (PST)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     martin.lau@kernel.org, andrii@kernel.org, memxor@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        kernel-team@fb.com, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH v10 bpf-next 2/9] bpf: Refactor process_dynptr_func
Date:   Thu, 16 Feb 2023 14:55:17 -0800
Message-Id: <20230216225524.1192789-3-joannelkoong@gmail.com>
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

This change cleans up process_dynptr_func's flow to be more intuitive
and updates some comments with more context.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/bpf_verifier.h |  3 --
 kernel/bpf/verifier.c        | 58 ++++++++++++++++++------------------
 2 files changed, 29 insertions(+), 32 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index cf1bb1cf4a7b..b26ff2a8f63b 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -616,9 +616,6 @@ int check_func_arg_reg_off(struct bpf_verifier_env *e=
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
index 272563a0b770..23a7749e8463 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -955,39 +955,49 @@ static int destroy_if_dynptr_stack_slot(struct bpf_=
verifier_env *env,
 	return 0;
 }
=20
-static bool is_dynptr_reg_valid_uninit(struct bpf_verifier_env *env, str=
uct bpf_reg_state *reg,
-				       int spi)
+static bool is_dynptr_reg_valid_uninit(struct bpf_verifier_env *env, str=
uct bpf_reg_state *reg)
 {
+	int spi;
+
 	if (reg->type =3D=3D CONST_PTR_TO_DYNPTR)
 		return false;
=20
-	/* For -ERANGE (i.e. spi not falling into allocated stack slots), we
-	 * will do check_mem_access to check and update stack bounds later, so
-	 * return true for that case.
+	spi =3D dynptr_get_spi(env, reg);
+
+	/* -ERANGE (i.e. spi not falling into allocated stack slots) isn't an
+	 * error because this just means the stack state hasn't been updated ye=
t.
+	 * We will do check_mem_access to check and update stack bounds later.
 	 */
-	if (spi < 0)
-		return spi =3D=3D -ERANGE;
-	/* We allow overwriting existing unreferenced STACK_DYNPTR slots, see
-	 * mark_stack_slots_dynptr which calls destroy_if_dynptr_stack_slot to
-	 * ensure dynptr objects at the slots we are touching are completely
-	 * destructed before we reinitialize them for a new one. For referenced
-	 * ones, destroy_if_dynptr_stack_slot returns an error early instead of
-	 * delaying it until the end where the user will get "Unreleased
+	if (spi < 0 && spi !=3D -ERANGE)
+		return false;
+
+	/* We don't need to check if the stack slots are marked by previous
+	 * dynptr initializations because we allow overwriting existing unrefer=
enced
+	 * STACK_DYNPTR slots, see mark_stack_slots_dynptr which calls
+	 * destroy_if_dynptr_stack_slot to ensure dynptr objects at the slots w=
e are
+	 * touching are completely destructed before we reinitialize them for a=
 new
+	 * one. For referenced ones, destroy_if_dynptr_stack_slot returns an er=
ror early
+	 * instead of delaying it until the end where the user will get "Unrele=
ased
 	 * reference" error.
 	 */
 	return true;
 }
=20
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
+	 * CONST_PTR_TO_DYNPTR already has fixed and var_off as 0 due to
+	 * check_func_arg_reg_off's logic, so we don't need to check its
+	 * offset and alignment.
+	 */
 	if (reg->type =3D=3D CONST_PTR_TO_DYNPTR)
 		return true;
=20
+	spi =3D dynptr_get_spi(env, reg);
 	if (spi < 0)
 		return false;
 	if (!state->stack[spi].spilled_ptr.dynptr.first_slot)
@@ -6210,7 +6220,6 @@ int process_dynptr_func(struct bpf_verifier_env *en=
v, int regno,
 			enum bpf_arg_type arg_type, struct bpf_call_arg_meta *meta)
 {
 	struct bpf_reg_state *regs =3D cur_regs(env), *reg =3D &regs[regno];
-	int spi =3D 0;
=20
 	/* MEM_UNINIT and MEM_RDONLY are exclusive, when applied to an
 	 * ARG_PTR_TO_DYNPTR (or ARG_PTR_TO_DYNPTR | DYNPTR_TYPE_*):
@@ -6219,15 +6228,6 @@ int process_dynptr_func(struct bpf_verifier_env *e=
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
@@ -6245,7 +6245,7 @@ int process_dynptr_func(struct bpf_verifier_env *en=
v, int regno,
 	 *		 to.
 	 */
 	if (arg_type & MEM_UNINIT) {
-		if (!is_dynptr_reg_valid_uninit(env, reg, spi)) {
+		if (!is_dynptr_reg_valid_uninit(env, reg)) {
 			verbose(env, "Dynptr has to be an uninitialized dynptr\n");
 			return -EINVAL;
 		}
@@ -6268,7 +6268,7 @@ int process_dynptr_func(struct bpf_verifier_env *en=
v, int regno,
 			return -EINVAL;
 		}
=20
-		if (!is_dynptr_reg_valid_init(env, reg, spi)) {
+		if (!is_dynptr_reg_valid_init(env, reg)) {
 			verbose(env,
 				"Expected an initialized dynptr as arg #%d\n",
 				regno);
--=20
2.30.2

