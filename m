Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F691B0B64
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 14:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbgDTMp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 08:45:27 -0400
Received: from foss.arm.com ([217.140.110.172]:47918 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728732AbgDTMpZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 08:45:25 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6C5011FB;
        Mon, 20 Apr 2020 05:45:24 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.30.55])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1C8243F237;
        Mon, 20 Apr 2020 05:45:20 -0700 (PDT)
Date:   Mon, 20 Apr 2020 13:45:18 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Alex Belits <abelits@marvell.com>
Cc:     "mingo@kernel.org" <mingo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "frederic@kernel.org" <frederic@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "will@kernel.org" <will@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [EXT] Re: [PATCH v3 03/13] task_isolation: add instruction
 synchronization memory barrier
Message-ID: <20200420124518.GC69441@C02TD0UTHF1T.local>
References: <4473787e1b6bc3cc226067e8d122092a678b63de.camel@marvell.com>
 <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
 <07c25c246c55012981ec0296eee23e68c719333a.camel@marvell.com>
 <d995795c731d6ecceb36bdf1c1df3d72fefd023d.camel@marvell.com>
 <20200415124427.GB28304@C02TD0UTHF1T.local>
 <e4d2cda6f011e80a0d8e482b85bca1c57665fcfd.camel@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4d2cda6f011e80a0d8e482b85bca1c57665fcfd.camel@marvell.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 19, 2020 at 05:02:01AM +0000, Alex Belits wrote:
> 
> On Wed, 2020-04-15 at 13:44 +0100, Mark Rutland wrote:
> > External Email
> > 
> > -------------------------------------------------------------------
> > ---
> > On Thu, Apr 09, 2020 at 03:17:40PM +0000, Alex Belits wrote:
> > > Some architectures implement memory synchronization instructions
> > > for
> > > instruction cache. Make a separate kind of barrier that calls them.
> > 
> > Modifying the instruction caches requries more than an ISB, and the
> > 'IMB' naming implies you're trying to order against memory accesses,
> > which isn't what ISB (generally) does.
> > 
> > What exactly do you want to use this for?
> 
> I guess, there should be different explanation and naming.
> 
> The intention is to have a separate barrier that causes cache
> synchronization event, for use in architecture-independent code. I am
> not sure, what exactly it should do to be implemented in architecture-
> independent manner, so it probably only makes sense along with a
> regular memory barrier.
> 
> The particular place where I had to use is the code that has to run
> after isolated task returns to the kernel. In the model that I propose
> for task isolation, remote context synchronization is skipped while
> task is in isolated in userspace (it doesn't run kernel, and kernel
> does not modify its userspace code, so it's harmless until entering the
> kernel). So it will skip the results of kick_all_cpus_sync() that was
> that was called from flush_icache_range() and other similar places.
> This means that once it's out of userspace, it should only run
> some "safe" kernel entry code, and then synchronize in some manner that
> avoids race conditions with possible IPIs intended for context
> synchronization that may happen at the same time. My next patch in the
> series uses it in that one place.
> 
> Synchronization will have to be implemented without a mandatory
> interrupt because it may be triggered locally, on the same CPU. On ARM,
> ISB is definitely necessary there, however I am not sure, how this
> should look like on x86 and other architectures. On ARM this probably
> still should be combined with a real memory barrier and cache
> synchronization, however I am not entirely sure about details. Would
> it make more sense to run DMB, IC and ISB? 

For the cases you mention above this really depends on how the new CPU
first synchronizes with the others, and what the scope of the "safe"
kernel entry code is.

Given that this is context-dependent, I think it would make more sense
for this to be an arch hook specific to task isolation rather than a
low-level common barrier.

Thanks,
Mark.

> 
> > 
> As-is, I don't think this makes sense as a generic barrier.
> 
> Thanks,
> Mark.
> 
> Signed-off-by: Alex Belits <abelits@marvell.com>
> ---
>  arch/arm/include/asm/barrier.h   | 2 ++
>  arch/arm64/include/asm/barrier.h | 2 ++
>  include/asm-generic/barrier.h    | 4 ++++
>  3 files changed, 8 insertions(+)
> 
> diff --git a/arch/arm/include/asm/barrier.h
> b/arch/arm/include/asm/barrier.h
> index 83ae97c049d9..6def62c95937 100644
> --- a/arch/arm/include/asm/barrier.h
> +++ b/arch/arm/include/asm/barrier.h
> @@ -64,12 +64,14 @@ extern void arm_heavy_mb(void);
>  #define mb()		__arm_heavy_mb()
>  #define rmb()		dsb()
>  #define wmb()		__arm_heavy_mb(st)
> +#define imb()		isb()
>  #define dma_rmb()	dmb(osh)
>  #define dma_wmb()	dmb(oshst)
>  #else
>  #define mb()		barrier()
>  #define rmb()		barrier()
>  #define wmb()		barrier()
> +#define imb()		barrier()
>  #define dma_rmb()	barrier()
>  #define dma_wmb()	barrier()
>  #endif
> diff --git a/arch/arm64/include/asm/barrier.h
> b/arch/arm64/include/asm/barrier.h
> index 7d9cc5ec4971..12a7dbd68bed 100644
> --- a/arch/arm64/include/asm/barrier.h
> +++ b/arch/arm64/include/asm/barrier.h
> @@ -45,6 +45,8 @@
>  #define rmb()		dsb(ld)
>  #define wmb()		dsb(st)
>  
> +#define imb()		isb()
> +
>  #define dma_rmb()	dmb(oshld)
>  #define dma_wmb()	dmb(oshst)
>  
> diff --git a/include/asm-generic/barrier.h b/include/asm-
> generic/barrier.h
> index 85b28eb80b11..d5a822fb3e92 100644
> --- a/include/asm-generic/barrier.h
> +++ b/include/asm-generic/barrier.h
> @@ -46,6 +46,10 @@
>  #define dma_wmb()	wmb()
>  #endif
>  
> +#ifndef imb
> +#define imb		barrier()
> +#endif
> +
>  #ifndef read_barrier_depends
>  #define read_barrier_depends()		do { } while (0)
>  #endif
> -- 
> 2.20.1
> 
> 
> 
> 
