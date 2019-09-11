Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4DA8AFD54
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 15:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbfIKNDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 09:03:46 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:57976 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbfIKNDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 09:03:46 -0400
Received: from [192.168.1.47] (unknown [50.34.216.97])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 4D7DE104F;
        Wed, 11 Sep 2019 06:03:44 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 4D7DE104F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1568207025;
        bh=XIn3JBORtKzOkERfGjA3+iWzadACjJyAvSCJ/fogVqA=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=CzsmEeLIiQrpfB+wLCa7XQ8FXXHnDjxlpGIfPOi68TLjouBlWMdKbC+N/VH+BHLCS
         InupJwTM0AK4i+yPeXA3RNJ1+VM/pj8ZcG1bZdo+jZLXFasa0bGpjtwb+ohIx+K3KY
         56+I9JUpJk4JZ7/mO6xiUBOyvT4kdLGGAwQUK2xY=
Subject: Re: WARNING at net/mac80211/sta_info.c:1057
 (__sta_info_destroy_part2())
To:     Johannes Berg <johannes@sipsolutions.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <CAHk-=wgBuu8PiYpD7uWgxTSY8aUOJj6NJ=ivNQPYjAKO=cRinA@mail.gmail.com>
 <feecebfcceba521703f13c8ee7f5bb9016924cb6.camel@sipsolutions.net>
 <CAHk-=wj_jneK+UYzHhjwsH0XxP0knM+2o2OeFVEz-FjuQ77-ow@mail.gmail.com>
 <30679d3f86731475943856196478677e70a349a9.camel@sipsolutions.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Message-ID: <2d673d55-eb27-8573-b8ae-a493335723cf@candelatech.com>
Date:   Wed, 11 Sep 2019 06:03:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <30679d3f86731475943856196478677e70a349a9.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09/11/2019 05:04 AM, Johannes Berg wrote:
> On Wed, 2019-09-11 at 12:58 +0100, Linus Torvalds wrote:
>>
>> And I didn't think about it or double-check, because the errors that
>> then followed later _looked_ like that TX power failing that I thought
>> hadn't happened.
>
> Yeah, it could be something already got stuck there, hard to say.
>
>>> Since we see that something actually did an rfkill operation. Did you
>>> push a button there?
>>
>> No, I tried to turn off and turn on Wifi manually (no button, just the
>> settings panel).
>
> That does usually also cause rfkill, so that explains how we got down
> this particular code path.
>
>> I didn't notice the WARN_ON(), I just noticed that there was no
>> networking, and "turn it off and on again" is obviously the first
>> thing to try ;)
>
> :-)
>
>> Sep 11 10:27:13 xps13 kernel: WARNING: CPU: 4 PID: 1246 at
>> net/mac80211/sta_info.c:1057 __sta_info_destroy_part2+0x147/0x150
>> [mac80211]
>>
>> but if you want full logs I can send them in private to you.
>
> No, it's fine, though maybe Kalle does - he was stepping out for a while
> but said he'd look later.
>
> This is the interesting time - 10:27:13 we get one of the first
> failures. Really the first one was this:
>
>> Sep 11 10:27:07 xps13 kernel: ath10k_pci 0000:02:00.0: wmi command 16387 timeout, restarting hardware
>
>
>> I do suspect it's atheros and suspend/resume or something. The
>> wireless clearly worked for a while after the resume, but then at some
>> point it stopped.
>
> I'm not really sure it's related to suspend/resume at all, the firmware
> seems to just have gotten stuck, and the device and firmware most likely
> got reset over the suspend/resume anyway.
>
>>> The only explanation I therefore have is that something is just taking
>>> *forever* in that code path, hence my question about timing information
>>> on the logs.
>>
>> Yeah, maybe it would time out everything eventually. But not for a
>> long time. It hadn't cleared up by
>>
>>   Sep 11 10:36:21 xps13 gnome-session-f[6837]: gnome-session-failed:
>> Fatal IO error 0 (Success) on X server :0.
>
> Ok, that's way longer than I would have guessed even! That's over 9
> minutes, that'd be close to 200 commands having to be issued and timing
> out ...
>
> I don't know. What I wrote before is basically all I can say, I think
> the driver gets stuck somewhere waiting for the device "forever", and
> the stack just doesn't get to release the lock, causing all the follow-
> up problems.

It looks to me like the ath10k firmware is not responding to commands and/or
is out of its WMI tx credits.  The code often takes a lock and then blocks for up to 3
or so seconds waiting for a response from the firmware, and the mac80211 calling
code is often already holding rtnl.  Pretty much every mac80211 call will cause a
WMI message and thus potentially hit this timeout.

This can easily cause rtnl to be held for 3 seconds, but after that, I believe
upstream ath10k will now time out and kill the firmware and restart.  (I run
a significantly modified ath10k driver, and that is how mine works, at least.)

In this case, it looks like restarting the firmware/NIC failed, and I guess
that must get it in a state where it is still blocking and trying to talk
to the firmware?  Or maybe deadlock down inside ath10k driver.

For what it's worth, we see that WARN_ON often when ath10k firmware crashes, but it
seems to not be a big deal and the system normally recovers fine.

Out of curiosity, I'm interested to know what ath10k NIC chipset this is from.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
