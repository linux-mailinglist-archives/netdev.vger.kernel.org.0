Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E574030FA
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 00:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349343AbhIGWZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 18:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348091AbhIGWZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 18:25:08 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971D6C061796
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 15:24:00 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id v5so93346edc.2
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 15:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4Hoi4u2G8QSI9j8NSKtALs+4n115VKwNp7ykDTPYo/0=;
        b=I+8JwBdVzJ+ayEjXr3bm7ZAMRgaDCMMYC6/sjN9wx0+6Wwx2bqgRf+AQoDYV2LEC2y
         gRKM5HjxKIdN6KLahOUYW4YsqS3tX9CPrcAibe/cOxrwZwHSehybxbBcRbRDh5Objxd5
         ykO3p7Z5P2omOjHGgos7dzcOeqA1ZJN0/jMNpRz+WxYP7glc8U2/8nGwBgve61jVAYVZ
         LKR68dLYcAkdGy22RbO9AcZLjSFl/cMaR2B9HBn+yIekRazNDDEQKidfwhpZgYjAuEj4
         K5bbiBIHqoIv3z8njdqnFxZCE5qOmpsWyhv7UwyyhliJh6rym4BbAtFNNUCBUpeudxpl
         IKmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4Hoi4u2G8QSI9j8NSKtALs+4n115VKwNp7ykDTPYo/0=;
        b=mBQHF1qoXf6cyD8NoYZ7a74WL1CwmfpMk6B7CpDtVPjoQ2NFohoTq3nTgX6zIKad9W
         AlJZeihR/oN39fHK36e2ASzpMkcOA17BeQYNncKo818recU7gu0ZW9dIs7Al/7pHJYNd
         6IoArtCba9bJ259JeuP0HrEXuq650kj5X/Ob53qTFadUqFl157U970fFCmIsocoSSxIz
         HvE4NcXp/Wuuj/ew7KlmKnPw9ne1w6o3JzK78N3xf1siYfSHvh+psdvtXQ29oEEH4C3l
         1YZhqGGoKi3Nr73lnkXidbeBoFsiALR3iPA3qgOt/FxCrjsiFKP3RIE1Hg3EcfcQRiQj
         szEg==
X-Gm-Message-State: AOAM532ZFs33ftX2sWiNMtw2BxLwaUfYyijvckd/Zr+wzFxW8ywtV28b
        p0weHMSWFx3lfEWoHOCibkiTBg==
X-Google-Smtp-Source: ABdhPJy7swd6eI/NjrcwiSEAPou2swBQ1oUK7u0Rb0RnLK6xpm4x/Oap3lg2+jIMOYnt66pxPT2DeQ==
X-Received: by 2002:a05:6402:3188:: with SMTP id di8mr536275edb.300.1631053439113;
        Tue, 07 Sep 2021 15:23:59 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id gb24sm71772ejc.53.2021.09.07.15.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 15:23:58 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next v2 10/13] bpf/tests: Add JMP tests with degenerate conditional
Date:   Wed,  8 Sep 2021 00:23:36 +0200
Message-Id: <20210907222339.4130924-11-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210907222339.4130924-1-johan.almbladh@anyfinetworks.com>
References: <20210907222339.4130924-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a set of tests for JMP and JMP32 operations where the
branch decision is know at JIT time. Mainly testing JIT behaviour.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 229 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 229 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 7286cf347b95..ae261667ca0a 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -10709,6 +10709,235 @@ static struct bpf_test tests[] = {
 		.fill_helper = bpf_fill_jmp32_jsle_reg,
 		.nr_testruns = NR_PATTERN_RUNS,
 	},
+	/* Conditional jumps with constant decision */
+	{
+		"JMP_JSET_K: imm = 0 -> never taken",
+		.u.insns_int = {
+			BPF_ALU64_IMM(BPF_MOV, R0, 1),
+			BPF_JMP_IMM(BPF_JSET, R1, 0, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 0 } },
+	},
+	{
+		"JMP_JLT_K: imm = 0 -> never taken",
+		.u.insns_int = {
+			BPF_ALU64_IMM(BPF_MOV, R0, 1),
+			BPF_JMP_IMM(BPF_JLT, R1, 0, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 0 } },
+	},
+	{
+		"JMP_JGE_K: imm = 0 -> always taken",
+		.u.insns_int = {
+			BPF_ALU64_IMM(BPF_MOV, R0, 1),
+			BPF_JMP_IMM(BPF_JGE, R1, 0, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+	},
+	{
+		"JMP_JGT_K: imm = 0xffffffff -> never taken",
+		.u.insns_int = {
+			BPF_ALU64_IMM(BPF_MOV, R0, 1),
+			BPF_JMP_IMM(BPF_JGT, R1, U32_MAX, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 0 } },
+	},
+	{
+		"JMP_JLE_K: imm = 0xffffffff -> always taken",
+		.u.insns_int = {
+			BPF_ALU64_IMM(BPF_MOV, R0, 1),
+			BPF_JMP_IMM(BPF_JLE, R1, U32_MAX, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+	},
+	{
+		"JMP32_JSGT_K: imm = 0x7fffffff -> never taken",
+		.u.insns_int = {
+			BPF_ALU64_IMM(BPF_MOV, R0, 1),
+			BPF_JMP32_IMM(BPF_JSGT, R1, S32_MAX, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 0 } },
+	},
+	{
+		"JMP32_JSGE_K: imm = -0x80000000 -> always taken",
+		.u.insns_int = {
+			BPF_ALU64_IMM(BPF_MOV, R0, 1),
+			BPF_JMP32_IMM(BPF_JSGE, R1, S32_MIN, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+	},
+	{
+		"JMP32_JSLT_K: imm = -0x80000000 -> never taken",
+		.u.insns_int = {
+			BPF_ALU64_IMM(BPF_MOV, R0, 1),
+			BPF_JMP32_IMM(BPF_JSLT, R1, S32_MIN, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 0 } },
+	},
+	{
+		"JMP32_JSLE_K: imm = 0x7fffffff -> always taken",
+		.u.insns_int = {
+			BPF_ALU64_IMM(BPF_MOV, R0, 1),
+			BPF_JMP32_IMM(BPF_JSLE, R1, S32_MAX, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+	},
+	{
+		"JMP_JEQ_X: dst = src -> always taken",
+		.u.insns_int = {
+			BPF_ALU64_IMM(BPF_MOV, R0, 1),
+			BPF_JMP_REG(BPF_JEQ, R1, R1, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+	},
+	{
+		"JMP_JGE_X: dst = src -> always taken",
+		.u.insns_int = {
+			BPF_ALU64_IMM(BPF_MOV, R0, 1),
+			BPF_JMP_REG(BPF_JGE, R1, R1, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+	},
+	{
+		"JMP_JLE_X: dst = src -> always taken",
+		.u.insns_int = {
+			BPF_ALU64_IMM(BPF_MOV, R0, 1),
+			BPF_JMP_REG(BPF_JLE, R1, R1, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+	},
+	{
+		"JMP_JSGE_X: dst = src -> always taken",
+		.u.insns_int = {
+			BPF_ALU64_IMM(BPF_MOV, R0, 1),
+			BPF_JMP_REG(BPF_JSGE, R1, R1, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+	},
+	{
+		"JMP_JSLE_X: dst = src -> always taken",
+		.u.insns_int = {
+			BPF_ALU64_IMM(BPF_MOV, R0, 1),
+			BPF_JMP_REG(BPF_JSLE, R1, R1, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+	},
+	{
+		"JMP_JNE_X: dst = src -> never taken",
+		.u.insns_int = {
+			BPF_ALU64_IMM(BPF_MOV, R0, 1),
+			BPF_JMP_REG(BPF_JNE, R1, R1, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 0 } },
+	},
+	{
+		"JMP_JGT_X: dst = src -> never taken",
+		.u.insns_int = {
+			BPF_ALU64_IMM(BPF_MOV, R0, 1),
+			BPF_JMP_REG(BPF_JGT, R1, R1, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 0 } },
+	},
+	{
+		"JMP_JLT_X: dst = src -> never taken",
+		.u.insns_int = {
+			BPF_ALU64_IMM(BPF_MOV, R0, 1),
+			BPF_JMP_REG(BPF_JLT, R1, R1, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 0 } },
+	},
+	{
+		"JMP_JSGT_X: dst = src -> never taken",
+		.u.insns_int = {
+			BPF_ALU64_IMM(BPF_MOV, R0, 1),
+			BPF_JMP_REG(BPF_JSGT, R1, R1, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 0 } },
+	},
+	{
+		"JMP_JSLT_X: dst = src -> never taken",
+		.u.insns_int = {
+			BPF_ALU64_IMM(BPF_MOV, R0, 1),
+			BPF_JMP_REG(BPF_JSLT, R1, R1, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 0 } },
+	},
 	/* Short relative jumps */
 	{
 		"Short relative jump: offset=0",
-- 
2.25.1

