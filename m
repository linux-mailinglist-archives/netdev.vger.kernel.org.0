Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD98826EF
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 23:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731003AbfHEV3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 17:29:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730817AbfHEV3M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 17:29:12 -0400
Received: from localhost (c-67-180-165-146.hsd1.ca.comcast.net [67.180.165.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD1C021738;
        Mon,  5 Aug 2019 21:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565040552;
        bh=MjASglgn8BTMtieff6uUmdmCRgm59TSL7K3TJym9g50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zgfi6gTHrrzzkRMNsc6NBxiyxour/9Y2vPB3XFVICq0B5z2ih3CEP8vpwpiRBYenl
         k5sLfVwDMyy7co0hkjmkIzGVh2EYqxwPVXJv8WG2eryBMf50Bw6uVctaJ/jlzVttxE
         RhCdiM3ifYIKegrFMuxWZRUOgeyVp/fD461RnwEs=
From:   Andy Lutomirski <luto@kernel.org>
To:     LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Song Liu <songliubraving@fb.com>,
        Kees Cook <keescook@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>
Subject: [WIP 3/4] bpf: Add a way to mark functions as requiring privilege
Date:   Mon,  5 Aug 2019 14:29:04 -0700
Message-Id: <968f3551247a43e1104b198f2e58fb0595d425e7.1565040372.git.luto@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1565040372.git.luto@kernel.org>
References: <cover.1565040372.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is horribly incomplete:

 - I only marked one function as requiring privilege, and there are
   surely more.

 - Checking is_priv is probably not the right thing to do.  This should
   probably do something more clever.  At the very lease, it needs to
   integrate with the upcoming lockdown LSM infrastructure.

 - The seen_privileged_funcs mechanism is probably not a good solution.
   Instead we should check something while we still have enough context
   to give a good error message.  But we *don't* want to check for
   capabilities up front before even seeing a function call, since we
   don't want to inadvertently generate audit events for privileges that
   are never used.

So it's the idea that counts :)

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 include/linux/bpf.h          | 15 +++++++++++++++
 include/linux/bpf_verifier.h |  1 +
 kernel/bpf/verifier.c        |  8 ++++++++
 kernel/trace/bpf_trace.c     |  1 +
 4 files changed, 25 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 2d5e1a4dff6c..de31b9888b6c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -229,6 +229,7 @@ struct bpf_func_proto {
 	u64 (*func)(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
 	bool gpl_only;
 	bool pkt_access;
+	u16 privilege;
 	enum bpf_return_type ret_type;
 	enum bpf_arg_type arg1_type;
 	enum bpf_arg_type arg2_type;
@@ -237,6 +238,20 @@ struct bpf_func_proto {
 	enum bpf_arg_type arg5_type;
 };
 
+/*
+ * Some functions should require privilege to call at all, even in a test
+ * run.  These flags indicate why privilege is required.  The core BPF
+ * code will verify that the creator of such a program has the requisite
+ * privilege.
+ *
+ * NB: This means that anyone who creates a privileged program (due to
+ * such a call or due to a privilege-requiring pointer-to-integer conversion)
+ * is responsible for restricting access to the program in an appropriate
+ * manner.
+ */
+#define BPF_FUNC_PRIV_READ_KERNEL_MEMORY BIT(0)
+#define BPT_FUNC_PRIV_WRITE_GLOBAL_LOGS BIT(1)
+
 /* bpf_context is intentionally undefined structure. Pointer to bpf_context is
  * the first argument to eBPF programs.
  * For socket filters: 'struct bpf_context *' == 'struct sk_buff *'
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 5fe99f322b1c..9877f5753cf4 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -363,6 +363,7 @@ struct bpf_verifier_env {
 	u32 id_gen;			/* used to generate unique reg IDs */
 	bool allow_ptr_leaks;
 	bool seen_direct_write;
+	u16 seen_privileged_funcs;
 	struct bpf_insn_aux_data *insn_aux_data; /* array of per-insn state */
 	const struct bpf_line_info *prev_linfo;
 	struct bpf_verifier_log log;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 5900cbb966b1..5e048688fd8d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4129,6 +4129,9 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 
 	if (changes_data)
 		clear_all_pkt_pointers(env);
+
+	env->seen_privileged_funcs |= fn->privilege;
+
 	return 0;
 }
 
@@ -9371,6 +9374,11 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 	if (ret == 0)
 		adjust_btf_func(env);
 
+	if (env->seen_privileged_funcs && !is_priv) {
+		ret = -EPERM;
+		goto err_release_maps;
+	}
+
 err_release_maps:
 	if (!env->prog->aux->used_maps)
 		/* if we didn't copy map pointers into bpf_prog_info, release
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index ca1255d14576..d9454588d9e8 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -152,6 +152,7 @@ BPF_CALL_3(bpf_probe_read, void *, dst, u32, size, const void *, unsafe_ptr)
 static const struct bpf_func_proto bpf_probe_read_proto = {
 	.func		= bpf_probe_read,
 	.gpl_only	= true,
+	.privilege	= BPF_FUNC_PRIV_READ_KERNEL_MEMORY,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_UNINIT_MEM,
 	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
-- 
2.21.0

