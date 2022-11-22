Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC1F86349DB
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 23:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234991AbiKVWMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 17:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235222AbiKVWLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 17:11:46 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DF849B7B
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 14:11:43 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id y83so2365689yby.12
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 14:11:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bZUQmB6GiXQi+M8Npz6+SwmWsXR3hQITzPdj0ohPJm4=;
        b=eUO7sYnvIbJsYZ0rzzXC7yH3N6HdZzYu0004UzcbkW8+vg0N1L8CfJzB97Fiut/sGk
         ND/gEcbc6o6qJF1g4VN8Ihs21pHn4QTl4poS5rssJ3uZ0To1v43esRc/ZlZFLu9QRcVV
         64qRYAWINJRl/0OQOzwWE+sigjOo7VTWIo7Q8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bZUQmB6GiXQi+M8Npz6+SwmWsXR3hQITzPdj0ohPJm4=;
        b=nBaTVOQ2RbfQLgGbAf+pdhqbQhAy3KYqZKAhBNIBTcYAXgs1z1thaiHMgjiiXaWI1h
         JUK8OJB04GE0PZDqmPUAfE39Qa9TIAPyUNIX79DLtkQhy71FtgSz5D9Gb+P1zBFrMQtd
         9eFO7CocKCXp3gQR3/yf6dnCN5q5auxX/gqntBdQwDlgPoxzuO2Siv4rno+I0Ogh/dJE
         8anGKAdWbNYvIwMzxFI1rkNjIYfJMlLL1VIXF5FHBNpUQyyuLVp6Oqqx3Dhl/MG8WuDg
         Xd+TjCdqAsNaA+cNPr8szR3VL6rCl3rMZU1tH/GIz3SKps0lBv783VpPSLwhwbOMrAwp
         HeHA==
X-Gm-Message-State: ANoB5pnA6ekTlym8D8Rvk6XahJ3oJkXauoEdzn2zvW1aLkiMkF0/hJPB
        +zcQe+2lX5wtRGXhm7XMvrCRR4yVhQTJwYrVNkp8mw==
X-Google-Smtp-Source: AA0mqf4WnaGBdw4CGCLWrsP49C0Rvke2rFymY2r/mpnyiluTDYxZrED1mX5IDgVYhn9F4YUEKHxvg1S2Zkm2Xoj42cU=
X-Received: by 2002:a25:ab44:0:b0:6dc:b78c:506d with SMTP id
 u62-20020a25ab44000000b006dcb78c506dmr23555771ybi.281.1669155102331; Tue, 22
 Nov 2022 14:11:42 -0800 (PST)
MIME-Version: 1.0
References: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
 <Y30rdnZ+lrfOxjTB@cmpxchg.org>
In-Reply-To: <Y30rdnZ+lrfOxjTB@cmpxchg.org>
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Tue, 22 Nov 2022 14:11:31 -0800
Message-ID: <CABWYdi3PqipLxnqeepXeZ471pfeBg06-PV0Uw04fU-LHnx_A4g@mail.gmail.com>
Subject: Re: Low TCP throughput due to vmpressure with swap enabled
To:     Johannes Weiner <hannes@cmpxchg.org>
Cc:     Linux MM <linux-mm@kvack.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, cgroups@vger.kernel.org,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 12:05 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Mon, Nov 21, 2022 at 04:53:43PM -0800, Ivan Babrou wrote:
> > Hello,
> >
> > We have observed a negative TCP throughput behavior from the following commit:
> >
> > * 8e8ae645249b mm: memcontrol: hook up vmpressure to socket pressure
> >
> > It landed back in 2016 in v4.5, so it's not exactly a new issue.
> >
> > The crux of the issue is that in some cases with swap present the
> > workload can be unfairly throttled in terms of TCP throughput.
>
> Thanks for the detailed analysis, Ivan.
>
> Originally, we pushed back on sockets only when regular page reclaim
> had completely failed and we were about to OOM. This patch was an
> attempt to be smarter about it and equalize pressure more smoothly
> between socket memory, file cache, anonymous pages.
>
> After a recent discussion with Shakeel, I'm no longer quite sure the
> kernel is the right place to attempt this sort of balancing. It kind
> of depends on the workload which type of memory is more imporant. And
> your report shows that vmpressure is a flawed mechanism to implement
> this, anyway.
>
> So I'm thinking we should delete the vmpressure thing, and go back to
> socket throttling only if an OOM is imminent. This is in line with
> what we do at the system level: sockets get throttled only after
> reclaim fails and we hit hard limits. It's then up to the users and
> sysadmin to allocate a reasonable amount of buffers given the overall
> memory budget.
>
> Cgroup accounting, limiting and OOM enforcement is still there for the
> socket buffers, so misbehaving groups will be contained either way.
>
> What do you think? Something like the below patch?

The idea sounds very reasonable to me. I can't really speak for the
patch contents with any sort of authority, but it looks ok to my
non-expert eyes.

There were some conflicts when cherry-picking this into v5.15. I think
the only real one was for the "!sc->proactive" condition not being
present there. For the rest I just accepted the incoming change.

I'm going to be away from my work computer until December 5th, but
I'll try to expedite my backported patch to a production machine today
to confirm that it makes the difference. If I can get some approvals
on my internal PRs, I should be able to provide the results by EOD
tomorrow.

>
> ---
>
> From 67757f78d8b4412b72fe1583ebaf13cfd0fc03b0 Mon Sep 17 00:00:00 2001
> From: Johannes Weiner <hannes@cmpxchg.org>
> Date: Tue, 22 Nov 2022 14:40:50 -0500
> Subject: [PATCH] Revert "mm: memcontrol: hook up vmpressure to socket
>  pressure"
>
> This reverts commit 8e8ae645249b85c8ed6c178557f8db8613a6bcc7.
>
> NOT-Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  include/linux/memcontrol.h |  6 ++--
>  include/linux/vmpressure.h |  7 ++---
>  mm/memcontrol.c            | 19 +++++++++----
>  mm/vmpressure.c            | 58 ++++++--------------------------------
>  mm/vmscan.c                | 15 +---------
>  5 files changed, 29 insertions(+), 76 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index e1644a24009c..e7369363d4c2 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -283,11 +283,11 @@ struct mem_cgroup {
>         atomic_long_t           memory_events[MEMCG_NR_MEMORY_EVENTS];
>         atomic_long_t           memory_events_local[MEMCG_NR_MEMORY_EVENTS];
>
> +       /* Socket memory allocations have failed */
>         unsigned long           socket_pressure;
>
>         /* Legacy tcp memory accounting */
>         bool                    tcpmem_active;
> -       int                     tcpmem_pressure;
>
>  #ifdef CONFIG_MEMCG_KMEM
>         int kmemcg_id;
> @@ -1701,10 +1701,10 @@ void mem_cgroup_sk_alloc(struct sock *sk);
>  void mem_cgroup_sk_free(struct sock *sk);
>  static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
>  {
> -       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
> +       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->socket_pressure)
>                 return true;
>         do {
> -               if (time_before(jiffies, READ_ONCE(memcg->socket_pressure)))
> +               if (memcg->socket_pressure)
>                         return true;
>         } while ((memcg = parent_mem_cgroup(memcg)));
>         return false;
> diff --git a/include/linux/vmpressure.h b/include/linux/vmpressure.h
> index 6a2f51ebbfd3..20d93de37a17 100644
> --- a/include/linux/vmpressure.h
> +++ b/include/linux/vmpressure.h
> @@ -11,9 +11,6 @@
>  #include <linux/eventfd.h>
>
>  struct vmpressure {
> -       unsigned long scanned;
> -       unsigned long reclaimed;
> -
>         unsigned long tree_scanned;
>         unsigned long tree_reclaimed;
>         /* The lock is used to keep the scanned/reclaimed above in sync. */
> @@ -30,7 +27,7 @@ struct vmpressure {
>  struct mem_cgroup;
>
>  #ifdef CONFIG_MEMCG
> -extern void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
> +extern void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,
>                        unsigned long scanned, unsigned long reclaimed);
>  extern void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg, int prio);
>
> @@ -44,7 +41,7 @@ extern int vmpressure_register_event(struct mem_cgroup *memcg,
>  extern void vmpressure_unregister_event(struct mem_cgroup *memcg,
>                                         struct eventfd_ctx *eventfd);
>  #else
> -static inline void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
> +static inline void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,
>                               unsigned long scanned, unsigned long reclaimed) {}
>  static inline void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg,
>                                    int prio) {}
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 2d8549ae1b30..066166aebbef 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -7195,10 +7195,10 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
>                 struct page_counter *fail;
>
>                 if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail)) {
> -                       memcg->tcpmem_pressure = 0;
> +                       memcg->socket_pressure = 0;
>                         return true;
>                 }
> -               memcg->tcpmem_pressure = 1;
> +               memcg->socket_pressure = 1;
>                 if (gfp_mask & __GFP_NOFAIL) {
>                         page_counter_charge(&memcg->tcpmem, nr_pages);
>                         return true;
> @@ -7206,12 +7206,21 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
>                 return false;
>         }
>
> -       if (try_charge(memcg, gfp_mask, nr_pages) == 0) {
> -               mod_memcg_state(memcg, MEMCG_SOCK, nr_pages);
> -               return true;
> +       if (try_charge(memcg, gfp_mask & ~__GFP_NOFAIL, nr_pages) == 0) {
> +               memcg->socket_pressure = 0;
> +               goto success;
> +       }
> +       memcg->socket_pressure = 1;
> +       if (gfp_mask & __GFP_NOFAIL) {
> +               try_charge(memcg, gfp_mask, nr_pages);
> +               goto success;
>         }
>
>         return false;
> +
> +success:
> +       mod_memcg_state(memcg, MEMCG_SOCK, nr_pages);
> +       return true;
>  }
>
>  /**
> diff --git a/mm/vmpressure.c b/mm/vmpressure.c
> index b52644771cc4..4cec90711cf4 100644
> --- a/mm/vmpressure.c
> +++ b/mm/vmpressure.c
> @@ -219,7 +219,6 @@ static void vmpressure_work_fn(struct work_struct *work)
>   * vmpressure() - Account memory pressure through scanned/reclaimed ratio
>   * @gfp:       reclaimer's gfp mask
>   * @memcg:     cgroup memory controller handle
> - * @tree:      legacy subtree mode
>   * @scanned:   number of pages scanned
>   * @reclaimed: number of pages reclaimed
>   *
> @@ -227,16 +226,9 @@ static void vmpressure_work_fn(struct work_struct *work)
>   * "instantaneous" memory pressure (scanned/reclaimed ratio). The raw
>   * pressure index is then further refined and averaged over time.
>   *
> - * If @tree is set, vmpressure is in traditional userspace reporting
> - * mode: @memcg is considered the pressure root and userspace is
> - * notified of the entire subtree's reclaim efficiency.
> - *
> - * If @tree is not set, reclaim efficiency is recorded for @memcg, and
> - * only in-kernel users are notified.
> - *
>   * This function does not return any value.
>   */
> -void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
> +void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,
>                 unsigned long scanned, unsigned long reclaimed)
>  {
>         struct vmpressure *vmpr;
> @@ -271,46 +263,14 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
>         if (!scanned)
>                 return;
>
> -       if (tree) {
> -               spin_lock(&vmpr->sr_lock);
> -               scanned = vmpr->tree_scanned += scanned;
> -               vmpr->tree_reclaimed += reclaimed;
> -               spin_unlock(&vmpr->sr_lock);
> -
> -               if (scanned < vmpressure_win)
> -                       return;
> -               schedule_work(&vmpr->work);
> -       } else {
> -               enum vmpressure_levels level;
> -
> -               /* For now, no users for root-level efficiency */
> -               if (!memcg || mem_cgroup_is_root(memcg))
> -                       return;
> -
> -               spin_lock(&vmpr->sr_lock);
> -               scanned = vmpr->scanned += scanned;
> -               reclaimed = vmpr->reclaimed += reclaimed;
> -               if (scanned < vmpressure_win) {
> -                       spin_unlock(&vmpr->sr_lock);
> -                       return;
> -               }
> -               vmpr->scanned = vmpr->reclaimed = 0;
> -               spin_unlock(&vmpr->sr_lock);
> +       spin_lock(&vmpr->sr_lock);
> +       scanned = vmpr->tree_scanned += scanned;
> +       vmpr->tree_reclaimed += reclaimed;
> +       spin_unlock(&vmpr->sr_lock);
>
> -               level = vmpressure_calc_level(scanned, reclaimed);
> -
> -               if (level > VMPRESSURE_LOW) {
> -                       /*
> -                        * Let the socket buffer allocator know that
> -                        * we are having trouble reclaiming LRU pages.
> -                        *
> -                        * For hysteresis keep the pressure state
> -                        * asserted for a second in which subsequent
> -                        * pressure events can occur.
> -                        */
> -                       WRITE_ONCE(memcg->socket_pressure, jiffies + HZ);
> -               }
> -       }
> +       if (scanned < vmpressure_win)
> +               return;
> +       schedule_work(&vmpr->work);
>  }
>
>  /**
> @@ -340,7 +300,7 @@ void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg, int prio)
>          * to the vmpressure() basically means that we signal 'critical'
>          * level.
>          */
> -       vmpressure(gfp, memcg, true, vmpressure_win, 0);
> +       vmpressure(gfp, memcg, vmpressure_win, 0);
>  }
>
>  #define MAX_VMPRESSURE_ARGS_LEN        (strlen("critical") + strlen("hierarchy") + 2)
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 04d8b88e5216..d348366d58d4 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -6035,8 +6035,6 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
>         memcg = mem_cgroup_iter(target_memcg, NULL, NULL);
>         do {
>                 struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
> -               unsigned long reclaimed;
> -               unsigned long scanned;
>
>                 /*
>                  * This loop can become CPU-bound when target memcgs
> @@ -6068,20 +6066,9 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
>                         memcg_memory_event(memcg, MEMCG_LOW);
>                 }
>
> -               reclaimed = sc->nr_reclaimed;
> -               scanned = sc->nr_scanned;
> -
>                 shrink_lruvec(lruvec, sc);
> -
>                 shrink_slab(sc->gfp_mask, pgdat->node_id, memcg,
>                             sc->priority);
> -
> -               /* Record the group's reclaim efficiency */
> -               if (!sc->proactive)
> -                       vmpressure(sc->gfp_mask, memcg, false,
> -                                  sc->nr_scanned - scanned,
> -                                  sc->nr_reclaimed - reclaimed);
> -
>         } while ((memcg = mem_cgroup_iter(target_memcg, memcg, NULL)));
>  }
>
> @@ -6111,7 +6098,7 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
>
>         /* Record the subtree's reclaim efficiency */
>         if (!sc->proactive)
> -               vmpressure(sc->gfp_mask, sc->target_mem_cgroup, true,
> +               vmpressure(sc->gfp_mask, sc->target_mem_cgroup,
>                            sc->nr_scanned - nr_scanned,
>                            sc->nr_reclaimed - nr_reclaimed);
>
> --
> 2.38.1
>
