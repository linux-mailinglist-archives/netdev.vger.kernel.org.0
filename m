Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E550C3A8CD3
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 01:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbhFOXqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 19:46:38 -0400
Received: from www62.your-server.de ([213.133.104.62]:43280 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbhFOXqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 19:46:37 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ltIjK-0002KH-C1; Wed, 16 Jun 2021 01:44:26 +0200
Received: from [85.7.101.30] (helo=linux-3.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ltIjJ-000K4g-Vt; Wed, 16 Jun 2021 01:44:26 +0200
Subject: Re: [PATCH RFC bpf-next 0/7] Add bpf_link based TC-BPF API
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <20210528195946.2375109-1-memxor@gmail.com>
 <CAM_iQpVqVKhK+09Sj_At226mdWpVXfVbhy89As2dai7ip8Nmtw@mail.gmail.com>
 <20210607033724.wn6qn4v42dlm4j4o@apollo>
 <CAM_iQpVCnG8pSci2sMbJ1B5YE-y=reAUp82itgrguecyNBCUVQ@mail.gmail.com>
 <20210607060724.4nidap5eywb23l3d@apollo>
 <CAM_iQpWA=SXNR3Ya8_L2aoVJGP_uaRP8EYCpDrnq3y8Uf6qu=g@mail.gmail.com>
 <20210608071908.sos275adj3gunewo@apollo>
 <CAM_iQpXFmsWhMA-RO2j5Ph5Ak8yJgUVBppGj2_5NS3BuyjkvzQ@mail.gmail.com>
 <20210613025308.75uia7rnt4ue2k7q@apollo>
 <CAM_iQpW7ZAz5rLAanMRg7R52Pn55N=puVkvoHcHF618wq8uA1g@mail.gmail.com>
 <877divs5py.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <15cd0a9c-95a1-9766-fca1-4bf9d09e4100@iogearbox.net>
Date:   Wed, 16 Jun 2021 01:44:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <877divs5py.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26202/Tue Jun 15 13:21:24 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/15/21 1:54 PM, Toke Høiland-Jørgensen wrote:
> Cong Wang <xiyou.wangcong@gmail.com> writes:
[...]
>>>> I offer two different views here:
>>>>
>>>> 1. If you view a TC filter as an instance as a netdev/qdisc/action, they
>>>> are no different from this perspective. Maybe the fact that a TC filter
>>>> resides in a qdisc makes a slight difference here, but like I mentioned, it
>>>> actually makes sense to let TC filters be standalone, qdisc's just have to
>>>> bind with them, like how we bind TC filters with standalone TC actions.
>>>
>>> You propose something different below IIUC, but I explained why I'm wary of
>>> these unbound filters. They seem to add a step to classifier setup for no real
>>> benefit to the user (except keeping track of one more object and cleaning it
>>> up with the link when done).
>>
>> I am not even sure if unbound filters help your case at all, making
>> them unbound merely changes their residence, not ownership.
>> You are trying to pass the ownership from TC to bpf_link, which
>> is what I am against.
> 
> So what do you propose instead?
> 
> bpf_link is solving a specific problem: ensuring automatic cleanup of
> kernel resources held by a userspace application with a BPF component.
> Not all applications work this way, but for the ones that do it's very
> useful. But if the TC filter stays around after bpf_link detaches, that
> kinda defeats the point of the automatic cleanup.
> 
> So I don't really see any way around transferring ownership somehow.
> Unless you have some other idea that I'm missing?

Just to keep on brainstorming here, I wanted to bring back Alexei's earlier quote:

   > I think it makes sense to create these objects as part of establishing bpf_link.
   > ingress qdisc is a fake qdisc anyway.
   > If we could go back in time I would argue that its existence doesn't
   > need to be shown in iproute2. It's an object that serves no purpose
   > other than attaching filters to it. It doesn't do any queuing unlike
   > real qdiscs.
   > It's an artifact of old choices. Old doesn't mean good.
   > The kernel is full of such quirks and oddities. New api-s shouldn't
   > blindly follow them.
   > tc qdisc add dev eth0 clsact
   > is a useless command with nop effect.

The whole bpf_link in this context feels somewhat awkward because both are two
different worlds, one accessible via netlink with its own lifetime etc, the other
one tied to fds and bpf syscall. Back in the days we did the cls_bpf integration
since it felt the most natural at that time and it had support for both the ingress
and egress side, along with the direct action support which was added later to have
a proper fast path for BPF. One thing that I personally never liked is that later
on tc sadly became a complex, quirky dumping ground for all the nic hw offloads (I
guess mainly driven from ovs side) for which I have a hard time convincing myself
that this is used at scale in production. Stuff like af699626ee26 just to pick one
which annoyingly also adds to the fast path given distros will just compile in most
of these things (like NET_TC_SKB_EXT)... what if such bpf_link object is not tied
at all to cls_bpf or cls_act qdisc, and instead would implement the tcf_classify_
{egress,ingress}() as-is in that sense, similar like the bpf_lsm hooks. Meaning,
you could run existing tc BPF prog without any modifications and without additional
extra overhead (no need to walk the clsact qdisc and then again into the cls_bpf
one). These tc BPF programs would be managed only from bpf() via tc bpf_link api,
and are otherwise not bothering to classic tc command (though they could be dumped
there as well for sake of visibility, though bpftool would be fitting too). However,
if there is something attached from classic tc side, it would also go into the old
style tcf_classify_ingress() implementation and walk whatever is there so that nothing
existing breaks (same as when no bpf_link would be present so that there is no extra
overhead). This would also allow for a migration path of multi prog from cls_bpf to
this new implementation. Details still tbd, but I would much rather like such an
approach than the current discussed one, and it would also fit better given we don't
run into this current mismatch of both worlds.

Thanks,
Daniel
