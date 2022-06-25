Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA2CB55AB81
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 18:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbiFYQDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 12:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233209AbiFYQC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 12:02:57 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9D21E2;
        Sat, 25 Jun 2022 09:02:53 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LVdw93KTqzSh5M;
        Sat, 25 Jun 2022 23:59:21 +0800 (CST)
Received: from huawei.com (10.67.174.197) by kwepemi500013.china.huawei.com
 (7.221.188.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sun, 26 Jun
 2022 00:02:47 +0800
From:   Xu Kuohai <xukuohai@huawei.com>
To:     <bpf@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Hou Tao <houtao1@huawei.com>,
        Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH bpf-next v6 3/4] bpf, arm64: Impelment bpf_arch_text_poke() for arm64
Date:   Sat, 25 Jun 2022 12:12:54 -0400
Message-ID: <20220625161255.547944-4-xukuohai@huawei.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220625161255.547944-1-xukuohai@huawei.com>
References: <20220625161255.547944-1-xukuohai@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.197]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Impelment bpf_arch_text_poke() for arm64, so bpf prog or bpf trampoline
can be patched with it.

When the target address is NULL, the original instruction is patched to a
NOP.

When the target address and the source address are within the branch
range, the original instruction is patched to a bl instruction to the
target address directly.

To support attaching bpf trampoline to both regular kernel function and
bpf prog, we follow the ftrace patchsite way for bpf prog. That is, two
instructions are inserted at the beginning of bpf prog, the first one
saves the return address to x9, and the second is a nop which will be
patched to a bl instruction when a bpf trampoline is attached.

However, when a bpf trmapoline is attached to bpf prog, the distance
between target address and source address may exceed 128MB, the maximum
branch range, because bpf trampoline and bpf prog are allocated
separately with vmalloc. So long jump should be handled.

When a bpf prog is constructed, a plt pointing to empty trampoline
dummy_tramp is placed at the end:

        bpf_prog:
                mov x9, lr
                nop // patchsite
                ...
                ret

        plt:
                ldr x10, target
                br x10
        target:
                .quad dummy_tramp // plt target

This is also the state when no trampoline is attached.

When a short-jump bpf trampoline is attached, the patchsite is patched to
a bl instruction to the trampoline directly:

        bpf_prog:
                mov x9, lr
                bl <short-jump bpf trampoline address> // patchsite
                ...
                ret

        plt:
                ldr x10, target
                br x10
        target:
                .quad dummy_tramp // plt target

When a long-jump bpf trampoline is attached, the plt target is filled with
the trampoline address and the patchsite is patched to a bl instruction to
the plt:

        bpf_prog:
                mov x9, lr
                bl plt // patchsite
                ...
                ret

        plt:
                ldr x10, target
                br x10
        target:
                .quad <long-jump bpf trampoline address>

dummy_tramp  is used to prevent another CPU from jumping to an unknown
location during the patching process, making the patching process easier.

The patching process is as follows:

1. when neither the old address or the new address is a long jump, the
   patchsite is replaced with a bl to the new address, or nop if the new
   address is NULL;

2. when the old address is not long jump but the new one is, the
   branch target address is written to plt first, then the patchsite
   is replaced with a bl instruction to the plt;

3. when the old address is long jump but the new one is not, the address
   of dummy_tramp is written to plt first, then the patchsite is replaced
   with a bl to the new address, or a nop if the new address is NULL;

4. when both the old address and the new address are long jump, the
   new address is written to plt and the patchsite is not changed.

Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Acked-by: Song Liu <songliubraving@fb.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Reviewed-by: KP Singh <kpsingh@kernel.org>
---
 arch/arm64/net/bpf_jit.h      |   7 +
 arch/arm64/net/bpf_jit_comp.c | 330 ++++++++++++++++++++++++++++++++--
 2 files changed, 323 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/net/bpf_jit.h b/arch/arm64/net/bpf_jit.h
index 194c95ccc1cf..a6acb94ea3d6 100644
--- a/arch/arm64/net/bpf_jit.h
+++ b/arch/arm64/net/bpf_jit.h
@@ -80,6 +80,12 @@
 #define A64_STR64I(Xt, Xn, imm) A64_LS_IMM(Xt, Xn, imm, 64, STORE)
 #define A64_LDR64I(Xt, Xn, imm) A64_LS_IMM(Xt, Xn, imm, 64, LOAD)
 
+/* LDR (literal) */
+#define A64_LDR32LIT(Wt, offset) \
+	aarch64_insn_gen_load_literal(0, offset, Wt, false)
+#define A64_LDR64LIT(Xt, offset) \
+	aarch64_insn_gen_load_literal(0, offset, Xt, true)
+
 /* Load/store register pair */
 #define A64_LS_PAIR(Rt, Rt2, Rn, offset, ls, type) \
 	aarch64_insn_gen_load_store_pair(Rt, Rt2, Rn, offset, \
@@ -270,6 +276,7 @@
 #define A64_BTI_C  A64_HINT(AARCH64_INSN_HINT_BTIC)
 #define A64_BTI_J  A64_HINT(AARCH64_INSN_HINT_BTIJ)
 #define A64_BTI_JC A64_HINT(AARCH64_INSN_HINT_BTIJC)
+#define A64_NOP    A64_HINT(AARCH64_INSN_HINT_NOP)
 
 /* DMB */
 #define A64_DMB_ISH aarch64_insn_gen_dmb(AARCH64_INSN_MB_ISH)
diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index f08a4447d363..e0e9c705a2e4 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -9,6 +9,7 @@
 
 #include <linux/bitfield.h>
 #include <linux/bpf.h>
+#include <linux/memory.h>
 #include <linux/filter.h>
 #include <linux/printk.h>
 #include <linux/slab.h>
@@ -18,6 +19,7 @@
 #include <asm/cacheflush.h>
 #include <asm/debug-monitors.h>
 #include <asm/insn.h>
+#include <asm/patching.h>
 #include <asm/set_memory.h>
 
 #include "bpf_jit.h"
@@ -78,6 +80,15 @@ struct jit_ctx {
 	int fpb_offset;
 };
 
+struct bpf_plt {
+	u32 insn_ldr; /* load target */
+	u32 insn_br;  /* branch to target */
+	u64 target;   /* target value */
+} __packed;
+
+#define PLT_TARGET_SIZE   sizeof_field(struct bpf_plt, target)
+#define PLT_TARGET_OFFSET offsetof(struct bpf_plt, target)
+
 static inline void emit(const u32 insn, struct jit_ctx *ctx)
 {
 	if (ctx->image != NULL)
@@ -140,6 +151,12 @@ static inline void emit_a64_mov_i64(const int reg, const u64 val,
 	}
 }
 
+static inline void emit_bti(u32 insn, struct jit_ctx *ctx)
+{
+	if (IS_ENABLED(CONFIG_ARM64_BTI_KERNEL))
+		emit(insn, ctx);
+}
+
 /*
  * Kernel addresses in the vmalloc space use at most 48 bits, and the
  * remaining bits are guaranteed to be 0x1. So we can compose the address
@@ -235,13 +252,30 @@ static bool is_lsi_offset(int offset, int scale)
 	return true;
 }
 
+/* generated prologue:
+ *      bti c // if CONFIG_ARM64_BTI_KERNEL
+ *      mov x9, lr
+ *      nop  // POKE_OFFSET
+ *      paciasp // if CONFIG_ARM64_PTR_AUTH_KERNEL
+ *      stp x29, lr, [sp, #-16]!
+ *      mov x29, sp
+ *      stp x19, x20, [sp, #-16]!
+ *      stp x21, x22, [sp, #-16]!
+ *      stp x25, x26, [sp, #-16]!
+ *      stp x27, x28, [sp, #-16]!
+ *      mov x25, sp
+ *      mov tcc, #0
+ *      // PROLOGUE_OFFSET
+ */
+
+#define BTI_INSNS (IS_ENABLED(CONFIG_ARM64_BTI_KERNEL) ? 1 : 0)
+#define PAC_INSNS (IS_ENABLED(CONFIG_ARM64_PTR_AUTH_KERNEL) ? 1 : 0)
+
+/* Offset of nop instruction in bpf prog entry to be poked */
+#define POKE_OFFSET (BTI_INSNS + 1)
+
 /* Tail call offset to jump into */
-#if IS_ENABLED(CONFIG_ARM64_BTI_KERNEL) || \
-	IS_ENABLED(CONFIG_ARM64_PTR_AUTH_KERNEL)
-#define PROLOGUE_OFFSET 9
-#else
-#define PROLOGUE_OFFSET 8
-#endif
+#define PROLOGUE_OFFSET (BTI_INSNS + 2 + PAC_INSNS + 8)
 
 static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf)
 {
@@ -280,12 +314,14 @@ static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf)
 	 *
 	 */
 
+	emit_bti(A64_BTI_C, ctx);
+
+	emit(A64_MOV(1, A64_R(9), A64_LR), ctx);
+	emit(A64_NOP, ctx);
+
 	/* Sign lr */
 	if (IS_ENABLED(CONFIG_ARM64_PTR_AUTH_KERNEL))
 		emit(A64_PACIASP, ctx);
-	/* BTI landing pad */
-	else if (IS_ENABLED(CONFIG_ARM64_BTI_KERNEL))
-		emit(A64_BTI_C, ctx);
 
 	/* Save FP and LR registers to stay align with ARM64 AAPCS */
 	emit(A64_PUSH(A64_FP, A64_LR, A64_SP), ctx);
@@ -312,8 +348,7 @@ static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf)
 		}
 
 		/* BTI landing pad for the tail call, done with a BR */
-		if (IS_ENABLED(CONFIG_ARM64_BTI_KERNEL))
-			emit(A64_BTI_J, ctx);
+		emit_bti(A64_BTI_J, ctx);
 	}
 
 	emit(A64_SUB_I(1, fpb, fp, ctx->fpb_offset), ctx);
@@ -557,6 +592,53 @@ static int emit_ll_sc_atomic(const struct bpf_insn *insn, struct jit_ctx *ctx)
 	return 0;
 }
 
+void dummy_tramp(void);
+
+asm (
+"	.pushsection .text, \"ax\", @progbits\n"
+"	.type dummy_tramp, %function\n"
+"dummy_tramp:"
+#if IS_ENABLED(CONFIG_ARM64_BTI_KERNEL)
+"	bti j\n" /* dummy_tramp is called via "br x10" */
+#endif
+"	mov x10, lr\n"
+"	mov lr, x9\n"
+"	ret x10\n"
+"	.size dummy_tramp, .-dummy_tramp\n"
+"	.popsection\n"
+);
+
+/* build a plt initialized like this:
+ *
+ * plt:
+ *      ldr tmp, target
+ *      br tmp
+ * target:
+ *      .quad dummy_tramp
+ *
+ * when a long jump trampoline is attached, target is filled with the
+ * trampoline address, and when the trampoine is removed, target is
+ * restored to dummy_tramp address.
+ */
+static void build_plt(struct jit_ctx *ctx, bool write_target)
+{
+	const u8 tmp = bpf2a64[TMP_REG_1];
+	struct bpf_plt *plt = NULL;
+
+	/* make sure target is 64-bit aligend */
+	if ((ctx->idx + PLT_TARGET_OFFSET / AARCH64_INSN_SIZE) % 2)
+		emit(A64_NOP, ctx);
+
+	plt = (struct bpf_plt *)(ctx->image + ctx->idx);
+	/* plt is called via bl, no BTI needed here */
+	emit(A64_LDR64LIT(tmp, 2 * AARCH64_INSN_SIZE), ctx);
+	emit(A64_BR(tmp), ctx);
+
+	/* false write_target means target space is not allocated yet */
+	if (write_target)
+		plt->target = (u64)&dummy_tramp;
+}
+
 static void build_epilogue(struct jit_ctx *ctx)
 {
 	const u8 r0 = bpf2a64[BPF_REG_0];
@@ -1356,7 +1438,7 @@ struct arm64_jit_data {
 
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 {
-	int image_size, prog_size, extable_size;
+	int image_size, prog_size, extable_size, extable_align, extable_offset;
 	struct bpf_prog *tmp, *orig_prog = prog;
 	struct bpf_binary_header *header;
 	struct arm64_jit_data *jit_data;
@@ -1426,13 +1508,17 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 
 	ctx.epilogue_offset = ctx.idx;
 	build_epilogue(&ctx);
+	build_plt(&ctx, false);
 
+	extable_align = __alignof__(struct exception_table_entry);
 	extable_size = prog->aux->num_exentries *
 		sizeof(struct exception_table_entry);
 
 	/* Now we know the actual image size. */
 	prog_size = sizeof(u32) * ctx.idx;
-	image_size = prog_size + extable_size;
+	/* also allocate space for plt target */
+	extable_offset = round_up(prog_size + PLT_TARGET_SIZE, extable_align);
+	image_size = extable_offset + extable_size;
 	header = bpf_jit_binary_alloc(image_size, &image_ptr,
 				      sizeof(u32), jit_fill_hole);
 	if (header == NULL) {
@@ -1444,7 +1530,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 
 	ctx.image = (__le32 *)image_ptr;
 	if (extable_size)
-		prog->aux->extable = (void *)image_ptr + prog_size;
+		prog->aux->extable = (void *)image_ptr + extable_offset;
 skip_init_ctx:
 	ctx.idx = 0;
 	ctx.exentry_idx = 0;
@@ -1458,6 +1544,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	}
 
 	build_epilogue(&ctx);
+	build_plt(&ctx, true);
 
 	/* 3. Extra pass to validate JITed code. */
 	if (validate_code(&ctx)) {
@@ -1537,3 +1624,218 @@ bool bpf_jit_supports_subprog_tailcalls(void)
 {
 	return true;
 }
+
+static bool is_long_jump(void *ip, void *target)
+{
+	long offset;
+
+	/* NULL target means this is a NOP */
+	if (!target)
+		return false;
+
+	offset = (long)target - (long)ip;
+	return offset < -SZ_128M || offset >= SZ_128M;
+}
+
+static int gen_branch_or_nop(enum aarch64_insn_branch_type type, void *ip,
+			     void *addr, void *plt, u32 *insn)
+{
+	void *target;
+
+	if (!addr) {
+		*insn = aarch64_insn_gen_nop();
+		return 0;
+	}
+
+	if (is_long_jump(ip, addr))
+		target = plt;
+	else
+		target = addr;
+
+	*insn = aarch64_insn_gen_branch_imm((unsigned long)ip,
+					    (unsigned long)target,
+					    type);
+
+	return *insn != AARCH64_BREAK_FAULT ? 0 : -EFAULT;
+}
+
+/* Replace the branch instruction from @ip to @old_addr in a bpf prog or a bpf
+ * trampoline with the branch instruction from @ip to @new_addr. If @old_addr
+ * or @new_addr is NULL, the old or new instruction is NOP.
+ *
+ * When @ip is the bpf prog entry, a bpf trampoline is being attached or
+ * detached. Since bpf trampoline and bpf prog are allocated separately with
+ * vmalloc, the address distance may exceed 128MB, the maximum branch range.
+ * So long jump should be handled.
+ *
+ * When a bpf prog is constructed, a plt pointing to empty trampoline
+ * dummy_tramp is placed at the end:
+ *
+ *      bpf_prog:
+ *              mov x9, lr
+ *              nop // patchsite
+ *              ...
+ *              ret
+ *
+ *      plt:
+ *              ldr x10, target
+ *              br x10
+ *      target:
+ *              .quad dummy_tramp // plt target
+ *
+ * This is also the state when no trampoline is attached.
+ *
+ * When a short-jump bpf trampoline is attached, the patchsite is patched
+ * to a bl instruction to the trampoline directly:
+ *
+ *      bpf_prog:
+ *              mov x9, lr
+ *              bl <short-jump bpf trampoline address> // patchsite
+ *              ...
+ *              ret
+ *
+ *      plt:
+ *              ldr x10, target
+ *              br x10
+ *      target:
+ *              .quad dummy_tramp // plt target
+ *
+ * When a long-jump bpf trampoline is attached, the plt target is filled with
+ * the trampoline address and the patchsite is patched to a bl instruction to
+ * the plt:
+ *
+ *      bpf_prog:
+ *              mov x9, lr
+ *              bl plt // patchsite
+ *              ...
+ *              ret
+ *
+ *      plt:
+ *              ldr x10, target
+ *              br x10
+ *      target:
+ *              .quad <long-jump bpf trampoline address> // plt target
+ *
+ * The dummy_tramp is used to prevent another CPU from jumping to unknown
+ * locations during the patching process, making the patching process easier.
+ */
+int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type poke_type,
+		       void *old_addr, void *new_addr)
+{
+	int ret;
+	u32 old_insn;
+	u32 new_insn;
+	u32 replaced;
+	struct bpf_plt *plt = NULL;
+	unsigned long size = 0UL;
+	unsigned long offset = ~0UL;
+	enum aarch64_insn_branch_type branch_type;
+	char namebuf[KSYM_NAME_LEN];
+	void *image = NULL;
+	u64 plt_target = 0ULL;
+	bool poking_bpf_entry;
+
+	if (!__bpf_address_lookup((unsigned long)ip, &size, &offset, namebuf))
+		/* Only poking bpf text is supported. Since kernel function
+		 * entry is set up by ftrace, we reply on ftrace to poke kernel
+		 * functions.
+		 */
+		return -ENOTSUPP;
+
+	image = ip - offset;
+	/* zero offset means we're poking bpf prog entry */
+	poking_bpf_entry = (offset == 0UL);
+
+	/* bpf prog entry, find plt and the real patchsite */
+	if (poking_bpf_entry) {
+		/* plt locates at the end of bpf prog */
+		plt = image + size - PLT_TARGET_OFFSET;
+
+		/* skip to the nop instruction in bpf prog entry:
+		 * bti c // if BTI enabled
+		 * mov x9, x30
+		 * nop
+		 */
+		ip = image + POKE_OFFSET * AARCH64_INSN_SIZE;
+	}
+
+	/* long jump is only possible at bpf prog entry */
+	if (WARN_ON((is_long_jump(ip, new_addr) || is_long_jump(ip, old_addr)) &&
+		    !poking_bpf_entry))
+		return -EINVAL;
+
+	if (poke_type == BPF_MOD_CALL)
+		branch_type = AARCH64_INSN_BRANCH_LINK;
+	else
+		branch_type = AARCH64_INSN_BRANCH_NOLINK;
+
+	if (gen_branch_or_nop(branch_type, ip, old_addr, plt, &old_insn) < 0)
+		return -EFAULT;
+
+	if (gen_branch_or_nop(branch_type, ip, new_addr, plt, &new_insn) < 0)
+		return -EFAULT;
+
+	if (is_long_jump(ip, new_addr))
+		plt_target = (u64)new_addr;
+	else if (is_long_jump(ip, old_addr))
+		/* if the old target is a long jump and the new target is not,
+		 * restore the plt target to dummy_tramp, so there is always a
+		 * legal and harmless address stored in plt target, and we'll
+		 * never jump from plt to an unknown place.
+		 */
+		plt_target = (u64)&dummy_tramp;
+
+	if (plt_target) {
+		/* non-zero plt_target indicates we're patching a bpf prog,
+		 * which is read only.
+		 */
+		if (set_memory_rw(PAGE_MASK & ((uintptr_t)&plt->target), 1))
+			return -EFAULT;
+		WRITE_ONCE(plt->target, plt_target);
+		set_memory_ro(PAGE_MASK & ((uintptr_t)&plt->target), 1);
+		/* since plt target points to either the new trmapoline
+		 * or dummy_tramp, even if aother CPU reads the old plt
+		 * target value before fetching the bl instruction to plt,
+		 * it will be brought back by dummy_tramp, so no barrier is
+		 * required here.
+		 */
+	}
+
+	/* if the old target and the new target are both long jumps, no
+	 * patching is required
+	 */
+	if (old_insn == new_insn)
+		return 0;
+
+	mutex_lock(&text_mutex);
+	if (aarch64_insn_read(ip, &replaced)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	if (replaced != old_insn) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	/* We call aarch64_insn_patch_text_nosync() to replace instruction
+	 * atomically, so no other CPUs will fetch a half-new and half-old
+	 * instruction. But there is chance that another CPU executes the
+	 * old instruction after the patching operation finishes (e.g.,
+	 * pipeline not flushed, or icache not synchronized yet).
+	 *
+	 * 1. when a new trampoline is attached, it is not a problem for
+	 *    different CPUs to jump to different trampolines temporarily.
+	 *
+	 * 2. when an old trampoline is freed, we should wait for all other
+	 *    CPUs to exit the trampoline and make sure the trampoline is no
+	 *    longer reachable, since bpf_tramp_image_put() function already
+	 *    uses percpu_ref and task rcu to do the sync, no need to call
+	 *    the sync version here, see bpf_tramp_image_put() for details.
+	 */
+	ret = aarch64_insn_patch_text_nosync(ip, new_insn);
+out:
+	mutex_unlock(&text_mutex);
+
+	return ret;
+}
-- 
2.30.2

