Return-Path: <netdev+bounces-2863-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EB67704502
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 08:16:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFCF328156C
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 06:16:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 045441D2C2;
	Tue, 16 May 2023 06:16:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C630519E73;
	Tue, 16 May 2023 06:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907F1C433D2;
	Tue, 16 May 2023 06:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684217760;
	bh=JSKxIFbAGqeUfrEyWSCXAbIJPXLuLup+2ppnOocd+Xk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HUdGEoKrHYqdQV9SKzKvV4HYtCsB6X2tL91pPrPLU7aNWXYb1cOIHv9LSMrHFD7CI
	 0UTMXTpKUNkE9khoCtx9RUXA27WX/8zAAqq3qWqx7wkmbqiEDA9g8zX2B9xH3F+edr
	 xWXEJ+1QmffpOMNcS1tYLp1lC2jqrVqLE/mM56vjQpDQB5I22BUv18GXFSNkei6e/5
	 Lnopwl4GmIA1AWbZ9ApJSlye00mdX/GHqSbo/wMwd+5PuEF2+6V9I/luIZwajeiQqi
	 HijxI+kept+Q4t/F6SqagBMmOxLf1/y5W+58LQldnVuOyrQH6/M5/nNwJ5xypS1sOp
	 Ez80gpOsB3pew==
Date: Tue, 16 May 2023 09:15:51 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Baoquan He <bhe@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, arnd@arndb.de, christophe.leroy@csgroup.eu,
	hch@infradead.org, agordeev@linux.ibm.com,
	wangkefeng.wang@huawei.com, schnelle@linux.ibm.com,
	David.Laight@aculab.com, shorne@gmail.com, willy@infradead.org,
	deller@gmx.de, loongarch@lists.linux.dev,
	linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v5 RESEND 01/17] asm-generic/iomap.h: remove
 ARCH_HAS_IOREMAP_xx macros
Message-ID: <ZGMfl5KW9sXkhT8n@kernel.org>
References: <20230515090848.833045-1-bhe@redhat.com>
 <20230515090848.833045-2-bhe@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515090848.833045-2-bhe@redhat.com>

Hi,

On Mon, May 15, 2023 at 05:08:32PM +0800, Baoquan He wrote:
> Let's use '#define ioremap_xx' and "#ifdef ioremap_xx" instead.
> 
> For each architecture to remove defined ARCH_HAS_IOREMAP_xx macros in

This sentence seems to be stale.

> To remove defined ARCH_HAS_IOREMAP_xx macros in <asm/io.h> of each ARCH,
> the ARCH's own ioremap_wc|wt|np definition need be above
> "#include <asm-generic/iomap.h>. Otherwise the redefinition error would
> be seen during compiling. So the relevant adjustments are made to avoid
> compiling error:
> 
>   loongarch:
>   - doesn't include <asm-generic/iomap.h>, defining ARCH_HAS_IOREMAP_WC
>     is redundant, so simply remove it.
> 
>   m68k:
>   - selected GENERIC_IOMAP, <asm-generic/iomap.h> has been added in
>     <asm-generic/io.h>, and <asm/kmap.h> is included above
>     <asm-generic/iomap.h>, so simply remove ARCH_HAS_IOREMAP_WT defining.
> 
>   mips:
>   - move "#include <asm-generic/iomap.h>" below ioremap_wc definition
>     in <asm/io.h>
> 
>   powerpc:
>   - remove "#include <asm-generic/iomap.h>" in <asm/io.h> because it's
>     duplicated with the one in <asm-generic/io.h>, let's rely on the
>     latter.
> 
>   x86:
>   - selected GENERIC_IOMAP, remove #include <asm-generic/iomap.h> in
>     the middle of <asm/io.h>. Let's rely on <asm-generic/io.h>.
> 
> Signed-off-by: Baoquan He <bhe@redhat.com>
> Cc: loongarch@lists.linux.dev
> Cc: linux-m68k@lists.linux-m68k.org
> Cc: linux-mips@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: x86@kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-arch@vger.kernel.org

Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>

> ---
>  arch/loongarch/include/asm/io.h     | 2 --
>  arch/m68k/include/asm/io_mm.h       | 2 --
>  arch/m68k/include/asm/kmap.h        | 2 --
>  arch/mips/include/asm/io.h          | 5 ++---
>  arch/powerpc/include/asm/io.h       | 9 +--------
>  arch/x86/include/asm/io.h           | 5 -----
>  drivers/net/ethernet/sfc/io.h       | 2 +-
>  drivers/net/ethernet/sfc/siena/io.h | 2 +-
>  include/asm-generic/iomap.h         | 6 +++---
>  9 files changed, 8 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/loongarch/include/asm/io.h b/arch/loongarch/include/asm/io.h
> index 545e2708fbf7..5fef1246c6fb 100644
> --- a/arch/loongarch/include/asm/io.h
> +++ b/arch/loongarch/include/asm/io.h
> @@ -5,8 +5,6 @@
>  #ifndef _ASM_IO_H
>  #define _ASM_IO_H
>  
> -#define ARCH_HAS_IOREMAP_WC
> -
>  #include <linux/kernel.h>
>  #include <linux/types.h>
>  
> diff --git a/arch/m68k/include/asm/io_mm.h b/arch/m68k/include/asm/io_mm.h
> index d41fa488453b..6a0abd4846c6 100644
> --- a/arch/m68k/include/asm/io_mm.h
> +++ b/arch/m68k/include/asm/io_mm.h
> @@ -26,8 +26,6 @@
>  #include <asm/virtconvert.h>
>  #include <asm/kmap.h>
>  
> -#include <asm-generic/iomap.h>
> -
>  #ifdef CONFIG_ATARI
>  #define atari_readb   raw_inb
>  #define atari_writeb  raw_outb
> diff --git a/arch/m68k/include/asm/kmap.h b/arch/m68k/include/asm/kmap.h
> index dec05743d426..4efb3efa593a 100644
> --- a/arch/m68k/include/asm/kmap.h
> +++ b/arch/m68k/include/asm/kmap.h
> @@ -4,8 +4,6 @@
>  
>  #ifdef CONFIG_MMU
>  
> -#define ARCH_HAS_IOREMAP_WT
> -
>  /* Values for nocacheflag and cmode */
>  #define IOMAP_FULL_CACHING		0
>  #define IOMAP_NOCACHE_SER		1
> diff --git a/arch/mips/include/asm/io.h b/arch/mips/include/asm/io.h
> index cc28d207a061..477773328a06 100644
> --- a/arch/mips/include/asm/io.h
> +++ b/arch/mips/include/asm/io.h
> @@ -12,8 +12,6 @@
>  #ifndef _ASM_IO_H
>  #define _ASM_IO_H
>  
> -#define ARCH_HAS_IOREMAP_WC
> -
>  #include <linux/compiler.h>
>  #include <linux/kernel.h>
>  #include <linux/types.h>
> @@ -25,7 +23,6 @@
>  #include <asm/byteorder.h>
>  #include <asm/cpu.h>
>  #include <asm/cpu-features.h>
> -#include <asm-generic/iomap.h>
>  #include <asm/page.h>
>  #include <asm/pgtable-bits.h>
>  #include <asm/processor.h>
> @@ -210,6 +207,8 @@ void iounmap(const volatile void __iomem *addr);
>  #define ioremap_wc(offset, size)					\
>  	ioremap_prot((offset), (size), boot_cpu_data.writecombine)
>  
> +#include <asm-generic/iomap.h>
> +
>  #if defined(CONFIG_CPU_CAVIUM_OCTEON)
>  #define war_io_reorder_wmb()		wmb()
>  #else
> diff --git a/arch/powerpc/include/asm/io.h b/arch/powerpc/include/asm/io.h
> index f1e657c9bbe8..67a3fb6de498 100644
> --- a/arch/powerpc/include/asm/io.h
> +++ b/arch/powerpc/include/asm/io.h
> @@ -3,11 +3,6 @@
>  #define _ASM_POWERPC_IO_H
>  #ifdef __KERNEL__
>  
> -#define ARCH_HAS_IOREMAP_WC
> -#ifdef CONFIG_PPC32
> -#define ARCH_HAS_IOREMAP_WT
> -#endif
> -
>  /*
>   */
>  
> @@ -732,9 +727,7 @@ static inline void name at					\
>  #define writel_relaxed(v, addr)	writel(v, addr)
>  #define writeq_relaxed(v, addr)	writeq(v, addr)
>  
> -#ifdef CONFIG_GENERIC_IOMAP
> -#include <asm-generic/iomap.h>
> -#else
> +#ifndef CONFIG_GENERIC_IOMAP
>  /*
>   * Here comes the implementation of the IOMAP interfaces.
>   */
> diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
> index e9025640f634..76238842406a 100644
> --- a/arch/x86/include/asm/io.h
> +++ b/arch/x86/include/asm/io.h
> @@ -35,9 +35,6 @@
>    *  - Arnaldo Carvalho de Melo <acme@conectiva.com.br>
>    */
>  
> -#define ARCH_HAS_IOREMAP_WC
> -#define ARCH_HAS_IOREMAP_WT
> -
>  #include <linux/string.h>
>  #include <linux/compiler.h>
>  #include <linux/cc_platform.h>
> @@ -212,8 +209,6 @@ void memset_io(volatile void __iomem *, int, size_t);
>  #define memcpy_toio memcpy_toio
>  #define memset_io memset_io
>  
> -#include <asm-generic/iomap.h>
> -
>  /*
>   * ISA space is 'always mapped' on a typical x86 system, no need to
>   * explicitly ioremap() it. The fact that the ISA IO space is mapped
> diff --git a/drivers/net/ethernet/sfc/io.h b/drivers/net/ethernet/sfc/io.h
> index 30439cc83a89..07f99ad14bf3 100644
> --- a/drivers/net/ethernet/sfc/io.h
> +++ b/drivers/net/ethernet/sfc/io.h
> @@ -70,7 +70,7 @@
>   */
>  #ifdef CONFIG_X86_64
>  /* PIO is a win only if write-combining is possible */
> -#ifdef ARCH_HAS_IOREMAP_WC
> +#ifdef ioremap_wc
>  #define EFX_USE_PIO 1
>  #endif
>  #endif
> diff --git a/drivers/net/ethernet/sfc/siena/io.h b/drivers/net/ethernet/sfc/siena/io.h
> index 30439cc83a89..07f99ad14bf3 100644
> --- a/drivers/net/ethernet/sfc/siena/io.h
> +++ b/drivers/net/ethernet/sfc/siena/io.h
> @@ -70,7 +70,7 @@
>   */
>  #ifdef CONFIG_X86_64
>  /* PIO is a win only if write-combining is possible */
> -#ifdef ARCH_HAS_IOREMAP_WC
> +#ifdef ioremap_wc
>  #define EFX_USE_PIO 1
>  #endif
>  #endif
> diff --git a/include/asm-generic/iomap.h b/include/asm-generic/iomap.h
> index 08237ae8b840..196087a8126e 100644
> --- a/include/asm-generic/iomap.h
> +++ b/include/asm-generic/iomap.h
> @@ -93,15 +93,15 @@ extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
>  extern void ioport_unmap(void __iomem *);
>  #endif
>  
> -#ifndef ARCH_HAS_IOREMAP_WC
> +#ifndef ioremap_wc
>  #define ioremap_wc ioremap
>  #endif
>  
> -#ifndef ARCH_HAS_IOREMAP_WT
> +#ifndef ioremap_wt
>  #define ioremap_wt ioremap
>  #endif
>  
> -#ifndef ARCH_HAS_IOREMAP_NP
> +#ifndef ioremap_np
>  /* See the comment in asm-generic/io.h about ioremap_np(). */
>  #define ioremap_np ioremap_np
>  static inline void __iomem *ioremap_np(phys_addr_t offset, size_t size)
> -- 
> 2.34.1
> 
> 

-- 
Sincerely yours,
Mike.

