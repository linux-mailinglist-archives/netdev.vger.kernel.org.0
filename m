Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70862201E1A
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 00:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729462AbgFSWiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 18:38:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57591 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729446AbgFSWiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 18:38:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592606302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=XBAMFpt5mjO6ZLivpEHGRQaVi/mePmSG2aOyU0W9mDw=;
        b=dsGqYXHAvLFU9nQQy2LiuxKvDNogqfG9L1lHooqFirOScDtHXk1VtibndvnzFK1SgUWchP
        /QQ0bsLuu0fhsxtsgR/riaW4r++JKHXVGtY/6Ps/JtGjpDRXmOUuiCThFzTc6CsRtc/jNY
        yST7NEwvggRaIuzX4xFxN8ppZXlieoM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-1R9FaN5OPNGXF6gjH2a0jA-1; Fri, 19 Jun 2020 18:38:19 -0400
X-MC-Unique: 1R9FaN5OPNGXF6gjH2a0jA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1A261005512;
        Fri, 19 Jun 2020 22:38:17 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-114-66.rdu2.redhat.com [10.10.114.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C9E5F7166E;
        Fri, 19 Jun 2020 22:38:16 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net] rxrpc: Fix notification call on completion of discarded
 calls
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     syzbot+d3eccef36ddbd02713e9@syzkaller.appspotmail.com,
        dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 19 Jun 2020 23:38:16 +0100
Message-ID: <159260629601.2218121.13958646181773576175.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.22
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When preallocated service calls are being discarded, they're passed to
->discard_new_call() to have the caller clean up any attached higher-layer
preallocated pieces before being marked completed.  However, the act of
marking them completed now invokes the call's notification function - which
causes a problem because that function might assume that the previously
freed pieces of memory are still there.

Fix this by setting a dummy notification function on the socket after
calling ->discard_new_call().

This results in the following kasan message when the kafs module is
removed.

==================================================================
BUG: KASAN: use-after-free in afs_wake_up_async_call+0x6aa/0x770 fs/afs/rxrpc.c:707
Write of size 1 at addr ffff8880946c39e4 by task kworker/u4:1/21

CPU: 0 PID: 21 Comm: kworker/u4:1 Not tainted 5.8.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x413 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 afs_wake_up_async_call+0x6aa/0x770 fs/afs/rxrpc.c:707
 rxrpc_notify_socket+0x1db/0x5d0 net/rxrpc/recvmsg.c:40
 __rxrpc_set_call_completion.part.0+0x172/0x410 net/rxrpc/recvmsg.c:76
 __rxrpc_call_completed net/rxrpc/recvmsg.c:112 [inline]
 rxrpc_call_completed+0xca/0xf0 net/rxrpc/recvmsg.c:111
 rxrpc_discard_prealloc+0x781/0xab0 net/rxrpc/call_accept.c:233
 rxrpc_listen+0x147/0x360 net/rxrpc/af_rxrpc.c:245
 afs_close_socket+0x95/0x320 fs/afs/rxrpc.c:110
 afs_net_exit+0x1bc/0x310 fs/afs/main.c:155
 ops_exit_list.isra.0+0xa8/0x150 net/core/net_namespace.c:186
 cleanup_net+0x511/0xa50 net/core/net_namespace.c:603
 process_one_work+0x965/0x1690 kernel/workqueue.c:2269
 worker_thread+0x96/0xe10 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

Allocated by task 6820:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc mm/kasan/common.c:494 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:467
 kmem_cache_alloc_trace+0x153/0x7d0 mm/slab.c:3551
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 afs_alloc_call+0x55/0x630 fs/afs/rxrpc.c:141
 afs_charge_preallocation+0xe9/0x2d0 fs/afs/rxrpc.c:757
 afs_open_socket+0x292/0x360 fs/afs/rxrpc.c:92
 afs_net_init+0xa6c/0xe30 fs/afs/main.c:125
 ops_init+0xaf/0x420 net/core/net_namespace.c:151
 setup_net+0x2de/0x860 net/core/net_namespace.c:341
 copy_net_ns+0x293/0x590 net/core/net_namespace.c:482
 create_new_namespaces+0x3fb/0xb30 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xbd/0x1f0 kernel/nsproxy.c:231
 ksys_unshare+0x43d/0x8e0 kernel/fork.c:2983
 __do_sys_unshare kernel/fork.c:3051 [inline]
 __se_sys_unshare kernel/fork.c:3049 [inline]
 __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3049
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 21:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0xf7/0x140 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x109/0x2b0 mm/slab.c:3757
 afs_put_call+0x585/0xa40 fs/afs/rxrpc.c:190
 rxrpc_discard_prealloc+0x764/0xab0 net/rxrpc/call_accept.c:230
 rxrpc_listen+0x147/0x360 net/rxrpc/af_rxrpc.c:245
 afs_close_socket+0x95/0x320 fs/afs/rxrpc.c:110
 afs_net_exit+0x1bc/0x310 fs/afs/main.c:155
 ops_exit_list.isra.0+0xa8/0x150 net/core/net_namespace.c:186
 cleanup_net+0x511/0xa50 net/core/net_namespace.c:603
 process_one_work+0x965/0x1690 kernel/workqueue.c:2269
 worker_thread+0x96/0xe10 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

The buggy address belongs to the object at ffff8880946c3800
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 484 bytes inside of
 1024-byte region [ffff8880946c3800, ffff8880946c3c00)
The buggy address belongs to the page:
page:ffffea000251b0c0 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea0002546508 ffffea00024fa248 ffff8880aa000c40
raw: 0000000000000000 ffff8880946c3000 0000000100000002 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880946c3880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880946c3900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8880946c3980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                       ^
 ffff8880946c3a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880946c3a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

Reported-by: syzbot+d3eccef36ddbd02713e9@syzkaller.appspotmail.com
Fixes: 5ac0d62226a0 ("rxrpc: Fix missing notification")
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/call_accept.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index b7611cc159e5..032ed76c0166 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -22,6 +22,11 @@
 #include <net/ip.h>
 #include "ar-internal.h"
 
+static void rxrpc_dummy_notify(struct sock *sk, struct rxrpc_call *call,
+			       unsigned long user_call_ID)
+{
+}
+
 /*
  * Preallocate a single service call, connection and peer and, if possible,
  * give them a user ID and attach the user's side of the ID to them.
@@ -228,6 +233,8 @@ void rxrpc_discard_prealloc(struct rxrpc_sock *rx)
 		if (rx->discard_new_call) {
 			_debug("discard %lx", call->user_call_ID);
 			rx->discard_new_call(call, call->user_call_ID);
+			if (call->notify_rx)
+				call->notify_rx = rxrpc_dummy_notify;
 			rxrpc_put_call(call, rxrpc_call_put_kernel);
 		}
 		rxrpc_call_completed(call);


