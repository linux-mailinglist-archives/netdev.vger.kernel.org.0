Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9135EF98A
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 17:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235776AbiI2Pw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 11:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234421AbiI2Pwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 11:52:55 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23CF4CDCCD
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 08:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1664466774; x=1696002774;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8aSAKc44QgJwZUq1xpcdgScrumZ/Q0qT1pdRJY8r3GM=;
  b=QxZxmsWK7ecQsIko2u8+J2xEykrzDQvXI1UalqG6Qh/dTocilWLPfQKZ
   EaHXohPFheJ6JRkbplNjnnxqMW4Tyf2qn0Im8hvc3dxxhb3WrHif6hNNB
   IezmdiD5sbYOgspkRiNqUwyAJdv3JoeA09BxuropGcm12SNIKf7DbBQ1Y
   s=;
X-IronPort-AV: E=Sophos;i="5.93,355,1654560000"; 
   d="scan'208";a="229560859"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-92ba9394.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 15:52:37 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-92ba9394.us-west-2.amazon.com (Postfix) with ESMTPS id 4914B45D1C;
        Thu, 29 Sep 2022 15:52:35 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 29 Sep 2022 15:52:34 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.214) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 29 Sep 2022 15:52:30 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Rao Shoaib <rao.shoaib@oracle.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, syzbot <syzkaller@googlegroups.com>
Subject: [PATCH v1 net] af_unix: Fix memory leaks of the whole sk due to OOB skb.
Date:   Thu, 29 Sep 2022 08:52:04 -0700
Message-ID: <20220929155204.6816-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.214]
X-ClientProxiedBy: EX13D16UWB001.ant.amazon.com (10.43.161.17) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported a sequence of memory leaks, and one of them indicated we
failed to free a whole sk:

  unreferenced object 0xffff8880126e0000 (size 1088):
    comm "syz-executor419", pid 326, jiffies 4294773607 (age 12.609s)
    hex dump (first 32 bytes):
      00 00 00 00 00 00 00 00 7d 00 00 00 00 00 00 00  ........}.......
      01 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
    backtrace:
      [<000000006fefe750>] sk_prot_alloc+0x64/0x2a0 net/core/sock.c:1970
      [<0000000074006db5>] sk_alloc+0x3b/0x800 net/core/sock.c:2029
      [<00000000728cd434>] unix_create1+0xaf/0x920 net/unix/af_unix.c:928
      [<00000000a279a139>] unix_create+0x113/0x1d0 net/unix/af_unix.c:997
      [<0000000068259812>] __sock_create+0x2ab/0x550 net/socket.c:1516
      [<00000000da1521e1>] sock_create net/socket.c:1566 [inline]
      [<00000000da1521e1>] __sys_socketpair+0x1a8/0x550 net/socket.c:1698
      [<000000007ab259e1>] __do_sys_socketpair net/socket.c:1751 [inline]
      [<000000007ab259e1>] __se_sys_socketpair net/socket.c:1748 [inline]
      [<000000007ab259e1>] __x64_sys_socketpair+0x97/0x100 net/socket.c:1748
      [<000000007dedddc1>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
      [<000000007dedddc1>] do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
      [<000000009456679f>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

We can reproduce this issue by creating two AF_UNIX SOCK_STREAM sockets,
send()ing an OOB skb to each other, and close()ing them without consuming
the OOB skbs.

  int skpair[2];

  socketpair(AF_UNIX, SOCK_STREAM, 0, skpair);

  send(skpair[0], "x", 1, MSG_OOB);
  send(skpair[1], "x", 1, MSG_OOB);

  close(skpair[0]);
  close(skpair[1]);

Currently, we free an OOB skb in unix_sock_destructor() which is called via
__sk_free(), but it's too late because the receiver's unix_sk(sk)->oob_skb
is accounted against the sender's sk->sk_wmem_alloc and __sk_free() is
called only when sk->sk_wmem_alloc is 0.

In the repro sequences, we do not consume the OOB skb, so both two sk's
sock_put() never reach __sk_free() due to the positive sk->sk_wmem_alloc.
Then, no one can consume the OOB skb nor call __sk_free(), and we finally
leak the two whole sk.

Thus, we must free the unconsumed OOB skb earlier when close()ing the
socket.

Fixes: 314001f0bf92 ("af_unix: Add OOB support")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/unix/af_unix.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index bf338b782fc4..d686804119c9 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -569,12 +569,6 @@ static void unix_sock_destructor(struct sock *sk)
 
 	skb_queue_purge(&sk->sk_receive_queue);
 
-#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
-	if (u->oob_skb) {
-		kfree_skb(u->oob_skb);
-		u->oob_skb = NULL;
-	}
-#endif
 	DEBUG_NET_WARN_ON_ONCE(refcount_read(&sk->sk_wmem_alloc));
 	DEBUG_NET_WARN_ON_ONCE(!sk_unhashed(sk));
 	DEBUG_NET_WARN_ON_ONCE(sk->sk_socket);
@@ -620,6 +614,13 @@ static void unix_release_sock(struct sock *sk, int embrion)
 
 	unix_state_unlock(sk);
 
+#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
+	if (u->oob_skb) {
+		kfree_skb(u->oob_skb);
+		u->oob_skb = NULL;
+	}
+#endif
+
 	wake_up_interruptible_all(&u->peer_wait);
 
 	if (skpair != NULL) {
-- 
2.30.2

