Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25DA753EA61
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241747AbiFFQWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 12:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241556AbiFFQWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 12:22:09 -0400
Received: from azure-sdnproxy-2.icoremail.net (azure-sdnproxy.icoremail.net [52.175.55.52])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 30C1A2E59BF;
        Mon,  6 Jun 2022 09:22:03 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [106.117.78.144])
        by mail-app2 (Coremail) with SMTP id by_KCgDHG0CSKZ5iwb1gAQ--.36763S2;
        Tue, 07 Jun 2022 00:21:45 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-kernel@vger.kernel.org
Cc:     jreuter@yaina.de, ralf@linux-mips.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-hams@vger.kernel.org,
        thomas@osterried.de, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net-next] ax25: Fix deadlock caused by skb_recv_datagram in ax25_recvmsg
Date:   Tue,  7 Jun 2022 00:21:38 +0800
Message-Id: <20220606162138.81505-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: by_KCgDHG0CSKZ5iwb1gAQ--.36763S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZw43ZFyruFW3Xr1DCF4xCrg_yoW5AFW7pF
        y5tw48Gr40yFykXF47AFykXr4UAFsIkFy5WFyxXw4xArn8Gwn8JFWrtw4Yva45tFZ8Aw1x
        tF1qgw40yF15XaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9j14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxV
        W8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xf
        McIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7
        v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF
        7I0E8cxan2IY04v7MxkIecxEwVAFwVWUMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
        AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
        17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
        IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4l
        IxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvf
        C2KfnxnUUI43ZEXa7VUjnjjDUUUUU==
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgoNAVZdtaEUYgAgsN
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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

[  861.122612] INFO: task ax25_deadlock:148 blocked for more than 737 seconds.
[  861.124543] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  861.127764] Call Trace:
[  861.129688]  <TASK>
[  861.130743]  __schedule+0x2f9/0xb20
[  861.131526]  schedule+0x49/0xb0
[  861.131640]  __lock_sock+0x92/0x100
[  861.131640]  ? destroy_sched_domains_rcu+0x20/0x20
[  861.131640]  lock_sock_nested+0x6e/0x70
[  861.131640]  ax25_sendmsg+0x46/0x420
[  861.134383]  ? ax25_recvmsg+0x1e0/0x1e0
[  861.135658]  sock_sendmsg+0x59/0x60
[  861.136791]  __sys_sendto+0xe9/0x150
[  861.137212]  ? __schedule+0x301/0xb20
[  861.137710]  ? __do_softirq+0x4a2/0x4fd
[  861.139153]  __x64_sys_sendto+0x20/0x30
[  861.140330]  do_syscall_64+0x3b/0x90
[  861.140731]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  861.141249] RIP: 0033:0x7fdf05ee4f64
[  861.141249] RSP: 002b:00007ffe95772fc0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  861.141249] RAX: ffffffffffffffda RBX: 0000565303a013f0 RCX: 00007fdf05ee4f64
[  861.141249] RDX: 0000000000000005 RSI: 0000565303a01678 RDI: 0000000000000005
[  861.141249] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[  861.141249] R10: 0000000000000000 R11: 0000000000000246 R12: 0000565303a00cf0
[  861.141249] R13: 00007ffe957730e0 R14: 0000000000000000 R15: 0000000000000000

This patch moves the skb_recv_datagram() before lock_sock() in order
that other functions that need lock_sock could be executed.

Reported-by: Thomas Habets <thomas@@habets.se>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
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

