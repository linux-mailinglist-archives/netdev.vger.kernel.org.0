Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C015129E8D9
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 11:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgJ2KTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 06:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgJ2KTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 06:19:21 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F71C0613D2
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 03:19:21 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id y12so2112983wrp.6
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 03:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=th1akp+i0p3luT17MDVyfDIixPXzvxVhiNfev+qI7wI=;
        b=iC70U5CLYiWXDHz1rFrAqzeBWc9a0al8lJK9LfUcr34rUjSsBqdO8qo8D2zLzeGq9w
         YlCp9FiPV9Tagua5n4ScQSbPM6SUEIsOG1YLjFi58I6dIJQQGM9LGFSBrdHPOvyrMY0r
         Oj2IS0HwhsgTTBSh8LimhBvl3bdyFYV31YevSkC73rlmMyyVjQ8UIKJDYZvd9NzRSrbr
         U2la0fpYZTdEn4OAvqA5lsJUM8G2TsSBAltBNjvc+wwA+yVICLjdeLVrs5v+Z1r4Mw2P
         DPv/rYitCMYQ873/vZf5Bk+dnMAfotM4Js1hgvWISAksDU24WkTAwOGQ5feDD6E+Z+zT
         yUPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=th1akp+i0p3luT17MDVyfDIixPXzvxVhiNfev+qI7wI=;
        b=gea1bLaqEkqALtHdFKx7VQGj7vJxZrX/frULjXI+yNnj+1DyMBNdszPjM+gwOFax/C
         iGdsjiyonn/piBdKlbMGBZXQhyj4QykgmkYXMpLoQBC9nBCzotytwOhegVJ/yIuC4SsX
         d/Fucn0ePJQ3Qp/Z/Vfs9h3KpK+efkABPSTKbnmupx7UgAPwJy0nhOjWtxjybASW64Gm
         3ppEuAPDXdjSj4FTzFBmLddUTSN7bfOl6uwafKsPNuG7EQu56zkgLXpwdlXNtz1aO0i/
         nnbOkIqifJa1F4PyQL+hV6zHd+3bGUScd0vqcTdL6UTAc6Usg7c4KYXwaOznLe8grUss
         d6Kg==
X-Gm-Message-State: AOAM530oPDHDcjJWUetF7oPyDdcgsMbSctZN0NwBEp16qIM7u8QPw4lf
        BaSO0NPT/XdlB+Ay13nWnCCzFZlpViM=
X-Google-Smtp-Source: ABdhPJy4QPqWYZNKIQc7D2gG7O/mI41qpKLwToDrywRQmOdHD+fm4wvti9heIxMZWZzcVCD4HnTpHg==
X-Received: by 2002:adf:92e4:: with SMTP id 91mr4536583wrn.230.1603966759992;
        Thu, 29 Oct 2020 03:19:19 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:c8fb:cb3e:2952:c247? (p200300ea8f232800c8fbcb3e2952c247.dip0.t-ipconnect.de. [2003:ea:8f23:2800:c8fb:cb3e:2952:c247])
        by smtp.googlemail.com with ESMTPSA id h4sm4136335wrp.52.2020.10.29.03.19.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 03:19:19 -0700 (PDT)
Subject: Re: [PATCH net] r8169: fix operation under forced interrupt threading
To:     Thomas Gleixner <tglx@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Serge Belyshev <belyshev@depni.sinp.msu.ru>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <4d3ef84a-c812-5072-918a-22a6f6468310@gmail.com>
 <877drabmoq.fsf@depni.sinp.msu.ru>
 <f0d713d2-6dc4-5246-daca-54811825e064@gmail.com>
 <20201028162929.5f250d12@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a37b2cdf-97c4-8d13-2a49-d4f8c0b43f04@gmail.com>
 <87y2jpe5by.fsf@nanos.tec.linutronix.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <b976846d-f40e-961f-6a3e-920fd5bf1add@gmail.com>
Date:   Thu, 29 Oct 2020 11:19:14 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <87y2jpe5by.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.10.2020 10:42, Thomas Gleixner wrote:
> On Thu, Oct 29 2020 at 09:42, Heiner Kallweit wrote:
>> On 29.10.2020 00:29, Jakub Kicinski wrote:
>>> Other handles may take spin_locks, which will sleep on RT.
>>>
>>> I guess we may need to switch away from the _irqoff() variant for
>>> drivers with IRQF_SHARED after all :(
>>>
>> Right. Unfortunately that's a large number of drivers,
>> e.g. pci_request_irq() sets IRQF_SHARED in general.
> 
> IRQF_SHARED is not the problem. It only becomes a problem when the
> interrupt is actually shared which is only the case with the legacy PCI
> interrupt. MSI[X] is not affected at all.
> 
Correct, just that the legacy PCI interrupt scenario doesn't affect old
systems/devices only. Users may run the system with nomsi for
whatever reason and we need to be prepared.

We could add handling for (pcidev->msi_enabled || pcidev->msix_enabled),
but this would look somewhat hacky to me.

>> But at least for now there doesn't seem to be a better way to deal
>> with the challenges imposed by forced threading and shared irqs.
> 
> We still can do the static key trick, though it's admittedly hacky.
> 
> Thanks,
> 
>         tglx
> 
> 

