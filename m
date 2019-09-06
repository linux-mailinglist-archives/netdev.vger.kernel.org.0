Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6368ABA79
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 16:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394090AbfIFOPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 10:15:47 -0400
Received: from inva021.nxp.com ([92.121.34.21]:57800 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394076AbfIFOPr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 10:15:47 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A946B2007ED;
        Fri,  6 Sep 2019 16:15:45 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 9D0FD2005E3;
        Fri,  6 Sep 2019 16:15:45 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 6DD142061D;
        Fri,  6 Sep 2019 16:15:45 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     alexandru.marginean@nxp.com, netdev@vger.kernel.org
Subject: [PATCH net-next 1/5] enetc: Fix if_mode extraction
Date:   Fri,  6 Sep 2019 17:15:40 +0300
Message-Id: <1567779344-30965-2-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567779344-30965-1-git-send-email-claudiu.manoil@nxp.com>
References: <1567779344-30965-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix handling of error return code. Before this fix,
the error code was handled as unsigned type.
Also, on this path if if_mode not found then just handle
it as fixed link (i.e mac2mac connection).

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 7d6513ff8507..3a556646a2fb 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -751,6 +751,7 @@ static int enetc_of_get_phy(struct enetc_ndev_priv *priv)
 	struct enetc_pf *pf = enetc_si_priv(priv->si);
 	struct device_node *np = priv->dev->of_node;
 	struct device_node *mdio_np;
+	int phy_mode;
 	int err;
 
 	if (!np) {
@@ -784,17 +785,11 @@ static int enetc_of_get_phy(struct enetc_ndev_priv *priv)
 		}
 	}
 
-	priv->if_mode = of_get_phy_mode(np);
-	if (priv->if_mode < 0) {
-		dev_err(priv->dev, "missing phy type\n");
-		of_node_put(priv->phy_node);
-		if (of_phy_is_fixed_link(np))
-			of_phy_deregister_fixed_link(np);
-		else
-			enetc_mdio_remove(pf);
-
-		return -EINVAL;
-	}
+	phy_mode = of_get_phy_mode(np);
+	if (phy_mode < 0)
+		priv->if_mode = PHY_INTERFACE_MODE_NA; /* fixed link */
+	else
+		priv->if_mode = phy_mode;
 
 	return 0;
 }
-- 
2.17.1

