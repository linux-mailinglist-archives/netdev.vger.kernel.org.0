Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB87F59CF15
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 05:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239827AbiHWDDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 23:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239823AbiHWDC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 23:02:28 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4145E5D0DB;
        Mon, 22 Aug 2022 20:01:53 -0700 (PDT)
Date:   Mon, 22 Aug 2022 20:01:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661223711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Dv94wdcOO0xhOXBTXmDpJmi7ih1YwEJglayhdPRmD3k=;
        b=Q/s0dQ+GuuAtGebBkJtXV90obc+1Z2wPGeW1NDPwJ7o/ZeFkub5Hgp4xeS/eR5MTQnxkHC
        9wZfI6JWVaySsx55Vt2v0Jqil9tD47K9d1QDkDgJ4Z2P5ahCSvPDf892RPulMt4lRMFWv2
        d4hF54n1m03uq1he43PTBbtWh54SEtQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     Johannes Weiner <hannes@cmpxchg.org>
Cc:     Mina Almasry <almasrymina@google.com>, Tejun Heo <tj@kernel.org>,
        Yafang Shao <laoar.shao@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, jolsa@kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Cgroups <cgroups@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Yosry Ahmed <yosryahmed@google.com>,
        Dan Schatzberg <schatzberg.dan@gmail.com>,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: [RFD RESEND] cgroup: Persistent memory usage tracking
Message-ID: <YwRDFe+K837tKGED@P9FQF9L96D>
References: <20220818143118.17733-1-laoar.shao@gmail.com>
 <Yv67MRQLPreR9GU5@slm.duckdns.org>
 <Yv6+HlEzpNy8y5kT@slm.duckdns.org>
 <CALOAHbDcrj1ifFsNMHBEih5-SXY2rWViig4rQHi9N07JY6CjXA@mail.gmail.com>
 <Yv/DK+AGlMeBGkF1@slm.duckdns.org>
 <CALOAHbCvUxQn5Zkp2FJ+eL1VgjeRSq1xQhzdiY87C1Cbib-nig@mail.gmail.com>
 <YwNold0GMOappUxc@slm.duckdns.org>
 <CAHS8izNvEpX3Lv7eFn-vu=4ZT96Djk2dU-VU+zOueZaZZbnWNw@mail.gmail.com>
 <YwPy9hervVxfuuYE@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwPy9hervVxfuuYE@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 05:19:50PM -0400, Johannes Weiner wrote:
> On Mon, Aug 22, 2022 at 12:02:48PM -0700, Mina Almasry wrote:
> > On Mon, Aug 22, 2022 at 4:29 AM Tejun Heo <tj@kernel.org> wrote:
> > > b. Let userspace specify which cgroup to charge for some of constructs like
> > >    tmpfs and bpf maps. The key problems with this approach are
> > >
> > >    1. How to grant/deny what can be charged where. We must ensure that a
> > >       descendant can't move charges up or across the tree without the
> > >       ancestors allowing it.
> > >
> > >    2. How to specify the cgroup to charge. While specifying the target
> > >       cgroup directly might seem like an obvious solution, it has a couple
> > >       rather serious problems. First, if the descendant is inside a cgroup
> > >       namespace, it might be able to see the target cgroup at all. Second,
> > >       it's an interface which is likely to cause misunderstandings on how it
> > >       can be used. It's too broad an interface.
> > >
> > 
> > This is pretty much the solution I sent out for review about a year
> > ago and yes, it suffers from the issues you've brought up:
> > https://lore.kernel.org/linux-mm/20211120045011.3074840-1-almasrymina@google.com/
> > 
> > 
> > >    One solution that I can think of is leveraging the resource domain
> > >    concept which is currently only used for threaded cgroups. All memory
> > >    usages of threaded cgroups are charged to their resource domain cgroup
> > >    which hosts the processes for those threads. The persistent usages have a
> > >    similar pattern, so maybe the service level cgroup can declare that it's
> > >    the encompassing resource domain and the instance cgroup can say whether
> > >    it's gonna charge e.g. the tmpfs instance to its own or the encompassing
> > >    resource domain.
> > >
> > 
> > I think this sounds excellent and addresses our use cases. Basically
> > the tmpfs/bpf memory would get charged to the encompassing resource
> > domain cgroup rather than the instance cgroup, making the memory usage
> > of the first and second+ instances consistent and predictable.
> > 
> > Would love to hear from other memcg folks what they would think of
> > such an approach. I would also love to hear what kind of interface you
> > have in mind. Perhaps a cgroup tunable that says whether it's going to
> > charge the tmpfs/bpf instance to itself or to the encompassing
> > resource domain?
> 
> I like this too. It makes shared charging predictable, with a coherent
> resource hierarchy (congruent OOM, CPU, IO domains), and without the
> need for cgroup paths in tmpfs mounts or similar.
> 
> As far as who is declaring what goes, though: if the instance groups
> can declare arbitrary files/objects persistent or shared, they'd be
> able to abuse this and sneak private memory past local limits and
> burden the wider persistent/shared domain with it.
> 
> I'm thinking it might make more sense for the service level to declare
> which objects are persistent and shared across instances.

I like this idea.

> 
> If that's the case, we may not need a two-component interface. Just
> the ability for an intermediate cgroup to say: "This object's future
> memory is to be charged to me, not the instantiating cgroup."
> 
> Can we require a process in the intermediate cgroup to set up the file
> or object, and use madvise/fadvise to say "charge me", before any
> instances are launched?

We need to think how to make this interface convenient to use.
First, these persistent resources are likely created by some agent software,
not the main workload. So the requirement to call madvise() from the
actual cgroup might be not easily achievable.

So _maybe_ something like writing a fd into cgroup.memory.resources.

Second, it would be really useful to export the current configuration
to userspace. E.g. a user should be able to query to which cgroup the given
bpf map "belongs" and which bpf maps belong to the given cgroups. Otherwise
it will create a problem for userspace programs which manage cgroups
(e.g. systemd): they should be able to restore the current configuration
from the kernel state, without "remembering" what has been configured
before.

Thanks!
