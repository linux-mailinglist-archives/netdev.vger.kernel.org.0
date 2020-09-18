Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD2B526EA47
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 03:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgIRBHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 21:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbgIRBHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 21:07:44 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A67C7C061788
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:07:43 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id j2so4375025eds.9
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1K6K2kX/90zcOwuebs9D6IZKYCpdcRTuANTwmhEDVDE=;
        b=piNp1wQL/85Ieay00rT5vfEp+KeTqzdDEWc94DrfWOBKUk4IMax21+/EuVYz2LiT2l
         FvT/2cVdYJHW5BszOt9tdE4PN407GQ0bTJFhe6aDcLeV1IPWEoTSf+3UYCiekVYNSskj
         2mIjkFpt25zRFv52YEinT1hRBB3pUoDcC4Lt2bkU0GQjCQfuHdqQirDVVOfFwQrgjSXT
         6njirJ2BOmx4amnkLSjrthNpfHmDJO5PPzjIlrLdCqCevNusBaI70wHc0jHB76v7nDKd
         Fm8slIIFn5lJWIhJxGoxdANOC9TwlUUfvm06xEFstj9bt0u12ZaF6L9kvQz1nYSPwF8S
         SUjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1K6K2kX/90zcOwuebs9D6IZKYCpdcRTuANTwmhEDVDE=;
        b=EiWfanFtrMQE6XJ/Hg3w2iw+nh+BKQfymUEEhqk1eFEiu990ClvTtnzgSF/Hoik6EB
         /ODOHBuHqgGe+iG8J5aPKooAPCO+JJzluFCrR0PmNnfyV0Xv3Pq7SnDZQKcg9KE6KvF5
         uQPfyuFlYsy1aG1RRxVh+AoGgqRe+wx/5lqIcxJjBdkUwEElSl98pC2FO7NhSnumGvXN
         DeNGFHhVz1WiodIY+OdAgQmt6NfOa332mnE/roWLALEprP4uwzD/wSqhy0tcynKNapOX
         aQJVkhsHqCDxwH4o7rGFepH572gSZtnXs3VTrj1S1z6GdYi/6hfVrhnrcrxpGTVem1RH
         2JRw==
X-Gm-Message-State: AOAM532Pl7zeal/Q/56lnSuYTxQuh5o4lYNUx6Ldjcns0heEo2zO2NMU
        MuMMBE9I6U/RHo+u3jTRXp8=
X-Google-Smtp-Source: ABdhPJycuD0k1IuVNRuZXKkWyJOjGT/2aFYWC1enbGo4m3K4PKbquoLuELBhobomJab1R3T7qRlj7A==
X-Received: by 2002:aa7:dd0d:: with SMTP id i13mr36363075edv.314.1600391262350;
        Thu, 17 Sep 2020 18:07:42 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id g20sm1068591ejx.12.2020.09.17.18.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 18:07:41 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH v2 net 6/8] net: mscc: ocelot: refactor ports parsing code into a dedicated function
Date:   Fri, 18 Sep 2020 04:07:28 +0300
Message-Id: <20200918010730.2911234-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918010730.2911234-1-olteanv@gmail.com>
References: <20200918010730.2911234-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

mscc_ocelot_probe() is already pretty large and hard to follow. So move
the code for parsing ports in a separate function.

This makes it easier for the next patch to just call
mscc_ocelot_release_ports from the error path of mscc_ocelot_init_ports.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
Changes in v2:
Keep a reference to the 'ports' OF node at caller side, in
mscc_ocelot_probe, because we need to populate ocelot->num_phys_ports
early. The ocelot_init() function depends on it being set correctly.

 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 209 +++++++++++----------
 1 file changed, 110 insertions(+), 99 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index a1cbb20a7757..ff4a01424953 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -896,11 +896,115 @@ static struct ptp_clock_info ocelot_ptp_clock_info = {
 	.enable		= ocelot_ptp_enable,
 };
 
+static int mscc_ocelot_init_ports(struct platform_device *pdev,
+				  struct device_node *ports)
+{
+	struct ocelot *ocelot = platform_get_drvdata(pdev);
+	struct device_node *portnp;
+	int err;
+
+	ocelot->ports = devm_kcalloc(ocelot->dev, ocelot->num_phys_ports,
+				     sizeof(struct ocelot_port *), GFP_KERNEL);
+	if (!ocelot->ports)
+		return -ENOMEM;
+
+	/* No NPI port */
+	ocelot_configure_cpu(ocelot, -1, OCELOT_TAG_PREFIX_NONE,
+			     OCELOT_TAG_PREFIX_NONE);
+
+	for_each_available_child_of_node(ports, portnp) {
+		struct ocelot_port_private *priv;
+		struct ocelot_port *ocelot_port;
+		struct device_node *phy_node;
+		phy_interface_t phy_mode;
+		struct phy_device *phy;
+		struct regmap *target;
+		struct resource *res;
+		struct phy *serdes;
+		char res_name[8];
+		u32 port;
+
+		if (of_property_read_u32(portnp, "reg", &port))
+			continue;
+
+		snprintf(res_name, sizeof(res_name), "port%d", port);
+
+		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+						   res_name);
+		target = ocelot_regmap_init(ocelot, res);
+		if (IS_ERR(target))
+			continue;
+
+		phy_node = of_parse_phandle(portnp, "phy-handle", 0);
+		if (!phy_node)
+			continue;
+
+		phy = of_phy_find_device(phy_node);
+		of_node_put(phy_node);
+		if (!phy)
+			continue;
+
+		err = ocelot_probe_port(ocelot, port, target, phy);
+		if (err) {
+			of_node_put(portnp);
+			return err;
+		}
+
+		ocelot_port = ocelot->ports[port];
+		priv = container_of(ocelot_port, struct ocelot_port_private,
+				    port);
+
+		of_get_phy_mode(portnp, &phy_mode);
+
+		ocelot_port->phy_mode = phy_mode;
+
+		switch (ocelot_port->phy_mode) {
+		case PHY_INTERFACE_MODE_NA:
+			continue;
+		case PHY_INTERFACE_MODE_SGMII:
+			break;
+		case PHY_INTERFACE_MODE_QSGMII:
+			/* Ensure clock signals and speed is set on all
+			 * QSGMII links
+			 */
+			ocelot_port_writel(ocelot_port,
+					   DEV_CLOCK_CFG_LINK_SPEED
+					   (OCELOT_SPEED_1000),
+					   DEV_CLOCK_CFG);
+			break;
+		default:
+			dev_err(ocelot->dev,
+				"invalid phy mode for port%d, (Q)SGMII only\n",
+				port);
+			of_node_put(portnp);
+			return -EINVAL;
+		}
+
+		serdes = devm_of_phy_get(ocelot->dev, portnp, NULL);
+		if (IS_ERR(serdes)) {
+			err = PTR_ERR(serdes);
+			if (err == -EPROBE_DEFER)
+				dev_dbg(ocelot->dev, "deferring probe\n");
+			else
+				dev_err(ocelot->dev,
+					"missing SerDes phys for port%d\n",
+					port);
+
+			of_node_put(portnp);
+			return err;
+		}
+
+		priv->serdes = serdes;
+	}
+
+	return 0;
+}
+
 static int mscc_ocelot_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
-	struct device_node *ports, *portnp;
 	int err, irq_xtr, irq_ptp_rdy;
+	struct device_node *ports;
 	struct ocelot *ocelot;
 	struct regmap *hsio;
 	unsigned int i;
@@ -985,19 +1089,12 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 
 	ports = of_get_child_by_name(np, "ethernet-ports");
 	if (!ports) {
-		dev_err(&pdev->dev, "no ethernet-ports child node found\n");
+		dev_err(ocelot->dev, "no ethernet-ports child node found\n");
 		return -ENODEV;
 	}
 
 	ocelot->num_phys_ports = of_get_child_count(ports);
 
-	ocelot->ports = devm_kcalloc(&pdev->dev, ocelot->num_phys_ports,
-				     sizeof(struct ocelot_port *), GFP_KERNEL);
-	if (!ocelot->ports) {
-		err = -ENOMEM;
-		goto out_put_ports;
-	}
-
 	ocelot->vcap_is2_keys = vsc7514_vcap_is2_keys;
 	ocelot->vcap_is2_actions = vsc7514_vcap_is2_actions;
 	ocelot->vcap = vsc7514_vcap_props;
@@ -1006,6 +1103,10 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	if (err)
 		goto out_put_ports;
 
+	err = mscc_ocelot_init_ports(pdev, ports);
+	if (err)
+		goto out_put_ports;
+
 	if (ocelot->ptp) {
 		err = ocelot_init_timestamp(ocelot, &ocelot_ptp_clock_info);
 		if (err) {
@@ -1015,96 +1116,6 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 		}
 	}
 
-	/* No NPI port */
-	ocelot_configure_cpu(ocelot, -1, OCELOT_TAG_PREFIX_NONE,
-			     OCELOT_TAG_PREFIX_NONE);
-
-	for_each_available_child_of_node(ports, portnp) {
-		struct ocelot_port_private *priv;
-		struct ocelot_port *ocelot_port;
-		struct device_node *phy_node;
-		phy_interface_t phy_mode;
-		struct phy_device *phy;
-		struct regmap *target;
-		struct resource *res;
-		struct phy *serdes;
-		char res_name[8];
-		u32 port;
-
-		if (of_property_read_u32(portnp, "reg", &port))
-			continue;
-
-		snprintf(res_name, sizeof(res_name), "port%d", port);
-
-		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
-						   res_name);
-		target = ocelot_regmap_init(ocelot, res);
-		if (IS_ERR(target))
-			continue;
-
-		phy_node = of_parse_phandle(portnp, "phy-handle", 0);
-		if (!phy_node)
-			continue;
-
-		phy = of_phy_find_device(phy_node);
-		of_node_put(phy_node);
-		if (!phy)
-			continue;
-
-		err = ocelot_probe_port(ocelot, port, target, phy);
-		if (err) {
-			of_node_put(portnp);
-			goto out_put_ports;
-		}
-
-		ocelot_port = ocelot->ports[port];
-		priv = container_of(ocelot_port, struct ocelot_port_private,
-				    port);
-
-		of_get_phy_mode(portnp, &phy_mode);
-
-		ocelot_port->phy_mode = phy_mode;
-
-		switch (ocelot_port->phy_mode) {
-		case PHY_INTERFACE_MODE_NA:
-			continue;
-		case PHY_INTERFACE_MODE_SGMII:
-			break;
-		case PHY_INTERFACE_MODE_QSGMII:
-			/* Ensure clock signals and speed is set on all
-			 * QSGMII links
-			 */
-			ocelot_port_writel(ocelot_port,
-					   DEV_CLOCK_CFG_LINK_SPEED
-					   (OCELOT_SPEED_1000),
-					   DEV_CLOCK_CFG);
-			break;
-		default:
-			dev_err(ocelot->dev,
-				"invalid phy mode for port%d, (Q)SGMII only\n",
-				port);
-			of_node_put(portnp);
-			err = -EINVAL;
-			goto out_put_ports;
-		}
-
-		serdes = devm_of_phy_get(ocelot->dev, portnp, NULL);
-		if (IS_ERR(serdes)) {
-			err = PTR_ERR(serdes);
-			if (err == -EPROBE_DEFER)
-				dev_dbg(ocelot->dev, "deferring probe\n");
-			else
-				dev_err(ocelot->dev,
-					"missing SerDes phys for port%d\n",
-					port);
-
-			of_node_put(portnp);
-			goto out_put_ports;
-		}
-
-		priv->serdes = serdes;
-	}
-
 	register_netdevice_notifier(&ocelot_netdevice_nb);
 	register_switchdev_notifier(&ocelot_switchdev_nb);
 	register_switchdev_blocking_notifier(&ocelot_switchdev_blocking_nb);
-- 
2.25.1

