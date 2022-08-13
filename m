Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 993FD591C46
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 20:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239916AbiHMSaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Aug 2022 14:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239428AbiHMSaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Aug 2022 14:30:12 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E80BBE32;
        Sat, 13 Aug 2022 11:30:11 -0700 (PDT)
Date:   Sat, 13 Aug 2022 11:30:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660415410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E63Q1bPVq427Ovtaj+mb5uXGGsmTNyBJBlzhvoLTwWg=;
        b=XdvYQabcYG06stMpL7taZTyyG5P1TGqdnpJqO/xobn+zdaM0gHjKmJS1RiR8q8k7WW5y/z
        MWC+HwqyGdQgITH4nwfv+7w09IKR7j1EkyVrU+LSEsH2O7ic770M27T3OEBvmLVqryM345
        2y46qaqEmEAroYsj4l2Fw6+DPT61iSw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
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
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH bpf-next 13/15] mm, memcg: Add new helper
 get_obj_cgroup_from_cgroup
Message-ID: <YvftrF7GmqMjvAa+@P9FQF9L96D.corp.robot.car>
References: <20220810151840.16394-1-laoar.shao@gmail.com>
 <20220810151840.16394-14-laoar.shao@gmail.com>
 <YvUrXLJF6qrGOdjP@P9FQF9L96D.corp.robot.car>
 <CALOAHbAj7BymBV7KhzxLfMPue8666V+24TOfqG0XTE4euWyR4Q@mail.gmail.com>
 <YvaQhLk06MHQJWHB@P9FQF9L96D.corp.robot.car>
 <CALOAHbBh4=yxX5c2_TK8-uf14KKg=Vp1NoHAEZGxS2wAxCnZWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbBh4=yxX5c2_TK8-uf14KKg=Vp1NoHAEZGxS2wAxCnZWA@mail.gmail.com>
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

On Sat, Aug 13, 2022 at 07:56:54AM +0800, Yafang Shao wrote:
> On Sat, Aug 13, 2022 at 1:40 AM Roman Gushchin <roman.gushchin@linux.dev> wrote:
> >
> > On Fri, Aug 12, 2022 at 08:35:19AM +0800, Yafang Shao wrote:
> > > On Fri, Aug 12, 2022 at 12:16 AM Roman Gushchin
> > > <roman.gushchin@linux.dev> wrote:
> > > >
> > > > On Wed, Aug 10, 2022 at 03:18:38PM +0000, Yafang Shao wrote:
> > > > > Introduce new helper get_obj_cgroup_from_cgroup() to get obj_cgroup from
> > > > > a specific cgroup.
> > > > >
> > > > > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > > > > ---
> > > > >  include/linux/memcontrol.h |  1 +
> > > > >  mm/memcontrol.c            | 41 +++++++++++++++++++++++++++++++++++++++++
> > > > >  2 files changed, 42 insertions(+)
> > > > >
> > > > > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > > > > index 2f0a611..901a921 100644
> > > > > --- a/include/linux/memcontrol.h
> > > > > +++ b/include/linux/memcontrol.h
> > > > > @@ -1713,6 +1713,7 @@ static inline void set_shrinker_bit(struct mem_cgroup *memcg,
> > > > >  int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order);
> > > > >  void __memcg_kmem_uncharge_page(struct page *page, int order);
> > > > >
> > > > > +struct obj_cgroup *get_obj_cgroup_from_cgroup(struct cgroup *cgrp);
> > > > >  struct obj_cgroup *get_obj_cgroup_from_current(void);
> > > > >  struct obj_cgroup *get_obj_cgroup_from_page(struct page *page);
> > > > >
> > > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > > index 618c366..762cffa 100644
> > > > > --- a/mm/memcontrol.c
> > > > > +++ b/mm/memcontrol.c
> > > > > @@ -2908,6 +2908,47 @@ static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
> > > > >       return objcg;
> > > > >  }
> > > > >
> > > > > +static struct obj_cgroup *get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
> > > > > +{
> > > > > +     struct obj_cgroup *objcg;
> > > > > +
> > > > > +     if (memcg_kmem_bypass())
> > > > > +             return NULL;
> > > > > +
> > > > > +     rcu_read_lock();
> > > > > +     objcg = __get_obj_cgroup_from_memcg(memcg);
> > > > > +     rcu_read_unlock();
> > > > > +     return objcg;
> > > >
> > > > This code doesn't make sense to me. What does rcu read lock protect here?
> > >
> > > To protect rcu_dereference(memcg->objcg);.
> > > Doesn't it need the read rcu lock ?
> >
> > No, it's not how rcu works. Please, take a look at the docs here:
> > https://docs.kernel.org/RCU/whatisRCU.html#whatisrcu .
> > In particular, it describes this specific case very well.
> >
> > In 2 words, you don't protect the rcu_dereference() call, you protect the pointer
> 
> I just copied and pasted rcu_dereference(memcg->objcg) there to make it clear.
> Actually it protects memcg->objcg, doesn't it ?
> 
> > you get, cause it's valid only inside the rcu read section. After rcu_read_unlock()
> > it might point at a random data, because the protected object can be already freed.
> >
> 
> Are you sure?
> Can't the obj_cgroup_tryget(objcg) prevent it from being freed ?

Ok, now I see where it comes from. You copy-pasted it from get_obj_cgroup_from_current()?
There rcu read lock section protects memcg, not objcg.
In your case you don't need it, because memcg is passed as a parameter to the function,
so it's the duty of the caller to ensure the lifetime of memcg.

Thanks!
