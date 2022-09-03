Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95F715AC14C
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 22:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233366AbiICUJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 16:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiICUJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 16:09:41 -0400
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2C1140A6;
        Sat,  3 Sep 2022 13:09:39 -0700 (PDT)
Received: by mail-io1-f47.google.com with SMTP id r141so4252850iod.4;
        Sat, 03 Sep 2022 13:09:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=Dcvr1AnDFIH5RK4jgdINjGbjfe3u4+AR2ebM5VrOJ5Y=;
        b=oK1QyKhX+4zUpv44FjAy8mxB8QK0FSI7v7eI5gFE3EX+91w1cL4cTOGnygjhTi6LKE
         GJP818CQ026UwhB/6U0aSWSWvLvUYDGld9mxlODv8OuFu6Pz5opOROxmeYhuM9KQ9xDp
         EL0+1ikG/QWukxLdeSKYvK63cAcHn9caxqswDlJGRV6XMCgBXJgyKjZUas8jzT559ocJ
         uUlAHq2Ygb1hdawIKy0OlA6i7Znv5zu2FmhWCJLBxaXG4Q8vNvvNnGKI+YdyqIJmBkPJ
         Y1dwu1P0tHABRYHxFSSy+j76gvEhSTe8fL2luDCPl/48sDkV0FUARCPdt3TLATIDYETo
         4rAg==
X-Gm-Message-State: ACgBeo2qP2alJ95ONSY7RJtflAQ/c7QB1+/Gn47smy9tFecS9e26YcHE
        Is+xcESSPXKeOzt5vjxcrEi/mtU3fXr0Rg==
X-Google-Smtp-Source: AA6agR5VC9+eM4U+bEZAVnGe7r/ivjxRGP0WDBRFfu7OMFDZu/8LEapS+svNHLpG7f5uypj7BlfGWg==
X-Received: by 2002:a05:6638:2484:b0:34c:1570:5580 with SMTP id x4-20020a056638248400b0034c15705580mr8117664jat.35.1662235778412;
        Sat, 03 Sep 2022 13:09:38 -0700 (PDT)
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com. [209.85.166.172])
        by smtp.gmail.com with ESMTPSA id l11-20020a02664b000000b0034a036a9a1fsm2370882jaf.48.2022.09.03.13.09.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Sep 2022 13:09:37 -0700 (PDT)
Received: by mail-il1-f172.google.com with SMTP id b17so2931310ilh.0;
        Sat, 03 Sep 2022 13:09:37 -0700 (PDT)
X-Received: by 2002:a92:b106:0:b0:2dc:eebb:e6f6 with SMTP id
 t6-20020a92b106000000b002dceebbe6f6mr21796591ilh.54.1662235777412; Sat, 03
 Sep 2022 13:09:37 -0700 (PDT)
MIME-Version: 1.0
From:   Sungwoo Kim <iam@sung-woo.kim>
Date:   Sat, 3 Sep 2022 16:09:21 -0400
X-Gmail-Original-Message-ID: <CAJNyHpLhfhfGUDvrFaFQ4pMPYYfsnSrfp=1mDCp8c8Kf91OP2Q@mail.gmail.com>
Message-ID: <CAJNyHpLhfhfGUDvrFaFQ4pMPYYfsnSrfp=1mDCp8c8Kf91OP2Q@mail.gmail.com>
Subject: KASAN: use-after-free in __mutex_lock
To:     marcel@holtmann.org
Cc:     johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, I am Sungwoo Kim (https://sung-woo.kim) from Purdue University.

We report a bug found by FuzzBT, a modified version of syzkaller.
It looks similar to the recent bug:
https://lore.kernel.org/lkml/20220622082716.478486-1-lee.jones@linaro.org

We propose to add l2cap_chan_hold_unless_zero() for after calling
__l2cap_get_chan_blah().

Bluetooth: l2cap_core.c:static void l2cap_chan_destroy(struct kref *kref)
Bluetooth: chan 0000000023c4974d
Bluetooth: parent 00000000ae861c08
==================================================================
BUG: KASAN: use-after-free in __mutex_waiter_is_first
kernel/locking/mutex.c:191 [inline]
BUG: KASAN: use-after-free in __mutex_lock_common
kernel/locking/mutex.c:671 [inline]
BUG: KASAN: use-after-free in __mutex_lock+0x278/0x400
kernel/locking/mutex.c:729
Read of size 8 at addr ffff888006a49b08 by task kworker/u3:2/389

CPU: 0 PID: 389 Comm: kworker/u3:2 Not tainted 5.15.0 #14
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x7e/0xb7 lib/dump_stack.c:106
 print_address_description+0x88/0x3b0 mm/kasan/report.c:256
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report+0x172/0x1c0 mm/kasan/report.c:459
 __asan_load8+0x80/0x90 mm/kasan/generic.c:256
 __mutex_waiter_is_first kernel/locking/mutex.c:191 [inline]
 __mutex_lock_common kernel/locking/mutex.c:671 [inline]
 __mutex_lock+0x278/0x400 kernel/locking/mutex.c:729
 __mutex_lock_slowpath+0x13/0x20 kernel/locking/mutex.c:979
 mutex_lock+0x91/0xf0 kernel/locking/mutex.c:280
 l2cap_chan_lock include/net/bluetooth/l2cap.h:890 [inline]
 l2cap_connect_create_rsp net/bluetooth/l2cap_core.c:4431 [inline]
 l2cap_bredr_sig_cmd+0xc7c/0x4060 net/bluetooth/l2cap_core.c:5865
 l2cap_sig_channel net/bluetooth/l2cap_core.c:6633 [inline]
 l2cap_recv_frame+0x71e/0xa00 net/bluetooth/l2cap_core.c:7899
 l2cap_recv_acldata+0x3a2/0x6c0 net/bluetooth/l2cap_core.c:8641
 hci_acldata_packet net/bluetooth/hci_core.c:5100 [inline]
 hci_rx_work+0x39c/0x500 net/bluetooth/hci_core.c:5307
 process_one_work+0x28c/0x440 kernel/workqueue.c:2297
 worker_thread+0x434/0x5d0 kernel/workqueue.c:2444
 kthread+0x214/0x250 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30

Allocated by task 389:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc+0xd6/0x110 mm/kasan/common.c:513
 __kasan_kmalloc+0x9/0x10 mm/kasan/common.c:522
 kasan_kmalloc include/linux/kasan.h:264 [inline]
 kmem_cache_alloc_trace+0x1a9/0x230 mm/slub.c:3240
 kmalloc include/linux/slab.h:591 [inline]
 kzalloc include/linux/slab.h:721 [inline]
 l2cap_chan_create+0x4c/0x2c0 net/bluetooth/l2cap_core.c:481
 l2cap_sock_alloc+0xfa/0x150 net/bluetooth/l2cap_sock.c:1867
 l2cap_sock_new_connection_cb+0xc9/0x140 net/bluetooth/l2cap_sock.c:1467
 l2cap_connect+0x3eb/0x850 net/bluetooth/l2cap_core.c:4274
 l2cap_connect_req net/bluetooth/l2cap_core.c:4387 [inline]
 l2cap_bredr_sig_cmd+0x13fd/0x4060 net/bluetooth/l2cap_core.c:5860
 l2cap_sig_channel net/bluetooth/l2cap_core.c:6633 [inline]
 l2cap_recv_frame+0x71e/0xa00 net/bluetooth/l2cap_core.c:7899
 l2cap_recv_acldata+0x3a2/0x6c0 net/bluetooth/l2cap_core.c:8641
 hci_acldata_packet net/bluetooth/hci_core.c:5100 [inline]
 hci_rx_work+0x39c/0x500 net/bluetooth/hci_core.c:5307
 process_one_work+0x28c/0x440 kernel/workqueue.c:2297
 worker_thread+0x434/0x5d0 kernel/workqueue.c:2444
 kthread+0x214/0x250 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30

Freed by task 364:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track+0x3d/0x70 mm/kasan/common.c:46
 kasan_set_free_info+0x23/0x40 mm/kasan/generic.c:360
 ____kasan_slab_free+0x13a/0x170 mm/kasan/common.c:366
 __kasan_slab_free+0x11/0x20 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:230 [inline]
 slab_free_hook mm/slub.c:1700 [inline]
 slab_free_freelist_hook+0x100/0x1a0 mm/slub.c:1726
 slab_free mm/slub.c:3492 [inline]
 kfree+0xe0/0x270 mm/slub.c:4552
 l2cap_chan_destroy net/bluetooth/l2cap_core.c:524 [inline]
 kref_put include/linux/kref.h:65 [inline]
 l2cap_chan_put+0x147/0x190 net/bluetooth/l2cap_core.c:540
 l2cap_sock_cleanup_listen net/bluetooth/l2cap_sock.c:1449 [inline]
 l2cap_sock_teardown_cb+0x33a/0x3e0 net/bluetooth/l2cap_sock.c:1564
 l2cap_chan_close+0x297/0x640
 l2cap_sock_shutdown+0x6cc/0x8b0 net/bluetooth/l2cap_sock.c:1367
 l2cap_sock_release+0x7d/0x130 net/bluetooth/l2cap_sock.c:1411
 __sock_release+0x80/0x170 net/socket.c:649
 sock_close+0x1e/0x30 net/socket.c:1314
 __fput+0x2de/0x5d0 fs/file_table.c:280
 ____fput+0x1a/0x20 fs/file_table.c:313
 task_work_run+0x102/0x150 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0x511/0x1260 kernel/exit.c:825
 do_group_exit+0xd9/0x1a0 kernel/exit.c:922
 get_signal+0x397/0x11a0 kernel/signal.c:2855
 arch_do_signal_or_restart+0x3b/0x3b0 arch/x86/kernel/signal.c:865
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x103/0x1a0 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x2a/0x40 kernel/entry/common.c:300
 do_syscall_64+0x52/0xc0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff888006a49800
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 776 bytes inside of
 1024-byte region [ffff888006a49800, ffff888006a49c00)
The buggy address belongs to the page:
page:000000004d4d912c refcount:1 mapcount:0 mapping:0000000000000000
index:0x0 pfn:0x6a48
head:000000004d4d912c order:2 compound_mapcount:0 compound_pincount:0
flags: 0xfffffc0010200(slab|head|node=0|zone=1|lastcpupid=0x1fffff)
raw: 000fffffc0010200 dead000000000100 dead000000000122 ffff888001041dc0
raw: 0000000000000000 0000000000080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888006a49a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888006a49a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888006a49b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                      ^
 ffff888006a49b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888006a49c00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 2c9de67da..0e7978228 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4309,7 +4309,10 @@ static int l2cap_connect_create_rsp(struct
l2cap_conn *conn,

        err = 0;

-       l2cap_chan_lock(chan);
+       chan = l2cap_chan_hold_unless_zero(chan);
+       if (chan) {
+               l2cap_chan_lock(chan);
+       }

        switch (result) {
        case L2CAP_CR_SUCCESS:
@@ -4336,6 +4339,7 @@ static int l2cap_connect_create_rsp(struct
l2cap_conn *conn,
        }

        l2cap_chan_unlock(chan);
+       l2cap_chan_put(chan);

 unlock:
        mutex_unlock(&conn->chan_lock);


Best regards,
Sungwoo Kim.
