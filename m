Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F317814F718
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 08:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgBAHqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 02:46:36 -0500
Received: from foss.arm.com ([217.140.110.172]:41130 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgBAHqf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Feb 2020 02:46:35 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A3E611D4;
        Fri, 31 Jan 2020 23:46:35 -0800 (PST)
Received: from u200856.usa.arm.com (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C0CF63F52E;
        Fri, 31 Jan 2020 23:50:13 -0800 (PST)
From:   Jeremy Linton <jeremy.linton@arm.com>
To:     netdev@vger.kernel.org
Cc:     opendmb@gmail.com, f.fainelli@gmail.com, davem@davemloft.net,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, wahrenst@gmx.net, andrew@lunn.ch,
        hkallweit1@gmail.com, Jeremy Linton <jeremy.linton@arm.com>
Subject: [PATCH 2/6] net: bcmgenet: refactor phy mode configuration
Date:   Sat,  1 Feb 2020 01:46:21 -0600
Message-Id: <20200201074625.8698-3-jeremy.linton@arm.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201074625.8698-1-jeremy.linton@arm.com>
References: <20200201074625.8698-1-jeremy.linton@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DT phy mode is similar to what we want for ACPI
lets factor it out of the of path, and change the
of_ call to device_. Further if the phy-mode property
cannot be found instead of failing the driver load lets
just default it to RGMII.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
---
 drivers/net/ethernet/broadcom/genet/bcmmii.c | 39 +++++++++++---------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 6392a2530183..2049f8218589 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -477,12 +477,30 @@ static int bcmgenet_mii_register(struct bcmgenet_priv *priv)
 	return ret;
 }
 
+static int bcmgenet_phy_interface_init(struct bcmgenet_priv *priv)
+{
+	struct device *kdev = &priv->pdev->dev;
+
+	priv->phy_interface = device_get_phy_mode(kdev);
+	if (priv->phy_interface < 0) {
+		dev_dbg(kdev, "invalid PHY mode property\n");
+		priv->phy_interface = PHY_INTERFACE_MODE_RGMII;
+	}
+
+	/* We need to specifically look up whether this PHY interface is internal
+	 * or not *before* we even try to probe the PHY driver over MDIO as we
+	 * may have shut down the internal PHY for power saving purposes.
+	 */
+	if (priv->phy_interface == PHY_INTERFACE_MODE_INTERNAL)
+		priv->internal_phy = true;
+
+	return 0;
+}
+
 static int bcmgenet_mii_of_init(struct bcmgenet_priv *priv)
 {
 	struct device_node *dn = priv->pdev->dev.of_node;
-	struct device *kdev = &priv->pdev->dev;
 	struct phy_device *phydev;
-	phy_interface_t phy_mode;
 	int ret;
 
 	/* Fetch the PHY phandle */
@@ -500,23 +518,10 @@ static int bcmgenet_mii_of_init(struct bcmgenet_priv *priv)
 	}
 
 	/* Get the link mode */
-	ret = of_get_phy_mode(dn, &phy_mode);
-	if (ret) {
-		dev_err(kdev, "invalid PHY mode property\n");
-		return ret;
-	}
-
-	priv->phy_interface = phy_mode;
-
-	/* We need to specifically look up whether this PHY interface is internal
-	 * or not *before* we even try to probe the PHY driver over MDIO as we
-	 * may have shut down the internal PHY for power saving purposes.
-	 */
-	if (priv->phy_interface == PHY_INTERFACE_MODE_INTERNAL)
-		priv->internal_phy = true;
+	bcmgenet_phy_interface_init(priv);
 
 	/* Make sure we initialize MoCA PHYs with a link down */
-	if (phy_mode == PHY_INTERFACE_MODE_MOCA) {
+	if (priv->phy_interface == PHY_INTERFACE_MODE_MOCA) {
 		phydev = of_phy_find_device(dn);
 		if (phydev) {
 			phydev->link = 0;
-- 
2.24.1

