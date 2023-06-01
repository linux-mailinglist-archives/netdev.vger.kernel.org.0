Return-Path: <netdev+bounces-7142-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6618271EE5D
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:12:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 038A91C2107F
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:12:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 949CB4078B;
	Thu,  1 Jun 2023 16:12:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBBCBA2F;
	Thu,  1 Jun 2023 16:12:16 +0000 (UTC)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 50B4C18F;
	Thu,  1 Jun 2023 09:12:13 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 525171063;
	Thu,  1 Jun 2023 09:12:58 -0700 (PDT)
Received: from FVFF77S0Q05N.cambridge.arm.com (FVFF77S0Q05N.cambridge.arm.com [10.1.36.140])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C47623F663;
	Thu,  1 Jun 2023 09:12:06 -0700 (PDT)
Date: Thu, 1 Jun 2023 17:12:03 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"David S. Miller" <davem@davemloft.net>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Russell King <linux@armlinux.org.uk>, Song Liu <song@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
	bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mips@vger.kernel.org, linux-mm@kvack.org,
	linux-modules@vger.kernel.org, linux-parisc@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	loongarch@lists.linux.dev, netdev@vger.kernel.org,
	sparclinux@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 00/13] mm: jit/text allocator
Message-ID: <ZHjDU/mxE+cugpLj@FVFF77S0Q05N.cambridge.arm.com>
References: <20230601101257.530867-1-rppt@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601101257.530867-1-rppt@kernel.org>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Mike,

On Thu, Jun 01, 2023 at 01:12:44PM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (IBM)" <rppt@kernel.org>
> 
> Hi,
> 
> module_alloc() is used everywhere as a mean to allocate memory for code.
> 
> Beside being semantically wrong, this unnecessarily ties all subsystmes
> that need to allocate code, such as ftrace, kprobes and BPF to modules
> and puts the burden of code allocation to the modules code.

I agree this is a problem, and one key issue here is that these can have
different requirements. For example, on arm64 we need modules to be placed
within a 128M or 2G window containing the kernel, whereas it would be safe for
the kprobes XOL area to be placed arbitrarily far from the kernel image (since
we don't allow PC-relative insns to be stepped out-of-line). Likewise arm64
doesn't have ftrace trampolines, and DIRECT_CALL trampolines can safely be
placed arbitarily far from the kernel image.

For a while I have wanted to give kprobes its own allocator so that it can work
even with CONFIG_MODULES=n, and so that it doesn't have to waste VA space in
the modules area.

Given that, I think these should have their own allocator functions that can be
provided independently, even if those happen to use common infrastructure.

> Several architectures override module_alloc() because of various
> constraints where the executable memory can be located and this causes
> additional obstacles for improvements of code allocation.
> 
> This set splits code allocation from modules by introducing
> jit_text_alloc(), jit_data_alloc() and jit_free() APIs, replaces call
> sites of module_alloc() and module_memfree() with the new APIs and
> implements core text and related allocation in a central place.
> 
> Instead of architecture specific overrides for module_alloc(), the
> architectures that require non-default behaviour for text allocation must
> fill jit_alloc_params structure and implement jit_alloc_arch_params() that
> returns a pointer to that structure. If an architecture does not implement
> jit_alloc_arch_params(), the defaults compatible with the current
> modules::module_alloc() are used.

As above, I suspect that each of the callsites should probably be using common
infrastructure, but I don't think that a single jit_alloc_arch_params() makes
sense, since the parameters for each case may need to be distinct.

> The new jitalloc infrastructure allows decoupling of kprobes and ftrace
> from modules, and most importantly it enables ROX allocations for
> executable memory.
> 
> A centralized infrastructure for code allocation allows future
> optimizations for allocations of executable memory, caching large pages for
> better iTLB performance and providing sub-page allocations for users that
> only need small jit code snippets.

This sounds interesting, but I think this can be achieved without requiring a
single jit_alloc_arch_params() shared by all users?

Thanks,
Mark.

> 
> patches 1-5: split out the code allocation from modules and arch
> patch 6: add dedicated API for data allocations with constraints similar to
> code allocations
> patches 7-9: decouple dynamic ftrace and kprobes form CONFIG_MODULES
> patches 10-13: enable ROX allocations for executable memory on x86
> 
> Mike Rapoport (IBM) (11):
>   nios2: define virtual address space for modules
>   mm: introduce jit_text_alloc() and use it instead of module_alloc()
>   mm/jitalloc, arch: convert simple overrides of module_alloc to jitalloc
>   mm/jitalloc, arch: convert remaining overrides of module_alloc to jitalloc
>   module, jitalloc: drop module_alloc
>   mm/jitalloc: introduce jit_data_alloc()
>   x86/ftrace: enable dynamic ftrace without CONFIG_MODULES
>   arch: make jitalloc setup available regardless of CONFIG_MODULES
>   kprobes: remove dependcy on CONFIG_MODULES
>   modules, jitalloc: prepare to allocate executable memory as ROX
>   x86/jitalloc: make memory allocated for code ROX
> 
> Song Liu (2):
>   ftrace: Add swap_func to ftrace_process_locs()
>   x86/jitalloc: prepare to allocate exectuatble memory as ROX
> 
>  arch/Kconfig                     |   5 +-
>  arch/arm/kernel/module.c         |  32 ------
>  arch/arm/mm/init.c               |  35 ++++++
>  arch/arm64/kernel/module.c       |  47 --------
>  arch/arm64/mm/init.c             |  42 +++++++
>  arch/loongarch/kernel/module.c   |   6 -
>  arch/loongarch/mm/init.c         |  16 +++
>  arch/mips/kernel/module.c        |   9 --
>  arch/mips/mm/init.c              |  19 ++++
>  arch/nios2/include/asm/pgtable.h |   5 +-
>  arch/nios2/kernel/module.c       |  24 ++--
>  arch/parisc/kernel/module.c      |  11 --
>  arch/parisc/mm/init.c            |  21 +++-
>  arch/powerpc/kernel/kprobes.c    |   4 +-
>  arch/powerpc/kernel/module.c     |  37 -------
>  arch/powerpc/mm/mem.c            |  41 +++++++
>  arch/riscv/kernel/module.c       |  10 --
>  arch/riscv/mm/init.c             |  18 +++
>  arch/s390/kernel/ftrace.c        |   4 +-
>  arch/s390/kernel/kprobes.c       |   4 +-
>  arch/s390/kernel/module.c        |  46 +-------
>  arch/s390/mm/init.c              |  35 ++++++
>  arch/sparc/kernel/module.c       |  34 +-----
>  arch/sparc/mm/Makefile           |   2 +
>  arch/sparc/mm/jitalloc.c         |  21 ++++
>  arch/sparc/net/bpf_jit_comp_32.c |   8 +-
>  arch/x86/Kconfig                 |   2 +
>  arch/x86/kernel/alternative.c    |  43 ++++---
>  arch/x86/kernel/ftrace.c         |  59 +++++-----
>  arch/x86/kernel/kprobes/core.c   |   4 +-
>  arch/x86/kernel/module.c         |  75 +------------
>  arch/x86/kernel/static_call.c    |  10 +-
>  arch/x86/kernel/unwind_orc.c     |  13 ++-
>  arch/x86/mm/init.c               |  52 +++++++++
>  arch/x86/net/bpf_jit_comp.c      |  22 +++-
>  include/linux/ftrace.h           |   2 +
>  include/linux/jitalloc.h         |  69 ++++++++++++
>  include/linux/moduleloader.h     |  15 ---
>  kernel/bpf/core.c                |  14 +--
>  kernel/kprobes.c                 |  51 +++++----
>  kernel/module/Kconfig            |   1 +
>  kernel/module/main.c             |  56 ++++------
>  kernel/trace/ftrace.c            |  13 ++-
>  kernel/trace/trace_kprobe.c      |  11 ++
>  mm/Kconfig                       |   3 +
>  mm/Makefile                      |   1 +
>  mm/jitalloc.c                    | 185 +++++++++++++++++++++++++++++++
>  mm/mm_init.c                     |   2 +
>  48 files changed, 777 insertions(+), 462 deletions(-)
>  create mode 100644 arch/sparc/mm/jitalloc.c
>  create mode 100644 include/linux/jitalloc.h
>  create mode 100644 mm/jitalloc.c
> 
> 
> base-commit: 44c026a73be8038f03dbdeef028b642880cf1511
> -- 
> 2.35.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

