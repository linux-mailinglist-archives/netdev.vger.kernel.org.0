Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE9B36B0A2
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 11:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbhDZJdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 05:33:12 -0400
Received: from inva021.nxp.com ([92.121.34.21]:54846 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232675AbhDZJc7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 05:32:59 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 902CC2033CA;
        Mon, 26 Apr 2021 11:32:08 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 50A7F2033CB;
        Mon, 26 Apr 2021 11:32:02 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 6061D4032D;
        Mon, 26 Apr 2021 11:31:54 +0200 (CEST)
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
Subject: [net-next, v2, 2/7] net: dsa: no longer identify PTP packet in core driver
Date:   Mon, 26 Apr 2021 17:37:57 +0800
Message-Id: <20210426093802.38652-3-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210426093802.38652-1-yangbo.lu@nxp.com>
References: <20210426093802.38652-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move ptp_classify_raw out of dsa core driver for handling tx
timestamp request. Let device drivers do this if they want.
Not all drivers want to limit tx timestamping for only PTP
packet.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
Tested-by: Kurt Kanzenbach <kurt@linutronix.de>
---
Changes for v2:
	- Split from tx timestamp optimization big patch.
---
 drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c |  7 ++++++-
 drivers/net/dsa/hirschmann/hellcreek_hwtstamp.h |  2 +-
 drivers/net/dsa/mv88e6xxx/hwtstamp.c            |  7 ++++++-
 drivers/net/dsa/mv88e6xxx/hwtstamp.h            |  5 ++---
 drivers/net/dsa/ocelot/felix.c                  |  2 +-
 drivers/net/dsa/sja1105/sja1105_ptp.c           |  3 +--
 drivers/net/dsa/sja1105/sja1105_ptp.h           |  2 +-
 include/net/dsa.h                               |  2 +-
 net/dsa/slave.c                                 | 12 ++----------
 9 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c b/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c
index 6ba5e2333066..5b2e023468fe 100644
--- a/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c
+++ b/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c
@@ -374,14 +374,19 @@ long hellcreek_hwtstamp_work(struct ptp_clock_info *ptp)
 }
 
 bool hellcreek_port_txtstamp(struct dsa_switch *ds, int port,
-			     struct sk_buff *clone, unsigned int type)
+			     struct sk_buff *clone)
 {
 	struct hellcreek *hellcreek = ds->priv;
 	struct hellcreek_port_hwtstamp *ps;
 	struct ptp_header *hdr;
+	unsigned int type;
 
 	ps = &hellcreek->ports[port].port_hwtstamp;
 
+	type = ptp_classify_raw(clone);
+	if (type == PTP_CLASS_NONE)
+		return false;
+
 	/* Make sure the message is a PTP message that needs to be timestamped
 	 * and the interaction with the HW timestamping is enabled. If not, stop
 	 * here
diff --git a/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.h b/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.h
index c0745ffa1ebb..728cd5dc650f 100644
--- a/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.h
+++ b/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.h
@@ -45,7 +45,7 @@ int hellcreek_port_hwtstamp_get(struct dsa_switch *ds, int port,
 bool hellcreek_port_rxtstamp(struct dsa_switch *ds, int port,
 			     struct sk_buff *clone, unsigned int type);
 bool hellcreek_port_txtstamp(struct dsa_switch *ds, int port,
-			     struct sk_buff *clone, unsigned int type);
+			     struct sk_buff *clone);
 
 int hellcreek_get_ts_info(struct dsa_switch *ds, int port,
 			  struct ethtool_ts_info *info);
diff --git a/drivers/net/dsa/mv88e6xxx/hwtstamp.c b/drivers/net/dsa/mv88e6xxx/hwtstamp.c
index 05ca1d3c6498..79514a54d903 100644
--- a/drivers/net/dsa/mv88e6xxx/hwtstamp.c
+++ b/drivers/net/dsa/mv88e6xxx/hwtstamp.c
@@ -469,11 +469,16 @@ long mv88e6xxx_hwtstamp_work(struct ptp_clock_info *ptp)
 }
 
 bool mv88e6xxx_port_txtstamp(struct dsa_switch *ds, int port,
-			     struct sk_buff *clone, unsigned int type)
+			     struct sk_buff *clone)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	struct mv88e6xxx_port_hwtstamp *ps = &chip->port_hwtstamp[port];
 	struct ptp_header *hdr;
+	unsigned int type;
+
+	type = ptp_classify_raw(clone);
+	if (type == PTP_CLASS_NONE)
+		return false;
 
 	hdr = mv88e6xxx_should_tstamp(chip, port, clone, type);
 	if (!hdr)
diff --git a/drivers/net/dsa/mv88e6xxx/hwtstamp.h b/drivers/net/dsa/mv88e6xxx/hwtstamp.h
index 9da9f197ba02..91fbc7838fc8 100644
--- a/drivers/net/dsa/mv88e6xxx/hwtstamp.h
+++ b/drivers/net/dsa/mv88e6xxx/hwtstamp.h
@@ -118,7 +118,7 @@ int mv88e6xxx_port_hwtstamp_get(struct dsa_switch *ds, int port,
 bool mv88e6xxx_port_rxtstamp(struct dsa_switch *ds, int port,
 			     struct sk_buff *clone, unsigned int type);
 bool mv88e6xxx_port_txtstamp(struct dsa_switch *ds, int port,
-			     struct sk_buff *clone, unsigned int type);
+			     struct sk_buff *clone);
 
 int mv88e6xxx_get_ts_info(struct dsa_switch *ds, int port,
 			  struct ethtool_ts_info *info);
@@ -152,8 +152,7 @@ static inline bool mv88e6xxx_port_rxtstamp(struct dsa_switch *ds, int port,
 }
 
 static inline bool mv88e6xxx_port_txtstamp(struct dsa_switch *ds, int port,
-					   struct sk_buff *clone,
-					   unsigned int type)
+					   struct sk_buff *clone)
 {
 	return false;
 }
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 1379f86d71ec..d679f023dc00 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1396,7 +1396,7 @@ static bool felix_rxtstamp(struct dsa_switch *ds, int port,
 }
 
 static bool felix_txtstamp(struct dsa_switch *ds, int port,
-			   struct sk_buff *clone, unsigned int type)
+			   struct sk_buff *clone)
 {
 	struct ocelot *ocelot = ds->priv;
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 1b90570b257b..72d052de82d8 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -435,8 +435,7 @@ bool sja1105_port_rxtstamp(struct dsa_switch *ds, int port,
  * the skb and have it available in DSA_SKB_CB in the .port_deferred_xmit
  * callback, where we will timestamp it synchronously.
  */
-bool sja1105_port_txtstamp(struct dsa_switch *ds, int port,
-			   struct sk_buff *skb, unsigned int type)
+bool sja1105_port_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
 {
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_port *sp = &priv->ports[port];
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
index 3daa33e98e77..c70c4729a06d 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.h
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -105,7 +105,7 @@ bool sja1105_port_rxtstamp(struct dsa_switch *ds, int port,
 			   struct sk_buff *skb, unsigned int type);
 
 bool sja1105_port_txtstamp(struct dsa_switch *ds, int port,
-			   struct sk_buff *skb, unsigned int type);
+			   struct sk_buff *skb);
 
 int sja1105_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr);
 
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 507082959aa4..905066055b08 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -741,7 +741,7 @@ struct dsa_switch_ops {
 	int	(*port_hwtstamp_set)(struct dsa_switch *ds, int port,
 				     struct ifreq *ifr);
 	bool	(*port_txtstamp)(struct dsa_switch *ds, int port,
-				 struct sk_buff *clone, unsigned int type);
+				 struct sk_buff *clone);
 	bool	(*port_rxtstamp)(struct dsa_switch *ds, int port,
 				 struct sk_buff *skb, unsigned int type);
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index b2a802e9330e..acaa52e60d7f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -20,7 +20,6 @@
 #include <linux/if_bridge.h>
 #include <linux/if_hsr.h>
 #include <linux/netpoll.h>
-#include <linux/ptp_classify.h>
 
 #include "dsa_priv.h"
 
@@ -557,15 +556,10 @@ static void dsa_skb_tx_timestamp(struct dsa_slave_priv *p,
 {
 	struct dsa_switch *ds = p->dp->ds;
 	struct sk_buff *clone;
-	unsigned int type;
 
 	if (!(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
 		return;
 
-	type = ptp_classify_raw(skb);
-	if (type == PTP_CLASS_NONE)
-		return;
-
 	if (!ds->ops->port_txtstamp)
 		return;
 
@@ -573,7 +567,7 @@ static void dsa_skb_tx_timestamp(struct dsa_slave_priv *p,
 	if (!clone)
 		return;
 
-	if (ds->ops->port_txtstamp(ds, p->dp->index, clone, type)) {
+	if (ds->ops->port_txtstamp(ds, p->dp->index, clone)) {
 		DSA_SKB_CB(skb)->clone = clone;
 		return;
 	}
@@ -632,9 +626,7 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	DSA_SKB_CB(skb)->clone = NULL;
 
-	/* Identify PTP protocol packets, clone them, and pass them to the
-	 * switch driver
-	 */
+	/* Handle tx timestamp if any */
 	dsa_skb_tx_timestamp(p, skb);
 
 	if (dsa_realloc_skb(skb, dev)) {
-- 
2.25.1

