Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 976635018D8
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 18:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238041AbiDNQmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 12:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239875AbiDNQlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 12:41:24 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6AA5BA313;
        Thu, 14 Apr 2022 09:10:14 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KfPYB2wzyzfYp8;
        Fri, 15 Apr 2022 00:09:34 +0800 (CST)
Received: from huawei.com (10.67.174.197) by kwepemi500013.china.huawei.com
 (7.221.188.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 15 Apr
 2022 00:10:11 +0800
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
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Peter Collingbourne <pcc@google.com>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Steven Price <steven.price@arm.com>,
        Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Delyan Kratunov <delyank@fb.com>
Subject: [PATCH bpf-next v2 1/6] arm64: ftrace: Add ftrace direct call support
Date:   Thu, 14 Apr 2022 12:22:15 -0400
Message-ID: <20220414162220.1985095-2-xukuohai@huawei.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220414162220.1985095-1-xukuohai@huawei.com>
References: <20220414162220.1985095-1-xukuohai@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.197]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ftrace direct support for arm64.

1. When there is custom trampoline only, replace the fentry nop to a
   jump instruction that jumps directly to the custom trampoline.

2. When ftrace trampoline and custom trampoline coexist, jump from
   fentry to ftrace trampoline first, then jump to custom trampoline
   when ftrace trampoline exits. The current unused register
   pt_regs->orig_x0 is used as an intermediary for jumping from ftrace
   trampoline to custom trampoline.

Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 arch/arm64/Kconfig               |  2 ++
 arch/arm64/include/asm/ftrace.h  | 10 ++++++++++
 arch/arm64/kernel/asm-offsets.c  |  1 +
 arch/arm64/kernel/entry-ftrace.S | 18 +++++++++++++++---
 4 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 57c4c995965f..81cc330daafc 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -177,6 +177,8 @@ config ARM64
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_DYNAMIC_FTRACE_WITH_REGS \
 		if $(cc-option,-fpatchable-function-entry=2)
+	select HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS \
+		if DYNAMIC_FTRACE_WITH_REGS
 	select FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY \
 		if DYNAMIC_FTRACE_WITH_REGS
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
diff --git a/arch/arm64/include/asm/ftrace.h b/arch/arm64/include/asm/ftrace.h
index 1494cfa8639b..3a363d6a3bd0 100644
--- a/arch/arm64/include/asm/ftrace.h
+++ b/arch/arm64/include/asm/ftrace.h
@@ -78,6 +78,16 @@ static inline unsigned long ftrace_call_adjust(unsigned long addr)
 	return addr;
 }
 
+static inline void arch_ftrace_set_direct_caller(struct pt_regs *regs,
+						 unsigned long addr)
+{
+	/*
+	 * Place custom trampoline address in regs->orig_x0 to let ftrace
+	 * trampoline jump to it.
+	 */
+	regs->orig_x0 = addr;
+}
+
 #ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
 struct dyn_ftrace;
 int ftrace_init_nop(struct module *mod, struct dyn_ftrace *rec);
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 1197e7679882..b1ed0bf01c59 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -80,6 +80,7 @@ int main(void)
   DEFINE(S_SDEI_TTBR1,		offsetof(struct pt_regs, sdei_ttbr1));
   DEFINE(S_PMR_SAVE,		offsetof(struct pt_regs, pmr_save));
   DEFINE(S_STACKFRAME,		offsetof(struct pt_regs, stackframe));
+  DEFINE(S_ORIG_X0,		offsetof(struct pt_regs, orig_x0));
   DEFINE(PT_REGS_SIZE,		sizeof(struct pt_regs));
   BLANK();
 #ifdef CONFIG_COMPAT
diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
index e535480a4069..dfe62c55e3a2 100644
--- a/arch/arm64/kernel/entry-ftrace.S
+++ b/arch/arm64/kernel/entry-ftrace.S
@@ -60,6 +60,9 @@
 	str	x29, [sp, #S_FP]
 	.endif
 
+	/* Set orig_x0 to zero  */
+	str     xzr, [sp, #S_ORIG_X0]
+
 	/* Save the callsite's SP and LR */
 	add	x10, sp, #(PT_REGS_SIZE + 16)
 	stp	x9, x10, [sp, #S_LR]
@@ -119,12 +122,21 @@ ftrace_common_return:
 	/* Restore the callsite's FP, LR, PC */
 	ldr	x29, [sp, #S_FP]
 	ldr	x30, [sp, #S_LR]
-	ldr	x9, [sp, #S_PC]
-
+	ldr	x10, [sp, #S_PC]
+
+	ldr	x11, [sp, #S_ORIG_X0]
+	cbz	x11, 1f
+	/* Set x9 to parent ip before jump to custom trampoline */
+	mov	x9,  x30
+	/* Set lr to self ip */
+	ldr	x30, [sp, #S_PC]
+	/* Set x10 (used for return address) to custom trampoline */
+	mov	x10, x11
+1:
 	/* Restore the callsite's SP */
 	add	sp, sp, #PT_REGS_SIZE + 16
 
-	ret	x9
+	ret	x10
 SYM_CODE_END(ftrace_common)
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-- 
2.30.2

