Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20CED1035F0
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 09:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbfKTIXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 03:23:45 -0500
Received: from inva021.nxp.com ([92.121.34.21]:52260 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727626AbfKTIXo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 03:23:44 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C4F8D20046F;
        Wed, 20 Nov 2019 09:23:41 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id CA3E92000B0;
        Wed, 20 Nov 2019 09:23:36 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 6F180402AD;
        Wed, 20 Nov 2019 16:23:30 +0800 (SGT)
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
Subject: [PATCH 3/5] net: mscc: ocelot: convert to use ocelot_port_add_txtstamp_skb()
Date:   Wed, 20 Nov 2019 16:23:16 +0800
Message-Id: <20191120082318.3909-4-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191120082318.3909-1-yangbo.lu@nxp.com>
References: <20191120082318.3909-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert to use ocelot_port_add_txtstamp_skb() for adding skbs which
require TX timestamp into list. Export it so that DSA Felix driver
could reuse it too.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 43 ++++++++++++++++++++++++--------------
 include/soc/mscc/ocelot.h          |  2 ++
 2 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index a58d2ed..0e96ffa 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -575,6 +575,32 @@ static int ocelot_gen_ifh(u32 *ifh, struct frame_info *info)
 	return 0;
 }
 
+int ocelot_port_add_txtstamp_skb(struct ocelot_port *ocelot_port,
+				 struct sk_buff *skb)
+{
+	struct skb_shared_info *shinfo = skb_shinfo(skb);
+	struct ocelot *ocelot = ocelot_port->ocelot;
+
+	if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP &&
+	    ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
+		struct ocelot_skb *oskb =
+			kzalloc(sizeof(struct ocelot_skb), GFP_ATOMIC);
+
+		if (unlikely(!oskb))
+			return -ENOMEM;
+
+		shinfo->tx_flags |= SKBTX_IN_PROGRESS;
+
+		oskb->skb = skb;
+		oskb->id = ocelot_port->ts_id % 4;
+
+		list_add_tail(&oskb->head, &ocelot_port->skbs);
+		return 0;
+	}
+	return -ENODATA;
+}
+EXPORT_SYMBOL(ocelot_port_add_txtstamp_skb);
+
 static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
@@ -637,26 +663,11 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 	dev->stats.tx_packets++;
 	dev->stats.tx_bytes += skb->len;
 
-	if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP &&
-	    ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
-		struct ocelot_skb *oskb =
-			kzalloc(sizeof(struct ocelot_skb), GFP_ATOMIC);
-
-		if (unlikely(!oskb))
-			goto out;
-
-		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
-
-		oskb->skb = skb;
-		oskb->id = ocelot_port->ts_id % 4;
+	if (!ocelot_port_add_txtstamp_skb(ocelot_port, skb)) {
 		ocelot_port->ts_id++;
-
-		list_add_tail(&oskb->head, &ocelot_port->skbs);
-
 		return NETDEV_TX_OK;
 	}
 
-out:
 	dev_kfree_skb_any(skb);
 	return NETDEV_TX_OK;
 }
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 1a5cb1b..e1108a5 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -543,6 +543,8 @@ int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid);
 int ocelot_hwstamp_get(struct ocelot *ocelot, int port, struct ifreq *ifr);
 int ocelot_hwstamp_set(struct ocelot *ocelot, int port, struct ifreq *ifr);
 int ocelot_ptp_gettime64(struct ptp_clock_info *ptp, struct timespec64 *ts);
+int ocelot_port_add_txtstamp_skb(struct ocelot_port *ocelot_port,
+				 struct sk_buff *skb);
 void ocelot_get_txtstamp(struct ocelot *ocelot);
 
 #endif
-- 
2.7.4

