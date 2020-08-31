Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35836257F42
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 19:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbgHaRHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 13:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbgHaRHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 13:07:39 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576E5C061573
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 10:07:39 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id w5so6677690wrp.8
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 10:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bXx6EwovJJq6v7wV2BHepyKT/6tHEYC1XWxZ6hHqypk=;
        b=uezbS/BDX0KprnO2yiAcPpIXJbQrdUH2RDXoj9IdjMqW7zHYI8mxKVoyA+sqzabBYm
         sGKqTPVkntp5W65eKlOs5tPtc1M+yXqi7lPy5nuo79xfBQKwwf0BzwEJBacaiskoOEI5
         o42btmSKp0RelQTOLTt0Lc7ir9k32ejZtMDlXr4eOTH4vmMWUmsptGxXPiOQbYGn1ZWm
         xHuBhWUghPAnK35WYmSDS70zEmmaKnDVPK2K5+xYRbGuC5+pPY39AvV1mgKLy23dxGw7
         x6LK8UCLBrlIof58zVSiFTf2iROVRcCWJ8vF8hYnWA8aUPHgb6k2BYWNhSS+yJACnaJo
         SkIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bXx6EwovJJq6v7wV2BHepyKT/6tHEYC1XWxZ6hHqypk=;
        b=AQ9TRqaS1mHIQ2q3dMbElHYdS2e67R9unf3M/q759L6AuXb+Sq2FzxcTS5ohJsQ3HY
         OqVhPTsoOLITGvCUoaPjhsFnOSaav806RfQRI94NCbu0Nk/1UfAIPezg9s4495N95CIY
         XLsmaPA7WTjjQcr4HH9sQ5N4FoqwWCTcpIpT8mTdQ0JDFbBR1jv5dfdWSIXMplj96Wbj
         sem2RbVaakhkgrCyU2cvPxigyFzN09v6fn/efaDMNZPO5nLn0LJA/hu1hbXpLKFieJB7
         PavqZcwgE8y8NN/np8G+2uMA6BbrA/NGhNnkRqIZbf0gdr1JCgEZN9D0giaDtROGpzzl
         hl/Q==
X-Gm-Message-State: AOAM53198VZ+oisoWJpVMK9L2nsZVdL0pAzg1RFy9W8Z2I8OfR5aKV8/
        6wdzpgqEovmGwn5maOJ94Z0=
X-Google-Smtp-Source: ABdhPJwNX4IzAsejnTCGgNZnKGLJAlWt4yZaiinLomJOeETFpXazlu5J6FeDSiwSBGg3BbeJVLsGSg==
X-Received: by 2002:adf:e647:: with SMTP id b7mr2701701wrn.220.1598893658004;
        Mon, 31 Aug 2020 10:07:38 -0700 (PDT)
Received: from [192.168.8.147] ([37.164.27.66])
        by smtp.gmail.com with ESMTPSA id h5sm13524658wrc.45.2020.08.31.10.07.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2020 10:07:37 -0700 (PDT)
Subject: Re: [net-next] tipc: fix use-after-free in tipc_bcast_get_mode
To:     Hoang Huu Le <hoang.h.le@dektech.com.au>, jmaloy@redhat.com,
        maloy@donjonn.com, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Cc:     syzbot+6ea1f7a8df64596ef4d7@syzkaller.appspotmail.com,
        syzbot+e9cc557752ab126c1b99@syzkaller.appspotmail.com
References: <20200827025651.52652-1-hoang.h.le@dektech.com.au>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a30db796-f077-a706-fdc2-d55bb7be3c60@gmail.com>
Date:   Mon, 31 Aug 2020 19:07:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200827025651.52652-1-hoang.h.le@dektech.com.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/26/20 7:56 PM, Hoang Huu Le wrote:
> Syzbot has reported those issues as:
> 
> ==================================================================
> BUG: KASAN: use-after-free in tipc_bcast_get_mode+0x3ab/0x400 net/tipc/bcast.c:759
> Read of size 1 at addr ffff88805e6b3571 by task kworker/0:6/3850
> 
> CPU: 0 PID: 3850 Comm: kworker/0:6 Not tainted 5.8.0-rc7-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: events tipc_net_finalize_work
> 
> Thread 1's call trace:
> [...]
>   kfree+0x103/0x2c0 mm/slab.c:3757 <- bcbase releasing
>   tipc_bcast_stop+0x1b0/0x2f0 net/tipc/bcast.c:721
>   tipc_exit_net+0x24/0x270 net/tipc/core.c:112
> [...]
> 
> Thread 2's call trace:
> [...]
>   tipc_bcast_get_mode+0x3ab/0x400 net/tipc/bcast.c:759 <- bcbase
> has already been freed by Thread 1
> 
>   tipc_node_broadcast+0x9e/0xcc0 net/tipc/node.c:1744
>   tipc_nametbl_publish+0x60b/0x970 net/tipc/name_table.c:752
>   tipc_net_finalize net/tipc/net.c:141 [inline]
>   tipc_net_finalize+0x1fa/0x310 net/tipc/net.c:131
>   tipc_net_finalize_work+0x55/0x80 net/tipc/net.c:150
> [...]
> 
> ==================================================================
> BUG: KASAN: use-after-free in tipc_named_reinit+0xef/0x290 net/tipc/name_distr.c:344
> Read of size 8 at addr ffff888052ab2000 by task kworker/0:13/30628
> CPU: 0 PID: 30628 Comm: kworker/0:13 Not tainted 5.8.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: events tipc_net_finalize_work
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x1f0/0x31e lib/dump_stack.c:118
>  print_address_description+0x66/0x5a0 mm/kasan/report.c:383
>  __kasan_report mm/kasan/report.c:513 [inline]
>  kasan_report+0x132/0x1d0 mm/kasan/report.c:530
>  tipc_named_reinit+0xef/0x290 net/tipc/name_distr.c:344
>  tipc_net_finalize+0x85/0xe0 net/tipc/net.c:138
>  tipc_net_finalize_work+0x50/0x70 net/tipc/net.c:150
>  process_one_work+0x789/0xfc0 kernel/workqueue.c:2269
>  worker_thread+0xaa4/0x1460 kernel/workqueue.c:2415
>  kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
> [...]
> Freed by task 14058:
>  save_stack mm/kasan/common.c:48 [inline]
>  set_track mm/kasan/common.c:56 [inline]
>  kasan_set_free_info mm/kasan/common.c:316 [inline]
>  __kasan_slab_free+0x114/0x170 mm/kasan/common.c:455
>  __cache_free mm/slab.c:3426 [inline]
>  kfree+0x10a/0x220 mm/slab.c:3757
>  tipc_exit_net+0x29/0x50 net/tipc/core.c:113
>  ops_exit_list net/core/net_namespace.c:186 [inline]
>  cleanup_net+0x708/0xba0 net/core/net_namespace.c:603
>  process_one_work+0x789/0xfc0 kernel/workqueue.c:2269
>  worker_thread+0xaa4/0x1460 kernel/workqueue.c:2415
>  kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
> 
> Fix it by calling flush_scheduled_work() to make sure the
> tipc_net_finalize_work() stopped before releasing bcbase object.
> 
> Reported-by: syzbot+6ea1f7a8df64596ef4d7@syzkaller.appspotmail.com
> Reported-by: syzbot+e9cc557752ab126c1b99@syzkaller.appspotmail.com
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Hoang Huu Le <hoang.h.le@dektech.com.au>
> ---
>  net/tipc/core.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/tipc/core.c b/net/tipc/core.c
> index 4f6dc74adf45..37d8695548cf 100644
> --- a/net/tipc/core.c
> +++ b/net/tipc/core.c
> @@ -109,6 +109,11 @@ static void __net_exit tipc_exit_net(struct net *net)
>  {
>  	tipc_detach_loopback(net);
>  	tipc_net_stop(net);
> +
> +	/* Make sure the tipc_net_finalize_work stopped
> +	 * before releasing the resources.
> +	 */
> +	flush_scheduled_work();
>  	tipc_bcast_stop(net);
>  	tipc_nametbl_stop(net);
>  	tipc_sk_rht_destroy(net);
> 

Lockdep disagrees with this change.

======================================================
WARNING: possible circular locking dependency detected
5.9.0-rc2-next-20200828-syzkaller #0 Not tainted
------------------------------------------------------
kworker/u4:5/197 is trying to acquire lock:
ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: flush_workqueue+0xe1/0x13e0 kernel/workqueue.c:2777

but task is already holding lock:
ffffffff8a879430 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x9b/0xb10 net/core/net_namespace.c:565

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (pernet_ops_rwsem){++++}-{3:3}:
       down_write+0x8d/0x150 kernel/locking/rwsem.c:1531
       unregister_netdevice_notifier+0x1e/0x170 net/core/dev.c:1861
       bcm_release+0x94/0x750 net/can/bcm.c:1474
       __sock_release+0xcd/0x280 net/socket.c:596
       sock_close+0x18/0x20 net/socket.c:1277
       __fput+0x285/0x920 fs/file_table.c:281
       task_work_run+0xdd/0x190 kernel/task_work.c:141
       tracehook_notify_resume include/linux/tracehook.h:188 [inline]
       exit_to_user_mode_loop kernel/entry/common.c:140 [inline]
       exit_to_user_mode_prepare+0x195/0x1c0 kernel/entry/common.c:167
       syscall_exit_to_user_mode+0x59/0x2b0 kernel/entry/common.c:242
       entry_SYSCALL_64_after_hwframe+0x44/0xa9

-> #2 (&sb->s_type->i_mutex_key#13){+.+.}-{3:3}:
       down_write+0x8d/0x150 kernel/locking/rwsem.c:1531
       inode_lock include/linux/fs.h:779 [inline]
       __sock_release+0x86/0x280 net/socket.c:595
       sock_close+0x18/0x20 net/socket.c:1277
       __fput+0x285/0x920 fs/file_table.c:281
       delayed_fput+0x56/0x70 fs/file_table.c:309
       process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
       worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
       kthread+0x3b5/0x4a0 kernel/kthread.c:292
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

-> #1 ((delayed_fput_work).work){+.+.}-{0:0}:
       process_one_work+0x8bb/0x1670 kernel/workqueue.c:2245
       worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
       kthread+0x3b5/0x4a0 kernel/kthread.c:292
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

-> #0 ((wq_completion)events){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:2496 [inline]
       check_prevs_add kernel/locking/lockdep.c:2601 [inline]
       validate_chain kernel/locking/lockdep.c:3218 [inline]
       __lock_acquire+0x2a6b/0x5640 kernel/locking/lockdep.c:4426
       lock_acquire+0x1f1/0xad0 kernel/locking/lockdep.c:5005
       flush_workqueue+0x110/0x13e0 kernel/workqueue.c:2780
       flush_scheduled_work include/linux/workqueue.h:597 [inline]
       tipc_exit_net+0x47/0x2a0 net/tipc/core.c:116
       ops_exit_list+0xb0/0x160 net/core/net_namespace.c:186
       cleanup_net+0x4ea/0xb10 net/core/net_namespace.c:603
       process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
       worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
       kthread+0x3b5/0x4a0 kernel/kthread.c:292
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

other info that might help us debug this:

Chain exists of:
  (wq_completion)events --> &sb->s_type->i_mutex_key#13 --> pernet_ops_rwsem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(pernet_ops_rwsem);
                               lock(&sb->s_type->i_mutex_key#13);
                               lock(pernet_ops_rwsem);
  lock((wq_completion)events);

 *** DEADLOCK ***

3 locks held by kworker/u4:5/197:
 #0: ffff8880a97b1138 ((wq_completion)netns){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880a97b1138 ((wq_completion)netns){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880a97b1138 ((wq_completion)netns){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880a97b1138 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880a97b1138 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880a97b1138 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc90001107da8 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffffffff8a879430 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x9b/0xb10 net/core/net_namespace.c:565

stack backtrace:
CPU: 0 PID: 197 Comm: kworker/u4:5 Not tainted 5.9.0-rc2-next-20200828-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 check_noncircular+0x324/0x3e0 kernel/locking/lockdep.c:1827
 check_prev_add kernel/locking/lockdep.c:2496 [inline]
 check_prevs_add kernel/locking/lockdep.c:2601 [inline]
 validate_chain kernel/locking/lockdep.c:3218 [inline]
 __lock_acquire+0x2a6b/0x5640 kernel/locking/lockdep.c:4426
 lock_acquire+0x1f1/0xad0 kernel/locking/lockdep.c:5005
 flush_workqueue+0x110/0x13e0 kernel/workqueue.c:2780
 flush_scheduled_work include/linux/workqueue.h:597 [inline]
 tipc_exit_net+0x47/0x2a0 net/tipc/core.c:116
 ops_exit_list+0xb0/0x160 net/core/net_namespace.c:186
 cleanup_net+0x4ea/0xb10 net/core/net_namespace.c:603
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
