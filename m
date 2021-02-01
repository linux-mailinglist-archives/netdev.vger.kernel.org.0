Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDEF30A2E6
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 08:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbhBAHyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 02:54:00 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:5115 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbhBAHx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 02:53:58 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6017b36d0002>; Sun, 31 Jan 2021 23:53:17 -0800
Received: from [172.27.14.151] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 07:53:15 +0000
Subject: Re: [PATCH net 1/1] netfilter: conntrack: Check offload bit on table
 dump
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, Paul Blakey <paulb@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, <fw@strlen.de>
References: <20210128074052.777999-1-roid@nvidia.com>
 <20210130120114.GA7846@salvia>
 <3a29e9b5-7bf8-5c00-3ede-738f9b4725bf@nvidia.com>
 <997cbda4-acd1-a000-1408-269bc5c3abf3@nvidia.com>
 <20210201030853.GA19878@salvia>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <1229b966-7772-44bd-6e91-fbde213ceb2d@nvidia.com>
Date:   Mon, 1 Feb 2021 09:53:18 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210201030853.GA19878@salvia>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612165997; bh=yEbyvGspdsxguPm8obNyss/nkLZKt6NetPJhOlj0tmQ=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=RT6MOJ2Um/rNOBgCHERMC6/sHnbuwuEgINWNWsnEFnyvku1NP+nr/JB7hsVHTwsRz
         oOBcS6JWsBZCdoJNEViXyvX89Lt4tPDY9WULlyrIgE3lPG1qPBrEgtR10q25BxnN+I
         l8PTAdvRc1r+ql/wCgsmkedhDJi1bh5xfLVvGwaN/UY24lk7Vo/e5jGfqbqPKbFqnT
         9Fxv7llVksW3fHzIczU2zVNXMyYTn4pN5FkztdXKB1DHz3ObMwd0F9D2r8Eu5qbP8V
         nV5vflRlAgd1MU4nZMpZjrFHpUnl29Ki2vM9TDoPA98CzNP/S1OjW7kyNv8JvAStdz
         +bnLCVWJ9wU3Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-02-01 5:08 AM, Pablo Neira Ayuso wrote:
> Hi Roi,
> 
> On Sun, Jan 31, 2021 at 03:18:34PM +0200, Roi Dayan wrote:
> [...]
>> Hi Pablo,
>>
>> We did more tests with just updating the timeout in the 2 callers
>> and it's not enough. We reproduce the issue of rules being timed
>> out just now frim different place.
> 
> Thanks for giving it a try to my suggestion, it was not correct.
> 
>> There is a 3rd caller nf_ct_gc_expired() which being called by 3
>> other callers:
>> ____nf_conntrack_find()
>> nf_conntrack_tuple_taken()
>> early_drop_list()
> 
> Hm. I'm not sure yet what path is triggering this bug.
> 
> Florian came up with the idea of setting a very large timeout for
> offloaded flows (that are refreshed by the garbage collector) to avoid
> the extra check from the packet path, so those 3 functions above never
> hit the garbage collection path. This also applies for the ctnetlink
> (conntrack -L) and the /proc/net/nf_conntrack sysctl paths that the
> patch describes, those should not ever see an offloaded flow with a
> small timeout.
> 
> nf_ct_offload_timeout() is called from:
> 
> #1 flow_offload_add() to set a very large timer.
> #2 the garbage collector path, to refresh the timeout the very large
>     offload timer.
> 
> Probably there is a race between setting the IPS_OFFLOAD and when
> flow_offload_add() is called? Garbage collector gets in between and
> zaps the connection. Is a newly offloaded connection that you observed
> that is being removed?
> 

yes. the flows being removed are newly offloaded connections.
I don't think the race is between setting IPS_OFFLOAD and calling
flow_offload_add().
In act_ct.c tcf_ct_flow_table_add() we first set the bit
and then call flow_offload_add().
I think the race is more of getting into the other flows and gc still
didn't kick in.
I'm sure of this because we added trace dump in nf_ct_delete()
and while creating connections we also ran in a loop conntrack -L.
In the same way instead of conntrack we did the dump from
/proc/net/nf_conntrack and we also saw the trace from there.
In this scenario if we stopped the loop of the dump we didn't crash
and then in more tests we failed again after I tried to moving the bit
check to your suggestion.
But leaving the bit check as in this commit we didn't reproduce the
issue at all.

>> only early_drop_list() has a check to skip conns with offload bit
>> but without extending the timeout.
>> I didnt do a dump but the issue could be from the other 2 calls.
>>
>> With current commit as is I didn't need to check more callers as I made
>> sure all callers will skip the non-offload gc.
>>
>> Instead of updating more callers and there might be more callers
>> later why current commit is not enough?
>> We skip offloaded flows and soon gc_worker() will hit and will update
>> the timeout anyway.
> 
> Another possibility would be to check for the offload bit from
> nf_ct_is_expired(), which is coming slighty before nf_ct_should_gc().
> But this is also in the ____nf_conntrack_find() path.
> > Florian?
> 

Right. beside the dumps paths that just call nf_ct_should_gc() which
calls nf_ct_is_expired() again.
Moving the bit check into nf_ct_is_expired() should work the same as
this commit.
I'll wait for a final decision if you prefer the bit check in
nf_ct_is_expired() and we will test again.

