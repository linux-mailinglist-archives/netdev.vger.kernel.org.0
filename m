Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CF81B236E
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 11:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728630AbgDUJ5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 05:57:45 -0400
Received: from foss.arm.com ([217.140.110.172]:60790 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbgDUJ5o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 05:57:44 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A1BB01FB;
        Tue, 21 Apr 2020 02:57:43 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 554A83F73D;
        Tue, 21 Apr 2020 02:57:39 -0700 (PDT)
Date:   Tue, 21 Apr 2020 10:57:36 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Jianyong Wu <jianyong.wu@arm.com>
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, will@kernel.org, suzuki.poulose@arm.com,
        steven.price@arm.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Steve.Capper@arm.com, Kaly.Xin@arm.com,
        justin.he@arm.com, nd@arm.com
Subject: Re: [RFC PATCH v11 5/9] psci: Add hypercall service for ptp_kvm.
Message-ID: <20200421095736.GB16306@C02TD0UTHF1T.local>
References: <20200421032304.26300-1-jianyong.wu@arm.com>
 <20200421032304.26300-6-jianyong.wu@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421032304.26300-6-jianyong.wu@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 11:23:00AM +0800, Jianyong Wu wrote:
> ptp_kvm modules will get this service through smccc call.
> The service offers real time and counter cycle of host for guest.
> Also let caller determine which cycle of virtual counter or physical counter
> to return.
> 
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> ---
>  include/linux/arm-smccc.h | 21 +++++++++++++++++++
>  virt/kvm/arm/hypercalls.c | 44 ++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 64 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> index 59494df0f55b..747b7595d0c6 100644
> --- a/include/linux/arm-smccc.h
> +++ b/include/linux/arm-smccc.h
> @@ -77,6 +77,27 @@
>  			   ARM_SMCCC_SMC_32,				\
>  			   0, 0x7fff)
>  
> +/* PTP KVM call requests clock time from guest OS to host */
> +#define ARM_SMCCC_HYP_KVM_PTP_FUNC_ID				\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
> +			   ARM_SMCCC_SMC_32,			\
> +			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
> +			   0)
> +
> +/* request for virtual counter from ptp_kvm guest */
> +#define ARM_SMCCC_HYP_KVM_PTP_VIRT				\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
> +			   ARM_SMCCC_SMC_32,			\
> +			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
> +			   1)
> +
> +/* request for physical counter from ptp_kvm guest */
> +#define ARM_SMCCC_HYP_KVM_PTP_PHY				\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
> +			   ARM_SMCCC_SMC_32,			\
> +			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
> +			   2)

ARM_SMCCC_OWNER_STANDARD_HYP is for standard calls as defined in SMCCC
and companion documents, so we should refer to the specific
documentation here. Where are these calls defined?

If these calls are Linux-specific then ARM_SMCCC_OWNER_STANDARD_HYP
isn't appropriate to use, as they are vendor-specific hypervisor service
call.

It looks like we don't currently have a ARM_SMCCC_OWNER_HYP for that
(which IIUC would be 6), but we can add one as necessary. I think that
Will might have added that as part of his SMCCC probing bits.

> +
>  #ifndef __ASSEMBLY__
>  
>  #include <linux/linkage.h>
> diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
> index 550dfa3e53cd..a5309c28d4dc 100644
> --- a/virt/kvm/arm/hypercalls.c
> +++ b/virt/kvm/arm/hypercalls.c
> @@ -3,6 +3,7 @@
>  
>  #include <linux/arm-smccc.h>
>  #include <linux/kvm_host.h>
> +#include <linux/clocksource_ids.h>
>  
>  #include <asm/kvm_emulate.h>
>  
> @@ -11,8 +12,11 @@
>  
>  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  {
> -	u32 func_id = smccc_get_function(vcpu);
> +	struct system_time_snapshot systime_snapshot;
> +	long arg[4];
> +	u64 cycles;
>  	long val = SMCCC_RET_NOT_SUPPORTED;
> +	u32 func_id = smccc_get_function(vcpu);
>  	u32 feature;
>  	gpa_t gpa;
>  
> @@ -62,6 +66,44 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  		if (gpa != GPA_INVALID)
>  			val = gpa;
>  		break;
> +	/*
> +	 * This serves virtual kvm_ptp.
> +	 * Four values will be passed back.
> +	 * reg0 stores high 32-bit host ktime;
> +	 * reg1 stores low 32-bit host ktime;
> +	 * reg2 stores high 32-bit difference of host cycles and cntvoff;
> +	 * reg3 stores low 32-bit difference of host cycles and cntvoff.
> +	 */
> +	case ARM_SMCCC_HYP_KVM_PTP_FUNC_ID:

Shouldn't the host opt-in to providing this to the guest, as with other
features?

> +		/*
> +		 * system time and counter value must captured in the same
> +		 * time to keep consistency and precision.
> +		 */
> +		ktime_get_snapshot(&systime_snapshot);
> +		if (systime_snapshot.cs_id != CSID_ARM_ARCH_COUNTER)
> +			break;
> +		arg[0] = upper_32_bits(systime_snapshot.real);
> +		arg[1] = lower_32_bits(systime_snapshot.real);

Why exactly does the guest need the host's real time? Neither the cover
letter nor this commit message have explained that, and for those of us
unfamliar with PTP it would be very helpful to know that to understand
what's going on.

> +		/*
> +		 * which of virtual counter or physical counter being
> +		 * asked for is decided by the first argument.
> +		 */
> +		feature = smccc_get_arg1(vcpu);
> +		switch (feature) {
> +		case ARM_SMCCC_HYP_KVM_PTP_PHY:
> +			cycles = systime_snapshot.cycles;
> +			break;
> +		case ARM_SMCCC_HYP_KVM_PTP_VIRT:
> +		default:
> +			cycles = systime_snapshot.cycles -
> +			vcpu_vtimer(vcpu)->cntvoff;
> +		}
> +		arg[2] = upper_32_bits(cycles);
> +		arg[3] = lower_32_bits(cycles);
> +
> +		smccc_set_retval(vcpu, arg[0], arg[1], arg[2], arg[3]);

I think the 'arg' buffer is confusing here, and it'd be clearer to have:

	u64 snaphot;
	u64 cycles;

... and here do:

		smccc_set_retval(vcpu,
				 upper_32_bits(snaphot),
				 lower_32_bits(snapshot), 
				 upper_32_bits(cycles),
				 lower_32_bits(cycles));

Thanks,
Mark.
