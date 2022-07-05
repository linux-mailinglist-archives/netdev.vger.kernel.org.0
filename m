Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 106C456771B
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 21:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233163AbiGETDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 15:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233148AbiGETDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 15:03:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FAF1EED9;
        Tue,  5 Jul 2022 12:03:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1A2161A9D;
        Tue,  5 Jul 2022 19:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F37C341CD;
        Tue,  5 Jul 2022 19:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657047821;
        bh=twXRGeflIiQLxPwsyCeS4+rA2mqh/YP2Rp+Kgb+cTUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+RnlzTolVuNxH7C1F4MFa1JcC/xxUDroV2a0SS2HP2LR4WmSF7UFNxsyQHYn+ozn
         73bmDKGF9KiRAf1fyg3FFyIN1Tvcusw7CQzJgT9mhOu+RnlQc8PguDMp5+HMN8voFh
         qaMX80bq0f6/eqMaE/+b7rJqpoKh2xZX8XYmRqvjP/MqUyWS2OUIXtyo0+YfyJRjWm
         9prqOZRoiXjMhj0pOyM6hxdQ9VHub53OpzBF0XwN4MI1ShL3PrKLtPnlKkDOptdlSO
         AQB37CS2IRzeWM8qhlwCy5qHzD48JgWdCroIAaoxOtlZbSCsWTLcUbZ8da0xmO2e36
         BMGvJp7kzFQBQ==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Martynas Pumputis <m@lambda.lt>,
        Yutaro Hayakawa <yutaro.hayakawa@isovalent.com>
Subject: [PATCH RFC bpf-next 2/4] bpf: Use given function address for trampoline ip arg
Date:   Tue,  5 Jul 2022 21:03:06 +0200
Message-Id: <20220705190308.1063813-3-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220705190308.1063813-1-jolsa@kernel.org>
References: <20220705190308.1063813-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using function address given at the generation time as the trampline
ip argument. This way we don't need to read the ip from the stack and
care about CONFIG_X86_KERNEL_IBT option.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 2f460c67f9c7..1d23dd51a42f 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -2015,13 +2015,14 @@ static bool is_valid_bpf_tramp_flags(unsigned int flags)
 int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *image_end,
 				const struct btf_func_model *m, u32 flags,
 				struct bpf_tramp_links *tlinks,
-				void *orig_call)
+				void *func_addr)
 {
 	int ret, i, nr_args = m->nr_args;
 	int regs_off, ip_off, args_off, stack_size = nr_args * 8, run_ctx_off;
 	struct bpf_tramp_links *fentry = &tlinks[BPF_TRAMP_FENTRY];
 	struct bpf_tramp_links *fexit = &tlinks[BPF_TRAMP_FEXIT];
 	struct bpf_tramp_links *fmod_ret = &tlinks[BPF_TRAMP_MODIFY_RETURN];
+	void *orig_call = func_addr;
 	u8 **branches = NULL;
 	u8 *prog;
 	bool save_ret;
@@ -2097,12 +2098,10 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 
 	if (flags & BPF_TRAMP_F_IP_ARG) {
 		/* Store IP address of the traced function:
-		 * mov rax, QWORD PTR [rbp + 8]
-		 * sub rax, X86_PATCH_SIZE
+		 * mov rax, func_addr
 		 * mov QWORD PTR [rbp - ip_off], rax
 		 */
-		emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, 8);
-		EMIT4(0x48, 0x83, 0xe8, X86_PATCH_SIZE);
+		emit_mov_imm64(&prog, BPF_REG_0, (long) func_addr >> 32, (u32) (long) func_addr);
 		emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -ip_off);
 	}
 
-- 
2.35.3

