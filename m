Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6103612BB7
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 12:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbfECKoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 06:44:00 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37218 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfECKnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 06:43:55 -0400
Received: by mail-wr1-f67.google.com with SMTP id d22so139372wrb.4
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 03:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5YnD+NSqVK6fhGQF6L29e9Q4qjgxcPpyRRt0fRxS8v8=;
        b=sItYbVo2wUf93MGkj2jUMdumjs2f7NgU0UDfWHoN0pQy1cNl1yt8W+3dUdYjRvoHWw
         kaNupo7Pn6ShbEaXoZQ1KaqvWaRuoA4PxG+aM3g6mVls2ktUOF7pwSJMn46tc5QZaKjY
         6Xg9x5U2a48lGHTvMwMAERY+xedDTZ9Qda5scP/dczqZsAbDJPazCAUq6iFYBfOBylAW
         ifsFNAajwzsZREyZMHFhyu83WYE1Y0/18LIO47Likus/I3W0zQ0KSQSuZ8aMWrpcnRgV
         4XHyWv14YDrIp17BAmlvFki64l2p6Q0TRToiFS3bc8A1DHqhE/Zj4iwU4l9cyeQ1omHA
         ekeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5YnD+NSqVK6fhGQF6L29e9Q4qjgxcPpyRRt0fRxS8v8=;
        b=JopYXEj9OwksBBFQDNtP36azfv5E+7lwuIdZ8/yfNOy4Pq6WCEu4aa5hMvjnmy1a5O
         iZ/Sp1Y5pJ4fReU0BK/RJ+eyiID7Xkj7HpXBrizLbJiHi1asMjeSijNJCoAi4qMaaiYj
         LdFcHEz3MpfdqG1H4nU0ddhVDTxp1KhpFtxO4vWX5FetOzlinvYzcffW1Iekgf+LUzTu
         UNGmaw3GTYMGBNbrw02AbqncRwnTjKXv4gFerkZnbSRVrq6j0ShkibNbmsPfRHzmg4GD
         ds7xmFxPJXKtmJrH6jPzANpkCK9dgHFG5Bn3nnmpP0sQfQ0jOTi0UwxdFQQDMVn6FXZy
         HPUQ==
X-Gm-Message-State: APjAAAXgTgX4KbIXlqZMjXLFxcnCq8BnSUyxSWT5xDc9QaJ/fpK3ujlI
        JMjfA+OI6ISfoza/OYJYiDJ6QNx74h8=
X-Google-Smtp-Source: APXvYqxRAUrqcleRUAnNOFOiK7NDzXQ48SFO+sweMddT50PDFvk3/xNJmREVQqPRD5o2bA7jk9FdhA==
X-Received: by 2002:a05:6000:45:: with SMTP id k5mr6632020wrx.261.1556880233071;
        Fri, 03 May 2019 03:43:53 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id r29sm1716999wra.56.2019.05.03.03.43.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 03 May 2019 03:43:52 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v6 bpf-next 09/17] selftests: bpf: adjust several test_verifier helpers for insn insertion
Date:   Fri,  3 May 2019 11:42:36 +0100
Message-Id: <1556880164-10689-10-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com>
References: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com>
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

