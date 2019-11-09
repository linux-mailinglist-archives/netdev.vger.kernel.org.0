Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65C25F5F48
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 14:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfKINDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 08:03:38 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40293 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbfKINDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 08:03:35 -0500
Received: by mail-wm1-f65.google.com with SMTP id f3so8875870wmc.5
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 05:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ctzlsovbhVTM3lHuhg5r2BdAYorz9h7tMQqzjJas6Hs=;
        b=mWHRwqF+YvHtup1syHxWYVR3Zd7dSP4XJw3LLwRuE8JzdkQTGVQzF0zODPYIG0kkvo
         SSIiTnzp96BkjWG72QTlf595cUUAP+IzQgvs17NssIIHjjWJbRSgot6dGBeHUOlsC8H1
         1xZYjSLh1poIzLJ4gTFXGmwSPo0oAq9N9t6WYLtsncIHnhh3MA7KNtBhzAgfd7zCzMIX
         gWmxBvAQ1dl5FjV65iu/d+ZKDfnegfaMGoRhUIXG9K/S0NJVaE1vKj8giTUGjgVd2L+C
         Ad/60akic88QddBHXakIrASnB2mCs5iNCJk2q7bCGjKRTxhcrpjvbsQzmMGyVZxmhFO+
         b2VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ctzlsovbhVTM3lHuhg5r2BdAYorz9h7tMQqzjJas6Hs=;
        b=iNZAUgdB4Qzqt/VLBjDTAGMGwUuffUdUUkfSXmQ4zFk1K/vxM6fHRlnGPQKSwPj15+
         +4rToGmsxeG6DXQDOq9TTmtw5wvW1BKsKQNzIvUQ1w2H5CpT9GkBe4x8vr1UhQX2Zlqd
         233kBeYSKvYvxhAWTkE21f3///YFdZkI/KSzx2IBmzButy0UVuwKUdbMcwJVSR2bl1GA
         t4BXY19IqVExpuQDx0Ji4eQlzFhArQfJEn5BoevvTOkl/7XQB0P2MfgPf4DImyimz/6G
         OCrN8BbDspVf78UgUA3t0TSvsZRZf2o3I7u1ihTA0au8PQLEDtk19wuZZ50PGB335gMD
         39WQ==
X-Gm-Message-State: APjAAAXMN+yaAcvOazZfD2wjVr70jQ5Ug4UfpntNEOIBWl0otyaz6tAT
        6hsX+H5lj3vIBho+9NS/GS0=
X-Google-Smtp-Source: APXvYqz3Tg/BX5YDmPgp1sD/uMZqnZWBL1Qx0Jmwo3+y4ZlUasAKwOv3s+sKx/p8DgNbSDBGEtbGaQ==
X-Received: by 2002:a1c:6745:: with SMTP id b66mr12438696wmc.30.1573304613597;
        Sat, 09 Nov 2019 05:03:33 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id n13sm8370908wmi.25.2019.11.09.05.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 05:03:32 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 11/15] net: mscc: ocelot: separate the common implementation of ndo_open and ndo_stop
Date:   Sat,  9 Nov 2019 15:02:57 +0200
Message-Id: <20191109130301.13716-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191109130301.13716-1-olteanv@gmail.com>
References: <20191109130301.13716-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Allow these functions to be called from the .port_enable and
.port_disable callbacks of DSA.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 36 +++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 83ecbbd720fd..df8796f05ff9 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -536,13 +536,9 @@ static void ocelot_port_adjust_link(struct net_device *dev)
 	ocelot_write(ocelot, ocelot_wm_enc(atop_wm), SYS_ATOP_TOT_CFG);
 }
 
-static int ocelot_port_open(struct net_device *dev)
+static void ocelot_port_enable(struct ocelot *ocelot, int port,
+			       struct phy_device *phy)
 {
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
-	int err;
-
 	/* Enable receiving frames on the port, and activate auto-learning of
 	 * MAC addresses.
 	 */
@@ -550,6 +546,14 @@ static int ocelot_port_open(struct net_device *dev)
 			 ANA_PORT_PORT_CFG_RECV_ENA |
 			 ANA_PORT_PORT_CFG_PORTID_VAL(port),
 			 ANA_PORT_PORT_CFG, port);
+}
+
+static int ocelot_port_open(struct net_device *dev)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
+	int err;
 
 	if (priv->serdes) {
 		err = phy_set_mode_ext(priv->serdes, PHY_MODE_ETHERNET,
@@ -571,21 +575,33 @@ static int ocelot_port_open(struct net_device *dev)
 
 	phy_attached_info(priv->phy);
 	phy_start(priv->phy);
+
+	ocelot_port_enable(ocelot, port, priv->phy);
+
 	return 0;
 }
 
+static void ocelot_port_disable(struct ocelot *ocelot, int port)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+	ocelot_port_writel(ocelot_port, 0, DEV_MAC_ENA_CFG);
+	ocelot_rmw_rix(ocelot, 0, QSYS_SWITCH_PORT_MODE_PORT_ENA,
+		       QSYS_SWITCH_PORT_MODE, port);
+}
+
 static int ocelot_port_stop(struct net_device *dev)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot_port *port = &priv->port;
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
 
 	phy_disconnect(priv->phy);
 
 	dev->phydev = NULL;
 
-	ocelot_port_writel(port, 0, DEV_MAC_ENA_CFG);
-	ocelot_rmw_rix(port->ocelot, 0, QSYS_SWITCH_PORT_MODE_PORT_ENA,
-		       QSYS_SWITCH_PORT_MODE, priv->chip_port);
+	ocelot_port_disable(ocelot, port);
+
 	return 0;
 }
 
-- 
2.17.1

