Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649ED41EE30
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 15:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354213AbhJANG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 09:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354251AbhJANG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 09:06:29 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0E6C0613EC
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 06:04:05 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id dn26so34417324edb.13
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 06:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a6y4JSy406Wu+PL5pFim+RuAZbB2EbfKD2rlF0TOar4=;
        b=RzpiLocflVSAD7CChVeRqlnX4KIPe8PDNEC+u6+IUU3ez+0g/3JZa0oyT2EHegTfol
         XRq62uP4Yyrs2xsKClcNp+rDh8CAzRMYCHZpMM/uI1e6u4vf/dfJ3d/456kmgg8RJ+m8
         rEwEq66lgQbQn8k6fVKHrgm5SOgbyUtYLtJJC97RjspN/iA1ZpnTDm/GDQVQyH7Aas3i
         K9X/qy8dvj9VUCNz3nbxFvd1CWLYgqyrfFPLq+avzg3QPSamtzeC8B7k/EO2uMAM3jzU
         ZSh11RPz+XxTNCKxfkXCQa1DsjVUrrwzmJpgVz71Y6HsVm59TECvq/hhAWVQ+rFpc5lH
         baQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a6y4JSy406Wu+PL5pFim+RuAZbB2EbfKD2rlF0TOar4=;
        b=gBzFkA0VCF/tbX7ZqqsbUwkrpytMr7yH8MQOO8dnoOESpbCS5ZmB8EVi+aT6fT9hF6
         BZj5uMniLlwtUrVtZ6o2e7V3ZaJFUrq9Csf1mAUAs9bfa1NDee2rLwUxEF3DDaH+1BLA
         pT3P4j+bGcg74our8li2tWHYMGoJYvdlhoyDBCqVGSjxD+UjoTDSVaYH+ZDeplHDcph0
         OWmI1Ud+3Bmwc0BMJ83b9iB/1nz3VLdOW0wbnFomXRhGJBIMe4iXNWW0PvyUANbuC7WW
         onK1W4QGEcZiThTsKdI5mwZcKdl/mgibRwLuHolUcJZGWzji+CW30iY7F86yNCexBTze
         2nFg==
X-Gm-Message-State: AOAM53308wUtDglbmjiP/cnmunqGrPzzv6Df8/8mCvfKqeTH9WZ7hieg
        ARnNhPzjR6jFK6w0SBN+Cpklaw==
X-Google-Smtp-Source: ABdhPJwj3yV8GHKjigIxa2Jnn7+zh39UAhWAy3pPE2urx3c414BWuJS1mfT237HxRD5wmYkPrqREjg==
X-Received: by 2002:a50:8282:: with SMTP id 2mr14038488edg.98.1633093442602;
        Fri, 01 Oct 2021 06:04:02 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id p22sm2920279ejl.90.2021.10.01.06.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 06:04:02 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        paul@cilium.io, yangtiezhu@loongson.cn, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next 04/10] bpf/tests: Add tests to check source register zero-extension
Date:   Fri,  1 Oct 2021 15:03:42 +0200
Message-Id: <20211001130348.3670534-5-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211001130348.3670534-1-johan.almbladh@anyfinetworks.com>
References: <20211001130348.3670534-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds tests to check that the source register is preserved when
zero-extending a 32-bit value. In particular, it checks that the source
operand is not zero-extended in-place.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 143 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 143 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 84efb23e09d0..c7db90112ef0 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -10586,6 +10586,149 @@ static struct bpf_test tests[] = {
 		{},
 		{ { 0, 2 } },
 	},
+	/* Checking that ALU32 src is not zero extended in place */
+#define BPF_ALU32_SRC_ZEXT(op)					\
+	{							\
+		"ALU32_" #op "_X: src preserved in zext",	\
+		.u.insns_int = {				\
+			BPF_LD_IMM64(R1, 0x0123456789acbdefULL),\
+			BPF_LD_IMM64(R2, 0xfedcba9876543210ULL),\
+			BPF_ALU64_REG(BPF_MOV, R0, R1),		\
+			BPF_ALU32_REG(BPF_##op, R2, R1),	\
+			BPF_ALU64_REG(BPF_SUB, R0, R1),		\
+			BPF_ALU64_REG(BPF_MOV, R1, R0),		\
+			BPF_ALU64_IMM(BPF_RSH, R1, 32),		\
+			BPF_ALU64_REG(BPF_OR, R0, R1),		\
+			BPF_EXIT_INSN(),			\
+		},						\
+		INTERNAL,					\
+		{ },						\
+		{ { 0, 0 } },					\
+	}
+	BPF_ALU32_SRC_ZEXT(MOV),
+	BPF_ALU32_SRC_ZEXT(AND),
+	BPF_ALU32_SRC_ZEXT(OR),
+	BPF_ALU32_SRC_ZEXT(XOR),
+	BPF_ALU32_SRC_ZEXT(ADD),
+	BPF_ALU32_SRC_ZEXT(SUB),
+	BPF_ALU32_SRC_ZEXT(MUL),
+	BPF_ALU32_SRC_ZEXT(DIV),
+	BPF_ALU32_SRC_ZEXT(MOD),
+#undef BPF_ALU32_SRC_ZEXT
+	/* Checking that ATOMIC32 src is not zero extended in place */
+#define BPF_ATOMIC32_SRC_ZEXT(op)					\
+	{								\
+		"ATOMIC_W_" #op ": src preserved in zext",		\
+		.u.insns_int = {					\
+			BPF_LD_IMM64(R0, 0x0123456789acbdefULL),	\
+			BPF_ALU64_REG(BPF_MOV, R1, R0),			\
+			BPF_ST_MEM(BPF_W, R10, -4, 0),			\
+			BPF_ATOMIC_OP(BPF_W, BPF_##op, R10, R1, -4),	\
+			BPF_ALU64_REG(BPF_SUB, R0, R1),			\
+			BPF_ALU64_REG(BPF_MOV, R1, R0),			\
+			BPF_ALU64_IMM(BPF_RSH, R1, 32),			\
+			BPF_ALU64_REG(BPF_OR, R0, R1),			\
+			BPF_EXIT_INSN(),				\
+		},							\
+		INTERNAL,						\
+		{ },							\
+		{ { 0, 0 } },						\
+		.stack_depth = 8,					\
+	}
+	BPF_ATOMIC32_SRC_ZEXT(ADD),
+	BPF_ATOMIC32_SRC_ZEXT(AND),
+	BPF_ATOMIC32_SRC_ZEXT(OR),
+	BPF_ATOMIC32_SRC_ZEXT(XOR),
+#undef BPF_ATOMIC32_SRC_ZEXT
+	/* Checking that CMPXCHG32 src is not zero extended in place */
+	{
+		"ATOMIC_W_CMPXCHG: src preserved in zext",
+		.u.insns_int = {
+			BPF_LD_IMM64(R1, 0x0123456789acbdefULL),
+			BPF_ALU64_REG(BPF_MOV, R2, R1),
+			BPF_ALU64_REG(BPF_MOV, R0, 0),
+			BPF_ST_MEM(BPF_W, R10, -4, 0),
+			BPF_ATOMIC_OP(BPF_W, BPF_CMPXCHG, R10, R1, -4),
+			BPF_ALU64_REG(BPF_SUB, R1, R2),
+			BPF_ALU64_REG(BPF_MOV, R2, R1),
+			BPF_ALU64_IMM(BPF_RSH, R2, 32),
+			BPF_ALU64_REG(BPF_OR, R1, R2),
+			BPF_ALU64_REG(BPF_MOV, R0, R1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0 } },
+		.stack_depth = 8,
+	},
+	/* Checking that JMP32 immediate src is not zero extended in place */
+#define BPF_JMP32_IMM_ZEXT(op)					\
+	{							\
+		"JMP32_" #op "_K: operand preserved in zext",	\
+		.u.insns_int = {				\
+			BPF_LD_IMM64(R0, 0x0123456789acbdefULL),\
+			BPF_ALU64_REG(BPF_MOV, R1, R0),		\
+			BPF_JMP32_IMM(BPF_##op, R0, 1234, 1),	\
+			BPF_JMP_A(0), /* Nop */			\
+			BPF_ALU64_REG(BPF_SUB, R0, R1),		\
+			BPF_ALU64_REG(BPF_MOV, R1, R0),		\
+			BPF_ALU64_IMM(BPF_RSH, R1, 32),		\
+			BPF_ALU64_REG(BPF_OR, R0, R1),		\
+			BPF_EXIT_INSN(),			\
+		},						\
+		INTERNAL,					\
+		{ },						\
+		{ { 0, 0 } },					\
+	}
+	BPF_JMP32_IMM_ZEXT(JEQ),
+	BPF_JMP32_IMM_ZEXT(JNE),
+	BPF_JMP32_IMM_ZEXT(JSET),
+	BPF_JMP32_IMM_ZEXT(JGT),
+	BPF_JMP32_IMM_ZEXT(JGE),
+	BPF_JMP32_IMM_ZEXT(JLT),
+	BPF_JMP32_IMM_ZEXT(JLE),
+	BPF_JMP32_IMM_ZEXT(JSGT),
+	BPF_JMP32_IMM_ZEXT(JSGE),
+	BPF_JMP32_IMM_ZEXT(JSGT),
+	BPF_JMP32_IMM_ZEXT(JSLT),
+	BPF_JMP32_IMM_ZEXT(JSLE),
+#undef BPF_JMP2_IMM_ZEXT
+	/* Checking that JMP32 dst & src are not zero extended in place */
+#define BPF_JMP32_REG_ZEXT(op)					\
+	{							\
+		"JMP32_" #op "_X: operands preserved in zext",	\
+		.u.insns_int = {				\
+			BPF_LD_IMM64(R0, 0x0123456789acbdefULL),\
+			BPF_LD_IMM64(R1, 0xfedcba9876543210ULL),\
+			BPF_ALU64_REG(BPF_MOV, R2, R0),		\
+			BPF_ALU64_REG(BPF_MOV, R3, R1),		\
+			BPF_JMP32_IMM(BPF_##op, R0, R1, 1),	\
+			BPF_JMP_A(0), /* Nop */			\
+			BPF_ALU64_REG(BPF_SUB, R0, R2),		\
+			BPF_ALU64_REG(BPF_SUB, R1, R3),		\
+			BPF_ALU64_REG(BPF_OR, R0, R1),		\
+			BPF_ALU64_REG(BPF_MOV, R1, R0),		\
+			BPF_ALU64_IMM(BPF_RSH, R1, 32),		\
+			BPF_ALU64_REG(BPF_OR, R0, R1),		\
+			BPF_EXIT_INSN(),			\
+		},						\
+		INTERNAL,					\
+		{ },						\
+		{ { 0, 0 } },					\
+	}
+	BPF_JMP32_REG_ZEXT(JEQ),
+	BPF_JMP32_REG_ZEXT(JNE),
+	BPF_JMP32_REG_ZEXT(JSET),
+	BPF_JMP32_REG_ZEXT(JGT),
+	BPF_JMP32_REG_ZEXT(JGE),
+	BPF_JMP32_REG_ZEXT(JLT),
+	BPF_JMP32_REG_ZEXT(JLE),
+	BPF_JMP32_REG_ZEXT(JSGT),
+	BPF_JMP32_REG_ZEXT(JSGE),
+	BPF_JMP32_REG_ZEXT(JSGT),
+	BPF_JMP32_REG_ZEXT(JSLT),
+	BPF_JMP32_REG_ZEXT(JSLE),
+#undef BPF_JMP2_REG_ZEXT
 	/* Exhaustive test of ALU64 shift operations */
 	{
 		"ALU64_LSH_K: all shift values",
-- 
2.30.2

