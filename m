Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED9E144C62
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 08:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgAVHRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 02:17:18 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:58899 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgAVHRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 02:17:18 -0500
Received: by mail-pj1-f73.google.com with SMTP id ie20so3530649pjb.8
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 23:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=hNIhzpSyw9cAvuPktaprfKceN62Vrz4AqH7p8jdq2ps=;
        b=Xx2K0zRgAztcwRPcDj8WCB2u7sPl6APNG+QiaolDZomCZ3jCzEuhgoKkro/tmOYWAy
         4WiMokgFi1ahHQ39KkrjagtlQiKi9W5okRJzOFwQtlN2XTThHcKW1o5szHMrNsVN0hfT
         SztPeq5fMmagw1bJYkj34r5NHjcI/UbMFahXSlknmPGpKxTsWRKs666ZVCkECmveJJh+
         mFRPSZWjNhsIOyI5fVQ7Cpc7cGAZbeE9Rx8Ym6rsGy9qr22etHJk5xeaOV0CnthpcjrY
         wU7IogyHzCrfkVCQT5oDxTh2ST+FSpfhSE4KJ23Wpfn/WCZVNzE/laZtAp1i/YkDfahe
         eTOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=hNIhzpSyw9cAvuPktaprfKceN62Vrz4AqH7p8jdq2ps=;
        b=dIG/yBbFf5WX0NumMrhlLtWhInkkiosu3nwgNmRt//MGm2eDtya+Mjwf0ndAId5bqI
         68cI3QvXnVQ9QF/HqQyRWJxYBclOWFnDHXMMsF+BagM3cxCgxOqgYvUKZufGcXClebke
         uNFm6SGAV2kw8HRrtBxgbzXkgy6j/S0C5viy3S499QRjisgn82pi1kg1UyfHxEfOZAZ6
         +cxJrLgtiY/1dUqBgGaqtQsAI13O0aZXZOvvYA/lzrR01WmTOuZSEJoLiD44DwEkSoeI
         M5UEMfadOwUTtt1o8eAtVxrUU582Jr03Ng/HNxk+Pl7mKdt03QtvWSDViBEC040OETQJ
         t2hA==
X-Gm-Message-State: APjAAAUvvHx9oOKUXd1avqPMChgSaCZUK6Dq8cz7E1RXkZTRh77vuDPq
        1tpTO4UnhZSC0eRTWRFl61rY5miydwXjBw==
X-Google-Smtp-Source: APXvYqyXfS9ypnlse4roKDvi2sJWW8ErO07Wso57z8ZH/ehRtkg38T4iBGjQitZ9DMv9y2TEW+RnQH7PKZr3zQ==
X-Received: by 2002:a63:d157:: with SMTP id c23mr9730952pgj.242.1579677437279;
 Tue, 21 Jan 2020 23:17:17 -0800 (PST)
Date:   Tue, 21 Jan 2020 23:17:14 -0800
Message-Id: <20200122071714.150259-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH net] gtp: make sure only SOCK_DGRAM UDP sockets are accepted
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Pablo Neira <pablo@netfilter.org>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A malicious user could use RAW sockets and fool
GTP using them as standard SOCK_DGRAM UDP sockets.

BUG: KMSAN: uninit-value in udp_tunnel_encap_enable include/net/udp_tunnel.h:174 [inline]
BUG: KMSAN: uninit-value in setup_udp_tunnel_sock+0x45e/0x6f0 net/ipv4/udp_tunnel.c:85
CPU: 0 PID: 11262 Comm: syz-executor613 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 udp_tunnel_encap_enable include/net/udp_tunnel.h:174 [inline]
 setup_udp_tunnel_sock+0x45e/0x6f0 net/ipv4/udp_tunnel.c:85
 gtp_encap_enable_socket+0x37f/0x5a0 drivers/net/gtp.c:827
 gtp_encap_enable drivers/net/gtp.c:844 [inline]
 gtp_newlink+0xfb/0x1e50 drivers/net/gtp.c:666
 __rtnl_newlink net/core/rtnetlink.c:3305 [inline]
 rtnl_newlink+0x2973/0x3920 net/core/rtnetlink.c:3363
 rtnetlink_rcv_msg+0x1153/0x1570 net/core/rtnetlink.c:5424
 netlink_rcv_skb+0x451/0x650 net/netlink/af_netlink.c:2477
 rtnetlink_rcv+0x50/0x60 net/core/rtnetlink.c:5442
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0xf9e/0x1100 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x1248/0x14d0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg net/socket.c:659 [inline]
 ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2330
 ___sys_sendmsg net/socket.c:2384 [inline]
 __sys_sendmsg+0x451/0x5f0 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2424
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2424
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x441359
Code: e8 ac e8 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 eb 08 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff1cd0ac28 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441359
RDX: 0000000000000000 RSI: 0000000020000100 RDI: 0000000000000003
RBP: 00000000006cb018 R08: 00000000004002c8 R09: 00000000004002c8
R10: 00000000004002c8 R11: 0000000000000246 R12: 00000000004020d0
R13: 0000000000402160 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
 kmsan_save_stack_with_flags+0x3c/0x90 mm/kmsan/kmsan.c:144
 kmsan_internal_alloc_meta_for_pages mm/kmsan/kmsan_shadow.c:307 [inline]
 kmsan_alloc_page+0x12a/0x310 mm/kmsan/kmsan_shadow.c:336
 __alloc_pages_nodemask+0x57f2/0x5f60 mm/page_alloc.c:4800
 alloc_pages_current+0x67d/0x990 mm/mempolicy.c:2207
 alloc_pages include/linux/gfp.h:534 [inline]
 alloc_slab_page+0x111/0x12f0 mm/slub.c:1511
 allocate_slab mm/slub.c:1656 [inline]
 new_slab+0x2bc/0x1130 mm/slub.c:1722
 new_slab_objects mm/slub.c:2473 [inline]
 ___slab_alloc+0x1533/0x1f30 mm/slub.c:2624
 __slab_alloc mm/slub.c:2664 [inline]
 slab_alloc_node mm/slub.c:2738 [inline]
 slab_alloc mm/slub.c:2783 [inline]
 kmem_cache_alloc+0xb23/0xd70 mm/slub.c:2788
 sk_prot_alloc+0xf2/0x620 net/core/sock.c:1597
 sk_alloc+0xf0/0xbe0 net/core/sock.c:1657
 inet_create+0x7c7/0x1370 net/ipv4/af_inet.c:321
 __sock_create+0x8eb/0xf00 net/socket.c:1420
 sock_create net/socket.c:1471 [inline]
 __sys_socket+0x1a1/0x600 net/socket.c:1513
 __do_sys_socket net/socket.c:1522 [inline]
 __se_sys_socket+0x8d/0xb0 net/socket.c:1520
 __x64_sys_socket+0x4a/0x70 net/socket.c:1520
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 459aa660eb1d ("gtp: add initial driver for datapath of GPRS Tunneling Protocol (GTP-U)")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Pablo Neira <pablo@netfilter.org>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 drivers/net/gtp.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index f6222ada68188e8201122a02da5cb3f2f254d1d0..9b3ba98726d7c98ed67acdda9fbb5a4bc7f3aa9f 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -804,19 +804,21 @@ static struct sock *gtp_encap_enable_socket(int fd, int type,
 		return NULL;
 	}
 
-	if (sock->sk->sk_protocol != IPPROTO_UDP) {
+	sk = sock->sk;
+	if (sk->sk_protocol != IPPROTO_UDP ||
+	    sk->sk_type != SOCK_DGRAM ||
+	    (sk->sk_family != AF_INET && sk->sk_family != AF_INET6)) {
 		pr_debug("socket fd=%d not UDP\n", fd);
 		sk = ERR_PTR(-EINVAL);
 		goto out_sock;
 	}
 
-	lock_sock(sock->sk);
-	if (sock->sk->sk_user_data) {
+	lock_sock(sk);
+	if (sk->sk_user_data) {
 		sk = ERR_PTR(-EBUSY);
 		goto out_rel_sock;
 	}
 
-	sk = sock->sk;
 	sock_hold(sk);
 
 	tuncfg.sk_user_data = gtp;
-- 
2.25.0.341.g760bfbb309-goog

