Return-Path: <netdev+bounces-1294-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0171E6FD351
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 02:36:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0CFD91C20CA1
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 00:36:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C6E8374;
	Wed, 10 May 2023 00:36:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0000362
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 00:36:08 +0000 (UTC)
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA4430C2
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 17:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1683678968; x=1715214968;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J8wtdr+CeFiGUHP95jC91ezbdkme4RCsxQv4wagAA1I=;
  b=VOA9SNNwjn3yXxDMPCw7stOcGZMXDNJGoLtkSJLuMg8x/9ZgS8uBuwN5
   Cmfh0+v7atHcVVLo29gD6DHqZNGBxzqCfqDXl1kJnlkn2cbZRCdgTdQAG
   S6VafqywKZY9yyQp1dv53m//jMauuG5jwOmGiv0/v8gx+J/AqNuMpGYCv
   s=;
X-IronPort-AV: E=Sophos;i="5.99,263,1677542400"; 
   d="scan'208";a="337574823"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-b1c0e1d0.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 00:36:03 +0000
Received: from EX19MTAUWA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
	by email-inbound-relay-pdx-2c-m6i4x-b1c0e1d0.us-west-2.amazon.com (Postfix) with ESMTPS id 6AC838121B;
	Wed, 10 May 2023 00:36:01 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 10 May 2023 00:36:00 +0000
Received: from 88665a182662.ant.amazon.com (10.187.171.39) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 10 May 2023 00:35:58 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>
CC: Kuniyuki Iwashima <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <netdev@vger.kernel.org>, syzbot
	<syzkaller@googlegroups.com>, Rainer Weikusat <rweikusat@mssgmbh.com>
Subject: [PATCH v1 net 2/2] af_unix: Fix data races around sk->sk_shutdown.
Date: Tue, 9 May 2023 17:34:56 -0700
Message-ID: <20230510003456.42357-3-kuniyu@amazon.com>
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
X-ClientProxiedBy: EX19D046UWB001.ant.amazon.com (10.13.139.187) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
	T_SPF_PERMERROR,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

KCSAN found a data race around sk->sk_shutdown where unix_release_sock()
and unix_shutdown() update it under unix_state_lock(), OTOH unix_poll()
and unix_dgram_poll() read it locklessly.

We need to annotate the writes and reads with WRITE_ONCE() and READ_ONCE().

BUG: KCSAN: data-race in unix_poll / unix_release_sock

write to 0xffff88800d0f8aec of 1 bytes by task 264 on cpu 0:
 unix_release_sock+0x75c/0x910 net/unix/af_unix.c:631
 unix_release+0x59/0x80 net/unix/af_unix.c:1042
 __sock_release+0x7d/0x170 net/socket.c:653
 sock_close+0x19/0x30 net/socket.c:1397
 __fput+0x179/0x5e0 fs/file_table.c:321
 ____fput+0x15/0x20 fs/file_table.c:349
 task_work_run+0x116/0x1a0 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x174/0x180 kernel/entry/common.c:204
 __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
 syscall_exit_to_user_mode+0x1a/0x30 kernel/entry/common.c:297
 do_syscall_64+0x4b/0x90 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

read to 0xffff88800d0f8aec of 1 bytes by task 222 on cpu 1:
 unix_poll+0xa3/0x2a0 net/unix/af_unix.c:3170
 sock_poll+0xcf/0x2b0 net/socket.c:1385
 vfs_poll include/linux/poll.h:88 [inline]
 ep_item_poll.isra.0+0x78/0xc0 fs/eventpoll.c:855
 ep_send_events fs/eventpoll.c:1694 [inline]
 ep_poll fs/eventpoll.c:1823 [inline]
 do_epoll_wait+0x6c4/0xea0 fs/eventpoll.c:2258
 __do_sys_epoll_wait fs/eventpoll.c:2270 [inline]
 __se_sys_epoll_wait fs/eventpoll.c:2265 [inline]
 __x64_sys_epoll_wait+0xcc/0x190 fs/eventpoll.c:2265
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3b/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

value changed: 0x00 -> 0x03

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 222 Comm: dbus-broker Not tainted 6.3.0-rc7-02330-gca6270c12e20 #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014

Fixes: 3c73419c09a5 ("af_unix: fix 'poll for write'/ connected DGRAM sockets")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
Cc: Rainer Weikusat <rweikusat@mssgmbh.com>
---
 net/unix/af_unix.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 08102e728b15..cc695c9f09ec 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -603,7 +603,7 @@ static void unix_release_sock(struct sock *sk, int embrion)
 	/* Clear state */
 	unix_state_lock(sk);
 	sock_orphan(sk);
-	sk->sk_shutdown = SHUTDOWN_MASK;
+	WRITE_ONCE(sk->sk_shutdown, SHUTDOWN_MASK);
 	path	     = u->path;
 	u->path.dentry = NULL;
 	u->path.mnt = NULL;
@@ -628,7 +628,7 @@ static void unix_release_sock(struct sock *sk, int embrion)
 		if (sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET) {
 			unix_state_lock(skpair);
 			/* No more writes */
-			skpair->sk_shutdown = SHUTDOWN_MASK;
+			WRITE_ONCE(skpair->sk_shutdown, SHUTDOWN_MASK);
 			if (!skb_queue_empty(&sk->sk_receive_queue) || embrion)
 				WRITE_ONCE(skpair->sk_err, ECONNRESET);
 			unix_state_unlock(skpair);
@@ -3008,7 +3008,7 @@ static int unix_shutdown(struct socket *sock, int mode)
 	++mode;
 
 	unix_state_lock(sk);
-	sk->sk_shutdown |= mode;
+	WRITE_ONCE(sk->sk_shutdown, sk->sk_shutdown | mode);
 	other = unix_peer(sk);
 	if (other)
 		sock_hold(other);
@@ -3028,7 +3028,7 @@ static int unix_shutdown(struct socket *sock, int mode)
 		if (mode&SEND_SHUTDOWN)
 			peer_mode |= RCV_SHUTDOWN;
 		unix_state_lock(other);
-		other->sk_shutdown |= peer_mode;
+		WRITE_ONCE(other->sk_shutdown, other->sk_shutdown | peer_mode);
 		unix_state_unlock(other);
 		other->sk_state_change(other);
 		if (peer_mode == SHUTDOWN_MASK)
@@ -3160,16 +3160,18 @@ static __poll_t unix_poll(struct file *file, struct socket *sock, poll_table *wa
 {
 	struct sock *sk = sock->sk;
 	__poll_t mask;
+	u8 shutdown;
 
 	sock_poll_wait(file, sock, wait);
 	mask = 0;
+	shutdown = READ_ONCE(sk->sk_shutdown);
 
 	/* exceptional events? */
 	if (READ_ONCE(sk->sk_err))
 		mask |= EPOLLERR;
-	if (sk->sk_shutdown == SHUTDOWN_MASK)
+	if (shutdown == SHUTDOWN_MASK)
 		mask |= EPOLLHUP;
-	if (sk->sk_shutdown & RCV_SHUTDOWN)
+	if (shutdown & RCV_SHUTDOWN)
 		mask |= EPOLLRDHUP | EPOLLIN | EPOLLRDNORM;
 
 	/* readable? */
@@ -3203,9 +3205,11 @@ static __poll_t unix_dgram_poll(struct file *file, struct socket *sock,
 	struct sock *sk = sock->sk, *other;
 	unsigned int writable;
 	__poll_t mask;
+	u8 shutdown;
 
 	sock_poll_wait(file, sock, wait);
 	mask = 0;
+	shutdown = READ_ONCE(sk->sk_shutdown);
 
 	/* exceptional events? */
 	if (READ_ONCE(sk->sk_err) ||
@@ -3213,9 +3217,9 @@ static __poll_t unix_dgram_poll(struct file *file, struct socket *sock,
 		mask |= EPOLLERR |
 			(sock_flag(sk, SOCK_SELECT_ERR_QUEUE) ? EPOLLPRI : 0);
 
-	if (sk->sk_shutdown & RCV_SHUTDOWN)
+	if (shutdown & RCV_SHUTDOWN)
 		mask |= EPOLLRDHUP | EPOLLIN | EPOLLRDNORM;
-	if (sk->sk_shutdown == SHUTDOWN_MASK)
+	if (shutdown == SHUTDOWN_MASK)
 		mask |= EPOLLHUP;
 
 	/* readable? */
-- 
2.30.2


