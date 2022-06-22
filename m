Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E18E05548F8
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357400AbiFVLco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 07:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiFVLco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 07:32:44 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8524D3C4B6;
        Wed, 22 Jun 2022 04:32:42 -0700 (PDT)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 98207C0006;
        Wed, 22 Jun 2022 11:32:38 +0000 (UTC)
Message-ID: <c7ab4a7b-a987-e74b-dd2d-ee2c8ca84147@ovn.org>
Date:   Wed, 22 Jun 2022 13:32:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Cc:     i.maximets@ovn.org, netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, dev@openvswitch.org,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>, Florian Westphal <fw@strlen.de>
References: <20220619003919.394622-1-i.maximets@ovn.org>
 <CANn89iL_EmkEgPAVdhNW4tyzwQbARyji93mUQ9E2MRczWpNm7g@mail.gmail.com>
 <20220622102813.GA24844@breakpoint.cc>
 <CANn89iLGKbeeBNoDQU9C7nPRCxc6FUsrwn0LfrAKrJiJ14PH+w@mail.gmail.com>
From:   Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [PATCH net] net: ensure all external references are released in
 deferred skbuffs
In-Reply-To: <CANn89iLGKbeeBNoDQU9C7nPRCxc6FUsrwn0LfrAKrJiJ14PH+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/22/22 12:36, Eric Dumazet wrote:
> On Wed, Jun 22, 2022 at 12:28 PM Florian Westphal <fw@strlen.de> wrote:
>>
>> Eric Dumazet <edumazet@google.com> wrote:
>>> On Sun, Jun 19, 2022 at 2:39 AM Ilya Maximets <i.maximets@ovn.org> wrote:
>>>>
>>>> Open vSwitch system test suite is broken due to inability to
>>>> load/unload netfilter modules.  kworker thread is getting trapped
>>>> in the infinite loop while running a net cleanup inside the
>>>> nf_conntrack_cleanup_net_list, because deferred skbuffs are still
>>>> holding nfct references and not being freed by their CPU cores.
>>>>
>>>> In general, the idea that we will have an rx interrupt on every
>>>> CPU core at some point in a near future doesn't seem correct.
>>>> Devices are getting created and destroyed, interrupts are getting
>>>> re-scheduled, CPUs are going online and offline dynamically.
>>>> Any of these events may leave packets stuck in defer list for a
>>>> long time.  It might be OK, if they are just a piece of memory,
>>>> but we can't afford them holding references to any other resources.
>>>>
>>>> In case of OVS, nfct reference keeps the kernel thread in busy loop
>>>> while holding a 'pernet_ops_rwsem' semaphore.  That blocks the
>>>> later modprobe request from user space:
>>>>
>>>>   # ps
>>>>    299 root  R  99.3  200:25.89 kworker/u96:4+
>>>>
>>>>   # journalctl
>>>>   INFO: task modprobe:11787 blocked for more than 1228 seconds.
>>>>         Not tainted 5.19.0-rc2 #8
>>>>   task:modprobe     state:D
>>>>   Call Trace:
>>>>    <TASK>
>>>>    __schedule+0x8aa/0x21d0
>>>>    schedule+0xcc/0x200
>>>>    rwsem_down_write_slowpath+0x8e4/0x1580
>>>>    down_write+0xfc/0x140
>>>>    register_pernet_subsys+0x15/0x40
>>>>    nf_nat_init+0xb6/0x1000 [nf_nat]
>>>>    do_one_initcall+0xbb/0x410
>>>>    do_init_module+0x1b4/0x640
>>>>    load_module+0x4c1b/0x58d0
>>>>    __do_sys_init_module+0x1d7/0x220
>>>>    do_syscall_64+0x3a/0x80
>>>>    entry_SYSCALL_64_after_hwframe+0x46/0xb0
>>>>
>>>> At this point OVS testsuite is unresponsive and never recover,
>>>> because these skbuffs are never freed.
>>>>
>>>> Solution is to make sure no external references attached to skb
>>>> before pushing it to the defer list.  Using skb_release_head_state()
>>>> for that purpose.  The function modified to be re-enterable, as it
>>>> will be called again during the defer list flush.
>>>>
>>>> Another approach that can fix the OVS use-case, is to kick all
>>>> cores while waiting for references to be released during the net
>>>> cleanup.  But that sounds more like a workaround for a current
>>>> issue rather than a proper solution and will not cover possible
>>>> issues in other parts of the code.
>>>>
>>>> Additionally checking for skb_zcopy() while deferring.  This might
>>>> not be necessary, as I'm not sure if we can actually have zero copy
>>>> packets on this path, but seems worth having for completeness as we
>>>> should never defer such packets regardless.
>>>>
>>>> CC: Eric Dumazet <edumazet@google.com>
>>>> Fixes: 68822bdf76f1 ("net: generalize skb freeing deferral to per-cpu lists")
>>>> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
>>>> ---
>>>>  net/core/skbuff.c | 16 +++++++++++-----
>>>>  1 file changed, 11 insertions(+), 5 deletions(-)
>>>
>>> I do not think this patch is doing the right thing.
>>>
>>> Packets sitting in TCP receive queues should not hold state that is
>>> not relevant for TCP recvmsg().
>>
>> Agree, but tcp_v4/6_rcv() already call nf_reset_ct(), else it would
>> not be possible to remove nf_conntrack module in practice.
> 
> Well, existing nf_reset_ct() does not catch all cases, like TCP fastopen ?

Yeah, that is kind of the main problem I have with the current
code.  It's very hard to find all the cases where skb has to be
cleaned up and almost impossible for someone who doesn't know
every aspect of every network subsystem in the kernel.  That's
why I went with the more or less bulletproof approach of cleaning
up while actually deferring.  I can try and test the code you
proposed in the other reply, but at least, I think, we need a
bunch of debug warnings in the skb_attempt_defer_free() to catch
possible issues.

Also, what about cleaning up extensions?  IIUC, at least one
of them can hold external references.  SKB_EXT_SEC_PATH holds
xfrm_state.  We should, probably, free them as well?

And what about zerocopy skb?  I think, we should still not
allow them to be deferred as they seem to hold HW resources.

> 
> Maybe 68822bdf76f1 ("net: generalize skb freeing deferral to per-cpu lists")
> only widened the problem.
> 
>>
>> I wonder where the deferred skbs are coming from, any and all
>> queued skbs need the conntrack state dropped.
>>
>> I don't mind a new helper that does a combined dst+ct release though.

