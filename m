Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83EDF22763F
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 04:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbgGUCxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 22:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgGUCwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 22:52:47 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA867C0619D5
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 19:52:47 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id k4so9592941pld.12
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 19:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZLIWvysF1C5d8TSKuMS5aP5i+ZqkWdLF8dd1Gt10AhQ=;
        b=eoQUnl6niWkeedct+t0u3kAA5svSXQDpADC8734or8i+rJMSN79XLSeZbLXzEI+sVV
         TcF/lUlXtDoAYSlTLh1lBE4aF9ckCKG4xSl7iee1yefW9g294+Ht4QtazfHecLlxbsnt
         S4WT79fzacDiCT/d6hSP13p/5197VaYuMOuLk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZLIWvysF1C5d8TSKuMS5aP5i+ZqkWdLF8dd1Gt10AhQ=;
        b=fyhJ24OKsja1iEG9nPk+FYqYIHb2aae9UqJUJgZukt8CWKmiD7t1+mcwTvPjv4wVPU
         4mjQVTHTjCnv7EgnjhcPfIr3QLKgt4OjGtDNZJ71CuOh1t/qvDxzer6Gu5IqMLfp+7Pj
         UbYs1V19IfTDQT9H6Y0/TB0ItZMtbTabpvl/qbgLRHdkQ2Jq0i545gCcEjq9Q12A9OxZ
         qNIMxIw8/TvFpVlCIFxs4HQT6Df9DAG8N+wzJ/1GkY5lbzFyYGu2O4A2+nY0ucoG7Azn
         jGvEWVUo4PsokcDp5QP6CgyKuhtn52EX84vEWF2ALMXLOSIUaB4jBraYWLAn8JJJS0si
         iubA==
X-Gm-Message-State: AOAM533r/wVxBqJYD5Omnq5qzd4G3SgLH9vLda3S7t2ReFiADaScwWdG
        fDy43laVAiX1xAuN3tMLYNY10Q==
X-Google-Smtp-Source: ABdhPJyaDHfJvH0sJQYvn1SrPD3Wsf3L+yPd0liTBdcKHlgXT6NmPwwJ9PejQ1z/1O+Md4Wcaw+x9w==
X-Received: by 2002:a17:90b:112:: with SMTP id p18mr2499313pjz.92.1595299967064;
        Mon, 20 Jul 2020 19:52:47 -0700 (PDT)
Received: from localhost.localdomain (c-73-53-94-119.hsd1.wa.comcast.net. [73.53.94.119])
        by smtp.gmail.com with ESMTPSA id m16sm18769753pfd.101.2020.07.20.19.52.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 19:52:46 -0700 (PDT)
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
Subject: [PATCH bpf-next v1 2/3] bpf, riscv: Add encodings for compressed instructions
Date:   Mon, 20 Jul 2020 19:52:39 -0700
Message-Id: <20200721025241.8077-3-luke.r.nels@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721025241.8077-1-luke.r.nels@gmail.com>
References: <20200721025241.8077-1-luke.r.nels@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds functions for encoding and emitting compressed riscv
(RVC) instructions to the BPF JIT.

Some regular riscv instructions can be compressed into an RVC instruction
if the instruction fields meet some requirements. For example, "add rd,
rs1, rs2" can be compressed into "c.add rd, rs2" when rd == rs1.

To make using RVC encodings simpler, this patch also adds helper
functions that selectively emit either a regular instruction or a
compressed instruction if possible.

For example, emit_add will produce a "c.add" if possible and regular
"add" otherwise.

Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
---
 arch/riscv/net/bpf_jit.h | 452 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 452 insertions(+)

diff --git a/arch/riscv/net/bpf_jit.h b/arch/riscv/net/bpf_jit.h
index e90d336a9e5f..75c1e9996867 100644
--- a/arch/riscv/net/bpf_jit.h
+++ b/arch/riscv/net/bpf_jit.h
@@ -53,6 +53,18 @@ enum {
 	RV_REG_T6 =	31,
 };
 
+static inline bool is_creg(u8 reg)
+{
+	return (1 << reg) & (BIT(RV_REG_FP) |
+			     BIT(RV_REG_S1) |
+			     BIT(RV_REG_A0) |
+			     BIT(RV_REG_A1) |
+			     BIT(RV_REG_A2) |
+			     BIT(RV_REG_A3) |
+			     BIT(RV_REG_A4) |
+			     BIT(RV_REG_A5));
+}
+
 struct rv_jit_context {
 	struct bpf_prog *prog;
 	u16 *insns;		/* RV insns */
@@ -142,6 +154,36 @@ static inline int invert_bpf_cond(u8 cond)
 	return -1;
 }
 
+static inline bool is_6b_int(long val)
+{
+	return -(1L << 5) <= val && val < (1L << 5);
+}
+
+static inline bool is_7b_uint(unsigned long val)
+{
+	return val < (1UL << 7);
+}
+
+static inline bool is_8b_uint(unsigned long val)
+{
+	return val < (1UL << 8);
+}
+
+static inline bool is_9b_uint(unsigned long val)
+{
+	return val < (1UL << 9);
+}
+
+static inline bool is_10b_int(long val)
+{
+	return -(1L << 9) <= val && val < (1L << 9);
+}
+
+static inline bool is_10b_uint(unsigned long val)
+{
+	return val < (1UL << 10);
+}
+
 static inline bool is_12b_int(long val)
 {
 	return -(1L << 11) <= val && val < (1L << 11);
@@ -232,6 +274,59 @@ static inline u32 rv_amo_insn(u8 funct5, u8 aq, u8 rl, u8 rs2, u8 rs1,
 	return rv_r_insn(funct7, rs2, rs1, funct3, rd, opcode);
 }
 
+/* RISC-V compressed instruction formats. */
+
+static inline u16 rv_cr_insn(u8 funct4, u8 rd, u8 rs2, u8 op)
+{
+	return (funct4 << 12) | (rd << 7) | (rs2 << 2) | op;
+}
+
+static inline u16 rv_ci_insn(u8 funct3, u32 imm6, u8 rd, u8 op)
+{
+	u32 imm;
+
+	imm = ((imm6 & 0x20) << 7) | ((imm6 & 0x1f) << 2);
+	return (funct3 << 13) | (rd << 7) | op | imm;
+}
+
+static inline u16 rv_css_insn(u8 funct3, u32 uimm, u8 rs2, u8 op)
+{
+	return (funct3 << 13) | (uimm << 7) | (rs2 << 2) | op;
+}
+
+static inline u16 rv_ciw_insn(u8 funct3, u32 uimm, u8 rd, u8 op)
+{
+	return (funct3 << 13) | (uimm << 5) | ((rd & 0x7) << 2) | op;
+}
+
+static inline u16 rv_cl_insn(u8 funct3, u32 imm_hi, u8 rs1, u32 imm_lo, u8 rd,
+			     u8 op)
+{
+	return (funct3 << 13) | (imm_hi << 10) | ((rs1 & 0x7) << 7) |
+		(imm_lo << 5) | ((rd & 0x7) << 2) | op;
+}
+
+static inline u16 rv_cs_insn(u8 funct3, u32 imm_hi, u8 rs1, u32 imm_lo, u8 rs2,
+			     u8 op)
+{
+	return (funct3 << 13) | (imm_hi << 10) | ((rs1 & 0x7) << 7) |
+		(imm_lo << 5) | ((rs2 & 0x7) << 2) | op;
+}
+
+static inline u16 rv_ca_insn(u8 funct6, u8 rd, u8 funct2, u8 rs2, u8 op)
+{
+	return (funct6 << 10) | ((rd & 0x7) << 7) | (funct2 << 5) |
+		((rs2 & 0x7) << 2) | op;
+}
+
+static inline u16 rv_cb_insn(u8 funct3, u32 imm6, u8 funct2, u8 rd, u8 op)
+{
+	u32 imm;
+
+	imm = ((imm6 & 0x20) << 7) | ((imm6 & 0x1f) << 2);
+	return (funct3 << 13) | (funct2 << 10) | ((rd & 0x7) << 7) | op | imm;
+}
+
 /* Instructions shared by both RV32 and RV64. */
 
 static inline u32 rv_addi(u8 rd, u8 rs1, u16 imm11_0)
@@ -439,6 +534,135 @@ static inline u32 rv_amoadd_w(u8 rd, u8 rs2, u8 rs1, u8 aq, u8 rl)
 	return rv_amo_insn(0, aq, rl, rs2, rs1, 2, rd, 0x2f);
 }
 
+/* RVC instrutions. */
+
+static inline u16 rvc_addi4spn(u8 rd, u32 imm10)
+{
+	u32 imm;
+
+	imm = ((imm10 & 0x30) << 2) | ((imm10 & 0x3c0) >> 4) |
+		((imm10 & 0x4) >> 1) | ((imm10 & 0x8) >> 3);
+	return rv_ciw_insn(0x0, imm, rd, 0x0);
+}
+
+static inline u16 rvc_lw(u8 rd, u32 imm7, u8 rs1)
+{
+	u32 imm_hi, imm_lo;
+
+	imm_hi = (imm7 & 0x38) >> 3;
+	imm_lo = ((imm7 & 0x4) >> 1) | ((imm7 & 0x40) >> 6);
+	return rv_cl_insn(0x2, imm_hi, rs1, imm_lo, rd, 0x0);
+}
+
+static inline u16 rvc_sw(u8 rs1, u32 imm7, u8 rs2)
+{
+	u32 imm_hi, imm_lo;
+
+	imm_hi = (imm7 & 0x38) >> 3;
+	imm_lo = ((imm7 & 0x4) >> 1) | ((imm7 & 0x40) >> 6);
+	return rv_cs_insn(0x6, imm_hi, rs1, imm_lo, rs2, 0x0);
+}
+
+static inline u16 rvc_addi(u8 rd, u32 imm6)
+{
+	return rv_ci_insn(0, imm6, rd, 0x1);
+}
+
+static inline u16 rvc_li(u8 rd, u32 imm6)
+{
+	return rv_ci_insn(0x2, imm6, rd, 0x1);
+}
+
+static inline u16 rvc_addi16sp(u32 imm10)
+{
+	u32 imm;
+
+	imm = ((imm10 & 0x200) >> 4) | (imm10 & 0x10) | ((imm10 & 0x40) >> 3) |
+		((imm10 & 0x180) >> 6) | ((imm10 & 0x20) >> 5);
+	return rv_ci_insn(0x3, imm, RV_REG_SP, 0x1);
+}
+
+static inline u16 rvc_lui(u8 rd, u32 imm6)
+{
+	return rv_ci_insn(0x3, imm6, rd, 0x1);
+}
+
+static inline u16 rvc_srli(u8 rd, u32 imm6)
+{
+	return rv_cb_insn(0x4, imm6, 0, rd, 0x1);
+}
+
+static inline u16 rvc_srai(u8 rd, u32 imm6)
+{
+	return rv_cb_insn(0x4, imm6, 0x1, rd, 0x1);
+}
+
+static inline u16 rvc_andi(u8 rd, u32 imm6)
+{
+	return rv_cb_insn(0x4, imm6, 0x2, rd, 0x1);
+}
+
+static inline u16 rvc_sub(u8 rd, u8 rs)
+{
+	return rv_ca_insn(0x23, rd, 0, rs, 0x1);
+}
+
+static inline u16 rvc_xor(u8 rd, u8 rs)
+{
+	return rv_ca_insn(0x23, rd, 0x1, rs, 0x1);
+}
+
+static inline u16 rvc_or(u8 rd, u8 rs)
+{
+	return rv_ca_insn(0x23, rd, 0x2, rs, 0x1);
+}
+
+static inline u16 rvc_and(u8 rd, u8 rs)
+{
+	return rv_ca_insn(0x23, rd, 0x3, rs, 0x1);
+}
+
+static inline u16 rvc_slli(u8 rd, u32 imm6)
+{
+	return rv_ci_insn(0, imm6, rd, 0x2);
+}
+
+static inline u16 rvc_lwsp(u8 rd, u32 imm8)
+{
+	u32 imm;
+
+	imm = ((imm8 & 0xc0) >> 6) | (imm8 & 0x3c);
+	return rv_ci_insn(0x2, imm, rd, 0x2);
+}
+
+static inline u16 rvc_jr(u8 rs1)
+{
+	return rv_cr_insn(0x8, rs1, RV_REG_ZERO, 0x2);
+}
+
+static inline u16 rvc_mv(u8 rd, u8 rs)
+{
+	return rv_cr_insn(0x8, rd, rs, 0x2);
+}
+
+static inline u16 rvc_jalr(u8 rs1)
+{
+	return rv_cr_insn(0x9, rs1, RV_REG_ZERO, 0x2);
+}
+
+static inline u16 rvc_add(u8 rd, u8 rs)
+{
+	return rv_cr_insn(0x9, rd, rs, 0x2);
+}
+
+static inline u16 rvc_swsp(u32 imm8, u8 rs2)
+{
+	u32 imm;
+
+	imm = (imm8 & 0x3c) | ((imm8 & 0xc0) >> 6);
+	return rv_css_insn(0x6, imm, rs2, 0x2);
+}
+
 /*
  * RV64-only instructions.
  *
@@ -528,6 +752,234 @@ static inline u32 rv_amoadd_d(u8 rd, u8 rs2, u8 rs1, u8 aq, u8 rl)
 	return rv_amo_insn(0, aq, rl, rs2, rs1, 3, rd, 0x2f);
 }
 
+/* RV64-only RVC instructions. */
+
+static inline u16 rvc_ld(u8 rd, u32 imm8, u8 rs1)
+{
+	u32 imm_hi, imm_lo;
+
+	imm_hi = (imm8 & 0x38) >> 3;
+	imm_lo = (imm8 & 0xc0) >> 6;
+	return rv_cl_insn(0x3, imm_hi, rs1, imm_lo, rd, 0x0);
+}
+
+static inline u16 rvc_sd(u8 rs1, u32 imm8, u8 rs2)
+{
+	u32 imm_hi, imm_lo;
+
+	imm_hi = (imm8 & 0x38) >> 3;
+	imm_lo = (imm8 & 0xc0) >> 6;
+	return rv_cs_insn(0x7, imm_hi, rs1, imm_lo, rs2, 0x0);
+}
+
+static inline u16 rvc_subw(u8 rd, u8 rs)
+{
+	return rv_ca_insn(0x27, rd, 0, rs, 0x1);
+}
+
+static inline u16 rvc_addiw(u8 rd, u32 imm6)
+{
+	return rv_ci_insn(0x1, imm6, rd, 0x1);
+}
+
+static inline u16 rvc_ldsp(u8 rd, u32 imm9)
+{
+	u32 imm;
+
+	imm = ((imm9 & 0x1c0) >> 6) | (imm9 & 0x38);
+	return rv_ci_insn(0x3, imm, rd, 0x2);
+}
+
+static inline u16 rvc_sdsp(u32 imm9, u8 rs2)
+{
+	u32 imm;
+
+	imm = (imm9 & 0x38) | ((imm9 & 0x1c0) >> 6);
+	return rv_css_insn(0x7, imm, rs2, 0x2);
+}
+
+#endif /* __riscv_xlen == 64 */
+
+/* Helper functions that emit RVC instructions when possible. */
+
+static inline void emit_jalr(u8 rd, u8 rs, s32 imm, struct rv_jit_context *ctx)
+{
+	if (rvc_enabled() && rd == RV_REG_RA && rs && !imm)
+		emitc(rvc_jalr(rs), ctx);
+	else if (rvc_enabled() && !rd && rs && !imm)
+		emitc(rvc_jr(rs), ctx);
+	else
+		emit(rv_jalr(rd, rs, imm), ctx);
+}
+
+static inline void emit_mv(u8 rd, u8 rs, struct rv_jit_context *ctx)
+{
+	if (rvc_enabled() && rd && rs)
+		emitc(rvc_mv(rd, rs), ctx);
+	else
+		emit(rv_addi(rd, rs, 0), ctx);
+}
+
+static inline void emit_add(u8 rd, u8 rs1, u8 rs2, struct rv_jit_context *ctx)
+{
+	if (rvc_enabled() && rd && rd == rs1 && rs2)
+		emitc(rvc_add(rd, rs2), ctx);
+	else
+		emit(rv_add(rd, rs1, rs2), ctx);
+}
+
+static inline void emit_addi(u8 rd, u8 rs, s32 imm, struct rv_jit_context *ctx)
+{
+	if (rvc_enabled() && rd == RV_REG_SP && rd == rs && is_10b_int(imm) && imm && !(imm & 0xf))
+		emitc(rvc_addi16sp(imm), ctx);
+	else if (rvc_enabled() && is_creg(rd) && rs == RV_REG_SP && is_10b_uint(imm) &&
+		 !(imm & 0x3) && imm)
+		emitc(rvc_addi4spn(rd, imm), ctx);
+	else if (rvc_enabled() && rd && rd == rs && imm && is_6b_int(imm))
+		emitc(rvc_addi(rd, imm), ctx);
+	else
+		emit(rv_addi(rd, rs, imm), ctx);
+}
+
+static inline void emit_li(u8 rd, s32 imm, struct rv_jit_context *ctx)
+{
+	if (rvc_enabled() && rd && is_6b_int(imm))
+		emitc(rvc_li(rd, imm), ctx);
+	else
+		emit(rv_addi(rd, RV_REG_ZERO, imm), ctx);
+}
+
+static inline void emit_lui(u8 rd, s32 imm, struct rv_jit_context *ctx)
+{
+	if (rvc_enabled() && rd && rd != RV_REG_SP && is_6b_int(imm) && imm)
+		emitc(rvc_lui(rd, imm), ctx);
+	else
+		emit(rv_lui(rd, imm), ctx);
+}
+
+static inline void emit_slli(u8 rd, u8 rs, s32 imm, struct rv_jit_context *ctx)
+{
+	if (rvc_enabled() && rd && rd == rs && imm && (u32)imm < __riscv_xlen)
+		emitc(rvc_slli(rd, imm), ctx);
+	else
+		emit(rv_slli(rd, rs, imm), ctx);
+}
+
+static inline void emit_andi(u8 rd, u8 rs, s32 imm, struct rv_jit_context *ctx)
+{
+	if (rvc_enabled() && is_creg(rd) && rd == rs && is_6b_int(imm))
+		emitc(rvc_andi(rd, imm), ctx);
+	else
+		emit(rv_andi(rd, rs, imm), ctx);
+}
+
+static inline void emit_srli(u8 rd, u8 rs, s32 imm, struct rv_jit_context *ctx)
+{
+	if (rvc_enabled() && is_creg(rd) && rd == rs && imm && (u32)imm < __riscv_xlen)
+		emitc(rvc_srli(rd, imm), ctx);
+	else
+		emit(rv_srli(rd, rs, imm), ctx);
+}
+
+static inline void emit_srai(u8 rd, u8 rs, s32 imm, struct rv_jit_context *ctx)
+{
+	if (rvc_enabled() && is_creg(rd) && rd == rs && imm && (u32)imm < __riscv_xlen)
+		emitc(rvc_srai(rd, imm), ctx);
+	else
+		emit(rv_srai(rd, rs, imm), ctx);
+}
+
+static inline void emit_sub(u8 rd, u8 rs1, u8 rs2, struct rv_jit_context *ctx)
+{
+	if (rvc_enabled() && is_creg(rd) && rd == rs1 && is_creg(rs2))
+		emitc(rvc_sub(rd, rs2), ctx);
+	else
+		emit(rv_sub(rd, rs1, rs2), ctx);
+}
+
+static inline void emit_or(u8 rd, u8 rs1, u8 rs2, struct rv_jit_context *ctx)
+{
+	if (rvc_enabled() && is_creg(rd) && rd == rs1 && is_creg(rs2))
+		emitc(rvc_or(rd, rs2), ctx);
+	else
+		emit(rv_or(rd, rs1, rs2), ctx);
+}
+
+static inline void emit_and(u8 rd, u8 rs1, u8 rs2, struct rv_jit_context *ctx)
+{
+	if (rvc_enabled() && is_creg(rd) && rd == rs1 && is_creg(rs2))
+		emitc(rvc_and(rd, rs2), ctx);
+	else
+		emit(rv_and(rd, rs1, rs2), ctx);
+}
+
+static inline void emit_xor(u8 rd, u8 rs1, u8 rs2, struct rv_jit_context *ctx)
+{
+	if (rvc_enabled() && is_creg(rd) && rd == rs1 && is_creg(rs2))
+		emitc(rvc_xor(rd, rs2), ctx);
+	else
+		emit(rv_xor(rd, rs1, rs2), ctx);
+}
+
+static inline void emit_lw(u8 rd, s32 off, u8 rs1, struct rv_jit_context *ctx)
+{
+	if (rvc_enabled() && rs1 == RV_REG_SP && rd && is_8b_uint(off) && !(off & 0x3))
+		emitc(rvc_lwsp(rd, off), ctx);
+	else if (rvc_enabled() && is_creg(rd) && is_creg(rs1) && is_7b_uint(off) && !(off & 0x3))
+		emitc(rvc_lw(rd, off, rs1), ctx);
+	else
+		emit(rv_lw(rd, off, rs1), ctx);
+}
+
+static inline void emit_sw(u8 rs1, s32 off, u8 rs2, struct rv_jit_context *ctx)
+{
+	if (rvc_enabled() && rs1 == RV_REG_SP && is_8b_uint(off) && !(off & 0x3))
+		emitc(rvc_swsp(off, rs2), ctx);
+	else if (rvc_enabled() && is_creg(rs1) && is_creg(rs2) && is_7b_uint(off) && !(off & 0x3))
+		emitc(rvc_sw(rs1, off, rs2), ctx);
+	else
+		emit(rv_sw(rs1, off, rs2), ctx);
+}
+
+/* RV64-only helper functions. */
+#if __riscv_xlen == 64
+
+static inline void emit_addiw(u8 rd, u8 rs, s32 imm, struct rv_jit_context *ctx)
+{
+	if (rvc_enabled() && rd && rd == rs && is_6b_int(imm))
+		emitc(rvc_addiw(rd, imm), ctx);
+	else
+		emit(rv_addiw(rd, rs, imm), ctx);
+}
+
+static inline void emit_ld(u8 rd, s32 off, u8 rs1, struct rv_jit_context *ctx)
+{
+	if (rvc_enabled() && rs1 == RV_REG_SP && rd && is_9b_uint(off) && !(off & 0x7))
+		emitc(rvc_ldsp(rd, off), ctx);
+	else if (rvc_enabled() && is_creg(rd) && is_creg(rs1) && is_8b_uint(off) && !(off & 0x7))
+		emitc(rvc_ld(rd, off, rs1), ctx);
+	else
+		emit(rv_ld(rd, off, rs1), ctx);
+}
+
+static inline void emit_sd(u8 rs1, s32 off, u8 rs2, struct rv_jit_context *ctx)
+{
+	if (rvc_enabled() && rs1 == RV_REG_SP && is_9b_uint(off) && !(off & 0x7))
+		emitc(rvc_sdsp(off, rs2), ctx);
+	else if (rvc_enabled() && is_creg(rs1) && is_creg(rs2) && is_8b_uint(off) && !(off & 0x7))
+		emitc(rvc_sd(rs1, off, rs2), ctx);
+	else
+		emit(rv_sd(rs1, off, rs2), ctx);
+}
+
+static inline void emit_subw(u8 rd, u8 rs1, u8 rs2, struct rv_jit_context *ctx)
+{
+	if (rvc_enabled() && is_creg(rd) && rd == rs1 && is_creg(rs2))
+		emitc(rvc_subw(rd, rs2), ctx);
+	else
+		emit(rv_subw(rd, rs1, rs2), ctx);
+}
+
 #endif /* __riscv_xlen == 64 */
 
 void bpf_jit_build_prologue(struct rv_jit_context *ctx);
-- 
2.25.1

