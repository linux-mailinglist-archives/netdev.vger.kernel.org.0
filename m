Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB07A1600
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 12:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfH2Kcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 06:32:48 -0400
Received: from foss.arm.com ([217.140.110.172]:41998 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbfH2Kcr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 06:32:47 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D58B628;
        Thu, 29 Aug 2019 03:32:45 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1EAAC3F59C;
        Thu, 29 Aug 2019 03:32:44 -0700 (PDT)
Subject: Re: [RFC PATCH 3/3] Enable ptp_kvm for arm64
To:     Jianyong Wu <jianyong.wu@arm.com>, netdev@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        richardcochran@gmail.com, Mark.Rutland@arm.com,
        Will.Deacon@arm.com, suzuki.poulose@arm.com
Cc:     linux-kernel@vger.kernel.org, Steve.Capper@arm.com,
        Kaly.Xin@arm.com, justin.he@arm.com
References: <20190829063952.18470-1-jianyong.wu@arm.com>
 <20190829063952.18470-4-jianyong.wu@arm.com>
From:   Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <4d04867c-2188-9574-fbd1-2356c6b99b7d@kernel.org>
Date:   Thu, 29 Aug 2019 11:32:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190829063952.18470-4-jianyong.wu@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/08/2019 07:39, Jianyong Wu wrote:
> Currently in arm64 virtualization environment, there is no mechanism to
> keep time sync between guest and host. Time in guest will drift compared
> with host after boot up as they may both use third party time sources
> to correct their time respectively. The time deviation will be in order
> of milliseconds but some scenarios ask for higher time precision, like
> in cloud envirenment, we want all the VMs running in the host aquire the
> same level accuracy from host clock.
> 
> Use of kvm ptp clock, which choose the host clock source clock as a
> reference clock to sync time clock between guest and host has been adopted
> by x86 which makes the time sync order from milliseconds to nanoseconds.
> 
> This patch enable kvm ptp on arm64 and we get the similar clock drift as
> found with x86 with kvm ptp.
> 
> Test result comparison between with kvm ptp and without it in arm64 are
> as follows. This test derived from the result of command 'chronyc
> sources'. we should take more cure of the last sample column which shows
> the offset between the local clock and the source at the last measurement.
> 
> no kvm ptp in guest:
> MS Name/IP address   Stratum Poll Reach LastRx Last sample
> ========================================================================
> ^* dns1.synet.edu.cn      2   6   377    13  +1040us[+1581us] +/-   21ms
> ^* dns1.synet.edu.cn      2   6   377    21  +1040us[+1581us] +/-   21ms
> ^* dns1.synet.edu.cn      2   6   377    29  +1040us[+1581us] +/-   21ms
> ^* dns1.synet.edu.cn      2   6   377    37  +1040us[+1581us] +/-   21ms
> ^* dns1.synet.edu.cn      2   6   377    45  +1040us[+1581us] +/-   21ms
> ^* dns1.synet.edu.cn      2   6   377    53  +1040us[+1581us] +/-   21ms
> ^* dns1.synet.edu.cn      2   6   377    61  +1040us[+1581us] +/-   21ms
> ^* dns1.synet.edu.cn      2   6   377     4   -130us[ +796us] +/-   21ms
> ^* dns1.synet.edu.cn      2   6   377    12   -130us[ +796us] +/-   21ms
> ^* dns1.synet.edu.cn      2   6   377    20   -130us[ +796us] +/-   21ms
> 
> in host:
> MS Name/IP address   Stratum Poll Reach LastRx Last sample
> ========================================================================
> ^* 120.25.115.20          2   7   377    72   -470us[ -603us] +/-   18ms
> ^* 120.25.115.20          2   7   377    92   -470us[ -603us] +/-   18ms
> ^* 120.25.115.20          2   7   377   112   -470us[ -603us] +/-   18ms
> ^* 120.25.115.20          2   7   377     2   +872ns[-6808ns] +/-   17ms
> ^* 120.25.115.20          2   7   377    22   +872ns[-6808ns] +/-   17ms
> ^* 120.25.115.20          2   7   377    43   +872ns[-6808ns] +/-   17ms
> ^* 120.25.115.20          2   7   377    63   +872ns[-6808ns] +/-   17ms
> ^* 120.25.115.20          2   7   377    83   +872ns[-6808ns] +/-   17ms
> ^* 120.25.115.20          2   7   377   103   +872ns[-6808ns] +/-   17ms
> ^* 120.25.115.20          2   7   377   123   +872ns[-6808ns] +/-   17ms
> 
> The dns1.synet.edu.cn is the network reference clock for guest and
> 120.25.115.20 is the network reference clock for host. we can't get the
> clock error between guest and host directly, but a roughly estimated value
> will be in order of hundreds of us to ms.
> 
> with kvm ptp in guest:
> chrony has been disabled in host to remove the disturb by network clock.

Is that a realistic use case? Why should the host not use NTP?

> 
> MS Name/IP address         Stratum Poll Reach LastRx Last sample
> ========================================================================
> * PHC0                    0   3   377     8     -7ns[   +1ns] +/-    3ns
> * PHC0                    0   3   377     8     +1ns[  +16ns] +/-    3ns
> * PHC0                    0   3   377     6     -4ns[   -0ns] +/-    6ns
> * PHC0                    0   3   377     6     -8ns[  -12ns] +/-    5ns
> * PHC0                    0   3   377     5     +2ns[   +4ns] +/-    4ns
> * PHC0                    0   3   377    13     +2ns[   +4ns] +/-    4ns
> * PHC0                    0   3   377    12     -4ns[   -6ns] +/-    4ns
> * PHC0                    0   3   377    11     -8ns[  -11ns] +/-    6ns
> * PHC0                    0   3   377    10    -14ns[  -20ns] +/-    4ns
> * PHC0                    0   3   377     8     +4ns[   +5ns] +/-    4ns
> 
> The PHC0 is the ptp clock which choose the host clock as its source
> clock. So we can be sure to say that the clock error between host and guest
> is in order of ns.
> 
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> ---
>  arch/arm64/include/asm/arch_timer.h  |  3 ++
>  arch/arm64/kvm/arch_ptp_kvm.c        | 76 ++++++++++++++++++++++++++++
>  drivers/clocksource/arm_arch_timer.c |  6 ++-
>  drivers/ptp/Kconfig                  |  2 +-
>  include/linux/arm-smccc.h            | 14 +++++
>  virt/kvm/arm/psci.c                  | 17 +++++++
>  6 files changed, 115 insertions(+), 3 deletions(-)
>  create mode 100644 arch/arm64/kvm/arch_ptp_kvm.c

Please split this patch into two parts: the hypervisor code in a patch
and the guest code in another patch. Having both of them together is
confusing.

> 
> diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
> index 6756178c27db..880576a814b6 100644
> --- a/arch/arm64/include/asm/arch_timer.h
> +++ b/arch/arm64/include/asm/arch_timer.h
> @@ -229,4 +229,7 @@ static inline int arch_timer_arch_init(void)
>  	return 0;
>  }
>  
> +extern struct clocksource clocksource_counter;
> +extern u64 arch_counter_read(struct clocksource *cs);

I'm definitely not keen on exposing the internals of the arch_timer
driver to random subsystems. Furthermore, you seem to expect that the
guest kernel will only use the arch timer as a clocksource, and nothing
really guarantees that (in which case get_device_system_crosststamp will
fail).

It looks to me that we'd be better off exposing a core timekeeping API
that populates a struct system_counterval_t based on the *current*
timekeeper monotonic clocksource. This would simplify the split between
generic and arch-specific code.

Whether or not tglx will be happy with the idea is another problem, but
I'm certainly not taking any change to the arch timer code based on this.

> +
>  #endif
> diff --git a/arch/arm64/kvm/arch_ptp_kvm.c b/arch/arm64/kvm/arch_ptp_kvm.c

We don't put non-hypervisor in arch/arm64/kvm. Please move it back to
drivers/ptp (as well as its x86 counterpart), and just link the two
parts there. This should also allow this to be enabled for 32bit guests.

> new file mode 100644
> index 000000000000..6b2165ebce62
> --- /dev/null
> +++ b/arch/arm64/kvm/arch_ptp_kvm.c
> @@ -0,0 +1,76 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + *  Virtual PTP 1588 clock for use with KVM guests
> + *  Copyright (C) 2019 ARM Ltd.
> + *  All Rights Reserved
> + */
> +
> +#include <asm/hypervisor.h>
> +#include <linux/module.h>
> +#include <linux/psci.h>
> +#include <linux/arm-smccc.h>
> +#include <linux/timecounter.h>
> +#include <linux/sched/clock.h>
> +#include <asm/arch_timer.h>
> +
> +/*
> + * as trap call cause delay, this function will return the delay in nanosecond
> + */
> +static u64 arm_smccc_1_1_invoke_delay(u32 id, struct arm_smccc_res *res)
> +{
> +	u64 ns, t1, t2;
> +
> +	t1 = sched_clock();
> +	arm_smccc_1_1_invoke(id, res);
> +	t2 = sched_clock();
> +	t2 -= t1;
> +	ns = t2;
> +	return ns;

I think you can get rid of the ns variable here...

> +}
> +
> +int kvm_arch_ptp_init(void)
> +{
> +	return 0;
> +}
> +
> +int kvm_arch_ptp_get_clock(struct timespec64 *ts)
> +{
> +	u64 ns;
> +	struct arm_smccc_res hvc_res;
> +
> +	if (!kvm_arm_hyp_service_available(
> +			ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID)) {
> +		return -EOPNOTSUPP;
> +	}
> +	ns = arm_smccc_1_1_invoke_delay(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID,
> +					&hvc_res);
> +	ts->tv_sec = hvc_res.a0;
> +	ts->tv_nsec = hvc_res.a1;
> +	timespec64_add_ns(ts, ns);
> +	return 0;
> +}
> +
> +int kvm_arch_ptp_get_clock_fn(long *cycle, struct timespec64 *ts,
> +			      struct clocksource **cs)
> +{
> +	u64 ns;
> +	struct arm_smccc_res hvc_res;
> +
> +	if (!kvm_arm_hyp_service_available(
> +			ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID)) {
> +		return -EOPNOTSUPP;
> +	}
> +	ns = arm_smccc_1_1_invoke_delay(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID,
> +					&hvc_res);
> +	ts->tv_sec = hvc_res.a0;
> +	ts->tv_nsec = hvc_res.a1;
> +	timespec64_add_ns(ts, ns);
> +	*cycle = hvc_res.a2;
> +	*cs = &clocksource_counter;
> +
> +	return 0;
> +}

Why do we have two functions doing almost the same thing? Why do you
call kvm_arm_hyp_service_available on each and every time? Isn't it
enough to check in kvm_arch_ptp_init()?

> +
> +MODULE_AUTHOR("Marcelo Tosatti <mtosatti@redhat.com>");
> +MODULE_DESCRIPTION("PTP clock using KVMCLOCK");
> +MODULE_LICENSE("GPL");

This should only exist in the generic code.

> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index 07e57a49d1e8..021e3f69364c 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -175,23 +175,25 @@ static notrace u64 arch_counter_get_cntvct(void)
>  u64 (*arch_timer_read_counter)(void) = arch_counter_get_cntvct;
>  EXPORT_SYMBOL_GPL(arch_timer_read_counter);
>  
> -static u64 arch_counter_read(struct clocksource *cs)
> +u64 arch_counter_read(struct clocksource *cs)
>  {
>  	return arch_timer_read_counter();
>  }
> +EXPORT_SYMBOL(arch_counter_read);
>  
>  static u64 arch_counter_read_cc(const struct cyclecounter *cc)
>  {
>  	return arch_timer_read_counter();
>  }
>  
> -static struct clocksource clocksource_counter = {
> +struct clocksource clocksource_counter = {
>  	.name	= "arch_sys_counter",
>  	.rating	= 400,
>  	.read	= arch_counter_read,
>  	.mask	= CLOCKSOURCE_MASK(56),
>  	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
>  };
> +EXPORT_SYMBOL(clocksource_counter);

I've said what I thought about this. Not happening.

>  
>  static struct cyclecounter cyclecounter __ro_after_init = {
>  	.read	= arch_counter_read_cc,
> diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
> index 9b8fee5178e8..e032fafdafa7 100644
> --- a/drivers/ptp/Kconfig
> +++ b/drivers/ptp/Kconfig
> @@ -110,7 +110,7 @@ config PTP_1588_CLOCK_PCH
>  config PTP_1588_CLOCK_KVM
>  	tristate "KVM virtual PTP clock"
>  	depends on PTP_1588_CLOCK
> -	depends on KVM_GUEST && X86
> +	depends on KVM_GUEST && X86 || ARM64
>  	default y
>  	help
>  	  This driver adds support for using kvm infrastructure as a PTP
> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> index a6e4d3e3d10a..2a222a1a8594 100644
> --- a/include/linux/arm-smccc.h
> +++ b/include/linux/arm-smccc.h
> @@ -94,6 +94,7 @@
>  
>  /* KVM "vendor specific" services */
>  #define ARM_SMCCC_KVM_FUNC_FEATURES		0
> +#define ARM_SMCCC_KVM_PTP			1
>  #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
>  #define ARM_SMCCC_KVM_NUM_FUNCS			128
>  
> @@ -102,6 +103,16 @@
>  			   ARM_SMCCC_SMC_32,				\
>  			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
>  			   ARM_SMCCC_KVM_FUNC_FEATURES)
> +/*
> + * This ID used for virtual ptp kvm clock and it will pass second value
> + * and nanosecond value of host real time and system counter by vcpu
> + * register to guest.
> + */
> +#define ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID				\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
> +			   ARM_SMCCC_SMC_32,				\
> +			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
> +			   ARM_SMCCC_KVM_PTP)
>  
>  #ifndef __ASSEMBLY__
>  
> @@ -373,5 +384,8 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
>  		method;							\
>  	})
>  
> +#include <linux/psci.h>
> +#include <linux/clocksource.h>
> +
>  #endif /*__ASSEMBLY__*/
>  #endif /*__LINUX_ARM_SMCCC_H*/
> diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
> index 0debf49bf259..7fffdb25d32c 100644
> --- a/virt/kvm/arm/psci.c
> +++ b/virt/kvm/arm/psci.c
> @@ -392,6 +392,8 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  	u32 func_id = smccc_get_function(vcpu);
>  	u32 val[4] = {};
>  	u32 option;
> +	struct timespec *ts;
> +	u64 cnt;
>  
>  	val[0] = SMCCC_RET_NOT_SUPPORTED;
>  
> @@ -431,6 +433,21 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
>  		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
>  		break;
> +	/*
> +	 * This will used for virtual ptp kvm clock. three
> +	 * values will be passed back.
> +	 * reg0 stores seconds of host real time;
> +	 * reg1 stores nanoseconds of host real time;
> +	 * reg2 stotes system counter cycle value.

stores

> +	 */
> +	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> +		getnstimeofday(ts);
> +		cnt = arch_timer_read_counter();
> +		val[0] = ts->tv_sec;
> +		val[1] = ts->tv_nsec;
> +		val[2] = cnt;

Can you explain what the purpose of exposing this counter is? The guest
should have access to the physical counter already.

> +		val[3] = 0;
> +		break;

This will probably conflict with Steven's stolen time series. Not a big
deal though.

>  	default:
>  		return kvm_psci_call(vcpu);
>  	}
> 

Other questions: how does this works with VM migration? Specially when
moving from a hypervisor that supports the feature to one that doesn't?

Thanks,

	M.
-- 
Jazz is not dead, it just smells funny...
