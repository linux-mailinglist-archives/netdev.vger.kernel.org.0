Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03058536D5E
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 16:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236880AbiE1Ozv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 10:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233875AbiE1Ozu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 10:55:50 -0400
Received: from zg8tmtyylji0my4xnjqunzqa.icoremail.net (zg8tmtyylji0my4xnjqunzqa.icoremail.net [162.243.164.74])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 561C8B3B;
        Sat, 28 May 2022 07:55:46 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [106.117.80.109])
        by mail-app4 (Coremail) with SMTP id cS_KCgCnfyLZN5JiJ630AA--.34921S2;
        Sat, 28 May 2022 22:55:28 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-hams@vger.kernel.org
Cc:     jreuter@yaina.de, ralf@linux-mips.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas@osterried.de, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net v3] ax25: Fix ax25 session cleanup problem in ax25_release
Date:   Sat, 28 May 2022 22:55:20 +0800
Message-Id: <20220528145520.130715-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cS_KCgCnfyLZN5JiJ630AA--.34921S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAF4xtw13WF4DXr1kCryDWrg_yoWrXFyDpF
        Wqgay3trZrXF48AF48WrZ7XF18uw4Yq3yDKF1UuFZakw1rJas8JFyktFyjqFW3JFZxAF1k
        Z34UWrn8Ar4kuFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
        cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
        nxnUUI43ZEXa7VUbkR65UUUUU==
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgEEAVZdtZ7x4QAFsz
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The timers of ax25 are used for correct session cleanup.
If we use ax25_release() to close ax25 sessions and
ax25_dev is not null, the del_timer_sync() functions in
ax25_release() will execute. As a result, the sessions
could not be cleaned up correctly, because the timers
have stopped.

This patch adds a device_up flag in ax25_dev in order to
judge whether the device is up. If there are sessions to
be cleaned up, the del_timer_sync() in ax25_release() will
not execute. What's more, we add ax25_cb_del() in
ax25_kill_by_device(), because the timers have been stopped
and there are no functions that could delete ax25_cb if we
do not call ax25_release(). Finally, we reorder the position
of ax25_list_lock in ax25_cb_del() in order to synchronize
among different functions that call ax25_cb_del().

Fixes: 82e31755e55f ("ax25: Fix UAF bugs in ax25 timers")
Reported-and-tested-by: Thomas Osterried <thomas@osterried.de>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
Changes in v3:
  - Mitigate race conditions through lock.

 include/net/ax25.h  |  1 +
 net/ax25/af_ax25.c  | 19 ++++++++++++-------
 net/ax25/ax25_dev.c |  1 +
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/net/ax25.h b/include/net/ax25.h
index 0f9790c455b..a427a05672e 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -228,6 +228,7 @@ typedef struct ax25_dev {
 	ax25_dama_info		dama;
 #endif
 	refcount_t		refcount;
+	bool device_up;
 } ax25_dev;
 
 typedef struct ax25_cb {
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 363d47f9453..a5b2cd6ce37 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -62,12 +62,12 @@ static void ax25_free_sock(struct sock *sk)
  */
 static void ax25_cb_del(ax25_cb *ax25)
 {
+	spin_lock_bh(&ax25_list_lock);
 	if (!hlist_unhashed(&ax25->ax25_node)) {
-		spin_lock_bh(&ax25_list_lock);
 		hlist_del_init(&ax25->ax25_node);
-		spin_unlock_bh(&ax25_list_lock);
 		ax25_cb_put(ax25);
 	}
+	spin_unlock_bh(&ax25_list_lock);
 }
 
 /*
@@ -81,6 +81,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 
 	if ((ax25_dev = ax25_dev_ax25dev(dev)) == NULL)
 		return;
+	ax25_dev->device_up = false;
 
 	spin_lock_bh(&ax25_list_lock);
 again:
@@ -91,6 +92,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 				spin_unlock_bh(&ax25_list_lock);
 				ax25_disconnect(s, ENETUNREACH);
 				s->ax25_dev = NULL;
+				ax25_cb_del(s);
 				spin_lock_bh(&ax25_list_lock);
 				goto again;
 			}
@@ -103,6 +105,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 				dev_put_track(ax25_dev->dev, &ax25_dev->dev_tracker);
 				ax25_dev_put(ax25_dev);
 			}
+			ax25_cb_del(s);
 			release_sock(sk);
 			spin_lock_bh(&ax25_list_lock);
 			sock_put(sk);
@@ -1053,11 +1056,13 @@ static int ax25_release(struct socket *sock)
 		ax25_destroy_socket(ax25);
 	}
 	if (ax25_dev) {
-		del_timer_sync(&ax25->timer);
-		del_timer_sync(&ax25->t1timer);
-		del_timer_sync(&ax25->t2timer);
-		del_timer_sync(&ax25->t3timer);
-		del_timer_sync(&ax25->idletimer);
+		if (!ax25_dev->device_up) {
+			del_timer_sync(&ax25->timer);
+			del_timer_sync(&ax25->t1timer);
+			del_timer_sync(&ax25->t2timer);
+			del_timer_sync(&ax25->t3timer);
+			del_timer_sync(&ax25->idletimer);
+		}
 		dev_put_track(ax25_dev->dev, &ax25_dev->dev_tracker);
 		ax25_dev_put(ax25_dev);
 	}
diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
index d2a244e1c26..5451be15e07 100644
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -62,6 +62,7 @@ void ax25_dev_device_up(struct net_device *dev)
 	ax25_dev->dev     = dev;
 	dev_hold_track(dev, &ax25_dev->dev_tracker, GFP_ATOMIC);
 	ax25_dev->forward = NULL;
+	ax25_dev->device_up = true;
 
 	ax25_dev->values[AX25_VALUES_IPDEFMODE] = AX25_DEF_IPDEFMODE;
 	ax25_dev->values[AX25_VALUES_AXDEFMODE] = AX25_DEF_AXDEFMODE;
-- 
2.17.1

