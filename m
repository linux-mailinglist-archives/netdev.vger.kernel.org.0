Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA3612940B
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 11:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfLWKO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 05:14:27 -0500
Received: from inva020.nxp.com ([92.121.34.13]:51738 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbfLWKO0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Dec 2019 05:14:26 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 60F021A1248;
        Mon, 23 Dec 2019 11:14:23 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 547FC1A1235;
        Mon, 23 Dec 2019 11:14:23 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id C8AC72033F;
        Mon, 23 Dec 2019 11:14:22 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, linux@armlinux.org.uk,
        andrew@lunn.ch
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, shawnguo@kernel.org,
        leoyang.li@nxp.com, devicetree@vger.kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH net-next v2 3/7] net: fsl/fman: add support for PHY_INTERFACE_MODE_XFI
Date:   Mon, 23 Dec 2019 12:14:09 +0200
Message-Id: <1577096053-20507-4-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1577096053-20507-1-git-send-email-madalin.bucur@oss.nxp.com>
References: <1577096053-20507-1-git-send-email-madalin.bucur@oss.nxp.com>
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@oss.nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support in the code for the XFI PHY interface mode. Although
the interfaces did not use XGMII, the device trees described the
interface type as XGMII and the code was written with XGMI as an
indicator for 10G. The patch does not remove XGMII as a transition
time will be required until the device trees, fix-ups performed
by bootloaders are all aligned.

Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
---
 drivers/net/ethernet/freescale/fman/fman_memac.c | 4 +++-
 drivers/net/ethernet/freescale/fman/mac.c        | 8 +++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index e1901874c19f..d0b12efadd6c 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -439,6 +439,7 @@ static int init(struct memac_regs __iomem *regs, struct memac_cfg *cfg,
 	/* IF_MODE */
 	tmp = 0;
 	switch (phy_if) {
+	case PHY_INTERFACE_MODE_XFI:
 	case PHY_INTERFACE_MODE_XGMII:
 		tmp |= IF_MODE_10G;
 		break;
@@ -454,7 +455,8 @@ static int init(struct memac_regs __iomem *regs, struct memac_cfg *cfg,
 
 	/* TX_FIFO_SECTIONS */
 	tmp = 0;
-	if (phy_if == PHY_INTERFACE_MODE_XGMII) {
+	if (phy_if == PHY_INTERFACE_MODE_XFI ||
+	    phy_if == PHY_INTERFACE_MODE_XGMII) {
 		if (slow_10g_if) {
 			tmp |= (TX_FIFO_SECTIONS_TX_AVAIL_SLOW_10G |
 				TX_FIFO_SECTIONS_TX_EMPTY_DEFAULT_10G);
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index f0806ace1ae2..2944188c19b3 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -221,7 +221,7 @@ static int memac_initialization(struct mac_device *mac_dev)
 	set_fman_mac_params(mac_dev, &params);
 
 	if (priv->max_speed == SPEED_10000)
-		params.phy_if = PHY_INTERFACE_MODE_XGMII;
+		params.phy_if = PHY_INTERFACE_MODE_XFI;
 
 	mac_dev->fman_mac = memac_config(&params);
 	if (!mac_dev->fman_mac) {
@@ -540,7 +540,8 @@ static const u16 phy2speed[] = {
 	[PHY_INTERFACE_MODE_RGMII_TXID]	= SPEED_1000,
 	[PHY_INTERFACE_MODE_RTBI]		= SPEED_1000,
 	[PHY_INTERFACE_MODE_QSGMII]		= SPEED_1000,
-	[PHY_INTERFACE_MODE_XGMII]		= SPEED_10000
+	[PHY_INTERFACE_MODE_XGMII]		= SPEED_10000,
+	[PHY_INTERFACE_MODE_XFI]		= SPEED_10000,
 };
 
 static struct platform_device *dpaa_eth_add_device(int fman_id,
@@ -798,7 +799,8 @@ static int mac_probe(struct platform_device *_of_dev)
 		mac_dev->if_support |= SUPPORTED_1000baseT_Full;
 
 	/* The 10G interface only supports one mode */
-	if (mac_dev->phy_if == PHY_INTERFACE_MODE_XGMII)
+	if (mac_dev->phy_if == PHY_INTERFACE_MODE_XFI ||
+	    mac_dev->phy_if == PHY_INTERFACE_MODE_XGMII)
 		mac_dev->if_support = SUPPORTED_10000baseT_Full;
 
 	/* Get the rest of the PHY information */
-- 
2.1.0

