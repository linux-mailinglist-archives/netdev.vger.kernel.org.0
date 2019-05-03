Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1CDC12BAF
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 12:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbfECKnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 06:43:53 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37212 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfECKnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 06:43:50 -0400
Received: by mail-wr1-f66.google.com with SMTP id d22so139109wrb.4
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 03:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=o6b5gCI0kQsMVMTRnly2wwGRw9RnWLxNorJTJW60taw=;
        b=BPQmM9egHcjPaM66UAArqH6p6Z/HPl6MCnPrHPkE9wr+vYaUuBjemmgniyQjTd8p64
         2q12e6eh5/C9/xDqNcpsZ+/WUsZ7/HcxxkmWY3n44dBp1S/S1T8TZpQwEgAPzpa2WcVP
         QEdcM0aHjpINIX/JSXMxNSdFaLKZSmE0FF7BzLhzltDuX08247OBffzJOY1fvtLdPZ4K
         NQ78+HprHh9ydnoPJOer0V1fxZNAVpVLFic82B1Rcdesg8V+l7UzndQ3W4KTTLMcBTry
         0ZKNujs4mL9yM/wrtIelXTuI52O8eAIx7ltJvHJILLZZpV0ujKgCrr9m6lwArHpTYJXK
         pCGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=o6b5gCI0kQsMVMTRnly2wwGRw9RnWLxNorJTJW60taw=;
        b=bfyP1KCtFFJTuknHczdsGGSsmqv39HSlnWVNmnkIkNTQEcXUwnpPSb5G/5+Q7pkRe+
         iPOL8SAEGaIdWhtmCVpR7IxF0KIi6kv+kjmvp9bzQvNSAQ6MRY0L4IqeUoxuuOjPHd9M
         L0O5CZF5XMgkUdzcsiq/g+kPy9f6b7BJHasq9MzIrRPAwMQGA3GSmu9RNjhchEn0IbGV
         YUOMs3dG42GKQLPoHEmGaenrLNFsgI2vhq62/HdHqGlzhBTuKh75FNef/hSE+XMZgRNJ
         Gv8tvp+JiGiuhZyL834X0RWYDI3QZBsl80+egjdBDUTvkTvKDmYUdaFc2W0wKa137tQu
         Inzw==
X-Gm-Message-State: APjAAAUuDqrVcZcDIBOzth5w3DkMlexuUZle2s1F3ppiRWctRrBNh+LN
        3RTMgZcAqJgwNupqUYfcJLLw6F4a/wM=
X-Google-Smtp-Source: APXvYqymzev1szgI437Z8oEdFLBAFsO5nuGw1E6XOdwamRjM1CvQ4pzTO08Voc7rJ+sIrUWYLKhxRw==
X-Received: by 2002:a5d:67cb:: with SMTP id n11mr6397395wrw.3.1556880228379;
        Fri, 03 May 2019 03:43:48 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id r29sm1716999wra.56.2019.05.03.03.43.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 03 May 2019 03:43:47 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v6 bpf-next 05/17] bpf: verifier: insert BPF_ZEXT according to zext analysis result
Date:   Fri,  3 May 2019 11:42:32 +0100
Message-Id: <1556880164-10689-6-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com>
References: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After previous patches, verifier has marked those instructions that really
need zero extension on dst_reg.

It is then for all back-ends to decide how to use such information to
eliminate unnecessary zero extension code-gen during JIT compilation.

One approach is:
  1. Verifier insert explicit zero extension for those instructions that
     need zero extension.
  2. All JIT back-ends do NOT generate zero extension for sub-register
     write any more.

The good thing for this approach is no major change on JIT back-end
interface, all back-ends could get this optimization.

However, only those back-ends that do not have hardware zero extension
want this optimization. For back-ends like x86_64 and AArch64, there is
hardware support, so zext insertion should be disabled.

This patch introduces new target hook "bpf_jit_hardware_zext" which is
default true, meaning the underlying hardware will do zero extension
implicitly, therefore zext insertion by verifier will be disabled. Once a
back-end overrides this hook to false, then verifier will insert BPF_ZEXT
to clear high 32-bit of definitions when necessary.

Offload targets do not use this native target hook, instead, they could
get the optimization results using bpf_prog_offload_ops.finalize.

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 include/linux/bpf.h    |  1 +
 include/linux/filter.h |  1 +
 kernel/bpf/core.c      |  8 ++++++++
 kernel/bpf/verifier.c  | 40 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 50 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 11a5fb9..cf3c3f3 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -373,6 +373,7 @@ struct bpf_prog_aux {
 	u32 id;
 	u32 func_cnt; /* used by non-func prog as the number of func progs */
 	u32 func_idx; /* 0 for non-func prog, the index in func array for func prog */
+	bool verifier_zext; /* Zero extensions has been inserted by verifier. */
 	bool offload_requested;
 	struct bpf_prog **func;
 	void *jit_data; /* JIT specific data. arch dependent */
diff --git a/include/linux/filter.h b/include/linux/filter.h
index fb0edad..8750657 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -821,6 +821,7 @@ u64 __bpf_call_base(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
 
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog);
 void bpf_jit_compile(struct bpf_prog *prog);
+bool bpf_jit_hardware_zext(void);
 bool bpf_helper_changes_pkt_data(void *func);
 
 static inline bool bpf_dump_raw_ok(void)
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index ee8703d..9754346 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2095,6 +2095,14 @@ bool __weak bpf_helper_changes_pkt_data(void *func)
 	return false;
 }
 
+/* Return TRUE is the target hardware of JIT will do zero extension to high bits
+ * when writing to low 32-bit of one register. Otherwise, return FALSE.
+ */
+bool __weak bpf_jit_hardware_zext(void)
+{
+	return true;
+}
+
 /* To execute LD_ABS/LD_IND instructions __bpf_prog_run() may call
  * skb_copy_bits(), so provide a weak definition of it for NET-less config.
  */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b43e8a2..999da02 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7648,6 +7648,37 @@ static int opt_remove_nops(struct bpf_verifier_env *env)
 	return 0;
 }
 
+static int opt_subreg_zext_lo32(struct bpf_verifier_env *env)
+{
+	struct bpf_insn_aux_data *aux = env->insn_aux_data;
+	struct bpf_insn *insns = env->prog->insnsi;
+	int i, delta = 0, len = env->prog->len;
+	struct bpf_insn zext_patch[2];
+	struct bpf_prog *new_prog;
+
+	zext_patch[1] = BPF_ALU32_IMM(BPF_ZEXT, 0, 0);
+	for (i = 0; i < len; i++) {
+		int adj_idx = i + delta;
+		struct bpf_insn insn;
+
+		if (!aux[adj_idx].zext_dst)
+			continue;
+
+		insn = insns[adj_idx];
+		zext_patch[0] = insn;
+		zext_patch[1].dst_reg = insn.dst_reg;
+		new_prog = bpf_patch_insn_data(env, adj_idx, zext_patch, 2);
+		if (!new_prog)
+			return -ENOMEM;
+		env->prog = new_prog;
+		insns = new_prog->insnsi;
+		aux = env->insn_aux_data;
+		delta += 2;
+	}
+
+	return 0;
+}
+
 /* convert load instructions that access fields of a context type into a
  * sequence of instructions that access fields of the underlying structure:
  *     struct __sk_buff    -> struct sk_buff
@@ -8499,6 +8530,15 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 	if (ret == 0)
 		ret = fixup_bpf_calls(env);
 
+	/* do 32-bit optimization after insn patching has done so those patched
+	 * insns could be handled correctly.
+	 */
+	if (ret == 0 && !bpf_jit_hardware_zext() &&
+	    !bpf_prog_is_dev_bound(env->prog->aux)) {
+		ret = opt_subreg_zext_lo32(env);
+		env->prog->aux->verifier_zext = !ret;
+	}
+
 	if (ret == 0)
 		ret = fixup_call_args(env);
 
-- 
2.7.4

