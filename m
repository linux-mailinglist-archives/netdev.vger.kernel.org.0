Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3B53C3DF6
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 18:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbhGKQeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 12:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232774AbhGKQeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 12:34:10 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B0DC061786;
        Sun, 11 Jul 2021 09:31:23 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4GNC881sKqzQjgk;
        Sun, 11 Jul 2021 18:31:20 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id leSaYwUIBFik; Sun, 11 Jul 2021 18:31:15 +0200 (CEST)
Subject: Re: [PATCH v2 2/2] mwifiex: pcie: add reset_d3cold quirk for Surface
 gen4+ devices
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>
Cc:     =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <20210709145831.6123-1-verdre@v0yd.nl>
 <20210709145831.6123-3-verdre@v0yd.nl> <20210709151800.7b2qqezlcicbgrqn@pali>
 <b1002254-97c6-d271-c385-4a5c9fe0c914@mailbox.org>
 <20210709161251.g4cvq3l4fnh4ve4r@pali>
 <d9158206-8ebe-c857-7533-47155a6464e1@gmail.com>
 <20210709173013.vkavxrtz767vrmej@pali>
From:   =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>
Message-ID: <aa261514-ef3b-cc8e-fe89-a840b3e70d81@mailbox.org>
Date:   Sun, 11 Jul 2021 18:31:08 +0200
MIME-Version: 1.0
In-Reply-To: <20210709173013.vkavxrtz767vrmej@pali>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -4.39 / 15.00 / 15.00
X-Rspamd-Queue-Id: 855961823
X-Rspamd-UID: 2793e4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/9/21 7:30 PM, Pali Rohár wrote:
> On Friday 09 July 2021 19:03:37 Maximilian Luz wrote:
>> On 7/9/21 6:12 PM, Pali Rohár wrote:
>>
>> [...]
>>
>>>>> Hello! Now I'm thinking loudly about this patch. Why this kind of reset
>>>>> is needed only for Surface devices? AFAIK these 88W8897 chips are same
>>>>> in all cards. Chip itself implements PCIe interface (and also SDIO) so
>>>>> for me looks very strange if this 88W8897 PCIe device needs DMI specific
>>>>> quirks. I cannot believe that Microsoft got some special version of
>>>>> these chips from Marvell which are different than version uses on cards
>>>>> in mPCIe form factor.
>>>>>
>>>>> And now when I'm reading comment below about PCIe bridge to which is
>>>>> this 88W8897 PCIe chip connected, is not this rather an issue in that
>>>>> PCIe bridge (instead of mwifiex/88W8897) or in ACPI firmware which
>>>>> controls this bridge?
>>>>>
>>>>> Or are having other people same issues on mPCIe form factor wifi cards
>>>>> with 88W8897 chips and then this quirk should not DMI dependent?
>>>>>
>>>>> Note that I'm seeing issues with reset and other things also on chip
>>>>> 88W8997 when is connected to system via SDIO. These chips have both PCIe
>>>>> and SDIO buses, it just depends which pins are used.
>>>>>
>>>>
>>>> Hi and thanks for the quick reply! Honestly I've no idea, this is just the
>>>> first method we found that allows for a proper reset of the chip. What I
>>>> know is that some Surface devices need that ACPI DSM call (the one that was
>>>> done in the commit I dropped in this version of the patchset) to reset the
>>>> chip instead of this method.
>>>>
>>>> Afaik other devices with this chip don't need this resetting method, at
>>>> least Marvell employees couldn't reproduce the issues on their testing
>>>> devices.
>>>>
>>>> So would you suggest we just try to match for the pci chip 88W8897 instead?
>>>
>>> Hello! Such suggestion makes sense when we know that it is 88W8897
>>> issue. But if you got information that issue cannot be reproduced on
>>> other 88W8897 cards then matching 88W8897 is not correct.
>>>
>>>   From all this information looks like that it is problem in (Microsoft?)
>>> PCIe bridge to which is card connected. Otherwise I do not reason how it
>>> can be 88W8897 affected. Either it is reproducible on 88W8897 cards also
>>> in other devices or issue is not on 88W8897 card.
>>
>> I doubt that it's an issue with the PCIe bridge (itself at least). The
>> same type of bridge is used for both dGPU and NVME SSD on my device (see
>> lspci output below) and those work fine. Also if I'm seeing that right
>> it's from the Intel CPU, so my guess is that a lot more people would
>> have issues with that then.
> 
>  From information below it seems to be related to surprise removal.
> Therefore is surprise removal working without issue for dGPU or NVME
> SSD? Not all PCIe bridges support surprise removal...
> 
>>
>> I don't know about the hardware side, so it might be possible that it's
>> an issue with integrating both bridge and wifi chip, in which case it's
>> still probably best handled via DMI quirks unless we know more.
>>
>> Also as Tsuchiya mentioned in his original submission, on Windows the
>> device is reset via this D3cold method. I've only skimmed that
>> errata.inf file mentioned, but I think this is what he's referring to:
>>
>>    Controls whether ACPIDeviceEnableD3ColdOnSurpriseRemoval rule will be
>>    evaluated or not on a given platform. Currently
>>    ACPIDeviceEnableD3ColdOnSurpriseRemoval rule only needs to be
>>    evaluated on Surface platforms which contain the Marvell WiFi
>>    controller which depends on device going through D3Cold as part of
>>    surprise-removal.
>>
>> and
>>
>>    Starting with Windows releases *after* Blue, ACPI will not put
>>    surprise-removed devices into D3Cold automatically. Some known
>>    scenarios (viz. WiFi reset/recovery) rely on the device cycling
>>    through D3Cold on surprise-removal. This hack allows surprise-removed
>>    devices to be put into D3Cold (if supported by the stack).
>>
>> So, as far as I can tell, the chip doesn't like to be surprise-removed
>> (which seems to happen during reset) and then needs to be power-cycled,
>> which I think is likely due to some issue with firmware state.
> 
> Thanks for information. This really does not look like PCIe bridge
> specific if bridge itself can handle surprise-removed devices. lspci can
> tell us if bridge supports it or not (see below).
> 
>> So the quirk on Windows seems very Surface specific.
>>
>> There also seem a bunch of revisions of these chips around, for example
>> my SB2 is affected by a bug that we've tied to the specific hardware
>> revision which causes some issues with host-sleep (IIRC chip switches
>> rapidly between wake and sleep states without any external influence,
>> which is not how it should behave and how it does behave on a later
>> hardware revision).
> 
> Interesting... This looks like the issue can be in 88W8897 chip and
> needs some special conditions to trigger? And Surface is triggering it
> always?

The specific issue was that the card wakes up very quickly after going 
into deep sleep (deep sleep is a state the firmware enters when idle and 
not connected to an AP). Now this in turn messed with the host 
suspending, because deep sleep is involved there and the card is not 
expected to wake up that quickly again (I'm oversimplifying here, it's 
also been some time since we looked into it).

Anyway, in the end those wakeups from deep sleep only happened with one 
hardware revision of the card (I guess it's caused by a hardware design 
issue like a floating gpio or something), and we managed to fix the 
problems by disabling deep sleep on that hardware revision, but as Max 
mentioned that problem is completely unrelated from this patch.

> 
>>>> Then we'd probably have to check if there are any laptops where multiple
>>>> devices are connected to the pci bridge as Amey suggested in a review
>>>> before.
>>>
>>> Well, I do not know... But if this is issue with PCIe bridge then
>>> similar issue could be observed also for other PCIe devices with this
>>> PCIe bridge. But question is if there are other laptops with this PCIe
>>> bridge. And also it can be a problem in ACPI firmware on those Surface
>>> devices, which implements some PCIe bridge functionality. So it is
>>> possible that issue is with PCIe bridge, not in HW, but in SW/firmware
>>> part which can be Microsoft specific... So too many questions to which
>>> we do not know answers.
>>>
>>> Could you provide output of 'lspci -nn -vv' and 'lspci -tvnn' on
>>> affected machines? If you have already sent it in some previous email,
>>> just send a link. At least I'm not able to find it right now and output
>>> may contain something useful...
>>
>>  From my Surface Book 2 (with the same issue):
>>
>>   - lspci -tvnn: https://paste.ubuntu.com/p/mm3YpcZJ8N/
>>   - lspci -vv -nn: https://paste.ubuntu.com/p/dctTDP738N/
> 
> Could you re-run lspci under root account? There are missing important
> parts like "Capabilities: <access denied>" where is information if
> bridge supports surprise removal or not.
> 
>> Regards,
>> Max

