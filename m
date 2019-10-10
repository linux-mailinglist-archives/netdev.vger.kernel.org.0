Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0549D1D7A
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 02:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732446AbfJJAjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 20:39:39 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34412 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731155AbfJJAji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 20:39:38 -0400
Received: by mail-wm1-f68.google.com with SMTP id y135so5893848wmc.1
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 17:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=563U4przLcG8LjNU87d5cVTOvYpB2ryYytD4viIP5EM=;
        b=NDdfwqezRos1reiGTwAb17a6rlpF68Av6HGrBDC3c5H1CiOo4sEDTsvz01kJlTPisk
         HK8JqRLs/E8ctWu3n0n+/dqB/75jTFjdzqNzgxGhZlRpuW0mYic9YCkLrnAFcVZiqDT7
         hjvE293Jsi4aOCfoSnhTRwuecYTY3eL5BbC7q8ZbRsEQfqQDBClbOpADlbNwvaw4Vemg
         dJma7KA1W2j70YovP1CTtHbZWySLgzqt/X+fqksyp1GZGkMIa1A4oc2vwDueOeNpTN/5
         7k+EviZIBBkDN4Jl4hN8UPC11fmVbxCyMY7/B9o01xO7OadZ+U3hYsn6WUvaOo6/h/2+
         aIdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=563U4przLcG8LjNU87d5cVTOvYpB2ryYytD4viIP5EM=;
        b=pmsUyFARDpveInghPL2g9xml0nmtQQQvOPN8S/MVgh4ylvGg3UqGTisxnVe9JQ6vG5
         AmDhf6KXnN9TYwn8+aqAM6+W4dgLDBLw8sRB0k4yzJFBPaYcDziy7AgZ4nV3CBZNvfB5
         WGZhl2q/TDxQhwSz0RsekAUk8VbDMOv+8xhW+Su6BojrrRBnKnHWRrGgXhmg5gK3Y9lY
         NTn5IZTZzmIkf1lSb2XopGsjd/aeeiwe+LaZn4lyizeZvJKWwnjVPRYB3TD/j7jf5Wcm
         BRT/hTnqoyetMdQiIEGOsNuh6mhYKYHOO2m85O++QcsdfodSbS//TKNWkEVnINvsyuv6
         sNDQ==
X-Gm-Message-State: APjAAAXv7E2GvZpPeAGHLgR/VXWgrW54nsqCteezR8Gdm3Ilj2KO0t6r
        EcK1y+lLHSFzP1RPugoUnTFpwBdmo3CG8jkOc78/2to4UP0=
X-Google-Smtp-Source: APXvYqwpMZ/R1AuT4egc/XMC4gAER/EcPpVBUj326Fq5g0cJWvGYpbAa9mewuuUJk4eGizndaRvg6vawmUduTwVYO4A=
X-Received: by 2002:a1c:f401:: with SMTP id z1mr4589307wma.66.1570667973515;
 Wed, 09 Oct 2019 17:39:33 -0700 (PDT)
MIME-Version: 1.0
References: <20191009231526.238985-1-maheshb@google.com>
In-Reply-To: <20191009231526.238985-1-maheshb@google.com>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Wed, 9 Oct 2019 17:39:16 -0700
Message-ID: <CAF2d9jiHfr_nctQW5YdSyZOhvxT792waAwyhN3mbD_g64H2RxQ@mail.gmail.com>
Subject: Re: [PATCH next] blackhole_netdev: fix syzkaller reported issue
To:     Netdev <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>,
        Mahesh Bandewar <mahesh@bandewar.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 9, 2019 at 4:15 PM Mahesh Bandewar <maheshb@google.com> wrote:
>
> While invalidating the dst, we assign backhole_netdev instead of
> loopback device. However, this device does not have idev pointer
> and hence no ip6_ptr even if IPv6 is enabled. Possibly this has
> triggered the syzbot reported crash.
>
> The syzbot report does not have reproducer, however, this is the
> only device that doesn't have matching idev created.
>
> Crash instruction is :
>
> static inline bool ip6_ignore_linkdown(const struct net_device *dev)
> {
>         const struct inet6_dev *idev = __in6_dev_get(dev);
>
>         return !!idev->cnf.ignore_routes_with_linkdown; <= crash
> }
>
> Also ipv6 always assumes presence of idev and never checks for it
> being NULL (as does the above referenced code). So adding a idev
> for the blackhole_netdev to avoid this class of crashes in the future.
>
> ---
>
> syzbot has found the following crash on:
>
> HEAD commit:    125b7e09 net: tc35815: Explicitly check NET_IP_ALIGN is no..
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master
> console output: https://syzkaller-buganizer.googleplex.com/text?tag=CrashLog&id=96236769ac48d9c2eb3a0db5385370ea6940be83
> kernel config:  https://syzkaller-buganizer.googleplex.com/text?tag=Config&id=1ed331b637302a68174fdbe34315b781b7c7ab1e
> dashboard link: https://syzkaller.appspot.com/bug?extid=86298614df433d7f3824
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> See http://go/syzbot for details on how to handle this bug.
>
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 16525 Comm: syz-executor.2 Not tainted 5.3.0-rc3+ #159
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:ip6_ignore_linkdown include/net/addrconf.h:402 [inline]
> RIP: 0010:find_match+0x132/0xd70 net/ipv6/route.c:743
> Code: 0f b6 75 b0 40 84 f6 0f 84 ad 01 00 00 e8 c6 4c 34 fb 49 8d bf 3c 02 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 15
> RSP: 0018:ffff88806c037038 EFLAGS: 00010207
> RAX: dffffc0000000000 RBX: ffff888094c5cd60 RCX: ffffc9000b791000
> RDX: 0000000000000047 RSI: ffffffff863e3caa RDI: 000000000000023c
> RBP: ffff88806c037098 R08: ffff888063de0600 R09: ffff88806c037288
> R10: fffffbfff134af07 R11: ffffffff89a5783f R12: 0000000000000003
> R13: ffff88806c037298 R14: ffff888094c5cd6f R15: 0000000000000000
> FS:  00007fa15e7de700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000625208 CR3: 000000005e348000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> __find_rr_leaf+0x14e/0x750 net/ipv6/route.c:831
> find_rr_leaf net/ipv6/route.c:852 [inline]
> rt6_select net/ipv6/route.c:896 [inline]
> fib6_table_lookup+0x697/0xdb0 net/ipv6/route.c:2164
> ip6_pol_route+0x1f6/0xaf0 net/ipv6/route.c:2200
> ip6_pol_route_output+0x54/0x70 net/ipv6/route.c:2452
> fib6_rule_lookup+0x133/0x7a0 net/ipv6/fib6_rules.c:113
> ip6_route_output_flags_noref+0x2d6/0x360 net/ipv6/route.c:2484
> ip6_route_output_flags+0x106/0x4d0 net/ipv6/route.c:2497
> ip6_route_output include/net/ip6_route.h:98 [inline]
> ip6_dst_lookup_tail+0x1042/0x1ef0 net/ipv6/ip6_output.c:1022
> ip6_dst_lookup_flow+0xa8/0x220 net/ipv6/ip6_output.c:1150
> ip6_sk_dst_lookup_flow net/ipv6/ip6_output.c:1188 [inline]
> ip6_sk_dst_lookup_flow+0x62a/0xb90 net/ipv6/ip6_output.c:1178
> udpv6_sendmsg+0x17ba/0x2990 net/ipv6/udp.c:1439
> inet6_sendmsg+0x9e/0xe0 net/ipv6/af_inet6.c:576
> sock_sendmsg_nosec net/socket.c:637 [inline]
> sock_sendmsg+0xd7/0x130 net/socket.c:657
> __sys_sendto+0x262/0x380 net/socket.c:1952
> __do_sys_sendto net/socket.c:1964 [inline]
> __se_sys_sendto net/socket.c:1960 [inline]
> __x64_sys_sendto+0xe1/0x1a0 net/socket.c:1960
> do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
> entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x459829
> Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007fa15e7ddc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
> RAX: ffffffffffffffda RBX: 0000000000000006 RCX: 0000000000459829
> RDX: 0000000000000001 RSI: 0000000020000000 RDI: 0000000000000007
> RBP: 000000000075c1c0 R08: 0000000020001000 R09: 000000000000001c
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007fa15e7de6d4
> R13: 00000000004c77e7 R14: 00000000004dd048 R15: 00000000ffffffff
> Modules linked in:
> ---[ end trace 4b3ce5eddd15c8f6 ]---
> RIP: 0010:ip6_ignore_linkdown include/net/addrconf.h:402 [inline]
> RIP: 0010:find_match+0x132/0xd70 net/ipv6/route.c:743
> Code: 0f b6 75 b0 40 84 f6 0f 84 ad 01 00 00 e8 c6 4c 34 fb 49 8d bf 3c 02 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 15
> RSP: 0018:ffff88806c037038 EFLAGS: 00010207
> RAX: dffffc0000000000 RBX: ffff888094c5cd60 RCX: ffffc9000b791000
> RDX: 0000000000000047 RSI: ffffffff863e3caa RDI: 000000000000023c
> RBP: ffff88806c037098 R08: ffff888063de0600 R09: ffff88806c037288
> R10: fffffbfff134af07 R11: ffffffff89a5783f R12: 0000000000000003
> R13: ffff88806c037298 R14: ffff888094c5cd6f R15: 0000000000000000
> FS:  00007fa15e7de700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000625208 CR3: 000000005e348000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>
> Fixes: 8d7017fd621d ("blackhole_netdev: use blackhole_netdev to invalidate dst entries")
> Signed-off-by: Mahesh Bandewar <maheshb@google.com>
> ---
>  net/ipv6/addrconf.c | 6 +++++-
>  net/ipv6/route.c    | 5 ++---
>  2 files changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index 98d82305d6de..0f216f7cbe3e 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -6995,7 +6995,7 @@ static struct rtnl_af_ops inet6_ops __read_mostly = {
>
>  int __init addrconf_init(void)
>  {
> -       struct inet6_dev *idev;
> +       struct inet6_dev *idev, *bdev;
>         int i, err;
>
>         err = ipv6_addr_label_init();
> @@ -7035,10 +7035,14 @@ int __init addrconf_init(void)
>          */
>         rtnl_lock();
>         idev = ipv6_add_dev(init_net.loopback_dev);
> +       bdev = ipv6_add_dev(blackhole_netdev);
>         rtnl_unlock();
>         if (IS_ERR(idev)) {
>                 err = PTR_ERR(idev);
>                 goto errlo;
> +       } else if (IS_ERR(bdev)) {
> +               err = PTR_ERR(bdev);
> +               goto errlo;
>         }
>
>         ip6_route_init_special_entries();
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index a63ff85fe141..ea16e037ec13 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -155,10 +155,9 @@ void rt6_uncached_list_del(struct rt6_info *rt)
>
>  static void rt6_uncached_list_flush_dev(struct net *net, struct net_device *dev)
>  {
> -       struct net_device *loopback_dev = net->loopback_dev;
>         int cpu;
>
> -       if (dev == loopback_dev)
> +       if (dev == net->loopback_dev)
>                 return;
>
>         for_each_possible_cpu(cpu) {
> @@ -171,7 +170,7 @@ static void rt6_uncached_list_flush_dev(struct net *net, struct net_device *dev)
>                         struct net_device *rt_dev = rt->dst.dev;
>
>                         if (rt_idev->dev == dev) {
> -                               rt->rt6i_idev = in6_dev_get(loopback_dev);
> +                               rt->rt6i_idev = in6_dev_get(blackhole_netdev);
>                                 in6_dev_put(rt_idev);
>                         }
>
Hmm, I think I missed one more location i.e. dst_dev_put() which call
ip6_dst_ifdown() which still assigns loopback_idev and would cause the
same asymmetry. Let me fix that in v2
> --
> 2.23.0.581.g78d2f28ef7-goog
>
