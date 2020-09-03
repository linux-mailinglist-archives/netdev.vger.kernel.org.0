Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B093125CDA9
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 00:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbgICWeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 18:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728988AbgICWdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 18:33:47 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230A0C06125C
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 15:33:46 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id q131so2451992qke.22
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 15:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=9i0t6QWb3/RQSionlukUT9JC2EpIJE7Rdq9kEE4nRBE=;
        b=wQY2ZOv4ZnWeqSNvQnlAtKTfs/MtMvPlJpYrujbAj3utXBR/a5ZX7wMIJDVsCUoJSo
         1fvjuM5XZno4/Xu1ageYgSGEPgUFWGBOV+ugYZ7HHEPhEZPq5/b2nLB7oqkMgEiqCquC
         FIskpfYRBe0q4mTCNypnGwT7pRUFyVyOZzXB6T240T54dZ4nTPrOiovViMFJveedxRgt
         0NmgbI8xDYecZvyaL5em5lo7vfriN802driPBwsdFXDfOzrjJXcgegIxAIqXIyLwAp0l
         2dFO7xqUW7j5lArbfu13xWlhD+b9114cROi84CqOEi685eepj//DeMlFJovvbw9uuIJU
         GY+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9i0t6QWb3/RQSionlukUT9JC2EpIJE7Rdq9kEE4nRBE=;
        b=lhoB9hhsNyD5c7VsQ/0+7bIDREUOcPMTpGUjQ+SqLqXtaOLrPSsJtFNwpYunhVKw3J
         kR97kwk9i/FMv3sTlliK5HSQbGNs5mbD9MyFQar8fU2aqg0SC0hzgnKcfzuyqzlQELU4
         bxr803OPcvBWGPAv/P2zW4dycE6RWjeOYsSs1Jnga2x2VorciFwJYVFHa8KmrOdnnv7M
         N3J7b7esjFsF+7/HbvYewsKllz8NnGVEY57JZCTcMuqf2QSnDQq8+qtgSkdIIPZKqFIT
         qD+Z9B71LzuY5nl2JZ/ETpT3w8Uwn0K1qMIbX3rJAHgNKhcRyhTA52TUuk/x3dKe+TKW
         xBnA==
X-Gm-Message-State: AOAM533VHu7y33W+iUIidQXlPfXMswlXB7sUMz3iGQ2bsl2AKB1+1fog
        ivREe+2DFXrfYAvnsvSMQshAy969wTr41DZJxgu7EzCUxbh3Q+vL0TuM7paJkTYZlv/9Dy7h38i
        R1ux+7I4KrUD1/ynbAzpXAeG7q6q0u5TCFyh6U46v4BN6Xr5R6V9A0ABIblGJ2Q==
X-Google-Smtp-Source: ABdhPJybi3nNfCHJvoO/aitmOVPd8wjroRs7m8AeqtNAymOVR52z8UV9xYyh6ny4zD1F6m7Yfjp2Pp4ogm4=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:f693:9fff:fef4:e444])
 (user=haoluo job=sendgmr) by 2002:a0c:e188:: with SMTP id p8mr4011448qvl.9.1599172425120;
 Thu, 03 Sep 2020 15:33:45 -0700 (PDT)
Date:   Thu,  3 Sep 2020 15:33:31 -0700
In-Reply-To: <20200903223332.881541-1-haoluo@google.com>
Message-Id: <20200903223332.881541-6-haoluo@google.com>
Mime-Version: 1.0
References: <20200903223332.881541-1-haoluo@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH bpf-next v2 5/6] bpf: Introduce bpf_this_cpu_ptr()
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

Add bpf_this_cpu_ptr() to help access percpu var on this cpu. This
helper always returns a valid pointer, therefore no need to check
returned value for NULL. Also note that all programs run with
preemption disabled, which means that the returned pointer is stable
during all the execution of the program.

Signed-off-by: Hao Luo <haoluo@google.com>
---
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       | 14 ++++++++++++++
 kernel/bpf/verifier.c          | 10 +++++++---
 kernel/trace/bpf_trace.c       | 14 ++++++++++++++
 tools/include/uapi/linux/bpf.h | 14 ++++++++++++++
 5 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 6b2034f7665e..506fdd5d0463 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -307,6 +307,7 @@ enum bpf_return_type {
 	RET_PTR_TO_ALLOC_MEM_OR_NULL,	/* returns a pointer to dynamically allocated memory or NULL */
 	RET_PTR_TO_BTF_ID_OR_NULL,	/* returns a pointer to a btf_id or NULL */
 	RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL, /* returns a pointer to a valid memory or a btf_id or NULL */
+	RET_PTR_TO_MEM_OR_BTF_ID,	/* returns a pointer to a valid memory or a btf_id */
 };
 
 /* eBPF function prototype used by verifier to allow BPF_CALLs from eBPF programs
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index d0ec94d5bdbf..e7ca91c697ed 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3612,6 +3612,19 @@ union bpf_attr {
  *             bpf_per_cpu_ptr() must check the returned value.
  *     Return
  *             A generic pointer pointing to the kernel percpu variable on *cpu*.
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
+ *		A generic pointer pointing to the kernel percpu variable on
+ *		this cpu.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3764,6 +3777,7 @@ union bpf_attr {
 	FN(d_path),			\
 	FN(copy_from_user),		\
 	FN(bpf_per_cpu_ptr),            \
+	FN(bpf_this_cpu_ptr),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a702600ff581..e070d2abc405 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5016,8 +5016,10 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 		regs[BPF_REG_0].type = PTR_TO_MEM_OR_NULL;
 		regs[BPF_REG_0].id = ++env->id_gen;
 		regs[BPF_REG_0].mem_size = meta.mem_size;
-	} else if (fn->ret_type == RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL) {
+	} else if (fn->ret_type == RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL ||
+		   fn->ret_type == RET_PTR_TO_MEM_OR_BTF_ID) {
 		const struct btf_type *t;
+		bool not_null = fn->ret_type == RET_PTR_TO_MEM_OR_BTF_ID;
 
 		mark_reg_known_zero(env, regs, BPF_REG_0);
 		t = btf_type_skip_modifiers(btf_vmlinux, meta.ret_btf_id, NULL);
@@ -5034,10 +5036,12 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 					tname, PTR_ERR(ret));
 				return -EINVAL;
 			}
-			regs[BPF_REG_0].type = PTR_TO_MEM_OR_NULL;
+			regs[BPF_REG_0].type = not_null ?
+				PTR_TO_MEM : PTR_TO_MEM_OR_NULL;
 			regs[BPF_REG_0].mem_size = tsize;
 		} else {
-			regs[BPF_REG_0].type = PTR_TO_BTF_ID_OR_NULL;
+			regs[BPF_REG_0].type = not_null ?
+				PTR_TO_BTF_ID : PTR_TO_BTF_ID_OR_NULL;
 			regs[BPF_REG_0].btf_id = meta.ret_btf_id;
 		}
 	} else if (fn->ret_type == RET_PTR_TO_BTF_ID_OR_NULL) {
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index d474c1530f87..466acf82a9c7 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1160,6 +1160,18 @@ static const struct bpf_func_proto bpf_per_cpu_ptr_proto = {
 	.arg2_type	= ARG_ANYTHING,
 };
 
+BPF_CALL_1(bpf_this_cpu_ptr, const void *, percpu_ptr)
+{
+	return (u64)this_cpu_ptr(percpu_ptr);
+}
+
+static const struct bpf_func_proto bpf_this_cpu_ptr_proto = {
+	.func		= bpf_this_cpu_ptr,
+	.gpl_only	= false,
+	.ret_type	= RET_PTR_TO_MEM_OR_BTF_ID,
+	.arg1_type	= ARG_PTR_TO_PERCPU_BTF_ID,
+};
+
 const struct bpf_func_proto *
 bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -1248,6 +1260,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return prog->aux->sleepable ? &bpf_copy_from_user_proto : NULL;
 	case BPF_FUNC_bpf_per_cpu_ptr:
 		return &bpf_per_cpu_ptr_proto;
+	case BPF_FUNC_bpf_this_cpu_ptr:
+		return &bpf_this_cpu_ptr_proto;
 	default:
 		return NULL;
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index d0ec94d5bdbf..e7ca91c697ed 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3612,6 +3612,19 @@ union bpf_attr {
  *             bpf_per_cpu_ptr() must check the returned value.
  *     Return
  *             A generic pointer pointing to the kernel percpu variable on *cpu*.
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
+ *		A generic pointer pointing to the kernel percpu variable on
+ *		this cpu.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3764,6 +3777,7 @@ union bpf_attr {
 	FN(d_path),			\
 	FN(copy_from_user),		\
 	FN(bpf_per_cpu_ptr),            \
+	FN(bpf_this_cpu_ptr),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.28.0.526.ge36021eeef-goog

