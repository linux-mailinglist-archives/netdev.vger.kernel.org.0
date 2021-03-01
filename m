Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB12328A4C
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 19:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239415AbhCASPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 13:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232384AbhCASMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 13:12:39 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D8FBC061788
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 10:11:59 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id r23so20586879ljh.1
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 10:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BGU0eUrGcHK/RDV2rfGKNSJvLH9RO1hVgeZSC29kjwo=;
        b=ht1sFzXFGRfS8LWY4p2VzOH9ey6K1YEdVoK6ois+19WsBeTJoAIp0tgzWGYsYZupDU
         qJFKb8PFVL3nJiTyit/TnKA8aEKQDxwwg71VD/oSYIQZaacqGy9Zwb2Fq8Pbi+ExaAsQ
         VL6amJZRvFp93GD92cT48zqHKb0jTeHHHfyb5JEJEiyWdxMJa/5UUKgZZmbMNPXLu1L+
         d7BSvB3G1hdvVn0qWuUDLAj/ndRvD7LVDuiJLAM1+CPfKY5NqqlhAQW6YxI5bLXG/pkJ
         l/f7aZVczU7/iYKir9kKh5hnoT+daU64GUZ0uEi3m6Kvqzx8q9w4NEkVdDFmjzlboJ+r
         yNCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BGU0eUrGcHK/RDV2rfGKNSJvLH9RO1hVgeZSC29kjwo=;
        b=WiCfxCx1Gsr7MaYS83RUjaaB5MH9HscLbsDKTIWcuQG6Y6E42XUOnUvMQqXDjWDBY4
         u4lbEiEdiJFLEEoXbrIQZr7in1CVgO+cgvANc41AJOTXWkzAsKt3DvgVrfoBtEge7skR
         RIW2X2WFkvE/Hv93l3AhVGcglKaKxFXqEMY2/hc0MubVEJZ5XagC8SLNu4AAmP+l047M
         3TJZ1r6g4gPTB3MHjPY+imhvPswF9d0d1//cF3u6nJLRYVNM16IIIaQOzZaITTMTE7oS
         r/cNIdM74LijuXEyoV3q6KUH4nhymBljwJ+15Ggvuv4p6SBAFnRy9hjAvdnpL7pa4817
         kcuQ==
X-Gm-Message-State: AOAM530X1HoJCiVtFCh1zXtNGIsNH0j2l/65qwdOCvSrgMBCao4ACkg8
        2BG8bpoaT11YRtM+3i1hYkSRtrjFa/1/pUs4qcq2SQ==
X-Google-Smtp-Source: ABdhPJyyN10CMbekqIe2EaCLHXVwEmhEw2eA0ojmVgi3XY81XzPa0cvQd4lzpVVcj9/BVccaJ8HjfF/Ze2+dV2hAXeM=
X-Received: by 2002:a2e:9cc4:: with SMTP id g4mr981268ljj.34.1614622317485;
 Mon, 01 Mar 2021 10:11:57 -0800 (PST)
MIME-Version: 1.0
References: <20210301062227.59292-1-songmuchun@bytedance.com> <20210301062227.59292-3-songmuchun@bytedance.com>
In-Reply-To: <20210301062227.59292-3-songmuchun@bytedance.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Mon, 1 Mar 2021 10:11:45 -0800
Message-ID: <CALvZod7sysj0+wrzLTXnwn7s_Gf-V2eFPJ6cLcoRmR0LdAFk0Q@mail.gmail.com>
Subject: Re: [PATCH 2/5] mm: memcontrol: make page_memcg{_rcu} only applicable
 for non-kmem page
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Amir Goldstein <amir73il@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        dietmar.eggemann@arm.com, Steven Rostedt <rostedt@goodmis.org>,
        Benjamin Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, bristot@redhat.com,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <guro@fb.com>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        alexander.h.duyck@linux.intel.com,
        Chris Down <chris@chrisdown.name>,
        Wei Yang <richard.weiyang@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Oskolkov <posk@google.com>, Jann Horn <jannh@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, daniel.vetter@ffwll.ch,
        Waiman Long <longman@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>, krisman@collabora.com,
        esyr@redhat.com, Suren Baghdasaryan <surenb@google.com>,
        Marco Elver <elver@google.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        duanxiongchun@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 28, 2021 at 10:25 PM Muchun Song <songmuchun@bytedance.com> wrote:
>
> We want to reuse the obj_cgroup APIs to reparent the kmem pages when
> the memcg offlined. If we do this, we should store an object cgroup
> pointer to page->memcg_data for the kmem pages.
>
> Finally, page->memcg_data can have 3 different meanings.
>
>   1) For the slab pages, page->memcg_data points to an object cgroups
>      vector.
>
>   2) For the kmem pages (exclude the slab pages), page->memcg_data
>      points to an object cgroup.
>
>   3) For the user pages (e.g. the LRU pages), page->memcg_data points
>      to a memory cgroup.
>
> Currently we always get the memcg associated with a page via page_memcg
> or page_memcg_rcu. page_memcg_check is special, it has to be used in
> cases when it's not known if a page has an associated memory cgroup
> pointer or an object cgroups vector. Because the page->memcg_data of
> the kmem page is not pointing to a memory cgroup in the later patch,
> the page_memcg and page_memcg_rcu cannot be applicable for the kmem
> pages. In this patch, we introduce page_memcg_kmem to get the memcg
> associated with the kmem pages. And make page_memcg and page_memcg_rcu
> no longer apply to the kmem pages.
>
> In the end, there are 4 helpers to get the memcg associated with a
> page. The usage is as follows.
>
>   1) Get the memory cgroup associated with a non-kmem page (e.g. the LRU
>      pages).
>
>      - page_memcg()
>      - page_memcg_rcu()

Can you rename these to page_memcg_lru[_rcu] to make them explicitly
for LRU pages?

>
>   2) Get the memory cgroup associated with a kmem page (exclude the slab
>      pages).
>
>      - page_memcg_kmem()
>
>   3) Get the memory cgroup associated with a page. It has to be used in
>      cases when it's not known if a page has an associated memory cgroup
>      pointer or an object cgroups vector. Returns NULL for slab pages or
>      uncharged pages, otherwise, returns memory cgroup for charged pages
>      (e.g. kmem pages, LRU pages).
>
>      - page_memcg_check()
>
> In some place, we use page_memcg to check whether the page is charged.
> Now we introduce page_memcg_charged helper to do this.
>
> This is a preparation for reparenting the kmem pages. To support reparent
> kmem pages, we just need to adjust page_memcg_kmem and page_memcg_check in
> the later patch.
>
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
[snip]
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -855,10 +855,11 @@ void __mod_lruvec_page_state(struct page *page, enum node_stat_item idx,
>                              int val)
>  {
>         struct page *head = compound_head(page); /* rmap on tail pages */
> -       struct mem_cgroup *memcg = page_memcg(head);
> +       struct mem_cgroup *memcg;
>         pg_data_t *pgdat = page_pgdat(page);
>         struct lruvec *lruvec;
>
> +       memcg = PageMemcgKmem(head) ? page_memcg_kmem(head) : page_memcg(head);

Should page_memcg_check() be used here?

>         /* Untracked pages have no memcg, no lruvec. Update only the node */
>         if (!memcg) {
>                 __mod_node_page_state(pgdat, idx, val);
> @@ -3170,12 +3171,13 @@ int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order)
>   */
>  void __memcg_kmem_uncharge_page(struct page *page, int order)
>  {
> -       struct mem_cgroup *memcg = page_memcg(page);
> +       struct mem_cgroup *memcg;
>         unsigned int nr_pages = 1 << order;
>
> -       if (!memcg)
> +       if (!page_memcg_charged(page))
>                 return;
>
> +       memcg = page_memcg_kmem(page);
>         VM_BUG_ON_PAGE(mem_cgroup_is_root(memcg), page);
>         __memcg_kmem_uncharge(memcg, nr_pages);
>         page->memcg_data = 0;
> @@ -6831,24 +6833,25 @@ static void uncharge_batch(const struct uncharge_gather *ug)
>  static void uncharge_page(struct page *page, struct uncharge_gather *ug)
>  {
>         unsigned long nr_pages;
> +       struct mem_cgroup *memcg;
>
>         VM_BUG_ON_PAGE(PageLRU(page), page);
>
> -       if (!page_memcg(page))
> +       if (!page_memcg_charged(page))
>                 return;
>
>         /*
>          * Nobody should be changing or seriously looking at
> -        * page_memcg(page) at this point, we have fully
> -        * exclusive access to the page.
> +        * page memcg at this point, we have fully exclusive
> +        * access to the page.
>          */
> -
> -       if (ug->memcg != page_memcg(page)) {
> +       memcg = PageMemcgKmem(page) ? page_memcg_kmem(page) : page_memcg(page);

Same, should page_memcg_check() be used here?
