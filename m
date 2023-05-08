Return-Path: <netdev+bounces-922-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC8406FB622
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 19:56:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A54501C20A41
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 17:56:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56DEE79DE;
	Mon,  8 May 2023 17:56:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473A24424
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 17:56:04 +0000 (UTC)
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9692B3599
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 10:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1683568562; x=1715104562;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=siKAywfkJKMAwL8zoP+kP8YwQNkaeXZxuuzc1BPiB94=;
  b=L25t2G6r7womeAG6e/Xexw9c2Fz0R18Bb8EHJzc52X57l/aL+d0pJ06X
   qt14AEBosfbU6QE+mFLhNj70ZTXGJ/OTxUKehLoZRiih2Mz+HFEKBY0Nz
   Y4QxaIlMsgWhJDFAMBBZlhcHYKRaBuD4H7CIaCSLXrLtu+qUB93p9tLaO
   0=;
X-IronPort-AV: E=Sophos;i="5.99,259,1677542400"; 
   d="scan'208";a="327278906"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-1box-2bm6-32cf6363.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 17:55:56 +0000
Received: from EX19MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
	by email-inbound-relay-pdx-1box-2bm6-32cf6363.us-west-2.amazon.com (Postfix) with ESMTPS id BEDD182156;
	Mon,  8 May 2023 17:55:55 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 8 May 2023 17:55:55 +0000
Received: from 88665a182662.ant.amazon.com.com (10.187.170.41) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 8 May 2023 17:55:52 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>
CC: Kuniyuki Iwashima <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <netdev@vger.kernel.org>, syzbot
	<syzkaller@googlegroups.com>
Subject: [PATCH v3 net] net: Fix load-tearing on sk->sk_stamp in sock_recv_cmsgs().
Date: Mon, 8 May 2023 10:55:43 -0700
Message-ID: <20230508175543.55756-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.170.41]
X-ClientProxiedBy: EX19D044UWA001.ant.amazon.com (10.13.139.100) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
	T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

KCSAN found a data race in sock_recv_cmsgs() where the read access
to sk->sk_stamp needs READ_ONCE().

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

Fixes: 6c7c98bad488 ("sock: avoid dirtying sk_stamp, if possible")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
v3:
  * Use sock_read_timestamp() instead of cmpxchg().

v2: https://lore.kernel.org/netdev/20230508165815.45602-1-kuniyu@amazon.com/
  * Add Fixes tag

v1: https://lore.kernel.org/netdev/20230506022325.99106-1-kuniyu@amazon.com/
---
 include/net/sock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 8b7ed7167243..656ea89f60ff 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2718,7 +2718,7 @@ static inline void sock_recv_cmsgs(struct msghdr *msg, struct sock *sk,
 		__sock_recv_cmsgs(msg, sk, skb);
 	else if (unlikely(sock_flag(sk, SOCK_TIMESTAMP)))
 		sock_write_timestamp(sk, skb->tstamp);
-	else if (unlikely(sk->sk_stamp == SK_DEFAULT_STAMP))
+	else if (unlikely(sock_read_timestamp(sk) == SK_DEFAULT_STAMP))
 		sock_write_timestamp(sk, 0);
 }
 
-- 
2.30.2


