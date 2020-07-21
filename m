Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC02227C79
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 12:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729204AbgGUKFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 06:05:11 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:59330 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726976AbgGUKFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 06:05:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595325910; x=1626861910;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PQhdyJFUcE/B+fHmZsdxZExh6mjBo63eSp4PWdlxyO0=;
  b=J7Al6bx06SREzqHpSbF5MLLDs53q8K85O1bMG1SyYGMTryr4r9GNQvdZ
   NkMLdHewmLvnMMYAwvdqNI3hogkVLPMKiV1i614MQFjDOVQHSTmyjf9Y6
   ITqrRIXeZsADuaF1AwV4n6EjFISEUrmVRlrEUINrV73doL7SzwwUXllwg
   6mBmYUVdwOTqMVjheoH8oXlup2LQl/s9uwdsLhjJm9DtOFquo4eF2SJWu
   +GE9eyEG2FTA7JsBK6cyzKOSzPCZg4EXF1v6hDXNA0zHNB8ckBcIIdd1M
   nbF1saJtLmnLgr5pxbz43629k6AMfYAfLvPyh+Ip3wFNM2ZQE9D72ToGE
   w==;
IronPort-SDR: kYOGqRBc3cKms3pWJwWEtqR4GGzfxu48uSdmDxeQBd/TcMT6FykuhbE33dUDHctBVcdjnFhIna
 1KyPRFyBtFW10ThcwrhCzy7fHja3G+fmezLWhtbiO6E0JcjNtod3mnwkYLNmlw0YmrrDnI0R4g
 jRMbsGjpK0CtSdz982UNTyPcL20viNfUfkZzjeJZvzvmfdN/wmP02y9sNSbDDfrS0tDNNP7QQ7
 OcftoEwCRpq5OSt5k/LNfasuLFntCRWn/idSqeqOAaKdog0IEvtm6HTsI7/ew76XZngnt8nBuU
 mB0=
X-IronPort-AV: E=Sophos;i="5.75,378,1589266800"; 
   d="scan'208";a="82644333"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Jul 2020 03:05:10 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 21 Jul 2020 03:05:09 -0700
Received: from rob-ult-m19940.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 21 Jul 2020 03:04:06 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <robh+dt@kernel.org>,
        <alexandre.belloni@bootlin.com>, <ludovic.desroches@microchip.com>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>
Subject: [PATCH net-next 3/7] net: macb: parse PHY nodes found under an MDIO node
Date:   Tue, 21 Jul 2020 13:02:30 +0300
Message-ID: <20200721100234.1302910-4-codrin.ciubotariu@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721100234.1302910-1-codrin.ciubotariu@microchip.com>
References: <20200721100234.1302910-1-codrin.ciubotariu@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MACB embeds an MDIO bus controller. For this reason, the PHY nodes
were represented as sub-nodes in the MACB node. Generally, the
Ethernet controller is different than the MDIO controller, so the PHYs
are probed by a separate MDIO driver. Since adding the PHY nodes directly
under the ETH node became deprecated, we adjust the MACB driver to look
for an MDIO node and register the subnode MDIO devices.

Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 89fe7af5e408..66f02c16cc7c 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -740,10 +740,20 @@ static int macb_mii_probe(struct net_device *dev)
 static int macb_mdiobus_register(struct macb *bp)
 {
 	struct device_node *child, *np = bp->pdev->dev.of_node;
+	struct device_node *mdio_node;
+	int ret;
 
 	if (of_phy_is_fixed_link(np))
 		return mdiobus_register(bp->mii_bus);
 
+	/* if an MDIO node is present, it should contain the PHY nodes */
+	mdio_node = of_get_child_by_name(np, "mdio");
+	if (mdio_node) {
+		ret = of_mdiobus_register(bp->mii_bus, mdio_node);
+		of_node_put(mdio_node);
+		return ret;
+	}
+
 	/* Only create the PHY from the device tree if at least one PHY is
 	 * described. Otherwise scan the entire MDIO bus. We do this to support
 	 * old device tree that did not follow the best practices and did not
@@ -755,7 +765,6 @@ static int macb_mdiobus_register(struct macb *bp)
 			 * decrement it before returning.
 			 */
 			of_node_put(child);
-
 			return of_mdiobus_register(bp->mii_bus, np);
 		}
 
-- 
2.25.1

