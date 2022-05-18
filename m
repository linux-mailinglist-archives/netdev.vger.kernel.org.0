Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA8752B7F4
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 12:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235217AbiERKo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 06:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235187AbiERKo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 06:44:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC8E52538;
        Wed, 18 May 2022 03:44:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCCDCB81F01;
        Wed, 18 May 2022 10:44:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EFD7C385AA;
        Wed, 18 May 2022 10:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652870662;
        bh=H08DQPrNlwPZStEmYgARTKjC6g6RtgiXUYPpiGX/+RI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EplQX/weLlc1xJZJyByVs+A+jDPHjqyYPXkJBWjcYkZ364Tjy88Mzvn5/CDWlYr6o
         TBf0pbdliIXyfwinbNbDawXQDmgUlzziIgn4JJZM5zy0S+A01Z2vcn418MLkyZJcGf
         mBj4+R6na53BfXEm2OBMa4Gf/vaTTmZTquFw89f/kx2S6jEHDXP1G83zAEbMou96q3
         COJnZFQulhgT0TwJCEGrJB+A9azSVOV72nz5cSLes0PZaXvFI3vEWuJ4RLvRyjWH91
         Hscq9CHnifJd89wcp6w4w2xFlmjAqC7YeRGPrtCXR1LsPQtxRUuWs2ktdW9FLrnb4J
         d15MQAMDK9fyQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com
Subject: [PATCH v3 bpf-next 2/5] selftests/bpf: Add verifier selftests for forced kfunc ref args
Date:   Wed, 18 May 2022 12:43:35 +0200
Message-Id: <987c9577695ef9d03c839100289dc432c7e22e4a.1652870182.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1652870182.git.lorenzo@kernel.org>
References: <cover.1652870182.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

Make sure verifier rejects the bad cases and ensure the good case keeps
working. The selftests make use of the bpf_kfunc_call_test_ref kfunc
added in the previous patch only for verification.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 tools/testing/selftests/bpf/verifier/calls.c | 53 ++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/tools/testing/selftests/bpf/verifier/calls.c b/tools/testing/selftests/bpf/verifier/calls.c
index 743ed34c1238..3fb4f69b1962 100644
--- a/tools/testing/selftests/bpf/verifier/calls.c
+++ b/tools/testing/selftests/bpf/verifier/calls.c
@@ -218,6 +218,59 @@
 	.result = REJECT,
 	.errstr = "variable ptr_ access var_off=(0x0; 0x7) disallowed",
 },
+{
+	"calls: invalid kfunc call: referenced arg needs refcounted PTR_TO_BTF_ID",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -8),
+	BPF_ST_MEM(BPF_DW, BPF_REG_1, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_6, 16),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.fixup_kfunc_btf_id = {
+		{ "bpf_kfunc_call_test_acquire", 3 },
+		{ "bpf_kfunc_call_test_ref", 8 },
+		{ "bpf_kfunc_call_test_ref", 10 },
+	},
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "R1 must be referenced",
+},
+{
+	"calls: valid kfunc call: referenced arg needs refcounted PTR_TO_BTF_ID",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -8),
+	BPF_ST_MEM(BPF_DW, BPF_REG_1, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.fixup_kfunc_btf_id = {
+		{ "bpf_kfunc_call_test_acquire", 3 },
+		{ "bpf_kfunc_call_test_ref", 8 },
+		{ "bpf_kfunc_call_test_release", 10 },
+	},
+	.result_unpriv = REJECT,
+	.result = ACCEPT,
+},
 {
 	"calls: basic sanity",
 	.insns = {
-- 
2.35.3

