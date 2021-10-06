Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9457F42420E
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 18:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239327AbhJFQDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 12:03:07 -0400
Received: from mout-p-201.mailbox.org ([80.241.56.171]:17782 "EHLO
        mout-p-201.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239206AbhJFQDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 12:03:06 -0400
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4HPfMB17jYzQlRX;
        Wed,  6 Oct 2021 18:01:10 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Message-ID: <61b034e3-8d16-0488-d7e0-016e64f33b67@v0yd.nl>
Date:   Wed, 6 Oct 2021 18:01:02 +0200
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/2] mwifiex: Use non-posted PCI write when setting TX
 ring write pointer
Content-Language: en-US
From:   =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>
To:     David Laight <David.Laight@ACULAB.COM>,
        =?UTF-8?B?J1BhbGkgUm9ow6FyJw==?= <pali@kernel.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Brian Norris <briannorris@chromium.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20210914114813.15404-1-verdre@v0yd.nl>
 <20210914114813.15404-2-verdre@v0yd.nl>
 <8f65f41a807c46d496bf1b45816077e4@AcuMS.aculab.com>
 <20210922142726.guviqler5k7wnm52@pali>
 <e0a4e0adc56148039f853ccb083be53a@AcuMS.aculab.com>
 <ae8ca158-ad86-9c0d-7217-f9db3d2fc42e@v0yd.nl>
In-Reply-To: <ae8ca158-ad86-9c0d-7217-f9db3d2fc42e@v0yd.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6BD7322F
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/21 16:27, Jonas Dreßler wrote:
> On 9/22/21 5:54 PM, David Laight wrote:
>>
>> From: Pali Rohár
>>> Sent: 22 September 2021 15:27
>>>
>>> On Wednesday 22 September 2021 14:03:25 David Laight wrote:
>>>> From: Jonas Dreßler
>>>>> Sent: 14 September 2021 12:48
>>>>>
>>>>> On the 88W8897 card it's very important the TX ring write pointer is
>>>>> updated correctly to its new value before setting the TX ready
>>>>> interrupt, otherwise the firmware appears to crash (probably because
>>>>> it's trying to DMA-read from the wrong place). The issue is present in
>>>>> the latest firmware version 15.68.19.p21 of the pcie+usb card.
>>>>>
>>>>> Since PCI uses "posted writes" when writing to a register, it's not
>>>>> guaranteed that a write will happen immediately. That means the pointer
>>>>> might be outdated when setting the TX ready interrupt, leading to
>>>>> firmware crashes especially when ASPM L1 and L1 substates are enabled
>>>>> (because of the higher link latency, the write will probably take
>>>>> longer).
>>>>>
>>>>> So fix those firmware crashes by always using a non-posted write for
>>>>> this specific register write. We do that by simply reading back the
>>>>> register after writing it, just as a few other PCI drivers do.
>>>>>
>>>>> This fixes a bug where during rx/tx traffic and with ASPM L1 substates
>>>>> enabled (the enabled substates are platform dependent), the firmware
>>>>> crashes and eventually a command timeout appears in the logs.
>>>>
>>>> I think you need to change your terminology.
>>>> PCIe does have some non-posted write transactions - but I can't
>>>> remember when they are used.
>>>
>>> In PCIe are all memory write requests as posted.
>>>
>>> Non-posted writes in PCIe are used only for IO and config requests. But
>>> this is not case for proposed patch change as it access only card's
>>> memory space.
>>>
>>> Technically this patch does not use non-posted memory write (as PCIe
>>> does not support / provide it), just adds something like a barrier and
>>> I'm not sure if it is really correct (you already wrote more details
>>> about it, so I will let it be).
>>>
>>> I'm not sure what is the correct terminology, I do not know how this
>>> kind of write-followed-by-read "trick" is correctly called.
>>
>> I think it is probably best to say:
>>     "flush the posted write when setting the TX ring write pointer".
>>
>> The write can get posted in any/all of the following places:
>> 1) The cpu store buffer.
>> 2) The PCIe host bridge.
>> 3) Any other PCIe bridges.
>> 4) The PCIe slave logic in the target.
>>     There could be separate buffers for each BAR,
>> 5) The actual target logic for that address block.
>>     The target (probably) will look a bit like an old fashioned cpu
>>     motherboard with the PCIe slave logic as the main bus master.
>>
>> The readback forces all the posted write buffers be flushed.
>>
>> In this case I suspect it is either flushing (5) or the extra
>> delay of the read TLP processing that 'fixes' the problem.
>>
>> Note that depending on the exact code and host cpu the second
>> write may not need to wait for the response to the read TLP.
>> So the write, readback, write TLP may be back to back on the
>> actual PCIe link.
>>
>> Although I don't have access to an actual PCIe monitor we
>> do have the ability to trace 'data' TLP into fpga memory
>> on one of our systems.
>> This is near real-time but they are slightly munged.
>> Watching the TLP can be illuminating!
>>
>>     David
>>
>> -
>> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
>> Registration No: 1397386 (Wales)
>>
> 
> Thanks for the detailed explanations, it looks like indeed the read-back is not the real fix here, a simple udelay(50) before sending the "TX ready" interrupt also does the trick.
> 
>                  } else {
> +                       udelay(50);
> +
>                          /* Send the TX ready interrupt */
>                          if (mwifiex_write_reg(adapter, PCIE_CPU_INT_EVENT,
>                                                CPU_INTR_DNLD_RDY)) {
> 
> I've tested that for a week now and haven't seen any firmware crashes. Interestingly enough it looks like the delay can also be added after setting the "TX ready" interrupt, just not before updating the TX ring write pointer.
> 
> I have no idea if 50 usecs is a good duration to wait here, from trying different values I found that 10 to 20 usecs is not enough, but who knows, maybe that's platform dependent?

So I spent the last few days going slightly crazy while trying to dig deeper
into this.

My theory was that the udelay() delays some subsequent register write or
other communication with the card that would trigger the crash if executed
too early after writing the TX ring write pointer. So I tried moving the
udelay() around, carefully checking when the crash is gone and when it isn't.

In the end my theory turned out completely wrong, what I found was this:
Pinning down the last place where the udelay() is effective gets us here
(https://elixir.bootlin.com/linux/latest/source/drivers/net/wireless/marvell/mwifiex/main.c#L340),
right before we bail out of the main process and idle.

I tried adding the udelay() as the first thing we do on the next run of the
while-loop after that break, but with that the crash came back.

So what does this mean, we fix the crash by sleeping before idling? Sounds
a bit counterintuitive to me...

The only thing I can take away from this is that maybe the udelay() keeps
the CPU from entering some powersaving state and with that the PCI bus from
entering ASPM states (considering that the crash can also be fixed by
disabling ASPM L1.2).
