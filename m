Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36CE96482B3
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 14:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiLINPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 08:15:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiLINPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 08:15:47 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BFEFA27CCC;
        Fri,  9 Dec 2022 05:15:44 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1554323A;
        Fri,  9 Dec 2022 05:15:51 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.39.232])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 70B243F73B;
        Fri,  9 Dec 2022 05:15:42 -0800 (PST)
Date:   Fri, 9 Dec 2022 13:15:39 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     syzbot <syzbot+09329bd987ebca21bced@syzkaller.appspotmail.com>
Cc:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        jakub@cloudflare.com, john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [syzbot] kernel stack overflow in sock_close
Message-ID: <Y5M0+1bJ/A/M3xKU@FVFF77S0Q05N>
References: <000000000000b2d33705ef4e2d70@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000b2d33705ef4e2d70@google.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Dec 08, 2022 at 02:05:36AM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    e3cb714fb489 Merge branch 'for-next/core' into for-kernelci

This commit has a known-broken parent where some uaccess copies appeared to
result in stack corruption:

  https://lore.kernel.org/linux-arm-kernel/Y44gVm7IEMXqilef@FVFF77S0Q05N.cambridge.arm.com/

... which has now been dropped from the arm64 for-next/core branch, but
anything found on commit e3cb714fb489 will be suspect due to that.

This *might* a manifestation of the same issue; I'll have a go at reproducing
it locally.

Thanks,
Mark.

> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=13d5c11d880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ec7118319bfb771e
> dashboard link: https://syzkaller.appspot.com/bug?extid=09329bd987ebca21bced
> compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
> userspace arch: arm64
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=145daef3880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1313d497880000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/832eb1866f2c/disk-e3cb714f.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/5fd572b7d96d/vmlinux-e3cb714f.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/34c82908beda/Image-e3cb714f.gz.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+09329bd987ebca21bced@syzkaller.appspotmail.com
> 
> x8 : 0000000000040574 x7 : ffff80000b22f58c x6 : 0000000000000000
> x5 : 0000000000000000 x4 : 0000000000000001 x3 : 0000000000000000
> x2 : 0000000000000002 x1 : ffff0000c60f3eb8 x0 : ffff0000c60f3480
> Kernel panic - not syncing: kernel stack overflow
> CPU: 1 PID: 3074 Comm: syz-executor169 Not tainted 6.1.0-rc7-syzkaller-33097-ge3cb714fb489 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/30/2022
> Call trace:
>  dump_backtrace+0x1c4/0x1f0 arch/arm64/kernel/stacktrace.c:156
>  show_stack+0x2c/0x54 arch/arm64/kernel/stacktrace.c:163
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0x104/0x16c lib/dump_stack.c:106
>  dump_stack+0x1c/0x58 lib/dump_stack.c:113
>  panic+0x218/0x508 kernel/panic.c:274
>  nmi_panic+0xbc/0xf0 kernel/panic.c:169
>  panic_bad_stack+0x134/0x154 arch/arm64/kernel/traps.c:886
>  handle_bad_stack+0x34/0x48 arch/arm64/kernel/entry-common.c:849
>  __bad_stack+0x78/0x7c arch/arm64/kernel/entry.S:552
>  mark_lock+0x4/0x1b4 kernel/locking/lockdep.c:4595
>  lock_acquire+0x100/0x1f8 kernel/locking/lockdep.c:5668
>  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:126 [inline]
>  _raw_spin_lock_bh+0x54/0x6c kernel/locking/spinlock.c:178
>  spin_lock_bh include/linux/spinlock.h:355 [inline]
>  lock_sock_nested+0x88/0xd8 net/core/sock.c:3450
>  lock_sock include/net/sock.h:1721 [inline]
>  sock_map_close+0x30/0x4bc net/core/sock_map.c:1610
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  sock_map_close+0x400/0x4bc
>  inet_release+0xc8/0xe4 net/ipv4/af_inet.c:428
>  inet6_release+0x3c/0x58 net/ipv6/af_inet6.c:488
>  __sock_release net/socket.c:650 [inline]
>  sock_close+0x50/0xf0 net/socket.c:1365
>  __fput+0x198/0x3e4 fs/file_table.c:320
>  ____fput+0x20/0x30 fs/file_table.c:348
>  task_work_run+0x100/0x148 kernel/task_work.c:179
>  exit_task_work include/linux/task_work.h:38 [inline]
>  do_exit+0x2dc/0xcac kernel/exit.c:820
>  do_group_exit+0x98/0xcc kernel/exit.c:950
>  get_signal+0xabc/0xb2c kernel/signal.c:2858
>  do_signal+0x128/0x438 arch/arm64/kernel/signal.c:1076
>  do_notify_resume+0xc0/0x1f0 arch/arm64/kernel/signal.c:1129
>  prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
>  exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
>  el0_svc+0x9c/0x150 arch/arm64/kernel/entry-common.c:638
>  el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
>  el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:584
> SMP: stopping secondary CPUs
> Kernel Offset: disabled
> CPU features: 0x00000,040e0108,4c017203
> Memory Limit: none
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
