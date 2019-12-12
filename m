Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F35CE11D8ED
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 22:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731253AbfLLV6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 16:58:12 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:51042 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730779AbfLLV6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 16:58:12 -0500
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id DE78813C2B0;
        Thu, 12 Dec 2019 13:58:10 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com DE78813C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1576187891;
        bh=mc4LwkIoijYEDOrgpkpHsgVxA6b5cRimdg12OtJw/FI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=hjbdk+JEz1JKGv5oYdJK/pK9RzDrJa0Z57d0rgpIjcVJyhB/8wK8rky5qWssETWrO
         Rs2BjH8+oFjxZFzvyBFgRVV+qGxXPpvV/LCySQvU5pOzle1aWbhErZKqGy+SKCqwXF
         QZrzOIre2AEfuGmBtQyoJy7iqZH6AHkhw8w84HAg=
Subject: Re: debugging TCP stalls on high-speed wifi
To:     Johannes Berg <johannes@sipsolutions.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>
References: <14cedbb9300f887fecc399ebcdb70c153955f876.camel@sipsolutions.net>
 <CADVnQym_CNktZ917q0-9dVY9dhtiJVRRotGTrPNdZUpkjd3vyw@mail.gmail.com>
 <f4670ce0f4399fe82e7168fb9c491d8eb718e8d8.camel@sipsolutions.net>
 <99748db5-7898-534b-d407-ed819f07f939@gmail.com>
 <ff6b35ad589d7cf0710cb9fca4c799538da2e653.camel@sipsolutions.net>
 <04dc171a-7385-6544-6cc6-141aae9f2782@candelatech.com>
 <49cd2d6c7bf597c224edb8806cd56c126b5901b4.camel@sipsolutions.net>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <4689a558-4fbe-a488-3384-24981a99fb1d@candelatech.com>
Date:   Thu, 12 Dec 2019 13:58:09 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <49cd2d6c7bf597c224edb8806cd56c126b5901b4.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/12/19 1:46 PM, Johannes Berg wrote:
> On Thu, 2019-12-12 at 13:29 -0800, Ben Greear wrote:
>>
>>> (*) Hmm. Now I have another idea. Maybe we have some kind of problem
>>> with the medium access configuration, and we transmit all this data
>>> without the AP having a chance to send back all the ACKs? Too bad I
>>> can't put an air sniffer into the setup - it's a conductive setup.
>>
>> splitter/combiner?
> 
> I guess. I haven't looked at it, it's halfway around the world or
> something :)
> 
>> If it is just delayed acks coming back, which would slow down a stream, then
>> multiple streams would tend to work around that problem?
> 
> Only a bit, because it allows somewhat more outstanding data. But each
> stream estimates the throughput lower in its congestion control
> algorithm, so it would have a smaller window size?
> 
> What I was thinking is that if we have some kind of skew in the system
> and always/frequently/sometimes make our transmissions have priority
> over the AP transmissions, then we'd not get ACKs back, and that might
> cause what I see - the queue drains entirely and *then* we get an ACK
> back...
> 
> That's not a _bad_ theory and I'll have to find a good way to test it,
> but I'm not entirely convinced that's the problem.
> 
> Oh, actually, I guess I know it's *not* the problem because otherwise
> the ss output would show we're blocked on congestion window far more
> than it looks like now? I think?

If you get the rough packet counters or characteristics, you could set up UDP flows to mimic
download and upload packet behaviour and run them concurrently.  If you can still push a good bit more UDP up even
with small UDP packets emulating TCP acks coming down, then I think you can be
confident that it is not ACKs clogging up the RF or AP being starved for airtime.

Since the windows driver works better, then probably it is not much to do with ACKs or
downstream traffic anyway.

>> 		TCP_TSQ=200
> 
> Setting it to 200 is way excessive. In particular since you already get
> the *8 from the default mac80211 behaviour, so now you effectively have
> *1600, which means instead of 1ms you can have 1.6s worth of TCP data on
> the queues ... way too much :)

Yes, this was hacked in back when the pacing did not work well with ath10k.
I'll do some tests to see how much this matters on modern kernels when I get
a chance.

This will allow huge congestion control windows....

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

