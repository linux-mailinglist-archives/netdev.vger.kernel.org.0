Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B93A4D2FEB
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 14:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbiCINaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 08:30:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbiCINaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 08:30:35 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCEF6175817;
        Wed,  9 Mar 2022 05:29:35 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id p2so1469232ile.2;
        Wed, 09 Mar 2022 05:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+Ie3g071ONGf67RV/Jbx4FIY700bvMZXq2+ZmsEi+AI=;
        b=QIUfIU5qzXULTpfA1D74Pw/xIK0NPaopdTDk8k2ygZTjo1n2jfbhz0/iuGe6x1Oa7F
         xxbP5v3KNuVHO0k8x0S9369AYAQIgFi7cCeznz4Gf0erFdfjCSDu8MI9Kwf/cQzqebXR
         AHg8yinGUbusdz/Kb18I8Bn76YNjPMo5ILsYvYgY+zZbRfAJsO4p1A6MIgPWiQfWU3+8
         /4TDpzoRd1+DXBKqrevTrJwbPRELTp+gNHa3WItasD8SXMvN2xnf4eKWWuo60DY/93bZ
         6LDjkDzjeqByU7zI7xMpO64/iKqZ4lsxktrvmKKinv4axpudjJRz8TlDaiL+KiJHR8aA
         W7Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+Ie3g071ONGf67RV/Jbx4FIY700bvMZXq2+ZmsEi+AI=;
        b=5TA2yFsOSwWAMat6cioyLC+4lvfN4NFOPUkBBaFkLthB1mTwX9Cr7I9wfqVRojm1DR
         cOiFVYMcRGIVX1IvLO+mg+4uwost1MHr0W1S0RCzk2tapnXVkj+AwEe2/+R6yIUUe02v
         f1KxAWaeXy7pbwmoe/WUBT8MeoY5YlDsIoS6tRns99EHWrz+GenoV+4siwMGxbnhaM46
         NfTdcaTwxIoT6Tq/KxkNzMQTp2WzBqfCtt0EcBi1pRyNhm8dfKyi97Rdmu+IlS2DnLC8
         M5u1mpHAmdQl469cHnz8/GhLbG9MhIibZbGrL1zvmpZ+I0CfN6U533bGyuRyZNPmwl1s
         IhVw==
X-Gm-Message-State: AOAM530S7ChC5paoW4pzBZE/z2DGa7E+DvxaluOZZK/J3BsoKJXA6zld
        BSZ+8vCi8bgT/Jv3p5DHf5W9H9I2ZGQINYPlf0iNUgmLWNk=
X-Google-Smtp-Source: ABdhPJzglI42fOllC5NUHdfXe8Gktl5ckVAcIjBAlwX/mY0PeB/ZjpzCY2ytg3QT5IHiwb9tRiiQNj7NVCEqRqX5CMA=
X-Received: by 2002:a92:7c13:0:b0:2c6:610f:82f0 with SMTP id
 x19-20020a927c13000000b002c6610f82f0mr5740790ilc.6.1646832575111; Wed, 09 Mar
 2022 05:29:35 -0800 (PST)
MIME-Version: 1.0
References: <20220308131056.6732-1-laoar.shao@gmail.com> <Yif+QZbCALQcYrFZ@carbon.dhcp.thefacebook.com>
In-Reply-To: <Yif+QZbCALQcYrFZ@carbon.dhcp.thefacebook.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Wed, 9 Mar 2022 21:28:58 +0800
Message-ID: <CALOAHbARWARjK4cAjUfsGDy3G4sAZaHRiFQsbjNc=EfHsCfnnQ@mail.gmail.com>
Subject: Re: [PATCH RFC 0/9] bpf, mm: recharge bpf memory from offline memcg
To:     Roman Gushchin <roman.gushchin@linux.dev>
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 9, 2022 at 9:09 AM Roman Gushchin <roman.gushchin@linux.dev> wrote:
>
> On Tue, Mar 08, 2022 at 01:10:47PM +0000, Yafang Shao wrote:
> > When we use memcg to limit the containers which load bpf progs and maps,
> > we find there is an issue that the lifecycle of container and bpf are not
> > always the same, because we may pin the maps and progs while update the
> > container only. So once the container which has alreay pinned progs and
> > maps is restarted, the pinned progs and maps are no longer charged to it
> > any more. In other words, this kind of container can steal memory from the
> > host, that is not expected by us. This patchset means to resolve this
> > issue.
> >
> > After the container is restarted, the old memcg which is charged by the
> > pinned progs and maps will be offline but won't be freed until all of the
> > related maps and progs are freed. If we want to charge these bpf memory to
> > the new started memcg, we should uncharge them from the offline memcg first
> > and then charge it to the new one. As we have already known how the bpf
> > memroy is allocated and freed, we can also know how to charge and uncharge
> > it. This pathset implements various charge and uncharge methords for these
> > memory.
> >
> > Regarding how to do the recharge, we decide to implement new bpf syscalls
> > to do it. With the new implemented bpf syscall, the agent running in the
> > container can use it to do the recharge. As of now we only implement it for
> > the bpf hash maps. Below is a simple example how to do the recharge,
> >
> > ====
> > int main(int argc, char *argv[])
> > {
> >       union bpf_attr attr = {};
> >       int map_id;
> >       int pfd;
> >
> >       if (argc < 2) {
> >               printf("Pls. give a map id \n");
> >               exit(-1);
> >       }
> >
> >       map_id = atoi(argv[1]);
> >       attr.map_id = map_id;
> >       pfd = syscall(SYS_bpf, BPF_MAP_RECHARGE, &attr, sizeof(attr));
> >       if (pfd < 0)
> >               perror("BPF_MAP_RECHARGE");
> >
> >       return 0;
> > }
> >
> > ====
> >
> > Patch #1 and #2 is for the observability, with which we can easily check
> > whether the bpf maps is charged to a memcg and whether the memcg is offline.
> > Patch #3, #4 and #5 is for the charge and uncharge methord for vmalloc-ed,
> > kmalloc-ed and percpu memory.
> > Patch #6~#9 implements the recharge of bpf hash map, which is mostly used
> > by our bpf services. The other maps hasn't been implemented yet. The bpf progs
> > hasn't been implemented neither.
> >
> > This pathset is still a POC now, with limited testing. Any feedback is
> > welcomed.
>
> Hello Yafang!
>
> It's an interesting topic, which goes well beyond bpf. In general, on cgroup
> offlining we either do nothing either recharge pages to the parent cgroup
> (latter is preferred), which helps to release the pinned memcg structure.
>

We have thought about recharging pages to the parent cgroup (the root
memcg in our case),
but it can't resolve our issue.
Releasing the pinned memcg struct is the benefit of recharging pages
to the parent,
but as there won't be too many memcgs pinned by bpf, so it may not be worth it.


> Your approach raises some questions:

Nice questions.

> 1) what if the new cgroup is not large enough to contain the bpf map?

The recharge is supposed to be triggered at the container start time.
After the container is started, the agent which will load the bpf
programs will do it as follows,
1. Check if the bpf program has already been loaded,
    if not,  goto 5.
2. Check if the bpf program will pin maps or progs,
    if not, goto 6.
3. Check if the pinned maps and progs are charged to an offline memcg,
    if not, goto 6.
4. Recharge the pinned maps or progs to the current memcg.
   goto 6.
5. load new bpf program, and also pinned maps and progs if desired.
6. End.

If the recharge fails, it means that the memcg limit is too low, we
should reconsider
the limit of the container.

Regarding other cases that it may do the recharge in the runtime, I
think the failure is
a common OOM case, that means the usage in this container is out of memory, we
should kill something.


> 2) does it mean that some userspace app will monitor the state of the cgroup
> which was the original owner of the bpf map and recharge once it's deleted?

In our use case,  we don't need to monitor that behavior.
The agent which loads the bpf programs has the responsibility to do
the recharge.
As all the agents are controlled by ourselves, it is easy to do it like that.

For more generic use cases, it can do the bpf maintenance in a sidecar container
in the containerized environment.  The admin can provide such sidercar
to bpf owners.
The admin can also introduce an agent on the host to check if there're
maps or progs
charged to an offline memcg and then take the action. It is not easy
to find which one owns
the pinned maps or progs as the pinned path is unique.

> 3) what if there are several cgroups are sharing the same map? who will be
> the next owner?

I think we can follow the same rule that we take care of sharing pages
across memcgs
currently: who loads it first, who owns the map. Then after the first
one exit, the next owner
is who firstly does the recharge.

> 4) because recharging is fully voluntary, why any application should want to do
> it, if it can just use the memory for free? it doesn't really look as a working
> resource control mechanism.
>

As I explained in 2), all the agents are under our control, so we can
easily handle it like that.
For generic use cases, an agent running on the host and sidecar (or
SDK) provided
to bpf users can also handle it.

> Will reparenting work for your case? If not, can you, please, describe the
> problem you're trying to solve by recharging the memory?
>

Reparenting doesn't work for us.
The problem is memory resource control: the limitation on the bpf
containers will be useless
if the lifecycle of bpf progs can containers are not the same.
The containers are always upgraded - IOW restarted - more frequently
than the bpf progs and maps,
that is also one of the reasons why we choose to pin them on the host.

-- 
Thanks
Yafang
