Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 862BE6214FE
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 15:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbiKHOHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 09:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235102AbiKHOHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 09:07:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B222E70563
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 06:06:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667916368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dVvkgZ8BF9CC85JQ/vfrhCVMFoovZDzaH0lpMRAf/NY=;
        b=TQQknR69QkRjiY8GCfYllGGNUlU8/N5GN6OKYF/eIpwqglv2AYAC68YYoUko+d52z8qNIW
        z+n5GxOZ171l4rsBEBVz1JRMF5PwmHqvtH3FN5pCjlt0vgwuK9YNg4q5S+UhRGOuH0CkP9
        EsI8MOBbCkUReJ7ZtpFNcUOYlhEHBgQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-267-NrOmnHpLMqaYulAr6XQcUg-1; Tue, 08 Nov 2022 09:06:07 -0500
X-MC-Unique: NrOmnHpLMqaYulAr6XQcUg-1
Received: by mail-ej1-f72.google.com with SMTP id sg37-20020a170907a42500b007adaedb5ba2so8430314ejc.18
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 06:06:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dVvkgZ8BF9CC85JQ/vfrhCVMFoovZDzaH0lpMRAf/NY=;
        b=kPQXpCiz6xOPDUXL8FvGDywVaKIkPWDQ6IH3pNNHA9C0DdSaxIYeHu0lRq4dLSegYs
         EzVFpTvOWuKG9XstWD04GhH1b1Q1QPdkoHEq4Uh7lioL8V1GricRai36QNFUoAKVXVJz
         gL6MzvcpnUPPBdhGZL/jlTpykmie808AnPyfpAWk1TrUEpnb0BaP4bIRO47oQQlzRxa+
         I62BWWTQtJilx+YxxTmj4dXHVI2td0/No8KeOR4SC48mf54AnKMNxnWPNeupDAX2JkuD
         sArklngWWZPEXZtvkU7RTefJQPARGW0l9hOw7rrUHGUbPYKxyN2zA3TPPEiB0Rpd+Llz
         gt1Q==
X-Gm-Message-State: ACrzQf3/r6QqTNA9NRNJ9by0cHR7pYgL7Kam2d/OWsUr4X053J4jN0Bc
        jJYF5s6AqzbbzqRLg55Z+pnHHA1B/05t49aMx3rzOVh8Y1EfKKSFtHFRUlo5WBt3VjTjBogtWaT
        QNKjQ9ux0ZtLLpN56
X-Received: by 2002:a17:907:6d88:b0:7ad:b5f1:8ffc with SMTP id sb8-20020a1709076d8800b007adb5f18ffcmr52498323ejc.727.1667916366011;
        Tue, 08 Nov 2022 06:06:06 -0800 (PST)
X-Google-Smtp-Source: AMsMyM6mwU6kKJ1f9uB19r3RGzfYNHovoxF5ytPa619e6EiWlgBzSmcCmo73OD7s58GwK+3BFLJa9w==
X-Received: by 2002:a17:907:6d88:b0:7ad:b5f1:8ffc with SMTP id sb8-20020a1709076d8800b007adb5f18ffcmr52498262ejc.727.1667916365475;
        Tue, 08 Nov 2022 06:06:05 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id s18-20020aa7c552000000b00461c1804cdasm5618185edr.3.2022.11.08.06.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 06:06:05 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5E527781531; Tue,  8 Nov 2022 15:06:04 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 3/3] bpf: Use 64-bit return value for bpf_prog_run
Date:   Tue,  8 Nov 2022 15:06:01 +0100
Message-Id: <20221108140601.149971-4-toke@redhat.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108140601.149971-1-toke@redhat.com>
References: <20221108140601.149971-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

BPF ABI always uses 64-bit return value, but so far __bpf_prog_run and
higher level wrappers always truncated the return value to 32-bit. We
want to be able to introduce a new BPF program type that returns a
PTR_TO_BTF_ID or NULL from the BPF program to the caller context in the
kernel. To be able to use this returned pointer value, the bpf_prog_run
invocation needs to be able to return a 64-bit value, so update the
definitions to allow this.

To avoid code churn in the whole kernel, we let the compiler handle
truncation normally, and allow new call sites to utilize the 64-bit
return value, by receiving the return value as a u64.

Only the cgroup_bpf_lsm functions have been modified apart from the
generic bpf_prog_run wrappers, as their prototype needs to match
bpf_func_t to be called generically, but otherwise none of other cases
have been modified yet. It will be done when a specific call site
requires handling of the 64-bit return value from the BPF program.

Acked-by: Song Liu <song@kernel.org>
Reviewed-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/bpf-cgroup.h | 12 ++++++------
 include/linux/bpf.h        | 22 +++++++++++-----------
 include/linux/filter.h     | 30 +++++++++++++++---------------
 kernel/bpf/cgroup.c        | 12 ++++++------
 kernel/bpf/core.c          | 14 +++++++-------
 kernel/bpf/offload.c       |  4 ++--
 net/packet/af_packet.c     |  7 +++++--
 7 files changed, 52 insertions(+), 49 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 57e9e109257e..85ae187e5d41 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -23,12 +23,12 @@ struct ctl_table;
 struct ctl_table_header;
 struct task_struct;
 
-unsigned int __cgroup_bpf_run_lsm_sock(const void *ctx,
-				       const struct bpf_insn *insn);
-unsigned int __cgroup_bpf_run_lsm_socket(const void *ctx,
-					 const struct bpf_insn *insn);
-unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
-					  const struct bpf_insn *insn);
+u64 __cgroup_bpf_run_lsm_sock(const void *ctx,
+			      const struct bpf_insn *insn);
+u64 __cgroup_bpf_run_lsm_socket(const void *ctx,
+				const struct bpf_insn *insn);
+u64 __cgroup_bpf_run_lsm_current(const void *ctx,
+				 const struct bpf_insn *insn);
 
 #ifdef CONFIG_CGROUP_BPF
 
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 863a5db1e370..8f1190a0fc62 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -59,8 +59,8 @@ typedef u64 (*bpf_callback_t)(u64, u64, u64, u64, u64);
 typedef int (*bpf_iter_init_seq_priv_t)(void *private_data,
 					struct bpf_iter_aux_info *aux);
 typedef void (*bpf_iter_fini_seq_priv_t)(void *private_data);
-typedef unsigned int (*bpf_func_t)(const void *,
-				   const struct bpf_insn *);
+typedef u64 (*bpf_func_t)(const void *,
+			  const struct bpf_insn *);
 struct bpf_iter_seq_info {
 	const struct seq_operations *seq_ops;
 	bpf_iter_init_seq_priv_t init_seq_private;
@@ -1004,7 +1004,7 @@ struct bpf_dispatcher {
 	struct bpf_ksym ksym;
 };
 
-static __always_inline __nocfi unsigned int bpf_dispatcher_nop_func(
+static __always_inline __nocfi u64 bpf_dispatcher_nop_func(
 	const void *ctx,
 	const struct bpf_insn *insnsi,
 	bpf_func_t bpf_func)
@@ -1049,7 +1049,7 @@ int __init bpf_arch_init_dispatcher_early(void *ip);
 
 #define DEFINE_BPF_DISPATCHER(name)					\
 	notrace BPF_DISPATCHER_ATTRIBUTES				\
-	noinline __nocfi unsigned int bpf_dispatcher_##name##_func(	\
+	noinline __nocfi u64 bpf_dispatcher_##name##_func(		\
 		const void *ctx,					\
 		const struct bpf_insn *insnsi,				\
 		bpf_func_t bpf_func)					\
@@ -1062,7 +1062,7 @@ int __init bpf_arch_init_dispatcher_early(void *ip);
 	BPF_DISPATCHER_INIT_CALL(bpf_dispatcher_##name);
 
 #define DECLARE_BPF_DISPATCHER(name)					\
-	unsigned int bpf_dispatcher_##name##_func(			\
+	u64 bpf_dispatcher_##name##_func(				\
 		const void *ctx,					\
 		const struct bpf_insn *insnsi,				\
 		bpf_func_t bpf_func);					\
@@ -1265,7 +1265,7 @@ struct bpf_prog {
 	u8			tag[BPF_TAG_SIZE];
 	struct bpf_prog_stats __percpu *stats;
 	int __percpu		*active;
-	unsigned int		(*bpf_func)(const void *ctx,
+	u64			(*bpf_func)(const void *ctx,
 					    const struct bpf_insn *insn);
 	struct bpf_prog_aux	*aux;		/* Auxiliary fields */
 	struct sock_fprog_kern	*orig_prog;	/* Original BPF program */
@@ -1619,9 +1619,9 @@ static inline void bpf_reset_run_ctx(struct bpf_run_ctx *old_ctx)
 /* BPF program asks to set CN on the packet. */
 #define BPF_RET_SET_CN						(1 << 0)
 
-typedef u32 (*bpf_prog_run_fn)(const struct bpf_prog *prog, const void *ctx);
+typedef u64 (*bpf_prog_run_fn)(const struct bpf_prog *prog, const void *ctx);
 
-static __always_inline u32
+static __always_inline u64
 bpf_prog_run_array(const struct bpf_prog_array *array,
 		   const void *ctx, bpf_prog_run_fn run_prog)
 {
@@ -1629,7 +1629,7 @@ bpf_prog_run_array(const struct bpf_prog_array *array,
 	const struct bpf_prog *prog;
 	struct bpf_run_ctx *old_run_ctx;
 	struct bpf_trace_run_ctx run_ctx;
-	u32 ret = 1;
+	u64 ret = 1;
 
 	RCU_LOCKDEP_WARN(!rcu_read_lock_held(), "no rcu lock held");
 
@@ -1659,7 +1659,7 @@ bpf_prog_run_array(const struct bpf_prog_array *array,
  * section and disable preemption for that program alone, so it can access
  * rcu-protected dynamically sized maps.
  */
-static __always_inline u32
+static __always_inline u64
 bpf_prog_run_array_sleepable(const struct bpf_prog_array __rcu *array_rcu,
 			     const void *ctx, bpf_prog_run_fn run_prog)
 {
@@ -1668,7 +1668,7 @@ bpf_prog_run_array_sleepable(const struct bpf_prog_array __rcu *array_rcu,
 	const struct bpf_prog_array *array;
 	struct bpf_run_ctx *old_run_ctx;
 	struct bpf_trace_run_ctx run_ctx;
-	u32 ret = 1;
+	u64 ret = 1;
 
 	might_fault();
 
diff --git a/include/linux/filter.h b/include/linux/filter.h
index e6c1c277ffdc..d67d3e6a2f58 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -573,16 +573,16 @@ extern int (*nfct_btf_struct_access)(struct bpf_verifier_log *log, const struct
 				     enum bpf_access_type atype, u32 *next_btf_id,
 				     enum bpf_type_flag *flag);
 
-typedef unsigned int (*bpf_dispatcher_fn)(const void *ctx,
-					  const struct bpf_insn *insnsi,
-					  unsigned int (*bpf_func)(const void *,
-								   const struct bpf_insn *));
+typedef u64 (*bpf_dispatcher_fn)(const void *ctx,
+				 const struct bpf_insn *insnsi,
+				 u64 (*bpf_func)(const void *,
+						 const struct bpf_insn *));
 
-static __always_inline u32 __bpf_prog_run(const struct bpf_prog *prog,
+static __always_inline u64 __bpf_prog_run(const struct bpf_prog *prog,
 					  const void *ctx,
 					  bpf_dispatcher_fn dfunc)
 {
-	u32 ret;
+	u64 ret;
 
 	cant_migrate();
 	if (static_branch_unlikely(&bpf_stats_enabled_key)) {
@@ -602,7 +602,7 @@ static __always_inline u32 __bpf_prog_run(const struct bpf_prog *prog,
 	return ret;
 }
 
-static __always_inline u32 bpf_prog_run(const struct bpf_prog *prog, const void *ctx)
+static __always_inline u64 bpf_prog_run(const struct bpf_prog *prog, const void *ctx)
 {
 	return __bpf_prog_run(prog, ctx, bpf_dispatcher_nop_func);
 }
@@ -615,10 +615,10 @@ static __always_inline u32 bpf_prog_run(const struct bpf_prog *prog, const void
  * invocation of a BPF program does not require reentrancy protection
  * against a BPF program which is invoked from a preempting task.
  */
-static inline u32 bpf_prog_run_pin_on_cpu(const struct bpf_prog *prog,
+static inline u64 bpf_prog_run_pin_on_cpu(const struct bpf_prog *prog,
 					  const void *ctx)
 {
-	u32 ret;
+	u64 ret;
 
 	migrate_disable();
 	ret = bpf_prog_run(prog, ctx);
@@ -714,13 +714,13 @@ static inline u8 *bpf_skb_cb(const struct sk_buff *skb)
 }
 
 /* Must be invoked with migration disabled */
-static inline u32 __bpf_prog_run_save_cb(const struct bpf_prog *prog,
+static inline u64 __bpf_prog_run_save_cb(const struct bpf_prog *prog,
 					 const void *ctx)
 {
 	const struct sk_buff *skb = ctx;
 	u8 *cb_data = bpf_skb_cb(skb);
 	u8 cb_saved[BPF_SKB_CB_LEN];
-	u32 res;
+	u64 res;
 
 	if (unlikely(prog->cb_access)) {
 		memcpy(cb_saved, cb_data, sizeof(cb_saved));
@@ -735,10 +735,10 @@ static inline u32 __bpf_prog_run_save_cb(const struct bpf_prog *prog,
 	return res;
 }
 
-static inline u32 bpf_prog_run_save_cb(const struct bpf_prog *prog,
+static inline u64 bpf_prog_run_save_cb(const struct bpf_prog *prog,
 				       struct sk_buff *skb)
 {
-	u32 res;
+	u64 res;
 
 	migrate_disable();
 	res = __bpf_prog_run_save_cb(prog, skb);
@@ -746,11 +746,11 @@ static inline u32 bpf_prog_run_save_cb(const struct bpf_prog *prog,
 	return res;
 }
 
-static inline u32 bpf_prog_run_clear_cb(const struct bpf_prog *prog,
+static inline u64 bpf_prog_run_clear_cb(const struct bpf_prog *prog,
 					struct sk_buff *skb)
 {
 	u8 *cb_data = bpf_skb_cb(skb);
-	u32 res;
+	u64 res;
 
 	if (unlikely(prog->cb_access))
 		memset(cb_data, 0, BPF_SKB_CB_LEN);
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index bf2fdb33fb31..b78a51513431 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -63,8 +63,8 @@ bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
 	return run_ctx.retval;
 }
 
-unsigned int __cgroup_bpf_run_lsm_sock(const void *ctx,
-				       const struct bpf_insn *insn)
+u64 __cgroup_bpf_run_lsm_sock(const void *ctx,
+			      const struct bpf_insn *insn)
 {
 	const struct bpf_prog *shim_prog;
 	struct sock *sk;
@@ -85,8 +85,8 @@ unsigned int __cgroup_bpf_run_lsm_sock(const void *ctx,
 	return ret;
 }
 
-unsigned int __cgroup_bpf_run_lsm_socket(const void *ctx,
-					 const struct bpf_insn *insn)
+u64 __cgroup_bpf_run_lsm_socket(const void *ctx,
+				const struct bpf_insn *insn)
 {
 	const struct bpf_prog *shim_prog;
 	struct socket *sock;
@@ -107,8 +107,8 @@ unsigned int __cgroup_bpf_run_lsm_socket(const void *ctx,
 	return ret;
 }
 
-unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
-					  const struct bpf_insn *insn)
+u64 __cgroup_bpf_run_lsm_current(const void *ctx,
+				 const struct bpf_insn *insn)
 {
 	const struct bpf_prog *shim_prog;
 	struct cgroup *cgrp;
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 9c16338bcbe8..bc4ca1e6a990 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2004,7 +2004,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
 
 #define PROG_NAME(stack_size) __bpf_prog_run##stack_size
 #define DEFINE_BPF_PROG_RUN(stack_size) \
-static unsigned int PROG_NAME(stack_size)(const void *ctx, const struct bpf_insn *insn) \
+static u64 PROG_NAME(stack_size)(const void *ctx, const struct bpf_insn *insn) \
 { \
 	u64 stack[stack_size / sizeof(u64)]; \
 	u64 regs[MAX_BPF_EXT_REG] = {}; \
@@ -2048,8 +2048,8 @@ EVAL4(DEFINE_BPF_PROG_RUN_ARGS, 416, 448, 480, 512);
 
 #define PROG_NAME_LIST(stack_size) PROG_NAME(stack_size),
 
-static unsigned int (*interpreters[])(const void *ctx,
-				      const struct bpf_insn *insn) = {
+static u64 (*interpreters[])(const void *ctx,
+			     const struct bpf_insn *insn) = {
 EVAL6(PROG_NAME_LIST, 32, 64, 96, 128, 160, 192)
 EVAL6(PROG_NAME_LIST, 224, 256, 288, 320, 352, 384)
 EVAL4(PROG_NAME_LIST, 416, 448, 480, 512)
@@ -2074,8 +2074,8 @@ void bpf_patch_call_args(struct bpf_insn *insn, u32 stack_depth)
 }
 
 #else
-static unsigned int __bpf_prog_ret0_warn(const void *ctx,
-					 const struct bpf_insn *insn)
+static u64 __bpf_prog_ret0_warn(const void *ctx,
+				const struct bpf_insn *insn)
 {
 	/* If this handler ever gets executed, then BPF_JIT_ALWAYS_ON
 	 * is not working properly, so warn about it!
@@ -2210,8 +2210,8 @@ struct bpf_prog *bpf_prog_select_runtime(struct bpf_prog *fp, int *err)
 }
 EXPORT_SYMBOL_GPL(bpf_prog_select_runtime);
 
-static unsigned int __bpf_prog_ret1(const void *ctx,
-				    const struct bpf_insn *insn)
+static u64 __bpf_prog_ret1(const void *ctx,
+			   const struct bpf_insn *insn)
 {
 	return 1;
 }
diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index 13e4efc971e6..d6a37ab87511 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -246,8 +246,8 @@ static int bpf_prog_offload_translate(struct bpf_prog *prog)
 	return ret;
 }
 
-static unsigned int bpf_prog_warn_on_exec(const void *ctx,
-					  const struct bpf_insn *insn)
+static u64 bpf_prog_warn_on_exec(const void *ctx,
+				 const struct bpf_insn *insn)
 {
 	WARN(1, "attempt to execute device eBPF program on the host!");
 	return 0;
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 44f20cf8a0c0..2f61f2889e52 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1444,8 +1444,11 @@ static unsigned int fanout_demux_bpf(struct packet_fanout *f,
 
 	rcu_read_lock();
 	prog = rcu_dereference(f->bpf_prog);
-	if (prog)
-		ret = bpf_prog_run_clear_cb(prog, skb) % num;
+	if (prog) {
+		ret = bpf_prog_run_clear_cb(prog, skb);
+		/* For some architectures, we need to do modulus in 32-bit width */
+		ret %= num;
+	}
 	rcu_read_unlock();
 
 	return ret;
-- 
2.38.1

