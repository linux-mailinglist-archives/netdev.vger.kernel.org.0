Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2628F56561E
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 14:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234677AbiGDMxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 08:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234664AbiGDMwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 08:52:41 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A6012092
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 05:52:31 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o8LYw-00013r-Rr
        for netdev@vger.kernel.org; Mon, 04 Jul 2022 14:52:26 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 5F813A7990
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 12:26:15 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 9BD6FA7922;
        Mon,  4 Jul 2022 12:26:14 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 6850e39a;
        Mon, 4 Jul 2022 12:26:14 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 01/15] can: bcm: use call_rcu() instead of costly synchronize_rcu()
Date:   Mon,  4 Jul 2022 14:25:59 +0200
Message-Id: <20220704122613.1551119-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220704122613.1551119-1-mkl@pengutronix.de>
References: <20220704122613.1551119-1-mkl@pengutronix.de>
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

In commit d5f9023fa61e ("can: bcm: delay release of struct bcm_op
after synchronize_rcu()") Thadeu Lima de Souza Cascardo introduced two
synchronize_rcu() calls in bcm_release() (only once at socket close)
and in bcm_delete_rx_op() (called on removal of each single bcm_op).

Unfortunately this slow removal of the bcm_op's affects user space
applications like cansniffer where the modification of a filter
removes 2048 bcm_op's which blocks the cansniffer application for
40(!) seconds.

In commit 181d4447905d ("can: gw: use call_rcu() instead of costly
synchronize_rcu()") Eric Dumazet replaced the synchronize_rcu() calls
with several call_rcu()'s to safely remove the data structures after
the removal of CAN ID subscriptions with can_rx_unregister() calls.

This patch adopts Erics approach for the can-bcm which should be
applicable since the removal of tasklet_kill() in bcm_remove_op() and
the introduction of the HRTIMER_MODE_SOFT timer handling in Linux 5.4.

Fixes: d5f9023fa61e ("can: bcm: delay release of struct bcm_op after synchronize_rcu()") # >= 5.4
Link: https://lore.kernel.org/all/20220520183239.19111-1-socketcan@hartkopp.net
Cc: stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>
Cc: Norbert Slusarek <nslusarek@gmx.net>
Cc: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/bcm.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index 65ee1b784a30..e60161bec850 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -100,6 +100,7 @@ static inline u64 get_u64(const struct canfd_frame *cp, int offset)
 
 struct bcm_op {
 	struct list_head list;
+	struct rcu_head rcu;
 	int ifindex;
 	canid_t can_id;
 	u32 flags;
@@ -718,10 +719,9 @@ static struct bcm_op *bcm_find_op(struct list_head *ops,
 	return NULL;
 }
 
-static void bcm_remove_op(struct bcm_op *op)
+static void bcm_free_op_rcu(struct rcu_head *rcu_head)
 {
-	hrtimer_cancel(&op->timer);
-	hrtimer_cancel(&op->thrtimer);
+	struct bcm_op *op = container_of(rcu_head, struct bcm_op, rcu);
 
 	if ((op->frames) && (op->frames != &op->sframe))
 		kfree(op->frames);
@@ -732,6 +732,14 @@ static void bcm_remove_op(struct bcm_op *op)
 	kfree(op);
 }
 
+static void bcm_remove_op(struct bcm_op *op)
+{
+	hrtimer_cancel(&op->timer);
+	hrtimer_cancel(&op->thrtimer);
+
+	call_rcu(&op->rcu, bcm_free_op_rcu);
+}
+
 static void bcm_rx_unreg(struct net_device *dev, struct bcm_op *op)
 {
 	if (op->rx_reg_dev == dev) {
@@ -757,6 +765,9 @@ static int bcm_delete_rx_op(struct list_head *ops, struct bcm_msg_head *mh,
 		if ((op->can_id == mh->can_id) && (op->ifindex == ifindex) &&
 		    (op->flags & CAN_FD_FRAME) == (mh->flags & CAN_FD_FRAME)) {
 
+			/* disable automatic timer on frame reception */
+			op->flags |= RX_NO_AUTOTIMER;
+
 			/*
 			 * Don't care if we're bound or not (due to netdev
 			 * problems) can_rx_unregister() is always a save
@@ -785,7 +796,6 @@ static int bcm_delete_rx_op(struct list_head *ops, struct bcm_msg_head *mh,
 						  bcm_rx_handler, op);
 
 			list_del(&op->list);
-			synchronize_rcu();
 			bcm_remove_op(op);
 			return 1; /* done */
 		}

base-commit: 280e3a857d96f9ca8e24632788e1e7a0fec4e9f7
-- 
2.35.1


