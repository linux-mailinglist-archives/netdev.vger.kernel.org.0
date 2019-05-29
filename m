Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4B762D9BD
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 11:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfE2J5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 05:57:24 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36677 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbfE2J5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 05:57:22 -0400
Received: by mail-wm1-f67.google.com with SMTP id v22so1139539wml.1
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 02:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jmR244p0L7KEhqm4CZvGQiomHPbgkGjwuYr3JXLhFX0=;
        b=Tc3hT79PRtblh4eYtq3+iC0QzcRTqQTicPGNAdhBybWTTz5jbU5DKfs2ACiHOmauQu
         3ZgNuSsy7Uog+EoZEWO38SDGedaa8N6R6aLAV0dqNMES+xchw4iXlR98WNQ7EB6+5+bB
         liFRFP6QAAdRwlcBDtMU8PBRTQQOeNtiLiUMLv5UBQbz+K7YaBEIWR2Gf4x8tLM9r71i
         5kyOVFtbwQy2tsfOU6hhcGNVTB4heZbygJhWJZz4twJbFReBQkxwM877vyRJrREea1KZ
         t8OoQ4FJrvU1lUZY+EHaeGCz/oQDaxX3JTUQp/tHmgEJTJlBtws1BOa/Jf5j03NRTQ7J
         LJwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jmR244p0L7KEhqm4CZvGQiomHPbgkGjwuYr3JXLhFX0=;
        b=ZAWD16mcv4PtgOdUilLWToAErM2516xAkuDZf6w88Tu/MWSk35ywC9tUCJ/C5mckR0
         ctJqu7YlsoO9MuqIrq42QX/Z4cFNDs6nTVjy++QGOKcmM90SDlzT9sBYmQtR1g2B859i
         Hs5YfD8YOOWxs95VP8ypE9a8vb2E6KGjW7KWfA9w3R3CWuAYolDznel3r1ES7PzJTdYN
         /tZWTvK35eO9iwfiStZXmc8XFpALu/Kda2iA3ZDgOtGZxDoSJoQqBgN94s5kQFuxIIEa
         kO30eigVRE5QolpDhuF8hhP2ulVO7Jt/05jpX53Ba0TPQtKUay4ZfkhDkbOM01GIDwyZ
         0qxg==
X-Gm-Message-State: APjAAAVOzYPYqaobG59efK6OfwRjE58JgO17gW/KGPqGXg3bMvsUppUz
        wSiGQmGFAB6RvaVSZUbytZX/IQ==
X-Google-Smtp-Source: APXvYqxWLW0+GDnMAqksjeDwWkx0o4LUuy1kodFS1ptt4WKZJTjG/tzri3j5d6aPXyLtxRzlTM4aEQ==
X-Received: by 2002:a05:600c:489:: with SMTP id d9mr5915205wme.173.1559123840230;
        Wed, 29 May 2019 02:57:20 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id 205sm6322206wmd.43.2019.05.29.02.57.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 29 May 2019 02:57:19 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bjorn.topel@intel.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH bpf 2/2] selftests: bpf: complete sub-register zero extension checks
Date:   Wed, 29 May 2019 10:57:09 +0100
Message-Id: <1559123829-9318-3-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559123829-9318-1-git-send-email-jiong.wang@netronome.com>
References: <1559123829-9318-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

eBPF ISA specification requires high 32-bit cleared when only low 32-bit
sub-register is written. JIT back-ends must guarantee this semantics when
doing code-gen.

This patch complete unit tests for all of those insns that could be visible
to JIT back-ends and defining sub-registers, if JIT back-ends failed to
guarantee the mentioned semantics, these unit tests will fail.

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 tools/testing/selftests/bpf/verifier/subreg.c | 516 +++++++++++++++++++++++++-
 1 file changed, 505 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/bpf/verifier/subreg.c b/tools/testing/selftests/bpf/verifier/subreg.c
index edeca3b..4c4133c 100644
--- a/tools/testing/selftests/bpf/verifier/subreg.c
+++ b/tools/testing/selftests/bpf/verifier/subreg.c
@@ -1,39 +1,533 @@
+/* This file contains sub-register zero extension checks for insns defining
+ * sub-registers, meaning:
+ *   - All insns under BPF_ALU class. Their BPF_ALU32 variants or narrow width
+ *     forms (BPF_END) could define sub-registers.
+ *   - Narrow direct loads, BPF_B/H/W | BPF_LDX.
+ *   - BPF_LD is not exposed to JIT back-ends, so no need for testing.
+ *
+ * "get_prandom_u32" is used to initialize low 32-bit of some registers to
+ * prevent potential optimizations done by verifier or JIT back-ends which could
+ * optimize register back into constant when range info shows one register is a
+ * constant.
+ */
 {
-	"or32 reg zero extend check",
+	"add32 reg zero extend check",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_LD_IMM64(BPF_REG_0, 0x100000000ULL),
+	BPF_ALU32_REG(BPF_ADD, BPF_REG_0, BPF_REG_1),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"add32 imm zero extend check",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x1000000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	/* An insn could have no effect on the low 32-bit, for example:
+	 *   a = a + 0
+	 *   a = a | 0
+	 *   a = a & -1
+	 * But, they should still zero high 32-bit.
+	 */
+	BPF_ALU32_IMM(BPF_ADD, BPF_REG_0, 0),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x1000000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	BPF_ALU32_IMM(BPF_ADD, BPF_REG_0, -2),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_6),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"sub32 reg zero extend check",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_LD_IMM64(BPF_REG_0, 0x1ffffffffULL),
+	BPF_ALU32_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"sub32 imm zero extend check",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x1000000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	BPF_ALU32_IMM(BPF_SUB, BPF_REG_0, 0),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x1000000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	BPF_ALU32_IMM(BPF_SUB, BPF_REG_0, 1),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_6),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"mul32 reg zero extend check",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_LD_IMM64(BPF_REG_0, 0x100000001ULL),
+	BPF_ALU32_REG(BPF_MUL, BPF_REG_0, BPF_REG_1),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"mul32 imm zero extend check",
 	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x1000000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	BPF_ALU32_IMM(BPF_MUL, BPF_REG_0, 1),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x1000000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	BPF_ALU32_IMM(BPF_MUL, BPF_REG_0, -1),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_6),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"div32 reg zero extend check",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
 	BPF_MOV64_IMM(BPF_REG_0, -1),
-	BPF_MOV64_IMM(BPF_REG_2, -2),
-	BPF_ALU32_REG(BPF_OR, BPF_REG_0, BPF_REG_2),
+	BPF_ALU32_REG(BPF_DIV, BPF_REG_0, BPF_REG_1),
 	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
 	BPF_EXIT_INSN(),
 	},
-	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"div32 imm zero extend check",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x1000000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	BPF_ALU32_IMM(BPF_DIV, BPF_REG_0, 1),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x1000000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	BPF_ALU32_IMM(BPF_DIV, BPF_REG_0, 2),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_6),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"or32 reg zero extend check",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_LD_IMM64(BPF_REG_0, 0x100000001ULL),
+	BPF_ALU32_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"or32 imm zero extend check",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x1000000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	BPF_ALU32_IMM(BPF_OR, BPF_REG_0, 0),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x1000000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	BPF_ALU32_IMM(BPF_OR, BPF_REG_0, 1),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_6),
+	BPF_EXIT_INSN(),
+	},
 	.result = ACCEPT,
 	.retval = 0,
 },
 {
 	"and32 reg zero extend check",
 	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x100000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_1, BPF_REG_0),
+	BPF_LD_IMM64(BPF_REG_0, 0x1ffffffffULL),
+	BPF_ALU32_REG(BPF_AND, BPF_REG_0, BPF_REG_1),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"and32 imm zero extend check",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x1000000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	BPF_ALU32_IMM(BPF_AND, BPF_REG_0, -1),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x1000000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	BPF_ALU32_IMM(BPF_AND, BPF_REG_0, -2),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_6),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"lsh32 reg zero extend check",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x100000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	BPF_MOV64_IMM(BPF_REG_1, 1),
+	BPF_ALU32_REG(BPF_LSH, BPF_REG_0, BPF_REG_1),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"lsh32 imm zero extend check",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x1000000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	BPF_ALU32_IMM(BPF_LSH, BPF_REG_0, 0),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x1000000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	BPF_ALU32_IMM(BPF_LSH, BPF_REG_0, 1),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_6),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"rsh32 reg zero extend check",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x1000000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	BPF_MOV64_IMM(BPF_REG_1, 1),
+	BPF_ALU32_REG(BPF_RSH, BPF_REG_0, BPF_REG_1),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"rsh32 imm zero extend check",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x1000000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	BPF_ALU32_IMM(BPF_RSH, BPF_REG_0, 0),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x1000000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	BPF_ALU32_IMM(BPF_RSH, BPF_REG_0, 1),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_6),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"neg32 reg zero extend check",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x1000000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	BPF_ALU32_IMM(BPF_NEG, BPF_REG_0, 0),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"mod32 reg zero extend check",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
 	BPF_MOV64_IMM(BPF_REG_0, -1),
-	BPF_MOV64_IMM(BPF_REG_2, -2),
-	BPF_ALU32_REG(BPF_AND, BPF_REG_0, BPF_REG_2),
+	BPF_ALU32_REG(BPF_MOD, BPF_REG_0, BPF_REG_1),
 	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
 	BPF_EXIT_INSN(),
 	},
-	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"mod32 imm zero extend check",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x1000000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	BPF_ALU32_IMM(BPF_MOD, BPF_REG_0, 1),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x1000000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	BPF_ALU32_IMM(BPF_MOD, BPF_REG_0, 2),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_6),
+	BPF_EXIT_INSN(),
+	},
 	.result = ACCEPT,
 	.retval = 0,
 },
 {
 	"xor32 reg zero extend check",
 	.insns = {
-	BPF_MOV64_IMM(BPF_REG_0, -1),
-	BPF_MOV64_IMM(BPF_REG_2, 0),
-	BPF_ALU32_REG(BPF_XOR, BPF_REG_0, BPF_REG_2),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_LD_IMM64(BPF_REG_0, 0x100000000ULL),
+	BPF_ALU32_REG(BPF_XOR, BPF_REG_0, BPF_REG_1),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"xor32 imm zero extend check",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x1000000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	BPF_ALU32_IMM(BPF_XOR, BPF_REG_0, 1),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"mov32 reg zero extend check",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x100000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_1, BPF_REG_0),
+	BPF_LD_IMM64(BPF_REG_0, 0x100000000ULL),
+	BPF_MOV32_REG(BPF_REG_0, BPF_REG_1),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"mov32 imm zero extend check",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x1000000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	BPF_MOV32_IMM(BPF_REG_0, 0),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x1000000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	BPF_MOV32_IMM(BPF_REG_0, 1),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_6),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"arsh32 reg zero extend check",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x1000000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	BPF_MOV64_IMM(BPF_REG_1, 1),
+	BPF_ALU32_REG(BPF_ARSH, BPF_REG_0, BPF_REG_1),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"arsh32 imm zero extend check",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x1000000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	BPF_ALU32_IMM(BPF_ARSH, BPF_REG_0, 0),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x1000000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	BPF_ALU32_IMM(BPF_ARSH, BPF_REG_0, 1),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_6),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"end16 (to_le) reg zero extend check",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
+	BPF_ALU64_IMM(BPF_LSH, BPF_REG_6, 32),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_6),
+	BPF_ENDIAN(BPF_TO_LE, BPF_REG_0, 16),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"end32 (to_le) reg zero extend check",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
+	BPF_ALU64_IMM(BPF_LSH, BPF_REG_6, 32),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_6),
+	BPF_ENDIAN(BPF_TO_LE, BPF_REG_0, 32),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"end16 (to_be) reg zero extend check",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
+	BPF_ALU64_IMM(BPF_LSH, BPF_REG_6, 32),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_6),
+	BPF_ENDIAN(BPF_TO_BE, BPF_REG_0, 16),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"end32 (to_be) reg zero extend check",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
+	BPF_ALU64_IMM(BPF_LSH, BPF_REG_6, 32),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_6),
+	BPF_ENDIAN(BPF_TO_BE, BPF_REG_0, 32),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"ldx_b zero extend check",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_6, -4),
+	BPF_ST_MEM(BPF_W, BPF_REG_6, 0, 0xfaceb00c),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x1000000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_6, 0),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"ldx_h zero extend check",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_6, -4),
+	BPF_ST_MEM(BPF_W, BPF_REG_6, 0, 0xfaceb00c),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x1000000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_6, 0),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"ldx_w zero extend check",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_6, -4),
+	BPF_ST_MEM(BPF_W, BPF_REG_6, 0, 0xfaceb00c),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_LD_IMM64(BPF_REG_1, 0x1000000000ULL),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_0, BPF_REG_1),
+	BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_6, 0),
 	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
 	BPF_EXIT_INSN(),
 	},
-	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 	.result = ACCEPT,
 	.retval = 0,
 },
-- 
2.7.4

