Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF66DFD228
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 02:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfKOBEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 20:04:25 -0500
Received: from www62.your-server.de ([213.133.104.62]:50756 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727451AbfKOBEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 20:04:24 -0500
Received: from 57.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.57] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iVQ29-00081R-7G; Fri, 15 Nov 2019 02:04:21 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH rfc bpf-next 7/8] bpf, x86: emit patchable direct jump as tail call
Date:   Fri, 15 Nov 2019 02:04:01 +0100
Message-Id: <78a8cbc4887d00b3dc4705347f05572630650cbf.1573779287.git.daniel@iogearbox.net>
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

Add initial code emission for *direct* jumps for tail call maps in
order to avoid the retpoline overhead from a493a87f38cf ("bpf, x64:
implement retpoline for tail call") for situations that allow for
it, meaning, for known constant keys at verification time which are
used as index into the tail call map. In case of Cilium which makes
heavy use of tail calls, constant keys are used in the vast majority,
only for a single occurence we use a dynamic key.

High level outline is that if the target prog is NULL in the map, we
emit a 5-byte nop for the fall-through case and if not we emit a
5-byte direct relative jmp to the target bpf_func + skipped prologue
offset. Later during runtime, we patch these 5-byte nop/jmps upon
tail call map update or deletions dynamically. Note that on x86-64
the direct jmp works as we reuse the same stack frame and skip
prologue (as opposed to some other JIT implementations).

One of the issues is that the tail call map slots can change at any
given time even during JITing. Therefore, we have two passes: i) emit
nops for all patchable locations during main JITing phase until we
declare prog->jited = 1 eventually. At this point the image is stable,
not public yet and with all jmps disabled. While JITing, we collect
additional info like poke->ip in order to remember the patch location
for later modifications. In ii) fixup_bpf_tail_call_direct() walks
over the progs poke_tab, locks the tail call maps poke_mutex to
prevent from parallel updates and patches in the right locations via
__bpf_arch_text_poke(). Note, the main bpf_arch_text_poke() cannot
be used at this point since we're not yet exposed to kallsyms. After
patching, we activate that poke entry through poke->ip_stable.
Meaning, at this point any tail call map updates/deletions are not
going to ignore that poke entry anymore.

Example prog:

  # ./bpftool p d x i 1655
   0: (b7) r3 = 0
   1: (18) r2 = map[id:526]
   3: (85) call bpf_tail_call#12
   4: (b7) r0 = 1
   5: (95) exit

Before:

  # ./bpftool p d j i 1655
  0xffffffffc076e55c:
   0:   nopl   0x0(%rax,%rax,1)
   5:   push   %rbp
   6:   mov    %rsp,%rbp
   9:   sub    $0x200,%rsp
  10:   push   %rbx
  11:   push   %r13
  13:   push   %r14
  15:   push   %r15
  17:   pushq  $0x0                      _
  19:   xor    %edx,%edx                |_ index (arg 3)
  1b:   movabs $0xffff88d95cc82600,%rsi |_ map (arg 2)
  25:   mov    %edx,%edx                |  index >= array->map.max_entries
  27:   cmp    %edx,0x24(%rsi)          |
  2a:   jbe    0x0000000000000066       |_
  2c:   mov    -0x224(%rbp),%eax        |  tail call limit check
  32:   cmp    $0x20,%eax               |
  35:   ja     0x0000000000000066       |
  37:   add    $0x1,%eax                |
  3a:   mov    %eax,-0x224(%rbp)        |_
  40:   mov    0xd0(%rsi,%rdx,8),%rax   |_ prog = array->ptrs[index]
  48:   test   %rax,%rax                |  prog == NULL check
  4b:   je     0x0000000000000066       |_
  4d:   mov    0x30(%rax),%rax          |  goto *(prog->bpf_func + prologue_size)
  51:   add    $0x19,%rax               |
  55:   callq  0x0000000000000061       |  retpoline for indirect jump
  5a:   pause                           |
  5c:   lfence                          |
  5f:   jmp    0x000000000000005a       |
  61:   mov    %rax,(%rsp)              |
  65:   retq                            |_
  66:   mov    $0x1,%eax
  6b:   pop    %rbx
  6c:   pop    %r15
  6e:   pop    %r14
  70:   pop    %r13
  72:   pop    %rbx
  73:   leaveq
  74:   retq

After; state after JIT:

  # ./bpftool p d j i 1655
  0xffffffffc08e8930:
   0:   nopl   0x0(%rax,%rax,1)
   5:   push   %rbp
   6:   mov    %rsp,%rbp
   9:   sub    $0x200,%rsp
  10:   push   %rbx
  11:   push   %r13
  13:   push   %r14
  15:   push   %r15
  17:   pushq  $0x0                      _
  19:   xor    %edx,%edx                |_ index (arg 3)
  1b:   movabs $0xffff9d8afd74c000,%rsi |_ map (arg 2)
  25:   mov    -0x224(%rbp),%eax        |  tail call limit check
  2b:   cmp    $0x20,%eax               |
  2e:   ja     0x000000000000003e       |
  30:   add    $0x1,%eax                |
  33:   mov    %eax,-0x224(%rbp)        |_
  39:   jmpq   0xfffffffffffd1785       |_ [direct] goto *(prog->bpf_func + prologue_size)
  3e:   mov    $0x1,%eax
  43:   pop    %rbx
  44:   pop    %r15
  46:   pop    %r14
  48:   pop    %r13
  4a:   pop    %rbx
  4b:   leaveq
  4c:   retq

After; state after map update (target prog):

  # ./bpftool p d j i 1655
  0xffffffffc08e8930:
   0:   nopl   0x0(%rax,%rax,1)
   5:   push   %rbp
   6:   mov    %rsp,%rbp
   9:   sub    $0x200,%rsp
  10:   push   %rbx
  11:   push   %r13
  13:   push   %r14
  15:   push   %r15
  17:   pushq  $0x0
  19:   xor    %edx,%edx
  1b:   movabs $0xffff9d8afd74c000,%rsi
  25:   mov    -0x224(%rbp),%eax
  2b:   cmp    $0x20,%eax               .
  2e:   ja     0x000000000000003e       .
  30:   add    $0x1,%eax                .
  33:   mov    %eax,-0x224(%rbp)        |_
  39:   jmpq   0xffffffffffb09f55       |_ goto *(prog->bpf_func + prologue_size)
  3e:   mov    $0x1,%eax
  43:   pop    %rbx
  44:   pop    %r15
  46:   pop    %r14
  48:   pop    %r13
  4a:   pop    %rbx
  4b:   leaveq
  4c:   retq

After; state after map update (no prog):

  # ./bpftool p d j i 1655
  0xffffffffc08e8930:
   0:   nopl   0x0(%rax,%rax,1)
   5:   push   %rbp
   6:   mov    %rsp,%rbp
   9:   sub    $0x200,%rsp
  10:   push   %rbx
  11:   push   %r13
  13:   push   %r14
  15:   push   %r15
  17:   pushq  $0x0
  19:   xor    %edx,%edx
  1b:   movabs $0xffff9d8afd74c000,%rsi
  25:   mov    -0x224(%rbp),%eax
  2b:   cmp    $0x20,%eax               .
  2e:   ja     0x000000000000003e       .
  30:   add    $0x1,%eax                .
  33:   mov    %eax,-0x224(%rbp)        |_
  39:   nopl   0x0(%rax,%rax,1)         |_ fall-through nop
  3e:   mov    $0x1,%eax
  43:   pop    %rbx
  44:   pop    %r15
  46:   pop    %r14
  48:   pop    %r13
  4a:   pop    %rbx
  4b:   leaveq
  4c:   retq

Nice side-effect is that this also shrinks the code emission quite a
bit for for every tail call invocation.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 arch/x86/net/bpf_jit_comp.c | 252 ++++++++++++++++++++++--------------
 1 file changed, 157 insertions(+), 95 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 66921f2aeece..f4d294b0af2b 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -239,6 +239,105 @@ static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf)
 	*pprog = prog;
 }
 
+static int emit_patchable(u8 **pprog, void *func, void *ip, u8 b1)
+{
+	u8 *prog = *pprog;
+	int cnt = 0;
+	s64 offset;
+
+	offset = func - (ip + X86_PATCHABLE_SIZE);
+	if (!is_simm32(offset)) {
+		pr_err("Target call %p is out of range\n", func);
+		return -EINVAL;
+	}
+	EMIT1_off32(b1, offset);
+	*pprog = prog;
+	return 0;
+}
+
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
+static int __bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
+				void *old_addr, void *new_addr)
+{
+	int (*emit_patch)(u8 **pprog, void *func, void *ip);
+	u8 old_insn[X86_PATCHABLE_SIZE] = {};
+	u8 new_insn[X86_PATCHABLE_SIZE] = {};
+	u8 *prog;
+	int ret;
+
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
+	if (old_addr) {
+		prog = old_insn;
+		ret = emit_patch(&prog, old_addr, (void *)ip);
+		if (ret)
+			return ret;
+	}
+	if (new_addr) {
+		prog = new_insn;
+		ret = emit_patch(&prog, new_addr, (void *)ip);
+		if (ret)
+			return ret;
+	}
+
+	ret = -EBUSY;
+	mutex_lock(&text_mutex);
+	switch (t) {
+	case BPF_MOD_NOP_TO_CALL:
+	case BPF_MOD_NOP_TO_JUMP:
+		if (memcmp(ip, ideal_nops[NOP_ATOMIC5], X86_PATCHABLE_SIZE))
+			goto out;
+		text_poke_bp(ip, new_insn, X86_PATCHABLE_SIZE, NULL);
+		break;
+	case BPF_MOD_CALL_TO_CALL:
+	case BPF_MOD_JUMP_TO_JUMP:
+		if (memcmp(ip, old_insn, X86_PATCHABLE_SIZE))
+			goto out;
+		text_poke_bp(ip, new_insn, X86_PATCHABLE_SIZE, NULL);
+		break;
+	case BPF_MOD_CALL_TO_NOP:
+	case BPF_MOD_JUMP_TO_NOP:
+		if (memcmp(ip, old_insn, X86_PATCHABLE_SIZE))
+			goto out;
+		text_poke_bp(ip, ideal_nops[NOP_ATOMIC5], X86_PATCHABLE_SIZE,
+			     NULL);
+		break;
+	}
+	ret = 0;
+out:
+	mutex_unlock(&text_mutex);
+	return ret;
+}
+
+int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
+		       void *old_addr, void *new_addr)
+{
+	if (!is_kernel_text((long)ip) &&
+	    !is_bpf_text_address((long)ip))
+		/* BPF poking in modules is not supported */
+		return -EINVAL;
+
+	return __bpf_arch_text_poke(ip, t, old_addr, new_addr);
+}
+
 /*
  * Generate the following code:
  *
@@ -253,7 +352,7 @@ static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf)
  *   goto *(prog->bpf_func + prologue_size);
  * out:
  */
-static void emit_bpf_tail_call(u8 **pprog)
+static void emit_bpf_tail_call_indirect(u8 **pprog)
 {
 	u8 *prog = *pprog;
 	int label1, label2, label3;
@@ -320,6 +419,57 @@ static void emit_bpf_tail_call(u8 **pprog)
 	*pprog = prog;
 }
 
+static void emit_bpf_tail_call_direct(struct bpf_jit_poke_descriptor *poke,
+				      u8 **pprog, int addr, u8 *image)
+{
+	u8 *prog = *pprog;
+	int i, cnt = 0;
+
+	/*
+	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
+	 *	goto out;
+	 */
+	EMIT2_off32(0x8B, 0x85, -36 - MAX_BPF_STACK); /* mov eax, dword ptr [rbp - 548] */
+	EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);         /* cmp eax, MAX_TAIL_CALL_CNT */
+	EMIT2(X86_JA, 14);                            /* ja out */
+	EMIT3(0x83, 0xC0, 0x01);                      /* add eax, 1 */
+	EMIT2_off32(0x89, 0x85, -36 - MAX_BPF_STACK); /* mov dword ptr [rbp -548], eax */
+
+	poke->ip = image + (addr - X86_PATCHABLE_SIZE);
+	poke->adj_off = PROLOGUE_SIZE;
+
+	BUILD_BUG_ON(X86_PATCHABLE_SIZE != 5);
+	for (i = 0; i < X86_PATCHABLE_SIZE; i++)
+		EMIT1(ideal_nops[NOP_ATOMIC5][i]);
+
+	*pprog = prog;
+}
+
+static void fixup_bpf_tail_call_direct(struct bpf_prog *prog)
+{
+	static const enum bpf_text_poke_type type = BPF_MOD_NOP_TO_JUMP;
+	struct bpf_jit_poke_descriptor *poke;
+	struct bpf_prog *target;
+	int i, ret;
+
+	for (i = 0; i < prog->aux->size_poke_tab; i++) {
+		poke = &prog->aux->poke_tab[i];
+		if (poke->reason != BPF_POKE_REASON_TAIL_CALL)
+			continue;
+		bpf_map_poke_lock(poke->tc.map);
+		target = container_of(poke->tc.map, struct bpf_array,
+				      map)->ptrs[poke->tc.key];
+		if (target) {
+			ret = __bpf_arch_text_poke(poke->ip, type, NULL,
+						   (u8 *)target->bpf_func +
+						   poke->adj_off);
+			BUG_ON(ret < 0);
+		}
+		WRITE_ONCE(poke->ip_stable, 1);
+		bpf_map_poke_unlock(poke->tc.map);
+	}
+}
+
 static void emit_mov_imm32(u8 **pprog, bool sign_propagate,
 			   u32 dst_reg, const u32 imm32)
 {
@@ -481,99 +631,6 @@ static void emit_stx(u8 **pprog, u32 size, u32 dst_reg, u32 src_reg, int off)
 	*pprog = prog;
 }
 
-static int emit_patchable(u8 **pprog, void *func, void *ip, u8 b1)
-{
-	u8 *prog = *pprog;
-	int cnt = 0;
-	s64 offset;
-
-	offset = func - (ip + X86_PATCHABLE_SIZE);
-	if (!is_simm32(offset)) {
-		pr_err("Target call %p is out of range\n", func);
-		return -EINVAL;
-	}
-	EMIT1_off32(b1, offset);
-	*pprog = prog;
-	return 0;
-}
-
-static int emit_call(u8 **pprog, void *func, void *ip)
-{
-	return emit_patchable(pprog, func, ip, 0xE8);
-}
-
-static int emit_jump(u8 **pprog, void *func, void *ip)
-{
-	return emit_patchable(pprog, func, ip, 0xE9);
-}
-
-int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
-		       void *old_addr, void *new_addr)
-{
-	int (*emit_patch)(u8 **pprog, void *func, void *ip);
-	u8 old_insn[X86_PATCHABLE_SIZE] = {};
-	u8 new_insn[X86_PATCHABLE_SIZE] = {};
-	u8 *prog;
-	int ret;
-
-	if (!is_kernel_text((long)ip) &&
-	    !is_bpf_text_address((long)ip))
-		/* BPF poking in modules is not supported */
-		return -EINVAL;
-
-	switch (t) {
-	case BPF_MOD_NOP_TO_CALL ... BPF_MOD_CALL_TO_NOP:
-		emit_patch = emit_call;
-		break;
-	case BPF_MOD_NOP_TO_JUMP ... BPF_MOD_JUMP_TO_NOP:
-		emit_patch = emit_jump;
-		break;
-	default:
-		return -ENOTSUPP;
-	}
-
-	if (old_addr) {
-		prog = old_insn;
-		ret = emit_patch(&prog, old_addr, (void *)ip);
-		if (ret)
-			return ret;
-	}
-	if (new_addr) {
-		prog = new_insn;
-		ret = emit_patch(&prog, new_addr, (void *)ip);
-		if (ret)
-			return ret;
-	}
-
-	ret = -EBUSY;
-	mutex_lock(&text_mutex);
-	switch (t) {
-	case BPF_MOD_NOP_TO_CALL:
-	case BPF_MOD_NOP_TO_JUMP:
-		if (memcmp(ip, ideal_nops[NOP_ATOMIC5], X86_PATCHABLE_SIZE))
-			goto out;
-		text_poke_bp(ip, new_insn, X86_PATCHABLE_SIZE, NULL);
-		break;
-	case BPF_MOD_CALL_TO_CALL:
-	case BPF_MOD_JUMP_TO_JUMP:
-		if (memcmp(ip, old_insn, X86_PATCHABLE_SIZE))
-			goto out;
-		text_poke_bp(ip, new_insn, X86_PATCHABLE_SIZE, NULL);
-		break;
-	case BPF_MOD_CALL_TO_NOP:
-	case BPF_MOD_JUMP_TO_NOP:
-		if (memcmp(ip, old_insn, X86_PATCHABLE_SIZE))
-			goto out;
-		text_poke_bp(ip, ideal_nops[NOP_ATOMIC5], X86_PATCHABLE_SIZE,
-			     NULL);
-		break;
-	}
-	ret = 0;
-out:
-	mutex_unlock(&text_mutex);
-	return ret;
-}
-
 static bool ex_handler_bpf(const struct exception_table_entry *x,
 			   struct pt_regs *regs, int trapnr,
 			   unsigned long error_code, unsigned long fault_addr)
@@ -1041,7 +1098,11 @@ xadd:			if (is_imm8(insn->off))
 			break;
 
 		case BPF_JMP | BPF_TAIL_CALL:
-			emit_bpf_tail_call(&prog);
+			if (imm32)
+				emit_bpf_tail_call_direct(&bpf_prog->aux->poke_tab[imm32 - 1],
+							  &prog, addrs[i], image);
+			else
+				emit_bpf_tail_call_indirect(&prog);
 			break;
 
 			/* cond jump */
@@ -1610,6 +1671,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 		prog->bpf_func = (void *)image;
 		prog->jited = 1;
 		prog->jited_len = proglen;
+		fixup_bpf_tail_call_direct(prog);
 	} else {
 		prog = orig_prog;
 	}
-- 
2.21.0

