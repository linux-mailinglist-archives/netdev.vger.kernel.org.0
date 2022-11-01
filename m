Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2C046146F5
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 10:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbiKAJlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 05:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbiKAJkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 05:40:11 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D7B219C06;
        Tue,  1 Nov 2022 02:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667295594; x=1698831594;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n9CzPbM1bAerbqvL5g54YnK8eRkiNqtBOY51LASSiP0=;
  b=FyWG6J2BnG8edudBtlZ7jQ5gGPawvbWHuM1PpDXaNs/ntpD73Uac8EgR
   tD3QcE2bpklST05mZqC8CXaI9RxtdKnJ3jNyhOy+nsFFJZQ7S6T0jRCjw
   wkxUVD89JTDXnFWaoTNL3Nv9yIzjYibkVR6kU1np7tq0dqt+ST1Iz3GwI
   n0NsvEXnBRZFCY1/CWyAIjIasFrArJO0UnSIyyjUJ+H5gBHeTgB9+g3bg
   gXfejTf/HsL1XtmPnu1XSw7y4z+71ULvuD6mbK1yr6M9CCaYhZ/3+YVCw
   FEf104V1JsMeHGbr7nypFKLlDYMDMnJtbXEIt9hC7C8pEGP954Zoq6x0T
   g==;
X-IronPort-AV: E=Sophos;i="5.95,230,1661842800"; 
   d="scan'208";a="181384460"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Nov 2022 02:39:53 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 1 Nov 2022 02:39:52 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 1 Nov 2022 02:39:48 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <petrm@nvidia.com>,
        <maxime.chevallier@bootlin.com>, <thomas.petazzoni@bootlin.com>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <daniel.machon@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <joe@perches.com>, <linux@armlinux.org.uk>,
        <horatiu.vultur@microchip.com>, <Julia.Lawall@inria.fr>,
        <vladimir.oltean@nxp.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH net-next v6 5/6] net: microchip: sparx5: add support for offloading dscp table
Date:   Tue, 1 Nov 2022 10:48:33 +0100
Message-ID: <20221101094834.2726202-6-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221101094834.2726202-1-daniel.machon@microchip.com>
References: <20221101094834.2726202-1-daniel.machon@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for offloading dscp app entries. Dscp values are global for
all ports on the sparx5 switch. Therefore, we replicate each dscp app
entry per-port.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 .../ethernet/microchip/sparx5/sparx5_dcb.c    | 66 ++++++++++++++++++-
 .../ethernet/microchip/sparx5/sparx5_port.c   | 39 +++++++++++
 .../ethernet/microchip/sparx5/sparx5_port.h   | 14 ++++
 3 files changed, 116 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
index 96100a063e13..be1dc78fc7ba 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
@@ -49,6 +49,13 @@ static int sparx5_dcb_app_validate(struct net_device *dev,
 	int err = 0;
 
 	switch (app->selector) {
+	/* Dscp checks */
+	case IEEE_8021QAZ_APP_SEL_DSCP:
+		if (app->protocol >= SPARX5_PORT_QOS_DSCP_COUNT)
+			err = -EINVAL;
+		else if (app->priority >= SPX5_PRIOS)
+			err = -ERANGE;
+		break;
 	/* Pcp checks */
 	case DCB_APP_SEL_PCP:
 		if (app->protocol >= SPARX5_PORT_QOS_PCP_DEI_COUNT)
@@ -119,17 +126,27 @@ static bool sparx5_dcb_apptrust_contains(int portno, u8 selector)
 
 static int sparx5_dcb_app_update(struct net_device *dev)
 {
-	struct dcb_app app_itr = { .selector = DCB_APP_SEL_PCP };
 	struct sparx5_port *port = netdev_priv(dev);
+	struct sparx5_port_qos_dscp_map *dscp_map;
 	struct sparx5_port_qos_pcp_map *pcp_map;
 	struct sparx5_port_qos qos = {0};
+	struct dcb_app app_itr = {0};
 	int portno = port->portno;
 	int i;
 
+	dscp_map = &qos.dscp.map;
 	pcp_map = &qos.pcp.map;
 
+	/* Get dscp ingress mapping */
+	for (i = 0; i < ARRAY_SIZE(dscp_map->map); i++) {
+		app_itr.selector = IEEE_8021QAZ_APP_SEL_DSCP;
+		app_itr.protocol = i;
+		dscp_map->map[i] = dcb_getapp(dev, &app_itr);
+	}
+
 	/* Get pcp ingress mapping */
 	for (i = 0; i < ARRAY_SIZE(pcp_map->map); i++) {
+		app_itr.selector = DCB_APP_SEL_PCP;
 		app_itr.protocol = i;
 		pcp_map->map[i] = dcb_getapp(dev, &app_itr);
 	}
@@ -140,9 +157,44 @@ static int sparx5_dcb_app_update(struct net_device *dev)
 		qos.pcp.dp_enable = qos.pcp.qos_enable;
 	}
 
+	/* Enable use of dscp for queue classification ? */
+	if (sparx5_dcb_apptrust_contains(portno, IEEE_8021QAZ_APP_SEL_DSCP)) {
+		qos.dscp.qos_enable = true;
+		qos.dscp.dp_enable = qos.dscp.qos_enable;
+	}
+
 	return sparx5_port_qos_set(port, &qos);
 }
 
+/* Set or delete dscp app entry.
+ *
+ * Dscp mapping is global for all ports, so set and delete app entries are
+ * replicated for each port.
+ */
+static int sparx5_dcb_ieee_dscp_setdel_app(struct net_device *dev,
+					   struct dcb_app *app, bool del)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+	struct dcb_app apps[SPX5_PORTS];
+	struct sparx5_port *port_itr;
+	int err, i;
+
+	for (i = 0; i < SPX5_PORTS; i++) {
+		port_itr = port->sparx5->ports[i];
+		if (!port_itr)
+			continue;
+		memcpy(&apps[i], app, sizeof(struct dcb_app));
+		if (del)
+			err = dcb_ieee_delapp(port_itr->ndev, &apps[i]);
+		else
+			err = dcb_ieee_setapp(port_itr->ndev, &apps[i]);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 static int sparx5_dcb_ieee_setapp(struct net_device *dev, struct dcb_app *app)
 {
 	struct dcb_app app_itr;
@@ -161,7 +213,11 @@ static int sparx5_dcb_ieee_setapp(struct net_device *dev, struct dcb_app *app)
 		dcb_ieee_delapp(dev, &app_itr);
 	}
 
-	err = dcb_ieee_setapp(dev, app);
+	if (app->selector == IEEE_8021QAZ_APP_SEL_DSCP)
+		err = sparx5_dcb_ieee_dscp_setdel_app(dev, app, false);
+	else
+		err = dcb_ieee_setapp(dev, app);
+
 	if (err)
 		goto out;
 
@@ -175,7 +231,11 @@ static int sparx5_dcb_ieee_delapp(struct net_device *dev, struct dcb_app *app)
 {
 	int err;
 
-	err = dcb_ieee_delapp(dev, app);
+	if (app->selector == IEEE_8021QAZ_APP_SEL_DSCP)
+		err = sparx5_dcb_ieee_dscp_setdel_app(dev, app, true);
+	else
+		err = dcb_ieee_delapp(dev, app);
+
 	if (err < 0)
 		return err;
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_port.c b/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
index 3cd310f5b9ee..23ef93919753 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
@@ -1149,6 +1149,7 @@ void sparx5_port_enable(struct sparx5_port *port, bool enable)
 int sparx5_port_qos_set(struct sparx5_port *port,
 			struct sparx5_port_qos *qos)
 {
+	sparx5_port_qos_dscp_set(port, &qos->dscp);
 	sparx5_port_qos_pcp_set(port, &qos->pcp);
 
 	return 0;
@@ -1181,3 +1182,41 @@ int sparx5_port_qos_pcp_set(const struct sparx5_port *port,
 
 	return 0;
 }
+
+int sparx5_port_qos_dscp_set(const struct sparx5_port *port,
+			     struct sparx5_port_qos_dscp *qos)
+{
+	struct sparx5 *sparx5 = port->sparx5;
+	u8 *dscp = qos->map.map;
+	int i;
+
+	/* Enable/disable dscp and dp for qos classification.
+	 * Disable rewrite of dscp values for now.
+	 */
+	spx5_rmw(ANA_CL_QOS_CFG_DSCP_QOS_ENA_SET(qos->qos_enable) |
+		 ANA_CL_QOS_CFG_DSCP_DP_ENA_SET(qos->dp_enable) |
+		 ANA_CL_QOS_CFG_DSCP_KEEP_ENA_SET(1),
+		 ANA_CL_QOS_CFG_DSCP_QOS_ENA | ANA_CL_QOS_CFG_DSCP_DP_ENA |
+		 ANA_CL_QOS_CFG_DSCP_KEEP_ENA, sparx5,
+		 ANA_CL_QOS_CFG(port->portno));
+
+	/* Map each dscp value to priority and dp */
+	for (i = 0; i < ARRAY_SIZE(qos->map.map); i++) {
+		spx5_rmw(ANA_CL_DSCP_CFG_DSCP_QOS_VAL_SET(*(dscp + i)) |
+			 ANA_CL_DSCP_CFG_DSCP_DP_VAL_SET(0),
+			 ANA_CL_DSCP_CFG_DSCP_QOS_VAL |
+			 ANA_CL_DSCP_CFG_DSCP_DP_VAL, sparx5,
+			 ANA_CL_DSCP_CFG(i));
+	}
+
+	/* Set per-dscp trust */
+	for (i = 0; i <  ARRAY_SIZE(qos->map.map); i++) {
+		if (qos->qos_enable) {
+			spx5_rmw(ANA_CL_DSCP_CFG_DSCP_TRUST_ENA_SET(1),
+				 ANA_CL_DSCP_CFG_DSCP_TRUST_ENA, sparx5,
+				 ANA_CL_DSCP_CFG(i));
+		}
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_port.h b/drivers/net/ethernet/microchip/sparx5/sparx5_port.h
index ae9625cbca8e..6141c0278e87 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_port.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_port.h
@@ -99,14 +99,26 @@ struct sparx5_port_qos_pcp_map {
 	u8 map[SPARX5_PORT_QOS_PCP_DEI_COUNT];
 };
 
+#define SPARX5_PORT_QOS_DSCP_COUNT 64
+struct sparx5_port_qos_dscp_map {
+	u8 map[SPARX5_PORT_QOS_DSCP_COUNT];
+};
+
 struct sparx5_port_qos_pcp {
 	struct sparx5_port_qos_pcp_map map;
 	bool qos_enable;
 	bool dp_enable;
 };
 
+struct sparx5_port_qos_dscp {
+	struct sparx5_port_qos_dscp_map map;
+	bool qos_enable;
+	bool dp_enable;
+};
+
 struct sparx5_port_qos {
 	struct sparx5_port_qos_pcp pcp;
+	struct sparx5_port_qos_dscp dscp;
 };
 
 int sparx5_port_qos_set(struct sparx5_port *port, struct sparx5_port_qos *qos);
@@ -114,4 +126,6 @@ int sparx5_port_qos_set(struct sparx5_port *port, struct sparx5_port_qos *qos);
 int sparx5_port_qos_pcp_set(const struct sparx5_port *port,
 			    struct sparx5_port_qos_pcp *qos);
 
+int sparx5_port_qos_dscp_set(const struct sparx5_port *port,
+			     struct sparx5_port_qos_dscp *qos);
 #endif	/* __SPARX5_PORT_H__ */
-- 
2.34.1

