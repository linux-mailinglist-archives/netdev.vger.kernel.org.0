Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBFDE2246F8
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 01:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbgGQXc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 19:32:56 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:30531 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727946AbgGQXc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 19:32:56 -0400
X-Originating-IP: 90.65.108.121
Received: from localhost (lfbn-lyo-1-1676-121.w90-65.abo.wanadoo.fr [90.65.108.121])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 634BF240003;
        Fri, 17 Jul 2020 23:32:53 +0000 (UTC)
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: macb: use phy_interface_mode_is_rgmii everywhere
Date:   Sat, 18 Jul 2020 01:32:21 +0200
Message-Id: <20200717233221.840294-1-alexandre.belloni@bootlin.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is one RGMII check not using the phy_interface_mode_is_rgmii()
helper. This prevents the driver from configuring the MAC properly when
using a phy-mode that is not just rgmii, e.g. rgmii-rxid. This became an
issue on sama5d3 xplained since the ksz9031 driver is hadling phy-mode
properly and the phy-mode has to be set to rgmii-rxid.

Fixes: bcf3440c6dd78bfe ("net: phy: micrel: add phy-mode support for the KSZ9031 PHY")
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 52582e8ed90e..61d5b5744261 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3730,7 +3730,7 @@ static int macb_init(struct platform_device *pdev)
 
 	if (!(bp->caps & MACB_CAPS_USRIO_DISABLED)) {
 		val = 0;
-		if (bp->phy_interface == PHY_INTERFACE_MODE_RGMII)
+		if (phy_interface_mode_is_rgmii(bp->phy_interface))
 			val = GEM_BIT(RGMII);
 		else if (bp->phy_interface == PHY_INTERFACE_MODE_RMII &&
 			 (bp->caps & MACB_CAPS_USRIO_DEFAULT_IS_MII_GMII))
-- 
2.26.2

