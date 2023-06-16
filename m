Return-Path: <netdev+bounces-11337-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CE337732A94
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:54:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0362C1C20F97
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:54:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50AB3C8E5;
	Fri, 16 Jun 2023 08:52:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C5014AAB;
	Fri, 16 Jun 2023 08:52:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 436DDC4339A;
	Fri, 16 Jun 2023 08:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686905527;
	bh=3ehPtg/wkIhd28ojF38ghyySOncCvbgritUgNc+jgzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=URGjKWosTv5rUBGWoAB8K22n+ckY0pEN8K+Bt4BqNRZ+SgzdpFKHreY43HU1dyMrc
	 63qklWW1H6ICT8nAwvHWhUBFVD/O59OAxG9WnKC7G37cBbzQyL5wndhMi12b+NjTmA
	 KzxWoXixUG1F/na3FTPbuDPpQSkcBRHUusl/huYZwNS0rNpCLSziH8G8sg9C2Gr5+V
	 sMjxpInlVLQ2ozavBCagEh9Z3UDjWGN+DByqgzlPXrWZaDTPyD05GivzpznP9XZ9h4
	 lQRd/685TGI6dpS6i6K691630F1e6FUmQK1hrJ/8UhpaIZwAh+GhrqsCum/sDilGPE
	 b7T6Nk8NGUZ9A==
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
	Mark Rutland <mark.rutland@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Mike Rapoport <rppt@kernel.org>,
	Nadav Amit <nadav.amit@gmail.com>,
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Puranjay Mohan <puranjay12@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
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
Subject: [PATCH v2 07/12] arm64, execmem: extend execmem_params for generated code definitions
Date: Fri, 16 Jun 2023 11:50:33 +0300
Message-Id: <20230616085038.4121892-8-rppt@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230616085038.4121892-1-rppt@kernel.org>
References: <20230616085038.4121892-1-rppt@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Mike Rapoport (IBM)" <rppt@kernel.org>

The memory allocations for kprobes on arm64 can be placed anywhere in
vmalloc address space and currently this is implemented with an override
of alloc_insn_page() in arm64.

Extend execmem_params with a range for generated code allocations and
make kprobes on arm64 use this extension rather than override
alloc_insn_page().

Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
---
 arch/arm64/kernel/module.c         |  9 +++++++++
 arch/arm64/kernel/probes/kprobes.c |  7 -------
 include/linux/execmem.h            | 11 +++++++++++
 mm/execmem.c                       | 14 +++++++++++++-
 4 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
index c3d999f3a3dd..52b09626bc0f 100644
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -30,6 +30,13 @@ static struct execmem_params execmem_params = {
 			.alignment = MODULE_ALIGN,
 		},
 	},
+	.jit = {
+		.text = {
+			.start = VMALLOC_START,
+			.end = VMALLOC_END,
+			.alignment = 1,
+		},
+	},
 };
 
 struct execmem_params __init *execmem_arch_params(void)
@@ -40,6 +47,8 @@ struct execmem_params __init *execmem_arch_params(void)
 	execmem_params.modules.text.start = module_alloc_base;
 	execmem_params.modules.text.end = module_alloc_end;
 
+	execmem_params.jit.text.pgprot = PAGE_KERNEL_ROX;
+
 	/*
 	 * KASAN without KASAN_VMALLOC can only deal with module
 	 * allocations being served from the reserved module region,
diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/kprobes.c
index 70b91a8c6bb3..6fccedd02b2a 100644
--- a/arch/arm64/kernel/probes/kprobes.c
+++ b/arch/arm64/kernel/probes/kprobes.c
@@ -129,13 +129,6 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	return 0;
 }
 
-void *alloc_insn_page(void)
-{
-	return __vmalloc_node_range(PAGE_SIZE, 1, VMALLOC_START, VMALLOC_END,
-			GFP_KERNEL, PAGE_KERNEL_ROX, VM_FLUSH_RESET_PERMS,
-			NUMA_NO_NODE, __builtin_return_address(0));
-}
-
 /* arm kprobe: install breakpoint in text */
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
diff --git a/include/linux/execmem.h b/include/linux/execmem.h
index 2e1221310d13..dc7c9a446111 100644
--- a/include/linux/execmem.h
+++ b/include/linux/execmem.h
@@ -52,12 +52,23 @@ struct execmem_modules_range {
 	struct execmem_range data;
 };
 
+/**
+ * struct execmem_jit_range - architecure parameters for address space
+ *			      suitable for JIT code allocations
+ * @text:	address range for text allocations
+ */
+struct execmem_jit_range {
+	struct execmem_range text;
+};
+
 /**
  * struct execmem_params -	architecure parameters for code allocations
  * @modules:	parameters for modules address space
+ * @jit:	parameters for jit memory address space
  */
 struct execmem_params {
 	struct execmem_modules_range	modules;
+	struct execmem_jit_range	jit;
 };
 
 /**
diff --git a/mm/execmem.c b/mm/execmem.c
index f7bf496ad4c3..9730ecef9a30 100644
--- a/mm/execmem.c
+++ b/mm/execmem.c
@@ -89,7 +89,12 @@ void execmem_free(void *ptr)
 
 void *jit_text_alloc(size_t size)
 {
-	return execmem_text_alloc(size);
+	unsigned long start = execmem_params.jit.text.start;
+	unsigned long end = execmem_params.jit.text.end;
+	pgprot_t pgprot = execmem_params.jit.text.pgprot;
+	unsigned int align = execmem_params.jit.text.alignment;
+
+	return execmem_alloc(size, start, end, align, pgprot, 0, 0, false);
 }
 
 void jit_free(void *ptr)
@@ -135,6 +140,13 @@ static void execmem_init_missing(struct execmem_params *p)
 		execmem_params.modules.data.fallback_start = m->text.fallback_start;
 		execmem_params.modules.data.fallback_end = m->text.fallback_end;
 	}
+
+	if (!execmem_params.jit.text.start) {
+		execmem_params.jit.text.start = m->text.start;
+		execmem_params.jit.text.end = m->text.end;
+		execmem_params.jit.text.alignment = m->text.alignment;
+		execmem_params.jit.text.pgprot = m->text.pgprot;
+	}
 }
 
 void __init execmem_init(void)
-- 
2.35.1


