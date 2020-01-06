Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 403921313F9
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 15:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgAFOpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 09:45:43 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:43708 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbgAFOpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 09:45:42 -0500
Received: by mail-pj1-f73.google.com with SMTP id 9so12694791pjn.8
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 06:45:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=m6tchpNT76+0hs6xcnFLkDSdHOhg1zBQ4zdEbTksZu4=;
        b=lwkdKK1wGXykbwf8vlYq3GwkWWJBMCpCWQ9e8nR2Bo814+gn2++9xdYH5GNQPO9utt
         ztgisRDF0nmAWNCTSEf0IzYhVTQLE1LR2+AQNOAOONJdRIeVCdXarqlD7l6/HIS/iEOI
         mLKoNSJ0NdCCqoOUFMI+lyNS4Cl9F/ej7yal/81h8BJ/l7a8Lv6wNYhuL43/7d7qsILY
         IVLfneWkkzTMq1ZSQvUj0ZAuAPlgZ2FtkyrHtsHjHGhxOuNg5jXWC0ZDVwBErrHctXfA
         KykK1ycZ5xD/Ms6vJxs3F9190qGOh9djBQt+pQ2rJunK4NF3bALxr5LKQQ7iC8BKZCWE
         C0HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=m6tchpNT76+0hs6xcnFLkDSdHOhg1zBQ4zdEbTksZu4=;
        b=Iu093Gqyj3lLZBrXpdCtKkbkYOskhHBTqY52ziLrIuBDevxbDtw+CZ4wcsUUu3YH0Z
         b40pq6M5UlzNq88+dJSOFLRpck/cFZk5LYctP6dKNv3TCKySnP7a5AbPIzHnvBBAvW5+
         sYIt66oY28SVnjIeKhNmwXGFuR+RD/D5HPoFLxaed8uFIqTwm+WhbKYdbg/bhZ8Z3KI2
         Z97LHtwmLPgPLpG4dZFTNxNzSQScYNUinGqffSW1RKTAJ7CFK4PdmzF6YJsjIiguK+n9
         /f/yX/AsaatZhcsVxHRMmjt5u4PO/x9BE1gHzP9JlenN0c7ZTB0iofaMvDbMPk0go47J
         UizA==
X-Gm-Message-State: APjAAAVZTTtPyfckD3+A9zIkHIQyRuHBkSmvKr2MFKxx/R389gR+XE1I
        dIgfnmfmipxGWlHt1BoIojYSquRyiVRaiw==
X-Google-Smtp-Source: APXvYqx1jFy0U5gNPd4Buh7b/cgmv15RXxX3E93pQkiVflhP82Y8FULbvr0YBmeFYKrkdiSDN3/3PvxPjxdv2A==
X-Received: by 2002:a63:d041:: with SMTP id s1mr112495073pgi.363.1578321941581;
 Mon, 06 Jan 2020 06:45:41 -0800 (PST)
Date:   Mon,  6 Jan 2020 06:45:37 -0800
Message-Id: <20200106144537.230912-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH net] gtp: fix bad unlock balance in gtp_encap_enable_socket
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Taehee Yoo <ap420073@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

WARNING: bad unlock balance detected!
5.5.0-rc5-syzkaller #0 Not tainted
-------------------------------------
syz-executor921/9688 is trying to release lock (sk_lock-AF_INET6) at:
[<ffffffff84bf8506>] gtp_encap_enable_socket+0x146/0x400 drivers/net/gtp.c:830
but there are no more locks to release!

other info that might help us debug this:
2 locks held by syz-executor921/9688:
 #0: ffffffff8a4d8840 (rtnl_mutex){+.+.}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8a4d8840 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x405/0xaf0 net/core/rtnetlink.c:5421
 #1: ffff88809304b560 (slock-AF_INET6){+...}, at: spin_lock_bh include/linux/spinlock.h:343 [inline]
 #1: ffff88809304b560 (slock-AF_INET6){+...}, at: release_sock+0x20/0x1c0 net/core/sock.c:2951

stack backtrace:
CPU: 0 PID: 9688 Comm: syz-executor921 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_unlock_imbalance_bug kernel/locking/lockdep.c:4008 [inline]
 print_unlock_imbalance_bug.cold+0x114/0x123 kernel/locking/lockdep.c:3984
 __lock_release kernel/locking/lockdep.c:4242 [inline]
 lock_release+0x5f2/0x960 kernel/locking/lockdep.c:4503
 sock_release_ownership include/net/sock.h:1496 [inline]
 release_sock+0x17c/0x1c0 net/core/sock.c:2961
 gtp_encap_enable_socket+0x146/0x400 drivers/net/gtp.c:830
 gtp_encap_enable drivers/net/gtp.c:852 [inline]
 gtp_newlink+0x9fc/0xc60 drivers/net/gtp.c:666
 __rtnl_newlink+0x109e/0x1790 net/core/rtnetlink.c:3305
 rtnl_newlink+0x69/0xa0 net/core/rtnetlink.c:3363
 rtnetlink_rcv_msg+0x45e/0xaf0 net/core/rtnetlink.c:5424
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5442
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:659
 ____sys_sendmsg+0x753/0x880 net/socket.c:2330
 ___sys_sendmsg+0x100/0x170 net/socket.c:2384
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg net/socket.c:2424 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2424
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x445d49
Code: e8 bc b7 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 2b 12 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f8019074db8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006dac38 RCX: 0000000000445d49
RDX: 0000000000000000 RSI: 0000000020000180 RDI: 0000000000000003
RBP: 00000000006dac30 R08: 0000000000000004 R09: 0000000000000000
R10: 0000000000000008 R11: 0000000000000246 R12: 00000000006dac3c
R13: 00007ffea687f6bf R14: 00007f80190759c0 R15: 20c49ba5e353f7cf

Fixes: e198987e7dd7 ("gtp: fix suspicious RCU usage")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/gtp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index fca471e27f39dff77cb3449322bbf28e9cd2f94b..f6222ada68188e8201122a02da5cb3f2f254d1d0 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -813,7 +813,7 @@ static struct sock *gtp_encap_enable_socket(int fd, int type,
 	lock_sock(sock->sk);
 	if (sock->sk->sk_user_data) {
 		sk = ERR_PTR(-EBUSY);
-		goto out_sock;
+		goto out_rel_sock;
 	}
 
 	sk = sock->sk;
@@ -826,8 +826,9 @@ static struct sock *gtp_encap_enable_socket(int fd, int type,
 
 	setup_udp_tunnel_sock(sock_net(sock->sk), sock, &tuncfg);
 
-out_sock:
+out_rel_sock:
 	release_sock(sock->sk);
+out_sock:
 	sockfd_put(sock);
 	return sk;
 }
-- 
2.24.1.735.g03f4e72817-goog

