Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFAD736BE31
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 06:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234764AbhD0EMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 00:12:38 -0400
Received: from inva021.nxp.com ([92.121.34.21]:45280 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234234AbhD0EMc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 00:12:32 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 11648200D3F;
        Tue, 27 Apr 2021 06:11:49 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C1555200184;
        Tue, 27 Apr 2021 06:11:42 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 3D604402BE;
        Tue, 27 Apr 2021 06:11:35 +0200 (CEST)
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
Subject: [net-next, v3, 6/7] net: mscc: ocelot: convert to ocelot_port_txtstamp_request()
Date:   Tue, 27 Apr 2021 12:22:02 +0800
Message-Id: <20210427042203.26258-7-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210427042203.26258-1-yangbo.lu@nxp.com>
References: <20210427042203.26258-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert to a common ocelot_port_txtstamp_request() for TX timestamp
request handling.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
Changes for v2:
	- Rebased.
Changes for v3:
	- None.
---
 drivers/net/dsa/ocelot/felix.c         | 15 +++++++--------
 drivers/net/ethernet/mscc/ocelot.c     | 24 +++++++++++++++++++++---
 drivers/net/ethernet/mscc/ocelot_net.c | 18 +++++++-----------
 include/soc/mscc/ocelot.h              |  5 +++--
 4 files changed, 38 insertions(+), 24 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index b28280b6e91a..ce607fbaaa3a 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1399,17 +1399,16 @@ static void felix_txtstamp(struct dsa_switch *ds, int port,
 			   struct sk_buff *skb)
 {
 	struct ocelot *ocelot = ds->priv;
-	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	struct sk_buff *clone;
+	struct sk_buff *clone = NULL;
 
-	if (ocelot->ptp && ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
-		clone = skb_clone_sk(skb);
-		if (!clone)
-			return;
+	if (!ocelot->ptp)
+		return;
 
-		ocelot_port_add_txtstamp_skb(ocelot, port, clone);
+	if (ocelot_port_txtstamp_request(ocelot, port, skb, &clone))
+		return;
+
+	if (clone)
 		OCELOT_SKB_CB(skb)->clone = clone;
-	}
 }
 
 static int felix_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 7da2dd1632b1..3ff4cce1ce7d 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -530,8 +530,8 @@ void ocelot_port_disable(struct ocelot *ocelot, int port)
 }
 EXPORT_SYMBOL(ocelot_port_disable);
 
-void ocelot_port_add_txtstamp_skb(struct ocelot *ocelot, int port,
-				  struct sk_buff *clone)
+static void ocelot_port_add_txtstamp_skb(struct ocelot *ocelot, int port,
+					 struct sk_buff *clone)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
@@ -545,7 +545,25 @@ void ocelot_port_add_txtstamp_skb(struct ocelot *ocelot, int port,
 
 	spin_unlock(&ocelot_port->ts_id_lock);
 }
-EXPORT_SYMBOL(ocelot_port_add_txtstamp_skb);
+
+int ocelot_port_txtstamp_request(struct ocelot *ocelot, int port,
+				 struct sk_buff *skb,
+				 struct sk_buff **clone)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	u8 ptp_cmd = ocelot_port->ptp_cmd;
+
+	if (ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
+		*clone = skb_clone_sk(skb);
+		if (!(*clone))
+			return -ENOMEM;
+
+		ocelot_port_add_txtstamp_skb(ocelot, port, *clone);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_port_txtstamp_request);
 
 static void ocelot_get_hwtimestamp(struct ocelot *ocelot,
 				   struct timespec64 *ts)
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 789a5fba146c..e99c8fb3cb15 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -507,19 +507,15 @@ static netdev_tx_t ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	/* Check if timestamping is needed */
 	if (ocelot->ptp && (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
-		rew_op = ocelot_port->ptp_cmd;
+		struct sk_buff *clone = NULL;
 
-		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
-			struct sk_buff *clone;
-
-			clone = skb_clone_sk(skb);
-			if (!clone) {
-				kfree_skb(skb);
-				return NETDEV_TX_OK;
-			}
-
-			ocelot_port_add_txtstamp_skb(ocelot, port, clone);
+		if (ocelot_port_txtstamp_request(ocelot, port, skb, &clone)) {
+			kfree_skb(skb);
+			return NETDEV_TX_OK;
+		}
 
+		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
+			rew_op = ocelot_port->ptp_cmd;
 			rew_op |= OCELOT_SKB_CB(clone)->ts_id << 3;
 		}
 	}
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index f075aaf70eee..f7632519cb9c 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -828,8 +828,9 @@ int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid);
 int ocelot_hwstamp_get(struct ocelot *ocelot, int port, struct ifreq *ifr);
 int ocelot_hwstamp_set(struct ocelot *ocelot, int port, struct ifreq *ifr);
-void ocelot_port_add_txtstamp_skb(struct ocelot *ocelot, int port,
-				  struct sk_buff *clone);
+int ocelot_port_txtstamp_request(struct ocelot *ocelot, int port,
+				 struct sk_buff *skb,
+				 struct sk_buff **clone);
 void ocelot_get_txtstamp(struct ocelot *ocelot);
 void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu);
 int ocelot_get_max_mtu(struct ocelot *ocelot, int port);
-- 
2.25.1

