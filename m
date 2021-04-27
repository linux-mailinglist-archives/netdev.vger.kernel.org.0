Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26EA36BE24
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 06:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232884AbhD0EM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 00:12:28 -0400
Received: from inva020.nxp.com ([92.121.34.13]:46160 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229674AbhD0EMZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 00:12:25 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C7E471A18B7;
        Tue, 27 Apr 2021 06:11:41 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 886F01A094A;
        Tue, 27 Apr 2021 06:11:35 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id B37B9402DA;
        Tue, 27 Apr 2021 06:11:27 +0200 (CEST)
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
Subject: [net-next, v3, 1/7] net: dsa: check tx timestamp request in core driver
Date:   Tue, 27 Apr 2021 12:21:57 +0800
Message-Id: <20210427042203.26258-2-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210427042203.26258-1-yangbo.lu@nxp.com>
References: <20210427042203.26258-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check tx timestamp request in core driver at very beginning of
dsa_skb_tx_timestamp(), so that most skbs not requiring tx
timestamp just return. And drop such checking in device drivers.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
Tested-by: Kurt Kanzenbach <kurt@linutronix.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
Changes for v2:
	- Split from tx timestamp optimization big patch.
Changes for v3:
	- None.
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

