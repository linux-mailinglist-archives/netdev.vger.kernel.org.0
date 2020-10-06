Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45BB4285303
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 22:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgJFUVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 16:21:00 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:58670 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbgJFUVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 16:21:00 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4C5TPN6dgsz1sNct;
        Tue,  6 Oct 2020 22:20:52 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4C5TPJ0vhNz1qs0Y;
        Tue,  6 Oct 2020 22:20:52 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id QGYITmiRYlSz; Tue,  6 Oct 2020 22:20:50 +0200 (CEST)
X-Auth-Info: lb96z2gpHsz6lOfBzLPQt/y9Z/blGWQ7J+g2PxCG/6o=
Received: from desktop.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue,  6 Oct 2020 22:20:50 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        "David S . Miller" <davem@davemloft.net>,
        NXP Linux Team <linux-imx@nxp.com>,
        Richard Leitner <richard.leitner@skidata.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH] net: fec: Fix phy_device lookup for phy_reset_after_clk_enable()
Date:   Tue,  6 Oct 2020 22:20:29 +0200
Message-Id: <20201006202029.254212-1-marex@denx.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The phy_reset_after_clk_enable() is always called with ndev->phydev,
however that pointer may be NULL even though the PHY device instance
already exists and is sufficient to perform the PHY reset.

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
 drivers/net/ethernet/freescale/fec_main.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 2d5433301843..5a4b20941aeb 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1912,6 +1912,24 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 	return ret;
 }
 
+static void fec_enet_phy_reset_after_clk_enable(struct net_device *ndev)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+	struct phy_device *phy_dev = ndev->phydev;
+
+	/*
+	 * If the PHY still is not bound to the MAC, but there is
+	 * OF PHY node and a matching PHY device instance already,
+	 * use the OF PHY node to obtain the PHY device instance,
+	 * and then use that PHY device instance when triggering
+	 * the PHY reset.
+	 */
+	if (!phy_dev && fep->phy_node)
+		phy_dev = of_phy_find_device(fep->phy_node);
+
+	phy_reset_after_clk_enable(phy_dev);
+}
+
 static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
@@ -1938,7 +1956,7 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 		if (ret)
 			goto failed_clk_ref;
 
-		phy_reset_after_clk_enable(ndev->phydev);
+		fec_enet_phy_reset_after_clk_enable(ndev);
 	} else {
 		clk_disable_unprepare(fep->clk_enet_out);
 		if (fep->clk_ptp) {
@@ -2987,7 +3005,7 @@ fec_enet_open(struct net_device *ndev)
 	 * phy_reset_after_clk_enable() before because the PHY wasn't probed.
 	 */
 	if (reset_again)
-		phy_reset_after_clk_enable(ndev->phydev);
+		fec_enet_phy_reset_after_clk_enable(ndev);
 
 	/* Probe and connect to PHY when open the interface */
 	ret = fec_enet_mii_probe(ndev);
-- 
2.28.0

