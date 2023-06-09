Return-Path: <netdev+bounces-9438-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 35B1872906C
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 08:52:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9E0C281874
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 06:52:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D444263D4;
	Fri,  9 Jun 2023 06:52:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99ECE1FCB;
	Fri,  9 Jun 2023 06:52:54 +0000 (UTC)
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7963226AD;
	Thu,  8 Jun 2023 23:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=Zce7jD3yMmKj5ywcbf8+TpMyjwL6KOjQLKSAAPOhSuA=; b=PJv9ZR4/Ccwkoc+Lu5n759TQUV
	4nVY11hyDhAvBs4Wss37loDWMPrsLcfZBSElOmFwk0r7P5NjvkB4dXbLu5BPPjIyArP7zxPpTDnSj
	hATP7hpgRqhRvEqLF96Mmn5hZqfl8Aeq1u3AOWLZuo9ukemrXmdUpsE7f3KwfNZEfYRYkM72PoJDY
	xVH1rmR0gd5F+8rGB9meV8zQ4EwXx6OoP4cswnfF1+oNoCAIiJcYMXNGYoM5mdLek7ELJJJgmO1xQ
	AS+tVc9H1xBKtrswd46Im6HyCJisnklvAvhixhnc/VB3++1VBO8UUmwsuUdSnpg8lmXXwZaUF8s6V
	QTC3/o9w==;
Received: from sslproxy01.your-server.de ([78.46.139.224])
	by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <daniel@iogearbox.net>)
	id 1q7VzB-000Bz1-SL; Fri, 09 Jun 2023 08:52:38 +0200
Received: from [178.197.249.34] (helo=linux.home)
	by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <daniel@iogearbox.net>)
	id 1q7VzB-000ABt-By; Fri, 09 Jun 2023 08:52:37 +0200
Subject: Re: [PATCH bpf-next v2 1/7] bpf: Add generic attach/detach/query API
 for multi-progs
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@kernel.org>,
 Stanislav Fomichev <sdf@google.com>,
 Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: ast@kernel.org, andrii@kernel.org, martin.lau@linux.dev,
 razor@blackwall.org, john.fastabend@gmail.com, kuba@kernel.org,
 dxu@dxuuu.xyz, joe@cilium.io, davem@davemloft.net, bpf@vger.kernel.org,
 netdev@vger.kernel.org
References: <20230607192625.22641-1-daniel@iogearbox.net>
 <20230607192625.22641-2-daniel@iogearbox.net> <ZIIOr1zvdRNTFKR7@google.com>
 <CAEf4BzbEf+U53UY6o+g5OZ6rg+T65_Aou4Nvrdbo-8sAjmdJmA@mail.gmail.com>
 <ZIJNlxCX4ksBFFwN@google.com>
 <CAEf4BzYbr5G8ZGnWEndiZ1-7_XqYfKFTorDvvafwZY0XJUn7cw@mail.gmail.com>
 <ZIJe5Ml6ILFa6tKP@google.com> <87a5x91nr8.fsf@toke.dk>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3a315a0d-52dd-7671-f6c1-bb681604c815@iogearbox.net>
Date: Fri, 9 Jun 2023 08:52:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <87a5x91nr8.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26933/Thu Jun  8 09:26:06 2023)
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/9/23 2:29 AM, Toke Høiland-Jørgensen wrote:
> Stanislav Fomichev <sdf@google.com> writes:
>> On 06/08, Andrii Nakryiko wrote:
>>> On Thu, Jun 8, 2023 at 2:52 PM Stanislav Fomichev <sdf@google.com> wrote:
>>>> On 06/08, Andrii Nakryiko wrote:
>>>>> On Thu, Jun 8, 2023 at 10:24 AM Stanislav Fomichev <sdf@google.com> wrote:
>>>>>> On 06/07, Daniel Borkmann wrote:
>>>>>>> This adds a generic layer called bpf_mprog which can be reused by different
>>>>>>> attachment layers to enable multi-program attachment and dependency resolution.
>>>>>>> In-kernel users of the bpf_mprog don't need to care about the dependency
>>>>>>> resolution internals, they can just consume it with few API calls.
>>>>>>>
>>>>>>> The initial idea of having a generic API sparked out of discussion [0] from an
>>>>>>> earlier revision of this work where tc's priority was reused and exposed via
>>>>>>> BPF uapi as a way to coordinate dependencies among tc BPF programs, similar
>>>>>>> as-is for classic tc BPF. The feedback was that priority provides a bad user
>>>>>>> experience and is hard to use [1], e.g.:
>>>>>>>
>>>>>>>    I cannot help but feel that priority logic copy-paste from old tc, netfilter
>>>>>>>    and friends is done because "that's how things were done in the past". [...]
>>>>>>>    Priority gets exposed everywhere in uapi all the way to bpftool when it's
>>>>>>>    right there for users to understand. And that's the main problem with it.
>>>>>>>
>>>>>>>    The user don't want to and don't need to be aware of it, but uapi forces them
>>>>>>>    to pick the priority. [...] Your cover letter [0] example proves that in
>>>>>>>    real life different service pick the same priority. They simply don't know
>>>>>>>    any better. Priority is an unnecessary magic that apps _have_ to pick, so
>>>>>>>    they just copy-paste and everyone ends up using the same.
>>>>>>>
>>>>>>> The course of the discussion showed more and more the need for a generic,
>>>>>>> reusable API where the "same look and feel" can be applied for various other
>>>>>>> program types beyond just tc BPF, for example XDP today does not have multi-
>>>>>>> program support in kernel, but also there was interest around this API for
>>>>>>> improving management of cgroup program types. Such common multi-program
>>>>>>> management concept is useful for BPF management daemons or user space BPF
>>>>>>> applications coordinating about their attachments.
>>>>>>>
>>>>>>> Both from Cilium and Meta side [2], we've collected the following requirements
>>>>>>> for a generic attach/detach/query API for multi-progs which has been implemented
>>>>>>> as part of this work:
>>>>>>>
>>>>>>>    - Support prog-based attach/detach and link API
>>>>>>>    - Dependency directives (can also be combined):
>>>>>>>      - BPF_F_{BEFORE,AFTER} with relative_{fd,id} which can be {prog,link,none}
>>>>>>>        - BPF_F_ID flag as {fd,id} toggle
>>>>>>>        - BPF_F_LINK flag as {prog,link} toggle
>>>>>>>        - If relative_{fd,id} is none, then BPF_F_BEFORE will just prepend, and
>>>>>>>          BPF_F_AFTER will just append for the case of attaching
>>>>>>>        - Enforced only at attach time
>>>>>>>      - BPF_F_{FIRST,LAST}
>>>>>>>        - Enforced throughout the bpf_mprog state's lifetime
>>>>>>>        - Admin override possible (e.g. link detach, prog-based BPF_F_REPLACE)
>>>>>>>    - Internal revision counter and optionally being able to pass expected_revision
>>>>>>>    - User space daemon can query current state with revision, and pass it along
>>>>>>>      for attachment to assert current state before doing updates
>>>>>>>    - Query also gets extension for link_ids array and link_attach_flags:
>>>>>>>      - prog_ids are always filled with program IDs
>>>>>>>      - link_ids are filled with link IDs when link was used, otherwise 0
>>>>>>>      - {prog,link}_attach_flags for holding {prog,link}-specific flags
>>>>>>>    - Must be easy to integrate/reuse for in-kernel users
>>>>>>>
>>>>>>> The uapi-side changes needed for supporting bpf_mprog are rather minimal,
>>>>>>> consisting of the additions of the attachment flags, revision counter, and
>>>>>>> expanding existing union with relative_{fd,id} member.
>>>>>>>
>>>>>>> The bpf_mprog framework consists of an bpf_mprog_entry object which holds
>>>>>>> an array of bpf_mprog_fp (fast-path structure) and bpf_mprog_cp (control-path
>>>>>>> structure). Both have been separated, so that fast-path gets efficient packing
>>>>>>> of bpf_prog pointers for maximum cache efficieny. Also, array has been chosen
>>>>>>> instead of linked list or other structures to remove unnecessary indirections
>>>>>>> for a fast point-to-entry in tc for BPF. The bpf_mprog_entry comes as a pair
>>>>>>> via bpf_mprog_bundle so that in case of updates the peer bpf_mprog_entry
>>>>>>> is populated and then just swapped which avoids additional allocations that
>>>>>>> could otherwise fail, for example, in detach case. bpf_mprog_{fp,cp} arrays are
>>>>>>> currently static, but they could be converted to dynamic allocation if necessary
>>>>>>> at a point in future. Locking is deferred to the in-kernel user of bpf_mprog,
>>>>>>> for example, in case of tcx which uses this API in the next patch, it piggy-
>>>>>>> backs on rtnl. The nitty-gritty details are in the bpf_mprog_{replace,head_tail,
>>>>>>> add,del} implementation and an extensive test suite for checking all aspects
>>>>>>> of this API for prog-based attach/detach and link API as BPF selftests in
>>>>>>> this series.
>>>>>>>
>>>>>>> Kudos also to Andrii Nakryiko for API discussions wrt Meta's BPF management daemon.
>>>>>>>
>>>>>>>    [0] https://lore.kernel.org/bpf/20221004231143.19190-1-daniel@iogearbox.net/
>>>>>>>    [1] https://lore.kernel.org/bpf/CAADnVQ+gEY3FjCR=+DmjDR4gp5bOYZUFJQXj4agKFHT9CQPZBw@mail.gmail.com
>>>>>>>    [2] http://vger.kernel.org/bpfconf2023_material/tcx_meta_netdev_borkmann.pdf
>>>>>>>
>>>>>>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>>>>>>> ---
>>>>>>>   MAINTAINERS                    |   1 +
>>>>>>>   include/linux/bpf_mprog.h      | 245 +++++++++++++++++
>>>>>>>   include/uapi/linux/bpf.h       |  37 ++-
>>>>>>>   kernel/bpf/Makefile            |   2 +-
>>>>>>>   kernel/bpf/mprog.c             | 476 +++++++++++++++++++++++++++++++++
>>>>>>>   tools/include/uapi/linux/bpf.h |  37 ++-
>>>>>>>   6 files changed, 781 insertions(+), 17 deletions(-)
>>>>>>>   create mode 100644 include/linux/bpf_mprog.h
>>>>>>>   create mode 100644 kernel/bpf/mprog.c
>>>>>
>>>>> [...]
>>>>>
>>>>>>> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
>>>>>>> index a7b5e91dd768..207f8a37b327 100644
>>>>>>> --- a/tools/include/uapi/linux/bpf.h
>>>>>>> +++ b/tools/include/uapi/linux/bpf.h
>>>>>>> @@ -1102,7 +1102,14 @@ enum bpf_link_type {
>>>>>>>    */
>>>>>>>   #define BPF_F_ALLOW_OVERRIDE (1U << 0)
>>>>>>>   #define BPF_F_ALLOW_MULTI    (1U << 1)
>>>>>>> +/* Generic attachment flags. */
>>>>>>>   #define BPF_F_REPLACE                (1U << 2)
>>>>>>> +#define BPF_F_BEFORE         (1U << 3)
>>>>>>> +#define BPF_F_AFTER          (1U << 4)
>>>>>>
>>>>>> [..]
>>>>>>
>>>>>>> +#define BPF_F_FIRST          (1U << 5)
>>>>>>> +#define BPF_F_LAST           (1U << 6)
>>>>>>
>>>>>> I'm still not sure whether the hard semantics of first/last is really
>>>>>> useful. My worry is that some prog will just use BPF_F_FIRST which
>>>>>> would prevent the rest of the users.. (starting with only
>>>>>> F_BEFORE/F_AFTER feels 'safer'; we can iterate later on if we really
>>>>>> need first/laste).
>>>>>
>>>>> Without FIRST/LAST some scenarios cannot be guaranteed to be safely
>>>>> implemented. E.g., if I have some hard audit requirements and I need
>>>>> to guarantee that my program runs first and observes each event, I'll
>>>>> enforce BPF_F_FIRST when attaching it. And if that attachment fails,
>>>>> then server setup is broken and my application cannot function.
>>>>>
>>>>> In a setup where we expect multiple applications to co-exist, it
>>>>> should be a rule that no one is using FIRST/LAST (unless it's
>>>>> absolutely required). And if someone doesn't comply, then that's a bug
>>>>> and has to be reported to application owners.
>>>>>
>>>>> But it's not up to the kernel to enforce this cooperation by
>>>>> disallowing FIRST/LAST semantics, because that semantics is critical
>>>>> for some applications, IMO.
>>>>
>>>> Maybe that's something that should be done by some other mechanism?
>>>> (and as a follow up, if needed) Something akin to what Toke
>>>> mentioned with another program doing sorting or similar.
>>>
>>> The goal of this API is to avoid needing some extra special program to
>>> do this sorting
>>>
>>>> Otherwise, those first/last are just plain simple old priority bands;
>>>> only we have two now, not u16.
>>>
>>> I think it's different. FIRST/LAST has to be used judiciously, of
>>> course, but when they are needed, they will have no alternative.
>>>
>>> Also, specifying FIRST + LAST is the way to say "I want my program to
>>> be the only one attached". Should we encourage such use cases? No, of
>>> course. But I think it's fair  for users to be able to express this.
>>>
>>>> I'm mostly coming from the observability point: imagine I have my fancy
>>>> tc_ingress_tcpdump program that I want to attach as a first program to debug
>>>> some issue, but it won't work because there is already a 'first' program
>>>> installed.. Or the assumption that I'd do F_REPLACE | F_FIRST ?
>>>
>>> If your production setup requires that some important program has to
>>> be FIRST, then yeah, your "let me debug something" program shouldn't
>>> interfere with it (assuming that FIRST requirement is a real
>>> requirement and not someone just thinking they need to be first; but
>>> that's up to user space to decide). Maybe the solution for you in that
>>> case would be freplace program installed on top of that stubborn FIRST
>>> program? And if we are talking about local debugging and development,
>>> then you are a sysadmin and you should be able to force-detach that
>>> program that is getting in the way.
>>
>> I'm not really concerned about our production environment. It's pretty
>> controlled and restricted and I'm pretty certain we can avoid doing
>> something stupid. Probably the same for your env.
>>
>> I'm mostly fantasizing about upstream world where different users don't
>> know about each other and start doing stupid things like F_FIRST where
>> they don't really have to be first. It's that "used judiciously" part
>> that I'm a bit skeptical about :-D

But in the end how is that different from just attaching themselves blindly
into the first position (e.g. with before and relative_fd as 0 or the fd/id
of the current first program) - same, they don't really have to be first.
How would that not result in doing something stupid? ;) To add to Andrii's
earlier DDoS mitigation example ... think of K8s environment: one project
is implementing DDoS mitigation with BPF, another one wants to monitor/
sample traffic to user space with BPF. Both install as first position by
default (before + 0). In K8s, there is no built-in Pod dependency management
so you cannot guarantee whether Pod A comes up before Pod B. So you'll end
up in a situation where sometimes the monitor runs before the DDoS mitigation
and on some other nodes it's vice versa. The other case where this gets
broken (assuming a node where we get first the DDoS mitigation, then the
monitoring) is when you need to upgrade one of the Pods: monitoring Pod
gets a new stable update and is being re-rolled out, then it inserts
itself before the DDoS mitigation mechanism, potentially causing outage.
With the first/last mechanism these two situations cannot happen. The DDoS
mitigation software uses first and the monitoring uses before + 0, then no
matter the re-rollouts or the ordering in which Pods come up, it's always
at the expected/correct location.

>> Because even with this new ordering scheme, there still should be
>> some entity to do relative ordering (systemd-style, maybe CNI?).
>> And if it does the ordering, I don't really see why we need
>> F_FIRST/F_LAST.
> 
> I can see I'm a bit late to the party, but FWIW I agree with this:
> FIRST/LAST will definitely be abused if we add it. It also seems to me

See above on the issues w/o the first/last. How would you work around them
in practice so they cannot happen?

> to be policy in the kernel, which would be much better handled in
> userspace like we do for so many other things. So we should rather
> expose a hook to allow userspace to set the policy, as we've discussed
> before; I definitely think we should add that at some point! Although
> obviously it doesn't have to be part of this series...

Imo, it would be better if we could avoid that.. it feels like we're
trying to shoot sparrows with cannon, e.g. when this API gets reused
for other attach hooks, then for each of them you need yet another
policy program. I don't think that's a good user experience, and I
presume this is then single-user program, thus you'll run into the same
race in the end - whichever management daemon or application gets to
install this policy program first wins. This is potentially just
shifting the same issue one level higher, imo.

Thanks,
Daniel

