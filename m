Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDB6E12659D
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 16:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfLSPVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 10:21:44 -0500
Received: from inva021.nxp.com ([92.121.34.21]:34200 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726908AbfLSPVj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 10:21:39 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id EC99D201107;
        Thu, 19 Dec 2019 16:21:37 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id DF09E20008E;
        Thu, 19 Dec 2019 16:21:37 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 56117203C8;
        Thu, 19 Dec 2019 16:21:37 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, shawnguo@kernel.org,
        devicetree@vger.kernel.org,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH 6/6] net: phy: aquantia: add support for PHY_INTERFACE_MODE_XFI
Date:   Thu, 19 Dec 2019 17:21:21 +0200
Message-Id: <1576768881-24971-7-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1576768881-24971-1-git-send-email-madalin.bucur@oss.nxp.com>
References: <1576768881-24971-1-git-send-email-madalin.bucur@oss.nxp.com>
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PHY_INTERFACE_MODE_10GKR was introduced as a catch-all
value for 10GBase-KR, XFI, SFI, to differentiate against XGMII.
The AQR PHYs support XFI as a PHY connection type, adding it
to the list of supported types. I'm not sure whether 10GBase-KR
is actually supported or not on the AQR devices so I'm not
touching that.

Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
---
 drivers/net/phy/aquantia_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 975789d9349d..688a637f1aba 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -358,9 +358,11 @@ static int aqr107_read_status(struct phy_device *phydev)
 
 	switch (FIELD_GET(MDIO_PHYXS_VEND_IF_STATUS_TYPE_MASK, val)) {
 	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_KR:
-	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_XFI:
 		phydev->interface = PHY_INTERFACE_MODE_10GKR;
 		break;
+	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_XFI:
+		phydev->interface = PHY_INTERFACE_MODE_XFI;
+		break;
 	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_USXGMII:
 		phydev->interface = PHY_INTERFACE_MODE_USXGMII;
 		break;
@@ -493,6 +495,7 @@ static int aqr107_config_init(struct phy_device *phydev)
 	    phydev->interface != PHY_INTERFACE_MODE_2500BASEX &&
 	    phydev->interface != PHY_INTERFACE_MODE_XGMII &&
 	    phydev->interface != PHY_INTERFACE_MODE_USXGMII &&
+	    phydev->interface != PHY_INTERFACE_MODE_XFI &&
 	    phydev->interface != PHY_INTERFACE_MODE_10GKR)
 		return -ENODEV;
 
-- 
2.1.0

