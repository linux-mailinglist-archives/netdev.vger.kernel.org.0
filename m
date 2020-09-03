Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292CF25CDAB
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 00:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgICWea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 18:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729356AbgICWdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 18:33:44 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40EE3C061247
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 15:33:44 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id w38so2350336ybi.20
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 15:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=0Glc7TccRxwMcDc5UApAFzlQy+c+Mw+LnskMm2Kovo0=;
        b=FpdspfuAH314geZIlOd3qlPzV3nN9QTeYoDjMnU1QD/RUke65/GPYnBLJRIcOpFa9k
         b19cD3Hn1wYHVxY5gplrDGBrnyFbyFZzq9SAYoCdzrQ71A+kfr3ARqs+3IZLLh0Y+JD+
         BuiJRugqUumB9rBf3FkqRzxb94GJhkAGRpH5ZQqf3zgLYvaz5Wf5NIfMi8c/GtWcsSe8
         q/mrgBlAA7B+k6gnr76pFCIRaSKQAgoW+EpFR7c23JSlli40dXBQfVqi1TQABFu1OSDQ
         VVxHB68geQxFZWotnipPNzK8sgeR7rLv5R1RBYoD7Cb66uxSuScCyO5jQcILuAJzzCG9
         hayg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0Glc7TccRxwMcDc5UApAFzlQy+c+Mw+LnskMm2Kovo0=;
        b=n5E0zDInZ5rSxARs6ZiLa4pGeOD10O7+wdw2GylCG7VAXWThztx0YgwDwzFjS8cVsY
         XQzYKKknTGjAPbUZ1nbX/XPECq6DoUj2nWTeRbK7koEIDqcnpJmrpsOEOCkCafhtOUEV
         Tot7+rCZZxflUDgUMEC5WrUwT0fk0/mbMPn6omDL6vUKVWDvcqJtdrWgFAglc9M+QCgk
         8F1HKnWiWUQ3KURCeMV5DCH7HpPUMul+WfRHK6SQzhYwbgC4o6jaJA5E7T/H5vvVOz8i
         0lfNvX6d5EsLb7sQ7gjogilKssARGA7NOyUbeXwYpMO8LqWA/Y+EeFrYV2i2xijhMaLT
         ZvGQ==
X-Gm-Message-State: AOAM533ItbDY4ZC57vFBHjtHUZN0ut0OZaVF0wmWo4WhoPhjrr3xgKzF
        RsACyIdLxQt7QYIyJJ5AJcM153lV6703008Q3V5KMnf/XMNVzLE/Zvr2K805y+yB4fI3t36VrXT
        A/nKevZsOJMrMOyCW2Zl3nDQja8mNo4zZu0RcQfBD3IUPcA8TBgUBPGxzF3PLFw==
X-Google-Smtp-Source: ABdhPJxdVm8RZQIjKc4D9/LZQWvBhazfT9+snZf0zkFJSyvFXVQ4xk4Y10+51qlTBzQ0GU1x1cOHlCzjc8I=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:f693:9fff:fef4:e444])
 (user=haoluo job=sendgmr) by 2002:a25:e03:: with SMTP id 3mr6232976ybo.334.1599172423347;
 Thu, 03 Sep 2020 15:33:43 -0700 (PDT)
Date:   Thu,  3 Sep 2020 15:33:30 -0700
In-Reply-To: <20200903223332.881541-1-haoluo@google.com>
Message-Id: <20200903223332.881541-5-haoluo@google.com>
Mime-Version: 1.0
References: <20200903223332.881541-1-haoluo@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH bpf-next v2 4/6] bpf: Introduce bpf_per_cpu_ptr()
From:   Hao Luo <haoluo@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Hao Luo <haoluo@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Andrey Ignatov <rdna@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpf_per_cpu_ptr() to help bpf programs access percpu vars.
bpf_per_cpu_ptr() has the same semantic as per_cpu_ptr() in the kernel
except that it may return NULL. This happens when the cpu parameter is
out of range. So the caller must check the returned value.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Hao Luo <haoluo@google.com>
---
 include/linux/bpf.h            |  3 ++
 include/linux/btf.h            | 11 ++++++
 include/uapi/linux/bpf.h       | 17 +++++++++
 kernel/bpf/btf.c               | 10 ------
 kernel/bpf/verifier.c          | 66 +++++++++++++++++++++++++++++++---
 kernel/trace/bpf_trace.c       | 18 ++++++++++
 tools/include/uapi/linux/bpf.h | 17 +++++++++
 7 files changed, 128 insertions(+), 14 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c6d9f2c444f4..6b2034f7665e 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -292,6 +292,7 @@ enum bpf_arg_type {
 	ARG_PTR_TO_ALLOC_MEM,	/* pointer to dynamically allocated memory */
 	ARG_PTR_TO_ALLOC_MEM_OR_NULL,	/* pointer to dynamically allocated memory or NULL */
 	ARG_CONST_ALLOC_SIZE_OR_ZERO,	/* number of allocated bytes requested */
+	ARG_PTR_TO_PERCPU_BTF_ID,	/* pointer to in-kernel percpu type */
 };
 
 /* type of values returned from helper functions */
@@ -305,6 +306,7 @@ enum bpf_return_type {
 	RET_PTR_TO_SOCK_COMMON_OR_NULL,	/* returns a pointer to a sock_common or NULL */
 	RET_PTR_TO_ALLOC_MEM_OR_NULL,	/* returns a pointer to dynamically allocated memory or NULL */
 	RET_PTR_TO_BTF_ID_OR_NULL,	/* returns a pointer to a btf_id or NULL */
+	RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL, /* returns a pointer to a valid memory or a btf_id or NULL */
 };
 
 /* eBPF function prototype used by verifier to allow BPF_CALLs from eBPF programs
@@ -385,6 +387,7 @@ enum bpf_reg_type {
 	PTR_TO_RDONLY_BUF_OR_NULL, /* reg points to a readonly buffer or NULL */
 	PTR_TO_RDWR_BUF,	 /* reg points to a read/write buffer */
 	PTR_TO_RDWR_BUF_OR_NULL, /* reg points to a read/write buffer or NULL */
+	PTR_TO_PERCPU_BTF_ID,	 /* reg points to percpu kernel type */
 };
 
 /* The information passed from prog-specific *_is_valid_access
diff --git a/include/linux/btf.h b/include/linux/btf.h
index 592373d359b9..07b7de1c05b0 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -71,6 +71,11 @@ btf_resolve_size(const struct btf *btf, const struct btf_type *type,
 	     i < btf_type_vlen(struct_type);			\
 	     i++, member++)
 
+#define for_each_vsi(i, struct_type, member)			\
+	for (i = 0, member = btf_type_var_secinfo(struct_type);	\
+	     i < btf_type_vlen(struct_type);			\
+	     i++, member++)
+
 static inline bool btf_type_is_ptr(const struct btf_type *t)
 {
 	return BTF_INFO_KIND(t->info) == BTF_KIND_PTR;
@@ -155,6 +160,12 @@ static inline const struct btf_member *btf_type_member(const struct btf_type *t)
 	return (const struct btf_member *)(t + 1);
 }
 
+static inline const struct btf_var_secinfo *btf_type_var_secinfo(
+		const struct btf_type *t)
+{
+	return (const struct btf_var_secinfo *)(t + 1);
+}
+
 #ifdef CONFIG_BPF_SYSCALL
 const struct btf_type *btf_type_by_id(const struct btf *btf, u32 type_id);
 const char *btf_name_by_offset(const struct btf *btf, u32 offset);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index ab00ad9b32e5..d0ec94d5bdbf 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3596,6 +3596,22 @@ union bpf_attr {
  * 		the data in *dst*. This is a wrapper of copy_from_user().
  * 	Return
  * 		0 on success, or a negative error in case of failure.
+ *
+ * void *bpf_per_cpu_ptr(const void *percpu_ptr, u32 cpu)
+ *     Description
+ *             Take a pointer to a percpu ksym, *percpu_ptr*, and return a
+ *             pointer to the percpu kernel variable on *cpu*. A ksym is an
+ *             extern variable decorated with '__ksym'. For ksym, there is a
+ *             global var (either static or global) defined of the same name
+ *             in the kernel. The ksym is percpu if the global var is percpu.
+ *             The returned pointer points to the global percpu var on *cpu*.
+ *
+ *             bpf_per_cpu_ptr() has the same semantic as per_cpu_ptr() in the
+ *             kernel, except that bpf_per_cpu_ptr() may return NULL. This
+ *             happens if *cpu* is larger than nr_cpu_ids. The caller of
+ *             bpf_per_cpu_ptr() must check the returned value.
+ *     Return
+ *             A generic pointer pointing to the kernel percpu variable on *cpu*.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3747,6 +3763,7 @@ union bpf_attr {
 	FN(inode_storage_delete),	\
 	FN(d_path),			\
 	FN(copy_from_user),		\
+	FN(bpf_per_cpu_ptr),            \
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 5831d9f3f3c5..4aa22e31774c 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -188,11 +188,6 @@
 	     i < btf_type_vlen(struct_type);				\
 	     i++, member++)
 
-#define for_each_vsi(i, struct_type, member)			\
-	for (i = 0, member = btf_type_var_secinfo(struct_type);	\
-	     i < btf_type_vlen(struct_type);			\
-	     i++, member++)
-
 #define for_each_vsi_from(i, from, struct_type, member)				\
 	for (i = from, member = btf_type_var_secinfo(struct_type) + from;	\
 	     i < btf_type_vlen(struct_type);					\
@@ -513,11 +508,6 @@ static const struct btf_var *btf_type_var(const struct btf_type *t)
 	return (const struct btf_var *)(t + 1);
 }
 
-static const struct btf_var_secinfo *btf_type_var_secinfo(const struct btf_type *t)
-{
-	return (const struct btf_var_secinfo *)(t + 1);
-}
-
 static const struct btf_kind_operations *btf_type_ops(const struct btf_type *t)
 {
 	return kind_ops[BTF_INFO_KIND(t->info)];
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 3b382c080cfd..a702600ff581 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -239,6 +239,7 @@ struct bpf_call_arg_meta {
 	int ref_obj_id;
 	int func_id;
 	u32 btf_id;
+	u32 ret_btf_id;
 };
 
 struct btf *btf_vmlinux;
@@ -504,6 +505,7 @@ static const char * const reg_type_str[] = {
 	[PTR_TO_XDP_SOCK]	= "xdp_sock",
 	[PTR_TO_BTF_ID]		= "ptr_",
 	[PTR_TO_BTF_ID_OR_NULL]	= "ptr_or_null_",
+	[PTR_TO_PERCPU_BTF_ID]	= "percpu_ptr_",
 	[PTR_TO_MEM]		= "mem",
 	[PTR_TO_MEM_OR_NULL]	= "mem_or_null",
 	[PTR_TO_RDONLY_BUF]	= "rdonly_buf",
@@ -570,7 +572,9 @@ static void print_verifier_state(struct bpf_verifier_env *env,
 			/* reg->off should be 0 for SCALAR_VALUE */
 			verbose(env, "%lld", reg->var_off.value + reg->off);
 		} else {
-			if (t == PTR_TO_BTF_ID || t == PTR_TO_BTF_ID_OR_NULL)
+			if (t == PTR_TO_BTF_ID ||
+			    t == PTR_TO_BTF_ID_OR_NULL ||
+			    t == PTR_TO_PERCPU_BTF_ID)
 				verbose(env, "%s", kernel_type_name(reg->btf_id));
 			verbose(env, "(id=%d", reg->id);
 			if (reg_type_may_be_refcounted_or_null(t))
@@ -2184,6 +2188,7 @@ static bool is_spillable_regtype(enum bpf_reg_type type)
 	case PTR_TO_RDONLY_BUF_OR_NULL:
 	case PTR_TO_RDWR_BUF:
 	case PTR_TO_RDWR_BUF_OR_NULL:
+	case PTR_TO_PERCPU_BTF_ID:
 		return true;
 	default:
 		return false;
@@ -4003,6 +4008,15 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 			if (type != expected_type)
 				goto err_type;
 		}
+	} else if (arg_type == ARG_PTR_TO_PERCPU_BTF_ID) {
+		expected_type = PTR_TO_PERCPU_BTF_ID;
+		if (type != expected_type)
+			goto err_type;
+		if (!reg->btf_id) {
+			verbose(env, "Helper has invalid btf_id in R%d\n", regno);
+			return -EACCES;
+		}
+		meta->ret_btf_id = reg->btf_id;
 	} else if (arg_type == ARG_PTR_TO_BTF_ID) {
 		bool ids_match = false;
 
@@ -5002,6 +5016,30 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 		regs[BPF_REG_0].type = PTR_TO_MEM_OR_NULL;
 		regs[BPF_REG_0].id = ++env->id_gen;
 		regs[BPF_REG_0].mem_size = meta.mem_size;
+	} else if (fn->ret_type == RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL) {
+		const struct btf_type *t;
+
+		mark_reg_known_zero(env, regs, BPF_REG_0);
+		t = btf_type_skip_modifiers(btf_vmlinux, meta.ret_btf_id, NULL);
+		if (!btf_type_is_struct(t)) {
+			u32 tsize;
+			const struct btf_type *ret;
+			const char *tname;
+
+			/* resolve the type size of ksym. */
+			ret = btf_resolve_size(btf_vmlinux, t, &tsize);
+			if (IS_ERR(ret)) {
+				tname = btf_name_by_offset(btf_vmlinux, t->name_off);
+				verbose(env, "unable to resolve the size of type '%s': %ld\n",
+					tname, PTR_ERR(ret));
+				return -EINVAL;
+			}
+			regs[BPF_REG_0].type = PTR_TO_MEM_OR_NULL;
+			regs[BPF_REG_0].mem_size = tsize;
+		} else {
+			regs[BPF_REG_0].type = PTR_TO_BTF_ID_OR_NULL;
+			regs[BPF_REG_0].btf_id = meta.ret_btf_id;
+		}
 	} else if (fn->ret_type == RET_PTR_TO_BTF_ID_OR_NULL) {
 		int ret_btf_id;
 
@@ -7407,7 +7445,8 @@ static int check_ld_imm(struct bpf_verifier_env *env, struct bpf_insn *insn)
 		regs[insn->dst_reg].type = type;
 		if (type == PTR_TO_MEM) {
 			regs[insn->dst_reg].mem_size = meta;
-		} else if (type == PTR_TO_BTF_ID) {
+		} else if (type == PTR_TO_BTF_ID ||
+			   type == PTR_TO_PERCPU_BTF_ID) {
 			regs[insn->dst_reg].btf_id = meta;
 		} else {
 			verbose(env, "bpf verifier is misconfigured\n");
@@ -9307,10 +9346,14 @@ static int check_pseudo_btf_id(struct bpf_verifier_env *env,
 			       struct bpf_insn *insn,
 			       struct bpf_insn_aux_data *aux)
 {
-	u32 type, id = insn->imm;
+	u32 datasec_id, type, id = insn->imm;
+	const struct btf_var_secinfo *vsi;
+	const struct btf_type *datasec;
 	const struct btf_type *t;
 	const char *sym_name;
+	bool percpu = false;
 	u64 addr;
+	int i;
 
 	if (!btf_vmlinux) {
 		verbose(env, "%s: btf not available. verifier misconfigured.\n",
@@ -9343,12 +9386,27 @@ static int check_pseudo_btf_id(struct bpf_verifier_env *env,
 		return -ENOENT;
 	}
 
+	datasec_id = btf_find_by_name_kind(btf_vmlinux, ".data..percpu",
+					   BTF_KIND_DATASEC);
+	if (datasec_id > 0) {
+		datasec = btf_type_by_id(btf_vmlinux, datasec_id);
+		for_each_vsi(i, datasec, vsi) {
+			if (vsi->type == id) {
+				percpu = true;
+				break;
+			}
+		}
+	}
+
 	insn[0].imm = (u32)addr;
 	insn[1].imm = addr >> 32;
 
 	type = t->type;
 	t = btf_type_skip_modifiers(btf_vmlinux, type, NULL);
-	if (!btf_type_is_struct(t)) {
+	if (percpu) {
+		aux->pseudo_btf_id_type = PTR_TO_PERCPU_BTF_ID;
+		aux->pseudo_btf_id_meta = type;
+	} else if (!btf_type_is_struct(t)) {
 		const struct btf_type *ret;
 		const char *tname;
 		u32 tsize;
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index b2a5380eb187..d474c1530f87 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1144,6 +1144,22 @@ static const struct bpf_func_proto bpf_d_path_proto = {
 	.allowed	= bpf_d_path_allowed,
 };
 
+BPF_CALL_2(bpf_per_cpu_ptr, const void *, ptr, u32, cpu)
+{
+	if (cpu >= nr_cpu_ids)
+		return 0;
+
+	return (u64)per_cpu_ptr(ptr, cpu);
+}
+
+static const struct bpf_func_proto bpf_per_cpu_ptr_proto = {
+	.func		= bpf_per_cpu_ptr,
+	.gpl_only	= false,
+	.ret_type	= RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL,
+	.arg1_type	= ARG_PTR_TO_PERCPU_BTF_ID,
+	.arg2_type	= ARG_ANYTHING,
+};
+
 const struct bpf_func_proto *
 bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -1230,6 +1246,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_task_stack_proto;
 	case BPF_FUNC_copy_from_user:
 		return prog->aux->sleepable ? &bpf_copy_from_user_proto : NULL;
+	case BPF_FUNC_bpf_per_cpu_ptr:
+		return &bpf_per_cpu_ptr_proto;
 	default:
 		return NULL;
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index ab00ad9b32e5..d0ec94d5bdbf 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3596,6 +3596,22 @@ union bpf_attr {
  * 		the data in *dst*. This is a wrapper of copy_from_user().
  * 	Return
  * 		0 on success, or a negative error in case of failure.
+ *
+ * void *bpf_per_cpu_ptr(const void *percpu_ptr, u32 cpu)
+ *     Description
+ *             Take a pointer to a percpu ksym, *percpu_ptr*, and return a
+ *             pointer to the percpu kernel variable on *cpu*. A ksym is an
+ *             extern variable decorated with '__ksym'. For ksym, there is a
+ *             global var (either static or global) defined of the same name
+ *             in the kernel. The ksym is percpu if the global var is percpu.
+ *             The returned pointer points to the global percpu var on *cpu*.
+ *
+ *             bpf_per_cpu_ptr() has the same semantic as per_cpu_ptr() in the
+ *             kernel, except that bpf_per_cpu_ptr() may return NULL. This
+ *             happens if *cpu* is larger than nr_cpu_ids. The caller of
+ *             bpf_per_cpu_ptr() must check the returned value.
+ *     Return
+ *             A generic pointer pointing to the kernel percpu variable on *cpu*.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3747,6 +3763,7 @@ union bpf_attr {
 	FN(inode_storage_delete),	\
 	FN(d_path),			\
 	FN(copy_from_user),		\
+	FN(bpf_per_cpu_ptr),            \
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.28.0.526.ge36021eeef-goog

