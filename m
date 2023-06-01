Return-Path: <netdev+bounces-7064-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 52C6D71996A
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 12:19:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C7901C209A6
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 10:19:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1499B42515;
	Thu,  1 Jun 2023 10:15:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C36542513;
	Thu,  1 Jun 2023 10:15:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A308C4339C;
	Thu,  1 Jun 2023 10:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685614505;
	bh=G2GdJVzAnUKaWnOT1TIoPAOd/IwXlrQ3DAxFtMYvPLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fMc3IUZIjV2o8AMw0NrnjHEPrq9u1V/LyWs/VxXTMokZCibw2xL5wgIFwcIxwuDQL
	 B2hJeVCtM/kQtm/+QoGK7QKLXDyuJzLK8wkNLwGzwXhCkYUqFj+3YM+T+MF0vbXkTO
	 1NCWdM02gpHmOd92bZSpMi5zoJ6gleYJkvsdOTcPs3uDaPyDdFvaf7JgqECftvKkGn
	 V83Lwg2PrWAiihvtavQekannW7SJnVqvEPuzLv4kqyplVFhtbdJOkdjdaHPHHXUQcD
	 KD8EsP14NPiqbvPVQNIIef3mObHow5F5dRYEXgVHenX3cnm55lwWVLdXRgZF4Ig2Oq
	 R+zMGOf1djivg==
From: Mike Rapoport <rppt@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"David S. Miller" <davem@davemloft.net>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Mike Rapoport <rppt@kernel.org>,
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Russell King <linux@armlinux.org.uk>,
	Song Liu <song@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Will Deacon <will@kernel.org>,
	bpf@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mips@vger.kernel.org,
	linux-mm@kvack.org,
	linux-modules@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	loongarch@lists.linux.dev,
	netdev@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH 12/13] x86/jitalloc: prepare to allocate exectuatble memory as ROX
Date: Thu,  1 Jun 2023 13:12:56 +0300
Message-Id: <20230601101257.530867-13-rppt@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230601101257.530867-1-rppt@kernel.org>
References: <20230601101257.530867-1-rppt@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Song Liu <song@kernel.org>

Replace direct memory writes to memory allocated for code with text poking
to allow allocation of executable memory as ROX.

The only exception is arch_prepare_bpf_trampoline() that cannot jit
directly into module memory yet, so it uses set_memory calls to
unprotect the memory before writing to it and to protect memory in the
end.

Signed-off-by: Song Liu <song@kernel.org>
Co-developed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
---
 arch/x86/kernel/alternative.c | 43 +++++++++++++++++++++++------------
 arch/x86/kernel/ftrace.c      | 41 +++++++++++++++++++++------------
 arch/x86/kernel/module.c      | 24 +++++--------------
 arch/x86/kernel/static_call.c | 10 ++++----
 arch/x86/kernel/unwind_orc.c  | 13 +++++++----
 arch/x86/net/bpf_jit_comp.c   | 22 +++++++++++++-----
 6 files changed, 91 insertions(+), 62 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index f615e0cb6d93..91057de8e6bc 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -18,6 +18,7 @@
 #include <linux/mmu_context.h>
 #include <linux/bsearch.h>
 #include <linux/sync_core.h>
+#include <linux/set_memory.h>
 #include <asm/text-patching.h>
 #include <asm/alternative.h>
 #include <asm/sections.h>
@@ -76,6 +77,19 @@ do {									\
 	}								\
 } while (0)
 
+void text_poke_early(void *addr, const void *opcode, size_t len);
+
+static void __init_or_module do_text_poke(void *addr, const void *opcode, size_t len)
+{
+	if (system_state < SYSTEM_RUNNING) {
+		text_poke_early(addr, opcode, len);
+	} else {
+		mutex_lock(&text_mutex);
+		text_poke(addr, opcode, len);
+		mutex_unlock(&text_mutex);
+	}
+}
+
 static const unsigned char x86nops[] =
 {
 	BYTES_NOP1,
@@ -108,7 +122,7 @@ static void __init_or_module add_nops(void *insns, unsigned int len)
 		unsigned int noplen = len;
 		if (noplen > ASM_NOP_MAX)
 			noplen = ASM_NOP_MAX;
-		memcpy(insns, x86_nops[noplen], noplen);
+		do_text_poke(insns, x86_nops[noplen], noplen);
 		insns += noplen;
 		len -= noplen;
 	}
@@ -120,7 +134,6 @@ extern s32 __cfi_sites[], __cfi_sites_end[];
 extern s32 __ibt_endbr_seal[], __ibt_endbr_seal_end[];
 extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
 extern s32 __smp_locks[], __smp_locks_end[];
-void text_poke_early(void *addr, const void *opcode, size_t len);
 
 /*
  * Are we looking at a near JMP with a 1 or 4-byte displacement.
@@ -331,7 +344,7 @@ void __init_or_module noinline apply_alternatives(struct alt_instr *start,
 
 		DUMP_BYTES(insn_buff, insn_buff_sz, "%px: final_insn: ", instr);
 
-		text_poke_early(instr, insn_buff, insn_buff_sz);
+		do_text_poke(instr, insn_buff, insn_buff_sz);
 
 next:
 		optimize_nops(instr, a->instrlen);
@@ -564,7 +577,7 @@ void __init_or_module noinline apply_retpolines(s32 *start, s32 *end)
 			optimize_nops(bytes, len);
 			DUMP_BYTES(((u8*)addr),  len, "%px: orig: ", addr);
 			DUMP_BYTES(((u8*)bytes), len, "%px: repl: ", addr);
-			text_poke_early(addr, bytes, len);
+			do_text_poke(addr, bytes, len);
 		}
 	}
 }
@@ -638,7 +651,7 @@ void __init_or_module noinline apply_returns(s32 *start, s32 *end)
 		if (len == insn.length) {
 			DUMP_BYTES(((u8*)addr),  len, "%px: orig: ", addr);
 			DUMP_BYTES(((u8*)bytes), len, "%px: repl: ", addr);
-			text_poke_early(addr, bytes, len);
+			do_text_poke(addr, bytes, len);
 		}
 	}
 }
@@ -674,7 +687,7 @@ static void poison_endbr(void *addr, bool warn)
 	 */
 	DUMP_BYTES(((u8*)addr), 4, "%px: orig: ", addr);
 	DUMP_BYTES(((u8*)&poison), 4, "%px: repl: ", addr);
-	text_poke_early(addr, &poison, 4);
+	do_text_poke(addr, &poison, 4);
 }
 
 /*
@@ -869,7 +882,7 @@ static int cfi_disable_callers(s32 *start, s32 *end)
 		if (!hash) /* nocfi callers */
 			continue;
 
-		text_poke_early(addr, jmp, 2);
+		do_text_poke(addr, jmp, 2);
 	}
 
 	return 0;
@@ -892,7 +905,7 @@ static int cfi_enable_callers(s32 *start, s32 *end)
 		if (!hash) /* nocfi callers */
 			continue;
 
-		text_poke_early(addr, mov, 2);
+		do_text_poke(addr, mov, 2);
 	}
 
 	return 0;
@@ -913,7 +926,7 @@ static int cfi_rand_preamble(s32 *start, s32 *end)
 			return -EINVAL;
 
 		hash = cfi_rehash(hash);
-		text_poke_early(addr + 1, &hash, 4);
+		do_text_poke(addr + 1, &hash, 4);
 	}
 
 	return 0;
@@ -932,9 +945,9 @@ static int cfi_rewrite_preamble(s32 *start, s32 *end)
 			 addr, addr, 5, addr))
 			return -EINVAL;
 
-		text_poke_early(addr, fineibt_preamble_start, fineibt_preamble_size);
+		do_text_poke(addr, fineibt_preamble_start, fineibt_preamble_size);
 		WARN_ON(*(u32 *)(addr + fineibt_preamble_hash) != 0x12345678);
-		text_poke_early(addr + fineibt_preamble_hash, &hash, 4);
+		do_text_poke(addr + fineibt_preamble_hash, &hash, 4);
 	}
 
 	return 0;
@@ -953,7 +966,7 @@ static int cfi_rand_callers(s32 *start, s32 *end)
 		hash = decode_caller_hash(addr);
 		if (hash) {
 			hash = -cfi_rehash(hash);
-			text_poke_early(addr + 2, &hash, 4);
+			do_text_poke(addr + 2, &hash, 4);
 		}
 	}
 
@@ -971,9 +984,9 @@ static int cfi_rewrite_callers(s32 *start, s32 *end)
 		addr -= fineibt_caller_size;
 		hash = decode_caller_hash(addr);
 		if (hash) {
-			text_poke_early(addr, fineibt_caller_start, fineibt_caller_size);
+			do_text_poke(addr, fineibt_caller_start, fineibt_caller_size);
 			WARN_ON(*(u32 *)(addr + fineibt_caller_hash) != 0x12345678);
-			text_poke_early(addr + fineibt_caller_hash, &hash, 4);
+			do_text_poke(addr + fineibt_caller_hash, &hash, 4);
 		}
 		/* rely on apply_retpolines() */
 	}
@@ -1243,7 +1256,7 @@ void __init_or_module apply_paravirt(struct paravirt_patch_site *start,
 
 		/* Pad the rest with nops */
 		add_nops(insn_buff + used, p->len - used);
-		text_poke_early(p->instr, insn_buff, p->len);
+		do_text_poke(p->instr, insn_buff, p->len);
 	}
 }
 extern struct paravirt_patch_site __start_parainstructions[],
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index aa99536b824c..d50595f2c1a6 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -118,10 +118,13 @@ ftrace_modify_code_direct(unsigned long ip, const char *old_code,
 		return ret;
 
 	/* replace the text with the new text */
-	if (ftrace_poke_late)
+	if (ftrace_poke_late) {
 		text_poke_queue((void *)ip, new_code, MCOUNT_INSN_SIZE, NULL);
-	else
-		text_poke_early((void *)ip, new_code, MCOUNT_INSN_SIZE);
+	} else {
+		mutex_lock(&text_mutex);
+		text_poke((void *)ip, new_code, MCOUNT_INSN_SIZE);
+		mutex_unlock(&text_mutex);
+	}
 	return 0;
 }
 
@@ -319,7 +322,7 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 	unsigned const char op_ref[] = { 0x48, 0x8b, 0x15 };
 	unsigned const char retq[] = { RET_INSN_OPCODE, INT3_INSN_OPCODE };
 	union ftrace_op_code_union op_ptr;
-	int ret;
+	void *ret;
 
 	if (ops->flags & FTRACE_OPS_FL_SAVE_REGS) {
 		start_offset = (unsigned long)ftrace_regs_caller;
@@ -350,15 +353,15 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 	npages = DIV_ROUND_UP(*tramp_size, PAGE_SIZE);
 
 	/* Copy ftrace_caller onto the trampoline memory */
-	ret = copy_from_kernel_nofault(trampoline, (void *)start_offset, size);
-	if (WARN_ON(ret < 0))
+	ret = text_poke_copy(trampoline, (void *)start_offset, size);
+	if (WARN_ON(!ret))
 		goto fail;
 
 	ip = trampoline + size;
 	if (cpu_feature_enabled(X86_FEATURE_RETHUNK))
 		__text_gen_insn(ip, JMP32_INSN_OPCODE, ip, x86_return_thunk, JMP32_INSN_SIZE);
 	else
-		memcpy(ip, retq, sizeof(retq));
+		text_poke_copy(ip, retq, sizeof(retq));
 
 	/* No need to test direct calls on created trampolines */
 	if (ops->flags & FTRACE_OPS_FL_SAVE_REGS) {
@@ -366,8 +369,7 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 		ip = trampoline + (jmp_offset - start_offset);
 		if (WARN_ON(*(char *)ip != 0x75))
 			goto fail;
-		ret = copy_from_kernel_nofault(ip, x86_nops[2], 2);
-		if (ret < 0)
+		if (!text_poke_copy(ip, x86_nops[2], 2))
 			goto fail;
 	}
 
@@ -380,7 +382,7 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 	 */
 
 	ptr = (unsigned long *)(trampoline + size + RET_SIZE);
-	*ptr = (unsigned long)ops;
+	text_poke_copy(ptr, &ops, sizeof(unsigned long));
 
 	op_offset -= start_offset;
 	memcpy(&op_ptr, trampoline + op_offset, OP_REF_SIZE);
@@ -396,7 +398,7 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 	op_ptr.offset = offset;
 
 	/* put in the new offset to the ftrace_ops */
-	memcpy(trampoline + op_offset, &op_ptr, OP_REF_SIZE);
+	text_poke_copy(trampoline + op_offset, &op_ptr, OP_REF_SIZE);
 
 	/* put in the call to the function */
 	mutex_lock(&text_mutex);
@@ -406,9 +408,9 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 	 * the depth accounting before the call already.
 	 */
 	dest = ftrace_ops_get_func(ops);
-	memcpy(trampoline + call_offset,
-	       text_gen_insn(CALL_INSN_OPCODE, trampoline + call_offset, dest),
-	       CALL_INSN_SIZE);
+	text_poke_copy_locked(trampoline + call_offset,
+	      text_gen_insn(CALL_INSN_OPCODE, trampoline + call_offset, dest),
+	      CALL_INSN_SIZE, false);
 	mutex_unlock(&text_mutex);
 
 	/* ALLOC_TRAMP flags lets us know we created it */
@@ -658,4 +660,15 @@ void ftrace_graph_func(unsigned long ip, unsigned long parent_ip,
 }
 #endif
 
+void ftrace_swap_func(void *a, void *b, int n)
+{
+	unsigned long t;
+
+	WARN_ON_ONCE(n != sizeof(t));
+
+	t = *((unsigned long *)a);
+	text_poke_copy(a, b, sizeof(t));
+	text_poke_copy(b, &t, sizeof(t));
+}
+
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index 94a00dc103cd..444bc76574b9 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -83,7 +83,6 @@ static int __write_relocate_add(Elf64_Shdr *sechdrs,
 		   unsigned int symindex,
 		   unsigned int relsec,
 		   struct module *me,
-		   void *(*write)(void *dest, const void *src, size_t len),
 		   bool apply)
 {
 	unsigned int i;
@@ -151,14 +150,14 @@ static int __write_relocate_add(Elf64_Shdr *sechdrs,
 				       (int)ELF64_R_TYPE(rel[i].r_info), loc, val);
 				return -ENOEXEC;
 			}
-			write(loc, &val, size);
+			text_poke(loc, &val, size);
 		} else {
 			if (memcmp(loc, &val, size)) {
 				pr_warn("x86/modules: Invalid relocation target, existing value does not match expected value for type %d, loc %p, val %Lx\n",
 					(int)ELF64_R_TYPE(rel[i].r_info), loc, val);
 				return -ENOEXEC;
 			}
-			write(loc, &zero, size);
+			text_poke(loc, &zero, size);
 		}
 	}
 	return 0;
@@ -179,22 +178,11 @@ static int write_relocate_add(Elf64_Shdr *sechdrs,
 			      bool apply)
 {
 	int ret;
-	bool early = me->state == MODULE_STATE_UNFORMED;
-	void *(*write)(void *, const void *, size_t) = memcpy;
-
-	if (!early) {
-		write = text_poke;
-		mutex_lock(&text_mutex);
-	}
-
-	ret = __write_relocate_add(sechdrs, strtab, symindex, relsec, me,
-				   write, apply);
-
-	if (!early) {
-		text_poke_sync();
-		mutex_unlock(&text_mutex);
-	}
 
+	mutex_lock(&text_mutex);
+	ret = __write_relocate_add(sechdrs, strtab, symindex, relsec, me, apply);
+	text_poke_sync();
+	mutex_unlock(&text_mutex);
 	return ret;
 }
 
diff --git a/arch/x86/kernel/static_call.c b/arch/x86/kernel/static_call.c
index b70670a98597..90aacef21dfa 100644
--- a/arch/x86/kernel/static_call.c
+++ b/arch/x86/kernel/static_call.c
@@ -51,7 +51,7 @@ asm (".global __static_call_return\n\t"
      ".size __static_call_return, . - __static_call_return \n\t");
 
 static void __ref __static_call_transform(void *insn, enum insn_type type,
-					  void *func, bool modinit)
+					  void *func)
 {
 	const void *emulate = NULL;
 	int size = CALL_INSN_SIZE;
@@ -105,7 +105,7 @@ static void __ref __static_call_transform(void *insn, enum insn_type type,
 	if (memcmp(insn, code, size) == 0)
 		return;
 
-	if (system_state == SYSTEM_BOOTING || modinit)
+	if (system_state == SYSTEM_BOOTING)
 		return text_poke_early(insn, code, size);
 
 	text_poke_bp(insn, code, size, emulate);
@@ -160,12 +160,12 @@ void arch_static_call_transform(void *site, void *tramp, void *func, bool tail)
 
 	if (tramp) {
 		__static_call_validate(tramp, true, true);
-		__static_call_transform(tramp, __sc_insn(!func, true), func, false);
+		__static_call_transform(tramp, __sc_insn(!func, true), func);
 	}
 
 	if (IS_ENABLED(CONFIG_HAVE_STATIC_CALL_INLINE) && site) {
 		__static_call_validate(site, tail, false);
-		__static_call_transform(site, __sc_insn(!func, tail), func, false);
+		__static_call_transform(site, __sc_insn(!func, tail), func);
 	}
 
 	mutex_unlock(&text_mutex);
@@ -193,7 +193,7 @@ bool __static_call_fixup(void *tramp, u8 op, void *dest)
 
 	mutex_lock(&text_mutex);
 	if (op == RET_INSN_OPCODE || dest == &__x86_return_thunk)
-		__static_call_transform(tramp, RET, NULL, true);
+		__static_call_transform(tramp, RET, NULL);
 	mutex_unlock(&text_mutex);
 
 	return true;
diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index 3ac50b7298d1..264188ec50c9 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -7,6 +7,7 @@
 #include <asm/unwind.h>
 #include <asm/orc_types.h>
 #include <asm/orc_lookup.h>
+#include <asm/text-patching.h>
 
 #define orc_warn(fmt, ...) \
 	printk_deferred_once(KERN_WARNING "WARNING: " fmt, ##__VA_ARGS__)
@@ -222,18 +223,22 @@ static void orc_sort_swap(void *_a, void *_b, int size)
 	struct orc_entry orc_tmp;
 	int *a = _a, *b = _b, tmp;
 	int delta = _b - _a;
+	int val;
 
 	/* Swap the .orc_unwind_ip entries: */
 	tmp = *a;
-	*a = *b + delta;
-	*b = tmp - delta;
+	val = *b + delta;
+	text_poke_copy(a, &val, sizeof(val));
+	val = tmp - delta;
+	text_poke_copy(b, &val, sizeof(val));
 
 	/* Swap the corresponding .orc_unwind entries: */
 	orc_a = cur_orc_table + (a - cur_orc_ip_table);
 	orc_b = cur_orc_table + (b - cur_orc_ip_table);
 	orc_tmp = *orc_a;
-	*orc_a = *orc_b;
-	*orc_b = orc_tmp;
+
+	text_poke_copy(orc_a, orc_b, sizeof(*orc_b));
+	text_poke_copy(orc_b, &orc_tmp, sizeof(orc_tmp));
 }
 
 static int orc_sort_cmp(const void *_a, const void *_b)
diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 1056bbf55b17..bae267f0a257 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -226,7 +226,7 @@ static u8 simple_alu_opcodes[] = {
 static void jit_fill_hole(void *area, unsigned int size)
 {
 	/* Fill whole space with INT3 instructions */
-	memset(area, 0xcc, size);
+	text_poke_set(area, 0xcc, size);
 }
 
 int bpf_arch_text_invalidate(void *dst, size_t len)
@@ -2202,6 +2202,9 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 		orig_call += X86_PATCH_SIZE;
 	}
 
+	set_memory_nx((unsigned long)image & PAGE_MASK, 1);
+	set_memory_rw((unsigned long)image & PAGE_MASK, 1);
+
 	prog = image;
 
 	EMIT_ENDBR();
@@ -2238,20 +2241,24 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 		emit_mov_imm64(&prog, BPF_REG_1, (long) im >> 32, (u32) (long) im);
 		if (emit_rsb_call(&prog, __bpf_tramp_enter, prog)) {
 			ret = -EINVAL;
-			goto cleanup;
+			goto reprotect_memory;
 		}
 	}
 
 	if (fentry->nr_links)
 		if (invoke_bpf(m, &prog, fentry, regs_off, run_ctx_off,
-			       flags & BPF_TRAMP_F_RET_FENTRY_RET))
-			return -EINVAL;
+			       flags & BPF_TRAMP_F_RET_FENTRY_RET)) {
+			ret = -EINVAL;
+			goto reprotect_memory;
+		}
 
 	if (fmod_ret->nr_links) {
 		branches = kcalloc(fmod_ret->nr_links, sizeof(u8 *),
 				   GFP_KERNEL);
-		if (!branches)
-			return -ENOMEM;
+		if (!branches) {
+			ret =  -ENOMEM;
+			goto reprotect_memory;
+		}
 
 		if (invoke_bpf_mod_ret(m, &prog, fmod_ret, regs_off,
 				       run_ctx_off, branches)) {
@@ -2336,6 +2343,9 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 
 cleanup:
 	kfree(branches);
+reprotect_memory:
+	set_memory_rox((unsigned long)image & PAGE_MASK, 1);
+
 	return ret;
 }
 
-- 
2.35.1


