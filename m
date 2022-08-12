Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67918590993
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 02:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234978AbiHLAcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 20:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiHLAcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 20:32:32 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E75A0313;
        Thu, 11 Aug 2022 17:32:30 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id c3so19878820vsc.6;
        Thu, 11 Aug 2022 17:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=03fjnh1xwewL0u689e6AC8d7EfZpcbmYwThbeEIF6Rs=;
        b=L9BIC0FSsu2fW5qW8A9HJmyxpMSSNuMf4263HMvYTZd7akdGq5Z5L8fL0H50GeDQIG
         gEHX7Btt79N3upJJqP1yuAAB9tmPy3gqBjTlhoxmlWCxoBuP0dk6I8FYEv3L7KQkUJOi
         K5Rzwydh8XPqVpzAznseOTIWJ5HuwzoNfKR3FRh+IZMBPWnvAc6mzKkNq9ePpbQV8nB6
         XnvALkD09KVnPMjwsbPKhO+X18rlft2HzMBXIgc2sjqw48l8gY27iPlZE3CWdoErBk9F
         odIRYh6kuzskgAU/iNuRlvWs2QZQgeqWh4TpFUWsP4AM0p65i+ULOi34birkfhUoUuaB
         UsUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=03fjnh1xwewL0u689e6AC8d7EfZpcbmYwThbeEIF6Rs=;
        b=zPGjtB0c6wub9xBR3GZ2yegFRNe6XFtaksoWdlU3gcOd76dOv9Y2hzZhStwxgeQwvo
         I0vxs/70/l8DELPSdKQY66REMPzCQ/RhqicR+kuDHVIg8ZmgyWvBC9y2zpMjFjvzyZsi
         BW2Tew8IC0Hhoac5Xk2nL+m48j6WrJhKpi5rBLcktF1X7RoxhnsZVPwRD7/BSt9thwSU
         U3gkbxh2QjPXtyO12vHD17AIHYe05NBeoVCnRZdiU1BrhLknVUvgti7sT0XvmrcvQ/LQ
         9UjC3izEfUpXExQuuQcmcwwAfizfr0pEN7DDtwNT7ogCMI8977bD4XDZF5wP8e1txGeM
         wpvw==
X-Gm-Message-State: ACgBeo1iJuEX32eXYORm7ob+dZVPZnSCMouw75/Z7VAxJXZhJQgDbOBy
        qY6UNi1ZI5Ef1NuCyO/d+WroM05+4TpvwUqB2H4=
X-Google-Smtp-Source: AA6agR5Yk07g13dO92BJmJBTUJKn4YRbog6iyUSopPgtnGx3pom6mYU73oS2EW6JwYnu2B9lSh/JqHHicdrPK0rUZ9g=
X-Received: by 2002:a05:6102:441c:b0:378:fcdd:d951 with SMTP id
 df28-20020a056102441c00b00378fcddd951mr805121vsb.22.1660264349645; Thu, 11
 Aug 2022 17:32:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220810151840.16394-1-laoar.shao@gmail.com> <20220810151840.16394-6-laoar.shao@gmail.com>
 <YvUy5IA+XJp7ylIC@P9FQF9L96D.corp.robot.car>
In-Reply-To: <YvUy5IA+XJp7ylIC@P9FQF9L96D.corp.robot.car>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Fri, 12 Aug 2022 08:31:50 +0800
Message-ID: <CALOAHbDGUJ4BELfUPF3Sq0bBcQhNU=RGOhr2_uCT3-XcjdYKSw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 05/15] bpf: Fix incorrect mem_cgroup_put
To:     Roman Gushchin <roman.gushchin@linux.dev>
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

On Fri, Aug 12, 2022 at 12:48 AM Roman Gushchin
<roman.gushchin@linux.dev> wrote:
>
> On Wed, Aug 10, 2022 at 03:18:30PM +0000, Yafang Shao wrote:
> > The memcg may be the root_mem_cgroup, in which case we shouldn't put it.
> > So a new helper bpf_map_put_memcg() is introduced to pair with
> > bpf_map_get_memcg().
> >
> > Fixes: 4201d9ab3e42 ("bpf: reparent bpf maps on memcg offlining")
> > Cc: Roman Gushchin <roman.gushchin@linux.dev>
> > Cc: Shakeel Butt <shakeelb@google.com>
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  kernel/bpf/syscall.c | 14 +++++++++++---
> >  1 file changed, 11 insertions(+), 3 deletions(-)
> >
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index 83c7136..51ab8b1 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -441,6 +441,14 @@ static struct mem_cgroup *bpf_map_get_memcg(const struct bpf_map *map)
> >       return root_mem_cgroup;
> >  }
> >
> > +static void bpf_map_put_memcg(struct mem_cgroup *memcg)
> > +{
> > +     if (mem_cgroup_is_root(memcg))
> > +             return;
> > +
> > +     mem_cgroup_put(memcg);
> > +}
>
> +1 to what Shakeel said. mem_cgroup_put(root_mem_cgroup) is totally valid.
> So this change does absolutely nothing.
>

Do you mean that we can mem_cgroup_put(root_mem_cgroup) without
mem_cgroup_get(root_mem_cgroup) ?
Am I missing something ?

> The fixes tag assumes there is a bug in the existing code. If so, please,
> describe the problem and how to reproduce it.
>

It is found by code review.  The root_mem_cgroup's css will break. But
I don't know what it may cause to the user.
If you think the fixes tag is unproper, I will remove it.

> Also, if it's not related to the rest of the patchset, please, send it
> separately.
>

I want to introduce a bpf_map_put_memcg() helper to pair with
bpf_map_get_memcg().
This new helper will be used by other patches.

-- 
Regards
Yafang
