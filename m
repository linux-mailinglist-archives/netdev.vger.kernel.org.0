Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E260536BE2C
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 06:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234640AbhD0EMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 00:12:35 -0400
Received: from inva021.nxp.com ([92.121.34.21]:45226 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233009AbhD0EMa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 00:12:30 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 52D9E201881;
        Tue, 27 Apr 2021 06:11:46 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 115B12001E2;
        Tue, 27 Apr 2021 06:11:40 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 3CA4940302;
        Tue, 27 Apr 2021 06:11:32 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [net-next, v3, 4/7] net: dsa: free skb->cb usage in core driver
Date:   Tue, 27 Apr 2021 12:22:00 +0800
Message-Id: <20210427042203.26258-5-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210427042203.26258-1-yangbo.lu@nxp.com>
References: <20210427042203.26258-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Free skb->cb usage in core driver and let device drivers decide to
use or not. The reason having a DSA_SKB_CB(skb)->clone was because
dsa_skb_tx_timestamp() which may set the clone pointer was called
before p->xmit() which would use the clone if any, and the device
driver has no way to initialize the clone pointer.

This patch just put memset(skb->cb, 0, sizeof(skb->cb)) at beginning
of dsa_slave_xmit(). Some new features in the future, like one-step
timestamp may need more bytes of skb->cb to use in
dsa_skb_tx_timestamp(), and p->xmit().

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
Changes for v2:
	- Added this patch.
Changes for v3:
	- Switched sequence of patch #3 and #4 with rebasing to fix build.
	- Replaced hard coded 48 of memset(skb->cb, 0, 48) with sizeof().
---
 drivers/net/dsa/ocelot/felix.c         |  2 +-
 drivers/net/dsa/sja1105/sja1105_main.c |  2 +-
 drivers/net/dsa/sja1105/sja1105_ptp.c  |  4 ++--
 drivers/net/ethernet/mscc/ocelot.c     |  6 +++---
 drivers/net/ethernet/mscc/ocelot_net.c |  2 +-
 include/linux/dsa/sja1105.h            |  3 ++-
 include/net/dsa.h                      | 14 --------------
 include/soc/mscc/ocelot.h              |  8 ++++++++
 net/dsa/slave.c                        |  2 +-
 net/dsa/tag_ocelot.c                   |  8 ++++----
 net/dsa/tag_ocelot_8021q.c             |  8 ++++----
 11 files changed, 27 insertions(+), 32 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index fe7e8bad90df..b28280b6e91a 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1408,7 +1408,7 @@ static void felix_txtstamp(struct dsa_switch *ds, int port,
 			return;
 
 		ocelot_port_add_txtstamp_skb(ocelot, port, clone);
-		DSA_SKB_CB(skb)->clone = clone;
+		OCELOT_SKB_CB(skb)->clone = clone;
 	}
 }
 
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index d9c198ca0197..405024b637d6 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -3137,7 +3137,7 @@ static void sja1105_port_deferred_xmit(struct kthread_work *work)
 	struct sk_buff *skb;
 
 	while ((skb = skb_dequeue(&sp->xmit_queue)) != NULL) {
-		struct sk_buff *clone = DSA_SKB_CB(skb)->clone;
+		struct sk_buff *clone = SJA1105_SKB_CB(skb)->clone;
 
 		mutex_lock(&priv->mgmt_lock);
 
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index a5140084000d..0bc566b9e958 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -432,7 +432,7 @@ bool sja1105_port_rxtstamp(struct dsa_switch *ds, int port,
 }
 
 /* Called from dsa_skb_tx_timestamp. This callback is just to clone
- * the skb and have it available in DSA_SKB_CB in the .port_deferred_xmit
+ * the skb and have it available in SJA1105_SKB_CB in the .port_deferred_xmit
  * callback, where we will timestamp it synchronously.
  */
 void sja1105_port_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
@@ -448,7 +448,7 @@ void sja1105_port_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
 	if (!clone)
 		return;
 
-	DSA_SKB_CB(skb)->clone = clone;
+	SJA1105_SKB_CB(skb)->clone = clone;
 }
 
 static int sja1105_ptp_reset(struct dsa_switch *ds)
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 8d06ffaf318a..7da2dd1632b1 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -538,8 +538,8 @@ void ocelot_port_add_txtstamp_skb(struct ocelot *ocelot, int port,
 	spin_lock(&ocelot_port->ts_id_lock);
 
 	skb_shinfo(clone)->tx_flags |= SKBTX_IN_PROGRESS;
-	/* Store timestamp ID in cb[0] of sk_buff */
-	clone->cb[0] = ocelot_port->ts_id;
+	/* Store timestamp ID in OCELOT_SKB_CB(clone)->ts_id */
+	OCELOT_SKB_CB(clone)->ts_id = ocelot_port->ts_id;
 	ocelot_port->ts_id = (ocelot_port->ts_id + 1) % 4;
 	skb_queue_tail(&ocelot_port->tx_skbs, clone);
 
@@ -604,7 +604,7 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 		spin_lock_irqsave(&port->tx_skbs.lock, flags);
 
 		skb_queue_walk_safe(&port->tx_skbs, skb, skb_tmp) {
-			if (skb->cb[0] != id)
+			if (OCELOT_SKB_CB(skb)->ts_id != id)
 				continue;
 			__skb_unlink(skb, &port->tx_skbs);
 			skb_match = skb;
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 36f32a4d9b0f..789a5fba146c 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -520,7 +520,7 @@ static netdev_tx_t ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 
 			ocelot_port_add_txtstamp_skb(ocelot, port, clone);
 
-			rew_op |= clone->cb[0] << 3;
+			rew_op |= OCELOT_SKB_CB(clone)->ts_id << 3;
 		}
 	}
 
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index dd93735ae228..1eb84562b311 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -47,11 +47,12 @@ struct sja1105_tagger_data {
 };
 
 struct sja1105_skb_cb {
+	struct sk_buff *clone;
 	u32 meta_tstamp;
 };
 
 #define SJA1105_SKB_CB(skb) \
-	((struct sja1105_skb_cb *)DSA_SKB_CB_PRIV(skb))
+	((struct sja1105_skb_cb *)((skb)->cb))
 
 struct sja1105_port {
 	u16 subvlan_map[DSA_8021Q_N_SUBVLAN];
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 73ce6ce38aa1..e1a2610a0e06 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -117,20 +117,6 @@ struct dsa_netdevice_ops {
 #define MODULE_ALIAS_DSA_TAG_DRIVER(__proto)				\
 	MODULE_ALIAS(DSA_TAG_DRIVER_ALIAS __stringify(__proto##_VALUE))
 
-struct dsa_skb_cb {
-	struct sk_buff *clone;
-};
-
-struct __dsa_skb_cb {
-	struct dsa_skb_cb cb;
-	u8 priv[48 - sizeof(struct dsa_skb_cb)];
-};
-
-#define DSA_SKB_CB(skb) ((struct dsa_skb_cb *)((skb)->cb))
-
-#define DSA_SKB_CB_PRIV(skb)			\
-	((void *)(skb)->cb + offsetof(struct __dsa_skb_cb, priv))
-
 struct dsa_switch_tree {
 	struct list_head	list;
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 68cdc7ceaf4d..f075aaf70eee 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -689,6 +689,14 @@ struct ocelot_policer {
 	u32 burst; /* bytes */
 };
 
+struct ocelot_skb_cb {
+	struct sk_buff *clone;
+	u8 ts_id;
+};
+
+#define OCELOT_SKB_CB(skb) \
+	((struct ocelot_skb_cb *)((skb)->cb))
+
 #define ocelot_read_ix(ocelot, reg, gi, ri) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
 #define ocelot_read_gix(ocelot, reg, gi) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi))
 #define ocelot_read_rix(ocelot, reg, ri) __ocelot_read_ix(ocelot, reg, reg##_RSZ * (ri))
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 85e51f46a9d5..8c0f3c6ab365 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -614,7 +614,7 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	dev_sw_netstats_tx_add(dev, 1, skb->len);
 
-	DSA_SKB_CB(skb)->clone = NULL;
+	memset(skb->cb, 0, sizeof(skb->cb));
 
 	/* Handle tx timestamp if any */
 	dsa_skb_tx_timestamp(p, skb);
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index f9df9cac81c5..1100a16f1032 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -15,11 +15,11 @@ static void ocelot_xmit_ptp(struct dsa_port *dp, void *injection,
 	ocelot_port = ocelot->ports[dp->index];
 	rew_op = ocelot_port->ptp_cmd;
 
-	/* Retrieve timestamp ID populated inside skb->cb[0] of the
-	 * clone by ocelot_port_add_txtstamp_skb
+	/* Retrieve timestamp ID populated inside OCELOT_SKB_CB(clone)->ts_id
+	 * by ocelot_port_add_txtstamp_skb
 	 */
 	if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP)
-		rew_op |= clone->cb[0] << 3;
+		rew_op |= OCELOT_SKB_CB(clone)->ts_id << 3;
 
 	ocelot_ifh_set_rew_op(injection, rew_op);
 }
@@ -28,7 +28,7 @@ static void ocelot_xmit_common(struct sk_buff *skb, struct net_device *netdev,
 			       __be32 ifh_prefix, void **ifh)
 {
 	struct dsa_port *dp = dsa_slave_to_port(netdev);
-	struct sk_buff *clone = DSA_SKB_CB(skb)->clone;
+	struct sk_buff *clone = OCELOT_SKB_CB(skb)->clone;
 	struct dsa_switch *ds = dp->ds;
 	void *injection;
 	__be32 *prefix;
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index 5f3e8e124a82..a001a7e3f575 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -28,11 +28,11 @@ static struct sk_buff *ocelot_xmit_ptp(struct dsa_port *dp,
 	ocelot_port = ocelot->ports[port];
 	rew_op = ocelot_port->ptp_cmd;
 
-	/* Retrieve timestamp ID populated inside skb->cb[0] of the
-	 * clone by ocelot_port_add_txtstamp_skb
+	/* Retrieve timestamp ID populated inside OCELOT_SKB_CB(clone)->ts_id
+	 * by ocelot_port_add_txtstamp_skb
 	 */
 	if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP)
-		rew_op |= clone->cb[0] << 3;
+		rew_op |= OCELOT_SKB_CB(clone)->ts_id << 3;
 
 	ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);
 
@@ -46,7 +46,7 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
-	struct sk_buff *clone = DSA_SKB_CB(skb)->clone;
+	struct sk_buff *clone = OCELOT_SKB_CB(skb)->clone;
 
 	/* TX timestamping was requested, so inject through MMIO */
 	if (clone)
-- 
2.25.1

