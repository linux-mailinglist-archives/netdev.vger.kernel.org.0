Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62230405982
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 16:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348972AbhIIOq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 10:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345189AbhIIOqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 10:46:02 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14F6C05BD29
        for <netdev@vger.kernel.org>; Thu,  9 Sep 2021 07:33:19 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id s25so3009977edw.0
        for <netdev@vger.kernel.org>; Thu, 09 Sep 2021 07:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VZ/cPc+HBBfNYmV8Vu/gOGq5qn13KsrfaisPWpux7Uw=;
        b=RDQzPibccQJxS+HzdBZtc/rJnHPJ8XY0Y50WKgapciQMnDQ+wFfT7baFYQDJLOqr0f
         WF7ScO9XpnCta0qNyUSAvRfSU4xl7xxjHAfmlLi5zCEYvD0kaWJd5JTyyNZNRKIahOA9
         n0Y4duckfr65sNFSWORzzlrJBOw+eyovOF/MHPsehjmhYheaqLZem1Rr6gvFVu5kkvHQ
         zu4+JBq/B3RyxgPZ5JPtg03hLQmHokotTIS3qOlTGjwDukwsnCjceI4BrCx4CK3mhfbV
         0sT5RCD/JCjm3qFd4NvEGttPmLfYAwN2UKf7GFfyFgWbp4mP/q518JfcCepSFwAsUSGj
         fleg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VZ/cPc+HBBfNYmV8Vu/gOGq5qn13KsrfaisPWpux7Uw=;
        b=bkiGb3qnnYCfRi7eGTxebQSBCK5WJihJbaHDJ743DsHFF0qnXR6LSVFOgwv+Lqzqbx
         cz8rJ3cj3EkVhcP1bnUCO/sNpbSO+El5zlTuOlAkdrraodYNbHBeiF4F67hAktDlQc7G
         8mBQGBgDE8n6R03fQEaMt8xb+igBqN0mhK8Rgnm9OCHhgarEV1FVfHKsAnP5JwsoPcQ5
         5TBt8jkDqQ0qWM07oWdvVn8JSZpxTV8+maMuqxOFZTql3XsiaLTDXKO7H6TTF0fN8J6F
         p97vbnyGlZiyHdC6Jnggfdt5hNbevg5STNqNwB1gfhgJxig/jyjfRMHPkiJwi2y+wQh6
         9apQ==
X-Gm-Message-State: AOAM5312grXm/aWUx2cSepw0iJ1BUCHLgrjdIVhvSJjQXw7O6DgCg+7u
        HZbVvIHtcTG8p2+UNJbl56TnJA==
X-Google-Smtp-Source: ABdhPJzvEsnLp+QNvkvJmFZqUjCKarguxeJsFtkG0t/DL+3U3dJw2wi3WfIoeuHCp4TnpWIeJfSTwA==
X-Received: by 2002:aa7:cc08:: with SMTP id q8mr3401605edt.225.1631197998497;
        Thu, 09 Sep 2021 07:33:18 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id bj10sm1030909ejb.17.2021.09.09.07.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 07:33:18 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next v3 05/13] bpf/tests: Add exhaustive tests of JMP operand magnitudes
Date:   Thu,  9 Sep 2021 16:32:55 +0200
Message-Id: <20210909143303.811171-6-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909143303.811171-1-johan.almbladh@anyfinetworks.com>
References: <20210909143303.811171-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a set of tests for conditional JMP and JMP32 operations to
verify correctness for all possible magnitudes of the immediate and
register operands. Mainly intended for JIT testing.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 779 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 779 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 7992004bc876..e7ea8472c3d1 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -1104,6 +1104,384 @@ static int bpf_fill_alu32_mod_reg(struct bpf_test *self)
 	return __bpf_fill_alu32_reg(self, BPF_MOD);
 }
 
+
+/*
+ * Exhaustive tests of JMP operations for all combinations of power-of-two
+ * magnitudes of the operands, both for positive and negative values. The
+ * test is designed to verify e.g. the JMP and JMP32 operations for JITs that
+ * emit different code depending on the magnitude of the immediate value.
+ */
+
+static bool __bpf_match_jmp_cond(s64 v1, s64 v2, u8 op)
+{
+	switch (op) {
+	case BPF_JSET:
+		return !!(v1 & v2);
+	case BPF_JEQ:
+		return v1 == v2;
+	case BPF_JNE:
+		return v1 != v2;
+	case BPF_JGT:
+		return (u64)v1 > (u64)v2;
+	case BPF_JGE:
+		return (u64)v1 >= (u64)v2;
+	case BPF_JLT:
+		return (u64)v1 < (u64)v2;
+	case BPF_JLE:
+		return (u64)v1 <= (u64)v2;
+	case BPF_JSGT:
+		return v1 > v2;
+	case BPF_JSGE:
+		return v1 >= v2;
+	case BPF_JSLT:
+		return v1 < v2;
+	case BPF_JSLE:
+		return v1 <= v2;
+	}
+	return false;
+}
+
+static int __bpf_emit_jmp_imm(struct bpf_test *self, void *arg,
+			      struct bpf_insn *insns, s64 dst, s64 imm)
+{
+	int op = *(int *)arg;
+
+	if (insns) {
+		bool match = __bpf_match_jmp_cond(dst, (s32)imm, op);
+		int i = 0;
+
+		insns[i++] = BPF_ALU32_IMM(BPF_MOV, R0, match);
+
+		i += __bpf_ld_imm64(&insns[i], R1, dst);
+		insns[i++] = BPF_JMP_IMM(op, R1, imm, 1);
+		if (!match)
+			insns[i++] = BPF_JMP_IMM(BPF_JA, 0, 0, 1);
+		insns[i++] = BPF_EXIT_INSN();
+
+		return i;
+	}
+
+	return 5 + 1;
+}
+
+static int __bpf_emit_jmp32_imm(struct bpf_test *self, void *arg,
+				struct bpf_insn *insns, s64 dst, s64 imm)
+{
+	int op = *(int *)arg;
+
+	if (insns) {
+		bool match = __bpf_match_jmp_cond((s32)dst, (s32)imm, op);
+		int i = 0;
+
+		i += __bpf_ld_imm64(&insns[i], R1, dst);
+		insns[i++] = BPF_JMP32_IMM(op, R1, imm, 1);
+		if (!match)
+			insns[i++] = BPF_JMP_IMM(BPF_JA, 0, 0, 1);
+		insns[i++] = BPF_EXIT_INSN();
+
+		return i;
+	}
+
+	return 5;
+}
+
+static int __bpf_emit_jmp_reg(struct bpf_test *self, void *arg,
+			      struct bpf_insn *insns, s64 dst, s64 src)
+{
+	int op = *(int *)arg;
+
+	if (insns) {
+		bool match = __bpf_match_jmp_cond(dst, src, op);
+		int i = 0;
+
+		i += __bpf_ld_imm64(&insns[i], R1, dst);
+		i += __bpf_ld_imm64(&insns[i], R2, src);
+		insns[i++] = BPF_JMP_REG(op, R1, R2, 1);
+		if (!match)
+			insns[i++] = BPF_JMP_IMM(BPF_JA, 0, 0, 1);
+		insns[i++] = BPF_EXIT_INSN();
+
+		return i;
+	}
+
+	return 7;
+}
+
+static int __bpf_emit_jmp32_reg(struct bpf_test *self, void *arg,
+				struct bpf_insn *insns, s64 dst, s64 src)
+{
+	int op = *(int *)arg;
+
+	if (insns) {
+		bool match = __bpf_match_jmp_cond((s32)dst, (s32)src, op);
+		int i = 0;
+
+		i += __bpf_ld_imm64(&insns[i], R1, dst);
+		i += __bpf_ld_imm64(&insns[i], R2, src);
+		insns[i++] = BPF_JMP32_REG(op, R1, R2, 1);
+		if (!match)
+			insns[i++] = BPF_JMP_IMM(BPF_JA, 0, 0, 1);
+		insns[i++] = BPF_EXIT_INSN();
+
+		return i;
+	}
+
+	return 7;
+}
+
+static int __bpf_fill_jmp_imm(struct bpf_test *self, int op)
+{
+	return __bpf_fill_pattern(self, &op, 64, 32,
+				  PATTERN_BLOCK1, PATTERN_BLOCK2,
+				  &__bpf_emit_jmp_imm);
+}
+
+static int __bpf_fill_jmp32_imm(struct bpf_test *self, int op)
+{
+	return __bpf_fill_pattern(self, &op, 64, 32,
+				  PATTERN_BLOCK1, PATTERN_BLOCK2,
+				  &__bpf_emit_jmp32_imm);
+}
+
+static int __bpf_fill_jmp_reg(struct bpf_test *self, int op)
+{
+	return __bpf_fill_pattern(self, &op, 64, 64,
+				  PATTERN_BLOCK1, PATTERN_BLOCK2,
+				  &__bpf_emit_jmp_reg);
+}
+
+static int __bpf_fill_jmp32_reg(struct bpf_test *self, int op)
+{
+	return __bpf_fill_pattern(self, &op, 64, 64,
+				  PATTERN_BLOCK1, PATTERN_BLOCK2,
+				  &__bpf_emit_jmp32_reg);
+}
+
+/* JMP immediate tests */
+static int bpf_fill_jmp_jset_imm(struct bpf_test *self)
+{
+	return __bpf_fill_jmp_imm(self, BPF_JSET);
+}
+
+static int bpf_fill_jmp_jeq_imm(struct bpf_test *self)
+{
+	return __bpf_fill_jmp_imm(self, BPF_JEQ);
+}
+
+static int bpf_fill_jmp_jne_imm(struct bpf_test *self)
+{
+	return __bpf_fill_jmp_imm(self, BPF_JNE);
+}
+
+static int bpf_fill_jmp_jgt_imm(struct bpf_test *self)
+{
+	return __bpf_fill_jmp_imm(self, BPF_JGT);
+}
+
+static int bpf_fill_jmp_jge_imm(struct bpf_test *self)
+{
+	return __bpf_fill_jmp_imm(self, BPF_JGE);
+}
+
+static int bpf_fill_jmp_jlt_imm(struct bpf_test *self)
+{
+	return __bpf_fill_jmp_imm(self, BPF_JLT);
+}
+
+static int bpf_fill_jmp_jle_imm(struct bpf_test *self)
+{
+	return __bpf_fill_jmp_imm(self, BPF_JLE);
+}
+
+static int bpf_fill_jmp_jsgt_imm(struct bpf_test *self)
+{
+	return __bpf_fill_jmp_imm(self, BPF_JSGT);
+}
+
+static int bpf_fill_jmp_jsge_imm(struct bpf_test *self)
+{
+	return __bpf_fill_jmp_imm(self, BPF_JSGE);
+}
+
+static int bpf_fill_jmp_jslt_imm(struct bpf_test *self)
+{
+	return __bpf_fill_jmp_imm(self, BPF_JSLT);
+}
+
+static int bpf_fill_jmp_jsle_imm(struct bpf_test *self)
+{
+	return __bpf_fill_jmp_imm(self, BPF_JSLE);
+}
+
+/* JMP32 immediate tests */
+static int bpf_fill_jmp32_jset_imm(struct bpf_test *self)
+{
+	return __bpf_fill_jmp32_imm(self, BPF_JSET);
+}
+
+static int bpf_fill_jmp32_jeq_imm(struct bpf_test *self)
+{
+	return __bpf_fill_jmp32_imm(self, BPF_JEQ);
+}
+
+static int bpf_fill_jmp32_jne_imm(struct bpf_test *self)
+{
+	return __bpf_fill_jmp32_imm(self, BPF_JNE);
+}
+
+static int bpf_fill_jmp32_jgt_imm(struct bpf_test *self)
+{
+	return __bpf_fill_jmp32_imm(self, BPF_JGT);
+}
+
+static int bpf_fill_jmp32_jge_imm(struct bpf_test *self)
+{
+	return __bpf_fill_jmp32_imm(self, BPF_JGE);
+}
+
+static int bpf_fill_jmp32_jlt_imm(struct bpf_test *self)
+{
+	return __bpf_fill_jmp32_imm(self, BPF_JLT);
+}
+
+static int bpf_fill_jmp32_jle_imm(struct bpf_test *self)
+{
+	return __bpf_fill_jmp32_imm(self, BPF_JLE);
+}
+
+static int bpf_fill_jmp32_jsgt_imm(struct bpf_test *self)
+{
+	return __bpf_fill_jmp32_imm(self, BPF_JSGT);
+}
+
+static int bpf_fill_jmp32_jsge_imm(struct bpf_test *self)
+{
+	return __bpf_fill_jmp32_imm(self, BPF_JSGE);
+}
+
+static int bpf_fill_jmp32_jslt_imm(struct bpf_test *self)
+{
+	return __bpf_fill_jmp32_imm(self, BPF_JSLT);
+}
+
+static int bpf_fill_jmp32_jsle_imm(struct bpf_test *self)
+{
+	return __bpf_fill_jmp32_imm(self, BPF_JSLE);
+}
+
+/* JMP register tests */
+static int bpf_fill_jmp_jset_reg(struct bpf_test *self)
+{
+	return __bpf_fill_jmp_reg(self, BPF_JSET);
+}
+
+static int bpf_fill_jmp_jeq_reg(struct bpf_test *self)
+{
+	return __bpf_fill_jmp_reg(self, BPF_JEQ);
+}
+
+static int bpf_fill_jmp_jne_reg(struct bpf_test *self)
+{
+	return __bpf_fill_jmp_reg(self, BPF_JNE);
+}
+
+static int bpf_fill_jmp_jgt_reg(struct bpf_test *self)
+{
+	return __bpf_fill_jmp_reg(self, BPF_JGT);
+}
+
+static int bpf_fill_jmp_jge_reg(struct bpf_test *self)
+{
+	return __bpf_fill_jmp_reg(self, BPF_JGE);
+}
+
+static int bpf_fill_jmp_jlt_reg(struct bpf_test *self)
+{
+	return __bpf_fill_jmp_reg(self, BPF_JLT);
+}
+
+static int bpf_fill_jmp_jle_reg(struct bpf_test *self)
+{
+	return __bpf_fill_jmp_reg(self, BPF_JLE);
+}
+
+static int bpf_fill_jmp_jsgt_reg(struct bpf_test *self)
+{
+	return __bpf_fill_jmp_reg(self, BPF_JSGT);
+}
+
+static int bpf_fill_jmp_jsge_reg(struct bpf_test *self)
+{
+	return __bpf_fill_jmp_reg(self, BPF_JSGE);
+}
+
+static int bpf_fill_jmp_jslt_reg(struct bpf_test *self)
+{
+	return __bpf_fill_jmp_reg(self, BPF_JSLT);
+}
+
+static int bpf_fill_jmp_jsle_reg(struct bpf_test *self)
+{
+	return __bpf_fill_jmp_reg(self, BPF_JSLE);
+}
+
+/* JMP32 register tests */
+static int bpf_fill_jmp32_jset_reg(struct bpf_test *self)
+{
+	return __bpf_fill_jmp32_reg(self, BPF_JSET);
+}
+
+static int bpf_fill_jmp32_jeq_reg(struct bpf_test *self)
+{
+	return __bpf_fill_jmp32_reg(self, BPF_JEQ);
+}
+
+static int bpf_fill_jmp32_jne_reg(struct bpf_test *self)
+{
+	return __bpf_fill_jmp32_reg(self, BPF_JNE);
+}
+
+static int bpf_fill_jmp32_jgt_reg(struct bpf_test *self)
+{
+	return __bpf_fill_jmp32_reg(self, BPF_JGT);
+}
+
+static int bpf_fill_jmp32_jge_reg(struct bpf_test *self)
+{
+	return __bpf_fill_jmp32_reg(self, BPF_JGE);
+}
+
+static int bpf_fill_jmp32_jlt_reg(struct bpf_test *self)
+{
+	return __bpf_fill_jmp32_reg(self, BPF_JLT);
+}
+
+static int bpf_fill_jmp32_jle_reg(struct bpf_test *self)
+{
+	return __bpf_fill_jmp32_reg(self, BPF_JLE);
+}
+
+static int bpf_fill_jmp32_jsgt_reg(struct bpf_test *self)
+{
+	return __bpf_fill_jmp32_reg(self, BPF_JSGT);
+}
+
+static int bpf_fill_jmp32_jsge_reg(struct bpf_test *self)
+{
+	return __bpf_fill_jmp32_reg(self, BPF_JSGE);
+}
+
+static int bpf_fill_jmp32_jslt_reg(struct bpf_test *self)
+{
+	return __bpf_fill_jmp32_reg(self, BPF_JSLT);
+}
+
+static int bpf_fill_jmp32_jsle_reg(struct bpf_test *self)
+{
+	return __bpf_fill_jmp32_reg(self, BPF_JSLE);
+}
+
+
 static struct bpf_test tests[] = {
 	{
 		"TAX",
@@ -9281,6 +9659,7 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, 1 } },
 		.fill_helper = bpf_fill_alu32_mod_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
 	},
 	/* ALU64 register magnitudes */
 	{
@@ -9446,6 +9825,406 @@ static struct bpf_test tests[] = {
 		.fill_helper = bpf_fill_alu32_mod_reg,
 		.nr_testruns = NR_PATTERN_RUNS,
 	},
+	/* JMP immediate magnitudes */
+	{
+		"JMP_JSET_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp_jset_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP_JEQ_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp_jeq_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP_JNE_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp_jne_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP_JGT_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp_jgt_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP_JGE_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp_jge_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP_JLT_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp_jlt_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP_JLE_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp_jle_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP_JSGT_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp_jsgt_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP_JSGE_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp_jsge_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP_JSLT_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp_jslt_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP_JSLE_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp_jsle_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	/* JMP register magnitudes */
+	{
+		"JMP_JSET_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp_jset_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP_JEQ_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp_jeq_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP_JNE_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp_jne_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP_JGT_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp_jgt_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP_JGE_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp_jge_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP_JLT_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp_jlt_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP_JLE_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp_jle_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP_JSGT_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp_jsgt_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP_JSGE_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp_jsge_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP_JSLT_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp_jslt_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP_JSLE_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp_jsle_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	/* JMP32 immediate magnitudes */
+	{
+		"JMP32_JSET_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp32_jset_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP32_JEQ_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp32_jeq_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP32_JNE_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp32_jne_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP32_JGT_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp32_jgt_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP32_JGE_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp32_jge_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP32_JLT_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp32_jlt_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP32_JLE_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp32_jle_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP32_JSGT_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp32_jsgt_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP32_JSGE_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp32_jsge_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP32_JSLT_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp32_jslt_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP32_JSLE_K: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp32_jsle_imm,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	/* JMP32 register magnitudes */
+	{
+		"JMP32_JSET_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp32_jset_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP32_JEQ_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp32_jeq_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP32_JNE_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp32_jne_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP32_JGT_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp32_jgt_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP32_JGE_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp32_jge_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP32_JLT_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp32_jlt_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP32_JLE_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp32_jle_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP32_JSGT_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp32_jsgt_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP32_JSGE_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp32_jsge_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP32_JSLT_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp32_jslt_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"JMP32_JSLE_X: all register value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_jmp32_jsle_reg,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
 };
 
 static struct net_device dev;
-- 
2.30.2

