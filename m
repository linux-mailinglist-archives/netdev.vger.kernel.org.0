Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B252F1CDF
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 18:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389926AbhAKRo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 12:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389764AbhAKRoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 12:44:55 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66BB7C0617A6
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 09:43:44 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id i24so606186edj.8
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 09:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FtjX5ebJuMIKM/i3X/AufqVtU3PM47ZfQ9s8Tntx8kM=;
        b=PJi2qSby+R8wmcXPu9ZVjbpdAH9tVJcievHSHItrEnD4B/yCnon876H7P7DAkQQ3J2
         3gN3aZbOWiOa/sE73OAli64Q6HsP/OoLnk+eHDKcvz8NC30QLacFAwxRcAI6nYtqykHY
         mnzOBZ+Kka2xiN3HLnq9AxmjZaolVNao6hacfbDRF14XhiumtFOxkjtrCnIsQkQJRwj5
         nxmiqlRwuZN20GQSBWlLrOAfCdLxIR1AR2IMkf6fX4n5N9zZysgprSi+AxfP/+JpAbc1
         65fuqNU2wf9K56J1PfT974ZZ1EENoKJ6ARa1Yovi55+RizSj34B0u6RSuqXEyd5gH2ms
         HbVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FtjX5ebJuMIKM/i3X/AufqVtU3PM47ZfQ9s8Tntx8kM=;
        b=PPxZsrOIC5vZMlr8b9s0PL7Wc2iKK/R2ZuVnagGi02VyNvql31IQvlIs3wfeUbE/Iy
         SlTogdn8SzXJwI0A32rymbUOHcIhKgaV1TrG3pUSy84/zQzetaJKBnHz2suhq4oE3Z/j
         KfkqNRHf0GAddN3tCmY11PP2dW/r3lDxeD2+PgdMob/AHXBaIDn2VFTyAStQv3L5rF+Q
         ZHp3NDybaFoMhxG7kOKL4FNh/EavCQKf48ynhPWE8ulZ7oESKqr9dauH1Ya8FK6Yb3Fd
         ZVzAY5Qb8RLZx3mTNE/R7FsMPyiUI/gD+B7FE8msnVht9IFXHDnUT5AeB4pwqwBToVYc
         JdNg==
X-Gm-Message-State: AOAM532fqKnuKrR8SnomefcPOClExPn7njaYMflTyqeNtSXhQu8x3HWu
        kDb24yvYkDTfzgGVPBjK/ig=
X-Google-Smtp-Source: ABdhPJx3MD0Fh/TXgQ7uHGHQWpKIkZ7bNr39iV3l2VxPp7KfxHelAQAzSTSHMCl/nYVh+pSvYrAHgQ==
X-Received: by 2002:a50:8b02:: with SMTP id l2mr366620edl.322.1610387023048;
        Mon, 11 Jan 2021 09:43:43 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id j22sm111132ejy.106.2021.01.11.09.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 09:43:42 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v4 net-next 08/10] net: mscc: ocelot: register devlink ports
Date:   Mon, 11 Jan 2021 19:43:14 +0200
Message-Id: <20210111174316.3515736-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210111174316.3515736-1-olteanv@gmail.com>
References: <20210111174316.3515736-1-olteanv@gmail.com>
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
the mscc_ocelot driver allocates that by itself, but in the case of
felix, it is DSA who allocates the devlink, and felix just propagates
the pointer towards struct ocelot.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v4:
- Register devlink ports before registering the net_devices.
- Register devlink ports for the unused ports too.
- More careful teardown path.

Changes in v3:
None.

Changes in v2:
Using devlink_port_type_eth_set as per Jiri's suggestion.

 drivers/net/ethernet/mscc/ocelot.h         |  5 ++
 drivers/net/ethernet/mscc/ocelot_net.c     | 97 +++++++++++++++-------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 91 ++++++++++++++++++--
 include/soc/mscc/ocelot.h                  |  2 +
 4 files changed, 160 insertions(+), 35 deletions(-)

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
index 2bd2840d88bd..0935af063da1 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -8,6 +8,74 @@
 #include "ocelot.h"
 #include "ocelot_vcap.h"
 
+struct ocelot_devlink_private {
+	struct ocelot *ocelot;
+};
+
+static const struct devlink_ops ocelot_devlink_ops = {
+};
+
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
+int ocelot_devlink_init(struct ocelot *ocelot)
+{
+	struct ocelot_devlink_private *dl_priv;
+	int err;
+
+	ocelot->devlink = devlink_alloc(&ocelot_devlink_ops, sizeof(*dl_priv));
+	if (!ocelot->devlink)
+		return -ENOMEM;
+
+	dl_priv = devlink_priv(ocelot->devlink);
+	dl_priv->ocelot = ocelot;
+
+	err = devlink_register(ocelot->devlink, ocelot->dev);
+	if (err) {
+		devlink_free(ocelot->devlink);
+		return err;
+	}
+
+	return 0;
+}
+
+void ocelot_devlink_teardown(struct ocelot *ocelot)
+{
+	devlink_unregister(ocelot->devlink);
+	devlink_free(ocelot->devlink);
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
@@ -525,20 +593,6 @@ static void ocelot_set_rx_mode(struct net_device *dev)
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
@@ -689,18 +743,6 @@ static int ocelot_set_features(struct net_device *dev,
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
@@ -727,7 +769,6 @@ static const struct net_device_ops ocelot_port_netdev_ops = {
 	.ndo_stop			= ocelot_port_stop,
 	.ndo_start_xmit			= ocelot_port_xmit,
 	.ndo_set_rx_mode		= ocelot_set_rx_mode,
-	.ndo_get_phys_port_name		= ocelot_port_get_phys_port_name,
 	.ndo_set_mac_address		= ocelot_port_set_mac_address,
 	.ndo_get_stats64		= ocelot_get_stats64,
 	.ndo_fdb_add			= ocelot_port_fdb_add,
@@ -736,9 +777,9 @@ static const struct net_device_ops ocelot_port_netdev_ops = {
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
index ecd474476cc6..41cf92e5be76 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -1051,6 +1051,14 @@ static struct ptp_clock_info ocelot_ptp_clock_info = {
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
@@ -1078,28 +1086,44 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
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
@@ -1117,15 +1141,26 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
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
 
@@ -1150,7 +1185,8 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 				"invalid phy mode for port%d, (Q)SGMII only\n",
 				port);
 			of_node_put(portnp);
-			return -EINVAL;
+			err = -EINVAL;
+			goto out_teardown;
 		}
 
 		serdes = devm_of_phy_get(ocelot->dev, portnp, NULL);
@@ -1164,13 +1200,46 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
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
@@ -1280,10 +1349,14 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	if (err)
 		goto out_put_ports;
 
-	err = mscc_ocelot_init_ports(pdev, ports);
+	err = ocelot_devlink_init(ocelot);
 	if (err)
 		goto out_ocelot_deinit;
 
+	err = mscc_ocelot_init_ports(pdev, ports);
+	if (err)
+		goto out_ocelot_devlink_teardown;
+
 	if (ocelot->ptp) {
 		err = ocelot_init_timestamp(ocelot, &ocelot_ptp_clock_info);
 		if (err) {
@@ -1303,6 +1376,8 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 
 	return 0;
 
+out_ocelot_devlink_teardown:
+	ocelot_devlink_teardown(ocelot);
 out_ocelot_deinit:
 	ocelot_deinit(ocelot);
 out_put_ports:
@@ -1316,6 +1391,8 @@ static int mscc_ocelot_remove(struct platform_device *pdev)
 
 	ocelot_deinit_timestamp(ocelot);
 	mscc_ocelot_release_ports(ocelot);
+	mscc_ocelot_teardown_devlink_ports(ocelot);
+	ocelot_devlink_teardown(ocelot);
 	ocelot_deinit(ocelot);
 	unregister_switchdev_blocking_notifier(&ocelot_switchdev_blocking_nb);
 	unregister_switchdev_notifier(&ocelot_switchdev_nb);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 9a46787c679b..dc3765e67c9d 100644
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

