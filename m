Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06F9130033E
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 13:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbhAVMdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 07:33:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728042AbhAVMdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 07:33:03 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7B4C06174A;
        Fri, 22 Jan 2021 04:32:20 -0800 (PST)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id BD26A23E55;
        Fri, 22 Jan 2021 13:32:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1611318739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ov6vIrC/q0d467yXdm93eNZr1OWHmR3FpV864jD1vNg=;
        b=cgHT7EncJgJSv6jmQTPdw+t8K68X4SW53G2kLDhkuhK3V9eS60+R29FLVZginMWB4G74xV
        Tid/b8ftHOvyAkepBtZ8a/D+/r9G2YplEdSRBlQVnclOlgcrQ6a+i7EY/+mPckv7skdDY8
        sm2Mr/KOcoCDAk72bUtLTD7zesUrWJg=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 22 Jan 2021 13:32:18 +0100
From:   Michael Walle <michael@walle.cc>
To:     Claudiu.Beznea@microchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas.Ferre@microchip.com, davem@davemloft.net
Subject: Re: [PATCH] net: macb: ignore tx_clk if MII is used
In-Reply-To: <9a6a93a0-7911-5910-333d-4aa9c0cd184d@microchip.com>
References: <20210120194303.28268-1-michael@walle.cc>
 <38734f00-e672-e694-1344-35f4dd68c90c@microchip.com>
 <bd029c647db42e05bf1a54d43d601861@walle.cc>
 <1bde9969-8769-726b-02cb-a1fcded0cd74@microchip.com>
 <9737f7e5e53790ca5acbea8f07ddf1a4@walle.cc>
 <9a6a93a0-7911-5910-333d-4aa9c0cd184d@microchip.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <b18ecd35dc826aa868e0b992d4ee38c9@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-01-22 12:38, schrieb Claudiu.Beznea@microchip.com:
> On 22.01.2021 13:20, Michael Walle wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know 
>> the
>> content is safe
>> 
>> Am 2021-01-22 10:10, schrieb Claudiu.Beznea@microchip.com:
>>> On 21.01.2021 11:41, Michael Walle wrote:
>>>> EXTERNAL EMAIL: Do not click links or open attachments unless you 
>>>> know
>>>> the
>>>> content is safe
>>>> 
>>>> Hi Claudiu,
>>>> 
>>>> Am 2021-01-21 10:19, schrieb Claudiu.Beznea@microchip.com:
>>>>> On 20.01.2021 21:43, Michael Walle wrote:
>>>>>> EXTERNAL EMAIL: Do not click links or open attachments unless you
>>>>>> know
>>>>>> the content is safe
>>>>>> 
>>>>>> If the MII interface is used, the PHY is the clock master, thus
>>>>>> don't
>>>>>> set the clock rate. On Zynq-7000, this will prevent the following
>>>>>> warning:
>>>>>>   macb e000b000.ethernet eth0: unable to generate target 
>>>>>> frequency:
>>>>>> 25000000 Hz
>>>>>> 
>>>>> 
>>>>> Since in this case the PHY provides the TX clock and it provides 
>>>>> the
>>>>> proper
>>>>> rate based on link speed, the MACB driver should not handle the
>>>>> bp->tx_clk
>>>>> at all (MACB driver uses this clock only for setting the proper 
>>>>> rate
>>>>> on
>>>>> it
>>>>> based on link speed). So, I believe the proper fix would be to not
>>>>> pass
>>>>> the
>>>>> tx_clk at all in device tree. This clock is optional for MACB 
>>>>> driver.
>>>> 
>>>> Thanks for looking into this.
>>>> 
>>>> I had the same thought. But shouldn't the driver handle this case
>>>> gracefully?
>>>> I mean it does know that the clock isn't needed at all.
>>> 
>>> Currently it may knows that by checking the bp->tx_clk. Moreover the
>>> clock
>>> could be provided by PHY not only for MII interface.
>> 
>> That doesn't make this patch wrong, does it? It just doesn't cover
>> all use cases (which also wasn't covered before).
> 
> I would say that it breaks setups using MII interface and with clock
> provided via DT that need to be handled by macb_set_tx_clk().

But the MII interface has by definition no tx clock? At the moment
tx_clk is set to the correct frequency for RGMII interfaces, right?
How would it break boards then?

And if you use tx_clk for like driving the PHY refclk input, that
would be an abuse of this clock (and shouldn't even work, because it
just sets the correct RGMII frequencies).

>>> Moreover the IP has the bit "refclk" of register at offset 0xc 
>>> (userio)
>>> that tells it to use the clock provided by PHY or to use one internal
>>> to
>>> the SoC. If a SoC generated clock would be used the IP logic may have
>>> the
>>> option to do the proper division based on link speed (if IP has this
>>> option
>>> enabled then this should be selected in driver with capability
>>> MACB_CAPS_CLK_HW_CHG).
>>> 
>>> If the clock provided by the PHY is the one to be used then this is
>>> selected with capability MACB_CAPS_USRIO_HAS_CLKEN. So, if the change
>>> you
>>> proposed in this patch is still imperative then checking for this
>>> capability would be the best as the clock could be provided by PHY 
>>> not
>>> only
>>> for MII interface.
>> 
>> Fair enough, but this register doesn't seem to be implemented on
>> Zynq-7000. Albeit MACB_CAPS_USRIO_DISABLED isn't defined for the
>> Zynq MACB. It isn't defined in the Zynq-7000 reference manual and
>> you cannot set any bits:
>> 
>> => mw 0xE000B00C 0xFFFFFFFF
>> => md 0xE000B00C 1
>> e000b00c: 00000000
> 
> I wasn't aware of this. In this case, maybe adding the
> MACB_CAPS_USRIO_DISABLED to the Zync-7000 capability list and checking 
> this
> one plus MACB_CAPS_USRIO_HAS_CLKEN would be better instead of checking 
> the
> MAC-PHY interface?

But then RGMII would be broken. Zynq and ZynqMP are the only users of
the tx_clk as far as I can see. There, it will set the clock generated
by the clock controller which is driving the TX_CLK for RGMII and the
corresponding input of the GEM/MACB.

I mean you have the same SoC, thus the same caps and usrio settings,
but you have two possible interfaces: MII and RGMII. (At least, because
there might also be other interfaces like GMII). Therefore, you cannot
check this bit, right? It will be the same for both MII and RGMII mode.

In any case, it should be correct to add MACB_CAPS_USRIO_DISABLED to
caps for the zynq family (I'd need to double check the ZynqMP RM).

>> Also please note, that tx_clk may be an arbitrary clock which doesn't
>> necessarily need to be the clock which is controlled by CLK_EN. Or
>> am I missing something here?
> 
> I suppose that whoever creates the device tree knows what is doing and 
> it
> passes the proper clock to macb driver.

Mh. If CLK_EN is supported this might be the case. Unfortunalty, Zynq
is the only user and doesn't have this bit.

-michael

PS. dont' get me wrong, I'm all for fixing this "the right way".
