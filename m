Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E2330BF3A
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 14:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbhBBNTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 08:19:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:56376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232228AbhBBNTI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 08:19:08 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43D6264ED7;
        Tue,  2 Feb 2021 13:18:27 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1l6vZZ-00BUwh-61; Tue, 02 Feb 2021 13:18:25 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 02 Feb 2021 13:18:24 +0000
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
Subject: Re: [PATCH v16 1/9] arm64: Probe for the presence of KVM hypervisor
In-Reply-To: <20201209060932.212364-2-jianyong.wu@arm.com>
References: <20201209060932.212364-1-jianyong.wu@arm.com>
 <20201209060932.212364-2-jianyong.wu@arm.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <0099a326c906f52fa5422d7c1b4fe767@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: jianyong.wu@arm.com, netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de, pbonzini@redhat.com, sean.j.christopherson@intel.com, richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com, Andre.Przywara@arm.com, steven.price@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Steve.Capper@arm.com, justin.he@arm.com, nd@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-09 06:09, Jianyong Wu wrote:
> From: Will Deacon <will@kernel.org>
> 
> Although the SMCCC specification provides some limited functionality 
> for
> describing the presence of hypervisor and firmware services, this is
> generally applicable only to functions designated as "Arm Architecture
> Service Functions" and no portable discovery mechanism is provided for
> standard hypervisor services, despite having a designated range of
> function identifiers reserved by the specification.
> 
> In an attempt to avoid the need for additional firmware changes every
> time a new function is added, introduce a UID to identify the service
> provider as being compatible with KVM. Once this has been established,
> additional services can be discovered via a feature bitmap.
> 
> Change from Jianyong Wu:
> mv kvm_arm_hyp_service_available to common place to let both arm/arm64 
> touch it.
> add kvm_init_hyp_services also under arm arch to let arm kvm guest use
> this service.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> ---
>  arch/arm/kernel/setup.c        |  5 ++++
>  arch/arm64/kernel/setup.c      |  1 +
>  drivers/firmware/smccc/smccc.c | 37 +++++++++++++++++++++++++++++
>  include/linux/arm-smccc.h      | 43 ++++++++++++++++++++++++++++++++++
>  4 files changed, 86 insertions(+)
> 
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index 1a5edf562e85..adcefa9c8fab 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -1156,6 +1156,11 @@ void __init setup_arch(char **cmdline_p)
> 
>  	arm_dt_init_cpu_maps();
>  	psci_dt_init();
> +
> +#ifdef CONFIG_HAVE_ARM_SMCCC_DISCOVERY
> +	kvm_init_hyp_services();
> +#endif
> +
>  #ifdef CONFIG_SMP
>  	if (is_smp()) {
>  		if (!mdesc->smp_init || !mdesc->smp_init()) {
> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> index a950d5bc1ba5..97037b15c6ea 100644
> --- a/arch/arm64/kernel/setup.c
> +++ b/arch/arm64/kernel/setup.c
> @@ -353,6 +353,7 @@ void __init __no_sanitize_address setup_arch(char
> **cmdline_p)
>  	else
>  		psci_acpi_init();
> 
> +	kvm_init_hyp_services();

Given that there is a dependency between the KVM discovery and PSCI,
it may make more sense to directly call this from the PSCI init,
and leave the arch-specific code alone.

>  	init_bootcpu_ops();
>  	smp_init_cpus();
>  	smp_build_mpidr_hash();
> diff --git a/drivers/firmware/smccc/smccc.c 
> b/drivers/firmware/smccc/smccc.c
> index 00c88b809c0c..e153c71ece99 100644
> --- a/drivers/firmware/smccc/smccc.c
> +++ b/drivers/firmware/smccc/smccc.c
> @@ -7,10 +7,47 @@
> 
>  #include <linux/init.h>
>  #include <linux/arm-smccc.h>
> +#include <linux/kernel.h>
> +#include <linux/string.h>
> 
>  static u32 smccc_version = ARM_SMCCC_VERSION_1_0;
>  static enum arm_smccc_conduit smccc_conduit = SMCCC_CONDUIT_NONE;
> 
> +DECLARE_BITMAP(__kvm_arm_hyp_services, ARM_SMCCC_KVM_NUM_FUNCS) = { };
> +EXPORT_SYMBOL_GPL(__kvm_arm_hyp_services);
> +
> +void __init kvm_init_hyp_services(void)
> +{
> +	int i;
> +	struct arm_smccc_res res;
> +
> +	if (arm_smccc_get_version() == ARM_SMCCC_VERSION_1_0)
> +		return;
> +
> +	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID, &res);

I think we may end-up calling into EL3 when running this on bare
metal if the systems implement PSCI 1,1. Robust firmware should
handle it, but there is plenty of broken ones around...

Checking on the SMCCC conduit would be safer.

> +	if (res.a0 != ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_0 ||
> +	    res.a1 != ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_1 ||
> +	    res.a2 != ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2 ||
> +	    res.a3 != ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3)
> +		return;
> +
> +	memset(&res, 0, sizeof(res));
> +	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID, 
> &res);
> +	for (i = 0; i < 32; ++i) {
> +		if (res.a0 & (i))
> +			set_bit(i + (32 * 0), __kvm_arm_hyp_services);
> +		if (res.a1 & (i))
> +			set_bit(i + (32 * 1), __kvm_arm_hyp_services);
> +		if (res.a2 & (i))
> +			set_bit(i + (32 * 2), __kvm_arm_hyp_services);
> +		if (res.a3 & (i))
> +			set_bit(i + (32 * 3), __kvm_arm_hyp_services);
> +	}
> +
> +	pr_info("KVM hypervisor services detected (0x%08lx 0x%08lx 0x%08lx
> 0x%08lx)\n",
> +		 res.a3, res.a2, res.a1, res.a0);
> +}
> +

Overall, this code should be in its own file, much like we already
do for the SOC_ID stuff.

>  void __init arm_smccc_version_init(u32 version, enum arm_smccc_conduit 
> conduit)
>  {
>  	smccc_version = version;
> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> index f860645f6512..d75408141137 100644
> --- a/include/linux/arm-smccc.h
> +++ b/include/linux/arm-smccc.h
> @@ -55,6 +55,8 @@
>  #define ARM_SMCCC_OWNER_TRUSTED_OS	50
>  #define ARM_SMCCC_OWNER_TRUSTED_OS_END	63
> 
> +#define ARM_SMCCC_FUNC_QUERY_CALL_UID  0xff01
> +
>  #define ARM_SMCCC_QUIRK_NONE		0
>  #define ARM_SMCCC_QUIRK_QCOM_A6		1 /* Save/restore register a6 */
> 
> @@ -87,6 +89,29 @@
>  			   ARM_SMCCC_SMC_32,				\
>  			   0, 0x7fff)
> 
> +#define ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID				\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
> +			   ARM_SMCCC_SMC_32,				\
> +			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
> +			   ARM_SMCCC_FUNC_QUERY_CALL_UID)
> +
> +/* KVM UID value: 28b46fb6-2ec5-11e9-a9ca-4b564d003a74 */
> +#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_0	0xb66fb428U
> +#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_1	0xe911c52eU
> +#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2	0x564bcaa9U
> +#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3	0x743a004dU
> +
> +/* KVM "vendor specific" services */
> +#define ARM_SMCCC_KVM_FUNC_FEATURES		0
> +#define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
> +#define ARM_SMCCC_KVM_NUM_FUNCS			128
> +
> +#define ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID			\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
> +			   ARM_SMCCC_SMC_32,				\
> +			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
> +			   ARM_SMCCC_KVM_FUNC_FEATURES)
> +
>  #define SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED	1
> 
>  /* Paravirtualised time calls (defined by ARM DEN0057A) */
> @@ -391,5 +416,23 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0,
> unsigned long a1,
>  		method;							\
>  	})
> 
> +void __init kvm_init_hyp_services(void);
> +
> +/*
> + * This helper will be called in guest. We put it here then both arm 
> and arm64
> + * guest can touch it.
> + */
> +#include <linux/kernel.h>
> +#include <linux/err.h>

I don't see the need for linux/err.h.

> +static inline bool kvm_arm_hyp_service_available(u32 func_id)
> +{
> +	extern DECLARE_BITMAP(__kvm_arm_hyp_services, 
> ARM_SMCCC_KVM_NUM_FUNCS);
> +
> +	if (func_id >= ARM_SMCCC_KVM_NUM_FUNCS)
> +		return -EINVAL;
> +
> +	return test_bit(func_id, __kvm_arm_hyp_services);
> +}
> +
>  #endif /*__ASSEMBLY__*/
>  #endif /*__LINUX_ARM_SMCCC_H*/

If we move this as part of a file holding the whole of the
KVM discovery, we can make it non-inline and export it
instead of the bitmap.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
