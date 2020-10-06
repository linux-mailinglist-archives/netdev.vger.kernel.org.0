Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7E7284CB8
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 15:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgJFNxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 09:53:14 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:41223 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgJFNxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 09:53:14 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4C5Jnw4YFhz1rspt;
        Tue,  6 Oct 2020 15:53:00 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4C5Jnm1Y7Hz1qwT4;
        Tue,  6 Oct 2020 15:53:00 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id TtsYYhZY2xS2; Tue,  6 Oct 2020 15:52:58 +0200 (CEST)
X-Auth-Info: iWQF8c1W6m1epY4dXeLEFdBUOikZm3DN8gHuoKMApoQ=
Received: from desktop.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue,  6 Oct 2020 15:52:58 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Richard Leitner <richard.leitner@skidata.com>,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        "David S . Miller" <davem@davemloft.net>,
        NXP Linux Team <linux-imx@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH][RESEND] net: fec: Fix PHY init after phy_reset_after_clk_enable()
Date:   Tue,  6 Oct 2020 15:52:53 +0200
Message-Id: <20201006135253.97395-1-marex@denx.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The phy_reset_after_clk_enable() does a PHY reset, which means the PHY
loses its register settings. The fec_enet_mii_probe() starts the PHY
and does the necessary calls to configure the PHY via PHY framework,
and loads the correct register settings into the PHY. Therefore,
fec_enet_mii_probe() should be called only after the PHY has been
reset, not before as it is now.

Fixes: 1b0a83ac04e3 ("net: fec: add phy_reset_after_clk_enable() support")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Richard Leitner <richard.leitner@skidata.com>
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: NXP Linux Team <linux-imx@nxp.com>
Cc: Richard Leitner <richard.leitner@skidata.com>
Cc: Shawn Guo <shawnguo@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index c043afb38b6e..2d5433301843 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2983,17 +2983,17 @@ fec_enet_open(struct net_device *ndev)
 	/* Init MAC prior to mii bus probe */
 	fec_restart(ndev);
 
-	/* Probe and connect to PHY when open the interface */
-	ret = fec_enet_mii_probe(ndev);
-	if (ret)
-		goto err_enet_mii_probe;
-
 	/* Call phy_reset_after_clk_enable() again if it failed during
 	 * phy_reset_after_clk_enable() before because the PHY wasn't probed.
 	 */
 	if (reset_again)
 		phy_reset_after_clk_enable(ndev->phydev);
 
+	/* Probe and connect to PHY when open the interface */
+	ret = fec_enet_mii_probe(ndev);
+	if (ret)
+		goto err_enet_mii_probe;
+
 	if (fep->quirks & FEC_QUIRK_ERR006687)
 		imx6q_cpuidle_fec_irqs_used();
 
-- 
2.28.0

