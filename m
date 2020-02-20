Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 468D8165637
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 05:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgBTEUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 23:20:33 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34161 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727576AbgBTEUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 23:20:33 -0500
Received: by mail-pf1-f194.google.com with SMTP id i6so1253633pfc.1
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 20:20:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=og9edFaHZnPmkuCex6wc/htEt3dB+T4YYkGkOXMur+Q=;
        b=e4M309azK9eW2AtYxFgrOwNuJPjOE38WDMCO9xnlzZ3UDsoNjQEz762YW712xxcZQJ
         yQxNJhLv8vdPChpAGfsqulvsIRu9+U1D1izjj1HnHkdShan8V89/8dJ1vgYXwEZzm2ZY
         YWLb0MYRmQYm798N7WX461npxLvJZoaL0HSs8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=og9edFaHZnPmkuCex6wc/htEt3dB+T4YYkGkOXMur+Q=;
        b=XiYapylYvz5d6DoSiiYL6i0lUKsZ4rdbP+3/AYuYkB0c3hdt2j5dZIUz3VtrdCz59O
         DMOeMm4QgwFGRz68XzTLBGFZ9CgLSLt68UHydKl1g6bBmy3tSY1xtm6b7aRbec/UahAd
         vigT9BUtKqOTalrLL25PfRqLQYq+eLU2swMG/q7DfkRLNY3syiTX1UWdlhp2SR5lVl3/
         BusAwMxyMH6m80J/s/V9MCbvHhAfAI4KgG9sFoWT9JQhpeWR08+gXxEF/KgFPJRJy97j
         ky7JnFD5oLCRpaJeDAF1ut/C0q8fubNPzsgDR9IHjHw4lDYwpMfBQ3MiP2TdYKU4E07R
         ucTQ==
X-Gm-Message-State: APjAAAV/05Non8NjBGEghTkuXdSAtq5ZjjSbbWY2v1B7uAiY5vt/C0aG
        TsacPFJhJaybNZTZtVIhUTjQxw==
X-Google-Smtp-Source: APXvYqwh3OXl6ocmIMzjHuD0GTcPjPsjTJqEdK7ny10Hopzhzod/kmFXprbyKiNZzIQW+lHmX5lzKA==
X-Received: by 2002:a63:731c:: with SMTP id o28mr5993951pgc.139.1582172430617;
        Wed, 19 Feb 2020 20:20:30 -0800 (PST)
Received: from kaby.cs.washington.edu ([2607:4000:200:11:8889:5a39:583:3c7f])
        by smtp.gmail.com with ESMTPSA id h185sm1247815pfg.135.2020.02.19.20.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 20:20:30 -0800 (PST)
From:   Luke Nelson <lukenels@cs.washington.edu>
To:     bpf@vger.kernel.org
Cc:     Luke Nelson <lukenels@cs.washington.edu>,
        Jiong Wang <jiong.wang@netronome.com>,
        Xi Wang <xi.wang@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v3 bpf-next] RV32G eBPF JIT
Date:   Wed, 19 Feb 2020 20:16:07 -0800
Message-Id: <20200220041608.30289-1-lukenels@cs.washington.edu>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an eBPF JIT for RV32G, adapted from the JIT for RV64G and
the 32-bit ARM JIT.

There are two main changes required for this to work compared to
the RV64 JIT.

First, eBPF registers are 64-bit, while RV32G registers are 32-bit.
BPF registers either map directly to 2 RISC-V registers, or reside
in stack scratch space and are saved and restored when used.

Second, many 64-bit ALU operations do not trivially map to 32-bit
operations. Operations that move bits between high and low words,
such as ADD, LSH, MUL, and others must emulate the 64-bit behavior
in terms of 32-bit instructions.

Supported features:

This JIT supports the same features and instructions as RV64, with the
following exceptions:

- ALU64 DIV/MOD: Requires loops to implement on 32-bit hardware.

- BPF_XADD | BPF_DW: Requires either an 8-byte atomic instruction
  in the target (which doesn't exist in RV32), or acqusition of
  locks in generated code.

These features are also unsupported on other BPF JITs for 32-bit
architectures.

Testing:

- lib/test_bpf.c
test_bpf: Summary: 378 PASSED, 0 FAILED, [349/366 JIT'ed]
test_bpf: test_skb_segment: Summary: 2 PASSED, 0 FAILED

- tools/testing/selftests/bpf/test_verifier.c
Summary: 1415 PASSED, 122 SKIPPED, 43 FAILED

This is the same set of tests that pass using the BPF interpreter with
the JIT disabled.

Running the BPF kernel tests / selftests on riscv32 is non-trivial,
to help others reproduce the test results I made a guide here:
https://github.com/lukenels/meta-linux-utils/tree/master/rv32-linux

Verification and synthesis:

We developed this JIT using our verification tool that we have used
in the past to verify patches to the RV64 JIT.  We also used the
tool to superoptimize the resulting code through program synthesis.

You can find the tool and a guide to the approach and results here:
https://github.com/uw-unsat/bpf-jit-verif

Changelog:

v2 -> v3:
  * Added support for far jumps / branches similar to RV64 JIT.
  * Added support for tail calls.
  * Cleaned up code with more optimizations and comments.
  * Removed special zero-extension instruction from BPF_ALU64
    case, pointed out by Jiong Wang.

v1 -> v2:
  * Added support for far conditional branches.
  * Added the zero-extension optimization pointed out by Jiong Wang.
  * Added more optimizations for operations with an immediate operand.

Cc: Jiong Wang <jiong.wang@netronome.com>
Co-developed-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Luke Nelson <lukenels@cs.washington.edu>
---
 arch/riscv/Kconfig              |    2 +-
 arch/riscv/net/Makefile         |    7 +-
 arch/riscv/net/bpf_jit_comp32.c | 1840 +++++++++++++++++++++++++++++++
 3 files changed, 1847 insertions(+), 2 deletions(-)
 create mode 100644 arch/riscv/net/bpf_jit_comp32.c

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 73f029eae0cc..e9791717e006 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -56,7 +56,7 @@ config RISCV
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_MMIOWB
 	select ARCH_HAS_DEBUG_VIRTUAL
-	select HAVE_EBPF_JIT if 64BIT
+	select HAVE_EBPF_JIT
 	select EDAC_SUPPORT
 	select ARCH_HAS_GIGANTIC_PAGE
 	select ARCH_WANT_HUGE_PMD_SHARE if 64BIT
diff --git a/arch/riscv/net/Makefile b/arch/riscv/net/Makefile
index ec5b14763316..5511fb1dd40e 100644
--- a/arch/riscv/net/Makefile
+++ b/arch/riscv/net/Makefile
@@ -1,2 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_BPF_JIT) += bpf_jit_comp.o
+
+ifeq ($(CONFIG_ARCH_RV64I),y)
+	obj-$(CONFIG_BPF_JIT) += bpf_jit_comp.o
+else
+	obj-$(CONFIG_BPF_JIT) += bpf_jit_comp32.o
+endif
diff --git a/arch/riscv/net/bpf_jit_comp32.c b/arch/riscv/net/bpf_jit_comp32.c
new file mode 100644
index 000000000000..f4f2c8a40cbf
--- /dev/null
+++ b/arch/riscv/net/bpf_jit_comp32.c
@@ -0,0 +1,1840 @@
+// SPDX-License-Identifier: GPL-2.0
+/* BPF JIT compiler for RV32G
+ *
+ * Copyright (c) 2019 Luke Nelson <luke.r.nels@gmail.com>
+ *
+ * This code is based on the code and ideas from
+ * Björn Töpel <bjorn.topel@gmail.com>, who wrote the rv64g BPF JIT, and
+ * Shubham Bansal <illusionist.neo@gmail.com> and Mircea Gherzan <mgherzan@gmail.com>,
+ * who wrote the 32-bit ARM BPF JIT.
+ */
+
+#include <linux/bpf.h>
+#include <linux/filter.h>
+#include <asm/cacheflush.h>
+
+enum {
+	RV_REG_ZERO =	0,	/* The constant value 0 */
+	RV_REG_RA =	1,	/* Return address */
+	RV_REG_SP =	2,	/* Stack pointer */
+	RV_REG_GP =	3,	/* Global pointer */
+	RV_REG_TP =	4,	/* Thread pointer */
+	RV_REG_T0 =	5,	/* Temporaries */
+	RV_REG_T1 =	6,
+	RV_REG_T2 =	7,
+	RV_REG_FP =	8,
+	RV_REG_S1 =	9,	/* Saved registers */
+	RV_REG_A0 =	10,	/* Function argument/return values */
+	RV_REG_A1 =	11,	/* Function arguments */
+	RV_REG_A2 =	12,
+	RV_REG_A3 =	13,
+	RV_REG_A4 =	14,
+	RV_REG_A5 =	15,
+	RV_REG_A6 =	16,
+	RV_REG_A7 =	17,
+	RV_REG_S2 =	18,	/* Saved registers */
+	RV_REG_S3 =	19,
+	RV_REG_S4 =	20,
+	RV_REG_S5 =	21,
+	RV_REG_S6 =	22,
+	RV_REG_S7 =	23,
+	RV_REG_S8 =	24,
+	RV_REG_S9 =	25,
+	RV_REG_S10 =	26,
+	RV_REG_S11 =	27,
+	RV_REG_T3 =	28,	/* Temporaries */
+	RV_REG_T4 =	29,
+	RV_REG_T5 =	30,
+	RV_REG_T6 =	31,
+};
+
+enum {
+	/* Stack layout - these are offsets from (top of stack - 4) */
+	BPF_R6_HI,
+	BPF_R6_LO,
+	BPF_R7_HI,
+	BPF_R7_LO,
+	BPF_R8_HI,
+	BPF_R8_LO,
+	BPF_R9_HI,
+	BPF_R9_LO,
+	BPF_AX_HI,
+	BPF_AX_LO,
+	/* Stack space for BPF_REG_6, BPF_REG_7, BPF_REG_8, BPF_REG_9,
+	 * BPF_REG_AX and tail call counts.
+	 */
+	BPF_JIT_SCRATCH_REGS,
+};
+
+#define STACK_OFFSET(k) (-4 - ((k) * 4))
+
+#define TMP_REG_1	(MAX_BPF_JIT_REG + 0)	/* TEMP Register 1 */
+#define TMP_REG_2	(MAX_BPF_JIT_REG + 1)	/* TEMP Register 2 */
+
+#define RV_REG_TCC		RV_REG_T6
+#define RV_REG_TCC_SAVED	RV_REG_S7
+
+#define NR_JIT_ITERATIONS	16	/* Number of iterations to try until offsets converge. */
+
+static const s8 bpf2rv32[][2] = {
+	/* Return value from in-kernel function, and exit value from eBPF */
+	[BPF_REG_0] = {RV_REG_S2, RV_REG_S1},
+	/* Arguments from eBPF program to in-kernel function */
+	[BPF_REG_1] = {RV_REG_A1, RV_REG_A0},
+	[BPF_REG_2] = {RV_REG_A3, RV_REG_A2},
+	[BPF_REG_3] = {RV_REG_A5, RV_REG_A4},
+	[BPF_REG_4] = {RV_REG_A7, RV_REG_A6},
+	[BPF_REG_5] = {RV_REG_S4, RV_REG_S3},
+	/* Callee saved registers that in-kernel function will preserve */
+	/* Stored on stack scratch space */
+	[BPF_REG_6] = {STACK_OFFSET(BPF_R6_HI), STACK_OFFSET(BPF_R6_LO)},
+	[BPF_REG_7] = {STACK_OFFSET(BPF_R7_HI), STACK_OFFSET(BPF_R7_LO)},
+	[BPF_REG_8] = {STACK_OFFSET(BPF_R8_HI), STACK_OFFSET(BPF_R8_LO)},
+	[BPF_REG_9] = {STACK_OFFSET(BPF_R9_HI), STACK_OFFSET(BPF_R9_LO)},
+	/* Read only Frame Pointer to access Stack */
+	[BPF_REG_FP] = {RV_REG_S6, RV_REG_S5},
+	/* Temporary register for blinding constants.
+	 * Stored on stack scratch space.
+	 */
+	[BPF_REG_AX] = {STACK_OFFSET(BPF_AX_HI), STACK_OFFSET(BPF_AX_LO)},
+	/* Temporary Register for internal BPF JIT,
+	 * used to operate on BPF registers stored on stack.
+	 * Save t0 and t1 for use internal to one instruction.
+	 */
+	[TMP_REG_1] = {RV_REG_T3, RV_REG_T2},
+	[TMP_REG_2] = {RV_REG_T5, RV_REG_T4},
+};
+
+static s8 hi(const s8 *r)
+{
+	return r[0];
+}
+
+static s8 lo(const s8 *r)
+{
+	return r[1];
+}
+
+struct rv_jit_context {
+	struct bpf_prog *prog;
+	u32 *insns; /* RV insns */
+	int ninsns;
+	int epilogue_offset;
+	int *offset; /* BPF to RV */
+	unsigned long flags;
+	int stack_size;
+};
+
+struct rv_jit_data {
+	struct bpf_binary_header *header;
+	u8 *image;
+	struct rv_jit_context ctx;
+};
+
+static void emit(const u32 insn, struct rv_jit_context *ctx)
+{
+	if (ctx->insns)
+		ctx->insns[ctx->ninsns] = insn;
+
+	ctx->ninsns++;
+}
+
+static u32 rv_r_insn(u8 funct7, u8 rs2, u8 rs1, u8 funct3, u8 rd, u8 opcode)
+{
+	return (funct7 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) |
+		(rd << 7) | opcode;
+}
+
+static u32 rv_i_insn(u16 imm11_0, u8 rs1, u8 funct3, u8 rd, u8 opcode)
+{
+	return (imm11_0 << 20) | (rs1 << 15) | (funct3 << 12) | (rd << 7) |
+		opcode;
+}
+
+static u32 rv_s_insn(u16 imm11_0, u8 rs2, u8 rs1, u8 funct3, u8 opcode)
+{
+	u8 imm11_5 = imm11_0 >> 5, imm4_0 = imm11_0 & 0x1f;
+
+	return (imm11_5 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) |
+		(imm4_0 << 7) | opcode;
+}
+
+static u32 rv_sb_insn(u16 imm12_1, u8 rs2, u8 rs1, u8 funct3, u8 opcode)
+{
+	u8 imm12 = ((imm12_1 & 0x800) >> 5) | ((imm12_1 & 0x3f0) >> 4);
+	u8 imm4_1 = ((imm12_1 & 0xf) << 1) | ((imm12_1 & 0x400) >> 10);
+
+	return (imm12 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) |
+		(imm4_1 << 7) | opcode;
+}
+
+static u32 rv_u_insn(u32 imm31_12, u8 rd, u8 opcode)
+{
+	return (imm31_12 << 12) | (rd << 7) | opcode;
+}
+
+static u32 rv_uj_insn(u32 imm20_1, u8 rd, u8 opcode)
+{
+	u32 imm;
+
+	imm = (imm20_1 & 0x80000) |  ((imm20_1 & 0x3ff) << 9) |
+		((imm20_1 & 0x400) >> 2) | ((imm20_1 & 0x7f800) >> 11);
+
+	return (imm << 12) | (rd << 7) | opcode;
+}
+
+static u32 rv_amo_insn(u8 funct5, u8 aq, u8 rl, u8 rs2, u8 rs1,
+		       u8 funct3, u8 rd, u8 opcode)
+{
+	u8 funct7 = (funct5 << 2) | (aq << 1) | rl;
+
+	return rv_r_insn(funct7, rs2, rs1, funct3, rd, opcode);
+}
+
+static u32 rv_addi(u8 rd, u8 rs1, u16 imm11_0)
+{
+	return rv_i_insn(imm11_0, rs1, 0, rd, 0x13);
+}
+
+static u32 rv_add(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(0, rs2, rs1, 0, rd, 0x33);
+}
+
+static u32 rv_sub(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(0x20, rs2, rs1, 0, rd, 0x33);
+}
+
+static u32 rv_and(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(0, rs2, rs1, 7, rd, 0x33);
+}
+
+static u32 rv_or(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(0, rs2, rs1, 6, rd, 0x33);
+}
+
+static u32 rv_xor(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(0, rs2, rs1, 4, rd, 0x33);
+}
+
+static u32 rv_mul(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(1, rs2, rs1, 0, rd, 0x33);
+}
+
+static u32 rv_mulhu(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(1, rs2, rs1, 3, rd, 0x33);
+}
+
+static u32 rv_divu(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(1, rs2, rs1, 5, rd, 0x33);
+}
+
+static u32 rv_remu(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(1, rs2, rs1, 7, rd, 0x33);
+}
+
+static u32 rv_sll(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(0, rs2, rs1, 1, rd, 0x33);
+}
+
+static u32 rv_srl(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(0, rs2, rs1, 5, rd, 0x33);
+}
+
+static u32 rv_sra(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(0x20, rs2, rs1, 5, rd, 0x33);
+}
+
+static u32 rv_sltu(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(0, rs2, rs1, 3, rd, 0x33);
+}
+
+static u32 rv_lui(u8 rd, u32 imm31_12)
+{
+	return rv_u_insn(imm31_12, rd, 0x37);
+}
+
+static u32 rv_slli(u8 rd, u8 rs1, u16 imm11_0)
+{
+	return rv_i_insn(imm11_0, rs1, 1, rd, 0x13);
+}
+
+static u32 rv_srli(u8 rd, u8 rs1, u16 imm11_0)
+{
+	return rv_i_insn(imm11_0, rs1, 5, rd, 0x13);
+}
+
+static u32 rv_srai(u8 rd, u8 rs1, u16 imm11_0)
+{
+	return rv_i_insn(0x400 | imm11_0, rs1, 5, rd, 0x13);
+}
+
+static u32 rv_andi(u8 rd, u8 rs1, u16 imm11_0)
+{
+	return rv_i_insn(imm11_0, rs1, 7, rd, 0x13);
+}
+
+static u32 rv_ori(u8 rd, u8 rs1, u16 imm11_0)
+{
+	return rv_i_insn(imm11_0, rs1, 6, rd, 0x13);
+}
+
+static u32 rv_xori(u8 rd, u8 rs1, u16 imm11_0)
+{
+	return rv_i_insn(imm11_0, rs1, 4, rd, 0x13);
+}
+
+static u32 rv_jal(u8 rd, u32 imm20_1)
+{
+	return rv_uj_insn(imm20_1, rd, 0x6f);
+}
+
+static u32 rv_jalr(u8 rd, u8 rs1, u16 imm11_0)
+{
+	return rv_i_insn(imm11_0, rs1, 0, rd, 0x67);
+}
+
+static u32 rv_beq(u8 rs1, u8 rs2, u16 imm12_1)
+{
+	return rv_sb_insn(imm12_1, rs2, rs1, 0, 0x63);
+}
+
+static u32 rv_bltu(u8 rs1, u8 rs2, u16 imm12_1)
+{
+	return rv_sb_insn(imm12_1, rs2, rs1, 6, 0x63);
+}
+
+static u32 rv_bgtu(u8 rs1, u8 rs2, u16 imm12_1)
+{
+	return rv_sb_insn(imm12_1, rs1, rs2, 6, 0x63);
+}
+
+static u32 rv_bgeu(u8 rs1, u8 rs2, u16 imm12_1)
+{
+	return rv_sb_insn(imm12_1, rs2, rs1, 7, 0x63);
+}
+
+static u32 rv_bleu(u8 rs1, u8 rs2, u16 imm12_1)
+{
+	return rv_sb_insn(imm12_1, rs1, rs2, 7, 0x63);
+}
+
+static u32 rv_bne(u8 rs1, u8 rs2, u16 imm12_1)
+{
+	return rv_sb_insn(imm12_1, rs2, rs1, 1, 0x63);
+}
+
+static u32 rv_blt(u8 rs1, u8 rs2, u16 imm12_1)
+{
+	return rv_sb_insn(imm12_1, rs2, rs1, 4, 0x63);
+}
+
+static u32 rv_bgt(u8 rs1, u8 rs2, u16 imm12_1)
+{
+	return rv_sb_insn(imm12_1, rs1, rs2, 4, 0x63);
+}
+
+static u32 rv_bge(u8 rs1, u8 rs2, u16 imm12_1)
+{
+	return rv_sb_insn(imm12_1, rs2, rs1, 5, 0x63);
+}
+
+static u32 rv_ble(u8 rs1, u8 rs2, u16 imm12_1)
+{
+	return rv_sb_insn(imm12_1, rs1, rs2, 5, 0x63);
+}
+
+static u32 rv_sb(u8 rs1, u16 imm11_0, u8 rs2)
+{
+	return rv_s_insn(imm11_0, rs2, rs1, 0, 0x23);
+}
+
+static u32 rv_sh(u8 rs1, u16 imm11_0, u8 rs2)
+{
+	return rv_s_insn(imm11_0, rs2, rs1, 1, 0x23);
+}
+
+static u32 rv_sw(u8 rs1, u16 imm11_0, u8 rs2)
+{
+	return rv_s_insn(imm11_0, rs2, rs1, 2, 0x23);
+}
+
+static u32 rv_lbu(u8 rd, u16 imm11_0, u8 rs1)
+{
+	return rv_i_insn(imm11_0, rs1, 4, rd, 0x03);
+}
+
+static u32 rv_lhu(u8 rd, u16 imm11_0, u8 rs1)
+{
+	return rv_i_insn(imm11_0, rs1, 5, rd, 0x03);
+}
+
+static u32 rv_lw(u8 rd, u16 imm11_0, u8 rs1)
+{
+	return rv_i_insn(imm11_0, rs1, 2, rd, 0x03);
+}
+
+static u32 rv_amoadd_w(u8 rd, u8 rs2, u8 rs1, u8 aq, u8 rl)
+{
+	return rv_amo_insn(0, aq, rl, rs2, rs1, 2, rd, 0x2f);
+}
+
+static u32 rv_auipc(u8 rd, u32 imm31_12)
+{
+	return rv_u_insn(imm31_12, rd, 0x17);
+}
+
+static bool is_12b_int(s32 val)
+{
+	return -(1 << 11) <= val && val < (1 << 11);
+}
+
+static bool is_13b_int(s32 val)
+{
+	return -(1 << 12) <= val && val < (1 << 12);
+}
+
+static bool is_21b_int(s32 val)
+{
+	return -(1L << 20) <= val && val < (1L << 20);
+}
+
+static void emit_imm(const s8 rd, s32 imm, struct rv_jit_context *ctx)
+{
+	u32 upper = (imm + (1 << 11)) >> 12;
+	u32 lower = imm & 0xfff;
+
+	if (upper) {
+		emit(rv_lui(rd, upper), ctx);
+		emit(rv_addi(rd, rd, lower), ctx);
+	} else {
+		emit(rv_addi(rd, RV_REG_ZERO, lower), ctx);
+	}
+}
+
+static void emit_imm32(const s8 *rd, s32 imm, struct rv_jit_context *ctx)
+{
+	/* Emit immediate into lower bits. */
+	emit_imm(lo(rd), imm, ctx);
+
+	/* Sign-extend into upper bits. */
+	if (imm >= 0)
+		emit(rv_addi(hi(rd), RV_REG_ZERO, 0), ctx);
+	else
+		emit(rv_addi(hi(rd), RV_REG_ZERO, -1), ctx);
+}
+
+static void emit_imm64(const s8 *rd, s32 imm_hi, s32 imm_lo,
+		       struct rv_jit_context *ctx)
+{
+	emit_imm(lo(rd), imm_lo, ctx);
+	emit_imm(hi(rd), imm_hi, ctx);
+}
+
+static int rv_offset(int insn, int off, struct rv_jit_context *ctx)
+{
+	int from, to;
+
+	off++; /* BPF branch is from PC+1, RV is from PC */
+	from = (insn > 0) ? ctx->offset[insn - 1] : 0;
+	to = (insn + off > 0) ? ctx->offset[insn + off - 1] : 0;
+	return (to - from) << 2;
+}
+
+static int epilogue_offset(struct rv_jit_context *ctx)
+{
+	int to = ctx->epilogue_offset, from = ctx->ninsns;
+
+	return (to - from) << 2;
+}
+
+static void __build_epilogue(bool is_tail_call, struct rv_jit_context *ctx)
+{
+	int stack_adjust = ctx->stack_size, store_offset = stack_adjust - 4;
+	const s8 *r0 = bpf2rv32[BPF_REG_0];
+
+	store_offset -= 4 * BPF_JIT_SCRATCH_REGS;
+
+	/* Set return value if not tail call. */
+	if (!is_tail_call) {
+		emit(rv_addi(RV_REG_A0, lo(r0), 0), ctx);
+		emit(rv_addi(RV_REG_A1, hi(r0), 0), ctx);
+	}
+
+	/* Restore callee-saved registers. */
+	emit(rv_lw(RV_REG_RA, store_offset - 0, RV_REG_SP), ctx);
+	emit(rv_lw(RV_REG_FP, store_offset - 4, RV_REG_SP), ctx);
+	emit(rv_lw(RV_REG_S1, store_offset - 8, RV_REG_SP), ctx);
+	emit(rv_lw(RV_REG_S2, store_offset - 12, RV_REG_SP), ctx);
+	emit(rv_lw(RV_REG_S3, store_offset - 16, RV_REG_SP), ctx);
+	emit(rv_lw(RV_REG_S4, store_offset - 20, RV_REG_SP), ctx);
+	emit(rv_lw(RV_REG_S5, store_offset - 24, RV_REG_SP), ctx);
+	emit(rv_lw(RV_REG_S6, store_offset - 28, RV_REG_SP), ctx);
+	emit(rv_lw(RV_REG_S7, store_offset - 32, RV_REG_SP), ctx);
+
+	emit(rv_addi(RV_REG_SP, RV_REG_SP, stack_adjust), ctx);
+
+	if (is_tail_call) {
+		/* goto *(t0 + 4);
+		 * Skip first instruction of prologue which
+		 * initializes tail call counter.
+		 * Assume t0 contains address of target program,
+		 * see emit_bpf_tail_call.
+		 */
+		emit(rv_jalr(RV_REG_ZERO, RV_REG_T0, 4), ctx);
+	} else {
+		emit(rv_jalr(RV_REG_ZERO, RV_REG_RA, 0), ctx);
+	}
+}
+
+static void build_epilogue(struct rv_jit_context *ctx)
+{
+	__build_epilogue(false, ctx);
+}
+
+static bool is_stacked(s8 reg)
+{
+	return reg < 0;
+}
+
+static const s8 *rv32_bpf_get_reg64(const s8 *reg, const s8 *tmp,
+				    struct rv_jit_context *ctx)
+{
+	if (is_stacked(hi(reg))) {
+		emit(rv_lw(hi(tmp), hi(reg), RV_REG_FP), ctx);
+		emit(rv_lw(lo(tmp), lo(reg), RV_REG_FP), ctx);
+		reg = tmp;
+	}
+	return reg;
+}
+
+static void rv32_bpf_put_reg64(const s8 *reg, const s8 *src,
+			       struct rv_jit_context *ctx)
+{
+	if (is_stacked(hi(reg))) {
+		emit(rv_sw(RV_REG_FP, hi(reg), hi(src)), ctx);
+		emit(rv_sw(RV_REG_FP, lo(reg), lo(src)), ctx);
+	}
+}
+
+static const s8 *rv32_bpf_get_reg32(const s8 *reg, const s8 *tmp,
+				    struct rv_jit_context *ctx)
+{
+	if (is_stacked(lo(reg))) {
+		emit(rv_lw(lo(tmp), lo(reg), RV_REG_FP), ctx);
+		reg = tmp;
+	}
+	return reg;
+}
+
+static void rv32_bpf_put_reg32(const s8 *reg, const s8 *src,
+			       struct rv_jit_context *ctx)
+{
+	if (is_stacked(lo(reg))) {
+		emit(rv_sw(RV_REG_FP, lo(reg), lo(src)), ctx);
+		if (!ctx->prog->aux->verifier_zext)
+			emit(rv_sw(RV_REG_FP, hi(reg), RV_REG_ZERO), ctx);
+	} else if (!ctx->prog->aux->verifier_zext) {
+		emit(rv_addi(hi(reg), RV_REG_ZERO, 0), ctx);
+	}
+}
+
+static void emit_jump_and_link(u8 rd, s32 rvoff, bool force_jalr,
+			       struct rv_jit_context *ctx)
+{
+	s32 upper, lower;
+
+	if (rvoff && is_21b_int(rvoff) && !force_jalr) {
+		emit(rv_jal(rd, rvoff >> 1), ctx);
+		return;
+	}
+
+	upper = (rvoff + (1 << 11)) >> 12;
+	lower = rvoff & 0xfff;
+	emit(rv_auipc(RV_REG_T1, upper), ctx);
+	emit(rv_jalr(rd, RV_REG_T1, lower), ctx);
+}
+
+static void emit_rv32_alu_i64(const s8 dst[], s32 imm,
+			      struct rv_jit_context *ctx,
+			      const u8 op)
+{
+	const s8 *tmp1 = bpf2rv32[TMP_REG_1];
+	const s8 *rd = rv32_bpf_get_reg64(dst, tmp1, ctx);
+
+	switch (op) {
+	case BPF_MOV:
+		emit_imm32(rd, imm, ctx);
+		break;
+	case BPF_AND:
+		if (is_12b_int(imm)) {
+			emit(rv_andi(lo(rd), lo(rd), imm), ctx);
+		} else {
+			emit_imm(RV_REG_T0, imm, ctx);
+			emit(rv_and(lo(rd), lo(rd), RV_REG_T0), ctx);
+		}
+		if (imm >= 0) {
+			emit(rv_addi(hi(rd), RV_REG_ZERO, 0), ctx);
+		}
+		break;
+	case BPF_OR:
+		if (is_12b_int(imm)) {
+			emit(rv_ori(lo(rd), lo(rd), imm), ctx);
+		} else {
+			emit_imm(RV_REG_T0, imm, ctx);
+			emit(rv_or(lo(rd), lo(rd), RV_REG_T0), ctx);
+		}
+		if (imm < 0) {
+			emit(rv_ori(hi(rd), RV_REG_ZERO, -1), ctx);
+		}
+		break;
+	case BPF_XOR:
+		if (is_12b_int(imm)) {
+			emit(rv_xori(lo(rd), lo(rd), imm), ctx);
+		} else {
+			emit_imm(RV_REG_T0, imm, ctx);
+			emit(rv_xor(lo(rd), lo(rd), RV_REG_T0), ctx);
+		}
+		if (imm < 0) {
+			emit(rv_xori(hi(rd), hi(rd), -1), ctx);
+		}
+		break;
+	case BPF_LSH:
+		if (imm >= 32) {
+			emit(rv_slli(hi(rd), lo(rd), imm - 32), ctx);
+			emit(rv_addi(lo(rd), RV_REG_ZERO, 0), ctx);
+		} else if (imm == 0) {
+			/* nop */
+		} else {
+			emit(rv_srli(RV_REG_T0, lo(rd), 32 - imm), ctx);
+			emit(rv_slli(hi(rd), hi(rd), imm), ctx);
+			emit(rv_or(hi(rd), RV_REG_T0, hi(rd)), ctx);
+			emit(rv_slli(lo(rd), lo(rd), imm), ctx);
+		}
+		break;
+	case BPF_RSH:
+		if (imm >= 32) {
+			emit(rv_srli(lo(rd), hi(rd), imm - 32), ctx);
+			emit(rv_addi(hi(rd), RV_REG_ZERO, 0), ctx);
+		} else if (imm == 0) {
+			/* nop */
+		} else {
+			emit(rv_slli(RV_REG_T0, hi(rd), 32 - imm), ctx);
+			emit(rv_srli(lo(rd), lo(rd), imm), ctx);
+			emit(rv_or(lo(rd), RV_REG_T0, lo(rd)), ctx);
+			emit(rv_srli(hi(rd), hi(rd), imm), ctx);
+		}
+		break;
+	case BPF_ARSH:
+		if (imm >= 32) {
+			emit(rv_srai(lo(rd), hi(rd), imm - 32), ctx);
+			emit(rv_srai(hi(rd), hi(rd), 31), ctx);
+		} else if (imm == 0) {
+			/* nop */
+		} else {
+			emit(rv_slli(RV_REG_T0, hi(rd), 32 - imm), ctx);
+			emit(rv_srli(lo(rd), lo(rd), imm), ctx);
+			emit(rv_or(lo(rd), RV_REG_T0, lo(rd)), ctx);
+			emit(rv_srai(hi(rd), hi(rd), imm), ctx);
+		}
+		break;
+	}
+
+	rv32_bpf_put_reg64(dst, rd, ctx);
+}
+
+static void emit_rv32_alu_i32(const s8 dst[], s32 imm,
+			      struct rv_jit_context *ctx,
+			      const u8 op)
+{
+	const s8 *tmp1 = bpf2rv32[TMP_REG_1];
+	const s8 *rd = rv32_bpf_get_reg32(dst, tmp1, ctx);
+
+	switch (op) {
+	case BPF_MOV:
+		emit_imm(lo(rd), imm, ctx);
+		break;
+	case BPF_ADD:
+		if (is_12b_int(imm)) {
+			emit(rv_addi(lo(rd), lo(rd), imm), ctx);
+		} else {
+			emit_imm(RV_REG_T0, imm, ctx);
+			emit(rv_add(lo(rd), lo(rd), RV_REG_T0), ctx);
+		}
+		break;
+	case BPF_SUB:
+		if (is_12b_int(-imm)) {
+			emit(rv_addi(lo(rd), lo(rd), -imm), ctx);
+		} else {
+			emit_imm(RV_REG_T0, imm, ctx);
+			emit(rv_sub(lo(rd), lo(rd), RV_REG_T0), ctx);
+		}
+		break;
+	case BPF_AND:
+		if (is_12b_int(imm)) {
+			emit(rv_andi(lo(rd), lo(rd), imm), ctx);
+		} else {
+			emit_imm(RV_REG_T0, imm, ctx);
+			emit(rv_and(lo(rd), lo(rd), RV_REG_T0), ctx);
+		}
+		break;
+	case BPF_OR:
+		if (is_12b_int(imm)) {
+			emit(rv_ori(lo(rd), lo(rd), imm), ctx);
+		} else {
+			emit_imm(RV_REG_T0, imm, ctx);
+			emit(rv_or(lo(rd), lo(rd), RV_REG_T0), ctx);
+		}
+		break;
+	case BPF_XOR:
+		if (is_12b_int(imm)) {
+			emit(rv_xori(lo(rd), lo(rd), imm), ctx);
+		} else {
+			emit_imm(RV_REG_T0, imm, ctx);
+			emit(rv_xor(lo(rd), lo(rd), RV_REG_T0), ctx);
+		}
+		break;
+	case BPF_LSH:
+		if (is_12b_int(imm)) {
+			emit(rv_slli(lo(rd), lo(rd), imm), ctx);
+		} else {
+			emit_imm(RV_REG_T0, imm, ctx);
+			emit(rv_sll(lo(rd), lo(rd), RV_REG_T0), ctx);
+		}
+		break;
+	case BPF_RSH:
+		if (is_12b_int(imm)) {
+			emit(rv_srli(lo(rd), lo(rd), imm), ctx);
+		} else {
+			emit_imm(RV_REG_T0, imm, ctx);
+			emit(rv_srl(lo(rd), lo(rd), RV_REG_T0), ctx);
+		}
+		break;
+	case BPF_ARSH:
+		if (is_12b_int(imm)) {
+			emit(rv_srai(lo(rd), lo(rd), imm), ctx);
+		} else {
+			emit_imm(RV_REG_T0, imm, ctx);
+			emit(rv_sra(lo(rd), lo(rd), RV_REG_T0), ctx);
+		}
+		break;
+	}
+
+	rv32_bpf_put_reg32(dst, rd, ctx);
+}
+
+static void emit_rv32_alu_r64(const s8 dst[], const s8 src[],
+			      struct rv_jit_context *ctx,
+			      const u8 op)
+{
+	const s8 *tmp1 = bpf2rv32[TMP_REG_1];
+	const s8 *tmp2 = bpf2rv32[TMP_REG_2];
+	const s8 *rd = rv32_bpf_get_reg64(dst, tmp1, ctx);
+	const s8 *rs = rv32_bpf_get_reg64(src, tmp2, ctx);
+
+	switch (op) {
+	case BPF_MOV:
+		emit(rv_addi(lo(rd), lo(rs), 0), ctx);
+		emit(rv_addi(hi(rd), hi(rs), 0), ctx);
+		break;
+	case BPF_ADD:
+		emit(rv_addi(RV_REG_T0, lo(rd), 0), ctx);
+		emit(rv_add(lo(rd), lo(rd), lo(rs)), ctx);
+		emit(rv_sltu(RV_REG_T0, lo(rd), RV_REG_T0), ctx);
+		emit(rv_add(hi(rd), hi(rd), hi(rs)), ctx);
+		emit(rv_add(hi(rd), hi(rd), RV_REG_T0), ctx);
+		break;
+	case BPF_SUB:
+		emit(rv_sub(RV_REG_T1, hi(rd), hi(rs)), ctx);
+		emit(rv_sltu(RV_REG_T0, lo(rd), lo(rs)), ctx);
+		emit(rv_sub(hi(rd), RV_REG_T1, RV_REG_T0), ctx);
+		emit(rv_sub(lo(rd), lo(rd), lo(rs)), ctx);
+		break;
+	case BPF_AND:
+		emit(rv_and(lo(rd), lo(rd), lo(rs)), ctx);
+		emit(rv_and(hi(rd), hi(rd), hi(rs)), ctx);
+		break;
+	case BPF_OR:
+		emit(rv_or(lo(rd), lo(rd), lo(rs)), ctx);
+		emit(rv_or(hi(rd), hi(rd), hi(rs)), ctx);
+		break;
+	case BPF_XOR:
+		emit(rv_xor(lo(rd), lo(rd), lo(rs)), ctx);
+		emit(rv_xor(hi(rd), hi(rd), hi(rs)), ctx);
+		break;
+	case BPF_MUL:
+		emit(rv_mul(RV_REG_T0, hi(rs), lo(rd)), ctx);
+		emit(rv_mul(hi(rd), hi(rd), lo(rs)), ctx);
+		emit(rv_mulhu(RV_REG_T1, lo(rd), lo(rs)), ctx);
+		emit(rv_add(hi(rd), hi(rd), RV_REG_T0), ctx);
+		emit(rv_mul(lo(rd), lo(rd), lo(rs)), ctx);
+		emit(rv_add(hi(rd), hi(rd), RV_REG_T1), ctx);
+		break;
+	case BPF_LSH:
+		emit(rv_addi(RV_REG_T0, lo(rs), -32), ctx);
+		emit(rv_blt(RV_REG_T0, RV_REG_ZERO, 8), ctx);
+		emit(rv_sll(hi(rd), lo(rd), RV_REG_T0), ctx);
+		emit(rv_addi(lo(rd), RV_REG_ZERO, 0), ctx);
+		emit(rv_jal(RV_REG_ZERO, 16), ctx);
+		emit(rv_addi(RV_REG_T1, RV_REG_ZERO, 31), ctx);
+		emit(rv_srli(RV_REG_T0, lo(rd), 1), ctx);
+		emit(rv_sub(RV_REG_T1, RV_REG_T1, lo(rs)), ctx);
+		emit(rv_srl(RV_REG_T0, RV_REG_T0, RV_REG_T1), ctx);
+		emit(rv_sll(hi(rd), hi(rd), lo(rs)), ctx);
+		emit(rv_or(hi(rd), RV_REG_T0, hi(rd)), ctx);
+		emit(rv_sll(lo(rd), lo(rd), lo(rs)), ctx);
+		break;
+	case BPF_RSH:
+		emit(rv_addi(RV_REG_T0, lo(rs), -32), ctx);
+		emit(rv_blt(RV_REG_T0, RV_REG_ZERO, 8), ctx);
+		emit(rv_srl(lo(rd), hi(rd), RV_REG_T0), ctx);
+		emit(rv_addi(hi(rd), RV_REG_ZERO, 0), ctx);
+		emit(rv_jal(RV_REG_ZERO, 16), ctx);
+		emit(rv_addi(RV_REG_T1, RV_REG_ZERO, 31), ctx);
+		emit(rv_slli(RV_REG_T0, hi(rd), 1), ctx);
+		emit(rv_sub(RV_REG_T1, RV_REG_T1, lo(rs)), ctx);
+		emit(rv_sll(RV_REG_T0, RV_REG_T0, RV_REG_T1), ctx);
+		emit(rv_srl(lo(rd), lo(rd), lo(rs)), ctx);
+		emit(rv_or(lo(rd), RV_REG_T0, lo(rd)), ctx);
+		emit(rv_srl(hi(rd), hi(rd), lo(rs)), ctx);
+		break;
+	case BPF_ARSH:
+		emit(rv_addi(RV_REG_T0, lo(rs), -32), ctx);
+		emit(rv_blt(RV_REG_T0, RV_REG_ZERO, 8), ctx);
+		emit(rv_sra(lo(rd), hi(rd), RV_REG_T0), ctx);
+		emit(rv_srai(hi(rd), hi(rd), 31), ctx);
+		emit(rv_jal(RV_REG_ZERO, 16), ctx);
+		emit(rv_addi(RV_REG_T1, RV_REG_ZERO, 31), ctx);
+		emit(rv_slli(RV_REG_T0, hi(rd), 1), ctx);
+		emit(rv_sub(RV_REG_T1, RV_REG_T1, lo(rs)), ctx);
+		emit(rv_sll(RV_REG_T0, RV_REG_T0, RV_REG_T1), ctx);
+		emit(rv_srl(lo(rd), lo(rd), lo(rs)), ctx);
+		emit(rv_or(lo(rd), RV_REG_T0, lo(rd)), ctx);
+		emit(rv_sra(hi(rd), hi(rd), lo(rs)), ctx);
+		break;
+	case BPF_NEG:
+		emit(rv_sub(lo(rd), RV_REG_ZERO, lo(rd)), ctx);
+		emit(rv_sltu(RV_REG_T0, RV_REG_ZERO, lo(rd)), ctx);
+		emit(rv_sub(hi(rd), RV_REG_ZERO, hi(rd)), ctx);
+		emit(rv_sub(hi(rd), hi(rd), RV_REG_T0), ctx);
+		break;
+	}
+
+	rv32_bpf_put_reg64(dst, rd, ctx);
+}
+
+static void emit_rv32_alu_r32(const s8 dst[], const s8 src[],
+			      struct rv_jit_context *ctx,
+			      const u8 op)
+{
+	const s8 *tmp1 = bpf2rv32[TMP_REG_1];
+	const s8 *tmp2 = bpf2rv32[TMP_REG_2];
+	const s8 *rd = rv32_bpf_get_reg32(dst, tmp1, ctx);
+	const s8 *rs = rv32_bpf_get_reg32(src, tmp2, ctx);
+
+	switch (op) {
+	case BPF_MOV:
+		emit(rv_addi(lo(rd), lo(rs), 0), ctx);
+		break;
+	case BPF_ADD:
+		emit(rv_add(lo(rd), lo(rd), lo(rs)), ctx);
+		break;
+	case BPF_SUB:
+		emit(rv_sub(lo(rd), lo(rd), lo(rs)), ctx);
+		break;
+	case BPF_AND:
+		emit(rv_and(lo(rd), lo(rd), lo(rs)), ctx);
+		break;
+	case BPF_OR:
+		emit(rv_or(lo(rd), lo(rd), lo(rs)), ctx);
+		break;
+	case BPF_XOR:
+		emit(rv_xor(lo(rd), lo(rd), lo(rs)), ctx);
+		break;
+	case BPF_MUL:
+		emit(rv_mul(lo(rd), lo(rd), lo(rs)), ctx);
+		break;
+	case BPF_DIV:
+		emit(rv_divu(lo(rd), lo(rd), lo(rs)), ctx);
+		break;
+	case BPF_MOD:
+		emit(rv_remu(lo(rd), lo(rd), lo(rs)), ctx);
+		break;
+	case BPF_LSH:
+		emit(rv_sll(lo(rd), lo(rd), lo(rs)), ctx);
+		break;
+	case BPF_RSH:
+		emit(rv_srl(lo(rd), lo(rd), lo(rs)), ctx);
+		break;
+	case BPF_ARSH:
+		emit(rv_sra(lo(rd), lo(rd), lo(rs)), ctx);
+		break;
+	case BPF_NEG:
+		emit(rv_sub(lo(rd), RV_REG_ZERO, lo(rd)), ctx);
+		break;
+	}
+
+	rv32_bpf_put_reg32(dst, rd, ctx);
+}
+
+static int emit_rv32_branch_r64(const s8 src1[], const s8 src2[],
+				s32 rvoff,
+				struct rv_jit_context *ctx,
+				const u8 op)
+{
+	int e, s = ctx->ninsns;
+	const s8 *tmp1 = bpf2rv32[TMP_REG_1];
+	const s8 *tmp2 = bpf2rv32[TMP_REG_2];
+
+	const s8 *rs1 = rv32_bpf_get_reg64(src1, tmp1, ctx);
+	const s8 *rs2 = rv32_bpf_get_reg64(src2, tmp2, ctx);
+
+#define NO_JUMP(idx) (6 + (2*idx))
+#define JUMP(idx) (2 + (2*idx))
+
+	switch (op) {
+	case BPF_JEQ:
+		emit(rv_bne(hi(rs1), hi(rs2), NO_JUMP(1)), ctx);
+		emit(rv_bne(lo(rs1), lo(rs2), NO_JUMP(0)), ctx);
+		break;
+	case BPF_JGT:
+		emit(rv_bgtu(hi(rs1), hi(rs2), JUMP(2)), ctx);
+		emit(rv_bltu(hi(rs1), hi(rs2), NO_JUMP(1)), ctx);
+		emit(rv_bleu(lo(rs1), lo(rs2), NO_JUMP(0)), ctx);
+		break;
+	case BPF_JLT:
+		emit(rv_bltu(hi(rs1), hi(rs2), JUMP(2)), ctx);
+		emit(rv_bgtu(hi(rs1), hi(rs2), NO_JUMP(1)), ctx);
+		emit(rv_bgeu(lo(rs1), lo(rs2), NO_JUMP(0)), ctx);
+		break;
+	case BPF_JGE:
+		emit(rv_bgtu(hi(rs1), hi(rs2), JUMP(2)), ctx);
+		emit(rv_bltu(hi(rs1), hi(rs2), NO_JUMP(1)), ctx);
+		emit(rv_bltu(lo(rs1), lo(rs2), NO_JUMP(0)), ctx);
+		break;
+	case BPF_JLE:
+		emit(rv_bltu(hi(rs1), hi(rs2), JUMP(2)), ctx);
+		emit(rv_bgtu(hi(rs1), hi(rs2), NO_JUMP(1)), ctx);
+		emit(rv_bgtu(lo(rs1), lo(rs2), NO_JUMP(0)), ctx);
+		break;
+	case BPF_JNE:
+		emit(rv_bne(hi(rs1), hi(rs2), JUMP(1)), ctx);
+		emit(rv_beq(lo(rs1), lo(rs2), NO_JUMP(0)), ctx);
+		break;
+	case BPF_JSGT:
+		emit(rv_bgt(hi(rs1), hi(rs2), JUMP(2)), ctx);
+		emit(rv_blt(hi(rs1), hi(rs2), NO_JUMP(1)), ctx);
+		emit(rv_bleu(lo(rs1), lo(rs2), NO_JUMP(0)), ctx);
+		break;
+	case BPF_JSLT:
+		emit(rv_blt(hi(rs1), hi(rs2), JUMP(2)), ctx);
+		emit(rv_bgt(hi(rs1), hi(rs2), NO_JUMP(1)), ctx);
+		emit(rv_bgeu(lo(rs1), lo(rs2), NO_JUMP(0)), ctx);
+		break;
+	case BPF_JSGE:
+		emit(rv_bgt(hi(rs1), hi(rs2), JUMP(2)), ctx);
+		emit(rv_blt(hi(rs1), hi(rs2), NO_JUMP(1)), ctx);
+		emit(rv_bltu(lo(rs1), lo(rs2), NO_JUMP(0)), ctx);
+		break;
+	case BPF_JSLE:
+		emit(rv_blt(hi(rs1), hi(rs2), JUMP(2)), ctx);
+		emit(rv_bgt(hi(rs1), hi(rs2), NO_JUMP(1)), ctx);
+		emit(rv_bgtu(lo(rs1), lo(rs2), NO_JUMP(0)), ctx);
+		break;
+	case BPF_JSET:
+		emit(rv_and(RV_REG_T0, hi(rs1), hi(rs2)), ctx);
+		emit(rv_bne(RV_REG_T0, RV_REG_ZERO, JUMP(2)), ctx);
+		emit(rv_and(RV_REG_T0, lo(rs1), lo(rs2)), ctx);
+		emit(rv_beq(RV_REG_T0, RV_REG_ZERO, NO_JUMP(0)), ctx);
+		break;
+	}
+
+#undef NO_JUMP
+#undef JUMP
+
+	e = ctx->ninsns;
+	/* Adjust for extra insns. */
+	rvoff -= (e - s) << 2;
+	emit_jump_and_link(RV_REG_ZERO, rvoff, true, ctx);
+	return 0;
+}
+
+static int invert_bpf_cond(u8 cond)
+{
+	switch (cond) {
+	case BPF_JEQ:
+		return BPF_JNE;
+	case BPF_JGT:
+		return BPF_JLE;
+	case BPF_JLT:
+		return BPF_JGE;
+	case BPF_JGE:
+		return BPF_JLT;
+	case BPF_JLE:
+		return BPF_JGT;
+	case BPF_JNE:
+		return BPF_JEQ;
+	case BPF_JSGT:
+		return BPF_JSLE;
+	case BPF_JSLT:
+		return BPF_JSGE;
+	case BPF_JSGE:
+		return BPF_JSLT;
+	case BPF_JSLE:
+		return BPF_JSGT;
+	}
+	return -1;
+}
+
+static int emit_bcc(u8 op, u8 rd, u8 rs, int rvoff,
+		    struct rv_jit_context *ctx)
+{
+	int e, s = ctx->ninsns;
+	bool far = false;
+	int off;
+
+	if (op == BPF_JSET) {
+		/* BPF_JSET is a special case: it has no inverse so we
+		 * always treat it as a far branch.
+		 */
+		far = true;
+	} else if (!is_13b_int(rvoff)) {
+		op = invert_bpf_cond(op);
+		far = true;
+	}
+
+	off = far ? 6 : (rvoff >> 1);
+
+	switch (op) {
+	case BPF_JEQ:
+		emit(rv_beq(rd, rs, off), ctx);
+		break;
+	case BPF_JGT:
+		emit(rv_bgtu(rd, rs, off), ctx);
+		break;
+	case BPF_JLT:
+		emit(rv_bltu(rd, rs, off), ctx);
+		break;
+	case BPF_JGE:
+		emit(rv_bgeu(rd, rs, off), ctx);
+		break;
+	case BPF_JLE:
+		emit(rv_bleu(rd, rs, off), ctx);
+		break;
+	case BPF_JNE:
+		emit(rv_bne(rd, rs, off), ctx);
+		break;
+	case BPF_JSGT:
+		emit(rv_bgt(rd, rs, off), ctx);
+		break;
+	case BPF_JSLT:
+		emit(rv_blt(rd, rs, off), ctx);
+		break;
+	case BPF_JSGE:
+		emit(rv_bge(rd, rs, off), ctx);
+		break;
+	case BPF_JSLE:
+		emit(rv_ble(rd, rs, off), ctx);
+		break;
+	case BPF_JSET:
+		emit(rv_and(RV_REG_T0, rd, rs), ctx);
+		emit(rv_beq(RV_REG_T0, RV_REG_ZERO, 6), ctx);
+		break;
+	}
+
+	if (far) {
+		e = ctx->ninsns;
+		/* Adjust for extra insns. */
+		rvoff -= (e - s) << 2;
+		emit_jump_and_link(RV_REG_ZERO, rvoff, true, ctx);
+	}
+	return 0;
+
+}
+
+static int emit_rv32_branch_r32(const s8 src1[], const s8 src2[],
+				s32 rvoff,
+				struct rv_jit_context *ctx,
+				const u8 op)
+{
+	int e, s = ctx->ninsns;
+	const s8 *tmp1 = bpf2rv32[TMP_REG_1];
+	const s8 *tmp2 = bpf2rv32[TMP_REG_2];
+
+	const s8 *rs1 = rv32_bpf_get_reg32(src1, tmp1, ctx);
+	const s8 *rs2 = rv32_bpf_get_reg32(src2, tmp2, ctx);
+
+	e = ctx->ninsns;
+	/* Adjust for extra insns. */
+	rvoff -= (e - s) << 2;
+
+	if (emit_bcc(op, lo(rs1), lo(rs2), rvoff, ctx))
+		return -1;
+
+	return 0;
+}
+
+static int emit_call(bool fixed, u64 addr, struct rv_jit_context *ctx)
+{
+	const s8 *r0 = bpf2rv32[BPF_REG_0];
+	const s8 *r5 = bpf2rv32[BPF_REG_5];
+	u32 upper = ((u32)addr + (1 << 11)) >> 12;
+	u32 lower = addr & 0xfff;
+
+	/* R1-R4 already in correct reigsters---need to push R5 to stack. */
+	emit(rv_addi(RV_REG_SP, RV_REG_SP, -16), ctx);
+	emit(rv_sw(RV_REG_SP, 0, lo(r5)), ctx);
+	emit(rv_sw(RV_REG_SP, 4, hi(r5)), ctx);
+
+	/* Backup TCC. */
+	emit(rv_addi(RV_REG_TCC_SAVED, RV_REG_TCC, 0), ctx);
+
+	/* Use lui/jalr pair to jump to absolute address.
+	 * Don't use emit_imm as the number of emitted instructions
+	 * should not depend on the value of addr.
+	 */
+	emit(rv_lui(RV_REG_T1, upper), ctx);
+	emit(rv_jalr(RV_REG_RA, RV_REG_T1, lower), ctx);
+
+	/* Restore TCC. */
+	emit(rv_addi(RV_REG_TCC, RV_REG_TCC_SAVED, 0), ctx);
+
+	/* Set return value and restore stack. */
+	emit(rv_addi(lo(r0), RV_REG_A0, 0), ctx);
+	emit(rv_addi(hi(r0), RV_REG_A1, 0), ctx);
+	emit(rv_addi(RV_REG_SP, RV_REG_SP, 16), ctx);
+	return 0;
+}
+
+static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
+{
+	/* R1 -> &ctx
+	 * R2 -> &array
+	 * R3 -> index
+	 */
+	int tc_ninsn, off, start_insn = ctx->ninsns;
+	const s8 *arr_reg = bpf2rv32[BPF_REG_2];
+	const s8 *idx_reg = bpf2rv32[BPF_REG_3];
+
+	tc_ninsn = insn ? ctx->offset[insn] - ctx->offset[insn - 1] :
+		ctx->offset[0];
+
+	/* max_entries = array->map.max_entries; */
+	off = offsetof(struct bpf_array, map.max_entries);
+	if (!is_12b_int(off)) {
+		pr_err("bpf-jit: offset=%d not supported\n", off);
+		return -1;
+	}
+	emit(rv_lw(RV_REG_T1, off, lo(arr_reg)), ctx);
+
+	/* if (index >= max_entries)
+	 *   goto out;
+	 */
+	off = (tc_ninsn - (ctx->ninsns - start_insn)) << 2;
+	emit_bcc(BPF_JGE, lo(idx_reg), RV_REG_T1, off, ctx);
+
+	/* if ((temp_tcc = tcc - 1) < 0)
+	 *   goto out;
+	 */
+	emit(rv_addi(RV_REG_T1, RV_REG_TCC, -1), ctx);
+	off = (tc_ninsn - (ctx->ninsns - start_insn)) << 2;
+	emit_bcc(BPF_JSLT, RV_REG_T1, RV_REG_ZERO, off, ctx);
+
+	/* prog = array->ptrs[index];
+	 * if (!prog)
+	 *   goto out;
+	 */
+	emit(rv_slli(RV_REG_T0, lo(idx_reg), 2), ctx);
+	emit(rv_add(RV_REG_T0, RV_REG_T0, lo(arr_reg)), ctx);
+	off = offsetof(struct bpf_array, ptrs);
+	if (!is_12b_int(off)) {
+		pr_err("bpf-jit: offset=%d not supported\n", off);
+		return -1;
+	}
+	emit(rv_lw(RV_REG_T0, off, RV_REG_T0), ctx);
+	off = (tc_ninsn - (ctx->ninsns - start_insn)) << 2;
+	emit_bcc(BPF_JEQ, RV_REG_T0, RV_REG_ZERO, off, ctx);
+
+	/* tcc = temp_tcc;
+	 * goto *(prog->bpf_func + 4);
+	 */
+	off = offsetof(struct bpf_prog, bpf_func);
+	if (!is_12b_int(off)) {
+		pr_err("bpf-jit: offset=%d not supported\n", off);
+		return -1;
+	}
+	emit(rv_lw(RV_REG_T0, off, RV_REG_T0), ctx);
+	emit(rv_addi(RV_REG_TCC, RV_REG_T1, 0), ctx);
+	/* Epilogue jumps to *(t0 + 4) */
+	__build_epilogue(true, ctx);
+	return 0;
+}
+
+static int emit_rv32_load_r64(const s8 dst[], const s8 src[],
+			      s16 off,
+			      struct rv_jit_context *ctx,
+			      const u8 size)
+{
+	const s8 *tmp1 = bpf2rv32[TMP_REG_1];
+	const s8 *tmp2 = bpf2rv32[TMP_REG_2];
+	const s8 *rd = rv32_bpf_get_reg64(dst, tmp1, ctx);
+	const s8 *rs = rv32_bpf_get_reg64(src, tmp2, ctx);
+
+	emit_imm(RV_REG_T0, off, ctx);
+	emit(rv_add(RV_REG_T0, RV_REG_T0, lo(rs)), ctx);
+
+	switch (size) {
+	case BPF_B:
+		emit(rv_lbu(lo(rd), 0, RV_REG_T0), ctx);
+		if (!ctx->prog->aux->verifier_zext)
+			emit(rv_addi(hi(rd), RV_REG_ZERO, 0), ctx);
+		break;
+	case BPF_H:
+		emit(rv_lhu(lo(rd), 0, RV_REG_T0), ctx);
+		if (!ctx->prog->aux->verifier_zext)
+			emit(rv_addi(hi(rd), RV_REG_ZERO, 0), ctx);
+		break;
+	case BPF_W:
+		emit(rv_lw(lo(rd), 0, RV_REG_T0), ctx);
+		if (!ctx->prog->aux->verifier_zext)
+			emit(rv_addi(hi(rd), RV_REG_ZERO, 0), ctx);
+		break;
+	case BPF_DW:
+		emit(rv_lw(lo(rd), 0, RV_REG_T0), ctx);
+		emit(rv_lw(hi(rd), 4, RV_REG_T0), ctx);
+		break;
+	}
+
+	rv32_bpf_put_reg64(dst, rd, ctx);
+	return 0;
+}
+
+static int emit_rv32_store_r64(const s8 dst[], const s8 src[],
+			       s16 off,
+			       struct rv_jit_context *ctx,
+			       const u8 size, const u8 mode)
+{
+	const s8 *tmp1 = bpf2rv32[TMP_REG_1];
+	const s8 *tmp2 = bpf2rv32[TMP_REG_2];
+	const s8 *rd = rv32_bpf_get_reg64(dst, tmp1, ctx);
+	const s8 *rs = rv32_bpf_get_reg64(src, tmp2, ctx);
+
+	if (mode == BPF_XADD && size != BPF_W)
+		return -1;
+
+	emit_imm(RV_REG_T0, off, ctx);
+	emit(rv_add(RV_REG_T0, RV_REG_T0, lo(rd)), ctx);
+
+	switch (size) {
+	case BPF_B:
+		emit(rv_sb(RV_REG_T0, 0, lo(rs)), ctx);
+		break;
+	case BPF_H:
+		emit(rv_sh(RV_REG_T0, 0, lo(rs)), ctx);
+		break;
+	case BPF_W:
+		switch (mode) {
+		case BPF_MEM:
+			emit(rv_sw(RV_REG_T0, 0, lo(rs)), ctx);
+			break;
+		case BPF_XADD:
+			emit(rv_amoadd_w(RV_REG_ZERO, lo(rs), RV_REG_T0, 0, 0), ctx);
+			break;
+		}
+		break;
+	case BPF_DW:
+		emit(rv_sw(RV_REG_T0, 0, lo(rs)), ctx);
+		emit(rv_sw(RV_REG_T0, 4, hi(rs)), ctx);
+		break;
+	}
+
+	return 0;
+}
+
+static void emit_rv32_rev16(const s8 rd, struct rv_jit_context *ctx)
+{
+	emit(rv_slli(rd, rd, 16), ctx);
+	emit(rv_slli(RV_REG_T1, rd, 8), ctx);
+	emit(rv_srli(rd, rd, 8), ctx);
+	emit(rv_add(RV_REG_T1, rd, RV_REG_T1), ctx);
+	emit(rv_srli(rd, RV_REG_T1, 16), ctx);
+}
+
+static void emit_rv32_rev32(const s8 rd, struct rv_jit_context *ctx)
+{
+	emit(rv_addi(RV_REG_T1, RV_REG_ZERO, 0), ctx);
+	emit(rv_andi(RV_REG_T0, rd, 255), ctx);
+	emit(rv_add(RV_REG_T1, RV_REG_T1, RV_REG_T0), ctx);
+	emit(rv_slli(RV_REG_T1, RV_REG_T1, 8), ctx);
+	emit(rv_srli(rd, rd, 8), ctx);
+	emit(rv_andi(RV_REG_T0, rd, 255), ctx);
+	emit(rv_add(RV_REG_T1, RV_REG_T1, RV_REG_T0), ctx);
+	emit(rv_slli(RV_REG_T1, RV_REG_T1, 8), ctx);
+	emit(rv_srli(rd, rd, 8), ctx);
+	emit(rv_andi(RV_REG_T0, rd, 255), ctx);
+	emit(rv_add(RV_REG_T1, RV_REG_T1, RV_REG_T0), ctx);
+	emit(rv_slli(RV_REG_T1, RV_REG_T1, 8), ctx);
+	emit(rv_srli(rd, rd, 8), ctx);
+	emit(rv_andi(RV_REG_T0, rd, 255), ctx);
+	emit(rv_add(RV_REG_T1, RV_REG_T1, RV_REG_T0), ctx);
+	emit(rv_addi(rd, RV_REG_T1, 0), ctx);
+}
+
+static void emit_rv32_zext64(const s8 *dst, struct rv_jit_context *ctx)
+{
+	const s8 *rd;
+	const s8 *tmp1 = bpf2rv32[TMP_REG_1];
+
+	rd = rv32_bpf_get_reg64(dst, tmp1, ctx);
+	emit(rv_addi(hi(rd), RV_REG_ZERO, 0), ctx);
+	rv32_bpf_put_reg64(dst, rd, ctx);
+}
+
+static int emit_insn(const struct bpf_insn *insn,
+		     struct rv_jit_context *ctx,
+		     bool extra_pass)
+{
+	bool is64 = BPF_CLASS(insn->code) == BPF_ALU64 ||
+		BPF_CLASS(insn->code) == BPF_JMP;
+	int s, e, rvoff, i = insn - ctx->prog->insnsi;
+	u8 code = insn->code;
+	s16 off = insn->off;
+	s32 imm = insn->imm;
+
+	const s8 *dst = bpf2rv32[insn->dst_reg];
+	const s8 *src = bpf2rv32[insn->src_reg];
+	const s8 *tmp1 = bpf2rv32[TMP_REG_1];
+	const s8 *tmp2 = bpf2rv32[TMP_REG_2];
+
+	switch (code) {
+	case BPF_ALU64 | BPF_MOV | BPF_X:
+
+	case BPF_ALU64 | BPF_ADD | BPF_X:
+	case BPF_ALU64 | BPF_ADD | BPF_K:
+
+	case BPF_ALU64 | BPF_SUB | BPF_X:
+	case BPF_ALU64 | BPF_SUB | BPF_K:
+
+	case BPF_ALU64 | BPF_AND | BPF_X:
+	case BPF_ALU64 | BPF_OR | BPF_X:
+	case BPF_ALU64 | BPF_XOR | BPF_X:
+
+	case BPF_ALU64 | BPF_MUL | BPF_X:
+	case BPF_ALU64 | BPF_MUL | BPF_K:
+
+	case BPF_ALU64 | BPF_LSH | BPF_X:
+	case BPF_ALU64 | BPF_RSH | BPF_X:
+	case BPF_ALU64 | BPF_ARSH | BPF_X:
+		if (BPF_SRC(code) == BPF_K) {
+			emit_imm32(tmp2, imm, ctx);
+			src = tmp2;
+		}
+		emit_rv32_alu_r64(dst, src, ctx, BPF_OP(code));
+		break;
+
+	case BPF_ALU64 | BPF_NEG:
+		emit_rv32_alu_r64(dst, tmp2, ctx, BPF_OP(code));
+		break;
+
+	case BPF_ALU64 | BPF_DIV | BPF_X:
+	case BPF_ALU64 | BPF_DIV | BPF_K:
+	case BPF_ALU64 | BPF_MOD | BPF_X:
+	case BPF_ALU64 | BPF_MOD | BPF_K:
+		goto notsupported;
+
+	case BPF_ALU64 | BPF_MOV | BPF_K:
+	case BPF_ALU64 | BPF_AND | BPF_K:
+	case BPF_ALU64 | BPF_OR | BPF_K:
+	case BPF_ALU64 | BPF_XOR | BPF_K:
+	case BPF_ALU64 | BPF_LSH | BPF_K:
+	case BPF_ALU64 | BPF_RSH | BPF_K:
+	case BPF_ALU64 | BPF_ARSH | BPF_K:
+		emit_rv32_alu_i64(dst, imm, ctx, BPF_OP(code));
+		break;
+
+	case BPF_ALU | BPF_MOV | BPF_X:
+		if (imm == 1) {
+			/* Special mov32 for zext */
+			emit_rv32_zext64(dst, ctx);
+			break;
+		}
+		/* fallthrough */
+
+	case BPF_ALU | BPF_ADD | BPF_X:
+	case BPF_ALU | BPF_SUB | BPF_X:
+	case BPF_ALU | BPF_AND | BPF_X:
+	case BPF_ALU | BPF_OR | BPF_X:
+	case BPF_ALU | BPF_XOR | BPF_X:
+
+	case BPF_ALU | BPF_MUL | BPF_X:
+	case BPF_ALU | BPF_MUL | BPF_K:
+
+	case BPF_ALU | BPF_DIV | BPF_X:
+	case BPF_ALU | BPF_DIV | BPF_K:
+
+	case BPF_ALU | BPF_MOD | BPF_X:
+	case BPF_ALU | BPF_MOD | BPF_K:
+
+	case BPF_ALU | BPF_LSH | BPF_X:
+	case BPF_ALU | BPF_RSH | BPF_X:
+	case BPF_ALU | BPF_ARSH | BPF_X:
+		if (BPF_SRC(code) == BPF_K) {
+			emit_imm32(tmp2, imm, ctx);
+			src = tmp2;
+		}
+		emit_rv32_alu_r32(dst, src, ctx, BPF_OP(code));
+		break;
+
+	case BPF_ALU | BPF_MOV | BPF_K:
+	case BPF_ALU | BPF_ADD | BPF_K:
+	case BPF_ALU | BPF_SUB | BPF_K:
+	case BPF_ALU | BPF_AND | BPF_K:
+	case BPF_ALU | BPF_OR | BPF_K:
+	case BPF_ALU | BPF_XOR | BPF_K:
+	case BPF_ALU | BPF_LSH | BPF_K:
+	case BPF_ALU | BPF_RSH | BPF_K:
+	case BPF_ALU | BPF_ARSH | BPF_K:
+		/* mul,div,mod are handled in the BPF_X case
+		 * since there are no RISC-V equivalents.
+		 */
+		emit_rv32_alu_i32(dst, imm, ctx, BPF_OP(code));
+		break;
+
+	case BPF_ALU | BPF_NEG:
+		/* src is ignored---choose tmp2 as a dummy register
+		 * since it is not on the stack.
+		 */
+		emit_rv32_alu_r32(dst, tmp2, ctx, BPF_OP(code));
+		break;
+
+	case BPF_ALU | BPF_END | BPF_FROM_LE:
+	{
+		const s8 *rd = rv32_bpf_get_reg64(dst, tmp1, ctx);
+
+		switch (imm) {
+		case 16:
+			emit(rv_slli(lo(rd), lo(rd), 16), ctx);
+			emit(rv_srli(lo(rd), lo(rd), 16), ctx);
+			/* fallthrough */
+		case 32:
+			if (!ctx->prog->aux->verifier_zext)
+				emit(rv_addi(hi(rd), RV_REG_ZERO, 0), ctx);
+			break;
+		case 64:
+			/* Do nothing. */
+			break;
+		default:
+			pr_err("bpf-jit: BPF_END imm %d invalid\n", imm);
+			return -1;
+		}
+
+		rv32_bpf_put_reg64(dst, rd, ctx);
+		break;
+	}
+
+	case BPF_ALU | BPF_END | BPF_FROM_BE:
+	{
+		const s8 *rd = rv32_bpf_get_reg64(dst, tmp1, ctx);
+
+		switch (imm) {
+		case 16:
+			emit_rv32_rev16(lo(rd), ctx);
+			if (!ctx->prog->aux->verifier_zext)
+				emit(rv_addi(hi(rd), RV_REG_ZERO, 0), ctx);
+			break;
+		case 32:
+			emit_rv32_rev32(lo(rd), ctx);
+			if (!ctx->prog->aux->verifier_zext)
+				emit(rv_addi(hi(rd), RV_REG_ZERO, 0), ctx);
+			break;
+		case 64:
+			/* Swap upper and lower halves. */
+			emit(rv_addi(RV_REG_T0, lo(rd), 0), ctx);
+			emit(rv_addi(lo(rd), hi(rd), 0), ctx);
+			emit(rv_addi(hi(rd), RV_REG_T0, 0), ctx);
+
+			/* Swap each half. */
+			emit_rv32_rev32(lo(rd), ctx);
+			emit_rv32_rev32(hi(rd), ctx);
+			break;
+		default:
+			pr_err("bpf-jit: BPF_END imm %d invalid\n", imm);
+			return -1;
+		}
+
+		rv32_bpf_put_reg64(dst, rd, ctx);
+		break;
+	}
+
+	case BPF_JMP | BPF_JA:
+		rvoff = rv_offset(i, off, ctx);
+		emit_jump_and_link(RV_REG_ZERO, rvoff, false, ctx);
+		break;
+
+	case BPF_JMP | BPF_CALL:
+	{
+		bool fixed;
+		int ret;
+		u64 addr;
+
+		ret = bpf_jit_get_func_addr(ctx->prog, insn, extra_pass, &addr,
+					    &fixed);
+		if (ret < 0)
+			return ret;
+		ret = emit_call(fixed, addr, ctx);
+		if (ret)
+			return ret;
+		break;
+	}
+
+	case BPF_JMP | BPF_TAIL_CALL:
+		if (emit_bpf_tail_call(i, ctx))
+			return -1;
+		break;
+
+	case BPF_JMP | BPF_JEQ | BPF_X:
+	case BPF_JMP | BPF_JEQ | BPF_K:
+	case BPF_JMP32 | BPF_JEQ | BPF_X:
+	case BPF_JMP32 | BPF_JEQ | BPF_K:
+
+	case BPF_JMP | BPF_JNE | BPF_X:
+	case BPF_JMP | BPF_JNE | BPF_K:
+	case BPF_JMP32 | BPF_JNE | BPF_X:
+	case BPF_JMP32 | BPF_JNE | BPF_K:
+
+	case BPF_JMP | BPF_JLE | BPF_X:
+	case BPF_JMP | BPF_JLE | BPF_K:
+	case BPF_JMP32 | BPF_JLE | BPF_X:
+	case BPF_JMP32 | BPF_JLE | BPF_K:
+
+	case BPF_JMP | BPF_JLT | BPF_X:
+	case BPF_JMP | BPF_JLT | BPF_K:
+	case BPF_JMP32 | BPF_JLT | BPF_X:
+	case BPF_JMP32 | BPF_JLT | BPF_K:
+
+	case BPF_JMP | BPF_JGE | BPF_X:
+	case BPF_JMP | BPF_JGE | BPF_K:
+	case BPF_JMP32 | BPF_JGE | BPF_X:
+	case BPF_JMP32 | BPF_JGE | BPF_K:
+
+	case BPF_JMP | BPF_JGT | BPF_X:
+	case BPF_JMP | BPF_JGT | BPF_K:
+	case BPF_JMP32 | BPF_JGT | BPF_X:
+	case BPF_JMP32 | BPF_JGT | BPF_K:
+
+	case BPF_JMP | BPF_JSLE | BPF_X:
+	case BPF_JMP | BPF_JSLE | BPF_K:
+	case BPF_JMP32 | BPF_JSLE | BPF_X:
+	case BPF_JMP32 | BPF_JSLE | BPF_K:
+
+	case BPF_JMP | BPF_JSLT | BPF_X:
+	case BPF_JMP | BPF_JSLT | BPF_K:
+	case BPF_JMP32 | BPF_JSLT | BPF_X:
+	case BPF_JMP32 | BPF_JSLT | BPF_K:
+
+	case BPF_JMP | BPF_JSGE | BPF_X:
+	case BPF_JMP | BPF_JSGE | BPF_K:
+	case BPF_JMP32 | BPF_JSGE | BPF_X:
+	case BPF_JMP32 | BPF_JSGE | BPF_K:
+
+	case BPF_JMP | BPF_JSGT | BPF_X:
+	case BPF_JMP | BPF_JSGT | BPF_K:
+	case BPF_JMP32 | BPF_JSGT | BPF_X:
+	case BPF_JMP32 | BPF_JSGT | BPF_K:
+
+	case BPF_JMP | BPF_JSET | BPF_X:
+	case BPF_JMP | BPF_JSET | BPF_K:
+	case BPF_JMP32 | BPF_JSET | BPF_X:
+	case BPF_JMP32 | BPF_JSET | BPF_K:
+		rvoff = rv_offset(i, off, ctx);
+		if (BPF_SRC(code) == BPF_K) {
+			s = ctx->ninsns;
+			emit_imm32(tmp2, imm, ctx);
+			src = tmp2;
+			e = ctx->ninsns;
+			rvoff -= (e - s) << 2;
+		}
+
+		if (is64) {
+			emit_rv32_branch_r64(dst, src, rvoff, ctx, BPF_OP(code));
+		} else {
+			emit_rv32_branch_r32(dst, src, rvoff, ctx, BPF_OP(code));
+		}
+		break;
+
+	case BPF_JMP | BPF_EXIT:
+		if (i == ctx->prog->len - 1)
+			break;
+
+		rvoff = epilogue_offset(ctx);
+		emit_jump_and_link(RV_REG_ZERO, rvoff, false, ctx);
+		break;
+
+	case BPF_LD | BPF_IMM | BPF_DW:
+	{
+		struct bpf_insn insn1 = insn[1];
+		s32 imm_lo = imm;
+		s32 imm_hi = insn1.imm;
+		const s8 *rd = rv32_bpf_get_reg64(dst, tmp1, ctx);
+
+		emit_imm64(rd, imm_hi, imm_lo, ctx);
+		rv32_bpf_put_reg64(dst, rd, ctx);
+		return 1;
+	}
+
+	case BPF_LDX | BPF_MEM | BPF_B:
+	case BPF_LDX | BPF_MEM | BPF_H:
+	case BPF_LDX | BPF_MEM | BPF_W:
+	case BPF_LDX | BPF_MEM | BPF_DW:
+		if (emit_rv32_load_r64(dst, src, off, ctx, BPF_SIZE(code)))
+			return -1;
+		break;
+
+	case BPF_ST | BPF_MEM | BPF_B:
+	case BPF_ST | BPF_MEM | BPF_H:
+	case BPF_ST | BPF_MEM | BPF_W:
+	case BPF_ST | BPF_MEM | BPF_DW:
+
+	case BPF_STX | BPF_MEM | BPF_B:
+	case BPF_STX | BPF_MEM | BPF_H:
+	case BPF_STX | BPF_MEM | BPF_W:
+	case BPF_STX | BPF_MEM | BPF_DW:
+	case BPF_STX | BPF_XADD | BPF_W:
+		if (BPF_CLASS(code) == BPF_ST) {
+			emit_imm32(tmp2, imm, ctx);
+			src = tmp2;
+		}
+
+		if (emit_rv32_store_r64(dst, src, off, ctx, BPF_SIZE(code), BPF_MODE(code)))
+			return -1;
+		break;
+
+	case BPF_STX | BPF_XADD | BPF_DW:
+		goto notsupported;
+
+notsupported:
+		pr_info_once("*** NOT SUPPORTED: opcode %02x ***\n", code);
+		return -EFAULT;
+
+	default:
+		pr_err("bpf-jit: unknown opcode %02x\n", code);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void build_prologue(struct rv_jit_context *ctx)
+{
+	int stack_adjust = 4 * 9, store_offset, bpf_stack_adjust;
+
+	bpf_stack_adjust = round_up(ctx->prog->aux->stack_depth, 16);
+	stack_adjust += bpf_stack_adjust;
+
+	store_offset = stack_adjust - 4;
+
+	stack_adjust += 4 * BPF_JIT_SCRATCH_REGS;
+
+	/* First instruction sets tail-call-counter,
+	 * skipped by tail call.
+	 */
+	emit(rv_addi(RV_REG_TCC, RV_REG_ZERO, MAX_TAIL_CALL_CNT), ctx);
+
+	emit(rv_addi(RV_REG_SP, RV_REG_SP, -stack_adjust), ctx);
+
+	/* Save callee-save registers. */
+	emit(rv_sw(RV_REG_SP, store_offset - 0, RV_REG_RA), ctx);
+	emit(rv_sw(RV_REG_SP, store_offset - 4, RV_REG_FP), ctx);
+	emit(rv_sw(RV_REG_SP, store_offset - 8, RV_REG_S1), ctx);
+	emit(rv_sw(RV_REG_SP, store_offset - 12, RV_REG_S2), ctx);
+	emit(rv_sw(RV_REG_SP, store_offset - 16, RV_REG_S3), ctx);
+	emit(rv_sw(RV_REG_SP, store_offset - 20, RV_REG_S4), ctx);
+	emit(rv_sw(RV_REG_SP, store_offset - 24, RV_REG_S5), ctx);
+	emit(rv_sw(RV_REG_SP, store_offset - 28, RV_REG_S6), ctx);
+	emit(rv_sw(RV_REG_SP, store_offset - 32, RV_REG_S7), ctx);
+
+	/* Set fp: used as the base address for stacked BPF registers. */
+	emit(rv_addi(RV_REG_FP, RV_REG_SP, stack_adjust), ctx);
+
+	/* Set up BPF stack pointer. */
+	emit(rv_addi(lo(bpf2rv32[BPF_REG_FP]), RV_REG_SP, bpf_stack_adjust), ctx);
+	emit(rv_addi(hi(bpf2rv32[BPF_REG_FP]), RV_REG_ZERO, 0), ctx);
+
+	/* Set up context pointer. */
+	emit(rv_addi(lo(bpf2rv32[BPF_REG_1]), RV_REG_A0, 0), ctx);
+	emit(rv_addi(hi(bpf2rv32[BPF_REG_1]), RV_REG_ZERO, 0), ctx);
+
+	ctx->stack_size = stack_adjust;
+}
+
+static int build_body(struct rv_jit_context *ctx, bool extra_pass, int *offset)
+{
+	const struct bpf_prog *prog = ctx->prog;
+	int i;
+
+	for (i = 0; i < prog->len; i++) {
+		const struct bpf_insn *insn = &prog->insnsi[i];
+		int ret;
+
+		ret = emit_insn(insn, ctx, extra_pass);
+		if (ret > 0)
+			/* BPF_LD | BPF_IMM | BPF_DW:
+			 * Skip next instruction.
+			 */
+			i++;
+		if (offset)
+			offset[i] = ctx->ninsns;
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
+}
+
+static void bpf_fill_ill_insns(void *area, unsigned int size)
+{
+	memset(area, 0, size);
+}
+
+static void bpf_flush_icache(void *start, void *end)
+{
+	flush_icache_range((unsigned long)start, (unsigned long)end);
+}
+
+bool bpf_jit_needs_zext(void)
+{
+	return true;
+}
+
+struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
+{
+	bool tmp_blinded = false, extra_pass = false;
+	struct bpf_prog *tmp, *orig_prog = prog;
+	int pass = 0, prev_ninsns = 0, i;
+	struct rv_jit_data *jit_data;
+	struct rv_jit_context *ctx;
+	unsigned int image_size = 0;
+
+	if (!prog->jit_requested)
+		return orig_prog;
+
+	tmp = bpf_jit_blind_constants(prog);
+	if (IS_ERR(tmp))
+		return orig_prog;
+	if (tmp != prog) {
+		tmp_blinded = true;
+		prog = tmp;
+	}
+
+	jit_data = prog->aux->jit_data;
+	if (!jit_data) {
+		jit_data = kzalloc(sizeof(*jit_data), GFP_KERNEL);
+		if (!jit_data) {
+			prog = orig_prog;
+			goto out;
+		}
+		prog->aux->jit_data = jit_data;
+	}
+
+	ctx = &jit_data->ctx;
+
+	if (ctx->offset) {
+		extra_pass = true;
+		image_size = sizeof(u32) * ctx->ninsns;
+		goto skip_init_ctx;
+	}
+
+	ctx->prog = prog;
+	ctx->offset = kcalloc(prog->len, sizeof(int), GFP_KERNEL);
+	if (!ctx->offset) {
+		prog = orig_prog;
+		goto out_offset;
+	}
+	for (i = 0; i < prog->len; i++) {
+		prev_ninsns += 32;
+		ctx->offset[i] = prev_ninsns;
+	}
+
+	for (i = 0; i < NR_JIT_ITERATIONS; i++) {
+		pass++;
+		ctx->ninsns = 0;
+		if (build_body(ctx, extra_pass, ctx->offset)) {
+			prog = orig_prog;
+			goto out_offset;
+		}
+		build_prologue(ctx);
+		ctx->epilogue_offset = ctx->ninsns;
+		build_epilogue(ctx);
+
+		if (ctx->ninsns == prev_ninsns) {
+			if (jit_data->header)
+				break;
+
+			image_size = sizeof(u32) * ctx->ninsns;
+			jit_data->header =
+				bpf_jit_binary_alloc(image_size,
+						     &jit_data->image,
+						     sizeof(u32),
+						     bpf_fill_ill_insns);
+			if (!jit_data->header) {
+				prog = orig_prog;
+				goto out_offset;
+			}
+
+			ctx->insns = (u32 *)jit_data->image;
+		}
+		prev_ninsns = ctx->ninsns;
+	}
+
+	if (i == NR_JIT_ITERATIONS) {
+		pr_err("bpf-jit: image did not converge in <%d passes!\n", i);
+		bpf_jit_binary_free(jit_data->header);
+		prog = orig_prog;
+		goto out_offset;
+	}
+
+skip_init_ctx:
+	pass++;
+	ctx->ninsns = 0;
+
+	build_prologue(ctx);
+	if (build_body(ctx, extra_pass, NULL)) {
+		bpf_jit_binary_free(jit_data->header);
+		prog = orig_prog;
+		goto out_offset;
+	}
+	build_epilogue(ctx);
+
+	if (bpf_jit_enable > 1)
+		bpf_jit_dump(prog->len, image_size, 2, ctx->insns);
+
+	prog->bpf_func = (void *)ctx->insns;
+	prog->jited = 1;
+	prog->jited_len = image_size;
+
+	bpf_flush_icache(jit_data->header, ctx->insns + ctx->ninsns);
+
+	if (!prog->is_func || extra_pass) {
+out_offset:
+		kfree(ctx->offset);
+		kfree(jit_data);
+		prog->aux->jit_data = NULL;
+	}
+out:
+
+	if (tmp_blinded)
+		bpf_jit_prog_release_other(prog, prog == orig_prog ?
+					   tmp : orig_prog);
+	return prog;
+}
-- 
2.20.1

