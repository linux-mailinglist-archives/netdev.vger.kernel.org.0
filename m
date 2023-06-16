Return-Path: <netdev+bounces-11339-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A26D9732A99
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:55:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D6E0280C8A
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:55:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 708C4171C6;
	Fri, 16 Jun 2023 08:52:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14474A925;
	Fri, 16 Jun 2023 08:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10D2C433C9;
	Fri, 16 Jun 2023 08:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686905546;
	bh=zp7Q5W5hhg/nI6mMLaPrtf/lusmFV7Z8YW7nip5II4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KxFrWYHeHpwcGUbxWkaMB83ecrjl0v+hXSJoSdevwYq1457qx+XC5pH2hwNcB7OJy
	 BwvPt5jaXdXDVAAK8wLt3BvkhL9bFKm5ZmoUGY+wBwPfiaUq1FrMNmPitFFFnpVK4u
	 ixA3C4gmJvX3Phwm0Cb/Ti+UGSkHwd2cn1C9JGVhNDuPjLJpERB/EawaSAnIJWgY0d
	 6dDF3oU5Bwj/MqxfBhEq0t0GM9GOHhDIGHOxT6E9WlvGlwMglCXID10GCfWlmI5Mxv
	 XJJ8eW7PieCf7GdA0Y1v+oFScNl8TL9sHxqnk8aS5sDFO0f8pXzJpZGi3DtHbexORX
	 ISfK1uW//RIDw==
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
Subject: [PATCH v2 09/12] powerpc: extend execmem_params for kprobes allocations
Date: Fri, 16 Jun 2023 11:50:35 +0300
Message-Id: <20230616085038.4121892-10-rppt@kernel.org>
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

powerpc overrides kprobes::alloc_insn_page() to remove writable
permissions when STRICT_MODULE_RWX is on.

Add definition of jit area to execmem_params to allow using the generic
kprobes::alloc_insn_page() with the desired permissions.

As powerpc uses breakpoint instructions to inject kprobes, it does not
need to constrain kprobe allocations to the modules area and can use the
entire vmalloc address space.

Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
---
 arch/powerpc/kernel/kprobes.c | 14 --------------
 arch/powerpc/kernel/module.c  | 13 +++++++++++++
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/kernel/kprobes.c b/arch/powerpc/kernel/kprobes.c
index 5db8df5e3657..14c5ddec3056 100644
--- a/arch/powerpc/kernel/kprobes.c
+++ b/arch/powerpc/kernel/kprobes.c
@@ -126,20 +126,6 @@ kprobe_opcode_t *arch_adjust_kprobe_addr(unsigned long addr, unsigned long offse
 	return (kprobe_opcode_t *)(addr + offset);
 }
 
-void *alloc_insn_page(void)
-{
-	void *page;
-
-	page = jit_text_alloc(PAGE_SIZE);
-	if (!page)
-		return NULL;
-
-	if (strict_module_rwx_enabled())
-		set_memory_rox((unsigned long)page, 1);
-
-	return page;
-}
-
 int arch_prepare_kprobe(struct kprobe *p)
 {
 	int ret = 0;
diff --git a/arch/powerpc/kernel/module.c b/arch/powerpc/kernel/module.c
index 4c6c15bf3947..8e5b379d6da1 100644
--- a/arch/powerpc/kernel/module.c
+++ b/arch/powerpc/kernel/module.c
@@ -96,6 +96,11 @@ static struct execmem_params execmem_params = {
 			.alignment = 1,
 		},
 	},
+	.jit = {
+		.text = {
+			.alignment = 1,
+		},
+	},
 };
 
 
@@ -131,5 +136,13 @@ struct execmem_params __init *execmem_arch_params(void)
 
 	execmem_params.modules.text.pgprot = prot;
 
+	execmem_params.jit.text.start = VMALLOC_START;
+	execmem_params.jit.text.end = VMALLOC_END;
+
+	if (strict_module_rwx_enabled())
+		execmem_params.jit.text.pgprot = PAGE_KERNEL_ROX;
+	else
+		execmem_params.jit.text.pgprot = PAGE_KERNEL_EXEC;
+
 	return &execmem_params;
 }
-- 
2.35.1


