Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 621A359098F
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 02:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233974AbiHLA1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 20:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiHLA1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 20:27:50 -0400
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F044EA00F1;
        Thu, 11 Aug 2022 17:27:48 -0700 (PDT)
Received: by mail-vk1-xa2c.google.com with SMTP id q14so9733893vke.9;
        Thu, 11 Aug 2022 17:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=1EqMW9+sIv7QJbTeZKUHZUM/p01kIgjNDKoKtzHUX6I=;
        b=M1GNjTX6MjOuuRZWm3CHgm0eqBJRWOE2DYIwkpijn0zr44uLH0SX2pVKsqnu6SKNns
         crOKzPpxy1RA43nKlwbqOUFzA7HRedMYZ8tQVF/fVGMAyKmhhwsTdSvsU68Ud2Rd1Vvf
         VGg7iWJFnTpKjk557gHnFc+YZibSg5rVyMlQJaEi3/Ldv14TBB8M/M2PtEJHVInQAn18
         t0OPuaERFvAALtrbkGhfJXRFwmuZN2S5HT8whf8Ecld+YIN1EMC8dvvmJ1vMiAv3owSc
         silpXSxehuEjE0NLkaQfkPb9niGhisKpqBCPa6hiJgda+d+CFnoRwtbCafYrK4a9pelF
         WX2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=1EqMW9+sIv7QJbTeZKUHZUM/p01kIgjNDKoKtzHUX6I=;
        b=0SqqQmwY5bCS30RwTOuUf75VVJqWlKzO8KAClOZPAWLl9jFHnnG++VOQp3MEaZwy/f
         +XxVDlDtefO9VbBaFC1IEw0nXy4f8fKVExtSBd13kfzoxeEIQM01hUKP8roAia5iXzQR
         lDIUTBE6bTjlGXTHsMyumFfV45EO7HgMGtHafabJ3g/Vkfz7XRjnAFmrksJEjXFDsFaS
         i0r36BdH4YMybtt5+nCCgNcAHA6waOFfHrJHLDkJo17RHMHdkysRvun+uxKglwGQmPg/
         jm4+piAbJpU2ZntRoaJxiNhw1QXxYnN08mpAzJpBp3GSmmNBygmnb16NS43ov5ahJXPw
         4oTg==
X-Gm-Message-State: ACgBeo3bg2alLkwOEEindbxEBQ1rd04KmlWkqk05GFhFln/lDaFucKxE
        mQxs5dzLVRZFbq32wUMum23ywqXS+i6TlYspBPjPoze9rnJ0Aw==
X-Google-Smtp-Source: AA6agR6Xxa627apoLE5N7GpRkjtgyd4LlWQoOuRcxBEEqPifbL4QHOVP/BOrxS/OJ4GGBJ0emBtj3jLw3QnSmFAygEI=
X-Received: by 2002:a1f:1644:0:b0:378:c157:d0f5 with SMTP id
 65-20020a1f1644000000b00378c157d0f5mr902289vkw.5.1660264068116; Thu, 11 Aug
 2022 17:27:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220810151840.16394-1-laoar.shao@gmail.com> <20220810151840.16394-6-laoar.shao@gmail.com>
 <20220810170706.ikyrsuzupjwt65h7@google.com> <CALOAHbBk+komswLqs0KBg8FeFAYpC20HjXrUeZA-=7cWf6nRUw@mail.gmail.com>
 <20220811154731.3smhom6v4qy2u6rd@google.com>
In-Reply-To: <20220811154731.3smhom6v4qy2u6rd@google.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Fri, 12 Aug 2022 08:27:09 +0800
Message-ID: <CALOAHbCXfRKDEt7jsUBsf-pQ-A7TpXPxGKYxu_GZN-8BUe2auw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 05/15] bpf: Fix incorrect mem_cgroup_put
To:     Shakeel Butt <shakeelb@google.com>
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
        Roman Gushchin <roman.gushchin@linux.dev>,
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

On Thu, Aug 11, 2022 at 11:47 PM Shakeel Butt <shakeelb@google.com> wrote:
>
> On Thu, Aug 11, 2022 at 10:49:13AM +0800, Yafang Shao wrote:
> > On Thu, Aug 11, 2022 at 1:07 AM Shakeel Butt <shakeelb@google.com> wrote:
> > >
> > > On Wed, Aug 10, 2022 at 03:18:30PM +0000, Yafang Shao wrote:
> > > > The memcg may be the root_mem_cgroup, in which case we shouldn't put it.
> > >
> > > No, it is ok to put root_mem_cgroup. css_put already handles the root
> > > cgroups.
> > >
> >
> > Ah, this commit log doesn't describe the issue clearly. I should improve it.
> > The issue is that in bpf_map_get_memcg() it doesn't get the objcg if
> > map->objcg is NULL (that can happen if the map belongs to the root
> > memcg), so we shouldn't put the objcg if map->objcg is NULL neither in
> > bpf_map_put_memcg().
>
> Sorry I am still not understanding. We are not 'getting' objcg in
> bpf_map_get_memcg(). We are 'getting' memcg from map->objcg and if that
> is NULL the function is returning root memcg and putting root memcg is
> totally fine.

When the map belongs to root_mem_cgroup, the map->objcg is NULL, right ?
See also bpf_map_save_memcg() and it describes clearly in the comment -

static void bpf_map_save_memcg(struct bpf_map *map)
{
        /* Currently if a map is created by a process belonging to the root
         * memory cgroup, get_obj_cgroup_from_current() will return NULL.
         * So we have to check map->objcg for being NULL each time it's
         * being used.
         */
        map->objcg = get_obj_cgroup_from_current();
}

So for the root_mem_cgroup case, bpf_map_get_memcg() will return
root_mem_cgroup directly without getting its css, right ? See below,

static struct mem_cgroup *bpf_map_get_memcg(const struct bpf_map *map)
{

        if (map->objcg)
                return get_mem_cgroup_from_objcg(map->objcg);

        return root_mem_cgroup;   // without css_get(&memcg->css);
}

But it will put the css unconditionally.  See below,

memcg = bpf_map_get_memcg(map);
...
mem_cgroup_put(memcg);

So we should put it *conditionally* as well.

  memcg = bpf_map_get_memcg(map);
   ...
+ if (map->objcg)
       mem_cgroup_put(memcg);

Is it clear to you ?

> Or are you saying that root_mem_cgroup is NULL?
>

No

-- 
Regards
Yafang
