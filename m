Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C26D2F8F6D
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 22:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbhAPV0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 16:26:39 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:52590 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbhAPV0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 16:26:34 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4DJB0j2s4Sz1rt3g;
        Sat, 16 Jan 2021 22:25:25 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4DJB0j28FMz1tSR0;
        Sat, 16 Jan 2021 22:25:25 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 4bfBtFBCBzQL; Sat, 16 Jan 2021 22:25:24 +0100 (CET)
X-Auth-Info: FZzoLgP5NuoESY5jS/XAjWFkiNdV73IB1lXOtAw/rB4=
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sat, 16 Jan 2021 22:25:23 +0100 (CET)
Subject: Re: [PATCH net-next V2] net: ks8851: Fix mixed module/builtin build
To:     Lukas Wunner <lukas@wunner.de>, Arnd Bergmann <arnd@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210116164828.40545-1-marex@denx.de>
 <CAK8P3a1iqXjsYERVh+nQs9Xz4x7FreW3aS7OQPSB8CWcntnL4A@mail.gmail.com>
 <a660f328-19d9-1e97-3f83-533c1245622e@denx.de>
 <CAK8P3a3qtrmxMg+uva-s18f_zj7aNXJXcJCzorr2d-XxnqV1Hw@mail.gmail.com>
 <20210116203945.GA32445@wunner.de>
From:   Marek Vasut <marex@denx.de>
Message-ID: <a6d74297-b29e-956e-5861-40cee359e892@denx.de>
Date:   Sat, 16 Jan 2021 22:25:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210116203945.GA32445@wunner.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/16/21 9:39 PM, Lukas Wunner wrote:
> On Sat, Jan 16, 2021 at 08:26:22PM +0100, Arnd Bergmann wrote:
>> On Sat, Jan 16, 2021 at 6:56 PM Marek Vasut <marex@denx.de> wrote:
>>> On 1/16/21 6:04 PM, Arnd Bergmann wrote:
>>>> On Sat, Jan 16, 2021 at 5:48 PM Marek Vasut <marex@denx.de> wrote:
>>>
>>>> I don't really like this version, as it does not actually solve the problem of
>>>> linking the same object file into both vmlinux and a loadable module, which
>>>> can have all kinds of side-effects besides that link failure you saw.
>>>>
>>>> If you want to avoid exporting all those symbols, a simpler hack would
>>>> be to '#include "ks8851_common.c" from each of the two files, which
>>>> then always duplicates the contents (even when both are built-in), but
>>>> at least builds the file the correct way.
>>>
>>> That's the same as V1, isn't it ?
>>
>> Ah, I had not actually looked at the original submission, but yes, that
>> was slightly better than v2, provided you make all symbols static to
>> avoid the new link error.
>>
>> I still think that having three modules and exporting the symbols from
>> the common part as Heiner Kallweit suggested would be the best
>> way to do it.
> 
> FWIW I'd prefer V1 (the #include approach) as it allows going back to
> using static inlines for register access.  That's what we had before
> 7a552c850c45.
> 
> It seems unlikely that a system uses both, the parallel *and* the SPI
> variant of the ks8851.  So the additional memory necessary because of
> code duplication wouldn't matter in practice.

I have a board with both options populated on my desk, sorry.
