Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C1E28A3DF
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389494AbgJJWzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730671AbgJJTtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:49:32 -0400
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECA9C0613DA
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 02:11:26 -0700 (PDT)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4C7fKl4LJlz1rlx2;
        Sat, 10 Oct 2020 11:10:19 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4C7fKl3sjrz1qvgd;
        Sat, 10 Oct 2020 11:10:19 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 2wIJjjYbHTpo; Sat, 10 Oct 2020 11:10:18 +0200 (CEST)
X-Auth-Info: zf2KXFqrcwn+/dcRaTN9kTAavBiDboZw5OEFgCoxCZI=
Received: from desktop.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sat, 10 Oct 2020 11:10:18 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        "David S . Miller" <davem@davemloft.net>,
        NXP Linux Team <linux-imx@nxp.com>,
        Richard Leitner <richard.leitner@skidata.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH V2] net: fec: Fix phy_device lookup for phy_reset_after_clk_enable()
Date:   Sat, 10 Oct 2020 11:10:00 +0200
Message-Id: <20201010091000.33047-1-marex@denx.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The phy_reset_after_clk_enable() is always called with ndev->phydev,
however that pointer may be NULL even though the PHY device instance
already exists and is sufficient to perform the PHY reset.

This condition happens in fec_open(), where the clock must be enabled
first, then the PHY must be reset, and then the PHY IDs can be read
out of the PHY.

If the PHY still is not bound to the MAC, but there is OF PHY node
and a matching PHY device instance already, use the OF PHY node to
obtain the PHY device instance, and then use that PHY device instance
when triggering the PHY reset.

Fixes: 1b0a83ac04e3 ("net: fec: add phy_reset_after_clk_enable() support")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: NXP Linux Team <linux-imx@nxp.com>
Cc: Richard Leitner <richard.leitner@skidata.com>
Cc: Shawn Guo <shawnguo@kernel.org>
---
V2: - put_device() the phy_dev reference from of_phy_find_device()
    - Add additional explanation into the commit message
---
 drivers/net/ethernet/freescale/fec_main.c | 25 +++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 2d5433301843..8f7eca1e7716 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1912,6 +1912,27 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 	return ret;
 }
 
+static void fec_enet_phy_reset_after_clk_enable(struct net_device *ndev)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+	struct phy_device *phy_dev = ndev->phydev;
+
+	if (phy_dev) {
+		phy_reset_after_clk_enable(phy_dev);
+	} else if (fep->phy_node) {
+		/*
+		 * If the PHY still is not bound to the MAC, but there is
+		 * OF PHY node and a matching PHY device instance already,
+		 * use the OF PHY node to obtain the PHY device instance,
+		 * and then use that PHY device instance when triggering
+		 * the PHY reset.
+		 */
+		phy_dev = of_phy_find_device(fep->phy_node);
+		phy_reset_after_clk_enable(phy_dev);
+		put_device(&phy_dev->mdio.dev);
+	}
+}
+
 static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
@@ -1938,7 +1959,7 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 		if (ret)
 			goto failed_clk_ref;
 
-		phy_reset_after_clk_enable(ndev->phydev);
+		fec_enet_phy_reset_after_clk_enable(ndev);
 	} else {
 		clk_disable_unprepare(fep->clk_enet_out);
 		if (fep->clk_ptp) {
@@ -2987,7 +3008,7 @@ fec_enet_open(struct net_device *ndev)
 	 * phy_reset_after_clk_enable() before because the PHY wasn't probed.
 	 */
 	if (reset_again)
-		phy_reset_after_clk_enable(ndev->phydev);
+		fec_enet_phy_reset_after_clk_enable(ndev);
 
 	/* Probe and connect to PHY when open the interface */
 	ret = fec_enet_mii_probe(ndev);
-- 
2.28.0

