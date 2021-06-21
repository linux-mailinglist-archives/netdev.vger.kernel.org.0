Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7BC3AF857
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 00:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbhFUWRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 18:17:41 -0400
Received: from www62.your-server.de ([213.133.104.62]:52366 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbhFUWRk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 18:17:40 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lvSCS-000ARV-FC; Tue, 22 Jun 2021 00:15:24 +0200
Received: from [85.7.101.30] (helo=linux-3.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lvSCS-0001Zm-7Z; Tue, 22 Jun 2021 00:15:24 +0200
Subject: Re: [PATCH bpf-next v3 03/16] xdp: add proper __rcu annotations to
 redirect map entries
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210617212748.32456-1-toke@redhat.com>
 <20210617212748.32456-4-toke@redhat.com>
 <1881ecbe-06ec-6b0a-836c-033c31fabef4@iogearbox.net> <87zgvirj6g.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <96117b3f-8041-b524-ef70-d5afc97e32f9@iogearbox.net>
Date:   Tue, 22 Jun 2021 00:15:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87zgvirj6g.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26208/Mon Jun 21 13:09:26 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/21/21 11:39 PM, Toke Høiland-Jørgensen wrote:
> Daniel Borkmann <daniel@iogearbox.net> writes:
>> On 6/17/21 11:27 PM, Toke Høiland-Jørgensen wrote:
>>> XDP_REDIRECT works by a three-step process: the bpf_redirect() and
>>> bpf_redirect_map() helpers will lookup the target of the redirect and store
>>> it (along with some other metadata) in a per-CPU struct bpf_redirect_info.
>>> Next, when the program returns the XDP_REDIRECT return code, the driver
>>> will call xdp_do_redirect() which will use the information thus stored to
>>> actually enqueue the frame into a bulk queue structure (that differs
>>> slightly by map type, but shares the same principle). Finally, before
>>> exiting its NAPI poll loop, the driver will call xdp_do_flush(), which will
>>> flush all the different bulk queues, thus completing the redirect.
>>>
>>> Pointers to the map entries will be kept around for this whole sequence of
>>> steps, protected by RCU. However, there is no top-level rcu_read_lock() in
>>> the core code; instead drivers add their own rcu_read_lock() around the XDP
>>> portions of the code, but somewhat inconsistently as Martin discovered[0].
>>> However, things still work because everything happens inside a single NAPI
>>> poll sequence, which means it's between a pair of calls to
>>> local_bh_disable()/local_bh_enable(). So Paul suggested[1] that we could
>>> document this intention by using rcu_dereference_check() with
>>> rcu_read_lock_bh_held() as a second parameter, thus allowing sparse and
>>> lockdep to verify that everything is done correctly.
>>>
>>> This patch does just that: we add an __rcu annotation to the map entry
>>> pointers and remove the various comments explaining the NAPI poll assurance
>>> strewn through devmap.c in favour of a longer explanation in filter.c. The
>>> goal is to have one coherent documentation of the entire flow, and rely on
>>> the RCU annotations as a "standard" way of communicating the flow in the
>>> map code (which can additionally be understood by sparse and lockdep).
>>>
>>> The RCU annotation replacements result in a fairly straight-forward
>>> replacement where READ_ONCE() becomes rcu_dereference_check(), WRITE_ONCE()
>>> becomes rcu_assign_pointer() and xchg() and cmpxchg() gets wrapped in the
>>> proper constructs to cast the pointer back and forth between __rcu and
>>> __kernel address space (for the benefit of sparse). The one complication is
>>> that xskmap has a few constructions where double-pointers are passed back
>>> and forth; these simply all gain __rcu annotations, and only the final
>>> reference/dereference to the inner-most pointer gets changed.
>>>
>>> With this, everything can be run through sparse without eliciting
>>> complaints, and lockdep can verify correctness even without the use of
>>> rcu_read_lock() in the drivers. Subsequent patches will clean these up from
>>> the drivers.
>>>
>>> [0] https://lore.kernel.org/bpf/20210415173551.7ma4slcbqeyiba2r@kafai-mbp.dhcp.thefacebook.com/
>>> [1] https://lore.kernel.org/bpf/20210419165837.GA975577@paulmck-ThinkPad-P17-Gen-1/
>>>
>>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>> ---
>>>    include/net/xdp_sock.h |  2 +-
>>>    kernel/bpf/cpumap.c    | 13 +++++++----
>>>    kernel/bpf/devmap.c    | 49 ++++++++++++++++++------------------------
>>>    net/core/filter.c      | 28 ++++++++++++++++++++++++
>>>    net/xdp/xsk.c          |  4 ++--
>>>    net/xdp/xsk.h          |  4 ++--
>>>    net/xdp/xskmap.c       | 29 ++++++++++++++-----------
>>>    7 files changed, 80 insertions(+), 49 deletions(-)
>> [...]
>>>    						 __dev_map_entry_free);
>>> diff --git a/net/core/filter.c b/net/core/filter.c
>>> index caa88955562e..0b7db5c70385 100644
>>> --- a/net/core/filter.c
>>> +++ b/net/core/filter.c
>>> @@ -3922,6 +3922,34 @@ static const struct bpf_func_proto bpf_xdp_adjust_meta_proto = {
>>>    	.arg2_type	= ARG_ANYTHING,
>>>    };
>>>    
>>> +/* XDP_REDIRECT works by a three-step process, implemented in the functions
>>> + * below:
>>> + *
>>> + * 1. The bpf_redirect() and bpf_redirect_map() helpers will lookup the target
>>> + *    of the redirect and store it (along with some other metadata) in a per-CPU
>>> + *    struct bpf_redirect_info.
>>> + *
>>> + * 2. When the program returns the XDP_REDIRECT return code, the driver will
>>> + *    call xdp_do_redirect() which will use the information in struct
>>> + *    bpf_redirect_info to actually enqueue the frame into a map type-specific
>>> + *    bulk queue structure.
>>> + *
>>> + * 3. Before exiting its NAPI poll loop, the driver will call xdp_do_flush(),
>>> + *    which will flush all the different bulk queues, thus completing the
>>> + *    redirect.
>>> + *
>>> + * Pointers to the map entries will be kept around for this whole sequence of
>>> + * steps, protected by RCU. However, there is no top-level rcu_read_lock() in
>>> + * the core code; instead, the RCU protection relies on everything happening
>>> + * inside a single NAPI poll sequence, which means it's between a pair of calls
>>> + * to local_bh_disable()/local_bh_enable().
>>> + *
>>> + * The map entries are marked as __rcu and the map code makes sure to
>>> + * dereference those pointers with rcu_dereference_check() in a way that works
>>> + * for both sections that to hold an rcu_read_lock() and sections that are
>>> + * called from NAPI without a separate rcu_read_lock(). The code below does not
>>> + * use RCU annotations, but relies on those in the map code.
>>
>> One more follow-up question related to tc BPF: given we do use rcu_read_lock_bh()
>> in case of sch_handle_egress(), could we also remove the rcu_read_lock() pair
>> from cls_bpf_classify() then?
> 
> I believe so, yeah. Patch 2 in this series should even make lockdep stop
> complaining about it :)

Btw, I was wondering whether we should just get rid of all the WARN_ON_ONCE()s
from those map helpers given in most situations these are not triggered anyway
due to retpoline avoidance where verifier rewrites the calls to jump to the map
backend implementation directly. One alternative could be to have an extension
to the bpf prologue generation under CONFIG_DEBUG_LOCK_ALLOC and call the lockdep
checks from there, but it's probably not worth the effort. (In the trampoline
case we have those __bpf_prog_enter()/__bpf_prog_enter_sleepable() where the
latter in particular has asserts like might_fault(), fwiw.)

> I can add a patch removing the rcu_read_lock() from cls_bpf in the next
> version.
> 
>> It would also be great if this scenario in general could be placed
>> under the Documentation/RCU/whatisRCU.rst as an example, so we could
>> refer to the official doc on this, too, if Paul is good with this.
> 
> I'll take a look and see if I can find a way to fit it in there...
> 
>> Could you also update the RCU comment in bpf_prog_run_xdp()? Or
>> alternatively move all the below driver comments in there as a single
>> location?
>>
>>     /* This code is invoked within a single NAPI poll cycle and thus under
>>      * local_bh_disable(), which provides the needed RCU protection.
>>      */
> 
> Sure, can do. And yeah, I do agree that moving the comment in there
> makes more sense than scattering it over all the drivers, even if that
> means I have to go back and edit all the drivers again :P

Yeap, all of the above sounds good, thanks!
