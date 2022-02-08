Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D979E4AE339
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 23:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbiBHWVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 17:21:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386290AbiBHUBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 15:01:01 -0500
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.164])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F053C0613CB
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 12:00:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1644350446;
    s=strato-dkim-0002; d=hartkopp.net;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=4AfHIdTHwEnkximOkz9mpc8bmI4/bQHur8BV8sweVH0=;
    b=VwGXCkscGHkvqWP2vSJaW9XHZi7e8X3YGh18pPV4An8RTTmPVnx0wdr+CEhRI2ZbI3
    5Thk3pqoxYok1MN6lTJxIuP8zHVHB1IuSmu2d+WeNpDc8g2IHMYB/5Yu4d5mz9JQLDlE
    NKF4WuCnf1gyV4RVISm2/iwSVXf1FlYeE8m/a+TzEj7kgoaE+1Hbl7opQhImirkaRpJc
    /mhTCwZemLj4cGxYhfBNzTHDSLtPaChfYDBVRZdxkSvo8hXZSDU4J18+ualBT9GlflYY
    a/sUcFobt9a7FP0xwGMHxCu5B8aKtzTJ3ogx3W+iDU8Mj3ftVW0HoP/tyeE4tOR9Dbl8
    1mdg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS/xvEBL7X5sbo3UIh9IyLecSWJafUv+rx4"
X-RZG-CLASS-ID: mo00
Received: from silver.lan
    by smtp.strato.de (RZmta 47.39.0 AUTH)
    with ESMTPSA id L7379cy18K0jNDP
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 8 Feb 2022 21:00:45 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     netdev@vger.kernel.org, linux-can@vger.kernel.org,
        william.xuanziyang@huawei.com, mkl@pengutronix.de
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com
Subject: [PATCH] can: isotp: fix potential CAN frame reception race in isotp_rcv()
Date:   Tue,  8 Feb 2022 21:00:26 +0100
Message-Id: <20220208200026.13783-1-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Link: https://lore.kernel.org/linux-can/d7e69278-d741-c706-65e1-e87623d9a8e8@huawei.com/T/
Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Reported-by: syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com
Reported-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 net/can/isotp.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 02cbcb2ecf0d..9149e8d8aefc 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -54,10 +54,11 @@
  */
 
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/spinlock.h>
 #include <linux/hrtimer.h>
 #include <linux/wait.h>
 #include <linux/uio.h>
 #include <linux/net.h>
 #include <linux/netdevice.h>
@@ -143,10 +144,11 @@ struct isotp_sock {
 	u32 force_tx_stmin;
 	u32 force_rx_stmin;
 	struct tpcon rx, tx;
 	struct list_head notifier;
 	wait_queue_head_t wait;
+	spinlock_t rx_lock; /* protect single thread state machine */
 };
 
 static LIST_HEAD(isotp_notifier_list);
 static DEFINE_SPINLOCK(isotp_notifier_lock);
 static struct isotp_sock *isotp_busy_notifier;
@@ -613,15 +615,21 @@ static void isotp_rcv(struct sk_buff *skb, void *data)
 	if (ae && cf->data[0] != so->opt.rx_ext_address)
 		return;
 
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
 	case N_PCI_FC:
 		/* tx path: flow control frame containing the FC parameters */
@@ -666,10 +674,13 @@ static void isotp_rcv(struct sk_buff *skb, void *data)
 	case N_PCI_CF:
 		/* rx path: consecutive frame */
 		isotp_rcv_cf(sk, cf, ae, skb);
 		break;
 	}
+
+out_unlock:
+	spin_unlock(&so->rx_lock);
 }
 
 static void isotp_fill_dataframe(struct canfd_frame *cf, struct isotp_sock *so,
 				 int ae, int off)
 {
@@ -1442,10 +1453,11 @@ static int isotp_init(struct sock *sk)
 	so->rxtimer.function = isotp_rx_timer_handler;
 	hrtimer_init(&so->txtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_SOFT);
 	so->txtimer.function = isotp_tx_timer_handler;
 
 	init_waitqueue_head(&so->wait);
+	spin_lock_init(&so->rx_lock);
 
 	spin_lock(&isotp_notifier_lock);
 	list_add_tail(&so->notifier, &isotp_notifier_list);
 	spin_unlock(&isotp_notifier_lock);
 
-- 
2.30.2

