Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F804D3D9F
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 00:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237096AbiCIXgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 18:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbiCIXgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 18:36:16 -0500
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7CDF25587;
        Wed,  9 Mar 2022 15:35:14 -0800 (PST)
Date:   Wed, 9 Mar 2022 15:35:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1646868912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O7iTHpYee//brbEtp3qf01UPCswchCFPmHWyZ1ZEOfI=;
        b=qo3XdARBAgNhQZL4WjTBIrJC6ctCL5lpMOT86YKNYA8Dah5xpn2IZwjKgW3NaSa/xhRdRW
        8CaIlmQX22F+coo+VUv9EY39hytXPG0YlXhPaHCwiIcpIKViBlZc/vSG7/inZcnAjCuOud
        DbsCp6EZGag5awyPdfAeCOsC3Er1uQs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, penberg@kernel.org,
        David Rientjes <rientjes@google.com>, iamjoonsoo.kim@lge.com,
        Vlastimil Babka <vbabka@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Roman Gushchin <guro@fb.com>, Linux MM <linux-mm@kvack.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH RFC 0/9] bpf, mm: recharge bpf memory from offline memcg
Message-ID: <Yik5qSryIPk70iVz@carbon.dhcp.thefacebook.com>
References: <20220308131056.6732-1-laoar.shao@gmail.com>
 <Yif+QZbCALQcYrFZ@carbon.dhcp.thefacebook.com>
 <CALOAHbARWARjK4cAjUfsGDy3G4sAZaHRiFQsbjNc=EfHsCfnnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbARWARjK4cAjUfsGDy3G4sAZaHRiFQsbjNc=EfHsCfnnQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 09, 2022 at 09:28:58PM +0800, Yafang Shao wrote:
> On Wed, Mar 9, 2022 at 9:09 AM Roman Gushchin <roman.gushchin@linux.dev> wrote:
> >
> > On Tue, Mar 08, 2022 at 01:10:47PM +0000, Yafang Shao wrote:
> > > When we use memcg to limit the containers which load bpf progs and maps,
> > > we find there is an issue that the lifecycle of container and bpf are not
> > > always the same, because we may pin the maps and progs while update the
> > > container only. So once the container which has alreay pinned progs and
> > > maps is restarted, the pinned progs and maps are no longer charged to it
> > > any more. In other words, this kind of container can steal memory from the
> > > host, that is not expected by us. This patchset means to resolve this
> > > issue.
> > >
> > > After the container is restarted, the old memcg which is charged by the
> > > pinned progs and maps will be offline but won't be freed until all of the
> > > related maps and progs are freed. If we want to charge these bpf memory to
> > > the new started memcg, we should uncharge them from the offline memcg first
> > > and then charge it to the new one. As we have already known how the bpf
> > > memroy is allocated and freed, we can also know how to charge and uncharge
> > > it. This pathset implements various charge and uncharge methords for these
> > > memory.
> > >
> > > Regarding how to do the recharge, we decide to implement new bpf syscalls
> > > to do it. With the new implemented bpf syscall, the agent running in the
> > > container can use it to do the recharge. As of now we only implement it for
> > > the bpf hash maps. Below is a simple example how to do the recharge,
> > >
> > > ====
> > > int main(int argc, char *argv[])
> > > {
> > >       union bpf_attr attr = {};
> > >       int map_id;
> > >       int pfd;
> > >
> > >       if (argc < 2) {
> > >               printf("Pls. give a map id \n");
> > >               exit(-1);
> > >       }
> > >
> > >       map_id = atoi(argv[1]);
> > >       attr.map_id = map_id;
> > >       pfd = syscall(SYS_bpf, BPF_MAP_RECHARGE, &attr, sizeof(attr));
> > >       if (pfd < 0)
> > >               perror("BPF_MAP_RECHARGE");
> > >
> > >       return 0;
> > > }
> > >
> > > ====
> > >
> > > Patch #1 and #2 is for the observability, with which we can easily check
> > > whether the bpf maps is charged to a memcg and whether the memcg is offline.
> > > Patch #3, #4 and #5 is for the charge and uncharge methord for vmalloc-ed,
> > > kmalloc-ed and percpu memory.
> > > Patch #6~#9 implements the recharge of bpf hash map, which is mostly used
> > > by our bpf services. The other maps hasn't been implemented yet. The bpf progs
> > > hasn't been implemented neither.
> > >
> > > This pathset is still a POC now, with limited testing. Any feedback is
> > > welcomed.
> >
> > Hello Yafang!
> >
> > It's an interesting topic, which goes well beyond bpf. In general, on cgroup
> > offlining we either do nothing either recharge pages to the parent cgroup
> > (latter is preferred), which helps to release the pinned memcg structure.
> >
> 
> We have thought about recharging pages to the parent cgroup (the root
> memcg in our case),
> but it can't resolve our issue.
> Releasing the pinned memcg struct is the benefit of recharging pages
> to the parent,
> but as there won't be too many memcgs pinned by bpf, so it may not be worth it.

I agree, that was my thinking too.

> 
> 
> > Your approach raises some questions:
> 
> Nice questions.
> 
> > 1) what if the new cgroup is not large enough to contain the bpf map?
> 
> The recharge is supposed to be triggered at the container start time.
> After the container is started, the agent which will load the bpf
> programs will do it as follows,
> 1. Check if the bpf program has already been loaded,
>     if not,  goto 5.
> 2. Check if the bpf program will pin maps or progs,
>     if not, goto 6.
> 3. Check if the pinned maps and progs are charged to an offline memcg,
>     if not, goto 6.
> 4. Recharge the pinned maps or progs to the current memcg.
>    goto 6.
> 5. load new bpf program, and also pinned maps and progs if desired.
> 6. End.
> 
> If the recharge fails, it means that the memcg limit is too low, we
> should reconsider
> the limit of the container.
> 
> Regarding other cases that it may do the recharge in the runtime, I
> think the failure is
> a common OOM case, that means the usage in this container is out of memory, we
> should kill something.

The problem here is that even invoking the oom killer might not help here,
if the size of the bpf map is larger than memory.max.

Also because recharging of a large object might take time and it's happening
simultaneously with other processes in the system (e.g. memory allocations,
cgroup limit changes, etc), potentially we might end up in the situation
when the new cgroup is not large enough to include the transferred object,
but also the original cgroup is not large enough (due to the limit set on one
of it's ancestors), so we'll need to break memory.max of either cgroup,
which is not great. We might solve this by pre-charging of target cgroup
and keeping the double-charge during the process, but it might not work
well for really large objects on small machines. Another approach is to transfer
in small chunks (e.g. pages), but then we might end with a partially transferred
object, which is also a questionable result.

<...>

> > Will reparenting work for your case? If not, can you, please, describe the
> > problem you're trying to solve by recharging the memory?
> >
> 
> Reparenting doesn't work for us.
> The problem is memory resource control: the limitation on the bpf
> containers will be useless
> if the lifecycle of bpf progs can containers are not the same.
> The containers are always upgraded - IOW restarted - more frequently
> than the bpf progs and maps,
> that is also one of the reasons why we choose to pin them on the host.

In general, I think I understand why this feature is useful for your case,
however I do have some serious concerns about adding such feature to
the upstream kernel:
1) The interface and the proposed feature is bpf-specific, however the problem
isn't. The same issue (an under reported memory consumption) can be caused by
other types of memory: pagecache, various kernel objects e.g. vfs cache etc.
If we introduce such a feature, we'd better be consistent across various
types of objects (how it's a good question).
2) Moving charges is proven to be tricky and cause various problems in the past.
If we're going back into this direction, we should come up with a really solid
plan for how to avoid past issues.
3) It would be great to understand who and how will use this feature in a more
generic environment. E.g. is it useful for systemd? Is it common to use bpf maps
over multiple cgroups? What for (given that these are not system-wide programs,
otherwise why would we charge their memory to some specific container)?

Btw, aren't you able to run a new container in the same cgroup? Or associate
the bpf map with the persistent parent cgroup?

Thanks!
