Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794382C0396
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 11:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbgKWKoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 05:44:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:41248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbgKWKoQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 05:44:16 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 691AB2076E;
        Mon, 23 Nov 2020 10:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606128254;
        bh=0i/Ni3kZzV5fbIzNzcjmFGKPO1GlWbvJIDpSsaZ7xz8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hTJmXcNrqPN4TANS18R1jlGBzZajV2aUWLpzDTGH88XrxC87G+t/jopKrepNEeLwm
         0+rqIZem3eap2IfVbXVwyersh3veLjNERXei8VwYWymhk4/paAWd+W/p7rGHrkcnXm
         +pjqXMdHX44U546hSqPOzry+sdpQiJe1afKpQhWs=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kh9KO-00Csxc-6S; Mon, 23 Nov 2020 10:44:12 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 23 Nov 2020 10:44:12 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Jianyong Wu <jianyong.wu@arm.com>
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, richardcochran@gmail.com,
        Mark.Rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com,
        Andre.Przywara@arm.com, steven.price@arm.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, justin.he@arm.com, nd@arm.com
Subject: Re: [PATCH v15 6/9] arm64/kvm: Add hypercall service for kvm ptp.
In-Reply-To: <20201111062211.33144-7-jianyong.wu@arm.com>
References: <20201111062211.33144-1-jianyong.wu@arm.com>
 <20201111062211.33144-7-jianyong.wu@arm.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <d409aa1cb7cfcbf4351e6c5fc34d9c7e@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: jianyong.wu@arm.com, netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de, pbonzini@redhat.com, sean.j.christopherson@intel.com, richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com, Andre.Przywara@arm.com, steven.price@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Steve.Capper@arm.com, justin.he@arm.com, nd@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-11 06:22, Jianyong Wu wrote:
> ptp_kvm will get this service through SMCC call.
> The service offers wall time and cycle count of host to guest.
> The caller must specify whether they want the host cycle count
> or the difference between host cycle count and cntvoff.
> 
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> ---
>  arch/arm64/kvm/hypercalls.c | 61 +++++++++++++++++++++++++++++++++++++
>  include/linux/arm-smccc.h   | 17 +++++++++++
>  2 files changed, 78 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index b9d8607083eb..f7d189563f3d 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -9,6 +9,51 @@
>  #include <kvm/arm_hypercalls.h>
>  #include <kvm/arm_psci.h>
> 
> +static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
> +{
> +	struct system_time_snapshot systime_snapshot;
> +	u64 cycles = ~0UL;
> +	u32 feature;
> +
> +	/*
> +	 * system time and counter value must captured in the same
> +	 * time to keep consistency and precision.
> +	 */
> +	ktime_get_snapshot(&systime_snapshot);
> +
> +	// binding ptp_kvm clocksource to arm_arch_counter
> +	if (systime_snapshot.cs_id != CSID_ARM_ARCH_COUNTER)
> +		return;
> +
> +	val[0] = upper_32_bits(systime_snapshot.real);
> +	val[1] = lower_32_bits(systime_snapshot.real);

What is the endianness of these values? I can't see it defined
anywhere, and this is likely not to work if guest and hypervisor
don't align.

> +
> +	/*
> +	 * which of virtual counter or physical counter being
> +	 * asked for is decided by the r1 value of SMCCC
> +	 * call. If no invalid r1 value offered, default cycle
> +	 * value(-1) will be returned.
> +	 * Note: keep in mind that feature is u32 and smccc_get_arg1
> +	 * will return u64, so need auto cast here.
> +	 */
> +	feature = smccc_get_arg1(vcpu);
> +	switch (feature) {
> +	case ARM_PTP_VIRT_COUNTER:
> +		cycles = systime_snapshot.cycles - vcpu_read_sys_reg(vcpu, 
> CNTVOFF_EL2);
> +		break;
> +	case ARM_PTP_PHY_COUNTER:
> +		cycles = systime_snapshot.cycles;
> +		break;
> +	case ARM_PTP_NONE_COUNTER:

What is this "NONE" counter?

> +		break;
> +	default:
> +		val[0] = SMCCC_RET_NOT_SUPPORTED;
> +		break;
> +	}
> +	val[2] = upper_32_bits(cycles);
> +	val[3] = lower_32_bits(cycles);

Same problem as above.

> +}
> +
>  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  {
>  	u32 func_id = smccc_get_function(vcpu);
> @@ -79,6 +124,22 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  		break;
>  	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
>  		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
> +		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_KVM_PTP);
> +		break;
> +	/*
> +	 * This serves virtual kvm_ptp.
> +	 * Four values will be passed back.
> +	 * reg0 stores high 32-bits of host ktime;
> +	 * reg1 stores low 32-bits of host ktime;
> +	 * For ARM_PTP_VIRT_COUNTER:
> +	 * reg2 stores high 32-bits of difference of host cycles and cntvoff;
> +	 * reg3 stores low 32-bits of difference of host cycles and cntvoff.
> +	 * For ARM_PTP_PHY_COUNTER:
> +	 * reg2 stores the high 32-bits of host cycles;
> +	 * reg3 stores the low 32-bits of host cycles.
> +	 */
> +	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> +		kvm_ptp_get_time(vcpu, val);
>  		break;
>  	default:
>  		return kvm_psci_call(vcpu);
> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> index d75408141137..a03c5dd409d3 100644
> --- a/include/linux/arm-smccc.h
> +++ b/include/linux/arm-smccc.h
> @@ -103,6 +103,7 @@
> 
>  /* KVM "vendor specific" services */
>  #define ARM_SMCCC_KVM_FUNC_FEATURES		0
> +#define ARM_SMCCC_KVM_FUNC_KVM_PTP		1

I think having KVM once in the name is enough.

>  #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
>  #define ARM_SMCCC_KVM_NUM_FUNCS			128
> 
> @@ -114,6 +115,22 @@
> 
>  #define SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED	1
> 
> +/*
> + * ptp_kvm is a feature used for time sync between vm and host.
> + * ptp_kvm module in guest kernel will get service from host using
> + * this hypercall ID.
> + */
> +#define ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID				\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
> +			   ARM_SMCCC_SMC_32,				\
> +			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
> +			   ARM_SMCCC_KVM_FUNC_KVM_PTP)
> +
> +/* ptp_kvm counter type ID */
> +#define ARM_PTP_VIRT_COUNTER			0
> +#define ARM_PTP_PHY_COUNTER			1
> +#define ARM_PTP_NONE_COUNTER			2

The architecture definitely doesn't have this last counter.

> +
>  /* Paravirtualised time calls (defined by ARM DEN0057A) */
>  #define ARM_SMCCC_HV_PV_TIME_FEATURES				\
>  	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
