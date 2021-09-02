Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6363FF392
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 20:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347345AbhIBSy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 14:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347238AbhIBSxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 14:53:53 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560BDC0617AF
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 11:52:52 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id z19so4381711edi.9
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 11:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xE2vatG15Bdcp+TUUj34HoSwRJXtzL9QIOGhWGZdLqU=;
        b=dAc3F1Sy7rI8V1OXc6APBRJzzt1ZbMG7WyWmajUal4fEcL/HCL//VgdByQ6ccrknwK
         GWvx+cpRFIMzQs6ybskOyqF9RgBikADu9N64GMPZgF5ofzSk4s5swyBrBEwALsKoOakn
         n0oZMIlOEfFdjkQaSPJdr3etEhxgR5xQmvumCUSz9+xcRjrc4NUuqx4lfW6Xf0XZpsz0
         YbTYk+keCKRBGtxhzRtdQtmHsOpTqUgch7VV9fRG1zl43zipxgdRzrns9pKA0ixINLYG
         oowUAr3X1HLcKwRoRe3ZweIvo+ET8Q2JRaMe8DLyajH0Kg3JosZE1WzeCmd+hdS4vdDk
         hSjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xE2vatG15Bdcp+TUUj34HoSwRJXtzL9QIOGhWGZdLqU=;
        b=GWTQMJwmfU+I/Tji0eZbHCwzWjUh42meNqAIVYCHOZGAoraV4yAawd9fK9EV1/capp
         Eb6Mhl6Cz1URUN+kXx0OolDkB1Padu48smJIUUS+iGCwMmwphAsxmFx0Lx1lskJmyVUy
         TxJuNUW51XVjpmiV0Br9BrLTsxvCjdKwyudLMQ/2h84FW9cvY/05Whu/PFUqvVyZfZmx
         PGFzf0YLFlKyKq4Baj+KGi0IKvkqYTsiyuQ44p+NUncqtR2HpwfXdGnuEf54wup09h6v
         mD0hy56tVAWI5redzB9EE7l3k0oPRVoJzDmkGgD7ugLR05KQWCLmVQllia5sD4Y6aXJc
         MiFw==
X-Gm-Message-State: AOAM531cs9zX5KAY1gheyIy6Cm4wGh2/cS0I0Bdx0bwdw7QLK9Oc6Mta
        scOuXpx6M1wy5V8yl6YE71KWNg==
X-Google-Smtp-Source: ABdhPJx0sqsXWSyLujF4eAF2W5CiTadxaemDaIfm64gvpVpZWtPVI/N4+1H1NeItVhfRfoU+Ibuwpg==
X-Received: by 2002:aa7:dd93:: with SMTP id g19mr4884801edv.262.1630608770988;
        Thu, 02 Sep 2021 11:52:50 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id mb14sm1592235ejb.81.2021.09.02.11.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 11:52:50 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        iii@linux.ibm.com
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next 13/13] bpf/tests: Add tail call limit test with external function call
Date:   Thu,  2 Sep 2021 20:52:29 +0200
Message-Id: <20210902185229.1840281-14-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210902185229.1840281-1-johan.almbladh@anyfinetworks.com>
References: <20210902185229.1840281-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a tail call limit test where the program also emits
a BPF_CALL to an external function prior to the tail call. Mainly
testing that JITed programs preserve its internal register state, for
example tail call count, across such external calls.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 48 insertions(+), 3 deletions(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index f138c6fad5ec..33c3fcc4c9f8 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -12257,6 +12257,20 @@ static struct tail_call_test tail_call_tests[] = {
 		},
 		.result = MAX_TAIL_CALL_CNT + 1,
 	},
+	{
+		"Tail call count preserved across function calls",
+		.insns = {
+			BPF_ALU64_IMM(BPF_ADD, R1, 1),
+			BPF_STX_MEM(BPF_DW, R10, R1, -8),
+			BPF_CALL_REL(0),
+			BPF_LDX_MEM(BPF_DW, R1, R10, -8),
+			BPF_ALU32_REG(BPF_MOV, R0, R1),
+			TAIL_CALL(0),
+			BPF_EXIT_INSN(),
+		},
+		.stack_depth = 8,
+		.result = MAX_TAIL_CALL_CNT + 1,
+	},
 	{
 		"Tail call error path, NULL target",
 		.insns = {
@@ -12279,6 +12293,29 @@ static struct tail_call_test tail_call_tests[] = {
 	},
 };
 
+/*
+ * A test function to be called from a BPF program, clobbering a lot of
+ * CPU registers in the process. A JITed BPF program calling this function
+ * must save and restore any caller-saved registers it uses for internal
+ * state, for example the current tail call count.
+ */
+BPF_CALL_1(test_bpf_func, u64, arg)
+{
+	char buf[64];
+	long a = 0;
+	long b = 1;
+	long c = 2;
+	long d = 3;
+	long e = 4;
+	long f = 5;
+	long g = 6;
+	long h = 7;
+
+	return snprintf(buf, sizeof(buf),
+			"%ld %lu %lx %ld %lu %lx %ld %lu %x",
+			a, b, c, d, e, f, g, h, (int)arg);
+}
+
 static void __init destroy_tail_call_tests(struct bpf_array *progs)
 {
 	int i;
@@ -12332,16 +12369,17 @@ static __init int prepare_tail_call_tests(struct bpf_array **pprogs)
 		for (i = 0; i < len; i++) {
 			struct bpf_insn *insn = &fp->insnsi[i];
 
-			if (insn->imm != TAIL_CALL_MARKER)
-				continue;
-
 			switch (insn->code) {
 			case BPF_LD | BPF_DW | BPF_IMM:
+				if (insn->imm != TAIL_CALL_MARKER)
+					break;
 				insn[0].imm = (u32)(long)progs;
 				insn[1].imm = ((u64)(long)progs) >> 32;
 				break;
 
 			case BPF_ALU | BPF_MOV | BPF_K:
+				if (insn->imm != TAIL_CALL_MARKER)
+					break;
 				if (insn->off == TAIL_CALL_NULL)
 					insn->imm = ntests;
 				else if (insn->off == TAIL_CALL_INVALID)
@@ -12349,6 +12387,13 @@ static __init int prepare_tail_call_tests(struct bpf_array **pprogs)
 				else
 					insn->imm = which + insn->off;
 				insn->off = 0;
+				break;
+
+			case BPF_JMP | BPF_CALL:
+				if (insn->src_reg != BPF_PSEUDO_CALL)
+					break;
+				*insn = BPF_EMIT_CALL(test_bpf_func);
+				break;
 			}
 		}
 
-- 
2.25.1

