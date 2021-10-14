Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A579D42DFF5
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 19:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232640AbhJNRQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 13:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232468AbhJNRQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 13:16:21 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA8DC061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 10:14:16 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id y10so6083982qkp.9
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 10:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bVPafhTqWtjLjIvW4BVlTjIeMKYkp9XIQIXCymUBmjw=;
        b=hzsT7i7B/DIqkUUdCdeyvnCb5jvU20PxRq0LOAzjh2eDafobXx97PREv5+BAs3UrYJ
         t0cOkrORCOQh6opH9IyOIgR173Hb6LddYT/KEHpNjxkxZ1pXFXSRx7RAVz0tRDj3gnKL
         /qVqVRuWF+dx9uRPmlhjOWc2WmFB8d7DgVT6XPGr0GgtFWGtCIh7kr+LpKLK7Qd0nmn/
         6TjRBSLs28tJkORk1tIULlV5iTV3C+SxPUSUPt5wmhFOf4RD91m7OhVeGe3NLJZzvcgc
         nSBIC8fZgCwXzJ+nqg//Q+FEkOguohEaPFnD2o2UMH+xNjHdqtLP1snxCULkCYyto8oq
         DJqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bVPafhTqWtjLjIvW4BVlTjIeMKYkp9XIQIXCymUBmjw=;
        b=r09oDDaiHsAUA+pF0HoL4PT29PIXNGERFHLG/BAOIi7+I4Jv/J11bLS24yX/cv40h0
         ncyCy9fTOf3CWespOVtlpDZSqlFpBRXfuNavihXUQGuoDWVm7pt9hANlYMt3jWp3RiJY
         DphOzKRHOMnV1CtFluWGUbeP6GNPjotpn/I90QhEN4QVlhAjydjCvvuCuygJUgwc/5lJ
         Qb/HR02emRo6IQFqbZxp0hUnVYtnb5rvUWBxp6AJQREKDeTMco6ye7ytBlK9tWlQHl2B
         FZwZqLM3jrec1O+wS7gmCrwzlZN1avNGU58s+z8Gaq4NDozh3YZFwJMRZyW+6Vw9Yn9z
         Sgtw==
X-Gm-Message-State: AOAM533oKrxZXFXZdsFlOocNCQ4wIJ88vpOmkRnb0nU82AdSqyh+r2ah
        atxflJTDiaYtr46m17/+RNi+Teo3x5/4sKrP/LfVXw==
X-Google-Smtp-Source: ABdhPJxxLjGFdFBVmi2gRM0LCfqMC0W365cKWe5GES4IOCMemgeU8JEdHozq964GKLc9luLClcNCInJv4siBYYyqRQA=
X-Received: by 2002:a37:6706:: with SMTP id b6mr5905433qkc.339.1634231655389;
 Thu, 14 Oct 2021 10:14:15 -0700 (PDT)
MIME-Version: 1.0
References: <20211014134126.3998932-1-eric.dumazet@gmail.com>
In-Reply-To: <20211014134126.3998932-1-eric.dumazet@gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 14 Oct 2021 13:13:58 -0400
Message-ID: <CADVnQyk9Vt-EV6yovMHkRaXsUYwDXpA=iBheUEaH71SLzMA03g@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] tcp: switch orphan_count to bare per-cpu counters
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stefan Bach <sfb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 14, 2021 at 9:41 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> Use of percpu_counter structure to track count of orphaned
> sockets is causing problems on modern hosts with 256 cpus
> or more.
>
> Stefan Bach reported a serious spinlock contention in real workloads,
> that I was able to reproduce with a netfilter rule dropping
> incoming FIN packets.
>
>     53.56%  server  [kernel.kallsyms]      [k] queued_spin_lock_slowpath
>             |
>             ---queued_spin_lock_slowpath
>                |
>                 --53.51%--_raw_spin_lock_irqsave
>                           |
>                            --53.51%--__percpu_counter_sum
>                                      tcp_check_oom
>                                      |
>                                      |--39.03%--__tcp_close
>                                      |          tcp_close
>                                      |          inet_release
>                                      |          inet6_release
>                                      |          sock_close
>                                      |          __fput
>                                      |          ____fput
>                                      |          task_work_run
>                                      |          exit_to_usermode_loop
>                                      |          do_syscall_64
>                                      |          entry_SYSCALL_64_after_hwframe
>                                      |          __GI___libc_close
>                                      |
>                                       --14.48%--tcp_out_of_resources
>                                                 tcp_write_timeout
>                                                 tcp_retransmit_timer
>                                                 tcp_write_timer_handler
>                                                 tcp_write_timer
>                                                 call_timer_fn
>                                                 expire_timers
>                                                 __run_timers
>                                                 run_timer_softirq
>                                                 __softirqentry_text_start
>
> As explained in commit cf86a086a180 ("net/dst: use a smaller percpu_counter
> batch for dst entries accounting"), default batch size is too big
> for the default value of tcp_max_orphans (262144).
>
> But even if we reduce batch sizes, there would still be cases
> where the estimated count of orphans is beyond the limit,
> and where tcp_too_many_orphans() has to call the expensive
> percpu_counter_sum_positive().
>
> One solution is to use plain per-cpu counters, and have
> a timer to periodically refresh this cache.
>
> Updating this cache every 100ms seems about right, tcp pressure
> state is not radically changing over shorter periods.
>
> percpu_counter was nice 15 years ago while hosts had less
> than 16 cpus, not anymore by current standards.
>
> v2: Fix the build issue for CONFIG_CRYPTO_DEV_CHELSIO_TLS=m,
>     reported by kernel test robot <lkp@intel.com>
>     Remove unused socket argument from tcp_too_many_orphans()
>
> Fixes: dd24c00191d5 ("net: Use a percpu_counter for orphan_count")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Stefan Bach <sfb@google.com>
> Cc: Neal Cardwell <ncardwell@google.com>
> ---

Fantastic. Thanks, Eric!

Acked-by: Neal Cardwell <ncardwell@google.com>

neal
