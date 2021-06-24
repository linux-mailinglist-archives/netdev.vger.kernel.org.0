Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71B63B340B
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 18:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbhFXQma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 12:42:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229445AbhFXQm3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 12:42:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E903F613CA;
        Thu, 24 Jun 2021 16:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624552810;
        bh=lJTybvnfd2Dl4R3uXC3jF8lbmzNbn81U7eS8WWOTCEg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=YTvqcNLd570mrY4dCrXUXRSK4l/MRHXMtYDEDucJucojPYRInb+tgsrIhfB6DUJ7w
         Gxph2m8AAZqhJnVycJzP0B4pqLOxTXebq/quL9g/CZYIeRIJQQ3bmPBmftGgSLJkkp
         2+rLtA6nTs3FqOhIEkCh73SEP1aDrEGwabsMKFNs3oaylaZzaCR6WUBt3ljfCbnhk+
         Wg42sTwmWtw/aCiAx+ZkDtwKijd9ZpZE3WiWorGUoFLbOM814jGV1HTn6UhjDgWYHy
         LbMYNWJOufe5Hb8dGENk1DmbZDcaIYjf7HuQuh5k4VcHhz0Y7jzYKduZl3c9qzY4LK
         C04Oi0lijykig==
Subject: Re: linux-next: build failure after merge of the net-next tree
To:     Marcin Wojtas <mw@semihalf.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        lkft-triage@lists.linaro.org
References: <20210624082911.5d013e8c@canb.auug.org.au>
 <CAPv3WKfiL+sR+iK_BjGKDhtNgjoxKEPv49bU1X9_7+v+ytdR1w@mail.gmail.com>
 <YNPt91bfjrgSt8G3@Ryzen-9-3900X.localdomain>
 <CA+G9fYtb07aySOpB6=wc4ip_9S4Rr2UUYNgEOG6i76g--uPryQ@mail.gmail.com>
 <20210624185430.692d4b60@canb.auug.org.au>
 <CAPv3WKf6HguRC_2ckau99d4iWG-FV71kn8wiX9r5wuK335EEFw@mail.gmail.com>
From:   Nathan Chancellor <nathan@kernel.org>
Message-ID: <3d6ea68a-9654-6def-9533-56640ceae69f@kernel.org>
Date:   Thu, 24 Jun 2021 09:40:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAPv3WKf6HguRC_2ckau99d4iWG-FV71kn8wiX9r5wuK335EEFw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcin,

On 6/24/2021 7:25 AM, Marcin Wojtas wrote:
> Hi Stephen,
> 
> czw., 24 cze 2021 o 10:54 Stephen Rothwell <sfr@canb.auug.org.au> napisał(a):
>>
>> Hi all,
>>
>> On Thu, 24 Jun 2021 11:43:14 +0530 Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>>>
>>> On Thu, 24 Jun 2021 at 07:59, Nathan Chancellor <nathan@kernel.org> wrote:
>>>>
>>>> On Thu, Jun 24, 2021 at 12:46:48AM +0200, Marcin Wojtas wrote:
>>>>> Hi Stephen,
>>>>>
>>>>> czw., 24 cze 2021 o 00:29 Stephen Rothwell <sfr@canb.auug.org.au> napisał(a):
>>>>>>
>>>>>> Hi all,
>>>>>>
>>>>>> Today's linux-next build (x86_64 modules_install) failed like this:
>>>>>>
>>>>>> depmod: ../tools/depmod.c:1792: depmod_report_cycles_from_root: Assertion `is < stack_size' failed.
>>>
>>> LKFT test farm found this build error.
>>>
>>> Regressions found on mips:
>>>
>>>   - build/gcc-9-malta_defconfig
>>>   - build/gcc-10-malta_defconfig
>>>   - build/gcc-8-malta_defconfig
>>>
>>> depmod: ERROR: Cycle detected: fwnode_mdio -> of_mdio -> fwnode_mdio
>>> depmod: ERROR: Found 2 modules in dependency cycles!
>>> make[1]: *** [/builds/linux/Makefile:1875: modules_install] Error 1
>>>
>>>>> Thank you for letting us know. Not sure if related, but I just found
>>>>> out that this code won't compile for the !CONFIG_FWNODE_MDIO. Below
>>>>> one-liner fixes it:
>>>>>
>>>>> --- a/include/linux/fwnode_mdio.h
>>>>> +++ b/include/linux/fwnode_mdio.h
>>>>> @@ -40,7 +40,7 @@ static inline int fwnode_mdiobus_register(struct mii_bus *bus,
>>>>>           * This way, we don't have to keep compat bits around in drivers.
>>>>>           */
>>>>>
>>>>> -       return mdiobus_register(mdio);
>>>>> +       return mdiobus_register(bus);
>>>>>   }
>>>>>   #endif
>>>>>
>>>>> I'm curious if this is the case. Tomorrow I'll resubmit with above, so
>>>>> I'd appreciate recheck.
>>>
>>> This proposed fix did not work.
>>>
>>>> Reverting all the patches in that series fixes the issue for me.
>>>
>>> Yes.
>>> Reverting all the (6) patches in that series fixed this build problem.
>>>
>>> git log --oneline | head
>>> 3752a7bfe73e Revert "Documentation: ACPI: DSD: describe additional MAC
>>> configuration"
>>> da53528ed548 Revert "net: mdiobus: Introduce fwnode_mdbiobus_register()"
>>> 479b72ae8b68 Revert "net/fsl: switch to fwnode_mdiobus_register"
>>> 92f85677aff4 Revert "net: mvmdio: add ACPI support"
>>> 3d725ff0f271 Revert "net: mvpp2: enable using phylink with ACPI"
>>> ffa8c267d44e Revert "net: mvpp2: remove unused 'has_phy' field"
>>> d61c8b66c840 Add linux-next specific files for 20210623
>>
>> So I have reverted the merge of that topic branch from linux-next for
>> today.
> 
> Just to understand correctly - you reverted merge from the local
> branch (I still see the commits on Dave M's net-next/master). I see a
> quick solution, but I'm wondering how I should proceed. Submit a
> correction patch to the mailing lists against the net-next? Or the
> branch is going to be reverted and I should resubmit everything as v4?

As far as I am aware, net and net-next are not rebased so you would need 
to submit a fixup patch against the current net-next with a proper 
Fixes: tag.

Cheers,
Nathan
