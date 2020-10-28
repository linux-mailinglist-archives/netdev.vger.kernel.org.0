Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8347429D9F6
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbgJ1XI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgJ1XIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 19:08:06 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71DE7C0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 16:08:05 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id g25so404840edm.6
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 16:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bQJAs4LY7bNygHAiq5I/EeDRUHh+RF0G60QKLvgYYc0=;
        b=Tyn3o7fbO2B76u0a7/xUeaGmCPzYPaPExndqQ0PdwY4MLFLlzbqhsKUIa9Pfy/jkiN
         ks2LHdXPwG9+t5BoQSuSVNL4NKkRxhYyQR23iBVdUz2/aiJjTezHUr34k9vv+uS17EvH
         SxwbTlGmdm5ZocJd4YhlPQRktN4U7GdwI7wT850BjCT6hfQFWBRh5tqq40yWwVFZ4rtA
         hubU/2L2T0CS9fFRmvjU8sQXg3fNhaupPK1xKGPBHiXS+4M02lGMHNEMxODZxULoJRB/
         Iqn41wDRx/pah49ZsJTLJWr1sj6vbasnuAbCqdGVG4rI1VQmslDHhjHFgeFtUNcauj32
         oBtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bQJAs4LY7bNygHAiq5I/EeDRUHh+RF0G60QKLvgYYc0=;
        b=eSBjJSK7QL86GDB5qPddQBgy6R0/lTvpZ9vK4TKSwGBFq5h73Ckr7/JaQUjWI/mv23
         DQIpbzRvMHKnekH0S+UpCjt/z3mTBw34AQLEbZw7pm6Cwo+ARlDOA6EPlLJe/DA2d6M+
         HdgTx9CgmN7pU4v/1SM3cllsV25Ux18zJvU2u2oE5hqmSyYWdD39+1hnxJ/7oztzMmyK
         BPV8ZjXZzpWjHajDMly10P7Xg6ztxYntNjHW2Qf9WHZ3Ak9bzYxOvhYezc2uasRoMIoG
         9EYBrcW3jGIRNvVgsKnrcxt7JyBa1hmJx1ZoL6EoHFHkN2KCUxzw9OOetLgiORJZrrdz
         5lKg==
X-Gm-Message-State: AOAM533WUHbuqs6buxFNFG5olNdcS0oCIRPvykNC/1rNGOYSMQLcvYbz
        ncLzvimjNx5YCYABsUga+k5O60sfyOU=
X-Google-Smtp-Source: ABdhPJxKsjthVwtHTIEa3Rh0qBzA5+9XY8T4VdCAawXpSm94MDUifPgegx8xaVATizxdLrfmJTne9w==
X-Received: by 2002:a05:6402:b72:: with SMTP id cb18mr7232034edb.129.1603887486242;
        Wed, 28 Oct 2020 05:18:06 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:7833:37d2:8d24:4d07? (p200300ea8f232800783337d28d244d07.dip0.t-ipconnect.de. [2003:ea:8f23:2800:7833:37d2:8d24:4d07])
        by smtp.googlemail.com with ESMTPSA id ks17sm2855403ejb.41.2020.10.28.05.18.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 05:18:05 -0700 (PDT)
Subject: Re: [PATCH net] r8169: fix operation under forced interrupt threading
To:     Serge Belyshev <belyshev@depni.sinp.msu.ru>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <4d3ef84a-c812-5072-918a-22a6f6468310@gmail.com>
 <877drabmoq.fsf@depni.sinp.msu.ru>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <f0d713d2-6dc4-5246-daca-54811825e064@gmail.com>
Date:   Wed, 28 Oct 2020 13:17:58 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <877drabmoq.fsf@depni.sinp.msu.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.10.2020 12:43, Serge Belyshev wrote:
> 
>> For several network drivers it was reported that using
>> __napi_schedule_irqoff() is unsafe with forced threading. One way to
>> fix this is switching back to __napi_schedule, but then we lose the
>> benefit of the irqoff version in general. As stated by Eric it doesn't
>> make sense to make the minimal hard irq handlers in drivers using NAPI
>> a thread. Therefore ensure that the hard irq handler is never
>> thread-ified.
>>
>> Fixes: 9a899a35b0d6 ("r8169: switch to napi_schedule_irqoff")
>> Link: https://lkml.org/lkml/2020/10/18/19
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/ethernet/realtek/r8169_main.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>> index 7d366b036..3b6ddc706 100644
>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> ...
> 
> Hi!  This patch actually breaks r8169 with threadirqs on an old box
> where it was working before:
> 
> [    0.000000] DMI: Gigabyte Technology Co., Ltd. GA-MA790FX-DQ6/GA-MA790FX-DQ6, BIOS F7g 07/19/2010
> ...
> [    1.072676] r8169 0000:02:00.0 eth0: RTL8168b/8111b, 00:1a:4d:5d:6b:c3, XID 380, IRQ 18
> ...
> [    8.850099] genirq: Flags mismatch irq 18. 00010080 (eth0) vs. 00002080 (ahci[0000:05:00.0])
> 
> (error is reported to userspace, interface failed to bring up).
> Reverting the patch fixes the problem.
> 
Thanks for the report. On this old chip version MSI is unreliable,
therefore r8169 falls back to a PCI legacy interrupt. On your system
this PCI legacy interrupt seems to be shared between network and
disk. Then the IRQ core tries to threadify the disk interrupt
(setting IRQF_ONESHOT), whilst the network interrupt doesn't have
this flag set. This results in the flag mismatch error.

Maybe, if one source of a shared interrupt doesn't allow forced
threading, this should be applied to the other sources too.
But this would require a change in the IRQ core, therefore
+Thomas to get his opinion on the issue.
