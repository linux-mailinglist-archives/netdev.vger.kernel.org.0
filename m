Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACA8BD6882
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 19:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388540AbfJNRd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 13:33:27 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:34408 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730307AbfJNRd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 13:33:27 -0400
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 8C95B137533;
        Mon, 14 Oct 2019 10:33:26 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 8C95B137533
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1571074406;
        bh=FKRNP+ZkOo3AY1vhdbMGqzZvplA6LM4PXPLVbSPT3oM=;
        h=Subject:From:To:References:Date:In-Reply-To:From;
        b=DC7whreDhQ7oM30gZ5/lQb6FzBagkQMKHrFdrArYciMvanIwLPoNeNXc9vHnYhq1K
         1vjBTD0AxUljgdyxOldbjUpIrgxiPX123usp+xLOW8TNUUZg6pG2ruXNx9FhT0yaOS
         1Av0MgTxJTOFMQ4KU9dHOY55Lb0UzPI/fLWgOinU=
Subject: Re: Strange routing with VRF and 5.2.7+
From:   Ben Greear <greearb@candelatech.com>
To:     David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>
References: <91749b17-7800-44c0-d137-5242b8ceb819@candelatech.com>
 <51aae991-a320-43be-bf73-8b8c0ffcba60@candelatech.com>
 <7d1de949-5cf0-cb74-6ca3-52315c34a340@candelatech.com>
 <795cb41e-4990-fdbe-8cbe-9c0ada751b80@gmail.com>
 <9eb82b65-0067-4320-4b11-7a02b6226cd5@candelatech.com>
Organization: Candela Technologies
Message-ID: <e8e7fd75-7486-0fc8-3ea0-95debe2d37b2@candelatech.com>
Date:   Mon, 14 Oct 2019 10:33:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <9eb82b65-0067-4320-4b11-7a02b6226cd5@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/19 11:45 AM, Ben Greear wrote:
> On 9/22/19 12:23 PM, David Ahern wrote:
>> On 9/20/19 9:57 AM, Ben Greear wrote:
>>> On 9/10/19 6:08 PM, Ben Greear wrote:
>>>> On 9/10/19 3:17 PM, Ben Greear wrote:
>>>>> Today we were testing creating 200 virtual station vdevs on ath9k,
>>>>> and using
>>>>> VRF for the routing.
>>>>
>>>> Looks like the same issue happens w/out VRF, but there I have oodles
>>>> of routing
>>>> rules, so it is an area ripe for failure.
>>>>
>>>> Will upgrade to 5.2.14+ and retest, and try 4.20 as well....
>>>
>>> Turns out, this was ipsec (strongswan) inserting a rule that pointed to
>>> a table
>>> that we then used for a vrf w/out realizing the rule was added.
>>>
>>> Stopping strongswan and/or reconfiguring how routing tables are assigned
>>> resolved the issue.
>>>
>>
>> Hi Ben:
>>
>> Since you are the pioneer with vrf and ipsec, can you add an ipsec
>> section with some notes to Documentation/networking/vrf.txt?
> 
> I need to to some more testing, an initial attempt to reproduce my working
> config on another system did not work properly, and I have not yet dug into
> it.

I'm still grinding out the bugs...  Here is my current quandry.

In the VRF I have the 'real' device, say eth4 with IP 192.168.5.5.  This talks to
the VPN gateway device at 192.168.5.1.

When I add the xfrm, it is given the address 192.168.10.100.

I need all traffic routing out the vrf to use the xfrm as source IP,
except the eth4 still needs to be able to talk to the 5.1 device
(I think?)

Evidently, adding this type of route below will do the trick, at least in
non-vrf setup, and with this route in its own table that is queried after
'local' routing table, but before the others via use of a fairly generic rule....

default via 192.168.5.1 dev enp1s0 proto static src 192.168.10.100

I am guessing that in VRF world, I can get rid of the rule, and replace the
existing default route (given to eth4 when it does DHCP or is statically assigned)
with something like the above.  And, maybe I need a special route for the VPN
gateway itself as destination so that ipsec logic on eth4 can still talk to it?

(I am thinking of the case where the VPN gateway is not on the local subnet
and so we have to route to it special???)

Any insight is welcome.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

