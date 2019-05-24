Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6522A142
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 00:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404431AbfEXW1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 18:27:30 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36781 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404408AbfEXW12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 18:27:28 -0400
Received: by mail-wm1-f66.google.com with SMTP id v22so3331212wml.1
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 15:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=alp57HodYFfImaYAX7nsf2qVWcWziZJB9RD0VS9QAaE=;
        b=J2mwVjl3+ye76JdHtATDzOnKsUC/wKW7Mqv/4l4pJBK3eIJHlq1fqYzkqpx0sp/u0T
         Au/34/b0pkvOAW538nxKNuZq0ygdQoqWgXWjC1MrwYuHy7OZUFAWY3DaGQyFqE1NL8S/
         R/BHsWSjkH2F6ehWjudvjPDfn9S/advTpvj4PFWK5W1ezV7CuhYN+p3pokpP0g7g6To+
         czBdNUqdaXz3u4MaBCvkTxPVNcrfDibgLnJFIicFKclF574LDy9sYPNJ3YjRIcw/M03A
         Ga8vyOk86hLnVhAHEl59T62J+4ejnrvfevt2WdHFPMHCIPd/Fe0Db+C/9bXUvTDrsm0V
         lq1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=alp57HodYFfImaYAX7nsf2qVWcWziZJB9RD0VS9QAaE=;
        b=mxdeurB6bvap4CyhVpu7mK3LsMpMRkccihmjHoMFvCZgH7xj+ilO0Y5klTg8knmXmk
         hA/70W4jvfX9MYfOzUkHOGaJ/XPcXB/qw09OvbLfAt/E14w9nqsmEj/rugz8Ojfjdo2w
         IekqGMqselIbRxS+Lgx11Somz9H6g+wO2e68N+rH3iOd1DLtgkOVLe/YAYQQ/Q0BBOpI
         uclUNZzOix4c7PUvbtDk/y/1HMATLkiA2l4KqeKgk+GixyM2jcOl7Cw2Wra7DRgoxMeB
         mbRqr1WBHsqK8kkwien+8j+CSHS4aTwxBN4E92ZvawlrX5W4Xf/ybseeXoIU2qSfyI8m
         bNjg==
X-Gm-Message-State: APjAAAWBbEdW1+uEo8GsVGbO26ObNkP5N9lADnIMtfsAd85dFHD+2ITK
        P78fVjPGWIhQzgFoHyeyi7XYkQ==
X-Google-Smtp-Source: APXvYqz7sgHKAGV09nSiwdHUv3Xyk5D7ub5HsgrNl38fUGQkRRz20T37syO3wQ8TKVKdA7Dn9eNevA==
X-Received: by 2002:a1c:cfce:: with SMTP id f197mr1365356wmg.56.1558736845831;
        Fri, 24 May 2019 15:27:25 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id y10sm7194961wmg.8.2019.05.24.15.27.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 May 2019 15:27:25 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, davem@davemloft.net,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v9 bpf-next 04/17] bpf: verifier: insert zero extension according to analysis result
Date:   Fri, 24 May 2019 23:25:15 +0100
Message-Id: <1558736728-7229-5-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558736728-7229-1-git-send-email-jiong.wang@netronome.com>
References: <1558736728-7229-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After previous patches, verifier will mark a insn if it really needs zero
extension on dst_reg.

It is then for back-ends to decide how to use such information to eliminate
unnecessary zero extension code-gen during JIT compilation.

One approach is verifier insert explicit zero extension for those insns
that need zero extension in a generic way, JIT back-ends then do not
generate zero extension for sub-register write at default.

However, only those back-ends which do not have hardware zero extension
want this optimization. Back-ends like x86_64 and AArch64 have hardware
zero extension support that the insertion should be disabled.

This patch introduces new target hook "bpf_jit_needs_zext" which returns
false at default, meaning verifier zero extension insertion is disabled at
default. A back-end could override this hook to return true if it doesn't
have hardware support and want verifier insert zero extension explicitly.

Offload targets do not use this native target hook, instead, they could
get the optimization results using bpf_prog_offload_ops.finalize.

NOTE: arches could have diversified features, it is possible for one arch
to have hardware zero extension support for some sub-register write insns
but not for all. For example, PowerPC, SPARC have zero extended loads, but
not for alu32. So when verifier zero extension insertion enabled, these JIT
back-ends need to peephole insns to remove those zero extension inserted
for insn that actually has hardware zero extension support. The peephole
could be as simple as looking the next insn, if it is a special zero
extension insn then it is safe to eliminate it if the current insn has
hardware zero extension support.

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 include/linux/bpf.h    |  1 +
 include/linux/filter.h |  1 +
 kernel/bpf/core.c      |  9 +++++++++
 kernel/bpf/verifier.c  | 41 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 52 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 4fb3aa2..d98141e 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -370,6 +370,7 @@ struct bpf_prog_aux {
 	u32 id;
 	u32 func_cnt; /* used by non-func prog as the number of func progs */
 	u32 func_idx; /* 0 for non-func prog, the index in func array for func prog */
+	bool verifier_zext; /* Zero extensions has been inserted by verifier. */
 	bool offload_requested;
 	struct bpf_prog **func;
 	void *jit_data; /* JIT specific data. arch dependent */
diff --git a/include/linux/filter.h b/include/linux/filter.h
index bb10ffb..ba8b6527 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -825,6 +825,7 @@ u64 __bpf_call_base(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
 
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog);
 void bpf_jit_compile(struct bpf_prog *prog);
+bool bpf_jit_needs_zext(void);
 bool bpf_helper_changes_pkt_data(void *func);
 
 static inline bool bpf_dump_raw_ok(void)
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 242a643..3675b19 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2090,6 +2090,15 @@ bool __weak bpf_helper_changes_pkt_data(void *func)
 	return false;
 }
 
+/* Return TRUE if the JIT backend wants verifier to enable sub-register usage
+ * analysis code and wants explicit zero extension inserted by verifier.
+ * Otherwise, return FALSE.
+ */
+bool __weak bpf_jit_needs_zext(void)
+{
+	return false;
+}
+
 /* To execute LD_ABS/LD_IND instructions __bpf_prog_run() may call
  * skb_copy_bits(), so provide a weak definition of it for NET-less config.
  */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a6af316..d4394a8 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7640,6 +7640,38 @@ static int opt_remove_nops(struct bpf_verifier_env *env)
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
+	zext_patch[1] = BPF_ZEXT_REG(0);
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
+		zext_patch[1].src_reg = insn.dst_reg;
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
@@ -8490,6 +8522,15 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 	if (ret == 0)
 		ret = fixup_bpf_calls(env);
 
+	/* do 32-bit optimization after insn patching has done so those patched
+	 * insns could be handled correctly.
+	 */
+	if (ret == 0 && bpf_jit_needs_zext() &&
+	    !bpf_prog_is_dev_bound(env->prog->aux)) {
+		ret = opt_subreg_zext_lo32(env);
+		env->prog->aux->verifier_zext = !ret;
+	}
+
 	if (ret == 0)
 		ret = fixup_call_args(env);
 
-- 
2.7.4

