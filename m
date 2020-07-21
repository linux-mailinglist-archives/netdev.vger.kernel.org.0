Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D582E228729
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbgGURTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:19:02 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:35316 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728306AbgGURTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:19:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595351941; x=1626887941;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ezYFKCqH/5hy28icqYteFOzwEiGJTFlqWA/30ubs58w=;
  b=Tf0eOfWTAe+nXgReySOrJxOjdKZcYw1yy9iUbWuln0iZ1VdCaGpYeIDB
   rYw1QfdZenhJncXp24jCa78baW2vvGqpNqo+xiyDpMEq0KtQyovUb/iDE
   TnzN+jXrLzpue05zWVoYLZv0hGCAqAGrTLyyuvf1fwjRx5WT1X4kDxFhn
   CAbpoMh/tC7vEuHM7CWqdGajHNwQmmn09lCHBCS2MSfuXLwu3UXFT2YZ1
   O6fJMIdkdoM46g81ROeRDMZ3Uw4yU3eLyut5fe1YywycOz2oLHQ/4q8p4
   XKOhiP346LdxWpEmSV3gIlMR9y+L7/u0t4kcWzF+6UGc8GGc+v6dtlg0i
   w==;
IronPort-SDR: JSYWO+OjTE4pFjk0/3Pe4owm1/AghDIxxkkQmcAKbcTKh0Ls39YkO08aG1JAwt1CE0rLcrpVWz
 XfOi3+3Hi8S7fi2VqbcbZDl6UYPP6wvWlwdRITeTFSoafBcHvyoyHKGgii/PWZgxsT1Oa9brEu
 8/rgCbBoZ/+YaCKcPmH4J8giOhv1xuZJRGMZlUUyopFn7wHiTWcYNnNV6TvsLYbXIeG9uzUf+B
 zQaAOZKih9MSfhkAP8ZNCaCbW1ZsiNXcjsC606LXlGHLoE502JDYrAcSM4rRzfw7wZbmsKJrk0
 EMM=
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="82697502"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Jul 2020 10:19:00 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 21 Jul 2020 10:18:23 -0700
Received: from rob-ult-m19940.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 21 Jul 2020 10:17:34 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <robh+dt@kernel.org>,
        <alexandre.belloni@bootlin.com>, <ludovic.desroches@microchip.com>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>
Subject: [PATCH net-next v2 3/7] net: macb: parse PHY nodes found under an MDIO node
Date:   Tue, 21 Jul 2020 20:13:12 +0300
Message-ID: <20200721171316.1427582-4-codrin.ciubotariu@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721171316.1427582-1-codrin.ciubotariu@microchip.com>
References: <20200721171316.1427582-1-codrin.ciubotariu@microchip.com>
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

Changes in v2:
 - readded newline removed by mistake;

 drivers/net/ethernet/cadence/macb_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 89fe7af5e408..b25c64b45148 100644
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
-- 
2.25.1

