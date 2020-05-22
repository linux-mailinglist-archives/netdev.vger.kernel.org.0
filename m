Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53ED41DE89C
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 16:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729980AbgEVOSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 10:18:31 -0400
Received: from foss.arm.com ([217.140.110.172]:36348 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729399AbgEVOSb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 10:18:31 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AD068D6E;
        Fri, 22 May 2020 07:18:30 -0700 (PDT)
Received: from [192.168.1.84] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 05A2A3F68F;
        Fri, 22 May 2020 07:18:27 -0700 (PDT)
Subject: Re: [RFC PATCH v12 07/11] psci: Add hypercall service for kvm ptp.
To:     Jianyong Wu <jianyong.wu@arm.com>, netdev@vger.kernel.org,
        yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        maz@kernel.org, richardcochran@gmail.com, Mark.Rutland@arm.com,
        will@kernel.org, suzuki.poulose@arm.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com,
        Wei.Chen@arm.com, nd@arm.com
References: <20200522083724.38182-1-jianyong.wu@arm.com>
 <20200522083724.38182-8-jianyong.wu@arm.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <87fce07b-d0f5-47b0-05ce-dd664ce53eec@arm.com>
Date:   Fri, 22 May 2020 15:18:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200522083724.38182-8-jianyong.wu@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/05/2020 09:37, Jianyong Wu wrote:
> ptp_kvm modules will get this service through smccc call.
> The service offers real time and counter cycle of host for guest.
> Also let caller determine which cycle of virtual counter or physical counter
> to return.
> 
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> ---
>   include/linux/arm-smccc.h | 14 ++++++++++++
>   virt/kvm/Kconfig          |  4 ++++
>   virt/kvm/arm/hypercalls.c | 47 +++++++++++++++++++++++++++++++++++++++
>   3 files changed, 65 insertions(+)
> 
> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> index bdc0124a064a..badadc390809 100644
> --- a/include/linux/arm-smccc.h
> +++ b/include/linux/arm-smccc.h
> @@ -94,6 +94,8 @@
>   
>   /* KVM "vendor specific" services */
>   #define ARM_SMCCC_KVM_FUNC_FEATURES		0
> +#define ARM_SMCCC_KVM_FUNC_KVM_PTP		1
> +#define ARM_SMCCC_KVM_FUNC_KVM_PTP_PHY		2
>   #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
>   #define ARM_SMCCC_KVM_NUM_FUNCS			128
>   
> @@ -103,6 +105,18 @@
>   			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
>   			   ARM_SMCCC_KVM_FUNC_FEATURES)
>   
> +#define ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID				\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
> +			   ARM_SMCCC_SMC_32,				\
> +			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
> +			   ARM_SMCCC_KVM_FUNC_KVM_PTP)
> +
> +#define ARM_SMCCC_VENDOR_HYP_KVM_PTP_PHY_FUNC_ID			\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
> +			   ARM_SMCCC_SMC_32,				\
> +			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
> +			   ARM_SMCCC_KVM_FUNC_KVM_PTP_PHY)
> +
>   #ifndef __ASSEMBLY__
>   
>   #include <linux/linkage.h>
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index aad9284c043a..bf820811e815 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -60,3 +60,7 @@ config HAVE_KVM_VCPU_RUN_PID_CHANGE
>   
>   config HAVE_KVM_NO_POLL
>          bool
> +
> +config ARM64_KVM_PTP_HOST
> +       def_bool y
> +       depends on ARM64 && KVM
> diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
> index db6dce3d0e23..c964122f8dae 100644
> --- a/virt/kvm/arm/hypercalls.c
> +++ b/virt/kvm/arm/hypercalls.c
> @@ -3,6 +3,7 @@
>   
>   #include <linux/arm-smccc.h>
>   #include <linux/kvm_host.h>
> +#include <linux/clocksource_ids.h>
>   
>   #include <asm/kvm_emulate.h>
>   
> @@ -11,6 +12,10 @@
>   
>   int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>   {
> +#ifdef CONFIG_ARM64_KVM_PTP_HOST
> +	struct system_time_snapshot systime_snapshot;
> +	u64 cycles;
> +#endif
>   	u32 func_id = smccc_get_function(vcpu);
>   	u32 val[4] = {SMCCC_RET_NOT_SUPPORTED};
>   	u32 feature;
> @@ -70,7 +75,49 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>   		break;
>   	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
>   		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
> +
> +#ifdef CONFIG_ARM64_KVM_PTP_HOST
> +		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_KVM_PTP);
> +#endif
>   		break;
> +
> +#ifdef CONFIG_ARM64_KVM_PTP_HOST
> +	/*
> +	 * This serves virtual kvm_ptp.
> +	 * Four values will be passed back.
> +	 * reg0 stores high 32-bit host ktime;
> +	 * reg1 stores low 32-bit host ktime;
> +	 * reg2 stores high 32-bit difference of host cycles and cntvoff;
> +	 * reg3 stores low 32-bit difference of host cycles and cntvoff.
> +	 */
> +	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> +		/*
> +		 * system time and counter value must captured in the same
> +		 * time to keep consistency and precision.
> +		 */
> +		ktime_get_snapshot(&systime_snapshot);
> +		if (systime_snapshot.cs_id != CSID_ARM_ARCH_COUNTER)
> +			break;
> +		val[0] = upper_32_bits(systime_snapshot.real);
> +		val[1] = lower_32_bits(systime_snapshot.real);
> +		/*
> +		 * which of virtual counter or physical counter being
> +		 * asked for is decided by the first argument.
> +		 */
> +		feature = smccc_get_arg1(vcpu);
> +		switch (feature) {
> +		case ARM_SMCCC_VENDOR_HYP_KVM_PTP_PHY_FUNC_ID:
> +			cycles = systime_snapshot.cycles;
> +			break;
> +		default:

There's something a bit odd here.

ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID and
ARM_SMCCC_VENDOR_HYP_KVM_PTP_PHY_FUNC_ID look like they should be names 
of separate (top-level) functions, but actually the _PHY_ one is a 
parameter for the first. If the intention is to have a parameter then it 
would be better to pick a better name for the _PHY_ define and not 
define it using ARM_SMCCC_CALL_VAL.

Second the use of "default:" means that there's no possibility to later 
extend this interface for more clocks if needed in the future.

Alternatively you could indeed implement as two top-level functions and 
change this to a...

	switch (func_id)

... along with multiple case labels as the functions would obviously be 
mostly the same.

Also a minor style issue - you might want to consider splitting this 
into it's own function.

Finally I do think it would be useful to add some documentation of the 
new SMC calls. It would be easier to review the interface based on that 
documentation rather than trying to reverse-engineer the interface from 
the code.

Steve

> +			cycles = systime_snapshot.cycles -
> +				 vcpu_vtimer(vcpu)->cntvoff;
> +		}
> +		val[2] = upper_32_bits(cycles);
> +		val[3] = lower_32_bits(cycles);
> +		break;
> +#endif
> +
>   	default:
>   		return kvm_psci_call(vcpu);
>   	}
> 

