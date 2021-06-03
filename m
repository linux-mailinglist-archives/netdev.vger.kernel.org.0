Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D1B399B9F
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 09:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhFCHex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 03:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhFCHew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 03:34:52 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DDAC06174A
        for <netdev@vger.kernel.org>; Thu,  3 Jun 2021 00:33:08 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 17-20020a630b110000b029022064e7cdcfso3462660pgl.10
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 00:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=80FYnOoUbaaxd+tUH+w5IlfAs8Z22hC83NU7mLqh5DY=;
        b=CmjVgh6jhJRJXMjBdGdUbH7+Ihe2Imxk7b3Lw3d1iZQsrI0kkOtYXNg6oib39857DN
         tC6RYWImo2wLkp7eomB5TpYcexjYFFf/CLnvlzX8qB/2q2UfNoAeeDu8mF8DGlSUVLba
         9mtlQT8FMH9jiL1hp/h7yvIrBTew3uI7nRq3M9uzqtPB2acDIFtelCIbBCyowS9q/zsZ
         xshsYwpnQu8D7eLOc9EPpVzUOjR6NjQSlmEIyJilT1o8zyDLSrXKqGNVfiVYYLEc+FjW
         NQJoPm9AJ+qdTA1dQpgpNJGlH/zmGrDE7DoRu9pqIRFNGmdVQUPJ7WJB+ri5VcgQhnoZ
         zM+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=80FYnOoUbaaxd+tUH+w5IlfAs8Z22hC83NU7mLqh5DY=;
        b=CmHSFBYSCI/u/DREok55u2PPnFAU2NEtjFK/lb652UP+GDLAJk44JmVV9rfvcTCcb4
         cYv0v3xxpLiJyDXn8yYf51WjCJVTZIy5CdaeIEyqyIVeGOUgrAujwi//ScbwJpCRJJLq
         r4AjuK+D/hninh0qdWNuJtYiWTAa9mm+OlDLm0xhMMJdEXKpUz5lPh7AfklrFoGsPiJG
         w+W0MIXKZ7yooev2HsKlP8oqPm3Y29rFYWJEMqWB3IbKOzjsrWOZTEGcastDY59s642X
         mIYlPnpmIk7+5HG/YBdsvqprrWlsSKGYA/znHxp1dlDVssFb0GH2R9RTIGgzodIRCe4d
         KDuw==
X-Gm-Message-State: AOAM53133D2lUNl6EVVVcx9MSrthLGTD+siR3oYKzypPSMh6SmBFR7tH
        kBpvDIhihMjDRDQFwfkT3Hy+ZTWf1eTtEHdO/eLsc6TVNfKl1AAmIwjyKAe6PTMyfA1BlvcBKjJ
        Jv/A4VhJnRWJ4jffHdC8zhtxAODpb0bHMMF18QkKFmtNuI+9R+n3Z3x98Vm3iaeMcmI5v0g==
X-Google-Smtp-Source: ABdhPJwdP43vWeAahyMlXcNfpvuWiQIgbjJV9QuCUPGGjMLC/XQbHHJmAn/hB3H5cHcQ33CHcou1cdOX8UNGvDg=
X-Received: from ctvm0820.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:5f5f])
 (user=lixiaoyan job=sendgmr) by 2002:a17:90a:cb07:: with SMTP id
 z7mr818344pjt.0.1622705586256; Thu, 03 Jun 2021 00:33:06 -0700 (PDT)
Date:   Thu,  3 Jun 2021 07:32:58 +0000
Message-Id: <20210603073258.1186722-1-lixiaoyan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH net] ipv6: Fix KASAN: slab-out-of-bounds Read in fib6_nh_flush_exceptions
From:   Coco Li <lixiaoyan@google.com>
To:     netdev@vger.kernel.org
Cc:     Coco Li <lixiaoyan@google.com>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reported by syzbot:
HEAD commit:    90c911ad Merge tag 'fixes' of git://git.kernel.org/pub/scm..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
dashboard link: https://syzkaller.appspot.com/bug?extid=123aa35098fd3c000eb7
compiler:       Debian clang version 11.0.1-2

==================================================================
BUG: KASAN: slab-out-of-bounds in fib6_nh_get_excptn_bucket net/ipv6/route.c:1604 [inline]
BUG: KASAN: slab-out-of-bounds in fib6_nh_flush_exceptions+0xbd/0x360 net/ipv6/route.c:1732
Read of size 8 at addr ffff8880145c78f8 by task syz-executor.4/17760

CPU: 0 PID: 17760 Comm: syz-executor.4 Not tainted 5.12.0-rc8-syzkaller #0
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x202/0x31e lib/dump_stack.c:120
 print_address_description+0x5f/0x3b0 mm/kasan/report.c:232
 __kasan_report mm/kasan/report.c:399 [inline]
 kasan_report+0x15c/0x200 mm/kasan/report.c:416
 fib6_nh_get_excptn_bucket net/ipv6/route.c:1604 [inline]
 fib6_nh_flush_exceptions+0xbd/0x360 net/ipv6/route.c:1732
 fib6_nh_release+0x9a/0x430 net/ipv6/route.c:3536
 fib6_info_destroy_rcu+0xcb/0x1c0 net/ipv6/ip6_fib.c:174
 rcu_do_batch kernel/rcu/tree.c:2559 [inline]
 rcu_core+0x8f6/0x1450 kernel/rcu/tree.c:2794
 __do_softirq+0x372/0x7a6 kernel/softirq.c:345
 invoke_softirq kernel/softirq.c:221 [inline]
 __irq_exit_rcu+0x22c/0x260 kernel/softirq.c:422
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:434
 sysvec_apic_timer_interrupt+0x91/0xb0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:632
RIP: 0010:lock_acquire+0x1f6/0x720 kernel/locking/lockdep.c:5515
Code: f6 84 24 a1 00 00 00 02 0f 85 8d 02 00 00 f7 c3 00 02 00 00 49 bd 00 00 00 00 00 fc ff df 74 01 fb 48 c7 44 24 40 0e 36 e0 45 <4b> c7 44 3d 00 00 00 00 00 4b c7 44 3d 09 00 00 00 00 43 c7 44 3d
RSP: 0018:ffffc90009e06560 EFLAGS: 00000206
RAX: 1ffff920013c0cc0 RBX: 0000000000000246 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90009e066e0 R08: dffffc0000000000 R09: fffffbfff1f992b1
R10: fffffbfff1f992b1 R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: 0000000000000000 R15: 1ffff920013c0cb4
 rcu_lock_acquire+0x2a/0x30 include/linux/rcupdate.h:267
 rcu_read_lock include/linux/rcupdate.h:656 [inline]
 ext4_get_group_info+0xea/0x340 fs/ext4/ext4.h:3231
 ext4_mb_prefetch+0x123/0x5d0 fs/ext4/mballoc.c:2212
 ext4_mb_regular_allocator+0x8a5/0x28f0 fs/ext4/mballoc.c:2379
 ext4_mb_new_blocks+0xc6e/0x24f0 fs/ext4/mballoc.c:4982
 ext4_ext_map_blocks+0x2be3/0x7210 fs/ext4/extents.c:4238
 ext4_map_blocks+0xab3/0x1cb0 fs/ext4/inode.c:638
 ext4_getblk+0x187/0x6c0 fs/ext4/inode.c:848
 ext4_bread+0x2a/0x1c0 fs/ext4/inode.c:900
 ext4_append+0x1a4/0x360 fs/ext4/namei.c:67
 ext4_init_new_dir+0x337/0xa10 fs/ext4/namei.c:2768
 ext4_mkdir+0x4b8/0xc00 fs/ext4/namei.c:2814
 vfs_mkdir+0x45b/0x640 fs/namei.c:3819
 ovl_do_mkdir fs/overlayfs/overlayfs.h:161 [inline]
 ovl_mkdir_real+0x53/0x1a0 fs/overlayfs/dir.c:146
 ovl_create_real+0x280/0x490 fs/overlayfs/dir.c:193
 ovl_workdir_create+0x425/0x600 fs/overlayfs/super.c:788
 ovl_make_workdir+0xed/0x1140 fs/overlayfs/super.c:1355
 ovl_get_workdir fs/overlayfs/super.c:1492 [inline]
 ovl_fill_super+0x39ee/0x5370 fs/overlayfs/super.c:2035
 mount_nodev+0x52/0xe0 fs/super.c:1413
 legacy_get_tree+0xea/0x180 fs/fs_context.c:592
 vfs_get_tree+0x86/0x270 fs/super.c:1497
 do_new_mount fs/namespace.c:2903 [inline]
 path_mount+0x196f/0x2be0 fs/namespace.c:3233
 do_mount fs/namespace.c:3246 [inline]
 __do_sys_mount fs/namespace.c:3454 [inline]
 __se_sys_mount+0x2f9/0x3b0 fs/namespace.c:3431
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f68f2b87188 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 00000000004665f9
RDX: 00000000200000c0 RSI: 0000000020000000 RDI: 000000000040000a
RBP: 00000000004bfbb9 R08: 0000000020000100 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
R13: 00007ffe19002dff R14: 00007f68f2b87300 R15: 0000000000022000

Allocated by task 17768:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:427 [inline]
 ____kasan_kmalloc+0xc2/0xf0 mm/kasan/common.c:506
 kasan_kmalloc include/linux/kasan.h:233 [inline]
 __kmalloc+0xb4/0x380 mm/slub.c:4055
 kmalloc include/linux/slab.h:559 [inline]
 kzalloc include/linux/slab.h:684 [inline]
 fib6_info_alloc+0x2c/0xd0 net/ipv6/ip6_fib.c:154
 ip6_route_info_create+0x55d/0x1a10 net/ipv6/route.c:3638
 ip6_route_add+0x22/0x120 net/ipv6/route.c:3728
 inet6_rtm_newroute+0x2cd/0x2260 net/ipv6/route.c:5352
 rtnetlink_rcv_msg+0xb34/0xe70 net/core/rtnetlink.c:5553
 netlink_rcv_skb+0x1f0/0x460 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x7de/0x9b0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0xaa6/0xe90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0x5a2/0x900 net/socket.c:2350
 ___sys_sendmsg net/socket.c:2404 [inline]
 __sys_sendmsg+0x319/0x400 net/socket.c:2433
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Last potentially related work creation:
 kasan_save_stack+0x27/0x50 mm/kasan/common.c:38
 kasan_record_aux_stack+0xee/0x120 mm/kasan/generic.c:345
 __call_rcu kernel/rcu/tree.c:3039 [inline]
 call_rcu+0x1b1/0xa30 kernel/rcu/tree.c:3114
 fib6_info_release include/net/ip6_fib.h:337 [inline]
 ip6_route_info_create+0x10c4/0x1a10 net/ipv6/route.c:3718
 ip6_route_add+0x22/0x120 net/ipv6/route.c:3728
 inet6_rtm_newroute+0x2cd/0x2260 net/ipv6/route.c:5352
 rtnetlink_rcv_msg+0xb34/0xe70 net/core/rtnetlink.c:5553
 netlink_rcv_skb+0x1f0/0x460 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x7de/0x9b0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0xaa6/0xe90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0x5a2/0x900 net/socket.c:2350
 ___sys_sendmsg net/socket.c:2404 [inline]
 __sys_sendmsg+0x319/0x400 net/socket.c:2433
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Second to last potentially related work creation:
 kasan_save_stack+0x27/0x50 mm/kasan/common.c:38
 kasan_record_aux_stack+0xee/0x120 mm/kasan/generic.c:345
 insert_work+0x54/0x400 kernel/workqueue.c:1331
 __queue_work+0x981/0xcc0 kernel/workqueue.c:1497
 queue_work_on+0x111/0x200 kernel/workqueue.c:1524
 queue_work include/linux/workqueue.h:507 [inline]
 call_usermodehelper_exec+0x283/0x470 kernel/umh.c:433
 kobject_uevent_env+0x1349/0x1730 lib/kobject_uevent.c:617
 kvm_uevent_notify_change+0x309/0x3b0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4809
 kvm_destroy_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:877 [inline]
 kvm_put_kvm+0x9c/0xd10 arch/x86/kvm/../../../virt/kvm/kvm_main.c:920
 kvm_vcpu_release+0x53/0x60 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3120
 __fput+0x352/0x7b0 fs/file_table.c:280
 task_work_run+0x146/0x1c0 kernel/task_work.c:140
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:174 [inline]
 exit_to_user_mode_prepare+0x10b/0x1e0 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x26/0x70 kernel/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff8880145c7800
 which belongs to the cache kmalloc-192 of size 192
The buggy address is located 56 bytes to the right of
 192-byte region [ffff8880145c7800, ffff8880145c78c0)
The buggy address belongs to the page:
page:ffffea00005171c0 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x145c7
flags: 0xfff00000000200(slab)
raw: 00fff00000000200 ffffea00006474c0 0000000200000002 ffff888010c41a00
raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880145c7780: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff8880145c7800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff8880145c7880: 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc fc
                                                                ^
 ffff8880145c7900: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880145c7980: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
==================================================================

In the ip6_route_info_create function, in the case that the nh pointer
is not NULL, the fib6_nh in fib6_info has not been allocated.
Therefore, when trying to free fib6_info in this error case using
fib6_info_release, the function will call fib6_info_destroy_rcu,
which it will access fib6_nh_release(f6i->fib6_nh);
However, f6i->fib6_nh doesn't have any refcount yet given the lack of allocation
causing the reported memory issue above.
Therefore, releasing the empty pointer directly instead would be the solution.

Fixes: f88d8ea67fbdb ("ipv6: Plumb support for nexthop object in a fib6_info")
Fixes: 706ec91916462 ("ipv6: Fix nexthop refcnt leak when creating ipv6 route info")
Signed-off-by: Coco Li <lixiaoyan@google.com>
Cc: David Ahern <dsahern@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/route.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 373d48073106..36e80b3598b0 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3676,11 +3676,11 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
 	if (nh) {
 		if (rt->fib6_src.plen) {
 			NL_SET_ERR_MSG(extack, "Nexthops can not be used with source routing");
-			goto out;
+			goto out_free;
 		}
 		if (!nexthop_get(nh)) {
 			NL_SET_ERR_MSG(extack, "Nexthop has been deleted");
-			goto out;
+			goto out_free;
 		}
 		rt->nh = nh;
 		fib6_nh = nexthop_fib6_nh(rt->nh);
@@ -3717,6 +3717,10 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
 out:
 	fib6_info_release(rt);
 	return ERR_PTR(err);
+out_free:
+	ip_fib_metrics_put(rt->fib6_metrics);
+	kfree(rt);
+	return ERR_PTR(err);
 }
 
 int ip6_route_add(struct fib6_config *cfg, gfp_t gfp_flags,
-- 
2.32.0.rc1.229.g3e70b5a671-goog

