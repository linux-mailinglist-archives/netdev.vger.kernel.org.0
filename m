Return-Path: <netdev+bounces-9702-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7464872A4BC
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 22:28:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B18FB281A45
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:28:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D340022E32;
	Fri,  9 Jun 2023 20:28:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507012099E;
	Fri,  9 Jun 2023 20:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F15C433EF;
	Fri,  9 Jun 2023 20:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686342512;
	bh=Gi3i+PvjIL/qableZxxJCIydbSUTQ88b5xQ7zlM9S5g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=S/SkWA5tYgb41gETFY2vAAdAsCMhMTag5XWmq30Rhzu0NzJn6vmARfEZ2qL9Hcrzw
	 Rdu+E5g4RBrkMLmypTeU+wUfNz617Lx1EBGBWjFrgzHZuLv3c4WDRfiEmotZWO9ytM
	 uJpt2UbYr+1LZvHlQ/6gZBickKyqto/39b5sZ7sQbp3CZws4nBPPJOF2xk8Sk8sugD
	 nLC47N8beBuHVqsOlwzcV4/4Rcd6X8Qwyz7k87gM4anyOa/ASe6jZXg82sF3DmHuES
	 LPsPAR0JK5+DbHF5bkY6A3vDVXbDCedTrcEV+lXxU5XAt1rHzPkWt1W7TTakQikP8X
	 25tYjRYeY2v/A==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id 76093BBE391; Fri,  9 Jun 2023 22:28:29 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>, Timo Beckers <timo@incline.eu>,
 Stanislav Fomichev <sdf@google.com>, Andrii Nakryiko
 <andrii.nakryiko@gmail.com>
Cc: ast@kernel.org, andrii@kernel.org, martin.lau@linux.dev,
 razor@blackwall.org, john.fastabend@gmail.com, kuba@kernel.org,
 dxu@dxuuu.xyz, joe@cilium.io, davem@davemloft.net, bpf@vger.kernel.org,
 netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 1/7] bpf: Add generic attach/detach/query
 API for multi-progs
In-Reply-To: <d0cf9a4f-c111-b594-7a12-84914419789e@iogearbox.net>
References: <20230607192625.22641-1-daniel@iogearbox.net>
 <20230607192625.22641-2-daniel@iogearbox.net>
 <ZIIOr1zvdRNTFKR7@google.com>
 <CAEf4BzbEf+U53UY6o+g5OZ6rg+T65_Aou4Nvrdbo-8sAjmdJmA@mail.gmail.com>
 <ZIJNlxCX4ksBFFwN@google.com>
 <CAEf4BzYbr5G8ZGnWEndiZ1-7_XqYfKFTorDvvafwZY0XJUn7cw@mail.gmail.com>
 <ZIJe5Ml6ILFa6tKP@google.com> <87a5x91nr8.fsf@toke.dk>
 <3a315a0d-52dd-7671-f6c1-bb681604c815@iogearbox.net>
 <874jng28xk.fsf@toke.dk> <1a73a1b9-c72a-de81-4fce-7ba4fb6d7900@incline.eu>
 <87sfb0zsok.fsf@toke.dk>
 <d0cf9a4f-c111-b594-7a12-84914419789e@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Fri, 09 Jun 2023 22:28:29 +0200
Message-ID: <87mt18z8gi.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 6/9/23 3:11 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Timo Beckers <timo@incline.eu> writes:
>>> On 6/9/23 13:04, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>> Daniel Borkmann <daniel@iogearbox.net> writes:
> [...]
>>>>>>>>>>> I'm still not sure whether the hard semantics of first/last is =
really
>>>>>>>>>>> useful. My worry is that some prog will just use BPF_F_FIRST wh=
ich
>>>>>>>>>>> would prevent the rest of the users.. (starting with only
>>>>>>>>>>> F_BEFORE/F_AFTER feels 'safer'; we can iterate later on if we r=
eally
>>>>>>>>>>> need first/laste).
>>>>>>>>>> Without FIRST/LAST some scenarios cannot be guaranteed to be saf=
ely
>>>>>>>>>> implemented. E.g., if I have some hard audit requirements and I =
need
>>>>>>>>>> to guarantee that my program runs first and observes each event,=
 I'll
>>>>>>>>>> enforce BPF_F_FIRST when attaching it. And if that attachment fa=
ils,
>>>>>>>>>> then server setup is broken and my application cannot function.
>>>>>>>>>>
>>>>>>>>>> In a setup where we expect multiple applications to co-exist, it
>>>>>>>>>> should be a rule that no one is using FIRST/LAST (unless it's
>>>>>>>>>> absolutely required). And if someone doesn't comply, then that's=
 a bug
>>>>>>>>>> and has to be reported to application owners.
>>>>>>>>>>
>>>>>>>>>> But it's not up to the kernel to enforce this cooperation by
>>>>>>>>>> disallowing FIRST/LAST semantics, because that semantics is crit=
ical
>>>>>>>>>> for some applications, IMO.
>>>>>>>>> Maybe that's something that should be done by some other mechanis=
m?
>>>>>>>>> (and as a follow up, if needed) Something akin to what Toke
>>>>>>>>> mentioned with another program doing sorting or similar.
>>>>>>>> The goal of this API is to avoid needing some extra special progra=
m to
>>>>>>>> do this sorting
>>>>>>>>
>>>>>>>>> Otherwise, those first/last are just plain simple old priority ba=
nds;
>>>>>>>>> only we have two now, not u16.
>>>>>>>> I think it's different. FIRST/LAST has to be used judiciously, of
>>>>>>>> course, but when they are needed, they will have no alternative.
>>>>>>>>
>>>>>>>> Also, specifying FIRST + LAST is the way to say "I want my program=
 to
>>>>>>>> be the only one attached". Should we encourage such use cases? No,=
 of
>>>>>>>> course. But I think it's fair  for users to be able to express thi=
s.
>>>>>>>>
>>>>>>>>> I'm mostly coming from the observability point: imagine I have my=
 fancy
>>>>>>>>> tc_ingress_tcpdump program that I want to attach as a first progr=
am to debug
>>>>>>>>> some issue, but it won't work because there is already a 'first' =
program
>>>>>>>>> installed.. Or the assumption that I'd do F_REPLACE | F_FIRST ?
>>>>>>>> If your production setup requires that some important program has =
to
>>>>>>>> be FIRST, then yeah, your "let me debug something" program shouldn=
't
>>>>>>>> interfere with it (assuming that FIRST requirement is a real
>>>>>>>> requirement and not someone just thinking they need to be first; b=
ut
>>>>>>>> that's up to user space to decide). Maybe the solution for you in =
that
>>>>>>>> case would be freplace program installed on top of that stubborn F=
IRST
>>>>>>>> program? And if we are talking about local debugging and developme=
nt,
>>>>>>>> then you are a sysadmin and you should be able to force-detach that
>>>>>>>> program that is getting in the way.
>>>>>>> I'm not really concerned about our production environment. It's pre=
tty
>>>>>>> controlled and restricted and I'm pretty certain we can avoid doing
>>>>>>> something stupid. Probably the same for your env.
>>>>>>>
>>>>>>> I'm mostly fantasizing about upstream world where different users d=
on't
>>>>>>> know about each other and start doing stupid things like F_FIRST wh=
ere
>>>>>>> they don't really have to be first. It's that "used judiciously" pa=
rt
>>>>>>> that I'm a bit skeptical about :-D
>>>>> But in the end how is that different from just attaching themselves b=
lindly
>>>>> into the first position (e.g. with before and relative_fd as 0 or the=
 fd/id
>>>>> of the current first program) - same, they don't really have to be fi=
rst.
>>>>> How would that not result in doing something stupid? ;) To add to And=
rii's
>>>>> earlier DDoS mitigation example ... think of K8s environment: one pro=
ject
>>>>> is implementing DDoS mitigation with BPF, another one wants to monito=
r/
>>>>> sample traffic to user space with BPF. Both install as first position=
 by
>>>>> default (before + 0). In K8s, there is no built-in Pod dependency man=
agement
>>>>> so you cannot guarantee whether Pod A comes up before Pod B. So you'l=
l end
>>>>> up in a situation where sometimes the monitor runs before the DDoS mi=
tigation
>>>>> and on some other nodes it's vice versa. The other case where this ge=
ts
>>>>> broken (assuming a node where we get first the DDoS mitigation, then =
the
>>>>> monitoring) is when you need to upgrade one of the Pods: monitoring P=
od
>>>>> gets a new stable update and is being re-rolled out, then it inserts
>>>>> itself before the DDoS mitigation mechanism, potentially causing outa=
ge.
>>>>> With the first/last mechanism these two situations cannot happen. The=
 DDoS
>>>>> mitigation software uses first and the monitoring uses before + 0, th=
en no
>>>>> matter the re-rollouts or the ordering in which Pods come up, it's al=
ways
>>>>> at the expected/correct location.
>>>> I'm not disputing that these kinds of policy issues need to be solved
>>>> somehow. But adding the first/last pinning as part of the kernel hooks
>>>> doesn't solve the policy problem, it just hard-codes a solution for one
>>>> particular instance of the problem.
>>>>
>>>> Taking your example from above, what happens when someone wants to
>>>> deploy those tools in reverse order? Say the monitoring tool counts
>>>> packets and someone wants to also count the DDOS traffic; but the DDOS
>>>> protection tool has decided for itself (by setting the FIRST) flag that
>>>> it can *only* run as the first program, so there is no way to achieve
>>>> this without modifying the application itself.
>>>>
>>>>>>> Because even with this new ordering scheme, there still should be
>>>>>>> some entity to do relative ordering (systemd-style, maybe CNI?).
>>>>>>> And if it does the ordering, I don't really see why we need
>>>>>>> F_FIRST/F_LAST.
>>>>>> I can see I'm a bit late to the party, but FWIW I agree with this:
>>>>>> FIRST/LAST will definitely be abused if we add it. It also seems to =
me
>>> It's in the prisoners' best interest to collaborate (and they do! see
>>> https://www.youtube.com/watch?v=3DYK7GyEJdJGo), except the current
>>> prio system is limiting and turns out to be really fragile in practice.
>>>
>>> If your tool wants to attach to tc prio 1 and there's already a prog
>>> attached,
>>> the most reliable option is basically to blindly replace the attachment,
>>> unless
>>> you have the possibility to inspect the attached prog and try to figure
>>> out if it
>>> belongs to another tool. This is fragile in and of itself, and only
>>> possible on
>>> more recent kernels iirc.
>>>
>>> With tcx, Cilium could make an initial attachment using F_FIRST and sim=
ply
>>> update a link at well-known path on subsequent startups. If there's no
>>> existing
>>> link, and F_FIRST is taken, bail out with an error. The owner of the
>>> existing
>>> F_FIRST program can be queried and logged; we know for sure the program
>>> doesn't belong to Cilium, and we have no interest in detaching it.
>>=20
>> That's conflating the benefit of F_FIRST with that of bpf_link, though;
>> you can have the replace thing without the exclusive locking.
>>=20
>>>>> See above on the issues w/o the first/last. How would you work around=
 them
>>>>> in practice so they cannot happen?
>>>> By having an ordering configuration that is deterministic. Enforced by
>>>> the system-wide management daemon by whichever mechanism suits it. We
>>>> could implement a minimal reference policy agent that just reads a
>>>> config file in /etc somewhere, and *that* could implement FIRST/LAST
>>>> semantics.
>>> I think this particular perspective is what's deadlocking this discussi=
on.
>>> To me, it looks like distros and hyperscalers are in the same boat with
>>> regards to the possibility of coordination between tools. Distros are o=
nly
>>> responsible for the tools they package themselves, and hyperscalers
>>> run a tight ship with mostly in-house tooling already. When it comes to
>>> projects out in the wild, that all goes out the window.
>>=20
>> Not really: from the distro PoV we absolutely care about arbitrary
>> combinations of programs with different authors. Which is why I'm
>> arguing against putting anything into the kernel where the first program
>> to come along can just grab a hook and lock everyone out.
>>=20
>> My assumption is basically this: A system administrator installs
>> packages A and B that both use the TC hook. The developers of A and B
>> have never heard about each other. It should be possible for that admin
>> to run A and B in whichever order they like, without making any changes
>> to A and B themselves.
>
> I would come with the point of view of the K8s cluster operator or platfo=
rm
> engineer, if you will. Someone deeply familiar with K8s, but not necessar=
ily
> knowing about kernel internals. I know my org needs to run container A and
> container B, so I'll deploy the daemon-sets for both and they get deployed
> into my cluster. That platform engineer might have never heard of BPF or =
might
> not even know that container A or container B ships software with BPF. As
> mentioned, K8s itself has no concept of Pod ordering as its paradigm is t=
hat
> everything is loosely coupled. We are now expecting from that person to m=
ake
> a concrete decision about some BPF kernel internals on various hooks in w=
hich
> order they should be executed given if they don't then the system becomes
> non-deterministic. I think that is quite a big burden and ask to understa=
nd.
> Eventually that person will say that he/she cannot make this technical de=
cision
> and that only one of the two containers can be deployed. I agree with you=
 that
> there should be an option for a technically versed person to be able to c=
hange
> ordering to avoid lock out, but I don't think it will fly asking users to=
 come
> up on their own with policies of BPF software in the wild ... similar as =
you
> probably don't want having to deal with writing systemd unit files for so=
ftware
> xyz before you can use your laptop. It's a burden. You expect this to mag=
ically
> work by default and only if needed for good reasons to make custom change=
s.
> Just the one difference is that the latter ships with the OS (a priori kn=
own /
> tight-ship analogy).

See my reply to Andrii: I'm not actually against having an API where an
application can say "please always run me first", I'm against the kernel
making a hard (UAPI) promise to honour that request.

>>> To circle back to the observability case: in offline discussions with
>>> Daniel,
>>> I've mentioned the need for 'shadow' progs that only collect data and
>>> pump it to user space, attached at specific points in the chain (still
>>> within tcx!).
>>> Their retcodes would be ignored, and context modifications would be
>>> rejected, so attaching multiple to the same hook can always succeed,
>>> much like cgroup multi. Consider the following:
>>>
>>> To attach a shadow prog before F_FIRST, a caller could use F_BEFORE |
>>> F_FIRST |
>>> F_RDONLY. Attaching between first and the 'relative' section: F_AFTER |
>>> F_FIRST |
>>> F_RDONLY, etc. The rdonly flag could even be made redundant if a new pr=
og/
>>> attach type is added for progs like these.
>>>
>>> This is still perfectly possible to implement on top of Daniel's
>>> proposal, and
>>> to me looks like it could address many of the concerns around ordering =
of
>>> progs I've seen in this thread, many mention data exfiltration.
>>=20
>> It may well be that semantics like this will turn out to be enough. Or
>> it may not (I personally believe we'll need something more expressive
>> still, and where the system admin has the option to override things; but
>> I may turn out to be wrong). Ultimately, my main point wrt this series
>> is that this kind of policy decision can be added later, and it's better
>> to merge the TCX infrastructure without it, instead of locking ourselves
>> into an API that is way too limited today. TCX (and in-kernel XDP
>> multiprog) has value without it, so let's merge that first and iterate
>> on the policy aspects.
>
> That's okay and I'll do that for v3 to move on.

Sounds good.

> I feel we might repeat the same discussion with no good solution for K8s
> users once we come back to this point again.

FWIW I do understand that we need to solve the problem for k8s as well,
and I'll try to get some people from RH who are working more with the
k8s side of things to look at this as well...

-Toke

