Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0595D35765B
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbhDGUxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 16:53:31 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:40426 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231520AbhDGUxa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 16:53:30 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.93.0.4)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1lUFAn-0007gx-8c; Wed, 07 Apr 2021 22:53:13 +0200
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
References: <e2924d81-0e30-2dd0-292b-428fea199484@maciej.szmigiero.name>
 <846f6166-c570-01fc-6bbc-3e3b44e51327@maciej.szmigiero.name>
 <87r1jnohq6.fsf@codeaurora.org>
 <8e0434eb-d15f-065d-2ba7-b50c67877112@maciej.szmigiero.name>
 <a2003668-5108-27b9-95cd-9e1d5d1aa94d@lwfinger.net>
 <1617763692.9857.7.camel@realtek.com>
 <1dc7e487-b97b-8584-47f7-37f3385c7bf9@lwfinger.net>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: rtlwifi/rtl8192cu AP mode broken with PS STA
Message-ID: <15737dcf-95ac-1ce6-a681-94ff5db968e4@maciej.szmigiero.name>
Date:   Wed, 7 Apr 2021 22:53:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <1dc7e487-b97b-8584-47f7-37f3385c7bf9@lwfinger.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.04.2021 06:21, Larry Finger wrote:
> On 4/6/21 9:48 PM, Pkshih wrote:
>> On Tue, 2021-04-06 at 11:25 -0500, Larry Finger wrote:
>>> On 4/6/21 7:06 AM, Maciej S. Szmigiero wrote:
>>>> On 06.04.2021 12:00, Kalle Valo wrote:
>>>>> "Maciej S. Szmigiero" <mail@maciej.szmigiero.name> writes:
>>>>>
>>>>>> On 29.03.2021 00:54, Maciej S. Szmigiero wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> It looks like rtlwifi/rtl8192cu AP mode is broken when a STA is using PS,
>>>>>>> since the driver does not update its beacon to account for TIM changes,
>>>>>>> so a station that is sleeping will never learn that it has packets
>>>>>>> buffered at the AP.
>>>>>>>
>>>>>>> Looking at the code, the rtl8192cu driver implements neither the set_tim()
>>>>>>> callback, nor does it explicitly update beacon data periodically, so it
>>>>>>> has no way to learn that it had changed.
>>>>>>>
>>>>>>> This results in the AP mode being virtually unusable with STAs that do
>>>>>>> PS and don't allow for it to be disabled (IoT devices, mobile phones,
>>>>>>> etc.).
>>>>>>>
>>>>>>> I think the easiest fix here would be to implement set_tim() for example
>>>>>>> the way rt2x00 driver does: queue a work or schedule a tasklet to update
>>>>>>> the beacon data on the device.
>>>>>>
>>>>>> Are there any plans to fix this?
>>>>>> The driver is listed as maintained by Ping-Ke.
>>>>>
>>>>> Yeah, power save is hard and I'm not surprised that there are drivers
>>>>> with broken power save mode support. If there's no fix available we
>>>>> should stop supporting AP mode in the driver.
>>>>>
>>>> https://wireless.wiki.kernel.org/en/developers/documentation/mac80211/api
>>>> clearly documents that "For AP mode, it must (...) react to the set_tim()
>>>> callback or fetch each beacon from mac80211".
>>>> The driver isn't doing either so no wonder the beacon it is sending
>>>> isn't getting updated.
>>>> As I have said above, it seems to me that all that needs to be done here
>>>> is to queue a work in a set_tim() callback, then call
>>>> send_beacon_frame() from rtlwifi/core.c from this work.
>>>> But I don't know the exact device semantics, maybe it needs some other
>>>> notification that the beacon has changed, too, or even tries to
>>>> manage the TIM bitmap by itself.
>>>> It would be a shame to lose the AP mode for such minor thing, though.
>>>> I would play with this myself, but unfortunately I don't have time
>>>> to work on this right now.
>>>> That's where my question to Realtek comes: are there plans to actually
>>>> fix this?
>>>
>>> Yes, I am working on this. My only question is "if you are such an expert on the
>>> problem, why do you not fix it?"
>>>
>>> The example in rx200 is not particularly useful, and I have not found any other
>>> examples.
>>>
>>
>> Hi Larry,
>>
>> I have a draft patch that forks a work to do send_beacon_frame(), whose
>> behavior like Maciej mentioned.

That's great, thanks!

>> I did test on RTL8821AE; it works well. But, it seems already work well even
>> I don't apply this patch, and I'm still digging why.

It looks like PCI rtlwifi hardware uses a tasklet (specifically,
_rtl_pci_prepare_bcn_tasklet() in pci.c) to periodically transfer the
current beacon to the NIC.

This tasklet is scheduled on a RTL_IMR_BCNINT interrupt, which sounds
like a beacon interval interrupt.

>> I don't have a rtl8192cu dongle on hand, but I'll try to find one.
> 
> Maceij,
> 
> Does this patch fix the problem?

The beacon seems to be updating now and STAs no longer get stuck in PS
mode.
Although sometimes (every 2-3 minutes with continuous 1s interval pings)
there is around 5s delay in updating the transmitted beacon - don't know
why, maybe the NIC hardware still has the old version in queue?

I doubt, however that this set_tim() callback should be added for every
rtlwifi device type.

As I have said above, PCI devices seem to already have a mechanism in
place to update their beacon each beacon interval.
Your test that RTL8821AE works without this patch confirms that (at
least for the rtl8821ae driver).

It seems this callback is only necessarily for USB rtlwifi devices.
Which currently means rtl8192cu only.

Thanks,
Maciej
