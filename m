Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36EBF2CDC7
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 19:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbfE1Rkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 13:40:53 -0400
Received: from inva020.nxp.com ([92.121.34.13]:60202 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbfE1Rku (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 13:40:50 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 181D41A0FBD;
        Tue, 28 May 2019 19:40:49 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 093B61A0FB6;
        Tue, 28 May 2019 19:40:49 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 85081205F4;
        Tue, 28 May 2019 19:40:48 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     linux@armlinux.org.uk, f.fainelli@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, maxime.chevallier@bootlin.com,
        olteanv@gmail.com, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v2 net-next 03/11] net: phy: Check against net_device being NULL
Date:   Tue, 28 May 2019 20:38:09 +0300
Message-Id: <1559065097-31832-4-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1559065097-31832-1-git-send-email-ioana.ciornei@nxp.com>
References: <1559065097-31832-1-git-send-email-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In general, we don't want MAC drivers calling phy_attach_direct with the
net_device being NULL. Add checks against this in all the functions
calling it: phy_attach() and phy_connect_direct().

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes in v2:
 - return directly -EINVAL instead of ERR_PTR(-EINVAL) in phy_connect_direct

 drivers/net/phy/phy_device.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index da3bf3f70d63..1b540ed9b326 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -948,6 +948,9 @@ int phy_connect_direct(struct net_device *dev, struct phy_device *phydev,
 {
 	int rc;
 
+	if (!dev)
+		return -EINVAL;
+
 	rc = phy_attach_direct(dev, phydev, phydev->dev_flags, interface);
 	if (rc)
 		return rc;
@@ -1307,6 +1310,9 @@ struct phy_device *phy_attach(struct net_device *dev, const char *bus_id,
 	struct device *d;
 	int rc;
 
+	if (!dev)
+		return ERR_PTR(-EINVAL);
+
 	/* Search the list of PHY devices on the mdio bus for the
 	 * PHY with the requested name
 	 */
-- 
1.9.1

