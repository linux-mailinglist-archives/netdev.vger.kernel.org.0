Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44BE74D925E
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 02:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344332AbiCOB6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 21:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343899AbiCOB6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 21:58:20 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 61FE23EAAE;
        Mon, 14 Mar 2022 18:57:08 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app2 (Coremail) with SMTP id by_KCgA3HwJn8i9iHNoPAA--.25435S2;
        Tue, 15 Mar 2022 09:56:59 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-hams@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, ralf@linux-mips.org,
        jreuter@yaina.de, dan.carpenter@oracle.com,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net V4 2/2] ax25: Fix NULL pointer dereferences in ax25 timers
Date:   Tue, 15 Mar 2022 09:56:54 +0800
Message-Id: <20220315015654.79941-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: by_KCgA3HwJn8i9iHNoPAA--.25435S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAF4rZF48trW3Zw1UZr4kCrg_yoWrXrWDpF
        WDKFWfJr4DXrW5Ar48GFs7Jr1UZw1DXr98Ar18uF4Sk3WxJrn8JF1UtFyjqFW3KFZ8Ar9r
        Aw1xWasxXF18uFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkI1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJr0_GcWl84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
        8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_
        JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxF
        aVAv8VW8uw4UJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr
        4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxG
        rwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJw
        CI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2
        z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VU1a9aPUUUUU==
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgwKAVZdtYrI6QABsR
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
ax25_cb->ax25_dev in ax25_kill_by_device().The function ax25_disconnect()
will not return until all timers are stopped, because we have changed
del_timer() to del_timer_sync(). What`s more, we add condition check in
ax25_destroy_socket(), because ax25_stop_heartbeat() will not return,
if there is still heartbeat.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
Changes in V4:
  - Based on [PATCH net V4 1/2] ax25: Fix refcount leaks caused by ax25_cb_del().

 net/ax25/af_ax25.c    |  7 ++++---
 net/ax25/ax25_timer.c | 10 +++++-----
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 0886109421a..dc6161a75a1 100644
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
 			if (sk->sk_wq) {
 				dev_put_track(ax25_dev->dev, &ax25_dev->dev_tracker);
 				ax25_dev_put(ax25_dev);
 			}
-			ax25_disconnect(s, ENETUNREACH);
 			release_sock(sk);
 			spin_lock_bh(&ax25_list_lock);
 			sock_put(sk);
@@ -307,7 +307,8 @@ void ax25_destroy_socket(ax25_cb *ax25)
 
 	ax25_cb_del(ax25);
 
-	ax25_stop_heartbeat(ax25);
+	if (!ax25->sk || !sock_flag(ax25->sk, SOCK_DESTROY))
+		ax25_stop_heartbeat(ax25);
 	ax25_stop_t1timer(ax25);
 	ax25_stop_t2timer(ax25);
 	ax25_stop_t3timer(ax25);
diff --git a/net/ax25/ax25_timer.c b/net/ax25/ax25_timer.c
index 85865ebfdfa..99af3d1aeec 100644
--- a/net/ax25/ax25_timer.c
+++ b/net/ax25/ax25_timer.c
@@ -78,27 +78,27 @@ void ax25_start_idletimer(ax25_cb *ax25)
 
 void ax25_stop_heartbeat(ax25_cb *ax25)
 {
-	del_timer(&ax25->timer);
+	del_timer_sync(&ax25->timer);
 }
 
 void ax25_stop_t1timer(ax25_cb *ax25)
 {
-	del_timer(&ax25->t1timer);
+	del_timer_sync(&ax25->t1timer);
 }
 
 void ax25_stop_t2timer(ax25_cb *ax25)
 {
-	del_timer(&ax25->t2timer);
+	del_timer_sync(&ax25->t2timer);
 }
 
 void ax25_stop_t3timer(ax25_cb *ax25)
 {
-	del_timer(&ax25->t3timer);
+	del_timer_sync(&ax25->t3timer);
 }
 
 void ax25_stop_idletimer(ax25_cb *ax25)
 {
-	del_timer(&ax25->idletimer);
+	del_timer_sync(&ax25->idletimer);
 }
 
 int ax25_t1timer_running(ax25_cb *ax25)
-- 
2.17.1

