Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9C25BB156
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 18:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiIPQyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 12:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiIPQyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 12:54:04 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF81419AC;
        Fri, 16 Sep 2022 09:54:01 -0700 (PDT)
Date:   Fri, 16 Sep 2022 09:53:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663347239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n4n2Nl5n36ivDDzzulJcSocyaueMbQPCwKCdGSryOBA=;
        b=Qh7ukVIG7RM4JQZ8n9VG8j81pE0NbVZzhJHb4JSHeRuv7mjQK6YWmFpBaazsx7AbjUZYQn
        jxCFNdSW8gJbrof9IJB+KlWpdMH/FQ/bWtfM/5K739UvGjQ21mFg93ADNQ4xWpTf+mSv1i
        EVp1/xldYfY34EGjzz2J7/KRzvPktZw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Tejun Heo <tj@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Cgroups <cgroups@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH bpf-next v3 00/13] bpf: Introduce selectable memcg for
 bpf map
Message-ID: <YySqFtU9skPaJipV@P9FQF9L96D.corp.robot.car>
References: <20220902023003.47124-1-laoar.shao@gmail.com>
 <Yxi8I4fXXSCi6z9T@slm.duckdns.org>
 <YxkVq4S1Eoa4edjZ@P9FQF9L96D.corp.robot.car>
 <CALOAHbAp=g20rL0taUpQmTwymanArhO-u69Xw42s5ap39Esn=A@mail.gmail.com>
 <YxoUkz05yA0ccGWe@P9FQF9L96D.corp.robot.car>
 <CALOAHbAzi0s3N_5BOkLsnGfwWCDpUksvvhPejjj5jo4G2v3mGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbAzi0s3N_5BOkLsnGfwWCDpUksvvhPejjj5jo4G2v3mGg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 13, 2022 at 02:15:20PM +0800, Yafang Shao wrote:
> On Fri, Sep 9, 2022 at 12:13 AM Roman Gushchin <roman.gushchin@linux.dev> wrote:
> >
> > On Thu, Sep 08, 2022 at 10:37:02AM +0800, Yafang Shao wrote:
> > > On Thu, Sep 8, 2022 at 6:29 AM Roman Gushchin <roman.gushchin@linux.dev> wrote:
> > > >
> > > > On Wed, Sep 07, 2022 at 05:43:31AM -1000, Tejun Heo wrote:
> > > > > Hello,
> > > > >
> > > > > On Fri, Sep 02, 2022 at 02:29:50AM +0000, Yafang Shao wrote:
> > > > > ...
> > > > > > This patchset tries to resolve the above two issues by introducing a
> > > > > > selectable memcg to limit the bpf memory. Currently we only allow to
> > > > > > select its ancestor to avoid breaking the memcg hierarchy further.
> > > > > > Possible use cases of the selectable memcg as follows,
> > > > >
> > > > > As discussed in the following thread, there are clear downsides to an
> > > > > interface which requires the users to specify the cgroups directly.
> > > > >
> > > > >  https://lkml.kernel.org/r/YwNold0GMOappUxc@slm.duckdns.org
> > > > >
> > > > > So, I don't really think this is an interface we wanna go for. I was hoping
> > > > > to hear more from memcg folks in the above thread. Maybe ping them in that
> > > > > thread and continue there?
> > > >
> > >
> > > Hi Roman,
> > >
> > > > As I said previously, I don't like it, because it's an attempt to solve a non
> > > > bpf-specific problem in a bpf-specific way.
> > > >
> > >
> > > Why do you still insist that bpf_map->memcg is not a bpf-specific
> > > issue after so many discussions?
> > > Do you charge the bpf-map's memory the same way as you charge the page
> > > caches or slabs ?
> > > No, you don't. You charge it in a bpf-specific way.
> >
> 
> Hi Roman,
> 
> Sorry for the late response.
> I've been on vacation in the past few days.
> 
> > The only difference is that we charge the cgroup of the processes who
> > created a map, not a process who is doing a specific allocation.
> 
> This means the bpf-map can be indepent of process, IOW, the memcg of
> bpf-map can be indepent of the memcg of the processes.
> This is the fundamental difference between bpf-map and page caches, then...
> 
> > Your patchset doesn't change this.
> 
> We can make this behavior reasonable by introducing an independent
> memcg, as what I did in the previous version.
> 
> > There are pros and cons with this approach, we've discussed it back
> > to the times when bpf memcg accounting was developed. If you want
> > to revisit this, it's maybe possible (given there is a really strong and likely
> > new motivation appears), but I haven't seen any complaints yet except from you.
> >
> 
> memcg-base bpf accounting is a new feature, which may not be used widely.
> 
> > >
> > > > Yes, memory cgroups are not great for accounting of shared resources, it's well
> > > > known. This patchset looks like an attempt to "fix" it specifically for bpf maps
> > > > in a particular cgroup setup. Honestly, I don't think it's worth the added
> > > > complexity. Especially because a similar behaviour can be achieved simple
> > > > by placing the task which creates the map into the desired cgroup.
> > >
> > > Are you serious ?
> > > Have you ever read the cgroup doc? Which clearly describe the "No
> > > Internal Process Constraint".[1]
> > > Obviously you can't place the task in the desired cgroup, i.e. the parent memcg.
> >
> > But you can place it into another leaf cgroup. You can delete this leaf cgroup
> > and your memcg will get reparented. You can attach this process and create
> > a bpf map to the parent cgroup before it gets child cgroups.
> 
> If the process doesn't exit after it created bpf-map, we have to
> migrate it around memcgs....
> The complexity in deployment can introduce unexpected issues easily.
> 
> > You can revisit the idea of shared bpf maps and outlive specific cgroups.
> > Lof of options.
> >
> > >
> > > [1] https://www.kernel.org/doc/Documentation/cgroup-v2.txt
> > >
> > > > Beatiful? Not. Neither is the proposed solution.
> > > >
> > >
> > > Is it really hard to admit a fault?
> >
> > Yafang, you posted several versions and so far I haven't seen much of support
> > or excitement from anyone (please, fix me if I'm wrong). It's not like I'm
> > nacking a patchset with many acks, reviews and supporters.
> >
> > Still think you're solving an important problem in a reasonable way?
> > It seems like not many are convinced yet. I'd recommend to focus on this instead
> > of blaming me.
> >
> 
> The best way so far is to introduce specific memcg for specific resources.
> Because not only the process owns its memcg, but also specific
> resources own their memcgs, for example bpf-map, or socket.
> 
> struct bpf_map {                                 <<<< memcg owner
>     struct memcg_cgroup *memcg;
> };
> 
> struct sock {                                       <<<< memcg owner
>     struct mem_cgroup *sk_memcg;
> };
> 
> These resources already have their own memcgs, so we should make this
> behavior formal.
> 
> The selectable memcg is just a variant of 'echo ${proc} > cgroup.procs'.

This is a fundamental change: cgroups were always hierarchical groups
of processes/threads. You're basically suggesting to extend it to
hierarchical groups of processes and some other objects (what's a good
definition?). It's a huge change and it's scope is definetely larger
than bpf and even memory cgroups. It will raise a lot of questions:
e.g. what does it mean for other controllers (cpu, io, etc)?
Which objects can have dedicated cgroups and which not? How the interface will
look like? How the oom handling will work? Etc.

The history showed that starting small with one controller and/or specific
use case isn't working well for cgroups, because different resources and
controllers are not living independently. So if you really want to go this way
you need to present the whole picture and convince many people that it's worth
it. I doubt this specific bpf map accounting thing can justify it.

Personally I know some examples where such functionality could be useful,
but I'm not yet convinced it's worth the effort and potential problems.

Thanks!
