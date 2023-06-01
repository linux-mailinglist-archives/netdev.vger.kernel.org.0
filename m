Return-Path: <netdev+bounces-7059-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B64297198F6
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 12:16:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C90A1C20FC2
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 10:16:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 879F8206A5;
	Thu,  1 Jun 2023 10:14:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C93B21CC2;
	Thu,  1 Jun 2023 10:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71499C4339B;
	Thu,  1 Jun 2023 10:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685614459;
	bh=pTt6oea7dl0OK8cq7WwHFZhtWWFAemGTmvVp6aKQFQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uD6/N81ikOPiRJAEV5qGhLjfWCawk0yMnp6Xt8fYx/PrTJkuDN66o3QZ5/QyahqEi
	 eEz3p9HhuIbubjxt94fZnmeMfIMlPtSuJAOfKCpVVmKDOUgkw+ZxlAzPGWu9ElDJox
	 8//FTUGz/X60PWEvHsAHESQPPehoEt7bviFexeZ2+2LRDfSYeGeeu1DFsnURPYhCb8
	 VA1UxImPpBwTmBGD+s3/pviyix4aZfXJhpSs4E0hU7dMP1uoMuAjAMHYvMlR6NxLUs
	 Woe4ghZDems2+gtF6bA6JpPo4jOZtr6deA+75+7bfQpGOZ/ORmQU/6FoNPAMN6dlf9
	 dqaesbQEJi8Eg==
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
Subject: [PATCH 07/13] x86/ftrace: enable dynamic ftrace without CONFIG_MODULES
Date: Thu,  1 Jun 2023 13:12:51 +0300
Message-Id: <20230601101257.530867-8-rppt@kernel.org>
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

From: "Mike Rapoport (IBM)" <rppt@kernel.org>

Dynamic ftrace must allocate memory for code and this was impossible
without CONFIG_MODULES.

With jitalloc separated from the modules code, the jit_text_alloc() is
available regardless of CONFIG_MODULE.

Move jitalloc initialization to x86/mm/init.c so that it won't get
compiled away when CONFIG_MODULE=n and enable dynamic ftrace
unconditionally.

Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
---
 arch/x86/Kconfig         |  1 +
 arch/x86/kernel/ftrace.c |  9 --------
 arch/x86/kernel/module.c | 44 --------------------------------------
 arch/x86/mm/init.c       | 46 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 47 insertions(+), 53 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 53bab123a8ee..fac4add6ce16 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -35,6 +35,7 @@ config X86_64
 	select SWIOTLB
 	select ARCH_HAS_ELFCORE_COMPAT
 	select ZONE_DMA32
+	select JIT_ALLOC if DYNAMIC_FTRACE
 
 config FORCE_DYNAMIC_FTRACE
 	def_bool y
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 157c8a799704..aa99536b824c 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -261,7 +261,6 @@ void arch_ftrace_update_code(int command)
 /* Currently only x86_64 supports dynamic trampolines */
 #ifdef CONFIG_X86_64
 
-#ifdef CONFIG_MODULES
 /* Module allocation simplifies allocating memory for code */
 static inline void *alloc_tramp(unsigned long size)
 {
@@ -271,14 +270,6 @@ static inline void tramp_free(void *tramp)
 {
 	jit_free(tramp);
 }
-#else
-/* Trampolines can only be created if modules are supported */
-static inline void *alloc_tramp(unsigned long size)
-{
-	return NULL;
-}
-static inline void tramp_free(void *tramp) { }
-#endif
 
 /* Defined as markers to the end of the ftrace default trampolines */
 extern void ftrace_regs_caller_end(void);
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index cacca613b8bd..94a00dc103cd 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -19,7 +19,6 @@
 #include <linux/jump_label.h>
 #include <linux/random.h>
 #include <linux/memory.h>
-#include <linux/jitalloc.h>
 
 #include <asm/text-patching.h>
 #include <asm/page.h>
@@ -37,49 +36,6 @@ do {							\
 } while (0)
 #endif
 
-#ifdef CONFIG_RANDOMIZE_BASE
-static unsigned long module_load_offset;
-
-/* Mutex protects the module_load_offset. */
-static DEFINE_MUTEX(module_kaslr_mutex);
-
-static unsigned long int get_module_load_offset(void)
-{
-	if (kaslr_enabled()) {
-		mutex_lock(&module_kaslr_mutex);
-		/*
-		 * Calculate the module_load_offset the first time this
-		 * code is called. Once calculated it stays the same until
-		 * reboot.
-		 */
-		if (module_load_offset == 0)
-			module_load_offset =
-				get_random_u32_inclusive(1, 1024) * PAGE_SIZE;
-		mutex_unlock(&module_kaslr_mutex);
-	}
-	return module_load_offset;
-}
-#else
-static unsigned long int get_module_load_offset(void)
-{
-	return 0;
-}
-#endif
-
-static struct jit_alloc_params jit_alloc_params = {
-	.alignment	= JIT_ALLOC_ALIGN,
-	.flags		= JIT_ALLOC_KASAN_SHADOW,
-};
-
-struct jit_alloc_params *jit_alloc_arch_params(void)
-{
-	jit_alloc_params.text.pgprot = PAGE_KERNEL;
-	jit_alloc_params.text.start = MODULES_VADDR + get_module_load_offset();
-	jit_alloc_params.text.end = MODULES_END;
-
-	return &jit_alloc_params;
-}
-
 #ifdef CONFIG_X86_32
 int apply_relocate(Elf32_Shdr *sechdrs,
 		   const char *strtab,
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 3cdac0f0055d..ffaf9a3840ce 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -7,6 +7,7 @@
 #include <linux/swapops.h>
 #include <linux/kmemleak.h>
 #include <linux/sched/task.h>
+#include <linux/jitalloc.h>
 
 #include <asm/set_memory.h>
 #include <asm/e820/api.h>
@@ -1084,3 +1085,48 @@ unsigned long arch_max_swapfile_size(void)
 	return pages;
 }
 #endif
+
+#ifdef CONFIG_JIT_ALLOC
+#ifdef CONFIG_RANDOMIZE_BASE
+static unsigned long jit_load_offset;
+
+/* Mutex protects the jit_load_offset. */
+static DEFINE_MUTEX(jit_kaslr_mutex);
+
+static unsigned long int get_jit_load_offset(void)
+{
+	if (kaslr_enabled()) {
+		mutex_lock(&jit_kaslr_mutex);
+		/*
+		 * Calculate the jit_load_offset the first time this
+		 * code is called. Once calculated it stays the same until
+		 * reboot.
+		 */
+		if (jit_load_offset == 0)
+			jit_load_offset =
+				get_random_u32_inclusive(1, 1024) * PAGE_SIZE;
+		mutex_unlock(&jit_kaslr_mutex);
+	}
+	return jit_load_offset;
+}
+#else
+static unsigned long int get_jit_load_offset(void)
+{
+	return 0;
+}
+#endif
+
+static struct jit_alloc_params jit_alloc_params = {
+	.alignment	= JIT_ALLOC_ALIGN,
+	.flags		= JIT_ALLOC_KASAN_SHADOW,
+};
+
+struct jit_alloc_params *jit_alloc_arch_params(void)
+{
+	jit_alloc_params.text.pgprot = PAGE_KERNEL;
+	jit_alloc_params.text.start = MODULES_VADDR + get_jit_load_offset();
+	jit_alloc_params.text.end = MODULES_END;
+
+	return &jit_alloc_params;
+}
+#endif /* CONFIG_JIT_ALLOC */
-- 
2.35.1


