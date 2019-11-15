Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5332EFD223
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 02:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbfKOBEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 20:04:21 -0500
Received: from www62.your-server.de ([213.133.104.62]:50706 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727080AbfKOBEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 20:04:21 -0500
Received: from 57.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.57] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iVQ26-00080Y-8P; Fri, 15 Nov 2019 02:04:18 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH rfc bpf-next 1/8] bpf, x86: generalize and extend bpf_arch_text_poke for direct jumps
Date:   Fri, 15 Nov 2019 02:03:55 +0100
Message-Id: <d2364bbaca1569b04e2434d8b58a458f21c685ef.1573779287.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1573779287.git.daniel@iogearbox.net>
References: <cover.1573779287.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25633/Thu Nov 14 10:50:04 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add BPF_MOD_{NOP_TO_JUMP,JUMP_TO_JUMP,JUMP_TO_NOP} patching for x86
JIT in order to be able to patch direct jumps or nop them out. We need
this facility in order to patch tail call jumps and in later work also
BPF static keys.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 arch/x86/net/bpf_jit_comp.c | 64 ++++++++++++++++++++++++++-----------
 include/linux/bpf.h         |  6 ++++
 2 files changed, 52 insertions(+), 18 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 2e586f579945..66921f2aeece 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -203,8 +203,9 @@ struct jit_context {
 /* Maximum number of bytes emitted while JITing one eBPF insn */
 #define BPF_MAX_INSN_SIZE	128
 #define BPF_INSN_SAFETY		64
-/* number of bytes emit_call() needs to generate call instruction */
-#define X86_CALL_SIZE		5
+
+/* Number of bytes emit_patchable() needs to generate instructions */
+#define X86_PATCHABLE_SIZE	5
 
 #define PROLOGUE_SIZE		25
 
@@ -215,7 +216,7 @@ struct jit_context {
 static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf)
 {
 	u8 *prog = *pprog;
-	int cnt = X86_CALL_SIZE;
+	int cnt = X86_PATCHABLE_SIZE;
 
 	/* BPF trampoline can be made to work without these nops,
 	 * but let's waste 5 bytes for now and optimize later
@@ -480,64 +481,91 @@ static void emit_stx(u8 **pprog, u32 size, u32 dst_reg, u32 src_reg, int off)
 	*pprog = prog;
 }
 
-static int emit_call(u8 **pprog, void *func, void *ip)
+static int emit_patchable(u8 **pprog, void *func, void *ip, u8 b1)
 {
 	u8 *prog = *pprog;
 	int cnt = 0;
 	s64 offset;
 
-	offset = func - (ip + X86_CALL_SIZE);
+	offset = func - (ip + X86_PATCHABLE_SIZE);
 	if (!is_simm32(offset)) {
 		pr_err("Target call %p is out of range\n", func);
 		return -EINVAL;
 	}
-	EMIT1_off32(0xE8, offset);
+	EMIT1_off32(b1, offset);
 	*pprog = prog;
 	return 0;
 }
 
+static int emit_call(u8 **pprog, void *func, void *ip)
+{
+	return emit_patchable(pprog, func, ip, 0xE8);
+}
+
+static int emit_jump(u8 **pprog, void *func, void *ip)
+{
+	return emit_patchable(pprog, func, ip, 0xE9);
+}
+
 int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
 		       void *old_addr, void *new_addr)
 {
-	u8 old_insn[X86_CALL_SIZE] = {};
-	u8 new_insn[X86_CALL_SIZE] = {};
+	int (*emit_patch)(u8 **pprog, void *func, void *ip);
+	u8 old_insn[X86_PATCHABLE_SIZE] = {};
+	u8 new_insn[X86_PATCHABLE_SIZE] = {};
 	u8 *prog;
 	int ret;
 
 	if (!is_kernel_text((long)ip) &&
 	    !is_bpf_text_address((long)ip))
-		/* BPF trampoline in modules is not supported */
+		/* BPF poking in modules is not supported */
 		return -EINVAL;
 
+	switch (t) {
+	case BPF_MOD_NOP_TO_CALL ... BPF_MOD_CALL_TO_NOP:
+		emit_patch = emit_call;
+		break;
+	case BPF_MOD_NOP_TO_JUMP ... BPF_MOD_JUMP_TO_NOP:
+		emit_patch = emit_jump;
+		break;
+	default:
+		return -ENOTSUPP;
+	}
+
 	if (old_addr) {
 		prog = old_insn;
-		ret = emit_call(&prog, old_addr, (void *)ip);
+		ret = emit_patch(&prog, old_addr, (void *)ip);
 		if (ret)
 			return ret;
 	}
 	if (new_addr) {
 		prog = new_insn;
-		ret = emit_call(&prog, new_addr, (void *)ip);
+		ret = emit_patch(&prog, new_addr, (void *)ip);
 		if (ret)
 			return ret;
 	}
+
 	ret = -EBUSY;
 	mutex_lock(&text_mutex);
 	switch (t) {
 	case BPF_MOD_NOP_TO_CALL:
-		if (memcmp(ip, ideal_nops[NOP_ATOMIC5], X86_CALL_SIZE))
+	case BPF_MOD_NOP_TO_JUMP:
+		if (memcmp(ip, ideal_nops[NOP_ATOMIC5], X86_PATCHABLE_SIZE))
 			goto out;
-		text_poke_bp(ip, new_insn, X86_CALL_SIZE, NULL);
+		text_poke_bp(ip, new_insn, X86_PATCHABLE_SIZE, NULL);
 		break;
 	case BPF_MOD_CALL_TO_CALL:
-		if (memcmp(ip, old_insn, X86_CALL_SIZE))
+	case BPF_MOD_JUMP_TO_JUMP:
+		if (memcmp(ip, old_insn, X86_PATCHABLE_SIZE))
 			goto out;
-		text_poke_bp(ip, new_insn, X86_CALL_SIZE, NULL);
+		text_poke_bp(ip, new_insn, X86_PATCHABLE_SIZE, NULL);
 		break;
 	case BPF_MOD_CALL_TO_NOP:
-		if (memcmp(ip, old_insn, X86_CALL_SIZE))
+	case BPF_MOD_JUMP_TO_NOP:
+		if (memcmp(ip, old_insn, X86_PATCHABLE_SIZE))
 			goto out;
-		text_poke_bp(ip, ideal_nops[NOP_ATOMIC5], X86_CALL_SIZE, NULL);
+		text_poke_bp(ip, ideal_nops[NOP_ATOMIC5], X86_PATCHABLE_SIZE,
+			     NULL);
 		break;
 	}
 	ret = 0;
@@ -1394,7 +1422,7 @@ int arch_prepare_bpf_trampoline(void *image, struct btf_func_model *m, u32 flags
 		/* skip patched call instruction and point orig_call to actual
 		 * body of the kernel function.
 		 */
-		orig_call += X86_CALL_SIZE;
+		orig_call += X86_PATCHABLE_SIZE;
 
 	prog = image;
 
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 42c112d2b3a9..562d9ade2926 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1283,10 +1283,16 @@ static inline u32 bpf_xdp_sock_convert_ctx_access(enum bpf_access_type type,
 #endif /* CONFIG_INET */
 
 enum bpf_text_poke_type {
+	/* All call-related pokes. */
 	BPF_MOD_NOP_TO_CALL,
 	BPF_MOD_CALL_TO_CALL,
 	BPF_MOD_CALL_TO_NOP,
+	/* All jump-related pokes. */
+	BPF_MOD_NOP_TO_JUMP,
+	BPF_MOD_JUMP_TO_JUMP,
+	BPF_MOD_JUMP_TO_NOP,
 };
+
 int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
 		       void *addr1, void *addr2);
 
-- 
2.21.0

