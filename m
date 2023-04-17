Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 694916E4EE2
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 19:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjDQRMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 13:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjDQRMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 13:12:15 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC59F5589
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 10:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1681751534; x=1713287534;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=22q3oOA/w/w112QFYNoaJwkDOHw/JpXRVf0koc1ogCI=;
  b=aYmgGGCQ1lxgoE+RKiH9Bgc88LXJHRDSduBdeJyIJ3V+ktxHmPd9Om2n
   gf44oBID+YXW3eLQ5wQh+Mjhblqc5jfIU3Gq2ztN0uWB+3i/AoUSyPXzY
   NHewdKekYNAiwkUiecBtSNaRuh+bppOngoWihjVo+12vvdkZ1Um681CSb
   E=;
X-IronPort-AV: E=Sophos;i="5.99,204,1677542400"; 
   d="scan'208";a="205339810"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-d40ec5a9.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 17:12:10 +0000
Received: from EX19MTAUWA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-d40ec5a9.us-west-2.amazon.com (Postfix) with ESMTPS id 4460141557;
        Mon, 17 Apr 2023 17:12:09 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 17 Apr 2023 17:12:08 +0000
Received: from 88665a182662.ant.amazon.com.com (10.94.51.151) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 17 Apr 2023 17:12:06 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Willem de Bruijn <willemb@google.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, syzbot <syzkaller@googlegroups.com>
Subject: [PATCH v1 net] udp: Fix memleaks of sk and zerocopy skbs with TX timestamp.
Date:   Mon, 17 Apr 2023 10:11:55 -0700
Message-ID: <20230417171155.22916-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.94.51.151]
X-ClientProxiedBy: EX19D038UWB004.ant.amazon.com (10.13.139.177) To
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

To avoid this problem, we must call skb_queue_purge() while we close()
UDP sockets.

Note that TCP does not have this problem because skb_queue_purge() is
called by sk_stream_kill_queues() during close().

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

Fixes: b5947e5d1e71 ("udp: msg_zerocopy")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/udp.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/net/udp.h b/include/net/udp.h
index de4b528522bb..b9182f166b2f 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -195,6 +195,11 @@ void udp_lib_rehash(struct sock *sk, u16 new_hash);
 
 static inline void udp_lib_close(struct sock *sk, long timeout)
 {
+	/* A zerocopy skb has a refcnt of sk and may be
+	 * put into sk_error_queue with TX timestamp
+	 */
+	skb_queue_purge(&sk->sk_error_queue);
+
 	sk_common_release(sk);
 }
 
-- 
2.30.2

