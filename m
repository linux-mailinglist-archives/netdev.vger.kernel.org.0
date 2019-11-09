Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFA0F5F4D
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 14:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbfKINDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 08:03:45 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52012 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfKINDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 08:03:33 -0500
Received: by mail-wm1-f66.google.com with SMTP id q70so8821856wme.1
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 05:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pz7jCL0OncQl+ctY/keoi4YKSykPbYYoa7XcwtNUZko=;
        b=XrNTsoCefNNreY1BnIDCVnNEG85vIZ14SYXU/Lm20ycEjfGjc2PyumSNIoL62YubrL
         cZ4gRO3WQo8AYI2xrj6fkjNuETMHUwlA7tnd/gwWUhHeaIsFmFFJjTAptXm0vyCkh7AY
         j3aOCdZEM4ax9gHvN/WtgcSAn+oSEu925lb/i6Pz+j/8ygDB6IdYkmlAkDXRosYGnrur
         ID8ZWYVN5zmMyQVE8/Xl1XpNbc4dsvGTjnTPTVSRWbDIHGriQNDx+H8zelzfsHffVsfZ
         ZtRwoCIDZ4Wa1aqLKNvG/a21UGJKcarjtL3drNXOnSlH+4h2EkYWcYyNMQ68yjCziz4k
         HHNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pz7jCL0OncQl+ctY/keoi4YKSykPbYYoa7XcwtNUZko=;
        b=ImoBGTU4e5UPcj9en5DUcdOB2CcZMHYJEqov4T1Y+tMP8k4OmuQXSrV1iiAq4lRkgC
         UKL/rncYTx9WcoB/vCOy+QiR94e3y0vEIye9q0qIk5cQV+o6o5TrGkk6out4MiSIWpvK
         yaPj9VTJNF88Xro2jndeZnK2jfK1O+9swW0nFBv4WlciHvBeeLcJhDrciDuZXfREyhjo
         OBIgtzi7kpPRtD9zurPtdXg0cdItR+Sr93G+ZCURaiqPHAq0NEzB9j+WWqcGr74ttjBK
         65rwJdu0Y3xhiw8RRBbXGEUnGBWyaYg0ey1UIaB6jdI1xQwwSXRZQp0chLDoY7nRaQFC
         3GdQ==
X-Gm-Message-State: APjAAAVlIa2HZDkmek8mZMLHW9V8oAZWKOG1ogOgblvXTVWx0s+8TZ+i
        nuEwPcI3zgdKt8CFEp1VJzs=
X-Google-Smtp-Source: APXvYqxIHVHHuKJbj1H5bY5NiOxLMXPmc+ppTJxXJ5bNaVOVymU1aYirJaNd1Vyjs7xvasM5AR+UZA==
X-Received: by 2002:a1c:2dd0:: with SMTP id t199mr12152675wmt.58.1573304611804;
        Sat, 09 Nov 2019 05:03:31 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id n13sm8370908wmi.25.2019.11.09.05.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 05:03:30 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 10/15] net: mscc: ocelot: move port initialization into separate function
Date:   Sat,  9 Nov 2019 15:02:56 +0200
Message-Id: <20191109130301.13716-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191109130301.13716-1-olteanv@gmail.com>
References: <20191109130301.13716-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

We need a function for the DSA front-end that does none of the
net_device registration, but initializes the hardware ports.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 45 ++++++++++++++++--------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 107a07cfaec9..83ecbbd720fd 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2133,6 +2133,28 @@ static int ocelot_init_timestamp(struct ocelot *ocelot)
 	return 0;
 }
 
+static void ocelot_init_port(struct ocelot *ocelot, int port)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+	INIT_LIST_HEAD(&ocelot_port->skbs);
+
+	/* Basic L2 initialization */
+
+	/* Drop frames with multicast source address */
+	ocelot_rmw_gix(ocelot, ANA_PORT_DROP_CFG_DROP_MC_SMAC_ENA,
+		       ANA_PORT_DROP_CFG_DROP_MC_SMAC_ENA,
+		       ANA_PORT_DROP_CFG, port);
+
+	/* Set default VLAN and tag type to 8021Q. */
+	ocelot_rmw_gix(ocelot, REW_PORT_VLAN_CFG_PORT_TPID(ETH_P_8021Q),
+		       REW_PORT_VLAN_CFG_PORT_TPID_M,
+		       REW_PORT_VLAN_CFG, port);
+
+	/* Enable vcap lookups */
+	ocelot_vcap_enable(ocelot, port);
+}
+
 int ocelot_probe_port(struct ocelot *ocelot, u8 port,
 		      void __iomem *regs,
 		      struct phy_device *phy)
@@ -2140,7 +2162,6 @@ int ocelot_probe_port(struct ocelot *ocelot, u8 port,
 	struct ocelot_port_private *priv;
 	struct ocelot_port *ocelot_port;
 	struct net_device *dev;
-	u32 val;
 	int err;
 
 	dev = alloc_etherdev(sizeof(struct ocelot_port_private));
@@ -2168,32 +2189,14 @@ int ocelot_probe_port(struct ocelot *ocelot, u8 port,
 	ocelot_mact_learn(ocelot, PGID_CPU, dev->dev_addr, ocelot_port->pvid,
 			  ENTRYTYPE_LOCKED);
 
-	INIT_LIST_HEAD(&ocelot_port->skbs);
+	ocelot_init_port(ocelot, port);
 
 	err = register_netdev(dev);
 	if (err) {
 		dev_err(ocelot->dev, "register_netdev failed\n");
-		goto err_register_netdev;
+		free_netdev(dev);
 	}
 
-	/* Basic L2 initialization */
-
-	/* Drop frames with multicast source address */
-	val = ANA_PORT_DROP_CFG_DROP_MC_SMAC_ENA;
-	ocelot_rmw_gix(ocelot, val, val, ANA_PORT_DROP_CFG, port);
-
-	/* Set default VLAN and tag type to 8021Q. */
-	ocelot_rmw_gix(ocelot, REW_PORT_VLAN_CFG_PORT_TPID(ETH_P_8021Q),
-		       REW_PORT_VLAN_CFG_PORT_TPID_M,
-		       REW_PORT_VLAN_CFG, port);
-
-	/* Enable vcap lookups */
-	ocelot_vcap_enable(ocelot, port);
-
-	return 0;
-
-err_register_netdev:
-	free_netdev(dev);
 	return err;
 }
 EXPORT_SYMBOL(ocelot_probe_port);
-- 
2.17.1

