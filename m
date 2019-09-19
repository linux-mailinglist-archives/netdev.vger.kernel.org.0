Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7854EB7897
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 13:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389973AbfISLjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 07:39:10 -0400
Received: from foss.arm.com ([217.140.110.172]:56598 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388331AbfISLjK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 07:39:10 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7AEB428;
        Thu, 19 Sep 2019 04:39:09 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5A7303F67D;
        Thu, 19 Sep 2019 04:39:07 -0700 (PDT)
Subject: Re: [RFC PATCH v3 4/6] psci: Add hvc call service for ptp_kvm.
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        "Kaly Xin (Arm Technology China)" <Kaly.Xin@arm.com>,
        "Justin He (Arm Technology China)" <Justin.He@arm.com>,
        nd <nd@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <20190918080716.64242-1-jianyong.wu@arm.com>
 <20190918080716.64242-5-jianyong.wu@arm.com>
 <83ed7fac-277f-a31e-af37-8ec134f39d26@redhat.com>
 <HE1PR0801MB1676F57B317AE85E3B934B32F48E0@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <629538ea-13fb-e666-8df6-8ad23f114755@redhat.com>
 <HE1PR0801MB167639E2F025998058A77F86F4890@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <ef6ab8bd-41ad-88f8-9cfd-dc749ca65310@redhat.com>
From:   Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <a1b554b8-4417-5305-3419-fe71a8c50842@kernel.org>
Date:   Thu, 19 Sep 2019 12:39:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <ef6ab8bd-41ad-88f8-9cfd-dc749ca65310@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/09/2019 12:07, Paolo Bonzini wrote:
> On 19/09/19 11:46, Jianyong Wu (Arm Technology China) wrote:
>>> On 18/09/19 11:57, Jianyong Wu (Arm Technology China) wrote:
>>>> Paolo Bonzini wrote:
>>>>> This is not Y2038-safe.  Please use ktime_get_real_ts64 instead, and
>>>>> split the 64-bit seconds value between val[0] and val[1].
>>
>> Val[] should be long not u32 I think, so in arm64 I can avoid that Y2038_safe, but
>> also need rewrite for arm32.
> 
> I don't think there's anything inherently wrong with u32 val[], and as
> you notice it lets you reuse code between arm and arm64.  It's up to you
> and Marc to decide.
> 
>>>>> However, it seems to me that the new function is not needed and you
>>>>> can just use ktime_get_snapshot.  You'll get the time in
>>>>> systime_snapshot->real and the cycles value in systime_snapshot->cycles.
>>>>
>>>> See patch 5/6, I need both counter cycle and clocksource,
>>> ktime_get_snapshot seems only offer cycles.
>>>
>>> No, patch 5/6 only needs the current clock (ptp_sc.cycles is never accessed).
>>> So you could just use READ_ONCE(tk->tkr_mono.clock).
>>>
>> Yeah, patch 5/6 just need clocksource, but I think tk->tkr_mono.clock can't read in external like module,
>> So I need an API to expose clocksource.
>>  
>>> However, even then I don't think it is correct to use ptp_sc.cs blindly in patch
>>> 5.  I think there is a misunderstanding on the meaning of
>>> system_counterval.cs as passed to get_device_system_crosststamp.
>>> system_counterval.cs is not the active clocksource; it's the clocksource on
>>> which system_counterval.cycles is based.
>>>
>>
>> I think we can use system_counterval_t as pass current clocksource to system_counterval_t.cs and its
>> corresponding cycles to system_counterval_t.cycles. is it a big problem?
> 
> Yes, it is.  Because...
> 
>>> Hypothetically, the clocksource could be one for which ptp_sc.cycles is _not_
>>> a cycle value.  If you set system_counterval.cs to the system clocksource,
>>> get_device_system_crosststamp will return a bogus value.
>>
>> Yeah, but in patch 3/6, we have a corresponding pair of clock source and cycle value. So I think there will be no
>> that problem in this patch set.
>> In the implementation of get_device_system_crosststamp:
>> "
>> ...
>> if (tk->tkr_mono.clock != system_counterval.cs)
>>                         return -ENODEV;
>> ...
>> "
>> We need tk->tkr_mono.clock passed to get_device_system_crosststamp, just like patch 3/6 do, otherwise will return error.
> 
> ... if the hypercall returns an architectural timer value, you must not
> pass tk->tkr.mono.clock to get_device_system_crosststamp: you must pass
> &clocksource_counter.  This way, PTP is disabled when using any other
> clocksource.
> 
>>> So system_counterval.cs should be set to something like
>>> &clocksource_counter (from drivers/clocksource/arm_arch_timer.c).
>>> Perhaps the right place to define kvm_arch_ptp_get_clock_fn is in that file?
>>>
>> I have checked that ptp_sc.cs is arch_sys_counter.
>> Also move the module API to arm_arch_timer.c will looks a little
>> ugly and it's not easy to be accept by arm side I think.
> 
> I don't think it's ugly but more important, using tk->tkr_mono.clock is
> incorrect.  See how the x86 code hardcodes &kvm_clock, it's the same for
> ARM.

Not really. The guest kernel is free to use any clocksource it wishes.
In some cases, it is actually desirable (like these broken systems that
cannot use an in-kernel irqchip...). Maybe it is that on x86 the guest
only uses the kvm_clock, but that's a much harder sell on ARM. The fact
that ptp_kvm assumes that the clocksource is fixed doesn't seem correct
in that case.

	M.
-- 
Jazz is not dead, it just smells funny...
