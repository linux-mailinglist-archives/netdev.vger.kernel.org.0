Return-Path: <netdev+bounces-1293-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B60DA6FD350
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 02:35:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE3251C20CA1
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 00:35:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0F84374;
	Wed, 10 May 2023 00:35:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D539362
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 00:35:47 +0000 (UTC)
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5661F2D7B
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 17:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1683678947; x=1715214947;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vRGwj9TmQn+NL1cHuG4ynyjy1mML9TlpemZFAb4/194=;
  b=Il+11J5nGRYgUN9wyVQSCbhZabJPCJGPH0XyMpkmoHsKQ1Nzlb8uDaGb
   SXcdM5Zgdq9Nklj2E/chOzM9qMDH4TMo+PVvDrSJWrWmlTK1MhxbnaL2U
   +cCdx7aY6Uk6A3i8WKZcxPYW0MFF9qr2Hka2yM9tWLrZ89Kj+ozZa67XK
   s=;
X-IronPort-AV: E=Sophos;i="5.99,263,1677542400"; 
   d="scan'208";a="212661507"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-153b24bc.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 00:35:44 +0000
Received: from EX19MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
	by email-inbound-relay-iad-1d-m6i4x-153b24bc.us-east-1.amazon.com (Postfix) with ESMTPS id 2096CC815A;
	Wed, 10 May 2023 00:35:39 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 10 May 2023 00:35:36 +0000
Received: from 88665a182662.ant.amazon.com (10.187.171.39) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.26;
 Wed, 10 May 2023 00:35:33 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>
CC: Kuniyuki Iwashima <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <netdev@vger.kernel.org>, syzbot
	<syzkaller@googlegroups.com>
Subject: [PATCH v1 net 1/2] af_unix: Fix a data race of sk->sk_receive_queue->qlen.
Date: Tue, 9 May 2023 17:34:55 -0700
Message-ID: <20230510003456.42357-2-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230510003456.42357-1-kuniyu@amazon.com>
References: <20230510003456.42357-1-kuniyu@amazon.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.171.39]
X-ClientProxiedBy: EX19D037UWC004.ant.amazon.com (10.13.139.254) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
	T_SPF_PERMERROR,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

KCSAN found a data race of sk->sk_receive_queue->qlen where recvmsg()
updates qlen under the queue lock and sendmsg() checks qlen under
unix_state_sock(), not the queue lock, so the reader side needs
READ_ONCE().

BUG: KCSAN: data-race in __skb_try_recv_from_queue / unix_wait_for_peer

write (marked) to 0xffff888019fe7c68 of 4 bytes by task 49792 on cpu 0:
 __skb_unlink include/linux/skbuff.h:2347 [inline]
 __skb_try_recv_from_queue+0x3de/0x470 net/core/datagram.c:197
 __skb_try_recv_datagram+0xf7/0x390 net/core/datagram.c:263
 __unix_dgram_recvmsg+0x109/0x8a0 net/unix/af_unix.c:2452
 unix_dgram_recvmsg+0x94/0xa0 net/unix/af_unix.c:2549
 sock_recvmsg_nosec net/socket.c:1019 [inline]
 ____sys_recvmsg+0x3a3/0x3b0 net/socket.c:2720
 ___sys_recvmsg+0xc8/0x150 net/socket.c:2764
 do_recvmmsg+0x182/0x560 net/socket.c:2858
 __sys_recvmmsg net/socket.c:2937 [inline]
 __do_sys_recvmmsg net/socket.c:2960 [inline]
 __se_sys_recvmmsg net/socket.c:2953 [inline]
 __x64_sys_recvmmsg+0x153/0x170 net/socket.c:2953
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3b/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

read to 0xffff888019fe7c68 of 4 bytes by task 49793 on cpu 1:
 skb_queue_len include/linux/skbuff.h:2127 [inline]
 unix_recvq_full net/unix/af_unix.c:229 [inline]
 unix_wait_for_peer+0x154/0x1a0 net/unix/af_unix.c:1445
 unix_dgram_sendmsg+0x13bc/0x14b0 net/unix/af_unix.c:2048
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg+0x148/0x160 net/socket.c:747
 ____sys_sendmsg+0x20e/0x620 net/socket.c:2503
 ___sys_sendmsg+0xc6/0x140 net/socket.c:2557
 __sys_sendmmsg+0x11d/0x370 net/socket.c:2643
 __do_sys_sendmmsg net/socket.c:2672 [inline]
 __se_sys_sendmmsg net/socket.c:2669 [inline]
 __x64_sys_sendmmsg+0x58/0x70 net/socket.c:2669
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3b/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

value changed: 0x0000000b -> 0x00000001

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 49793 Comm: syz-executor.0 Not tainted 6.3.0-rc7-02330-gca6270c12e20 #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/unix/af_unix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index fb31e8a4409e..08102e728b15 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1442,7 +1442,7 @@ static long unix_wait_for_peer(struct sock *other, long timeo)
 
 	sched = !sock_flag(other, SOCK_DEAD) &&
 		!(other->sk_shutdown & RCV_SHUTDOWN) &&
-		unix_recvq_full(other);
+		unix_recvq_full_lockless(other);
 
 	unix_state_unlock(other);
 
-- 
2.30.2


