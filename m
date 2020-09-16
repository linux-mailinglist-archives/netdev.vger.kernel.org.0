Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C43426CED8
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 00:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgIPWiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 18:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbgIPWiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 18:38:04 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73515C061222
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 15:38:03 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id k3so257869ybk.16
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 15:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=H6ZmBHNIlcWXh49fohZxtebGN/ajK82s8lOp9sbc7A4=;
        b=hz3K6ntLTjv75W6gtd9iLg4Ywy313y+4oNNthWavTThkEnBPrS3K1L1iXq24LNvosL
         p9VIEAvJuGc9jh5PviWRks2wvubUtSet2ZU6PCd+z/pIVrWUu6goDC0Q4HfPvAb8WU+i
         WXYNoDZXnFSUOfjn7/i5rXrGiVSchmDzfKhxJNeQhbxW5RvAdXN9rr/XOdWJaKqizn7Q
         op2OVnrCQ/wvJB+4tgQsMYe2TsZ5ltUSxmfDPOhOJnencwSbgZBF/YGWkG/5T36VTwdT
         6qdwPfktlg33PUOiJI2P4XRP0bXYrgk9kl3LkIzCqo7CsKCI5PvZtJmelBAabfkvZRz8
         8ojg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=H6ZmBHNIlcWXh49fohZxtebGN/ajK82s8lOp9sbc7A4=;
        b=KavMG4AFQVhKs5Gjzqc/xay7GUsXXIGHBgJCIFpJplMY9gio/eB/3e9+ivOBQxb1Yr
         tdcQG+BHU1+FF/GKwPcHON0mFWzM/T8oKEi++swp2XnHmg16mJO6r8YCcU/Eyp+95mmo
         puT3Oyg7cxe+75WQSV9H2qSBL9nQsbrYyYyJ05YcbHiJJaU09z90IqJi5CxsCCZeEGun
         el7EsFj8qEgvza2UjIvtDj8zOgGWvU7trXjxoSQ0YPtheqBFX/gchZMI6M8ZCy7IIanz
         6MQ4APfta/5OIPCbcMipzGVvVm5G1FoA/h6es/wXlagcECvg2werm5Pk1Y6hu/eICw9B
         MH8A==
X-Gm-Message-State: AOAM531gogzSQ+b7cQefWe/V8mWgEsMQ9Lh8kWK8/qAXP/CI4jEgrw7J
        zAQXhKUIsHLRrfV85J2YgyEtEUKm9T/4jcDUreZ1opnYPwGbYaNWy6wIdZEcMGGWOyAhHcHGpUX
        TOU4TI7u+NzHHAB1nKwRCy/fSr8XwlDouLu4h4KjBktIJzYvHi9wv/20lxjzt0g==
X-Google-Smtp-Source: ABdhPJyv9Y4hN7+iTDfB8hp6VYiOBLxX9J9WiPV08j1Ok5R3UURLarPkPk52EhQdbx2hEFChUx1llaKbM0Q=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:f693:9fff:fef4:e444])
 (user=haoluo job=sendgmr) by 2002:a25:b186:: with SMTP id h6mr33624465ybj.24.1600295882651;
 Wed, 16 Sep 2020 15:38:02 -0700 (PDT)
Date:   Wed, 16 Sep 2020 15:35:11 -0700
In-Reply-To: <20200916223512.2885524-1-haoluo@google.com>
Message-Id: <20200916223512.2885524-6-haoluo@google.com>
Mime-Version: 1.0
References: <20200916223512.2885524-1-haoluo@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH bpf-next v3 5/6] bpf: Introduce bpf_this_cpu_ptr()
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
index 980907e837dd..d73c63150d51 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -307,6 +307,7 @@ enum bpf_return_type {
 	RET_PTR_TO_ALLOC_MEM_OR_NULL,	/* returns a pointer to dynamically allocated memory or NULL */
 	RET_PTR_TO_BTF_ID_OR_NULL,	/* returns a pointer to a btf_id or NULL */
 	RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL, /* returns a pointer to a valid memory or a btf_id or NULL */
+	RET_PTR_TO_MEM_OR_BTF_ID,	/* returns a pointer to a valid memory or a btf_id */
 };
 
 /* eBPF function prototype used by verifier to allow BPF_CALLs from eBPF programs
@@ -1790,6 +1791,7 @@ extern const struct bpf_func_proto bpf_skc_to_tcp_request_sock_proto;
 extern const struct bpf_func_proto bpf_skc_to_udp6_sock_proto;
 extern const struct bpf_func_proto bpf_copy_from_user_proto;
 extern const struct bpf_func_proto bpf_per_cpu_ptr_proto;
+extern const struct bpf_func_proto bpf_this_cpu_ptr_proto;
 
 const struct bpf_func_proto *bpf_tracing_func_proto(
 	enum bpf_func_id func_id, const struct bpf_prog *prog);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index ed6fd7ab1f0c..b6e8c0995005 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3621,6 +3621,18 @@ union bpf_attr {
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
@@ -3773,6 +3785,7 @@ union bpf_attr {
 	FN(d_path),			\
 	FN(copy_from_user),		\
 	FN(bpf_per_cpu_ptr),            \
+	FN(bpf_this_cpu_ptr),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index b5a64ce49597..8452fa251ebb 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -639,6 +639,18 @@ const struct bpf_func_proto bpf_per_cpu_ptr_proto = {
 	.arg2_type	= ARG_ANYTHING,
 };
 
+BPF_CALL_1(bpf_this_cpu_ptr, const void *, percpu_ptr)
+{
+	return (unsigned long)this_cpu_ptr(percpu_ptr);
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
@@ -703,6 +715,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_jiffies64_proto;
 	case BPF_FUNC_bpf_per_cpu_ptr:
 		return &bpf_per_cpu_ptr_proto;
+	case BPF_FUNC_bpf_this_cpu_ptr:
+		return &bpf_this_cpu_ptr_proto;
 	default:
 		break;
 	}
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6771d2e2ab9f..a033cba90271 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5016,7 +5016,8 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 		regs[BPF_REG_0].type = PTR_TO_MEM_OR_NULL;
 		regs[BPF_REG_0].id = ++env->id_gen;
 		regs[BPF_REG_0].mem_size = meta.mem_size;
-	} else if (fn->ret_type == RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL) {
+	} else if (fn->ret_type == RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL ||
+		   fn->ret_type == RET_PTR_TO_MEM_OR_BTF_ID) {
 		const struct btf_type *t;
 
 		mark_reg_known_zero(env, regs, BPF_REG_0);
@@ -5034,10 +5035,14 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
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
index 4e01c98a16d8..a24195fe3d68 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1232,6 +1232,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return prog->aux->sleepable ? &bpf_copy_from_user_proto : NULL;
 	case BPF_FUNC_bpf_per_cpu_ptr:
 		return &bpf_per_cpu_ptr_proto;
+	case BPF_FUNC_bpf_this_cpu_ptr:
+		return &bpf_this_cpu_ptr_proto;
 	default:
 		return NULL;
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index ed6fd7ab1f0c..b6e8c0995005 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3621,6 +3621,18 @@ union bpf_attr {
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
@@ -3773,6 +3785,7 @@ union bpf_attr {
 	FN(d_path),			\
 	FN(copy_from_user),		\
 	FN(bpf_per_cpu_ptr),            \
+	FN(bpf_this_cpu_ptr),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.28.0.618.gf4bc123cb7-goog

