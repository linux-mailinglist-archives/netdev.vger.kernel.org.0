Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6C8405989
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 16:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349289AbhIIOqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 10:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237302AbhIIOqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 10:46:05 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904FDC05BD36
        for <netdev@vger.kernel.org>; Thu,  9 Sep 2021 07:33:28 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id n27so4043625eja.5
        for <netdev@vger.kernel.org>; Thu, 09 Sep 2021 07:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z6CCIXp3/0lUB8b2ITGekrG0zOghhlWaucDl/1+HzwA=;
        b=TxqOBXOnSUU7VLEtnIhCMpWO9U66WBrCeKOgZpIwIiUALGE5q4Gpo1fJ++x2X+jKXD
         8tMR+yaMuhYezMFt/tsoRsqrihaK/PhiUkGx4rpQUifyFVZe1i50/ABdDpmS8umBFiQK
         0bJgLcWVaQ2EJdhwk3YMNAsLvGwZ/Nd7OGQQONN8mkWQF4NvsIv0cyScp6hNj+MRH9OI
         hWxD+lsMFuEaxamT985LvQMvnzfrXYqgN+6c8EZth9Fsg6MpJ6S/YzT+DG/UmBVdhOGS
         SLcFd08qTSKipSxreYQf0nxJyTuwGBvL75XWfYFIexVEdI6fKDj0H5l+IgAmyzOLm9ER
         6uOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z6CCIXp3/0lUB8b2ITGekrG0zOghhlWaucDl/1+HzwA=;
        b=vctnEVkmNvfB3uMUoTFHSO89zMFPZjKwNbkU6HtotGsQLShE9P3/5EzGIjvw6i3LpI
         UO1Mk6dHEQL7fqcDPJh+wSL2QoY1FYWFYyY2Jh82K2ic2agJadAm28Y4JnnOJT5SSZmi
         z4k2bSl/hx2BwRxjX3RtEe5iw6es5UUPBkqCszRKvt6PvVI1TZFYuSDbjvHd24Ra/JiC
         P4aCDfaoeZWlTXx3S0nYGQPOL8r6/Y9teVlM8OelEZtg07WEnIvda9dRcAPRl3EmexxH
         bWoVguUjLu3hIKJMPSksgslvAgi9oxK2J+H2H5KSC1Xbki/Ak26WBp/8emKw9iFEnZlq
         aJcA==
X-Gm-Message-State: AOAM530P+ptjwBljSvnFXv+ZLLWpfrFhFADASE96SB++D0YQo/uU/HGj
        Kch1LK42Y3xJb6IX3yDnI6ozKw==
X-Google-Smtp-Source: ABdhPJzf3Z6vUsyKJf4tpgjFYvONSrqXryJ2ztvhXEeVeWDNciO7iSdOo7jqF7GAOOHCP5IlpLH7/g==
X-Received: by 2002:a17:906:6148:: with SMTP id p8mr3755267ejl.263.1631198007088;
        Thu, 09 Sep 2021 07:33:27 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id bj10sm1030909ejb.17.2021.09.09.07.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 07:33:26 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next v3 13/13] bpf/tests: Add tail call limit test with external function call
Date:   Thu,  9 Sep 2021 16:33:03 +0200
Message-Id: <20210909143303.811171-14-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909143303.811171-1-johan.almbladh@anyfinetworks.com>
References: <20210909143303.811171-1-johan.almbladh@anyfinetworks.com>
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
 lib/test_bpf.c | 83 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 80 insertions(+), 3 deletions(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 7475abfd2186..152193b4080f 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -12202,6 +12202,30 @@ struct tail_call_test {
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
@@ -12259,6 +12283,25 @@ static struct tail_call_test tail_call_tests[] = {
 		},
 		.result = MAX_TAIL_CALL_CNT + 1,
 	},
+	{
+		"Tail call count preserved across function calls",
+		.insns = {
+			BPF_ALU64_IMM(BPF_ADD, R1, 1),
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
+		.result = MAX_TAIL_CALL_CNT + 1,
+	},
 	{
 		"Tail call error path, NULL target",
 		.insns = {
@@ -12333,17 +12376,19 @@ static __init int prepare_tail_call_tests(struct bpf_array **pprogs)
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
@@ -12351,6 +12396,38 @@ static __init int prepare_tail_call_tests(struct bpf_array **pprogs)
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

