Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76530573511
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 13:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235940AbiGMLOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 07:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235327AbiGMLOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 07:14:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 10F48AE3A5
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657710878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kUXHMLLa6TGj+N3iLFRjHqYiMI2HN4GorZ64uF/S2p4=;
        b=LU+fmQ2QgQD/D75a+GtVdt73wM2dw7tcGYeDK2QE3yNouyjGwRbKy9qyXrrcpmok8l3845
        o5lmmUQTOqnYp43ja3HS8RkoUt+n3WLM3PptAFbGWTTqRBz+OKd1yxgXmiYOcS7w/SUYxN
        BT4gJjvHeBrqre1vhx8/gO4pwz2kxdE=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-W-O9HKzoOB-FPbqmu7sMIg-1; Wed, 13 Jul 2022 07:14:37 -0400
X-MC-Unique: W-O9HKzoOB-FPbqmu7sMIg-1
Received: by mail-ej1-f71.google.com with SMTP id hr24-20020a1709073f9800b0072b57c28438so2919812ejc.5
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:14:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kUXHMLLa6TGj+N3iLFRjHqYiMI2HN4GorZ64uF/S2p4=;
        b=byPSX8sis6RtoXokePZ4sQbPTNtRRi5Q6bTMxOYOgqOhxeKc5hn6bhJ8nk/sN8wEEl
         Xc36lyVpnN48i2nygqd65/stOeJMABazbzsMTFp61V+1Z4YW3Wz5u7uFHvrW4c0TN4A6
         m5iMIerKyGWrm40l53hm2Ris8fJbamQldWo9i7Qo6YA8hiUvlHCWfE6mJLP1F9SCbrsJ
         Vi4m8qwzKOtgtzXhZNpiuOeXiFhnOXr5eaGEzIIjTKNWyuCcNcs2cPFrl0NzfWRK6IqN
         /Uyf2dc4gQTpLrxiQvTBEDPVd7IQqXKZ2a5RoNr1SHq4TLYa0W3OfOwGbYoZxmdqSJaw
         s0Ig==
X-Gm-Message-State: AJIora/IbTmJ0udG17xOsHlCM6CmuOwCrYyV/ZD/vRQQ2iTInelnRY1p
        5afrHJIGSSfyy//9/c8M4gOXvotAj/kTH8AwdFjGpTx8++bRaQufHF39nHRhoqqVnzGCrgD3XH1
        rUXObD3apeNOXe/KK
X-Received: by 2002:a17:907:7f05:b0:72b:5a11:b357 with SMTP id qf5-20020a1709077f0500b0072b5a11b357mr2969589ejc.67.1657710875603;
        Wed, 13 Jul 2022 04:14:35 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1shlOkKTLY74UvhMGPgdm0TM9lJocW3Dqtd6mDQPeIl/i79kT2eJuKmmH7+aqmeDGXJ1iBgnA==
X-Received: by 2002:a17:907:7f05:b0:72b:5a11:b357 with SMTP id qf5-20020a1709077f0500b0072b5a11b357mr2969539ejc.67.1657710875104;
        Wed, 13 Jul 2022 04:14:35 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906310900b0072b7b317aadsm1970271ejx.150.2022.07.13.04.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 04:14:34 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 20FAD4D9901; Wed, 13 Jul 2022 13:14:34 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [RFC PATCH 03/17] bpf: Use 64-bit return value for bpf_prog_run
Date:   Wed, 13 Jul 2022 13:14:11 +0200
Message-Id: <20220713111430.134810-4-toke@redhat.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220713111430.134810-1-toke@redhat.com>
References: <20220713111430.134810-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

BPF ABI always uses 64-bit return value, but so far __bpf_prog_run and
higher level wrappers always truncated the return value to 32-bit.
Future patches introducing a new BPF_PROG_TYPE_DEQUEUE return a
PTR_TO_BTF_ID or NULL from the BPF program to the caller context in the
kernel. The verifier is taught to enforce a successful return of such a
referenced PTR_TO_BTF_ID, explicit release, or the return of a NULL
pointer to indicate absence. To be able to use this returned pointer
value, the bpf_prog_run invocation needs to be able to return a 64-bit
value.

To avoid code churn in the whole kernel, we let the compiler handle
truncation normally, and allow new call sites to utilize the 64-bit
return value, by receiving the return value as a u64.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/bpf-cgroup.h | 12 ++++++------
 include/linux/bpf.h        | 14 +++++++-------
 include/linux/filter.h     | 34 +++++++++++++++++-----------------
 kernel/bpf/cgroup.c        | 12 ++++++------
 kernel/bpf/core.c          | 14 +++++++-------
 kernel/bpf/offload.c       |  4 ++--
 net/bpf/test_run.c         | 21 ++++++++++++---------
 net/packet/af_packet.c     |  7 +++++--
 8 files changed, 62 insertions(+), 56 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 2bd1b5f8de9b..e975f89c491b 100644
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
index d877d9825e77..ebe6f2d95182 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -56,8 +56,8 @@ typedef u64 (*bpf_callback_t)(u64, u64, u64, u64, u64);
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
@@ -882,7 +882,7 @@ struct bpf_dispatcher {
 	struct bpf_ksym ksym;
 };
 
-static __always_inline __nocfi unsigned int bpf_dispatcher_nop_func(
+static __always_inline __nocfi u64 bpf_dispatcher_nop_func(
 	const void *ctx,
 	const struct bpf_insn *insnsi,
 	bpf_func_t bpf_func)
@@ -911,7 +911,7 @@ int arch_prepare_bpf_dispatcher(void *image, s64 *funcs, int num_funcs);
 }
 
 #define DEFINE_BPF_DISPATCHER(name)					\
-	noinline __nocfi unsigned int bpf_dispatcher_##name##_func(	\
+	noinline __nocfi u64 bpf_dispatcher_##name##_func(		\
 		const void *ctx,					\
 		const struct bpf_insn *insnsi,				\
 		bpf_func_t bpf_func)					\
@@ -922,7 +922,7 @@ int arch_prepare_bpf_dispatcher(void *image, s64 *funcs, int num_funcs);
 	struct bpf_dispatcher bpf_dispatcher_##name =			\
 		BPF_DISPATCHER_INIT(bpf_dispatcher_##name);
 #define DECLARE_BPF_DISPATCHER(name)					\
-	unsigned int bpf_dispatcher_##name##_func(			\
+	u64 bpf_dispatcher_##name##_func(				\
 		const void *ctx,					\
 		const struct bpf_insn *insnsi,				\
 		bpf_func_t bpf_func);					\
@@ -1127,7 +1127,7 @@ struct bpf_prog {
 	u8			tag[BPF_TAG_SIZE];
 	struct bpf_prog_stats __percpu *stats;
 	int __percpu		*active;
-	unsigned int		(*bpf_func)(const void *ctx,
+	u64			(*bpf_func)(const void *ctx,
 					    const struct bpf_insn *insn);
 	struct bpf_prog_aux	*aux;		/* Auxiliary fields */
 	struct sock_fprog_kern	*orig_prog;	/* Original BPF program */
@@ -1472,7 +1472,7 @@ static inline void bpf_reset_run_ctx(struct bpf_run_ctx *old_ctx)
 /* BPF program asks to set CN on the packet. */
 #define BPF_RET_SET_CN						(1 << 0)
 
-typedef u32 (*bpf_prog_run_fn)(const struct bpf_prog *prog, const void *ctx);
+typedef u64 (*bpf_prog_run_fn)(const struct bpf_prog *prog, const void *ctx);
 
 static __always_inline u32
 bpf_prog_run_array(const struct bpf_prog_array *array,
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 10167ab1ef95..b0ddb647d5f2 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -567,16 +567,16 @@ struct sk_filter {
 
 DECLARE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
 
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
@@ -596,7 +596,7 @@ static __always_inline u32 __bpf_prog_run(const struct bpf_prog *prog,
 	return ret;
 }
 
-static __always_inline u32 bpf_prog_run(const struct bpf_prog *prog, const void *ctx)
+static __always_inline u64 bpf_prog_run(const struct bpf_prog *prog, const void *ctx)
 {
 	return __bpf_prog_run(prog, ctx, bpf_dispatcher_nop_func);
 }
@@ -609,10 +609,10 @@ static __always_inline u32 bpf_prog_run(const struct bpf_prog *prog, const void
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
@@ -708,13 +708,13 @@ static inline u8 *bpf_skb_cb(const struct sk_buff *skb)
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
@@ -729,10 +729,10 @@ static inline u32 __bpf_prog_run_save_cb(const struct bpf_prog *prog,
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
@@ -740,11 +740,11 @@ static inline u32 bpf_prog_run_save_cb(const struct bpf_prog *prog,
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
@@ -759,14 +759,14 @@ DECLARE_STATIC_KEY_FALSE(bpf_master_redirect_enabled_key);
 
 u32 xdp_master_redirect(struct xdp_buff *xdp);
 
-static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
+static __always_inline u64 bpf_prog_run_xdp(const struct bpf_prog *prog,
 					    struct xdp_buff *xdp)
 {
 	/* Driver XDP hooks are invoked within a single NAPI poll cycle and thus
 	 * under local_bh_disable(), which provides the needed RCU protection
 	 * for accessing map entries.
 	 */
-	u32 act = __bpf_prog_run(prog, xdp, BPF_DISPATCHER_FUNC(xdp));
+	u64 act = __bpf_prog_run(prog, xdp, BPF_DISPATCHER_FUNC(xdp));
 
 	if (static_branch_unlikely(&bpf_master_redirect_enabled_key)) {
 		if (act == XDP_TX && netif_is_bond_slave(xdp->rxq->dev))
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 59b7eb60d5b4..1721b09d0838 100644
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
index 805c2ad5c793..a94dbb822f11 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2039,7 +2039,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
 
 #define PROG_NAME(stack_size) __bpf_prog_run##stack_size
 #define DEFINE_BPF_PROG_RUN(stack_size) \
-static unsigned int PROG_NAME(stack_size)(const void *ctx, const struct bpf_insn *insn) \
+static u64 PROG_NAME(stack_size)(const void *ctx, const struct bpf_insn *insn) \
 { \
 	u64 stack[stack_size / sizeof(u64)]; \
 	u64 regs[MAX_BPF_EXT_REG]; \
@@ -2083,8 +2083,8 @@ EVAL4(DEFINE_BPF_PROG_RUN_ARGS, 416, 448, 480, 512);
 
 #define PROG_NAME_LIST(stack_size) PROG_NAME(stack_size),
 
-static unsigned int (*interpreters[])(const void *ctx,
-				      const struct bpf_insn *insn) = {
+static u64 (*interpreters[])(const void *ctx,
+			     const struct bpf_insn *insn) = {
 EVAL6(PROG_NAME_LIST, 32, 64, 96, 128, 160, 192)
 EVAL6(PROG_NAME_LIST, 224, 256, 288, 320, 352, 384)
 EVAL4(PROG_NAME_LIST, 416, 448, 480, 512)
@@ -2109,8 +2109,8 @@ void bpf_patch_call_args(struct bpf_insn *insn, u32 stack_depth)
 }
 
 #else
-static unsigned int __bpf_prog_ret0_warn(const void *ctx,
-					 const struct bpf_insn *insn)
+static u64 __bpf_prog_ret0_warn(const void *ctx,
+				const struct bpf_insn *insn)
 {
 	/* If this handler ever gets executed, then BPF_JIT_ALWAYS_ON
 	 * is not working properly, so warn about it!
@@ -2245,8 +2245,8 @@ struct bpf_prog *bpf_prog_select_runtime(struct bpf_prog *fp, int *err)
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
index bd09290e3648..fabda7ed5dd0 100644
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
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 2ca96acbc50a..f05d13717430 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -370,7 +370,7 @@ static int bpf_test_run_xdp_live(struct bpf_prog *prog, struct xdp_buff *ctx,
 }
 
 static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
-			u32 *retval, u32 *time, bool xdp)
+			u64 *retval, u32 *time, bool xdp)
 {
 	struct bpf_prog_array_item item = {.prog = prog};
 	struct bpf_run_ctx *old_ctx;
@@ -769,7 +769,7 @@ int bpf_prog_test_run_tracing(struct bpf_prog *prog,
 	struct bpf_fentry_test_t arg = {};
 	u16 side_effect = 0, ret = 0;
 	int b = 2, err = -EFAULT;
-	u32 retval = 0;
+	u64 retval = 0;
 
 	if (kattr->test.flags || kattr->test.cpu || kattr->test.batch_size)
 		return -EINVAL;
@@ -809,7 +809,7 @@ int bpf_prog_test_run_tracing(struct bpf_prog *prog,
 struct bpf_raw_tp_test_run_info {
 	struct bpf_prog *prog;
 	void *ctx;
-	u32 retval;
+	u64 retval;
 };
 
 static void
@@ -1054,15 +1054,15 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 			  union bpf_attr __user *uattr)
 {
 	bool is_l2 = false, is_direct_pkt_access = false;
+	u32 size = kattr->test.data_size_in, duration;
 	struct net *net = current->nsproxy->net_ns;
 	struct net_device *dev = net->loopback_dev;
-	u32 size = kattr->test.data_size_in;
 	u32 repeat = kattr->test.repeat;
 	struct __sk_buff *ctx = NULL;
-	u32 retval, duration;
 	int hh_len = ETH_HLEN;
 	struct sk_buff *skb;
 	struct sock *sk;
+	u64 retval;
 	void *data;
 	int ret;
 
@@ -1250,15 +1250,16 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 	bool do_live = (kattr->test.flags & BPF_F_TEST_XDP_LIVE_FRAMES);
 	u32 tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 	u32 batch_size = kattr->test.batch_size;
-	u32 retval = 0, duration, max_data_sz;
 	u32 size = kattr->test.data_size_in;
 	u32 headroom = XDP_PACKET_HEADROOM;
 	u32 repeat = kattr->test.repeat;
 	struct netdev_rx_queue *rxqueue;
 	struct skb_shared_info *sinfo;
+	u32 duration, max_data_sz;
 	struct xdp_buff xdp = {};
 	int i, ret = -EINVAL;
 	struct xdp_md *ctx;
+	u64 retval = 0;
 	void *data;
 
 	if (prog->expected_attach_type == BPF_XDP_DEVMAP ||
@@ -1416,7 +1417,8 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 	struct bpf_flow_keys flow_keys;
 	const struct ethhdr *eth;
 	unsigned int flags = 0;
-	u32 retval, duration;
+	u32 duration;
+	u64 retval;
 	void *data;
 	int ret;
 
@@ -1481,8 +1483,9 @@ int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog, const union bpf_attr *kat
 	struct bpf_sk_lookup_kern ctx = {};
 	u32 repeat = kattr->test.repeat;
 	struct bpf_sk_lookup *user_ctx;
-	u32 retval, duration;
 	int ret = -EINVAL;
+	u32 duration;
+	u64 retval;
 
 	if (kattr->test.flags || kattr->test.cpu || kattr->test.batch_size)
 		return -EINVAL;
@@ -1580,8 +1583,8 @@ int bpf_prog_test_run_syscall(struct bpf_prog *prog,
 	void __user *ctx_in = u64_to_user_ptr(kattr->test.ctx_in);
 	__u32 ctx_size_in = kattr->test.ctx_size_in;
 	void *ctx = NULL;
-	u32 retval;
 	int err = 0;
+	u64 retval;
 
 	/* doesn't support data_in/out, ctx_out, duration, or repeat or flags */
 	if (kattr->test.data_in || kattr->test.data_out ||
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index d08c4728523b..5b91f712d246 100644
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
2.37.0

