Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD754D5784
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 02:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238789AbiCKBrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 20:47:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231840AbiCKBrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 20:47:48 -0500
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EC224177D21;
        Thu, 10 Mar 2022 17:46:43 -0800 (PST)
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app3 (Coremail) with SMTP id cC_KCgBHnxXyqSpipmKMAA--.24830S2;
        Fri, 11 Mar 2022 09:46:31 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-hams@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jreuter@yaina.de, kuba@kernel.org, davem@davemloft.net,
        ralf@linux-mips.org, thomas@osterried.de,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH V3] ax25: Fix refcount leaks caused by ax25_cb_del()
Date:   Fri, 11 Mar 2022 09:46:24 +0800
Message-Id: <20220311014624.51117-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cC_KCgBHnxXyqSpipmKMAA--.24830S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGw1Uur4DKw15Cw18JF43Jrb_yoWrAF4kpF
        WqvayrArZrtr1rCa18GryxWF18Zryqk3ykGry5ZFyIkasxJwn5ArZ3t3yUJry3JFZ5JF18
        Z347Ww43Zr1DuFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkI1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJr0_GcWl84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
        8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
        Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxF
        aVAv8VW8uw4UJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr
        4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxG
        rwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8Jw
        CI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2
        z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgkFAVZdtYnj3gAHsC
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous commit d01ffb9eee4a ("ax25: add refcount in ax25_dev to
avoid UAF bugs") and commit feef318c855a ("ax25: fix UAF bugs of
net_device caused by rebinding operation") increase the refcounts of
ax25_dev and net_device in ax25_bind() and decrease the matching refcounts
in ax25_kill_by_device() in order to prevent UAF bugs, but there are
reference count leaks.

The root cause of refcount leaks is shown below:

     (Thread 1)                      |      (Thread 2)
ax25_bind()                          |
 ...                                 |
 ax25_addr_ax25dev()                 |
  ax25_dev_hold()   //(1)            |
  ...                                |
 dev_hold_track()   //(2)            |
 ...                                 | ax25_destroy_socket()
                                     |  ax25_cb_del()
                                     |   ...
                                     |   hlist_del_init() //(3)
                                     |
                                     |
     (thread 3)                      |
ax25_kill_by_device()                |
 ...                                 |
 ax25_for_each(s, &ax25_list) {      |
  if (s->ax25_dev == ax25_dev) //(4) |
   ...                               |

Firstly, we use ax25_bind() to increase the refcount of ax25_dev in
position (1) and increase the refcount of net_device in position (2).
Then, we use ax25_cb_del() invoked by ax25_destroy_socket() to delete
ax25_cb in hlist in position (3) before calling ax25_kill_by_device().
Finally, the decrements of refcounts in ax25_kill_by_device() will not
be executed, because no s->ax25_dev equals to ax25_dev in position (4).

This patch adds a flag in ax25_dev in order to prevent reference count
leaks. If the above condition happens, the "test_bit" condition check
in ax25_kill_by_device() could pass and the refcounts could be
decreased properly.

Fixes: d01ffb9eee4a ("ax25: add refcount in ax25_dev to avoid UAF bugs")
Fixes: feef318c855a ("ax25: fix UAF bugs of net_device caused by rebinding operation")
Reported-by: Thomas Osterried <thomas@osterried.de>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
Changes in V3:
  - Use one flag in ax25_dev to check.
  - Make commit message more clearer.
  - Fix format problem.

 include/net/ax25.h  | 5 +++++
 net/ax25/af_ax25.c  | 6 ++++++
 net/ax25/ax25_dev.c | 1 +
 3 files changed, 12 insertions(+)

diff --git a/include/net/ax25.h b/include/net/ax25.h
index 8221af1811d..ea6ca385190 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -158,6 +158,10 @@ enum {
 #define	AX25_DEF_PROTOCOL	AX25_PROTO_STD_SIMPLEX	/* Standard AX.25 */
 #define AX25_DEF_DS_TIMEOUT	180000			/* DAMA timeout 3 minutes */
 
+#define AX25_DEV_INIT    0
+#define AX25_DEV_KILL    0
+#define AX25_DEV_BIND    1
+
 typedef struct ax25_uid_assoc {
 	struct hlist_node	uid_node;
 	refcount_t		refcount;
@@ -240,6 +244,7 @@ typedef struct ax25_dev {
 	ax25_dama_info		dama;
 #endif
 	refcount_t		refcount;
+	unsigned long	flag;
 } ax25_dev;
 
 typedef struct ax25_cb {
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 6bd09718077..fc564b87acc 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -86,6 +86,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 again:
 	ax25_for_each(s, &ax25_list) {
 		if (s->ax25_dev == ax25_dev) {
+			set_bit(AX25_DEV_KILL, &ax25_dev->flag);
 			sk = s->sk;
 			if (!sk) {
 				spin_unlock_bh(&ax25_list_lock);
@@ -115,6 +116,10 @@ static void ax25_kill_by_device(struct net_device *dev)
 		}
 	}
 	spin_unlock_bh(&ax25_list_lock);
+	if (!test_bit(AX25_DEV_KILL, &ax25_dev->flag) && test_bit(AX25_DEV_BIND, &ax25_dev->flag)) {
+		dev_put_track(ax25_dev->dev, &ax25_dev->dev_tracker);
+		ax25_dev_put(ax25_dev);
+	}
 }
 
 /*
@@ -1132,6 +1137,7 @@ static int ax25_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 done:
 	ax25_cb_add(ax25);
 	sock_reset_flag(sk, SOCK_ZAPPED);
+	set_bit(AX25_DEV_BIND, &ax25_dev->flag);
 
 out:
 	release_sock(sk);
diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
index d2a244e1c26..9b04d74a1be 100644
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -77,6 +77,7 @@ void ax25_dev_device_up(struct net_device *dev)
 	ax25_dev->values[AX25_VALUES_PACLEN]	= AX25_DEF_PACLEN;
 	ax25_dev->values[AX25_VALUES_PROTOCOL]  = AX25_DEF_PROTOCOL;
 	ax25_dev->values[AX25_VALUES_DS_TIMEOUT]= AX25_DEF_DS_TIMEOUT;
+	ax25_dev->flag = AX25_DEV_INIT;
 
 #if defined(CONFIG_AX25_DAMA_SLAVE) || defined(CONFIG_AX25_DAMA_MASTER)
 	ax25_ds_setup_timer(ax25_dev);
-- 
2.17.1

