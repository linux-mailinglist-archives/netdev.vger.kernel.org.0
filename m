Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18FCD5BDA46
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 04:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiITCk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 22:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiITCk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 22:40:26 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0717AE96;
        Mon, 19 Sep 2022 19:40:22 -0700 (PDT)
Date:   Mon, 19 Sep 2022 19:40:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663641620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gZS5sqyWSO3yFeBcOAHmX3+4vNuQk4vlxXsy9wXRJYQ=;
        b=L6Imu+c68+a2ysnK5RgOIzLcFHaxaChY8+VJb198+3lRmsAb5UOsa/DjbnCwCQPjk50QUL
        k/IwMVtsg1xp+9fr84CH2pyUG+j48J44igAn/mK4NwHlDVAlISWOFhV2uhvt44x5yeNFG2
        EMJe8LTS4WSVxoP8QUrdUU/s1UihOWE=
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
Message-ID: <YykoDeoqz6VYe2I4@P9FQF9L96D>
References: <20220902023003.47124-1-laoar.shao@gmail.com>
 <Yxi8I4fXXSCi6z9T@slm.duckdns.org>
 <YxkVq4S1Eoa4edjZ@P9FQF9L96D.corp.robot.car>
 <CALOAHbAp=g20rL0taUpQmTwymanArhO-u69Xw42s5ap39Esn=A@mail.gmail.com>
 <YxoUkz05yA0ccGWe@P9FQF9L96D.corp.robot.car>
 <CALOAHbAzi0s3N_5BOkLsnGfwWCDpUksvvhPejjj5jo4G2v3mGg@mail.gmail.com>
 <YySqFtU9skPaJipV@P9FQF9L96D.corp.robot.car>
 <CALOAHbAYx1=uu7AP=5Gbs6-eggXTKmkhzc-MhROezxqkbVQRiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbAYx1=uu7AP=5Gbs6-eggXTKmkhzc-MhROezxqkbVQRiQ@mail.gmail.com>
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

On Sun, Sep 18, 2022 at 11:44:48AM +0800, Yafang Shao wrote:
> On Sat, Sep 17, 2022 at 12:53 AM Roman Gushchin
> <roman.gushchin@linux.dev> wrote:
> >
> > On Tue, Sep 13, 2022 at 02:15:20PM +0800, Yafang Shao wrote:
> > > On Fri, Sep 9, 2022 at 12:13 AM Roman Gushchin <roman.gushchin@linux.dev> wrote:
> > > >
> > > > On Thu, Sep 08, 2022 at 10:37:02AM +0800, Yafang Shao wrote:
> > > > > On Thu, Sep 8, 2022 at 6:29 AM Roman Gushchin <roman.gushchin@linux.dev> wrote:
> > > > > >
> > > > > > On Wed, Sep 07, 2022 at 05:43:31AM -1000, Tejun Heo wrote:
> > > > > > > Hello,
> > > > > > >
> > > > > > > On Fri, Sep 02, 2022 at 02:29:50AM +0000, Yafang Shao wrote:
> > > > > > > ...
> > > > > > > > This patchset tries to resolve the above two issues by introducing a
> > > > > > > > selectable memcg to limit the bpf memory. Currently we only allow to
> > > > > > > > select its ancestor to avoid breaking the memcg hierarchy further.
> > > > > > > > Possible use cases of the selectable memcg as follows,
> > > > > > >
> > > > > > > As discussed in the following thread, there are clear downsides to an
> > > > > > > interface which requires the users to specify the cgroups directly.
> > > > > > >
> > > > > > >  https://lkml.kernel.org/r/YwNold0GMOappUxc@slm.duckdns.org
> > > > > > >
> > > > > > > So, I don't really think this is an interface we wanna go for. I was hoping
> > > > > > > to hear more from memcg folks in the above thread. Maybe ping them in that
> > > > > > > thread and continue there?
> > > > > >
> > > > >
> > > > > Hi Roman,
> > > > >
> > > > > > As I said previously, I don't like it, because it's an attempt to solve a non
> > > > > > bpf-specific problem in a bpf-specific way.
> > > > > >
> > > > >
> > > > > Why do you still insist that bpf_map->memcg is not a bpf-specific
> > > > > issue after so many discussions?
> > > > > Do you charge the bpf-map's memory the same way as you charge the page
> > > > > caches or slabs ?
> > > > > No, you don't. You charge it in a bpf-specific way.
> > > >
> > >
> > > Hi Roman,
> > >
> > > Sorry for the late response.
> > > I've been on vacation in the past few days.
> > >
> > > > The only difference is that we charge the cgroup of the processes who
> > > > created a map, not a process who is doing a specific allocation.
> > >
> > > This means the bpf-map can be indepent of process, IOW, the memcg of
> > > bpf-map can be indepent of the memcg of the processes.
> > > This is the fundamental difference between bpf-map and page caches, then...
> > >
> > > > Your patchset doesn't change this.
> > >
> > > We can make this behavior reasonable by introducing an independent
> > > memcg, as what I did in the previous version.
> > >
> > > > There are pros and cons with this approach, we've discussed it back
> > > > to the times when bpf memcg accounting was developed. If you want
> > > > to revisit this, it's maybe possible (given there is a really strong and likely
> > > > new motivation appears), but I haven't seen any complaints yet except from you.
> > > >
> > >
> > > memcg-base bpf accounting is a new feature, which may not be used widely.
> > >
> > > > >
> > > > > > Yes, memory cgroups are not great for accounting of shared resources, it's well
> > > > > > known. This patchset looks like an attempt to "fix" it specifically for bpf maps
> > > > > > in a particular cgroup setup. Honestly, I don't think it's worth the added
> > > > > > complexity. Especially because a similar behaviour can be achieved simple
> > > > > > by placing the task which creates the map into the desired cgroup.
> > > > >
> > > > > Are you serious ?
> > > > > Have you ever read the cgroup doc? Which clearly describe the "No
> > > > > Internal Process Constraint".[1]
> > > > > Obviously you can't place the task in the desired cgroup, i.e. the parent memcg.
> > > >
> > > > But you can place it into another leaf cgroup. You can delete this leaf cgroup
> > > > and your memcg will get reparented. You can attach this process and create
> > > > a bpf map to the parent cgroup before it gets child cgroups.
> > >
> > > If the process doesn't exit after it created bpf-map, we have to
> > > migrate it around memcgs....
> > > The complexity in deployment can introduce unexpected issues easily.
> > >
> > > > You can revisit the idea of shared bpf maps and outlive specific cgroups.
> > > > Lof of options.
> > > >
> > > > >
> > > > > [1] https://www.kernel.org/doc/Documentation/cgroup-v2.txt
> > > > >
> > > > > > Beatiful? Not. Neither is the proposed solution.
> > > > > >
> > > > >
> > > > > Is it really hard to admit a fault?
> > > >
> > > > Yafang, you posted several versions and so far I haven't seen much of support
> > > > or excitement from anyone (please, fix me if I'm wrong). It's not like I'm
> > > > nacking a patchset with many acks, reviews and supporters.
> > > >
> > > > Still think you're solving an important problem in a reasonable way?
> > > > It seems like not many are convinced yet. I'd recommend to focus on this instead
> > > > of blaming me.
> > > >
> > >
> > > The best way so far is to introduce specific memcg for specific resources.
> > > Because not only the process owns its memcg, but also specific
> > > resources own their memcgs, for example bpf-map, or socket.
> > >
> > > struct bpf_map {                                 <<<< memcg owner
> > >     struct memcg_cgroup *memcg;
> > > };
> > >
> > > struct sock {                                       <<<< memcg owner
> > >     struct mem_cgroup *sk_memcg;
> > > };
> > >
> > > These resources already have their own memcgs, so we should make this
> > > behavior formal.
> > >
> > > The selectable memcg is just a variant of 'echo ${proc} > cgroup.procs'.
> >
> > This is a fundamental change: cgroups were always hierarchical groups
> > of processes/threads. You're basically suggesting to extend it to
> > hierarchical groups of processes and some other objects (what's a good
> > definition?).
> 
> Kind of, but not exactly.
> We can do it without breaking the cgroup hierarchy. Under current
> cgroup hierarchy, the user can only echo processes/threads into a
> cgroup, that won't be changed in the future. The specific resources
> are not exposed to the user, the user can only control these specific
> resources by controlling their associated processes/threads.
> For example,
> 
>                 Memcg-A
>                        |---- Memcg-A1
>                        |---- Memcg-A2
> 
> We can introduce a new file memory.owner into each memcg. Each bit of
> memory.owner represents a specific resources,
> 
>  memory.owner: | bit31 | bitN | ... | bit1 | bit0 |
>                                          |               |
> |------ bit0: bpf memory
>                                          |
> |-------------- bit1: socket memory
>                                          |
>                                          |---------------------------
> bitN: a specific resource
> 
> There won't be too many specific resources which have to own their
> memcgs, so I think 32bits is enough.
> 
>                 Memcg-A : memory.owner == 0x1
>                        |---- Memcg-A1 : memory.owner == 0
>                        |---- Memcg-A2 : memory.owner == 0x1
> 
> Then the bpf created by processes in Memcg-A1 will be charged into
> Memcg-A directly without charging into Memcg-A1.
> But the bpf created by processes in Memcg-A2 will be charged into
> Memcg-A2 as its memory.owner is 0x1.
> That said, these specific resources are not fully independent of
> process, while they are still associated with the processes which
> create them.
> Luckily memory.move_charge_at_immigrate is disabled in cgroup2, so we
> don't need to care about the possible migration issue.
> 
> I think we may also apply it to shared page caches.  For example,
>       struct inode {
>           struct mem_cgroup *memcg;          <<<< add a new member
>       };
> 
> We define struct inode as a memcg owner, and use scope-based charge to
> charge its pages into inode->memcg.
> And then put all memcgs which shared these resources under the same
> parent. The page caches of this inode will be charged into the parent
> directly.

Ok, so it's something like premature selective reparenting.

> The shared page cache is more complicated than bpf memory, so I'm not
> quite sure if it can apply to shared page cache, but it can work well
> for bpf memory.

Yeah, this is the problem. It feels like it's a problem very specific
to bpf maps and an exact way you use them. I don't think you can successfully
advocate for changes of these calibre without a more generic problem. I might
be wrong.

> 
> Regarding the observability, we can introduce a specific item into
> memory.stat for this specific memory. For example a new item 'bpf' for
> bpf memory.
> That can be accounted/unaccounted for in the same way as we do in
> set_active_memcg(). for example,
> 
>     struct task_struct {
>         struct mem_cgroup  *active_memcg;
>         int                             active_memcg_item;   <<<<
> introduce a new member
>     };
> 
>     bpf_memory_alloc()
>     {
>              old_memcg = set_active_memcg(memcg);
>              old_item = set_active_memcg_item(MEMCG_BPF);

I thought about something like this but for a different purpose:
to track the amount of memory consumed by bpf.

>              alloc();
>              set_active_memcg_item(old_item);
>              set_active_memcg(old_memcg);
>     }
> 
>     bpf_memory_free()
>     {
>              old = set_active_memcg_item(MEMCG_BPF);
>              free();
>              set_active_memcg_item(old);
>     }

But the problem is that we shoud very carefully mark all allocations and
releases, which is very error-prone. Interfaces which don't require annotating
releases are generally better, but require additional memory.

Thanks!
