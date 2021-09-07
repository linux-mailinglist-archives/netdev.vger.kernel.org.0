Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6AB34030F2
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 00:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348974AbhIGWZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 18:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348169AbhIGWZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 18:25:03 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8E1C06175F
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 15:23:56 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id g22so30942edy.12
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 15:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uooNLUFw7tTjyttcx5ZfcVBX1/gJxTnpJeJqLsHXd70=;
        b=aIlisFBohL6Jf0r6Dj4HyCs3AQn9tN0chC8zUyz1c7la5S+A1cEjHiARE0HZMOdXyR
         vy36fEtlRL2X0E5bqTHfgz26PT0rkOs/srnobobFAVby+AAorDW+0Rxn5R4Q32tufp8E
         5iDaQoMiX0qvLTq3OTdfXfnl0FV58LcaiZb7NdnWoLaOWHSJC63Yw15XqXZeVZFAgcfX
         5SL7xUzW7xYg1nAkn6aZBPRRykWT5c3tqz7Cs3unAJx6US4CdWuMpgAtPRRwF4pLDfKl
         mDdfWEEgXML49jINbFMdv7LyYJ7a+d4EaB0z8vDV8LEpngDIoM0BLq1dYxSViZ3+fCe4
         U/qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uooNLUFw7tTjyttcx5ZfcVBX1/gJxTnpJeJqLsHXd70=;
        b=aKKo6TnHEwviwluJMoGLTI/quv5NnLtGBaHtWQsGPK5D+wNQYZp+9ne6LCCT4vUDob
         Q5Xh+EFuX6rflP9wWvRKw7xuGOcTGMA1RUdq18e5d5n+tsXZbCswAJQe7WJ/VxJCqodi
         X6npCqeMaId7UWe5AY0zvjp/dnPtxTEp5VbYl4Dm0RlwOX0EABGr9nBgfor35FZc3h1q
         e8GQyeF5ZQqcmSFKSHRfOa4k3k/pr3Bs7G3Fl9nABHzEuZWUk+X5jZl5KRUqpt8jSkF4
         aR5QTxeEi254HsSRuf5tBCe3ex0bBIcV87ERnu4JAfRZQCq0GvpJkKwX7F4MNgmcxEvm
         7Hew==
X-Gm-Message-State: AOAM531YLf9eU5w3yC5pnDvj0AghxH7Iyge0GCQaTFbArC66UlCRgztP
        TQQD28GSx2trbR75NSNaK5sERA==
X-Google-Smtp-Source: ABdhPJytjE2GCvCIaCoxeBNOe0JBGv1XW+v6YxCtV4nPYFTLRwvR7/RCzPfqHrSrjpwDG+6/WrK5Dw==
X-Received: by 2002:a50:ee94:: with SMTP id f20mr513340edr.117.1631053435023;
        Tue, 07 Sep 2021 15:23:55 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id gb24sm71772ejc.53.2021.09.07.15.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 15:23:54 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next v2 06/13] bpf/tests: Add staggered JMP and JMP32 tests
Date:   Wed,  8 Sep 2021 00:23:32 +0200
Message-Id: <20210907222339.4130924-7-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210907222339.4130924-1-johan.almbladh@anyfinetworks.com>
References: <20210907222339.4130924-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a new type of jump test where the program jumps forwards
and backwards with increasing offset. It mainly tests JITs where a
relative jump may generate different JITed code depending on the offset
size, read MIPS.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 829 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 829 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index e7ea8472c3d1..c25e99a461de 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -1481,6 +1481,426 @@ static int bpf_fill_jmp32_jsle_reg(struct bpf_test *self)
 	return __bpf_fill_jmp32_reg(self, BPF_JSLE);
 }
 
+/*
+ * Set up a sequence of staggered jumps, forwards and backwards with
+ * increasing offset. This tests the conversion of relative jumps to
+ * JITed native jumps. On some architectures, for example MIPS, a large
+ * PC-relative jump offset may overflow the immediate field of the native
+ * conditional branch instruction, triggering a conversion to use an
+ * absolute jump instead. Since this changes the jump offsets, another
+ * offset computation pass is necessary, and that may in turn trigger
+ * another branch conversion. This jump sequence is particularly nasty
+ * in that regard.
+ *
+ * The sequence generation is parameterized by size and jump type.
+ * The size must be even, and the expected result is always size + 1.
+ * Below is an example with size=8 and result=9.
+ *
+ *                     ________________________Start
+ *                     R0 = 0
+ *                     R1 = r1
+ *                     R2 = r2
+ *            ,------- JMP +4 * 3______________Preamble: 4 insns
+ * ,----------|-ind 0- if R0 != 7 JMP 8 * 3 + 1 <--------------------.
+ * |          |        R0 = 8                                        |
+ * |          |        JMP +7 * 3               ------------------------.
+ * | ,--------|-----1- if R0 != 5 JMP 7 * 3 + 1 <--------------.     |  |
+ * | |        |        R0 = 6                                  |     |  |
+ * | |        |        JMP +5 * 3               ------------------.  |  |
+ * | | ,------|-----2- if R0 != 3 JMP 6 * 3 + 1 <--------.     |  |  |  |
+ * | | |      |        R0 = 4                            |     |  |  |  |
+ * | | |      |        JMP +3 * 3               ------------.  |  |  |  |
+ * | | | ,----|-----3- if R0 != 1 JMP 5 * 3 + 1 <--.     |  |  |  |  |  |
+ * | | | |    |        R0 = 2                      |     |  |  |  |  |  |
+ * | | | |    |        JMP +1 * 3               ------.  |  |  |  |  |  |
+ * | | | | ,--t=====4> if R0 != 0 JMP 4 * 3 + 1    1  2  3  4  5  6  7  8 loc
+ * | | | | |           R0 = 1                     -1 +2 -3 +4 -5 +6 -7 +8 off
+ * | | | | |           JMP -2 * 3               ---'  |  |  |  |  |  |  |
+ * | | | | | ,------5- if R0 != 2 JMP 3 * 3 + 1 <-----'  |  |  |  |  |  |
+ * | | | | | |         R0 = 3                            |  |  |  |  |  |
+ * | | | | | |         JMP -4 * 3               ---------'  |  |  |  |  |
+ * | | | | | | ,----6- if R0 != 4 JMP 2 * 3 + 1 <-----------'  |  |  |  |
+ * | | | | | | |       R0 = 5                                  |  |  |  |
+ * | | | | | | |       JMP -6 * 3               ---------------'  |  |  |
+ * | | | | | | | ,--7- if R0 != 6 JMP 1 * 3 + 1 <-----------------'  |  |
+ * | | | | | | | |     R0 = 7                                        |  |
+ * | | Error | | |     JMP -8 * 3               ---------------------'  |
+ * | | paths | | | ,8- if R0 != 8 JMP 0 * 3 + 1 <-----------------------'
+ * | | | | | | | | |   R0 = 9__________________Sequence: 3 * size - 1 insns
+ * `-+-+-+-+-+-+-+-+-> EXIT____________________Return: 1 insn
+ *
+ */
+
+/* The maximum size parameter */
+#define MAX_STAGGERED_JMP_SIZE ((0x7fff / 3) & ~1)
+
+/* We use a reduced number of iterations to get a reasonable execution time */
+#define NR_STAGGERED_JMP_RUNS 10
+
+static int __bpf_fill_staggered_jumps(struct bpf_test *self,
+				      const struct bpf_insn *jmp,
+				      u64 r1, u64 r2)
+{
+	int size = self->test[0].result - 1;
+	int len = 4 + 3 * (size + 1);
+	struct bpf_insn *insns;
+	int off, ind;
+
+	insns = kmalloc_array(len, sizeof(*insns), GFP_KERNEL);
+	if (!insns)
+		return -ENOMEM;
+
+	/* Preamble */
+	insns[0] = BPF_ALU64_IMM(BPF_MOV, R0, 0);
+	insns[1] = BPF_ALU64_IMM(BPF_MOV, R1, r1);
+	insns[2] = BPF_ALU64_IMM(BPF_MOV, R2, r2);
+	insns[3] = BPF_JMP_IMM(BPF_JA, 0, 0, 3 * size / 2);
+
+	/* Sequence */
+	for (ind = 0, off = size; ind <= size; ind++, off -= 2) {
+		struct bpf_insn *ins = &insns[4 + 3 * ind];
+		int loc;
+
+		if (off == 0)
+			off--;
+
+		loc = abs(off);
+		ins[0] = BPF_JMP_IMM(BPF_JNE, R0, loc - 1,
+				     3 * (size - ind) + 1);
+		ins[1] = BPF_ALU64_IMM(BPF_MOV, R0, loc);
+		ins[2] = *jmp;
+		ins[2].off = 3 * (off - 1);
+	}
+
+	/* Return */
+	insns[len - 1] = BPF_EXIT_INSN();
+
+	self->u.ptr.insns = insns;
+	self->u.ptr.len = len;
+
+	return 0;
+}
+
+/* 64-bit unconditional jump */
+static int bpf_fill_staggered_ja(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP_IMM(BPF_JA, 0, 0, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, 0, 0);
+}
+
+/* 64-bit immediate jumps */
+static int bpf_fill_staggered_jeq_imm(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP_IMM(BPF_JEQ, R1, 1234, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, 1234, 0);
+}
+
+static int bpf_fill_staggered_jne_imm(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP_IMM(BPF_JNE, R1, 1234, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, 4321, 0);
+}
+
+static int bpf_fill_staggered_jset_imm(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP_IMM(BPF_JSET, R1, 0x82, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, 0x86, 0);
+}
+
+static int bpf_fill_staggered_jgt_imm(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP_IMM(BPF_JGT, R1, 1234, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, 0x80000000, 0);
+}
+
+static int bpf_fill_staggered_jge_imm(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP_IMM(BPF_JGE, R1, 1234, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, 1234, 0);
+}
+
+static int bpf_fill_staggered_jlt_imm(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP_IMM(BPF_JLT, R1, 0x80000000, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, 1234, 0);
+}
+
+static int bpf_fill_staggered_jle_imm(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP_IMM(BPF_JLE, R1, 1234, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, 1234, 0);
+}
+
+static int bpf_fill_staggered_jsgt_imm(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP_IMM(BPF_JSGT, R1, -2, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, -1, 0);
+}
+
+static int bpf_fill_staggered_jsge_imm(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP_IMM(BPF_JSGE, R1, -2, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, -2, 0);
+}
+
+static int bpf_fill_staggered_jslt_imm(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP_IMM(BPF_JSLT, R1, -1, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, -2, 0);
+}
+
+static int bpf_fill_staggered_jsle_imm(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP_IMM(BPF_JSLE, R1, -1, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, -1, 0);
+}
+
+/* 64-bit register jumps */
+static int bpf_fill_staggered_jeq_reg(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP_REG(BPF_JEQ, R1, R2, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, 1234, 1234);
+}
+
+static int bpf_fill_staggered_jne_reg(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP_REG(BPF_JNE, R1, R2, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, 4321, 1234);
+}
+
+static int bpf_fill_staggered_jset_reg(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP_REG(BPF_JSET, R1, R2, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, 0x86, 0x82);
+}
+
+static int bpf_fill_staggered_jgt_reg(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP_REG(BPF_JGT, R1, R2, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, 0x80000000, 1234);
+}
+
+static int bpf_fill_staggered_jge_reg(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP_REG(BPF_JGE, R1, R2, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, 1234, 1234);
+}
+
+static int bpf_fill_staggered_jlt_reg(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP_REG(BPF_JLT, R1, R2, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, 1234, 0x80000000);
+}
+
+static int bpf_fill_staggered_jle_reg(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP_REG(BPF_JLE, R1, R2, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, 1234, 1234);
+}
+
+static int bpf_fill_staggered_jsgt_reg(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP_REG(BPF_JSGT, R1, R2, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, -1, -2);
+}
+
+static int bpf_fill_staggered_jsge_reg(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP_REG(BPF_JSGE, R1, R2, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, -2, -2);
+}
+
+static int bpf_fill_staggered_jslt_reg(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP_REG(BPF_JSLT, R1, R2, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, -2, -1);
+}
+
+static int bpf_fill_staggered_jsle_reg(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP_REG(BPF_JSLE, R1, R2, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, -1, -1);
+}
+
+/* 32-bit immediate jumps */
+static int bpf_fill_staggered_jeq32_imm(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP32_IMM(BPF_JEQ, R1, 1234, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, 1234, 0);
+}
+
+static int bpf_fill_staggered_jne32_imm(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP32_IMM(BPF_JNE, R1, 1234, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, 4321, 0);
+}
+
+static int bpf_fill_staggered_jset32_imm(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP32_IMM(BPF_JSET, R1, 0x82, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, 0x86, 0);
+}
+
+static int bpf_fill_staggered_jgt32_imm(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP32_IMM(BPF_JGT, R1, 1234, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, 0x80000000, 0);
+}
+
+static int bpf_fill_staggered_jge32_imm(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP32_IMM(BPF_JGE, R1, 1234, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, 1234, 0);
+}
+
+static int bpf_fill_staggered_jlt32_imm(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP32_IMM(BPF_JLT, R1, 0x80000000, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, 1234, 0);
+}
+
+static int bpf_fill_staggered_jle32_imm(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP32_IMM(BPF_JLE, R1, 1234, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, 1234, 0);
+}
+
+static int bpf_fill_staggered_jsgt32_imm(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP32_IMM(BPF_JSGT, R1, -2, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, -1, 0);
+}
+
+static int bpf_fill_staggered_jsge32_imm(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP32_IMM(BPF_JSGE, R1, -2, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, -2, 0);
+}
+
+static int bpf_fill_staggered_jslt32_imm(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP32_IMM(BPF_JSLT, R1, -1, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, -2, 0);
+}
+
+static int bpf_fill_staggered_jsle32_imm(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP32_IMM(BPF_JSLE, R1, -1, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, -1, 0);
+}
+
+/* 32-bit register jumps */
+static int bpf_fill_staggered_jeq32_reg(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP32_REG(BPF_JEQ, R1, R2, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, 1234, 1234);
+}
+
+static int bpf_fill_staggered_jne32_reg(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP32_REG(BPF_JNE, R1, R2, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, 4321, 1234);
+}
+
+static int bpf_fill_staggered_jset32_reg(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP32_REG(BPF_JSET, R1, R2, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, 0x86, 0x82);
+}
+
+static int bpf_fill_staggered_jgt32_reg(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP32_REG(BPF_JGT, R1, R2, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, 0x80000000, 1234);
+}
+
+static int bpf_fill_staggered_jge32_reg(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP32_REG(BPF_JGE, R1, R2, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, 1234, 1234);
+}
+
+static int bpf_fill_staggered_jlt32_reg(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP32_REG(BPF_JLT, R1, R2, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, 1234, 0x80000000);
+}
+
+static int bpf_fill_staggered_jle32_reg(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP32_REG(BPF_JLE, R1, R2, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, 1234, 1234);
+}
+
+static int bpf_fill_staggered_jsgt32_reg(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP32_REG(BPF_JSGT, R1, R2, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, -1, -2);
+}
+
+static int bpf_fill_staggered_jsge32_reg(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP32_REG(BPF_JSGE, R1, R2, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, -2, -2);
+}
+
+static int bpf_fill_staggered_jslt32_reg(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP32_REG(BPF_JSLT, R1, R2, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, -2, -1);
+}
+
+static int bpf_fill_staggered_jsle32_reg(struct bpf_test *self)
+{
+	struct bpf_insn jmp = BPF_JMP32_REG(BPF_JSLE, R1, R2, 0);
+
+	return __bpf_fill_staggered_jumps(self, &jmp, -1, -1);
+}
+
 
 static struct bpf_test tests[] = {
 	{
@@ -10225,6 +10645,415 @@ static struct bpf_test tests[] = {
 		.fill_helper = bpf_fill_jmp32_jsle_reg,
 		.nr_testruns = NR_PATTERN_RUNS,
 	},
+	/* Staggered jump sequences, immediate */
+	{
+		"Staggered jumps: JMP_JA",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_ja,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP_JEQ_K",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jeq_imm,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP_JNE_K",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jne_imm,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP_JSET_K",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jset_imm,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP_JGT_K",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jgt_imm,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP_JGE_K",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jge_imm,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP_JLT_K",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jlt_imm,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP_JLE_K",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jle_imm,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP_JSGT_K",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jsgt_imm,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP_JSGE_K",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jsge_imm,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP_JSLT_K",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jslt_imm,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP_JSLE_K",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jsle_imm,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	/* Staggered jump sequences, register */
+	{
+		"Staggered jumps: JMP_JEQ_X",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jeq_reg,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP_JNE_X",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jne_reg,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP_JSET_X",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jset_reg,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP_JGT_X",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jgt_reg,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP_JGE_X",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jge_reg,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP_JLT_X",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jlt_reg,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP_JLE_X",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jle_reg,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP_JSGT_X",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jsgt_reg,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP_JSGE_X",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jsge_reg,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP_JSLT_X",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jslt_reg,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP_JSLE_X",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jsle_reg,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	/* Staggered jump sequences, JMP32 immediate */
+	{
+		"Staggered jumps: JMP32_JEQ_K",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jeq32_imm,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP32_JNE_K",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jne32_imm,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP32_JSET_K",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jset32_imm,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP32_JGT_K",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jgt32_imm,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP32_JGE_K",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jge32_imm,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP32_JLT_K",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jlt32_imm,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP32_JLE_K",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jle32_imm,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP32_JSGT_K",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jsgt32_imm,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP32_JSGE_K",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jsge32_imm,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP32_JSLT_K",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jslt32_imm,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP32_JSLE_K",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jsle32_imm,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	/* Staggered jump sequences, JMP32 register */
+	{
+		"Staggered jumps: JMP32_JEQ_X",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jeq32_reg,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP32_JNE_X",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jne32_reg,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP32_JSET_X",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jset32_reg,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP32_JGT_X",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jgt32_reg,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP32_JGE_X",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jge32_reg,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP32_JLT_X",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jlt32_reg,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP32_JLE_X",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jle32_reg,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP32_JSGT_X",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jsgt32_reg,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP32_JSGE_X",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jsge32_reg,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP32_JSLT_X",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jslt32_reg,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
+	{
+		"Staggered jumps: JMP32_JSLE_X",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
+		.fill_helper = bpf_fill_staggered_jsle32_reg,
+		.nr_testruns = NR_STAGGERED_JMP_RUNS,
+	},
 };
 
 static struct net_device dev;
-- 
2.25.1

