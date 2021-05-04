Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F863729EC
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 14:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbhEDMQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 08:16:27 -0400
Received: from foss.arm.com ([217.140.110.172]:57392 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230253AbhEDMQZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 08:16:25 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B1595ED1;
        Tue,  4 May 2021 05:15:30 -0700 (PDT)
Received: from [10.57.59.124] (unknown [10.57.59.124])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EE4C13F73B;
        Tue,  4 May 2021 05:15:26 -0700 (PDT)
Subject: Re: [PATCH tip:irq/core v1] genirq: remove auto-set of the mask when
 setting the hint
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, jbrandeb@kernel.org,
        "frederic@kernel.org" <frederic@kernel.org>,
        "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, abelits@marvell.com,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "rppt@linux.vnet.ibm.com" <rppt@linux.vnet.ibm.com>,
        "jinyuqi@huawei.com" <jinyuqi@huawei.com>,
        "zhangshaokun@hisilicon.com" <zhangshaokun@hisilicon.com>,
        netdev@vger.kernel.org, chris.friesen@windriver.com,
        Nitesh Lal <nilal@redhat.com>, Marc Zyngier <maz@kernel.org>
References: <20210501021832.743094-1-jesse.brandeburg@intel.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <16d8ca67-30c6-bb4b-8946-79de8629156e@arm.com>
Date:   Tue, 4 May 2021 13:15:22 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210501021832.743094-1-jesse.brandeburg@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-05-01 03:18, Jesse Brandeburg wrote:
> It was pointed out by Nitesh that the original work I did in 2014
> to automatically set the interrupt affinity when requesting a
> mask is no longer necessary. The kernel has moved on and no
> longer has the original problem, BUT the original patch
> introduced a subtle bug when booting a system with reserved or
> excluded CPUs. Drivers calling this function with a mask value
> that included a CPU that was currently or in the future
> unavailable would generally not update the hint.
> 
> I'm sure there are a million ways to solve this, but the simplest
> one is to just remove a little code that tries to force the
> affinity, as Nitesh has shown it fixes the bug and doesn't seem
> to introduce immediate side effects.

Unfortunately, I think there are quite a few other drivers now relying 
on this behaviour, since they are really using irq_set_affinity_hint() 
as a proxy for irq_set_affinity(). Partly since the latter isn't 
exported to modules, but also I have a vague memory of it being said 
that it's nice to update the user-visible hint to match when the 
affinity does have to be forced to something specific.

Robin.

> While I'm here, introduce a kernel-doc for the hint function.
> 
> Ref: https://lore.kernel.org/lkml/CAFki+L=_dd+JgAR12_eBPX0kZO2_6=1dGdgkwHE=u=K6chMeLQ@mail.gmail.com/
> Cc: netdev@vger.kernel.org
> Fixes: 4fe7ffb7e17c ("genirq: Fix null pointer reference in irq_set_affinity_hint()")
> Fixes: e2e64a932556 ("genirq: Set initial affinity in irq_set_affinity_hint()")
> Reported-by: Nitesh Lal <nilal@redhat.com>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
> 
> !!! NOTE: Compile tested only, would appreciate feedback
> 
> ---
>   kernel/irq/manage.c | 13 ++++++++++---
>   1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index e976c4927b25..a31df64662d5 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -456,6 +456,16 @@ int __irq_set_affinity(unsigned int irq, const struct cpumask *mask, bool force)
>   	return ret;
>   }
>   
> +/**
> + * 	irq_set_affinity_hint - set the hint for an irq
> + *	@irq:	Interrupt for which to set the hint
> + *	@m:	Mask to indicate which CPUs to suggest for the interrupt, use
> + *		NULL here to indicate to clear the value.
> + *
> + *	Use this function to recommend which CPU should handle the
> + *	interrupt to any userspace that uses /proc/irq/nn/smp_affinity_hint
> + *	in order to align interrupts. Pass NULL as the mask to clear the hint.
> + */
>   int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
>   {
>   	unsigned long flags;
> @@ -465,9 +475,6 @@ int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
>   		return -EINVAL;
>   	desc->affinity_hint = m;
>   	irq_put_desc_unlock(desc, flags);
> -	/* set the initial affinity to prevent every interrupt being on CPU0 */
> -	if (m)
> -		__irq_set_affinity(irq, m, false);
>   	return 0;
>   }
>   EXPORT_SYMBOL_GPL(irq_set_affinity_hint);
> 
> base-commit: 765822e1569a37aab5e69736c52d4ad4a289eba6
> 
