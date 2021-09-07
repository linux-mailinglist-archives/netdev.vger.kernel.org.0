Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F56E4030F0
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 00:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348615AbhIGWZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 18:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348085AbhIGWZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 18:25:02 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71186C0617A8
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 15:23:54 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id g22so30862edy.12
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 15:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ch5Oo1oq8i1LcY9ozSfNlxFm0FOEnR5Hv+KS3NKiJvg=;
        b=VN8VE94cysfKu//qVGAZCdglLsljT0DLn5EdDSCyiRskhwndrJUa6G6w55XuQDsnbN
         nDG03jLFZJXxtZMTtHJi0uYjIBhh4fkjCOKLcR4h18bI1ceEmr0LBLZ5u16+nBK2shzk
         wpTL4y1G4v+xBgGwO9z1nhiIcl/fzZ6O2ujxlO+6W9xHCDqaoO4WfqmpxTLiYjlmjVBH
         FioawrK/OP3PtzmtwDYeEjTVdapK82xap9laEFP0/+sL/u/xLibFONh/waKqc6Jg4eWX
         HtR4TciZ5t+IyEjZEfBqdAOFnqpkA9h1Ge+9c1Irx63JCArL3yUfs7WsbJzqb27tZNO6
         Qqsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ch5Oo1oq8i1LcY9ozSfNlxFm0FOEnR5Hv+KS3NKiJvg=;
        b=AMRP34L2Bd+DNXvxPXcISG/y58TtoctNuJotyK4/b1E51IrkjMWVGm3d+3n/BsKyQ7
         QDQMMFshM/tPUlPozBfir0C8zQmIZMujw2pR0R+XZpAiqEwnC0HZYmyAx6EMEgatITLj
         TpjcnoRi6T7z159/XN77GUlB0Vrb+Y1DcXIE2uQvZ+C9jKWmVhJOPpJ4hLhh45vfUgX4
         bZAWB7PEMaG63OvbUwJ6yL3MaMfqMGk7N/9POtnH7IPW0EUwhN6uz940voU61ZPrFWHm
         ns+0L229987uGAX9PERDQQ6K08sdePWykFQ1+GIPzKCjuJDscVC9tlfznJ6afnlptF9B
         W4NQ==
X-Gm-Message-State: AOAM533DYXSu5yhRzIENjpXHv9RloJsNuabeSmKWQsnJrXVPNnljg5P8
        IsOKMi5/rlGt4fr6ka4eDGVD4Q==
X-Google-Smtp-Source: ABdhPJzDUpSeuKwRJcZ81gJmPxBR4vE/+7X0KywCvCrvPxih76lXtBKZDn3QTQ4mXi0sWXYHQ9u89Q==
X-Received: by 2002:aa7:c408:: with SMTP id j8mr528045edq.280.1631053433031;
        Tue, 07 Sep 2021 15:23:53 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id gb24sm71772ejc.53.2021.09.07.15.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 15:23:52 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next v2 04/13] bpf/tests: Add exhaustive tests of ALU operand magnitudes
Date:   Wed,  8 Sep 2021 00:23:30 +0200
Message-Id: <20210907222339.4130924-5-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210907222339.4130924-1-johan.almbladh@anyfinetworks.com>
References: <20210907222339.4130924-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a set of tests for ALU64 and ALU32 arithmetic and bitwise
logical operations to verify correctness for all possible magnitudes of
the register and immediate operands. Mainly intended for JIT testing.

The patch introduces a pattern generator that can be used to drive
extensive tests of different kinds of operations. It is parameterized
to allow tuning of the operand combinations to test.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 772 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 772 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index f76472c050a7..7992004bc876 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -659,6 +659,451 @@ static int bpf_fill_alu32_arsh_reg(struct bpf_test *self)
 	return __bpf_fill_alu_shift(self, BPF_ARSH, BPF_X, true);
 }
 
+/*
+ * Common operand pattern generator for exhaustive power-of-two magnitudes
+ * tests. The block size parameters can be adjusted to increase/reduce the
+ * number of combinatons tested and thereby execution speed and memory
+ * footprint.
+ */
+
+static inline s64 value(int msb, int delta, int sign)
+{
+	return sign * (1LL << msb) + delta;
+}
+
+static int __bpf_fill_pattern(struct bpf_test *self, void *arg,
+			      int dbits, int sbits, int block1, int block2,
+			      int (*emit)(struct bpf_test*, void*,
+					  struct bpf_insn*, s64, s64))
+{
+	static const int sgn[][2] = {{1, 1}, {1, -1}, {-1, 1}, {-1, -1}};
+	struct bpf_insn *insns;
+	int di, si, bt, db, sb;
+	int count, len, k;
+	int extra = 1 + 2;
+	int i = 0;
+
+	/* Total number of iterations for the two pattern */
+	count = (dbits - 1) * (sbits - 1) * block1 * block1 * ARRAY_SIZE(sgn);
+	count += (max(dbits, sbits) - 1) * block2 * block2 * ARRAY_SIZE(sgn);
+
+	/* Compute the maximum number of insns and allocate the buffer */
+	len = extra + count * (*emit)(self, arg, NULL, 0, 0);
+	insns = kmalloc_array(len, sizeof(*insns), GFP_KERNEL);
+	if (!insns)
+		return -ENOMEM;
+
+	/* Add head instruction(s) */
+	insns[i++] = BPF_ALU64_IMM(BPF_MOV, R0, 0);
+
+	/*
+	 * Pattern 1: all combinations of power-of-two magnitudes and sign,
+	 * and with a block of contiguous values around each magnitude.
+	 */
+	for (di = 0; di < dbits - 1; di++)                 /* Dst magnitudes */
+		for (si = 0; si < sbits - 1; si++)         /* Src magnitudes */
+			for (k = 0; k < ARRAY_SIZE(sgn); k++) /* Sign combos */
+				for (db = -(block1 / 2);
+				     db < (block1 + 1) / 2; db++)
+					for (sb = -(block1 / 2);
+					     sb < (block1 + 1) / 2; sb++) {
+						s64 dst, src;
+
+						dst = value(di, db, sgn[k][0]);
+						src = value(si, sb, sgn[k][1]);
+						i += (*emit)(self, arg,
+							     &insns[i],
+							     dst, src);
+					}
+	/*
+	 * Pattern 2: all combinations for a larger block of values
+	 * for each power-of-two magnitude and sign, where the magnitude is
+	 * the same for both operands.
+	 */
+	for (bt = 0; bt < max(dbits, sbits) - 1; bt++)        /* Magnitude   */
+		for (k = 0; k < ARRAY_SIZE(sgn); k++)         /* Sign combos */
+			for (db = -(block2 / 2); db < (block2 + 1) / 2; db++)
+				for (sb = -(block2 / 2);
+				     sb < (block2 + 1) / 2; sb++) {
+					s64 dst, src;
+
+					dst = value(bt % dbits, db, sgn[k][0]);
+					src = value(bt % sbits, sb, sgn[k][1]);
+					i += (*emit)(self, arg, &insns[i],
+						     dst, src);
+				}
+
+	/* Append tail instructions */
+	insns[i++] = BPF_ALU64_IMM(BPF_MOV, R0, 1);
+	insns[i++] = BPF_EXIT_INSN();
+	BUG_ON(i > len);
+
+	self->u.ptr.insns = insns;
+	self->u.ptr.len = i;
+
+	return 0;
+}
+
+/*
+ * Block size parameters used in pattern tests below. une as needed to
+ * increase/reduce the number combinations tested, see following examples.
+ *        block   values per operand MSB
+ * ----------------------------------------
+ *           0     none
+ *           1     (1 << MSB)
+ *           2     (1 << MSB) + [-1, 0]
+ *           3     (1 << MSB) + [-1, 0, 1]
+ */
+#define PATTERN_BLOCK1 1
+#define PATTERN_BLOCK2 5
+
+/* Number of test runs for a pattern test */
+#define NR_PATTERN_RUNS 1
+
+/*
+ * Exhaustive tests of ALU operations for all combinations of power-of-two
+ * magnitudes of the operands, both for positive and negative values. The
+ * test is designed to verify e.g. the JMP and JMP32 operations for JITs that
+ * emit different code depending on the magnitude of the immediate value.
+ */
+
+static bool __bpf_alu_result(u64 *res, u64 v1, u64 v2, u8 op)
+{
+	*res = 0;
+	switch (op) {
+	case BPF_MOV:
+		*res = v2;
+		break;
+	case BPF_AND:
+		*res = v1 & v2;
+		break;
+	case BPF_OR:
+		*res = v1 | v2;
+		break;
+	case BPF_XOR:
+		*res = v1 ^ v2;
+		break;
+	case BPF_ADD:
+		*res = v1 + v2;
+		break;
+	case BPF_SUB:
+		*res = v1 - v2;
+		break;
+	case BPF_MUL:
+		*res = v1 * v2;
+		break;
+	case BPF_DIV:
+		if (v2 == 0)
+			return false;
+		*res = div64_u64(v1, v2);
+		break;
+	case BPF_MOD:
+		if (v2 == 0)
+			return false;
+		div64_u64_rem(v1, v2, res);
+		break;
+	}
+	return true;
+}
+
+static int __bpf_emit_alu64_imm(struct bpf_test *self, void *arg,
+				struct bpf_insn *insns, s64 dst, s64 imm)
+{
+	int op = *(int *)arg;
+	int i = 0;
+	u64 res;
+
+	if (!insns)
+		return 7;
+
+	if (__bpf_alu_result(&res, dst, (s32)imm, op)) {
+		i += __bpf_ld_imm64(&insns[i], R1, dst);
+		i += __bpf_ld_imm64(&insns[i], R3, res);
+		insns[i++] = BPF_ALU64_IMM(op, R1, imm);
+		insns[i++] = BPF_JMP_REG(BPF_JEQ, R1, R3, 1);
+		insns[i++] = BPF_EXIT_INSN();
+	}
+
+	return i;
+}
+
+static int __bpf_emit_alu32_imm(struct bpf_test *self, void *arg,
+				struct bpf_insn *insns, s64 dst, s64 imm)
+{
+	int op = *(int *)arg;
+	int i = 0;
+	u64 res;
+
+	if (!insns)
+		return 7;
+
+	if (__bpf_alu_result(&res, (u32)dst, (u32)imm, op)) {
+		i += __bpf_ld_imm64(&insns[i], R1, dst);
+		i += __bpf_ld_imm64(&insns[i], R3, (u32)res);
+		insns[i++] = BPF_ALU32_IMM(op, R1, imm);
+		insns[i++] = BPF_JMP_REG(BPF_JEQ, R1, R3, 1);
+		insns[i++] = BPF_EXIT_INSN();
+	}
+
+	return i;
+}
+
+static int __bpf_emit_alu64_reg(struct bpf_test *self, void *arg,
+				struct bpf_insn *insns, s64 dst, s64 src)
+{
+	int op = *(int *)arg;
+	int i = 0;
+	u64 res;
+
+	if (!insns)
+		return 9;
+
+	if (__bpf_alu_result(&res, dst, src, op)) {
+		i += __bpf_ld_imm64(&insns[i], R1, dst);
+		i += __bpf_ld_imm64(&insns[i], R2, src);
+		i += __bpf_ld_imm64(&insns[i], R3, res);
+		insns[i++] = BPF_ALU64_REG(op, R1, R2);
+		insns[i++] = BPF_JMP_REG(BPF_JEQ, R1, R3, 1);
+		insns[i++] = BPF_EXIT_INSN();
+	}
+
+	return i;
+}
+
+static int __bpf_emit_alu32_reg(struct bpf_test *self, void *arg,
+				struct bpf_insn *insns, s64 dst, s64 src)
+{
+	int op = *(int *)arg;
+	int i = 0;
+	u64 res;
+
+	if (!insns)
+		return 9;
+
+	if (__bpf_alu_result(&res, (u32)dst, (u32)src, op)) {
+		i += __bpf_ld_imm64(&insns[i], R1, dst);
+		i += __bpf_ld_imm64(&insns[i], R2, src);
+		i += __bpf_ld_imm64(&insns[i], R3, (u32)res);
+		insns[i++] = BPF_ALU32_REG(op, R1, R2);
+		insns[i++] = BPF_JMP_REG(BPF_JEQ, R1, R3, 1);
+		insns[i++] = BPF_EXIT_INSN();
+	}
+
+	return i;
+}
+
+static int __bpf_fill_alu64_imm(struct bpf_test *self, int op)
+{
+	return __bpf_fill_pattern(self, &op, 64, 32,
+				  PATTERN_BLOCK1, PATTERN_BLOCK2,
+				  &__bpf_emit_alu64_imm);
+}
+
+static int __bpf_fill_alu32_imm(struct bpf_test *self, int op)
+{
+	return __bpf_fill_pattern(self, &op, 64, 32,
+				  PATTERN_BLOCK1, PATTERN_BLOCK2,
+				  &__bpf_emit_alu32_imm);
+}
+
+static int __bpf_fill_alu64_reg(struct bpf_test *self, int op)
+{
+	return __bpf_fill_pattern(self, &op, 64, 64,
+				  PATTERN_BLOCK1, PATTERN_BLOCK2,
+				  &__bpf_emit_alu64_reg);
+}
+
+static int __bpf_fill_alu32_reg(struct bpf_test *self, int op)
+{
+	return __bpf_fill_pattern(self, &op, 64, 64,
+				  PATTERN_BLOCK1, PATTERN_BLOCK2,
+				  &__bpf_emit_alu32_reg);
+}
+
+/* ALU64 immediate operations */
+static int bpf_fill_alu64_mov_imm(struct bpf_test *self)
+{
+	return __bpf_fill_alu64_imm(self, BPF_MOV);
+}
+
+static int bpf_fill_alu64_and_imm(struct bpf_test *self)
+{
+	return __bpf_fill_alu64_imm(self, BPF_AND);
+}
+
+static int bpf_fill_alu64_or_imm(struct bpf_test *self)
+{
+	return __bpf_fill_alu64_imm(self, BPF_OR);
+}
+
+static int bpf_fill_alu64_xor_imm(struct bpf_test *self)
+{
+	return __bpf_fill_alu64_imm(self, BPF_XOR);
+}
+
+static int bpf_fill_alu64_add_imm(struct bpf_test *self)
+{
+	return __bpf_fill_alu64_imm(self, BPF_ADD);
+}
+
+static int bpf_fill_alu64_sub_imm(struct bpf_test *self)
+{
+	return __bpf_fill_alu64_imm(self, BPF_SUB);
+}
+
+static int bpf_fill_alu64_mul_imm(struct bpf_test *self)
+{
+	return __bpf_fill_alu64_imm(self, BPF_MUL);
+}
+
+static int bpf_fill_alu64_div_imm(struct bpf_test *self)
+{
+	return __bpf_fill_alu64_imm(self, BPF_DIV);
+}
+
+static int bpf_fill_alu64_mod_imm(struct bpf_test *self)
+{
+	return __bpf_fill_alu64_imm(self, BPF_MOD);
+}
+
+/* ALU32 immediate operations */
+static int bpf_fill_alu32_mov_imm(struct bpf_test *self)
+{
+	return __bpf_fill_alu32_imm(self, BPF_MOV);
+}
+
+static int bpf_fill_alu32_and_imm(struct bpf_test *self)
+{
+	return __bpf_fill_alu32_imm(self, BPF_AND);
+}
+
+static int bpf_fill_alu32_or_imm(struct bpf_test *self)
+{
+	return __bpf_fill_alu32_imm(self, BPF_OR);
+}
+
+static int bpf_fill_alu32_xor_imm(struct bpf_test *self)
+{
+	return __bpf_fill_alu32_imm(self, BPF_XOR);
+}
+
+static int bpf_fill_alu32_add_imm(struct bpf_test *self)
+{
+	return __bpf_fill_alu32_imm(self, BPF_ADD);
+}
+
+static int bpf_fill_alu32_sub_imm(struct bpf_test *self)
+{
+	return __bpf_fill_alu32_imm(self, BPF_SUB);
+}
+
+static int bpf_fill_alu32_mul_imm(struct bpf_test *self)
+{
+	return __bpf_fill_alu32_imm(self, BPF_MUL);
+}
+
+static int bpf_fill_alu32_div_imm(struct bpf_test *self)
+{
+	return __bpf_fill_alu32_imm(self, BPF_DIV);
+}
+
+static int bpf_fill_alu32_mod_imm(struct bpf_test *self)
+{
+	return __bpf_fill_alu32_imm(self, BPF_MOD);
+}
+
+/* ALU64 register operations */
+static int bpf_fill_alu64_mov_reg(struct bpf_test *self)
+{
+	return __bpf_fill_alu64_reg(self, BPF_MOV);
+}
+
+static int bpf_fill_alu64_and_reg(struct bpf_test *self)
+{
+	return __bpf_fill_alu64_reg(self, BPF_AND);
+}
+
+static int bpf_fill_alu64_or_reg(struct bpf_test *self)
+{
+	return __bpf_fill_alu64_reg(self, BPF_OR);
+}
+
+static int bpf_fill_alu64_xor_reg(struct bpf_test *self)
+{
+	return __bpf_fill_alu64_reg(self, BPF_XOR);
+}
+
+static int bpf_fill_alu64_add_reg(struct bpf_test *self)
+{
+	return __bpf_fill_alu64_reg(self, BPF_ADD);
+}
+
+static int bpf_fill_alu64_sub_reg(struct bpf_test *self)
+{
+	return __bpf_fill_alu64_reg(self, BPF_SUB);
+}
+
+static int bpf_fill_alu64_mul_reg(struct bpf_test *self)
+{
+	return __bpf_fill_alu64_reg(self, BPF_MUL);
+}
+
+static int bpf_fill_alu64_div_reg(struct bpf_test *self)
+{
+	return __bpf_fill_alu64_reg(self, BPF_DIV);
+}
+
+static int bpf_fill_alu64_mod_reg(struct bpf_test *self)
+{
+	return __bpf_fill_alu64_reg(self, BPF_MOD);
+}
+
+/* ALU32 register operations */
+static int bpf_fill_alu32_mov_reg(struct bpf_test *self)
+{
+	return __bpf_fill_alu32_reg(self, BPF_MOV);
+}
+
+static int bpf_fill_alu32_and_reg(struct bpf_test *self)
+{
+	return __bpf_fill_alu32_reg(self, BPF_AND);
+}
+
+static int bpf_fill_alu32_or_reg(struct bpf_test *self)
+{
+	return __bpf_fill_alu32_reg(self, BPF_OR);
+}
+
+static int bpf_fill_alu32_xor_reg(struct bpf_test *self)
+{
+	return __bpf_fill_alu32_reg(self, BPF_XOR);
+}
+
+static int bpf_fill_alu32_add_reg(struct bpf_test *self)
+{
+	return __bpf_fill_alu32_reg(self, BPF_ADD);
+}
+
+static int bpf_fill_alu32_sub_reg(struct bpf_test *self)
+{
+	return __bpf_fill_alu32_reg(self, BPF_SUB);
+}
+
+static int bpf_fill_alu32_mul_reg(struct bpf_test *self)
+{
+	return __bpf_fill_alu32_reg(self, BPF_MUL);
+}
+
+static int bpf_fill_alu32_div_reg(struct bpf_test *self)
+{
+	return __bpf_fill_alu32_reg(self, BPF_DIV);
+}
+
+static int bpf_fill_alu32_mod_reg(struct bpf_test *self)
+{
+	return __bpf_fill_alu32_reg(self, BPF_MOD);
+}
+
 static struct bpf_test tests[] = {
 	{
 		"TAX",
@@ -8674,6 +9119,333 @@ static struct bpf_test tests[] = {
 		{ { 0, 1 } },
 		.fill_helper = bpf_fill_alu32_arsh_reg,
 	},
+	/* ALU64 immediate magnitudes */
+	{
+		"ALU64_MOV_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_mov_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU64_AND_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_and_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU64_OR_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_or_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU64_XOR_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_xor_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU64_ADD_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_add_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU64_SUB_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_sub_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU64_MUL_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_mul_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU64_DIV_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_div_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU64_MOD_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_mod_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	/* ALU32 immediate magnitudes */
+	{
+		"ALU32_MOV_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_mov_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU32_AND_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_and_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU32_OR_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_or_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU32_XOR_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_xor_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU32_ADD_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_add_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU32_SUB_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_sub_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU32_MUL_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_mul_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU32_DIV_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_div_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU32_MOD_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_mod_imm,
+	},
+	/* ALU64 register magnitudes */
+	{
+		"ALU64_MOV_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_mov_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU64_AND_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_and_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU64_OR_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_or_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU64_XOR_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_xor_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU64_ADD_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_add_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU64_SUB_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_sub_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU64_MUL_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_mul_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU64_DIV_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_div_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU64_MOD_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_mod_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	/* ALU32 register magnitudes */
+	{
+		"ALU32_MOV_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_mov_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU32_AND_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_and_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU32_OR_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_or_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU32_XOR_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_xor_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU32_ADD_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_add_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU32_SUB_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_sub_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU32_MUL_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_mul_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU32_DIV_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_div_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ALU32_MOD_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_mod_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
 };
 
 static struct net_device dev;
-- 
2.25.1

