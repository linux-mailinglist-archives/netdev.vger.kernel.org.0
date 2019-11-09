Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44DC7F5F4A
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 14:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfKINDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 08:03:40 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34689 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbfKINDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 08:03:38 -0500
Received: by mail-wr1-f66.google.com with SMTP id e6so10002573wrw.1
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 05:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zC0NABsuJFOx/yhlkJZKOp6j0qZL1JeQC/H+XJfkqzk=;
        b=XIoAi2gSJ5TOFA5f2TwXb9OY6YL9V3xEEIU/6O4WAlCwMabrAd6x5mczA572sxrjWk
         6KgZCHEdoxifj+dNSA/glBCV+dKPoN8j/h8zVButXZjBGLY5YFvGXRo8nUmmN4nVcy5u
         LLh5muo92JsM7oDOsjoB2yt7BodYmXozEvU8i1LPH05SOi+en3WKQ2WtDjiYo08WdCgD
         zAWFttnzGQyWX13o3Soz4fSnXHiFDbNMnau7iym20rNHKAgJ5Bfod8PHSB3FiQ+niwuC
         WINj4wakYMMs0S2AVTJYrzrYUKx4yQgOoL2sZiVYbkRuy1DOjCruIBgWkwKN2rDVqLoL
         NizA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zC0NABsuJFOx/yhlkJZKOp6j0qZL1JeQC/H+XJfkqzk=;
        b=KTZO2CS9jTx1tu8vwePMc/6De5+cEcsVkqBGda47E/2+QbGc49pI58HTAengxudLob
         l/XVaQDJEvQUrjSURWgVrlutoBhAmMzByJ43BUDwwWnSYCD4S58yS4D3+yvw9+H1YW8K
         T4JsbtstPRq18ekBHc5K4fcU5WUvOdz60OTDHwcQ3XUEAV2JZW7Y++S3YyAadMFuHYqQ
         1v5/VViNMd1ks+KtuLVRYw3gmSfOe3RVFbpGcCbvNjGOtmf+rCHJPO/+LvnxGJFXsQGd
         2tdMwG2xRMV7ALlCrnyE62cznOIGycaTg2qYQJ4voX2OsseNzdAbTAnQvyl2JDquDIWj
         j0cA==
X-Gm-Message-State: APjAAAWlQQpf+WFdCv6uk7rnGXNnccj+Y50CaFY61AuUyMOhUWZnmYAM
        3OtxcUjJxBPIJEYHv5npKTo=
X-Google-Smtp-Source: APXvYqww7nbZhixQUDUejEcL1Ga6XbAGgiQPGrnRPhYN39Rmt9DlWI8Z9S+w0lju6lnVR16CktjZIg==
X-Received: by 2002:adf:ba50:: with SMTP id t16mr6286431wrg.315.1573304616643;
        Sat, 09 Nov 2019 05:03:36 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id n13sm8370908wmi.25.2019.11.09.05.03.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 05:03:36 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 13/15] net: mscc: ocelot: refactor adjust_link into a netdev-independent function
Date:   Sat,  9 Nov 2019 15:02:59 +0200
Message-Id: <20191109130301.13716-14-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191109130301.13716-1-olteanv@gmail.com>
References: <20191109130301.13716-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This will be called from the Felix DSA frontend, which will work in
PHYLIB compatibility mode initially.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 4cb78e14f2fd..7f0bd89fc363 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -410,15 +410,13 @@ static u16 ocelot_wm_enc(u16 value)
 	return value;
 }
 
-static void ocelot_port_adjust_link(struct net_device *dev)
+static void ocelot_adjust_link(struct ocelot *ocelot, int port,
+			       struct phy_device *phydev)
 {
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot_port *ocelot_port = &priv->port;
-	struct ocelot *ocelot = ocelot_port->ocelot;
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	int speed, atop_wm, mode = 0;
-	u8 port = priv->chip_port;
 
-	switch (dev->phydev->speed) {
+	switch (phydev->speed) {
 	case SPEED_10:
 		speed = OCELOT_SPEED_10;
 		break;
@@ -434,14 +432,14 @@ static void ocelot_port_adjust_link(struct net_device *dev)
 		mode = DEV_MAC_MODE_CFG_GIGA_MODE_ENA;
 		break;
 	default:
-		netdev_err(dev, "Unsupported PHY speed: %d\n",
-			   dev->phydev->speed);
+		dev_err(ocelot->dev, "Unsupported PHY speed on port %d: %d\n",
+			port, phydev->speed);
 		return;
 	}
 
-	phy_print_status(dev->phydev);
+	phy_print_status(phydev);
 
-	if (!dev->phydev->link)
+	if (!phydev->link)
 		return;
 
 	/* Only full duplex supported for now */
@@ -536,6 +534,15 @@ static void ocelot_port_adjust_link(struct net_device *dev)
 	ocelot_write(ocelot, ocelot_wm_enc(atop_wm), SYS_ATOP_TOT_CFG);
 }
 
+static void ocelot_port_adjust_link(struct net_device *dev)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
+
+	ocelot_adjust_link(ocelot, port, dev->phydev);
+}
+
 static void ocelot_port_enable(struct ocelot *ocelot, int port,
 			       struct phy_device *phy)
 {
-- 
2.17.1

