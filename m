Return-Path: <netdev+bounces-7057-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 541CF7198DC
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 12:15:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0EDFD281755
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 10:15:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B61BE21063;
	Thu,  1 Jun 2023 10:14:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1BC21CC2;
	Thu,  1 Jun 2023 10:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E135C433D2;
	Thu,  1 Jun 2023 10:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685614441;
	bh=Nnp2tKeQsy9S1Buuet1AHc7f4tHZFZxjf1wLfSYTAOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MF5vLNhZLpSbVwcgCvq0oXRt929gpOhkr853XkKz69bg/ldd3tNXof5hsUBl0SCFP
	 zQZ15mT4d2ziMwvK3J8yM4HwL0HKNyCnKRsKvOqUGhynhIPIkiR0lcHqBpmr4JtDoY
	 c0p7+vyhNYXA7v2TlP4RC4JswkNElYkeEJLKFMa229yS/bUNH9LL8jgny7wXnZth8H
	 29CMTiAaeXP3OXygN5uAJ6WVb2EiM8nNfRFOymcc11hQEW05TvfK45mLkpdN2kJ1Pg
	 7p/23b1uSKjn8QRr7wdRVggNxp5f42/QF0VED+n4usyq7QAat/XaMSGR3H3OzbLL6t
	 qJvDLt1CyQM2A==
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
Subject: [PATCH 05/13] module, jitalloc: drop module_alloc
Date: Thu,  1 Jun 2023 13:12:49 +0300
Message-Id: <20230601101257.530867-6-rppt@kernel.org>
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

Define default parameters for address range for code allocations
using the current values in module_alloc() and make jit_text_alloc() use
these defaults when an architecure does not supply its specific
parameters.

With this, jit_text_alloc() implements memory allocation in a way
compatible with module_alloc() and can be used as a replacement for
module_alloc().

Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
---
 arch/arm64/kernel/module.c   |  2 +-
 arch/s390/kernel/module.c    |  2 +-
 arch/x86/kernel/module.c     |  2 +-
 include/linux/jitalloc.h     |  8 ++++++++
 include/linux/moduleloader.h | 12 ------------
 kernel/module/main.c         |  7 -------
 mm/jitalloc.c                | 31 +++++++++++++++++--------------
 7 files changed, 28 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
index ecf1f4030317..91ffcff5a44c 100644
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -24,7 +24,7 @@
 #include <asm/sections.h>
 
 static struct jit_alloc_params jit_alloc_params = {
-	.alignment	= MODULE_ALIGN,
+	.alignment	= JIT_ALLOC_ALIGN,
 	.flags		= JIT_ALLOC_KASAN_SHADOW,
 };
 
diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
index 0986a1a1b261..3f85cf1e7c4e 100644
--- a/arch/s390/kernel/module.c
+++ b/arch/s390/kernel/module.c
@@ -56,7 +56,7 @@ static unsigned long get_module_load_offset(void)
 }
 
 static struct jit_alloc_params jit_alloc_params = {
-	.alignment	= MODULE_ALIGN,
+	.alignment	= JIT_ALLOC_ALIGN,
 	.flags		= JIT_ALLOC_KASAN_SHADOW,
 	.text.pgprot	= PAGE_KERNEL,
 };
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index cce84b61a036..cacca613b8bd 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -67,7 +67,7 @@ static unsigned long int get_module_load_offset(void)
 #endif
 
 static struct jit_alloc_params jit_alloc_params = {
-	.alignment	= MODULE_ALIGN,
+	.alignment	= JIT_ALLOC_ALIGN,
 	.flags		= JIT_ALLOC_KASAN_SHADOW,
 };
 
diff --git a/include/linux/jitalloc.h b/include/linux/jitalloc.h
index 34ee57795a18..823b13706a90 100644
--- a/include/linux/jitalloc.h
+++ b/include/linux/jitalloc.h
@@ -4,6 +4,14 @@
 
 #include <linux/types.h>
 
+#if (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)) && \
+		!defined(CONFIG_KASAN_VMALLOC)
+#include <linux/kasan.h>
+#define JIT_ALLOC_ALIGN (PAGE_SIZE << KASAN_SHADOW_SCALE_SHIFT)
+#else
+#define JIT_ALLOC_ALIGN PAGE_SIZE
+#endif
+
 /**
  * enum jit_alloc_flags - options for executable memory allocations
  * @JIT_ALLOC_KASAN_SHADOW:	allocate kasan shadow
diff --git a/include/linux/moduleloader.h b/include/linux/moduleloader.h
index b3374342f7af..4321682fe849 100644
--- a/include/linux/moduleloader.h
+++ b/include/linux/moduleloader.h
@@ -25,10 +25,6 @@ int module_frob_arch_sections(Elf_Ehdr *hdr,
 /* Additional bytes needed by arch in front of individual sections */
 unsigned int arch_mod_section_prepend(struct module *mod, unsigned int section);
 
-/* Allocator used for allocating struct module, core sections and init
-   sections.  Returns NULL on failure. */
-void *module_alloc(unsigned long size);
-
 /* Determines if the section name is an init section (that is only used during
  * module loading).
  */
@@ -113,12 +109,4 @@ void module_arch_cleanup(struct module *mod);
 /* Any cleanup before freeing mod->module_init */
 void module_arch_freeing_init(struct module *mod);
 
-#if (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)) && \
-		!defined(CONFIG_KASAN_VMALLOC)
-#include <linux/kasan.h>
-#define MODULE_ALIGN (PAGE_SIZE << KASAN_SHADOW_SCALE_SHIFT)
-#else
-#define MODULE_ALIGN PAGE_SIZE
-#endif
-
 #endif
diff --git a/kernel/module/main.c b/kernel/module/main.c
index 51278c571bcb..dfb7fa109f1a 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1600,13 +1600,6 @@ static void free_modinfo(struct module *mod)
 	}
 }
 
-void * __weak module_alloc(unsigned long size)
-{
-	return __vmalloc_node_range(size, 1, VMALLOC_START, VMALLOC_END,
-			GFP_KERNEL, PAGE_KERNEL_EXEC, VM_FLUSH_RESET_PERMS,
-			NUMA_NO_NODE, __builtin_return_address(0));
-}
-
 bool __weak module_init_section(const char *name)
 {
 	return strstarts(name, ".init");
diff --git a/mm/jitalloc.c b/mm/jitalloc.c
index 4e10af7803f7..221940e36b46 100644
--- a/mm/jitalloc.c
+++ b/mm/jitalloc.c
@@ -60,20 +60,16 @@ void jit_free(void *buf)
 
 void *jit_text_alloc(size_t len)
 {
-	if (jit_alloc_params.text.start) {
-		unsigned int align = jit_alloc_params.alignment;
-		pgprot_t pgprot = jit_alloc_params.text.pgprot;
-		unsigned long start = jit_alloc_params.text.start;
-		unsigned long end = jit_alloc_params.text.end;
-		unsigned long fallback_start = jit_alloc_params.text.fallback_start;
-		unsigned long fallback_end = jit_alloc_params.text.fallback_end;
-		bool kasan = jit_alloc_params.flags & JIT_ALLOC_KASAN_SHADOW;
-
-		return jit_alloc(len, align, pgprot, start, end,
-				 fallback_start, fallback_end, kasan);
-	}
-
-	return module_alloc(len);
+	unsigned int align = jit_alloc_params.alignment;
+	pgprot_t pgprot = jit_alloc_params.text.pgprot;
+	unsigned long start = jit_alloc_params.text.start;
+	unsigned long end = jit_alloc_params.text.end;
+	unsigned long fallback_start = jit_alloc_params.text.fallback_start;
+	unsigned long fallback_end = jit_alloc_params.text.fallback_end;
+	bool kasan = jit_alloc_params.flags & JIT_ALLOC_KASAN_SHADOW;
+
+	return jit_alloc(len, align, pgprot, start, end,
+			 fallback_start, fallback_end, kasan);
 }
 
 struct jit_alloc_params * __weak jit_alloc_arch_params(void)
@@ -101,5 +97,12 @@ void jit_alloc_init(void)
 			return;
 
 		jit_alloc_params = *p;
+		return;
 	}
+
+	/* defaults for architecures that don't need special handling */
+	jit_alloc_params.alignment	= 1;
+	jit_alloc_params.text.pgprot	= PAGE_KERNEL_EXEC;
+	jit_alloc_params.text.start	= VMALLOC_START;
+	jit_alloc_params.text.end	= VMALLOC_END;
 }
-- 
2.35.1


