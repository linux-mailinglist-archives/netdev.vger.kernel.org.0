Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7FA5227624
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 04:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbgGUCwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 22:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728423AbgGUCwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 22:52:46 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CFDC061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 19:52:46 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id p3so11272894pgh.3
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 19:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZLQrY/UxqOtjwjwh/fxvAJLrfWIZm1b3xNWosA3saFY=;
        b=gRsu9i6MV4eWpF19q01vv2BC0F3TlknCkO9P0X8iCUUE48ncCkyH2TORh8i6O2HHgL
         tR4jT7e84z2ZbKs4m1KV4MsIxSSFHOf3myiJlh2YPg4E9QZsvSLpY4yQNyw6A8oQsH0N
         lg79Ek8LMaooCc29SJQgT780v3nihRW+3kG4Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZLQrY/UxqOtjwjwh/fxvAJLrfWIZm1b3xNWosA3saFY=;
        b=lH7OkzXrH9pBT1DIH44sd2Wg1uQiQ3Q08HzSjoaDxcdCb3/+kNQWLglcfTeBd5M8s+
         6dU7CYXaLj+/Lqjbcy2ZiWymqaJ3GvQILEIY7nqzR69UkQ3CdpK1q5Um7xq6ZLXiRWYw
         WqipG7GairGFIW6Miubxiqf/rl6h1Dwfkjlf3uGS4jMHa8+zG9z3M2eEeEd1g3YhxjTO
         SfKwHGHdOW+f8u8mJgz0ZLEw/mY6cFefdKitHEq/PIzSyDOx0t2mb7XyV3f25hygossP
         Iz3ufHUaCIfdtZK8Lirr5W2O3iVqdvKrEM5ar84zNj2nY8WCmYi0lVpwarOaLdFAK3O4
         2hKA==
X-Gm-Message-State: AOAM531UIJSUvP8X7Z8A70e6WgOpuuU2vGIYjYkdv1CXIZum+hK3gB9a
        EFXHJe8KXaRcMlU8qFOuwDtd1w==
X-Google-Smtp-Source: ABdhPJyE3L+cDNdzoHQhi+HQkOXnzOIkbXcyhyTdH5bf+s90354rPpV94ZUn2mHfYv5TWCEwNPntog==
X-Received: by 2002:a62:be04:: with SMTP id l4mr22143227pff.323.1595299965619;
        Mon, 20 Jul 2020 19:52:45 -0700 (PDT)
Received: from localhost.localdomain (c-73-53-94-119.hsd1.wa.comcast.net. [73.53.94.119])
        by smtp.gmail.com with ESMTPSA id m16sm18769753pfd.101.2020.07.20.19.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 19:52:45 -0700 (PDT)
From:   Luke Nelson <lukenels@cs.washington.edu>
X-Google-Original-From: Luke Nelson <luke.r.nels@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Luke Nelson <luke.r.nels@gmail.com>, Xi Wang <xi.wang@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v1 1/3] bpf, riscv: Modify JIT ctx to support compressed instructions
Date:   Mon, 20 Jul 2020 19:52:38 -0700
Message-Id: <20200721025241.8077-2-luke.r.nels@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721025241.8077-1-luke.r.nels@gmail.com>
References: <20200721025241.8077-1-luke.r.nels@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch makes the necessary changes to struct rv_jit_context and to
bpf_int_jit_compile to support compressed riscv (RVC) instructions in
the BPF JIT.

It changes the JIT image to be u16 instead of u32, since RVC instructions
are 2 bytes as opposed to 4.

It also changes ctx->offset and ctx->ninsns to refer to 2-byte
instructions rather than 4-byte ones. The riscv PC is required to be
16-bit aligned with or without RVC, so this is sufficient to refer to
any valid riscv offset.

The code for computing jump offsets in bytes is updated accordingly,
and factored into a new "ninsns_rvoff" function to simplify the code.

Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
---
 arch/riscv/net/bpf_jit.h        | 31 ++++++++++++++++++++++++++++---
 arch/riscv/net/bpf_jit_comp32.c | 14 +++++++-------
 arch/riscv/net/bpf_jit_comp64.c | 12 ++++++------
 arch/riscv/net/bpf_jit_core.c   |  6 +++---
 4 files changed, 44 insertions(+), 19 deletions(-)

diff --git a/arch/riscv/net/bpf_jit.h b/arch/riscv/net/bpf_jit.h
index 20e235d06f66..e90d336a9e5f 100644
--- a/arch/riscv/net/bpf_jit.h
+++ b/arch/riscv/net/bpf_jit.h
@@ -13,6 +13,11 @@
 #include <linux/filter.h>
 #include <asm/cacheflush.h>
 
+static inline bool rvc_enabled(void)
+{
+	return IS_ENABLED(CONFIG_RISCV_ISA_C);
+}
+
 enum {
 	RV_REG_ZERO =	0,	/* The constant value 0 */
 	RV_REG_RA =	1,	/* Return address */
@@ -50,7 +55,7 @@ enum {
 
 struct rv_jit_context {
 	struct bpf_prog *prog;
-	u32 *insns;		/* RV insns */
+	u16 *insns;		/* RV insns */
 	int ninsns;
 	int epilogue_offset;
 	int *offset;		/* BPF to RV */
@@ -58,6 +63,12 @@ struct rv_jit_context {
 	int stack_size;
 };
 
+/* Convert from ninsns to bytes. */
+static inline int ninsns_rvoff(int ninsns)
+{
+	return ninsns << 1;
+}
+
 struct rv_jit_data {
 	struct bpf_binary_header *header;
 	u8 *image;
@@ -74,8 +85,22 @@ static inline void bpf_flush_icache(void *start, void *end)
 	flush_icache_range((unsigned long)start, (unsigned long)end);
 }
 
+/* Emit a 4-byte riscv instruction. */
 static inline void emit(const u32 insn, struct rv_jit_context *ctx)
 {
+	if (ctx->insns) {
+		ctx->insns[ctx->ninsns] = insn;
+		ctx->insns[ctx->ninsns + 1] = (insn >> 16);
+	}
+
+	ctx->ninsns += 2;
+}
+
+/* Emit a 2-byte riscv compressed instruction. */
+static inline void emitc(const u16 insn, struct rv_jit_context *ctx)
+{
+	BUILD_BUG_ON(!rvc_enabled());
+
 	if (ctx->insns)
 		ctx->insns[ctx->ninsns] = insn;
 
@@ -86,7 +111,7 @@ static inline int epilogue_offset(struct rv_jit_context *ctx)
 {
 	int to = ctx->epilogue_offset, from = ctx->ninsns;
 
-	return (to - from) << 2;
+	return ninsns_rvoff(to - from);
 }
 
 /* Return -1 or inverted cond. */
@@ -149,7 +174,7 @@ static inline int rv_offset(int insn, int off, struct rv_jit_context *ctx)
 	off++; /* BPF branch is from PC+1, RV is from PC */
 	from = (insn > 0) ? ctx->offset[insn - 1] : 0;
 	to = (insn + off > 0) ? ctx->offset[insn + off - 1] : 0;
-	return (to - from) << 2;
+	return ninsns_rvoff(to - from);
 }
 
 /* Instruction formats. */
diff --git a/arch/riscv/net/bpf_jit_comp32.c b/arch/riscv/net/bpf_jit_comp32.c
index b198eaa74456..bc5f2204693f 100644
--- a/arch/riscv/net/bpf_jit_comp32.c
+++ b/arch/riscv/net/bpf_jit_comp32.c
@@ -644,7 +644,7 @@ static int emit_branch_r64(const s8 *src1, const s8 *src2, s32 rvoff,
 
 	e = ctx->ninsns;
 	/* Adjust for extra insns. */
-	rvoff -= (e - s) << 2;
+	rvoff -= ninsns_rvoff(e - s);
 	emit_jump_and_link(RV_REG_ZERO, rvoff, true, ctx);
 	return 0;
 }
@@ -713,7 +713,7 @@ static int emit_bcc(u8 op, u8 rd, u8 rs, int rvoff, struct rv_jit_context *ctx)
 	if (far) {
 		e = ctx->ninsns;
 		/* Adjust for extra insns. */
-		rvoff -= (e - s) << 2;
+		rvoff -= ninsns_rvoff(e - s);
 		emit_jump_and_link(RV_REG_ZERO, rvoff, true, ctx);
 	}
 	return 0;
@@ -731,7 +731,7 @@ static int emit_branch_r32(const s8 *src1, const s8 *src2, s32 rvoff,
 
 	e = ctx->ninsns;
 	/* Adjust for extra insns. */
-	rvoff -= (e - s) << 2;
+	rvoff -= ninsns_rvoff(e - s);
 
 	if (emit_bcc(op, lo(rs1), lo(rs2), rvoff, ctx))
 		return -1;
@@ -795,7 +795,7 @@ static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
 	 * if (index >= max_entries)
 	 *   goto out;
 	 */
-	off = (tc_ninsn - (ctx->ninsns - start_insn)) << 2;
+	off = ninsns_rvoff(tc_ninsn - (ctx->ninsns - start_insn));
 	emit_bcc(BPF_JGE, lo(idx_reg), RV_REG_T1, off, ctx);
 
 	/*
@@ -804,7 +804,7 @@ static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
 	 *   goto out;
 	 */
 	emit(rv_addi(RV_REG_T1, RV_REG_TCC, -1), ctx);
-	off = (tc_ninsn - (ctx->ninsns - start_insn)) << 2;
+	off = ninsns_rvoff(tc_ninsn - (ctx->ninsns - start_insn));
 	emit_bcc(BPF_JSLT, RV_REG_TCC, RV_REG_ZERO, off, ctx);
 
 	/*
@@ -818,7 +818,7 @@ static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
 	if (is_12b_check(off, insn))
 		return -1;
 	emit(rv_lw(RV_REG_T0, off, RV_REG_T0), ctx);
-	off = (tc_ninsn - (ctx->ninsns - start_insn)) << 2;
+	off = ninsns_rvoff(tc_ninsn - (ctx->ninsns - start_insn));
 	emit_bcc(BPF_JEQ, RV_REG_T0, RV_REG_ZERO, off, ctx);
 
 	/*
@@ -1214,7 +1214,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 			emit_imm32(tmp2, imm, ctx);
 			src = tmp2;
 			e = ctx->ninsns;
-			rvoff -= (e - s) << 2;
+			rvoff -= ninsns_rvoff(e - s);
 		}
 
 		if (is64)
diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index 6cfd164cbe88..55861269da2a 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -304,14 +304,14 @@ static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
 	if (is_12b_check(off, insn))
 		return -1;
 	emit(rv_lwu(RV_REG_T1, off, RV_REG_A1), ctx);
-	off = (tc_ninsn - (ctx->ninsns - start_insn)) << 2;
+	off = ninsns_rvoff(tc_ninsn - (ctx->ninsns - start_insn));
 	emit_branch(BPF_JGE, RV_REG_A2, RV_REG_T1, off, ctx);
 
 	/* if (TCC-- < 0)
 	 *     goto out;
 	 */
 	emit(rv_addi(RV_REG_T1, tcc, -1), ctx);
-	off = (tc_ninsn - (ctx->ninsns - start_insn)) << 2;
+	off = ninsns_rvoff(tc_ninsn - (ctx->ninsns - start_insn));
 	emit_branch(BPF_JSLT, tcc, RV_REG_ZERO, off, ctx);
 
 	/* prog = array->ptrs[index];
@@ -324,7 +324,7 @@ static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
 	if (is_12b_check(off, insn))
 		return -1;
 	emit(rv_ld(RV_REG_T2, off, RV_REG_T2), ctx);
-	off = (tc_ninsn - (ctx->ninsns - start_insn)) << 2;
+	off = ninsns_rvoff(tc_ninsn - (ctx->ninsns - start_insn));
 	emit_branch(BPF_JEQ, RV_REG_T2, RV_REG_ZERO, off, ctx);
 
 	/* goto *(prog->bpf_func + 4); */
@@ -757,7 +757,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 			e = ctx->ninsns;
 
 			/* Adjust for extra insns */
-			rvoff -= (e - s) << 2;
+			rvoff -= ninsns_rvoff(e - s);
 		}
 
 		if (BPF_OP(code) == BPF_JSET) {
@@ -810,7 +810,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 		e = ctx->ninsns;
 
 		/* Adjust for extra insns */
-		rvoff -= (e - s) << 2;
+		rvoff -= ninsns_rvoff(e - s);
 		emit_branch(BPF_OP(code), rd, rs, rvoff, ctx);
 		break;
 
@@ -831,7 +831,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 		if (!is64 && imm < 0)
 			emit(rv_addiw(RV_REG_T1, RV_REG_T1, 0), ctx);
 		e = ctx->ninsns;
-		rvoff -= (e - s) << 2;
+		rvoff -= ninsns_rvoff(e - s);
 		emit_branch(BPF_JNE, RV_REG_T1, RV_REG_ZERO, rvoff, ctx);
 		break;
 
diff --git a/arch/riscv/net/bpf_jit_core.c b/arch/riscv/net/bpf_jit_core.c
index 709b94ece3ed..3630d447352c 100644
--- a/arch/riscv/net/bpf_jit_core.c
+++ b/arch/riscv/net/bpf_jit_core.c
@@ -73,7 +73,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 
 	if (ctx->offset) {
 		extra_pass = true;
-		image_size = sizeof(u32) * ctx->ninsns;
+		image_size = sizeof(*ctx->insns) * ctx->ninsns;
 		goto skip_init_ctx;
 	}
 
@@ -103,7 +103,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 			if (jit_data->header)
 				break;
 
-			image_size = sizeof(u32) * ctx->ninsns;
+			image_size = sizeof(*ctx->insns) * ctx->ninsns;
 			jit_data->header =
 				bpf_jit_binary_alloc(image_size,
 						     &jit_data->image,
@@ -114,7 +114,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 				goto out_offset;
 			}
 
-			ctx->insns = (u32 *)jit_data->image;
+			ctx->insns = (u16 *)jit_data->image;
 			/*
 			 * Now, when the image is allocated, the image can
 			 * potentially shrink more (auipc/jalr -> jal).
-- 
2.25.1

