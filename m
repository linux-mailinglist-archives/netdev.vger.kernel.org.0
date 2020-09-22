Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B61F273BCF
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 09:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729983AbgIVH1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 03:27:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:56506 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729748AbgIVH1p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 03:27:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1600759663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Erw2OosUhNlUjJ/92tw/QfOb1ODXL2vdqOviv1OTGQE=;
        b=SJu6HGOM7mmekNJl2WAqQ2Z0OqgE18sdv4bZEjSiRqgybbfl14iLBvSa882Sg+JSj+TZhl
        UMLU1ibKgV/UqhrqCSyTiFlZ8zGyr3CeNw9z6X6gESLPqu69C9fKTiSuSmG4ObY2kuJbYo
        T6QzgAjoDLcehxHPNXIOeQcatmJPSdI=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 50C8AAA35;
        Tue, 22 Sep 2020 07:28:20 +0000 (UTC)
Date:   Tue, 22 Sep 2020 09:27:33 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     zangchunxin@bytedance.com, Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, lizefan@huawei.com,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kafai@fb.com,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        andriin@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org,
        Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org,
        Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org
Subject: Re: [PATCH] mm/memcontrol: Add the drop_cache interface for cgroup v2
Message-ID: <20200922072733.GT12990@dhcp22.suse.cz>
References: <20200921080255.15505-1-zangchunxin@bytedance.com>
 <20200921081200.GE12990@dhcp22.suse.cz>
 <CALOAHbDKvT58UFjxy770VDxO0VWABRYb7GVwgw+NiJp62mB06w@mail.gmail.com>
 <20200921110505.GH12990@dhcp22.suse.cz>
 <CALOAHbCDXwjN+WDSGVv+G3ho-YRRPjAAqMJBtyxeGHH6utb5ew@mail.gmail.com>
 <20200921113646.GJ12990@dhcp22.suse.cz>
 <CALOAHbCker64WEW9w4oq8=avA6oKf3-Jrn-vOOgkpqkV3g+CYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbCker64WEW9w4oq8=avA6oKf3-Jrn-vOOgkpqkV3g+CYA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 22-09-20 12:20:52, Yafang Shao wrote:
> On Mon, Sep 21, 2020 at 7:36 PM Michal Hocko <mhocko@suse.com> wrote:
> >
> > On Mon 21-09-20 19:23:01, Yafang Shao wrote:
> > > On Mon, Sep 21, 2020 at 7:05 PM Michal Hocko <mhocko@suse.com> wrote:
> > > >
> > > > On Mon 21-09-20 18:55:40, Yafang Shao wrote:
> > > > > On Mon, Sep 21, 2020 at 4:12 PM Michal Hocko <mhocko@suse.com> wrote:
> > > > > >
> > > > > > On Mon 21-09-20 16:02:55, zangchunxin@bytedance.com wrote:
> > > > > > > From: Chunxin Zang <zangchunxin@bytedance.com>
> > > > > > >
> > > > > > > In the cgroup v1, we have 'force_mepty' interface. This is very
> > > > > > > useful for userspace to actively release memory. But the cgroup
> > > > > > > v2 does not.
> > > > > > >
> > > > > > > This patch reuse cgroup v1's function, but have a new name for
> > > > > > > the interface. Because I think 'drop_cache' may be is easier to
> > > > > > > understand :)
> > > > > >
> > > > > > This should really explain a usecase. Global drop_caches is a terrible
> > > > > > interface and it has caused many problems in the past. People have
> > > > > > learned to use it as a remedy to any problem they might see and cause
> > > > > > other problems without realizing that. This is the reason why we even
> > > > > > log each attempt to drop caches.
> > > > > >
> > > > > > I would rather not repeat the same mistake on the memcg level unless
> > > > > > there is a very strong reason for it.
> > > > > >
> > > > >
> > > > > I think we'd better add these comments above the function
> > > > > mem_cgroup_force_empty() to explain why we don't want to expose this
> > > > > interface in cgroup2, otherwise people will continue to send this
> > > > > proposal without any strong reason.
> > > >
> > > > I do not mind people sending this proposal.  "V1 used to have an
> > > > interface, we need it in v2 as well" is not really viable without
> > > > providing more reasoning on the specific usecase.
> > > >
> > > > _Any_ patch should have a proper justification. This is nothing really
> > > > new to the process and I am wondering why this is coming as a surprise.
> > > >
> > >
> > > Container users always want to drop cache in a specific container,
> > > because they used to use drop_caches to fix memory pressure issues.
> >
> > This is exactly the kind of problems we have seen in the past. There
> > should be zero reason to addre potential reclaim problems by dropping
> > page cache on the floor. There is a huge cargo cult about this
> > procedure and I have seen numerous reports when people complained about
> > performance afterwards just to learn that the dropped page cache was one
> > of the resons for that.
> >
> > > Although drop_caches can cause some unexpected issues, it could also
> > > fix some issues.
> >
> > "Some issues" is way too general. We really want to learn about those
> > issues and address them properly.
> >
> 
> One use case in our production environment is that some of our tasks
> become very latency sensitive from 7am to 10am, so before these tasks
> become active we will use drop_caches to drop page caches generated by
> other tasks at night to avoid these tasks triggering direct reclaim.
>
> The best way to do it is to fix the latency in direct reclaim, but it
> will take great effort.

What is the latency triggered by the memory reclaim? It should be mostly
a clean page cache right as drop_caches only drops clean pages. Or is
this more about [id]cache? Do you have any profiles where is the time
spent?

> while drop_caches give us an easier way to achieve the same goal.

It papers over real problems and that is my earlier comment about.

> IOW, drop_caches give the users an option to achieve their goal before
> they find a better solution.

You can achieve the same by a different configuration already. You can
isolate your page cache hungry overnight (likely a backup) workload into
its own memcg. You can either use an aggressive high limit during the
run or simply reduce the high/max limit after the work is done.

If you cannot isolate that easily then you can lower high limit
temporarily before your peak workload.

Really throwing all the page cache away just to prepare for a peak
workload sounds like a bad idea to me. You are potentially throwing
data that you have to spend time to refault again.
-- 
Michal Hocko
SUSE Labs
