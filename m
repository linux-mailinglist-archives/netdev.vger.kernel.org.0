Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B649C13CEA3
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 22:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729638AbgAOVJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 16:09:17 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:57506 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729126AbgAOVJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 16:09:17 -0500
Received: from [192.168.1.47] (unknown [50.34.171.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 30797105A;
        Wed, 15 Jan 2020 13:09:16 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 30797105A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1579122556;
        bh=BEmdZ8V9XpYRGugF4/w6bUtb3BRsXBKc17VQNaaNqf4=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=LiomHAmgVadbby2x4os+EQ+GBTjcjIDKhhMyuoakn/434cRHDqZfhkAsVJnmkroZq
         r66mfmYZ3b7R1MkSyglhXlU7wMj42ewnuuj4XxEa7LxrXB7+Gycjm4Pb+Mgf6C1M1E
         aRo4UIdGCWn28nvKMuXcYNFy9SnvNQqr1NJ4SUbE=
Subject: Re: vrf and multicast is broken in some cases
To:     David Ahern <dsahern@gmail.com>, Ido Schimmel <idosch@idosch.org>
References: <e439bcae-7d20-801c-007d-a41e8e9cd5f5@candelatech.com>
 <3906c6fe-e7a7-94c1-9d7d-74050084b56e@gmail.com>
 <dbefe9b1-c846-6cc6-3819-520fd084a447@candelatech.com>
 <20200115191920.GA1490933@splinter>
 <2b5cae7b-598a-8874-f9e9-5721099b9b6d@candelatech.com>
 <20200115202354.GB1513116@splinter>
 <9ed604cd-19de-337a-e112-96e05dad1073@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Message-ID: <127f1b9d-0bbe-5a1b-f322-a467d3f7d764@candelatech.com>
Date:   Wed, 15 Jan 2020 13:09:14 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <9ed604cd-19de-337a-e112-96e05dad1073@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 01/15/2020 12:33 PM, David Ahern wrote:
> On 1/15/20 1:23 PM, Ido Schimmel wrote:
>>
>> I'm not sure this is the correct way (David?). Can you try to delete
>> this default route and instead add a default unreachable route with an
>> high metric according to step 3 in Documentation/networking/vrf.txt:
>>
>> "
>> 3. Set the default route for the table (and hence default route for the VRF).
>>        ip route add table 10 unreachable default metric 4278198272
>>
>>    This high metric value ensures that the default unreachable route can
>>    be overridden by a routing protocol suite.  FRRouting interprets
>>    kernel metrics as a combined admin distance (upper byte) and priority
>>    (lower 3 bytes).  Thus the above metric translates to [255/8192].
>> "
>>
>> If I'm reading ip_route_output_key_hash_rcu() correctly, then the error
>> returned from fib_lookup() because of the unreachable route should allow
>> you to route the packet via the requested interface.
>>
>
> yes, IPv4 is a bit goofy with multicast (at least to me, but then I have
> not done much with mcast).

For the vrf.txt referenced above, it would be nice if it mentioned that
if you do NOT add the default route, it will skip to the main table
and use it's gateway.  I was visualizing VRF as a self contained thing
that would not do such a thing.

When we are using xorp (which is our mcast router), then it automatically
takes care of dealing with replacing an unreachable route and/or metrics,
so in my case, I think the default metric on the unreachable route will
be fine.

That said, I am not sure xorp is completely working with our vrf setup
yet, so I'll keep this in mind next time I am poking at that.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
