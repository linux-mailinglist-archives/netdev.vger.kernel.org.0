Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B944AEBB5
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 09:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240293AbiBIICA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 03:02:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240290AbiBIIB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 03:01:56 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E503C05CB84
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 00:01:59 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nHhvJ-0003oL-U3
        for netdev@vger.kernel.org; Wed, 09 Feb 2022 09:01:57 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id C64D32EF16
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 08:01:55 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 298F52EEFE;
        Wed,  9 Feb 2022 08:01:55 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c9a9f42f;
        Wed, 9 Feb 2022 08:01:54 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        stable@vger.kernel.org,
        syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 1/2] can: isotp: fix potential CAN frame reception race in isotp_rcv()
Date:   Wed,  9 Feb 2022 09:01:53 +0100
Message-Id: <20220209080154.315214-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209080154.315214-1-mkl@pengutronix.de>
References: <20220209080154.315214-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

When receiving a CAN frame the current code logic does not consider
concurrently receiving processes which do not show up in real world
usage.

Ziyang Xuan writes:

The following syz problem is one of the scenarios. so->rx.len is
changed by isotp_rcv_ff() during isotp_rcv_cf(), so->rx.len equals
0 before alloc_skb() and equals 4096 after alloc_skb(). That will
trigger skb_over_panic() in skb_put().

=======================================================
CPU: 1 PID: 19 Comm: ksoftirqd/1 Not tainted 5.16.0-rc8-syzkaller #0
RIP: 0010:skb_panic+0x16c/0x16e net/core/skbuff.c:113
Call Trace:
 <TASK>
 skb_over_panic net/core/skbuff.c:118 [inline]
 skb_put.cold+0x24/0x24 net/core/skbuff.c:1990
 isotp_rcv_cf net/can/isotp.c:570 [inline]
 isotp_rcv+0xa38/0x1e30 net/can/isotp.c:668
 deliver net/can/af_can.c:574 [inline]
 can_rcv_filter+0x445/0x8d0 net/can/af_can.c:635
 can_receive+0x31d/0x580 net/can/af_can.c:665
 can_rcv+0x120/0x1c0 net/can/af_can.c:696
 __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5465
 __netif_receive_skb+0x24/0x1b0 net/core/dev.c:5579

Therefore we make sure the state changes and data structures stay
consistent at CAN frame reception time by adding a spin_lock in
isotp_rcv(). This fixes the issue reported by syzkaller but does not
affect real world operation.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Link: https://lore.kernel.org/linux-can/d7e69278-d741-c706-65e1-e87623d9a8e8@huawei.com/T/
Link: https://lore.kernel.org/all/20220208200026.13783-1-socketcan@hartkopp.net
Cc: stable@vger.kernel.org
Reported-by: syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com
Reported-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/isotp.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 02cbcb2ecf0d..9149e8d8aefc 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -56,6 +56,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/spinlock.h>
 #include <linux/hrtimer.h>
 #include <linux/wait.h>
 #include <linux/uio.h>
@@ -145,6 +146,7 @@ struct isotp_sock {
 	struct tpcon rx, tx;
 	struct list_head notifier;
 	wait_queue_head_t wait;
+	spinlock_t rx_lock; /* protect single thread state machine */
 };
 
 static LIST_HEAD(isotp_notifier_list);
@@ -615,11 +617,17 @@ static void isotp_rcv(struct sk_buff *skb, void *data)
 
 	n_pci_type = cf->data[ae] & 0xF0;
 
+	/* Make sure the state changes and data structures stay consistent at
+	 * CAN frame reception time. This locking is not needed in real world
+	 * use cases but the inconsistency can be triggered with syzkaller.
+	 */
+	spin_lock(&so->rx_lock);
+
 	if (so->opt.flags & CAN_ISOTP_HALF_DUPLEX) {
 		/* check rx/tx path half duplex expectations */
 		if ((so->tx.state != ISOTP_IDLE && n_pci_type != N_PCI_FC) ||
 		    (so->rx.state != ISOTP_IDLE && n_pci_type == N_PCI_FC))
-			return;
+			goto out_unlock;
 	}
 
 	switch (n_pci_type) {
@@ -668,6 +676,9 @@ static void isotp_rcv(struct sk_buff *skb, void *data)
 		isotp_rcv_cf(sk, cf, ae, skb);
 		break;
 	}
+
+out_unlock:
+	spin_unlock(&so->rx_lock);
 }
 
 static void isotp_fill_dataframe(struct canfd_frame *cf, struct isotp_sock *so,
@@ -1444,6 +1455,7 @@ static int isotp_init(struct sock *sk)
 	so->txtimer.function = isotp_tx_timer_handler;
 
 	init_waitqueue_head(&so->wait);
+	spin_lock_init(&so->rx_lock);
 
 	spin_lock(&isotp_notifier_lock);
 	list_add_tail(&so->notifier, &isotp_notifier_list);

base-commit: 7db788ad627aabff2b74d4f1a3b68516d0fee0d7
-- 
2.34.1


