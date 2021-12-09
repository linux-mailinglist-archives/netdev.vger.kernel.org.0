Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7AF746F35D
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 19:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhLISyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 13:54:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhLISyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 13:54:37 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E18C061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 10:51:03 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id y7so4623443plp.0
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 10:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GyAGEu0bAhk+8OIaGywzYwwmiqK3De3LhRAFJTgTRgM=;
        b=MermTH94Mpg0JSutnOHFSlnwO0PoJMWAjriqB956fDt0Ak/mRTNPyVIH58ucfQnhn6
         92NuZzvCfPza3S515uDTK6s5F5296MTHUkR4M8mCgYYlXUzqadkwo0IdJnPJ1y1d53fG
         G6SqagMKg1CuMy5flo7H4YEgS7O0CTAa/kEoSaQ5Ulqwq6S2S3o3bHcbPBkRKv7DdrLk
         Adh/ZESOfLQ0EzPQIobVrXFuSs39Loj5s7pEzsQI9CMYkg4P31API4P9L++ozGuK6YFn
         nqVtruOrLXsK0A0s/TBar2v117IdDmki6U/gjOE/M5YRVjmyfYTtB64goHHBIaS+BV8Q
         gdKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GyAGEu0bAhk+8OIaGywzYwwmiqK3De3LhRAFJTgTRgM=;
        b=xcnzyXon6aZf1HmPJnLiqhRBFjkieq8owCD6WSRxFwTninlMbuhAkMhhKMYYSf3cZN
         dKfUOcDfRTXTS/npMMBvCYcfXhkOjCLkoZGC6wW+z0Qy4jGuj1NcZvjPcySdqwpfXuRI
         D+l1669hdg1+ljDO758ix3UvppW/XGZlOth97rsD+xovzox89XSS2GAp7EmuuDN5CyjH
         C7sQoAte/qBIUXz6g9QTCpWJJAf3gcHH6t6YJ9rfFKfJXN+DKcKwquBy+M4a6mJQQgb/
         amxlI2y1yKaT8+28VzeEzBQoFlz6/EzJRr56uffF3f012ekczgqxJNhqYEDh1WvvxXHu
         qTGQ==
X-Gm-Message-State: AOAM5308Q5IO577rIm2YPracXQ26+CesOu3Fot+ETDCC6BlytKNO7z7I
        8BmbJr0UE8so56fT6dDmA6w=
X-Google-Smtp-Source: ABdhPJzREPgK8C/2bRV5bdZ9fJ1POGnC4/NA6saTWOR/AOD/dwGCiSTtolZMLFtxHba2k7PDiUkz9A==
X-Received: by 2002:a17:90b:3ecc:: with SMTP id rm12mr17975175pjb.22.1639075863190;
        Thu, 09 Dec 2021 10:51:03 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4f5:a6b4:3889:ebe5])
        by smtp.gmail.com with ESMTPSA id m6sm343970pgs.18.2021.12.09.10.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 10:51:02 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] inet_diag: fix kernel-infoleak for UDP sockets
Date:   Thu,  9 Dec 2021 10:50:58 -0800
Message-Id: <20211209185058.53917-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

KMSAN reported a kernel-infoleak [1], that can exploited
by unpriv users.

After analysis it turned out UDP was not initializing
r->idiag_expires. Other users of inet_sk_diag_fill()
might make the same mistake in the future, so fix this
in inet_sk_diag_fill().

[1]
BUG: KMSAN: kernel-infoleak in instrument_copy_to_user include/linux/instrumented.h:121 [inline]
BUG: KMSAN: kernel-infoleak in copyout lib/iov_iter.c:156 [inline]
BUG: KMSAN: kernel-infoleak in _copy_to_iter+0x69d/0x25c0 lib/iov_iter.c:670
 instrument_copy_to_user include/linux/instrumented.h:121 [inline]
 copyout lib/iov_iter.c:156 [inline]
 _copy_to_iter+0x69d/0x25c0 lib/iov_iter.c:670
 copy_to_iter include/linux/uio.h:155 [inline]
 simple_copy_to_iter+0xf3/0x140 net/core/datagram.c:519
 __skb_datagram_iter+0x2cb/0x1280 net/core/datagram.c:425
 skb_copy_datagram_iter+0xdc/0x270 net/core/datagram.c:533
 skb_copy_datagram_msg include/linux/skbuff.h:3657 [inline]
 netlink_recvmsg+0x660/0x1c60 net/netlink/af_netlink.c:1974
 sock_recvmsg_nosec net/socket.c:944 [inline]
 sock_recvmsg net/socket.c:962 [inline]
 sock_read_iter+0x5a9/0x630 net/socket.c:1035
 call_read_iter include/linux/fs.h:2156 [inline]
 new_sync_read fs/read_write.c:400 [inline]
 vfs_read+0x1631/0x1980 fs/read_write.c:481
 ksys_read+0x28c/0x520 fs/read_write.c:619
 __do_sys_read fs/read_write.c:629 [inline]
 __se_sys_read fs/read_write.c:627 [inline]
 __x64_sys_read+0xdb/0x120 fs/read_write.c:627
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:524 [inline]
 slab_alloc_node mm/slub.c:3251 [inline]
 __kmalloc_node_track_caller+0xe0c/0x1510 mm/slub.c:4974
 kmalloc_reserve net/core/skbuff.c:354 [inline]
 __alloc_skb+0x545/0xf90 net/core/skbuff.c:426
 alloc_skb include/linux/skbuff.h:1126 [inline]
 netlink_dump+0x3d5/0x16a0 net/netlink/af_netlink.c:2245
 __netlink_dump_start+0xd1c/0xee0 net/netlink/af_netlink.c:2370
 netlink_dump_start include/linux/netlink.h:254 [inline]
 inet_diag_handler_cmd+0x2e7/0x400 net/ipv4/inet_diag.c:1343
 sock_diag_rcv_msg+0x24a/0x620
 netlink_rcv_skb+0x447/0x800 net/netlink/af_netlink.c:2491
 sock_diag_rcv+0x63/0x80 net/core/sock_diag.c:276
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x1095/0x1360 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x16f3/0x1870 net/netlink/af_netlink.c:1916
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 sock_write_iter+0x594/0x690 net/socket.c:1057
 do_iter_readv_writev+0xa7f/0xc70
 do_iter_write+0x52c/0x1500 fs/read_write.c:851
 vfs_writev fs/read_write.c:924 [inline]
 do_writev+0x63f/0xe30 fs/read_write.c:967
 __do_sys_writev fs/read_write.c:1040 [inline]
 __se_sys_writev fs/read_write.c:1037 [inline]
 __x64_sys_writev+0xe5/0x120 fs/read_write.c:1037
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Bytes 68-71 of 312 are uninitialized
Memory access of size 312 starts at ffff88812ab54000
Data copied to user address 0000000020001440

CPU: 1 PID: 6365 Comm: syz-executor801 Not tainted 5.16.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 3c4d05c80567 ("inet_diag: Introduce the inet socket dumping routine")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv4/inet_diag.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index c8fa6e7f7d1241691e048c868878b388e04b6f80..581b5b2d72a5bcc9c1ddf2b3664ef9ff669f63a5 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -261,6 +261,7 @@ int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
 	r->idiag_state = sk->sk_state;
 	r->idiag_timer = 0;
 	r->idiag_retrans = 0;
+	r->idiag_expires = 0;
 
 	if (inet_diag_msg_attrs_fill(sk, skb, r, ext,
 				     sk_user_ns(NETLINK_CB(cb->skb).sk),
@@ -314,9 +315,6 @@ int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
 		r->idiag_retrans = icsk->icsk_probes_out;
 		r->idiag_expires =
 			jiffies_delta_to_msecs(sk->sk_timer.expires - jiffies);
-	} else {
-		r->idiag_timer = 0;
-		r->idiag_expires = 0;
 	}
 
 	if ((ext & (1 << (INET_DIAG_INFO - 1))) && handler->idiag_info_size) {
-- 
2.34.1.173.g76aa8bc2d0-goog

