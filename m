Return-Path: <netdev+bounces-670-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B3CE46F8DF1
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 04:23:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64928281157
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 02:23:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05B5B15B2;
	Sat,  6 May 2023 02:23:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCB2139B
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 02:23:45 +0000 (UTC)
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38405B86
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 19:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1683339824; x=1714875824;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qOiSjhSINa7sgen4oEl7bOJ2v+KzkkaHUSV2gjwz1jc=;
  b=XpH4B2G/Id2NV2oBzZ4y3tbLdTy0cF5MrvwXLyALDaOjL7460u/CO+tK
   6AuKPKeSgWWLJFdbJbYgGIbfXKYJJjU0zBv6Q3WatnvWHHcoHrtGKhzxy
   9DyRK1DfaHmdlV57E6iWKl3WrZH0iTTmPqI4vGbXb/tdfG4E/pu/OqO8G
   Y=;
X-IronPort-AV: E=Sophos;i="5.99,253,1677542400"; 
   d="scan'208";a="322134784"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-94edd59b.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2023 02:23:41 +0000
Received: from EX19MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
	by email-inbound-relay-pdx-2c-m6i4x-94edd59b.us-west-2.amazon.com (Postfix) with ESMTPS id CD48040E64;
	Sat,  6 May 2023 02:23:39 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Sat, 6 May 2023 02:23:38 +0000
Received: from 88665a182662.ant.amazon.com (10.187.171.33) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.26;
 Sat, 6 May 2023 02:23:36 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>
CC: Kuniyuki Iwashima <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <netdev@vger.kernel.org>, syzbot
	<syzkaller@googlegroups.com>
Subject: [PATCH v1 net] net: Fix sk->sk_stamp race in sock_recv_cmsgs().
Date: Fri, 5 May 2023 19:23:25 -0700
Message-ID: <20230506022325.99106-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.171.33]
X-ClientProxiedBy: EX19D035UWA004.ant.amazon.com (10.13.139.109) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

KCSAN found a data race in sock_recv_cmsgs() [0] where the read access
to sk->sk_stamp needs READ_ONCE().

Also, there is another race below.  If the torn load of the high 32-bits
precedes WRITE_ONCE(sk, skb->tstamp) and later the written lower 32-bits
happens to match with SK_DEFAULT_STAMP, the final result of sk->sk_stamp
could be 0.

  sock_recv_cmsgs()  ioctl(SIOCGSTAMP)      sock_recv_cmsgs()
  |                  |                      |
  |- if (sock_flag(sk, SOCK_TIMESTAMP))     |
  |                  |                      |
  |                  `- sock_set_flag(sk, SOCK_TIMESTAMP)
  |                                         |
  |                                          `- if (sock_flag(sk, SOCK_TIMESTAMP))
  `- if (sk->sk_stamp == SK_DEFAULT_STAMP)      `- sock_write_timestamp(sk, skb->tstamp)
      `- sock_write_timestamp(sk, 0)

Even with READ_ONCE(), we could get the same result if READ_ONCE() precedes
WRITE_ONCE() because the SK_DEFAULT_STAMP check and WRITE_ONCE(sk_stamp, 0)
are not atomic.

Let's avoid the race by cmpxchg() on 64-bits architecture or seqlock on
32-bits machines.

[0]:
BUG: KCSAN: data-race in packet_recvmsg / packet_recvmsg

write (marked) to 0xffff88803c81f258 of 8 bytes by task 19171 on cpu 0:
 sock_write_timestamp include/net/sock.h:2670 [inline]
 sock_recv_cmsgs include/net/sock.h:2722 [inline]
 packet_recvmsg+0xb97/0xd00 net/packet/af_packet.c:3489
 sock_recvmsg_nosec net/socket.c:1019 [inline]
 sock_recvmsg+0x11a/0x130 net/socket.c:1040
 sock_read_iter+0x176/0x220 net/socket.c:1118
 call_read_iter include/linux/fs.h:1845 [inline]
 new_sync_read fs/read_write.c:389 [inline]
 vfs_read+0x5e0/0x630 fs/read_write.c:470
 ksys_read+0x163/0x1a0 fs/read_write.c:613
 __do_sys_read fs/read_write.c:623 [inline]
 __se_sys_read fs/read_write.c:621 [inline]
 __x64_sys_read+0x41/0x50 fs/read_write.c:621
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3b/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

read to 0xffff88803c81f258 of 8 bytes by task 19183 on cpu 1:
 sock_recv_cmsgs include/net/sock.h:2721 [inline]
 packet_recvmsg+0xb64/0xd00 net/packet/af_packet.c:3489
 sock_recvmsg_nosec net/socket.c:1019 [inline]
 sock_recvmsg+0x11a/0x130 net/socket.c:1040
 sock_read_iter+0x176/0x220 net/socket.c:1118
 call_read_iter include/linux/fs.h:1845 [inline]
 new_sync_read fs/read_write.c:389 [inline]
 vfs_read+0x5e0/0x630 fs/read_write.c:470
 ksys_read+0x163/0x1a0 fs/read_write.c:613
 __do_sys_read fs/read_write.c:623 [inline]
 __se_sys_read fs/read_write.c:621 [inline]
 __x64_sys_read+0x41/0x50 fs/read_write.c:621
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3b/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

value changed: 0xffffffffc4653600 -> 0x0000000000000000

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 19183 Comm: syz-executor.5 Not tainted 6.3.0-rc7-02330-gca6270c12e20 #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014

Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/sock.h | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 8b7ed7167243..c2a8b799283e 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2671,6 +2671,20 @@ static inline void sock_write_timestamp(struct sock *sk, ktime_t kt)
 #endif
 }
 
+#define SK_DEFAULT_STAMP (-1L * NSEC_PER_SEC)
+
+static inline void sock_zero_timestamp(struct sock *sk)
+{
+#if BITS_PER_LONG==32
+	write_seqlock(&sk->sk_stamp_seq);
+	if (sk->sk_stamp == SK_DEFAULT_STAMP)
+		sk->sk_stamp = 0;
+	write_sequnlock(&sk->sk_stamp_seq);
+#else
+	cmpxchg(&sk->sk_stamp, SK_DEFAULT_STAMP, 0);
+#endif
+}
+
 void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
 			   struct sk_buff *skb);
 void __sock_recv_wifi_status(struct msghdr *msg, struct sock *sk,
@@ -2704,7 +2718,6 @@ sock_recv_timestamp(struct msghdr *msg, struct sock *sk, struct sk_buff *skb)
 void __sock_recv_cmsgs(struct msghdr *msg, struct sock *sk,
 		       struct sk_buff *skb);
 
-#define SK_DEFAULT_STAMP (-1L * NSEC_PER_SEC)
 static inline void sock_recv_cmsgs(struct msghdr *msg, struct sock *sk,
 				   struct sk_buff *skb)
 {
@@ -2718,8 +2731,8 @@ static inline void sock_recv_cmsgs(struct msghdr *msg, struct sock *sk,
 		__sock_recv_cmsgs(msg, sk, skb);
 	else if (unlikely(sock_flag(sk, SOCK_TIMESTAMP)))
 		sock_write_timestamp(sk, skb->tstamp);
-	else if (unlikely(sk->sk_stamp == SK_DEFAULT_STAMP))
-		sock_write_timestamp(sk, 0);
+	else
+		sock_zero_timestamp(sk);
 }
 
 void __sock_tx_timestamp(__u16 tsflags, __u8 *tx_flags);
-- 
2.30.2


