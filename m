Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95D443E992C
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 21:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbhHKTq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 15:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbhHKTqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 15:46:22 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC81C061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 12:45:58 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id z128so6841547ybc.10
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 12:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rmCZfgibO0w4qM0h5z9GUKC+BABdJ5Xz7PCci/uX+uc=;
        b=bQNINJdh8XyFjAH1nodbu4ve7ZJa9ey6urBIbSxjDFSLPyrCRZN0IrF3YOFltFWMmQ
         /3yqc24HsOOoMyPHPdmCuvIzT2NNQbqhQVbOpt9RfoqDH3o+ycuuHt2lK70vVvCsgXPn
         dBadmLbwDpoU4h0Ea8rDkauNlCqmwmDkbjj+8j2X2dFh9BOV3XWKN1uaAybLK5OKA+nu
         kmTBFu4nuq7e3I3PoGPQUcIb7oQCMkhFUJKWqQ4228jIEKbbSwYlorPeR/Q5MeSCkjSl
         nFrr9pA83WmGz+StD+aRoaMdBvvx9UMhQroBa8+X0gxmfsCyhpryoR9ETe3sH2nxr/TJ
         6KPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rmCZfgibO0w4qM0h5z9GUKC+BABdJ5Xz7PCci/uX+uc=;
        b=m1mZcMhEZ3dht9I6cLduKiCkWXUVHtNIy0R0Dfa22rbH4wKTUBlBnXynvYIswNX8pG
         dqyDFApnU7oNC3/hIsDc3UMl6xQiyPvX7NkqqqXGd7PTsIOLgVzW59Kxt9hSPt5dyckm
         4zM0h7HGP8miD6JA5PjQ3Uh5zDgSZZbIFAE0rwkLBGE40KsnWbo5HfeMDSpvE7MbGP6q
         6PWhKYieiP7+ih6keRqm3JDWiwzIInPjXbQEPJ6W7z+MNPtAN+ceOfwqW7v9UGaXcRqK
         lhBHKCTo8yqGk+aqM+WVAlhp2e/6E9gp+cWJQjNxTuDdG2IiPe5GhkltF+dO2O1hqkwT
         4wIg==
X-Gm-Message-State: AOAM5316gTQtKXUtgjNN7DtEs/fgBVPC1ir6oNKMISREXOZrOFk+dAGx
        r0DK53HVKyPXtgR4TcQUzaNbEDJOxZXeBqGn9vuYxA==
X-Google-Smtp-Source: ABdhPJyEelXsYoHGDhlf/xVnYTD//bTmbhRiScNl85Op27cZUES9xv/ElmA4bMcLTy+Z9uCKBLcZiJAkDFKcxY8e+7w=
X-Received: by 2002:a25:afcd:: with SMTP id d13mr114441ybj.504.1628711156478;
 Wed, 11 Aug 2021 12:45:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210810094547.1851947-1-eric.dumazet@gmail.com>
 <20210811182923.GA4027194@roeck-us.net> <20210811183256.GA4139434@roeck-us.net>
In-Reply-To: <20210811183256.GA4139434@roeck-us.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 11 Aug 2021 21:45:45 +0200
Message-ID: <CANn89iJXAMcHubmAEr21y6HjsbPORSitqBhKD+-068qV-LXoEw@mail.gmail.com>
Subject: Re: [PATCH net] net: igmp: fix data-race in igmp_ifc_timer_expire()
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Time to make mr_ifc_count a 32bit field then :/

On Wed, Aug 11, 2021 at 8:32 PM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On Wed, Aug 11, 2021 at 11:29:25AM -0700, Guenter Roeck wrote:
> > On Tue, Aug 10, 2021 at 02:45:47AM -0700, Eric Dumazet wrote:
> > > From: Eric Dumazet <edumazet@google.com>
> > >
> > > Fix the data-race reported by syzbot [1]
> > > Issue here is that igmp_ifc_timer_expire() can update in_dev->mr_ifc_count
> > > while another change just occured from another context.
> > >
> > > in_dev->mr_ifc_count is only 8bit wide, so the race had little
> > > consequences.
> > >
> > > [1]
> > > BUG: KCSAN: data-race in igmp_ifc_event / igmp_ifc_timer_expire
> > >
> > > write to 0xffff8881051e3062 of 1 bytes by task 12547 on cpu 0:
> > >  igmp_ifc_event+0x1d5/0x290 net/ipv4/igmp.c:821
> > >  igmp_group_added+0x462/0x490 net/ipv4/igmp.c:1356
> > >  ____ip_mc_inc_group+0x3ff/0x500 net/ipv4/igmp.c:1461
> > >  __ip_mc_join_group+0x24d/0x2c0 net/ipv4/igmp.c:2199
> > >  ip_mc_join_group_ssm+0x20/0x30 net/ipv4/igmp.c:2218
> > >  do_ip_setsockopt net/ipv4/ip_sockglue.c:1285 [inline]
> > >  ip_setsockopt+0x1827/0x2a80 net/ipv4/ip_sockglue.c:1423
> > >  tcp_setsockopt+0x8c/0xa0 net/ipv4/tcp.c:3657
> > >  sock_common_setsockopt+0x5d/0x70 net/core/sock.c:3362
> > >  __sys_setsockopt+0x18f/0x200 net/socket.c:2159
> > >  __do_sys_setsockopt net/socket.c:2170 [inline]
> > >  __se_sys_setsockopt net/socket.c:2167 [inline]
> > >  __x64_sys_setsockopt+0x62/0x70 net/socket.c:2167
> > >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > >  do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
> > >  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > >
> > > read to 0xffff8881051e3062 of 1 bytes by interrupt on cpu 1:
> > >  igmp_ifc_timer_expire+0x706/0xa30 net/ipv4/igmp.c:808
> > >  call_timer_fn+0x2e/0x1d0 kernel/time/timer.c:1419
> > >  expire_timers+0x135/0x250 kernel/time/timer.c:1464
> > >  __run_timers+0x358/0x420 kernel/time/timer.c:1732
> > >  run_timer_softirq+0x19/0x30 kernel/time/timer.c:1745
> > >  __do_softirq+0x12c/0x26e kernel/softirq.c:558
> > >  invoke_softirq kernel/softirq.c:432 [inline]
> > >  __irq_exit_rcu+0x9a/0xb0 kernel/softirq.c:636
> > >  sysvec_apic_timer_interrupt+0x69/0x80 arch/x86/kernel/apic/apic.c:1100
> > >  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
> > >  console_unlock+0x8e8/0xb30 kernel/printk/printk.c:2646
> > >  vprintk_emit+0x125/0x3d0 kernel/printk/printk.c:2174
> > >  vprintk_default+0x22/0x30 kernel/printk/printk.c:2185
> > >  vprintk+0x15a/0x170 kernel/printk/printk_safe.c:392
> > >  printk+0x62/0x87 kernel/printk/printk.c:2216
> > >  selinux_netlink_send+0x399/0x400 security/selinux/hooks.c:6041
> > >  security_netlink_send+0x42/0x90 security/security.c:2070
> > >  netlink_sendmsg+0x59e/0x7c0 net/netlink/af_netlink.c:1919
> > >  sock_sendmsg_nosec net/socket.c:703 [inline]
> > >  sock_sendmsg net/socket.c:723 [inline]
> > >  ____sys_sendmsg+0x360/0x4d0 net/socket.c:2392
> > >  ___sys_sendmsg net/socket.c:2446 [inline]
> > >  __sys_sendmsg+0x1ed/0x270 net/socket.c:2475
> > >  __do_sys_sendmsg net/socket.c:2484 [inline]
> > >  __se_sys_sendmsg net/socket.c:2482 [inline]
> > >  __x64_sys_sendmsg+0x42/0x50 net/socket.c:2482
> > >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > >  do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
> > >  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > >
> > > value changed: 0x01 -> 0x02
> > >
> > > Reported by Kernel Concurrency Sanitizer on:
> > > CPU: 1 PID: 12539 Comm: syz-executor.1 Not tainted 5.14.0-rc4-syzkaller #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > >
> > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > Reported-by: syzbot <syzkaller@googlegroups.com>
> > > ---
> > >  net/ipv4/igmp.c | 21 ++++++++++++++-------
> > >  1 file changed, 14 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
> > > index 6b3c558a4f232652b97a078d48f302864e60a866..a51360087b19845a28408c827032e08dabf99838 100644
> > > --- a/net/ipv4/igmp.c
> > > +++ b/net/ipv4/igmp.c
> > > @@ -803,10 +803,17 @@ static void igmp_gq_timer_expire(struct timer_list *t)
> > >  static void igmp_ifc_timer_expire(struct timer_list *t)
> > >  {
> > >     struct in_device *in_dev = from_timer(in_dev, t, mr_ifc_timer);
> > > +   u8 mr_ifc_count;
> > >
> > >     igmpv3_send_cr(in_dev);
> > > -   if (in_dev->mr_ifc_count) {
> > > -           in_dev->mr_ifc_count--;
> > > +restart:
> > > +   mr_ifc_count = READ_ONCE(in_dev->mr_ifc_count);
> > > +
> > > +   if (mr_ifc_count) {
> > > +           if (cmpxchg(&in_dev->mr_ifc_count,
> >
> > Unfortunately riscv only supports 4-byte and 8-byte cmpxchg(),
> > so this results in build errors.
> >
> > Building riscv:defconfig ... failed
> > --------------
> > Error log:
> > In file included from <command-line>:
> > net/ipv4/igmp.c: In function 'igmp_ifc_timer_expire':
> > include/linux/compiler_types.h:328:45: error: call to '__compiletime_assert_547' declared with attribute error: BUILD_BUG failed
> >
>
> Also:
>
> Building arm:allmodconfig ... failed
> --------------
> Error log:
> arm-linux-gnueabi-ld: net/ipv4/igmp.o: in function `igmp_ifc_timer_expire':
> igmp.c:(.text+0x9b44): undefined reference to `__bad_cmpxchg'
> make[1]: *** [Makefile:1176: vmlinux] Error 1
> make: *** [Makefile:220: __sub-make] Error 2
>
> Building xtensa:allmodconfig ... failed
> --------------
> Error log:
> xtensa-linux-ld: net/ipv4/igmp.o: in function `igmp_gq_timer_expire':
> igmp.c:(.text+0x4d4c): undefined reference to `__cmpxchg_called_with_bad_pointer'
> xtensa-linux-ld: net/ipv4/igmp.o: in function `igmp_ifc_timer_expire':
> igmp.c:(.text+0x4dad): undefined reference to `__cmpxchg_called_with_bad_pointer'
>
> Guenter
