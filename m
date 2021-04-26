Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC5536B0A0
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 11:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbhDZJdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 05:33:11 -0400
Received: from inva021.nxp.com ([92.121.34.21]:54772 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232630AbhDZJc7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 05:32:59 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 5BB342033DB;
        Mon, 26 Apr 2021 11:32:07 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 17C6F2033E2;
        Mon, 26 Apr 2021 11:32:01 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id DAE0D402F0;
        Mon, 26 Apr 2021 11:31:52 +0200 (CEST)
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
Subject: [net-next, v2, 1/7] net: dsa: check tx timestamp request in core driver
Date:   Mon, 26 Apr 2021 17:37:56 +0800
Message-Id: <20210426093802.38652-2-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210426093802.38652-1-yangbo.lu@nxp.com>
References: <20210426093802.38652-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check tx timestamp request in core driver at very beginning of
dsa_skb_tx_timestamp(), so that most skbs not requiring tx
timestamp just return. And drop such checking in device drivers.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
Tested-by: Kurt Kanzenbach <kurt@linutronix.de>
---
Changes for v2:
	- Split from tx timestamp optimization big patch.
---
 drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c | 4 ----
 drivers/net/dsa/mv88e6xxx/hwtstamp.c            | 3 ---
 drivers/net/dsa/ocelot/felix.c                  | 3 +--
 net/dsa/slave.c                                 | 3 +++
 4 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c b/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c
index 69dd9a2e8bb6..6ba5e2333066 100644
--- a/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c
+++ b/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c
@@ -382,10 +382,6 @@ bool hellcreek_port_txtstamp(struct dsa_switch *ds, int port,
 
 	ps = &hellcreek->ports[port].port_hwtstamp;
 
-	/* Check if the driver is expected to do HW timestamping */
-	if (!(skb_shinfo(clone)->tx_flags & SKBTX_HW_TSTAMP))
-		return false;
-
 	/* Make sure the message is a PTP message that needs to be timestamped
 	 * and the interaction with the HW timestamping is enabled. If not, stop
 	 * here
diff --git a/drivers/net/dsa/mv88e6xxx/hwtstamp.c b/drivers/net/dsa/mv88e6xxx/hwtstamp.c
index 094d17a1d037..05ca1d3c6498 100644
--- a/drivers/net/dsa/mv88e6xxx/hwtstamp.c
+++ b/drivers/net/dsa/mv88e6xxx/hwtstamp.c
@@ -475,9 +475,6 @@ bool mv88e6xxx_port_txtstamp(struct dsa_switch *ds, int port,
 	struct mv88e6xxx_port_hwtstamp *ps = &chip->port_hwtstamp[port];
 	struct ptp_header *hdr;
 
-	if (!(skb_shinfo(clone)->tx_flags & SKBTX_HW_TSTAMP))
-		return false;
-
 	hdr = mv88e6xxx_should_tstamp(chip, port, clone, type);
 	if (!hdr)
 		return false;
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 6b5442be0230..1379f86d71ec 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1401,8 +1401,7 @@ static bool felix_txtstamp(struct dsa_switch *ds, int port,
 	struct ocelot *ocelot = ds->priv;
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
-	if (ocelot->ptp && (skb_shinfo(clone)->tx_flags & SKBTX_HW_TSTAMP) &&
-	    ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
+	if (ocelot->ptp && ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
 		ocelot_port_add_txtstamp_skb(ocelot, port, clone);
 		return true;
 	}
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 77b33bd161b8..b2a802e9330e 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -559,6 +559,9 @@ static void dsa_skb_tx_timestamp(struct dsa_slave_priv *p,
 	struct sk_buff *clone;
 	unsigned int type;
 
+	if (!(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
+		return;
+
 	type = ptp_classify_raw(skb);
 	if (type == PTP_CLASS_NONE)
 		return;
-- 
2.25.1

