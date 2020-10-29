Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B7729E698
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 09:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727735AbgJ2Ims (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 04:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbgJ2Ims (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 04:42:48 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E91C0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 01:42:47 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id k18so1605881wmj.5
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 01:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ByEnfQ9p6htMN5uVO47E7lMDFYeuY/wDCJ4OcZ3c9i8=;
        b=PqiIa3XupI7Hh4+4ipTIPqqmxJ69797EecfjlOgOiQLFjwz/w4tCoN/30B9dtcoJJL
         ON+7w5TjTt2M1v6iRQ70i1x6dkVfrBhuHSYsGnGFhqD7MPP6mjUW+rN239rzv1NMROHo
         tVjFqgt3XjgE5xAfH5covnDkL91k4Yrv4hYwvTI1orhcD4bt92XeOaooLNY1wCUGtSbx
         053e9rJFs443GfDgfN4k9hjPL9hbLKlaLcxoEiKEJqx4h6iAe/q972AbPmsdToD+G00W
         CVpODAZHgFhupcI7QJTjwHPTpPKqF5aKknLAGkfOS9k9PCZsEREgtGlK8r9Jl6IVpQGm
         5jLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ByEnfQ9p6htMN5uVO47E7lMDFYeuY/wDCJ4OcZ3c9i8=;
        b=JzntHMM9v5zbjGn3QnWkUmJvEJ6MV4v8aUpAVkAMiuVmvbV5sNqG4ZIcrwwuDFbny0
         Yqa/hXL2tRu4qZvVNdY0V90tEH+Cff9mtG67+CZ+5dJeVeXfVrxflBIzH3R11c7ezCC6
         wWO0Tli2tYchb0gSjjRVsA45NcV86d9r+S+rxb+bOp7xMr8EdsbEXGFH+4whhEXNISjS
         5UZC6UFyZh9r/13SDoPGlEeHv4K1n0/ysb+MlEU7Vxl3jctFHqbejiR4L1bEuATAlW+d
         girSf4mYz7GsQFGOr49dJ23AU+/3SAZU4FTECT5ckyfHHUSCDfzR606LSLJ/mgymwPlk
         7i9Q==
X-Gm-Message-State: AOAM5310iJoM4Omt2SMCT8nxbgBaASIytCAy1LzbnU+DJ0UfLwgV7EJ1
        8zLldaTnsRr1MOIqQwXeNZORCqIFb0Y=
X-Google-Smtp-Source: ABdhPJwPXSryd0vuHSeXOZYi7kO3bKx8Eu4/dKMvcCH3q2Ud8gZ2ZPFVEa0HNyzc0+TK/2Dkpm/LQQ==
X-Received: by 2002:a1c:7e4e:: with SMTP id z75mr3088514wmc.55.1603960966448;
        Thu, 29 Oct 2020 01:42:46 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:c8fb:cb3e:2952:c247? (p200300ea8f232800c8fbcb3e2952c247.dip0.t-ipconnect.de. [2003:ea:8f23:2800:c8fb:cb3e:2952:c247])
        by smtp.googlemail.com with ESMTPSA id 14sm3109480wmf.27.2020.10.29.01.42.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 01:42:46 -0700 (PDT)
Subject: Re: [PATCH net] r8169: fix operation under forced interrupt threading
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Serge Belyshev <belyshev@depni.sinp.msu.ru>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <4d3ef84a-c812-5072-918a-22a6f6468310@gmail.com>
 <877drabmoq.fsf@depni.sinp.msu.ru>
 <f0d713d2-6dc4-5246-daca-54811825e064@gmail.com>
 <20201028162929.5f250d12@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <a37b2cdf-97c4-8d13-2a49-d4f8c0b43f04@gmail.com>
Date:   Thu, 29 Oct 2020 09:42:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201028162929.5f250d12@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.10.2020 00:29, Jakub Kicinski wrote:
> On Wed, 28 Oct 2020 13:17:58 +0100 Heiner Kallweit wrote:
>> On 28.10.2020 12:43, Serge Belyshev wrote:
>>>> For several network drivers it was reported that using
>>>> __napi_schedule_irqoff() is unsafe with forced threading. One way to
>>>> fix this is switching back to __napi_schedule, but then we lose the
>>>> benefit of the irqoff version in general. As stated by Eric it doesn't
>>>> make sense to make the minimal hard irq handlers in drivers using NAPI
>>>> a thread. Therefore ensure that the hard irq handler is never
>>>> thread-ified.
>>>>
>>>> Fixes: 9a899a35b0d6 ("r8169: switch to napi_schedule_irqoff")
>>>> Link: https://lkml.org/lkml/2020/10/18/19
>>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>>> ---
>>>>  drivers/net/ethernet/realtek/r8169_main.c | 8 ++++----
>>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>>>> index 7d366b036..3b6ddc706 100644
>>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c  
>>> ...
>>>
>>> Hi!  This patch actually breaks r8169 with threadirqs on an old box
>>> where it was working before:
>>>
>>> [    0.000000] DMI: Gigabyte Technology Co., Ltd. GA-MA790FX-DQ6/GA-MA790FX-DQ6, BIOS F7g 07/19/2010
>>> ...
>>> [    1.072676] r8169 0000:02:00.0 eth0: RTL8168b/8111b, 00:1a:4d:5d:6b:c3, XID 380, IRQ 18
>>> ...
>>> [    8.850099] genirq: Flags mismatch irq 18. 00010080 (eth0) vs. 00002080 (ahci[0000:05:00.0])
>>>
>>> (error is reported to userspace, interface failed to bring up).
>>> Reverting the patch fixes the problem.
>>>   
>> Thanks for the report. On this old chip version MSI is unreliable,
>> therefore r8169 falls back to a PCI legacy interrupt. On your system
>> this PCI legacy interrupt seems to be shared between network and
>> disk. Then the IRQ core tries to threadify the disk interrupt
>> (setting IRQF_ONESHOT), whilst the network interrupt doesn't have
>> this flag set. This results in the flag mismatch error.
>>
>> Maybe, if one source of a shared interrupt doesn't allow forced
>> threading, this should be applied to the other sources too.
>> But this would require a change in the IRQ core, therefore
>> +Thomas to get his opinion on the issue.
> 
> Other handles may take spin_locks, which will sleep on RT.
> 
> I guess we may need to switch away from the _irqoff() variant for
> drivers with IRQF_SHARED after all :(
> 
Right. Unfortunately that's a large number of drivers,
e.g. pci_request_irq() sets IRQF_SHARED in general.
But at least for now there doesn't seem to be a better way to deal
with the challenges imposed by forced threading and shared irqs.
