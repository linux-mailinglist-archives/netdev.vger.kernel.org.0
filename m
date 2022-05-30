Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC351538573
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 17:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238522AbiE3PwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 11:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242924AbiE3Pvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 11:51:53 -0400
Received: from zg8tndyumtaxlji0oc4xnzya.icoremail.net (zg8tndyumtaxlji0oc4xnzya.icoremail.net [46.101.248.176])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 54B96366A3;
        Mon, 30 May 2022 08:22:29 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [106.117.80.109])
        by mail-app2 (Coremail) with SMTP id by_KCgCXnwsV4ZRiwJkMAQ--.5265S2;
        Mon, 30 May 2022 23:22:05 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-hams@vger.kernel.org
Cc:     jreuter@yaina.de, ralf@linux-mips.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas@osterried.de, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net v5] ax25: Fix ax25 session cleanup problems
Date:   Mon, 30 May 2022 23:21:58 +0800
Message-Id: <20220530152158.108619-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: by_KCgCXnwsV4ZRiwJkMAQ--.5265S2
X-Coremail-Antispam: 1UD129KBjvJXoWxtF45ZFWxZry7XFWfAw1DZFb_yoWxWF4UpF
        W7Ka1fJrWDXr4rCw4ruFWkWF18Zw4qq3yUGr1UuFnakw13Gr98JFyktFyjqFW3GFWfJF1D
        Z34UWan8Ar4kuaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
        Y2ka0xkIwI1lc2xSY4AK67AK6ryrMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
        1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
        b7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
        vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
        cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
        nxnUUI43ZEXa7VUbOB_UUUUUU==
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgkGAVZdtZ9ZQQABs0
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are session cleanup problems in ax25_release() and
ax25_disconnect(). If we setup a session and then disconnect,
the disconnected session is still in "LISTENING" state that
is shown below.

Active AX.25 sockets
Dest       Source     Device  State        Vr/Vs    Send-Q  Recv-Q
DL9SAU-4   DL9SAU-3   ???     LISTENING    000/000  0       0
DL9SAU-3   DL9SAU-4   ???     LISTENING    000/000  0       0

The first reason is caused by del_timer_sync() in ax25_release().
The timers of ax25 are used for correct session cleanup. If we use
ax25_release() to close ax25 sessions and ax25_dev is not null,
the del_timer_sync() functions in ax25_release() will execute.
As a result, the sessions could not be cleaned up correctly,
because the timers have stopped.

In order to solve this problem, this patch adds a device_up flag
in ax25_dev in order to judge whether the device is up. If there
are sessions to be cleaned up, the del_timer_sync() in
ax25_release() will not execute. What's more, we add ax25_cb_del()
in ax25_kill_by_device(), because the timers have been stopped
and there are no functions that could delete ax25_cb if we do not
call ax25_release(). Finally, we reorder the position of
ax25_list_lock in ax25_cb_del() in order to synchronize among
different functions that call ax25_cb_del().

The second reason is caused by improper check in ax25_disconnect().
The incoming ax25 sessions which ax25->sk is null will close
heartbeat timer, because the check "if(!ax25->sk || ..)" is
satisfied. As a result, the session could not be cleaned up properly.

In order to solve this problem, this patch changes the improper
check to "if(ax25->sk && ..)" in ax25_disconnect().

What`s more, the ax25_disconnect() may be called twice, which is
not necessary. For example, ax25_kill_by_device() calls
ax25_disconnect() and sets ax25->state to AX25_STATE_0, but
ax25_release() calls ax25_disconnect() again.

In order to solve this problem, this patch add a check in
ax25_release(). If the flag of ax25->sk equals to SOCK_DEAD,
the ax25_disconnect() in ax25_release() should not be executed.

Fixes: 82e31755e55f ("ax25: Fix UAF bugs in ax25 timers")
Fixes: 8a367e74c012 ("ax25: Fix segfault after sock connection timeout")
Reported-and-tested-by: Thomas Osterried <thomas@osterried.de>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
Changes since v1:
  - Add ax25_cb_del() in ax25_kill_by_device().
  - Mitigate race conditions through lock.
  - Fix session cleanup problem in ax25_disconnect().
  - Fix ax25_disconnect() may be called twice problem.
  - Change check in ax25_disconnect() to "if(ax25->sk && ..)".

 include/net/ax25.h   |  1 +
 net/ax25/af_ax25.c   | 27 +++++++++++++++++----------
 net/ax25/ax25_dev.c  |  1 +
 net/ax25/ax25_subr.c |  2 +-
 4 files changed, 20 insertions(+), 11 deletions(-)

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
index 363d47f9453..289f355e185 100644
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
@@ -995,9 +998,11 @@ static int ax25_release(struct socket *sock)
 	if (sk->sk_type == SOCK_SEQPACKET) {
 		switch (ax25->state) {
 		case AX25_STATE_0:
-			release_sock(sk);
-			ax25_disconnect(ax25, 0);
-			lock_sock(sk);
+			if (!sock_flag(ax25->sk, SOCK_DEAD)) {
+				release_sock(sk);
+				ax25_disconnect(ax25, 0);
+				lock_sock(sk);
+			}
 			ax25_destroy_socket(ax25);
 			break;
 
@@ -1053,11 +1058,13 @@ static int ax25_release(struct socket *sock)
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
diff --git a/net/ax25/ax25_subr.c b/net/ax25/ax25_subr.c
index 3a476e4f6cd..9ff98f46dc6 100644
--- a/net/ax25/ax25_subr.c
+++ b/net/ax25/ax25_subr.c
@@ -268,7 +268,7 @@ void ax25_disconnect(ax25_cb *ax25, int reason)
 		del_timer_sync(&ax25->t3timer);
 		del_timer_sync(&ax25->idletimer);
 	} else {
-		if (!ax25->sk || !sock_flag(ax25->sk, SOCK_DESTROY))
+		if (ax25->sk && !sock_flag(ax25->sk, SOCK_DESTROY))
 			ax25_stop_heartbeat(ax25);
 		ax25_stop_t1timer(ax25);
 		ax25_stop_t2timer(ax25);
-- 
2.17.1

