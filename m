Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC30E4AC0E2
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 15:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355995AbiBGOQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 09:16:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346678AbiBGONR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 09:13:17 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C912CC0401C0;
        Mon,  7 Feb 2022 06:13:15 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4JsnYz0qd9z1FD1V;
        Mon,  7 Feb 2022 21:49:27 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Mon, 7 Feb
 2022 21:53:36 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <houtao1@huawei.com>, Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <jthierry@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH bpf-next v3 3/4] bpf, arm64: support more atomic operations
Date:   Sun, 30 Jan 2022 06:04:51 +0800
Message-ID: <20220129220452.194585-4-houtao1@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220129220452.194585-1-houtao1@huawei.com>
References: <20220129220452.194585-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Atomics for eBPF patch series adds support for atomic[64]_fetch_add,
atomic[64]_[fetch_]{and,or,xor} and atomic[64]_{xchg|cmpxchg}, but
it only adds support for x86-64, so support these atomic operations
for arm64 as well.

Basically the implementation procedure is almost mechanical translation
of code snippets in atomic_ll_sc.h & atomic_lse.h & cmpxchg.h located
under arch/arm64/include/asm.

When LSE atomic is unavailable, an extra temporary register is needed for
(BPF_ADD | BPF_FETCH) to save the value of src register, instead of adding
TMP_REG_4 just use BPF_REG_AX instead. Also make emit_lse_atomic() as an
empty inline function when CONFIG_ARM64_LSE_ATOMICS is disabled.

For cpus_have_cap(ARM64_HAS_LSE_ATOMICS) case and no-LSE-ATOMICS case, the
following three tests: "./test_verifier", "./test_progs -t atomic" and
"insmod ./test_bpf.ko" are exercised and passed.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 arch/arm64/net/bpf_jit.h      |  44 ++++++-
 arch/arm64/net/bpf_jit_comp.c | 223 +++++++++++++++++++++++++++-------
 2 files changed, 223 insertions(+), 44 deletions(-)

diff --git a/arch/arm64/net/bpf_jit.h b/arch/arm64/net/bpf_jit.h
index cc0cf0f5c7c3..dd59b5ad8fe4 100644
--- a/arch/arm64/net/bpf_jit.h
+++ b/arch/arm64/net/bpf_jit.h
@@ -88,10 +88,42 @@
 /* [Rn] = Rt; (atomic) Rs = [state] */
 #define A64_STXR(sf, Rt, Rn, Rs) \
 	A64_LSX(sf, Rt, Rn, Rs, STORE_EX)
+/* [Rn] = Rt (store release); (atomic) Rs = [state] */
+#define A64_STLXR(sf, Rt, Rn, Rs) \
+	aarch64_insn_gen_load_store_ex(Rt, Rn, Rs, A64_SIZE(sf), \
+				       AARCH64_INSN_LDST_STORE_REL_EX)
+
+/*
+ * LSE atomics
+ *
+ * ST{ADD,CLR,SET,EOR} is simply encoded as an alias for
+ * LDD{ADD,CLR,SET,EOR} with XZR as the destination register.
+ */
+#define A64_ST_OP(sf, Rn, Rs, op) \
+	aarch64_insn_gen_atomic_ld_op(A64_ZR, Rn, Rs, \
+		A64_SIZE(sf), AARCH64_INSN_MEM_ATOMIC_##op, \
+		AARCH64_INSN_MEM_ORDER_NONE)
+/* [Rn] <op>= Rs */
+#define A64_STADD(sf, Rn, Rs) A64_ST_OP(sf, Rn, Rs, ADD)
+#define A64_STCLR(sf, Rn, Rs) A64_ST_OP(sf, Rn, Rs, CLR)
+#define A64_STEOR(sf, Rn, Rs) A64_ST_OP(sf, Rn, Rs, EOR)
+#define A64_STSET(sf, Rn, Rs) A64_ST_OP(sf, Rn, Rs, SET)
 
-/* LSE atomics */
-#define A64_STADD(sf, Rn, Rs) \
-	aarch64_insn_gen_stadd(Rn, Rs, A64_SIZE(sf))
+#define A64_LD_OP_AL(sf, Rt, Rn, Rs, op) \
+	aarch64_insn_gen_atomic_ld_op(Rt, Rn, Rs, \
+		A64_SIZE(sf), AARCH64_INSN_MEM_ATOMIC_##op, \
+		AARCH64_INSN_MEM_ORDER_ACQREL)
+/* Rt = [Rn] (load acquire); [Rn] <op>= Rs (store release) */
+#define A64_LDADDAL(sf, Rt, Rn, Rs) A64_LD_OP_AL(sf, Rt, Rn, Rs, ADD)
+#define A64_LDCLRAL(sf, Rt, Rn, Rs) A64_LD_OP_AL(sf, Rt, Rn, Rs, CLR)
+#define A64_LDEORAL(sf, Rt, Rn, Rs) A64_LD_OP_AL(sf, Rt, Rn, Rs, EOR)
+#define A64_LDSETAL(sf, Rt, Rn, Rs) A64_LD_OP_AL(sf, Rt, Rn, Rs, SET)
+/* Rt = [Rn] (load acquire); [Rn] = Rs (store release) */
+#define A64_SWPAL(sf, Rt, Rn, Rs) A64_LD_OP_AL(sf, Rt, Rn, Rs, SWP)
+/* Rs = CAS(Rn, Rs, Rt) (load acquire & store release) */
+#define A64_CASAL(sf, Rt, Rn, Rs) \
+	aarch64_insn_gen_cas(Rt, Rn, Rs, A64_SIZE(sf), \
+		AARCH64_INSN_MEM_ORDER_ACQREL)
 
 /* Add/subtract (immediate) */
 #define A64_ADDSUB_IMM(sf, Rd, Rn, imm12, type) \
@@ -196,6 +228,9 @@
 #define A64_ANDS(sf, Rd, Rn, Rm) A64_LOGIC_SREG(sf, Rd, Rn, Rm, AND_SETFLAGS)
 /* Rn & Rm; set condition flags */
 #define A64_TST(sf, Rn, Rm) A64_ANDS(sf, A64_ZR, Rn, Rm)
+/* Rd = ~Rm (alias of ORN with A64_ZR as Rn) */
+#define A64_MVN(sf, Rd, Rm)  \
+	A64_LOGIC_SREG(sf, Rd, A64_ZR, Rm, ORN)
 
 /* Logical (immediate) */
 #define A64_LOGIC_IMM(sf, Rd, Rn, imm, type) ({ \
@@ -219,4 +254,7 @@
 #define A64_BTI_J  A64_HINT(AARCH64_INSN_HINT_BTIJ)
 #define A64_BTI_JC A64_HINT(AARCH64_INSN_HINT_BTIJC)
 
+/* DMB */
+#define A64_DMB_ISH aarch64_insn_gen_dmb(AARCH64_INSN_MB_ISH)
+
 #endif /* _BPF_JIT_H */
diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 74f9a9b6a053..2375ed3e4c8a 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -27,6 +27,17 @@
 #define TCALL_CNT (MAX_BPF_JIT_REG + 2)
 #define TMP_REG_3 (MAX_BPF_JIT_REG + 3)
 
+#define check_imm(bits, imm) do {				\
+	if ((((imm) > 0) && ((imm) >> (bits))) ||		\
+	    (((imm) < 0) && (~(imm) >> (bits)))) {		\
+		pr_info("[%2d] imm=%d(0x%x) out of range\n",	\
+			i, imm, imm);				\
+		return -EINVAL;					\
+	}							\
+} while (0)
+#define check_imm19(imm) check_imm(19, imm)
+#define check_imm26(imm) check_imm(26, imm)
+
 /* Map BPF registers to A64 registers */
 static const int bpf2a64[] = {
 	/* return value from in-kernel function, and exit value from eBPF */
@@ -329,6 +340,170 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx)
 #undef jmp_offset
 }
 
+#ifdef CONFIG_ARM64_LSE_ATOMICS
+static int emit_lse_atomic(const struct bpf_insn *insn, struct jit_ctx *ctx)
+{
+	const u8 code = insn->code;
+	const u8 dst = bpf2a64[insn->dst_reg];
+	const u8 src = bpf2a64[insn->src_reg];
+	const u8 tmp = bpf2a64[TMP_REG_1];
+	const u8 tmp2 = bpf2a64[TMP_REG_2];
+	const bool isdw = BPF_SIZE(code) == BPF_DW;
+	const s16 off = insn->off;
+	u8 reg;
+
+	if (!off) {
+		reg = dst;
+	} else {
+		emit_a64_mov_i(1, tmp, off, ctx);
+		emit(A64_ADD(1, tmp, tmp, dst), ctx);
+		reg = tmp;
+	}
+
+	switch (insn->imm) {
+	/* lock *(u32/u64 *)(dst_reg + off) <op>= src_reg */
+	case BPF_ADD:
+		emit(A64_STADD(isdw, reg, src), ctx);
+		break;
+	case BPF_AND:
+		emit(A64_MVN(isdw, tmp2, src), ctx);
+		emit(A64_STCLR(isdw, reg, tmp2), ctx);
+		break;
+	case BPF_OR:
+		emit(A64_STSET(isdw, reg, src), ctx);
+		break;
+	case BPF_XOR:
+		emit(A64_STEOR(isdw, reg, src), ctx);
+		break;
+	/* src_reg = atomic_fetch_<op>(dst_reg + off, src_reg) */
+	case BPF_ADD | BPF_FETCH:
+		emit(A64_LDADDAL(isdw, src, reg, src), ctx);
+		break;
+	case BPF_AND | BPF_FETCH:
+		emit(A64_MVN(isdw, tmp2, src), ctx);
+		emit(A64_LDCLRAL(isdw, src, reg, tmp2), ctx);
+		break;
+	case BPF_OR | BPF_FETCH:
+		emit(A64_LDSETAL(isdw, src, reg, src), ctx);
+		break;
+	case BPF_XOR | BPF_FETCH:
+		emit(A64_LDEORAL(isdw, src, reg, src), ctx);
+		break;
+	/* src_reg = atomic_xchg(dst_reg + off, src_reg); */
+	case BPF_XCHG:
+		emit(A64_SWPAL(isdw, src, reg, src), ctx);
+		break;
+	/* r0 = atomic_cmpxchg(dst_reg + off, r0, src_reg); */
+	case BPF_CMPXCHG:
+		emit(A64_CASAL(isdw, src, reg, bpf2a64[BPF_REG_0]), ctx);
+		break;
+	default:
+		pr_err_once("unknown atomic op code %02x\n", insn->imm);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+#else
+static inline int emit_lse_atomic(const struct bpf_insn *insn, struct jit_ctx *ctx)
+{
+	return -EINVAL;
+}
+#endif
+
+static int emit_ll_sc_atomic(const struct bpf_insn *insn, struct jit_ctx *ctx)
+{
+	const u8 code = insn->code;
+	const u8 dst = bpf2a64[insn->dst_reg];
+	const u8 src = bpf2a64[insn->src_reg];
+	const u8 tmp = bpf2a64[TMP_REG_1];
+	const u8 tmp2 = bpf2a64[TMP_REG_2];
+	const u8 tmp3 = bpf2a64[TMP_REG_3];
+	const int i = insn - ctx->prog->insnsi;
+	const s32 imm = insn->imm;
+	const s16 off = insn->off;
+	const bool isdw = BPF_SIZE(code) == BPF_DW;
+	u8 reg;
+	s32 jmp_offset;
+
+	if (!off) {
+		reg = dst;
+	} else {
+		emit_a64_mov_i(1, tmp, off, ctx);
+		emit(A64_ADD(1, tmp, tmp, dst), ctx);
+		reg = tmp;
+	}
+
+	if (imm == BPF_ADD || imm == BPF_AND ||
+	    imm == BPF_OR || imm == BPF_XOR) {
+		/* lock *(u32/u64 *)(dst_reg + off) <op>= src_reg */
+		emit(A64_LDXR(isdw, tmp2, reg), ctx);
+		if (imm == BPF_ADD)
+			emit(A64_ADD(isdw, tmp2, tmp2, src), ctx);
+		else if (imm == BPF_AND)
+			emit(A64_AND(isdw, tmp2, tmp2, src), ctx);
+		else if (imm == BPF_OR)
+			emit(A64_ORR(isdw, tmp2, tmp2, src), ctx);
+		else
+			emit(A64_EOR(isdw, tmp2, tmp2, src), ctx);
+		emit(A64_STXR(isdw, tmp2, reg, tmp3), ctx);
+		jmp_offset = -3;
+		check_imm19(jmp_offset);
+		emit(A64_CBNZ(0, tmp3, jmp_offset), ctx);
+	} else if (imm == (BPF_ADD | BPF_FETCH) ||
+		   imm == (BPF_AND | BPF_FETCH) ||
+		   imm == (BPF_OR | BPF_FETCH) ||
+		   imm == (BPF_XOR | BPF_FETCH)) {
+		/* src_reg = atomic_fetch_<op>(dst_reg + off, src_reg) */
+		const u8 ax = bpf2a64[BPF_REG_AX];
+
+		emit(A64_MOV(isdw, ax, src), ctx);
+		emit(A64_LDXR(isdw, src, reg), ctx);
+		if (imm == (BPF_ADD | BPF_FETCH))
+			emit(A64_ADD(isdw, tmp2, src, ax), ctx);
+		else if (imm == (BPF_AND | BPF_FETCH))
+			emit(A64_AND(isdw, tmp2, src, ax), ctx);
+		else if (imm == (BPF_OR | BPF_FETCH))
+			emit(A64_ORR(isdw, tmp2, src, ax), ctx);
+		else
+			emit(A64_EOR(isdw, tmp2, src, ax), ctx);
+		emit(A64_STLXR(isdw, tmp2, reg, tmp3), ctx);
+		jmp_offset = -3;
+		check_imm19(jmp_offset);
+		emit(A64_CBNZ(0, tmp3, jmp_offset), ctx);
+		emit(A64_DMB_ISH, ctx);
+	} else if (imm == BPF_XCHG) {
+		/* src_reg = atomic_xchg(dst_reg + off, src_reg); */
+		emit(A64_MOV(isdw, tmp2, src), ctx);
+		emit(A64_LDXR(isdw, src, reg), ctx);
+		emit(A64_STLXR(isdw, tmp2, reg, tmp3), ctx);
+		jmp_offset = -2;
+		check_imm19(jmp_offset);
+		emit(A64_CBNZ(0, tmp3, jmp_offset), ctx);
+		emit(A64_DMB_ISH, ctx);
+	} else if (imm == BPF_CMPXCHG) {
+		/* r0 = atomic_cmpxchg(dst_reg + off, r0, src_reg); */
+		const u8 r0 = bpf2a64[BPF_REG_0];
+
+		emit(A64_MOV(isdw, tmp2, r0), ctx);
+		emit(A64_LDXR(isdw, r0, reg), ctx);
+		emit(A64_EOR(isdw, tmp3, r0, tmp2), ctx);
+		jmp_offset = 4;
+		check_imm19(jmp_offset);
+		emit(A64_CBNZ(isdw, tmp3, jmp_offset), ctx);
+		emit(A64_STLXR(isdw, src, reg, tmp3), ctx);
+		jmp_offset = -4;
+		check_imm19(jmp_offset);
+		emit(A64_CBNZ(0, tmp3, jmp_offset), ctx);
+		emit(A64_DMB_ISH, ctx);
+	} else {
+		pr_err_once("unknown atomic op code %02x\n", imm);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static void build_epilogue(struct jit_ctx *ctx)
 {
 	const u8 r0 = bpf2a64[BPF_REG_0];
@@ -434,29 +609,16 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	const u8 src = bpf2a64[insn->src_reg];
 	const u8 tmp = bpf2a64[TMP_REG_1];
 	const u8 tmp2 = bpf2a64[TMP_REG_2];
-	const u8 tmp3 = bpf2a64[TMP_REG_3];
 	const s16 off = insn->off;
 	const s32 imm = insn->imm;
 	const int i = insn - ctx->prog->insnsi;
 	const bool is64 = BPF_CLASS(code) == BPF_ALU64 ||
 			  BPF_CLASS(code) == BPF_JMP;
-	const bool isdw = BPF_SIZE(code) == BPF_DW;
-	u8 jmp_cond, reg;
+	u8 jmp_cond;
 	s32 jmp_offset;
 	u32 a64_insn;
 	int ret;
 
-#define check_imm(bits, imm) do {				\
-	if ((((imm) > 0) && ((imm) >> (bits))) ||		\
-	    (((imm) < 0) && (~(imm) >> (bits)))) {		\
-		pr_info("[%2d] imm=%d(0x%x) out of range\n",	\
-			i, imm, imm);				\
-		return -EINVAL;					\
-	}							\
-} while (0)
-#define check_imm19(imm) check_imm(19, imm)
-#define check_imm26(imm) check_imm(26, imm)
-
 	switch (code) {
 	/* dst = src */
 	case BPF_ALU | BPF_MOV | BPF_X:
@@ -891,33 +1053,12 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 
 	case BPF_STX | BPF_ATOMIC | BPF_W:
 	case BPF_STX | BPF_ATOMIC | BPF_DW:
-		if (insn->imm != BPF_ADD) {
-			pr_err_once("unknown atomic op code %02x\n", insn->imm);
-			return -EINVAL;
-		}
-
-		/* STX XADD: lock *(u32 *)(dst + off) += src
-		 * and
-		 * STX XADD: lock *(u64 *)(dst + off) += src
-		 */
-
-		if (!off) {
-			reg = dst;
-		} else {
-			emit_a64_mov_i(1, tmp, off, ctx);
-			emit(A64_ADD(1, tmp, tmp, dst), ctx);
-			reg = tmp;
-		}
-		if (cpus_have_cap(ARM64_HAS_LSE_ATOMICS)) {
-			emit(A64_STADD(isdw, reg, src), ctx);
-		} else {
-			emit(A64_LDXR(isdw, tmp2, reg), ctx);
-			emit(A64_ADD(isdw, tmp2, tmp2, src), ctx);
-			emit(A64_STXR(isdw, tmp2, reg, tmp3), ctx);
-			jmp_offset = -3;
-			check_imm19(jmp_offset);
-			emit(A64_CBNZ(0, tmp3, jmp_offset), ctx);
-		}
+		if (cpus_have_cap(ARM64_HAS_LSE_ATOMICS))
+			ret = emit_lse_atomic(insn, ctx);
+		else
+			ret = emit_ll_sc_atomic(insn, ctx);
+		if (ret)
+			return ret;
 		break;
 
 	default:
-- 
2.27.0

