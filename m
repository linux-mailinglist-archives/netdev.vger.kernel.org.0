Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A49222A13E
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 00:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404447AbfEXW16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 18:27:58 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37713 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404448AbfEXW1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 18:27:34 -0400
Received: by mail-wr1-f67.google.com with SMTP id e15so11401073wrs.4
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 15:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xTwwuxPV3uUT4NunKLFggl50SO6uXgijXKYOVj0eUcM=;
        b=zkLSjg1s5hUs26HA4+PSKF0XsJnhSJMLQTtlwp93eaOq+mXPvkd1+JtayTyrsVv7tI
         /Prm6zhkyW34sRN/dbyekWk0MsW+bimSbEUOe7vR/kppaQ29or7zBxt3ob5rLiFOzEil
         gRPEAXUFbmZD1Mpo64CIuJwJZXAOaG4ovvqG+gg/6kirQgFhd48gBH/5jmlJDvEl6g48
         hYUPxezJkLvaeEfNIKKu9JpJOW2KHDFBJyezRuByoupBy5KQhp8XVh6j201YnIBQqPK7
         yQbX8PRYdGIfceDgSSrvDoKSgqq2UU0EhRsTnuFjs5LRJMCMNIOv/Wlc5fXxB4LZo+OM
         DxoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xTwwuxPV3uUT4NunKLFggl50SO6uXgijXKYOVj0eUcM=;
        b=Kvt57bn0IdI8IhY0HjVjdl5vQyLez2/IGTFRV4eUNHL296LnuZ1GShsvAt5q20BJy5
         eaXcQLmTZMj18NOIT8AjYEoBVNPDH405QX/qvsafDqaC/KkddYTGhcI8+YtFjLd7hxuZ
         YZ5DRZWXySivTtxvBYoQzlsV1Qv1McJiQBFf9anbAc0sCMW/qVXunC+M+/wAAWlZhy/9
         L4shOpqqOS/mC/rOqPCoQzUVsl+49wmk9N0Z+bUDLs94DQLqTry21C7UOu/MsPKtzVY9
         V0v/6oxkvPP3qtYcZsMvYtIKSr7BAP3t1yn61hC0XwwVjJMtK2MoYZMp/xMMv8U+vz6K
         Oxyw==
X-Gm-Message-State: APjAAAWB0Bm/+BxtqUz2VuKLQIP97LcQXFR6KgIIcveLG/uaou11nZg4
        292x4OlVht5qRhEHo2eI5iVDoQ==
X-Google-Smtp-Source: APXvYqyol9wi1r8Z6udpioamcbp0Jt4jtp8W4azgBiCWwGWYzCSlAfY2ngqztbLz7jftSj7186Bqig==
X-Received: by 2002:adf:e711:: with SMTP id c17mr27405166wrm.227.1558736851983;
        Fri, 24 May 2019 15:27:31 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id y10sm7194961wmg.8.2019.05.24.15.27.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 May 2019 15:27:31 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, davem@davemloft.net,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v9 bpf-next 09/17] selftests: bpf: adjust several test_verifier helpers for insn insertion
Date:   Fri, 24 May 2019 23:25:20 +0100
Message-Id: <1558736728-7229-10-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558736728-7229-1-git-send-email-jiong.wang@netronome.com>
References: <1558736728-7229-1-git-send-email-jiong.wang@netronome.com>
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
index 6e2fec8..fa9b5bf 100644
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
@@ -232,7 +241,7 @@ static void bpf_fill_scale1(struct bpf_test *self)
 	 * within 1m limit add MAX_TEST_INSNS - MAX_JMP_SEQ - 1 MOVs and 1 EXIT
 	 */
 	while (i < MAX_TEST_INSNS - MAX_JMP_SEQ - 1)
-		insn[i++] = BPF_ALU32_IMM(BPF_MOV, BPF_REG_0, 42);
+		insn[i++] = BPF_ALU64_IMM(BPF_MOV, BPF_REG_0, 42);
 	insn[i] = BPF_EXIT_INSN();
 	self->prog_len = i + 1;
 	self->retval = 42;
@@ -264,7 +273,7 @@ static void bpf_fill_scale2(struct bpf_test *self)
 	 * within 1m limit add MAX_TEST_INSNS - MAX_JMP_SEQ - 1 MOVs and 1 EXIT
 	 */
 	while (i < MAX_TEST_INSNS - MAX_JMP_SEQ - 1)
-		insn[i++] = BPF_ALU32_IMM(BPF_MOV, BPF_REG_0, 42);
+		insn[i++] = BPF_ALU64_IMM(BPF_MOV, BPF_REG_0, 42);
 	insn[i] = BPF_EXIT_INSN();
 	self->prog_len = i + 1;
 	self->retval = 42;
-- 
2.7.4

