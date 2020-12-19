Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC71C2DF090
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 17:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgLSQzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 11:55:49 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:45144 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbgLSQzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Dec 2020 11:55:48 -0500
Received: from [192.168.254.6] (unknown [50.46.158.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id B576613C2B0;
        Sat, 19 Dec 2020 08:55:06 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com B576613C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1608396907;
        bh=N8Teo2Gvj/dcotfU7a3Y6k0H/wTnwCczQpS2oTRP+k4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=dgkA0UhIe/zektImVhncv+1MCMKZAVORkf0DA/F62xbk2jMreowvM9op8LGPjydav
         1eIAzHsmHqPiwbLHjLA8V7tZ5sMKGCtPoxXKOCZw5O6SWyfzDWQkHBz5HQxPJkQ84s
         2asDpS0mToV9TZizT2hdNp/UnQzFN5pTe51j95X0=
Subject: Re: net: tso: add UDP segmentation support: adds regression for ax200
 upload
To:     Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luca Coelho <luciano.coelho@intel.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org
References: <5664fa0f-aef2-c336-651a-093c9eed23ab@candelatech.com>
 <765f370d-ce2d-b75a-2dde-87f69ae7c185@candelatech.com>
 <CANn89iKpa1y2SKJuR9kRi=AZs94sj+-tzRs+2D0vmxh+ahEcGA@mail.gmail.com>
 <adbee2ec-c6ba-7a17-eb98-1c53365fa911@candelatech.com>
 <CANn89iJQnSVZFp2XDgREN1QMtU4exOsnJq=5VzJ6tqTCJ7MH-g@mail.gmail.com>
 <c4bcee7d-b2eb-759c-c659-d65f3e7daec9@candelatech.com>
 <CANn89i++Kgkj57ms70a5GDOQ-Cpewx3NQkzP3EmZmLYQ4eHzww@mail.gmail.com>
 <5d89fd24-f00a-7e70-00ce-83529f13b05e@candelatech.com>
 <20201218121627.603329b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <9003ea3720a03b4bd1b8abf3d8f645563a58f953.camel@sipsolutions.net>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <43a5b45c-955a-22d4-2bf9-dbab852dbb5f@candelatech.com>
Date:   Sat, 19 Dec 2020 08:55:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <9003ea3720a03b4bd1b8abf3d8f645563a58f953.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/19/20 7:18 AM, Johannes Berg wrote:
> On Fri, 2020-12-18 at 12:16 -0800, Jakub Kicinski wrote:
>> On Thu, 17 Dec 2020 12:40:26 -0800 Ben Greear wrote:
>>> On 12/17/20 10:20 AM, Eric Dumazet wrote:
>>>> On Thu, Dec 17, 2020 at 7:13 PM Ben Greear <greearb@candelatech.com> wrote:
>>>>> It is the iwlwifi/mvm logic that supports ax200.
>>>>
>>>> Let me ask again :
>>>>
>>>> I see two different potential call points :
>>>>
>>>> drivers/net/wireless/intel/iwlwifi/pcie/tx.c:1529:
>>>> tso_build_hdr(skb, hdr_page->pos, &tso, data_left, !total_len);
>>>> drivers/net/wireless/intel/iwlwifi/queue/tx.c:427:
>>>> tso_build_hdr(skb, hdr_page->pos, &tso, data_left, !total_len);
>>>>
>>>> To the best of your knowledge, which one would be used in your case ?
>>>>
>>>> Both are horribly complex, I do not want to spend time studying two
>>>> implementations.
>>>
>>> It is the queue/tx.c code that executes on my system, verified with
>>> printk.
>>
>> Not sure why Intel's not on CC here.
> 
> Heh :)
> 
> Let's also add linux-wireless.
> 
>> Luca, is the ax200 TSO performance regression with recent kernel on your
>> radar?
> 
> It wasn't on mine for sure, so far. But it's supposed to be Christmas
> vacation, so haven't checked our bug tracker etc. I see Emmanuel was at
> least looking at the bug report, but not sure what else happened yet.

Not to bitch and moan too much, but even the most basic of testing would
have shown this, how can testing be so poor on the ax200 driver?

It even shows up with the out-of-tree ax200 driver.

> Off the top of my head, I don't really see the issue. Does anyone have
> the ability to capture the frames over the air (e.g. with another AX200
> in monitor mode, load the driver with amsdu_size=3 module parameter to
> properly capture A-MSDUs)?

I can do that at some point, and likely it could be reproduced with an /n or /ac
AP and those are a lot easier to sniff.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
