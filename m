Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20AEA54AD61
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 11:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240380AbiFNJ0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 05:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiFNJ0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 05:26:36 -0400
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id F3DB4E028;
        Tue, 14 Jun 2022 02:26:31 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [106.117.76.43])
        by mail-app4 (Coremail) with SMTP id cS_KCgD3XyMlVKhiihHXAQ--.18766S2;
        Tue, 14 Jun 2022 17:26:06 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-hams@vger.kernel.org, pabeni@redhat.com
Cc:     jreuter@yaina.de, ralf@linux-mips.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas@osterried.de,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net v5] net: ax25: Fix deadlock caused by skb_recv_datagram in ax25_recvmsg
Date:   Tue, 14 Jun 2022 17:25:57 +0800
Message-Id: <20220614092557.6713-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cS_KCgD3XyMlVKhiihHXAQ--.18766S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZw43ZFyfAF1kWFy3KFW3Jrb_yoWrWrW3pF
        yUKF18Wr4kJrW29r43tFWDXr4fZ3ZakFy7XrWxX34xAF9rW3WrXryrtr4jy3yjgrZ8A347
        tF1qga18Kr13WaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
        JVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
        n2kIc2xKxwCY02Avz4vE14v_GFWl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
        0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
        17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
        C0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
        6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
        73UjIFyTuYvjfUeLvtDUUUU
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgsBAVZdtaNBvQAEss
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,
        RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The skb_recv_datagram() in ax25_recvmsg() will hold lock_sock
and block until it receives a packet from the remote. If the client
doesn`t connect to server and calls read() directly, it will not
receive any packets forever. As a result, the deadlock will happen.

The fail log caused by deadlock is shown below:

[  369.606973] INFO: task ax25_deadlock:157 blocked for more than 245 seconds.
[  369.608919] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  369.613058] Call Trace:
[  369.613315]  <TASK>
[  369.614072]  __schedule+0x2f9/0xb20
[  369.615029]  schedule+0x49/0xb0
[  369.615734]  __lock_sock+0x92/0x100
[  369.616763]  ? destroy_sched_domains_rcu+0x20/0x20
[  369.617941]  lock_sock_nested+0x6e/0x70
[  369.618809]  ax25_bind+0xaa/0x210
[  369.619736]  __sys_bind+0xca/0xf0
[  369.620039]  ? do_futex+0xae/0x1b0
[  369.620387]  ? __x64_sys_futex+0x7c/0x1c0
[  369.620601]  ? fpregs_assert_state_consistent+0x19/0x40
[  369.620613]  __x64_sys_bind+0x11/0x20
[  369.621791]  do_syscall_64+0x3b/0x90
[  369.622423]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  369.623319] RIP: 0033:0x7f43c8aa8af7
[  369.624301] RSP: 002b:00007f43c8197ef8 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
[  369.625756] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f43c8aa8af7
[  369.626724] RDX: 0000000000000010 RSI: 000055768e2021d0 RDI: 0000000000000005
[  369.628569] RBP: 00007f43c8197f00 R08: 0000000000000011 R09: 00007f43c8198700
[  369.630208] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff845e6afe
[  369.632240] R13: 00007fff845e6aff R14: 00007f43c8197fc0 R15: 00007f43c8198700

This patch replaces skb_recv_datagram() with an open-coded variant of it
releasing the socket lock before the __skb_wait_for_more_packets() call
and re-acquiring it after such call in order that other functions that
need socket lock could be executed.

what's more, the socket lock will be released only when recvmsg() will
block and that should produce nicer overall behavior.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Suggested-by: Thomas Osterried <thomas@osterried.de>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reported-by: Thomas Habets <thomas@@habets.se>
Acked-by: Paolo Abeni <pabeni@redhat.com>
---
Changes in v5:
  - Correct Fixes tag.

 net/ax25/af_ax25.c | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 95393bb2760..4c7030ed8d3 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1661,9 +1661,12 @@ static int ax25_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 			int flags)
 {
 	struct sock *sk = sock->sk;
-	struct sk_buff *skb;
+	struct sk_buff *skb, *last;
+	struct sk_buff_head *sk_queue;
 	int copied;
 	int err = 0;
+	int off = 0;
+	long timeo;
 
 	lock_sock(sk);
 	/*
@@ -1675,10 +1678,29 @@ static int ax25_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		goto out;
 	}
 
-	/* Now we can treat all alike */
-	skb = skb_recv_datagram(sk, flags, &err);
-	if (skb == NULL)
-		goto out;
+	/*  We need support for non-blocking reads. */
+	sk_queue = &sk->sk_receive_queue;
+	skb = __skb_try_recv_datagram(sk, sk_queue, flags, &off, &err, &last);
+	/* If no packet is available, release_sock(sk) and try again. */
+	if (!skb) {
+		if (err != -EAGAIN)
+			goto out;
+		release_sock(sk);
+		timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
+		while (timeo && !__skb_wait_for_more_packets(sk, sk_queue, &err,
+							     &timeo, last)) {
+			skb = __skb_try_recv_datagram(sk, sk_queue, flags, &off,
+						      &err, &last);
+			if (skb)
+				break;
+
+			if (err != -EAGAIN)
+				goto done;
+		}
+		if (!skb)
+			goto done;
+		lock_sock(sk);
+	}
 
 	if (!sk_to_ax25(sk)->pidincl)
 		skb_pull(skb, 1);		/* Remove PID */
@@ -1725,6 +1747,7 @@ static int ax25_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 out:
 	release_sock(sk);
 
+done:
 	return err;
 }
 
-- 
2.17.1

