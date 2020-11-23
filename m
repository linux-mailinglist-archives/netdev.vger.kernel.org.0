Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC5452C0524
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 13:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbgKWL7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 06:59:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:56526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729277AbgKWL7N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 06:59:13 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 368802076E;
        Mon, 23 Nov 2020 11:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606132752;
        bh=SNzmc2sgfjK6RMMu/GL0rJxigW65dyO8WaugKYy1Ed4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HQQpseAIMOO0IZb4YiComOvdilzhwi7IJMFaJHJk7huXj7OGXw6ILYx117GWvUA13
         /KeJ8/5AgMzifF6/kwnF4ABjF+D92ZqMB+gPby5nu1oYUfLLF18DPYlSbZmowyanA/
         qETj81GnR39/kacyhwt/ZzX7XQeUcwXitxywMDIU=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1khAUw-00Cu3B-03; Mon, 23 Nov 2020 11:59:10 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 23 Nov 2020 11:59:09 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Jianyong Wu <jianyong.wu@arm.com>
Cc:     justin.he@arm.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        richardcochran@gmail.com, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, steven.price@arm.com,
        Andre.Przywara@arm.com, john.stultz@linaro.org, yangbo.lu@nxp.com,
        pbonzini@redhat.com, tglx@linutronix.de, nd@arm.com,
        will@kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v15 6/9] arm64/kvm: Add hypercall service for kvm ptp.
In-Reply-To: <d409aa1cb7cfcbf4351e6c5fc34d9c7e@kernel.org>
References: <20201111062211.33144-1-jianyong.wu@arm.com>
 <20201111062211.33144-7-jianyong.wu@arm.com>
 <d409aa1cb7cfcbf4351e6c5fc34d9c7e@kernel.org>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <276428d3d291f703e2f0c2c323194e98@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: jianyong.wu@arm.com, justin.he@arm.com, kvm@vger.kernel.org, netdev@vger.kernel.org, richardcochran@gmail.com, linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com, steven.price@arm.com, Andre.Przywara@arm.com, john.stultz@linaro.org, yangbo.lu@nxp.com, pbonzini@redhat.com, tglx@linutronix.de, nd@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-23 10:44, Marc Zyngier wrote:
> On 2020-11-11 06:22, Jianyong Wu wrote:
>> ptp_kvm will get this service through SMCC call.
>> The service offers wall time and cycle count of host to guest.
>> The caller must specify whether they want the host cycle count
>> or the difference between host cycle count and cntvoff.
>> 
>> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
>> ---
>>  arch/arm64/kvm/hypercalls.c | 61 
>> +++++++++++++++++++++++++++++++++++++
>>  include/linux/arm-smccc.h   | 17 +++++++++++
>>  2 files changed, 78 insertions(+)
>> 
>> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
>> index b9d8607083eb..f7d189563f3d 100644
>> --- a/arch/arm64/kvm/hypercalls.c
>> +++ b/arch/arm64/kvm/hypercalls.c
>> @@ -9,6 +9,51 @@
>>  #include <kvm/arm_hypercalls.h>
>>  #include <kvm/arm_psci.h>
>> 
>> +static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
>> +{
>> +	struct system_time_snapshot systime_snapshot;
>> +	u64 cycles = ~0UL;
>> +	u32 feature;
>> +
>> +	/*
>> +	 * system time and counter value must captured in the same
>> +	 * time to keep consistency and precision.
>> +	 */
>> +	ktime_get_snapshot(&systime_snapshot);
>> +
>> +	// binding ptp_kvm clocksource to arm_arch_counter
>> +	if (systime_snapshot.cs_id != CSID_ARM_ARCH_COUNTER)
>> +		return;
>> +
>> +	val[0] = upper_32_bits(systime_snapshot.real);
>> +	val[1] = lower_32_bits(systime_snapshot.real);
> 
> What is the endianness of these values? I can't see it defined
> anywhere, and this is likely not to work if guest and hypervisor
> don't align.

Scratch that. This is all passed via registers, so the endianness
of the data is irrelevant. Please discard any comment about endianness
I made in this review.

The documentation aspect still requires to be beefed up.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
