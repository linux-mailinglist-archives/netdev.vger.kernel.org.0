Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11D64E20DD
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 08:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344690AbiCUHDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 03:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344736AbiCUHDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 03:03:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C51BEF;
        Mon, 21 Mar 2022 00:01:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CA9260F87;
        Mon, 21 Mar 2022 07:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D30C340E8;
        Mon, 21 Mar 2022 07:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647846100;
        bh=puLQDTiFTDL4+6lJJT8R6d0QSTr8Crkduhdp395IOrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gmP8Yz2Emselwfr2/YGSJ6mDNqr1Pva2gGvBFdqECMY42RAhzp4xorRbqQ9T8HGIs
         5jhpTeLSb/mdPUSlOkR2kwlw8hXbQ1WW4ERgl3hh7wQN9vliDwJByPGC1yLO0GwTyx
         FFTswONw+Rd0L0hJnuw4wZpL1GTm2CihhRn6jowqqFJJKfn7PPoI8mtNNbhtCZGYqX
         eVFz7wph6tXPz75hkJrdDn08EdU3h/wgg+cQiAYFpNXcdDsN6bGpod4RDOutComzJX
         KgVLX2ebwLA/HKuIUWljo/k7TSW8lC/GlgIo2yuo8LLjEuyjaNHt3oKtbp0rA1yC60
         qxeP6pqqp6RUg==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH bpf-next 2/2] bpf: Fix kprobe_multi return probe backtrace
Date:   Mon, 21 Mar 2022 08:01:13 +0100
Message-Id: <20220321070113.1449167-3-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321070113.1449167-1-jolsa@kernel.org>
References: <20220321070113.1449167-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii reported that backtraces from kprobe_multi program attached
as return probes are not complete and showing just initial entry [1].

It's caused by changing registers to have original function ip address
as instruction pointer even for return probe, which will screw backtrace
from return probe.

This change keeps registers intact and store original entry ip and
link address on the stack in bpf_kprobe_multi_run_ctx struct, where
bpf_get_func_ip and bpf_get_attach_cookie helpers for kprobe_multi
programs can find it.

[1] https://lore.kernel.org/bpf/CAEf4BzZDDqK24rSKwXNp7XL3ErGD4bZa1M6c_c4EvDSt3jrZcg@mail.gmail.com/T/#m8d1301c0ea0892ddf9dc6fba57a57b8cf11b8c51
Fixes: ca74823c6e16 ("bpf: Add cookie support to programs attached with kprobe multi link")
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/trace/bpf_trace.c | 67 ++++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 30 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 52c2998e1dc3..172ef545730d 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -80,7 +80,8 @@ u64 bpf_get_stack(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
 static int bpf_btf_printf_prepare(struct btf_ptr *ptr, u32 btf_ptr_size,
 				  u64 flags, const struct btf **btf,
 				  s32 *btf_id);
-static u64 bpf_kprobe_multi_cookie(struct bpf_run_ctx *ctx, u64 ip);
+static u64 bpf_kprobe_multi_cookie(struct bpf_run_ctx *ctx);
+static u64 bpf_kprobe_multi_entry_ip(struct bpf_run_ctx *ctx);
 
 /**
  * trace_call_bpf - invoke BPF program
@@ -1042,7 +1043,7 @@ static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe = {
 
 BPF_CALL_1(bpf_get_func_ip_kprobe_multi, struct pt_regs *, regs)
 {
-	return instruction_pointer(regs);
+	return bpf_kprobe_multi_entry_ip(current->bpf_ctx);
 }
 
 static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe_multi = {
@@ -1054,7 +1055,7 @@ static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe_multi = {
 
 BPF_CALL_1(bpf_get_attach_cookie_kprobe_multi, struct pt_regs *, regs)
 {
-	return bpf_kprobe_multi_cookie(current->bpf_ctx, instruction_pointer(regs));
+	return bpf_kprobe_multi_cookie(current->bpf_ctx);
 }
 
 static const struct bpf_func_proto bpf_get_attach_cookie_proto_kmulti = {
@@ -2219,15 +2220,16 @@ struct bpf_kprobe_multi_link {
 	struct bpf_link link;
 	struct fprobe fp;
 	unsigned long *addrs;
-	/*
-	 * The run_ctx here is used to get struct bpf_kprobe_multi_link in
-	 * get_attach_cookie helper, so it can't be used to store data.
-	 */
-	struct bpf_run_ctx run_ctx;
 	u64 *cookies;
 	u32 cnt;
 };
 
+struct bpf_kprobe_multi_run_ctx {
+	struct bpf_run_ctx run_ctx;
+	struct bpf_kprobe_multi_link *link;
+	unsigned long entry_ip;
+};
+
 static void bpf_kprobe_multi_link_release(struct bpf_link *link)
 {
 	struct bpf_kprobe_multi_link *kmulti_link;
@@ -2281,18 +2283,21 @@ static int bpf_kprobe_multi_cookie_cmp(const void *a, const void *b, const void
 	return __bpf_kprobe_multi_cookie_cmp(a, b);
 }
 
-static u64 bpf_kprobe_multi_cookie(struct bpf_run_ctx *ctx, u64 ip)
+static u64 bpf_kprobe_multi_cookie(struct bpf_run_ctx *ctx)
 {
+	struct bpf_kprobe_multi_run_ctx *run_ctx;
 	struct bpf_kprobe_multi_link *link;
+	u64 *cookie, entry_ip;
 	unsigned long *addr;
-	u64 *cookie;
 
 	if (WARN_ON_ONCE(!ctx))
 		return 0;
-	link = container_of(ctx, struct bpf_kprobe_multi_link, run_ctx);
+	run_ctx = container_of(current->bpf_ctx, struct bpf_kprobe_multi_run_ctx, run_ctx);
+	link = run_ctx->link;
 	if (!link->cookies)
 		return 0;
-	addr = bsearch(&ip, link->addrs, link->cnt, sizeof(ip),
+	entry_ip = run_ctx->entry_ip;
+	addr = bsearch(&entry_ip, link->addrs, link->cnt, sizeof(entry_ip),
 		       __bpf_kprobe_multi_cookie_cmp);
 	if (!addr)
 		return 0;
@@ -2300,10 +2305,22 @@ static u64 bpf_kprobe_multi_cookie(struct bpf_run_ctx *ctx, u64 ip)
 	return *cookie;
 }
 
+static u64 bpf_kprobe_multi_entry_ip(struct bpf_run_ctx *ctx)
+{
+	struct bpf_kprobe_multi_run_ctx *run_ctx;
+
+	run_ctx = container_of(current->bpf_ctx, struct bpf_kprobe_multi_run_ctx, run_ctx);
+	return run_ctx->entry_ip;
+}
+
 static int
 kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
-			   struct pt_regs *regs)
+			   unsigned long entry_ip, struct pt_regs *regs)
 {
+	struct bpf_kprobe_multi_run_ctx run_ctx = {
+		.link = link,
+		.entry_ip = entry_ip,
+	};
 	struct bpf_run_ctx *old_run_ctx;
 	int err;
 
@@ -2314,7 +2331,7 @@ kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
 
 	migrate_disable();
 	rcu_read_lock();
-	old_run_ctx = bpf_set_run_ctx(&link->run_ctx);
+	old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
 	err = bpf_prog_run(link->link.prog, regs);
 	bpf_reset_run_ctx(old_run_ctx);
 	rcu_read_unlock();
@@ -2329,24 +2346,10 @@ static void
 kprobe_multi_link_handler(struct fprobe *fp, unsigned long entry_ip,
 			  struct pt_regs *regs)
 {
-	unsigned long saved_ip = instruction_pointer(regs);
 	struct bpf_kprobe_multi_link *link;
 
-	/*
-	 * Because fprobe's regs->ip is set to the next instruction of
-	 * dynamic-ftrace instruction, correct entry ip must be set, so
-	 * that the bpf program can access entry address via regs as same
-	 * as kprobes.
-	 *
-	 * Both kprobe and kretprobe see the entry ip of traced function
-	 * as instruction pointer.
-	 */
-	instruction_pointer_set(regs, entry_ip);
-
 	link = container_of(fp, struct bpf_kprobe_multi_link, fp);
-	kprobe_multi_link_prog_run(link, regs);
-
-	instruction_pointer_set(regs, saved_ip);
+	kprobe_multi_link_prog_run(link, entry_ip, regs);
 }
 
 static int
@@ -2513,7 +2516,11 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 {
 	return -EOPNOTSUPP;
 }
-static u64 bpf_kprobe_multi_cookie(struct bpf_run_ctx *ctx, u64 ip)
+static u64 bpf_kprobe_multi_cookie(struct bpf_run_ctx *ctx)
+{
+	return 0;
+}
+static u64 bpf_kprobe_multi_entry_ip(struct bpf_run_ctx *ctx)
 {
 	return 0;
 }
-- 
2.35.1

