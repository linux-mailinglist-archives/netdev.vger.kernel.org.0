Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753A6443F41
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 10:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbhKCJXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 05:23:05 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:50557 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231904AbhKCJXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 05:23:03 -0400
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id CB062100012;
        Wed,  3 Nov 2021 09:20:25 +0000 (UTC)
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH v2 1/6] net: ocelot: add support to get port mac from device-tree
Date:   Wed,  3 Nov 2021 10:19:38 +0100
Message-Id: <20211103091943.3878621-2-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211103091943.3878621-1-clement.leger@bootlin.com>
References: <20211103091943.3878621-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to get mac from device-tree using of_get_mac_address.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index eaeba60b1bba..d76def435b23 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1704,7 +1704,10 @@ int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 		NETIF_F_HW_TC;
 	dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_TC;
 
-	eth_hw_addr_gen(dev, ocelot->base_mac, port);
+	err = of_get_mac_address(portnp, dev->dev_addr);
+	if (err)
+		eth_hw_addr_gen(dev, ocelot->base_mac, port);
+
 	ocelot_mact_learn(ocelot, PGID_CPU, dev->dev_addr,
 			  OCELOT_VLAN_UNAWARE_PVID, ENTRYTYPE_LOCKED);
 
-- 
2.33.0

