Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A48122033FC
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 11:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgFVJv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 05:51:29 -0400
Received: from foss.arm.com ([217.140.110.172]:35490 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726901AbgFVJv3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 05:51:29 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 80FF41FB;
        Mon, 22 Jun 2020 02:51:28 -0700 (PDT)
Received: from [192.168.1.84] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C7EE93F71E;
        Mon, 22 Jun 2020 02:51:25 -0700 (PDT)
Subject: Re: [RFC PATCH v13 7/9] arm64/kvm: Add hypercall service for kvm ptp.
To:     Jianyong Wu <Jianyong.Wu@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        Kaly Xin <Kaly.Xin@arm.com>, Justin He <Justin.He@arm.com>,
        Wei Chen <Wei.Chen@arm.com>, nd <nd@arm.com>
References: <20200619093033.58344-1-jianyong.wu@arm.com>
 <20200619093033.58344-8-jianyong.wu@arm.com>
 <c56a5b56-8bcb-915c-ae7e-5de92161538c@arm.com>
 <HE1PR0802MB25558F9A526C327134C7A7EEF4970@HE1PR0802MB2555.eurprd08.prod.outlook.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <f331dc59-5642-33b0-9a37-553b7f536afe@arm.com>
Date:   Mon, 22 Jun 2020 10:51:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <HE1PR0802MB25558F9A526C327134C7A7EEF4970@HE1PR0802MB2555.eurprd08.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/06/2020 03:25, Jianyong Wu wrote:
> Hi Steven,

Hi Jianyong

[...]
>>> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
>>> index db6dce3d0e23..366b0646c360 100644
>>> --- a/arch/arm64/kvm/hypercalls.c
>>> +++ b/arch/arm64/kvm/hypercalls.c
>>> @@ -3,6 +3,7 @@
>>>
>>>    #include <linux/arm-smccc.h>
>>>    #include <linux/kvm_host.h>
>>> +#include <linux/clocksource_ids.h>
>>>
>>>    #include <asm/kvm_emulate.h>
>>>
>>> @@ -11,6 +12,10 @@
>>>
>>>    int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>>>    {
>>> +#ifdef CONFIG_ARM64_KVM_PTP_HOST
>>> +	struct system_time_snapshot systime_snapshot;
>>> +	u64 cycles = 0;
>>> +#endif
>>>    	u32 func_id = smccc_get_function(vcpu);
>>>    	u32 val[4] = {SMCCC_RET_NOT_SUPPORTED};
>>>    	u32 feature;
>>> @@ -70,7 +75,52 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>>>    		break;
>>>    	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
>>>    		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
>>> +
>>> +#ifdef CONFIG_ARM64_KVM_PTP_HOST
>>> +		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_KVM_PTP); #endif
>>> +		break;
>>> +
>>> +#ifdef CONFIG_ARM64_KVM_PTP_HOST
>>> +	/*
>>> +	 * This serves virtual kvm_ptp.
>>> +	 * Four values will be passed back.
>>> +	 * reg0 stores high 32-bit host ktime;
>>> +	 * reg1 stores low 32-bit host ktime;
>>> +	 * reg2 stores high 32-bit difference of host cycles and cntvoff;
>>> +	 * reg3 stores low 32-bit difference of host cycles and cntvoff.
>>> +	 */
>>> +	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
>>> +		/*
>>> +		 * system time and counter value must captured in the same
>>> +		 * time to keep consistency and precision.
>>> +		 */
>>> +		ktime_get_snapshot(&systime_snapshot);
>>> +		if (systime_snapshot.cs_id != CSID_ARM_ARCH_COUNTER)
>>> +			break;
>>> +		val[0] = upper_32_bits(systime_snapshot.real);
>>> +		val[1] = lower_32_bits(systime_snapshot.real);
>>> +		/*
>>> +		 * which of virtual counter or physical counter being
>>> +		 * asked for is decided by the first argument of smccc
>>> +		 * call. If no first argument or invalid argument, zero
>>> +		 * counter value will return;
>>> +		 */
>>
>> It's not actually possible to have "no first argument" - there's no argument
>> count, so whatever is in the register during the call with be passed. I'd also
>> caution that "first argument" is ambigious: r0 could be the 'first' but is also the
>> function number, here you mean r1.
>>
> Sorry,  I really make mistake here, I really mean no r1 value.

My point is that it's not possible to have "no r1 value" - r1 always has 
a value. So you can have an "invalid argument" (r1 has a value which 
isn't valid), but it's not possible to have "no first argument". It 
would only be possible to have no argument if the interface told us how 
many arguments were valid, but SMCCC doesn't do that.

>> There's also a subtle cast to 32 bits here (feature is u32), which might be
>> worth a comment before someone 'optimises' by removing the 'feature'
>> variable.
>>
> Yeah, it's better to add a note, but I think it's better add it at the first time calling smccc_get_arg1.
> WDYT?

I'm a bit confused about where exactly you were suggesting. The 
assignment (and implicit cast) are just below, so this comment block 
seemed a sensible place to add the note. But I don't really mind exactly 
where you put it (as long as it's close), it's just a subtle detail that 
might get lost if there isn't a comment.

>> Finally I'm not sure if zero counter value is best - would it not be possible for
>> this to be a valid counter value?
> 
> We have two different ways to call this service in ptp_kvm guest, one needs counter cycle,  the other
> not. So I think it's vain to return a valid counter cycle back if the ptp_kvm does not needs it.

Sorry, I didn't write that very clearly. What I meant is that returning 
'0' in the case of an invalid argument might be difficult to recognise. 
'0' may be a valid reading of a counter (e.g. reading the counter just 
after the VM has been created if the counter increments very slowly). So 
it may be worth using a different value when an invalid argument has 
been specified. E.g. an "all ones" (-1) value may be more recognisable.

In practice most counters increment fast enough that this may not 
actually be an issue, but this sort of thing is a pain to fix if it 
becomes a problem in the future.

>>
>>> +		feature = smccc_get_arg1(vcpu);
>>> +		switch (feature) {
>>> +		case ARM_PTP_VIRT_COUNTER:
>>> +			cycles = systime_snapshot.cycles -
>>> +			vcpu_vtimer(vcpu)->cntvoff;
>>
>> Please indent the continuation line so that it's obvious.
> Ok,
> 
>>
>>> +			break;
>>> +		case ARM_PTP_PHY_COUNTER:
>>> +			cycles = systime_snapshot.cycles;
>>> +			break;
>>> +		}
>>> +		val[2] = upper_32_bits(cycles);
>>> +		val[3] = lower_32_bits(cycles);
>>>    		break;
>>> +#endif
>>> +
>>>    	default:
>>>    		return kvm_psci_call(vcpu);
>>>    	}
>>> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
>>> index 86ff30131e7b..e593ec515f82 100644
>>> --- a/include/linux/arm-smccc.h
>>> +++ b/include/linux/arm-smccc.h
>>> @@ -98,6 +98,9 @@
>>>
>>>    /* KVM "vendor specific" services */
>>>    #define ARM_SMCCC_KVM_FUNC_FEATURES		0
>>> +#define ARM_SMCCC_KVM_FUNC_KVM_PTP		1
>>> +#define ARM_SMCCC_KVM_FUNC_KVM_PTP_PHY		2
>>> +#define ARM_SMCCC_KVM_FUNC_KVM_PTP_VIRT		3
>>>    #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
>>>    #define ARM_SMCCC_KVM_NUM_FUNCS			128
>>>
>>> @@ -107,6 +110,33 @@
>>>    			   ARM_SMCCC_OWNER_VENDOR_HYP,
>> 		\
>>>    			   ARM_SMCCC_KVM_FUNC_FEATURES)
>>>
>>> +/*
>>> + * kvm_ptp is a feature used for time sync between vm and host.
>>> + * kvm_ptp module in guest kernel will get service from host using
>>> + * this hypercall ID.
>>> + */
>>> +#define ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID
>> 		\
>>> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,
>> 		\
>>> +			   ARM_SMCCC_SMC_32,
>> 	\
>>> +			   ARM_SMCCC_OWNER_VENDOR_HYP,
>> 		\
>>> +			   ARM_SMCCC_KVM_FUNC_KVM_PTP)
>>> +
>>> +/*
>>> + * kvm_ptp may get counter cycle from host and should ask for which
>>> +of
>>> + * physical counter or virtual counter by using ARM_PTP_PHY_COUNTER
>>> +and
>>> + * ARM_PTP_VIRT_COUNTER explicitly.
>>> + */
>>> +#define ARM_PTP_PHY_COUNTER
>> 	\
>>> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,
>> 		\
>>> +			   ARM_SMCCC_SMC_32,
>> 	\
>>> +			   ARM_SMCCC_OWNER_VENDOR_HYP,
>> 		\
>>> +			   ARM_SMCCC_KVM_FUNC_KVM_PTP_PHY)
>>> +
>>> +#define ARM_PTP_VIRT_COUNTER
>> 	\
>>> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,
>> 		\
>>> +			   ARM_SMCCC_SMC_32,
>> 	\
>>> +			   ARM_SMCCC_OWNER_VENDOR_HYP,
>> 		\
>>> +			   ARM_SMCCC_KVM_FUNC_KVM_PTP_VIRT)
>>
>> These two are not SMCCC calls themselves (just parameters to an SMCCC),
>> so they really shouldn't be defined using ARM_SMCCC_CALL_VAL (it's just
>> confusing and unnecessary). Can we not just pick small integers (e.g. 0 and 1)
>> for these?
>>
> Yeah, I think so, it's better to define these parameters ID as single number and not related to
> SMCCC. What about keep these 2 macros and define it directly as a number in include/linux/arm-smccc.h.

Yes that sounds good.

>> We also need some documentation of these SMCCC calls somewhere which
>> would make this sort of review easier. For instance for paravirtualised stolen
>> time there is Documentation/virt/kvm/arm/pvtime.rst (which also links to
>> the published document from Arm).
>>
> Good point, a documentation is needed to explain these new SMCCC funcs.
> Do you think we should do that in this patch serial? Does it beyond the scope of this patch set?

Adding it in this patch series seems like the right place to me.

Thanks,

Steve
