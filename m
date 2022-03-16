Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8044DA9DE
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 06:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344087AbiCPFb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 01:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232644AbiCPFb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 01:31:28 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6A0615DA6F;
        Tue, 15 Mar 2022 22:30:13 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app3 (Coremail) with SMTP id cC_KCgC3jqTZdTFiHbsNAA--.45082S2;
        Wed, 16 Mar 2022 13:30:05 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-hams@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, ralf@linux-mips.org,
        jreuter@yaina.de, eric.dumazet@gmail.com,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net V5 2/2] ax25: Fix NULL pointer dereferences in ax25 timers
Date:   Wed, 16 Mar 2022 13:30:00 +0800
Message-Id: <20220316053000.130053-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cC_KCgC3jqTZdTFiHbsNAA--.45082S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAF4rZF48trW3Zw1UCw1Dtrb_yoWrJw4fpF
        ZFgFWfJr4vqrW5Ar48Grs7JF1Uuw1qq3y5Ar18uF4Sk3Z7Jrn8JFyUtFyUXFWakFZ8AF9r
        Aw18WasxZF18uaDanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvq1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
        6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v
        1sIEY20_GFWkJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUXVWUAw
        C20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAF
        wI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjx
        v20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2
        jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0x
        ZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgULAVZdtYslngADsA
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

If ax25_disconnect() is called by ax25_kill_by_device() or ax25->ax25_dev
is NULL, the reason in ax25_disconnect() will be equal to ENETUNREACH.
This patch adds check and uses del_timer_sync() to delete timers in
ax25_disconnect(), it will wait all timers to stop before we set null
to ax25_cb->ax25_dev in ax25_kill_by_device().

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
Changes in V5:
  - Add a check and use del_timer_sync() to delete timers in ax25_disconnect().
  - Based on [PATCH net V5 1/2] ax25: Fix refcount leaks caused by ax25_cb_del().

 net/ax25/af_ax25.c   |  4 ++--
 net/ax25/ax25_subr.c | 20 ++++++++++++++------
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index cf8847cfc66..992b6e5d85d 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -89,20 +89,20 @@ static void ax25_kill_by_device(struct net_device *dev)
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
 			if (sk->sk_socket) {
 				dev_put_track(ax25_dev->dev, &ax25_dev->dev_tracker);
 				ax25_dev_put(ax25_dev);
 			}
-			ax25_disconnect(s, ENETUNREACH);
 			release_sock(sk);
 			spin_lock_bh(&ax25_list_lock);
 			sock_put(sk);
diff --git a/net/ax25/ax25_subr.c b/net/ax25/ax25_subr.c
index 15ab812c4fe..3a476e4f6cd 100644
--- a/net/ax25/ax25_subr.c
+++ b/net/ax25/ax25_subr.c
@@ -261,12 +261,20 @@ void ax25_disconnect(ax25_cb *ax25, int reason)
 {
 	ax25_clear_queues(ax25);
 
-	if (!ax25->sk || !sock_flag(ax25->sk, SOCK_DESTROY))
-		ax25_stop_heartbeat(ax25);
-	ax25_stop_t1timer(ax25);
-	ax25_stop_t2timer(ax25);
-	ax25_stop_t3timer(ax25);
-	ax25_stop_idletimer(ax25);
+	if (reason == ENETUNREACH) {
+		del_timer_sync(&ax25->timer);
+		del_timer_sync(&ax25->t1timer);
+		del_timer_sync(&ax25->t2timer);
+		del_timer_sync(&ax25->t3timer);
+		del_timer_sync(&ax25->idletimer);
+	} else {
+		if (!ax25->sk || !sock_flag(ax25->sk, SOCK_DESTROY))
+			ax25_stop_heartbeat(ax25);
+		ax25_stop_t1timer(ax25);
+		ax25_stop_t2timer(ax25);
+		ax25_stop_t3timer(ax25);
+		ax25_stop_idletimer(ax25);
+	}
 
 	ax25->state = AX25_STATE_0;
 
-- 
2.17.1

