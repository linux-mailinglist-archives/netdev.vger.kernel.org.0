Return-Path: <netdev+bounces-10111-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1884572C4AC
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 14:43:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F419D1C20B46
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 12:43:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B85F1800B;
	Mon, 12 Jun 2023 12:43:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4665A11C83;
	Mon, 12 Jun 2023 12:43:41 +0000 (UTC)
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41AF618C;
	Mon, 12 Jun 2023 05:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=ihS5517nU3tjTgWNndOlFQgaoABhZT9PArIocTy/Cxo=; b=P7D+38mdr0kR7srq7qqrNR+5Eh
	0pY7AGhH65HjohWVQD3LQgdF7sRPYrgb/l0/fF/GQqe1533sKxAhAa15i0wzVWAZPPJ9XhQ/NAwhH
	Gqpzi8FTjOZr4Id5Z1Xzu5GPIy1eO4H/fOdja8BA9xWO8BurBCMZxNITI/46X8tzEL9T+KVIZUVvL
	wmprjI0hVtpVdpQDs4iiDmtEibc5F5boMg0pcJfN8q1MmEVVslZ5e72+eAh9JvroNurIolQg2CQ2c
	JwFJ50ruA1cRzgCLPO4r2W5YVhtMsuSDepZHsB+qQNOgdxRju1kxzE3LDzm9dXxDLb5T5xVQrxlIn
	gtBgdk2w==;
Received: from sslproxy03.your-server.de ([88.198.220.132])
	by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <daniel@iogearbox.net>)
	id 1q8gtE-000M7S-GP; Mon, 12 Jun 2023 14:43:20 +0200
Received: from [85.1.206.226] (helo=linux.home)
	by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <daniel@iogearbox.net>)
	id 1q8gtD-000XUM-VQ; Mon, 12 Jun 2023 14:43:20 +0200
Subject: Re: [PATCH bpf-next v2 1/7] bpf: Add generic attach/detach/query API
 for multi-progs
To: Dave Tucker <datucker@redhat.com>
Cc: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@kernel.org>,
 Timo Beckers <timo@incline.eu>, Stanislav Fomichev <sdf@google.com>,
 Andrii Nakryiko <andrii.nakryiko@gmail.com>, ast@kernel.org,
 andrii@kernel.org, martin.lau@linux.dev, razor@blackwall.org,
 john.fastabend@gmail.com, kuba@kernel.org, dxu@dxuuu.xyz, joe@cilium.io,
 davem@davemloft.net, bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20230607192625.22641-1-daniel@iogearbox.net>
 <20230607192625.22641-2-daniel@iogearbox.net> <ZIIOr1zvdRNTFKR7@google.com>
 <CAEf4BzbEf+U53UY6o+g5OZ6rg+T65_Aou4Nvrdbo-8sAjmdJmA@mail.gmail.com>
 <ZIJNlxCX4ksBFFwN@google.com>
 <CAEf4BzYbr5G8ZGnWEndiZ1-7_XqYfKFTorDvvafwZY0XJUn7cw@mail.gmail.com>
 <ZIJe5Ml6ILFa6tKP@google.com> <87a5x91nr8.fsf@toke.dk>
 <3a315a0d-52dd-7671-f6c1-bb681604c815@iogearbox.net> <874jng28xk.fsf@toke.dk>
 <1a73a1b9-c72a-de81-4fce-7ba4fb6d7900@incline.eu> <87sfb0zsok.fsf@toke.dk>
 <d0cf9a4f-c111-b594-7a12-84914419789e@iogearbox.net>
 <F0A1F306-F68F-4DD6-A44E-D3EA6F9BBB0D@redhat.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2a9eb424-e767-d76e-df92-5cadd858ead5@iogearbox.net>
Date: Mon, 12 Jun 2023 14:43:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <F0A1F306-F68F-4DD6-A44E-D3EA6F9BBB0D@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26937/Mon Jun 12 09:24:05 2023)
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/12/23 1:21 PM, Dave Tucker wrote:
>> On 9 Jun 2023, at 15:15, Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 6/9/23 3:11 PM, Toke Høiland-Jørgensen wrote:
>>> Timo Beckers <timo@incline.eu> writes:
>>>> On 6/9/23 13:04, Toke Høiland-Jørgensen wrote:
>>>>> Daniel Borkmann <daniel@iogearbox.net> writes:
>> [...]
>>>>>>>>>>>> I'm still not sure whether the hard semantics of first/last is really
>>>>>>>>>>>> useful. My worry is that some prog will just use BPF_F_FIRST which
>>>>>>>>>>>> would prevent the rest of the users.. (starting with only
>>>>>>>>>>>> F_BEFORE/F_AFTER feels 'safer'; we can iterate later on if we really
>>>>>>>>>>>> need first/laste).
>>>>>>>>>>> Without FIRST/LAST some scenarios cannot be guaranteed to be safely
>>>>>>>>>>> implemented. E.g., if I have some hard audit requirements and I need
>>>>>>>>>>> to guarantee that my program runs first and observes each event, I'll
>>>>>>>>>>> enforce BPF_F_FIRST when attaching it. And if that attachment fails,
>>>>>>>>>>> then server setup is broken and my application cannot function.
>>>>>>>>>>>
>>>>>>>>>>> In a setup where we expect multiple applications to co-exist, it
>>>>>>>>>>> should be a rule that no one is using FIRST/LAST (unless it's
>>>>>>>>>>> absolutely required). And if someone doesn't comply, then that's a bug
>>>>>>>>>>> and has to be reported to application owners.
>>>>>>>>>>>
>>>>>>>>>>> But it's not up to the kernel to enforce this cooperation by
>>>>>>>>>>> disallowing FIRST/LAST semantics, because that semantics is critical
>>>>>>>>>>> for some applications, IMO.
>>>>>>>>>> Maybe that's something that should be done by some other mechanism?
>>>>>>>>>> (and as a follow up, if needed) Something akin to what Toke
>>>>>>>>>> mentioned with another program doing sorting or similar.
>>>>>>>>> The goal of this API is to avoid needing some extra special program to
>>>>>>>>> do this sorting
>>>>>>>>>
>>>>>>>>>> Otherwise, those first/last are just plain simple old priority bands;
>>>>>>>>>> only we have two now, not u16.
>>>>>>>>> I think it's different. FIRST/LAST has to be used judiciously, of
>>>>>>>>> course, but when they are needed, they will have no alternative.
>>>>>>>>>
>>>>>>>>> Also, specifying FIRST + LAST is the way to say "I want my program to
>>>>>>>>> be the only one attached". Should we encourage such use cases? No, of
>>>>>>>>> course. But I think it's fair  for users to be able to express this.
>>>>>>>>>
>>>>>>>>>> I'm mostly coming from the observability point: imagine I have my fancy
>>>>>>>>>> tc_ingress_tcpdump program that I want to attach as a first program to debug
>>>>>>>>>> some issue, but it won't work because there is already a 'first' program
>>>>>>>>>> installed.. Or the assumption that I'd do F_REPLACE | F_FIRST ?
>>>>>>>>> If your production setup requires that some important program has to
>>>>>>>>> be FIRST, then yeah, your "let me debug something" program shouldn't
>>>>>>>>> interfere with it (assuming that FIRST requirement is a real
>>>>>>>>> requirement and not someone just thinking they need to be first; but
>>>>>>>>> that's up to user space to decide). Maybe the solution for you in that
>>>>>>>>> case would be freplace program installed on top of that stubborn FIRST
>>>>>>>>> program? And if we are talking about local debugging and development,
>>>>>>>>> then you are a sysadmin and you should be able to force-detach that
>>>>>>>>> program that is getting in the way.
>>>>>>>> I'm not really concerned about our production environment. It's pretty
>>>>>>>> controlled and restricted and I'm pretty certain we can avoid doing
>>>>>>>> something stupid. Probably the same for your env.
>>>>>>>>
>>>>>>>> I'm mostly fantasizing about upstream world where different users don't
>>>>>>>> know about each other and start doing stupid things like F_FIRST where
>>>>>>>> they don't really have to be first. It's that "used judiciously" part
>>>>>>>> that I'm a bit skeptical about :-D
>>>>>> But in the end how is that different from just attaching themselves blindly
>>>>>> into the first position (e.g. with before and relative_fd as 0 or the fd/id
>>>>>> of the current first program) - same, they don't really have to be first.
>>>>>> How would that not result in doing something stupid? ;) To add to Andrii's
>>>>>> earlier DDoS mitigation example ... think of K8s environment: one project
>>>>>> is implementing DDoS mitigation with BPF, another one wants to monitor/
>>>>>> sample traffic to user space with BPF. Both install as first position by
>>>>>> default (before + 0). In K8s, there is no built-in Pod dependency management
>>>>>> so you cannot guarantee whether Pod A comes up before Pod B. So you'll end
>>>>>> up in a situation where sometimes the monitor runs before the DDoS mitigation
>>>>>> and on some other nodes it's vice versa. The other case where this gets
>>>>>> broken (assuming a node where we get first the DDoS mitigation, then the
>>>>>> monitoring) is when you need to upgrade one of the Pods: monitoring Pod
>>>>>> gets a new stable update and is being re-rolled out, then it inserts
>>>>>> itself before the DDoS mitigation mechanism, potentially causing outage.
>>>>>> With the first/last mechanism these two situations cannot happen. The DDoS
>>>>>> mitigation software uses first and the monitoring uses before + 0, then no
>>>>>> matter the re-rollouts or the ordering in which Pods come up, it's always
>>>>>> at the expected/correct location.
>>>>> I'm not disputing that these kinds of policy issues need to be solved
>>>>> somehow. But adding the first/last pinning as part of the kernel hooks
>>>>> doesn't solve the policy problem, it just hard-codes a solution for one
>>>>> particular instance of the problem.
>>>>>
>>>>> Taking your example from above, what happens when someone wants to
>>>>> deploy those tools in reverse order? Say the monitoring tool counts
>>>>> packets and someone wants to also count the DDOS traffic; but the DDOS
>>>>> protection tool has decided for itself (by setting the FIRST) flag that
>>>>> it can *only* run as the first program, so there is no way to achieve
>>>>> this without modifying the application itself.
>>>>>
>>>>>>>> Because even with this new ordering scheme, there still should be
>>>>>>>> some entity to do relative ordering (systemd-style, maybe CNI?).
>>>>>>>> And if it does the ordering, I don't really see why we need
>>>>>>>> F_FIRST/F_LAST.
>>>>>>> I can see I'm a bit late to the party, but FWIW I agree with this:
>>>>>>> FIRST/LAST will definitely be abused if we add it. It also seems to me
>>>> It's in the prisoners' best interest to collaborate (and they do! see
>>>> https://www.youtube.com/watch?v=YK7GyEJdJGo), except the current
>>>> prio system is limiting and turns out to be really fragile in practice.
>>>>
>>>> If your tool wants to attach to tc prio 1 and there's already a prog
>>>> attached,
>>>> the most reliable option is basically to blindly replace the attachment,
>>>> unless
>>>> you have the possibility to inspect the attached prog and try to figure
>>>> out if it
>>>> belongs to another tool. This is fragile in and of itself, and only
>>>> possible on
>>>> more recent kernels iirc.
>>>>
>>>> With tcx, Cilium could make an initial attachment using F_FIRST and simply
>>>> update a link at well-known path on subsequent startups. If there's no
>>>> existing
>>>> link, and F_FIRST is taken, bail out with an error. The owner of the
>>>> existing
>>>> F_FIRST program can be queried and logged; we know for sure the program
>>>> doesn't belong to Cilium, and we have no interest in detaching it.
>>> That's conflating the benefit of F_FIRST with that of bpf_link, though;
>>> you can have the replace thing without the exclusive locking.
>>>>>> See above on the issues w/o the first/last. How would you work around them
>>>>>> in practice so they cannot happen?
>>>>> By having an ordering configuration that is deterministic. Enforced by
>>>>> the system-wide management daemon by whichever mechanism suits it. We
>>>>> could implement a minimal reference policy agent that just reads a
>>>>> config file in /etc somewhere, and *that* could implement FIRST/LAST
>>>>> semantics.
>>>> I think this particular perspective is what's deadlocking this discussion.
>>>> To me, it looks like distros and hyperscalers are in the same boat with
>>>> regards to the possibility of coordination between tools. Distros are only
>>>> responsible for the tools they package themselves, and hyperscalers
>>>> run a tight ship with mostly in-house tooling already. When it comes to
>>>> projects out in the wild, that all goes out the window.
>>> Not really: from the distro PoV we absolutely care about arbitrary
>>> combinations of programs with different authors. Which is why I'm
>>> arguing against putting anything into the kernel where the first program
>>> to come along can just grab a hook and lock everyone out.
>>> My assumption is basically this: A system administrator installs
>>> packages A and B that both use the TC hook. The developers of A and B
>>> have never heard about each other. It should be possible for that admin
>>> to run A and B in whichever order they like, without making any changes
>>> to A and B themselves.
>>
>> I would come with the point of view of the K8s cluster operator or platform
>> engineer, if you will. Someone deeply familiar with K8s, but not necessarily
>> knowing about kernel internals. I know my org needs to run container A and
>> container B, so I'll deploy the daemon-sets for both and they get deployed
>> into my cluster. That platform engineer might have never heard of BPF or might
>> not even know that container A or container B ships software with BPF. As
>> mentioned, K8s itself has no concept of Pod ordering as its paradigm is that
>> everything is loosely coupled. We are now expecting from that person to make
>> a concrete decision about some BPF kernel internals on various hooks in which
>> order they should be executed given if they don't then the system becomes
>> non-deterministic. I think that is quite a big burden and ask to understand.
>> Eventually that person will say that he/she cannot make this technical decision
>> and that only one of the two containers can be deployed. I agree with you that
>> there should be an option for a technically versed person to be able to change
>> ordering to avoid lock out, but I don't think it will fly asking users to come
>> up on their own with policies of BPF software in the wild ... similar as you
>> probably don't want having to deal with writing systemd unit files for software
>> xyz before you can use your laptop. It's a burden. You expect this to magically
>> work by default and only if needed for good reasons to make custom changes.
>> Just the one difference is that the latter ships with the OS (a priori known /
>> tight-ship analogy).
> 
> As someone deeply familiar with the K8s side of the equation you’re greatly oversimplifying.
> 
> You can’t just “run a daemon-set” for eBPF-enabled software and expect it to work.
> <Insert Boromir stating “One does not simply walk into Mordor”>
> 
> First off, you need to find out which privileges it needs.
> 
> Just CAP_BPF? Pttf nope.
> Depending on the program type likely it will need more, up to and including CAP_SYS_ADMIN.
> Scary stuff.
> 
> Beyond that, you’ll also need some “special” paths from the host mounted into your container
> for vmlinux, tracefs maybe even a bpffs etc…
> 
> Furthermore, all of these things above are usually restricted/discouraged in most K8s distros
> so you need to wade into the depths of how to disable these protections.
> 
> The poor platform engineer in this case will be forced to learn all of these concepts on-the-fly.
> So the assumption of them being oblivious to eBPF being run in their cluster should be dismissed.

Sure, a lot of the above is irrelevant to the discussion, though. Yes, things need to
align and in many cases this is done by the existing projects shipping via Helm charts
or other means to make installation easier. Unless you build something from scratch, ofc.

> Clearly explaining the following in documentation would make coming up with policies much easier:
> 1. Which priority you choose if not instructed otherwise via configuration
> 2. The risks of attaching other programs ahead/behind this one
> 3. The risks of having a conflicting priority with another application >
> Even from the bpf-enabled software vendor standpoint, the status-quo is annoying because you’ll
> need to provide recipes to deploy your software on every different K8s distro.
> 
> I’ve been working on bpfd [1] + it’s kube integration for the past year to solve these problems
> for users/vendors.
> 
>  From a kernel standpoint, give me an array that does something like this:
> - If no priority is provided picks the first free from upper 16 bits of the priority range
> - If priority is provided, attach at that priority
> - If conflict, use flags to decide what to do where the options are something like:
>    - BPF_F_ERR_ON_CONFLICT
>    - BPF_F_ASSIGN_ON_CONFLICT
> 
> That solves the immediate problem since given a block of u32 priorities I’m sure affected
> vendors can pick one within the lower 16 bits that would produce the desired ordering.

See the discussion that we're moving away from priorities. I used them in v1, but
the community feedback was that priorities are discouraged.

> As for how this works with a system daemon (and by extension in K8s), I’m of the
> opinion that the only viable option is to move program load and
> attachment to some other API, be it varlink, gRPC, or the K8s API.

Fwiw, I doubt that this will fly to be honest. You would have to rewrite libbpf, and
all loaders out in the wild to standardize and implement this rpc protocol, and you
also still need to support the non-rpc way of loading your BPF programs for the case
where you need to deal with old/existing environments where this is not the case. If
bpfd ships as a 3rd party software, then fingers crossed that eventually all k8s distros
would actually adopt it. If it's something that comes natively with K8s it would probably
have a better chance, but still you'd force every project to support loading via both
ways. It's not as straight forward, and for it to be the only viable path you need a
clean way for projects to transition to this w/o breaking.

> It’s at that layer that policy decisions about priority are made and the kernel semantics
> can remain as above.
> 
>>>> Regardless of merit or feasability of a system-wide bpf management
>>>> daemon for k8s, there _is no ordering configuration possible_. K8s is not
>>>> a distro where package maintainers (or anyone else, really) can coordinate
>>>> on correctly defining priority of each of the tools they ship. This is
>>>> effectively
>>>> the prisoner's dilemma. I feel like most of the discussion so far has been
>>>> very hand-wavy in 'user space should solve it'. Well, we are user space, and
>>>> we're here trying to solve it. :)
>>>>
>>>> A hypothetical policy/gatekeeper/ordering daemon doesn't possess
>>>> implicit knowledge about which program needs to go where in the chain,
>>>> nor is there an obvious heuristic about how to order things. Maintaining
>>>> such a configuration for all cloud-native tooling out there that possibly
>>>> uses bpf is simply impossible, as even a tool like Cilium can change
>>>> dramatically from one release to the next. Having to manage this too
>>>> would put a significant burden on velocity and flexibility for arguably
>>>> little benefit to the user.
>>>> So, daemon/kernel will need to be told how to order things, preferably by
>>>> the tools (Cilium/datadog-agent) themselves, since the user/admin of the
>>>> system cannot be expected to know where to position the hundreds of progs
>>>> loaded by Cilium and how they might interfere with other tools. Figuring
>>>> this out is the job of the tool, daemon or not.
> 
> I’m sorry but again I have to strongly disagree here.
> 
> Tools can provide hints at where they should be placed in a chain of programs, but
> that eventual placement should always be down to the user.
> 
> The examples you’ve cited are large, specialised applications… but consider for a moment how
> this works for smaller programs.
> 
> Let’s say you’ve got 3 programs:
> - Firewall
> - Load-Balancer
> - Packet Logger
> 
> There are 6 ways that I can order these programs, each of which will have a very different effect.
> How can any of these tools individually understand what the user actually wants?
> 
> - Dave
> 
> [1]: https://github.com/bpfd-dev/bpfd
> 


