Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 186864E20DB
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 08:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344702AbiCUHDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 03:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344698AbiCUHC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 03:02:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB31C47573;
        Mon, 21 Mar 2022 00:01:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D1DBB8111E;
        Mon, 21 Mar 2022 07:01:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A704C340E8;
        Mon, 21 Mar 2022 07:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647846090;
        bh=u1STiVGzz0ru5k2gp8EX2bP4ct/KMQWeRO1OSnv21mY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iy07tSpXxuRvPhvIInY5zosmT9O597GdPTzqcHw/YLHkz3bdaqBgBDdhdXPAMA5cA
         +4rODK9F3A2R1zfJU2WPtgb1xZs/04LqReUxNoLwnmnRHFp68o7yjnNqgKvjnrvCcO
         SlVn63WUf8AyPtjjcaLYwMipp7YSrNj2FDdJeGlkgUB5dmZd5jbKcBZ440f5VfaT74
         sJgrQpjaH4Xysob/W+uijlj25w6RfmLXtXTdI0tNTD0RDJtqI/Poh0tKoIgY+b30Ob
         GLAo54dsIUQymWIwJ4aHKqlbxlj8wIUKNffXRXuQMhR8dB0Zv4j77GEwmNcUbUSTN9
         AvoFxB5EKfK/w==
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
Subject: [PATCH bpf-next 1/2] Revert "bpf: Add support to inline bpf_get_func_ip helper on x86"
Date:   Mon, 21 Mar 2022 08:01:12 +0100
Message-Id: <20220321070113.1449167-2-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321070113.1449167-1-jolsa@kernel.org>
References: <20220321070113.1449167-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 97ee4d20ee67eb462581a7af01442de6586e390b.

Following change is adding more complexity to bpf_get_func_ip
helper for kprobe_multi programs, which can't be inlined easily.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/verifier.c    | 21 +--------------------
 kernel/trace/bpf_trace.c |  1 -
 2 files changed, 1 insertion(+), 21 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0287176bfe9a..cf92f9c01556 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13678,7 +13678,7 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			continue;
 		}
 
-		/* Implement tracing bpf_get_func_ip inline. */
+		/* Implement bpf_get_func_ip inline. */
 		if (prog_type == BPF_PROG_TYPE_TRACING &&
 		    insn->imm == BPF_FUNC_get_func_ip) {
 			/* Load IP address from ctx - 16 */
@@ -13693,25 +13693,6 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			continue;
 		}
 
-#ifdef CONFIG_X86
-		/* Implement kprobe_multi bpf_get_func_ip inline. */
-		if (prog_type == BPF_PROG_TYPE_KPROBE &&
-		    eatype == BPF_TRACE_KPROBE_MULTI &&
-		    insn->imm == BPF_FUNC_get_func_ip) {
-			/* Load IP address from ctx (struct pt_regs) ip */
-			insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
-						  offsetof(struct pt_regs, ip));
-
-			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, 1);
-			if (!new_prog)
-				return -ENOMEM;
-
-			env->prog = prog = new_prog;
-			insn      = new_prog->insnsi + i + delta;
-			continue;
-		}
-#endif
-
 patch_call_imm:
 		fn = env->ops->get_func_proto(insn->imm, env->prog);
 		/* all functions that have prototype and verifier allowed
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 9a7b6be655e4..52c2998e1dc3 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1042,7 +1042,6 @@ static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe = {
 
 BPF_CALL_1(bpf_get_func_ip_kprobe_multi, struct pt_regs *, regs)
 {
-	/* This helper call is inlined by verifier on x86. */
 	return instruction_pointer(regs);
 }
 
-- 
2.35.1

