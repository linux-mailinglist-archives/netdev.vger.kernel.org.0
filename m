Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA5D4B7F64
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 05:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344483AbiBPESQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 23:18:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344304AbiBPERn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 23:17:43 -0500
X-Greylist: delayed 257 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 15 Feb 2022 20:17:10 PST
Received: from lgeamrelo11.lge.com (lgeamrelo13.lge.com [156.147.23.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2DAFA7F6E8
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 20:17:09 -0800 (PST)
Received: from unknown (HELO lgeamrelo04.lge.com) (156.147.1.127)
        by 156.147.23.53 with ESMTP; 16 Feb 2022 13:17:09 +0900
X-Original-SENDERIP: 156.147.1.127
X-Original-MAILFROM: byungchul.park@lge.com
Received: from unknown (HELO localhost.localdomain) (10.177.244.38)
        by 156.147.1.127 with ESMTP; 16 Feb 2022 13:17:09 +0900
X-Original-SENDERIP: 10.177.244.38
X-Original-MAILFROM: byungchul.park@lge.com
From:   Byungchul Park <byungchul.park@lge.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     torvalds@linux-foundation.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        will@kernel.org, tglx@linutronix.de, rostedt@goodmis.org,
        joel@joelfernandes.org, sashal@kernel.org, daniel.vetter@ffwll.ch,
        chris@chris-wilson.co.uk, duyuyang@gmail.com,
        johannes.berg@intel.com, tj@kernel.org, tytso@mit.edu,
        willy@infradead.org, david@fromorbit.com, amir73il@gmail.com,
        bfields@fieldses.org, gregkh@linuxfoundation.org,
        kernel-team@lge.com, linux-mm@kvack.org, akpm@linux-foundation.org,
        mhocko@kernel.org, minchan@kernel.org, hannes@cmpxchg.org,
        vdavydov.dev@gmail.com, sj@kernel.org, jglisse@redhat.com,
        dennis@kernel.org, cl@linux.com, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz, ngupta@vflare.org,
        linux-block@vger.kernel.org, axboe@kernel.dk,
        paolo.valente@linaro.org, josef@toxicpanda.com,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        jack@suse.cz, jlayton@kernel.org, dan.j.williams@intel.com,
        hch@infradead.org, djwong@kernel.org,
        dri-devel@lists.freedesktop.org, airlied@linux.ie,
        rodrigosiqueiramelo@gmail.com, melissa.srw@gmail.com,
        hamohammed.sa@gmail.com
Subject: Report in unix_stream_read_generic()
Date:   Wed, 16 Feb 2022 13:17:03 +0900
Message-Id: <1644985024-28757-1-git-send-email-byungchul.park@lge.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1644984767-26886-1-git-send-email-byungchul.park@lge.com>
References: <1644984767-26886-1-git-send-email-byungchul.park@lge.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[    7.013330] ===================================================
[    7.013331] DEPT: Circular dependency has been detected.
[    7.013332] 5.17.0-rc1-00014-gcf3441bb2012 #2 Tainted: G        W        
[    7.013333] ---------------------------------------------------
[    7.013334] summary
[    7.013334] ---------------------------------------------------
[    7.013335] *** DEADLOCK ***
[    7.013335] 
[    7.013335] context A
[    7.013336]     [S] (unknown)(&(&ei->socket.wq.wait)->dmap:0)
[    7.013337]     [W] __mutex_lock_common(&u->iolock:0)
[    7.013338]     [E] event(&(&ei->socket.wq.wait)->dmap:0)
[    7.013340] 
[    7.013340] context B
[    7.013341]     [S] __raw_spin_lock(&u->lock:0)
[    7.013342]     [W] wait(&(&ei->socket.wq.wait)->dmap:0)
[    7.013343]     [E] spin_unlock(&u->lock:0)
[    7.013344] 
[    7.013344] context C
[    7.013345]     [S] __mutex_lock_common(&u->iolock:0)
[    7.013346]     [W] __raw_spin_lock(&u->lock:0)
[    7.013347]     [E] mutex_unlock(&u->iolock:0)
[    7.013348] 
[    7.013348] [S]: start of the event context
[    7.013349] [W]: the wait blocked
[    7.013349] [E]: the event not reachable
[    7.013350] ---------------------------------------------------
[    7.013351] context A's detail
[    7.013351] ---------------------------------------------------
[    7.013352] context A
[    7.013352]     [S] (unknown)(&(&ei->socket.wq.wait)->dmap:0)
[    7.013353]     [W] __mutex_lock_common(&u->iolock:0)
[    7.013354]     [E] event(&(&ei->socket.wq.wait)->dmap:0)
[    7.013355] 
[    7.013356] [S] (unknown)(&(&ei->socket.wq.wait)->dmap:0):
[    7.013357] (N/A)
[    7.013357] 
[    7.013358] [W] __mutex_lock_common(&u->iolock:0):
[    7.013359] [<ffffffff81aa4918>] unix_stream_read_generic+0xab8/0xb60
[    7.013362] stacktrace:
[    7.013362]       __mutex_lock+0x52c/0x900
[    7.013364]       unix_stream_read_generic+0xab8/0xb60
[    7.013366]       unix_stream_recvmsg+0x40/0x50
[    7.013368]       ____sys_recvmsg+0x85/0x190
[    7.013370]       ___sys_recvmsg+0x78/0xb0
[    7.013371]       __sys_recvmsg+0x4b/0x80
[    7.013373]       do_syscall_64+0x3a/0x90
[    7.013374]       entry_SYSCALL_64_after_hwframe+0x44/0xae
[    7.013376] 
[    7.013377] [E] event(&(&ei->socket.wq.wait)->dmap:0):
[    7.013378] [<ffffffff810baa53>] __wake_up_common+0x93/0x1a0
[    7.013379] stacktrace:
[    7.013380]       dept_event+0x12b/0x1f0
[    7.013381]       __wake_up_common+0xb0/0x1a0
[    7.013383]       __wake_up_common_lock+0x65/0x90
[    7.013384]       unix_write_space+0x75/0x100
[    7.013386]       sock_wfree+0x68/0xa0
[    7.013387]       unix_destruct_scm+0x66/0x70
[    7.013389]       skb_release_head_state+0x3b/0x90
[    7.013391]       skb_release_all+0x9/0x20
[    7.013393]       consume_skb+0x4c/0xe0
[    7.013394]       unix_stream_read_generic+0xa3c/0xb60
[    7.013397]       unix_stream_recvmsg+0x40/0x50
[    7.013399]       ____sys_recvmsg+0x85/0x190
[    7.013400]       ___sys_recvmsg+0x78/0xb0
[    7.013402]       __sys_recvmsg+0x4b/0x80
[    7.013403]       do_syscall_64+0x3a/0x90
[    7.013405]       entry_SYSCALL_64_after_hwframe+0x44/0xae
[    7.013407] ---------------------------------------------------
[    7.013407] context B's detail
[    7.013408] ---------------------------------------------------
[    7.013408] context B
[    7.013409]     [S] __raw_spin_lock(&u->lock:0)
[    7.013410]     [W] wait(&(&ei->socket.wq.wait)->dmap:0)
[    7.013411]     [E] spin_unlock(&u->lock:0)
[    7.013412] 
[    7.013412] [S] __raw_spin_lock(&u->lock:0):
[    7.013413] [<ffffffff81aa451f>] unix_stream_read_generic+0x6bf/0xb60
[    7.013416] stacktrace:
[    7.013416]       _raw_spin_lock+0x6e/0x90
[    7.013418]       unix_stream_read_generic+0x6bf/0xb60
[    7.013420]       unix_stream_recvmsg+0x40/0x50
[    7.013422]       sock_read_iter+0x85/0xd0
[    7.013424]       new_sync_read+0x162/0x180
[    7.013426]       vfs_read+0xf3/0x190
[    7.013428]       ksys_read+0xa6/0xc0
[    7.013429]       do_syscall_64+0x3a/0x90
[    7.013431]       entry_SYSCALL_64_after_hwframe+0x44/0xae
[    7.013433] 
[    7.013434] [W] wait(&(&ei->socket.wq.wait)->dmap:0):
[    7.013434] [<ffffffff810bb017>] prepare_to_wait+0x47/0xd0
[    7.013436] stacktrace:
[    7.013437]       unix_stream_read_generic+0x6fa/0xb60
[    7.013439]       unix_stream_recvmsg+0x40/0x50
[    7.013441]       sock_read_iter+0x85/0xd0
[    7.013443]       new_sync_read+0x162/0x180
[    7.013445]       vfs_read+0xf3/0x190
[    7.013447]       ksys_read+0xa6/0xc0
[    7.013448]       do_syscall_64+0x3a/0x90
[    7.013449]       entry_SYSCALL_64_after_hwframe+0x44/0xae
[    7.013451] 
[    7.013452] [E] spin_unlock(&u->lock:0):
[    7.013453] [<ffffffff81aa45df>] unix_stream_read_generic+0x77f/0xb60
[    7.013455] stacktrace:
[    7.013456]       _raw_spin_unlock+0x30/0x70
[    7.013457]       unix_stream_read_generic+0x77f/0xb60
[    7.013460]       unix_stream_recvmsg+0x40/0x50
[    7.013462]       sock_read_iter+0x85/0xd0
[    7.013464]       new_sync_read+0x162/0x180
[    7.013465]       vfs_read+0xf3/0x190
[    7.013467]       ksys_read+0xa6/0xc0
[    7.013468]       do_syscall_64+0x3a/0x90
[    7.013470]       entry_SYSCALL_64_after_hwframe+0x44/0xae
[    7.013472] ---------------------------------------------------
[    7.013473] context C's detail
[    7.013473] ---------------------------------------------------
[    7.013474] context C
[    7.013474]     [S] __mutex_lock_common(&u->iolock:0)
[    7.013475]     [W] __raw_spin_lock(&u->lock:0)
[    7.013476]     [E] mutex_unlock(&u->iolock:0)
[    7.013477] 
[    7.013478] [S] __mutex_lock_common(&u->iolock:0):
[    7.013479] [<ffffffff81aa3f40>] unix_stream_read_generic+0xe0/0xb60
[    7.013481] stacktrace:
[    7.013482]       __mutex_lock+0x54d/0x900
[    7.013483]       unix_stream_read_generic+0xe0/0xb60
[    7.013486]       unix_stream_recvmsg+0x40/0x50
[    7.013488]       ____sys_recvmsg+0x85/0x190
[    7.013490]       ___sys_recvmsg+0x78/0xb0
[    7.013491]       __sys_recvmsg+0x4b/0x80
[    7.013492]       do_syscall_64+0x3a/0x90
[    7.013494]       entry_SYSCALL_64_after_hwframe+0x44/0xae
[    7.013496] 
[    7.013496] [W] __raw_spin_lock(&u->lock:0):
[    7.013497] [<ffffffff81aa3f92>] unix_stream_read_generic+0x132/0xb60
[    7.013499] stacktrace:
[    7.013500]       _raw_spin_lock+0x4b/0x90
[    7.013502]       unix_stream_read_generic+0x132/0xb60
[    7.013504]       unix_stream_recvmsg+0x40/0x50
[    7.013506]       ____sys_recvmsg+0x85/0x190
[    7.013508]       ___sys_recvmsg+0x78/0xb0
[    7.013509]       __sys_recvmsg+0x4b/0x80
[    7.013510]       do_syscall_64+0x3a/0x90
[    7.013512]       entry_SYSCALL_64_after_hwframe+0x44/0xae
[    7.013514] 
[    7.013514] [E] mutex_unlock(&u->iolock:0):
[    7.013515] [<ffffffff81aa4058>] unix_stream_read_generic+0x1f8/0xb60
[    7.013518] stacktrace:
[    7.013518]       __mutex_unlock_slowpath+0x49/0x2a0
[    7.013520]       unix_stream_read_generic+0x1f8/0xb60
[    7.013522]       unix_stream_recvmsg+0x40/0x50
[    7.013524]       ____sys_recvmsg+0x85/0x190
[    7.013526]       ___sys_recvmsg+0x78/0xb0
[    7.013527]       __sys_recvmsg+0x4b/0x80
[    7.013528]       do_syscall_64+0x3a/0x90
[    7.013530]       entry_SYSCALL_64_after_hwframe+0x44/0xae
[    7.013532] ---------------------------------------------------
[    7.013532] information that might be helpful
[    7.013533] ---------------------------------------------------
[    7.013534] CPU: 2 PID: 641 Comm: avahi-daemon Tainted: G        W         5.17.0-rc1-00014-gcf3441bb2012 #2
[    7.013535] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
[    7.013536] Call Trace:
[    7.013537]  <TASK>
[    7.013538]  dump_stack_lvl+0x44/0x57
[    7.013540]  print_circle+0x384/0x510
[    7.013542]  ? print_circle+0x510/0x510
[    7.013544]  cb_check_dl+0x58/0x60
[    7.013545]  bfs+0xdc/0x1b0
[    7.013548]  add_dep+0x94/0x120
[    7.013550]  do_event.isra.22+0x284/0x300
[    7.013552]  ? __wake_up_common+0x93/0x1a0
[    7.013553]  dept_event+0x12b/0x1f0
[    7.013555]  __wake_up_common+0xb0/0x1a0
[    7.013557]  __wake_up_common_lock+0x65/0x90
[    7.013559]  unix_write_space+0x75/0x100
[    7.013562]  sock_wfree+0x68/0xa0
[    7.013564]  unix_destruct_scm+0x66/0x70
[    7.013565]  skb_release_head_state+0x3b/0x90
[    7.013568]  skb_release_all+0x9/0x20
[    7.013570]  consume_skb+0x4c/0xe0
[    7.013572]  unix_stream_read_generic+0xa3c/0xb60
[    7.013575]  ? prepare_to_wait_exclusive+0xa0/0xa0
[    7.013577]  unix_stream_recvmsg+0x40/0x50
[    7.013580]  ? unix_state_double_unlock+0x40/0x40
[    7.013582]  ____sys_recvmsg+0x85/0x190
[    7.013584]  ? __import_iovec+0xd1/0x140
[    7.013587]  ? import_iovec+0x17/0x20
[    7.013589]  ? copy_msghdr_from_user+0x47/0x60
[    7.013591]  ___sys_recvmsg+0x78/0xb0
[    7.013593]  ? trace_hardirqs_on+0x38/0xe0
[    7.013595]  ? finish_task_switch+0xf3/0x2a0
[    7.013598]  ? __sys_recvmsg+0x4b/0x80
[    7.013599]  __sys_recvmsg+0x4b/0x80
[    7.013601]  do_syscall_64+0x3a/0x90
[    7.013603]  entry_SYSCALL_64_after_hwframe+0x44/0xae
