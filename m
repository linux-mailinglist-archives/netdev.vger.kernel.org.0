Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2FC5591508
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 19:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233434AbiHLRkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 13:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239610AbiHLRke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 13:40:34 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A2BE11;
        Fri, 12 Aug 2022 10:40:29 -0700 (PDT)
Date:   Fri, 12 Aug 2022 10:40:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660326026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w6Ui6PFQyblCEyPZ57T42coFxoRognQXiZqVXoIWqFs=;
        b=eo8EzCBX6CNmdTr4sLF70dtLbMt2dPXPD+HVktl34F94LkJrzZnomVdsA1IW+KkSKIhOpX
        KAGdoooorLo30gCs7Ru+u/ohPX2xxjs9PBmJCpJW1AOPb4axDNy7fCbXgl3mfYn8aJo0pJ
        rmlvouwRHuE5JLXmMq7k1JcDX4HKc2Y=
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
Message-ID: <YvaQhLk06MHQJWHB@P9FQF9L96D.corp.robot.car>
References: <20220810151840.16394-1-laoar.shao@gmail.com>
 <20220810151840.16394-14-laoar.shao@gmail.com>
 <YvUrXLJF6qrGOdjP@P9FQF9L96D.corp.robot.car>
 <CALOAHbAj7BymBV7KhzxLfMPue8666V+24TOfqG0XTE4euWyR4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbAj7BymBV7KhzxLfMPue8666V+24TOfqG0XTE4euWyR4Q@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 12, 2022 at 08:35:19AM +0800, Yafang Shao wrote:
> On Fri, Aug 12, 2022 at 12:16 AM Roman Gushchin
> <roman.gushchin@linux.dev> wrote:
> >
> > On Wed, Aug 10, 2022 at 03:18:38PM +0000, Yafang Shao wrote:
> > > Introduce new helper get_obj_cgroup_from_cgroup() to get obj_cgroup from
> > > a specific cgroup.
> > >
> > > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > > ---
> > >  include/linux/memcontrol.h |  1 +
> > >  mm/memcontrol.c            | 41 +++++++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 42 insertions(+)
> > >
> > > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > > index 2f0a611..901a921 100644
> > > --- a/include/linux/memcontrol.h
> > > +++ b/include/linux/memcontrol.h
> > > @@ -1713,6 +1713,7 @@ static inline void set_shrinker_bit(struct mem_cgroup *memcg,
> > >  int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order);
> > >  void __memcg_kmem_uncharge_page(struct page *page, int order);
> > >
> > > +struct obj_cgroup *get_obj_cgroup_from_cgroup(struct cgroup *cgrp);
> > >  struct obj_cgroup *get_obj_cgroup_from_current(void);
> > >  struct obj_cgroup *get_obj_cgroup_from_page(struct page *page);
> > >
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 618c366..762cffa 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -2908,6 +2908,47 @@ static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
> > >       return objcg;
> > >  }
> > >
> > > +static struct obj_cgroup *get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
> > > +{
> > > +     struct obj_cgroup *objcg;
> > > +
> > > +     if (memcg_kmem_bypass())
> > > +             return NULL;
> > > +
> > > +     rcu_read_lock();
> > > +     objcg = __get_obj_cgroup_from_memcg(memcg);
> > > +     rcu_read_unlock();
> > > +     return objcg;
> >
> > This code doesn't make sense to me. What does rcu read lock protect here?
> 
> To protect rcu_dereference(memcg->objcg);.
> Doesn't it need the read rcu lock ?

No, it's not how rcu works. Please, take a look at the docs here:
https://docs.kernel.org/RCU/whatisRCU.html#whatisrcu .
In particular, it describes this specific case very well.

In 2 words, you don't protect the rcu_dereference() call, you protect the pointer
you get, cause it's valid only inside the rcu read section. After rcu_read_unlock()
it might point at a random data, because the protected object can be already freed.

Thanks!
