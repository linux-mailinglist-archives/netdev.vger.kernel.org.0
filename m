Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEC74D4674
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 13:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234298AbiCJMIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 07:08:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240407AbiCJMIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 07:08:01 -0500
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E255114077C;
        Thu, 10 Mar 2022 04:06:57 -0800 (PST)
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app4 (Coremail) with SMTP id cS_KCgDnCUnR6Sliw8BjAA--.3672S2;
        Thu, 10 Mar 2022 20:06:47 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-hams@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, ralf@linux-mips.org,
        jreuter@yaina.de, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH] ax25: Fix NULL pointer dereferences in ax25 timers
Date:   Thu, 10 Mar 2022 20:06:40 +0800
Message-Id: <20220310120640.43269-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cS_KCgDnCUnR6Sliw8BjAA--.3672S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAF4rZF48trW3Zw1UZr4kCrg_yoWrGF18pF
        ZrKFWfJr4DXrW5AF48Cw4kJr1UZw1DXr98Ar18ZF4Sk3WxJrn8JF1DtryjqFW3KFZ0yF9r
        A34xXasxJF18uFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUka1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
        6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v
        1sIEY20_GFWkJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
        18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vI
        r41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr
        1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvE
        x4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgMDAVZdtYkSWQAQsv
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are race conditions that may lead to null pointer dereferences in
ax25_heartbeat_expiry(), ax25_t1timer_expiry(), ax25_t2timer_expiry(),
ax25_t3timer_expiry() and ax25_idletimer_expiry(), when we use
ax25_kill_by_device() to detach the ax25 device.

One of the race conditions that cause null pointer dereferences can be
shown as below:

      (Thread 1)                    |      (Thread 2)
ax25_connect()                      |
 ax25_std_establish_data_link()     |
  ax25_start_t1timer()              |
   mod_timer(&ax25->t1timer,..)     |
                                    | ax25_kill_by_device()
   (wait a time)                    |  ...
                                    |  s->ax25_dev = NULL; //(1)
   ax25_t1timer_expiry()            |
    ax25->ax25_dev->values[..] //(2)|  ...
     ...                            |

We set null to ax25_cb->ax25_dev in position (1) and dereference
the null pointer in position (2).

The corresponding fail log is shown below:
===============================================================
BUG: kernel NULL pointer dereference, address: 0000000000000050
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.17.0-rc6-00794-g45690b7d0
RIP: 0010:ax25_t1timer_expiry+0x12/0x40
...
Call Trace:
 call_timer_fn+0x21/0x120
 __run_timers.part.0+0x1ca/0x250
 run_timer_softirq+0x2c/0x60
 __do_softirq+0xef/0x2f3
 irq_exit_rcu+0xb6/0x100
 sysvec_apic_timer_interrupt+0xa2/0xd0
...

This patch uses ax25_disconnect() to delete timers before we set null to
ax25_cb->ax25_dev in ax25_kill_by_device(). Function ax25_disconnect()
will not return until all timers are stopped, because we have changed
del_timer() to del_timer_sync(). What`s more, we could not use syscalls
such as ax25_connect(), ax25_sendmsg() and so on to activate timers again
unless we start the device, because we have set null to ax25_cb->ax25_dev.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 net/ax25/af_ax25.c    |  4 ++--
 net/ax25/ax25_timer.c | 16 +++++-----------
 2 files changed, 7 insertions(+), 13 deletions(-)
 mode change 100644 => 100755 net/ax25/af_ax25.c
 mode change 100644 => 100755 net/ax25/ax25_timer.c

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
old mode 100644
new mode 100755
index 6bd09718077..9a93ede3307
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -89,18 +89,18 @@ static void ax25_kill_by_device(struct net_device *dev)
 			sk = s->sk;
 			if (!sk) {
 				spin_unlock_bh(&ax25_list_lock);
-				s->ax25_dev = NULL;
 				ax25_disconnect(s, ENETUNREACH);
+				s->ax25_dev = NULL;
 				spin_lock_bh(&ax25_list_lock);
 				goto again;
 			}
 			sock_hold(sk);
 			spin_unlock_bh(&ax25_list_lock);
 			lock_sock(sk);
+			ax25_disconnect(s, ENETUNREACH);
 			s->ax25_dev = NULL;
 			dev_put_track(ax25_dev->dev, &ax25_dev->dev_tracker);
 			ax25_dev_put(ax25_dev);
-			ax25_disconnect(s, ENETUNREACH);
 			release_sock(sk);
 			spin_lock_bh(&ax25_list_lock);
 			sock_put(sk);
diff --git a/net/ax25/ax25_timer.c b/net/ax25/ax25_timer.c
old mode 100644
new mode 100755
index 85865ebfdfa..403d43fe1c6
--- a/net/ax25/ax25_timer.c
+++ b/net/ax25/ax25_timer.c
@@ -75,32 +75,26 @@ void ax25_start_idletimer(ax25_cb *ax25)
 	else
 		del_timer(&ax25->idletimer);
 }
-
 void ax25_stop_heartbeat(ax25_cb *ax25)
 {
-	del_timer(&ax25->timer);
+	del_timer_sync(&ax25->timer);
 }
-
 void ax25_stop_t1timer(ax25_cb *ax25)
 {
-	del_timer(&ax25->t1timer);
+	del_timer_sync(&ax25->t1timer);
 }
-
 void ax25_stop_t2timer(ax25_cb *ax25)
 {
-	del_timer(&ax25->t2timer);
+	del_timer_sync(&ax25->t2timer);
 }
-
 void ax25_stop_t3timer(ax25_cb *ax25)
 {
-	del_timer(&ax25->t3timer);
+	del_timer_sync(&ax25->t3timer);
 }
-
 void ax25_stop_idletimer(ax25_cb *ax25)
 {
-	del_timer(&ax25->idletimer);
+	del_timer_sync(&ax25->idletimer);
 }
-
 int ax25_t1timer_running(ax25_cb *ax25)
 {
 	return timer_pending(&ax25->t1timer);
--
2.17.1

