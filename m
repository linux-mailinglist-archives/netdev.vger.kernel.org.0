Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D94765EEE57
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235083AbiI2HE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235042AbiI2HEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:04:38 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D585131991;
        Thu, 29 Sep 2022 00:04:26 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1664435064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0UfA0PJAoP2y++0RBxRan7HEgfBgWML+qPMCq4fnM70=;
        b=mRk14q4vNluBZXNfspg7aaGv2Ssf8VeGa2c+QtWLH0sBTVfnGCTDLsqXFMabz/XOnn7Zm7
        ih90pDyo9Vazg8Ley+J0F62obm2JDthX07ULLtJ7Qej1qoyhyhg0cmnk09izNxhgPjZb+L
        Bz0ZGvAxA7J8HSmMw55BrPDr7flS4BY=
From:   Martin KaFai Lau <martin.lau@linux.dev>
To:     ' ' <bpf@vger.kernel.org>, ' ' <netdev@vger.kernel.org>
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        'Daniel Borkmann ' <daniel@iogearbox.net>,
        'David Miller ' <davem@davemloft.net>,
        'Jakub Kicinski ' <kuba@kernel.org>,
        'Eric Dumazet ' <edumazet@google.com>,
        'Paolo Abeni ' <pabeni@redhat.com>, ' ' <kernel-team@fb.com>
Subject: [PATCH v3 bpf-next 1/5] bpf: Add __bpf_prog_{enter,exit}_struct_ops for struct_ops trampoline
Date:   Thu, 29 Sep 2022 00:04:03 -0700
Message-Id: <20220929070407.965581-2-martin.lau@linux.dev>
In-Reply-To: <20220929070407.965581-1-martin.lau@linux.dev>
References: <20220929070407.965581-1-martin.lau@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <martin.lau@kernel.org>

The struct_ops prog is to allow using bpf to implement the functions in
a struct (eg. kernel module).  The current usage is to implement the
tcp_congestion.  The kernel does not call the tcp-cc's ops (ie.
the bpf prog) in a recursive way.

The struct_ops is sharing the tracing-trampoline's enter/exit
function which tracks prog->active to avoid recursion.  It is
needed for tracing prog.  However, it turns out the struct_ops
bpf prog will hit this prog->active and unnecessarily skipped
running the struct_ops prog.  eg.  The '.ssthresh' may run in_task()
and then interrupted by softirq that runs the same '.ssthresh'.
Skip running the '.ssthresh' will end up returning random value
to the caller.

The patch adds __bpf_prog_{enter,exit}_struct_ops for the
struct_ops trampoline.  They do not track the prog->active
to detect recursion.

One exception is when the tcp_congestion's '.init' ops is doing
bpf_setsockopt(TCP_CONGESTION) and then recurs to the same
'.init' ops.  This will be addressed in the following patches.

Fixes: ca06f55b9002 ("bpf: Add per-program recursion prevention mechanism")
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c |  3 +++
 include/linux/bpf.h         |  4 ++++
 kernel/bpf/trampoline.c     | 23 +++++++++++++++++++++++
 3 files changed, 30 insertions(+)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 35796db58116..5b6230779cf3 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1836,6 +1836,9 @@ static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
 	if (p->aux->sleepable) {
 		enter = __bpf_prog_enter_sleepable;
 		exit = __bpf_prog_exit_sleepable;
+	} else if (p->type == BPF_PROG_TYPE_STRUCT_OPS) {
+		enter = __bpf_prog_enter_struct_ops;
+		exit = __bpf_prog_exit_struct_ops;
 	} else if (p->expected_attach_type == BPF_LSM_CGROUP) {
 		enter = __bpf_prog_enter_lsm_cgroup;
 		exit = __bpf_prog_exit_lsm_cgroup;
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 5161fac0513f..f98ab36c09d3 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -864,6 +864,10 @@ u64 notrace __bpf_prog_enter_lsm_cgroup(struct bpf_prog *prog,
 					struct bpf_tramp_run_ctx *run_ctx);
 void notrace __bpf_prog_exit_lsm_cgroup(struct bpf_prog *prog, u64 start,
 					struct bpf_tramp_run_ctx *run_ctx);
+u64 notrace __bpf_prog_enter_struct_ops(struct bpf_prog *prog,
+					struct bpf_tramp_run_ctx *run_ctx);
+void notrace __bpf_prog_exit_struct_ops(struct bpf_prog *prog, u64 start,
+					struct bpf_tramp_run_ctx *run_ctx);
 void notrace __bpf_tramp_enter(struct bpf_tramp_image *tr);
 void notrace __bpf_tramp_exit(struct bpf_tramp_image *tr);
 
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 6f7b939321d6..bf0906e1e2b9 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -964,6 +964,29 @@ void notrace __bpf_prog_exit_sleepable(struct bpf_prog *prog, u64 start,
 	rcu_read_unlock_trace();
 }
 
+u64 notrace __bpf_prog_enter_struct_ops(struct bpf_prog *prog,
+					struct bpf_tramp_run_ctx *run_ctx)
+	__acquires(RCU)
+{
+	rcu_read_lock();
+	migrate_disable();
+
+	run_ctx->saved_run_ctx = bpf_set_run_ctx(&run_ctx->run_ctx);
+
+	return bpf_prog_start_time();
+}
+
+void notrace __bpf_prog_exit_struct_ops(struct bpf_prog *prog, u64 start,
+					struct bpf_tramp_run_ctx *run_ctx)
+	__releases(RCU)
+{
+	bpf_reset_run_ctx(run_ctx->saved_run_ctx);
+
+	update_prog_stats(prog, start);
+	migrate_enable();
+	rcu_read_unlock();
+}
+
 void notrace __bpf_tramp_enter(struct bpf_tramp_image *tr)
 {
 	percpu_ref_get(&tr->pcref);
-- 
2.30.2

