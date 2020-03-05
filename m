Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADDF1179ED5
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 06:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbgCEFCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 00:02:20 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42940 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgCEFCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 00:02:20 -0500
Received: by mail-pf1-f195.google.com with SMTP id f5so2147841pfk.9
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 21:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F6xpWJNnviYx0UXiufCowhh03LwABxA+pXEEfc9R5RE=;
        b=EoW/rZKrpqiQ8IpaU03NKmhe5xIKgB4WRhdxJbguJbvdWj7jY0ryml+MHJWsOiddHT
         qM8iN3UkaPIPXJyrJ043THt3tMDRLIivxCPcaDYBL2hNhb5ztR6klvlBtiYH2DQyGwhj
         nliveVLDE4rTVRr62jdpVMN6LvprUyAKxDc1A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F6xpWJNnviYx0UXiufCowhh03LwABxA+pXEEfc9R5RE=;
        b=O5dGQz7WLNzCMqXsMcu+XamTwZjQd667urp/+n918BwiSFisnyemi3etwesI8jCVtb
         GcTOIJOS1KdEGnz9oMfpC57vFyvE/5adV7ulb7DXFvIl7syetEnvmoMeRAL2inndZPfi
         iNBmNmcBZefPy0hlGOjB7A33k4ikA64Xo4doaNiS+e/2gybFTleL+Me+XsS1Fxf4c3Fv
         mTlO8IMb9dBQ7PYAt95+ZJqSA4k+qGGW6DsSpR/+BXhAEM5wrdnbAldrO1chL7fdpOP5
         VN0ZL2JWFcePvfX0oydCEcBJSJ/FzAJ/mBFeagRX8Mat07hM8cFKgQDEoMAM62PE2pt/
         wBcg==
X-Gm-Message-State: ANhLgQ1zwgnUhnqh+cf3xiCfO0GFTVXEUNXGqiZSf7q25fu9Lb8+9Z2T
        e6D2QQ/JKgOZdeW8w9yD8s679g==
X-Google-Smtp-Source: ADFU+vsHA0frR6iRl6MgoKMNb4yR7jkavunG04ogNwOu3NEiE6yGiFHJ9doeFV+6+MoKZxIsIOPafw==
X-Received: by 2002:a62:1456:: with SMTP id 83mr5100200pfu.237.1583384537809;
        Wed, 04 Mar 2020 21:02:17 -0800 (PST)
Received: from ryzen.cs.washington.edu ([2607:4000:200:11:e9fe:faad:3d84:58ea])
        by smtp.gmail.com with ESMTPSA id y7sm17820466pfq.15.2020.03.04.21.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 21:02:17 -0800 (PST)
From:   Luke Nelson <lukenels@cs.washington.edu>
X-Google-Original-From: Luke Nelson <luke.r.nels@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Luke Nelson <luke.r.nels@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: [PATCH bpf-next v5 1/4] riscv, bpf: factor common RISC-V JIT code
Date:   Wed,  4 Mar 2020 21:02:04 -0800
Message-Id: <20200305050207.4159-2-luke.r.nels@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305050207.4159-1-luke.r.nels@gmail.com>
References: <20200305050207.4159-1-luke.r.nels@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch factors out code that can be used by both the RV64 and RV32
BPF JITs to a common bpf_jit.h and bpf_jit_core.c.

Move struct definitions and macro-like functions to header. Rename
rv_sb_insn/rv_uj_insn to rv_b_insn/rv_j_insn to match the RISC-V
specification.

Move reusable functions emit_body() and bpf_int_jit_compile() to
bpf_jit_core.c with minor simplifications. Rename emit_insn() and
build_{prologue,epilogue}() to be prefixed with "bpf_jit_" as they are
no longer static.

Rename bpf_jit_comp.c to bpf_jit_comp64.c to be more explicit.

Co-developed-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
---
 arch/riscv/net/Makefile                       |   3 +-
 arch/riscv/net/bpf_jit.h                      | 466 ++++++++++++++
 .../net/{bpf_jit_comp.c => bpf_jit_comp64.c}  | 605 +-----------------
 arch/riscv/net/bpf_jit_core.c                 | 166 +++++
 4 files changed, 639 insertions(+), 601 deletions(-)
 create mode 100644 arch/riscv/net/bpf_jit.h
 rename arch/riscv/net/{bpf_jit_comp.c => bpf_jit_comp64.c} (69%)
 create mode 100644 arch/riscv/net/bpf_jit_core.c

diff --git a/arch/riscv/net/Makefile b/arch/riscv/net/Makefile
index ec5b14763316..018074dbf986 100644
--- a/arch/riscv/net/Makefile
+++ b/arch/riscv/net/Makefile
@@ -1,2 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_BPF_JIT) += bpf_jit_comp.o
+
+obj-$(CONFIG_BPF_JIT) += bpf_jit_core.o bpf_jit_comp64.o
diff --git a/arch/riscv/net/bpf_jit.h b/arch/riscv/net/bpf_jit.h
new file mode 100644
index 000000000000..23c123331f94
--- /dev/null
+++ b/arch/riscv/net/bpf_jit.h
@@ -0,0 +1,466 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Common functionality for RV32 and RV64 BPF JIT compilers
+ *
+ * Copyright (c) 2019 Björn Töpel <bjorn.topel@gmail.com>
+ *
+ */
+
+#ifndef _BPF_JIT_H
+#define _BPF_JIT_H
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
+	RV_REG_FP =	8,	/* Saved register/frame pointer */
+	RV_REG_S1 =	9,	/* Saved register */
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
+struct rv_jit_context {
+	struct bpf_prog *prog;
+	u32 *insns;		/* RV insns */
+	int ninsns;
+	int epilogue_offset;
+	int *offset;		/* BPF to RV */
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
+static inline void bpf_fill_ill_insns(void *area, unsigned int size)
+{
+	memset(area, 0, size);
+}
+
+static inline void bpf_flush_icache(void *start, void *end)
+{
+	flush_icache_range((unsigned long)start, (unsigned long)end);
+}
+
+static inline void emit(const u32 insn, struct rv_jit_context *ctx)
+{
+	if (ctx->insns)
+		ctx->insns[ctx->ninsns] = insn;
+
+	ctx->ninsns++;
+}
+
+static inline int epilogue_offset(struct rv_jit_context *ctx)
+{
+	int to = ctx->epilogue_offset, from = ctx->ninsns;
+
+	return (to - from) << 2;
+}
+
+/* Return -1 or inverted cond. */
+static inline int invert_bpf_cond(u8 cond)
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
+static inline bool is_12b_int(long val)
+{
+	return -(1L << 11) <= val && val < (1L << 11);
+}
+
+static inline int is_12b_check(int off, int insn)
+{
+	if (!is_12b_int(off)) {
+		pr_err("bpf-jit: insn=%d 12b < offset=%d not supported yet!\n",
+		       insn, (int)off);
+		return -1;
+	}
+	return 0;
+}
+
+static inline bool is_13b_int(long val)
+{
+	return -(1L << 12) <= val && val < (1L << 12);
+}
+
+static inline bool is_21b_int(long val)
+{
+	return -(1L << 20) <= val && val < (1L << 20);
+}
+
+static inline int rv_offset(int insn, int off, struct rv_jit_context *ctx)
+{
+	int from, to;
+
+	off++; /* BPF branch is from PC+1, RV is from PC */
+	from = (insn > 0) ? ctx->offset[insn - 1] : 0;
+	to = (insn + off > 0) ? ctx->offset[insn + off - 1] : 0;
+	return (to - from) << 2;
+}
+
+/* Instruction formats. */
+
+static inline u32 rv_r_insn(u8 funct7, u8 rs2, u8 rs1, u8 funct3, u8 rd,
+			    u8 opcode)
+{
+	return (funct7 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) |
+		(rd << 7) | opcode;
+}
+
+static inline u32 rv_i_insn(u16 imm11_0, u8 rs1, u8 funct3, u8 rd, u8 opcode)
+{
+	return (imm11_0 << 20) | (rs1 << 15) | (funct3 << 12) | (rd << 7) |
+		opcode;
+}
+
+static inline u32 rv_s_insn(u16 imm11_0, u8 rs2, u8 rs1, u8 funct3, u8 opcode)
+{
+	u8 imm11_5 = imm11_0 >> 5, imm4_0 = imm11_0 & 0x1f;
+
+	return (imm11_5 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) |
+		(imm4_0 << 7) | opcode;
+}
+
+static inline u32 rv_b_insn(u16 imm12_1, u8 rs2, u8 rs1, u8 funct3, u8 opcode)
+{
+	u8 imm12 = ((imm12_1 & 0x800) >> 5) | ((imm12_1 & 0x3f0) >> 4);
+	u8 imm4_1 = ((imm12_1 & 0xf) << 1) | ((imm12_1 & 0x400) >> 10);
+
+	return (imm12 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) |
+		(imm4_1 << 7) | opcode;
+}
+
+static inline u32 rv_u_insn(u32 imm31_12, u8 rd, u8 opcode)
+{
+	return (imm31_12 << 12) | (rd << 7) | opcode;
+}
+
+static inline u32 rv_j_insn(u32 imm20_1, u8 rd, u8 opcode)
+{
+	u32 imm;
+
+	imm = (imm20_1 & 0x80000) | ((imm20_1 & 0x3ff) << 9) |
+		((imm20_1 & 0x400) >> 2) | ((imm20_1 & 0x7f800) >> 11);
+
+	return (imm << 12) | (rd << 7) | opcode;
+}
+
+static inline u32 rv_amo_insn(u8 funct5, u8 aq, u8 rl, u8 rs2, u8 rs1,
+			      u8 funct3, u8 rd, u8 opcode)
+{
+	u8 funct7 = (funct5 << 2) | (aq << 1) | rl;
+
+	return rv_r_insn(funct7, rs2, rs1, funct3, rd, opcode);
+}
+
+static inline u32 rv_addi(u8 rd, u8 rs1, u16 imm11_0)
+{
+	return rv_i_insn(imm11_0, rs1, 0, rd, 0x13);
+}
+
+static inline u32 rv_andi(u8 rd, u8 rs1, u16 imm11_0)
+{
+	return rv_i_insn(imm11_0, rs1, 7, rd, 0x13);
+}
+
+static inline u32 rv_ori(u8 rd, u8 rs1, u16 imm11_0)
+{
+	return rv_i_insn(imm11_0, rs1, 6, rd, 0x13);
+}
+
+static inline u32 rv_xori(u8 rd, u8 rs1, u16 imm11_0)
+{
+	return rv_i_insn(imm11_0, rs1, 4, rd, 0x13);
+}
+
+static inline u32 rv_slli(u8 rd, u8 rs1, u16 imm11_0)
+{
+	return rv_i_insn(imm11_0, rs1, 1, rd, 0x13);
+}
+
+static inline u32 rv_srli(u8 rd, u8 rs1, u16 imm11_0)
+{
+	return rv_i_insn(imm11_0, rs1, 5, rd, 0x13);
+}
+
+static inline u32 rv_srai(u8 rd, u8 rs1, u16 imm11_0)
+{
+	return rv_i_insn(0x400 | imm11_0, rs1, 5, rd, 0x13);
+}
+
+static inline u32 rv_lui(u8 rd, u32 imm31_12)
+{
+	return rv_u_insn(imm31_12, rd, 0x37);
+}
+
+static inline u32 rv_auipc(u8 rd, u32 imm31_12)
+{
+	return rv_u_insn(imm31_12, rd, 0x17);
+}
+
+static inline u32 rv_add(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(0, rs2, rs1, 0, rd, 0x33);
+}
+
+static inline u32 rv_sub(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(0x20, rs2, rs1, 0, rd, 0x33);
+}
+
+static inline u32 rv_and(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(0, rs2, rs1, 7, rd, 0x33);
+}
+
+static inline u32 rv_or(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(0, rs2, rs1, 6, rd, 0x33);
+}
+
+static inline u32 rv_xor(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(0, rs2, rs1, 4, rd, 0x33);
+}
+
+static inline u32 rv_sll(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(0, rs2, rs1, 1, rd, 0x33);
+}
+
+static inline u32 rv_srl(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(0, rs2, rs1, 5, rd, 0x33);
+}
+
+static inline u32 rv_sra(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(0x20, rs2, rs1, 5, rd, 0x33);
+}
+
+static inline u32 rv_mul(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(1, rs2, rs1, 0, rd, 0x33);
+}
+
+static inline u32 rv_divu(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(1, rs2, rs1, 5, rd, 0x33);
+}
+
+static inline u32 rv_remu(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(1, rs2, rs1, 7, rd, 0x33);
+}
+
+static inline u32 rv_jal(u8 rd, u32 imm20_1)
+{
+	return rv_j_insn(imm20_1, rd, 0x6f);
+}
+
+static inline u32 rv_jalr(u8 rd, u8 rs1, u16 imm11_0)
+{
+	return rv_i_insn(imm11_0, rs1, 0, rd, 0x67);
+}
+
+static inline u32 rv_beq(u8 rs1, u8 rs2, u16 imm12_1)
+{
+	return rv_b_insn(imm12_1, rs2, rs1, 0, 0x63);
+}
+
+static inline u32 rv_bne(u8 rs1, u8 rs2, u16 imm12_1)
+{
+	return rv_b_insn(imm12_1, rs2, rs1, 1, 0x63);
+}
+
+static inline u32 rv_bltu(u8 rs1, u8 rs2, u16 imm12_1)
+{
+	return rv_b_insn(imm12_1, rs2, rs1, 6, 0x63);
+}
+
+static inline u32 rv_bgeu(u8 rs1, u8 rs2, u16 imm12_1)
+{
+	return rv_b_insn(imm12_1, rs2, rs1, 7, 0x63);
+}
+
+static inline u32 rv_blt(u8 rs1, u8 rs2, u16 imm12_1)
+{
+	return rv_b_insn(imm12_1, rs2, rs1, 4, 0x63);
+}
+
+static inline u32 rv_bge(u8 rs1, u8 rs2, u16 imm12_1)
+{
+	return rv_b_insn(imm12_1, rs2, rs1, 5, 0x63);
+}
+
+static inline u32 rv_lbu(u8 rd, u16 imm11_0, u8 rs1)
+{
+	return rv_i_insn(imm11_0, rs1, 4, rd, 0x03);
+}
+
+static inline u32 rv_lhu(u8 rd, u16 imm11_0, u8 rs1)
+{
+	return rv_i_insn(imm11_0, rs1, 5, rd, 0x03);
+}
+
+static inline u32 rv_sb(u8 rs1, u16 imm11_0, u8 rs2)
+{
+	return rv_s_insn(imm11_0, rs2, rs1, 0, 0x23);
+}
+
+static inline u32 rv_sh(u8 rs1, u16 imm11_0, u8 rs2)
+{
+	return rv_s_insn(imm11_0, rs2, rs1, 1, 0x23);
+}
+
+static inline u32 rv_sw(u8 rs1, u16 imm11_0, u8 rs2)
+{
+	return rv_s_insn(imm11_0, rs2, rs1, 2, 0x23);
+}
+
+static inline u32 rv_amoadd_w(u8 rd, u8 rs2, u8 rs1, u8 aq, u8 rl)
+{
+	return rv_amo_insn(0, aq, rl, rs2, rs1, 2, rd, 0x2f);
+}
+
+static inline u32 rv_addiw(u8 rd, u8 rs1, u16 imm11_0)
+{
+	return rv_i_insn(imm11_0, rs1, 0, rd, 0x1b);
+}
+
+static inline u32 rv_slliw(u8 rd, u8 rs1, u16 imm11_0)
+{
+	return rv_i_insn(imm11_0, rs1, 1, rd, 0x1b);
+}
+
+static inline u32 rv_srliw(u8 rd, u8 rs1, u16 imm11_0)
+{
+	return rv_i_insn(imm11_0, rs1, 5, rd, 0x1b);
+}
+
+static inline u32 rv_sraiw(u8 rd, u8 rs1, u16 imm11_0)
+{
+	return rv_i_insn(0x400 | imm11_0, rs1, 5, rd, 0x1b);
+}
+
+static inline u32 rv_addw(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(0, rs2, rs1, 0, rd, 0x3b);
+}
+
+static inline u32 rv_subw(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(0x20, rs2, rs1, 0, rd, 0x3b);
+}
+
+static inline u32 rv_sllw(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(0, rs2, rs1, 1, rd, 0x3b);
+}
+
+static inline u32 rv_srlw(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(0, rs2, rs1, 5, rd, 0x3b);
+}
+
+static inline u32 rv_sraw(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(0x20, rs2, rs1, 5, rd, 0x3b);
+}
+
+static inline u32 rv_mulw(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(1, rs2, rs1, 0, rd, 0x3b);
+}
+
+static inline u32 rv_divuw(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(1, rs2, rs1, 5, rd, 0x3b);
+}
+
+static inline u32 rv_remuw(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(1, rs2, rs1, 7, rd, 0x3b);
+}
+
+static inline u32 rv_ld(u8 rd, u16 imm11_0, u8 rs1)
+{
+	return rv_i_insn(imm11_0, rs1, 3, rd, 0x03);
+}
+
+static inline u32 rv_lwu(u8 rd, u16 imm11_0, u8 rs1)
+{
+	return rv_i_insn(imm11_0, rs1, 6, rd, 0x03);
+}
+
+static inline u32 rv_sd(u8 rs1, u16 imm11_0, u8 rs2)
+{
+	return rv_s_insn(imm11_0, rs2, rs1, 3, 0x23);
+}
+
+static inline u32 rv_amoadd_d(u8 rd, u8 rs2, u8 rs1, u8 aq, u8 rl)
+{
+	return rv_amo_insn(0, aq, rl, rs2, rs1, 3, rd, 0x2f);
+}
+
+void bpf_jit_build_prologue(struct rv_jit_context *ctx);
+void bpf_jit_build_epilogue(struct rv_jit_context *ctx);
+
+int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
+		      bool extra_pass);
+
+#endif /* _BPF_JIT_H */
diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp64.c
similarity index 69%
rename from arch/riscv/net/bpf_jit_comp.c
rename to arch/riscv/net/bpf_jit_comp64.c
index 483f4ad7f4dc..cc1985d8750a 100644
--- a/arch/riscv/net/bpf_jit_comp.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -7,42 +7,7 @@
 
 #include <linux/bpf.h>
 #include <linux/filter.h>
-#include <asm/cacheflush.h>
-
-enum {
-	RV_REG_ZERO =	0,	/* The constant value 0 */
-	RV_REG_RA =	1,	/* Return address */
-	RV_REG_SP =	2,	/* Stack pointer */
-	RV_REG_GP =	3,	/* Global pointer */
-	RV_REG_TP =	4,	/* Thread pointer */
-	RV_REG_T0 =	5,	/* Temporaries */
-	RV_REG_T1 =	6,
-	RV_REG_T2 =	7,
-	RV_REG_FP =	8,
-	RV_REG_S1 =	9,	/* Saved registers */
-	RV_REG_A0 =	10,	/* Function argument/return values */
-	RV_REG_A1 =	11,	/* Function arguments */
-	RV_REG_A2 =	12,
-	RV_REG_A3 =	13,
-	RV_REG_A4 =	14,
-	RV_REG_A5 =	15,
-	RV_REG_A6 =	16,
-	RV_REG_A7 =	17,
-	RV_REG_S2 =	18,	/* Saved registers */
-	RV_REG_S3 =	19,
-	RV_REG_S4 =	20,
-	RV_REG_S5 =	21,
-	RV_REG_S6 =	22,
-	RV_REG_S7 =	23,
-	RV_REG_S8 =	24,
-	RV_REG_S9 =	25,
-	RV_REG_S10 =	26,
-	RV_REG_S11 =	27,
-	RV_REG_T3 =	28,	/* Temporaries */
-	RV_REG_T4 =	29,
-	RV_REG_T5 =	30,
-	RV_REG_T6 =	31,
-};
+#include "bpf_jit.h"
 
 #define RV_REG_TCC RV_REG_A6
 #define RV_REG_TCC_SAVED RV_REG_S6 /* Store A6 in S6 if program do calls */
@@ -73,22 +38,6 @@ enum {
 	RV_CTX_F_SEEN_S6 =		RV_REG_S6,
 };
 
-struct rv_jit_context {
-	struct bpf_prog *prog;
-	u32 *insns; /* RV insns */
-	int ninsns;
-	int epilogue_offset;
-	int *offset; /* BPF to RV */
-	unsigned long flags;
-	int stack_size;
-};
-
-struct rv_jit_data {
-	struct bpf_binary_header *header;
-	u8 *image;
-	struct rv_jit_context ctx;
-};
-
 static u8 bpf_to_rv_reg(int bpf_reg, struct rv_jit_context *ctx)
 {
 	u8 reg = regmap[bpf_reg];
@@ -156,346 +105,11 @@ static u8 rv_tail_call_reg(struct rv_jit_context *ctx)
 	return RV_REG_A6;
 }
 
-static void emit(const u32 insn, struct rv_jit_context *ctx)
-{
-	if (ctx->insns)
-		ctx->insns[ctx->ninsns] = insn;
-
-	ctx->ninsns++;
-}
-
-static u32 rv_r_insn(u8 funct7, u8 rs2, u8 rs1, u8 funct3, u8 rd, u8 opcode)
-{
-	return (funct7 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) |
-		(rd << 7) | opcode;
-}
-
-static u32 rv_i_insn(u16 imm11_0, u8 rs1, u8 funct3, u8 rd, u8 opcode)
-{
-	return (imm11_0 << 20) | (rs1 << 15) | (funct3 << 12) | (rd << 7) |
-		opcode;
-}
-
-static u32 rv_s_insn(u16 imm11_0, u8 rs2, u8 rs1, u8 funct3, u8 opcode)
-{
-	u8 imm11_5 = imm11_0 >> 5, imm4_0 = imm11_0 & 0x1f;
-
-	return (imm11_5 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) |
-		(imm4_0 << 7) | opcode;
-}
-
-static u32 rv_sb_insn(u16 imm12_1, u8 rs2, u8 rs1, u8 funct3, u8 opcode)
-{
-	u8 imm12 = ((imm12_1 & 0x800) >> 5) | ((imm12_1 & 0x3f0) >> 4);
-	u8 imm4_1 = ((imm12_1 & 0xf) << 1) | ((imm12_1 & 0x400) >> 10);
-
-	return (imm12 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) |
-		(imm4_1 << 7) | opcode;
-}
-
-static u32 rv_u_insn(u32 imm31_12, u8 rd, u8 opcode)
-{
-	return (imm31_12 << 12) | (rd << 7) | opcode;
-}
-
-static u32 rv_uj_insn(u32 imm20_1, u8 rd, u8 opcode)
-{
-	u32 imm;
-
-	imm = (imm20_1 & 0x80000) |  ((imm20_1 & 0x3ff) << 9) |
-	      ((imm20_1 & 0x400) >> 2) | ((imm20_1 & 0x7f800) >> 11);
-
-	return (imm << 12) | (rd << 7) | opcode;
-}
-
-static u32 rv_amo_insn(u8 funct5, u8 aq, u8 rl, u8 rs2, u8 rs1,
-		       u8 funct3, u8 rd, u8 opcode)
-{
-	u8 funct7 = (funct5 << 2) | (aq << 1) | rl;
-
-	return rv_r_insn(funct7, rs2, rs1, funct3, rd, opcode);
-}
-
-static u32 rv_addiw(u8 rd, u8 rs1, u16 imm11_0)
-{
-	return rv_i_insn(imm11_0, rs1, 0, rd, 0x1b);
-}
-
-static u32 rv_addi(u8 rd, u8 rs1, u16 imm11_0)
-{
-	return rv_i_insn(imm11_0, rs1, 0, rd, 0x13);
-}
-
-static u32 rv_addw(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(0, rs2, rs1, 0, rd, 0x3b);
-}
-
-static u32 rv_add(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(0, rs2, rs1, 0, rd, 0x33);
-}
-
-static u32 rv_subw(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(0x20, rs2, rs1, 0, rd, 0x3b);
-}
-
-static u32 rv_sub(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(0x20, rs2, rs1, 0, rd, 0x33);
-}
-
-static u32 rv_and(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(0, rs2, rs1, 7, rd, 0x33);
-}
-
-static u32 rv_or(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(0, rs2, rs1, 6, rd, 0x33);
-}
-
-static u32 rv_xor(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(0, rs2, rs1, 4, rd, 0x33);
-}
-
-static u32 rv_mulw(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(1, rs2, rs1, 0, rd, 0x3b);
-}
-
-static u32 rv_mul(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(1, rs2, rs1, 0, rd, 0x33);
-}
-
-static u32 rv_divuw(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(1, rs2, rs1, 5, rd, 0x3b);
-}
-
-static u32 rv_divu(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(1, rs2, rs1, 5, rd, 0x33);
-}
-
-static u32 rv_remuw(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(1, rs2, rs1, 7, rd, 0x3b);
-}
-
-static u32 rv_remu(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(1, rs2, rs1, 7, rd, 0x33);
-}
-
-static u32 rv_sllw(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(0, rs2, rs1, 1, rd, 0x3b);
-}
-
-static u32 rv_sll(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(0, rs2, rs1, 1, rd, 0x33);
-}
-
-static u32 rv_srlw(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(0, rs2, rs1, 5, rd, 0x3b);
-}
-
-static u32 rv_srl(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(0, rs2, rs1, 5, rd, 0x33);
-}
-
-static u32 rv_sraw(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(0x20, rs2, rs1, 5, rd, 0x3b);
-}
-
-static u32 rv_sra(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(0x20, rs2, rs1, 5, rd, 0x33);
-}
-
-static u32 rv_lui(u8 rd, u32 imm31_12)
-{
-	return rv_u_insn(imm31_12, rd, 0x37);
-}
-
-static u32 rv_slli(u8 rd, u8 rs1, u16 imm11_0)
-{
-	return rv_i_insn(imm11_0, rs1, 1, rd, 0x13);
-}
-
-static u32 rv_andi(u8 rd, u8 rs1, u16 imm11_0)
-{
-	return rv_i_insn(imm11_0, rs1, 7, rd, 0x13);
-}
-
-static u32 rv_ori(u8 rd, u8 rs1, u16 imm11_0)
-{
-	return rv_i_insn(imm11_0, rs1, 6, rd, 0x13);
-}
-
-static u32 rv_xori(u8 rd, u8 rs1, u16 imm11_0)
-{
-	return rv_i_insn(imm11_0, rs1, 4, rd, 0x13);
-}
-
-static u32 rv_slliw(u8 rd, u8 rs1, u16 imm11_0)
-{
-	return rv_i_insn(imm11_0, rs1, 1, rd, 0x1b);
-}
-
-static u32 rv_srliw(u8 rd, u8 rs1, u16 imm11_0)
-{
-	return rv_i_insn(imm11_0, rs1, 5, rd, 0x1b);
-}
-
-static u32 rv_srli(u8 rd, u8 rs1, u16 imm11_0)
-{
-	return rv_i_insn(imm11_0, rs1, 5, rd, 0x13);
-}
-
-static u32 rv_sraiw(u8 rd, u8 rs1, u16 imm11_0)
-{
-	return rv_i_insn(0x400 | imm11_0, rs1, 5, rd, 0x1b);
-}
-
-static u32 rv_srai(u8 rd, u8 rs1, u16 imm11_0)
-{
-	return rv_i_insn(0x400 | imm11_0, rs1, 5, rd, 0x13);
-}
-
-static u32 rv_jal(u8 rd, u32 imm20_1)
-{
-	return rv_uj_insn(imm20_1, rd, 0x6f);
-}
-
-static u32 rv_jalr(u8 rd, u8 rs1, u16 imm11_0)
-{
-	return rv_i_insn(imm11_0, rs1, 0, rd, 0x67);
-}
-
-static u32 rv_beq(u8 rs1, u8 rs2, u16 imm12_1)
-{
-	return rv_sb_insn(imm12_1, rs2, rs1, 0, 0x63);
-}
-
-static u32 rv_bltu(u8 rs1, u8 rs2, u16 imm12_1)
-{
-	return rv_sb_insn(imm12_1, rs2, rs1, 6, 0x63);
-}
-
-static u32 rv_bgeu(u8 rs1, u8 rs2, u16 imm12_1)
-{
-	return rv_sb_insn(imm12_1, rs2, rs1, 7, 0x63);
-}
-
-static u32 rv_bne(u8 rs1, u8 rs2, u16 imm12_1)
-{
-	return rv_sb_insn(imm12_1, rs2, rs1, 1, 0x63);
-}
-
-static u32 rv_blt(u8 rs1, u8 rs2, u16 imm12_1)
-{
-	return rv_sb_insn(imm12_1, rs2, rs1, 4, 0x63);
-}
-
-static u32 rv_bge(u8 rs1, u8 rs2, u16 imm12_1)
-{
-	return rv_sb_insn(imm12_1, rs2, rs1, 5, 0x63);
-}
-
-static u32 rv_sb(u8 rs1, u16 imm11_0, u8 rs2)
-{
-	return rv_s_insn(imm11_0, rs2, rs1, 0, 0x23);
-}
-
-static u32 rv_sh(u8 rs1, u16 imm11_0, u8 rs2)
-{
-	return rv_s_insn(imm11_0, rs2, rs1, 1, 0x23);
-}
-
-static u32 rv_sw(u8 rs1, u16 imm11_0, u8 rs2)
-{
-	return rv_s_insn(imm11_0, rs2, rs1, 2, 0x23);
-}
-
-static u32 rv_sd(u8 rs1, u16 imm11_0, u8 rs2)
-{
-	return rv_s_insn(imm11_0, rs2, rs1, 3, 0x23);
-}
-
-static u32 rv_lbu(u8 rd, u16 imm11_0, u8 rs1)
-{
-	return rv_i_insn(imm11_0, rs1, 4, rd, 0x03);
-}
-
-static u32 rv_lhu(u8 rd, u16 imm11_0, u8 rs1)
-{
-	return rv_i_insn(imm11_0, rs1, 5, rd, 0x03);
-}
-
-static u32 rv_lwu(u8 rd, u16 imm11_0, u8 rs1)
-{
-	return rv_i_insn(imm11_0, rs1, 6, rd, 0x03);
-}
-
-static u32 rv_ld(u8 rd, u16 imm11_0, u8 rs1)
-{
-	return rv_i_insn(imm11_0, rs1, 3, rd, 0x03);
-}
-
-static u32 rv_amoadd_w(u8 rd, u8 rs2, u8 rs1, u8 aq, u8 rl)
-{
-	return rv_amo_insn(0, aq, rl, rs2, rs1, 2, rd, 0x2f);
-}
-
-static u32 rv_amoadd_d(u8 rd, u8 rs2, u8 rs1, u8 aq, u8 rl)
-{
-	return rv_amo_insn(0, aq, rl, rs2, rs1, 3, rd, 0x2f);
-}
-
-static u32 rv_auipc(u8 rd, u32 imm31_12)
-{
-	return rv_u_insn(imm31_12, rd, 0x17);
-}
-
-static bool is_12b_int(s64 val)
-{
-	return -(1 << 11) <= val && val < (1 << 11);
-}
-
-static bool is_13b_int(s64 val)
-{
-	return -(1 << 12) <= val && val < (1 << 12);
-}
-
-static bool is_21b_int(s64 val)
-{
-	return -(1L << 20) <= val && val < (1L << 20);
-}
-
 static bool is_32b_int(s64 val)
 {
 	return -(1L << 31) <= val && val < (1L << 31);
 }
 
-static int is_12b_check(int off, int insn)
-{
-	if (!is_12b_int(off)) {
-		pr_err("bpf-jit: insn=%d 12b < offset=%d not supported yet!\n",
-		       insn, (int)off);
-		return -1;
-	}
-	return 0;
-}
-
 static void emit_imm(u8 rd, s64 val, struct rv_jit_context *ctx)
 {
 	/* Note that the immediate from the add is sign-extended,
@@ -535,23 +149,6 @@ static void emit_imm(u8 rd, s64 val, struct rv_jit_context *ctx)
 		emit(rv_addi(rd, rd, lower), ctx);
 }
 
-static int rv_offset(int insn, int off, struct rv_jit_context *ctx)
-{
-	int from, to;
-
-	off++; /* BPF branch is from PC+1, RV is from PC */
-	from = (insn > 0) ? ctx->offset[insn - 1] : 0;
-	to = (insn + off > 0) ? ctx->offset[insn + off - 1] : 0;
-	return (to - from) << 2;
-}
-
-static int epilogue_offset(struct rv_jit_context *ctx)
-{
-	int to = ctx->epilogue_offset, from = ctx->ninsns;
-
-	return (to - from) << 2;
-}
-
 static void __build_epilogue(bool is_tail_call, struct rv_jit_context *ctx)
 {
 	int stack_adjust = ctx->stack_size, store_offset = stack_adjust - 8;
@@ -596,34 +193,6 @@ static void __build_epilogue(bool is_tail_call, struct rv_jit_context *ctx)
 	     ctx);
 }
 
-/* return -1 or inverted cond */
-static int invert_bpf_cond(u8 cond)
-{
-	switch (cond) {
-	case BPF_JEQ:
-		return BPF_JNE;
-	case BPF_JGT:
-		return BPF_JLE;
-	case BPF_JLT:
-		return BPF_JGE;
-	case BPF_JGE:
-		return BPF_JLT;
-	case BPF_JLE:
-		return BPF_JGT;
-	case BPF_JNE:
-		return BPF_JEQ;
-	case BPF_JSGT:
-		return BPF_JSLE;
-	case BPF_JSLT:
-		return BPF_JSGE;
-	case BPF_JSGE:
-		return BPF_JSLT;
-	case BPF_JSLE:
-		return BPF_JSGT;
-	}
-	return -1;
-}
-
 static void emit_bcc(u8 cond, u8 rd, u8 rs, int rvoff,
 		     struct rv_jit_context *ctx)
 {
@@ -855,8 +424,8 @@ static int emit_call(bool fixed, u64 addr, struct rv_jit_context *ctx)
 	return 0;
 }
 
-static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
-		     bool extra_pass)
+int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
+		      bool extra_pass)
 {
 	bool is64 = BPF_CLASS(insn->code) == BPF_ALU64 ||
 		    BPF_CLASS(insn->code) == BPF_JMP;
@@ -1434,7 +1003,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	return 0;
 }
 
-static void build_prologue(struct rv_jit_context *ctx)
+void bpf_jit_build_prologue(struct rv_jit_context *ctx)
 {
 	int stack_adjust = 0, store_offset, bpf_stack_adjust;
 
@@ -1515,175 +1084,11 @@ static void build_prologue(struct rv_jit_context *ctx)
 	ctx->stack_size = stack_adjust;
 }
 
-static void build_epilogue(struct rv_jit_context *ctx)
+void bpf_jit_build_epilogue(struct rv_jit_context *ctx)
 {
 	__build_epilogue(false, ctx);
 }
 
-static int build_body(struct rv_jit_context *ctx, bool extra_pass, int *offset)
-{
-	const struct bpf_prog *prog = ctx->prog;
-	int i;
-
-	for (i = 0; i < prog->len; i++) {
-		const struct bpf_insn *insn = &prog->insnsi[i];
-		int ret;
-
-		ret = emit_insn(insn, ctx, extra_pass);
-		if (ret > 0) {
-			i++;
-			if (offset)
-				offset[i] = ctx->ninsns;
-			continue;
-		}
-		if (offset)
-			offset[i] = ctx->ninsns;
-		if (ret)
-			return ret;
-	}
-	return 0;
-}
-
-static void bpf_fill_ill_insns(void *area, unsigned int size)
-{
-	memset(area, 0, size);
-}
-
-static void bpf_flush_icache(void *start, void *end)
-{
-	flush_icache_range((unsigned long)start, (unsigned long)end);
-}
-
-bool bpf_jit_needs_zext(void)
-{
-	return true;
-}
-
-struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
-{
-	bool tmp_blinded = false, extra_pass = false;
-	struct bpf_prog *tmp, *orig_prog = prog;
-	int pass = 0, prev_ninsns = 0, i;
-	struct rv_jit_data *jit_data;
-	unsigned int image_size = 0;
-	struct rv_jit_context *ctx;
-
-	if (!prog->jit_requested)
-		return orig_prog;
-
-	tmp = bpf_jit_blind_constants(prog);
-	if (IS_ERR(tmp))
-		return orig_prog;
-	if (tmp != prog) {
-		tmp_blinded = true;
-		prog = tmp;
-	}
-
-	jit_data = prog->aux->jit_data;
-	if (!jit_data) {
-		jit_data = kzalloc(sizeof(*jit_data), GFP_KERNEL);
-		if (!jit_data) {
-			prog = orig_prog;
-			goto out;
-		}
-		prog->aux->jit_data = jit_data;
-	}
-
-	ctx = &jit_data->ctx;
-
-	if (ctx->offset) {
-		extra_pass = true;
-		image_size = sizeof(u32) * ctx->ninsns;
-		goto skip_init_ctx;
-	}
-
-	ctx->prog = prog;
-	ctx->offset = kcalloc(prog->len, sizeof(int), GFP_KERNEL);
-	if (!ctx->offset) {
-		prog = orig_prog;
-		goto out_offset;
-	}
-	for (i = 0; i < prog->len; i++) {
-		prev_ninsns += 32;
-		ctx->offset[i] = prev_ninsns;
-	}
-
-	for (i = 0; i < 16; i++) {
-		pass++;
-		ctx->ninsns = 0;
-		if (build_body(ctx, extra_pass, ctx->offset)) {
-			prog = orig_prog;
-			goto out_offset;
-		}
-		build_prologue(ctx);
-		ctx->epilogue_offset = ctx->ninsns;
-		build_epilogue(ctx);
-
-		if (ctx->ninsns == prev_ninsns) {
-			if (jit_data->header)
-				break;
-
-			image_size = sizeof(u32) * ctx->ninsns;
-			jit_data->header =
-				bpf_jit_binary_alloc(image_size,
-						     &jit_data->image,
-						     sizeof(u32),
-						     bpf_fill_ill_insns);
-			if (!jit_data->header) {
-				prog = orig_prog;
-				goto out_offset;
-			}
-
-			ctx->insns = (u32 *)jit_data->image;
-			/* Now, when the image is allocated, the image
-			 * can potentially shrink more (auipc/jalr ->
-			 * jal).
-			 */
-		}
-		prev_ninsns = ctx->ninsns;
-	}
-
-	if (i == 16) {
-		pr_err("bpf-jit: image did not converge in <%d passes!\n", i);
-		bpf_jit_binary_free(jit_data->header);
-		prog = orig_prog;
-		goto out_offset;
-	}
-
-skip_init_ctx:
-	pass++;
-	ctx->ninsns = 0;
-
-	build_prologue(ctx);
-	if (build_body(ctx, extra_pass, NULL)) {
-		bpf_jit_binary_free(jit_data->header);
-		prog = orig_prog;
-		goto out_offset;
-	}
-	build_epilogue(ctx);
-
-	if (bpf_jit_enable > 1)
-		bpf_jit_dump(prog->len, image_size, pass, ctx->insns);
-
-	prog->bpf_func = (void *)ctx->insns;
-	prog->jited = 1;
-	prog->jited_len = image_size;
-
-	bpf_flush_icache(jit_data->header, ctx->insns + ctx->ninsns);
-
-	if (!prog->is_func || extra_pass) {
-out_offset:
-		kfree(ctx->offset);
-		kfree(jit_data);
-		prog->aux->jit_data = NULL;
-	}
-out:
-	if (tmp_blinded)
-		bpf_jit_prog_release_other(prog, prog == orig_prog ?
-					   tmp : orig_prog);
-	return prog;
-}
-
 void *bpf_jit_alloc_exec(unsigned long size)
 {
 	return __vmalloc_node_range(size, PAGE_SIZE, BPF_JIT_REGION_START,
diff --git a/arch/riscv/net/bpf_jit_core.c b/arch/riscv/net/bpf_jit_core.c
new file mode 100644
index 000000000000..709b94ece3ed
--- /dev/null
+++ b/arch/riscv/net/bpf_jit_core.c
@@ -0,0 +1,166 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Common functionality for RV32 and RV64 BPF JIT compilers
+ *
+ * Copyright (c) 2019 Björn Töpel <bjorn.topel@gmail.com>
+ *
+ */
+
+#include <linux/bpf.h>
+#include <linux/filter.h>
+#include "bpf_jit.h"
+
+/* Number of iterations to try until offsets converge. */
+#define NR_JIT_ITERATIONS	16
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
+		ret = bpf_jit_emit_insn(insn, ctx, extra_pass);
+		/* BPF_LD | BPF_IMM | BPF_DW: skip the next instruction. */
+		if (ret > 0)
+			i++;
+		if (offset)
+			offset[i] = ctx->ninsns;
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
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
+		bpf_jit_build_prologue(ctx);
+		ctx->epilogue_offset = ctx->ninsns;
+		bpf_jit_build_epilogue(ctx);
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
+			/*
+			 * Now, when the image is allocated, the image can
+			 * potentially shrink more (auipc/jalr -> jal).
+			 */
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
+	bpf_jit_build_prologue(ctx);
+	if (build_body(ctx, extra_pass, NULL)) {
+		bpf_jit_binary_free(jit_data->header);
+		prog = orig_prog;
+		goto out_offset;
+	}
+	bpf_jit_build_epilogue(ctx);
+
+	if (bpf_jit_enable > 1)
+		bpf_jit_dump(prog->len, image_size, pass, ctx->insns);
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

