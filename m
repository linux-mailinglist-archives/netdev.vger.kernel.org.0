Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFC65AB26A
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 15:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238494AbiIBN6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 09:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238454AbiIBN5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 09:57:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885539D112
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 06:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662125414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9bq5YvMBdGA8n7Qb3yfoNJy8seo0Dva12mZq13np5+s=;
        b=eN7aqjOzR8YnLNHt3VyodYEw67DbmVZ+7uWzeiWPITA2XhTQXje6Zv5s27crzxS5bkgqSN
        JhqHdvp+Eeoq4KoruhAFa5V0WN5Gzwgk0pPHtuxjRDhOmft3Zs7K+gg2hC6pp1TO0Nh3qH
        Vqsc39c83Ut5A4dRtxhHr3GSO4Uc52c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-328-zQRTCliXNjikF6l4Ich7ew-1; Fri, 02 Sep 2022 09:30:08 -0400
X-MC-Unique: zQRTCliXNjikF6l4Ich7ew-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B1AF6800124;
        Fri,  2 Sep 2022 13:30:07 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.193.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4BC5E492C3B;
        Fri,  2 Sep 2022 13:30:04 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v10 06/23] bpf/verifier: allow kfunc to return an allocated mem
Date:   Fri,  2 Sep 2022 15:29:21 +0200
Message-Id: <20220902132938.2409206-7-benjamin.tissoires@redhat.com>
In-Reply-To: <20220902132938.2409206-1-benjamin.tissoires@redhat.com>
References: <20220902132938.2409206-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For drivers (outside of network), the incoming data is not statically
defined in a struct. Most of the time the data buffer is kzalloc-ed
and thus we can not rely on eBPF and BTF to explore the data.

This commit allows to return an arbitrary memory, previously allocated by
the driver.
An interesting extra point is that the kfunc can mark the exported
memory region as read only or read/write.

So, when a kfunc is not returning a pointer to a struct but to a plain
type, we can consider it is a valid allocated memory assuming that:
- one of the arguments is either called rdonly_buf_size or
  rdwr_buf_size
- and this argument is a const from the caller point of view

We can then use this parameter as the size of the allocated memory.

The memory is either read-only or read-write based on the name
of the size parameter.

Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v10:
- remove extra check to PTR_TO_BTF_ID
- mark_chain_precision on const register
  (https://lore.kernel.org/bpf/20220823185300.406-2-memxor@gmail.com)

changes in v9:
- updated to match upstream (replaced kfunc_flag by a field in
  kfunc_meta)

no changes in v8

changes in v7:
- ensures btf_type_is_struct_ptr() checks for a ptr first
  (squashed from next commit)
- remove multiple_ref_obj_id need
- use btf_type_skip_modifiers instead of manually doing it in
  btf_type_is_struct_ptr()
- s/strncmp/strcmp/ in btf_is_kfunc_arg_mem_size()
- check for tnum_is_const when retrieving the size value
- have only one check for "Ensure only one argument is referenced
  PTR_TO_BTF_ID"
- add some more context to the commit message

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

change btf.h

fix allow kfunc to return an allocated mem
---
 include/linux/bpf.h          |   9 +++-
 include/linux/bpf_verifier.h |   2 +
 include/linux/btf.h          |  10 ++++
 kernel/bpf/btf.c             | 101 ++++++++++++++++++++++++++++-------
 kernel/bpf/verifier.c        |  45 +++++++++++-----
 5 files changed, 133 insertions(+), 34 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c9c72a089579..b879465306fb 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1940,6 +1940,13 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
 			   const char *func_name,
 			   struct btf_func_model *m);
 
+struct bpf_kfunc_arg_meta {
+	u64 r0_size;
+	bool r0_rdonly;
+	int ref_obj_id;
+	u32 flags;
+};
+
 struct bpf_reg_state;
 int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
 				struct bpf_reg_state *regs);
@@ -1948,7 +1955,7 @@ int btf_check_subprog_call(struct bpf_verifier_env *env, int subprog,
 int btf_check_kfunc_arg_match(struct bpf_verifier_env *env,
 			      const struct btf *btf, u32 func_id,
 			      struct bpf_reg_state *regs,
-			      u32 kfunc_flags);
+			      struct bpf_kfunc_arg_meta *meta);
 int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
 			  struct bpf_reg_state *reg);
 int btf_check_type_match(struct bpf_verifier_log *log, const struct bpf_prog *prog,
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 1fdddbf3546b..8fbc1d05281e 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -598,6 +598,8 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 			    struct bpf_attach_target_info *tgt_info);
 void bpf_free_kfunc_btf_tab(struct bpf_kfunc_btf_tab *tab);
 
+int mark_chain_precision(struct bpf_verifier_env *env, int regno);
+
 #define BPF_BASE_TYPE_MASK	GENMASK(BPF_BASE_TYPE_BITS - 1, 0)
 
 /* extract base type from bpf_{arg, return, reg}_type. */
diff --git a/include/linux/btf.h b/include/linux/btf.h
index ad93c2d9cc1c..1fcc833a8690 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -441,4 +441,14 @@ static inline int register_btf_id_dtor_kfuncs(const struct btf_id_dtor_kfunc *dt
 }
 #endif
 
+static inline bool btf_type_is_struct_ptr(struct btf *btf, const struct btf_type *t)
+{
+	if (!btf_type_is_ptr(t))
+		return false;
+
+	t = btf_type_skip_modifiers(btf, t->type, NULL);
+
+	return btf_type_is_struct(t);
+}
+
 #endif
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 8280c1a8dbce..13203d7cb1c6 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6166,11 +6166,36 @@ static bool is_kfunc_arg_mem_size(const struct btf *btf,
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
+	if (strcmp(param_name, name))
+		return false;
+
+	return true;
+}
+
 static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 				    const struct btf *btf, u32 func_id,
 				    struct bpf_reg_state *regs,
 				    bool ptr_to_mem_ok,
-				    u32 kfunc_flags,
+				    struct bpf_kfunc_arg_meta *kfunc_meta,
 				    bool processing_call)
 {
 	enum bpf_prog_type prog_type = resolve_prog_type(env->prog);
@@ -6208,12 +6233,12 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 		return -EINVAL;
 	}
 
-	if (is_kfunc) {
+	if (is_kfunc && kfunc_meta) {
 		/* Only kfunc can be release func */
-		rel = kfunc_flags & KF_RELEASE;
-		kptr_get = kfunc_flags & KF_KPTR_GET;
-		trusted_arg = kfunc_flags & KF_TRUSTED_ARGS;
-		sleepable = kfunc_flags & KF_SLEEPABLE;
+		rel = kfunc_meta->flags & KF_RELEASE;
+		kptr_get = kfunc_meta->flags & KF_KPTR_GET;
+		trusted_arg = kfunc_meta->flags & KF_TRUSTED_ARGS;
+		sleepable = kfunc_meta->flags & KF_SLEEPABLE;
 	}
 
 	/* check that BTF function arguments match actual types that the
@@ -6226,6 +6251,38 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 
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
+					if (!tnum_is_const(reg->var_off)) {
+						bpf_log(log, "R%d is not a const\n", regno);
+						return -EINVAL;
+					}
+
+					kfunc_meta->r0_size = reg->var_off.value;
+					ret = mark_chain_precision(env, regno);
+					if (ret)
+						return ret;
+				}
+			}
+
 			if (reg->type == SCALAR_VALUE)
 				continue;
 			bpf_log(log, "R%d is not a scalar\n", regno);
@@ -6256,6 +6313,17 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 		if (ret < 0)
 			return ret;
 
+		if (is_kfunc && reg->ref_obj_id) {
+			/* Ensure only one argument is referenced PTR_TO_BTF_ID */
+			if (ref_obj_id) {
+				bpf_log(log, "verifier internal error: more than one arg with ref_obj_id R%d %u %u\n",
+					regno, reg->ref_obj_id, ref_obj_id);
+				return -EFAULT;
+			}
+			ref_regno = regno;
+			ref_obj_id = reg->ref_obj_id;
+		}
+
 		/* kptr_get is only true for kfunc */
 		if (i == 0 && kptr_get) {
 			struct bpf_map_value_off_desc *off_desc;
@@ -6328,16 +6396,6 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 			if (reg->type == PTR_TO_BTF_ID) {
 				reg_btf = reg->btf;
 				reg_ref_id = reg->btf_id;
-				/* Ensure only one argument is referenced PTR_TO_BTF_ID */
-				if (reg->ref_obj_id) {
-					if (ref_obj_id) {
-						bpf_log(log, "verifier internal error: more than one arg with ref_obj_id R%d %u %u\n",
-							regno, reg->ref_obj_id, ref_obj_id);
-						return -EFAULT;
-					}
-					ref_regno = regno;
-					ref_obj_id = reg->ref_obj_id;
-				}
 			} else {
 				reg_btf = btf_vmlinux;
 				reg_ref_id = *reg2btf_ids[base_type(reg->type)];
@@ -6428,6 +6486,9 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 		return -EINVAL;
 	}
 
+	if (kfunc_meta && ref_obj_id)
+		kfunc_meta->ref_obj_id = ref_obj_id;
+
 	/* returns argument register number > 0 in case of reference release kfunc */
 	return rel ? ref_regno : 0;
 }
@@ -6459,7 +6520,7 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
 		return -EINVAL;
 
 	is_global = prog->aux->func_info_aux[subprog].linkage == BTF_FUNC_GLOBAL;
-	err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global, 0, false);
+	err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global, NULL, false);
 
 	/* Compiler optimizations can remove arguments from static functions
 	 * or mismatched type can be passed into a global function.
@@ -6502,7 +6563,7 @@ int btf_check_subprog_call(struct bpf_verifier_env *env, int subprog,
 		return -EINVAL;
 
 	is_global = prog->aux->func_info_aux[subprog].linkage == BTF_FUNC_GLOBAL;
-	err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global, 0, true);
+	err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global, NULL, true);
 
 	/* Compiler optimizations can remove arguments from static functions
 	 * or mismatched type can be passed into a global function.
@@ -6516,9 +6577,9 @@ int btf_check_subprog_call(struct bpf_verifier_env *env, int subprog,
 int btf_check_kfunc_arg_match(struct bpf_verifier_env *env,
 			      const struct btf *btf, u32 func_id,
 			      struct bpf_reg_state *regs,
-			      u32 kfunc_flags)
+			      struct bpf_kfunc_arg_meta *meta)
 {
-	return btf_check_func_arg_match(env, btf, func_id, regs, true, kfunc_flags, true);
+	return btf_check_func_arg_match(env, btf, func_id, regs, true, meta, true);
 }
 
 /* Convert BTF of a function into bpf_reg_state if possible
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 3f9e6fa92cde..ca12ee8262bf 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2908,7 +2908,7 @@ static int __mark_chain_precision(struct bpf_verifier_env *env, int regno,
 	return 0;
 }
 
-static int mark_chain_precision(struct bpf_verifier_env *env, int regno)
+int mark_chain_precision(struct bpf_verifier_env *env, int regno)
 {
 	return __mark_chain_precision(env, regno, -1);
 }
@@ -7594,6 +7594,7 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 {
 	const struct btf_type *t, *func, *func_proto, *ptr_type;
 	struct bpf_reg_state *regs = cur_regs(env);
+	struct bpf_kfunc_arg_meta meta = { 0 };
 	const char *func_name, *ptr_type_name;
 	u32 i, nargs, func_id, ptr_type_id;
 	int err, insn_idx = *insn_idx_p;
@@ -7628,8 +7629,10 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 
 	acq = *kfunc_flags & KF_ACQUIRE;
 
+	meta.flags = *kfunc_flags;
+
 	/* Check the arguments */
-	err = btf_check_kfunc_arg_match(env, desc_btf, func_id, regs, *kfunc_flags);
+	err = btf_check_kfunc_arg_match(env, desc_btf, func_id, regs, &meta);
 	if (err < 0)
 		return err;
 	/* In case of release function, we get register number of refcounted
@@ -7650,7 +7653,7 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 	/* Check return type */
 	t = btf_type_skip_modifiers(desc_btf, func_proto->type, NULL);
 
-	if (acq && !btf_type_is_ptr(t)) {
+	if (acq && !btf_type_is_struct_ptr(desc_btf, t)) {
 		verbose(env, "acquire kernel function does not return PTR_TO_BTF_ID\n");
 		return -EINVAL;
 	}
@@ -7662,17 +7665,33 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
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
 		if (*kfunc_flags & KF_RET_NULL) {
 			regs[BPF_REG_0].type |= PTR_MAYBE_NULL;
 			/* For mark_ptr_or_null_reg, see 93c230e3f5bd6 */
-- 
2.36.1

