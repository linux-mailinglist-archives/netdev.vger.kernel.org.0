Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC1E473FF5
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 10:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbhLNJ4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 04:56:32 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:44973 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhLNJ4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 04:56:31 -0500
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 23458240012;
        Tue, 14 Dec 2021 09:56:27 +0000 (UTC)
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next] net: ocelot: add support to get port mac from device-tree
Date:   Tue, 14 Dec 2021 10:55:34 +0100
Message-Id: <20211214095534.563822-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to get mac from device-tree using of_get_ethdev_address.

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 5fc8a0f8e8cd..8115c3db252e 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1695,7 +1695,10 @@ int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 		NETIF_F_HW_TC;
 	dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_TC;
 
-	eth_hw_addr_gen(dev, ocelot->base_mac, port);
+	err = of_get_ethdev_address(portnp, dev);
+	if (err)
+		eth_hw_addr_gen(dev, ocelot->base_mac, port);
+
 	ocelot_mact_learn(ocelot, PGID_CPU, dev->dev_addr,
 			  OCELOT_VLAN_UNAWARE_PVID, ENTRYTYPE_LOCKED);
 
-- 
2.34.1

