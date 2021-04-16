Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17531361FDC
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 14:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243472AbhDPMbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 08:31:13 -0400
Received: from inva021.nxp.com ([92.121.34.21]:42490 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241437AbhDPMbL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 08:31:11 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C57AB203A7C;
        Fri, 16 Apr 2021 14:30:45 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 41E85203A74;
        Fri, 16 Apr 2021 14:30:39 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 3B0C540249;
        Fri, 16 Apr 2021 14:30:31 +0200 (CEST)
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
Subject: [net-next 1/3] net: dsa: optimize tx timestamp request handling
Date:   Fri, 16 Apr 2021 20:36:53 +0800
Message-Id: <20210416123655.42783-2-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210416123655.42783-1-yangbo.lu@nxp.com>
References: <20210416123655.42783-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Optimization could be done on dsa_skb_tx_timestamp(), and dsa device
drivers should adapt to it.

- Check SKBTX_HW_TSTAMP request flag at the very beginning, instead of in
  port_txtstamp, so that most skbs not requiring tx timestamp just return.

- No longer to identify PTP packets, and limit tx timestamping only for PTP
  packets. If device driver likes, let device driver do.

- It is a waste to clone skb directly in dsa_skb_tx_timestamp().
  For one-step timestamping, a clone is not needed. For any failure of
  port_txtstamp (this may usually happen), the skb clone has to be freed.
  So put skb cloning into port_txtstamp where it really needs.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 Documentation/networking/timestamping.rst     |  7 +++++--
 .../net/dsa/hirschmann/hellcreek_hwtstamp.c   | 20 ++++++++++++------
 .../net/dsa/hirschmann/hellcreek_hwtstamp.h   |  2 +-
 drivers/net/dsa/mv88e6xxx/hwtstamp.c          | 21 +++++++++++++------
 drivers/net/dsa/mv88e6xxx/hwtstamp.h          |  6 +++---
 drivers/net/dsa/ocelot/felix.c                | 11 ++++++----
 drivers/net/dsa/sja1105/sja1105_ptp.c         |  6 +++++-
 drivers/net/dsa/sja1105/sja1105_ptp.h         |  2 +-
 include/net/dsa.h                             |  2 +-
 net/dsa/slave.c                               | 20 +++++-------------
 10 files changed, 57 insertions(+), 40 deletions(-)

diff --git a/Documentation/networking/timestamping.rst b/Documentation/networking/timestamping.rst
index f682e88fa87e..7f04a699a5d1 100644
--- a/Documentation/networking/timestamping.rst
+++ b/Documentation/networking/timestamping.rst
@@ -635,8 +635,8 @@ in generic code: a BPF classifier (``ptp_classify_raw``) is used to identify
 PTP event messages (any other packets, including PTP general messages, are not
 timestamped), and provides two hooks to drivers:
 
-- ``.port_txtstamp()``: The driver is passed a clone of the timestampable skb
-  to be transmitted, before actually transmitting it. Typically, a switch will
+- ``.port_txtstamp()``: A clone of the timestampable skb to be transmitted
+  is needed, before actually transmitting it. Typically, a switch will
   have a PTP TX timestamp register (or sometimes a FIFO) where the timestamp
   becomes available. There may be an IRQ that is raised upon this timestamp's
   availability, or the driver might have to poll after invoking
@@ -645,6 +645,9 @@ timestamped), and provides two hooks to drivers:
   later use (when the timestamp becomes available). Each skb is annotated with
   a pointer to its clone, in ``DSA_SKB_CB(skb)->clone``, to ease the driver's
   job of keeping track of which clone belongs to which skb.
+  But one-step timestamping request is handled differently with above two-step
+  timestamping. The skb clone is no longer needed since hardware will insert
+  TX time information on packet during egress.
 
 - ``.port_rxtstamp()``: The original (and only) timestampable skb is provided
   to the driver, for it to annotate it with a timestamp, if that is immediately
diff --git a/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c b/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c
index 69dd9a2e8bb6..2ff4b7c08b72 100644
--- a/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c
+++ b/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c
@@ -374,31 +374,39 @@ long hellcreek_hwtstamp_work(struct ptp_clock_info *ptp)
 }
 
 bool hellcreek_port_txtstamp(struct dsa_switch *ds, int port,
-			     struct sk_buff *clone, unsigned int type)
+			     struct sk_buff *skb, struct sk_buff **clone)
 {
 	struct hellcreek *hellcreek = ds->priv;
 	struct hellcreek_port_hwtstamp *ps;
 	struct ptp_header *hdr;
+	unsigned int type;
 
 	ps = &hellcreek->ports[port].port_hwtstamp;
 
-	/* Check if the driver is expected to do HW timestamping */
-	if (!(skb_shinfo(clone)->tx_flags & SKBTX_HW_TSTAMP))
+	type = ptp_classify_raw(skb);
+	if (type == PTP_CLASS_NONE)
 		return false;
 
 	/* Make sure the message is a PTP message that needs to be timestamped
 	 * and the interaction with the HW timestamping is enabled. If not, stop
 	 * here
 	 */
-	hdr = hellcreek_should_tstamp(hellcreek, port, clone, type);
+	hdr = hellcreek_should_tstamp(hellcreek, port, skb, type);
 	if (!hdr)
 		return false;
 
+	*clone = skb_clone_sk(skb);
+	if (!(*clone))
+		return false;
+
 	if (test_and_set_bit_lock(HELLCREEK_HWTSTAMP_TX_IN_PROGRESS,
-				  &ps->state))
+				  &ps->state)) {
+		kfree_skb(*clone);
+		*clone = NULL;
 		return false;
+	}
 
-	ps->tx_skb = clone;
+	ps->tx_skb = *clone;
 
 	/* store the number of ticks occurred since system start-up till this
 	 * moment
diff --git a/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.h b/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.h
index c0745ffa1ebb..58cc96642076 100644
--- a/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.h
+++ b/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.h
@@ -45,7 +45,7 @@ int hellcreek_port_hwtstamp_get(struct dsa_switch *ds, int port,
 bool hellcreek_port_rxtstamp(struct dsa_switch *ds, int port,
 			     struct sk_buff *clone, unsigned int type);
 bool hellcreek_port_txtstamp(struct dsa_switch *ds, int port,
-			     struct sk_buff *clone, unsigned int type);
+			     struct sk_buff *skb, struct sk_buff **clone);
 
 int hellcreek_get_ts_info(struct dsa_switch *ds, int port,
 			  struct ethtool_ts_info *info);
diff --git a/drivers/net/dsa/mv88e6xxx/hwtstamp.c b/drivers/net/dsa/mv88e6xxx/hwtstamp.c
index 094d17a1d037..280a95962861 100644
--- a/drivers/net/dsa/mv88e6xxx/hwtstamp.c
+++ b/drivers/net/dsa/mv88e6xxx/hwtstamp.c
@@ -469,24 +469,33 @@ long mv88e6xxx_hwtstamp_work(struct ptp_clock_info *ptp)
 }
 
 bool mv88e6xxx_port_txtstamp(struct dsa_switch *ds, int port,
-			     struct sk_buff *clone, unsigned int type)
+			     struct sk_buff *skb, struct sk_buff **clone)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	struct mv88e6xxx_port_hwtstamp *ps = &chip->port_hwtstamp[port];
 	struct ptp_header *hdr;
+	unsigned int type;
 
-	if (!(skb_shinfo(clone)->tx_flags & SKBTX_HW_TSTAMP))
-		return false;
+	type = ptp_classify_raw(skb);
+	if (type == PTP_CLASS_NONE)
+		return false
 
-	hdr = mv88e6xxx_should_tstamp(chip, port, clone, type);
+	hdr = mv88e6xxx_should_tstamp(chip, port, skb, type);
 	if (!hdr)
 		return false;
 
+	*clone = skb_clone_sk(skb);
+	if (!(*clone))
+		return false;
+
 	if (test_and_set_bit_lock(MV88E6XXX_HWTSTAMP_TX_IN_PROGRESS,
-				  &ps->state))
+				  &ps->state)) {
+		kfree_skb(*clone);
+		*clone = NULL;
 		return false;
+	}
 
-	ps->tx_skb = clone;
+	ps->tx_skb = *clone;
 	ps->tx_tstamp_start = jiffies;
 	ps->tx_seq_id = be16_to_cpu(hdr->sequence_id);
 
diff --git a/drivers/net/dsa/mv88e6xxx/hwtstamp.h b/drivers/net/dsa/mv88e6xxx/hwtstamp.h
index 9da9f197ba02..da2b253334d0 100644
--- a/drivers/net/dsa/mv88e6xxx/hwtstamp.h
+++ b/drivers/net/dsa/mv88e6xxx/hwtstamp.h
@@ -118,7 +118,7 @@ int mv88e6xxx_port_hwtstamp_get(struct dsa_switch *ds, int port,
 bool mv88e6xxx_port_rxtstamp(struct dsa_switch *ds, int port,
 			     struct sk_buff *clone, unsigned int type);
 bool mv88e6xxx_port_txtstamp(struct dsa_switch *ds, int port,
-			     struct sk_buff *clone, unsigned int type);
+			     struct sk_buff *skb, struct sk_buff **clone);
 
 int mv88e6xxx_get_ts_info(struct dsa_switch *ds, int port,
 			  struct ethtool_ts_info *info);
@@ -152,8 +152,8 @@ static inline bool mv88e6xxx_port_rxtstamp(struct dsa_switch *ds, int port,
 }
 
 static inline bool mv88e6xxx_port_txtstamp(struct dsa_switch *ds, int port,
-					   struct sk_buff *clone,
-					   unsigned int type)
+					   struct sk_buff *skb,
+					   struct sk_buff **clone)
 {
 	return false;
 }
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 6b5442be0230..cdec2f5e271c 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1396,14 +1396,17 @@ static bool felix_rxtstamp(struct dsa_switch *ds, int port,
 }
 
 static bool felix_txtstamp(struct dsa_switch *ds, int port,
-			   struct sk_buff *clone, unsigned int type)
+			   struct sk_buff *skb, struct sk_buff **clone)
 {
 	struct ocelot *ocelot = ds->priv;
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
-	if (ocelot->ptp && (skb_shinfo(clone)->tx_flags & SKBTX_HW_TSTAMP) &&
-	    ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
-		ocelot_port_add_txtstamp_skb(ocelot, port, clone);
+	if (ocelot->ptp && ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
+		*clone = skb_clone_sk(skb);
+		if (!(*clone))
+			return false;
+
+		ocelot_port_add_txtstamp_skb(ocelot, port, *clone);
 		return true;
 	}
 
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 1b90570b257b..6a1f854a8c33 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -436,7 +436,7 @@ bool sja1105_port_rxtstamp(struct dsa_switch *ds, int port,
  * callback, where we will timestamp it synchronously.
  */
 bool sja1105_port_txtstamp(struct dsa_switch *ds, int port,
-			   struct sk_buff *skb, unsigned int type)
+			   struct sk_buff *skb, struct sk_buff **clone)
 {
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_port *sp = &priv->ports[port];
@@ -444,6 +444,10 @@ bool sja1105_port_txtstamp(struct dsa_switch *ds, int port,
 	if (!sp->hwts_tx_en)
 		return false;
 
+	*clone = skb_clone_sk(skb);
+	if (!(*clone))
+		return false;
+
 	return true;
 }
 
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
index 3daa33e98e77..ab80b73219cb 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.h
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -105,7 +105,7 @@ bool sja1105_port_rxtstamp(struct dsa_switch *ds, int port,
 			   struct sk_buff *skb, unsigned int type);
 
 bool sja1105_port_txtstamp(struct dsa_switch *ds, int port,
-			   struct sk_buff *skb, unsigned int type);
+			   struct sk_buff *skb, struct sk_buff **clone);
 
 int sja1105_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr);
 
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 1259b0f40684..c8415c324e27 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -734,7 +734,7 @@ struct dsa_switch_ops {
 	int	(*port_hwtstamp_set)(struct dsa_switch *ds, int port,
 				     struct ifreq *ifr);
 	bool	(*port_txtstamp)(struct dsa_switch *ds, int port,
-				 struct sk_buff *clone, unsigned int type);
+				 struct sk_buff *skb, struct sk_buff **clone);
 	bool	(*port_rxtstamp)(struct dsa_switch *ds, int port,
 				 struct sk_buff *skb, unsigned int type);
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 9300cb66e500..5b746a903ef4 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -19,7 +19,6 @@
 #include <linux/if_bridge.h>
 #include <linux/if_hsr.h>
 #include <linux/netpoll.h>
-#include <linux/ptp_classify.h>
 
 #include "dsa_priv.h"
 
@@ -555,26 +554,19 @@ static void dsa_skb_tx_timestamp(struct dsa_slave_priv *p,
 				 struct sk_buff *skb)
 {
 	struct dsa_switch *ds = p->dp->ds;
-	struct sk_buff *clone;
-	unsigned int type;
+	struct sk_buff *clone = NULL;
 
-	type = ptp_classify_raw(skb);
-	if (type == PTP_CLASS_NONE)
+	if (!(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
 		return;
 
 	if (!ds->ops->port_txtstamp)
 		return;
 
-	clone = skb_clone_sk(skb);
-	if (!clone)
+	if (!ds->ops->port_txtstamp(ds, p->dp->index, skb, &clone))
 		return;
 
-	if (ds->ops->port_txtstamp(ds, p->dp->index, clone, type)) {
+	if (clone)
 		DSA_SKB_CB(skb)->clone = clone;
-		return;
-	}
-
-	kfree_skb(clone);
 }
 
 netdev_tx_t dsa_enqueue_skb(struct sk_buff *skb, struct net_device *dev)
@@ -628,9 +620,7 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	DSA_SKB_CB(skb)->clone = NULL;
 
-	/* Identify PTP protocol packets, clone them, and pass them to the
-	 * switch driver
-	 */
+	/* Handle tx timestamp request if has */
 	dsa_skb_tx_timestamp(p, skb);
 
 	if (dsa_realloc_skb(skb, dev)) {
-- 
2.25.1

