Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC00E82E
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 18:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbfD2QzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 12:55:14 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39556 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728520AbfD2QzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 12:55:14 -0400
Received: by mail-lj1-f195.google.com with SMTP id q10so10022863ljc.6
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 09:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/7H/e2EUrCWHHDStB+dx3w/xV/0sn3mW7wWKzELkwAM=;
        b=cs0WlBHRxwia7fkoTovg5PVEV7ruG5SVKGsKFniIbeCAhR/m1arqGFlg0nVUlgsnnE
         mEKXkIIMW1MLQ+KqSDZvSY8Wgcfi3FDWzThPLymVFPWm/ePBflHRFvMCxn3xvTHt9tLv
         RveptY8Qd0vqmVavOEmOncix6eez09Y/GwWeiEygvRSXzseiEz/TbtqnulzLukB0PH/Y
         HpHopUtRwTLdA03SgQeb6pk9JcEkaH56wctMk91+yutx8PogIWK6CE6QnHGBrO9nGW7Q
         +hCRnxjF7mYkVb62IV8OMEaXGK+YnYMBxHnZMuz7NMbVZkDDKkJxEPXLJ/6WbvULrExC
         Op4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/7H/e2EUrCWHHDStB+dx3w/xV/0sn3mW7wWKzELkwAM=;
        b=JbtIbo4iVrhW1/4K1HTqRPiRIJDv18C5lmqPeCCfEWfhz6VRSjF7o5TVztgi0qWa7Q
         6s07og8CnWDLulCv7fTSmc4pRu5zTQAPiiSe551Jnx+Prc2o+DggXbsx5HkTed2XygNu
         Ys6dfF2Q9t6kQmC9e4Qlgw9CT3eKGpKX/hbnsHpKB0JQHOQhWRTkBkqrZ0evPd0OpiFM
         aw/uQPE2/3N8pYP9IpmXF4JmySGmeoM3n+5GESwLnkjxT3I7H9iyHw0vdJak3Klb2xJD
         6IFL752b0nq0E6bkKpcKnYUVnd4LXeSSbu8grmiX93YjfWdTL2acBFhvxVh2E4ZzcyAp
         vE9Q==
X-Gm-Message-State: APjAAAWdHr1ZHaC4+vJoYcVCUmQLAE9RVwKpJMQ/mAMyKDLSmW5UUm/Q
        Y6+wpFky8ScZ90p5FSyXyZKQsvrGp5H+tUDSMFs=
X-Google-Smtp-Source: APXvYqw/zsbyLYE4nzDoVqGD165bbgknTl+ikIdlPbNOsEDWf/ZSgpouZ5iI9Mne+HD3ltXlEWRcDOumBxuJFGfqGhE=
X-Received: by 2002:a2e:4b19:: with SMTP id y25mr1783976lja.106.1556556910834;
 Mon, 29 Apr 2019 09:55:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190428192225.123882-1-edumazet@google.com>
In-Reply-To: <20190428192225.123882-1-edumazet@google.com>
From:   Wei Wang <tracywwnj@gmail.com>
Date:   Mon, 29 Apr 2019 09:55:00 -0700
Message-ID: <CAC15z3gWSQOefy+vx+JV_bYLerpKXiS6qyoWApCV7Szso=8pWg@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: fix races in ip6_dst_destroy()
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 28, 2019 at 12:24 PM Eric Dumazet <edumazet@google.com> wrote:
>
> We had many syzbot reports that seem to be caused by use-after-free
> of struct fib6_info.
>
> ip6_dst_destroy(), fib6_drop_pcpu_from() and rt6_remove_exception()
> are writers vs rt->from, and use non consistent synchronization among
> themselves.
>
> Switching to xchg() will solve the issues with no possible
> lockdep issues.
>
> BUG: KASAN: user-memory-access in atomic_dec_and_test include/asm-generic/atomic-instrumented.h:747 [inline]
> BUG: KASAN: user-memory-access in fib6_info_release include/net/ip6_fib.h:294 [inline]
> BUG: KASAN: user-memory-access in fib6_info_release include/net/ip6_fib.h:292 [inline]
> BUG: KASAN: user-memory-access in fib6_drop_pcpu_from net/ipv6/ip6_fib.c:927 [inline]
> BUG: KASAN: user-memory-access in fib6_purge_rt+0x4f6/0x670 net/ipv6/ip6_fib.c:960
> Write of size 4 at addr 0000000000ffffb4 by task syz-executor.1/7649
>
> CPU: 0 PID: 7649 Comm: syz-executor.1 Not tainted 5.1.0-rc6+ #183
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
>  kasan_report.cold+0x5/0x40 mm/kasan/report.c:321
>  check_memory_region_inline mm/kasan/generic.c:185 [inline]
>  check_memory_region+0x123/0x190 mm/kasan/generic.c:191
>  kasan_check_write+0x14/0x20 mm/kasan/common.c:108
>  atomic_dec_and_test include/asm-generic/atomic-instrumented.h:747 [inline]
>  fib6_info_release include/net/ip6_fib.h:294 [inline]
>  fib6_info_release include/net/ip6_fib.h:292 [inline]
>  fib6_drop_pcpu_from net/ipv6/ip6_fib.c:927 [inline]
>  fib6_purge_rt+0x4f6/0x670 net/ipv6/ip6_fib.c:960
>  fib6_del_route net/ipv6/ip6_fib.c:1813 [inline]
>  fib6_del+0xac2/0x10a0 net/ipv6/ip6_fib.c:1844
>  fib6_clean_node+0x3a8/0x590 net/ipv6/ip6_fib.c:2006
>  fib6_walk_continue+0x495/0x900 net/ipv6/ip6_fib.c:1928
>  fib6_walk+0x9d/0x100 net/ipv6/ip6_fib.c:1976
>  fib6_clean_tree+0xe0/0x120 net/ipv6/ip6_fib.c:2055
>  __fib6_clean_all+0x118/0x2a0 net/ipv6/ip6_fib.c:2071
>  fib6_clean_all+0x2b/0x40 net/ipv6/ip6_fib.c:2082
>  rt6_sync_down_dev+0x134/0x150 net/ipv6/route.c:4057
>  rt6_disable_ip+0x27/0x5f0 net/ipv6/route.c:4062
>  addrconf_ifdown+0xa2/0x1220 net/ipv6/addrconf.c:3705
>  addrconf_notify+0x19a/0x2260 net/ipv6/addrconf.c:3630
>  notifier_call_chain+0xc7/0x240 kernel/notifier.c:93
>  __raw_notifier_call_chain kernel/notifier.c:394 [inline]
>  raw_notifier_call_chain+0x2e/0x40 kernel/notifier.c:401
>  call_netdevice_notifiers_info+0x3f/0x90 net/core/dev.c:1753
>  call_netdevice_notifiers_extack net/core/dev.c:1765 [inline]
>  call_netdevice_notifiers net/core/dev.c:1779 [inline]
>  dev_close_many+0x33f/0x6f0 net/core/dev.c:1522
>  rollback_registered_many+0x43b/0xfd0 net/core/dev.c:8177
>  rollback_registered+0x109/0x1d0 net/core/dev.c:8242
>  unregister_netdevice_queue net/core/dev.c:9289 [inline]
>  unregister_netdevice_queue+0x1ee/0x2c0 net/core/dev.c:9282
>  unregister_netdevice include/linux/netdevice.h:2658 [inline]
>  __tun_detach+0xd5b/0x1000 drivers/net/tun.c:727
>  tun_detach drivers/net/tun.c:744 [inline]
>  tun_chr_close+0xe0/0x180 drivers/net/tun.c:3443
>  __fput+0x2e5/0x8d0 fs/file_table.c:278
>  ____fput+0x16/0x20 fs/file_table.c:309
>  task_work_run+0x14a/0x1c0 kernel/task_work.c:113
>  exit_task_work include/linux/task_work.h:22 [inline]
>  do_exit+0x90a/0x2fa0 kernel/exit.c:876
>  do_group_exit+0x135/0x370 kernel/exit.c:980
>  __do_sys_exit_group kernel/exit.c:991 [inline]
>  __se_sys_exit_group kernel/exit.c:989 [inline]
>  __x64_sys_exit_group+0x44/0x50 kernel/exit.c:989
>  do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x458da9
> Code: ad b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffeafc2a6a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 000000000000001c RCX: 0000000000458da9
> RDX: 0000000000412a80 RSI: 0000000000a54ef0 RDI: 0000000000000043
> RBP: 00000000004be552 R08: 000000000000000c R09: 000000000004c0d1
> R10: 0000000002341940 R11: 0000000000000246 R12: 00000000ffffffff
> R13: 00007ffeafc2a7f0 R14: 000000000004c065 R15: 00007ffeafc2a800
>
> Fixes: a68886a69180 ("net/ipv6: Make from in rt6_info rcu protected")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: David Ahern <dsahern@gmail.com>
> ---
Acked-by: Wei Wang <weiwan@google.com>

Nice fix. Thanks Eric.

>  net/ipv6/ip6_fib.c | 4 +---
>  net/ipv6/route.c   | 9 ++-------
>  2 files changed, 3 insertions(+), 10 deletions(-)
>
> diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
> index 6613d8dbb0e5a5c3ba883c957e5bc4ba2bf00777..91247a6fc67ff7de1106d028b315a559e53e47f4 100644
> --- a/net/ipv6/ip6_fib.c
> +++ b/net/ipv6/ip6_fib.c
> @@ -921,9 +921,7 @@ static void fib6_drop_pcpu_from(struct fib6_info *f6i,
>                 if (pcpu_rt) {
>                         struct fib6_info *from;
>
> -                       from = rcu_dereference_protected(pcpu_rt->from,
> -                                            lockdep_is_held(&table->tb6_lock));
> -                       rcu_assign_pointer(pcpu_rt->from, NULL);
> +                       from = xchg((__force struct fib6_info **)&pcpu_rt->from, NULL);
>                         fib6_info_release(from);
>                 }
>         }
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 7178e32eb15d0a969eb39fcfec9973bb0150bf48..19d4edf37947de33423e1d590d3e556763f9a3fb 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -379,11 +379,8 @@ static void ip6_dst_destroy(struct dst_entry *dst)
>                 in6_dev_put(idev);
>         }
>
> -       rcu_read_lock();
> -       from = rcu_dereference(rt->from);
> -       rcu_assign_pointer(rt->from, NULL);
> +       from = xchg((__force struct fib6_info **)&rt->from, NULL);
>         fib6_info_release(from);
> -       rcu_read_unlock();
>  }
>
>  static void ip6_dst_ifdown(struct dst_entry *dst, struct net_device *dev,
> @@ -1288,9 +1285,7 @@ static void rt6_remove_exception(struct rt6_exception_bucket *bucket,
>         /* purge completely the exception to allow releasing the held resources:
>          * some [sk] cache may keep the dst around for unlimited time
>          */
> -       from = rcu_dereference_protected(rt6_ex->rt6i->from,
> -                                        lockdep_is_held(&rt6_exception_lock));
> -       rcu_assign_pointer(rt6_ex->rt6i->from, NULL);
> +       from = xchg((__force struct fib6_info **)&rt6_ex->rt6i->from, NULL);
>         fib6_info_release(from);
>         dst_dev_put(&rt6_ex->rt6i->dst);
>
> --
> 2.21.0.593.g511ec345e18-goog
>
