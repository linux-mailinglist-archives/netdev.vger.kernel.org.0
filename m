Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3430BA1463
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 11:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfH2JJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 05:09:20 -0400
Received: from foss.arm.com ([217.140.110.172]:40998 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbfH2JJU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 05:09:20 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8E89628;
        Thu, 29 Aug 2019 02:09:19 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C799D3F246;
        Thu, 29 Aug 2019 02:09:14 -0700 (PDT)
Subject: Re: [RFC PATCH 2/3] reorganize ptp_kvm modules to make it
 arch-independent.
To:     Jianyong Wu <jianyong.wu@arm.com>, netdev@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        richardcochran@gmail.com, Mark.Rutland@arm.com,
        Will.Deacon@arm.com, suzuki.poulose@arm.com
Cc:     linux-kernel@vger.kernel.org, Steve.Capper@arm.com,
        Kaly.Xin@arm.com, justin.he@arm.com
References: <20190829063952.18470-1-jianyong.wu@arm.com>
 <20190829063952.18470-3-jianyong.wu@arm.com>
From:   Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <4c6038f5-1da4-0b43-d8b7-541379321bf1@kernel.org>
Date:   Thu, 29 Aug 2019 10:09:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190829063952.18470-3-jianyong.wu@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/08/2019 07:39, Jianyong Wu wrote:
> Currently, ptp_kvm modules implementation is only for x86 which includs
> large part of arch-specific code.  This patch move all of those code
> into related arch directory.
> 
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> ---
>  arch/x86/kvm/arch_ptp_kvm.c          | 92 ++++++++++++++++++++++++++++
>  drivers/ptp/Makefile                 |  1 +
>  drivers/ptp/{ptp_kvm.c => kvm_ptp.c} | 77 ++++++-----------------
>  include/asm-generic/ptp_kvm.h        | 12 ++++
>  4 files changed, 123 insertions(+), 59 deletions(-)
>  create mode 100644 arch/x86/kvm/arch_ptp_kvm.c
>  rename drivers/ptp/{ptp_kvm.c => kvm_ptp.c} (63%)
>  create mode 100644 include/asm-generic/ptp_kvm.h
> 
> diff --git a/arch/x86/kvm/arch_ptp_kvm.c b/arch/x86/kvm/arch_ptp_kvm.c
> new file mode 100644
> index 000000000000..56ea84a86da2
> --- /dev/null
> +++ b/arch/x86/kvm/arch_ptp_kvm.c
> @@ -0,0 +1,92 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + *  Virtual PTP 1588 clock for use with KVM guests
> + *
> + *  Copyright (C) 2019 ARM Ltd.
> + *  All Rights Reserved

No. This isn't ARM's code, not by a million mile. You've simply
refactored existing code. Please keep the correct attribution (i.e. that
of the original code).

> + */
> +
> +#include <asm/pvclock.h>
> +#include <asm/kvmclock.h>
> +#include <linux/module.h>
> +#include <uapi/asm/kvm_para.h>
> +#include <uapi/linux/kvm_para.h>
> +#include <linux/ptp_clock_kernel.h>
> +
> +phys_addr_t clock_pair_gpa;
> +struct kvm_clock_pairing clock_pair;
> +struct pvclock_vsyscall_time_info *hv_clock;
> +
> +int kvm_arch_ptp_init(void)
> +{
> +	int ret;
> +
> +	if (!kvm_para_available())
> +		return -ENODEV;
> +
> +	clock_pair_gpa = slow_virt_to_phys(&clock_pair);
> +	hv_clock = pvclock_get_pvti_cpu0_va();
> +	if (!hv_clock)
> +		return -ENODEV;
> +
> +	ret = kvm_hypercall2(KVM_HC_CLOCK_PAIRING, clock_pair_gpa,
> +			     KVM_CLOCK_PAIRING_WALLCLOCK);
> +	if (ret == -KVM_ENOSYS || ret == -KVM_EOPNOTSUPP)
> +		return -ENODEV;
> +
> +	return 0;
> +}
> +
> +int kvm_arch_ptp_get_clock(struct timespec64 *ts)
> +{
> +	long ret;
> +
> +	ret = kvm_hypercall2(KVM_HC_CLOCK_PAIRING,
> +			     clock_pair_gpa,
> +			     KVM_CLOCK_PAIRING_WALLCLOCK);
> +	if (ret != 0)
> +		return -EOPNOTSUPP;
> +
> +	ts->tv_sec = clock_pair.sec;
> +	ts->tv_nsec = clock_pair.nsec;
> +
> +	return 0;
> +}
> +
> +int kvm_arch_ptp_get_clock_fn(long *cycle, struct timespec64 *tspec,
> +			      struct clocksource **cs)
> +{
> +	unsigned long ret;
> +	unsigned int version;
> +	int cpu;
> +	struct pvclock_vcpu_time_info *src;
> +
> +	cpu = smp_processor_id();
> +	src = &hv_clock[cpu].pvti;
> +
> +	do {
> +		/*
> +		 * We are using a TSC value read in the hosts
> +		 * kvm_hc_clock_pairing handling.
> +		 * So any changes to tsc_to_system_mul
> +		 * and tsc_shift or any other pvclock
> +		 * data invalidate that measurement.
> +		 */
> +		version = pvclock_read_begin(src);
> +
> +		ret = kvm_hypercall2(KVM_HC_CLOCK_PAIRING,
> +				     clock_pair_gpa,
> +				     KVM_CLOCK_PAIRING_WALLCLOCK);
> +		tspec->tv_sec = clock_pair.sec;
> +		tspec->tv_nsec = clock_pair.nsec;
> +		*cycle = __pvclock_read_cycles(src, clock_pair.tsc);
> +	} while (pvclock_read_retry(src, version));
> +
> +	*cs = &kvm_clock;
> +
> +	return 0;
> +}
> +
> +MODULE_AUTHOR("Marcelo Tosatti <mtosatti@redhat.com>");
> +MODULE_DESCRIPTION("PTP clock using KVMCLOCK");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/ptp/Makefile b/drivers/ptp/Makefile
> index 677d1d178a3e..5a8c6462fc0f 100644
> --- a/drivers/ptp/Makefile
> +++ b/drivers/ptp/Makefile
> @@ -4,6 +4,7 @@
>  #
>  
>  ptp-y					:= ptp_clock.o ptp_chardev.o ptp_sysfs.o
> +ptp_kvm-y				:= ../../arch/$(ARCH)/kvm/arch_ptp_kvm.o kvm_ptp.o
>  obj-$(CONFIG_PTP_1588_CLOCK)		+= ptp.o
>  obj-$(CONFIG_PTP_1588_CLOCK_DTE)	+= ptp_dte.o
>  obj-$(CONFIG_PTP_1588_CLOCK_IXP46X)	+= ptp_ixp46x.o
> diff --git a/drivers/ptp/ptp_kvm.c b/drivers/ptp/kvm_ptp.c
> similarity index 63%
> rename from drivers/ptp/ptp_kvm.c
> rename to drivers/ptp/kvm_ptp.c
> index fc7d0b77e118..9d07cf872be7 100644
> --- a/drivers/ptp/ptp_kvm.c
> +++ b/drivers/ptp/kvm_ptp.c
> @@ -8,12 +8,12 @@
>  #include <linux/err.h>
>  #include <linux/init.h>
>  #include <linux/kernel.h>
> +#include <linux/slab.h>
>  #include <linux/module.h>
>  #include <uapi/linux/kvm_para.h>
>  #include <asm/kvm_para.h>
> -#include <asm/pvclock.h>
> -#include <asm/kvmclock.h>
>  #include <uapi/asm/kvm_para.h>
> +#include <asm-generic/ptp_kvm.h>
>  
>  #include <linux/ptp_clock_kernel.h>
>  
> @@ -24,56 +24,29 @@ struct kvm_ptp_clock {
>  
>  DEFINE_SPINLOCK(kvm_ptp_lock);
>  
> -static struct pvclock_vsyscall_time_info *hv_clock;
> -
> -static struct kvm_clock_pairing clock_pair;
> -static phys_addr_t clock_pair_gpa;
> -
>  static int ptp_kvm_get_time_fn(ktime_t *device_time,
>  			       struct system_counterval_t *system_counter,
>  			       void *ctx)
>  {
> -	unsigned long ret;
> +	unsigned long ret, cycle;
>  	struct timespec64 tspec;
> -	unsigned version;
> -	int cpu;
> -	struct pvclock_vcpu_time_info *src;
> +	struct clocksource *cs;
>  
>  	spin_lock(&kvm_ptp_lock);
>  
>  	preempt_disable_notrace();
> -	cpu = smp_processor_id();
> -	src = &hv_clock[cpu].pvti;
> -
> -	do {
> -		/*
> -		 * We are using a TSC value read in the hosts
> -		 * kvm_hc_clock_pairing handling.
> -		 * So any changes to tsc_to_system_mul
> -		 * and tsc_shift or any other pvclock
> -		 * data invalidate that measurement.
> -		 */
> -		version = pvclock_read_begin(src);
> -
> -		ret = kvm_hypercall2(KVM_HC_CLOCK_PAIRING,
> -				     clock_pair_gpa,
> -				     KVM_CLOCK_PAIRING_WALLCLOCK);
> -		if (ret != 0) {
> -			pr_err_ratelimited("clock pairing hypercall ret %lu\n", ret);
> -			spin_unlock(&kvm_ptp_lock);
> -			preempt_enable_notrace();
> -			return -EOPNOTSUPP;
> -		}
> -
> -		tspec.tv_sec = clock_pair.sec;
> -		tspec.tv_nsec = clock_pair.nsec;
> -		ret = __pvclock_read_cycles(src, clock_pair.tsc);
> -	} while (pvclock_read_retry(src, version));
> +	ret = kvm_arch_ptp_get_clock_fn(&cycle, &tspec, &cs);
> +	if (ret != 0) {
> +		pr_err_ratelimited("clock pairing hypercall ret %lu\n", ret);
> +		spin_unlock(&kvm_ptp_lock);
> +		preempt_enable_notrace();
> +		return -EOPNOTSUPP;
> +	}
>  
>  	preempt_enable_notrace();
>  
> -	system_counter->cycles = ret;
> -	system_counter->cs = &kvm_clock;
> +	system_counter->cycles = cycle;
> +	system_counter->cs = cs;
>  
>  	*device_time = timespec64_to_ktime(tspec);
>  
> @@ -116,17 +89,13 @@ static int ptp_kvm_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
>  
>  	spin_lock(&kvm_ptp_lock);
>  
> -	ret = kvm_hypercall2(KVM_HC_CLOCK_PAIRING,
> -			     clock_pair_gpa,
> -			     KVM_CLOCK_PAIRING_WALLCLOCK);
> +	ret = kvm_arch_ptp_get_clock(&tspec);
>  	if (ret != 0) {
>  		pr_err_ratelimited("clock offset hypercall ret %lu\n", ret);
>  		spin_unlock(&kvm_ptp_lock);
>  		return -EOPNOTSUPP;
>  	}
>  
> -	tspec.tv_sec = clock_pair.sec;
> -	tspec.tv_nsec = clock_pair.nsec;
>  	spin_unlock(&kvm_ptp_lock);
>  
>  	memcpy(ts, &tspec, sizeof(struct timespec64));
> @@ -166,21 +135,11 @@ static void __exit ptp_kvm_exit(void)
>  
>  static int __init ptp_kvm_init(void)
>  {
> -	long ret;
> -
> -	if (!kvm_para_available())
> -		return -ENODEV;
> -
> -	clock_pair_gpa = slow_virt_to_phys(&clock_pair);
> -	hv_clock = pvclock_get_pvti_cpu0_va();
> -
> -	if (!hv_clock)
> -		return -ENODEV;
> +	int ret;
>  
> -	ret = kvm_hypercall2(KVM_HC_CLOCK_PAIRING, clock_pair_gpa,
> -			KVM_CLOCK_PAIRING_WALLCLOCK);
> -	if (ret == -KVM_ENOSYS || ret == -KVM_EOPNOTSUPP)
> -		return -ENODEV;
> +	ret = kvm_arch_ptp_init();
> +	if (IS_ERR(ret))
> +		return ret;
>  
>  	kvm_ptp_clock.caps = ptp_kvm_caps;
>  
> diff --git a/include/asm-generic/ptp_kvm.h b/include/asm-generic/ptp_kvm.h
> new file mode 100644
> index 000000000000..128a9d7af161
> --- /dev/null
> +++ b/include/asm-generic/ptp_kvm.h
> @@ -0,0 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + *  Virtual PTP 1588 clock for use with KVM guests
> + *
> + *  Copyright (C) 2019 ARM Ltd.
> + *  All Rights Reserved

Same here.

> + */
> +
> +static int kvm_arch_ptp_init(void);
> +static int kvm_arch_ptp_get_clock(struct timespec64 *ts);
> +static int kvm_arch_ptp_get_clock_fn(long *cycle,
> +		struct timespec64 *tspec, void *cs);
> 

	M.
-- 
Jazz is not dead, it just smells funny...
