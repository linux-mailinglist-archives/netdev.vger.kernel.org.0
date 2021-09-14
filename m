Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F88840AAAB
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 11:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbhINJVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 05:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbhINJUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 05:20:38 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D6DC0613D9
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 02:19:20 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id kt8so27333534ejb.13
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 02:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wuSu4wyeQe544QYrvabdyuLRDzOBYBuIdaBFG7YY+kM=;
        b=nSMM0JwGDd1OMdMdAzUtzmgNs6tnzkFC0D8Qpt7vGmebsAETRQgOzuYwb7T4oip1AT
         XIR/dKntRBIjIjvBrTGk6Zicpr/12JHIeUtpIaIkP1IoPjL56mvJh0dw+O41ZtOOcXTx
         I3Iallzij8EFydCDrNWUA+iQAChGiUjfX7OaYv8LklqeRO1mL1q6V2x3Y8cUvTLrAXYM
         VzxuRhMEM0vQk2sUJOkpuzSl0w0B2JMGHyzRYSc7Lla7sWpf0HB9HB29oNpzMCyKrPvL
         uSFOAGayBJfYEONws0XdL9FilwjhYMG7krdj6vbiJWLknJy/cJVU+mtI529jyXNqHJ0U
         oQ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wuSu4wyeQe544QYrvabdyuLRDzOBYBuIdaBFG7YY+kM=;
        b=194d2zPolMfPtwsSWzAkfkayvAb0MzN5XN6RqbENZD503k8PrM4VMKeG6hwlqwsF7O
         9bQQZmaOKlHwUbKsHt3lnS4p3nucX1d0nt+C7sFCxR3VPNIQaTIFuGrk91/SOcsvEvVU
         WRIa1yId44WepHMxKNdRVSZ+Xg3K/r0MNj3vQNahYdoyXGj9S5tzF5hrgetIznjI4ZlQ
         Qo+TFIRW09QlZDfsZqJnm+kY1SIgj/HNhJYEOpwvcL1jlhQ+atHy2dWsiOLteA5X3NVR
         8OTzE4ThrIbMC04L2hFSbRXzk2KGc1gjCllCEesZwUSu9Ab3HO0R/Hdp5ZgxAWoNX8lt
         WY1Q==
X-Gm-Message-State: AOAM533B9KolGhkODFDyqvUOFb7hgicDTVYxFoRGAXSi/nkUTAFA7WF+
        DxRX8xIeLXsxEZfo+NzQvvlY0w==
X-Google-Smtp-Source: ABdhPJwnxnO4rtzZQcp0bxDzK5ItJcRigcy3k/hTReYfP1lUVoqUp9JGjOiKTsWEICVNLqONWL6CUg==
X-Received: by 2002:a17:906:2ed1:: with SMTP id s17mr18489299eji.261.1631611159370;
        Tue, 14 Sep 2021 02:19:19 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id h10sm4615915ede.28.2021.09.14.02.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 02:19:18 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        paul@cilium.io, yangtiezhu@loongson.cn, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf v4 14/14] bpf/tests: Add tail call limit test with external function call
Date:   Tue, 14 Sep 2021 11:18:42 +0200
Message-Id: <20210914091842.4186267-15-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210914091842.4186267-1-johan.almbladh@anyfinetworks.com>
References: <20210914091842.4186267-1-johan.almbladh@anyfinetworks.com>
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
 lib/test_bpf.c | 86 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 83 insertions(+), 3 deletions(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index ddb9a8089d2e..99783088dcd0 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -12207,6 +12207,30 @@ struct tail_call_test {
 		     offset, TAIL_CALL_MARKER),	       \
 	BPF_JMP_IMM(BPF_TAIL_CALL, 0, 0, 0)
 
+/*
+ * A test function to be called from a BPF program, clobbering a lot of
+ * CPU registers in the process. A JITed BPF program calling this function
+ * must save and restore any caller-saved registers it uses for internal
+ * state, for example the current tail call count.
+ */
+BPF_CALL_1(bpf_test_func, u64, arg)
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
+#define BPF_FUNC_test_func __BPF_FUNC_MAX_ID
+
 /*
  * Tail call tests. Each test case may call any other test in the table,
  * including itself, specified as a relative index offset from the calling
@@ -12266,6 +12290,28 @@ static struct tail_call_test tail_call_tests[] = {
 		.flags = FLAG_NEED_STATE | FLAG_RESULT_IN_STATE,
 		.result = (MAX_TAIL_CALL_CNT + 1 + 1) * MAX_TESTRUNS,
 	},
+	{
+		"Tail call count preserved across function calls",
+		.insns = {
+			BPF_LDX_MEM(BPF_W, R2, R1, 0),
+			BPF_ALU64_IMM(BPF_ADD, R2, 1),
+			BPF_STX_MEM(BPF_W, R1, R2, 0),
+			BPF_STX_MEM(BPF_DW, R10, R1, -8),
+			BPF_CALL_REL(BPF_FUNC_get_numa_node_id),
+			BPF_CALL_REL(BPF_FUNC_ktime_get_ns),
+			BPF_CALL_REL(BPF_FUNC_ktime_get_boot_ns),
+			BPF_CALL_REL(BPF_FUNC_ktime_get_coarse_ns),
+			BPF_CALL_REL(BPF_FUNC_jiffies64),
+			BPF_CALL_REL(BPF_FUNC_test_func),
+			BPF_LDX_MEM(BPF_DW, R1, R10, -8),
+			BPF_ALU32_REG(BPF_MOV, R0, R1),
+			TAIL_CALL(0),
+			BPF_EXIT_INSN(),
+		},
+		.stack_depth = 8,
+		.flags = FLAG_NEED_STATE | FLAG_RESULT_IN_STATE,
+		.result = (MAX_TAIL_CALL_CNT + 1 + 1) * MAX_TESTRUNS,
+	},
 	{
 		"Tail call error path, NULL target",
 		.insns = {
@@ -12344,17 +12390,19 @@ static __init int prepare_tail_call_tests(struct bpf_array **pprogs)
 		/* Relocate runtime tail call offsets and addresses */
 		for (i = 0; i < len; i++) {
 			struct bpf_insn *insn = &fp->insnsi[i];
-
-			if (insn->imm != TAIL_CALL_MARKER)
-				continue;
+			long addr = 0;
 
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
@@ -12362,6 +12410,38 @@ static __init int prepare_tail_call_tests(struct bpf_array **pprogs)
 				else
 					insn->imm = which + insn->off;
 				insn->off = 0;
+				break;
+
+			case BPF_JMP | BPF_CALL:
+				if (insn->src_reg != BPF_PSEUDO_CALL)
+					break;
+				switch (insn->imm) {
+				case BPF_FUNC_get_numa_node_id:
+					addr = (long)&numa_node_id;
+					break;
+				case BPF_FUNC_ktime_get_ns:
+					addr = (long)&ktime_get_ns;
+					break;
+				case BPF_FUNC_ktime_get_boot_ns:
+					addr = (long)&ktime_get_boot_fast_ns;
+					break;
+				case BPF_FUNC_ktime_get_coarse_ns:
+					addr = (long)&ktime_get_coarse_ns;
+					break;
+				case BPF_FUNC_jiffies64:
+					addr = (long)&get_jiffies_64;
+					break;
+				case BPF_FUNC_test_func:
+					addr = (long)&bpf_test_func;
+					break;
+				default:
+					err = -EFAULT;
+					goto out_err;
+				}
+				*insn = BPF_EMIT_CALL(BPF_CAST_CALL(addr));
+				if ((long)__bpf_call_base + insn->imm != addr)
+					*insn = BPF_JMP_A(0); /* Skip: NOP */
+				break;
 			}
 		}
 
-- 
2.30.2

