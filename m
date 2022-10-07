Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D307D5F78EC
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 15:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiJGN0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 09:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiJGN0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 09:26:53 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22F22315B;
        Fri,  7 Oct 2022 06:26:49 -0700 (PDT)
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ognNH-000CLU-En; Fri, 07 Oct 2022 15:26:47 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ognNH-0007iZ-3U; Fri, 07 Oct 2022 15:26:47 +0200
Subject: Re: [PATCH bpf-next 01/10] bpf: Add initial fd-based API to attach tc
 BPF programs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Joe Stringer <joe@cilium.io>,
        Network Development <netdev@vger.kernel.org>
References: <20221004231143.19190-1-daniel@iogearbox.net>
 <20221004231143.19190-2-daniel@iogearbox.net>
 <20221006050053.pbwo72xtzoza6gfl@macbook-pro-4.dhcp.thefacebook.com>
 <f355eeba-1b46-749f-c102-65074e7eac27@iogearbox.net>
 <CAADnVQ+gEY3FjCR=+DmjDR4gp5bOYZUFJQXj4agKFHT9CQPZBw@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <14f368eb-9158-68bc-956c-c8371cfcb531@iogearbox.net>
Date:   Fri, 7 Oct 2022 15:26:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAADnVQ+gEY3FjCR=+DmjDR4gp5bOYZUFJQXj4agKFHT9CQPZBw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26682/Fri Oct  7 09:58:07 2022)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/7/22 1:28 AM, Alexei Starovoitov wrote:
> On Thu, Oct 6, 2022 at 2:29 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 10/6/22 7:00 AM, Alexei Starovoitov wrote:
>>> On Wed, Oct 05, 2022 at 01:11:34AM +0200, Daniel Borkmann wrote:
>> [...]
>>>
>>> I cannot help but feel that prio logic copy-paste from old tc, netfilter and friends
>>> is done because "that's how things were done in the past".
>>> imo it was a well intentioned mistake and all networking things (tc, netfilter, etc)
>>> copy-pasted that cumbersome and hard to use concept.
>>> Let's throw away that baggage?
>>> In good set of cases the bpf prog inserter cares whether the prog is first or not.
>>> Since the first prog returning anything but TC_NEXT will be final.
>>> I think prog insertion flags: 'I want to run first' vs 'I don't care about order'
>>> is good enough in practice. Any complex scheme should probably be programmable
>>> as any policy should. For example in Meta we have 'xdp chainer' logic that is similar
>>> to libxdp chaining, but we added a feature that allows a prog to jump over another
>>> prog and continue the chain. Priority concept cannot express that.
>>> Since we'd have to add some "policy program" anyway for use cases like this
>>> let's keep things as simple as possible?
>>> Then maybe we can adopt this "as-simple-as-possible" to XDP hooks ?
>>> And allow bpf progs chaining in the kernel with "run_me_first" vs "run_me_anywhere"
>>> in both tcx and xdp ?
>>> Naturally "run_me_first" prog will be the only one. No need for F_REPLACE flags, etc.
>>> The owner of "run_me_first" will update its prog through bpf_link_update.
>>> "run_me_anywhere" will add to the end of the chain.
>>> In XDP for compatibility reasons "run_me_first" will be the default.
>>> Since only one prog can be enqueued with such flag it will match existing single prog behavior.
>>> Well behaving progs will use (like xdp-tcpdump or monitoring progs) will use "run_me_anywhere".
>>> I know it's far from covering plenty of cases that we've discussed for long time,
>>> but prio concept isn't really covering them either.
>>> We've struggled enough with single xdp prog, so certainly not advocating for that.
>>> Another alternative is to do: "queue_at_head" vs "queue_at_tail". Just as simple.
>>> Both simple versions have their pros and cons and don't cover everything,
>>> but imo both are better than prio.
>>
>> Yeah, it's kind of tricky, imho. The 'run_me_first' vs 'run_me_anywhere' are two
>> use cases that should be covered (and actually we kind of do this in this set, too,
>> with the prios via prio=x vs prio=0). Given users will only be consuming the APIs
>> via libs like libbpf, this can also be abstracted this way w/o users having to be
>> aware of prios.
> 
> but the patchset tells different story.
> Prio gets exposed everywhere in uapi all the way to bpftool
> when it's right there for users to understand.
> And that's the main problem with it.
> The user don't want to and don't need to be aware of it,
> but uapi forces them to pick the priority.
> 
>> Anyway, where it gets tricky would be when things depend on ordering,
>> e.g. you have BPF progs doing: policy, monitoring, lb, monitoring, encryption, which
>> would be sth you can build today via tc BPF: so policy one acts as a prefilter for
>> various cidr ranges that should be blocked no matter what, then monitoring to sample
>> what goes into the lb, then lb itself which does snat/dnat, then monitoring to see what
>> the corresponding pkt looks that goes to backend, and maybe encryption to e.g. send
>> the result to wireguard dev, so it's encrypted from lb node to backend.
> 
> That's all theory. Your cover letter example proves that in
> real life different service pick the same priority.
> They simply don't know any better.
> prio is an unnecessary magic that apps _have_ to pick,
> so they just copy-paste and everyone ends up using the same.
> 
>> For such
>> example, you'd need prios as the 'run_me_anywhere' doesn't guarantee order, so there's
>> a case for both scenarios (concrete layout vs loose one), and for latter we could
>> start off with and internal prio around x (e.g. 16k), so there's room to attach in
>> front via fixed prio, but also append to end for 'don't care', and that could be
>> from lib pov the default/main API whereas prio would be some kind of extended one.
>> Thoughts?
> 
> If prio was not part of uapi, like kernel internal somehow,
> and there was a user space daemon, systemd, or another bpf prog,
> module, whatever that users would interface to then
> the proposed implementation of prio would totally make sense.
> prio as uapi is not that.

A good analogy to this issue might be systemd's unit files.. you specify dependencies
for your own <unit> file via 'Wants=<unitA>', and ordering via 'Before=<unitB>' and
'After=<unitC>' and they refer to other unit files. I think that is generally okay,
you don't deal with prio numbers, but rather some kind textual representation. However
user/operator will have to deal with dependencies/ordering one way or another, the
problem here is that we deal with kernel and loader talks to kernel directly so it
has no awareness of what else is running or could be running, so apps needs to deal
with it somehow (and it cannot without external help). Some kind of system daemon
(like systemd) also won't fly much given such applications as Pods are typically
shipped individually as container images, so really only host /netns/ is shared in
such case but nothing else (base image itself can be alpine, ubuntu, etc, and it has
its own systemd instance, for example). Maybe BPF links could have user defined
name, and you'd express dependencies via names, but then again the application/
loader deals with bpf(2) directly and only kernel is common denominator and apps
themselves have no awareness of other components that run or might run in the
system which load bpf (unless they expose config knob).. you mentioned 'xdp chainer'
at Meta, how do you express dependencies and ordering there? When you deploy a new
app for XDP to production, I presume you need to know exactly where it's running
and not just 'ordering doesn't matter, just append to the end', no? I guess we
generally agree on that, just whether there are better options than prio for uapi
to express ordering/dependencies. Do you use sth different in mentioned 'xdp chainer'?

Thanks,
Daniel
