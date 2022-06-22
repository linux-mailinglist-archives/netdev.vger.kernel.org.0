Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5797554CEC
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 16:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353459AbiFVO0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 10:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356759AbiFVO0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 10:26:35 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB431B78A;
        Wed, 22 Jun 2022 07:26:31 -0700 (PDT)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 94B8A60007;
        Wed, 22 Jun 2022 14:26:24 +0000 (UTC)
Message-ID: <068ad894-c60f-c089-fd4a-5deda1c84cdd@ovn.org>
Date:   Wed, 22 Jun 2022 16:26:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Cc:     i.maximets@ovn.org, Florian Westphal <fw@strlen.de>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, dev@openvswitch.org,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <20220619003919.394622-1-i.maximets@ovn.org>
 <CANn89iL_EmkEgPAVdhNW4tyzwQbARyji93mUQ9E2MRczWpNm7g@mail.gmail.com>
 <20220622102813.GA24844@breakpoint.cc>
 <CANn89iLGKbeeBNoDQU9C7nPRCxc6FUsrwn0LfrAKrJiJ14PH+w@mail.gmail.com>
 <c7ab4a7b-a987-e74b-dd2d-ee2c8ca84147@ovn.org>
 <CANn89iLxqae9wZ-h5M-whSsmAZ_7hW1e_=krvSyF8x89Y6o76w@mail.gmail.com>
From:   Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [PATCH net] net: ensure all external references are released in
 deferred skbuffs
In-Reply-To: <CANn89iLxqae9wZ-h5M-whSsmAZ_7hW1e_=krvSyF8x89Y6o76w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/22/22 13:43, Eric Dumazet wrote:
> On Wed, Jun 22, 2022 at 1:32 PM Ilya Maximets <i.maximets@ovn.org> wrote:
>>
>> On 6/22/22 12:36, Eric Dumazet wrote:
>>> On Wed, Jun 22, 2022 at 12:28 PM Florian Westphal <fw@strlen.de> wrote:
>>>>
>>>> Eric Dumazet <edumazet@google.com> wrote:
>>>>> On Sun, Jun 19, 2022 at 2:39 AM Ilya Maximets <i.maximets@ovn.org> wrote:
>>>>>>
>>>>>> Open vSwitch system test suite is broken due to inability to
>>>>>> load/unload netfilter modules.  kworker thread is getting trapped
>>>>>> in the infinite loop while running a net cleanup inside the
>>>>>> nf_conntrack_cleanup_net_list, because deferred skbuffs are still
>>>>>> holding nfct references and not being freed by their CPU cores.
>>>>>>
>>>>>> In general, the idea that we will have an rx interrupt on every
>>>>>> CPU core at some point in a near future doesn't seem correct.
>>>>>> Devices are getting created and destroyed, interrupts are getting
>>>>>> re-scheduled, CPUs are going online and offline dynamically.
>>>>>> Any of these events may leave packets stuck in defer list for a
>>>>>> long time.  It might be OK, if they are just a piece of memory,
>>>>>> but we can't afford them holding references to any other resources.
>>>>>>
>>>>>> In case of OVS, nfct reference keeps the kernel thread in busy loop
>>>>>> while holding a 'pernet_ops_rwsem' semaphore.  That blocks the
>>>>>> later modprobe request from user space:
>>>>>>
>>>>>>   # ps
>>>>>>    299 root  R  99.3  200:25.89 kworker/u96:4+
>>>>>>
>>>>>>   # journalctl
>>>>>>   INFO: task modprobe:11787 blocked for more than 1228 seconds.
>>>>>>         Not tainted 5.19.0-rc2 #8
>>>>>>   task:modprobe     state:D
>>>>>>   Call Trace:
>>>>>>    <TASK>
>>>>>>    __schedule+0x8aa/0x21d0
>>>>>>    schedule+0xcc/0x200
>>>>>>    rwsem_down_write_slowpath+0x8e4/0x1580
>>>>>>    down_write+0xfc/0x140
>>>>>>    register_pernet_subsys+0x15/0x40
>>>>>>    nf_nat_init+0xb6/0x1000 [nf_nat]
>>>>>>    do_one_initcall+0xbb/0x410
>>>>>>    do_init_module+0x1b4/0x640
>>>>>>    load_module+0x4c1b/0x58d0
>>>>>>    __do_sys_init_module+0x1d7/0x220
>>>>>>    do_syscall_64+0x3a/0x80
>>>>>>    entry_SYSCALL_64_after_hwframe+0x46/0xb0
>>>>>>
>>>>>> At this point OVS testsuite is unresponsive and never recover,
>>>>>> because these skbuffs are never freed.
>>>>>>
>>>>>> Solution is to make sure no external references attached to skb
>>>>>> before pushing it to the defer list.  Using skb_release_head_state()
>>>>>> for that purpose.  The function modified to be re-enterable, as it
>>>>>> will be called again during the defer list flush.
>>>>>>
>>>>>> Another approach that can fix the OVS use-case, is to kick all
>>>>>> cores while waiting for references to be released during the net
>>>>>> cleanup.  But that sounds more like a workaround for a current
>>>>>> issue rather than a proper solution and will not cover possible
>>>>>> issues in other parts of the code.
>>>>>>
>>>>>> Additionally checking for skb_zcopy() while deferring.  This might
>>>>>> not be necessary, as I'm not sure if we can actually have zero copy
>>>>>> packets on this path, but seems worth having for completeness as we
>>>>>> should never defer such packets regardless.
>>>>>>
>>>>>> CC: Eric Dumazet <edumazet@google.com>
>>>>>> Fixes: 68822bdf76f1 ("net: generalize skb freeing deferral to per-cpu lists")
>>>>>> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
>>>>>> ---
>>>>>>  net/core/skbuff.c | 16 +++++++++++-----
>>>>>>  1 file changed, 11 insertions(+), 5 deletions(-)
>>>>>
>>>>> I do not think this patch is doing the right thing.
>>>>>
>>>>> Packets sitting in TCP receive queues should not hold state that is
>>>>> not relevant for TCP recvmsg().
>>>>
>>>> Agree, but tcp_v4/6_rcv() already call nf_reset_ct(), else it would
>>>> not be possible to remove nf_conntrack module in practice.
>>>
>>> Well, existing nf_reset_ct() does not catch all cases, like TCP fastopen ?
>>
>> Yeah, that is kind of the main problem I have with the current
>> code.  It's very hard to find all the cases where skb has to be
>> cleaned up and almost impossible for someone who doesn't know
>> every aspect of every network subsystem in the kernel.  That's
>> why I went with the more or less bulletproof approach of cleaning
>> up while actually deferring.  I can try and test the code you
>> proposed in the other reply, but at least, I think, we need a
>> bunch of debug warnings in the skb_attempt_defer_free() to catch
>> possible issues.
> 
> Debug warnings are expensive if they need to bring new cache lines.
> 
> So far skb_attempt_defer_free() is only used by TCP in well known conditions.

That's true for skb_attempt_defer_free() itself, but it's
hard to tell the same for all the parts of the code that
are enqueuing these skbuffs.  Even if all the places are
well known, it looks to me highly error prone.  Having
a couple of DEBUG_NET_WARN_ON_ONCE should not cause any
performance issues, IIUC, unless debug is enabled, right?

e.g.

	DEBUG_NET_WARN_ON_ONCE(skb_nfct(skb));
	DEBUG_NET_WARN_ON_ONCE(skb_dst(skb));

> 
> 
>>
>> Also, what about cleaning up extensions?  IIUC, at least one
>> of them can hold external references.  SKB_EXT_SEC_PATH holds
>> xfrm_state.  We should, probably, free them as well?
> 
> I do not know about this, I would ask XFRM maintainers

@Steffen, @Herbert, what do you think?  Is it a problem if the
skb holding SKB_EXT_SEC_PATH extension is held not freed in
a defer list indefinitely (for a very long time)?  Or is it
even possible for an skb with SKB_EXT_SEC_PATH extension present
to be enqueued to a TCP receive queue without releasing all
the references?

This seems like a long existing problem though, so can be fixed
separately, if it is a problem.

> 
>>
>> And what about zerocopy skb?  I think, we should still not
>> allow them to be deferred as they seem to hold HW resources.
> 
> The point of skb_attempt_defer_free() i is to make the freeing happen
> at producer
>  much instead of consumer.
> 
> I do not think there is anything special in this regard with zero
> copy. I would leave the current code as is.

The problem is that these skbuffs are never actually freed,
so if they do hold HW resources, these resources will never be
released (never == for a very long time, hours, days).

Not a blocker from my point of view, just trying to highlight
a possible issue.

> 
> A simpler patch might be to move the existing nf_reset_ct() earlier,
> can you test this ?

I tested the patch below and it seems to fix the issue seen
with OVS testsuite.  Though it's not obvious for me why this
happens.  Can you explain a bit more?

> 
> I note that IPv6 does the nf_reset_ct() earlier, from ip6_protocol_deliver_rcu()
> 
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index fda811a5251f2d76ac24a036e6b4f4e7d7d96d6f..a06464f96fe0cc94dd78272738ddaab2c19e87db
> 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -1919,6 +1919,8 @@ int tcp_v4_rcv(struct sk_buff *skb)
>         struct sock *sk;
>         int ret;
> 
> +       nf_reset_ct(skb);
> +
>         drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
>         if (skb->pkt_type != PACKET_HOST)
>                 goto discard_it;
> @@ -2046,8 +2048,6 @@ int tcp_v4_rcv(struct sk_buff *skb)
>         if (drop_reason)
>                 goto discard_and_relse;
> 
> -       nf_reset_ct(skb);
> -
>         if (tcp_filter(sk, skb)) {
>                 drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
>                 goto discard_and_relse;

