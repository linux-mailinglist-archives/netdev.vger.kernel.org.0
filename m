Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8084DAFA5
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 13:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355745AbiCPM1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 08:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355707AbiCPM0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 08:26:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC51065D31;
        Wed, 16 Mar 2022 05:25:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D09DB81A79;
        Wed, 16 Mar 2022 12:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91508C340E9;
        Wed, 16 Mar 2022 12:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647433523;
        bh=RZsAiCgamQw/VBmv4pya7wZRyPanEGSIbARyaYXI3JU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tp4VhGfc51BfgOzXjQZ7P3iVndWHipewigfCF4/7ZUAlqFWfHYsnMz3idsmvkxXrj
         pd9h6NlvHlsRpsAZNXyQ8DOGKdwvrTeHBnqa7vX7iPoiGTkslyvHRY6BgZtgeWfyK8
         zuWGjWi6t6UWW7+RAyZRxj/VrirpGy61b+zLV93NnoIPKEV+kQU3u9jvIaKRx2I2Dl
         nVqGeH6zPvyGCuaNTPiO3sU6Usa/EwpsrmKaPCgTpIu6f0OAoiI4rzghCtRmF7dJ9z
         XD5iDwStkQe4lrpwYCgQl16caV4Vj8/KUD8kc9Lho2VfaAgsMoo3inoa/G3ILZVwjm
         fglGPJcEoKIfA==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCHv3 bpf-next 05/13] bpf: Add support to inline bpf_get_func_ip helper on x86
Date:   Wed, 16 Mar 2022 13:24:11 +0100
Message-Id: <20220316122419.933957-6-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220316122419.933957-1-jolsa@kernel.org>
References: <20220316122419.933957-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support to inline it on x86, because it's single
load instruction.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/verifier.c    | 21 ++++++++++++++++++++-
 kernel/trace/bpf_trace.c |  1 +
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0db6cd8dcb35..c40f1aa07979 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13677,7 +13677,7 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			continue;
 		}
 
-		/* Implement bpf_get_func_ip inline. */
+		/* Implement tracing bpf_get_func_ip inline. */
 		if (prog_type == BPF_PROG_TYPE_TRACING &&
 		    insn->imm == BPF_FUNC_get_func_ip) {
 			/* Load IP address from ctx - 16 */
@@ -13692,6 +13692,25 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			continue;
 		}
 
+#ifdef CONFIG_X86
+		/* Implement kprobe_multi bpf_get_func_ip inline. */
+		if (prog_type == BPF_PROG_TYPE_KPROBE &&
+		    eatype == BPF_TRACE_KPROBE_MULTI &&
+		    insn->imm == BPF_FUNC_get_func_ip) {
+			/* Load IP address from ctx (struct pt_regs) ip */
+			insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
+						  offsetof(struct pt_regs, ip));
+
+			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, 1);
+			if (!new_prog)
+				return -ENOMEM;
+
+			env->prog = prog = new_prog;
+			insn      = new_prog->insnsi + i + delta;
+			continue;
+		}
+#endif
+
 patch_call_imm:
 		fn = env->ops->get_func_proto(insn->imm, env->prog);
 		/* all functions that have prototype and verifier allowed
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 250750932228..0e7f8c9bc756 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1039,6 +1039,7 @@ static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe = {
 
 BPF_CALL_1(bpf_get_func_ip_kprobe_multi, struct pt_regs *, regs)
 {
+	/* This helper call is inlined by verifier on x86. */
 	return instruction_pointer(regs);
 }
 
-- 
2.35.1

