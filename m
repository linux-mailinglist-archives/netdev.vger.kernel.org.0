Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8ED150D2B0
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 17:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiDXPhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 11:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239844AbiDXPbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 11:31:25 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65045171C03;
        Sun, 24 Apr 2022 08:28:24 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KmX6265dFzGp58;
        Sun, 24 Apr 2022 23:25:46 +0800 (CST)
Received: from huawei.com (10.67.174.197) by kwepemi500013.china.huawei.com
 (7.221.188.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sun, 24 Apr
 2022 23:28:20 +0800
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
Subject: [PATCH bpf-next v3 5/7] bpf, arm64: Support to poke bpf prog
Date:   Sun, 24 Apr 2022 11:40:26 -0400
Message-ID: <20220424154028.1698685-6-xukuohai@huawei.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220424154028.1698685-1-xukuohai@huawei.com>
References: <20220424154028.1698685-1-xukuohai@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.197]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. Set up the bpf prog entry in the same way as fentry to support
   trampoline. Now bpf prog entry looks like this:

   bti c        // if BTI enabled
   mov x9, x30  // save lr
   nop          // to be replaced with jump instruction
   paciasp      // if PAC enabled

2. Update bpf_arch_text_poke() to poke bpf prog. If the instruction
   to be poked is bpf prog's first instruction, skip to the nop
   instruction in the prog entry.

Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
---
 arch/arm64/net/bpf_jit.h      |  1 +
 arch/arm64/net/bpf_jit_comp.c | 41 +++++++++++++++++++++++++++--------
 2 files changed, 33 insertions(+), 9 deletions(-)

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
index 3f9bdfec54c4..293bdefc5d0c 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -237,14 +237,23 @@ static bool is_lsi_offset(int offset, int scale)
 	return true;
 }
 
-/* Tail call offset to jump into */
-#if IS_ENABLED(CONFIG_ARM64_BTI_KERNEL) || \
-	IS_ENABLED(CONFIG_ARM64_PTR_AUTH_KERNEL)
-#define PROLOGUE_OFFSET 9
+#if IS_ENABLED(CONFIG_ARM64_BTI_KERNEL)
+#define BTI_INSNS	1
+#else
+#define BTI_INSNS	0
+#endif
+
+#if IS_ENABLED(CONFIG_ARM64_PTR_AUTH_KERNEL)
+#define PAC_INSNS	1
 #else
-#define PROLOGUE_OFFSET 8
+#define PAC_INSNS	0
 #endif
 
+/* Tail call offset to jump into */
+#define PROLOGUE_OFFSET	(BTI_INSNS + 2 + PAC_INSNS + 8)
+/* Offset of nop instruction in bpf prog entry to be poked */
+#define POKE_OFFSET	(BTI_INSNS + 1)
+
 static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf)
 {
 	const struct bpf_prog *prog = ctx->prog;
@@ -281,12 +290,15 @@ static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf)
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
@@ -1552,9 +1564,11 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type poke_type,
 	u32 old_insn;
 	u32 new_insn;
 	u32 replaced;
+	unsigned long offset = ~0UL;
 	enum aarch64_insn_branch_type branch_type;
+	char namebuf[KSYM_NAME_LEN];
 
-	if (!is_bpf_text_address((long)ip))
+	if (!__bpf_address_lookup((unsigned long)ip, NULL, &offset, namebuf))
 		/* Only poking bpf text is supported. Since kernel function
 		 * entry is set up by ftrace, we reply on ftrace to poke kernel
 		 * functions. For kernel funcitons, bpf_arch_text_poke() is only
@@ -1565,6 +1579,15 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type poke_type,
 		 */
 		return -EINVAL;
 
+	/* bpf entry */
+	if (offset == 0UL)
+		/* skip to the nop instruction in bpf prog entry:
+		 * bti c	// if BTI enabled
+		 * mov x9, x30
+		 * nop
+		 */
+		ip = (u32 *)ip + POKE_OFFSET;
+
 	if (poke_type == BPF_MOD_CALL)
 		branch_type = AARCH64_INSN_BRANCH_LINK;
 	else
-- 
2.30.2

