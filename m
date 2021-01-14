Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23F5F2F62E6
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 15:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729161AbhANORD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 09:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727206AbhANORB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 09:17:01 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C914C061794
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 06:15:53 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id u19so5872786edx.2
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 06:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DmWx3lMhRFMKjVamIPZY9jr+GlRZ4E5gCzkoqcH7u8w=;
        b=P+68Ezx/1O4m59EOiE6EmfG5qzmnO8vQ9mIn1mTtEPpC/UMAsdhldFKn/ftaZ3DbIC
         yeD0kfQUaHW5kBVimzgZ9vfePRDh19AbXUeC6Qy8V06uZIFSegntVqJd3uw/0tq4i+bj
         rqx1dcJEYYaKlQ5YU/dVWOxhmqSe6pg4C2bwDr7QD9DVJ9JHnAHVEYVaE/6vm+rWb/Tl
         YOr9CgDsGe12Xmuv9SF5GppbACRBeB+hhsZGgluk2ELvldbNa11vEwrzXKT5i/wzakSg
         cW26leMX4Bk35maiqMbpIw/biSGBM1C5bvhEelYW8WxSP/AvKAGRKou3eOx0sMTybHsq
         EJ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DmWx3lMhRFMKjVamIPZY9jr+GlRZ4E5gCzkoqcH7u8w=;
        b=oMqi8PVlbm3yNP1+hdH4eZytkot8Vx9CO5gOO0lg8ElHazf3r8vWNkR3cw9E++yXRQ
         SCsPXrnUtzheuW0ZnoObotQ1dXPAQRcgOVgPfIQsN1c7lhQdzPen9VDxKDyJaH62IzX7
         dFYM1stFfairvN1aNymwnXxm/p7f/f7bEl7YpBJuIbK61hPWhpbtrnaKgmqnqD0GNB/0
         IbV/3eqkPQYO2uBhf+vfoBICdFBwBqmHMy1GE8vgatwyJCWgXwzWtccwR0xHwHcPyGEb
         sdqFa1YDvGbbCGSjvhipHACvUapkLp5SnLnSdJrNQqeovVVHMjiwlVqkSHCYyG/cNrAY
         eY8A==
X-Gm-Message-State: AOAM533LINu6EE+vfO+a1r2dZtEDXT/FPGNGRDAJf/UW/kdus3XWi4OQ
        hKBu3WbwEQ8zKvKJCxJeXgM=
X-Google-Smtp-Source: ABdhPJyqH8VZ9Jy2+NAocFowiy7T/1KpME2bZp8ZF5EzbY41Gp+sJ9edXLAL0V/HB42Q4XspGDewpQ==
X-Received: by 2002:a05:6402:41:: with SMTP id f1mr5759973edu.286.1610633751964;
        Thu, 14 Jan 2021 06:15:51 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id hr3sm773535ejc.41.2021.01.14.06.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 06:15:51 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v5 net-next 08/10] net: mscc: ocelot: register devlink ports
Date:   Thu, 14 Jan 2021 16:15:20 +0200
Message-Id: <20210114141522.2478059-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210114141522.2478059-1-olteanv@gmail.com>
References: <20210114141522.2478059-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Add devlink integration into the mscc_ocelot switchdev driver. All
physical ports (i.e. the unused ones as well) except the CPU port module
at ocelot->num_phys_ports are registered with devlink, and that requires
keeping the devlink_port structure outside struct ocelot_port_private,
since the latter has a 1:1 mapping with a struct net_device (which does
not exist for unused ports).

Since we use devlink_port_type_eth_set to link the devlink port to the
net_device, we can as well remove the .ndo_get_phys_port_name and
.ndo_get_port_parent_id implementations, since devlink takes care of
retrieving the port name and number automatically, once
.ndo_get_devlink_port is implemented.

Note that the felix DSA driver is already integrated with devlink by
default, since that is a thing that the DSA core takes care of. This is
the reason why these devlink stubs were put in ocelot_net.c and not in
the common library. It is also the reason why ocelot::devlink is a
pointer and not a full structure embedded inside struct ocelot: because
the mscc_ocelot driver allocates that by itself (as the container of
struct ocelot, in fact), but in the case of felix, it is DSA who
allocates the devlink, and felix just propagates the pointer towards
struct ocelot.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v5:
Use devlink_alloc to allocate ocelot->devlink, as per Jakub's
suggestion.

Changes in v4:
- Register devlink ports before registering the net_devices.
- Register devlink ports for the unused ports too.
- More careful teardown path.

Changes in v3:
None.

Changes in v2:
Using devlink_port_type_eth_set as per Jiri's suggestion.

 drivers/net/ethernet/mscc/ocelot.h         |   5 +
 drivers/net/ethernet/mscc/ocelot_net.c     |  63 ++++++-----
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 121 ++++++++++++++++++---
 include/soc/mscc/ocelot.h                  |   2 +
 4 files changed, 147 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 519335676c24..de4dd62ef39e 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -121,6 +121,11 @@ void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
 
 int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 		      struct phy_device *phy);
+int ocelot_devlink_init(struct ocelot *ocelot);
+void ocelot_devlink_teardown(struct ocelot *ocelot);
+int ocelot_port_devlink_init(struct ocelot *ocelot, int port,
+			     enum devlink_port_flavour flavour);
+void ocelot_port_devlink_teardown(struct ocelot *ocelot, int port);
 
 extern struct notifier_block ocelot_netdevice_nb;
 extern struct notifier_block ocelot_switchdev_nb;
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 4fb9095be3ea..a97bf1ffc24a 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -8,6 +8,40 @@
 #include "ocelot.h"
 #include "ocelot_vcap.h"
 
+int ocelot_port_devlink_init(struct ocelot *ocelot, int port,
+			     enum devlink_port_flavour flavour)
+{
+	struct devlink_port *dlp = &ocelot->devlink_ports[port];
+	int id_len = sizeof(ocelot->base_mac);
+	struct devlink *dl = ocelot->devlink;
+	struct devlink_port_attrs attrs = {};
+
+	memcpy(attrs.switch_id.id, &ocelot->base_mac, id_len);
+	attrs.switch_id.id_len = id_len;
+	attrs.phys.port_number = port;
+	attrs.flavour = flavour;
+
+	devlink_port_attrs_set(dlp, &attrs);
+
+	return devlink_port_register(dl, dlp, port);
+}
+
+void ocelot_port_devlink_teardown(struct ocelot *ocelot, int port)
+{
+	struct devlink_port *dlp = &ocelot->devlink_ports[port];
+
+	devlink_port_unregister(dlp);
+}
+
+static struct devlink_port *ocelot_get_devlink_port(struct net_device *dev)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
+
+	return &ocelot->devlink_ports[port];
+}
+
 int ocelot_setup_tc_cls_flower(struct ocelot_port_private *priv,
 			       struct flow_cls_offload *f,
 			       bool ingress)
@@ -525,20 +559,6 @@ static void ocelot_set_rx_mode(struct net_device *dev)
 	__dev_mc_sync(dev, ocelot_mc_sync, ocelot_mc_unsync);
 }
 
-static int ocelot_port_get_phys_port_name(struct net_device *dev,
-					  char *buf, size_t len)
-{
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	int port = priv->chip_port;
-	int ret;
-
-	ret = snprintf(buf, len, "p%d", port);
-	if (ret >= len)
-		return -EINVAL;
-
-	return 0;
-}
-
 static int ocelot_port_set_mac_address(struct net_device *dev, void *p)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
@@ -689,18 +709,6 @@ static int ocelot_set_features(struct net_device *dev,
 	return 0;
 }
 
-static int ocelot_get_port_parent_id(struct net_device *dev,
-				     struct netdev_phys_item_id *ppid)
-{
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot *ocelot = priv->port.ocelot;
-
-	ppid->id_len = sizeof(ocelot->base_mac);
-	memcpy(&ppid->id, &ocelot->base_mac, ppid->id_len);
-
-	return 0;
-}
-
 static int ocelot_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
@@ -727,7 +735,6 @@ static const struct net_device_ops ocelot_port_netdev_ops = {
 	.ndo_stop			= ocelot_port_stop,
 	.ndo_start_xmit			= ocelot_port_xmit,
 	.ndo_set_rx_mode		= ocelot_set_rx_mode,
-	.ndo_get_phys_port_name		= ocelot_port_get_phys_port_name,
 	.ndo_set_mac_address		= ocelot_port_set_mac_address,
 	.ndo_get_stats64		= ocelot_get_stats64,
 	.ndo_fdb_add			= ocelot_port_fdb_add,
@@ -736,9 +743,9 @@ static const struct net_device_ops ocelot_port_netdev_ops = {
 	.ndo_vlan_rx_add_vid		= ocelot_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid		= ocelot_vlan_rx_kill_vid,
 	.ndo_set_features		= ocelot_set_features,
-	.ndo_get_port_parent_id		= ocelot_get_port_parent_id,
 	.ndo_setup_tc			= ocelot_setup_tc,
 	.ndo_do_ioctl			= ocelot_ioctl,
+	.ndo_get_devlink_port		= ocelot_get_devlink_port,
 };
 
 struct net_device *ocelot_port_to_netdev(struct ocelot *ocelot, int port)
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index ecd474476cc6..f46199b32fa7 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -481,6 +481,9 @@ static const struct ocelot_stat_layout ocelot_stats_layout[] = {
 	{ .name = "drop_green_prio_7", .offset = 0x91, },
 };
 
+static const struct devlink_ops ocelot_devlink_ops = {
+};
+
 static void ocelot_pll5_init(struct ocelot *ocelot)
 {
 	/* Configure PLL5. This will need a proper CCF driver
@@ -1051,6 +1054,14 @@ static struct ptp_clock_info ocelot_ptp_clock_info = {
 	.enable		= ocelot_ptp_enable,
 };
 
+static void mscc_ocelot_teardown_devlink_ports(struct ocelot *ocelot)
+{
+	int port;
+
+	for (port = 0; port < ocelot->num_phys_ports; port++)
+		ocelot_port_devlink_teardown(ocelot, port);
+}
+
 static void mscc_ocelot_release_ports(struct ocelot *ocelot)
 {
 	int port;
@@ -1078,28 +1089,44 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 {
 	struct ocelot *ocelot = platform_get_drvdata(pdev);
 	struct device_node *portnp;
-	int err;
+	bool *registered_ports;
+	int port, err;
+	u32 reg;
 
 	ocelot->ports = devm_kcalloc(ocelot->dev, ocelot->num_phys_ports,
 				     sizeof(struct ocelot_port *), GFP_KERNEL);
 	if (!ocelot->ports)
 		return -ENOMEM;
 
+	ocelot->devlink_ports = devm_kcalloc(ocelot->dev,
+					     ocelot->num_phys_ports,
+					     sizeof(*ocelot->devlink_ports),
+					     GFP_KERNEL);
+	if (!ocelot->devlink_ports)
+		return -ENOMEM;
+
+	registered_ports = kcalloc(ocelot->num_phys_ports, sizeof(bool),
+				   GFP_KERNEL);
+	if (!registered_ports)
+		return -ENOMEM;
+
 	for_each_available_child_of_node(ports, portnp) {
 		struct ocelot_port_private *priv;
 		struct ocelot_port *ocelot_port;
 		struct device_node *phy_node;
+		struct devlink_port *dlp;
 		phy_interface_t phy_mode;
 		struct phy_device *phy;
 		struct regmap *target;
 		struct resource *res;
 		struct phy *serdes;
 		char res_name[8];
-		u32 port;
 
-		if (of_property_read_u32(portnp, "reg", &port))
+		if (of_property_read_u32(portnp, "reg", &reg))
 			continue;
 
+		port = reg;
+
 		snprintf(res_name, sizeof(res_name), "port%d", port);
 
 		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
@@ -1117,15 +1144,26 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 		if (!phy)
 			continue;
 
+		err = ocelot_port_devlink_init(ocelot, port,
+					       DEVLINK_PORT_FLAVOUR_PHYSICAL);
+		if (err) {
+			of_node_put(portnp);
+			goto out_teardown;
+		}
+
 		err = ocelot_probe_port(ocelot, port, target, phy);
 		if (err) {
 			of_node_put(portnp);
-			return err;
+			goto out_teardown;
 		}
 
+		registered_ports[port] = true;
+
 		ocelot_port = ocelot->ports[port];
 		priv = container_of(ocelot_port, struct ocelot_port_private,
 				    port);
+		dlp = &ocelot->devlink_ports[port];
+		devlink_port_type_eth_set(dlp, priv->dev);
 
 		of_get_phy_mode(portnp, &phy_mode);
 
@@ -1150,7 +1188,8 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 				"invalid phy mode for port%d, (Q)SGMII only\n",
 				port);
 			of_node_put(portnp);
-			return -EINVAL;
+			err = -EINVAL;
+			goto out_teardown;
 		}
 
 		serdes = devm_of_phy_get(ocelot->dev, portnp, NULL);
@@ -1164,13 +1203,46 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 					port);
 
 			of_node_put(portnp);
-			return err;
+			goto out_teardown;
 		}
 
 		priv->serdes = serdes;
 	}
 
+	/* Initialize unused devlink ports at the end */
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		if (registered_ports[port])
+			continue;
+
+		err = ocelot_port_devlink_init(ocelot, port,
+					       DEVLINK_PORT_FLAVOUR_UNUSED);
+		if (err) {
+			while (port-- >= 0) {
+				if (!registered_ports[port])
+					continue;
+				ocelot_port_devlink_teardown(ocelot, port);
+			}
+
+			goto out_teardown;
+		}
+	}
+
+	kfree(registered_ports);
+
 	return 0;
+
+out_teardown:
+	/* Unregister the network interfaces */
+	mscc_ocelot_release_ports(ocelot);
+	/* Tear down devlink ports for the registered network interfaces */
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		if (!registered_ports[port])
+			continue;
+
+		ocelot_port_devlink_teardown(ocelot, port);
+	}
+	kfree(registered_ports);
+	return err;
 }
 
 static int mscc_ocelot_probe(struct platform_device *pdev)
@@ -1178,6 +1250,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	struct device_node *np = pdev->dev.of_node;
 	int err, irq_xtr, irq_ptp_rdy;
 	struct device_node *ports;
+	struct devlink *devlink;
 	struct ocelot *ocelot;
 	struct regmap *hsio;
 	unsigned int i;
@@ -1201,10 +1274,12 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	if (!np && !pdev->dev.platform_data)
 		return -ENODEV;
 
-	ocelot = devm_kzalloc(&pdev->dev, sizeof(*ocelot), GFP_KERNEL);
-	if (!ocelot)
+	devlink = devlink_alloc(&ocelot_devlink_ops, sizeof(*ocelot));
+	if (!devlink)
 		return -ENOMEM;
 
+	ocelot = devlink_priv(devlink);
+	ocelot->devlink = priv_to_devlink(ocelot);
 	platform_set_drvdata(pdev, ocelot);
 	ocelot->dev = &pdev->dev;
 
@@ -1221,7 +1296,8 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 				ocelot->targets[io_target[i].id] = NULL;
 				continue;
 			}
-			return PTR_ERR(target);
+			err = PTR_ERR(target);
+			goto out_free_devlink;
 		}
 
 		ocelot->targets[io_target[i].id] = target;
@@ -1230,24 +1306,25 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	hsio = syscon_regmap_lookup_by_compatible("mscc,ocelot-hsio");
 	if (IS_ERR(hsio)) {
 		dev_err(&pdev->dev, "missing hsio syscon\n");
-		return PTR_ERR(hsio);
+		err = PTR_ERR(hsio);
+		goto out_free_devlink;
 	}
 
 	ocelot->targets[HSIO] = hsio;
 
 	err = ocelot_chip_init(ocelot, &ocelot_ops);
 	if (err)
-		return err;
+		goto out_free_devlink;
 
 	irq_xtr = platform_get_irq_byname(pdev, "xtr");
 	if (irq_xtr < 0)
-		return -ENODEV;
+		goto out_free_devlink;
 
 	err = devm_request_threaded_irq(&pdev->dev, irq_xtr, NULL,
 					ocelot_xtr_irq_handler, IRQF_ONESHOT,
 					"frame extraction", ocelot);
 	if (err)
-		return err;
+		goto out_free_devlink;
 
 	irq_ptp_rdy = platform_get_irq_byname(pdev, "ptp_rdy");
 	if (irq_ptp_rdy > 0 && ocelot->targets[PTP]) {
@@ -1256,7 +1333,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 						IRQF_ONESHOT, "ptp ready",
 						ocelot);
 		if (err)
-			return err;
+			goto out_free_devlink;
 
 		/* Both the PTP interrupt and the PTP bank are available */
 		ocelot->ptp = 1;
@@ -1265,7 +1342,8 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	ports = of_get_child_by_name(np, "ethernet-ports");
 	if (!ports) {
 		dev_err(ocelot->dev, "no ethernet-ports child node found\n");
-		return -ENODEV;
+		err = -ENODEV;
+		goto out_free_devlink;
 	}
 
 	ocelot->num_phys_ports = of_get_child_count(ports);
@@ -1280,10 +1358,14 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	if (err)
 		goto out_put_ports;
 
-	err = mscc_ocelot_init_ports(pdev, ports);
+	err = devlink_register(devlink, ocelot->dev);
 	if (err)
 		goto out_ocelot_deinit;
 
+	err = mscc_ocelot_init_ports(pdev, ports);
+	if (err)
+		goto out_ocelot_devlink_unregister;
+
 	if (ocelot->ptp) {
 		err = ocelot_init_timestamp(ocelot, &ocelot_ptp_clock_info);
 		if (err) {
@@ -1303,10 +1385,14 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 
 	return 0;
 
+out_ocelot_devlink_unregister:
+	devlink_unregister(devlink);
 out_ocelot_deinit:
 	ocelot_deinit(ocelot);
 out_put_ports:
 	of_node_put(ports);
+out_free_devlink:
+	devlink_free(devlink);
 	return err;
 }
 
@@ -1316,10 +1402,13 @@ static int mscc_ocelot_remove(struct platform_device *pdev)
 
 	ocelot_deinit_timestamp(ocelot);
 	mscc_ocelot_release_ports(ocelot);
+	mscc_ocelot_teardown_devlink_ports(ocelot);
+	devlink_unregister(ocelot->devlink);
 	ocelot_deinit(ocelot);
 	unregister_switchdev_blocking_notifier(&ocelot_switchdev_blocking_nb);
 	unregister_switchdev_notifier(&ocelot_switchdev_nb);
 	unregister_netdevice_notifier(&ocelot_netdevice_nb);
+	devlink_free(ocelot->devlink);
 
 	return 0;
 }
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 1dc0c6d0671a..fc7dc6679739 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -602,6 +602,8 @@ struct ocelot_port {
 
 struct ocelot {
 	struct device			*dev;
+	struct devlink			*devlink;
+	struct devlink_port		*devlink_ports;
 
 	const struct ocelot_ops		*ops;
 	struct regmap			*targets[TARGET_MAX];
-- 
2.25.1

