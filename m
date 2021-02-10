Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 262C7316B0A
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 17:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbhBJQVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 11:21:14 -0500
Received: from foss.arm.com ([217.140.110.172]:40226 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230005AbhBJQVK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 11:21:10 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9DDD8113E;
        Wed, 10 Feb 2021 08:20:24 -0800 (PST)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ECAD83F73B;
        Wed, 10 Feb 2021 08:20:20 -0800 (PST)
Date:   Wed, 10 Feb 2021 16:19:20 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com, seanjc@google.com,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com, steven.price@arm.com,
        lorenzo.pieralisi@arm.com, sudeep.holla@arm.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, justin.he@arm.com, jianyong.wu@arm.com,
        kernel-team@android.com
Subject: Re: [PATCH v18 3/7] ptp: Reorganize ptp_kvm.c to make it
 arch-independent
Message-ID: <20210210161920.7815d1e5@slackpad.fritz.box>
In-Reply-To: <20210208134029.3269384-4-maz@kernel.org>
References: <20210208134029.3269384-1-maz@kernel.org>
        <20210208134029.3269384-4-maz@kernel.org>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  8 Feb 2021 13:40:25 +0000
Marc Zyngier <maz@kernel.org> wrote:

> From: Jianyong Wu <jianyong.wu@arm.com>
> 
> Currently, the ptp_kvm module contains a lot of x86-specific code.
> Let's move this code into a new arch-specific file in the same directory,
> and rename the arch-independent file to ptp_kvm_common.c.
> 
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20201209060932.212364-4-jianyong.wu@arm.com

Verified that the code movements are correct. Test compiled for x86.

1.5 nits below, but regardless:

Reviewed-by: Andre Przywara <andre.przywara@arm.com>


> ---
>  drivers/ptp/Makefile                        |  1 +
>  drivers/ptp/{ptp_kvm.c => ptp_kvm_common.c} | 84 +++++-------------
>  drivers/ptp/ptp_kvm_x86.c                   | 97 +++++++++++++++++++++
>  include/linux/ptp_kvm.h                     | 19 ++++
>  4 files changed, 139 insertions(+), 62 deletions(-)
>  rename drivers/ptp/{ptp_kvm.c => ptp_kvm_common.c} (60%)
>  create mode 100644 drivers/ptp/ptp_kvm_x86.c
>  create mode 100644 include/linux/ptp_kvm.h
> 
> diff --git a/drivers/ptp/Makefile b/drivers/ptp/Makefile
> index db5aef3bddc6..d11eeb5811d1 100644
> --- a/drivers/ptp/Makefile
> +++ b/drivers/ptp/Makefile
> @@ -4,6 +4,7 @@
>  #
>  
>  ptp-y					:= ptp_clock.o ptp_chardev.o ptp_sysfs.o
> +ptp_kvm-$(CONFIG_X86)			:= ptp_kvm_x86.o ptp_kvm_common.o
>  obj-$(CONFIG_PTP_1588_CLOCK)		+= ptp.o
>  obj-$(CONFIG_PTP_1588_CLOCK_DTE)	+= ptp_dte.o
>  obj-$(CONFIG_PTP_1588_CLOCK_INES)	+= ptp_ines.o
> diff --git a/drivers/ptp/ptp_kvm.c b/drivers/ptp/ptp_kvm_common.c
> similarity index 60%
> rename from drivers/ptp/ptp_kvm.c
> rename to drivers/ptp/ptp_kvm_common.c
> index 658d33fc3195..721ddcede5e1 100644
> --- a/drivers/ptp/ptp_kvm.c
> +++ b/drivers/ptp/ptp_kvm_common.c
> @@ -8,11 +8,11 @@
>  #include <linux/err.h>
>  #include <linux/init.h>
>  #include <linux/kernel.h>
> +#include <linux/slab.h>
>  #include <linux/module.h>
> +#include <linux/ptp_kvm.h>
>  #include <uapi/linux/kvm_para.h>
>  #include <asm/kvm_para.h>
> -#include <asm/pvclock.h>
> -#include <asm/kvmclock.h>
>  #include <uapi/asm/kvm_para.h>
>  
>  #include <linux/ptp_clock_kernel.h>
> @@ -24,56 +24,29 @@ struct kvm_ptp_clock {
>  
>  static DEFINE_SPINLOCK(kvm_ptp_lock);
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
> +	long ret;
> +	u64 cycle;
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
> +	ret = kvm_arch_ptp_get_crosststamp(&cycle, &tspec, &cs);
> +	if (ret) {
> +		spin_unlock(&kvm_ptp_lock);
> +		preempt_enable_notrace();
> +		return ret;
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
> @@ -111,22 +84,17 @@ static int ptp_kvm_settime(struct ptp_clock_info *ptp,
>  
>  static int ptp_kvm_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
>  {
> -	unsigned long ret;
> +	long ret;
>  	struct timespec64 tspec;
>  
>  	spin_lock(&kvm_ptp_lock);
>  
> -	ret = kvm_hypercall2(KVM_HC_CLOCK_PAIRING,
> -			     clock_pair_gpa,
> -			     KVM_CLOCK_PAIRING_WALLCLOCK);
> -	if (ret != 0) {
> -		pr_err_ratelimited("clock offset hypercall ret %lu\n", ret);
> +	ret = kvm_arch_ptp_get_clock(&tspec);
> +	if (ret) {
>  		spin_unlock(&kvm_ptp_lock);
> -		return -EOPNOTSUPP;
> +		return ret;
>  	}
>  
> -	tspec.tv_sec = clock_pair.sec;
> -	tspec.tv_nsec = clock_pair.nsec;
>  	spin_unlock(&kvm_ptp_lock);
>  
>  	memcpy(ts, &tspec, sizeof(struct timespec64));
> @@ -168,19 +136,11 @@ static int __init ptp_kvm_init(void)
>  {
>  	long ret;
>  
> -	if (!kvm_para_available())
> -		return -ENODEV;
> -
> -	clock_pair_gpa = slow_virt_to_phys(&clock_pair);
> -	hv_clock = pvclock_get_pvti_cpu0_va();
> -
> -	if (!hv_clock)
> -		return -ENODEV;
> -
> -	ret = kvm_hypercall2(KVM_HC_CLOCK_PAIRING, clock_pair_gpa,
> -			KVM_CLOCK_PAIRING_WALLCLOCK);
> -	if (ret == -KVM_ENOSYS || ret == -KVM_EOPNOTSUPP)
> -		return -ENODEV;
> +	ret = kvm_arch_ptp_init();
> +	if (ret) {
> +		pr_err("fail to initialize ptp_kvm");
> +		return ret;
> +	}
>  
>  	kvm_ptp_clock.caps = ptp_kvm_caps;
>  
> diff --git a/drivers/ptp/ptp_kvm_x86.c b/drivers/ptp/ptp_kvm_x86.c
> new file mode 100644
> index 000000000000..82a6be9a7479
> --- /dev/null
> +++ b/drivers/ptp/ptp_kvm_x86.c
> @@ -0,0 +1,97 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Virtual PTP 1588 clock for use with KVM guests
> + *
> + * Copyright (C) 2017 Red Hat Inc.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/kernel.h>
> +#include <asm/pvclock.h>
> +#include <asm/kvmclock.h>
> +#include <linux/module.h>
> +#include <uapi/asm/kvm_para.h>
> +#include <uapi/linux/kvm_para.h>
> +#include <linux/ptp_clock_kernel.h>
> +#include <linux/ptp_kvm.h>
> +
> +struct pvclock_vsyscall_time_info *hv_clock;
> +
> +static phys_addr_t clock_pair_gpa;
> +static struct kvm_clock_pairing clock_pair;
> +
> +int kvm_arch_ptp_init(void)
> +{
> +	long ret;
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
> +	unsigned long ret;

Nit: The return value type of kvm_hypercall2 is signed, so you can use
just "long" here. The former code used unsigned because ret was re-used
again for another call. This is now gone.

> +
> +	ret = kvm_hypercall2(KVM_HC_CLOCK_PAIRING,
> +			     clock_pair_gpa,
> +			     KVM_CLOCK_PAIRING_WALLCLOCK);
> +	if (ret != 0) {
> +		pr_err_ratelimited("clock offset hypercall ret %lu\n", ret);
> +		return -EOPNOTSUPP;
> +	}
> +
> +	ts->tv_sec = clock_pair.sec;
> +	ts->tv_nsec = clock_pair.nsec;
> +
> +	return 0;
> +}
> +
> +int kvm_arch_ptp_get_crosststamp(u64 *cycle, struct timespec64 *tspec,
> +			      struct clocksource **cs)
> +{
> +	unsigned long ret;

Same here.

Cheers,
Andre

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
> +		if (ret != 0) {
> +			pr_err_ratelimited("clock pairing hypercall ret %lu\n", ret);
> +			return -EOPNOTSUPP;
> +		}
> +		tspec->tv_sec = clock_pair.sec;
> +		tspec->tv_nsec = clock_pair.nsec;
> +		*cycle = __pvclock_read_cycles(src, clock_pair.tsc);
> +	} while (pvclock_read_retry(src, version));
> +
> +	*cs = &kvm_clock;
> +
> +	return 0;
> +}
> diff --git a/include/linux/ptp_kvm.h b/include/linux/ptp_kvm.h
> new file mode 100644
> index 000000000000..f960a719f0d5
> --- /dev/null
> +++ b/include/linux/ptp_kvm.h
> @@ -0,0 +1,19 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Virtual PTP 1588 clock for use with KVM guests
> + *
> + * Copyright (C) 2017 Red Hat Inc.
> + */
> +
> +#ifndef _PTP_KVM_H_
> +#define _PTP_KVM_H_
> +
> +struct timespec64;
> +struct clocksource;
> +
> +int kvm_arch_ptp_init(void);
> +int kvm_arch_ptp_get_clock(struct timespec64 *ts);
> +int kvm_arch_ptp_get_crosststamp(u64 *cycle,
> +		struct timespec64 *tspec, struct clocksource **cs);
> +
> +#endif /* _PTP_KVM_H_ */

