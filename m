Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9816F2F8E12
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 18:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbhAPROg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 12:14:36 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:52831 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728078AbhAPROe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 12:14:34 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4DJ3ts1Pvxz1qs3H;
        Sat, 16 Jan 2021 17:49:57 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4DJ3ts0W9Zz1qqkg;
        Sat, 16 Jan 2021 17:49:57 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id FS-vg56CNTBJ; Sat, 16 Jan 2021 17:49:55 +0100 (CET)
X-Auth-Info: NlhpEy54om9+R1npcjDADIV+Ngy5iA4WyWUQ5UHQKmk=
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sat, 16 Jan 2021 17:49:55 +0100 (CET)
Subject: Re: [PATCH net-next] net: ks8851: Fix mixed module/builtin build
To:     Arnd Bergmann <arnd@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Lukas Wunner <lukas@wunner.de>
References: <20210115134239.126152-1-marex@denx.de> <YAGuA8O0lr19l5lH@lunn.ch>
 <e000a5f4-53bb-a4e4-f032-3dbe394d5ea3@denx.de> <YAG79tfQXTVWtPJX@lunn.ch>
 <48be7af4-3233-c3dc-70a1-1197b7ad83d7@gmail.com>
 <CAK8P3a1A=Fa6dHvLKkqcmDwPGh2MsJfpTDwmRAjkn1++jAJUWA@mail.gmail.com>
From:   Marek Vasut <marex@denx.de>
Message-ID: <f4a93d29-cc43-7cca-5b98-c279cbd0ca1c@denx.de>
Date:   Sat, 16 Jan 2021 17:49:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a1A=Fa6dHvLKkqcmDwPGh2MsJfpTDwmRAjkn1++jAJUWA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/15/21 10:36 PM, Arnd Bergmann wrote:
> On Fri, Jan 15, 2021 at 6:24 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>> On 15.01.2021 16:59, Andrew Lunn wrote:
>>> On Fri, Jan 15, 2021 at 04:05:57PM +0100, Marek Vasut wrote:
>>>> On 1/15/21 4:00 PM, Andrew Lunn wrote:
>>>>> On Fri, Jan 15, 2021 at 02:42:39PM +0100, Marek Vasut wrote:
>>>>>> When either the SPI or PAR variant is compiled as module AND the other
>>>>>> variant is compiled as built-in, the following build error occurs:
>>>>>>
>>>>>> arm-linux-gnueabi-ld: drivers/net/ethernet/micrel/ks8851_common.o: in function `ks8851_probe_common':
>>>>>> ks8851_common.c:(.text+0x1564): undefined reference to `__this_module'
>>>>>>
>>>>>> Fix this by including the ks8851_common.c in both ks8851_spi.c and
>>>>>> ks8851_par.c. The DEBUG macro is defined in ks8851_common.c, so it
>>>>>> does not have to be defined again.
>>>>>
>>>>> DEBUG should not be defined for production code. So i would remove it
>>>>> altogether.
>>>>>
>>>>> There is kconfig'ury you can use to make them both the same. But i'm
>>>>> not particularly good with it.
>>>>
>>>> We had discussion about this module/builtin topic in ks8851 before, so I was
>>>> hoping someone might provide a better suggestion.
>>>
>>> Try Arnd Bergmann. He is good with this sort of thing.
>>>
>> I'd say make ks8851_common.c a separate module. Then, if one of SPI / PAR
>> is built in, ks8851_common needs to be built in too. To do so you'd have
>> export all symbols from ks8851_common that you want to use in SPI /PAR.
> 
> Yes, that should work, as long the common module does not reference
> any symbols from the other two modules (it normally wouldn't), and all
> globals in the common one are exported.
> 
> You can also link everything into a single module, but then you have
> to deal with registering two device_driver structures from a single
> init function, which would undo some of cleanup.

Maybe just passing THIS_MODULE around is even better way to do it, I 
CCed you on the V2, [PATCH net-next V2] net: ks8851: Fix mixed 
module/builtin build .
