Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF751035EF
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 09:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbfKTIXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 03:23:43 -0500
Received: from inva021.nxp.com ([92.121.34.21]:52236 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727733AbfKTIXm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 03:23:42 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 816AC2004C7;
        Wed, 20 Nov 2019 09:23:40 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 5144D20046F;
        Wed, 20 Nov 2019 09:23:35 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 6033F40286;
        Wed, 20 Nov 2019 16:23:29 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Yangbo Lu <yangbo.lu@nxp.com>
Subject: [PATCH 2/5] net: mscc: ocelot: convert to use ocelot_get_txtstamp()
Date:   Wed, 20 Nov 2019 16:23:15 +0800
Message-Id: <20191120082318.3909-3-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191120082318.3909-1-yangbo.lu@nxp.com>
References: <20191120082318.3909-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The method getting TX timestamp by reading timestamp FIFO and
matching skbs list is common for DSA Felix driver too.
So move code out of ocelot_board.c, convert to use
ocelot_get_txtstamp() function and export it.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c       | 62 ++++++++++++++++++++++++++++++--
 drivers/net/ethernet/mscc/ocelot.h       |  6 ----
 drivers/net/ethernet/mscc/ocelot_board.c | 53 +--------------------------
 include/soc/mscc/ocelot.h                |  9 ++++-
 4 files changed, 69 insertions(+), 61 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 7302724..a58d2ed 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -661,7 +661,8 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
-void ocelot_get_hwtimestamp(struct ocelot *ocelot, struct timespec64 *ts)
+static void ocelot_get_hwtimestamp(struct ocelot *ocelot,
+				   struct timespec64 *ts)
 {
 	unsigned long flags;
 	u32 val;
@@ -686,7 +687,64 @@ void ocelot_get_hwtimestamp(struct ocelot *ocelot, struct timespec64 *ts)
 
 	spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
 }
-EXPORT_SYMBOL(ocelot_get_hwtimestamp);
+
+void ocelot_get_txtstamp(struct ocelot *ocelot)
+{
+	int budget = OCELOT_PTP_QUEUE_SZ;
+
+	while (budget--) {
+		struct skb_shared_hwtstamps shhwtstamps;
+		struct list_head *pos, *tmp;
+		struct sk_buff *skb = NULL;
+		struct ocelot_skb *entry;
+		struct ocelot_port *port;
+		struct timespec64 ts;
+		u32 val, id, txport;
+
+		val = ocelot_read(ocelot, SYS_PTP_STATUS);
+
+		/* Check if a timestamp can be retrieved */
+		if (!(val & SYS_PTP_STATUS_PTP_MESS_VLD))
+			break;
+
+		WARN_ON(val & SYS_PTP_STATUS_PTP_OVFL);
+
+		/* Retrieve the ts ID and Tx port */
+		id = SYS_PTP_STATUS_PTP_MESS_ID_X(val);
+		txport = SYS_PTP_STATUS_PTP_MESS_TXPORT_X(val);
+
+		/* Retrieve its associated skb */
+		port = ocelot->ports[txport];
+
+		list_for_each_safe(pos, tmp, &port->skbs) {
+			entry = list_entry(pos, struct ocelot_skb, head);
+			if (entry->id != id)
+				continue;
+
+			skb = entry->skb;
+
+			list_del(pos);
+			kfree(entry);
+		}
+
+		/* Next ts */
+		ocelot_write(ocelot, SYS_PTP_NXT_PTP_NXT, SYS_PTP_NXT);
+
+		if (unlikely(!skb))
+			continue;
+
+		/* Get the h/w timestamp */
+		ocelot_get_hwtimestamp(ocelot, &ts);
+
+		/* Set the timestamp into the skb */
+		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
+		shhwtstamps.hwtstamp = ktime_set(ts.tv_sec, ts.tv_nsec);
+		skb_tstamp_tx(skb, &shhwtstamps);
+
+		dev_kfree_skb_any(skb);
+	}
+}
+EXPORT_SYMBOL(ocelot_get_txtstamp);
 
 static int ocelot_mc_unsync(struct net_device *dev, const unsigned char *addr)
 {
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 32fef4f..c259114 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -74,12 +74,6 @@ struct ocelot_port_private {
 	struct ocelot_port_tc tc;
 };
 
-struct ocelot_skb {
-	struct list_head head;
-	struct sk_buff *skb;
-	u8 id;
-};
-
 u32 ocelot_port_readl(struct ocelot_port *port, u32 reg);
 void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
 
diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index 5541ec2..2da8eee 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -190,60 +190,9 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 
 static irqreturn_t ocelot_ptp_rdy_irq_handler(int irq, void *arg)
 {
-	int budget = OCELOT_PTP_QUEUE_SZ;
 	struct ocelot *ocelot = arg;
 
-	while (budget--) {
-		struct skb_shared_hwtstamps shhwtstamps;
-		struct list_head *pos, *tmp;
-		struct sk_buff *skb = NULL;
-		struct ocelot_skb *entry;
-		struct ocelot_port *port;
-		struct timespec64 ts;
-		u32 val, id, txport;
-
-		val = ocelot_read(ocelot, SYS_PTP_STATUS);
-
-		/* Check if a timestamp can be retrieved */
-		if (!(val & SYS_PTP_STATUS_PTP_MESS_VLD))
-			break;
-
-		WARN_ON(val & SYS_PTP_STATUS_PTP_OVFL);
-
-		/* Retrieve the ts ID and Tx port */
-		id = SYS_PTP_STATUS_PTP_MESS_ID_X(val);
-		txport = SYS_PTP_STATUS_PTP_MESS_TXPORT_X(val);
-
-		/* Retrieve its associated skb */
-		port = ocelot->ports[txport];
-
-		list_for_each_safe(pos, tmp, &port->skbs) {
-			entry = list_entry(pos, struct ocelot_skb, head);
-			if (entry->id != id)
-				continue;
-
-			skb = entry->skb;
-
-			list_del(pos);
-			kfree(entry);
-		}
-
-		/* Next ts */
-		ocelot_write(ocelot, SYS_PTP_NXT_PTP_NXT, SYS_PTP_NXT);
-
-		if (unlikely(!skb))
-			continue;
-
-		/* Get the h/w timestamp */
-		ocelot_get_hwtimestamp(ocelot, &ts);
-
-		/* Set the timestamp into the skb */
-		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
-		shhwtstamps.hwtstamp = ktime_set(ts.tv_sec, ts.tv_nsec);
-		skb_tstamp_tx(skb, &shhwtstamps);
-
-		dev_kfree_skb_any(skb);
-	}
+	ocelot_get_txtstamp(ocelot);
 
 	return IRQ_HANDLED;
 }
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 2bac4bc..1a5cb1b 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -406,6 +406,13 @@ struct ocelot_ops {
 	int (*reset)(struct ocelot *ocelot);
 };
 
+struct ocelot_skb {
+	struct list_head head;
+	struct sk_buff *skb;
+	u8 id;
+};
+
+
 struct ocelot_port {
 	struct ocelot			*ocelot;
 
@@ -536,6 +543,6 @@ int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid);
 int ocelot_hwstamp_get(struct ocelot *ocelot, int port, struct ifreq *ifr);
 int ocelot_hwstamp_set(struct ocelot *ocelot, int port, struct ifreq *ifr);
 int ocelot_ptp_gettime64(struct ptp_clock_info *ptp, struct timespec64 *ts);
-void ocelot_get_hwtimestamp(struct ocelot *ocelot, struct timespec64 *ts);
+void ocelot_get_txtstamp(struct ocelot *ocelot);
 
 #endif
-- 
2.7.4

