Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF7C12940C
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 11:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfLWKO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 05:14:28 -0500
Received: from inva021.nxp.com ([92.121.34.21]:41968 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726834AbfLWKO0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Dec 2019 05:14:26 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 5025B200A44;
        Mon, 23 Dec 2019 11:14:25 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 42A65200338;
        Mon, 23 Dec 2019 11:14:25 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id C01AA2033F;
        Mon, 23 Dec 2019 11:14:24 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, linux@armlinux.org.uk,
        andrew@lunn.ch
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, shawnguo@kernel.org,
        leoyang.li@nxp.com, devicetree@vger.kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH net-next v2 4/7] net: fsl/fman: add support for PHY_INTERFACE_MODE_SFI
Date:   Mon, 23 Dec 2019 12:14:10 +0200
Message-Id: <1577096053-20507-5-git-send-email-madalin.bucur@oss.nxp.com>
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

Add support for the SFI PHY interface mode.

Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
---
 drivers/net/ethernet/freescale/fman/fman_memac.c | 2 ++
 drivers/net/ethernet/freescale/fman/mac.c        | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index d0b12efadd6c..09fdec935bf2 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -440,6 +440,7 @@ static int init(struct memac_regs __iomem *regs, struct memac_cfg *cfg,
 	tmp = 0;
 	switch (phy_if) {
 	case PHY_INTERFACE_MODE_XFI:
+	case PHY_INTERFACE_MODE_SFI:
 	case PHY_INTERFACE_MODE_XGMII:
 		tmp |= IF_MODE_10G;
 		break;
@@ -456,6 +457,7 @@ static int init(struct memac_regs __iomem *regs, struct memac_cfg *cfg,
 	/* TX_FIFO_SECTIONS */
 	tmp = 0;
 	if (phy_if == PHY_INTERFACE_MODE_XFI ||
+	    phy_if == PHY_INTERFACE_MODE_SFI ||
 	    phy_if == PHY_INTERFACE_MODE_XGMII) {
 		if (slow_10g_if) {
 			tmp |= (TX_FIFO_SECTIONS_TX_AVAIL_SLOW_10G |
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 2944188c19b3..5e6317742c38 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -542,6 +542,7 @@ static const u16 phy2speed[] = {
 	[PHY_INTERFACE_MODE_QSGMII]		= SPEED_1000,
 	[PHY_INTERFACE_MODE_XGMII]		= SPEED_10000,
 	[PHY_INTERFACE_MODE_XFI]		= SPEED_10000,
+	[PHY_INTERFACE_MODE_SFI]		= SPEED_10000,
 };
 
 static struct platform_device *dpaa_eth_add_device(int fman_id,
@@ -800,6 +801,7 @@ static int mac_probe(struct platform_device *_of_dev)
 
 	/* The 10G interface only supports one mode */
 	if (mac_dev->phy_if == PHY_INTERFACE_MODE_XFI ||
+	    mac_dev->phy_if == PHY_INTERFACE_MODE_SFI ||
 	    mac_dev->phy_if == PHY_INTERFACE_MODE_XGMII)
 		mac_dev->if_support = SUPPORTED_10000baseT_Full;
 
-- 
2.1.0

