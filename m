Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE82D2BAC73
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 16:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbgKTPCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 10:02:15 -0500
Received: from smtp2.axis.com ([195.60.68.18]:54938 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728230AbgKTPCP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 10:02:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=axis.com; l=5069; q=dns/txt; s=axis-central1;
  t=1605884534; x=1637420534;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rjqMVu2KUMS1Pxw2CKwe4RqIVEAuisLy8K6GdODxf5g=;
  b=JFHcnmfqTvGXUqhUURSNEahDBj66yQO3V/ZvT2vfGHLiVTUejZBBK4JD
   S61L2NB8aZXJVxm+Cf9gtT5uHsOCqGtdxftcuUjI348a6Cm1qkhAvX3i1
   Jzt7v9ldjbcrMefhauNejq9k6otxK6sWPKO9Jwqx5LPqDiLZ4ePkstE5/
   cdStgdbU0J2wP6JM2yjUEjXtM/PZOvhNmzNOMdKH9PpeIGYRlQhdSJOKC
   EgHVtAqjD4Yti53lGSBt/lvEo7rrkIcAZwMGVsve+YaMbBVGKOaHosMyc
   52h7evOJeOmb74K+6Dt3uOO7xDvMD2ozFqcnlUOE0VQhfmrVOHW4MWd86
   g==;
IronPort-SDR: ijdgRJOxCjyKCp40loxAl70BcLcFwIXboLaR+lKYgPVf6kv2ZgJ+I4nTgPWmlyV9DqvWnfVswk
 Mg06uSO1Az3tN+JNrrMDcuoev8LgaaLHXq7Vuf7mc19iJBuDGQLfzVN97nc5oJgY3dLxDUFCnJ
 UymSW9UJxmtPVsFL2dalDVXmPvPI5o8HXAMmqRo73+ynYg0lhOwyuzFkBh0bxXvfK0UoP2uG5P
 zNyoMnQlKY/AkCkHTWlE3ERFVFip9w90tIl7mdKH4tVqm9xCNf6db8BbTkaU0L+YRP7ECVdfes
 Cbs=
X-IronPort-AV: E=Sophos;i="5.78,356,1599516000"; 
   d="scan'208";a="14738095"
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <kernel@axis.com>, <netdev@vger.kernel.org>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: [PATCH net] net: stmmac: Use hrtimer for TX coalescing
Date:   Fri, 20 Nov 2020 16:02:08 +0100
Message-ID: <20201120150208.6838-1-vincent.whitchurch@axis.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver uses a normal timer for TX coalescing, which means that the
with the default tx-usecs of 1000 microseconds the cleanups actually
happen 10 ms or more later with HZ=100.  This leads to very low
througput with TCP when bridged to a slow link such as a 4G modem.  Fix
this by using an hrtimer instead.

On my ARM platform with HZ=100 and the default TX coalescing settings
(tx-frames 25 tx-usecs 1000), with "tc qdisc add dev eth0 root netem
delay 60ms 40ms rate 50Mbit" run on the server, netperf's TCP_STREAM
improves from ~5.5 Mbps to ~100 Mbps.

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  3 ++-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 23 +++++++++++--------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 727e68dfaf1c..04b7162211cb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -13,6 +13,7 @@
 #define DRV_MODULE_VERSION	"Jan_2016"
 
 #include <linux/clk.h>
+#include <linux/hrtimer.h>
 #include <linux/if_vlan.h>
 #include <linux/stmmac.h>
 #include <linux/phylink.h>
@@ -46,7 +47,7 @@ struct stmmac_tx_info {
 struct stmmac_tx_queue {
 	u32 tx_count_frames;
 	int tbs;
-	struct timer_list txtimer;
+	struct hrtimer txtimer;
 	u32 queue_index;
 	struct stmmac_priv *priv_data;
 	struct dma_extended_desc *dma_etx ____cacheline_aligned_in_smp;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index ba45fe237512..eea740c06f52 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -111,7 +111,7 @@ static void stmmac_init_fs(struct net_device *dev);
 static void stmmac_exit_fs(struct net_device *dev);
 #endif
 
-#define STMMAC_COAL_TIMER(x) (jiffies + usecs_to_jiffies(x))
+#define STMMAC_COAL_TIMER(x) (ns_to_ktime((x) * NSEC_PER_USEC))
 
 /**
  * stmmac_verify_args - verify the driver parameters.
@@ -2051,7 +2051,8 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
 
 	/* We still have pending packets, let's call for a new scheduling */
 	if (tx_q->dirty_tx != tx_q->cur_tx)
-		mod_timer(&tx_q->txtimer, STMMAC_COAL_TIMER(priv->tx_coal_timer));
+		hrtimer_start(&tx_q->txtimer, STMMAC_COAL_TIMER(priv->tx_coal_timer),
+			      HRTIMER_MODE_REL);
 
 	__netif_tx_unlock_bh(netdev_get_tx_queue(priv->dev, queue));
 
@@ -2335,7 +2336,8 @@ static void stmmac_tx_timer_arm(struct stmmac_priv *priv, u32 queue)
 {
 	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
 
-	mod_timer(&tx_q->txtimer, STMMAC_COAL_TIMER(priv->tx_coal_timer));
+	hrtimer_start(&tx_q->txtimer, STMMAC_COAL_TIMER(priv->tx_coal_timer),
+		      HRTIMER_MODE_REL);
 }
 
 /**
@@ -2344,9 +2346,9 @@ static void stmmac_tx_timer_arm(struct stmmac_priv *priv, u32 queue)
  * Description:
  * This is the timer handler to directly invoke the stmmac_tx_clean.
  */
-static void stmmac_tx_timer(struct timer_list *t)
+static enum hrtimer_restart stmmac_tx_timer(struct hrtimer *t)
 {
-	struct stmmac_tx_queue *tx_q = from_timer(tx_q, t, txtimer);
+	struct stmmac_tx_queue *tx_q = container_of(t, struct stmmac_tx_queue, txtimer);
 	struct stmmac_priv *priv = tx_q->priv_data;
 	struct stmmac_channel *ch;
 
@@ -2360,6 +2362,8 @@ static void stmmac_tx_timer(struct timer_list *t)
 		spin_unlock_irqrestore(&ch->lock, flags);
 		__napi_schedule(&ch->tx_napi);
 	}
+
+	return HRTIMER_NORESTART;
 }
 
 /**
@@ -2382,7 +2386,8 @@ static void stmmac_init_coalesce(struct stmmac_priv *priv)
 	for (chan = 0; chan < tx_channel_count; chan++) {
 		struct stmmac_tx_queue *tx_q = &priv->tx_queue[chan];
 
-		timer_setup(&tx_q->txtimer, stmmac_tx_timer, 0);
+		hrtimer_init(&tx_q->txtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+		tx_q->txtimer.function = stmmac_tx_timer;
 	}
 }
 
@@ -2874,7 +2879,7 @@ static int stmmac_open(struct net_device *dev)
 	phylink_stop(priv->phylink);
 
 	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
-		del_timer_sync(&priv->tx_queue[chan].txtimer);
+		hrtimer_cancel(&priv->tx_queue[chan].txtimer);
 
 	stmmac_hw_teardown(dev);
 init_error:
@@ -2907,7 +2912,7 @@ static int stmmac_release(struct net_device *dev)
 	stmmac_disable_all_queues(priv);
 
 	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
-		del_timer_sync(&priv->tx_queue[chan].txtimer);
+		hrtimer_cancel(&priv->tx_queue[chan].txtimer);
 
 	/* Free the IRQ lines */
 	free_irq(dev->irq, dev);
@@ -5140,7 +5145,7 @@ int stmmac_suspend(struct device *dev)
 	stmmac_disable_all_queues(priv);
 
 	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
-		del_timer_sync(&priv->tx_queue[chan].txtimer);
+		hrtimer_cancel(&priv->tx_queue[chan].txtimer);
 
 	/* Stop TX/RX DMA */
 	stmmac_stop_all_dma(priv);
-- 
2.28.0

