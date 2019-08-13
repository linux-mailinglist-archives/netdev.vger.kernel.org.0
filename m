Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD558B1EC
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 10:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbfHMIAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 04:00:32 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:33171 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727263AbfHMIAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 04:00:32 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1hxRjF-0007Bi-Cp; Tue, 13 Aug 2019 10:00:25 +0200
Date:   Tue, 13 Aug 2019 10:00:25 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: [PATCH net-next] net/mvpp2: Replace tasklet with softirq hrtimer
Message-ID: <20190813080025.2j3cj6gfyzzxek7x@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The tx_done_tasklet tasklet is used in invoke the hrtimer
(mvpp2_hr_timer_cb) in softirq context. This can be also achieved without
the tasklet but with HRTIMER_MODE_SOFT as hrtimer mode.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  3 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 58 +++++++------------
 2 files changed, 23 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 4d9564ba68f69..ee3bab508ee8c 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -829,9 +829,8 @@ struct mvpp2_pcpu_stats {
 /* Per-CPU port control */
 struct mvpp2_port_pcpu {
 	struct hrtimer tx_done_timer;
+	struct net_device *dev;
 	bool timer_scheduled;
-	/* Tasklet for egress finalization */
-	struct tasklet_struct tx_done_tasklet;
 };
 
 struct mvpp2_queue_vector {
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 74fd9e1718654..12e799e99803c 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -2651,31 +2651,21 @@ static irqreturn_t mvpp2_link_status_isr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static void mvpp2_timer_set(struct mvpp2_port_pcpu *port_pcpu)
-{
-	ktime_t interval;
-
-	if (!port_pcpu->timer_scheduled) {
-		port_pcpu->timer_scheduled = true;
-		interval = MVPP2_TXDONE_HRTIMER_PERIOD_NS;
-		hrtimer_start(&port_pcpu->tx_done_timer, interval,
-			      HRTIMER_MODE_REL_PINNED);
-	}
-}
-
-static void mvpp2_tx_proc_cb(unsigned long data)
+static enum hrtimer_restart mvpp2_hr_timer_cb(struct hrtimer *timer)
 {
-	struct net_device *dev = (struct net_device *)data;
-	struct mvpp2_port *port = netdev_priv(dev);
+	struct net_device *dev;
+	struct mvpp2_port *port;
 	struct mvpp2_port_pcpu *port_pcpu;
 	unsigned int tx_todo, cause;
 
-	port_pcpu = per_cpu_ptr(port->pcpu,
-				mvpp2_cpu_to_thread(port->priv, smp_processor_id()));
+	port_pcpu = container_of(timer, struct mvpp2_port_pcpu, tx_done_timer);
+	dev = port_pcpu->dev;
 
 	if (!netif_running(dev))
-		return;
+		return HRTIMER_NORESTART;
+
 	port_pcpu->timer_scheduled = false;
+	port = netdev_priv(dev);
 
 	/* Process all the Tx queues */
 	cause = (1 << port->ntxqs) - 1;
@@ -2683,18 +2673,13 @@ static void mvpp2_tx_proc_cb(unsigned long data)
 				mvpp2_cpu_to_thread(port->priv, smp_processor_id()));
 
 	/* Set the timer in case not all the packets were processed */
-	if (tx_todo)
-		mvpp2_timer_set(port_pcpu);
-}
-
-static enum hrtimer_restart mvpp2_hr_timer_cb(struct hrtimer *timer)
-{
-	struct mvpp2_port_pcpu *port_pcpu = container_of(timer,
-							 struct mvpp2_port_pcpu,
-							 tx_done_timer);
-
-	tasklet_schedule(&port_pcpu->tx_done_tasklet);
+	if (tx_todo && !port_pcpu->timer_scheduled) {
+		port_pcpu->timer_scheduled = true;
+		hrtimer_forward_now(&port_pcpu->tx_done_timer,
+				    MVPP2_TXDONE_HRTIMER_PERIOD_NS);
 
+		return HRTIMER_RESTART;
+	}
 	return HRTIMER_NORESTART;
 }
 
@@ -3182,7 +3167,12 @@ static netdev_tx_t mvpp2_tx(struct sk_buff *skb, struct net_device *dev)
 	    txq_pcpu->count > 0) {
 		struct mvpp2_port_pcpu *port_pcpu = per_cpu_ptr(port->pcpu, thread);
 
-		mvpp2_timer_set(port_pcpu);
+		if (!port_pcpu->timer_scheduled) {
+			port_pcpu->timer_scheduled = true;
+			hrtimer_start(&port_pcpu->tx_done_timer,
+				      MVPP2_TXDONE_HRTIMER_PERIOD_NS,
+				      HRTIMER_MODE_REL_PINNED_SOFT);
+		}
 	}
 
 	if (test_bit(thread, &port->priv->lock_map))
@@ -3619,7 +3609,6 @@ static int mvpp2_stop(struct net_device *dev)
 
 			hrtimer_cancel(&port_pcpu->tx_done_timer);
 			port_pcpu->timer_scheduled = false;
-			tasklet_kill(&port_pcpu->tx_done_tasklet);
 		}
 	}
 	mvpp2_cleanup_rxqs(port);
@@ -5183,13 +5172,10 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 			port_pcpu = per_cpu_ptr(port->pcpu, thread);
 
 			hrtimer_init(&port_pcpu->tx_done_timer, CLOCK_MONOTONIC,
-				     HRTIMER_MODE_REL_PINNED);
+				     HRTIMER_MODE_REL_PINNED_SOFT);
 			port_pcpu->tx_done_timer.function = mvpp2_hr_timer_cb;
 			port_pcpu->timer_scheduled = false;
-
-			tasklet_init(&port_pcpu->tx_done_tasklet,
-				     mvpp2_tx_proc_cb,
-				     (unsigned long)dev);
+			port_pcpu->dev = dev;
 		}
 	}
 
-- 
2.23.0.rc1

