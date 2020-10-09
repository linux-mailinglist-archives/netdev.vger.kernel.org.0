Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F92D289C05
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 01:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390100AbgJIXFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 19:05:40 -0400
Received: from www62.your-server.de ([213.133.104.62]:35446 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731374AbgJIXFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 19:05:40 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kR1SA-0002nU-Vw; Sat, 10 Oct 2020 01:05:35 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kR1SA-0000ZS-R5; Sat, 10 Oct 2020 01:05:34 +0200
Subject: Re: [PATCH bpf-next v2] bpf_fib_lookup: optionally skip neighbour
 lookup
To:     David Ahern <dsahern@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>, ast@fb.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20201009101356.129228-1-toke@redhat.com>
 <0a463800-a663-3fd3-2e1a-eac5526ed691@gmail.com> <87v9fjckcd.fsf@toke.dk>
 <4972626e-c86d-8715-0565-20bed680227c@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <50fc3fee-13b2-11d1-f5b1-e0d8669cd655@iogearbox.net>
Date:   Sat, 10 Oct 2020 01:05:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <4972626e-c86d-8715-0565-20bed680227c@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25952/Fri Oct  9 15:52:40 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/9/20 11:28 PM, David Ahern wrote:
> On 10/9/20 11:42 AM, Toke Høiland-Jørgensen wrote:
>> David Ahern <dsahern@gmail.com> writes:
>>> On 10/9/20 3:13 AM, Toke Høiland-Jørgensen wrote:
>>>> The bpf_fib_lookup() helper performs a neighbour lookup for the destination
>>>> IP and returns BPF_FIB_LKUP_NO_NEIGH if this fails, with the expectation
>>>> that the BPF program will pass the packet up the stack in this case.
>>>> However, with the addition of bpf_redirect_neigh() that can be used instead
>>>> to perform the neighbour lookup, at the cost of a bit of duplicated work.
>>>>
>>>> For that we still need the target ifindex, and since bpf_fib_lookup()
>>>> already has that at the time it performs the neighbour lookup, there is
>>>> really no reason why it can't just return it in any case. So let's just
>>>> always return the ifindex, and also add a flag that lets the caller turn
>>>> off the neighbour lookup entirely in bpf_fib_lookup().
>>>
>>> seems really odd to do the fib lookup only to skip the neighbor lookup
>>> and defer to a second helper to do a second fib lookup and send out.
>>>
>>> The better back-to-back calls is to return the ifindex and gateway on
>>> successful fib lookup regardless of valid neighbor. If the call to
>>> bpf_redirect_neigh is needed, it can have a flag to skip the fib lookup
>>> and just redirect to the given nexthop address + ifindex. ie.,
>>> bpf_redirect_neigh only does neighbor handling in this case.
>>
>> Hmm, yeah, I guess it would make sense to cache and reuse the lookup -
>> maybe stick it in bpf_redirect_info()? However, given the imminent
> 
> That is not needed.
> 
>> opening of the merge window, I don't see this landing before then. So
>> I'm going to respin this patch with just the original change to always
>> return the ifindex, then we can revisit the flags/reuse of the fib
>> lookup later.
> 
> What I am suggesting is a change in API to bpf_redirect_neigh which
> should be done now, before the merge window, before it comes a locked
> API. Right now, bpf_redirect_neigh does a lookup to get the nexthop. It
> should take the gateway as an input argument. If set, then the lookup is
> not done - only the neighbor redirect.

Sounds like a reasonable extension, agree. API freeze is not merge win, but
final v5.10 tag in this case as it always has been. In case it's not in time,
we can simply just move flags to arg3 and add a reserved param as arg2 which
must be zero (and thus indicate to perform the lookup as-is). Later we could
extend to pass params similar as in fib_lookup helper for the gw.
