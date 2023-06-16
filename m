Return-Path: <netdev+bounces-11330-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D64FD732A33
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:51:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04FC11C20F7F
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:51:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D594EA928;
	Fri, 16 Jun 2023 08:51:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E1B2569;
	Fri, 16 Jun 2023 08:50:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D119C433C0;
	Fri, 16 Jun 2023 08:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686905458;
	bh=UifOGBhwjuFfbJuOcG7ahrWbKbx6ngB0ASSIbVF4SDg=;
	h=From:To:Cc:Subject:Date:From;
	b=ck0ec7mnOXOJHNfyR0Cuz10mDHrTJaqzBdkJJzGI4J5mxsDw+S1o8grrhlLF0PRRJ
	 Blj2mY565pFuuPac9zqDUVIJhp2GAgrXs6ZInsTC/6pWhSlWp11aHMJNQn9eODGEeh
	 VSvFVRn4+rUIJbQbY7eRV1WOekMqiki5eGyfHIlx8ZQ2xx8xQp/apWKMDOp78uimel
	 sukig/TwDMPtoPPprD/GNVQGbNgwIMeqg0FWBqqu8wfvHogW2g7+TEtlFT4sJSL93V
	 o47E4rKDkN2DN+bQ/ziUVnSQt1N7BfNFA4zob4IPcJj+QLlo2BCg+LbIduSrfniXxn
	 WV2mvb8jIG0NA==
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
Subject: [PATCH v2 00/12] mm: jit/text allocator
Date: Fri, 16 Jun 2023 11:50:26 +0300
Message-Id: <20230616085038.4121892-1-rppt@kernel.org>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Mike Rapoport (IBM)" <rppt@kernel.org>

Hi,

module_alloc() is used everywhere as a mean to allocate memory for code.

Beside being semantically wrong, this unnecessarily ties all subsystmes
that need to allocate code, such as ftrace, kprobes and BPF to modules and
puts the burden of code allocation to the modules code.

Several architectures override module_alloc() because of various
constraints where the executable memory can be located and this causes
additional obstacles for improvements of code allocation.

A centralized infrastructure for code allocation allows allocations of
executable memory as ROX, and future optimizations such as caching large
pages for better iTLB performance and providing sub-page allocations for
users that only need small jit code snippets.

Rick Edgecombe proposed perm_alloc extension to vmalloc [1] and Song Liu
proposed execmem_alloc [2], but both these approaches were targeting BPF
allocations and lacked the ground work to abstract executable allocations
and split them from the modules core.

Thomas Gleixner's suggested to express module allocation restrictions and
requirements as struct mod_alloc_type_params [3] that would define ranges,
protections and other parameters for different types of allocations used by
modules and following that suggestion Song separated allocations of
different types in modules (commit ac3b43283923 ("module: replace
module_layout with module_memory")) and posted "Type aware module
allocator" set [4].

I liked the idea of parametrising code allocation requirements as a
structure, but I believe the original proposal and Song's module allocator
were too module centric, so I came up with these patches.

This set splits code allocation from modules by introducing
execmem_text_alloc(), execmem_data_alloc(), execmem_free(),
jit_text_alloc() and jit_free() APIs, replaces call sites of module_alloc()
and module_memfree() with the new APIs and implements core text and related
allocation in a central place.

Instead of architecture specific overrides for module_alloc(), the
architectures that require non-default behaviour for text allocation must
fill execmem_alloc_params structure and implement execmem_arch_params()
that returns a pointer to that structure. If an architecture does not
implement execmem_arch_params(), the defaults compatible with the current
modules::module_alloc() are used.

The intended semantics of the new APIs is that execmem APIs should be used
to allocate memory that must reside close to the kernel image because of
addressing mode restrictions, e.g modules on many architectures or dynamic
ftrace trampolines on x86.

The jit APIs are intended for users that can place code anywhere in vmalloc
area, like kprobes on most architectures and BPF on arm/arm64.

While two distinct API cover the major cases, there is still might be need
for arch-specific overrides for some of the usecases. For example, riscv
uses a dedicated range for BPF allocations in order to be able to use
relative addressing, but for kprobes riscv can use the entire vmalloc area.
For such overrides we might introduce jit_text_alloc variant that gets
start + end parameters to restrict the range like Mark Rutland suggested
and then use that variant in arch override.

The new infrastructure allows decoupling of kprobes and ftrace from
modules, and most importantly it paves the way for ROX allocations for
executable memory.

For now I've dropped patches that enable ROX allocations on x86 because
with them modprobe takes ten times more. To make modprobe fast with ROX
allocations more work is required to text poking infrastructure, but this
work is not a prerequisite for this series.

[1] https://lore.kernel.org/lkml/20201120202426.18009-1-rick.p.edgecombe@intel.com/
[2] https://lore.kernel.org/all/20221107223921.3451913-1-song@kernel.org/
[3] https://lore.kernel.org/all/87v8mndy3y.ffs@tglx/
[4] https://lore.kernel.org/all/20230526051529.3387103-1-song@kernel.org

v2 changes:
* Separate "module" and "others" allocations with execmem_text_alloc()
and jit_text_alloc()
* Drop ROX entablement on x86
* Add ack for nios2 changes, thanks Dinh Nguyen

v1: https://lore.kernel.org/all/20230601101257.530867-1-rppt@kernel.org

Mike Rapoport (IBM) (12):
  nios2: define virtual address space for modules
  mm: introduce execmem_text_alloc() and jit_text_alloc()
  mm/execmem, arch: convert simple overrides of module_alloc to execmem
  mm/execmem, arch: convert remaining overrides of module_alloc to execmem
  modules, execmem: drop module_alloc
  mm/execmem: introduce execmem_data_alloc()
  arm64, execmem: extend execmem_params for generated code definitions
  riscv: extend execmem_params for kprobes allocations
  powerpc: extend execmem_params for kprobes allocations
  arch: make execmem setup available regardless of CONFIG_MODULES
  x86/ftrace: enable dynamic ftrace without CONFIG_MODULES
  kprobes: remove dependcy on CONFIG_MODULES

 arch/Kconfig                       |   2 +-
 arch/arm/kernel/module.c           |  32 ------
 arch/arm/mm/init.c                 |  36 ++++++
 arch/arm64/include/asm/memory.h    |   8 ++
 arch/arm64/include/asm/module.h    |   6 -
 arch/arm64/kernel/kaslr.c          |   3 +-
 arch/arm64/kernel/module.c         |  47 --------
 arch/arm64/kernel/probes/kprobes.c |   7 --
 arch/arm64/mm/init.c               |  56 +++++++++
 arch/loongarch/kernel/module.c     |   6 -
 arch/loongarch/mm/init.c           |  20 ++++
 arch/mips/kernel/module.c          |  10 +-
 arch/mips/mm/init.c                |  19 ++++
 arch/nios2/include/asm/pgtable.h   |   5 +-
 arch/nios2/kernel/module.c         |  28 +++--
 arch/parisc/kernel/module.c        |  12 +-
 arch/parisc/mm/init.c              |  22 +++-
 arch/powerpc/kernel/kprobes.c      |  16 +--
 arch/powerpc/kernel/module.c       |  37 ------
 arch/powerpc/mm/mem.c              |  59 ++++++++++
 arch/riscv/kernel/module.c         |  10 --
 arch/riscv/kernel/probes/kprobes.c |  10 --
 arch/riscv/mm/init.c               |  34 ++++++
 arch/s390/kernel/ftrace.c          |   4 +-
 arch/s390/kernel/kprobes.c         |   4 +-
 arch/s390/kernel/module.c          |  42 +------
 arch/s390/mm/init.c                |  41 +++++++
 arch/sparc/kernel/module.c         |  33 +-----
 arch/sparc/mm/Makefile             |   2 +
 arch/sparc/mm/execmem.c            |  25 ++++
 arch/sparc/net/bpf_jit_comp_32.c   |   8 +-
 arch/x86/Kconfig                   |   1 +
 arch/x86/kernel/ftrace.c           |  16 +--
 arch/x86/kernel/kprobes/core.c     |   4 +-
 arch/x86/kernel/module.c           |  51 ---------
 arch/x86/mm/init.c                 |  54 +++++++++
 include/linux/execmem.h            | 155 +++++++++++++++++++++++++
 include/linux/moduleloader.h       |  15 ---
 kernel/bpf/core.c                  |  14 +--
 kernel/kprobes.c                   |  51 +++++----
 kernel/module/Kconfig              |   1 +
 kernel/module/main.c               |  45 ++------
 kernel/trace/trace_kprobe.c        |  11 ++
 mm/Kconfig                         |   3 +
 mm/Makefile                        |   1 +
 mm/execmem.c                       | 177 +++++++++++++++++++++++++++++
 mm/mm_init.c                       |   2 +
 47 files changed, 813 insertions(+), 432 deletions(-)
 create mode 100644 arch/sparc/mm/execmem.c
 create mode 100644 include/linux/execmem.h
 create mode 100644 mm/execmem.c


base-commit: 44c026a73be8038f03dbdeef028b642880cf1511
-- 
2.35.1


