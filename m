Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42ACF1E2052
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 13:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388767AbgEZLCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 07:02:07 -0400
Received: from foss.arm.com ([217.140.110.172]:49256 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388704AbgEZLCG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 07:02:06 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C65A931B;
        Tue, 26 May 2020 04:02:05 -0700 (PDT)
Received: from [192.168.1.84] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 18D213F6C4;
        Tue, 26 May 2020 04:02:02 -0700 (PDT)
Subject: Re: [RFC PATCH v12 07/11] psci: Add hypercall service for kvm ptp.
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
References: <20200522083724.38182-1-jianyong.wu@arm.com>
 <20200522083724.38182-8-jianyong.wu@arm.com>
 <87fce07b-d0f5-47b0-05ce-dd664ce53eec@arm.com>
 <HE1PR0802MB2555A66F063927D5B855E1C6F4B30@HE1PR0802MB2555.eurprd08.prod.outlook.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <d7ec2534-95e4-ae79-fc53-4d48a4ea628c@arm.com>
Date:   Tue, 26 May 2020 12:02:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <HE1PR0802MB2555A66F063927D5B855E1C6F4B30@HE1PR0802MB2555.eurprd08.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/05/2020 03:11, Jianyong Wu wrote:
> Hi Steven,

Hi Jianyong,

[...]>>> diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
>>> index db6dce3d0e23..c964122f8dae 100644
>>> --- a/virt/kvm/arm/hypercalls.c
>>> +++ b/virt/kvm/arm/hypercalls.c
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
>>> +	u64 cycles;
>>> +#endif
>>>    	u32 func_id = smccc_get_function(vcpu);
>>>    	u32 val[4] = {SMCCC_RET_NOT_SUPPORTED};
>>>    	u32 feature;
>>> @@ -70,7 +75,49 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>>>    		break;
>>>    	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
>>>    		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
>>> +
>>> +#ifdef CONFIG_ARM64_KVM_PTP_HOST
>>> +		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_KVM_PTP); #endif
>>>    		break;
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
>>> +		 * asked for is decided by the first argument.
>>> +		 */
>>> +		feature = smccc_get_arg1(vcpu);
>>> +		switch (feature) {
>>> +		case ARM_SMCCC_VENDOR_HYP_KVM_PTP_PHY_FUNC_ID:
>>> +			cycles = systime_snapshot.cycles;
>>> +			break;
>>> +		default:
>>
>> There's something a bit odd here.
>>
>> ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID and
>> ARM_SMCCC_VENDOR_HYP_KVM_PTP_PHY_FUNC_ID look like they should
>> be names of separate (top-level) functions, but actually the _PHY_ one is a
>> parameter for the first. If the intention is to have a parameter then it would
>> be better to pick a better name for the _PHY_ define and not define it using
>> ARM_SMCCC_CALL_VAL.
>>
> Yeah, _PHY_ is not the same meaning with _PTP_FUNC_ID,  so I think it should be a different name.
> What about ARM_SMCCC_VENDOR_HYP_KVM_PTP_PHY_COUNTER?

Personally I'd go with something much shorter, e.g. ARM_PTP_PHY_COUNTER. 
This is just an argument to an SMCCC call so there's no need for most of 
the prefix, indeed if (for whatever reason) there was a non-SMCCC 
mechanism added to do the same thing it would be reasonable to reuse the 
same values.

>> Second the use of "default:" means that there's no possibility to later extend
>> this interface for more clocks if needed in the future.
>>
> I think we can add more clocks by adding more cases, this "default" means we can use no first arg to determine the default clock.

The problem with the 'default' is it means it's not possible to probe 
whether the kernel supports any more clocks. If we used a different 
value (that the kernel doesn't support) then we end up in the default 
case and have no idea whether the clock value is the one we requested or 
not.

It's generally better when defining an ABI to explicitly return an error 
for unknown parameters, that way a future user of the ABI can discover 
whether the call did what was expected or not.

>> Alternatively you could indeed implement as two top-level functions and
>> change this to a...
>>
>> 	switch (func_id)
>>
>> ... along with multiple case labels as the functions would obviously be mostly
>> the same.
>>
>> Also a minor style issue - you might want to consider splitting this into it's
>> own function.
>>
> I think "switch (feature)" maybe better as this _PHY_ is not like a function id. Just like:
> "
> case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
>                  feature = smccc_get_arg1(vcpu);
>                  switch (feature) {
>                  case ARM_SMCCC_ARCH_WORKAROUND_1:
> ...
> "

I'm happy either way - it's purely that the definition/naming of 
ARM_SMCCC_VENDOR_HYP_KVM_PTP_PHY_FUNC_ID made it look like that was the 
intention. My preference would be to stick with the 'feature' approach 
as above because there's no need to "use up" the top-level SMCCC calls 
(but equally there's a large space so we'd have to work very hard to run 
out... ;) )

>> Finally I do think it would be useful to add some documentation of the new
>> SMC calls. It would be easier to review the interface based on that
>> documentation rather than trying to reverse-engineer the interface from the
>> code.
>>
> Yeah, more doc needed here.

Thanks, I think it's a good idea to get the ABI nailed down before 
worrying too much about the code, and it's easier to discuss based on 
documentation rather than code.

Thanks,

Steve
