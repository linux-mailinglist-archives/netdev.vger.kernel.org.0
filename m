Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1C030AA6E
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 16:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbhBAPFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 10:05:25 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10357 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbhBAPFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 10:05:08 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601818830000>; Mon, 01 Feb 2021 07:04:35 -0800
Received: from [172.27.14.151] (172.20.145.6) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 15:04:33 +0000
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
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <edb8da93-d859-e7ae-53dd-cae09dff2eba@nvidia.com>
Date:   Mon, 1 Feb 2021 17:04:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210201115036.GB12443@breakpoint.cc>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL101.nvidia.com (172.20.187.10)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612191875; bh=OKk8Wm1Nl876VozeMcsIPd2bPWbPqu6Qu8VEGR6jDOE=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=CqTIckptOaNH1xRTTrz7MGzaUjUiy+mQNYrKSe40crESlGQlBeCDrI9xvJ4+G+pPL
         6sE+1RmAfxguSnWJN5xs+UZRHsAs93p4hLGfi1rxAMZfus7+VnkqyfRclYeQDkFkbM
         XVYFBJCUgWZYI260QhHWtYQ2N9I1n2T4QG2L0VbYghKyMT2zV5R9heWHu8s8hzs/do
         uJOTdCmcxxe0SospkwS9KqepsN4Jgk+55n10bkXoKi8hN4/yqVoEE+p7A7JB8qBpHh
         XdSdmIPI8P/PJX7V6BJAwpJx81gfkX69qPskMnkzJjYh4fq17O0Czjo+PAGCsTH7ZY
         5wGOyw0RnGZxw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-02-01 1:50 PM, Florian Westphal wrote:
> Roi Dayan <roid@nvidia.com> wrote:
>>>> There is a 3rd caller nf_ct_gc_expired() which being called by 3
>>>> other callers:
>>>> ____nf_conntrack_find()
>>>> nf_conntrack_tuple_taken()
>>>> early_drop_list()
>>>
>>> Hm. I'm not sure yet what path is triggering this bug.
>>>
>>> Florian came up with the idea of setting a very large timeout for
>>> offloaded flows (that are refreshed by the garbage collector) to avoid
>>> the extra check from the packet path, so those 3 functions above never
>>> hit the garbage collection path. This also applies for the ctnetlink
>>> (conntrack -L) and the /proc/net/nf_conntrack sysctl paths that the
>>> patch describes, those should not ever see an offloaded flow with a
>>> small timeout.
>>>
>>> nf_ct_offload_timeout() is called from:
>>>
>>> #1 flow_offload_add() to set a very large timer.
>>> #2 the garbage collector path, to refresh the timeout the very large
>>>      offload timer.
>>>
>>> Probably there is a race between setting the IPS_OFFLOAD and when
>>> flow_offload_add() is called? Garbage collector gets in between and
>>> zaps the connection. Is a newly offloaded connection that you observed
>>> that is being removed?
>>>
>>
>> yes. the flows being removed are newly offloaded connections.
> 
> If they are new, how can they be timed out already?
> 
> TCP initial timeout is one minute, UDP 30 seconds.
> That should surely be enough to do flow_offload_add (which extends
> the timeout)?

Yes, flow_offload_add() extends the timeout. but it needs to finish.

> 
> Maybe something is doing flow_offload_add() for unconfirmed conntrack?
> 
> In unconfirmed conntrack case, ct->timeout is absolute timeout value, e.g. for
> tcp it will be set to 60 * HZ.

When I hit the issue I printed jiffies and ct->timeout and saw they are
the same or very close but not an absolute number.

> 
> conntrack confirmation adds jiffies32 to it to make it relative
> to current time (this is before insertion into the conntrack table,
> so GC isn't supposed to happen before this).
> 

We hit this issue before more easily and pushed this fix

4203b19c2796 netfilter: flowtable: Set offload timeout when adding flow

That commit changed flow_offload_add() to extend ct timeout because on
we noticed on busy systems GC didn't finish a full iteration on all
conns and conns were cleaned.
I think we might have the same issue.

tcf_ct_flow_table_add() set the offload bit and calls flow_offload_add()

We do know the offload bit is set when conn it deleted, so we hit the
issue where timeout being tested after tcf_ct_flow_table_add() was 
called but before ct timeout was fixed. so flow_offload_add() didn't
finish and GC didn't start, or did start but did not finish full
iteration.

> In any case adding test for the offload bit seems to be papering over
> invalid/broken ct->timeout value.
> 
