Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEF127DD12
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 01:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729678AbgI2Xvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 19:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729127AbgI2XvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 19:51:17 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A08C0613DA
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 16:51:05 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id s128so6691802ybc.21
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 16:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=oZ34IDN4PvgG8eYWuVE6yYAnqnV9VjHwLOqvMFaCnG4=;
        b=Rd+SVfPuulplK1E109Equtk/M5beOIneDgAfiYgJY2AU8DTGX6OVr13ECLolfHv1Z2
         WIuef+JtNsL/7r6sJ7O6GhqMDFEX1/aYDzzhCf8tbgT66bkODmteH3yAFBUTEFW9uhmv
         TN0wd4Updh0CIRe3fPB8hFcIwbLRZHKeG+7LCNeakDQWf0cXu/OgEsprB7G0VuDYcMv9
         NiAOafcF7RIiUTskr/92QZgAt6aNM4DhBSihQiXmA4jvv+ARMYlHpfIf2eV92JUD3kot
         0IGjFFJmFaBjPPPyRi5rfgHF6o3AC3ftzKvRgAcwPtezN0x2hfYniWxvRXJJYa9PkTmN
         peZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oZ34IDN4PvgG8eYWuVE6yYAnqnV9VjHwLOqvMFaCnG4=;
        b=M7M+tBPov/lh0ezq3W7T+7XW1vjz78TBFIEKfx9dtGhWQnrMrmjEt0j7oWM/zVMXFj
         FdhLz4fXKKYKsnvlnTVLCo9rVc7kTgG/q/Zn4kSvuE5evS+sMFzB/IIYipp+E14FyO5b
         gWXFmOe6XJx+cBPk0QW2P30CPA8bNeOPPIVoj8+UBsS9obxKooET1WvOyRbEbeKd2YGh
         jTp37EZWWLYRsFPJ4rH8XDNOurQtrmOp04TJ7Q2DM7UC0G2qexqnnCG5eeLbkKDP9PNB
         nXLtK1ojCGRSWdc2OOS8d9mZIRzauqLxKUPxkgCd3AbtDWoeFvxU8P5TPBDA+1nGR2oT
         eScA==
X-Gm-Message-State: AOAM531OQAF57PtoJTb0CYeF9X00sj/2AomawlJllkaXmGi9V1lZPN4C
        3ZQRS4e0p355mq+Le0Dkd0DD9uKQdoPJERrfsWgbSuBqUwItupWTOxEfke1cW0RcpcBAgBdcGp8
        KePND+rDHmUwLQx3esn59DEwXcKJsxAeqU5IjKDIxZ9Gy2jl9zqcia6aKHFlWRg==
X-Google-Smtp-Source: ABdhPJyRwrFW8nDN3cFC4o4OI3uF8P5xyz5wlnYgk2pIlVFxBvpcnGY33y/MInNGGp5omDhVJLV6nmPAFzs=
Sender: "haoluo via sendgmr" <haoluo@haoluo.svl.corp.google.com>
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:f693:9fff:fef4:e444])
 (user=haoluo job=sendgmr) by 2002:a25:b31f:: with SMTP id l31mr9908979ybj.198.1601423464570;
 Tue, 29 Sep 2020 16:51:04 -0700 (PDT)
Date:   Tue, 29 Sep 2020 16:50:48 -0700
In-Reply-To: <20200929235049.2533242-1-haoluo@google.com>
Message-Id: <20200929235049.2533242-6-haoluo@google.com>
Mime-Version: 1.0
References: <20200929235049.2533242-1-haoluo@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH bpf-next v4 5/6] bpf: Introducte bpf_this_cpu_ptr()
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
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpf_this_cpu_ptr() to help access percpu var on this cpu. This
helper always returns a valid pointer, therefore no need to check
returned value for NULL. Also note that all programs run with
preemption disabled, which means that the returned pointer is stable
during all the execution of the program.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Hao Luo <haoluo@google.com>
---
 include/linux/bpf.h            |  2 ++
 include/uapi/linux/bpf.h       | 13 +++++++++++++
 kernel/bpf/helpers.c           | 14 ++++++++++++++
 kernel/bpf/verifier.c          | 11 ++++++++---
 kernel/trace/bpf_trace.c       |  2 ++
 tools/include/uapi/linux/bpf.h | 13 +++++++++++++
 6 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 9dde15b2479d..dc63eeed4fd9 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -309,6 +309,7 @@ enum bpf_return_type {
 	RET_PTR_TO_ALLOC_MEM_OR_NULL,	/* returns a pointer to dynamically allocated memory or NULL */
 	RET_PTR_TO_BTF_ID_OR_NULL,	/* returns a pointer to a btf_id or NULL */
 	RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL, /* returns a pointer to a valid memory or a btf_id or NULL */
+	RET_PTR_TO_MEM_OR_BTF_ID,	/* returns a pointer to a valid memory or a btf_id */
 };
 
 /* eBPF function prototype used by verifier to allow BPF_CALLs from eBPF programs
@@ -1832,6 +1833,7 @@ extern const struct bpf_func_proto bpf_skc_to_udp6_sock_proto;
 extern const struct bpf_func_proto bpf_copy_from_user_proto;
 extern const struct bpf_func_proto bpf_snprintf_btf_proto;
 extern const struct bpf_func_proto bpf_per_cpu_ptr_proto;
+extern const struct bpf_func_proto bpf_this_cpu_ptr_proto;
 
 const struct bpf_func_proto *bpf_tracing_func_proto(
 	enum bpf_func_id func_id, const struct bpf_prog *prog);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index feae87eaa8c6..8b360fd42094 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3678,6 +3678,18 @@ union bpf_attr {
  *     Return
  *             A pointer pointing to the kernel percpu variable on *cpu*, or
  *             NULL, if *cpu* is invalid.
+ *
+ * void *bpf_this_cpu_ptr(const void *percpu_ptr)
+ *	Description
+ *		Take a pointer to a percpu ksym, *percpu_ptr*, and return a
+ *		pointer to the percpu kernel variable on this cpu. See the
+ *		description of 'ksym' in **bpf_per_cpu_ptr**\ ().
+ *
+ *		bpf_this_cpu_ptr() has the same semantic as this_cpu_ptr() in
+ *		the kernel. Different from **bpf_per_cpu_ptr**\ (), it would
+ *		never return NULL.
+ *	Return
+ *		A pointer pointing to the kernel percpu variable on this cpu.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3832,6 +3844,7 @@ union bpf_attr {
 	FN(snprintf_btf),		\
 	FN(seq_printf_btf),		\
 	FN(bpf_per_cpu_ptr),            \
+	FN(bpf_this_cpu_ptr),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 14fe3f64fd82..25520f5eeaf6 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -639,6 +639,18 @@ const struct bpf_func_proto bpf_per_cpu_ptr_proto = {
 	.arg2_type	= ARG_ANYTHING,
 };
 
+BPF_CALL_1(bpf_this_cpu_ptr, const void *, percpu_ptr)
+{
+	return (unsigned long)this_cpu_ptr((const void __percpu *)percpu_ptr);
+}
+
+const struct bpf_func_proto bpf_this_cpu_ptr_proto = {
+	.func		= bpf_this_cpu_ptr,
+	.gpl_only	= false,
+	.ret_type	= RET_PTR_TO_MEM_OR_BTF_ID,
+	.arg1_type	= ARG_PTR_TO_PERCPU_BTF_ID,
+};
+
 const struct bpf_func_proto bpf_get_current_task_proto __weak;
 const struct bpf_func_proto bpf_probe_read_user_proto __weak;
 const struct bpf_func_proto bpf_probe_read_user_str_proto __weak;
@@ -707,6 +719,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_jiffies64_proto;
 	case BPF_FUNC_bpf_per_cpu_ptr:
 		return &bpf_per_cpu_ptr_proto;
+	case BPF_FUNC_bpf_this_cpu_ptr:
+		return &bpf_this_cpu_ptr_proto;
 	default:
 		break;
 	}
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 216b8ece23ce..d9dbf271ebab 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5128,7 +5128,8 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 		regs[BPF_REG_0].type = PTR_TO_MEM_OR_NULL;
 		regs[BPF_REG_0].id = ++env->id_gen;
 		regs[BPF_REG_0].mem_size = meta.mem_size;
-	} else if (fn->ret_type == RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL) {
+	} else if (fn->ret_type == RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL ||
+		   fn->ret_type == RET_PTR_TO_MEM_OR_BTF_ID) {
 		const struct btf_type *t;
 
 		mark_reg_known_zero(env, regs, BPF_REG_0);
@@ -5146,10 +5147,14 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 					tname, PTR_ERR(ret));
 				return -EINVAL;
 			}
-			regs[BPF_REG_0].type = PTR_TO_MEM_OR_NULL;
+			regs[BPF_REG_0].type =
+				fn->ret_type == RET_PTR_TO_MEM_OR_BTF_ID ?
+				PTR_TO_MEM : PTR_TO_MEM_OR_NULL;
 			regs[BPF_REG_0].mem_size = tsize;
 		} else {
-			regs[BPF_REG_0].type = PTR_TO_BTF_ID_OR_NULL;
+			regs[BPF_REG_0].type =
+				fn->ret_type == RET_PTR_TO_MEM_OR_BTF_ID ?
+				PTR_TO_BTF_ID : PTR_TO_BTF_ID_OR_NULL;
 			regs[BPF_REG_0].btf_id = meta.ret_btf_id;
 		}
 	} else if (fn->ret_type == RET_PTR_TO_BTF_ID_OR_NULL) {
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 364a322e2898..a136a6a63a71 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1329,6 +1329,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_snprintf_btf_proto;
 	case BPF_FUNC_bpf_per_cpu_ptr:
 		return &bpf_per_cpu_ptr_proto;
+	case BPF_FUNC_bpf_this_cpu_ptr:
+		return &bpf_this_cpu_ptr_proto;
 	default:
 		return NULL;
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index feae87eaa8c6..8b360fd42094 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3678,6 +3678,18 @@ union bpf_attr {
  *     Return
  *             A pointer pointing to the kernel percpu variable on *cpu*, or
  *             NULL, if *cpu* is invalid.
+ *
+ * void *bpf_this_cpu_ptr(const void *percpu_ptr)
+ *	Description
+ *		Take a pointer to a percpu ksym, *percpu_ptr*, and return a
+ *		pointer to the percpu kernel variable on this cpu. See the
+ *		description of 'ksym' in **bpf_per_cpu_ptr**\ ().
+ *
+ *		bpf_this_cpu_ptr() has the same semantic as this_cpu_ptr() in
+ *		the kernel. Different from **bpf_per_cpu_ptr**\ (), it would
+ *		never return NULL.
+ *	Return
+ *		A pointer pointing to the kernel percpu variable on this cpu.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3832,6 +3844,7 @@ union bpf_attr {
 	FN(snprintf_btf),		\
 	FN(seq_printf_btf),		\
 	FN(bpf_per_cpu_ptr),            \
+	FN(bpf_this_cpu_ptr),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.28.0.709.gb0816b6eb0-goog

