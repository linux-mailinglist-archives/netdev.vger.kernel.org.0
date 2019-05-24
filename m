Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3EBA29755
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 13:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391194AbfEXLgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 07:36:01 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46677 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391140AbfEXLf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 07:35:58 -0400
Received: by mail-wr1-f68.google.com with SMTP id r7so9638876wrr.13
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 04:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xTwwuxPV3uUT4NunKLFggl50SO6uXgijXKYOVj0eUcM=;
        b=xUK4MnJjpnHyswF/dFXcC+ZzCjc6obPTzxM+zzz6IzwWHA8cW5IU65CczY11hzMMIS
         CXCEM/5sj5ICdP6knwcSANe0IZE5gkgklHB3XvxGKj4MC+w8d2tyDCD8pbWC476oYENQ
         gR/NNrrNXjUsrgVwVvciaAdBz7P0W8jTX/vMtd9NU1S7a0OzJXFSI8m6oWiWaKisIdfj
         AWRZUX7Aez8fLeCLgoZ44/P9qYfbZOsCjQzQfyVNtpZmSXlG6si88f4CbMahE/s1KzA+
         4v33pHpq82cGzaWRlr7SEx7nkLxgrplpEIyy7fxzruqxFDQO2M4pYarexHSkPu94AFW7
         mKTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xTwwuxPV3uUT4NunKLFggl50SO6uXgijXKYOVj0eUcM=;
        b=bExCPgZkJDKyNiHDhWMLVkgnxoXlR2YOGIpQBa0ZZ2a1LvG9C2spg+2sZxojU7RUXG
         r8uYTtZqK3p4od9JJuL6SldxwatR9aW+eGO68plg8mu+jKIwQMNfdRJAjUgVj0jEApHs
         rCmkO6XsZ/QHImd1zuYLXOK3dX5rjah01rASeQYvrPKGivY3/3UhMNUz4MzCphtebYQp
         tXgHJWtDkzkOqPDwbjZ3UnWSxja0xH1NULWuFRy8N44Lk1goOiSDprCoFq7h1QfrN57v
         MaT2jjIYR9XEVRtsLLEybf1xJEHwuif3EGkot5m1ZtvNMM9Bgl1VjuksiAYfwEvaMhg0
         X24A==
X-Gm-Message-State: APjAAAWxwdWBVrw+bSRmDy6NSnhV+QjBjYD4htwoOUK1ZPKvZEQ6a+lI
        motJcnjk+7a55pd4BcmR4n37Eg==
X-Google-Smtp-Source: APXvYqxKm9dGztRAm6hTAXc0xEl/WauBBSajRtDnIqEX+if6/XaFGJxtMxIjYbTxON8gZZj+EEkSYg==
X-Received: by 2002:a5d:54cc:: with SMTP id x12mr17107082wrv.303.1558697755479;
        Fri, 24 May 2019 04:35:55 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id x22sm2462902wmi.4.2019.05.24.04.35.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 May 2019 04:35:54 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, davem@davemloft.net,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v8 bpf-next 08/16] selftests: bpf: adjust several test_verifier helpers for insn insertion
Date:   Fri, 24 May 2019 12:35:18 +0100
Message-Id: <1558697726-4058-9-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558697726-4058-1-git-send-email-jiong.wang@netronome.com>
References: <1558697726-4058-1-git-send-email-jiong.wang@netronome.com>
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

