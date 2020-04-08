Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A49D1A29A2
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 21:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729618AbgDHTuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 15:50:52 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:38223 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727903AbgDHTuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 15:50:52 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48yFJ90F4Dz1qs3K;
        Wed,  8 Apr 2020 21:50:43 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48yFJ26zbpz1qqkP;
        Wed,  8 Apr 2020 21:50:42 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id SdcSIJbG6HVK; Wed,  8 Apr 2020 21:50:41 +0200 (CEST)
X-Auth-Info: ckA0+LYz8St3t7G6xpdX1YTYZX//Ss/lfBMal/fmiuI=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Wed,  8 Apr 2020 21:50:41 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
Subject: Re: [PATCH V3 00/18] net: ks8851: Unify KS8851 SPI and MLL drivers
To:     Lukas Wunner <lukas@wunner.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
References: <20200328003148.498021-1-marex@denx.de>
 <20200406031649.zujfod44bz53ztlo@wunner.de>
 <f9449a3b-7536-0bde-4ee6-b254fd90923f@denx.de>
Message-ID: <143b003a-81f9-d908-9580-67317a8e96c6@denx.de>
Date:   Wed, 8 Apr 2020 21:49:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <f9449a3b-7536-0bde-4ee6-b254fd90923f@denx.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/6/20 1:20 PM, Marek Vasut wrote:
> On 4/6/20 5:16 AM, Lukas Wunner wrote:
>> On Sat, Mar 28, 2020 at 01:31:30AM +0100, Marek Vasut wrote:
>>> The KS8851SNL/SNLI and KS8851-16MLL/MLLI/MLLU are very much the same pieces
>>> of silicon, except the former has an SPI interface, while the later has a
>>> parallel bus interface. Thus far, Linux has two separate drivers for each
>>> and they are diverging considerably.
>>>
>>> This series unifies them into a single driver with small SPI and parallel
>>> bus specific parts. The approach here is to first separate out the SPI
>>> specific parts into a separate file, then add parallel bus accessors in
>>> another separate file and then finally remove the old parallel bus driver.
>>> The reason for replacing the old parallel bus driver is because the SPI
>>> bus driver is much higher quality.
>>
>> Sorry for the delay Marek.
>>
>> ks8851.ko (SPI variant) no longer compiles with this series.
>> The attached 0001 patch fixes it.
>>
>> Both drivers can only be compiled as modules with this series:
>> If only one of them is built-in, there's a linker error because of
>> the module_param_named() for msg_enable.
>> If both are built-in, the symbol collisions you've mentioned occur.
>>
>> It seems Kbuild can't support building a .o file with a different name
>> than the corresponding .c file because of the implicit rules used
>> everywhere.  However, ks8851_common.c can be renamed to be a header
>> file (a library of sorts) which is included by the two .c files.
>> I've renamed ks8851_spi.c back to the original ks8851.c and
>> ks8851_par.c back to ks8851_mll.c. The result is the attached 0002 patch.
>> Compiles without any errors regardless if one or both drivers are
>> built-in or modules.
>>
>> I'll be back at the office this week and will conduct performance
>> measurements with this version.
> 
> This looks like a hack, I'm more inclined to go back to using callbacks
> for the various functions, since I don't see any performance problems
> there. We're still talking about 25 MHz SPI bus here and the SPI
> subsystem is full of such indirection anyway, so I'm not even sure what
> you're hoping to gain here ; it seems to me like a premature
> optimization which only causes trouble.

So I got the KS8851SNL development kit to test the SPI option. The
current driver in linux-next gives me SPI transfer timeouts at 1 MHz (I
also tried 6 MHz, 10 MHz, same problem, I also checked the signal
quality which is OK) both on iMX6Q and on STM32MP1 with ~2 cm long
wiring between the SoM and the KS8851SNL devkit, so that's where my
testing ends, sadly. Unless you have some idea what the problem might be ?

That said, I at least did test of the impact of the pointer indirection
on the KS8851-16MLL with [1] (direct access test is with the top 7
patches removed, indirect access test is with the branch as-is). The
KS8851-16MLL also has higher bandwidth, so it calls the IO accessors
more often than the SPI variant, and so it's likely more relevant when
testing whether their overhead matters.

- SoC is stm32mp157c at 650 MHz
- link partner
  Intel Corporation 82579LM Gigabit Network Connection (Lewisville) (rev 06)
- Test commands (repeated thrice, averaged,
                 after three discarded runs to prime the system):
  $ iperf -sei 1               # RX
  $ iperf -c 192.168.1.1 -ei 1 # TX

             | accessor |     RX       |     TX
KS8851-16MLL | indirect | 52.86 Mbit/s | 74.03 Mbit/s
KS8851-16MLL |  direct  | 53.80 Mbit/s | 73.90 Mbit/s

There is ~1 Mbit/s throughput increase on the RX average, however the
throughput fluctuates by a few Mbit/s during the iperf RX tests between
50.7 Mbit/s and 54.1 Mbit/s. There is also some decrease on TX, but it
is marginal. Interestingly enough, the TX test throughput fluctuates
less than RX, only by small hundreds of kbit/s.

I'd say that the pointer indirection doesn't play any role here and it
is better to keep the driver simple and go with it, unless the SPI
option is affected, which I doubt it is.

[1]
https://git.kernel.org/pub/scm/linux/kernel/git/marex/linux-2.6.git/log/?h=ks8851-v4
