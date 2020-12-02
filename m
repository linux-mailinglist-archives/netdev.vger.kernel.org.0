Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1CF2CBF6A
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 15:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbgLBOTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 09:19:15 -0500
Received: from foss.arm.com ([217.140.110.172]:41346 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727245AbgLBOTP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 09:19:15 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 279A430E;
        Wed,  2 Dec 2020 06:18:29 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.23.201])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9FE403F718;
        Wed,  2 Dec 2020 06:18:24 -0800 (PST)
Date:   Wed, 2 Dec 2020 14:18:21 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Alex Belits <abelits@marvell.com>
Cc:     "nitesh@redhat.com" <nitesh@redhat.com>,
        "frederic@kernel.org" <frederic@kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "trix@redhat.com" <trix@redhat.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "will@kernel.org" <will@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "leon@sidebranch.com" <leon@sidebranch.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "pauld@redhat.com" <pauld@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 5/9] task_isolation: Add driver-specific hooks
Message-ID: <20201202141821.GC66958@C02TD0UTHF1T.local>
References: <8d887e59ca713726f4fcb25a316e1e932b02823e.camel@marvell.com>
 <6e15fde56203f89ebab0565dc22177f42063ae7c.camel@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e15fde56203f89ebab0565dc22177f42063ae7c.camel@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 05:57:42PM +0000, Alex Belits wrote:
> Some drivers don't call functions that call
> task_isolation_kernel_enter() in interrupt handlers. Call it
> directly.

I don't think putting this in drivers is the right approach. IIUC we
only need to track user<->kernel transitions, and we can do that within
the architectural entry code before we ever reach irqchip code. I
suspect the current approacch is an artifact of that being difficult in
the old structure of the arch code; recent rework should address that,
and we can restruecture things further in future.

Thanks,
Mark.

> Signed-off-by: Alex Belits <abelits@marvell.com>
> ---
>  drivers/irqchip/irq-armada-370-xp.c | 6 ++++++
>  drivers/irqchip/irq-gic-v3.c        | 3 +++
>  drivers/irqchip/irq-gic.c           | 3 +++
>  drivers/s390/cio/cio.c              | 3 +++
>  4 files changed, 15 insertions(+)
> 
> diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
> index d7eb2e93db8f..4ac7babe1abe 100644
> --- a/drivers/irqchip/irq-armada-370-xp.c
> +++ b/drivers/irqchip/irq-armada-370-xp.c
> @@ -29,6 +29,7 @@
>  #include <linux/slab.h>
>  #include <linux/syscore_ops.h>
>  #include <linux/msi.h>
> +#include <linux/isolation.h>
>  #include <asm/mach/arch.h>
>  #include <asm/exception.h>
>  #include <asm/smp_plat.h>
> @@ -572,6 +573,7 @@ static const struct irq_domain_ops armada_370_xp_mpic_irq_ops = {
>  static void armada_370_xp_handle_msi_irq(struct pt_regs *regs, bool is_chained)
>  {
>  	u32 msimask, msinr;
> +	int isol_entered = 0;
>  
>  	msimask = readl_relaxed(per_cpu_int_base +
>  				ARMADA_370_XP_IN_DRBEL_CAUSE_OFFS)
> @@ -588,6 +590,10 @@ static void armada_370_xp_handle_msi_irq(struct pt_regs *regs, bool is_chained)
>  			continue;
>  
>  		if (is_chained) {
> +			if (!isol_entered) {
> +				task_isolation_kernel_enter();
> +				isol_entered = 1;
> +			}
>  			irq = irq_find_mapping(armada_370_xp_msi_inner_domain,
>  					       msinr - PCI_MSI_DOORBELL_START);
>  			generic_handle_irq(irq);
> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
> index 16fecc0febe8..ded26dd4da0f 100644
> --- a/drivers/irqchip/irq-gic-v3.c
> +++ b/drivers/irqchip/irq-gic-v3.c
> @@ -18,6 +18,7 @@
>  #include <linux/percpu.h>
>  #include <linux/refcount.h>
>  #include <linux/slab.h>
> +#include <linux/isolation.h>
>  
>  #include <linux/irqchip.h>
>  #include <linux/irqchip/arm-gic-common.h>
> @@ -646,6 +647,8 @@ static asmlinkage void __exception_irq_entry gic_handle_irq(struct pt_regs *regs
>  {
>  	u32 irqnr;
>  
> +	task_isolation_kernel_enter();
> +
>  	irqnr = gic_read_iar();
>  
>  	if (gic_supports_nmi() &&
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index 6053245a4754..bb482b4ae218 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -35,6 +35,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/percpu.h>
>  #include <linux/slab.h>
> +#include <linux/isolation.h>
>  #include <linux/irqchip.h>
>  #include <linux/irqchip/chained_irq.h>
>  #include <linux/irqchip/arm-gic.h>
> @@ -337,6 +338,8 @@ static void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
>  	struct gic_chip_data *gic = &gic_data[0];
>  	void __iomem *cpu_base = gic_data_cpu_base(gic);
>  
> +	task_isolation_kernel_enter();
> +
>  	do {
>  		irqstat = readl_relaxed(cpu_base + GIC_CPU_INTACK);
>  		irqnr = irqstat & GICC_IAR_INT_ID_MASK;
> diff --git a/drivers/s390/cio/cio.c b/drivers/s390/cio/cio.c
> index 6d716db2a46a..beab88881b6d 100644
> --- a/drivers/s390/cio/cio.c
> +++ b/drivers/s390/cio/cio.c
> @@ -20,6 +20,7 @@
>  #include <linux/kernel_stat.h>
>  #include <linux/interrupt.h>
>  #include <linux/irq.h>
> +#include <linux/isolation.h>
>  #include <asm/cio.h>
>  #include <asm/delay.h>
>  #include <asm/irq.h>
> @@ -584,6 +585,8 @@ void cio_tsch(struct subchannel *sch)
>  	struct irb *irb;
>  	int irq_context;
>  
> +	task_isolation_kernel_enter();
> +
>  	irb = this_cpu_ptr(&cio_irb);
>  	/* Store interrupt response block to lowcore. */
>  	if (tsch(sch->schid, irb) != 0)
> -- 
> 2.20.1
> 
