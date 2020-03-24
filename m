Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28604191379
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 15:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgCXOoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 10:44:12 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:60769 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727289AbgCXOoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 10:44:11 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48mvCF2wPMz1qs4C;
        Tue, 24 Mar 2020 15:44:05 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48mvC95tszz1qqkB;
        Tue, 24 Mar 2020 15:44:05 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id j68Vve-KVJMe; Tue, 24 Mar 2020 15:44:04 +0100 (CET)
X-Auth-Info: GSpCfzg0jTac3xBKXYPoSuMuv3lZYMTw9ufvUAxzSmw=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue, 24 Mar 2020 15:44:04 +0100 (CET)
Subject: Re: [PATCH 11/14] net: ks8851: Implement register and FIFO accessor
 callbacks
To:     Lukas Wunner <lukas@wunner.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>, Andrew Lunn <andrew@lunn.ch>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-12-marex@denx.de>
 <20200324134555.wgtvj4owmkw3jup4@wunner.de>
 <a071d1a4-c627-f2e2-d689-4663671d97d9@denx.de>
 <20200324142929.dfs2cdmj3na27oo5@wunner.de>
From:   Marek Vasut <marex@denx.de>
Message-ID: <c89bf616-2936-6ebd-452f-e680859b2963@denx.de>
Date:   Tue, 24 Mar 2020 15:44:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200324142929.dfs2cdmj3na27oo5@wunner.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/20 3:29 PM, Lukas Wunner wrote:
> On Tue, Mar 24, 2020 at 03:10:59PM +0100, Marek Vasut wrote:
>> On 3/24/20 2:45 PM, Lukas Wunner wrote:
>>> On Tue, Mar 24, 2020 at 12:43:00AM +0100, Marek Vasut wrote:
>>>> The register and FIFO accessors are bus specific. Implement callbacks so
>>>> that each variant of the KS8851 can implement matching accessors and use
>>>> the rest of the common code.
>>> [...]
>>>> +	unsigned int		(*rdreg16)(struct ks8851_net *ks,
>>>> +					   unsigned int reg);
>>>> +	void			(*wrreg16)(struct ks8851_net *ks,
>>>> +					   unsigned int reg, unsigned int val);
>>>> +	void			(*rdfifo)(struct ks8851_net *ks, u8 *buff,
>>>> +					  unsigned int len);
>>>> +	void			(*wrfifo)(struct ks8851_net *ks,
>>>> +					  struct sk_buff *txp, bool irq);
>>>
>>> Using callbacks entails a dereference for each invocation.
>>
>> Yes indeed, the SPI stack which you use to talk to the KS8851 SPI is
>> also full of those.
> 
> Apples and oranges.  Low-level SPI drivers provide callbacks to the
> SPI core because it would be too expensive (space-wise) to link the
> SPI core into every low-level driver.  Whereas in this case, you're
> generating two separate modules anyway, so there's no need at all
> to use callbacks.
> 
> 
>>> A cheaper approach is to just declare the function signatures
>>> in ks8851.h and provide non-static implementations in
>>> ks8851_spi.c and ks8851_mll.c, so I'd strongly prefer that.
>>>
>>> Even better, since this only concerns the register accessors
>>> (which are inlined anyway by the compiler), it would be best
>>> to have them in header files (e.g. ks8851_spi.h / ks8851_par.h)
>>> which are included by the common ks8851.c based on the target
>>> which is being compiled.  That involves a bit of kbuild magic
>>> though to generate two different .o from the same .c file,
>>> each with specific "-include ..." CFLAGS.
>>
>> Before we go down the complex and ugly path, can you check whether this
>> actually has performance impact ? I would expect that since this is an
>> SPI-connected device, this here shouldn't have that much impact. But I
>> might be wrong, I don't have the hardware.
> 
> I can test it, but the devices are in the office, I won't return there
> before Thursday.  That said, I don't think it's a proper approach to
> make the code more expensive even though it's perfectly possible to
> avoid any performance impact, and shrug off concerns with the argument
> that the impact should be measured first.

I cannot measure the impact on the SPI device, but I would like to know
the numbers to see whether it's worth it all, before I start creating a
more complex solution.

Since the SPI bus is limited to 40 MHz per datasheet, I don't think the
pointer dereference is gonna introduce any performance problem.

I can at least try skipping the dereference on the parallel bus option
and see if it makes a difference.

>> Also note that having this dereference in place, it permits me to easily
>> implement accessors for both LE and BE variant of the parallel bus device.
> 
> My understanding is that you're supposed to configure the chip to use
> the native endianness of your architecture on ->probe() such that
> conversions become unnecessary and the same accessor can be used for
> LE and BE.  So why do you need two accessors?

Because I have a device here which is configured the "wrong" way thus far.
