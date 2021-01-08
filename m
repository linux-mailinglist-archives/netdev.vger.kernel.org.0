Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9762EF6EB
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 19:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728630AbhAHSDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 13:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728595AbhAHSDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 13:03:54 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F029DC06129E
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 10:02:42 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id c7so12058474edv.6
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 10:02:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PVUZjFWOvTOjM3ZLU5zACmAZmC29U2Z8kaUUAtYK5do=;
        b=IkYcYzklN82dQD5cvG2Gdp5uttGnVBO0Dr8vHvT0Cfi4aAlavASP6l+MSMWDdPQqkY
         50CG4gPx9vzW2iRE+3OySTSQI+CjfQ64eIFed2PaflktmMEfkgHaKbb3B704Leghrs09
         ILNApkaSiM3hiSjAKuqf5CFcSh/wLPCvY/Lf2dAdf2MJh5JQwHTEPDdqr5K+I0seYRCr
         pfl3JGtpXtscvgsUGMbAUPhY2ECoEtGS/HZXpGRttO4Y9bLHt7t33VL+xDkzBgUO/IOw
         IRO5Th6p9L/wzJtYoUf9DikacTxAlavRPO17Pi//Qp0Yre0s7xdIsPJr/FczHwrcaQih
         Kj/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PVUZjFWOvTOjM3ZLU5zACmAZmC29U2Z8kaUUAtYK5do=;
        b=OKuo8gNTHg7IywCSydpKeDAMqlNei8+G4q894Cx8O/N8jO4FeuGF6ug5+A0F9Fo495
         c7EPNOLupkLI7oVNOe/eZGuJkYCMCcGTpe+Gze1wyhOxLak1URNhL6GoN4JiGyMlUg+2
         UevExX2y0OwRBG9Hd3QLhQgJw+xwEnPrxivCd2VezERK9CeXUBa28KQMyNhUVN2VCaQS
         322k9BJdUo44eLGLaR9ELj/6DME5NV3EtYdaqvkmQLrTso0KtJIW2nXTv/OD+kfQ/7Gy
         ET7H68Gy8Vs7sjoEKlGYh5U1Nt+8HmHF5FBhrKFk6t0BeQMiVVyOk5nyl7CPNOvSKzaN
         fODw==
X-Gm-Message-State: AOAM530ER90OwellW3glKqBdtoIqsMsMtQZ2IbhANb5CvQbt6ZN86GB5
        cLSNXYLTk4yc9hROUEaqxVApwRd04k8=
X-Google-Smtp-Source: ABdhPJxJ/5K+QXX95Fbf3GEtmvcCmKmccecimz7WF3hHtY6dLFmtskogSDzXkvV9ENIrLJoroeTXew==
X-Received: by 2002:aa7:d916:: with SMTP id a22mr6101608edr.122.1610128961371;
        Fri, 08 Jan 2021 10:02:41 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id b19sm4059713edx.47.2021.01.08.10.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 10:02:40 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v3 net-next 08/10] net: mscc: ocelot: register devlink ports
Date:   Fri,  8 Jan 2021 19:59:48 +0200
Message-Id: <20210108175950.484854-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108175950.484854-1-olteanv@gmail.com>
References: <20210108175950.484854-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Add devlink integration into the mscc_ocelot switchdev driver. Only the
probed interfaces are registered with devlink, because for convenience,
struct devlink_port was included into struct ocelot_port_private, which
is only initialized for the ports that are used.

Since we use devlink_port_type_eth_set to link the devlink port to the
net_device, we can as well remove the .ndo_get_phys_port_name and
.ndo_get_port_parent_id implementations, since devlink takes care of
retrieving the port name and number automatically, once
.ndo_get_devlink_port is implemented.

Note that the felix DSA driver is already integrated with devlink by
default, since that is a thing that the DSA core takes care of. This is
the reason why these devlink stubs were put in ocelot_net.c and not in
the common library.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
Using devlink_port_type_eth_set as per Jiri's suggestion.

 drivers/net/ethernet/mscc/ocelot.h         |   4 +
 drivers/net/ethernet/mscc/ocelot_net.c     | 139 ++++++++++++++++-----
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |   7 ++
 include/soc/mscc/ocelot.h                  |   1 +
 4 files changed, 123 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 519335676c24..2e9a3c4697c8 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -57,6 +57,8 @@ struct ocelot_port_private {
 	struct phy *serdes;
 
 	struct ocelot_port_tc tc;
+
+	struct devlink_port devlink_port;
 };
 
 struct ocelot_dump_ctx {
@@ -121,6 +123,8 @@ void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
 
 int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 		      struct phy_device *phy);
+int ocelot_devlink_init(struct ocelot *ocelot);
+void ocelot_devlink_teardown(struct ocelot *ocelot);
 
 extern struct notifier_block ocelot_netdevice_nb;
 extern struct notifier_block ocelot_switchdev_nb;
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 2bd2840d88bd..d0d98c6adea8 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -8,6 +8,116 @@
 #include "ocelot.h"
 #include "ocelot_vcap.h"
 
+struct ocelot_devlink_private {
+	struct ocelot *ocelot;
+};
+
+static const struct devlink_ops ocelot_devlink_ops = {
+};
+
+static int ocelot_port_devlink_init(struct ocelot *ocelot, int port)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	int id_len = sizeof(ocelot->base_mac);
+	struct devlink *dl = ocelot->devlink;
+	struct devlink_port_attrs attrs = {};
+	struct ocelot_port_private *priv;
+	struct devlink_port *dlp;
+	int err;
+
+	if (!ocelot_port)
+		return 0;
+
+	priv = container_of(ocelot_port, struct ocelot_port_private, port);
+	dlp = &priv->devlink_port;
+
+	memcpy(attrs.switch_id.id, &ocelot->base_mac, id_len);
+	attrs.switch_id.id_len = id_len;
+	attrs.phys.port_number = port;
+
+	if (priv->dev)
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+	else
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_UNUSED;
+
+	devlink_port_attrs_set(dlp, &attrs);
+
+	err = devlink_port_register(dl, dlp, port);
+	if (err)
+		return err;
+
+	if (priv->dev)
+		devlink_port_type_eth_set(dlp, priv->dev);
+
+	return 0;
+}
+
+static void ocelot_port_devlink_teardown(struct ocelot *ocelot, int port)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	struct ocelot_port_private *priv;
+	struct devlink_port *dlp;
+
+	if (!ocelot_port)
+		return;
+
+	priv = container_of(ocelot_port, struct ocelot_port_private, port);
+	dlp = &priv->devlink_port;
+
+	devlink_port_unregister(dlp);
+}
+
+int ocelot_devlink_init(struct ocelot *ocelot)
+{
+	struct ocelot_devlink_private *dl_priv;
+	int port, err;
+
+	ocelot->devlink = devlink_alloc(&ocelot_devlink_ops, sizeof(*dl_priv));
+	if (!ocelot->devlink)
+		return -ENOMEM;
+	dl_priv = devlink_priv(ocelot->devlink);
+	dl_priv->ocelot = ocelot;
+
+	err = devlink_register(ocelot->devlink, ocelot->dev);
+	if (err)
+		goto free_devlink;
+
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		err = ocelot_port_devlink_init(ocelot, port);
+		if (err) {
+			while (port-- > 0)
+				ocelot_port_devlink_teardown(ocelot, port);
+			goto unregister_devlink;
+		}
+	}
+
+	return 0;
+
+unregister_devlink:
+	devlink_unregister(ocelot->devlink);
+free_devlink:
+	devlink_free(ocelot->devlink);
+	return err;
+}
+
+void ocelot_devlink_teardown(struct ocelot *ocelot)
+{
+	int port;
+
+	for (port = 0; port < ocelot->num_phys_ports; port++)
+		ocelot_port_devlink_teardown(ocelot, port);
+
+	devlink_unregister(ocelot->devlink);
+	devlink_free(ocelot->devlink);
+}
+
+static struct devlink_port *ocelot_get_devlink_port(struct net_device *dev)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+
+	return &priv->devlink_port;
+}
+
 int ocelot_setup_tc_cls_flower(struct ocelot_port_private *priv,
 			       struct flow_cls_offload *f,
 			       bool ingress)
@@ -525,20 +635,6 @@ static void ocelot_set_rx_mode(struct net_device *dev)
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
@@ -689,18 +785,6 @@ static int ocelot_set_features(struct net_device *dev,
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
@@ -727,7 +811,6 @@ static const struct net_device_ops ocelot_port_netdev_ops = {
 	.ndo_stop			= ocelot_port_stop,
 	.ndo_start_xmit			= ocelot_port_xmit,
 	.ndo_set_rx_mode		= ocelot_set_rx_mode,
-	.ndo_get_phys_port_name		= ocelot_port_get_phys_port_name,
 	.ndo_set_mac_address		= ocelot_port_set_mac_address,
 	.ndo_get_stats64		= ocelot_get_stats64,
 	.ndo_fdb_add			= ocelot_port_fdb_add,
@@ -736,9 +819,9 @@ static const struct net_device_ops ocelot_port_netdev_ops = {
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
index ecd474476cc6..80fdf971d573 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -1293,6 +1293,12 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 		}
 	}
 
+	err = ocelot_devlink_init(ocelot);
+	if (err) {
+		mscc_ocelot_release_ports(ocelot);
+		goto out_ocelot_deinit;
+	}
+
 	register_netdevice_notifier(&ocelot_netdevice_nb);
 	register_switchdev_notifier(&ocelot_switchdev_nb);
 	register_switchdev_blocking_notifier(&ocelot_switchdev_blocking_nb);
@@ -1314,6 +1320,7 @@ static int mscc_ocelot_remove(struct platform_device *pdev)
 {
 	struct ocelot *ocelot = platform_get_drvdata(pdev);
 
+	ocelot_devlink_teardown(ocelot);
 	ocelot_deinit_timestamp(ocelot);
 	mscc_ocelot_release_ports(ocelot);
 	ocelot_deinit(ocelot);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 9a46787c679b..75cd457b99b9 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -602,6 +602,7 @@ struct ocelot_port {
 
 struct ocelot {
 	struct device			*dev;
+	struct devlink			*devlink;
 
 	const struct ocelot_ops		*ops;
 	struct regmap			*targets[TARGET_MAX];
-- 
2.25.1

