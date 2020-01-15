Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C976313CD9A
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 21:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729577AbgAOUAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 15:00:12 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:55650 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729025AbgAOUAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 15:00:11 -0500
Received: from [192.168.1.47] (unknown [50.34.171.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 4CB5C2F7539;
        Wed, 15 Jan 2020 12:00:10 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 4CB5C2F7539
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1579118410;
        bh=x+9Xkl9/U+uIpqovRnoe0ypuSx0FMZEYiovi++h5qq0=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=kExQPc/GvEC5p/X4GnV5ZdopqbllWPI1LYwCStGFcYKqaA/dmEpnE5DXoOhJR2gaL
         8kse7VkyqNXsKIxu/ki7RuzKChSqzV/yU8BY2UfVNE2sAGMhHUKwGPSco58U43Mre7
         ntH34aGD6upDa3sDhq9/2YNnMMvp9Yx1kX/kkzWU=
Subject: Re: vrf and multicast is broken in some cases
To:     Ido Schimmel <idosch@idosch.org>
References: <e439bcae-7d20-801c-007d-a41e8e9cd5f5@candelatech.com>
 <3906c6fe-e7a7-94c1-9d7d-74050084b56e@gmail.com>
 <dbefe9b1-c846-6cc6-3819-520fd084a447@candelatech.com>
 <20200115191920.GA1490933@splinter>
Cc:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Message-ID: <2b5cae7b-598a-8874-f9e9-5721099b9b6d@candelatech.com>
Date:   Wed, 15 Jan 2020 12:00:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20200115191920.GA1490933@splinter>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 01/15/2020 11:19 AM, Ido Schimmel wrote:
> On Wed, Jan 15, 2020 at 11:02:26AM -0800, Ben Greear wrote:
>>
>>
>> On 01/15/2020 10:45 AM, David Ahern wrote:
>>> On 1/15/20 10:57 AM, Ben Greear wrote:
>>>> Hello,
>>>>
>>>> We put two different ports into their own VRF, and then tried to run a
>>>> multicast
>>>> sender on one and receiver on the other.  The receiver does not receive
>>>> anything.
>>>>
>>>> Is this a known problem?
>>>>
>>>> If we do a similar setup with policy based routing rules instead of VRF,
>>>> then the multicast
>>>> test works.
>>>>
>>>
>>> It works for OSPF for example. I have lost track of FRR features that
>>> use it, so you will need to specify more details.
>>>
>>> Are the sender / receiver on the same host?
>>
>> Yes, like eth2 sending to eth3, eth2 is associated with _vrf2, eth3 with _vrf3.
>
> Two questions:
>
> 1. Did you re-order the FIB rules so that l3mdev rule is before the main
> table?

That seems OK:

[root@lf0313-6477 lanforge]# ip ru show
1000:	from all lookup [l3mdev-table]
1512:	from all lookup local
32766:	from all lookup main
32767:	from all lookup default


> 2. Did you configure a default unreachable route in the VRF?

I did not have this, so maybe that is the issue.  This is my mcast
transmitter table.

[root@lf0313-6477 lanforge]# ip route show table 10
broadcast 7.7.1.0 dev rddVR0  proto kernel  scope link  src 7.7.1.2
7.7.1.0/24 dev rddVR0  scope link  src 7.7.1.2
local 7.7.1.2 dev rddVR0  proto kernel  scope host  src 7.7.1.2
broadcast 7.7.1.255 dev rddVR0  proto kernel  scope link  src 7.7.1.2

When sniffing, I see IGMP group add/delete messages sent from the receiver
towards the sender, but transmitted mcast frames are not seen on the rddVR0
(veth mcast sender port).

>
> IIRC, locally generated multicast packets are forwarded according to the
> unicast FIB rules, so if you don't have the unreachable route, it is
> possible the packet is forwarded according to the default route in the
> main table.

And now that is interesting.  When I sniff on eth0, which holds the default
route outside of the VRFs, then I do see the mcast frames sent there.

I tried adding default routes, and now sure enough it starts working!

[root@lf0313-6477 lanforge]# ip route show table 10
default via 7.7.1.1 dev rddVR0
broadcast 7.7.1.0 dev rddVR0  proto kernel  scope link  src 7.7.1.2
7.7.1.0/24 dev rddVR0  scope link  src 7.7.1.2
local 7.7.1.2 dev rddVR0  proto kernel  scope host  src 7.7.1.2
broadcast 7.7.1.255 dev rddVR0  proto kernel  scope link  src 7.7.1.2


I'll work on adding an un-reachable route when a real gateway is not
configured...

Thanks for the hint, saved me lots of work!

--Ben

>
>>
>> I'll go poking at the code.
>>
>> Thanks,
>> Ben
>>
>> --
>> Ben Greear <greearb@candelatech.com>
>> Candela Technologies Inc  http://www.candelatech.com
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
