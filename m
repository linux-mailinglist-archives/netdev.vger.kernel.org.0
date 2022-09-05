Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 617AF5AD387
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 15:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237347AbiIENO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 09:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237318AbiIENOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 09:14:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A05518341;
        Mon,  5 Sep 2022 06:14:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCCA7612A0;
        Mon,  5 Sep 2022 13:14:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0FCC433C1;
        Mon,  5 Sep 2022 13:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662383689;
        bh=73MXNlDfCk7Np3WdM/V2WZYYH+LgksZEBi+Nygzbg6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cYrFiJZfBvpooNjGh80BpiNvw1Pg9VvNXrpWMCPFeE5FVxEci9hCe9ZyvtBLit7Qz
         35qXAtJlTtOJUiUba90yDgrj5Y4lXXXF7p3HZZBS7NnfkIsdDUaigzwBBOgyL/1N/x
         C/hV4tnPdtgE70HhQBqVmUnCxoPiaq1W57P+ipAy/ofY/lvBmeKOVuzoBGPCbBafAR
         3pd5vEr11m7uKv/GDvGsC6aVjVht0Q0YZG1oHU3Uw+AM+J9ZDhcWw7F6LmlmWQX26g
         LGBRF/IUVehAHLpvGTq0cQzDajkBntqbRzW5+9VWg8vxPgpIoLXA7kf+ppyOVUZ/0j
         ZxRxgWDTF9C+w==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com
Subject: [PATCH v2 bpf-next 2/4] selftests/bpf: Extend KF_TRUSTED_ARGS test for __ref annotation
Date:   Mon,  5 Sep 2022 15:14:03 +0200
Message-Id: <1bea1050068d7ad50baa2f6b6c09c9eb1ae5b4dd.1662383493.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1662383493.git.lorenzo@kernel.org>
References: <cover.1662383493.git.lorenzo@kernel.org>
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
2.37.3

