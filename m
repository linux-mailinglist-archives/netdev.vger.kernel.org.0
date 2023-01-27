Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE1A67E6ED
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 14:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbjA0NlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 08:41:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbjA0NlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 08:41:06 -0500
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC4283498;
        Fri, 27 Jan 2023 05:40:42 -0800 (PST)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id C877CE0009;
        Fri, 27 Jan 2023 13:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1674826840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=N3geanatGOkfOmTjoq5leoCDPGbWHSLSPAA4X4PnxkM=;
        b=P/+OFCdjc2+VT6bp0fkrTjei1I6nCRYEraH0rjhcMyo5dbMujJLsX9QEm5VycTs22YmmM+
        Z7OfFLGvHszimzvgXMqhNSmxBYkAaLew/pr/Nn5qAhTz6JROaIush7LVIQO5RTaFSriGnP
        4QP4XHrcsRH/vJEs0TjcuWMAJSOI0jl+M6Ebm3rY6J8VmknI0jFPmPI/f1RL9+hxiJurWu
        6tqqOOzKVKp2VmaKyIZHXASVkwsLPoQvfUdANDTpJ6rUeJSDcZiby/pgrl+mBEV3F+ea8M
        1233p4/InRq3yCjzCN3aULMXJyZE/yrlJ90fWWEk64uZoXs3Lz6Mi/uQa2yXew==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com
Subject: [PATCH net-next] net: pcs: pcs-lynx: remove lynx_get_mdio_device() and refactor cleanup
Date:   Fri, 27 Jan 2023 14:40:30 +0100
Message-Id: <20230127134031.156143-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As of today, the lynx_get_mdio_device() function is only used during the
cleanup phase, to free the underlying mdio_device. This can be
factored inside lynx_pcs_destroy().

Part of the effort driving this is the merge of pcs-altera-tse into
pcs-lynx, as both have very similar register layouts. One of the main
difference is that the TSE pcs is memory-mapped, and the merge into
pcs-lynx would first require a conversion of pcs-lynx to regmap.

Removing lynx_get_mdio_device() makes pcs-lynx somewhat less
mdio-specific.

The following drivers have been trivialy modified to account for the
modification :
 - felix_vsc9959.c
 - seville_vsc9953.c
 - enetc_pf.c
 - fman_memac.c

For dpaa2-mac.c, the cleanup sequence used put_device(&mdio->dev), which
is exactly what mdio_device_free(mdio) does.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
Although this patch covers multiple drivers, it was kept as a single
patch to keep things bisectable. It was also only compile-tested, any
review and test is very welcome.

 drivers/net/dsa/ocelot/felix_vsc9959.c           |  3 ---
 drivers/net/dsa/ocelot/seville_vsc9953.c         |  3 ---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c |  4 ----
 drivers/net/ethernet/freescale/enetc/enetc_pf.c  |  8 ++------
 drivers/net/ethernet/freescale/fman/fman_memac.c |  4 ----
 drivers/net/pcs/pcs-lynx.c                       | 10 ++--------
 include/linux/pcs-lynx.h                         |  2 --
 7 files changed, 4 insertions(+), 30 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 43dc8ed4854d..1696d1eaa570 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1054,13 +1054,10 @@ static void vsc9959_mdio_bus_free(struct ocelot *ocelot)
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
 		struct phylink_pcs *phylink_pcs = felix->pcs[port];
-		struct mdio_device *mdio_device;
 
 		if (!phylink_pcs)
 			continue;
 
-		mdio_device = lynx_get_mdio_device(phylink_pcs);
-		mdio_device_free(mdio_device);
 		lynx_pcs_destroy(phylink_pcs);
 	}
 	mdiobus_unregister(felix->imdio);
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 88ed3a2e487a..0f7b947cb43b 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -946,13 +946,10 @@ static void vsc9953_mdio_bus_free(struct ocelot *ocelot)
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
 		struct phylink_pcs *phylink_pcs = felix->pcs[port];
-		struct mdio_device *mdio_device;
 
 		if (!phylink_pcs)
 			continue;
 
-		mdio_device = lynx_get_mdio_device(phylink_pcs);
-		mdio_device_free(mdio_device);
 		lynx_pcs_destroy(phylink_pcs);
 	}
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index c886f33f8c6f..c4733c46c896 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -284,11 +284,7 @@ static void dpaa2_pcs_destroy(struct dpaa2_mac *mac)
 	struct phylink_pcs *phylink_pcs = mac->pcs;
 
 	if (phylink_pcs) {
-		struct mdio_device *mdio = lynx_get_mdio_device(phylink_pcs);
-		struct device *dev = &mdio->dev;
-
 		lynx_pcs_destroy(phylink_pcs);
-		put_device(dev);
 		mac->pcs = NULL;
 	}
 }
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 7facc7d5261e..39940bd25b8d 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -915,13 +915,9 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 
 static void enetc_imdio_remove(struct enetc_pf *pf)
 {
-	struct mdio_device *mdio_device;
-
-	if (pf->pcs) {
-		mdio_device = lynx_get_mdio_device(pf->pcs);
-		mdio_device_free(mdio_device);
+	if (pf->pcs)
 		lynx_pcs_destroy(pf->pcs);
-	}
+
 	if (pf->imdio) {
 		mdiobus_unregister(pf->imdio);
 		mdiobus_free(pf->imdio);
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 9349f841bd06..555729c7c67e 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -976,14 +976,10 @@ static int memac_init(struct fman_mac *memac)
 
 static void pcs_put(struct phylink_pcs *pcs)
 {
-	struct mdio_device *mdiodev;
-
 	if (IS_ERR_OR_NULL(pcs))
 		return;
 
-	mdiodev = lynx_get_mdio_device(pcs);
 	lynx_pcs_destroy(pcs);
-	mdio_device_free(mdiodev);
 }
 
 static int memac_free(struct fman_mac *memac)
diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index 3903f3baba2b..4457298f7fb8 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -34,14 +34,6 @@ enum sgmii_speed {
 #define phylink_pcs_to_lynx(pl_pcs) container_of((pl_pcs), struct lynx_pcs, pcs)
 #define lynx_to_phylink_pcs(lynx) (&(lynx)->pcs)
 
-struct mdio_device *lynx_get_mdio_device(struct phylink_pcs *pcs)
-{
-	struct lynx_pcs *lynx = phylink_pcs_to_lynx(pcs);
-
-	return lynx->mdio;
-}
-EXPORT_SYMBOL(lynx_get_mdio_device);
-
 static void lynx_pcs_get_state_usxgmii(struct mdio_device *pcs,
 				       struct phylink_link_state *state)
 {
@@ -335,6 +327,8 @@ void lynx_pcs_destroy(struct phylink_pcs *pcs)
 {
 	struct lynx_pcs *lynx = phylink_pcs_to_lynx(pcs);
 
+	mdio_device_free(lynx->mdio);
+
 	kfree(lynx);
 }
 EXPORT_SYMBOL(lynx_pcs_destroy);
diff --git a/include/linux/pcs-lynx.h b/include/linux/pcs-lynx.h
index 5712cc2ce775..d8327323ddf7 100644
--- a/include/linux/pcs-lynx.h
+++ b/include/linux/pcs-lynx.h
@@ -9,8 +9,6 @@
 #include <linux/mdio.h>
 #include <linux/phylink.h>
 
-struct mdio_device *lynx_get_mdio_device(struct phylink_pcs *pcs);
-
 struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio);
 
 void lynx_pcs_destroy(struct phylink_pcs *pcs);
-- 
2.39.1

