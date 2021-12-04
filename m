Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 069B046853E
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 15:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385156AbhLDOKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 09:10:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:59241 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1385141AbhLDOKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 09:10:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638626837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fy97f1CqrZ7QTLG50aGd3f39RUXo3RV1YxCemTb3pN4=;
        b=ElokiwOFh/ZOHIA7KeqO1ORE+kYRjBwXmQw4ykOvCpPISufHpmo0T30iO1Qrx85OlyOphn
        S8z7E83V8y6JKi88sI94nDROPHKdgN91MtrXjXADxolUmw/aW2HGgHqk7AYw2UdZ42VzrJ
        7t5KtHu6lVdFTr8OcZwzvDXuImE7Rbg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-23-ci2bWTahNkKpH1Rd5Pvm_A-1; Sat, 04 Dec 2021 09:07:16 -0500
X-MC-Unique: ci2bWTahNkKpH1Rd5Pvm_A-1
Received: by mail-wm1-f69.google.com with SMTP id 205-20020a1c00d6000000b003335d1384f1so5132133wma.3
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 06:07:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fy97f1CqrZ7QTLG50aGd3f39RUXo3RV1YxCemTb3pN4=;
        b=YWm2lPNTNtHBYe/CsJEUSZr2CQyuaKFmHfijviFfyOEdX7pcFdl/hKDiQdcH/mYi0X
         erQas+DmpaYI2uEE7REyfXj4KvmrULi3HMzDBAmljP5NgV8Ufjdi0JVfvyH0JgQgrFgz
         bZtCqybPyKaBfSCh/SK6dhmnondqCR2NFp/bgU024YLDn6KNANLzD4bNkH94l54UFkeg
         Qv9AZCzVVD9ngCJHU0q+08QcZtLDO7zNWTFREfDwTCXIIpo5A818h/ih3yrWH7VzR53d
         QM0CWGmz0DAXye4eTwEcLU1qzuKHScuFbYU+erDaOJaKOECvK5LZ0AqN8QfAvtG+cZKr
         Ylkw==
X-Gm-Message-State: AOAM533X/5FcvOTOQsCSca7AKaYET147UryuHrwlkeC4DDUze5Dv3jeH
        yZgQ6fZUZALSbhwBUdFlHENiZ4GkvHBYvgYe8/HoBr4LO5crLzZBIaRy47qM/hiFFMKsEcVSzej
        0MbueEIaEJaIg11g3
X-Received: by 2002:a05:6000:18ac:: with SMTP id b12mr30073552wri.355.1638626834836;
        Sat, 04 Dec 2021 06:07:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyMnHJ5sZbvEYHFxtaP5iF0ydF0lExxBQOALf68sq3yY5BGHYBFtT5R4i4Sax8amTxUdodfeA==
X-Received: by 2002:a05:6000:18ac:: with SMTP id b12mr30073524wri.355.1638626834586;
        Sat, 04 Dec 2021 06:07:14 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id i7sm5608803wro.58.2021.12.04.06.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 06:07:14 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH bpf-next 2/3] bpf: Add get_func_[arg|ret|arg_cnt] helpers
Date:   Sat,  4 Dec 2021 15:06:59 +0100
Message-Id: <20211204140700.396138-3-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211204140700.396138-1-jolsa@kernel.org>
References: <20211204140700.396138-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding following helpers for tracing programs:

Get n-th argument of the traced function:
  long bpf_get_func_arg(void *ctx, u32 n, u64 *value)

Get return value of the traced function:
  long bpf_get_func_ret(void *ctx, u64 *value)

Get arguments count of the traced funtion:
  long bpf_get_func_arg_cnt(void *ctx)

The trampoline now stores number of arguments on ctx-8
address, so it's easy to verify argument index and find
return value argument's position.

Moving function ip address on the trampoline stack behind
the number of functions arguments, so it's now stored on
ctx-16 address if it's needed.

All helpers above are inlined by verifier.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c    | 15 ++++++-
 include/uapi/linux/bpf.h       | 28 +++++++++++++
 kernel/bpf/verifier.c          | 73 +++++++++++++++++++++++++++++++++-
 kernel/trace/bpf_trace.c       | 58 ++++++++++++++++++++++++++-
 tools/include/uapi/linux/bpf.h | 28 +++++++++++++
 5 files changed, 198 insertions(+), 4 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index b106e80e8d9c..142e6b90fa52 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1941,7 +1941,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 				void *orig_call)
 {
 	int ret, i, nr_args = m->nr_args;
-	int regs_off, ip_off, stack_size = nr_args * 8;
+	int regs_off, ip_off, args_off, stack_size = nr_args * 8;
 	struct bpf_tramp_progs *fentry = &tprogs[BPF_TRAMP_FENTRY];
 	struct bpf_tramp_progs *fexit = &tprogs[BPF_TRAMP_FEXIT];
 	struct bpf_tramp_progs *fmod_ret = &tprogs[BPF_TRAMP_MODIFY_RETURN];
@@ -1968,6 +1968,8 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	 *                 [ ...             ]
 	 * RBP - regs_off  [ reg_arg1        ]
 	 *
+	 * RBP - args_off  [ args count      ]  always
+	 *
 	 * RBP - ip_off    [ traced function ]  BPF_TRAMP_F_IP_ARG flag
 	 */
 
@@ -1978,6 +1980,10 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 
 	regs_off = stack_size;
 
+	/* args count  */
+	stack_size += 8;
+	args_off = stack_size;
+
 	if (flags & BPF_TRAMP_F_IP_ARG)
 		stack_size += 8; /* room for IP address argument */
 
@@ -1996,6 +2002,13 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	EMIT4(0x48, 0x83, 0xEC, stack_size); /* sub rsp, stack_size */
 	EMIT1(0x53);		 /* push rbx */
 
+	/* Store number of arguments of the traced function:
+	 *   mov rax, nr_args
+	 *   mov QWORD PTR [rbp - args_off], rax
+	 */
+	emit_mov_imm64(&prog, BPF_REG_0, 0, (u32) nr_args);
+	emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -args_off);
+
 	if (flags & BPF_TRAMP_F_IP_ARG) {
 		/* Store IP address of the traced function:
 		 * mov rax, QWORD PTR [rbp + 8]
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index c26871263f1f..d5a3791071d6 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4983,6 +4983,31 @@ union bpf_attr {
  *	Return
  *		The number of loops performed, **-EINVAL** for invalid **flags**,
  *		**-E2BIG** if **nr_loops** exceeds the maximum number of loops.
+ *
+ * long bpf_get_func_arg(void *ctx, u32 n, u64 *value)
+ *	Description
+ *		Get **n**-th argument (zero based) of the traced function (for tracing programs)
+ *		returned in **value**.
+ *
+ *	Return
+ *		0 on success.
+ *		**-EINVAL** if n >= arguments count of traced function.
+ *
+ * long bpf_get_func_ret(void *ctx, u64 *value)
+ *	Description
+ *		Get return value of the traced function (for tracing programs)
+ *		in **value**.
+ *
+ *	Return
+ *		0 on success.
+ *		**-EINVAL** for tracing programs other than BPF_TRACE_FEXIT or BPF_MODIFY_RETURN.
+ *
+ * long bpf_get_func_arg_cnt(void *ctx)
+ *	Description
+ *		Get number of arguments of the traced function (for tracing programs).
+ *
+ *	Return
+ *		The number of arguments of the traced function.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5167,6 +5192,9 @@ union bpf_attr {
 	FN(kallsyms_lookup_name),	\
 	FN(find_vma),			\
 	FN(loop),			\
+	FN(get_func_arg),		\
+	FN(get_func_ret),		\
+	FN(get_func_arg_cnt),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6522ffdea487..cf6853d3a8e9 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12974,6 +12974,7 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env,
 static int do_misc_fixups(struct bpf_verifier_env *env)
 {
 	struct bpf_prog *prog = env->prog;
+	enum bpf_attach_type eatype = prog->expected_attach_type;
 	bool expect_blinding = bpf_jit_blinding_enabled(prog);
 	enum bpf_prog_type prog_type = resolve_prog_type(prog);
 	struct bpf_insn *insn = prog->insnsi;
@@ -13344,11 +13345,79 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			continue;
 		}
 
+		/* Implement bpf_get_func_arg inline. */
+		if (prog_type == BPF_PROG_TYPE_TRACING &&
+		    insn->imm == BPF_FUNC_get_func_arg) {
+			/* Load nr_args from ctx - 8 */
+			insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8);
+			insn_buf[1] = BPF_JMP32_REG(BPF_JGE, BPF_REG_2, BPF_REG_0, 6);
+			insn_buf[2] = BPF_ALU64_IMM(BPF_LSH, BPF_REG_2, 3);
+			insn_buf[3] = BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_1);
+			insn_buf[4] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_2, 0);
+			insn_buf[5] = BPF_STX_MEM(BPF_DW, BPF_REG_3, BPF_REG_0, 0);
+			insn_buf[6] = BPF_MOV64_IMM(BPF_REG_0, 0);
+			insn_buf[7] = BPF_JMP_A(1);
+			insn_buf[8] = BPF_MOV64_IMM(BPF_REG_0, -EINVAL);
+			cnt = 9;
+
+			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, cnt);
+			if (!new_prog)
+				return -ENOMEM;
+
+			delta    += cnt - 1;
+			env->prog = prog = new_prog;
+			insn      = new_prog->insnsi + i + delta;
+			continue;
+		}
+
+		/* Implement bpf_get_func_ret inline. */
+		if (prog_type == BPF_PROG_TYPE_TRACING &&
+		    insn->imm == BPF_FUNC_get_func_ret) {
+			if (eatype == BPF_TRACE_FEXIT ||
+			    eatype == BPF_MODIFY_RETURN) {
+				/* Load nr_args from ctx - 8 */
+				insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8);
+				insn_buf[1] = BPF_ALU64_IMM(BPF_LSH, BPF_REG_0, 3);
+				insn_buf[2] = BPF_ALU64_REG(BPF_ADD, BPF_REG_0, BPF_REG_1);
+				insn_buf[3] = BPF_LDX_MEM(BPF_DW, BPF_REG_3, BPF_REG_0, 0);
+				insn_buf[4] = BPF_STX_MEM(BPF_DW, BPF_REG_2, BPF_REG_3, 0);
+				insn_buf[5] = BPF_MOV64_IMM(BPF_REG_0, 0);
+				cnt = 6;
+			} else {
+				insn_buf[0] = BPF_MOV64_IMM(BPF_REG_0, -EINVAL);
+				cnt = 1;
+			}
+
+			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, cnt);
+			if (!new_prog)
+				return -ENOMEM;
+
+			delta    += cnt - 1;
+			env->prog = prog = new_prog;
+			insn      = new_prog->insnsi + i + delta;
+			continue;
+		}
+
+		/* Implement get_func_arg_cnt inline. */
+		if (prog_type == BPF_PROG_TYPE_TRACING &&
+		    insn->imm == BPF_FUNC_get_func_arg_cnt) {
+			/* Load nr_args from ctx - 8 */
+			insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8);
+
+			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, 1);
+			if (!new_prog)
+				return -ENOMEM;
+
+			env->prog = prog = new_prog;
+			insn      = new_prog->insnsi + i + delta;
+			continue;
+		}
+
 		/* Implement bpf_get_func_ip inline. */
 		if (prog_type == BPF_PROG_TYPE_TRACING &&
 		    insn->imm == BPF_FUNC_get_func_ip) {
-			/* Load IP address from ctx - 8 */
-			insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8);
+			/* Load IP address from ctx - 16 */
+			insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -16);
 
 			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, 1);
 			if (!new_prog)
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 25ea521fb8f1..d1d4617c9fd5 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1012,7 +1012,7 @@ const struct bpf_func_proto bpf_snprintf_btf_proto = {
 BPF_CALL_1(bpf_get_func_ip_tracing, void *, ctx)
 {
 	/* This helper call is inlined by verifier. */
-	return ((u64 *)ctx)[-1];
+	return ((u64 *)ctx)[-2];
 }
 
 static const struct bpf_func_proto bpf_get_func_ip_proto_tracing = {
@@ -1091,6 +1091,56 @@ static const struct bpf_func_proto bpf_get_branch_snapshot_proto = {
 	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
+BPF_CALL_3(get_func_arg, void *, ctx, u32, n, u64 *, value)
+{
+	/* This helper call is inlined by verifier. */
+	u64 nr_args = ((u64 *)ctx)[-1];
+
+	if ((u64) n >= nr_args)
+		return -EINVAL;
+	*value = ((u64 *)ctx)[n];
+	return 0;
+}
+
+static const struct bpf_func_proto bpf_get_func_arg_proto = {
+	.func		= get_func_arg,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_ANYTHING,
+	.arg3_type	= ARG_PTR_TO_LONG,
+};
+
+BPF_CALL_2(get_func_ret, void *, ctx, u64 *, value)
+{
+	/* This helper call is inlined by verifier. */
+	u64 nr_args = ((u64 *)ctx)[-1];
+
+	*value = ((u64 *)ctx)[nr_args];
+	return 0;
+}
+
+static const struct bpf_func_proto bpf_get_func_ret_proto = {
+	.func		= get_func_ret,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_PTR_TO_LONG,
+};
+
+BPF_CALL_1(get_func_arg_cnt, void *, ctx)
+{
+	/* This helper call is inlined by verifier. */
+	return ((u64 *)ctx)[-1];
+}
+
+static const struct bpf_func_proto bpf_get_func_arg_cnt_proto = {
+	.func		= get_func_arg_cnt,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+};
+
 static const struct bpf_func_proto *
 bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -1212,6 +1262,12 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_find_vma_proto;
 	case BPF_FUNC_trace_vprintk:
 		return bpf_get_trace_vprintk_proto();
+	case BPF_FUNC_get_func_arg:
+		return &bpf_get_func_arg_proto;
+	case BPF_FUNC_get_func_ret:
+		return &bpf_get_func_ret_proto;
+	case BPF_FUNC_get_func_arg_cnt:
+		return &bpf_get_func_arg_cnt_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index c26871263f1f..d5a3791071d6 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4983,6 +4983,31 @@ union bpf_attr {
  *	Return
  *		The number of loops performed, **-EINVAL** for invalid **flags**,
  *		**-E2BIG** if **nr_loops** exceeds the maximum number of loops.
+ *
+ * long bpf_get_func_arg(void *ctx, u32 n, u64 *value)
+ *	Description
+ *		Get **n**-th argument (zero based) of the traced function (for tracing programs)
+ *		returned in **value**.
+ *
+ *	Return
+ *		0 on success.
+ *		**-EINVAL** if n >= arguments count of traced function.
+ *
+ * long bpf_get_func_ret(void *ctx, u64 *value)
+ *	Description
+ *		Get return value of the traced function (for tracing programs)
+ *		in **value**.
+ *
+ *	Return
+ *		0 on success.
+ *		**-EINVAL** for tracing programs other than BPF_TRACE_FEXIT or BPF_MODIFY_RETURN.
+ *
+ * long bpf_get_func_arg_cnt(void *ctx)
+ *	Description
+ *		Get number of arguments of the traced function (for tracing programs).
+ *
+ *	Return
+ *		The number of arguments of the traced function.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5167,6 +5192,9 @@ union bpf_attr {
 	FN(kallsyms_lookup_name),	\
 	FN(find_vma),			\
 	FN(loop),			\
+	FN(get_func_arg),		\
+	FN(get_func_ret),		\
+	FN(get_func_arg_cnt),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.33.1

