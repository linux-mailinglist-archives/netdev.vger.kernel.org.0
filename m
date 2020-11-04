Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56DBF2A6684
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729975AbgKDOjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:39:44 -0500
Received: from smtprelay02.ispgateway.de ([80.67.31.36]:51251 "EHLO
        smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbgKDOjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 09:39:44 -0500
X-Greylist: delayed 725 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Nov 2020 09:39:43 EST
Received: from [89.1.81.74] (helo=mb-ubuntu.Ka-Ro.local)
        by smtprelay02.ispgateway.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92.3)
        (envelope-from <mb@karo-electronics.de>)
        id 1kaJVT-0000qC-4I; Wed, 04 Nov 2020 15:11:23 +0100
From:   Markus Bauer <mb@karo-electronics.de>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Markus Bauer <mb@karo-electronics.de>
Subject: [PATCH] net: stmmac: Don't log error message in case of -EPROBE_DEFER.
Date:   Wed,  4 Nov 2020 15:15:24 +0100
Message-Id: <20201104141524.13044-1-mb@karo-electronics.de>
X-Mailer: git-send-email 2.17.1
X-Df-Sender: bWJAa2Fyby1lbGVjdHJvbmljcy5kb21haW5mYWN0b3J5LWt1bmRlLmRl
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove error messages that might confuse users when error is just -517 / -EPROBE_DEFER.

[...]
imx-dwmac 30bf0000.ethernet: Cannot register the MDIO bus                                                                          
imx-dwmac 30bf0000.ethernet: stmmac_dvr_probe: MDIO bus (id: 0) registration failed
[...]

---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 7 ++++---
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 6 ++++--
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 33272a12989a..7d1cdd576b91 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4857,9 +4857,10 @@ int stmmac_dvr_probe(struct device *device,
 		/* MDIO bus Registration */
 		ret = stmmac_mdio_register(ndev);
 		if (ret < 0) {
-			dev_err(priv->device,
-				"%s: MDIO bus (id: %d) registration failed",
-				__func__, priv->plat->bus_id);
+			if (ret != -EPROBE_DEFER)
+				dev_err(priv->device,
+					"%s: MDIO bus (id: %d) registration failed, err=%d",
+					__func__, priv->plat->bus_id, ret);
 			goto error_mdio_register;
 		}
 	}
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 226e5a4bf21c..8e202f63da31 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -401,8 +401,10 @@ int stmmac_mdio_register(struct net_device *ndev)
 	new_bus->parent = priv->device;
 
 	err = of_mdiobus_register(new_bus, mdio_node);
-	if (err != 0) {
-		dev_err(dev, "Cannot register the MDIO bus\n");
+	if (err) {
+		if (err != -EPROBE_DEFER)
+			dev_err(dev,
+				"Cannot register the MDIO bus, err=%d\n", err);
 		goto bus_register_fail;
 	}
 
-- 
2.17.1

