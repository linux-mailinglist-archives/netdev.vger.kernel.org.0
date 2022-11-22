Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34F026348D5
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 21:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbiKVU6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 15:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiKVU6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 15:58:40 -0500
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE025E3EF
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 12:58:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1669150719; x=1700686719;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=58dNQVKqeDksWseF0awQrKYpFQ4D7sUOyuz+r+YL5uk=;
  b=a02FxHO0HKXeurLPdII8dpbE5t0ZK9DJUGY3bviyPpJk1HY6ZUUL1H1x
   E9/xFGUAzE1i+800dBr3sGm3klYXdA+2PwdRYSd9D17e4EeBCBR7WzCNX
   5jIeLqoNKN4384bi6LqlFvBl2bB+ymWtvfjJo8ZyO0GxssxJdHRwO+UcW
   w=;
X-IronPort-AV: E=Sophos;i="5.96,185,1665446400"; 
   d="scan'208";a="243003183"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-25ac6bd5.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 20:58:34 +0000
Received: from EX13MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1d-m6i4x-25ac6bd5.us-east-1.amazon.com (Postfix) with ESMTPS id 0539F42438;
        Tue, 22 Nov 2022 20:58:30 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Tue, 22 Nov 2022 20:58:29 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.14) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Tue, 22 Nov 2022 20:58:27 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, syzbot <syzkaller@googlegroups.com>,
        Wei Chen <harperchen1110@gmail.com>
Subject: [PATCH v1 net] af_unix: Call sk_diag_fill() under the bucket lock.
Date:   Tue, 22 Nov 2022 12:58:11 -0800
Message-ID: <20221122205811.20910-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.14]
X-ClientProxiedBy: EX13D49UWC003.ant.amazon.com (10.43.162.10) To
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

Wei Chen reported sk->sk_socket can be NULL in sk_user_ns(). [0][1]

It seems that syzbot was dumping an AF_UNIX socket while closing it,
and there is a race below.

  unix_release_sock               unix_diag_handler_dump
  |                               `- unix_diag_get_exact
  |                                  |- unix_lookup_by_ino
  |                                  |  |- spin_lock(&net->unx.table.locks[i])
  |                                  |  |- sock_hold
  |                                  |  `- spin_unlock(&net->unx.table.locks[i])
  |- unix_remove_socket(net, sk)     |     /* after releasing this lock,
  |  /* from here, sk cannot be      |      * there is no guarantee that
  |   * seen in the hash table.      |      * sk is not SOCK_DEAD.
  |   */                             |      */
  |                                  |
  |- unix_state_lock(sk)             |
  |- sock_orphan(sk)                 `- sk_diag_fill
  |  |- sock_set_flag(sk, SOCK_DEAD)    `- sk_diag_dump_uid
  |  `- sk_set_socket(sk, NULL)            `- sk_user_ns
  `- unix_state_unlock(sk)                   `- sk->sk_socket->file->f_cred->user_ns
                                                /* NULL deref here */

After releasing the bucket lock, we cannot guarantee that the found
socket is still alive.  Then, we have to check the SOCK_DEAD flag
under unix_state_lock() and keep holding it unless we access the socket.

In this case, however, we cannot acquire unix_state_lock() in
unix_lookup_by_ino() because we lock it later in sk_diag_dump_peer(),
resulting in deadlock.

Instead, we do not release the bucket lock; then, we can safely access
sk->sk_socket later in sk_user_ns(), and there is no deadlock scenario.
We are already using this strategy in unix_diag_dump().

Note we have to call nlmsg_new() before unix_lookup_by_ino() not to
change the flag from GFP_KERNEL to GFP_ATOMIC.

[0]: https://lore.kernel.org/netdev/CAO4mrfdvyjFpokhNsiwZiP-wpdSD0AStcJwfKcKQdAALQ9_2Qw@mail.gmail.com/
[1]:
BUG: kernel NULL pointer dereference, address: 0000000000000270
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 12bbce067 P4D 12bbce067 PUD 12bc40067 PMD 0
Oops: 0000 [#1] PREEMPT SMP
CPU: 0 PID: 27942 Comm: syz-executor.0 Not tainted 6.1.0-rc5-next-20221118 #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
RIP: 0010:sk_user_ns include/net/sock.h:920 [inline]
RIP: 0010:sk_diag_dump_uid net/unix/diag.c:119 [inline]
RIP: 0010:sk_diag_fill+0x77d/0x890 net/unix/diag.c:170
Code: 89 ef e8 66 d4 2d fd c7 44 24 40 00 00 00 00 49 8d 7c 24 18 e8
54 d7 2d fd 49 8b 5c 24 18 48 8d bb 70 02 00 00 e8 43 d7 2d fd <48> 8b
9b 70 02 00 00 48 8d 7b 10 e8 33 d7 2d fd 48 8b 5b 10 48 8d
RSP: 0018:ffffc90000d67968 EFLAGS: 00010246
RAX: ffff88812badaa48 RBX: 0000000000000000 RCX: ffffffff840d481d
RDX: 0000000000000465 RSI: 0000000000000000 RDI: 0000000000000270
RBP: ffffc90000d679a8 R08: 0000000000000277 R09: 0000000000000000
R10: 0001ffffffffffff R11: 0001c90000d679a8 R12: ffff88812ac03800
R13: ffff88812c87c400 R14: ffff88812ae42210 R15: ffff888103026940
FS:  00007f08b4e6f700(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000270 CR3: 000000012c58b000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 unix_diag_get_exact net/unix/diag.c:285 [inline]
 unix_diag_handler_dump+0x3f9/0x500 net/unix/diag.c:317
 __sock_diag_cmd net/core/sock_diag.c:235 [inline]
 sock_diag_rcv_msg+0x237/0x250 net/core/sock_diag.c:266
 netlink_rcv_skb+0x13e/0x250 net/netlink/af_netlink.c:2564
 sock_diag_rcv+0x24/0x40 net/core/sock_diag.c:277
 netlink_unicast_kernel net/netlink/af_netlink.c:1330 [inline]
 netlink_unicast+0x5e9/0x6b0 net/netlink/af_netlink.c:1356
 netlink_sendmsg+0x739/0x860 net/netlink/af_netlink.c:1932
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0x38f/0x500 net/socket.c:2476
 ___sys_sendmsg net/socket.c:2530 [inline]
 __sys_sendmsg+0x197/0x230 net/socket.c:2559
 __do_sys_sendmsg net/socket.c:2568 [inline]
 __se_sys_sendmsg net/socket.c:2566 [inline]
 __x64_sys_sendmsg+0x42/0x50 net/socket.c:2566
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x4697f9
Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f08b4e6ec48 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000077bf80 RCX: 00000000004697f9
RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000003
RBP: 00000000004d29e9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000077bf80
R13: 0000000000000000 R14: 000000000077bf80 R15: 00007ffdb36bc6c0
 </TASK>
Modules linked in:
CR2: 0000000000000270

Fixes: 5d3cae8bc39d ("unix_diag: Dumping exact socket core")
Reported-by: syzbot <syzkaller@googlegroups.com>
Reported-by: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/unix/diag.c | 38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/net/unix/diag.c b/net/unix/diag.c
index 105f522a89fe..96583cb71cf5 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -242,8 +242,9 @@ static struct sock *unix_lookup_by_ino(struct net *net, unsigned int ino)
 		spin_lock(&net->unx.table.locks[i]);
 		sk_for_each(sk, &net->unx.table.buckets[i]) {
 			if (ino == sock_i_ino(sk)) {
-				sock_hold(sk);
-				spin_unlock(&net->unx.table.locks[i]);
+				/* sk_diag_fill() must be done under the bucket
+				 * lock not to race with unix_release_sock().
+				 */
 				return sk;
 			}
 		}
@@ -264,15 +265,6 @@ static int unix_diag_get_exact(struct sk_buff *in_skb,
 
 	err = -EINVAL;
 	if (req->udiag_ino == 0)
-		goto out_nosk;
-
-	sk = unix_lookup_by_ino(net, req->udiag_ino);
-	err = -ENOENT;
-	if (sk == NULL)
-		goto out_nosk;
-
-	err = sock_diag_check_cookie(sk, req->udiag_cookie);
-	if (err)
 		goto out;
 
 	extra_len = 256;
@@ -282,8 +274,21 @@ static int unix_diag_get_exact(struct sk_buff *in_skb,
 	if (!rep)
 		goto out;
 
+	/* Acquire a bucket lock on success. */
+	sk = unix_lookup_by_ino(net, req->udiag_ino);
+	err = -ENOENT;
+	if (!sk)
+		goto free;
+
+	err = sock_diag_check_cookie(sk, req->udiag_cookie);
+	if (err)
+		goto unlock;
+
 	err = sk_diag_fill(sk, rep, req, NETLINK_CB(in_skb).portid,
 			   nlh->nlmsg_seq, 0, req->udiag_ino);
+
+	spin_unlock(&net->unx.table.locks[sk->sk_hash]);
+
 	if (err < 0) {
 		nlmsg_free(rep);
 		extra_len += 256;
@@ -292,13 +297,16 @@ static int unix_diag_get_exact(struct sk_buff *in_skb,
 
 		goto again;
 	}
-	err = nlmsg_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid);
 
+	err = nlmsg_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid);
 out:
-	if (sk)
-		sock_put(sk);
-out_nosk:
 	return err;
+
+unlock:
+	spin_unlock(&net->unx.table.locks[sk->sk_hash]);
+free:
+	nlmsg_free(rep);
+	goto out;
 }
 
 static int unix_diag_handler_dump(struct sk_buff *skb, struct nlmsghdr *h)
-- 
2.30.2

