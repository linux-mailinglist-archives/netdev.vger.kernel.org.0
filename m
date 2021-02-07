Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6DAD3122D1
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 09:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhBGIjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 03:39:09 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:13831 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhBGIjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 03:39:03 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601fa6fe0000>; Sun, 07 Feb 2021 00:38:22 -0800
Received: from [172.27.13.234] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 7 Feb
 2021 08:38:20 +0000
Subject: Re: [PATCH net 1/1] netfilter: conntrack: Check offload bit on table
 dump
To:     Florian Westphal <fw@strlen.de>
CC:     Pablo Neira Ayuso <pablo@netfilter.org>, <netdev@vger.kernel.org>,
        "Paul Blakey" <paulb@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>
References: <20210128074052.777999-1-roid@nvidia.com>
 <20210130120114.GA7846@salvia>
 <3a29e9b5-7bf8-5c00-3ede-738f9b4725bf@nvidia.com>
 <997cbda4-acd1-a000-1408-269bc5c3abf3@nvidia.com>
 <20210201030853.GA19878@salvia>
 <1229b966-7772-44bd-6e91-fbde213ceb2d@nvidia.com>
 <20210201115036.GB12443@breakpoint.cc>
 <edb8da93-d859-e7ae-53dd-cae09dff2eba@nvidia.com>
 <20210201152534.GJ12443@breakpoint.cc>
 <a908ac8f-1fb4-1427-520d-3a702ecb7597@nvidia.com>
 <20210203125035.GC16570@breakpoint.cc>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <a283c129-5faa-17b3-b13a-ef336e3d5f85@nvidia.com>
Date:   Sun, 7 Feb 2021 10:38:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210203125035.GC16570@breakpoint.cc>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612687102; bh=ckRaYIZhNfErdXl967jJneHJtZmeMgdH1Sb8jC/hjf4=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=DkT08IiTnmG80HLmxF5NGTkzAsrk5712nMn2jxldGIE9mDHWWbqMgZ5P1SBtMzSpz
         ejGCqHDWNXC8LxQtP+6E5NVYnHfphSO58iQnOEjC6URS+yC5RW9C5fOOllkCIzwPEP
         HwHlnMW1ZyymDno7+p/bOMZR8FCRRv3ASC4eTVqjzX0N4Rxm3Twfbs/8oN9iOM98Jx
         wrmfy51LnU3CF4WB7I/vIT32FEGXdoiHyEnpTCR15Y1wYrN8m3ayrUXg5Ezqnmzqs6
         I4Y+pgho9+Qk+V0slUu13fcGnYlJJ9Hkn+nUzOWU2hNKmJU2lwZ5lKC4l/p/n9f/bb
         Ynadh1egpY9tw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-02-03 2:50 PM, Florian Westphal wrote:
> Roi Dayan <roid@nvidia.com> wrote:
>>> Do you think rhashtable_insert_fast() in flow_offload_add() blocks for
>>> dozens of seconds?
>>
>> I'm not sure. but its not only that but also the time to be in
>> established state as only then we offload.
> 
> That makes it even more weird.  Timeout for established is even larger.
> In case of TCP, its days... so I don't understand at all :/
> 
>>> Thats about the only thing I can see between 'offload bit gets set'
>>> and 'timeout is extended' in flow_offload_add() that could at least
>>> spend *some* time.
>>>
>>>> We hit this issue before more easily and pushed this fix
>>>>
>>>> 4203b19c2796 netfilter: flowtable: Set offload timeout when adding flow
>>>
>>> This fix makes sense to me.
>>
>> I just noted we didn't test correctly Pablo's suggestion instead of
>> to check the bit and extend the timeout in ctnetlink_dump_table() and
>> ct_seq_show() like GC does.
> 
> Ok.  Extending it there makes sense, but I still don't understand
> why newly offloaded flows hit this problem.
> 
> Flow offload should never see a 'about to expire' ct entry.
> The 'extend timeout from gc' is more to make sure GC doesn't reap
> long-lived entries that have been offloaded aeons ago, not 'prevent
> new flows from getting zapped...'
> 

I'll add that an extended timeout from gc is if gc actually iterated
this conn since it was created.
I'll investigate this more and try to do more tests.
thanks for the info
