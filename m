Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47671178458
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 21:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731583AbgCCUxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 15:53:41 -0500
Received: from www62.your-server.de ([213.133.104.62]:37814 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731123AbgCCUxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 15:53:41 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j9EXn-0005NF-Ok; Tue, 03 Mar 2020 21:53:35 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j9EXn-0002Oc-Fh; Tue, 03 Mar 2020 21:53:35 +0100
Subject: Re: [PATCH bpf-next 0/3] Introduce pinnable bpf_link kernel
 abstraction
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
References: <20200228223948.360936-1-andriin@fb.com> <87mu8zt6a8.fsf@toke.dk>
 <CAEf4BzZGn9FcUdEOSR_ouqSNvzY2AdJA=8ffMV5mTmJQS-10VA@mail.gmail.com>
 <87imjms8cm.fsf@toke.dk> <094a8c0f-d781-d2a2-d4cd-721b20d75edd@iogearbox.net>
 <e9a4351a-4cf9-120a-1ae1-94a707a6217f@fb.com>
 <8083c916-ac2c-8ce0-2286-4ea40578c47f@iogearbox.net>
 <CAEf4BzbokCJN33Nw_kg82sO=xppXnKWEncGTWCTB9vGCmLB6pw@mail.gmail.com>
 <87pndt4268.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ab2f98f6-c712-d8a2-1fd3-b39abbaa9f64@iogearbox.net>
Date:   Tue, 3 Mar 2020 21:53:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87pndt4268.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25740/Tue Mar  3 13:12:16 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/3/20 9:24 PM, Toke Høiland-Jørgensen wrote:
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>> On Tue, Mar 3, 2020 at 11:23 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>> On 3/3/20 4:46 PM, Alexei Starovoitov wrote:
>>>> On 3/3/20 12:12 AM, Daniel Borkmann wrote:
>>>>>
>>>>> I can see the motivation for this abstraction in particular for tracing, but given
>>>>> the goal of bpf_link is to formalize and make the various program attachment types
>>>>> more uniform, how is this going to solve e.g. the tc/BPF case? There is no guarantee
>>>>> that while you create a link with the prog attached to cls_bpf that someone else is
>>>>> going to replace that qdisc underneath you, and hence you end up with the same case
>>>>> as if you would have only pinned the program itself (and not a link). So bpf_link
>>>>> then gives a wrong impression that something is still attached and active while it
>>>>> is not. What is the plan for these types?
>>>>
>>>> TC is not easy to handle, right, but I don't see a 'wrong impression' part. The link will keep the program attached to qdisc. The admin
>>>> may try to remove qdisc for netdev, but that's a separate issue.
>>>> Same thing with xdp. The link will keep xdp program attached,
>>>> but admin may do ifconfig down and no packets will be flowing.
>>>> Similar with cgroups. The link will keep prog attached to a cgroup,
>>>> but admin can still do rmdir and cgroup will be in 'dying' state.
>>>> In case of tracing there is no intermediate entity between programs
>>>> and the kernel. In case of networking there are layers.
>>>> Netdevs, qdiscs, etc. May be dev_hold is a way to go.
>>>
>>> Yep, right. I mean taking tracing use-case aside, in Cilium we attach to XDP, tc,
>>> cgroups BPF and whatnot, and we can tear down the Cilium user space agent just
>>> fine while packets keep flowing through the BPF progs, and a later restart will
>>> just reattach them atomically, e.g. Cilium version upgrades are usually done this
>>> way.
>>
>> Right. This is the case where you want attached BPF program to survive
>> control application process exiting. Which is not a safe default,
>> though, because it might lead to BPF program running without anyone
>> knowing, leading to really bad consequences. It's especially important
>> for applications that are deployed fleet-wide and that don't "control"
>> hosts they are deployed to. If such application crashes and no one
>> notices and does anything about that, BPF program will keep running
>> draining resources or even just, say, dropping packets. We at FB had
>> outages due to such permanent BPF attachment semantics. With FD-based

I think it depends on the environment, and yes, whether the orchestrator
of those progs controls the host [networking] as in case of Cilium. We
actually had cases where a large user in prod was accidentally removing
the Cilium k8s daemon set (and hence the user space agent as well) and only
noticed 1hrs later since everything just kept running in the data path as
expected w/o causing them an outage. So I think both attachment semantics
have pros and cons. ;)

>> bpf_link we are getting a framework, which allows safe,
>> auto-detachable behavior by default, unless application explicitly
>> opts in w/ bpf_link__pin().
>>
>>> This decoupling works since the attach point is already holding the reference on
>>> the program, and if needed user space can always retrieve what has been attached
>>> there. So the surrounding object acts like the "bpf_link" already. I think we need
>>> to figure out what semantics an actual bpf_link should have there. Given an admin
>>> can change qdisc/netdev/etc underneath us, and hence cause implicit detachment, I
>>> don't know whether it would make much sense to keep surrounding objects like filter,
>>> qdisc or even netdev alive to work around it since there's a whole dependency chain,
>>> like in case of filter instance, it would be kept alive, but surrounding qdisc may
>>> be dropped.
>>
>> I don't have specific enough knowledge right now to answer tc/BPF
>> question, but it seems like attached BPF program should hold a
>> reference to whatever it's attached to (net_device or whatnot) and not
>> let it just disappear? E.g., for cgroups, cgroup will go into dying

But then are you also expecting that netlink requests which drop that tc
filter that holds this BPF prog would get rejected given it has a bpf_link,
is active & pinned and traffic goes through? If not the case, then what
would be the point? If it is the case, then this seems rather complex to
realize for rather little gain given there are two uapi interfaces (bpf,
tc/netlink) which then mess around with the same underlying object in
different ways.

>> state, but it still will be there as long as there are remaining BPF
>> programs attached, sockets open, etc. I think it should be a general
>> approach, but again, I don't know specifics of each "attach point".
>>
>>> Question is, if there are no good semantics and benefits over what can be done
>>> today with existing infra (abstracted from user space via libbpf) for the remaining
>>> program types, perhaps it makes sense to have the pinning tracing specific only
>>> instead of generic abstraction which only ever works for a limited number?
>>
>> See above, I think bpf_link is what allows to have both
>> auto-detachment by default, as well as allow long-lived BPF
>> attachments (with explicit opt int).
>>
>> As for what bpf_link can provide on top of existing stuff. One thing
>> that becomes more apparent with recent XDP discussions and what was
>> solved in cgroup-specific way for cgroup BPFs, is that there is a need
>> to swap BPF programs without interruption (BPF_F_REPLACE behavior for
>> cgroup BPF). Similar semantics is desirable for XDP, it seems. That's
>> where bpf_link is useful. Once bpf_link is attached (for specificity,
>> let's say XDP program to some ifindex), it cannot be replaced with
>> other bpf_link. Attached bpf_link will need to be detached first (by
>> means of closing all open FDs) to it. This ensures no-one can
>> accidentally replace XDP dispatcher program.
>>
>> Now, once you have bpf_link attached, there will be bpf_link operation
>> (e.g., BPF_LINK_SWAP or something like that), where underlying BPF
>> program, associated with bpf_link, will get replaced with a new BPF
>> program without an interruption. Optionally, we can provide
>> expected_bpf_program_fd to make sure we are replacing the right
>> program (for cases where could be few bpf_link owners trying to modify
>> bpf_link, like in libxdp case). So in that sense bpf_link is a
>> coordination point, which mediates access to BPF hook (resource).
>>
>> Thoughts?
> 
> I can see how the bpf_link abstraction helps by providing a single
> abstraction for all the tracing-type attachments that are fd-based
> anyway; but I think I agree with Daniel that maybe it makes more sense
> to keep it to those? I.e., I'm not sure what bpf_link adds to XDP
> program attachment? The expected_prev_fd field to replace a program
> could just as well be provided by extending the existing netlink API?
> 
> -Toke
> 

