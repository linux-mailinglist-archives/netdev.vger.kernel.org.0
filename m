Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 808654BFFB3
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 18:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbiBVRHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 12:07:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234545AbiBVRHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 12:07:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDBDDE84;
        Tue, 22 Feb 2022 09:07:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D95F160F89;
        Tue, 22 Feb 2022 17:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671A4C36AEB;
        Tue, 22 Feb 2022 17:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645549624;
        bh=7gGtwxVWHRIA9qaPB3Q5gClXDbN5Gk7FLicmyv8ugAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pmDa8PxQiE/gifqFM9N2SQADv5cyLNTBgNBio/yCR19/GLZd/GAb0kO66aro5D5NS
         7PC11NJZS8d0DQ+HZvX1Q+Vz41kYtOn3L4IlCTOUTfu43rLPsdtwUW55q/zWAzs1nW
         ZQ4wpZrQZ2Yi37VUjZ2ViFpH5kPUaH9L0f2WEa/s3uzOLx9b0d3RRmDc6XK6ASOLnk
         9HdlZB6oTAwZJOC0TWB50x5v4Y7O+NYcoE+tWo0ZKh0hdmhaS0/vg1ujQYfICpJWZJ
         yTI1UbKLjoeejkpzNWacxUSCWc8Lnc02aPDJRCJetgJdsUk13bMRh50+gBiCJY+SM8
         zCGaym35TYntg==
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
Subject: [PATCH 04/10] bpf: Add support to inline bpf_get_func_ip helper on x86
Date:   Tue, 22 Feb 2022 18:05:54 +0100
Message-Id: <20220222170600.611515-5-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220222170600.611515-1-jolsa@kernel.org>
References: <20220222170600.611515-1-jolsa@kernel.org>
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

Adding support to inline it on x86, because it's single
load instruction.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/verifier.c    | 21 ++++++++++++++++++++-
 kernel/trace/bpf_trace.c |  1 +
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d7473fee247c..f125c33a37c9 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13635,7 +13635,7 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			continue;
 		}
 
-		/* Implement bpf_get_func_ip inline. */
+		/* Implement tracing bpf_get_func_ip inline. */
 		if (prog_type == BPF_PROG_TYPE_TRACING &&
 		    insn->imm == BPF_FUNC_get_func_ip) {
 			/* Load IP address from ctx - 16 */
@@ -13650,6 +13650,25 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
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
index 64891b7b0885..c1998b9d5531 100644
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

