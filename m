Return-Path: <netdev+bounces-11338-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AF7A732A96
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:55:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5AA571C20FD4
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:55:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CDF315AE8;
	Fri, 16 Jun 2023 08:52:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56357A925;
	Fri, 16 Jun 2023 08:52:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3C5C433CD;
	Fri, 16 Jun 2023 08:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686905537;
	bh=QpRLaiTQjkFAZbWC8PMbwO4haV/9se+uMBjn/xjk6Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RXsNDUtYj249KQAhJs+wEQjCxqfjKx6/L1Un4qq+20KcffdZ1deQG8lIIT7DV+ZMq
	 m0eHek+DKutrTD2bY61bqwx/MvyuFb7gWqbU+m6qEsiGCLCvTZ7S6qv0+x7akVCFuB
	 hR9l1tbgw6B2t7wTqYFLvXI+KAAIhbgEWQDFcYOxbtABFlclmsFbdqgW4kmI9RoSdI
	 zuYaQBPZBK8o2VXshwQtSE3bM0njGcW3mDpBRHQHK++MLDhg4oBdqwaVZ6MqkCYoov
	 3oCj/KsihjERHBpOHzrJ3ShbDZ37kQWZGW77+ZrjAOqj6IbLfSqY9c93w/m7agDClK
	 PWUowLo8PSiqQ==
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
Subject: [PATCH v2 08/12] riscv: extend execmem_params for kprobes allocations
Date: Fri, 16 Jun 2023 11:50:34 +0300
Message-Id: <20230616085038.4121892-9-rppt@kernel.org>
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

RISC-V overrides kprobes::alloc_insn_range() to use the entire vmalloc area
rather than limit the allocations to the modules area.

Slightly reorder execmem_params initialization to support both 32 and 64
bit variantsi and add definition of jit area to execmem_params to support
generic kprobes::alloc_insn_page().

Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
---
 arch/riscv/kernel/module.c         | 16 +++++++++++++++-
 arch/riscv/kernel/probes/kprobes.c | 10 ----------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/arch/riscv/kernel/module.c b/arch/riscv/kernel/module.c
index ee5e04cd3f21..cca6ed4e9340 100644
--- a/arch/riscv/kernel/module.c
+++ b/arch/riscv/kernel/module.c
@@ -436,7 +436,7 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 	return 0;
 }
 
-#if defined(CONFIG_MMU) && defined(CONFIG_64BIT)
+#ifdef CONFIG_MMU
 static struct execmem_params execmem_params = {
 	.modules = {
 		.text = {
@@ -444,12 +444,26 @@ static struct execmem_params execmem_params = {
 			.alignment = 1,
 		},
 	},
+	.jit = {
+		.text = {
+			.pgprot = PAGE_KERNEL_READ_EXEC,
+			.alignment = 1,
+		},
+	},
 };
 
 struct execmem_params __init *execmem_arch_params(void)
 {
+#ifdef CONFIG_64BIT
 	execmem_params.modules.text.start = MODULES_VADDR;
 	execmem_params.modules.text.end = MODULES_END;
+#else
+	execmem_params.modules.text.start = VMALLOC_START;
+	execmem_params.modules.text.end = VMALLOC_END;
+#endif
+
+	execmem_params.jit.text.start = VMALLOC_START;
+	execmem_params.jit.text.end = VMALLOC_END;
 
 	return &execmem_params;
 }
diff --git a/arch/riscv/kernel/probes/kprobes.c b/arch/riscv/kernel/probes/kprobes.c
index 2f08c14a933d..e64f2f3064eb 100644
--- a/arch/riscv/kernel/probes/kprobes.c
+++ b/arch/riscv/kernel/probes/kprobes.c
@@ -104,16 +104,6 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	return 0;
 }
 
-#ifdef CONFIG_MMU
-void *alloc_insn_page(void)
-{
-	return  __vmalloc_node_range(PAGE_SIZE, 1, VMALLOC_START, VMALLOC_END,
-				     GFP_KERNEL, PAGE_KERNEL_READ_EXEC,
-				     VM_FLUSH_RESET_PERMS, NUMA_NO_NODE,
-				     __builtin_return_address(0));
-}
-#endif
-
 /* install breakpoint in text */
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
-- 
2.35.1


