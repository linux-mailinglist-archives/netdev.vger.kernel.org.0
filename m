Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFB61E24E6
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 17:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729527AbgEZPDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 11:03:16 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:58281 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727978AbgEZPDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 11:03:16 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 32C3EE000B;
        Tue, 26 May 2020 15:03:09 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@bootlin.com, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com, vladimir.oltean@nxp.com
Subject: [PATCH net-next 1/2] net: mscc: use the PHY MII ioctl interface when possible
Date:   Tue, 26 May 2020 17:01:48 +0200
Message-Id: <20200526150149.456719-2-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526150149.456719-1-antoine.tenart@bootlin.com>
References: <20200526150149.456719-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow ioctl to be implemented by the PHY, when a PHY is attached to the
Ocelot switch. In case the ioctl is a request to set or get the hardware
timestamp, use the Ocelot switch implementation for now.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index e621c4c3ee86..2151c08a57c7 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1204,18 +1204,16 @@ static int ocelot_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	struct ocelot *ocelot = priv->port.ocelot;
 	int port = priv->chip_port;
 
-	/* The function is only used for PTP operations for now */
-	if (!ocelot->ptp)
-		return -EOPNOTSUPP;
-
-	switch (cmd) {
-	case SIOCSHWTSTAMP:
-		return ocelot_hwstamp_set(ocelot, port, ifr);
-	case SIOCGHWTSTAMP:
-		return ocelot_hwstamp_get(ocelot, port, ifr);
-	default:
-		return -EOPNOTSUPP;
+	if (ocelot->ptp) {
+		switch (cmd) {
+		case SIOCSHWTSTAMP:
+			return ocelot_hwstamp_set(ocelot, port, ifr);
+		case SIOCGHWTSTAMP:
+			return ocelot_hwstamp_get(ocelot, port, ifr);
+		}
 	}
+
+	return phy_mii_ioctl(dev->phydev, ifr, cmd);
 }
 
 static const struct net_device_ops ocelot_port_netdev_ops = {
-- 
2.26.2

