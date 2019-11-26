Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0B6109C78
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 11:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbfKZKo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 05:44:28 -0500
Received: from inva021.nxp.com ([92.121.34.21]:42962 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727603AbfKZKo2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Nov 2019 05:44:28 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 5BC2E2002CC;
        Tue, 26 Nov 2019 11:44:25 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 9385620013E;
        Tue, 26 Nov 2019 11:44:22 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 11B18402EE;
        Tue, 26 Nov 2019 18:44:18 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Yangbo Lu <yangbo.lu@nxp.com>
Subject: [PATCH] net: mscc: ocelot: fix potential issues accessing skbs list
Date:   Tue, 26 Nov 2019 18:44:03 +0800
Message-Id: <20191126104403.46717-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix two prtential issues accessing skbs list.
- Protect skbs list in case of competing for accessing.
- Break the matching loop when find the matching skb to
  avoid consuming more skbs incorrectly. The ID is only
  from 0 to 3, but the FIFO supports 128 timestamps at most.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 11 +++++++++++
 include/soc/mscc/ocelot.h          |  2 ++
 2 files changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 0e96ffa..5d842d8 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -580,6 +580,7 @@ int ocelot_port_add_txtstamp_skb(struct ocelot_port *ocelot_port,
 {
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
 	struct ocelot *ocelot = ocelot_port->ocelot;
+	unsigned long flags;
 
 	if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP &&
 	    ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
@@ -594,7 +595,9 @@ int ocelot_port_add_txtstamp_skb(struct ocelot_port *ocelot_port,
 		oskb->skb = skb;
 		oskb->id = ocelot_port->ts_id % 4;
 
+		spin_lock_irqsave(&ocelot_port->skbs_lock, flags);
 		list_add_tail(&oskb->head, &ocelot_port->skbs);
+		spin_unlock_irqrestore(&ocelot_port->skbs_lock, flags);
 		return 0;
 	}
 	return -ENODATA;
@@ -702,6 +705,7 @@ static void ocelot_get_hwtimestamp(struct ocelot *ocelot,
 void ocelot_get_txtstamp(struct ocelot *ocelot)
 {
 	int budget = OCELOT_PTP_QUEUE_SZ;
+	unsigned long flags;
 
 	while (budget--) {
 		struct skb_shared_hwtstamps shhwtstamps;
@@ -727,6 +731,7 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 		/* Retrieve its associated skb */
 		port = ocelot->ports[txport];
 
+		spin_lock_irqsave(&port->skbs_lock, flags);
 		list_for_each_safe(pos, tmp, &port->skbs) {
 			entry = list_entry(pos, struct ocelot_skb, head);
 			if (entry->id != id)
@@ -736,7 +741,9 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 
 			list_del(pos);
 			kfree(entry);
+			break;
 		}
+		spin_unlock_irqrestore(&port->skbs_lock, flags);
 
 		/* Next ts */
 		ocelot_write(ocelot, SYS_PTP_NXT_PTP_NXT, SYS_PTP_NXT);
@@ -2205,6 +2212,7 @@ void ocelot_init_port(struct ocelot *ocelot, int port)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
+	spin_lock_init(&ocelot_port->skbs_lock);
 	INIT_LIST_HEAD(&ocelot_port->skbs);
 
 	/* Basic L2 initialization */
@@ -2493,6 +2501,7 @@ void ocelot_deinit(struct ocelot *ocelot)
 	struct list_head *pos, *tmp;
 	struct ocelot_port *port;
 	struct ocelot_skb *entry;
+	unsigned long flags;
 	int i;
 
 	cancel_delayed_work(&ocelot->stats_work);
@@ -2503,6 +2512,7 @@ void ocelot_deinit(struct ocelot *ocelot)
 	for (i = 0; i < ocelot->num_phys_ports; i++) {
 		port = ocelot->ports[i];
 
+		spin_lock_irqsave(&port->skbs_lock, flags);
 		list_for_each_safe(pos, tmp, &port->skbs) {
 			entry = list_entry(pos, struct ocelot_skb, head);
 
@@ -2510,6 +2520,7 @@ void ocelot_deinit(struct ocelot *ocelot)
 			dev_kfree_skb_any(entry->skb);
 			kfree(entry);
 		}
+		spin_unlock_irqrestore(&port->skbs_lock, flags);
 	}
 }
 EXPORT_SYMBOL(ocelot_deinit);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index e1108a5..7973458 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -426,6 +426,8 @@ struct ocelot_port {
 
 	u8				ptp_cmd;
 	struct list_head		skbs;
+	/* Protects the skbs list */
+	spinlock_t			skbs_lock;
 	u8				ts_id;
 };
 
-- 
2.7.4

