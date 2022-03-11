Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80F794D6571
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 16:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347525AbiCKP6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 10:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350265AbiCKP6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 10:58:25 -0500
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C63731451E6;
        Fri, 11 Mar 2022 07:57:17 -0800 (PST)
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app3 (Coremail) with SMTP id cC_KCgDHzzNHcStioxCZAA--.41247S2;
        Fri, 11 Mar 2022 23:56:59 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-hams@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, ralf@linux-mips.org,
        jreuter@yaina.de, thomas@osterried.de,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net V2 1/2] ax25: Fix refcount leaks caused by ax25_cb_del()
Date:   Fri, 11 Mar 2022 23:55:50 +0800
Message-Id: <20220311155550.102954-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cC_KCgDHzzNHcStioxCZAA--.41247S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGw1Uur4DKw15Cw18JF43Jrb_yoW5AF4rpF
        WUtF4rJrZ7tFs5CrsxWryxWF1rZrWj9393Jr1Yva4Ik3s8JasYy34rtryUtry3JFZ8JF48
        Xw17W3WxAF1kuF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUka1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r10
        6r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v
        1sIEY20_GFWkJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
        18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vI
        r41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr
        1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvE
        x4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUZa9-UUUUU=
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgkFAVZdtYnj3gAUsR
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

This patch adds decrements of refcounts in ax25_release() and use
lock_sock() to do synchronization. If refcounts decrease in ax25_release(),
the decrements of refcounts in ax25_kill_by_device() will not be
executed and vice versa.

Fixes: d01ffb9eee4a ("ax25: add refcount in ax25_dev to avoid UAF bugs")
Fixes: feef318c855a ("ax25: fix UAF bugs of net_device caused by rebinding operation")
Reported-by: Thomas Osterried <thomas@osterried.de>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
Changes in V2:
  - Add decrements of refcounts in ax25_release().

 net/ax25/af_ax25.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 6bd09718077..0886109421a 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -98,8 +98,10 @@ static void ax25_kill_by_device(struct net_device *dev)
 			spin_unlock_bh(&ax25_list_lock);
 			lock_sock(sk);
 			s->ax25_dev = NULL;
-			dev_put_track(ax25_dev->dev, &ax25_dev->dev_tracker);
-			ax25_dev_put(ax25_dev);
+			if (sk->sk_wq) {
+				dev_put_track(ax25_dev->dev, &ax25_dev->dev_tracker);
+				ax25_dev_put(ax25_dev);
+			}
 			ax25_disconnect(s, ENETUNREACH);
 			release_sock(sk);
 			spin_lock_bh(&ax25_list_lock);
@@ -979,14 +981,20 @@ static int ax25_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
 	ax25_cb *ax25;
+	ax25_dev *ax25_dev;
 
 	if (sk == NULL)
 		return 0;
 
 	sock_hold(sk);
-	sock_orphan(sk);
 	lock_sock(sk);
+	sock_orphan(sk);
 	ax25 = sk_to_ax25(sk);
+	ax25_dev = ax25->ax25_dev;
+	if (ax25_dev) {
+		dev_put_track(ax25_dev->dev, &ax25_dev->dev_tracker);
+		ax25_dev_put(ax25_dev);
+	}
 
 	if (sk->sk_type == SOCK_SEQPACKET) {
 		switch (ax25->state) {
-- 
2.17.1

