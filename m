Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B69514E4680
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 20:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbiCVTLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 15:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbiCVTLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 15:11:40 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1563664716;
        Tue, 22 Mar 2022 12:10:10 -0700 (PDT)
Date:   Tue, 22 Mar 2022 12:10:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1647976208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vXE6TzaCfyY4su+93YVQaZWrgnt287+DKYzpx1gYF/M=;
        b=eQjjovZYd4ajm2z4iw7sr5TTqwxTKH2HkI5ejyFpzKgFRe03hzSrTjQFxkphqDrKINmyNk
        6egroVVoQowujRuVLCj1RlXjgVCXJeduBv1293lS+CaeEnXf9Vm2BaWI2QWwIkKzYZRhTl
        tbRJCgkbpLHHppkW2e89Q0A0XVE/3tw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, shuah@kernel.org,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 00/14] bpf: Allow not to charge bpf memory
Message-ID: <YjofCAq3chsgVv2n@carbon.dhcp.thefacebook.com>
References: <20220319173036.23352-1-laoar.shao@gmail.com>
 <YjkBkIHde+fWHw9K@carbon.dhcp.thefacebook.com>
 <CALOAHbBaRnF4g0uFdYMMJfAimfK+oQDhgshuohrLdQiKVShP+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbBaRnF4g0uFdYMMJfAimfK+oQDhgshuohrLdQiKVShP+A@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 23, 2022 at 12:10:34AM +0800, Yafang Shao wrote:
> On Tue, Mar 22, 2022 at 6:52 AM Roman Gushchin <roman.gushchin@linux.dev> wrote:
> >
> > Hello, Yafang!
> >
> > Thank you for continuing working on this!
> >
> > On Sat, Mar 19, 2022 at 05:30:22PM +0000, Yafang Shao wrote:
> > > After switching to memcg-based bpf memory accounting, the bpf memory is
> > > charged to the loader's memcg by defaut, that causes unexpected issues for
> > > us. For instance, the container of the loader-which loads the bpf programs
> > > and pins them on bpffs-may restart after pinning the progs and maps. After
> > > the restart, the pinned progs and maps won't belong to the new container
> > > any more, while they actually belong to an offline memcg left by the
> > > previous generation. That inconsistent behavior will make trouble for the
> > > memory resource management for this container.
> >
> > I'm looking at this text and increasingly feeling that it's not a bpf-specific
> > problem and it shouldn't be solved as one.
> >
> 
> I'm not sure whether it is a common issue or not, but I'm sure bpf has
> its special attribute that we should handle it specifically.  I can
> show you an example on why bpf is a special one.
> 
> The pinned bpf is similar to a kernel module, right?
> But that issue can't happen in a kernel module, while it can happen in
> bpf only.  The reason is that the kernel module has the choice on
> whether account the allocated memory or not, e.g.
>     - Account
>       kmalloc(size,  GFP_KERNEL | __GFP_ACCOUNT);
>    - Not Account
>       kmalloc(size, GFP_KERNEL);
> 
> While the bpf has no choice because the GFP_KERNEL is a KAPI which is
> not exposed to the user.

But if your process opens a file, creates a pipe etc there are also
kernel allocations happening and the process has no control over whether
these allocations are accounted or not. The same applies for the anonymous
memory and pagecache as well, so it's not even kmem-specific.

> 
> Then the issue is exposed when the memcg-based accounting is
> forcefully enabled to all bpf programs. That is a behavior change,
> while unfortunately we don't give the user a chance to keep the old
> behavior unless they don't use memcg....
> 
> But that is not to say the memcg-based accounting is bad, while it is
> really useful, but it needs to be improved. We can't expose
> GFP_ACCOUNT to the user, but we can expose a wrapper of GFP_ACCOUNT to
> the user, that's what this patchset did, like what we always have done
> in bpf.
> 
> > Is there any significant reason why the loader can't temporarily enter the
> > root cgroup before creating bpf maps/progs? I know it will require some changes
> > in the userspace code, but so do new bpf flags.
> >
> 
> On our k8s environment, the user agents should be deployed in a
> Daemonset[1].  It will make more trouble to temporarily enter the root
> group before creating bpf maps/progs, for example we must change the
> way we used to deploy user agents, that will be a big project.

I understand, however introducing new kernel interfaces to overcome such
things has its own downside: every introduced interface will stay pretty
much forever and we'll _have_ to support it. Kernel interfaces have a very long
life cycle, we have to admit it.

The problem you're describing - inconsistencies on accounting of shared regions
of memory - is a generic cgroup problem, which has a configuration solution:
the resource accounting and control should be performed on a stable level and
actual workloads can be (re)started in sub-cgroups with optionally disabled
physical controllers.
E.g.:
			/
	workload2.slice   workload1.slice     <- accounting should be performed here
workload_gen1.scope workload_gen2.scope ...


> 
> [1]. https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/
> 
> > >
> > > The reason why these progs and maps have to be persistent across multiple
> > > generations is that these progs and maps are also used by other processes
> > > which are not in this container. IOW, they can't be removed when this
> > > container is restarted. Take a specific example, bpf program for clsact
> > > qdisc is loaded by a agent running in a container, which not only loads
> > > bpf program but also processes the data generated by this program and do
> > > some other maintainace things.
> > >
> > > In order to keep the charging behavior consistent, we used to consider a
> > > way to recharge these pinned maps and progs again after the container is
> > > restarted, but after the discussion[1] with Roman, we decided to go
> > > another direction that don't charge them to the container in the first
> > > place. TL;DR about the mentioned disccussion: recharging is not a generic
> > > solution and it may take too much risk.
> > >
> > > This patchset is the solution of no charge. Two flags are introduced in
> > > union bpf_attr, one for bpf map and another for bpf prog. The user who
> > > doesn't want to charge to current memcg can use these two flags. These two
> > > flags are only permitted for sys admin as these memory will be accounted to
> > > the root memcg only.
> >
> > If we're going with bpf-specific flags (which I'd prefer not to), let's
> > define them as the way to create system-wide bpf objects which are expected
> > to outlive the original cgroup. With expectations that they will be treated
> > as belonging to the root cgroup by any sort of existing or future resource
> > accounting (e.g. if we'll start accounting CPU used by bpf prgrams).
> >
> 
> Now that talking about the cpu resource, I have some more complaints
> that cpu cgroup does really better than memory cgroup. Below is the
> detailed information why cpu cgroup does a good job,
> 
>    - CPU
>                         Task Cgroup
>       Code          CPU time is accounted to the one who is executeING
>  this code
> 
>    - Memory
>                          Memory Cgroup
>       Data           Memory usage is accounted to the one who
> allocatED this data.
> 
> Have you found the difference?

Well, RAM is a vastly different thing than CPU :)
They have different physical properties and corresponding accounting limitations.

> The difference is that, cpu time is accounted to the one who is using
> it (that is reasonable), while memory usage is accounted to the one
> who allocated it (that is unreasonable). If we split the Data/Code
> into private and shared, we can find why it is unreasonable.
> 
>                                 Memory Cgroup
> Private Data           Private and thus accounted to one single memcg, good.
> Shared Data           Shared but accounted to one single memcg, bad.
> 
>                                 Task Cgroup
> Private Code          Private and thus accounted to one single task group, good.
> Shared Code          Shared and thus accounted to all the task groups, good.
> 
> The pages are accounted when they are allocated rather than when they
> are used, that is why so many ridiculous things happen.   But we have
> a common sense that we can’t dynamically charge the page to the
> process who is accessing it, right?  So we have to handle the issues
> caused by shared pages case by case.

The accounting of shared regions of memory is complex because of two
physical limitations:

1) Amount of (meta)data which we can be used to track ownership. We expect
the memory overhead be small in comparison to the accounted data. If a page
is used by many cgroups, even saving a single pointer to each cgroup can take
a lot of space. Even worse for slab objects. At some point it stops making
sense: if the accounting takes more memory than the accounted memory, it's
better to not account at all.

2) CPU overhead: tracking memory usage beyond the initial allocation adds
an overhead to some very hot paths. Imagine two processes mapping the same file,
first processes faults in the whole file and the second just uses the pagecache.
Currently it's very efficient. Causing the second process to change the ownership
information on each minor page fault will lead to a performance regression.
Think of libc binary as this file.

That said, I'm not saying it can't be done better that now. But it's a complex
problem.

Thanks!
