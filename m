Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F1C5B2350
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 18:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbiIHQOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 12:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbiIHQOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 12:14:08 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B98CE9013;
        Thu,  8 Sep 2022 09:13:38 -0700 (PDT)
Date:   Thu, 8 Sep 2022 09:13:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662653615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XFgnxoiMa/OYh81zS7O/8tqwdekKzHoWthmdHPgMZK8=;
        b=lYtwB4ezHv8drbW5ICWe9wsFxRHHKSt63b6pqQ7+h/lyVpPvBSnR5nQhmhy7dem/p8sNgh
        Brue/zCx0KrHlawTBZyOG77bX3NhlcBkbrwe9frXiG4tVdwbG5t0mRkmaNiYxmP+/HhAeI
        lnJMdts3Xwvzy69wuOflohBjbNm3FSI=
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
        Hao Luo <haoluo@google.com>, jolsa@kernel.org,
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
Message-ID: <YxoUkz05yA0ccGWe@P9FQF9L96D.corp.robot.car>
References: <20220902023003.47124-1-laoar.shao@gmail.com>
 <Yxi8I4fXXSCi6z9T@slm.duckdns.org>
 <YxkVq4S1Eoa4edjZ@P9FQF9L96D.corp.robot.car>
 <CALOAHbAp=g20rL0taUpQmTwymanArhO-u69Xw42s5ap39Esn=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbAp=g20rL0taUpQmTwymanArhO-u69Xw42s5ap39Esn=A@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 08, 2022 at 10:37:02AM +0800, Yafang Shao wrote:
> On Thu, Sep 8, 2022 at 6:29 AM Roman Gushchin <roman.gushchin@linux.dev> wrote:
> >
> > On Wed, Sep 07, 2022 at 05:43:31AM -1000, Tejun Heo wrote:
> > > Hello,
> > >
> > > On Fri, Sep 02, 2022 at 02:29:50AM +0000, Yafang Shao wrote:
> > > ...
> > > > This patchset tries to resolve the above two issues by introducing a
> > > > selectable memcg to limit the bpf memory. Currently we only allow to
> > > > select its ancestor to avoid breaking the memcg hierarchy further.
> > > > Possible use cases of the selectable memcg as follows,
> > >
> > > As discussed in the following thread, there are clear downsides to an
> > > interface which requires the users to specify the cgroups directly.
> > >
> > >  https://lkml.kernel.org/r/YwNold0GMOappUxc@slm.duckdns.org
> > >
> > > So, I don't really think this is an interface we wanna go for. I was hoping
> > > to hear more from memcg folks in the above thread. Maybe ping them in that
> > > thread and continue there?
> >
> 
> Hi Roman,
> 
> > As I said previously, I don't like it, because it's an attempt to solve a non
> > bpf-specific problem in a bpf-specific way.
> >
> 
> Why do you still insist that bpf_map->memcg is not a bpf-specific
> issue after so many discussions?
> Do you charge the bpf-map's memory the same way as you charge the page
> caches or slabs ?
> No, you don't. You charge it in a bpf-specific way.

The only difference is that we charge the cgroup of the processes who
created a map, not a process who is doing a specific allocation.
Your patchset doesn't change this.
There are pros and cons with this approach, we've discussed it back
to the times when bpf memcg accounting was developed. If you want
to revisit this, it's maybe possible (given there is a really strong and likely
new motivation appears), but I haven't seen any complaints yet except from you.

> 
> > Yes, memory cgroups are not great for accounting of shared resources, it's well
> > known. This patchset looks like an attempt to "fix" it specifically for bpf maps
> > in a particular cgroup setup. Honestly, I don't think it's worth the added
> > complexity. Especially because a similar behaviour can be achieved simple
> > by placing the task which creates the map into the desired cgroup.
> 
> Are you serious ?
> Have you ever read the cgroup doc? Which clearly describe the "No
> Internal Process Constraint".[1]
> Obviously you can't place the task in the desired cgroup, i.e. the parent memcg.

But you can place it into another leaf cgroup. You can delete this leaf cgroup
and your memcg will get reparented. You can attach this process and create
a bpf map to the parent cgroup before it gets child cgroups.
You can revisit the idea of shared bpf maps and outlive specific cgroups.
Lof of options.

> 
> [1] https://www.kernel.org/doc/Documentation/cgroup-v2.txt
> 
> > Beatiful? Not. Neither is the proposed solution.
> >
> 
> Is it really hard to admit a fault?

Yafang, you posted several versions and so far I haven't seen much of support
or excitement from anyone (please, fix me if I'm wrong). It's not like I'm
nacking a patchset with many acks, reviews and supporters.

Still think you're solving an important problem in a reasonable way?
It seems like not many are convinced yet. I'd recommend to focus on this instead
of blaming me.

Thanks!
