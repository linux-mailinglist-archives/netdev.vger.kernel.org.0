Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCDC48992F
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 14:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbiAJNFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 08:05:33 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:31083 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbiAJNE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 08:04:56 -0500
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4JXYqN5DPxz1FCdT;
        Mon, 10 Jan 2022 21:01:20 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 10 Jan 2022 21:04:53 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <socketcan@hartkopp.net>,
        <mkl@pengutronix.de>, <netdev@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
        <linux-can@vger.kernel.org>, <tglx@linutronix.de>,
        <anna-maria@linutronix.de>
Subject: [PATCH net] can: bcm: switch timer to HRTIMER_MODE_SOFT and remove hrtimer_tasklet
Date:   Mon, 10 Jan 2022 21:23:22 +0800
Message-ID: <20220110132322.1726106-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ commit bf74aa86e111aa3b2fbb25db37e3a3fab71b5b68 upstream ]

Stop tx/rx cycle rely on the active state of tasklet and hrtimer
sequentially in bcm_remove_op(), the op object will be freed if they
are all unactive. Assume the hrtimer timeout is short, the hrtimer
cb has been excuted after tasklet conditional judgment which must be
false after last round tasklet_kill() and before condition
hrtimer_active(), it is false when execute to hrtimer_active(). Bug
is triggerd, because the stopping action is end and the op object
will be freed, but the tasklet is scheduled. The resources of the op
object will occur UAF bug.

----------------------------------------------------------------------

This patch switches the timer to HRTIMER_MODE_SOFT, which executed the
timer callback in softirq context and removes the hrtimer_tasklet.

Reported-by: syzbot+652023d5376450cc8516@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org # 4.19
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Anna-Maria Gleixner <anna-maria@linutronix.de>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/can/bcm.c | 156 +++++++++++++++++---------------------------------
 1 file changed, 52 insertions(+), 104 deletions(-)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index e75d3fd7da4f..353098166031 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -105,7 +105,6 @@ struct bcm_op {
 	unsigned long frames_abs, frames_filtered;
 	struct bcm_timeval ival1, ival2;
 	struct hrtimer timer, thrtimer;
-	struct tasklet_struct tsklet, thrtsklet;
 	ktime_t rx_stamp, kt_ival1, kt_ival2, kt_lastmsg;
 	int rx_ifindex;
 	int cfsiz;
@@ -374,25 +373,34 @@ static void bcm_send_to_user(struct bcm_op *op, struct bcm_msg_head *head,
 	}
 }
 
-static void bcm_tx_start_timer(struct bcm_op *op)
+static bool bcm_tx_set_expiry(struct bcm_op *op, struct hrtimer *hrt)
 {
+	ktime_t ival;
+
 	if (op->kt_ival1 && op->count)
-		hrtimer_start(&op->timer,
-			      ktime_add(ktime_get(), op->kt_ival1),
-			      HRTIMER_MODE_ABS);
+		ival = op->kt_ival1;
 	else if (op->kt_ival2)
-		hrtimer_start(&op->timer,
-			      ktime_add(ktime_get(), op->kt_ival2),
-			      HRTIMER_MODE_ABS);
+		ival = op->kt_ival2;
+	else
+		return false;
+
+	hrtimer_set_expires(hrt, ktime_add(ktime_get(), ival));
+	return true;
 }
 
-static void bcm_tx_timeout_tsklet(unsigned long data)
+static void bcm_tx_start_timer(struct bcm_op *op)
 {
-	struct bcm_op *op = (struct bcm_op *)data;
+	if (bcm_tx_set_expiry(op, &op->timer))
+		hrtimer_start_expires(&op->timer, HRTIMER_MODE_ABS_SOFT);
+}
+
+/* bcm_tx_timeout_handler - performs cyclic CAN frame transmissions */
+static enum hrtimer_restart bcm_tx_timeout_handler(struct hrtimer *hrtimer)
+{
+	struct bcm_op *op = container_of(hrtimer, struct bcm_op, timer);
 	struct bcm_msg_head msg_head;
 
 	if (op->kt_ival1 && (op->count > 0)) {
-
 		op->count--;
 		if (!op->count && (op->flags & TX_COUNTEVT)) {
 
@@ -410,22 +418,12 @@ static void bcm_tx_timeout_tsklet(unsigned long data)
 		}
 		bcm_can_tx(op);
 
-	} else if (op->kt_ival2)
+	} else if (op->kt_ival2) {
 		bcm_can_tx(op);
+	}
 
-	bcm_tx_start_timer(op);
-}
-
-/*
- * bcm_tx_timeout_handler - performs cyclic CAN frame transmissions
- */
-static enum hrtimer_restart bcm_tx_timeout_handler(struct hrtimer *hrtimer)
-{
-	struct bcm_op *op = container_of(hrtimer, struct bcm_op, timer);
-
-	tasklet_schedule(&op->tsklet);
-
-	return HRTIMER_NORESTART;
+	return bcm_tx_set_expiry(op, &op->timer) ?
+		HRTIMER_RESTART : HRTIMER_NORESTART;
 }
 
 /*
@@ -492,7 +490,7 @@ static void bcm_rx_update_and_send(struct bcm_op *op,
 		/* do not send the saved data - only start throttle timer */
 		hrtimer_start(&op->thrtimer,
 			      ktime_add(op->kt_lastmsg, op->kt_ival2),
-			      HRTIMER_MODE_ABS);
+			      HRTIMER_MODE_ABS_SOFT);
 		return;
 	}
 
@@ -551,14 +549,21 @@ static void bcm_rx_starttimer(struct bcm_op *op)
 		return;
 
 	if (op->kt_ival1)
-		hrtimer_start(&op->timer, op->kt_ival1, HRTIMER_MODE_REL);
+		hrtimer_start(&op->timer, op->kt_ival1, HRTIMER_MODE_REL_SOFT);
 }
 
-static void bcm_rx_timeout_tsklet(unsigned long data)
+/* bcm_rx_timeout_handler - when the (cyclic) CAN frame reception timed out */
+static enum hrtimer_restart bcm_rx_timeout_handler(struct hrtimer *hrtimer)
 {
-	struct bcm_op *op = (struct bcm_op *)data;
+	struct bcm_op *op = container_of(hrtimer, struct bcm_op, timer);
 	struct bcm_msg_head msg_head;
 
+	/* if user wants to be informed, when cyclic CAN-Messages come back */
+	if ((op->flags & RX_ANNOUNCE_RESUME) && op->last_frames) {
+		/* clear received CAN frames to indicate 'nothing received' */
+		memset(op->last_frames, 0, op->nframes * op->cfsiz);
+	}
+
 	/* create notification to user */
 	memset(&msg_head, 0, sizeof(msg_head));
 	msg_head.opcode  = RX_TIMEOUT;
@@ -570,25 +575,6 @@ static void bcm_rx_timeout_tsklet(unsigned long data)
 	msg_head.nframes = 0;
 
 	bcm_send_to_user(op, &msg_head, NULL, 0);
-}
-
-/*
- * bcm_rx_timeout_handler - when the (cyclic) CAN frame reception timed out
- */
-static enum hrtimer_restart bcm_rx_timeout_handler(struct hrtimer *hrtimer)
-{
-	struct bcm_op *op = container_of(hrtimer, struct bcm_op, timer);
-
-	/* schedule before NET_RX_SOFTIRQ */
-	tasklet_hi_schedule(&op->tsklet);
-
-	/* no restart of the timer is done here! */
-
-	/* if user wants to be informed, when cyclic CAN-Messages come back */
-	if ((op->flags & RX_ANNOUNCE_RESUME) && op->last_frames) {
-		/* clear received CAN frames to indicate 'nothing received' */
-		memset(op->last_frames, 0, op->nframes * op->cfsiz);
-	}
 
 	return HRTIMER_NORESTART;
 }
@@ -596,14 +582,12 @@ static enum hrtimer_restart bcm_rx_timeout_handler(struct hrtimer *hrtimer)
 /*
  * bcm_rx_do_flush - helper for bcm_rx_thr_flush
  */
-static inline int bcm_rx_do_flush(struct bcm_op *op, int update,
-				  unsigned int index)
+static inline int bcm_rx_do_flush(struct bcm_op *op, unsigned int index)
 {
 	struct canfd_frame *lcf = op->last_frames + op->cfsiz * index;
 
 	if ((op->last_frames) && (lcf->flags & RX_THR)) {
-		if (update)
-			bcm_rx_changed(op, lcf);
+		bcm_rx_changed(op, lcf);
 		return 1;
 	}
 	return 0;
@@ -611,11 +595,8 @@ static inline int bcm_rx_do_flush(struct bcm_op *op, int update,
 
 /*
  * bcm_rx_thr_flush - Check for throttled data and send it to the userspace
- *
- * update == 0 : just check if throttled data is available  (any irq context)
- * update == 1 : check and send throttled data to userspace (soft_irq context)
  */
-static int bcm_rx_thr_flush(struct bcm_op *op, int update)
+static int bcm_rx_thr_flush(struct bcm_op *op)
 {
 	int updated = 0;
 
@@ -624,24 +605,16 @@ static int bcm_rx_thr_flush(struct bcm_op *op, int update)
 
 		/* for MUX filter we start at index 1 */
 		for (i = 1; i < op->nframes; i++)
-			updated += bcm_rx_do_flush(op, update, i);
+			updated += bcm_rx_do_flush(op, i);
 
 	} else {
 		/* for RX_FILTER_ID and simple filter */
-		updated += bcm_rx_do_flush(op, update, 0);
+		updated += bcm_rx_do_flush(op, 0);
 	}
 
 	return updated;
 }
 
-static void bcm_rx_thr_tsklet(unsigned long data)
-{
-	struct bcm_op *op = (struct bcm_op *)data;
-
-	/* push the changed data to the userspace */
-	bcm_rx_thr_flush(op, 1);
-}
-
 /*
  * bcm_rx_thr_handler - the time for blocked content updates is over now:
  *                      Check for throttled data and send it to the userspace
@@ -650,9 +623,7 @@ static enum hrtimer_restart bcm_rx_thr_handler(struct hrtimer *hrtimer)
 {
 	struct bcm_op *op = container_of(hrtimer, struct bcm_op, thrtimer);
 
-	tasklet_schedule(&op->thrtsklet);
-
-	if (bcm_rx_thr_flush(op, 0)) {
+	if (bcm_rx_thr_flush(op)) {
 		hrtimer_forward(hrtimer, ktime_get(), op->kt_ival2);
 		return HRTIMER_RESTART;
 	} else {
@@ -748,23 +719,8 @@ static struct bcm_op *bcm_find_op(struct list_head *ops,
 
 static void bcm_remove_op(struct bcm_op *op)
 {
-	if (op->tsklet.func) {
-		while (test_bit(TASKLET_STATE_SCHED, &op->tsklet.state) ||
-		       test_bit(TASKLET_STATE_RUN, &op->tsklet.state) ||
-		       hrtimer_active(&op->timer)) {
-			hrtimer_cancel(&op->timer);
-			tasklet_kill(&op->tsklet);
-		}
-	}
-
-	if (op->thrtsklet.func) {
-		while (test_bit(TASKLET_STATE_SCHED, &op->thrtsklet.state) ||
-		       test_bit(TASKLET_STATE_RUN, &op->thrtsklet.state) ||
-		       hrtimer_active(&op->thrtimer)) {
-			hrtimer_cancel(&op->thrtimer);
-			tasklet_kill(&op->thrtsklet);
-		}
-	}
+	hrtimer_cancel(&op->timer);
+	hrtimer_cancel(&op->thrtimer);
 
 	if ((op->frames) && (op->frames != &op->sframe))
 		kfree(op->frames);
@@ -998,15 +954,13 @@ static int bcm_tx_setup(struct bcm_msg_head *msg_head, struct msghdr *msg,
 		op->ifindex = ifindex;
 
 		/* initialize uninitialized (kzalloc) structure */
-		hrtimer_init(&op->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+		hrtimer_init(&op->timer, CLOCK_MONOTONIC,
+			     HRTIMER_MODE_REL_SOFT);
 		op->timer.function = bcm_tx_timeout_handler;
 
-		/* initialize tasklet for tx countevent notification */
-		tasklet_init(&op->tsklet, bcm_tx_timeout_tsklet,
-			     (unsigned long) op);
-
 		/* currently unused in tx_ops */
-		hrtimer_init(&op->thrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+		hrtimer_init(&op->thrtimer, CLOCK_MONOTONIC,
+			     HRTIMER_MODE_REL_SOFT);
 
 		/* add this bcm_op to the list of the tx_ops */
 		list_add(&op->list, &bo->tx_ops);
@@ -1175,20 +1129,14 @@ static int bcm_rx_setup(struct bcm_msg_head *msg_head, struct msghdr *msg,
 		op->rx_ifindex = ifindex;
 
 		/* initialize uninitialized (kzalloc) structure */
-		hrtimer_init(&op->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+		hrtimer_init(&op->timer, CLOCK_MONOTONIC,
+			     HRTIMER_MODE_REL_SOFT);
 		op->timer.function = bcm_rx_timeout_handler;
 
-		/* initialize tasklet for rx timeout notification */
-		tasklet_init(&op->tsklet, bcm_rx_timeout_tsklet,
-			     (unsigned long) op);
-
-		hrtimer_init(&op->thrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+		hrtimer_init(&op->thrtimer, CLOCK_MONOTONIC,
+			     HRTIMER_MODE_REL_SOFT);
 		op->thrtimer.function = bcm_rx_thr_handler;
 
-		/* initialize tasklet for rx throttle handling */
-		tasklet_init(&op->thrtsklet, bcm_rx_thr_tsklet,
-			     (unsigned long) op);
-
 		/* add this bcm_op to the list of the rx_ops */
 		list_add(&op->list, &bo->rx_ops);
 
@@ -1234,12 +1182,12 @@ static int bcm_rx_setup(struct bcm_msg_head *msg_head, struct msghdr *msg,
 			 */
 			op->kt_lastmsg = 0;
 			hrtimer_cancel(&op->thrtimer);
-			bcm_rx_thr_flush(op, 1);
+			bcm_rx_thr_flush(op);
 		}
 
 		if ((op->flags & STARTTIMER) && op->kt_ival1)
 			hrtimer_start(&op->timer, op->kt_ival1,
-				      HRTIMER_MODE_REL);
+				      HRTIMER_MODE_REL_SOFT);
 	}
 
 	/* now we can register for can_ids, if we added a new bcm_op */
-- 
2.25.1

