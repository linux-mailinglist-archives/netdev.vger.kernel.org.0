Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47E576A07C1
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 12:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbjBWLx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 06:53:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233699AbjBWLx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 06:53:56 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6345B2332E;
        Thu, 23 Feb 2023 03:53:46 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PMrwM5nMCzKptH;
        Thu, 23 Feb 2023 19:51:47 +0800 (CST)
Received: from huawei.com (10.175.101.6) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.6; Thu, 23 Feb
 2023 19:53:41 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <edumazet@google.com>, <john.fastabend@gmail.com>,
        <jakub@cloudflare.com>, <davem@davemloft.net>,
        <dsahern@kernel.org>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <ast@kernel.org>, <cong.wang@bytedance.com>, <daniel@iogearbox.net>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <liujian56@huawei.com>
Subject: [PATCH bpf] bpf, sockmap: fix an infinite loop error when len is 0 in tcp_bpf_recvmsg_parser()
Date:   Thu, 23 Feb 2023 20:02:12 +0800
Message-ID: <20230223120212.1604148-1-liujian56@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the buffer length of the recvmsg system call is 0, we got the
flollowing soft lockup problem:

watchdog: BUG: soft lockup - CPU#3 stuck for 27s! [a.out:6149]
CPU: 3 PID: 6149 Comm: a.out Kdump: loaded Not tainted 6.2.0+ #30
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
RIP: 0010:remove_wait_queue+0xb/0xc0
Code: 5e 41 5f c3 cc cc cc cc 0f 1f 80 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 0f 1f 44 00 00 41 57 <41> 56 41 55 41 54 55 48 89 fd 53 48 89 f3 4c 8d 6b 18 4c 8d 73 20
RSP: 0018:ffff88811b5978b8 EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffff88811a7d3780 RCX: ffffffffb7a4d768
RDX: dffffc0000000000 RSI: ffff88811b597908 RDI: ffff888115408040
RBP: 1ffff110236b2f1b R08: 0000000000000000 R09: ffff88811a7d37e7
R10: ffffed10234fa6fc R11: 0000000000000001 R12: ffff88811179b800
R13: 0000000000000001 R14: ffff88811a7d38a8 R15: ffff88811a7d37e0
FS:  00007f6fb5398740(0000) GS:ffff888237180000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000000 CR3: 000000010b6ba002 CR4: 0000000000370ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 tcp_msg_wait_data+0x279/0x2f0
 tcp_bpf_recvmsg_parser+0x3c6/0x490
 inet_recvmsg+0x280/0x290
 sock_recvmsg+0xfc/0x120
 ____sys_recvmsg+0x160/0x3d0
 ___sys_recvmsg+0xf0/0x180
 __sys_recvmsg+0xea/0x1a0
 do_syscall_64+0x3f/0x90
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

The logic in tcp_bpf_recvmsg_parser is as follows:

msg_bytes_ready:
	copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
	if (!copied) {
		wait data;
		goto msg_bytes_ready;
	}

In this case, "copied" alway is 0, the infinite loop occurs.

According to the Linux system call man page, 0 should be returned in this
case. Therefore, in tcp_bpf_recvmsg_parser(), if the length is 0, directly
return.

Also modify several other functions with the same problem.

Fixes: 1f5be6b3b063 ("udp: Implement udp_bpf_recvmsg() for sockmap")
Fixes: 9825d866ce0d ("af_unix: Implement unix_dgram_bpf_recvmsg()")
Fixes: c5d2177a72a1 ("bpf, sockmap: Fix race in ingress receive verdict with redirect to self")
Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Liu Jian <liujian56@huawei.com>
---
 net/ipv4/tcp_bpf.c  | 6 ++++++
 net/ipv4/udp_bpf.c  | 3 +++
 net/unix/unix_bpf.c | 3 +++
 3 files changed, 12 insertions(+)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index cf26d65ca389..36b52ae519ab 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -186,6 +186,9 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return inet_recv_error(sk, msg, len, addr_len);
 
+	if (len == 0)
+		return 0;
+
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock))
 		return tcp_recvmsg(sk, msg, len, flags, addr_len);
@@ -244,6 +247,9 @@ static int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return inet_recv_error(sk, msg, len, addr_len);
 
+	if (len == 0)
+		return 0;
+
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock))
 		return tcp_recvmsg(sk, msg, len, flags, addr_len);
diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
index e5dc91d0e079..a2a9d67bd3ff 100644
--- a/net/ipv4/udp_bpf.c
+++ b/net/ipv4/udp_bpf.c
@@ -68,6 +68,9 @@ static int udp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return inet_recv_error(sk, msg, len, addr_len);
 
+	if (len == 0)
+		return 0;
+
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock))
 		return sk_udp_recvmsg(sk, msg, len, flags, addr_len);
diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
index e9bf15513961..851c4719f8a9 100644
--- a/net/unix/unix_bpf.c
+++ b/net/unix/unix_bpf.c
@@ -54,6 +54,9 @@ static int unix_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
 	struct sk_psock *psock;
 	int copied;
 
+	if (len == 0)
+		return 0;
+
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock))
 		return __unix_recvmsg(sk, msg, len, flags);
-- 
2.34.1

