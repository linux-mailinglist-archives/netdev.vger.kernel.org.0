Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBB6355321
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 14:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343691AbhDFMHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 08:07:00 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:41686 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232861AbhDFMG7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 08:06:59 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.93.0.4)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1lTkTj-0002Tk-UG; Tue, 06 Apr 2021 14:06:43 +0200
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
References: <e2924d81-0e30-2dd0-292b-428fea199484@maciej.szmigiero.name>
 <846f6166-c570-01fc-6bbc-3e3b44e51327@maciej.szmigiero.name>
 <87r1jnohq6.fsf@codeaurora.org>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: rtlwifi/rtl8192cu AP mode broken with PS STA
Message-ID: <8e0434eb-d15f-065d-2ba7-b50c67877112@maciej.szmigiero.name>
Date:   Tue, 6 Apr 2021 14:06:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <87r1jnohq6.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.04.2021 12:00, Kalle Valo wrote:
> "Maciej S. Szmigiero" <mail@maciej.szmigiero.name> writes:
> 
>> On 29.03.2021 00:54, Maciej S. Szmigiero wrote:
>>> Hi,
>>>
>>> It looks like rtlwifi/rtl8192cu AP mode is broken when a STA is using PS,
>>> since the driver does not update its beacon to account for TIM changes,
>>> so a station that is sleeping will never learn that it has packets
>>> buffered at the AP.
>>>
>>> Looking at the code, the rtl8192cu driver implements neither the set_tim()
>>> callback, nor does it explicitly update beacon data periodically, so it
>>> has no way to learn that it had changed.
>>>
>>> This results in the AP mode being virtually unusable with STAs that do
>>> PS and don't allow for it to be disabled (IoT devices, mobile phones,
>>> etc.).
>>>
>>> I think the easiest fix here would be to implement set_tim() for example
>>> the way rt2x00 driver does: queue a work or schedule a tasklet to update
>>> the beacon data on the device.
>>
>> Are there any plans to fix this?
>> The driver is listed as maintained by Ping-Ke.
> 
> Yeah, power save is hard and I'm not surprised that there are drivers
> with broken power save mode support. If there's no fix available we
> should stop supporting AP mode in the driver.
> 

https://wireless.wiki.kernel.org/en/developers/documentation/mac80211/api
clearly documents that "For AP mode, it must (...) react to the set_tim()
callback or fetch each beacon from mac80211".

The driver isn't doing either so no wonder the beacon it is sending
isn't getting updated.

As I have said above, it seems to me that all that needs to be done here
is to queue a work in a set_tim() callback, then call
send_beacon_frame() from rtlwifi/core.c from this work.

But I don't know the exact device semantics, maybe it needs some other
notification that the beacon has changed, too, or even tries to
manage the TIM bitmap by itself.

It would be a shame to lose the AP mode for such minor thing, though.

I would play with this myself, but unfortunately I don't have time
to work on this right now.

That's where my question to Realtek comes: are there plans to actually
fix this?

Maciej
