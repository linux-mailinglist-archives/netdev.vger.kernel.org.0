Return-Path: <netdev+bounces-5622-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FE01712459
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:16:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BE14281704
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:16:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 561CD156DF;
	Fri, 26 May 2023 10:14:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0B3168C4
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:14:59 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55690A9
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=y2g6Xwli6qRJUIXihphD722Io5yxSfEJ9CpTNYMQB0M=; b=08XTIlB5WE+PGZbul/XVLUgeRS
	Oqd0ETZkZhrIdF97TSHLirnpSyhoyHXp0BzPq3lfP8Ol1FafhtMU837Nm7vP28zo0myQhs1M/lYjd
	vlFZN02T6RTXetvqEj+tArGMV0bvxdOFntXF+4TMSCHkzdW8FJeXo+HxoiuMXPwxfQsEg0diJrY7y
	r8aqQ0Lr8VyzBsw6qpQ/zFvhVBX8GaUuC5ieRtFhGFZWT45LRLUc1C4pGy2tuybi9D+QzevRrg4RX
	0el+peGpLpZYPET+Jn4mDWCJjmmWxvMCNhQK+X2kCFJXreYxvd2n1fIt8+Dvn4Vxx0ELrZe/uGBI1
	K9fDDxBg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:41920 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q2UT7-0005Q6-JX; Fri, 26 May 2023 11:14:45 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q2UT6-008PAm-UO; Fri, 26 May 2023 11:14:44 +0100
In-Reply-To: <ZHCGZ8IgAAwr8bla@shell.armlinux.org.uk>
References: <ZHCGZ8IgAAwr8bla@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: Jiawen Wu <jiawenwu@trustnetic.com>,
	 Maxime Chevallier <maxime.chevallier@bootlin.com>,
	 Simon Horman <simon.horman@corigine.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	UNGLinuxDriver@microchip.com,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: [PATCH net-next 5/6] net: dsa: ocelot: use lynx_pcs_create_mdiodev()
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q2UT6-008PAm-UO@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 26 May 2023 11:14:44 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Use the newly introduced lynx_pcs_create_mdiodev() which simplifies the
creation and destruction of the lynx PCS.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 20 ++++----------------
 drivers/net/dsa/ocelot/seville_vsc9953.c | 20 ++++----------------
 2 files changed, 8 insertions(+), 32 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index cfb3faeaa5bf..030738fef60e 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1021,7 +1021,6 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 	for (port = 0; port < felix->info->num_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
 		struct phylink_pcs *phylink_pcs;
-		struct mdio_device *mdio_device;
 
 		if (dsa_is_unused_port(felix->ds, port))
 			continue;
@@ -1029,16 +1028,10 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 		if (ocelot_port->phy_mode == PHY_INTERFACE_MODE_INTERNAL)
 			continue;
 
-		mdio_device = mdio_device_create(felix->imdio, port);
-		if (IS_ERR(mdio_device))
+		phylink_pcs = lynx_pcs_create_mdiodev(felix->imdio, port);
+		if (IS_ERR(phylink_pcs))
 			continue;
 
-		phylink_pcs = lynx_pcs_create(mdio_device);
-		if (!phylink_pcs) {
-			mdio_device_free(mdio_device);
-			continue;
-		}
-
 		felix->pcs[port] = phylink_pcs;
 
 		dev_info(dev, "Found PCS at internal MDIO address %d\n", port);
@@ -1054,14 +1047,9 @@ static void vsc9959_mdio_bus_free(struct ocelot *ocelot)
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
 		struct phylink_pcs *phylink_pcs = felix->pcs[port];
-		struct mdio_device *mdio_device;
-
-		if (!phylink_pcs)
-			continue;
 
-		mdio_device = lynx_get_mdio_device(phylink_pcs);
-		mdio_device_free(mdio_device);
-		lynx_pcs_destroy(phylink_pcs);
+		if (phylink_pcs)
+			lynx_pcs_destroy(phylink_pcs);
 	}
 	mdiobus_unregister(felix->imdio);
 	mdiobus_free(felix->imdio);
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 96d4972a62f0..15003b2af264 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -912,7 +912,6 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 	for (port = 0; port < felix->info->num_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
 		struct phylink_pcs *phylink_pcs;
-		struct mdio_device *mdio_device;
 		int addr = port + 4;
 
 		if (dsa_is_unused_port(felix->ds, port))
@@ -921,16 +920,10 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 		if (ocelot_port->phy_mode == PHY_INTERFACE_MODE_INTERNAL)
 			continue;
 
-		mdio_device = mdio_device_create(felix->imdio, addr);
-		if (IS_ERR(mdio_device))
+		phylink_pcs = lynx_pcs_create_mdiodev(felix->imdio, addr);
+		if (IS_ERR(phylink_pcs))
 			continue;
 
-		phylink_pcs = lynx_pcs_create(mdio_device);
-		if (!phylink_pcs) {
-			mdio_device_free(mdio_device);
-			continue;
-		}
-
 		felix->pcs[port] = phylink_pcs;
 
 		dev_info(dev, "Found PCS at internal MDIO address %d\n", addr);
@@ -946,14 +939,9 @@ static void vsc9953_mdio_bus_free(struct ocelot *ocelot)
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
 		struct phylink_pcs *phylink_pcs = felix->pcs[port];
-		struct mdio_device *mdio_device;
-
-		if (!phylink_pcs)
-			continue;
 
-		mdio_device = lynx_get_mdio_device(phylink_pcs);
-		mdio_device_free(mdio_device);
-		lynx_pcs_destroy(phylink_pcs);
+		if (phylink_pcs)
+			lynx_pcs_destroy(phylink_pcs);
 	}
 
 	/* mdiobus_unregister and mdiobus_free handled by devres */
-- 
2.30.2


