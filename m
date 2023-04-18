Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0383F6E6BBB
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 20:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjDRSJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 14:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232450AbjDRSJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 14:09:09 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B092718
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 11:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1681841348; x=1713377348;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=t7i6P6zTZruAnp5QT/UErqvdAhyp/PGSiVziru6kM0o=;
  b=KhHMpzohem2NsfGwPBVqj7lIw9UtgIA550pQ0OZacyEZ+d+5U9jEN7Ye
   VKX2IMVRZ5dEYCAjH+Ki3422m7o34+u/ouzUH3CkLSyKVVbFjZtPInFha
   a8xGvm8iYQVT8z7BUeqv0u3TQDs0u9K7+k1W87Rv9CWcAS6zn4DOY5Ktc
   0=;
X-IronPort-AV: E=Sophos;i="5.99,207,1677542400"; 
   d="scan'208";a="321860061"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-9fe6ad2f.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 18:09:03 +0000
Received: from EX19MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-9fe6ad2f.us-east-1.amazon.com (Postfix) with ESMTPS id 710D580CE6;
        Tue, 18 Apr 2023 18:09:01 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Tue, 18 Apr 2023 18:08:51 +0000
Received: from 88665a182662.ant.amazon.com.com (10.106.101.27) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 18 Apr 2023 18:08:48 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Willem de Bruijn <willemb@google.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, syzbot <syzkaller@googlegroups.com>
Subject: [PATCH v2 net] tcp/udp: Fix memleaks of sk and zerocopy skbs with TX timestamp.
Date:   Tue, 18 Apr 2023 11:08:32 -0700
Message-ID: <20230418180832.81430-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.101.27]
X-ClientProxiedBy: EX19D041UWA003.ant.amazon.com (10.13.139.105) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzkaller reported [0] memory leaks of an UDP socket and ZEROCOPY
skbs.  We can reproduce the problem with these sequences:

  sk = socket(AF_INET, SOCK_DGRAM, 0)
  sk.setsockopt(SOL_SOCKET, SO_TIMESTAMPING, SOF_TIMESTAMPING_TX_SOFTWARE)
  sk.setsockopt(SOL_SOCKET, SO_ZEROCOPY, 1)
  sk.sendto(b'', MSG_ZEROCOPY, ('127.0.0.1', 53))
  sk.close()

sendmsg() calls msg_zerocopy_alloc(), which allocates a skb, sets
skb->cb->ubuf.refcnt to 1, and calls sock_hold().  Here, struct
ubuf_info_msgzc indirectly holds a refcnt of the socket.  When the
skb is sent, __skb_tstamp_tx() clones it and puts the clone into
the socket's error queue with the TX timestamp.

When the original skb is received locally, skb_copy_ubufs() calls
skb_unclone(), and pskb_expand_head() increments skb->cb->ubuf.refcnt.
This additional count is decremented while freeing the skb, but struct
ubuf_info_msgzc still has a refcnt, so __msg_zerocopy_callback() is
not called.

The last refcnt is not released unless we retrieve the TX timestamped
skb by recvmsg().  When we close() the socket holding such skb, we
never call sock_put() and leak the count, skb, and sk.

To avoid this problem, we must (i) call skb_queue_purge() after
flagging SOCK_DEAD during close() and (ii) make sure that TX tstamp
skb is not queued when SOCK_DEAD is flagged.  UDP lacks (i) and (ii),
and TCP lacks (ii).

Without (ii), a skb queued in a qdisc or device could be put into
the error queue after skb_queue_purge().

  sendmsg() /* return immediately, but packets
             * are queued in a qdisc or device
             */
                                    close()
                                      skb_queue_purge()
  __skb_tstamp_tx()
    __skb_complete_tx_timestamp()
      sock_queue_err_skb()
        skb_queue_tail()

Also, we need to check SOCK_DEAD under sk->sk_error_queue.lock
in sock_queue_err_skb() to avoid this race.

  if (!sock_flag(sk, SOCK_DEAD))
                                    sock_set_flag(sk, SOCK_DEAD)
                                    skb_queue_purge()

    skb_queue_tail()

[0]:
BUG: memory leak
unreferenced object 0xffff88800c6d2d00 (size 1152):
  comm "syz-executor392", pid 264, jiffies 4294785440 (age 13.044s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 cd af e8 81 00 00 00 00  ................
    02 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
  backtrace:
    [<0000000055636812>] sk_prot_alloc+0x64/0x2a0 net/core/sock.c:2024
    [<0000000054d77b7a>] sk_alloc+0x3b/0x800 net/core/sock.c:2083
    [<0000000066f3c7e0>] inet_create net/ipv4/af_inet.c:319 [inline]
    [<0000000066f3c7e0>] inet_create+0x31e/0xe40 net/ipv4/af_inet.c:245
    [<000000009b83af97>] __sock_create+0x2ab/0x550 net/socket.c:1515
    [<00000000b9b11231>] sock_create net/socket.c:1566 [inline]
    [<00000000b9b11231>] __sys_socket_create net/socket.c:1603 [inline]
    [<00000000b9b11231>] __sys_socket_create net/socket.c:1588 [inline]
    [<00000000b9b11231>] __sys_socket+0x138/0x250 net/socket.c:1636
    [<000000004fb45142>] __do_sys_socket net/socket.c:1649 [inline]
    [<000000004fb45142>] __se_sys_socket net/socket.c:1647 [inline]
    [<000000004fb45142>] __x64_sys_socket+0x73/0xb0 net/socket.c:1647
    [<0000000066999e0e>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<0000000066999e0e>] do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
    [<0000000017f238c1>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

BUG: memory leak
unreferenced object 0xffff888017633a00 (size 240):
  comm "syz-executor392", pid 264, jiffies 4294785440 (age 13.044s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 2d 6d 0c 80 88 ff ff  .........-m.....
  backtrace:
    [<000000002b1c4368>] __alloc_skb+0x229/0x320 net/core/skbuff.c:497
    [<00000000143579a6>] alloc_skb include/linux/skbuff.h:1265 [inline]
    [<00000000143579a6>] sock_omalloc+0xaa/0x190 net/core/sock.c:2596
    [<00000000be626478>] msg_zerocopy_alloc net/core/skbuff.c:1294 [inline]
    [<00000000be626478>] msg_zerocopy_realloc+0x1ce/0x7f0 net/core/skbuff.c:1370
    [<00000000cbfc9870>] __ip_append_data+0x2adf/0x3b30 net/ipv4/ip_output.c:1037
    [<0000000089869146>] ip_make_skb+0x26c/0x2e0 net/ipv4/ip_output.c:1652
    [<00000000098015c2>] udp_sendmsg+0x1bac/0x2390 net/ipv4/udp.c:1253
    [<0000000045e0e95e>] inet_sendmsg+0x10a/0x150 net/ipv4/af_inet.c:819
    [<000000008d31bfde>] sock_sendmsg_nosec net/socket.c:714 [inline]
    [<000000008d31bfde>] sock_sendmsg+0x141/0x190 net/socket.c:734
    [<0000000021e21aa4>] __sys_sendto+0x243/0x360 net/socket.c:2117
    [<00000000ac0af00c>] __do_sys_sendto net/socket.c:2129 [inline]
    [<00000000ac0af00c>] __se_sys_sendto net/socket.c:2125 [inline]
    [<00000000ac0af00c>] __x64_sys_sendto+0xe1/0x1c0 net/socket.c:2125
    [<0000000066999e0e>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<0000000066999e0e>] do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
    [<0000000017f238c1>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: f214f915e7db ("tcp: enable MSG_ZEROCOPY")
Fixes: b5947e5d1e71 ("udp: msg_zerocopy")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
v2:
  * Move skb_queue_purge() after setting SOCK_DEAD in udp_destroy_sock()
  * Check SOCK_DEAD in sock_queue_err_skb() with sk_error_queue.lock
  * Add Fixes tag for TCP

v1: https://lore.kernel.org/netdev/20230417171155.22916-1-kuniyu@amazon.com/
---
 net/core/skbuff.c | 15 ++++++++++++---
 net/ipv4/udp.c    |  5 +++++
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 4c0879798eb8..287b834df9c8 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4979,6 +4979,8 @@ static void skb_set_err_queue(struct sk_buff *skb)
  */
 int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb)
 {
+	unsigned long flags;
+
 	if (atomic_read(&sk->sk_rmem_alloc) + skb->truesize >=
 	    (unsigned int)READ_ONCE(sk->sk_rcvbuf))
 		return -ENOMEM;
@@ -4992,9 +4994,16 @@ int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb)
 	/* before exiting rcu section, make sure dst is refcounted */
 	skb_dst_force(skb);
 
-	skb_queue_tail(&sk->sk_error_queue, skb);
-	if (!sock_flag(sk, SOCK_DEAD))
-		sk_error_report(sk);
+	spin_lock_irqsave(&sk->sk_error_queue.lock, flags);
+	if (sock_flag(sk, SOCK_DEAD)) {
+		spin_unlock_irqrestore(&sk->sk_error_queue.lock, flags);
+		return -EINVAL;
+	}
+	__skb_queue_tail(&sk->sk_error_queue, skb);
+	spin_unlock_irqrestore(&sk->sk_error_queue.lock, flags);
+
+	sk_error_report(sk);
+
 	return 0;
 }
 EXPORT_SYMBOL(sock_queue_err_skb);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index c605d171eb2d..7060a5cda711 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2674,6 +2674,11 @@ void udp_destroy_sock(struct sock *sk)
 		if (up->encap_enabled)
 			static_branch_dec(&udp_encap_needed_key);
 	}
+
+	/* A zerocopy skb has a refcnt of sk and may be
+	 * put into sk_error_queue with TX timestamp
+	 */
+	skb_queue_purge(&sk->sk_error_queue);
 }
 
 /*
-- 
2.30.2

