Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 075A5571DBC
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 17:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbiGLPBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 11:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233840AbiGLPAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 11:00:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 36EE5BE6A4
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 07:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657637969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E3SQXmPM9gpjU/ECDq2xrd0FpowC3nFhR3ZobqZq6q0=;
        b=dyZhaE2Spt8kx/q2VuvYDQu4W+V7dDYmFaQRbEV9d/gOtBnt+He8Vj2tbykxWXTFXFUX8m
        QsqrkO0BNo++JrPAvGxJ/9KT8y17kS5jDrHJaUEQXHM7QQajSSu7vDpWx0MKtD2EAsjjLC
        yGgJFwIZqMHMT3hVGij4+Y7GPSL/K4I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-467---2eCvZvPI6dlz6yKl4nrg-1; Tue, 12 Jul 2022 10:59:23 -0400
X-MC-Unique: --2eCvZvPI6dlz6yKl4nrg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E40C61035347;
        Tue, 12 Jul 2022 14:59:21 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.195.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B3B6D2166B26;
        Tue, 12 Jul 2022 14:59:17 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v6 05/23] bpf/verifier: allow kfunc to return an allocated mem
Date:   Tue, 12 Jul 2022 16:58:32 +0200
Message-Id: <20220712145850.599666-6-benjamin.tissoires@redhat.com>
In-Reply-To: <20220712145850.599666-1-benjamin.tissoires@redhat.com>
References: <20220712145850.599666-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a kfunc is not returning a pointer to a struct but to a plain type,
we can consider it is a valid allocated memory assuming that:
- one of the arguments is either called rdonly_buf_size or
  rdwr_buf_size
- and this argument is a const from the caller point of view

We can then use this parameter as the size of the allocated memory.

The memory is either read-only or read-write based on the name
of the size parameter.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v6:
- code review from Kartikeya:
  - remove comment change that had no reasons to be
  - remove handling of PTR_TO_MEM with kfunc releases
  - introduce struct bpf_kfunc_arg_meta
  - do rdonly/rdwr_buf_size check in btf_check_kfunc_arg_match
  - reverted most of the changes in verifier.c
  - make sure kfunc acquire is using a struct pointer, not just a plain
    pointer
  - also forward ref_obj_id to PTR_TO_MEM in kfunc to not use after free
    the allocated memory

changes in v5:
- updated PTR_TO_MEM comment in btf.c to match upstream
- make it read-only or read-write based on the name of size

new in v4
---
 include/linux/bpf.h   | 10 ++++++-
 include/linux/btf.h   | 12 ++++++++
 kernel/bpf/btf.c      | 67 ++++++++++++++++++++++++++++++++++++++++---
 kernel/bpf/verifier.c | 49 +++++++++++++++++++++++--------
 4 files changed, 121 insertions(+), 17 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 2b21f2a3452f..5b8eadb6e7bc 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1916,12 +1916,20 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
 			   const char *func_name,
 			   struct btf_func_model *m);
 
+struct bpf_kfunc_arg_meta {
+	u64 r0_size;
+	bool r0_rdonly;
+	int ref_obj_id;
+	bool multiple_ref_obj_id;
+};
+
 struct bpf_reg_state;
 int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
 				struct bpf_reg_state *regs);
 int btf_check_kfunc_arg_match(struct bpf_verifier_env *env,
 			      const struct btf *btf, u32 func_id,
-			      struct bpf_reg_state *regs);
+			      struct bpf_reg_state *regs,
+			      struct bpf_kfunc_arg_meta *meta);
 int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
 			  struct bpf_reg_state *reg);
 int btf_check_type_match(struct bpf_verifier_log *log, const struct bpf_prog *prog,
diff --git a/include/linux/btf.h b/include/linux/btf.h
index 1bfed7fa0428..31da4273c2ec 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -420,4 +420,16 @@ static inline int register_btf_id_dtor_kfuncs(const struct btf_id_dtor_kfunc *dt
 }
 #endif
 
+static inline bool btf_type_is_struct_ptr(struct btf *btf, const struct btf_type *t)
+{
+	/* t comes in already as a pointer */
+	t = btf_type_by_id(btf, t->type);
+
+	/* allow const */
+	if (BTF_INFO_KIND(t->info) == BTF_KIND_CONST)
+		t = btf_type_by_id(btf, t->type);
+
+	return btf_type_is_struct(t);
+}
+
 #endif
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 4423045b8ff3..552d7bc05a0c 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6168,10 +6168,36 @@ static bool is_kfunc_arg_mem_size(const struct btf *btf,
 	return true;
 }
 
+static bool btf_is_kfunc_arg_mem_size(const struct btf *btf,
+				      const struct btf_param *arg,
+				      const struct bpf_reg_state *reg,
+				      const char *name)
+{
+	int len, target_len = strlen(name);
+	const struct btf_type *t;
+	const char *param_name;
+
+	t = btf_type_skip_modifiers(btf, arg->type, NULL);
+	if (!btf_type_is_scalar(t) || reg->type != SCALAR_VALUE)
+		return false;
+
+	param_name = btf_name_by_offset(btf, arg->name_off);
+	if (str_is_empty(param_name))
+		return false;
+	len = strlen(param_name);
+	if (len != target_len)
+		return false;
+	if (strncmp(param_name, name, target_len))
+		return false;
+
+	return true;
+}
+
 static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 				    const struct btf *btf, u32 func_id,
 				    struct bpf_reg_state *regs,
-				    bool ptr_to_mem_ok)
+				    bool ptr_to_mem_ok,
+				    struct bpf_kfunc_arg_meta *kfunc_meta)
 {
 	enum bpf_prog_type prog_type = resolve_prog_type(env->prog);
 	struct bpf_verifier_log *log = &env->log;
@@ -6225,6 +6251,30 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 
 		t = btf_type_skip_modifiers(btf, args[i].type, NULL);
 		if (btf_type_is_scalar(t)) {
+			if (is_kfunc && kfunc_meta) {
+				bool is_buf_size = false;
+
+				/* check for any const scalar parameter of name "rdonly_buf_size"
+				 * or "rdwr_buf_size"
+				 */
+				if (btf_is_kfunc_arg_mem_size(btf, &args[i], reg,
+							      "rdonly_buf_size")) {
+					kfunc_meta->r0_rdonly = true;
+					is_buf_size = true;
+				} else if (btf_is_kfunc_arg_mem_size(btf, &args[i], reg,
+								     "rdwr_buf_size"))
+					is_buf_size = true;
+
+				if (is_buf_size) {
+					if (kfunc_meta->r0_size) {
+						bpf_log(log, "2 or more rdonly/rdwr_buf_size parameters for kfunc");
+						return -EINVAL;
+					}
+
+					kfunc_meta->r0_size = reg->var_off.value;
+				}
+			}
+
 			if (reg->type == SCALAR_VALUE)
 				continue;
 			bpf_log(log, "R%d is not a scalar\n", regno);
@@ -6246,6 +6296,14 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 		if (ret < 0)
 			return ret;
 
+		/* kptr_get is only valid for kfunc */
+		if (kfunc_meta && reg->ref_obj_id) {
+			/* check for any one ref_obj_id to keep track of memory */
+			if (kfunc_meta->ref_obj_id)
+				kfunc_meta->multiple_ref_obj_id = true;
+			kfunc_meta->ref_obj_id = reg->ref_obj_id;
+		}
+
 		/* kptr_get is only true for kfunc */
 		if (i == 0 && kptr_get) {
 			struct bpf_map_value_off_desc *off_desc;
@@ -6441,7 +6499,7 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
 		return -EINVAL;
 
 	is_global = prog->aux->func_info_aux[subprog].linkage == BTF_FUNC_GLOBAL;
-	err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global);
+	err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global, NULL);
 
 	/* Compiler optimizations can remove arguments from static functions
 	 * or mismatched type can be passed into a global function.
@@ -6454,9 +6512,10 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
 
 int btf_check_kfunc_arg_match(struct bpf_verifier_env *env,
 			      const struct btf *btf, u32 func_id,
-			      struct bpf_reg_state *regs)
+			      struct bpf_reg_state *regs,
+			      struct bpf_kfunc_arg_meta *meta)
 {
-	return btf_check_func_arg_match(env, btf, func_id, regs, true);
+	return btf_check_func_arg_match(env, btf, func_id, regs, true, meta);
 }
 
 /* Convert BTF of a function into bpf_reg_state if possible
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 3adcc0d123af..77556132db15 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7561,6 +7561,7 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 {
 	const struct btf_type *t, *func, *func_proto, *ptr_type;
 	struct bpf_reg_state *regs = cur_regs(env);
+	struct bpf_kfunc_arg_meta meta = { 0 };
 	const char *func_name, *ptr_type_name;
 	u32 i, nargs, func_id, ptr_type_id;
 	int err, insn_idx = *insn_idx_p;
@@ -7592,7 +7593,7 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 					BTF_KFUNC_TYPE_ACQUIRE, func_id);
 
 	/* Check the arguments */
-	err = btf_check_kfunc_arg_match(env, desc_btf, func_id, regs);
+	err = btf_check_kfunc_arg_match(env, desc_btf, func_id, regs, &meta);
 	if (err < 0)
 		return err;
 	/* In case of release function, we get register number of refcounted
@@ -7613,7 +7614,7 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 	/* Check return type */
 	t = btf_type_skip_modifiers(desc_btf, func_proto->type, NULL);
 
-	if (acq && !btf_type_is_ptr(t)) {
+	if (acq && !btf_type_is_struct_ptr(desc_btf, t)) {
 		verbose(env, "acquire kernel function does not return PTR_TO_BTF_ID\n");
 		return -EINVAL;
 	}
@@ -7625,17 +7626,41 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 		ptr_type = btf_type_skip_modifiers(desc_btf, t->type,
 						   &ptr_type_id);
 		if (!btf_type_is_struct(ptr_type)) {
-			ptr_type_name = btf_name_by_offset(desc_btf,
-							   ptr_type->name_off);
-			verbose(env, "kernel function %s returns pointer type %s %s is not supported\n",
-				func_name, btf_type_str(ptr_type),
-				ptr_type_name);
-			return -EINVAL;
+			if (!meta.r0_size) {
+				ptr_type_name = btf_name_by_offset(desc_btf,
+								   ptr_type->name_off);
+				verbose(env,
+					"kernel function %s returns pointer type %s %s is not supported\n",
+					func_name,
+					btf_type_str(ptr_type),
+					ptr_type_name);
+				return -EINVAL;
+			}
+
+			if (meta.multiple_ref_obj_id) {
+				verbose(env,
+					"kernel function %s has multiple memory tracked objects\n",
+					func_name);
+				return -EINVAL;
+			}
+
+			mark_reg_known_zero(env, regs, BPF_REG_0);
+			regs[BPF_REG_0].type = PTR_TO_MEM;
+			regs[BPF_REG_0].mem_size = meta.r0_size;
+
+			if (meta.r0_rdonly)
+				regs[BPF_REG_0].type |= MEM_RDONLY;
+
+			/* Ensures we don't access the memory after a release_reference() */
+			if (meta.ref_obj_id)
+				regs[BPF_REG_0].ref_obj_id = meta.ref_obj_id;
+		} else {
+			mark_reg_known_zero(env, regs, BPF_REG_0);
+			regs[BPF_REG_0].btf = desc_btf;
+			regs[BPF_REG_0].type = PTR_TO_BTF_ID;
+			regs[BPF_REG_0].btf_id = ptr_type_id;
 		}
-		mark_reg_known_zero(env, regs, BPF_REG_0);
-		regs[BPF_REG_0].btf = desc_btf;
-		regs[BPF_REG_0].type = PTR_TO_BTF_ID;
-		regs[BPF_REG_0].btf_id = ptr_type_id;
+
 		if (btf_kfunc_id_set_contains(desc_btf, resolve_prog_type(env->prog),
 					      BTF_KFUNC_TYPE_RET_NULL, func_id)) {
 			regs[BPF_REG_0].type |= PTR_MAYBE_NULL;
-- 
2.36.1

