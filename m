Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D716DD41EC
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 15:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbfJKN5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 09:57:11 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:49584 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728068AbfJKN5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 09:57:10 -0400
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 07F5E13C340;
        Fri, 11 Oct 2019 06:57:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 07F5E13C340
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1570802230;
        bh=D53uYXs3aE0juT/zjbU0lTYElCrHfrRmv3cuayLXR8Q=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=o/BOx6iosvfqrw/3LMJYQJmH9RC3kJCqu8EhN7u6RFjfjz34kQO7ej/reGpPSu41D
         WrQENnBcCJtC0ckgWk7aoT1VEcs+0zyG/WyLu5vb8l606oP/CS2vFVMhaSglbBJZ6C
         shTBmP4I1F7O7/caBAZcLNBRyJe5G6aRMQSAVWrg=
Subject: Re: IPv6 addr and route is gone after adding port to vrf (5.2.0+)
To:     David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>
References: <c55619f8-c565-d611-0261-c64fa7590274@candelatech.com>
 <2a53ff58-9d5d-ac22-dd23-b4225682c944@gmail.com>
 <ca625841-6de8-addb-9b85-8da90715868c@candelatech.com>
 <e3f2990e-d3d0-e615-8230-dcfe76451c15@gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <3cd9b1a7-bf87-8bd2-84f4-503f300e847b@candelatech.com>
Date:   Fri, 11 Oct 2019 06:57:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <e3f2990e-d3d0-e615-8230-dcfe76451c15@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/16/19 2:48 PM, David Ahern wrote:
> On 8/16/19 3:28 PM, Ben Greear wrote:
>> On 8/16/19 12:15 PM, David Ahern wrote:
>>> On 8/16/19 1:13 PM, Ben Greear wrote:
>>>> I have a problem with a VETH port when setting up a somewhat complicated
>>>> VRF setup. I am loosing the global IPv6 addr, and also the route,
>>>> apparently
>>>> when I add the veth device to a vrf.  From my script's output:
>>>
>>> Either enslave the device before adding the address or enable the
>>> retention of addresses:
>>>
>>> sysctl -q -w net.ipv6.conf.all.keep_addr_on_down=1
>>>
>>
>> Thanks, I added it to the vrf first just in case some other logic was
>> expecting the routes to go away on network down.
>>
>> That part now seems to be working.
>>
> 
> The down-up cycling is done on purpose - to clear out neigh entries and
> routes associated with the device under the old VRF. All entries must be
> created with the device in the new VRF.

I believe I found another thing to be aware of relating to this.

My logic has been to do supplicant, then do DHCP, and only when DHCP
responds do I set up the networking for the wifi station.

It is at this time that I would be creating a VRF (or using routing rules
if not using VRF).

But, when I add the station to the newly created vrf, then it bounces it,
and that causes supplicant to have to re-associate  (I think, lots of moving
pieces, so I could be missing something).

Any chance you could just clear the neighbor entries and routes w/out bouncing
the interface?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

