Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B66B84030F5
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 00:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349136AbhIGWZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 18:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241562AbhIGWZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 18:25:04 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8EDC061575
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 15:23:57 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id r7so70075edd.6
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 15:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HhJO+fwx4Re7Ogd46AIK3Gol1QT5GDKpHEFoCva4/XY=;
        b=r9wpcq38uuyLdaPq7ss8nO5w1z+fCl9W3VsjbCMpFzMP35wvpUwboXIzDS/Tjqn5Ni
         os5Zi46c/M+nDj+H9P4MI/k04Mh3YiIWYXyRNNsY4XJNT+oo/57KrovlY/dZbVS48zdU
         Iu/XsZJQ19wROcY4hxUimFZOk281vlX78qqDyYPIm4tlzx9PWu2OYMvGZt1+8P+D8E5q
         5nhaXLFiDHn6u+DOIEdK8oDW7n0B4Hs9cBDwA5YFI9fHELtOlrVeTN3ob0/C3UoG3BAT
         Xn29EwFGPdBJyPgf1aqVVX9Qiz/W56meTh7R+3RJkDHJDqKWh6mhSEIek1Ld/SV1icog
         kXwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HhJO+fwx4Re7Ogd46AIK3Gol1QT5GDKpHEFoCva4/XY=;
        b=pQB8TCMqd/qgqWa8i+hGkacr2HHXzpgDDgqanpsVx6nKOBqbnj9Tip4pomdsjkiafo
         OEemVJPACzLr2YZyW/TlU8He2d/DQp+QOJQEW2RgRchZVrZ2k8Uu0eb6rdpiRoxTpTK+
         iXuDH1zf2biJz4ChknT3ehaA1E9fU4/+qzWPOo0H1KFZJtiXg5UEiHnGLk9js30k4CSD
         geVMOnHC6asdPEF/oiZX+iDXULiwhAcv55J5Gn49xbpMymS9vQpSfoGcPqjDTO3ynZNR
         TuBK+/N6FI1wKpCjGBExZkTy5Mpz+BeZ5TpBFNszUEPlkEjtHX3uspny4dpDgoExRS01
         CEsg==
X-Gm-Message-State: AOAM5339VDxZDFvb+3koOp2YApO2h3asCkN47zFOb5YHah+wUimfMxID
        Ci6MlG/klbil5tA3mTRPMW+GrQ==
X-Google-Smtp-Source: ABdhPJxlrzDpvGTsqk6MIZOtirpUruD2WU7uuxQMUtZlfIvU3sqqMMbq/bMtQO3bMygvpMbkLzkf7Q==
X-Received: by 2002:aa7:c313:: with SMTP id l19mr512534edq.131.1631053436076;
        Tue, 07 Sep 2021 15:23:56 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id gb24sm71772ejc.53.2021.09.07.15.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 15:23:55 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next v2 07/13] bpf/tests: Add exhaustive test of LD_IMM64 immediate magnitudes
Date:   Wed,  8 Sep 2021 00:23:33 +0200
Message-Id: <20210907222339.4130924-8-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210907222339.4130924-1-johan.almbladh@anyfinetworks.com>
References: <20210907222339.4130924-1-johan.almbladh@anyfinetworks.com>
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
 lib/test_bpf.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index c25e99a461de..6a04447171c7 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -1104,6 +1104,60 @@ static int bpf_fill_alu32_mod_reg(struct bpf_test *self)
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
+	int len = 3 + 8 * 63 * block * 2;
+	struct bpf_insn *insn;
+	int bit, adj, sign;
+	int i = 0;
+
+	insn = kmalloc_array(len, sizeof(*insn), GFP_KERNEL);
+	if (!insn)
+		return -ENOMEM;
+
+	insn[i++] = BPF_ALU64_IMM(BPF_MOV, R0, 0);
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
@@ -10245,6 +10299,15 @@ static struct bpf_test tests[] = {
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

