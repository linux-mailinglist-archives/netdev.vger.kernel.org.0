Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C69C43E2A8
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhJ1Ny1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:54:27 -0400
Received: from mslow1.mail.gandi.net ([217.70.178.240]:58431 "EHLO
        mslow1.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbhJ1NyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 09:54:22 -0400
Received: from relay9-d.mail.gandi.net (unknown [217.70.183.199])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 7AC1EC5142;
        Thu, 28 Oct 2021 13:51:27 +0000 (UTC)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id A81E6FF816;
        Thu, 28 Oct 2021 13:51:02 +0000 (UTC)
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
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] net: ocelot: add support to get mac from device-tree
Date:   Thu, 28 Oct 2021 15:49:30 +0200
Message-Id: <20211028134932.658167-2-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211028134932.658167-1-clement.leger@bootlin.com>
References: <20211028134932.658167-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to get mac from device-tree using of_get_mac_address.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index d51f799e4e86..c39118e5b3ee 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -526,7 +526,10 @@ static int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops)
 
 	ocelot_pll5_init(ocelot);
 
-	eth_random_addr(ocelot->base_mac);
+	ret = of_get_mac_address(ocelot->dev->of_node, ocelot->base_mac);
+	if (ret)
+		eth_random_addr(ocelot->base_mac);
+
 	ocelot->base_mac[5] &= 0xf0;
 
 	return 0;
-- 
2.33.0

