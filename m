Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E68C37A32C
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 11:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhEKJOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 05:14:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231318AbhEKJOM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 05:14:12 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D04616157F;
        Tue, 11 May 2021 09:13:05 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lgORr-000doA-Os; Tue, 11 May 2021 10:13:03 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 11 May 2021 10:13:03 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     jianyong.wu@arm.com, netdev <netdev@vger.kernel.org>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com,
        Richard Cochran <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andre Przywara <Andre.Przywara@arm.com>,
        Steven Price <steven.price@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, KVM list <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>, justin.he@arm.com,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH v19 7/7] ptp: arm/arm64: Enable ptp_kvm for arm/arm64
In-Reply-To: <CAMuHMdWd5261ti-zKsroFLvWs0abaWa7G4DKefgPwFb3rEjnNw@mail.gmail.com>
References: <20210330145430.996981-1-maz@kernel.org>
 <20210330145430.996981-8-maz@kernel.org>
 <CAMuHMdWd5261ti-zKsroFLvWs0abaWa7G4DKefgPwFb3rEjnNw@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <6c522f8116f54fa6f23a2d217d966c5a@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: geert@linux-m68k.org, jianyong.wu@arm.com, netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de, pbonzini@redhat.com, seanjc@google.com, richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com, Andre.Przywara@arm.com, steven.price@arm.com, lorenzo.pieralisi@arm.com, sudeep.holla@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Steve.Capper@arm.com, justin.he@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

On 2021-05-11 10:07, Geert Uytterhoeven wrote:
> Hi Marc, Jianyong,
> 
> On Tue, Mar 30, 2021 at 4:56 PM Marc Zyngier <maz@kernel.org> wrote:
>> From: Jianyong Wu <jianyong.wu@arm.com>
>> 
>> Currently, there is no mechanism to keep time sync between guest and 
>> host
>> in arm/arm64 virtualization environment. Time in guest will drift 
>> compared
>> with host after boot up as they may both use third party time sources
>> to correct their time respectively. The time deviation will be in 
>> order
>> of milliseconds. But in some scenarios,like in cloud environment, we 
>> ask
>> for higher time precision.
>> 
>> kvm ptp clock, which chooses the host clock source as a reference
>> clock to sync time between guest and host, has been adopted by x86
>> which takes the time sync order from milliseconds to nanoseconds.
>> 
>> This patch enables kvm ptp clock for arm/arm64 and improves clock sync 
>> precision
>> significantly.
> 
>> --- a/drivers/ptp/Kconfig
>> +++ b/drivers/ptp/Kconfig
>> @@ -108,7 +108,7 @@ config PTP_1588_CLOCK_PCH
>>  config PTP_1588_CLOCK_KVM
>>         tristate "KVM virtual PTP clock"
>>         depends on PTP_1588_CLOCK
>> -       depends on KVM_GUEST && X86
>> +       depends on (KVM_GUEST && X86) || (HAVE_ARM_SMCCC_DISCOVERY && 
>> ARM_ARCH_TIMER)
> 
> Why does this not depend on KVM_GUEST on ARM?
> I.e. shouldn't the dependency be:
> 
>     KVM_GUEST && (X86 || (HAVE_ARM_SMCCC_DISCOVERY && ARM_ARCH_TIMER))
> 
> ?

arm/arm64 do not select KVM_GUEST. Any kernel can be used for a guest,
and KVM/arm64 doesn't know about this configuration symbol.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
