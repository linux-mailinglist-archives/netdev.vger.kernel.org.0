Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D811E86B5
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 20:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgE2Scb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 14:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbgE2Sc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 14:32:29 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA0AC03E969
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 11:32:29 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id u26so3595067qtj.21
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 11:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=CPD6t8qyn60uaZGexPzIrN0uMFVn1hag1oBpJqZOMio=;
        b=Wj63pLcIVgZqFnHF2SWV8aawtVj5OcW4Rbncms5DBmv1hWNlbZHJDk45+4m3SYy0dm
         9ZyiQ9tDgbCF8YRQv1SNqgASPIR/KQB29n0UdHyxC7zEQJtK9KiRxQIPkrWpWlaztuTG
         lQQhsmKtrOxQrQGtYqEFCpzg1NF5HKhirSJR4b72/icYuBjdwMm33ik5UYJ0eTs/gRDy
         PRR7ZcVHCVBA2fn8bPZdEo5mbJ6GQRbNrGeC1q1Mm0pBA5mkaKm15S5F63+9k1XdlAch
         MGEyPlAzbRa1aIewuOZGQh/EP7HZQ14SPMcQCVcSwyt2vD92z7jhnv0eMeQyizruCihg
         A6Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=CPD6t8qyn60uaZGexPzIrN0uMFVn1hag1oBpJqZOMio=;
        b=bH6toD2GjBMBXy+4crFCMJlJPBIsW/6Vw1PXr7IJkub0rjHlwPRHDYpWIBQsMHdSE4
         h80uhWDhXztNtXmVqL4BhrrsNWLRQ2H3Xss/kpwPyropiq2gmCS++Pxec6JiKHKao/cZ
         1/T7Qn3hE3hrOpCujaLcCpTbybd8Q6Nj02CMPzpstoI/WKuzULg5e8GK+ym/dXd2FXvx
         yM0sEQC0mSPFvZNx2kOPcF8rHhZwH0VnkUAlADFNCzkwFLvkwaykSVKgxI68jgB1th8T
         +O3+JF3Ib4BpM5E5dvJAdvCXvhHa/cwYh7vbPsqRPeamQIk7lc+xuvSwoqKDEKFtz4TV
         +/Ag==
X-Gm-Message-State: AOAM531qvh9I1KlsepqzxYDd0B8TiPdRlaIXCLjpTsxt+JKc5sLqNFMH
        hVy2ykDHjJX9OkLI/uJtH63ERxmVtZRNKg==
X-Google-Smtp-Source: ABdhPJwq+oftMciw4vHgXt35oSCPiv3eW+RqKyFgULBS02WQjoXW2KfEC1N91bmgJNAJ8Uh2xnZ+9MLPLT6TcA==
X-Received: by 2002:a0c:e403:: with SMTP id o3mr9084233qvl.24.1590777148552;
 Fri, 29 May 2020 11:32:28 -0700 (PDT)
Date:   Fri, 29 May 2020 11:32:25 -0700
Message-Id: <20200529183225.150288-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.rc2.251.g90737beb825-goog
Subject: [PATCH net] l2tp: add sk_family checks to l2tp_validate_socket
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        James Chapman <jchapman@katalix.com>,
        Guillaume Nault <gnault@redhat.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot was able to trigger a crash after using an ISDN socket
and fool l2tp.

Fix this by making sure the UDP socket is of the proper family.

BUG: KASAN: slab-out-of-bounds in setup_udp_tunnel_sock+0x465/0x540 net/ipv4/udp_tunnel.c:78
Write of size 1 at addr ffff88808ed0c590 by task syz-executor.5/3018

CPU: 0 PID: 3018 Comm: syz-executor.5 Not tainted 5.7.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x413 mm/kasan/report.c:382
 __kasan_report.cold+0x20/0x38 mm/kasan/report.c:511
 kasan_report+0x33/0x50 mm/kasan/common.c:625
 setup_udp_tunnel_sock+0x465/0x540 net/ipv4/udp_tunnel.c:78
 l2tp_tunnel_register+0xb15/0xdd0 net/l2tp/l2tp_core.c:1523
 l2tp_nl_cmd_tunnel_create+0x4b2/0xa60 net/l2tp/l2tp_netlink.c:249
 genl_family_rcv_msg_doit net/netlink/genetlink.c:673 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:718 [inline]
 genl_rcv_msg+0x627/0xdf0 net/netlink/genetlink.c:735
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2469
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:746
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e6/0x810 net/socket.c:2352
 ___sys_sendmsg+0x100/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45ca29
Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007effe76edc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004fe1c0 RCX: 000000000045ca29
RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000005
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 000000000000094e R14: 00000000004d5d00 R15: 00007effe76ee6d4

Allocated by task 3018:
 save_stack+0x1b/0x40 mm/kasan/common.c:49
 set_track mm/kasan/common.c:57 [inline]
 __kasan_kmalloc mm/kasan/common.c:495 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:468
 __do_kmalloc mm/slab.c:3656 [inline]
 __kmalloc+0x161/0x7a0 mm/slab.c:3665
 kmalloc include/linux/slab.h:560 [inline]
 sk_prot_alloc+0x223/0x2f0 net/core/sock.c:1612
 sk_alloc+0x36/0x1100 net/core/sock.c:1666
 data_sock_create drivers/isdn/mISDN/socket.c:600 [inline]
 mISDN_sock_create+0x272/0x400 drivers/isdn/mISDN/socket.c:796
 __sock_create+0x3cb/0x730 net/socket.c:1428
 sock_create net/socket.c:1479 [inline]
 __sys_socket+0xef/0x200 net/socket.c:1521
 __do_sys_socket net/socket.c:1530 [inline]
 __se_sys_socket net/socket.c:1528 [inline]
 __x64_sys_socket+0x6f/0xb0 net/socket.c:1528
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3

Freed by task 2484:
 save_stack+0x1b/0x40 mm/kasan/common.c:49
 set_track mm/kasan/common.c:57 [inline]
 kasan_set_free_info mm/kasan/common.c:317 [inline]
 __kasan_slab_free+0xf7/0x140 mm/kasan/common.c:456
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x109/0x2b0 mm/slab.c:3757
 kvfree+0x42/0x50 mm/util.c:603
 __free_fdtable+0x2d/0x70 fs/file.c:31
 put_files_struct fs/file.c:420 [inline]
 put_files_struct+0x248/0x2e0 fs/file.c:413
 exit_files+0x7e/0xa0 fs/file.c:445
 do_exit+0xb04/0x2dd0 kernel/exit.c:791
 do_group_exit+0x125/0x340 kernel/exit.c:894
 get_signal+0x47b/0x24e0 kernel/signal.c:2739
 do_signal+0x81/0x2240 arch/x86/kernel/signal.c:784
 exit_to_usermode_loop+0x26c/0x360 arch/x86/entry/common.c:161
 prepare_exit_to_usermode arch/x86/entry/common.c:196 [inline]
 syscall_return_slowpath arch/x86/entry/common.c:279 [inline]
 do_syscall_64+0x6b1/0x7d0 arch/x86/entry/common.c:305
 entry_SYSCALL_64_after_hwframe+0x49/0xb3

The buggy address belongs to the object at ffff88808ed0c000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 1424 bytes inside of
 2048-byte region [ffff88808ed0c000, ffff88808ed0c800)
The buggy address belongs to the page:
page:ffffea00023b4300 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea0002838208 ffffea00015ba288 ffff8880aa000e00
raw: 0000000000000000 ffff88808ed0c000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88808ed0c480: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88808ed0c500: 00 00 00 fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88808ed0c580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                         ^
 ffff88808ed0c600: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88808ed0c680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc

Fixes: 6b9f34239b00 ("l2tp: fix races in tunnel creation")
Fixes: fd558d186df2 ("l2tp: Split pppol2tp patch into separate l2tp and ppp parts")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: James Chapman <jchapman@katalix.com>
Cc: Guillaume Nault <gnault@redhat.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/l2tp/l2tp_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index fcb53ed1c4fb98de3d60c52542e4c4260582bf3a..6d7ef78c88af059a4cbfb5d89f32ad6d1babfe74 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1458,6 +1458,9 @@ static int l2tp_validate_socket(const struct sock *sk, const struct net *net,
 	if (sk->sk_type != SOCK_DGRAM)
 		return -EPROTONOSUPPORT;
 
+	if (sk->sk_family != PF_INET && sk->sk_family != PF_INET6)
+		return -EPROTONOSUPPORT;
+
 	if ((encap == L2TP_ENCAPTYPE_UDP && sk->sk_protocol != IPPROTO_UDP) ||
 	    (encap == L2TP_ENCAPTYPE_IP && sk->sk_protocol != IPPROTO_L2TP))
 		return -EPROTONOSUPPORT;
-- 
2.27.0.rc2.251.g90737beb825-goog

