Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241723FC30E
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 09:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238208AbhHaG5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 02:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbhHaG5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 02:57:23 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B353C061575;
        Mon, 30 Aug 2021 23:56:29 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so1267003pjr.1;
        Mon, 30 Aug 2021 23:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lfEtYIu/utfFULs5apSczuS/W4kZB9kIF3Fl1+UV+f4=;
        b=SgOqcilv+OBh9sCxLnxuq6V5TkLRgFPTBWHi+6IWG6HdR2fqHX/I+aBq92DldYTjh8
         ER39P6/wwinMTr5nA4dz1tLfPMHD1uIWZN2wFUPITJG8gqQ7gC4xeOa7ZzpWdJbWHgKH
         PcRE8RWm93M/qVlbyXi6k9lMF3sunaPijww3qlZZ577SWwNxRw/v/culHIaCyNXZaw7U
         UW+cMdLEFavKrbOOdohdZz6jy9Uhi6NqjQXPwluHCGiJHF5fhRFip3ihSUJsFP8J23DT
         /r6Nsau5I++wjbY1h1ZT+ZQvMKbngEXah53cgMhPVH/Ee7HE0i0lbT7ED3wPeejcfs+3
         ACIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lfEtYIu/utfFULs5apSczuS/W4kZB9kIF3Fl1+UV+f4=;
        b=pq9Z13HwCq/S3wqCB0VNmvkzJq92TNN1TKAA8Rzao03FfDUBNSwjhGgoRnm5SfPbia
         07/mGadHqYJoVurC7gcCs5ll3dn9T8TuDv1NGF7IuNSPiusGva13teIqGngB5MwpHn+8
         RKSBQnJ99Eq6fm894GAMg9ZTXCTWx+rkNbI/PyA6eZfB5lO8Pjk0Wz8/X+n4vBQDytNx
         ArAHjt9D5Ms6n5RGKHyi1/MIsrpcL/P8YRFws9t4Z2qrK0IPaYtdBVwRKyMT6DAxpWNG
         Ek0Uyuu2S6eXxjUqtP0P6b5MYuipKwCRDsid8mNJ9OmXmxwDTnkwv66cY6kYMjhMCsBA
         C8Hg==
X-Gm-Message-State: AOAM533ElDrjqqcJwcteiCA22YPMqmM9Uzwo035HcpdwJyhaUZhJeYyu
        aqc0sPLNrf7cZq7aVnf2DMPRv70v7d05JsB5LdwYeg==
X-Google-Smtp-Source: ABdhPJzzK+r0wG1xM0noPs3I19S+pjKi0DqezCPPUQWpcMTdoXqyzAIMzeX+feHAB4Pnxy9i4LJG/w==
X-Received: by 2002:a17:90a:8b12:: with SMTP id y18mr3649666pjn.72.1630392988407;
        Mon, 30 Aug 2021 23:56:28 -0700 (PDT)
Received: from sanitydock.wifi-cloud.jp ([210.160.217.69])
        by smtp.gmail.com with ESMTPSA id k190sm7988894pgc.11.2021.08.30.23.56.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 23:56:27 -0700 (PDT)
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
        gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+2bef95d3ab4daa10155b@syzkaller.appspotmail.com,
        Hillf Danton <hdanton@sina.com>
Subject: [PATCH] Bluetooth: fix race in sco_sock_connect
Date:   Tue, 31 Aug 2021 14:56:01 +0800
Message-Id: <20210831065601.101185-1-desmondcheongzx@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported a use-after-free Write in sco_sock_timeout [1]:

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
BUG: KASAN: use-after-free in atomic_fetch_add_relaxed include/asm-generic/atomic-instrumented.h:111 [inline]
BUG: KASAN: use-after-free in __refcount_add include/linux/refcount.h:193 [inline]
BUG: KASAN: use-after-free in __refcount_inc include/linux/refcount.h:250 [inline]
BUG: KASAN: use-after-free in refcount_inc include/linux/refcount.h:267 [inline]
BUG: KASAN: use-after-free in sock_hold include/net/sock.h:702 [inline]
BUG: KASAN: use-after-free in sco_sock_timeout+0x64/0x290 net/bluetooth/sco.c:88
Write of size 4 at addr ffff888034b46080 by task kworker/1:0/20

CPU: 1 PID: 20 Comm: kworker/1:0 Not tainted 5.14.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events sco_sock_timeout
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 print_address_description.constprop.0.cold+0x6c/0x309 mm/kasan/report.c:233
 __kasan_report mm/kasan/report.c:419 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:436
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 atomic_fetch_add_relaxed include/asm-generic/atomic-instrumented.h:111 [inline]
 __refcount_add include/linux/refcount.h:193 [inline]
 __refcount_inc include/linux/refcount.h:250 [inline]
 refcount_inc include/linux/refcount.h:267 [inline]
 sock_hold include/net/sock.h:702 [inline]
 sco_sock_timeout+0x64/0x290 net/bluetooth/sco.c:88
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Allocated by task 4872:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc mm/kasan/common.c:513 [inline]
 ____kasan_kmalloc mm/kasan/common.c:472 [inline]
 __kasan_kmalloc+0x9b/0xd0 mm/kasan/common.c:522
 kmalloc include/linux/slab.h:596 [inline]
 sk_prot_alloc+0x110/0x290 net/core/sock.c:1822
 sk_alloc+0x32/0xbc0 net/core/sock.c:1875
 __netlink_create+0x63/0x2f0 net/netlink/af_netlink.c:640
 netlink_create+0x3ad/0x5e0 net/netlink/af_netlink.c:703
 __sock_create+0x353/0x790 net/socket.c:1461
 sock_create net/socket.c:1512 [inline]
 __sys_socket+0xef/0x200 net/socket.c:1554
 __do_sys_socket net/socket.c:1563 [inline]
 __se_sys_socket net/socket.c:1561 [inline]
 __x64_sys_socket+0x6f/0xb0 net/socket.c:1561
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 0:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:360
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free mm/kasan/common.c:328 [inline]
 __kasan_slab_free+0xfb/0x130 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:230 [inline]
 slab_free_hook mm/slub.c:1628 [inline]
 slab_free_freelist_hook+0xdf/0x240 mm/slub.c:1653
 slab_free mm/slub.c:3213 [inline]
 kfree+0xe4/0x540 mm/slub.c:4267
 sk_prot_free net/core/sock.c:1858 [inline]
 __sk_destruct+0x6a8/0x900 net/core/sock.c:1943
 sk_destruct+0xbd/0xe0 net/core/sock.c:1958
 __sk_free+0xef/0x3d0 net/core/sock.c:1969
 sk_free+0x78/0xa0 net/core/sock.c:1980
 deferred_put_nlk_sk+0x151/0x2f0 net/netlink/af_netlink.c:740
 rcu_do_batch kernel/rcu/tree.c:2550 [inline]
 rcu_core+0x7ab/0x1380 kernel/rcu/tree.c:2785
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558

Last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:348
 __call_rcu kernel/rcu/tree.c:3029 [inline]
 call_rcu+0xb1/0x750 kernel/rcu/tree.c:3109
 netlink_release+0xdd4/0x1dd0 net/netlink/af_netlink.c:812
 __sock_release+0xcd/0x280 net/socket.c:649
 sock_close+0x18/0x20 net/socket.c:1311
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xbd4/0x2a60 kernel/exit.c:825
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Second to last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:348
 __call_rcu kernel/rcu/tree.c:3029 [inline]
 call_rcu+0xb1/0x750 kernel/rcu/tree.c:3109
 netlink_release+0xdd4/0x1dd0 net/netlink/af_netlink.c:812
 __sock_release+0xcd/0x280 net/socket.c:649
 sock_close+0x18/0x20 net/socket.c:1311
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xbd4/0x2a60 kernel/exit.c:825
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff888034b46000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 128 bytes inside of
 2048-byte region [ffff888034b46000, ffff888034b46800)
The buggy address belongs to the page:
page:ffffea0000d2d000 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x34b40
head:ffffea0000d2d000 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffffea0000c37a00 0000000200000002 ffff888010c42000
raw: 0000000000000000 0000000000080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 8634, ts 417197903424, free_ts 417180376519
 prep_new_page mm/page_alloc.c:2436 [inline]
 get_page_from_freelist+0xa72/0x2f80 mm/page_alloc.c:4169
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5391
 alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2244
 alloc_slab_page mm/slub.c:1691 [inline]
 allocate_slab+0x32e/0x4b0 mm/slub.c:1831
 new_slab mm/slub.c:1894 [inline]
 new_slab_objects mm/slub.c:2640 [inline]
 ___slab_alloc+0x473/0x7b0 mm/slub.c:2803
 __slab_alloc.constprop.0+0xa7/0xf0 mm/slub.c:2843
 slab_alloc_node mm/slub.c:2925 [inline]
 __kmalloc_node_track_caller+0x2e3/0x360 mm/slub.c:4653
 kmalloc_reserve net/core/skbuff.c:355 [inline]
 __alloc_skb+0xde/0x340 net/core/skbuff.c:426
 alloc_skb include/linux/skbuff.h:1116 [inline]
 alloc_skb_with_frags+0x93/0x620 net/core/skbuff.c:6073
 sock_alloc_send_pskb+0x783/0x910 net/core/sock.c:2475
 mld_newpack+0x1df/0x770 net/ipv6/mcast.c:1756
 add_grhead+0x265/0x330 net/ipv6/mcast.c:1859
 add_grec+0x1053/0x14e0 net/ipv6/mcast.c:1997
 mld_send_initial_cr.part.0+0xf6/0x230 net/ipv6/mcast.c:2244
 mld_send_initial_cr net/ipv6/mcast.c:1232 [inline]
 ipv6_mc_dad_complete+0x1d0/0x690 net/ipv6/mcast.c:2255
 addrconf_dad_completed+0xa20/0xd60 net/ipv6/addrconf.c:4181
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1346 [inline]
 free_pcp_prepare+0x2c5/0x780 mm/page_alloc.c:1397
 free_unref_page_prepare mm/page_alloc.c:3332 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3411
 unfreeze_partials+0x16c/0x1b0 mm/slub.c:2421
 put_cpu_partial+0x13d/0x230 mm/slub.c:2457
 qlink_free mm/kasan/quarantine.c:146 [inline]
 qlist_free_all+0x5a/0xc0 mm/kasan/quarantine.c:165
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:272
 __kasan_slab_alloc+0x8e/0xa0 mm/kasan/common.c:444
 kasan_slab_alloc include/linux/kasan.h:254 [inline]
 slab_post_alloc_hook mm/slab.h:519 [inline]
 slab_alloc_node mm/slub.c:2959 [inline]
 slab_alloc mm/slub.c:2967 [inline]
 kmem_cache_alloc+0x285/0x4a0 mm/slub.c:2972
 getname_flags.part.0+0x50/0x4f0 fs/namei.c:138
 getname_flags fs/namei.c:2747 [inline]
 user_path_at_empty+0xa1/0x100 fs/namei.c:2747
 user_path_at include/linux/namei.h:57 [inline]
 vfs_statx+0x142/0x390 fs/stat.c:203
 vfs_fstatat fs/stat.c:225 [inline]
 vfs_lstat include/linux/fs.h:3386 [inline]
 __do_sys_newlstat+0x91/0x110 fs/stat.c:380
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff888034b45f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888034b46000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff888034b46080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff888034b46100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888034b46180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

sco_sock_connect checks the socket's state before allocating a new SCO
connection and creating a channel for it with the given socket.

However, because this check occurs outside the socket lock, multiple
concurrent calls to sco_sock_connect are able to pass the check before
serially entering the critical section and making multiple recursive
calls to sco_connect.

The result is that multiple SCO connections are allocated, but each
connection overrides the socket's channel with the previous
connection. This may cause a UAF because the overwritten connections
can't have their channels deleted when the socket is released, so
sco_sock_timeout is able to access the freed socket.

Fix this by checking the socket's state after the socket is locked in
sco_sock_connect.

Link: https://syzkaller.appspot.com/bug?extid=2bef95d3ab4daa10155b [1]
Reported-by: syzbot+2bef95d3ab4daa10155b@syzkaller.appspotmail.com
Tested-by: syzbot+2bef95d3ab4daa10155b@syzkaller.appspotmail.com
Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
---
 net/bluetooth/sco.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 98a881586512..fa25b07120c9 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -578,9 +578,6 @@ static int sco_sock_connect(struct socket *sock, struct sockaddr *addr, int alen
 	    addr->sa_family != AF_BLUETOOTH)
 		return -EINVAL;
 
-	if (sk->sk_state != BT_OPEN && sk->sk_state != BT_BOUND)
-		return -EBADFD;
-
 	if (sk->sk_type != SOCK_SEQPACKET)
 		return -EINVAL;
 
@@ -591,6 +588,13 @@ static int sco_sock_connect(struct socket *sock, struct sockaddr *addr, int alen
 
 	lock_sock(sk);
 
+	if (sk->sk_state != BT_OPEN && sk->sk_state != BT_BOUND) {
+		hci_dev_unlock(hdev);
+		hci_dev_put(hdev);
+		err = -EBADFD;
+		goto done;
+	}
+
 	/* Set destination address and psm */
 	bacpy(&sco_pi(sk)->dst, &sa->sco_bdaddr);
 
-- 
2.25.1

