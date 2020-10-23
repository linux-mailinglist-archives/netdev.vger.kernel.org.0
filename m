Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAE12977A3
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 21:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751912AbgJWTWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 15:22:18 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:47490 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750821AbgJWTWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 15:22:17 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 09NJLwtd017969;
        Fri, 23 Oct 2020 14:21:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1603480918;
        bh=Htvmso5Exfy0aVjyQ1Scu+QqaW7L8R2426oXukUsxkE=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=nhXvbCVNrkgDgNl7nYLgFQeQQ2reg2wUFJoh9r3ReVKhD8TsMDDvT0mguF+70AYiH
         vMBpcQvWjGEyz4s1ubT+MCN7lvXA/1XJuy1Yd7Xf6Ipll8Q6nP0EHNuzR+uDhIKjRp
         QQ9h48A6MgEL9gn/N4iuc3lA9I38oduXzJIDPPng=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 09NJLwFG055091
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 23 Oct 2020 14:21:58 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 23
 Oct 2020 14:21:57 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 23 Oct 2020 14:21:57 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 09NJLsaj025751;
        Fri, 23 Oct 2020 14:21:55 -0500
Subject: Re: Remove __napi_schedule_irqoff?
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <01af7f4f-bd05-b93e-57ad-c2e9b8726e90@gmail.com>
 <20201017162949.0a6dd37a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89i+q=q_LNDzE23y74Codh5EY0HHi_tROsEL2yJAdRjh-vQ@mail.gmail.com>
 <668a1291-e7f0-ef71-c921-e173d4767a14@gmail.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <00036150-6e58-7b47-398a-902a24c0e3c1@ti.com>
Date:   Fri, 23 Oct 2020 22:21:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <668a1291-e7f0-ef71-c921-e173d4767a14@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18/10/2020 11:20, Heiner Kallweit wrote:
> On 18.10.2020 10:02, Eric Dumazet wrote:
>> On Sun, Oct 18, 2020 at 1:29 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>>
>>> On Sat, 17 Oct 2020 15:45:57 +0200 Heiner Kallweit wrote:
>>>> When __napi_schedule_irqoff was added with bc9ad166e38a
>>>> ("net: introduce napi_schedule_irqoff()") the commit message stated:
>>>> "Many NIC drivers can use it from their hard IRQ handler instead of
>>>> generic variant."
>>>
>>> Eric, do you think it still matters? Does it matter on x86?
>>>
>>>> It turned out that this most of the time isn't safe in certain
>>>> configurations:
>>>> - if CONFIG_PREEMPT_RT is set
>>>> - if command line parameter threadirqs is set
>>>>
>>>> Having said that drivers are being switched back to __napi_schedule(),
>>>> see e.g. patch in [0] and related discussion. I thought about a
>>>> __napi_schedule version checking dynamically whether interrupts are
>>>> disabled. But checking e.g. variable force_irqthreads also comes at
>>>> a cost, so that we may not see a benefit compared to calling
>>>> local_irq_save/local_irq_restore.
>>>>
>>>> If more or less all users have to switch back, then the question is
>>>> whether we should remove __napi_schedule_irqoff.
>>>> Instead of touching all users we could make  __napi_schedule_irqoff
>>>> an alias for __napi_schedule for now.
>>>>
>>>> [0] https://lkml.org/lkml/2020/10/8/706
>>>
>>> We're effectively calling raise_softirq_irqoff() from IRQ handlers,
>>> with force_irqthreads == true that's no longer legal.
>>>
>>> Thomas - is the expectation that IRQ handlers never assume they have
>>> IRQs disabled going forward? We don't have any performance numbers
>>> but if I'm reading Agner's tables right POPF is 18 cycles on Broadwell.
>>> Is PUSHF/POPF too cheap to bother?
>>>
>>> Otherwise a non-solution could be to make IRQ_FORCED_THREADING
>>> configurable.
>>
>> I have to say I do not understand why we want to defer to a thread the
>> hard IRQ that we use in NAPI model.
>>
> Seems like the current forced threading comes with the big hammer and
> thread-ifies all hard irq's. To avoid this all NAPI network drivers
> would have to request the interrupt with IRQF_NO_THREAD.

I did some work in this area for TI drivers long time ago, just FYI
https://patchwork.kernel.org/project/linux-omap/patch/20160811161540.9613-1-grygorii.strashko@ti.com/
but, not re-checked it with more recent RT Kernels.

> 
>> Whole point of NAPI was to keep hard irq handler very short.
>>
>> We should focus on transferring the NAPI work (potentially disrupting
>> ) to a thread context, instead of the very minor hard irq trigger.
>>
> 

-- 
Best regards,
grygorii
