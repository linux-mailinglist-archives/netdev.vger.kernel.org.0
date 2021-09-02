Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8A33FF38F
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 20:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347298AbhIBSyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 14:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347202AbhIBSxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 14:53:45 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51998C061764
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 11:52:46 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id j13so4378825edv.13
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 11:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RubSeZHKUufNS8uBgeBaGKg0zaBzqY92qIlNlu65D7c=;
        b=xrEv3XFDf1oHubRN+3bgqjAZUi51EORd9N9zj6HS5i6T5kR4leRv6znfRDr7CaMOQC
         1AkSCieQgacJ8hvy6sF1V4Tolk/Rz8+sFA6Z1ItyCRs38tV0vg7Rk7I+b96kRVbh0Z/5
         ImK9S4BnSKcHfzoG+OVZ//XL+qjEEsXJR1KDbKHf/6TpOzpEi356c4T6j0TemHBD0cp1
         J9VQ1egOUjhM2Wy9xybyouyLYgcH+gibIUu13lFP2gjl+72GaMNf23HgxYzvLoZuWs9x
         2dnZjGA6pB4S1UphnWVhgrkKChKEN03Qybf6i6VqH7WnfuZjxTRSW05k1ZIJrtezNs09
         CXRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RubSeZHKUufNS8uBgeBaGKg0zaBzqY92qIlNlu65D7c=;
        b=Rp4evFlzmD2GGsRqfniPW/GgATyjfFdWMqRnEUAG0OjxiqidqKBz95iPnS/32yWZMI
         Xq0gceu8YpQkh31jWcgWJCgVSvsHipFRl57O0BqAH8PEtxcZFmf+70aHV7lCDOuwAi1V
         IZYmWnFWj5VmNaOcXOaObfipgzrkSwT1F1YwA+lDvC3qQwFHCQsvsxB5p10MUtAs4Ae+
         g3akV1E/HXaqHNMITtt3/diTu9MOweHzJF9smRIQvyOZr18Jfq2ZQvG09/2nT+gbl4Mf
         m+oZBMN9lj8NQmx/Tuhh9pQjAL+4qx5xKVT4p6bim5tjiwSo4HVxNkIZyDts7gFVHgTl
         Sj/g==
X-Gm-Message-State: AOAM533bkwBrjVoFO5q6vi77rBX2SHR9Z/bYLeziEvHF4DoHyJt7UHLA
        7+ILfaj0tZZj5xz/iD7LdUAhQw==
X-Google-Smtp-Source: ABdhPJzHspo0HhFXFcKxLURTX/3PPSIqmQc1mSb2JiiCsaMVN5oCSgGT53Rl8lmqMbFfE7Q8OXSHug==
X-Received: by 2002:aa7:d3d6:: with SMTP id o22mr4922511edr.155.1630608764954;
        Thu, 02 Sep 2021 11:52:44 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id mb14sm1592235ejb.81.2021.09.02.11.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 11:52:44 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        iii@linux.ibm.com
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next 07/13] bpf/tests: Add exhaustive test of LD_IMM64 immediate magnitudes
Date:   Thu,  2 Sep 2021 20:52:23 +0200
Message-Id: <20210902185229.1840281-8-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210902185229.1840281-1-johan.almbladh@anyfinetworks.com>
References: <20210902185229.1840281-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

this patch adds a test for the 64-bit immediate load, a two-instruction
operation, to verify correctness for all possible magnitudes of the
immediate operand. Mainly intended for JIT testing.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 64 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index ea29e42418e3..3af8421ceb94 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -1101,6 +1101,61 @@ static int bpf_fill_alu32_mod_reg(struct bpf_test *self)
 	return __bpf_fill_alu32_reg(self, BPF_MOD);
 }
 
+/*
+ * Test the two-instruction 64-bit immediate load operation for all
+ * power-of-two magnitudes of the immediate operand. For each MSB, a block
+ * of immediate values centered around the power-of-two MSB are tested,
+ * both for positive and negative values. The test is designed to verify
+ * the operation for JITs that emit different code depending on the magnitude
+ * of the immediate value. This is often the case if the native instruction
+ * immediate field width is narrower than 32 bits.
+ */
+static int bpf_fill_ld_imm64(struct bpf_test *self)
+{
+	int block = 64; /* Increase for more tests per MSB position */
+	int len = 2 + 9 * 63 * block * 2;
+	struct bpf_insn *insn;
+	int bit, adj, sign;
+	int i = 0;
+
+	insn = kmalloc_array(len, sizeof(*insn), GFP_KERNEL);
+	if (!insn)
+		return -ENOMEM;
+
+	for (bit = 0; bit <= 62; bit++) {
+		for (adj = -block / 2; adj < block / 2; adj++) {
+			for (sign = -1; sign <= 1; sign += 2) {
+				s64 imm = sign * ((1LL << bit) + adj);
+
+				/* Perform operation */
+				i += __bpf_ld_imm64(&insn[i], R1, imm);
+
+				/* Load reference */
+				insn[i++] = BPF_ALU32_IMM(BPF_MOV, R2, imm);
+				insn[i++] = BPF_ALU32_IMM(BPF_MOV, R3,
+							  (u32)(imm >> 32));
+				insn[i++] = BPF_ALU64_IMM(BPF_LSH, R3, 32);
+				insn[i++] = BPF_ALU64_REG(BPF_OR, R2, R3);
+
+				/* For diagnostic purposes */
+				insn[i++] = BPF_ALU64_IMM(BPF_MOV, R0, i);
+
+				/* Check result */
+				insn[i++] = BPF_JMP_REG(BPF_JEQ, R1, R2, 1);
+				insn[i++] = BPF_EXIT_INSN();
+			}
+		}
+	}
+
+	insn[i++] = BPF_ALU64_IMM(BPF_MOV, R0, 1);
+	insn[i++] = BPF_EXIT_INSN();
+
+	self->u.ptr.insns = insn;
+	self->u.ptr.len = len;
+	BUG_ON(i != len);
+
+	return 0;
+}
 
 /*
  * Exhaustive tests of JMP operations for all combinations of power-of-two
@@ -10242,6 +10297,15 @@ static struct bpf_test tests[] = {
 		.fill_helper = bpf_fill_alu32_mod_reg,
 		.nr_testruns = NR_PATTERN_RUNS,
 	},
+	/* LD_IMM64 immediate magnitudes */
+	{
+		"LD_IMM64: all immediate value magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_ld_imm64,
+	},
 	/* JMP immediate magnitudes */
 	{
 		"JMP_JSET_K: all immediate value magnitudes",
-- 
2.25.1

