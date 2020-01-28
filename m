Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E48314ADFA
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 03:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbgA1CO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 21:14:56 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43291 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbgA1CO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 21:14:56 -0500
Received: by mail-pf1-f195.google.com with SMTP id s1so5218605pfh.10
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 18:14:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=subject:date:message-id:mime-version:content-transfer-encoding:cc
         :from:to:in-reply-to:references;
        bh=vlorJcvaP10UZfjLamGOOlyDMylrB7iiHsA2qcGcn2c=;
        b=wIVx5InN6/DzJVEigJkJbaohW40EGIe8KYnsmlI6ruUV1jfOEXmaV23mBGuxsbBdZZ
         7N5HJz6fhvoeGjRPqyHw4cQLMNsZap4dno9K9rOg88GKKO0wPpVtVk369vKFayuZU5Z3
         5Flw1wwHLh9O9DQZQTciGdHwm1qbkIb8HtClNU6B1kMPffvLLLeTYvsIc7IFOTJGrRP3
         SyzkIZz34nOkSB9/5HyV2JYgvxR9XE7nVDO+BkBUI5F0ICsuFrJAuKdJFfEYUNMGpkZ9
         eQDk7IhpuBKghrnxUYESqFen0lnva69a+zckjFBNE2KlKqDRnZmXl4U5GhQiIVPVOm2I
         L8Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:date:message-id:mime-version
         :content-transfer-encoding:cc:from:to:in-reply-to:references;
        bh=vlorJcvaP10UZfjLamGOOlyDMylrB7iiHsA2qcGcn2c=;
        b=Z8usBVkPbf7G98j06c0GvSTLmjO6WhVvkwGkq2dre2Joql05u3ik180vUHYTjEwegw
         qMoAwIvK4iT9xKhVSXazyfG+3+N6UXx1NbSK8eCRTMwA1qXcz70LdTc5EXRUy9kM8L47
         3oyg1fzZ1AbPWBThSuQWRJsPm1mmL5kzSHLvplGBuinDZ4yLXOq+ufMPO4mCYm/6fPto
         GVSmzcOuhXAA2OXdNulHB79KTRVGmIUZUmvIa2VApFy/p/5n+r9Sc9F6oSdhiWIWm17q
         eK2nhW9k8sGdW4ICQkQnxTD1vL0+3wIS0I8wgxDs582ubKRDIo1X6v9dlCO6Ld1QhbgL
         qaaw==
X-Gm-Message-State: APjAAAVgDvQGTPZIYqHH/7DfdphGMHPzdxZ5pCRU4d3RBgZ2pc4YLwEn
        M7bIG7jK+jXh+gf8h4lg9+rhCA==
X-Google-Smtp-Source: APXvYqwztG3P3KPhEdDXDM7eU2re4Pli6ZoCVOT/l3ew9l8F5p7fV2G51hn2C7+OmMraT7KvzDqk4w==
X-Received: by 2002:a62:52d0:: with SMTP id g199mr1553020pfb.241.1580177693903;
        Mon, 27 Jan 2020 18:14:53 -0800 (PST)
Received: from localhost ([216.9.110.6])
        by smtp.gmail.com with ESMTPSA id b12sm17391719pfi.157.2020.01.27.18.14.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 18:14:53 -0800 (PST)
Subject: [PATCH 2/4] arm64: bpf: Convert bpf2a64 to a function
Date:   Mon, 27 Jan 2020 18:11:43 -0800
Message-Id: <20200128021145.36774-3-palmerdabbelt@google.com>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc:     daniel@iogearbox.net, ast@kernel.org, zlim.lnx@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        shuah@kernel.org, Palmer Dabbelt <palmerdabbelt@google.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        clang-built-linux@googlegroups.com, kernel-team@android.com
From:   Palmer Dabbelt <palmerdabbelt@google.com>
To:     Bjorn Topel <bjorn.topel@gmail.com>
In-Reply-To: <20200128021145.36774-1-palmerdabbelt@google.com>
References: <20200128021145.36774-1-palmerdabbelt@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is intended to change no functionality, it just allows me to more
cleanly add dynamic register mapping later.

Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
---
 arch/arm64/net/bpf_jit_comp.c | 53 +++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index cdc79de0c794..8eee68705056 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -25,7 +25,7 @@
 #define TMP_REG_3 (MAX_BPF_JIT_REG + 3)
 
 /* Map BPF registers to A64 registers */
-static const int bpf2a64[] = {
+static const int bpf2a64_default[] = {
 	/* return value from in-kernel function, and exit value from eBPF */
 	[BPF_REG_0] = A64_R(7),
 	/* arguments from eBPF program to in-kernel function */
@@ -60,6 +60,11 @@ struct jit_ctx {
 	u32 stack_size;
 };
 
+static inline int bpf2a64(struct jit_ctx *ctx, int bpf_reg)
+{
+	return bpf2a64_default[bpf_reg];
+}
+
 static inline void emit(const u32 insn, struct jit_ctx *ctx)
 {
 	if (ctx->image != NULL)
@@ -176,12 +181,12 @@ static inline int epilogue_offset(const struct jit_ctx *ctx)
 static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf)
 {
 	const struct bpf_prog *prog = ctx->prog;
-	const u8 r6 = bpf2a64[BPF_REG_6];
-	const u8 r7 = bpf2a64[BPF_REG_7];
-	const u8 r8 = bpf2a64[BPF_REG_8];
-	const u8 r9 = bpf2a64[BPF_REG_9];
-	const u8 fp = bpf2a64[BPF_REG_FP];
-	const u8 tcc = bpf2a64[TCALL_CNT];
+	const u8 r6 = bpf2a64(ctx, BPF_REG_6);
+	const u8 r7 = bpf2a64(ctx, BPF_REG_7);
+	const u8 r8 = bpf2a64(ctx, BPF_REG_8);
+	const u8 r9 = bpf2a64(ctx, BPF_REG_9);
+	const u8 fp = bpf2a64(ctx, BPF_REG_FP);
+	const u8 tcc = bpf2a64(ctx, TCALL_CNT);
 	const int idx0 = ctx->idx;
 	int cur_offset;
 
@@ -243,12 +248,12 @@ static int out_offset = -1; /* initialized on the first pass of build_body() */
 static int emit_bpf_tail_call(struct jit_ctx *ctx)
 {
 	/* bpf_tail_call(void *prog_ctx, struct bpf_array *array, u64 index) */
-	const u8 r2 = bpf2a64[BPF_REG_2];
-	const u8 r3 = bpf2a64[BPF_REG_3];
+	const u8 r2 = bpf2a64(ctx, BPF_REG_2);
+	const u8 r3 = bpf2a64(ctx, BPF_REG_3);
 
-	const u8 tmp = bpf2a64[TMP_REG_1];
-	const u8 prg = bpf2a64[TMP_REG_2];
-	const u8 tcc = bpf2a64[TCALL_CNT];
+	const u8 tmp = bpf2a64(ctx, TMP_REG_1);
+	const u8 prg = bpf2a64(ctx, TMP_REG_2);
+	const u8 tcc = bpf2a64(ctx, TCALL_CNT);
 	const int idx0 = ctx->idx;
 #define cur_offset (ctx->idx - idx0)
 #define jmp_offset (out_offset - (cur_offset))
@@ -307,12 +312,12 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx)
 
 static void build_epilogue(struct jit_ctx *ctx)
 {
-	const u8 r0 = bpf2a64[BPF_REG_0];
-	const u8 r6 = bpf2a64[BPF_REG_6];
-	const u8 r7 = bpf2a64[BPF_REG_7];
-	const u8 r8 = bpf2a64[BPF_REG_8];
-	const u8 r9 = bpf2a64[BPF_REG_9];
-	const u8 fp = bpf2a64[BPF_REG_FP];
+	const u8 r0 = bpf2a64(ctx, BPF_REG_0);
+	const u8 r6 = bpf2a64(ctx, BPF_REG_6);
+	const u8 r7 = bpf2a64(ctx, BPF_REG_7);
+	const u8 r8 = bpf2a64(ctx, BPF_REG_8);
+	const u8 r9 = bpf2a64(ctx, BPF_REG_9);
+	const u8 fp = bpf2a64(ctx, BPF_REG_FP);
 
 	/* We're done with BPF stack */
 	emit(A64_ADD_I(1, A64_SP, A64_SP, ctx->stack_size), ctx);
@@ -343,11 +348,11 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		      bool extra_pass)
 {
 	const u8 code = insn->code;
-	const u8 dst = bpf2a64[insn->dst_reg];
-	const u8 src = bpf2a64[insn->src_reg];
-	const u8 tmp = bpf2a64[TMP_REG_1];
-	const u8 tmp2 = bpf2a64[TMP_REG_2];
-	const u8 tmp3 = bpf2a64[TMP_REG_3];
+	const u8 dst = bpf2a64(ctx, insn->dst_reg);
+	const u8 src = bpf2a64(ctx, insn->src_reg);
+	const u8 tmp = bpf2a64(ctx, TMP_REG_1);
+	const u8 tmp2 = bpf2a64(ctx, TMP_REG_2);
+	const u8 tmp3 = bpf2a64(ctx, TMP_REG_3);
 	const s16 off = insn->off;
 	const s32 imm = insn->imm;
 	const int i = insn - ctx->prog->insnsi;
@@ -634,7 +639,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	/* function call */
 	case BPF_JMP | BPF_CALL:
 	{
-		const u8 r0 = bpf2a64[BPF_REG_0];
+		const u8 r0 = bpf2a64(ctx, BPF_REG_0);
 		bool func_addr_fixed;
 		u64 func_addr;
 		int ret;
-- 
2.25.0.341.g760bfbb309-goog

