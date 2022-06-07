Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E73CA54014E
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 16:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245350AbiFGOZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 10:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245492AbiFGOZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 10:25:18 -0400
X-Greylist: delayed 7443 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 07 Jun 2022 07:25:13 PDT
Received: from azure-sdnproxy-1.icoremail.net (azure-sdnproxy.icoremail.net [52.237.72.81])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 33CC3F1353;
        Tue,  7 Jun 2022 07:25:10 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [106.117.78.144])
        by mail-app2 (Coremail) with SMTP id by_KCgCHjopqX59izNVuAQ--.20134S2;
        Tue, 07 Jun 2022 22:23:46 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-kernel@vger.kernel.org
Cc:     jreuter@yaina.de, ralf@linux-mips.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-hams@vger.kernel.org,
        thomas@osterried.de, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH v2] net: ax25: Fix deadlock caused by skb_recv_datagram in ax25_recvmsg
Date:   Tue,  7 Jun 2022 22:23:37 +0800
Message-Id: <20220607142337.78458-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: by_KCgCHjopqX59izNVuAQ--.20134S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZw43ZFyfAF1kWFy3KFW3Jrb_yoW5CrWxpF
        yUKF18Wr48JFy2qF47JFWDXr1xAFsFyFWUXrW7W3yxZFnxW3WrJryrtr4jk34jgrZ8A347
        t3Wqga1ftF43WaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
        Y2ka0xkIwI1lc2xSY4AK67AK6ry5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
        1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
        b7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
        vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
        cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxh
        VjvjDU0xZFpf9x0JUmzuXUUUUU=
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAg0OAVZdtaF12QABsy
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

This patch moves the skb_recv_datagram() before lock_sock() in order
that other functions that need lock_sock could be executed.

Suggested-by: Thomas Osterried <thomas@osterried.de>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reported-by: Thomas Habets <thomas@@habets.se>
---
Changes in v2:
  - Make commit messages clearer.

 net/ax25/af_ax25.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 95393bb2760..02cd6087512 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1665,6 +1665,11 @@ static int ax25_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	int copied;
 	int err = 0;
 
+	/* Now we can treat all alike */
+	skb = skb_recv_datagram(sk, flags, &err);
+	if (!skb)
+		goto done;
+
 	lock_sock(sk);
 	/*
 	 * 	This works for seqpacket too. The receiver has ordered the
@@ -1675,11 +1680,6 @@ static int ax25_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		goto out;
 	}
 
-	/* Now we can treat all alike */
-	skb = skb_recv_datagram(sk, flags, &err);
-	if (skb == NULL)
-		goto out;
-
 	if (!sk_to_ax25(sk)->pidincl)
 		skb_pull(skb, 1);		/* Remove PID */
 
@@ -1725,6 +1725,7 @@ static int ax25_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 out:
 	release_sock(sk);
 
+done:
 	return err;
 }
 
-- 
2.17.1

