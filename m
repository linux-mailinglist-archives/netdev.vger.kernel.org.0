Return-Path: <netdev+bounces-9542-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78CC7729B2A
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 15:11:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 504FB1C20B12
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 13:11:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FFCA174CE;
	Fri,  9 Jun 2023 13:11:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E7279E5;
	Fri,  9 Jun 2023 13:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E80C433D2;
	Fri,  9 Jun 2023 13:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686316302;
	bh=PmsrRFhPPeHgUi1WPpAEAkyqbvkhDaBrr6icE/lOttU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=GOumSRLCsVIxWesR9+wIN3jua+C/BeFL7x/UVgRSuRx2aXDmC1lgzWl1pkjZFWuab
	 4FngF+b5zkAQlf/OzTTr3VzIku/3Qfr2OMe1/FTpjiSxVNUsYUnYchI/blQP6cjB1h
	 M2KyP6GEoWPSwTWVL2oR85UNeMzjaZ09RmHNYeK6d0fvDqu9nKM07dA/Tu7hNPv8cu
	 kRAfjEVr4ocOPU9NlGd7VT9b6dl0EeS8DZ6+uURdfNs1KUk+ih1vGL9WcP9qJW+EmQ
	 EUa+K5IjfhCLBd2oTalz6DzluhGaq91H4+T0EetYhwjIimgMOpED5825qV2CeDsXmE
	 goBSaAqzaTvbw==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id 36FD9BBE31A; Fri,  9 Jun 2023 15:11:39 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To: Timo Beckers <timo@incline.eu>, Daniel Borkmann <daniel@iogearbox.net>,
 Stanislav Fomichev <sdf@google.com>, Andrii Nakryiko
 <andrii.nakryiko@gmail.com>
Cc: ast@kernel.org, andrii@kernel.org, martin.lau@linux.dev,
 razor@blackwall.org, john.fastabend@gmail.com, kuba@kernel.org,
 dxu@dxuuu.xyz, joe@cilium.io, davem@davemloft.net, bpf@vger.kernel.org,
 netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 1/7] bpf: Add generic attach/detach/query
 API for multi-progs
In-Reply-To: <1a73a1b9-c72a-de81-4fce-7ba4fb6d7900@incline.eu>
References: <20230607192625.22641-1-daniel@iogearbox.net>
 <20230607192625.22641-2-daniel@iogearbox.net>
 <ZIIOr1zvdRNTFKR7@google.com>
 <CAEf4BzbEf+U53UY6o+g5OZ6rg+T65_Aou4Nvrdbo-8sAjmdJmA@mail.gmail.com>
 <ZIJNlxCX4ksBFFwN@google.com>
 <CAEf4BzYbr5G8ZGnWEndiZ1-7_XqYfKFTorDvvafwZY0XJUn7cw@mail.gmail.com>
 <ZIJe5Ml6ILFa6tKP@google.com> <87a5x91nr8.fsf@toke.dk>
 <3a315a0d-52dd-7671-f6c1-bb681604c815@iogearbox.net>
 <874jng28xk.fsf@toke.dk> <1a73a1b9-c72a-de81-4fce-7ba4fb6d7900@incline.eu>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Fri, 09 Jun 2023 15:11:39 +0200
Message-ID: <87sfb0zsok.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Timo Beckers <timo@incline.eu> writes:

> On 6/9/23 13:04, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Daniel Borkmann <daniel@iogearbox.net> writes:
>>
>>>>>>>>> I'm still not sure whether the hard semantics of first/last is re=
ally
>>>>>>>>> useful. My worry is that some prog will just use BPF_F_FIRST which
>>>>>>>>> would prevent the rest of the users.. (starting with only
>>>>>>>>> F_BEFORE/F_AFTER feels 'safer'; we can iterate later on if we rea=
lly
>>>>>>>>> need first/laste).
>>>>>>>> Without FIRST/LAST some scenarios cannot be guaranteed to be safely
>>>>>>>> implemented. E.g., if I have some hard audit requirements and I ne=
ed
>>>>>>>> to guarantee that my program runs first and observes each event, I=
'll
>>>>>>>> enforce BPF_F_FIRST when attaching it. And if that attachment fail=
s,
>>>>>>>> then server setup is broken and my application cannot function.
>>>>>>>>
>>>>>>>> In a setup where we expect multiple applications to co-exist, it
>>>>>>>> should be a rule that no one is using FIRST/LAST (unless it's
>>>>>>>> absolutely required). And if someone doesn't comply, then that's a=
 bug
>>>>>>>> and has to be reported to application owners.
>>>>>>>>
>>>>>>>> But it's not up to the kernel to enforce this cooperation by
>>>>>>>> disallowing FIRST/LAST semantics, because that semantics is critic=
al
>>>>>>>> for some applications, IMO.
>>>>>>> Maybe that's something that should be done by some other mechanism?
>>>>>>> (and as a follow up, if needed) Something akin to what Toke
>>>>>>> mentioned with another program doing sorting or similar.
>>>>>> The goal of this API is to avoid needing some extra special program =
to
>>>>>> do this sorting
>>>>>>
>>>>>>> Otherwise, those first/last are just plain simple old priority band=
s;
>>>>>>> only we have two now, not u16.
>>>>>> I think it's different. FIRST/LAST has to be used judiciously, of
>>>>>> course, but when they are needed, they will have no alternative.
>>>>>>
>>>>>> Also, specifying FIRST + LAST is the way to say "I want my program to
>>>>>> be the only one attached". Should we encourage such use cases? No, of
>>>>>> course. But I think it's fair  for users to be able to express this.
>>>>>>
>>>>>>> I'm mostly coming from the observability point: imagine I have my f=
ancy
>>>>>>> tc_ingress_tcpdump program that I want to attach as a first program=
 to debug
>>>>>>> some issue, but it won't work because there is already a 'first' pr=
ogram
>>>>>>> installed.. Or the assumption that I'd do F_REPLACE | F_FIRST ?
>>>>>> If your production setup requires that some important program has to
>>>>>> be FIRST, then yeah, your "let me debug something" program shouldn't
>>>>>> interfere with it (assuming that FIRST requirement is a real
>>>>>> requirement and not someone just thinking they need to be first; but
>>>>>> that's up to user space to decide). Maybe the solution for you in th=
at
>>>>>> case would be freplace program installed on top of that stubborn FIR=
ST
>>>>>> program? And if we are talking about local debugging and development,
>>>>>> then you are a sysadmin and you should be able to force-detach that
>>>>>> program that is getting in the way.
>>>>> I'm not really concerned about our production environment. It's pretty
>>>>> controlled and restricted and I'm pretty certain we can avoid doing
>>>>> something stupid. Probably the same for your env.
>>>>>
>>>>> I'm mostly fantasizing about upstream world where different users don=
't
>>>>> know about each other and start doing stupid things like F_FIRST where
>>>>> they don't really have to be first. It's that "used judiciously" part
>>>>> that I'm a bit skeptical about :-D
>>> But in the end how is that different from just attaching themselves bli=
ndly
>>> into the first position (e.g. with before and relative_fd as 0 or the f=
d/id
>>> of the current first program) - same, they don't really have to be firs=
t.
>>> How would that not result in doing something stupid? ;) To add to Andri=
i's
>>> earlier DDoS mitigation example ... think of K8s environment: one proje=
ct
>>> is implementing DDoS mitigation with BPF, another one wants to monitor/
>>> sample traffic to user space with BPF. Both install as first position by
>>> default (before + 0). In K8s, there is no built-in Pod dependency manag=
ement
>>> so you cannot guarantee whether Pod A comes up before Pod B. So you'll =
end
>>> up in a situation where sometimes the monitor runs before the DDoS miti=
gation
>>> and on some other nodes it's vice versa. The other case where this gets
>>> broken (assuming a node where we get first the DDoS mitigation, then the
>>> monitoring) is when you need to upgrade one of the Pods: monitoring Pod
>>> gets a new stable update and is being re-rolled out, then it inserts
>>> itself before the DDoS mitigation mechanism, potentially causing outage.
>>> With the first/last mechanism these two situations cannot happen. The D=
DoS
>>> mitigation software uses first and the monitoring uses before + 0, then=
 no
>>> matter the re-rollouts or the ordering in which Pods come up, it's alwa=
ys
>>> at the expected/correct location.
>> I'm not disputing that these kinds of policy issues need to be solved
>> somehow. But adding the first/last pinning as part of the kernel hooks
>> doesn't solve the policy problem, it just hard-codes a solution for one
>> particular instance of the problem.
>>
>> Taking your example from above, what happens when someone wants to
>> deploy those tools in reverse order? Say the monitoring tool counts
>> packets and someone wants to also count the DDOS traffic; but the DDOS
>> protection tool has decided for itself (by setting the FIRST) flag that
>> it can *only* run as the first program, so there is no way to achieve
>> this without modifying the application itself.
>>
>>>>> Because even with this new ordering scheme, there still should be
>>>>> some entity to do relative ordering (systemd-style, maybe CNI?).
>>>>> And if it does the ordering, I don't really see why we need
>>>>> F_FIRST/F_LAST.
>>>> I can see I'm a bit late to the party, but FWIW I agree with this:
>>>> FIRST/LAST will definitely be abused if we add it. It also seems to me
> It's in the prisoners' best interest to collaborate (and they do! see
> https://www.youtube.com/watch?v=3DYK7GyEJdJGo), except the current
> prio system is limiting and turns out to be really fragile in practice.
>
> If your tool wants to attach to tc prio 1 and there's already a prog=20
> attached,
> the most reliable option is basically to blindly replace the attachment,=
=20
> unless
> you have the possibility to inspect the attached prog and try to figure=20
> out if it
> belongs to another tool. This is fragile in and of itself, and only=20
> possible on
> more recent kernels iirc.
>
> With tcx, Cilium could make an initial attachment using F_FIRST and simply
> update a link at well-known path on subsequent startups. If there's no=20
> existing
> link, and F_FIRST is taken, bail out with an error. The owner of the=20
> existing
> F_FIRST program can be queried and logged; we know for sure the program
> doesn't belong to Cilium, and we have no interest in detaching it.

That's conflating the benefit of F_FIRST with that of bpf_link, though;
you can have the replace thing without the exclusive locking.

>>> See above on the issues w/o the first/last. How would you work around t=
hem
>>> in practice so they cannot happen?
>> By having an ordering configuration that is deterministic. Enforced by
>> the system-wide management daemon by whichever mechanism suits it. We
>> could implement a minimal reference policy agent that just reads a
>> config file in /etc somewhere, and *that* could implement FIRST/LAST
>> semantics.
> I think this particular perspective is what's deadlocking this discussion.
> To me, it looks like distros and hyperscalers are in the same boat with
> regards to the possibility of coordination between tools. Distros are only
> responsible for the tools they package themselves, and hyperscalers
> run a tight ship with mostly in-house tooling already. When it comes to
> projects out in the wild, that all goes out the window.

Not really: from the distro PoV we absolutely care about arbitrary
combinations of programs with different authors. Which is why I'm
arguing against putting anything into the kernel where the first program
to come along can just grab a hook and lock everyone out.

My assumption is basically this: A system administrator installs
packages A and B that both use the TC hook. The developers of A and B
have never heard about each other. It should be possible for that admin
to run A and B in whichever order they like, without making any changes
to A and B themselves.

> Regardless of merit or feasability of a system-wide bpf management
> daemon for k8s, there _is no ordering configuration possible_. K8s is not
> a distro where package maintainers (or anyone else, really) can coordinate
> on correctly defining priority of each of the tools they ship. This is=20
> effectively
> the prisoner's dilemma. I feel like most of the discussion so far has been
> very hand-wavy in 'user space should solve it'. Well, we are user space, =
and
> we're here trying to solve it. :)
>
> A hypothetical policy/gatekeeper/ordering daemon doesn't possess
> implicit knowledge about which program needs to go where in the chain,
> nor is there an obvious heuristic about how to order things. Maintaining
> such a configuration for all cloud-native tooling out there that possibly
> uses bpf is simply impossible, as even a tool like Cilium can change
> dramatically from one release to the next. Having to manage this too
> would put a significant burden on velocity and flexibility for arguably
> little benefit to the user.
>
> So, daemon/kernel will need to be told how to order things, preferably by
> the tools (Cilium/datadog-agent) themselves, since the user/admin of the
> system cannot be expected to know where to position the hundreds of progs
> loaded by Cilium and how they might interfere with other tools. Figuring
> this out is the job of the tool, daemon or not.
>
> The prisoners _must_ communicate (so, not abuse F_FIRST) for things to
> work correctly, and it's 100% in their best interest in doing so. Let's n=
ot
> pretend like we're able to solve game theory on this mailing list. :)
> We'll have to settle for the next-best thing: give user space a safe and=
=20
> clear
> API to allow it to coordinate and make the right decisions.

But "always first" is not a meaningful concept. It's just what we have
today (everyone picks priority 1), except now if there are two programs
that want the same hook, it will be the first program that wins the
contest (by locking the second one out), instead of the second program
winning (by overriding the first one) as is the case with the silent
override semantics we have with TC today. So we haven't solved the
problem, we've just shifted the breakage.

> To circle back to the observability case: in offline discussions with=20
> Daniel,
> I've mentioned the need for 'shadow' progs that only collect data and
> pump it to user space, attached at specific points in the chain (still=20
> within tcx!).
> Their retcodes would be ignored, and context modifications would be
> rejected, so attaching multiple to the same hook can always succeed,
> much like cgroup multi. Consider the following:
>
> To attach a shadow prog before F_FIRST, a caller could use F_BEFORE |=20
> F_FIRST |
> F_RDONLY. Attaching between first and the 'relative' section: F_AFTER |=20
> F_FIRST |
> F_RDONLY, etc. The rdonly flag could even be made redundant if a new prog/
> attach type is added for progs like these.
>
> This is still perfectly possible to implement on top of Daniel's=20
> proposal, and
> to me looks like it could address many of the concerns around ordering of
> progs I've seen in this thread, many mention data exfiltration.

It may well be that semantics like this will turn out to be enough. Or
it may not (I personally believe we'll need something more expressive
still, and where the system admin has the option to override things; but
I may turn out to be wrong). Ultimately, my main point wrt this series
is that this kind of policy decision can be added later, and it's better
to merge the TCX infrastructure without it, instead of locking ourselves
into an API that is way too limited today. TCX (and in-kernel XDP
multiprog) has value without it, so let's merge that first and iterate
on the policy aspects.

-Toke

