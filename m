Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B29FF30BF98
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 14:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbhBBNft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 08:35:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:60348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232496AbhBBNdJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 08:33:09 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD48864DDA;
        Tue,  2 Feb 2021 13:32:27 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1l6vn7-00BV6N-D5; Tue, 02 Feb 2021 13:32:25 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 02 Feb 2021 13:32:25 +0000
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
Subject: Re: [PATCH v16 6/9] arm64/kvm: Add hypercall service for kvm ptp.
In-Reply-To: <20201209060932.212364-7-jianyong.wu@arm.com>
References: <20201209060932.212364-1-jianyong.wu@arm.com>
 <20201209060932.212364-7-jianyong.wu@arm.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <188d7687c948827cd1d218bc8ba3e5a2@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: jianyong.wu@arm.com, netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de, pbonzini@redhat.com, sean.j.christopherson@intel.com, richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com, Andre.Przywara@arm.com, steven.price@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Steve.Capper@arm.com, justin.he@arm.com, nd@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-09 06:09, Jianyong Wu wrote:
> ptp_kvm will get this service through SMCC call.
> The service offers wall time and cycle count of host to guest.
> The caller must specify whether they want the host cycle count
> or the difference between host cycle count and cntvoff.
> 
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> ---
>  arch/arm64/kvm/hypercalls.c | 59 +++++++++++++++++++++++++++++++++++++
>  include/linux/arm-smccc.h   | 16 ++++++++++
>  2 files changed, 75 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index b9d8607083eb..9a4834502388 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -9,6 +9,49 @@
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
> +
> +	/*
> +	 * which of virtual counter or physical counter being
> +	 * asked for is decided by the r1 value of SMCCC
> +	 * call. If no invalid r1 value offered, default cycle
> +	 * value(-1) will be returned.
> +	 * Note: keep in mind that feature is u32 and smccc_get_arg1
> +	 * will return u64, so need auto cast here.

This feels like a useless comment. On the other hand, you don't
document why we don't need to worry about -1 being used as the
top 32bits of the real time.

> +	 */
> +	feature = smccc_get_arg1(vcpu);
> +	switch (feature) {
> +	case ARM_PTP_VIRT_COUNTER:

This #define should at least contain "KVM", because this isn't
something that is architectural.

> +		cycles = systime_snapshot.cycles - vcpu_read_sys_reg(vcpu, 
> CNTVOFF_EL2);
> +		break;
> +	case ARM_PTP_PHY_COUNTER:

s/PHY/PHYS/

> +		cycles = systime_snapshot.cycles;
> +		break;
> +	default:
> +		val[0] = SMCCC_RET_NOT_SUPPORTED;
> +		break;
> +	}
> +	val[2] = upper_32_bits(cycles);
> +	val[3] = lower_32_bits(cycles);

The control flow is really odd. You start by writing values to
the return array, and then have to overwrite it if you fail.

I came up with the following instead (including comments):

@@ -16,38 +16,44 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, 
u64 *val)
  	u32 feature;

  	/*
-	 * system time and counter value must captured in the same
+	 * system time and counter value must captured at the same
  	 * time to keep consistency and precision.
  	 */
  	ktime_get_snapshot(&systime_snapshot);

-	// binding ptp_kvm clocksource to arm_arch_counter
+	/*
+	 * This is only valid if the current clocksource is the
+	 * architected counter, as this is the only one the guest
+	 * can see.
+	 */
  	if (systime_snapshot.cs_id != CSID_ARM_ARCH_COUNTER)
  		return;

-	val[0] = upper_32_bits(systime_snapshot.real);
-	val[1] = lower_32_bits(systime_snapshot.real);
-
  	/*
-	 * which of virtual counter or physical counter being
-	 * asked for is decided by the r1 value of SMCCC
-	 * call. If no invalid r1 value offered, default cycle
-	 * value(-1) will be returned.
-	 * Note: keep in mind that feature is u32 and smccc_get_arg1
-	 * will return u64, so need auto cast here.
+	 * The guest selects one of the two reference counters
+	 * (virtual or physical) with the first argument of the SMCCC
+	 * call. In case the identifier is not supported, error out.
  	 */
  	feature = smccc_get_arg1(vcpu);
  	switch (feature) {
-	case ARM_PTP_VIRT_COUNTER:
+	case KVM_PTP_VIRT_COUNTER:
  		cycles = systime_snapshot.cycles - vcpu_read_sys_reg(vcpu, 
CNTVOFF_EL2);
  		break;
-	case ARM_PTP_PHY_COUNTER:
+	case KVM_PTP_PHYS_COUNTER:
  		cycles = systime_snapshot.cycles;
  		break;
  	default:
-		val[0] = SMCCC_RET_NOT_SUPPORTED;
-		break;
+		return;
  	}
+
+	/*
+	 * This relies on the top bit of val[0] never being set for
+	 * valid values of system time, because that is *really* far
+	 * in the future (about 292 years from 1970, and at that stage
+	 * nobody will give a damn about it).
+	 */
+	val[0] = upper_32_bits(systime_snapshot.real);
+	val[1] = lower_32_bits(systime_snapshot.real);
  	val[2] = upper_32_bits(cycles);
  	val[3] = lower_32_bits(cycles);
  }


> +}
> +
>  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  {
>  	u32 func_id = smccc_get_function(vcpu);
> @@ -79,6 +122,22 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  		break;
>  	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
>  		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
> +		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_PTP);
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

You have a patch with documentation in this series, and I don't think
this adds much.

> +	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> +		kvm_ptp_get_time(vcpu, val);
>  		break;
>  	default:
>  		return kvm_psci_call(vcpu);
> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> index d75408141137..7924069f8f0a 100644
> --- a/include/linux/arm-smccc.h
> +++ b/include/linux/arm-smccc.h
> @@ -103,6 +103,7 @@
> 
>  /* KVM "vendor specific" services */
>  #define ARM_SMCCC_KVM_FUNC_FEATURES		0
> +#define ARM_SMCCC_KVM_FUNC_PTP			1
>  #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
>  #define ARM_SMCCC_KVM_NUM_FUNCS			128
> 
> @@ -114,6 +115,21 @@
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
> +			   ARM_SMCCC_KVM_FUNC_PTP)
> +
> +/* ptp_kvm counter type ID */
> +#define ARM_PTP_VIRT_COUNTER			0
> +#define ARM_PTP_PHY_COUNTER			1

+#define KVM_PTP_VIRT_COUNTER			0
+#define KVM_PTP_PHYS_COUNTER			1

> +
>  /* Paravirtualised time calls (defined by ARM DEN0057A) */
>  #define ARM_SMCCC_HV_PV_TIME_FEATURES				\
>  	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
