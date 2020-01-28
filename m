Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5514014AE05
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 03:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbgA1CPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 21:15:09 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:55445 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727754AbgA1CPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 21:15:05 -0500
Received: by mail-pj1-f68.google.com with SMTP id d5so311167pjz.5
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 18:15:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=subject:date:message-id:mime-version:content-transfer-encoding:cc
         :from:to:in-reply-to:references;
        bh=LUiKWI3Cf+9+n0Mf0T0uSDtpI14DkFl6R/zPz6oE4kA=;
        b=t6Fkbs2B6XQQ1FJjHeJszTkGjc450EaIRq1KZfmbn8O4NYMZcq6AXMS7pmHbUboObC
         +++s+jeLdsA6RQB08P9Q5Ack/z09JhMpcwAH9ll/D/MNh2PF/l8bN+H59x2KdWIZQaGJ
         V6rLY45e1nmA4dzti6zKLzfbfSQH01wh1Pq+jqMqsvZxpHPcSUIN8yopf38iePTDe4Fn
         PnNN2/5p6w6AcizSaS4T/xDwCmkQr+gZ6sexRbfAK34zFGsth0Z8GT9lZrcVKfKxscsF
         FNGp79tHt13MmqPXpQkiJlgMycGe4X09ATmdUeh59o7i1ed82t9JibgA5r1Fh0RysWRj
         6HTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:date:message-id:mime-version
         :content-transfer-encoding:cc:from:to:in-reply-to:references;
        bh=LUiKWI3Cf+9+n0Mf0T0uSDtpI14DkFl6R/zPz6oE4kA=;
        b=Z95I4smXk2Lp4m0l/eGU4P1beNnHmebi27gVP1JwOTk9w1IracNQ2owlN1uhRLWAdp
         CzyBbnjgiUk3q3cW0Gg5mgGo+0tXAW0TGmSZ5numllWGQKfgKqaxlrw48afXLs/cx/9W
         RY28CqAKc76dW1UWKdq0Y/z9woMkuK6CR4YRhSUfyZcTvemy3tCVQqgO4B7ZfFsW6Zmd
         v/ENuD0xhxnjm2uBFcY+/dYFLa4EOyOdxxu0oSrJQBQ8zZwwslgd/ocDLzzZvQCTjcJw
         Uvn9gOXmk+Mm8VT5/qcTjBV8furSt/eQrDRtMGnF4jxljh4pnkvweSe5JnZ3PpPsng4V
         oQHw==
X-Gm-Message-State: APjAAAXgQmwaD3GdKNhxukBpWryPPQMT4xL1IqxH43ZdfolPLcCfHXN3
        jl88Gj0fwO3Qif5RJdWIkblqMd5xt68=
X-Google-Smtp-Source: APXvYqxlXoEawlGrjKe7Dg0dTNaImpBzNfwMgpu5Qd3tYpex5PzlG+tN2FelRoSSzPaUPamCbr5Lgw==
X-Received: by 2002:a17:902:9a09:: with SMTP id v9mr19976280plp.341.1580177704696;
        Mon, 27 Jan 2020 18:15:04 -0800 (PST)
Received: from localhost ([216.9.110.11])
        by smtp.gmail.com with ESMTPSA id o17sm393828pjq.1.2020.01.27.18.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 18:15:04 -0800 (PST)
Subject: [PATCH 4/4] arm64: bpf: Elide some moves to a0 after calls
Date:   Mon, 27 Jan 2020 18:11:45 -0800
Message-Id: <20200128021145.36774-5-palmerdabbelt@google.com>
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

On arm64, the BPF function ABI doesn't match the C function ABI.  Specifically,
arm64 encodes calls as `a0 = f(a0, a1, ...)` while BPF encodes calls as
`BPF_REG_0 = f(BPF_REG_1, BPF_REG_2, ...)`.  This discrepancy results in
function calls being encoded as a two operations sequence that first does a C
ABI calls and then moves the return register into the right place.  This
results in one extra instruction for every function call.

This patch adds an optimization to the arm64 BPF JIT backend that aims to avoid
some of these moves.

I've done no benchmarking to determine if this is correct.  I ran the BPF
selftests before and after the change on arm64 in QEMU and found that I had a
single failure both before and after.  I'm not at all confident this code
actually works as it's my first time doing anything with both ARM64 and BPF and
I didn't even open the documentation for either of these.  I was particularly
surprised that the code didn't fail any tests -- I was kind of assuming this
would fail the tests, get put on the backburner, sit long enough for me to stop
caring, and then get deleted.

Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
---
 arch/arm64/net/bpf_jit_comp.c | 71 +++++++++++++++++++++++++++++++++--
 1 file changed, 68 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index fba5b1b00cd7..48d900cc7258 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -58,10 +58,14 @@ struct jit_ctx {
 	int *offset;
 	__le32 *image;
 	u32 stack_size;
+	int reg0_in_reg1;
 };
 
 static inline int bpf2a64(struct jit_ctx *ctx, int bpf_reg)
 {
+	if (ctx->reg0_in_reg1 && bpf_reg == BPF_REG_0)
+		bpf_reg = BPF_REG_1;
+
 	return bpf2a64_default[bpf_reg];
 }
 
@@ -338,6 +342,47 @@ static void build_epilogue(struct jit_ctx *ctx)
 	emit(A64_RET(A64_LR), ctx);
 }
 
+static int dead_register(const struct jit_ctx *ctx, int offset, int bpf_reg)
+{
+	const struct bpf_prog *prog = ctx->prog;
+	int i;
+
+	for (i = offset; i < prog->len; ++i) {
+		const struct bpf_insn *insn = &prog->insnsi[i];
+		const u8 code = insn->code;
+		const u8 bpf_dst = insn->dst_reg;
+		const u8 bpf_src = insn->src_reg;
+		const int writes_dst = !((code & BPF_ST) || (code & BPF_STX)
+					 || (code & BPF_JMP32) || (code & BPF_JMP));
+		const int reads_dst  = !((code & BPF_LD));
+		const int reads_src  = true;
+
+		/* Calls are a bit special in that they clobber a bunch of regisers. */
+		if ((code & (BPF_JMP | BPF_CALL)) || (code & (BPF_JMP | BPF_TAIL_CALL)))
+			if ((bpf_reg >= BPF_REG_0) && (bpf_reg <= BPF_REG_5))
+				return false;
+
+		/* Registers that are read before they're written are alive.
+		 * Most opcodes are of the form DST = DEST op SRC, but there
+		 * are some exceptions.*/
+		if (bpf_src == bpf_reg && reads_src)
+			return false;
+
+		if (bpf_dst == bpf_reg && reads_dst)
+			return false;
+		
+		if (bpf_dst == bpf_reg && writes_dst)
+			return true;
+
+		/* Most BPF instructions are 8 bits long, but some ar 16 bits
+		 * long. */
+		if (code & (BPF_LD | BPF_IMM | BPF_DW))
+			++i;
+	}
+
+	return true;
+}
+
 /* JITs an eBPF instruction.
  * Returns:
  * 0  - successfully JITed an 8-byte eBPF instruction.
@@ -348,7 +393,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		      bool extra_pass)
 {
 	const u8 code = insn->code;
-	const u8 dstw = bpf2a64(ctx, insn->dst_reg);
+	u8 dstw;
 	const u8 dstr = bpf2a64(ctx, insn->dst_reg);
 	const u8 src = bpf2a64(ctx, insn->src_reg);
 	const u8 tmp = bpf2a64(ctx, TMP_REG_1);
@@ -374,6 +419,27 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 #define check_imm19(imm) check_imm(19, imm)
 #define check_imm26(imm) check_imm(26, imm)
 
+	/* Handle BPF_REG_0, which may be in the wrong place because the ARM64
+	 * ABI doesn't match the BPF ABI for function calls. */
+	if (ctx->reg0_in_reg1) {
+		/* If we're writing BPF_REG_0 then we don't need to do any
+		 * extra work to get the registers back in their correct
+		 * locations. */
+		if (insn->dst_reg == BPF_REG_0)
+			ctx->reg0_in_reg1 = false;
+
+		/* If we're writing to BPF_REG_1 then we need to save BPF_REG_0
+		 * into the correct location if it's still alive, as otherwise
+		 * it will be clobbered. */
+		if (insn->dst_reg == BPF_REG_1) {
+			if (!dead_register(ctx, off + 1, BPF_REG_0))
+				emit(A64_MOV(1, A64_R(7), A64_R(0)), ctx);
+			ctx->reg0_in_reg1 = false;
+		}
+	}
+
+	dstw = bpf2a64(ctx, insn->dst_reg);
+
 	switch (code) {
 	/* dst = src */
 	case BPF_ALU | BPF_MOV | BPF_X:
@@ -640,7 +706,6 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	/* function call */
 	case BPF_JMP | BPF_CALL:
 	{
-		const u8 r0 = bpf2a64(ctx, BPF_REG_0);
 		bool func_addr_fixed;
 		u64 func_addr;
 		int ret;
@@ -651,7 +716,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 			return ret;
 		emit_addr_mov_i64(tmp, func_addr, ctx);
 		emit(A64_BLR(tmp), ctx);
-		emit(A64_MOV(1, r0, A64_R(0)), ctx);
+		ctx->reg0_in_reg1 = true;
 		break;
 	}
 	/* tail call */
-- 
2.25.0.341.g760bfbb309-goog

