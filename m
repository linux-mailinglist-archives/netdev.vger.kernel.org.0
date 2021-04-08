Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9232E358D3B
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 21:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbhDHTFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 15:05:19 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:50524 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232885AbhDHTFT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 15:05:19 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.93.0.4)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1lUZxY-0002jj-L9; Thu, 08 Apr 2021 21:04:56 +0200
To:     Pkshih <pkshih@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
References: <e2924d81-0e30-2dd0-292b-428fea199484@maciej.szmigiero.name>
 <846f6166-c570-01fc-6bbc-3e3b44e51327@maciej.szmigiero.name>
 <87r1jnohq6.fsf@codeaurora.org>
 <8e0434eb-d15f-065d-2ba7-b50c67877112@maciej.szmigiero.name>
 <a2003668-5108-27b9-95cd-9e1d5d1aa94d@lwfinger.net>
 <1617763692.9857.7.camel@realtek.com>
 <1dc7e487-b97b-8584-47f7-37f3385c7bf9@lwfinger.net>
 <15737dcf-95ac-1ce6-a681-94ff5db968e4@maciej.szmigiero.name>
 <c5556a207c5c40ac849c6a0e1919baca@realtek.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: rtlwifi/rtl8192cu AP mode broken with PS STA
Message-ID: <220c4fe4-c9e1-347a-8cef-cd91d31c56df@maciej.szmigiero.name>
Date:   Thu, 8 Apr 2021 21:04:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <c5556a207c5c40ac849c6a0e1919baca@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.04.2021 06:42, Pkshih wrote:
>> -----Original Message-----
>> From: Maciej S. Szmigiero [mailto:mail@maciej.szmigiero.name]
>> Sent: Thursday, April 08, 2021 4:53 AM
>> To: Larry Finger; Pkshih
>> Cc: linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
>> johannes@sipsolutions.net; kvalo@codeaurora.org
>> Subject: Re: rtlwifi/rtl8192cu AP mode broken with PS STA
>>
(...)
>>> Maceij,
>>>
>>> Does this patch fix the problem?
>>
>> The beacon seems to be updating now and STAs no longer get stuck in PS
>> mode.
>> Although sometimes (every 2-3 minutes with continuous 1s interval pings)
>> there is around 5s delay in updating the transmitted beacon - don't know
>> why, maybe the NIC hardware still has the old version in queue?
> 
> Since USB device doesn't update every beacon, dtim_count isn't updated neither.
> It leads STA doesn't awake properly. Please try to fix dtim_period=1 in
> hostapd.conf, which tells STA awakes every beacon interval.

The situation is the same with dtim_period=1.

When I look at a packet trace (captured from a different NIC running in
monitor mode) it's obvious that the pinged STA wakes up almost
immediately once it sees its DTIM bit set in a beacon.

But many beacons pass (the network has beacon interval of 0.1s) between
where a ping request (ICMP echo request) is buffered on the AP and where
the transmitted beacon actually starts to have DTIM bit set.

I am observing delays up to 9 seconds, which means a delay up to 90
beacons between when DTIM bit should be set and when it actually gets
set.

As I said above, this happens only sometimes (every 2-3 minutes with
continuous 1s interval pings) but there is definitely something wrong
here.

My wild guess would be that if the NIC is prevented from sending a beacon
due to, for example, its radio channel being busy it keeps that beacon
in queue for the next transmission attempt and only then sends it and
removes from that queue.
Even thought there might be newer beacon data already available for
transmission.

And then these "unsent" beacons pile up in queue and the delays I am
observing are simply old queued beacons (that don't have the DTIM bit
set yet) being transmitted.

But that's just my hypothesis - I don't know how rtl8192cu hardware
actually works.

> --
> Ping-Ke

Thanks,
Maciej
