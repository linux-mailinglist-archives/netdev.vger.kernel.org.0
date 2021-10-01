Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C80641EE39
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 15:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353946AbhJANHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 09:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354139AbhJANGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 09:06:51 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3C5C061794
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 06:04:15 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id ba1so34580328edb.4
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 06:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1dyBuNYzpYckrS6HbYo2UriEXk3AJ+jSdp87B70JRTg=;
        b=HNqKx+ZGamiEvqIRVIhBXRul+X41vt7idhdmzZ2tqvQXSDhu1Y/8QY9s/4Btj1xNA2
         sMRVJZ09fxzvGcPcPVdmxa5ts//bpPWe1x0PX6dTiIqvLxv9Y045HTJuqxjU53hopRmF
         NRfRgu6VCWnVI7DcTv6Q2t8qc3G/9Y8jTYy0OzHzBXj2Nt+rWOcv96n3qIXxf0JECfkB
         QMVkWIz60UFkwCBNXcvLPG1s/e9CZnEjt+lzFqQYo3g3Z+AgA9q/jwcqJE+jbrP+4iPI
         tJA3YyyQEl/CkVIkszb3/fAliu5P/YK1pDithnVEDtVMvbb3TDpSmIKhIK8qej+w4Unk
         HhIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1dyBuNYzpYckrS6HbYo2UriEXk3AJ+jSdp87B70JRTg=;
        b=0bW/CvJp110xU0Pk253Qcc23fcq2Z6XQMgSieULR+DzTRuLP73WclyEunhy16O7AaJ
         6fj8qXxdN7iI/Kk3/4XlPFdNOJm34K3tDS5wSTPJ6EwXdJdMq+BoeO+uTASjmgvQrjso
         zGSjBawAlroWM+/KfCS9KApW5YVHlXKK811tkFPetRq5oDBFRgrv3RM/Nw9JRWSlYScp
         yV6Q99/zHsP2BnMKt9en7QGvYRtIIoME+eK0VWMMGuf6LpbZgvJbIeR9ExQRaLGcrjIs
         TnIA20Jg0Mv1sPSg8kufl19Ep6QDDVdYPeFV77ylnZTrfdQ2hdikstWatocpc+6ToOCa
         lY9Q==
X-Gm-Message-State: AOAM530g+0d+oGVZKNWUCEvPxJVPNsWGBvEPZicidkNplKmMZJFPMj/H
        pT9cw0W78Qcnhef009m8KwnVyA==
X-Google-Smtp-Source: ABdhPJzUUJNfhTVTRaRNPEHw3vr+IXFQKIy7lZ1UXp50ZegUvxV75vx2AXRWvT6bjkHNGrJyIi9/dQ==
X-Received: by 2002:a17:906:318b:: with SMTP id 11mr6364683ejy.493.1633093448772;
        Fri, 01 Oct 2021 06:04:08 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id p22sm2920279ejl.90.2021.10.01.06.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 06:04:08 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        paul@cilium.io, yangtiezhu@loongson.cn, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next 09/10] bpf/tests: Add test of ALU shifts with operand register aliasing
Date:   Fri,  1 Oct 2021 15:03:47 +0200
Message-Id: <20211001130348.3670534-10-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211001130348.3670534-1-johan.almbladh@anyfinetworks.com>
References: <20211001130348.3670534-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a tests of ALU32 and ALU64 LSH/RSH/ARSH operations for the
case when the two operands are the same register. Mainly intended to test
JITs that implement ALU64 shifts with 32-bit CPU instructions.

Also renamed related helper functions for consistency with the new tests.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 162 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 149 insertions(+), 13 deletions(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 40db4cee4f51..dfcbdff714b6 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -660,37 +660,37 @@ static int __bpf_fill_alu_shift(struct bpf_test *self, u8 op,
 
 	self->u.ptr.insns = insn;
 	self->u.ptr.len = len;
-	BUG_ON(i > len);
+	BUG_ON(i != len);
 
 	return 0;
 }
 
-static int bpf_fill_alu_lsh_imm(struct bpf_test *self)
+static int bpf_fill_alu64_lsh_imm(struct bpf_test *self)
 {
 	return __bpf_fill_alu_shift(self, BPF_LSH, BPF_K, false);
 }
 
-static int bpf_fill_alu_rsh_imm(struct bpf_test *self)
+static int bpf_fill_alu64_rsh_imm(struct bpf_test *self)
 {
 	return __bpf_fill_alu_shift(self, BPF_RSH, BPF_K, false);
 }
 
-static int bpf_fill_alu_arsh_imm(struct bpf_test *self)
+static int bpf_fill_alu64_arsh_imm(struct bpf_test *self)
 {
 	return __bpf_fill_alu_shift(self, BPF_ARSH, BPF_K, false);
 }
 
-static int bpf_fill_alu_lsh_reg(struct bpf_test *self)
+static int bpf_fill_alu64_lsh_reg(struct bpf_test *self)
 {
 	return __bpf_fill_alu_shift(self, BPF_LSH, BPF_X, false);
 }
 
-static int bpf_fill_alu_rsh_reg(struct bpf_test *self)
+static int bpf_fill_alu64_rsh_reg(struct bpf_test *self)
 {
 	return __bpf_fill_alu_shift(self, BPF_RSH, BPF_X, false);
 }
 
-static int bpf_fill_alu_arsh_reg(struct bpf_test *self)
+static int bpf_fill_alu64_arsh_reg(struct bpf_test *self)
 {
 	return __bpf_fill_alu_shift(self, BPF_ARSH, BPF_X, false);
 }
@@ -725,6 +725,86 @@ static int bpf_fill_alu32_arsh_reg(struct bpf_test *self)
 	return __bpf_fill_alu_shift(self, BPF_ARSH, BPF_X, true);
 }
 
+/*
+ * Test an ALU register shift operation for all valid shift values
+ * for the case when the source and destination are the same.
+ */
+static int __bpf_fill_alu_shift_same_reg(struct bpf_test *self, u8 op,
+					 bool alu32)
+{
+	int bits = alu32 ? 32 : 64;
+	int len = 3 + 6 * bits;
+	struct bpf_insn *insn;
+	int i = 0;
+	u64 val;
+
+	insn = kmalloc_array(len, sizeof(*insn), GFP_KERNEL);
+	if (!insn)
+		return -ENOMEM;
+
+	insn[i++] = BPF_ALU64_IMM(BPF_MOV, R0, 0);
+
+	for (val = 0; val < bits; val++) {
+		u64 res;
+
+		/* Perform operation */
+		insn[i++] = BPF_ALU64_IMM(BPF_MOV, R1, val);
+		if (alu32)
+			insn[i++] = BPF_ALU32_REG(op, R1, R1);
+		else
+			insn[i++] = BPF_ALU64_REG(op, R1, R1);
+
+		/* Compute the reference result */
+		__bpf_alu_result(&res, val, val, op);
+		if (alu32)
+			res = (u32)res;
+		i += __bpf_ld_imm64(&insn[i], R2, res);
+
+		/* Check the actual result */
+		insn[i++] = BPF_JMP_REG(BPF_JEQ, R1, R2, 1);
+		insn[i++] = BPF_EXIT_INSN();
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
+
+static int bpf_fill_alu64_lsh_same_reg(struct bpf_test *self)
+{
+	return __bpf_fill_alu_shift_same_reg(self, BPF_LSH, false);
+}
+
+static int bpf_fill_alu64_rsh_same_reg(struct bpf_test *self)
+{
+	return __bpf_fill_alu_shift_same_reg(self, BPF_RSH, false);
+}
+
+static int bpf_fill_alu64_arsh_same_reg(struct bpf_test *self)
+{
+	return __bpf_fill_alu_shift_same_reg(self, BPF_ARSH, false);
+}
+
+static int bpf_fill_alu32_lsh_same_reg(struct bpf_test *self)
+{
+	return __bpf_fill_alu_shift_same_reg(self, BPF_LSH, true);
+}
+
+static int bpf_fill_alu32_rsh_same_reg(struct bpf_test *self)
+{
+	return __bpf_fill_alu_shift_same_reg(self, BPF_RSH, true);
+}
+
+static int bpf_fill_alu32_arsh_same_reg(struct bpf_test *self)
+{
+	return __bpf_fill_alu_shift_same_reg(self, BPF_ARSH, true);
+}
+
 /*
  * Common operand pattern generator for exhaustive power-of-two magnitudes
  * tests. The block size parameters can be adjusted to increase/reduce the
@@ -11788,7 +11868,7 @@ static struct bpf_test tests[] = {
 		INTERNAL | FLAG_NO_DATA,
 		{ },
 		{ { 0, 1 } },
-		.fill_helper = bpf_fill_alu_lsh_imm,
+		.fill_helper = bpf_fill_alu64_lsh_imm,
 	},
 	{
 		"ALU64_RSH_K: all shift values",
@@ -11796,7 +11876,7 @@ static struct bpf_test tests[] = {
 		INTERNAL | FLAG_NO_DATA,
 		{ },
 		{ { 0, 1 } },
-		.fill_helper = bpf_fill_alu_rsh_imm,
+		.fill_helper = bpf_fill_alu64_rsh_imm,
 	},
 	{
 		"ALU64_ARSH_K: all shift values",
@@ -11804,7 +11884,7 @@ static struct bpf_test tests[] = {
 		INTERNAL | FLAG_NO_DATA,
 		{ },
 		{ { 0, 1 } },
-		.fill_helper = bpf_fill_alu_arsh_imm,
+		.fill_helper = bpf_fill_alu64_arsh_imm,
 	},
 	{
 		"ALU64_LSH_X: all shift values",
@@ -11812,7 +11892,7 @@ static struct bpf_test tests[] = {
 		INTERNAL | FLAG_NO_DATA,
 		{ },
 		{ { 0, 1 } },
-		.fill_helper = bpf_fill_alu_lsh_reg,
+		.fill_helper = bpf_fill_alu64_lsh_reg,
 	},
 	{
 		"ALU64_RSH_X: all shift values",
@@ -11820,7 +11900,7 @@ static struct bpf_test tests[] = {
 		INTERNAL | FLAG_NO_DATA,
 		{ },
 		{ { 0, 1 } },
-		.fill_helper = bpf_fill_alu_rsh_reg,
+		.fill_helper = bpf_fill_alu64_rsh_reg,
 	},
 	{
 		"ALU64_ARSH_X: all shift values",
@@ -11828,7 +11908,7 @@ static struct bpf_test tests[] = {
 		INTERNAL | FLAG_NO_DATA,
 		{ },
 		{ { 0, 1 } },
-		.fill_helper = bpf_fill_alu_arsh_reg,
+		.fill_helper = bpf_fill_alu64_arsh_reg,
 	},
 	/* Exhaustive test of ALU32 shift operations */
 	{
@@ -11879,6 +11959,62 @@ static struct bpf_test tests[] = {
 		{ { 0, 1 } },
 		.fill_helper = bpf_fill_alu32_arsh_reg,
 	},
+	/*
+	 * Exhaustive test of ALU64 shift operations when
+	 * source and destination register are the same.
+	 */
+	{
+		"ALU64_LSH_X: all shift values with the same register",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_lsh_same_reg,
+	},
+	{
+		"ALU64_RSH_X: all shift values with the same register",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_rsh_same_reg,
+	},
+	{
+		"ALU64_ARSH_X: all shift values with the same register",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_arsh_same_reg,
+	},
+	/*
+	 * Exhaustive test of ALU32 shift operations when
+	 * source and destination register are the same.
+	 */
+	{
+		"ALU32_LSH_X: all shift values with the same register",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_lsh_same_reg,
+	},
+	{
+		"ALU32_RSH_X: all shift values with the same register",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_rsh_same_reg,
+	},
+	{
+		"ALU32_ARSH_X: all shift values with the same register",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_arsh_same_reg,
+	},
 	/* ALU64 immediate magnitudes */
 	{
 		"ALU64_MOV_K: all immediate value magnitudes",
-- 
2.30.2

