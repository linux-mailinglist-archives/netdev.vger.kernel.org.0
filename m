Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 832185A9D59
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 18:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbiIAQoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 12:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235088AbiIAQoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 12:44:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805CA979D2;
        Thu,  1 Sep 2022 09:44:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 351AEB82897;
        Thu,  1 Sep 2022 16:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C06C433C1;
        Thu,  1 Sep 2022 16:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662050641;
        bh=nTRyDE/tlcu26oOgF+fqvvQmycX3GsZj+AE7SDb4RYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eIJpstqvLb7TrRdACrbInjFYN7NaMhFWkWZyHT+UFKZ5tLZd4q6Pf6zB8lsAcZgN4
         nJPHKH25QO267jpjdEO5Q2SUS3BZz1V0hSgkiG/NCYMFHM9/3v1LQmYe/V7/Owi/hJ
         menl6eKgFwv+INeadU5zaRgTNGepgkbAneoMVC7hbleE8dbIPvC1zuk2kZkddakEpf
         dQeEbkrO0YRSGWCW1zX06eMGhwxrli7/WIeN0hPpkkKU+QjJ7DoGYG8y4TuAM7ULq6
         V0rHAjSF9hYR3UUjEiHGuR0adoxV+8eKW1csIl8zOa3dJ73noY3dUqwd75Bl6c+ly/
         9FFlkYGLP1VgA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com
Subject: [PATCH bpf-next 2/4] selftests/bpf: Extend KF_TRUSTED_ARGS test for __ref annotation
Date:   Thu,  1 Sep 2022 18:43:25 +0200
Message-Id: <0f0bcb579a7e214c8286830375dae14d64b1af25.1662050126.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662050126.git.lorenzo@kernel.org>
References: <cover.1662050126.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

Extend the existing test for KF_TRUSTED_ARGS by also checking whether
the same happens when a __ref suffix is present in argument name of a
kfunc.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 tools/testing/selftests/bpf/verifier/calls.c | 38 +++++++++++++++-----
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/verifier/calls.c b/tools/testing/selftests/bpf/verifier/calls.c
index 3fb4f69b1962..891fcda50d9d 100644
--- a/tools/testing/selftests/bpf/verifier/calls.c
+++ b/tools/testing/selftests/bpf/verifier/calls.c
@@ -219,7 +219,7 @@
 	.errstr = "variable ptr_ access var_off=(0x0; 0x7) disallowed",
 },
 {
-	"calls: invalid kfunc call: referenced arg needs refcounted PTR_TO_BTF_ID",
+	"calls: invalid kfunc call: referenced arg needs refcounted PTR_TO_BTF_ID (KF_TRUSTED_ARGS)",
 	.insns = {
 	BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
 	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -8),
@@ -227,10 +227,30 @@
 	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
 	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
 	BPF_EXIT_INSN(),
-	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
-	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 16),
 	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
-	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_6, 16),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.fixup_kfunc_btf_id = {
+		{ "bpf_kfunc_call_test_acquire", 3 },
+		{ "bpf_kfunc_call_test_trusted", 7 },
+	},
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "R1 must be referenced",
+},
+{
+	"calls: invalid kfunc call: referenced arg needs refcounted PTR_TO_BTF_ID (__ref)",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -8),
+	BPF_ST_MEM(BPF_DW, BPF_REG_1, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 16),
 	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
@@ -238,8 +258,7 @@
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 	.fixup_kfunc_btf_id = {
 		{ "bpf_kfunc_call_test_acquire", 3 },
-		{ "bpf_kfunc_call_test_ref", 8 },
-		{ "bpf_kfunc_call_test_ref", 10 },
+		{ "bpf_kfunc_call_test_ref", 7 },
 	},
 	.result_unpriv = REJECT,
 	.result = REJECT,
@@ -259,14 +278,17 @@
 	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
 	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
 	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 	.fixup_kfunc_btf_id = {
 		{ "bpf_kfunc_call_test_acquire", 3 },
-		{ "bpf_kfunc_call_test_ref", 8 },
-		{ "bpf_kfunc_call_test_release", 10 },
+		{ "bpf_kfunc_call_test_trusted", 8 },
+		{ "bpf_kfunc_call_test_ref", 10 },
+		{ "bpf_kfunc_call_test_release", 12 },
 	},
 	.result_unpriv = REJECT,
 	.result = ACCEPT,
-- 
2.37.2

