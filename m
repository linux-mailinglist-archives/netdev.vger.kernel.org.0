Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D66B10959
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 16:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfEAOoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 10:44:21 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51845 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbfEAOoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 10:44:20 -0400
Received: by mail-wm1-f65.google.com with SMTP id t76so3483374wmt.1
        for <netdev@vger.kernel.org>; Wed, 01 May 2019 07:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5YnD+NSqVK6fhGQF6L29e9Q4qjgxcPpyRRt0fRxS8v8=;
        b=q1nbJqrJiTzGptzGHdmpiAP29L5w7h56JERnBJ/hsL9eD+e1GNFItOsDGhz4buSOE4
         rYLkzxqti0Omb3fdJcRNQM0xawyY9SXnekLegO2yJTbBPDptvyTCFm6IN0MwVQnNbIeJ
         qmPcBdJRPrLDBoLhVv+Br+sKQ4pfktJNcdxaB+1ljK7+a5ux/Rkm8SzrCARDdimbNZUa
         O9pn2u5HM1ghFbS2r72UIEL1T7icQLxZ5sm/tldn7MaW1VQeADWQ58rfoQS0e6G5AfqR
         w2hgi4oIsT0Ekpynm1sr75j45uDTsMs6N/QFWbqSjzwfJr6C/LMH/LG+uFjTIIcAft8j
         QkpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5YnD+NSqVK6fhGQF6L29e9Q4qjgxcPpyRRt0fRxS8v8=;
        b=b1WhlYEmylUmRLRvbg7jDoYAQKYnilXytYkrtcSKVG9yTXAoX2Eo7kjV/1tbzoC5q3
         /DmsXJpSHUboWXgoan971xP/QK9ELNzE551lEoRxxcFLVF03tc65GCJ4IfpWjUYFMc3H
         n8+J1fcztgsxixceWDqyeP9FETfm+T3hC1Lu62Zs6TNwmvsuAoNWYEyEEy9TzbuCtckG
         lb+1nRVBJEXOhS8rkPg8FouS5eyTOVNb0B28KFyKgiEgroexEe4VD/dp/1KTxCBTVwlA
         M/s/rTJDuVIY5FeDjn5M7xJJSXBTJgfJ2wwGKGdBQv16LZ1XwVZAhsG3h7W/6vLOd+R+
         OOgQ==
X-Gm-Message-State: APjAAAVvmy+TE0xtIWdjl/7MX4lrkWuSUaBNnZfXo6YYZ3O6fxB8diX1
        JtNi3It4VsCZ5m4OeerwlRB7uw==
X-Google-Smtp-Source: APXvYqyNTyVEsYQuZUO9Erf+VGnO4B5wcXkCgkOEuZwQVrgDhWou+D7xCW9Ud8LncVTTBIwHOkdUKQ==
X-Received: by 2002:a1c:2e89:: with SMTP id u131mr7222867wmu.82.1556721859055;
        Wed, 01 May 2019 07:44:19 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id g10sm36164976wrq.2.2019.05.01.07.44.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 01 May 2019 07:44:18 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v5 bpf-next 09/17] selftests: bpf: adjust several test_verifier helpers for insn insertion
Date:   Wed,  1 May 2019 15:43:54 +0100
Message-Id: <1556721842-29836-10-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556721842-29836-1-git-send-email-jiong.wang@netronome.com>
References: <1556721842-29836-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  - bpf_fill_ld_abs_vlan_push_pop:
    Prevent zext happens inside PUSH_CNT loop. This could happen because
    of BPF_LD_ABS (32-bit def) + BPF_JMP (64-bit use), or BPF_LD_ABS +
    EXIT (64-bit use of R0). So, change BPF_JMP to BPF_JMP32 and redefine
    R0 at exit path to cut off the data-flow from inside the loop.

  - bpf_fill_jump_around_ld_abs:
    Jump range is limited to 16 bit. every ld_abs is replaced by 6 insns,
    but on arches like arm, ppc etc, there will be one BPF_ZEXT inserted
    to extend the error value of the inlined ld_abs sequence which then
    contains 7 insns. so, set the dividend to 7 so the testcase could
    work on all arches.

  - bpf_fill_scale1/bpf_fill_scale2:
    Both contains ~1M BPF_ALU32_IMM which will trigger ~1M insn patcher
    call because of hi32 randomization later when BPF_F_TEST_RND_HI32 is
    set for bpf selftests. Insn patcher is not efficient that 1M call to
    it will hang computer. So , change to BPF_ALU64_IMM to avoid hi32
    randomization.

Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 tools/testing/selftests/bpf/test_verifier.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index ccd896b..3dcdfd4 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -138,32 +138,36 @@ static void bpf_fill_ld_abs_vlan_push_pop(struct bpf_test *self)
 loop:
 	for (j = 0; j < PUSH_CNT; j++) {
 		insn[i++] = BPF_LD_ABS(BPF_B, 0);
-		insn[i] = BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0x34, len - i - 2);
+		/* jump to error label */
+		insn[i] = BPF_JMP32_IMM(BPF_JNE, BPF_REG_0, 0x34, len - i - 3);
 		i++;
 		insn[i++] = BPF_MOV64_REG(BPF_REG_1, BPF_REG_6);
 		insn[i++] = BPF_MOV64_IMM(BPF_REG_2, 1);
 		insn[i++] = BPF_MOV64_IMM(BPF_REG_3, 2);
 		insn[i++] = BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
 					 BPF_FUNC_skb_vlan_push),
-		insn[i] = BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, len - i - 2);
+		insn[i] = BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, len - i - 3);
 		i++;
 	}
 
 	for (j = 0; j < PUSH_CNT; j++) {
 		insn[i++] = BPF_LD_ABS(BPF_B, 0);
-		insn[i] = BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0x34, len - i - 2);
+		insn[i] = BPF_JMP32_IMM(BPF_JNE, BPF_REG_0, 0x34, len - i - 3);
 		i++;
 		insn[i++] = BPF_MOV64_REG(BPF_REG_1, BPF_REG_6);
 		insn[i++] = BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
 					 BPF_FUNC_skb_vlan_pop),
-		insn[i] = BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, len - i - 2);
+		insn[i] = BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, len - i - 3);
 		i++;
 	}
 	if (++k < 5)
 		goto loop;
 
-	for (; i < len - 1; i++)
-		insn[i] = BPF_ALU32_IMM(BPF_MOV, BPF_REG_0, 0xbef);
+	for (; i < len - 3; i++)
+		insn[i] = BPF_ALU64_IMM(BPF_MOV, BPF_REG_0, 0xbef);
+	insn[len - 3] = BPF_JMP_A(1);
+	/* error label */
+	insn[len - 2] = BPF_MOV32_IMM(BPF_REG_0, 0);
 	insn[len - 1] = BPF_EXIT_INSN();
 	self->prog_len = len;
 }
@@ -171,8 +175,13 @@ static void bpf_fill_ld_abs_vlan_push_pop(struct bpf_test *self)
 static void bpf_fill_jump_around_ld_abs(struct bpf_test *self)
 {
 	struct bpf_insn *insn = self->fill_insns;
-	/* jump range is limited to 16 bit. every ld_abs is replaced by 6 insns */
-	unsigned int len = (1 << 15) / 6;
+	/* jump range is limited to 16 bit. every ld_abs is replaced by 6 insns,
+	 * but on arches like arm, ppc etc, there will be one BPF_ZEXT inserted
+	 * to extend the error value of the inlined ld_abs sequence which then
+	 * contains 7 insns. so, set the dividend to 7 so the testcase could
+	 * work on all arches.
+	 */
+	unsigned int len = (1 << 15) / 7;
 	int i = 0;
 
 	insn[i++] = BPF_MOV64_REG(BPF_REG_6, BPF_REG_1);
@@ -230,7 +239,7 @@ static void bpf_fill_scale1(struct bpf_test *self)
 	 * within 1m limit add MAX_TEST_INSNS - 1025 MOVs and 1 EXIT
 	 */
 	while (i < MAX_TEST_INSNS - 1025)
-		insn[i++] = BPF_ALU32_IMM(BPF_MOV, BPF_REG_0, 42);
+		insn[i++] = BPF_ALU64_IMM(BPF_MOV, BPF_REG_0, 42);
 	insn[i] = BPF_EXIT_INSN();
 	self->prog_len = i + 1;
 	self->retval = 42;
@@ -261,7 +270,7 @@ static void bpf_fill_scale2(struct bpf_test *self)
 	 * within 1m limit add MAX_TEST_INSNS - 1025 MOVs and 1 EXIT
 	 */
 	while (i < MAX_TEST_INSNS - 1025)
-		insn[i++] = BPF_ALU32_IMM(BPF_MOV, BPF_REG_0, 42);
+		insn[i++] = BPF_ALU64_IMM(BPF_MOV, BPF_REG_0, 42);
 	insn[i] = BPF_EXIT_INSN();
 	self->prog_len = i + 1;
 	self->retval = 42;
-- 
2.7.4

