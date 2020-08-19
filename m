Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED92E24A990
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 00:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgHSWlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 18:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727905AbgHSWkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 18:40:52 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4919CC06134D
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 15:40:47 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id e196so114091ybh.6
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 15:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=afpt0scmaMzcHXIzp9Twx0dB3tEDbNEdi+Fw7mN7FIw=;
        b=CaHLnB3haQfx6MS2XC38I9D/MfLgVT1XUQHMfUepLNppnOGkbLBb6SsG8xp2hB1g8U
         tC7lmStG8YvCaDdZPVJ9y6PhlH8t6310HFK0znFVybfVuzTCH1LxDNU4GaUYKgr+/osQ
         SCLCNd4Eo7U9VbRDFwLW5Xqz0P0jD+xRUykjThPnNtGIJtjieBvbawYs0ubT8ytXBJT4
         kNsGqSjTt/rS2kNgemuUknrhD8obiU3x8HV6FW8HzYE7HHCbIOEKLRRv5AyHrGgQXt8e
         TadPkVYURET9F3BWrG1yVcvGYWzdofaf+Reg2BhmzEaVhI2hmvwsoMGqzRIbvgdPhBuR
         NFIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=afpt0scmaMzcHXIzp9Twx0dB3tEDbNEdi+Fw7mN7FIw=;
        b=XA6n1IMSU6nSOONLNDgE8SopLrjkwoz3fO31E/QfWL5Lhb+F8jneBOMvnvHaiEMoJv
         Whs8lFPfc8k1/imZcJf2xakPoDypi3RINM6/me70jou3ZVP5FHrRuWHwO0oV3qYmBnuh
         MPFdF2ZXkch/0n5Tf0u4ot4neDCRDGWRh1F+WksZdY1Kn0XN1Zw2zLeNUyqX+vYjUC1P
         MjE3jYfcwsj7lNKTki5y2IKznaYlG3PY8yjI9pLE8VlKOZjwemymqGg87cwWSicE3C1k
         S8/vvIUKFfeCXNEjb4h3NUHkBYDSmG7kSsvPIEkV2Yd3T/WQNc+AEVfeOd0TY6ebim5a
         vEQA==
X-Gm-Message-State: AOAM532ktuKZgtnBd3m6XBWjekEIjzynLvdoewD7IDNAbM3yCOf5JS21
        GcOmD59CQ04FHpMc/n9m1+k6oSpjSDNY72gfmSaoKvMe1OEb9IbHSVpzydH3LoEprFHRDYqdVrW
        XzNocuUvH8nZzEk10R9+emSFAPmWNp9Coo3OF7uHuPJtkmMTTPvyk7HqQ3Om0jA==
X-Google-Smtp-Source: ABdhPJx1SBqLs8Bkr7O8Zl7ClzzAPwhu+tQxqiv7VTVMn7zbURfW1doOwgpZE92q6ImKVA/MAqPhIBzkBew=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:f693:9fff:fef4:e444])
 (user=haoluo job=sendgmr) by 2002:a25:c347:: with SMTP id t68mr961734ybf.105.1597876846395;
 Wed, 19 Aug 2020 15:40:46 -0700 (PDT)
Date:   Wed, 19 Aug 2020 15:40:28 -0700
In-Reply-To: <20200819224030.1615203-1-haoluo@google.com>
Message-Id: <20200819224030.1615203-7-haoluo@google.com>
Mime-Version: 1.0
References: <20200819224030.1615203-1-haoluo@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH bpf-next v1 6/8] bpf: Introduce bpf_per_cpu_ptr()
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

Signed-off-by: Hao Luo <haoluo@google.com>
---
 include/linux/bpf.h      |  3 ++
 include/linux/btf.h      | 11 +++++++
 include/uapi/linux/bpf.h | 14 +++++++++
 kernel/bpf/btf.c         | 10 -------
 kernel/bpf/verifier.c    | 64 ++++++++++++++++++++++++++++++++++++++--
 kernel/trace/bpf_trace.c | 18 +++++++++++
 6 files changed, 107 insertions(+), 13 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 55f694b63164..613404beab33 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -268,6 +268,7 @@ enum bpf_arg_type {
 	ARG_PTR_TO_ALLOC_MEM,	/* pointer to dynamically allocated memory */
 	ARG_PTR_TO_ALLOC_MEM_OR_NULL,	/* pointer to dynamically allocated memory or NULL */
 	ARG_CONST_ALLOC_SIZE_OR_ZERO,	/* number of allocated bytes requested */
+	ARG_PTR_TO_PERCPU_BTF_ID,	/* pointer to in-kernel percpu type */
 };
 
 /* type of values returned from helper functions */
@@ -281,6 +282,7 @@ enum bpf_return_type {
 	RET_PTR_TO_SOCK_COMMON_OR_NULL,	/* returns a pointer to a sock_common or NULL */
 	RET_PTR_TO_ALLOC_MEM_OR_NULL,	/* returns a pointer to dynamically allocated memory or NULL */
 	RET_PTR_TO_BTF_ID_OR_NULL,	/* returns a pointer to a btf_id or NULL */
+	RET_PTR_TO_MEM_OR_BTF_OR_NULL,	/* returns a pointer to a valid memory or a btf_id or NULL */
 };
 
 /* eBPF function prototype used by verifier to allow BPF_CALLs from eBPF programs
@@ -360,6 +362,7 @@ enum bpf_reg_type {
 	PTR_TO_RDONLY_BUF_OR_NULL, /* reg points to a readonly buffer or NULL */
 	PTR_TO_RDWR_BUF,	 /* reg points to a read/write buffer */
 	PTR_TO_RDWR_BUF_OR_NULL, /* reg points to a read/write buffer or NULL */
+	PTR_TO_PERCPU_BTF_ID,	 /* reg points to percpu kernel type */
 };
 
 /* The information passed from prog-specific *_is_valid_access
diff --git a/include/linux/btf.h b/include/linux/btf.h
index cee4089e83c0..dc3509246913 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -72,6 +72,11 @@ btf_resolve_size(const struct btf *btf, const struct btf_type *type,
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
@@ -156,6 +161,12 @@ static inline const struct btf_member *btf_type_member(const struct btf_type *t)
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
index 468376f2910b..c7e49a102ed2 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3415,6 +3415,19 @@ union bpf_attr {
  *		A non-negative value equal to or less than *size* on success,
  *		or a negative error in case of failure.
  *
+ * void *bpf_per_cpu_ptr(const void *ptr, u32 cpu)
+ *	Description
+ *		Take the address of a percpu ksym and return a pointer pointing
+ *		to the variable on *cpu*. A ksym is an extern variable decorated
+ *		with '__ksym'. A ksym is percpu if there is a global percpu var
+ *		(either static or global) defined of the same name in the kernel.
+ *
+ *		bpf_per_cpu_ptr() has the same semantic as per_cpu_ptr() in the
+ *		kernel, except that bpf_per_cpu_ptr() may return NULL. This
+ *		happens if *cpu* is larger than nr_cpu_ids. The caller of
+ *		bpf_per_cpu_ptr() must check the returned value.
+ *	Return
+ *		A generic pointer pointing to the variable on *cpu*.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3559,6 +3572,7 @@ union bpf_attr {
 	FN(skc_to_tcp_request_sock),	\
 	FN(skc_to_udp6_sock),		\
 	FN(get_task_stack),		\
+	FN(bpf_per_cpu_ptr),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index b6d8f653afe2..e735804f5f34 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -186,11 +186,6 @@
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
@@ -511,11 +506,6 @@ static const struct btf_var *btf_type_var(const struct btf_type *t)
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
index 47badde71f83..c2db6308d6fa 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -238,6 +238,7 @@ struct bpf_call_arg_meta {
 	int ref_obj_id;
 	int func_id;
 	u32 btf_id;
+	u32 ret_btf_id;
 };
 
 struct btf *btf_vmlinux;
@@ -503,6 +504,7 @@ static const char * const reg_type_str[] = {
 	[PTR_TO_XDP_SOCK]	= "xdp_sock",
 	[PTR_TO_BTF_ID]		= "ptr_",
 	[PTR_TO_BTF_ID_OR_NULL]	= "ptr_or_null_",
+	[PTR_TO_PERCPU_BTF_ID]	= "percpu_ptr_",
 	[PTR_TO_MEM]		= "mem",
 	[PTR_TO_MEM_OR_NULL]	= "mem_or_null",
 	[PTR_TO_RDONLY_BUF]	= "rdonly_buf",
@@ -569,7 +571,9 @@ static void print_verifier_state(struct bpf_verifier_env *env,
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
@@ -2183,6 +2187,7 @@ static bool is_spillable_regtype(enum bpf_reg_type type)
 	case PTR_TO_RDONLY_BUF_OR_NULL:
 	case PTR_TO_RDWR_BUF:
 	case PTR_TO_RDWR_BUF_OR_NULL:
+	case PTR_TO_PERCPU_BTF_ID:
 		return true;
 	default:
 		return false;
@@ -3959,6 +3964,15 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 			if (type != expected_type)
 				goto err_type;
 		}
+	} else if (arg_type == ARG_PTR_TO_PERCPU_BTF_ID) {
+		expected_type = PTR_TO_PERCPU_BTF_ID;
+		if (type != expected_type)
+			goto err_type;
+		if (!reg->btf_id) {
+			verbose(env, "Helper has zero btf_id in R%d\n", regno);
+			return -EACCES;
+		}
+		meta->ret_btf_id = reg->btf_id;
 	} else if (arg_type == ARG_PTR_TO_BTF_ID) {
 		expected_type = PTR_TO_BTF_ID;
 		if (type != expected_type)
@@ -4904,6 +4918,30 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 		regs[BPF_REG_0].type = PTR_TO_MEM_OR_NULL;
 		regs[BPF_REG_0].id = ++env->id_gen;
 		regs[BPF_REG_0].mem_size = meta.mem_size;
+	} else if (fn->ret_type == RET_PTR_TO_MEM_OR_BTF_OR_NULL) {
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
+			ret = btf_resolve_size(btf_vmlinux, t, &tsize, NULL, NULL);
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
 
@@ -7210,10 +7248,15 @@ static inline int check_pseudo_btf_id(struct bpf_verifier_env *env,
 				      struct bpf_insn *insn)
 {
 	struct bpf_reg_state *regs = cur_regs(env);
-	u32 type, id = insn->imm;
+	u32 datasec_id, type, id = insn->imm;
 	u64 addr;
 	const char *sym_name;
 	const struct btf_type *t = btf_type_by_id(btf_vmlinux, id);
+	const struct btf_type *datasec;
+	const struct btf_var_secinfo *vsi;
+	int i;
+
+	bool percpu = false;
 
 	if (!t) {
 		verbose(env, "%s: invalid btf_id %d\n", __func__, id);
@@ -7243,9 +7286,24 @@ static inline int check_pseudo_btf_id(struct bpf_verifier_env *env,
 	insn[1].imm = addr >> 32;
 	mark_reg_known_zero(env, regs, insn->dst_reg);
 
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
 	type = t->type;
 	t = btf_type_skip_modifiers(btf_vmlinux, type, NULL);
-	if (!btf_type_is_struct(t)) {
+	if (percpu) {
+		regs[insn->dst_reg].type = PTR_TO_PERCPU_BTF_ID;
+		regs[insn->dst_reg].btf_id = type;
+	} else if (!btf_type_is_struct(t)) {
 		u32 tsize;
 		const struct btf_type *ret;
 		const char *tname;
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index a8d4f253ed77..7f0033960d82 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1098,6 +1098,22 @@ static const struct bpf_func_proto bpf_send_signal_thread_proto = {
 	.arg1_type	= ARG_ANYTHING,
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
+	.ret_type	= RET_PTR_TO_MEM_OR_BTF_OR_NULL,
+	.arg1_type	= ARG_PTR_TO_PERCPU_BTF_ID,
+	.arg2_type	= ARG_ANYTHING,
+};
+
 const struct bpf_func_proto *
 bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -1182,6 +1198,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_jiffies64_proto;
 	case BPF_FUNC_get_task_stack:
 		return &bpf_get_task_stack_proto;
+	case BPF_FUNC_bpf_per_cpu_ptr:
+		return &bpf_per_cpu_ptr_proto;
 	default:
 		return NULL;
 	}
-- 
2.28.0.220.ged08abb693-goog

