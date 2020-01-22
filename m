Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A70414561F
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 14:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730126AbgAVNU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 08:20:59 -0500
Received: from inva020.nxp.com ([92.121.34.13]:41748 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730117AbgAVNU4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 08:20:56 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 2C0FD1A3D33;
        Wed, 22 Jan 2020 14:20:55 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 1F9341A294D;
        Wed, 22 Jan 2020 14:20:55 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id CE60D205CD;
        Wed, 22 Jan 2020 14:20:54 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH net 3/3] net/fsl: treat fsl,erratum-a011043
Date:   Wed, 22 Jan 2020 15:20:29 +0200
Message-Id: <1579699229-5948-4-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1579699229-5948-1-git-send-email-madalin.bucur@oss.nxp.com>
References: <1579699229-5948-1-git-send-email-madalin.bucur@oss.nxp.com>
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@oss.nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When fsl,erratum-a011043 is set, adjust for erratum A011043:
MDIO reads to internal PCS registers may result in having
the MDIO_CFG[MDIO_RD_ER] bit set, even when there is no
error and read data (MDIO_DATA[MDIO_DATA]) is correct.
Software may get false read error when reading internal
PCS registers through MDIO. As a workaround, all internal
MDIO accesses should ignore the MDIO_CFG[MDIO_RD_ER] bit.

Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
---
 drivers/net/ethernet/freescale/xgmac_mdio.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index e03b30c60dcf..c82c85ef5fb3 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -49,6 +49,7 @@ struct tgec_mdio_controller {
 struct mdio_fsl_priv {
 	struct	tgec_mdio_controller __iomem *mdio_base;
 	bool	is_little_endian;
+	bool	has_a011043;
 };
 
 static u32 xgmac_read32(void __iomem *regs,
@@ -226,7 +227,8 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 		return ret;
 
 	/* Return all Fs if nothing was there */
-	if (xgmac_read32(&regs->mdio_stat, endian) & MDIO_STAT_RD_ER) {
+	if ((xgmac_read32(&regs->mdio_stat, endian) & MDIO_STAT_RD_ER) &&
+	    !priv->has_a011043) {
 		dev_err(&bus->dev,
 			"Error while reading PHY%d reg at %d.%hhu\n",
 			phy_id, dev_addr, regnum);
@@ -274,6 +276,9 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 	priv->is_little_endian = of_property_read_bool(pdev->dev.of_node,
 						       "little-endian");
 
+	priv->has_a011043 = of_property_read_bool(pdev->dev.of_node,
+						  "fsl,erratum-a011043");
+
 	ret = of_mdiobus_register(bus, np);
 	if (ret) {
 		dev_err(&pdev->dev, "cannot register MDIO bus\n");
-- 
2.1.0

