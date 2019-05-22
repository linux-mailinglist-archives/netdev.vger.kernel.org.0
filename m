Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC8FC26A31
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 20:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729696AbfEVSz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 14:55:56 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36485 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728761AbfEVSzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 14:55:55 -0400
Received: by mail-wm1-f65.google.com with SMTP id j187so3295537wmj.1
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 11:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=S+W2odUo3nSc6T3Sfm6jiUu8ReAEI7X0SKf4MDUNqvQ=;
        b=B5FtgXXasfYdwdHUxmczJhbrWCPI7lWZisr4A/sAPxS6M6w6k2+6dBmHG/eV7gVISC
         B0svG3JGk4caXJ/KT4SkKjrnElBacv6KFa58YZa4ZB8zn2SagDSABW8y2bcVxqw2thPK
         BADy99sX/nQ/AdkUB0mlgGkdH9VonAbKIQOjIOzbiviw12TjDkzD17dod7YHabL8WYMK
         b+k2zvlMlMZPCphshZvzBbDYjiBcn7vZFIUmWwG1T/e/YfETsCCPivFDJXXEN0/yLpcE
         zVNi2dBJglI5KGjdM4YMX6NjTp+jWLOSD5/54WGPRU2ZgPEdAJhN8GX6u4ztj2sHvIyo
         OI1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=S+W2odUo3nSc6T3Sfm6jiUu8ReAEI7X0SKf4MDUNqvQ=;
        b=ZQBv7evlWRQbQIIIynxUfscPqFQabt7Buw946yi/IgAa6ztcZtf3iGKrju+v86PlIs
         e/GTGFHtrpZFtfPGKdli43D3q76oJ7A+aJRW7HuHtgRqqn7ll7kvVyp72x8ZjXwvXbGm
         bCMG6xG59fWQC0YaWO9ILupRIvhcnODIXxM056IZ+gJNJ2xLsRHVQzm0lcf23OTqho2K
         ll6YrosQ8dml1XNKArTbGYNuXxfMw6hzRxPujS7D7c3QVLCXv7+am5DnvMZy8DUDcl6D
         NS9Ps5rOyunENoz5h+0T6D9LkVk3DUuNATo8bK4Sx7L3rm3wL+30YZc3COaJPNU6Pfav
         SfXA==
X-Gm-Message-State: APjAAAW9FsZ9MozpG7SozjHSWCciiEJy05BuFEF62y4Frox6DLAG2eBU
        LdkjJ4ua9VRV0E8qzzVF8Mbc/w==
X-Google-Smtp-Source: APXvYqxgol2lbkT3TLS4hpBRwuNzyaEKpTvGh7z1osobbh5+OU4Y0+KGInmjinShKizCMyAwUDqNlA==
X-Received: by 2002:a1c:238d:: with SMTP id j135mr9257697wmj.46.1558551353587;
        Wed, 22 May 2019 11:55:53 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id t12sm16328801wro.2.2019.05.22.11.55.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 22 May 2019 11:55:53 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, davem@davemloft.net,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v7 bpf-next 04/16] bpf: verifier: insert zero extension according to analysis result
Date:   Wed, 22 May 2019 19:55:00 +0100
Message-Id: <1558551312-17081-5-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558551312-17081-1-git-send-email-jiong.wang@netronome.com>
References: <1558551312-17081-1-git-send-email-jiong.wang@netronome.com>
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
index 16d8ed9..560e17d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7621,6 +7621,38 @@ static int opt_remove_nops(struct bpf_verifier_env *env)
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
@@ -8472,6 +8504,15 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
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

