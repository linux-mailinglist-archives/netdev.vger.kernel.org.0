Return-Path: <netdev+bounces-9503-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89D2D7297B5
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 13:04:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D20F1C21105
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 11:04:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC93C1096D;
	Fri,  9 Jun 2023 11:04:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7DF8472;
	Fri,  9 Jun 2023 11:04:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FAAC433EF;
	Fri,  9 Jun 2023 11:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686308682;
	bh=/ZBBK71Gao1Rfr2HDkukRbqhfbCsu1SOwj+6rfheKQI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=UDIK8aMzRT4Wdb7zPQkr6Vg4Fw8ighrX8fbeCrR+lFGV0Qv5Odmwji/lbwnGNYoG1
	 q1k5ZlYRi9P4dLA5mGfpn3IuLZgCB1Hg9yx2YhZE5/56e8+Hk3mtBa6+YoV2Bnu0bT
	 N17RmKu68g7WGmj6cMWg4z9KJuzjbFAick0NvcxUJTnicvbCX1scaB9BROxvXuYX/F
	 CZKIVJALad38LdoWpZSr8b68MUh1ntfvpJIGMiKeHqEFxRBUK+JhsEtSTkJjQAMGbJ
	 9BSLVQW4IT4wAiPYWYfjzinwiDvpxb7l2oV5u7e9O8BH5a/LE9XvBFUt6irrBFSt/6
	 7qd0gSzZboIpQ==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id EA4F5BBE2E0; Fri,  9 Jun 2023 13:04:39 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>, Stanislav Fomichev
 <sdf@google.com>, Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: ast@kernel.org, andrii@kernel.org, martin.lau@linux.dev,
 razor@blackwall.org, john.fastabend@gmail.com, kuba@kernel.org,
 dxu@dxuuu.xyz, joe@cilium.io, davem@davemloft.net, bpf@vger.kernel.org,
 netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 1/7] bpf: Add generic attach/detach/query
 API for multi-progs
In-Reply-To: <3a315a0d-52dd-7671-f6c1-bb681604c815@iogearbox.net>
References: <20230607192625.22641-1-daniel@iogearbox.net>
 <20230607192625.22641-2-daniel@iogearbox.net>
 <ZIIOr1zvdRNTFKR7@google.com>
 <CAEf4BzbEf+U53UY6o+g5OZ6rg+T65_Aou4Nvrdbo-8sAjmdJmA@mail.gmail.com>
 <ZIJNlxCX4ksBFFwN@google.com>
 <CAEf4BzYbr5G8ZGnWEndiZ1-7_XqYfKFTorDvvafwZY0XJUn7cw@mail.gmail.com>
 <ZIJe5Ml6ILFa6tKP@google.com> <87a5x91nr8.fsf@toke.dk>
 <3a315a0d-52dd-7671-f6c1-bb681604c815@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Fri, 09 Jun 2023 13:04:39 +0200
Message-ID: <874jng28xk.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Daniel Borkmann <daniel@iogearbox.net> writes:

>>>>>>> I'm still not sure whether the hard semantics of first/last is really
>>>>>>> useful. My worry is that some prog will just use BPF_F_FIRST which
>>>>>>> would prevent the rest of the users.. (starting with only
>>>>>>> F_BEFORE/F_AFTER feels 'safer'; we can iterate later on if we really
>>>>>>> need first/laste).
>>>>>>
>>>>>> Without FIRST/LAST some scenarios cannot be guaranteed to be safely
>>>>>> implemented. E.g., if I have some hard audit requirements and I need
>>>>>> to guarantee that my program runs first and observes each event, I'll
>>>>>> enforce BPF_F_FIRST when attaching it. And if that attachment fails,
>>>>>> then server setup is broken and my application cannot function.
>>>>>>
>>>>>> In a setup where we expect multiple applications to co-exist, it
>>>>>> should be a rule that no one is using FIRST/LAST (unless it's
>>>>>> absolutely required). And if someone doesn't comply, then that's a bug
>>>>>> and has to be reported to application owners.
>>>>>>
>>>>>> But it's not up to the kernel to enforce this cooperation by
>>>>>> disallowing FIRST/LAST semantics, because that semantics is critical
>>>>>> for some applications, IMO.
>>>>>
>>>>> Maybe that's something that should be done by some other mechanism?
>>>>> (and as a follow up, if needed) Something akin to what Toke
>>>>> mentioned with another program doing sorting or similar.
>>>>
>>>> The goal of this API is to avoid needing some extra special program to
>>>> do this sorting
>>>>
>>>>> Otherwise, those first/last are just plain simple old priority bands;
>>>>> only we have two now, not u16.
>>>>
>>>> I think it's different. FIRST/LAST has to be used judiciously, of
>>>> course, but when they are needed, they will have no alternative.
>>>>
>>>> Also, specifying FIRST + LAST is the way to say "I want my program to
>>>> be the only one attached". Should we encourage such use cases? No, of
>>>> course. But I think it's fair  for users to be able to express this.
>>>>
>>>>> I'm mostly coming from the observability point: imagine I have my fancy
>>>>> tc_ingress_tcpdump program that I want to attach as a first program to debug
>>>>> some issue, but it won't work because there is already a 'first' program
>>>>> installed.. Or the assumption that I'd do F_REPLACE | F_FIRST ?
>>>>
>>>> If your production setup requires that some important program has to
>>>> be FIRST, then yeah, your "let me debug something" program shouldn't
>>>> interfere with it (assuming that FIRST requirement is a real
>>>> requirement and not someone just thinking they need to be first; but
>>>> that's up to user space to decide). Maybe the solution for you in that
>>>> case would be freplace program installed on top of that stubborn FIRST
>>>> program? And if we are talking about local debugging and development,
>>>> then you are a sysadmin and you should be able to force-detach that
>>>> program that is getting in the way.
>>>
>>> I'm not really concerned about our production environment. It's pretty
>>> controlled and restricted and I'm pretty certain we can avoid doing
>>> something stupid. Probably the same for your env.
>>>
>>> I'm mostly fantasizing about upstream world where different users don't
>>> know about each other and start doing stupid things like F_FIRST where
>>> they don't really have to be first. It's that "used judiciously" part
>>> that I'm a bit skeptical about :-D
>
> But in the end how is that different from just attaching themselves blindly
> into the first position (e.g. with before and relative_fd as 0 or the fd/id
> of the current first program) - same, they don't really have to be first.
> How would that not result in doing something stupid? ;) To add to Andrii's
> earlier DDoS mitigation example ... think of K8s environment: one project
> is implementing DDoS mitigation with BPF, another one wants to monitor/
> sample traffic to user space with BPF. Both install as first position by
> default (before + 0). In K8s, there is no built-in Pod dependency management
> so you cannot guarantee whether Pod A comes up before Pod B. So you'll end
> up in a situation where sometimes the monitor runs before the DDoS mitigation
> and on some other nodes it's vice versa. The other case where this gets
> broken (assuming a node where we get first the DDoS mitigation, then the
> monitoring) is when you need to upgrade one of the Pods: monitoring Pod
> gets a new stable update and is being re-rolled out, then it inserts
> itself before the DDoS mitigation mechanism, potentially causing outage.
> With the first/last mechanism these two situations cannot happen. The DDoS
> mitigation software uses first and the monitoring uses before + 0, then no
> matter the re-rollouts or the ordering in which Pods come up, it's always
> at the expected/correct location.

I'm not disputing that these kinds of policy issues need to be solved
somehow. But adding the first/last pinning as part of the kernel hooks
doesn't solve the policy problem, it just hard-codes a solution for one
particular instance of the problem.

Taking your example from above, what happens when someone wants to
deploy those tools in reverse order? Say the monitoring tool counts
packets and someone wants to also count the DDOS traffic; but the DDOS
protection tool has decided for itself (by setting the FIRST) flag that
it can *only* run as the first program, so there is no way to achieve
this without modifying the application itself.

>>> Because even with this new ordering scheme, there still should be
>>> some entity to do relative ordering (systemd-style, maybe CNI?).
>>> And if it does the ordering, I don't really see why we need
>>> F_FIRST/F_LAST.
>> 
>> I can see I'm a bit late to the party, but FWIW I agree with this:
>> FIRST/LAST will definitely be abused if we add it. It also seems to me
>
> See above on the issues w/o the first/last. How would you work around them
> in practice so they cannot happen?

By having an ordering configuration that is deterministic. Enforced by
the system-wide management daemon by whichever mechanism suits it. We
could implement a minimal reference policy agent that just reads a
config file in /etc somewhere, and *that* could implement FIRST/LAST
semantics.

>> to be policy in the kernel, which would be much better handled in
>> userspace like we do for so many other things. So we should rather
>> expose a hook to allow userspace to set the policy, as we've discussed
>> before; I definitely think we should add that at some point! Although
>> obviously it doesn't have to be part of this series...
>
> Imo, it would be better if we could avoid that.. it feels like we're
> trying to shoot sparrows with cannon, e.g. when this API gets reused
> for other attach hooks, then for each of them you need yet another
> policy program.

Or a single one that understands multiple program types. Sharing the
multi-prog implementation is helpful here.

> I don't think that's a good user experience, and I presume this is
> then single-user program, thus you'll run into the same race in the
> end - whichever management daemon or application gets to install this
> policy program first wins. This is potentially just shifting the same
> issue one level higher, imo.

Sure, we're shifting the problem one level higher, i.e., out of the
kernel. That's the point: this is better solved in userspace, so
different environments can solve it according to their needs :)

I'm not against having one policy agent on the system, I just don't
think the kernel should hard-code one particular solution to the policy
problem. Much better to merge this without it, and then iterate on
different options (and happy to help with this!), instead of locking the
UAPI into a single solution straight away.

-Toke

