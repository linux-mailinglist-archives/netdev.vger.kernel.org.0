Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D03987E475
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 22:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387891AbfHAUpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 16:45:33 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:46062 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727127AbfHAUpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 16:45:32 -0400
Received: by mail-qt1-f193.google.com with SMTP id x22so66789128qtp.12
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 13:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=starry.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2x/VpBKjqeFRxNJzwXYyjQLvo6E6m/yhOqpVOvNodtI=;
        b=DtFju9qWo6vvWWYh+5pQxvqI0u22nof/S95SC3dYkFTL7E+n6e7T9eFsfuD3U5VuoE
         0aURdirfQklfTXzCLmXGQEduXSYgdr6idxkWv0Z/JhyHDLSkeqT7+lRsnP2RnicNUERb
         Pkk3LWw0DwIqI3mWrPaNVJVIPfdIODfCsHuwo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2x/VpBKjqeFRxNJzwXYyjQLvo6E6m/yhOqpVOvNodtI=;
        b=oUIIoY8DKUInCB3EBymCKsszL8RbdYkF597gXt2wfoefvSyoUo46333hg2jP1F1zrI
         KxSbPyTrTSn/o/NA4tpCsqL4b6Jg0sPsx4ZiyyP16MfIVXJxgTsT9RMO7LBay09k5bfU
         lSOa3fXZia0yaOb26A1rwP5Z8AaCEV0Q/8Sv3+tNCjzkez0btZGwL1/5UIkMdAfpwvO7
         ECUrX18Nhf2Vwn0CzYKHd032qI6CuXnuKkpdC/qrnTmYr3WJ/JeaHNRHB9VWmojNBQ+P
         R4Rol68xNk0uq/s0ZGZ22K8ttaWxJuRpMbMrAPp8hLZ8iQeBHbz6v+AjjLwuFdu7DNfC
         FTFg==
X-Gm-Message-State: APjAAAVYdJdhWi0OlF5xH83Ti0hChJhS51OcCHtJMC4Xee7xwkoQE4R/
        dtD9gMI4TM/zd5VLWrK9EV4mPx341fA=
X-Google-Smtp-Source: APXvYqxzzFN41VEDD3IqrngxWpozjAGvc/BFjN2GHtUKP0PV/8tqlZ9I+qZLdKccOLp7lJ3wY49Yeg==
X-Received: by 2002:a0c:b084:: with SMTP id o4mr94278706qvc.227.1564692331484;
        Thu, 01 Aug 2019 13:45:31 -0700 (PDT)
Received: from localhost.localdomain (205-201-16-55.starry-inc.net. [205.201.16.55])
        by smtp.gmail.com with ESMTPSA id b23sm42724059qte.19.2019.08.01.13.45.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 13:45:30 -0700 (PDT)
From:   Matt Pelland <mpelland@starry.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, maxime.chevallier@bootlin.com,
        antoine.tenart@bootlin.com, Matt Pelland <mpelland@starry.com>
Subject: [PATCH 2/2] net: mvpp2: support multiple comphy lanes
Date:   Thu,  1 Aug 2019 16:45:23 -0400
Message-Id: <20190801204523.26454-3-mpelland@starry.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190801204523.26454-1-mpelland@starry.com>
References: <20190801204523.26454-1-mpelland@starry.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mvpp 2.2 supports RXAUI which requires a pair of serdes lanes instead of
the usual single lane required by other interface modes. This patch
expands the number of lanes that can be associated to a port so that
both lanes are correctly configured at the appropriate times when RXAUI
is in use.

Signed-off-by: Matt Pelland <mpelland@starry.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  7 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 66 +++++++++++++------
 2 files changed, 53 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 256e7c796631..9ae2b3d9d0c7 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -655,6 +655,11 @@
 #define MVPP2_F_LOOPBACK		BIT(0)
 #define MVPP2_F_DT_COMPAT		BIT(1)
 
+/* MVPP22 supports RXAUI which requires two comphy lanes, all other modes
+ * require one.
+ */
+#define MVPP22_MAX_COMPHYS		2
+
 /* Marvell tag types */
 enum mvpp2_tag_type {
 	MVPP2_TAG_TYPE_NONE = 0,
@@ -935,7 +940,7 @@ struct mvpp2_port {
 	phy_interface_t phy_interface;
 	struct phylink *phylink;
 	struct phylink_config phylink_config;
-	struct phy *comphy;
+	struct phy *comphys[MVPP22_MAX_COMPHYS];
 
 	struct mvpp2_bm_pool *pool_long;
 	struct mvpp2_bm_pool *pool_short;
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 8b633af4a684..97dfe2e71b03 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1186,17 +1186,40 @@ static void mvpp22_gop_setup_irq(struct mvpp2_port *port)
  */
 static int mvpp22_comphy_init(struct mvpp2_port *port)
 {
-	int ret;
+	int i, ret;
 
-	if (!port->comphy)
-		return 0;
+	for (i = 0; i < ARRAY_SIZE(port->comphys); i++) {
+		if (!port->comphys[i])
+			return 0;
 
-	ret = phy_set_mode_ext(port->comphy, PHY_MODE_ETHERNET,
-			       port->phy_interface);
-	if (ret)
-		return ret;
+		ret = phy_set_mode_ext(port->comphys[i],
+				       PHY_MODE_ETHERNET,
+				       port->phy_interface);
+		if (ret)
+			return ret;
 
-	return phy_power_on(port->comphy);
+		ret = phy_power_on(port->comphys[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int mvpp22_comphy_deinit(struct mvpp2_port *port)
+{
+	int i, ret;
+
+	for (i = 0; i < ARRAY_SIZE(port->comphys); i++) {
+		if (!port->comphys[i])
+			return 0;
+
+		ret = phy_power_off(port->comphys[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 static void mvpp2_port_enable(struct mvpp2_port *port)
@@ -3375,7 +3398,9 @@ static void mvpp2_stop_dev(struct mvpp2_port *port)
 
 	if (port->phylink)
 		phylink_stop(port->phylink);
-	phy_power_off(port->comphy);
+
+	if (port->priv->hw_version == MVPP22)
+		mvpp22_comphy_deinit(port);
 }
 
 static int mvpp2_check_ringparam_valid(struct net_device *dev,
@@ -4947,7 +4972,7 @@ static void mvpp2_mac_config(struct phylink_config *config, unsigned int mode,
 		port->phy_interface = state->interface;
 
 		/* Reconfigure the serdes lanes */
-		phy_power_off(port->comphy);
+		mvpp22_comphy_deinit(port);
 		mvpp22_mode_reconfigure(port);
 	}
 
@@ -5038,7 +5063,6 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 			    struct fwnode_handle *port_fwnode,
 			    struct mvpp2 *priv)
 {
-	struct phy *comphy = NULL;
 	struct mvpp2_port *port;
 	struct mvpp2_port_pcpu *port_pcpu;
 	struct device_node *port_node = to_of_node(port_fwnode);
@@ -5085,14 +5109,20 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 		goto err_free_netdev;
 	}
 
+	port = netdev_priv(dev);
+
 	if (port_node) {
-		comphy = devm_of_phy_get(&pdev->dev, port_node, NULL);
-		if (IS_ERR(comphy)) {
-			if (PTR_ERR(comphy) == -EPROBE_DEFER) {
-				err = -EPROBE_DEFER;
-				goto err_free_netdev;
+		for (i = 0; i < ARRAY_SIZE(port->comphys); i++) {
+			port->comphys[i] = devm_of_phy_get_by_index(&pdev->dev,
+								    port_node,
+								    i);
+			if (IS_ERR(port->comphys[i])) {
+				err = PTR_ERR(port->comphys[i]);
+				port->comphys[i] = NULL;
+				if (err == -EPROBE_DEFER)
+					goto err_free_netdev;
+				err = 0;
 			}
-			comphy = NULL;
 		}
 	}
 
@@ -5107,7 +5137,6 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 	dev->netdev_ops = &mvpp2_netdev_ops;
 	dev->ethtool_ops = &mvpp2_eth_tool_ops;
 
-	port = netdev_priv(dev);
 	port->dev = dev;
 	port->fwnode = port_fwnode;
 	port->has_phy = !!of_find_property(port_node, "phy", NULL);
@@ -5144,7 +5173,6 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 
 	port->of_node = port_node;
 	port->phy_interface = phy_mode;
-	port->comphy = comphy;
 
 	if (priv->hw_version == MVPP21) {
 		port->base = devm_platform_ioremap_resource(pdev, 2 + id);
-- 
2.21.0

