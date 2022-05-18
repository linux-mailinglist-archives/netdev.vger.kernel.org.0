Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F31252BD33
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 16:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238254AbiERNyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 09:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238276AbiERNyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 09:54:04 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5572B1C7411;
        Wed, 18 May 2022 06:54:01 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4L3DqM04Q1zCsqk;
        Wed, 18 May 2022 21:49:02 +0800 (CST)
Received: from huawei.com (10.67.174.197) by kwepemi500013.china.huawei.com
 (7.221.188.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 18 May
 2022 21:53:57 +0800
From:   Xu Kuohai <xukuohai@huawei.com>
To:     <bpf@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>
CC:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
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
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Steven Price <steven.price@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        Mark Brown <broonie@kernel.org>,
        Delyan Kratunov <delyank@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: [PATCH bpf-next v5 4/6] bpf, arm64: Impelment bpf_arch_text_poke() for arm64
Date:   Wed, 18 May 2022 09:16:36 -0400
Message-ID: <20220518131638.3401509-5-xukuohai@huawei.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220518131638.3401509-1-xukuohai@huawei.com>
References: <20220518131638.3401509-1-xukuohai@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.197]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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

Impelment bpf_arch_text_poke() for arm64, so bpf trampoline code can use
it to replace nop with jump, or replace jump with nop.

Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Acked-by: Song Liu <songliubraving@fb.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 arch/arm64/net/bpf_jit.h      |   1 +
 arch/arm64/net/bpf_jit_comp.c | 107 +++++++++++++++++++++++++++++++---
 2 files changed, 99 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/net/bpf_jit.h b/arch/arm64/net/bpf_jit.h
index 194c95ccc1cf..1c4b0075a3e2 100644
--- a/arch/arm64/net/bpf_jit.h
+++ b/arch/arm64/net/bpf_jit.h
@@ -270,6 +270,7 @@
 #define A64_BTI_C  A64_HINT(AARCH64_INSN_HINT_BTIC)
 #define A64_BTI_J  A64_HINT(AARCH64_INSN_HINT_BTIJ)
 #define A64_BTI_JC A64_HINT(AARCH64_INSN_HINT_BTIJC)
+#define A64_NOP    A64_HINT(AARCH64_INSN_HINT_NOP)
 
 /* DMB */
 #define A64_DMB_ISH aarch64_insn_gen_dmb(AARCH64_INSN_MB_ISH)
diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 8ab4035dea27..5ce6ed5f42a1 100644
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
@@ -235,13 +237,13 @@ static bool is_lsi_offset(int offset, int scale)
 	return true;
 }
 
+#define BTI_INSNS (IS_ENABLED(CONFIG_ARM64_BTI_KERNEL) ? 1 : 0)
+#define PAC_INSNS (IS_ENABLED(CONFIG_ARM64_PTR_AUTH_KERNEL) ? 1 : 0)
+
 /* Tail call offset to jump into */
-#if IS_ENABLED(CONFIG_ARM64_BTI_KERNEL) || \
-	IS_ENABLED(CONFIG_ARM64_PTR_AUTH_KERNEL)
-#define PROLOGUE_OFFSET 9
-#else
-#define PROLOGUE_OFFSET 8
-#endif
+#define PROLOGUE_OFFSET	(BTI_INSNS + 2 + PAC_INSNS + 8)
+/* Offset of nop instruction in bpf prog entry to be poked */
+#define POKE_OFFSET	(BTI_INSNS + 1)
 
 static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf)
 {
@@ -279,12 +281,15 @@ static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf)
 	 *
 	 */
 
+	if (IS_ENABLED(CONFIG_ARM64_BTI_KERNEL))
+		emit(A64_BTI_C, ctx);
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
@@ -1529,3 +1534,87 @@ void bpf_jit_free_exec(void *addr)
 {
 	return vfree(addr);
 }
+
+static int gen_branch_or_nop(enum aarch64_insn_branch_type type, void *ip,
+			     void *addr, u32 *insn)
+{
+	if (!addr)
+		*insn = aarch64_insn_gen_nop();
+	else
+		*insn = aarch64_insn_gen_branch_imm((unsigned long)ip,
+						    (unsigned long)addr,
+						    type);
+
+	return *insn != AARCH64_BREAK_FAULT ? 0 : -EFAULT;
+}
+
+int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type poke_type,
+		       void *old_addr, void *new_addr)
+{
+	int ret;
+	u32 old_insn;
+	u32 new_insn;
+	u32 replaced;
+	unsigned long offset = ~0UL;
+	enum aarch64_insn_branch_type branch_type;
+	char namebuf[KSYM_NAME_LEN];
+
+	if (!__bpf_address_lookup((unsigned long)ip, NULL, &offset, namebuf))
+		/* Only poking bpf text is supported. Since kernel function
+		 * entry is set up by ftrace, we reply on ftrace to poke kernel
+		 * functions.
+		 */
+		return -EINVAL;
+
+	/* bpf entry */
+	if (offset == 0UL)
+		/* skip to the nop instruction in bpf prog entry:
+		 * bti c	// if BTI enabled
+		 * mov x9, x30
+		 * nop
+		 */
+		ip = ip + POKE_OFFSET * AARCH64_INSN_SIZE;
+
+	if (poke_type == BPF_MOD_CALL)
+		branch_type = AARCH64_INSN_BRANCH_LINK;
+	else
+		branch_type = AARCH64_INSN_BRANCH_NOLINK;
+
+	if (gen_branch_or_nop(branch_type, ip, old_addr, &old_insn) < 0)
+		return -EFAULT;
+
+	if (gen_branch_or_nop(branch_type, ip, new_addr, &new_insn) < 0)
+		return -EFAULT;
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
+	 * instruction. But there is chance that another CPU fetches the old
+	 * instruction after bpf_arch_text_poke() finishes, that is, different
+	 * CPUs may execute different versions of instructions at the same
+	 * time before the icache is synchronized by hardware.
+	 *
+	 * 1. when a new trampoline is attached, it is not an issue for
+	 *    different CPUs to jump to different trampolines temporarily.
+	 *
+	 * 2. when an old trampoline is freed, we should wait for all other
+	 *    CPUs to exit the trampoline and make sure the trampoline is no
+	 *    longer reachable, since bpf_tramp_image_put() function already
+	 *    uses percpu_ref and rcu task to do the sync, no need to call the
+	 *    sync interface here.
+	 */
+	ret = aarch64_insn_patch_text_nosync(ip, new_insn);
+out:
+	mutex_unlock(&text_mutex);
+	return ret;
+}
-- 
2.30.2

