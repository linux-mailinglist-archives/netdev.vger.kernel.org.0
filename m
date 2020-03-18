Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA7C189DBA
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 15:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgCROWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 10:22:42 -0400
Received: from www62.your-server.de ([213.133.104.62]:44064 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbgCROWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 10:22:42 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jEZaX-0005bw-Md; Wed, 18 Mar 2020 15:22:29 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jEZaX-000WcX-Ea; Wed, 18 Mar 2020 15:22:29 +0100
Subject: Re: [PATCH net-next] netfilter: revert introduction of egress hook
To:     Florian Westphal <fw@strlen.de>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Alexei Starovoitov <ast@kernel.org>
References: <bbdee6355234e730ef686f9321bd072bcf4bb232.1584523237.git.daniel@iogearbox.net>
 <20200318100227.GE979@breakpoint.cc>
 <c7c6fb40-06f9-8078-6f76-5dc75a094e25@iogearbox.net>
 <20200318123315.GI979@breakpoint.cc>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <792ee103-a357-e80c-31f0-684de55fd6e6@iogearbox.net>
Date:   Wed, 18 Mar 2020 15:22:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200318123315.GI979@breakpoint.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25755/Wed Mar 18 14:14:00 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/18/20 1:33 PM, Florian Westphal wrote:
> Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 3/18/20 11:02 AM, Florian Westphal wrote:
>>> Daniel Borkmann <daniel@iogearbox.net> wrote:
>>>> This reverts the following commits:
>>>>
>>>>     8537f78647c0 ("netfilter: Introduce egress hook")
>>>>     5418d3881e1f ("netfilter: Generalize ingress hook")
>>>>     b030f194aed2 ("netfilter: Rename ingress hook include file")
>>>>
>>>>   From the discussion in [0], the author's main motivation to add a hook
>>>> in fast path is for an out of tree kernel module, which is a red flag
>>>> to begin with.
>>>
>>> The author did post patches for nftables, i.e. you can hook up rulesets to
>>> this new hook point.
>>>
>>>> is on future extensions w/o concrete code in the tree yet. Revert as
>>>> suggested [1] given the weak justification to add more hooks to critical
>>>> fast-path.
>>>
>>> Do you have an alternative suggestion on how to expose this?
>>
>> Yeah, I think we should not plaster the stack with same/similar hooks that
>> achieve the same functionality next to each other over and over at the cost
>> of performance for users .. ideally there should just be a single entry point
>> that is very lightweight/efficient when not used and can otherwise patch to
>> a direct call when in use. Recent work from KP Singh goes into this direction
>> with the fmodify_return work [0], so we would have a single static key which
>> wraps an empty function call entry which can then be patched by the kernel at
>> runtime. Inside that trampoline we can still keep the ordering intact, but
>> imho this would overall better reduce overhead when functionality is not used
>> compared to the practice of duplication today.
> 
> Thanks for explaining.  If I understand this correctly then:
> 
> 1. sch_handle_egress() becomes a non-inlined function that isn't called
>     from __dev_queue_xmit or any other location
> 2. __dev_queue_xmit calls a dummy do-nothing function wrapped in
>     existing egress-static-key
> 3. kernels sched/tc code can patch the dummy function so it calls
>     sch_handle_egress, without userspace changes/awareness
> 4. netfilter could reuse this even when tc is already patched in, so
>     the dummy function does two direct calls.

Yes, pretty much and we could do the same for the ingress side as well.

> How does that differ from current code?  One could also re-arrange
> things like this (diff below, just for illustration).
> 
> The only difference I see vs. my understanding of your proposal is:
> 1. no additional static key, nf_hook_egress_active() doesn't exist
> 2. nf_hook_egress exists, but isn't called anywhere, patched-in at runtime
> 3. sch_handle_egress isn't called anywhere either, patched-in too
> 
> Did I get that right? The idea/plan looks good to me, it just looks
> like a very marginal difference to me, thats why I'm asking.

Aside from that, we could take that approach potentially even further in that
it would allow for converting more indirect calls into direct ones, e.g. the
tp->classify() ones from sch_handle_egress() or potentially the entry->hook()
from nf_hook_slow() side, or BPF directly as well, so I think it would be worth
a try to see how far we could simplify both and get rid of indirect calls for
their users with this approach. Happy to help out here as well.

Thanks,
Daniel
