Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488831E24E9
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 17:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729734AbgEZPDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 11:03:23 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:44103 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728442AbgEZPDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 11:03:23 -0400
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 1A381100003;
        Tue, 26 May 2020 15:03:15 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@bootlin.com, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com, vladimir.oltean@nxp.com
Subject: [PATCH net-next 2/2] net: mscc: allow offloading timestamping operations to the PHY
Date:   Tue, 26 May 2020 17:01:49 +0200
Message-Id: <20200526150149.456719-3-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526150149.456719-1-antoine.tenart@bootlin.com>
References: <20200526150149.456719-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for offloading timestamping operations not only
to the Ocelot switch (as already supported) but to compatible PHYs.
When both the PHY and the Ocelot switch support timestamping operations,
the PHY implementation is chosen as the timestamp will happen closer to
the medium.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/ethernet/mscc/ocelot.c       | 5 ++++-
 drivers/net/ethernet/mscc/ocelot_board.c | 3 ++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 2151c08a57c7..9cfe1fd98c30 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1204,7 +1204,10 @@ static int ocelot_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	struct ocelot *ocelot = priv->port.ocelot;
 	int port = priv->chip_port;
 
-	if (ocelot->ptp) {
+	/* If the attached PHY device isn't capable of timestamping operations,
+	 * use our own (when possible).
+	 */
+	if (!phy_has_hwtstamp(dev->phydev) && ocelot->ptp) {
 		switch (cmd) {
 		case SIOCSHWTSTAMP:
 			return ocelot_hwstamp_set(ocelot, port, ifr);
diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index 67a8d61c926a..4a15d2ff8b70 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -189,7 +189,8 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 			skb->offload_fwd_mark = 1;
 
 		skb->protocol = eth_type_trans(skb, dev);
-		netif_rx(skb);
+		if (!skb_defer_rx_timestamp(skb))
+			netif_rx(skb);
 		dev->stats.rx_bytes += len;
 		dev->stats.rx_packets++;
 	} while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp));
-- 
2.26.2

