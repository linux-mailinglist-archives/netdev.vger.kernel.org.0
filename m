Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9EEA10AB2A
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 08:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfK0H2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 02:28:24 -0500
Received: from inva020.nxp.com ([92.121.34.13]:33810 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726078AbfK0H2X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 02:28:23 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 860821A0130;
        Wed, 27 Nov 2019 08:28:21 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 559B91A0156;
        Wed, 27 Nov 2019 08:28:18 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 55F73402CF;
        Wed, 27 Nov 2019 15:28:14 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Yangbo Lu <yangbo.lu@nxp.com>
Subject: [v2, 2/2] net: mscc: ocelot: use skb queue instead of skbs list
Date:   Wed, 27 Nov 2019 15:27:57 +0800
Message-Id: <20191127072757.34502-3-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191127072757.34502-1-yangbo.lu@nxp.com>
References: <20191127072757.34502-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert to use skb queue instead of the list of skbs.
The skb queue could provide protection with lock.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v2:
	- Converted to use skb queue.
---
 drivers/net/ethernet/mscc/ocelot.c | 54 +++++++++++++-------------------------
 include/soc/mscc/ocelot.h          |  9 +------
 2 files changed, 19 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 6dc9de3..2cccadc 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -583,18 +583,10 @@ int ocelot_port_add_txtstamp_skb(struct ocelot_port *ocelot_port,
 
 	if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP &&
 	    ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
-		struct ocelot_skb *oskb =
-			kzalloc(sizeof(struct ocelot_skb), GFP_ATOMIC);
-
-		if (unlikely(!oskb))
-			return -ENOMEM;
-
 		shinfo->tx_flags |= SKBTX_IN_PROGRESS;
-
-		oskb->skb = skb;
-		oskb->id = ocelot_port->ts_id % 4;
-
-		list_add_tail(&oskb->head, &ocelot_port->skbs);
+		/* Store timestamp ID in cb[0] of sk_buff */
+		skb->cb[0] = ocelot_port->ts_id % 4;
+		skb_queue_tail(&ocelot_port->tx_skbs, skb);
 		return 0;
 	}
 	return -ENODATA;
@@ -704,12 +696,11 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 	int budget = OCELOT_PTP_QUEUE_SZ;
 
 	while (budget--) {
+		struct sk_buff *skb, *skb_tmp, *skb_match = NULL;
 		struct skb_shared_hwtstamps shhwtstamps;
-		struct list_head *pos, *tmp;
-		struct sk_buff *skb = NULL;
-		struct ocelot_skb *entry;
 		struct ocelot_port *port;
 		struct timespec64 ts;
+		unsigned long flags;
 		u32 val, id, txport;
 
 		val = ocelot_read(ocelot, SYS_PTP_STATUS);
@@ -727,22 +718,22 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 		/* Retrieve its associated skb */
 		port = ocelot->ports[txport];
 
-		list_for_each_safe(pos, tmp, &port->skbs) {
-			entry = list_entry(pos, struct ocelot_skb, head);
-			if (entry->id != id)
-				continue;
+		spin_lock_irqsave(&port->tx_skbs.lock, flags);
 
-			skb = entry->skb;
-
-			list_del(pos);
-			kfree(entry);
+		skb_queue_walk_safe(&port->tx_skbs, skb, skb_tmp) {
+			if (skb->cb[0] != id)
+				continue;
+			__skb_unlink(skb, &port->tx_skbs);
+			skb_match = skb;
 			break;
 		}
 
+		spin_unlock_irqrestore(&port->tx_skbs.lock, flags);
+
 		/* Next ts */
 		ocelot_write(ocelot, SYS_PTP_NXT_PTP_NXT, SYS_PTP_NXT);
 
-		if (unlikely(!skb))
+		if (unlikely(!skb_match))
 			continue;
 
 		/* Get the h/w timestamp */
@@ -751,9 +742,9 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 		/* Set the timestamp into the skb */
 		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
 		shhwtstamps.hwtstamp = ktime_set(ts.tv_sec, ts.tv_nsec);
-		skb_tstamp_tx(skb, &shhwtstamps);
+		skb_tstamp_tx(skb_match, &shhwtstamps);
 
-		dev_kfree_skb_any(skb);
+		dev_kfree_skb_any(skb_match);
 	}
 }
 EXPORT_SYMBOL(ocelot_get_txtstamp);
@@ -2206,7 +2197,7 @@ void ocelot_init_port(struct ocelot *ocelot, int port)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
-	INIT_LIST_HEAD(&ocelot_port->skbs);
+	skb_queue_head_init(&ocelot_port->tx_skbs);
 
 	/* Basic L2 initialization */
 
@@ -2491,9 +2482,7 @@ EXPORT_SYMBOL(ocelot_init);
 
 void ocelot_deinit(struct ocelot *ocelot)
 {
-	struct list_head *pos, *tmp;
 	struct ocelot_port *port;
-	struct ocelot_skb *entry;
 	int i;
 
 	cancel_delayed_work(&ocelot->stats_work);
@@ -2503,14 +2492,7 @@ void ocelot_deinit(struct ocelot *ocelot)
 
 	for (i = 0; i < ocelot->num_phys_ports; i++) {
 		port = ocelot->ports[i];
-
-		list_for_each_safe(pos, tmp, &port->skbs) {
-			entry = list_entry(pos, struct ocelot_skb, head);
-
-			list_del(pos);
-			dev_kfree_skb_any(entry->skb);
-			kfree(entry);
-		}
+		skb_queue_purge(&port->tx_skbs);
 	}
 }
 EXPORT_SYMBOL(ocelot_deinit);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index e1108a5..64cbbbe 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -406,13 +406,6 @@ struct ocelot_ops {
 	int (*reset)(struct ocelot *ocelot);
 };
 
-struct ocelot_skb {
-	struct list_head head;
-	struct sk_buff *skb;
-	u8 id;
-};
-
-
 struct ocelot_port {
 	struct ocelot			*ocelot;
 
@@ -425,7 +418,7 @@ struct ocelot_port {
 	u16				vid;
 
 	u8				ptp_cmd;
-	struct list_head		skbs;
+	struct sk_buff_head		tx_skbs;
 	u8				ts_id;
 };
 
-- 
2.7.4

