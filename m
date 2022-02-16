Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5104B7F61
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 05:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344474AbiBPESO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 23:18:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344252AbiBPERn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 23:17:43 -0500
Received: from lgeamrelo11.lge.com (lgeamrelo12.lge.com [156.147.23.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 56BD583036
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 20:17:10 -0800 (PST)
Received: from unknown (HELO lgeamrelo04.lge.com) (156.147.1.127)
        by 156.147.23.52 with ESMTP; 16 Feb 2022 13:17:09 +0900
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
Subject: Report in unix_stream_sendmsg()
Date:   Wed, 16 Feb 2022 13:17:04 +0900
Message-Id: <1644985024-28757-2-git-send-email-byungchul.park@lge.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1644985024-28757-1-git-send-email-byungchul.park@lge.com>
References: <1644984767-26886-1-git-send-email-byungchul.park@lge.com>
 <1644985024-28757-1-git-send-email-byungchul.park@lge.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[    7.008968] ===================================================
[    7.008973] DEPT: Circular dependency has been detected.
[    7.008974] 5.17.0-rc1-00014-gcf3441bb2012 #2 Tainted: G        W        
[    7.008975] ---------------------------------------------------
[    7.008976] summary
[    7.008976] ---------------------------------------------------
[    7.008980] *** DEADLOCK ***
[    7.008980] 
[    7.008981] context A
[    7.008982]     [S] (unknown)(&(&ei->socket.wq.wait)->dmap:0)
[    7.008983]     [W] __raw_spin_lock(&u->lock:0)
[    7.008984]     [E] event(&(&ei->socket.wq.wait)->dmap:0)
[    7.008986] 
[    7.008986] context B
[    7.008987]     [S] __raw_spin_lock(&u->lock:0)
[    7.008988]     [W] wait(&(&ei->socket.wq.wait)->dmap:0)
[    7.008989]     [E] spin_unlock(&u->lock:0)
[    7.008990] 
[    7.008991] [S]: start of the event context
[    7.008991] [W]: the wait blocked
[    7.008992] [E]: the event not reachable
[    7.008992] ---------------------------------------------------
[    7.008993] context A's detail
[    7.008994] ---------------------------------------------------
[    7.008994] context A
[    7.008995]     [S] (unknown)(&(&ei->socket.wq.wait)->dmap:0)
[    7.008996]     [W] __raw_spin_lock(&u->lock:0)
[    7.008997]     [E] event(&(&ei->socket.wq.wait)->dmap:0)
[    7.008998] 
[    7.008999] [S] (unknown)(&(&ei->socket.wq.wait)->dmap:0):
[    7.009000] (N/A)
[    7.009000] 
[    7.009001] [W] __raw_spin_lock(&u->lock:0):
[    7.009002] [<ffffffff81aa5c24>] unix_stream_sendmsg+0x294/0x590
[    7.009006] stacktrace:
[    7.009007]       _raw_spin_lock+0x4b/0x90
[    7.009010]       unix_stream_sendmsg+0x294/0x590
[    7.009011]       sock_sendmsg+0x56/0x60
[    7.009015]       sock_write_iter+0x82/0xe0
[    7.009017]       new_sync_write+0x16d/0x190
[    7.009020]       vfs_write+0x134/0x360
[    7.009022]       ksys_write+0xa6/0xc0
[    7.009023]       do_syscall_64+0x3a/0x90
[    7.009026]       entry_SYSCALL_64_after_hwframe+0x44/0xae
[    7.009028] 
[    7.009028] [E] event(&(&ei->socket.wq.wait)->dmap:0):
[    7.009029] [<ffffffff810baa53>] __wake_up_common+0x93/0x1a0
[    7.009031] stacktrace:
[    7.009032]       dept_event+0x12b/0x1f0
[    7.009035]       __wake_up_common+0xb0/0x1a0
[    7.009036]       __wake_up_common_lock+0x65/0x90
[    7.009037]       sock_def_readable+0x5c/0xe0
[    7.009040]       unix_stream_sendmsg+0x19a/0x590
[    7.009041]       sock_sendmsg+0x56/0x60
[    7.009043]       sock_write_iter+0x82/0xe0
[    7.009045]       new_sync_write+0x16d/0x190
[    7.009047]       vfs_write+0x134/0x360
[    7.009049]       ksys_write+0xa6/0xc0
[    7.009050]       do_syscall_64+0x3a/0x90
[    7.009052]       entry_SYSCALL_64_after_hwframe+0x44/0xae
[    7.009054] ---------------------------------------------------
[    7.009054] context B's detail
[    7.009055] ---------------------------------------------------
[    7.009057] context B
[    7.009057]     [S] __raw_spin_lock(&u->lock:0)
[    7.009059]     [W] wait(&(&ei->socket.wq.wait)->dmap:0)
[    7.009060]     [E] spin_unlock(&u->lock:0)
[    7.009061] 
[    7.009061] [S] __raw_spin_lock(&u->lock:0):
[    7.009062] [<ffffffff81aa451f>] unix_stream_read_generic+0x6bf/0xb60
[    7.009066] stacktrace:
[    7.009067]       _raw_spin_lock+0x6e/0x90
[    7.009068]       unix_stream_read_generic+0x6bf/0xb60
[    7.009071]       unix_stream_recvmsg+0x40/0x50
[    7.009073]       sock_read_iter+0x85/0xd0
[    7.009074]       new_sync_read+0x162/0x180
[    7.009076]       vfs_read+0xf3/0x190
[    7.009078]       ksys_read+0xa6/0xc0
[    7.009079]       do_syscall_64+0x3a/0x90
[    7.009081]       entry_SYSCALL_64_after_hwframe+0x44/0xae
[    7.009083] 
[    7.009084] [W] wait(&(&ei->socket.wq.wait)->dmap:0):
[    7.009085] [<ffffffff810bb017>] prepare_to_wait+0x47/0xd0
[    7.009087] stacktrace:
[    7.009087]       unix_stream_read_generic+0x6fa/0xb60
[    7.009089]       unix_stream_recvmsg+0x40/0x50
[    7.009091]       sock_read_iter+0x85/0xd0
[    7.009093]       new_sync_read+0x162/0x180
[    7.009095]       vfs_read+0xf3/0x190
[    7.009097]       ksys_read+0xa6/0xc0
[    7.009098]       do_syscall_64+0x3a/0x90
[    7.009100]       entry_SYSCALL_64_after_hwframe+0x44/0xae
[    7.009102] 
[    7.009102] [E] spin_unlock(&u->lock:0):
[    7.009103] [<ffffffff81aa45df>] unix_stream_read_generic+0x77f/0xb60
[    7.009106] stacktrace:
[    7.009107]       _raw_spin_unlock+0x30/0x70
[    7.009108]       unix_stream_read_generic+0x77f/0xb60
[    7.009110]       unix_stream_recvmsg+0x40/0x50
[    7.009113]       sock_read_iter+0x85/0xd0
[    7.009114]       new_sync_read+0x162/0x180
[    7.009116]       vfs_read+0xf3/0x190
[    7.009118]       ksys_read+0xa6/0xc0
[    7.009119]       do_syscall_64+0x3a/0x90
[    7.009121]       entry_SYSCALL_64_after_hwframe+0x44/0xae
[    7.009123] ---------------------------------------------------
[    7.009124] information that might be helpful
[    7.009124] ---------------------------------------------------
[    7.009125] CPU: 2 PID: 641 Comm: avahi-daemon Tainted: G        W         5.17.0-rc1-00014-gcf3441bb2012 #2
[    7.009128] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
[    7.009129] Call Trace:
[    7.009130]  <TASK>
[    7.009131]  dump_stack_lvl+0x44/0x57
[    7.009134]  print_circle+0x384/0x510
[    7.009136]  ? print_circle+0x510/0x510
[    7.009138]  cb_check_dl+0x58/0x60
[    7.009139]  bfs+0xdc/0x1b0
[    7.009142]  add_dep+0x94/0x120
[    7.009144]  do_event.isra.22+0x284/0x300
[    7.009146]  ? __wake_up_common+0x93/0x1a0
[    7.009147]  dept_event+0x12b/0x1f0
[    7.009149]  __wake_up_common+0xb0/0x1a0
[    7.009151]  __wake_up_common_lock+0x65/0x90
[    7.009153]  sock_def_readable+0x5c/0xe0
[    7.009155]  unix_stream_sendmsg+0x19a/0x590
[    7.009158]  sock_sendmsg+0x56/0x60
[    7.009160]  sock_write_iter+0x82/0xe0
[    7.009163]  new_sync_write+0x16d/0x190
[    7.009166]  vfs_write+0x134/0x360
[    7.009169]  ksys_write+0xa6/0xc0
[    7.009170]  ? trace_hardirqs_on+0x38/0xe0
[    7.009173]  do_syscall_64+0x3a/0x90
[    7.009175]  entry_SYSCALL_64_after_hwframe+0x44/0xae
