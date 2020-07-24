Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB07422C3B9
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 12:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbgGXKu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 06:50:58 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:40568 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgGXKuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 06:50:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595587857; x=1627123857;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n4qDjdS4aJARjsbRK53YPMVPhwJsBHC7jGieRK5mseY=;
  b=1Y8ucun42+W51S+HFfCjzmUojzbMvBo5JlvKl/BTuLd8bfdDSep5wWrb
   SR+pff/8LxXrIfqkbVIlST20dqWZ5/X9SWWz+1SrIeerTAbeLlZIs39wK
   XCpp5468WiieASzZQ2sFrpSdaPZFhD/ytI8S947tXjUkGqXd5A8M9sxGa
   LyDH8gqSFvq9Pjs/zPGeIQOzdpyatflc7SOf49KYohUf1yiyJIktfNVzw
   z29Qovv4UNsQTCMV/RQfUOJTT2jKzdSBtF2Jj00C5F10PkmUP/EA6QPmJ
   PPp/9DZ6jYRmY3liyBGQZfcJq/Q1UOUkgakJNyixbC2G6JlDS50wro2z+
   A==;
IronPort-SDR: LcoYlfsVMsYNce8usGky2WRqwRCWrMe2Mmk81h9WnehE5loCzjBq4aQm+f6svT9dalOvI2u2eb
 QSumn23FEhXjQ2WL2/WD85aKgg1KpEzuqymhnoPrpG2T2++AN5Z+Z4aOr/WxSOvT60P9G4GXe0
 uSgvyZ4PdY8tYW7jEghXc+uH0DCKCvHidxbuqM9zPC5nVHGOL9i0k1DJOKo/cRsmQWPaBIg+2/
 O6kCBE53aQt2LuVTYL58D0ZbQ20ke9vggvaWN0NTWUdyMpK9JdDHJ0eimNbGn8oDCvitNWEbMs
 Cks=
X-IronPort-AV: E=Sophos;i="5.75,390,1589266800"; 
   d="scan'208";a="84467163"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jul 2020 03:50:56 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 24 Jul 2020 03:50:11 -0700
Received: from rob-ult-m19940.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 24 Jul 2020 03:50:09 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <robh+dt@kernel.org>,
        <alexandre.belloni@bootlin.com>, <ludovic.desroches@microchip.com>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>
Subject: [PATCH net-next v3 3/7] net: macb: parse PHY nodes found under an MDIO node
Date:   Fri, 24 Jul 2020 13:50:29 +0300
Message-ID: <20200724105033.2124881-4-codrin.ciubotariu@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200724105033.2124881-1-codrin.ciubotariu@microchip.com>
References: <20200724105033.2124881-1-codrin.ciubotariu@microchip.com>
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

Changes in v3:
 - moved the check for the mdio node at the beginnging of
   macb_mdiobus_register(). This way, the mdio devices will be probed even
   if macb is a fixed-link

Changes in v2:
 - readded newline removed by mistake;

 drivers/net/ethernet/cadence/macb_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 89fe7af5e408..cb0b3637651c 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -740,6 +740,16 @@ static int macb_mii_probe(struct net_device *dev)
 static int macb_mdiobus_register(struct macb *bp)
 {
 	struct device_node *child, *np = bp->pdev->dev.of_node;
+	struct device_node *mdio_node;
+	int ret;
+
+	/* if an MDIO node is present, it should contain the PHY nodes */
+	mdio_node = of_get_child_by_name(np, "mdio");
+	if (mdio_node) {
+		ret = of_mdiobus_register(bp->mii_bus, mdio_node);
+		of_node_put(mdio_node);
+		return ret;
+	}
 
 	if (of_phy_is_fixed_link(np))
 		return mdiobus_register(bp->mii_bus);
-- 
2.25.1

