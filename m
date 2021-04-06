Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D584F355B64
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 20:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238903AbhDFS3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 14:29:52 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:38006 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238613AbhDFS32 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 14:29:28 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.93.0.4)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1lTqRr-0003Ku-8U; Tue, 06 Apr 2021 20:29:11 +0200
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
References: <e2924d81-0e30-2dd0-292b-428fea199484@maciej.szmigiero.name>
 <846f6166-c570-01fc-6bbc-3e3b44e51327@maciej.szmigiero.name>
 <87r1jnohq6.fsf@codeaurora.org>
 <8e0434eb-d15f-065d-2ba7-b50c67877112@maciej.szmigiero.name>
 <a2003668-5108-27b9-95cd-9e1d5d1aa94d@lwfinger.net>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: rtlwifi/rtl8192cu AP mode broken with PS STA
Message-ID: <1cec013f-1f30-ec40-ed73-1dea2dc74d5f@maciej.szmigiero.name>
Date:   Tue, 6 Apr 2021 20:29:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <a2003668-5108-27b9-95cd-9e1d5d1aa94d@lwfinger.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.04.2021 18:25, Larry Finger wrote:
> On 4/6/21 7:06 AM, Maciej S. Szmigiero wrote:
>> On 06.04.2021 12:00, Kalle Valo wrote:
>>> "Maciej S. Szmigiero" <mail@maciej.szmigiero.name> writes:
>>>
>>>> On 29.03.2021 00:54, Maciej S. Szmigiero wrote:
>>>>> Hi,
>>>>>
>>>>> It looks like rtlwifi/rtl8192cu AP mode is broken when a STA is using PS,
>>>>> since the driver does not update its beacon to account for TIM changes,
>>>>> so a station that is sleeping will never learn that it has packets
>>>>> buffered at the AP.
>>>>>
>>>>> Looking at the code, the rtl8192cu driver implements neither the set_tim()
>>>>> callback, nor does it explicitly update beacon data periodically, so it
>>>>> has no way to learn that it had changed.
>>>>>
>>>>> This results in the AP mode being virtually unusable with STAs that do
>>>>> PS and don't allow for it to be disabled (IoT devices, mobile phones,
>>>>> etc.).
>>>>>
>>>>> I think the easiest fix here would be to implement set_tim() for example
>>>>> the way rt2x00 driver does: queue a work or schedule a tasklet to update
>>>>> the beacon data on the device.
>>>>
>>>> Are there any plans to fix this?
>>>> The driver is listed as maintained by Ping-Ke.
>>>
>>> Yeah, power save is hard and I'm not surprised that there are drivers
>>> with broken power save mode support. If there's no fix available we
>>> should stop supporting AP mode in the driver.
>>>
>>
>> https://wireless.wiki.kernel.org/en/developers/documentation/mac80211/api
>> clearly documents that "For AP mode, it must (...) react to the set_tim()
>> callback or fetch each beacon from mac80211".
>>
>> The driver isn't doing either so no wonder the beacon it is sending
>> isn't getting updated.
>>
>> As I have said above, it seems to me that all that needs to be done here
>> is to queue a work in a set_tim() callback, then call
>> send_beacon_frame() from rtlwifi/core.c from this work.
>>
>> But I don't know the exact device semantics, maybe it needs some other
>> notification that the beacon has changed, too, or even tries to
>> manage the TIM bitmap by itself.
>>
>> It would be a shame to lose the AP mode for such minor thing, though.
>>
>> I would play with this myself, but unfortunately I don't have time
>> to work on this right now.
>>
>> That's where my question to Realtek comes: are there plans to actually
>> fix this?
> 
> Yes, I am working on this. My only question is "if you are such an expert on the problem, why do you not fix it?"

I don't think I am an expert here - I've tried to use a rtl8192cu USB
dongle in AP mode but its STAs would become unreachable or disconnect
after a short while, so I have started investigating the reason for such
problems.
Ultimately, I have traced it to DTIM in beacons not indicating there are
frames buffered for connected stations.

Then I've looked how the beacon that is broadcast is supposed to get
updated when it changes and seen there seems to be no existing mechanism
for this in rtl8192cu driver.
However, I had to stop at this point and post my findings as I could not
commit more time to this issue due to other workload.

> The example in rx200 is not particularly useful, and I have not found any other examples.

That's why I thought it would be best if somebody from Realtek, with
deep knowledge of both the driver and the hardware, could voice their
opinion here.

As I have stated earlier, just uploading new beacon to the hardware
might not be enough for it to be (safely) updated.

> Larry
> 

Thanks,
Maciej
