Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCE5361383
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 22:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235030AbhDOUbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 16:31:31 -0400
Received: from www62.your-server.de ([213.133.104.62]:46654 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234226AbhDOUb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 16:31:29 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lX8dg-0005L4-PW; Thu, 15 Apr 2021 22:31:00 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lX8dg-000Dlb-Hy; Thu, 15 Apr 2021 22:31:00 +0200
Subject: Re: [PATCH v2 bpf-next] cpumap: bulk skb using netif_receive_skb_list
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, brouer@redhat.com, song@kernel.org
References: <bb627106428ea3223610f5623142c24270f0e14e.1618330734.git.lorenzo@kernel.org>
 <252403c5-d3a7-03fb-24c3-0f328f8f8c70@iogearbox.net>
 <47f3711d-e13a-a537-4e0e-13c3c5ff6822@gmail.com> <YHhj61rDPai8YKjL@lore-desk>
 <7cbba160-c56a-8ec5-b9e1-455889bacb86@gmail.com> <YHidrRnmDe25lact@lore-desk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a20526b4-677b-0dea-98f5-ec3aa70f95dd@iogearbox.net>
Date:   Thu, 15 Apr 2021 22:31:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <YHidrRnmDe25lact@lore-desk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26141/Thu Apr 15 13:13:26 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/15/21 10:10 PM, Lorenzo Bianconi wrote:
>> On 4/15/21 9:03 AM, Lorenzo Bianconi wrote:
>>>> On 4/15/21 8:05 AM, Daniel Borkmann wrote:
>>> [...]
>>>>>> &stats);
>>>>>
>>>>> Given we stop counting drops with the netif_receive_skb_list(), we
>>>>> should then
>>>>> also remove drops from trace_xdp_cpumap_kthread(), imho, as otherwise it
>>>>> is rather
>>>>> misleading (as in: drops actually happening, but 0 are shown from the
>>>>> tracepoint).
>>>>> Given they are not considered stable API, I would just remove those to
>>>>> make it clear
>>>>> to users that they cannot rely on this counter anymore anyway.
>>>>
>>>> What's the visibility into drops then? Seems like it would be fairly
>>>> easy to have netif_receive_skb_list return number of drops.
>>>
>>> In order to return drops from netif_receive_skb_list() I guess we need to introduce
>>> some extra checks in the hot path. Moreover packet drops are already accounted
>>> in the networking stack and this is currently the only consumer for this info.
>>> Does it worth to do so?
>>
>> right - softnet_stat shows the drop. So the loss here is that the packet
>> is from a cpumap XDP redirect.
>>
>> Better insights into drops is needed, but I guess in this case coming
>> from the cpumap does not really aid into why it is dropped - that is
>> more core to __netif_receive_skb_list_core. I guess this is ok to drop
>> the counter from the tracepoint.
> 
> Applying the current patch, drops just counts the number of kmem_cache_alloc_bulk()
> failures. Looking at kmem_cache_alloc_bulk() code, it does not seem to me there any
> failure counters. So I am wondering, is this an important info for the user?
> Is so I guess we can just rename the counter in something more meaningful
> (e.g. skb_alloc_failures).

Right, at min it could be renamed, but I also wonder if cpumap users really run this
tracepoint permanently to check for that ... presumably not, and if there is a temporary
drop due to that when the tracepoint is not enabled you won't see it either. So this
field could probably be dropped and if needed the accounting in cpumap improved in a
different way.
