Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01C26672A00
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbjARVJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbjARVJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:09:09 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161EE613F5;
        Wed, 18 Jan 2023 13:09:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674076145; x=1705612145;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eBU/kig49eqP5PrpEeB/IpbjYeGrToeyL2Qvjt7ggj4=;
  b=zwH63QGtfHtp74h73aF3wXmzlRa7REfNNzWbb50Gq3Zv2uJ+CcWrKpqF
   57y80KBDAb6xAhGmQdEFKdgibyKhnOLqGHytL97lFxAIkqe2be935xSX9
   Fxmx3V6CNzVFzbIAgqB5C84uP2DCFa8dr8Icf4RhSCFXBt5a8NYq69gdE
   FlJDloa7Bfya+QxkAPAmTBmvWEPTWbW8+RKgJT6y9FGNfl7ML9HxeQixQ
   rYgnXo75wZWWLePYhDFVVxAvkKUN+CnVgUNKx0/bjOWy1VeyDrUlPPimu
   NIWDJDiEM6CzB9umGoFTs5UQhpAtt7YOKrlhjOqxZ6E8hfx8UYmUxH9Ki
   g==;
X-IronPort-AV: E=Sophos;i="5.97,226,1669100400"; 
   d="scan'208";a="132994326"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Jan 2023 14:09:04 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 14:09:02 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 14:08:59 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <error27@gmail.com>, <horatiu.vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <petrm@nvidia.com>,
        <vladimir.oltean@nxp.com>, <maxime.chevallier@bootlin.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v3 5/6] net: microchip: sparx5: add support for PCP rewrite
Date:   Wed, 18 Jan 2023 22:08:29 +0100
Message-ID: <20230118210830.2287069-6-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230118210830.2287069-1-daniel.machon@microchip.com>
References: <20230118210830.2287069-1-daniel.machon@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for rewrite of PCP and DEI, based on classified Quality of
Service (QoS) class and Drop-Precedence (DP) level.

The DCB rewrite table is queried for mappings between priority and
PCP/DEI. The classified DP level is then encoded in the DEI bit, if a
mapping for DEI exists.

Sparx5 has four DP levels, where by default, 0 is mapped to DE0 and 1-3
are mapped to DE1. If a mapping exists where DEI=1, then all classified
DP levels mapped to DE1 will set the DEI bit. The other way around for
DEI=0. Effectively, this means that the tagged DEI bit will reflect the
DP level for any mappings where DEI=1.

Map priority=1 to PCP=1 and DEI=1:
$ dcb rewr add dev eth0 pcp-prio 1:1de

Map priority=7 to PCP=2 and DEI=0
$ dcb rewr add dev eth0 pcp-prio 7:2nd

Also, sparx5_dcb_ieee_dscp_setdel() has been refactored, to work for
both APP and rewrite entries.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 .../ethernet/microchip/sparx5/sparx5_dcb.c    | 86 ++++++++++++++++---
 .../microchip/sparx5/sparx5_main_regs.h       | 44 +++++++++-
 .../ethernet/microchip/sparx5/sparx5_port.c   | 57 ++++++++++++
 .../ethernet/microchip/sparx5/sparx5_port.h   | 18 ++++
 4 files changed, 191 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
index 74abb946b2a3..dd321dd9f223 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
@@ -133,12 +133,14 @@ static bool sparx5_dcb_apptrust_contains(int portno, u8 selector)
 
 static int sparx5_dcb_app_update(struct net_device *dev)
 {
+	struct dcb_rewr_prio_pcp_map pcp_rewr_map = {0};
 	struct sparx5_port *port = netdev_priv(dev);
 	struct sparx5_port_qos_dscp_map *dscp_map;
 	struct sparx5_port_qos_pcp_map *pcp_map;
 	struct sparx5_port_qos qos = {0};
 	struct dcb_app app_itr = {0};
 	int portno = port->portno;
+	bool pcp_rewr = false;
 	int i;
 
 	dscp_map = &qos.dscp.map;
@@ -163,10 +165,24 @@ static int sparx5_dcb_app_update(struct net_device *dev)
 		pcp_map->map[i] = dcb_getapp(dev, &app_itr);
 	}
 
+	/* Get pcp rewrite mapping */
+	dcb_getrewr_prio_pcp_mask_map(dev, &pcp_rewr_map);
+	for (i = 0; i < ARRAY_SIZE(pcp_rewr_map.map); i++) {
+		if (!pcp_rewr_map.map[i])
+			continue;
+		pcp_rewr = true;
+		qos.pcp_rewr.map.map[i] = fls(pcp_rewr_map.map[i]) - 1;
+	}
+
 	/* Enable use of pcp for queue classification ? */
 	if (sparx5_dcb_apptrust_contains(portno, DCB_APP_SEL_PCP)) {
 		qos.pcp.qos_enable = true;
 		qos.pcp.dp_enable = qos.pcp.qos_enable;
+		/* Enable rewrite of PCP and DEI if PCP is trusted *and* rewrite
+		 * table is not empty.
+		 */
+		if (pcp_rewr)
+			qos.pcp_rewr.enable = true;
 	}
 
 	/* Enable use of dscp for queue classification ? */
@@ -178,16 +194,17 @@ static int sparx5_dcb_app_update(struct net_device *dev)
 	return sparx5_port_qos_set(port, &qos);
 }
 
-/* Set or delete dscp app entry.
+/* Set or delete DSCP app entry.
  *
- * Dscp mapping is global for all ports, so set and delete app entries are
+ * DSCP mapping is global for all ports, so set and delete app entries are
  * replicated for each port.
  */
-static int sparx5_dcb_ieee_dscp_setdel_app(struct net_device *dev,
-					   struct dcb_app *app, bool del)
+static int sparx5_dcb_ieee_dscp_setdel(struct net_device *dev,
+				       struct dcb_app *app,
+				       int (*setdel)(struct net_device *,
+						     struct dcb_app *))
 {
 	struct sparx5_port *port = netdev_priv(dev);
-	struct dcb_app apps[SPX5_PORTS];
 	struct sparx5_port *port_itr;
 	int err, i;
 
@@ -195,11 +212,7 @@ static int sparx5_dcb_ieee_dscp_setdel_app(struct net_device *dev,
 		port_itr = port->sparx5->ports[i];
 		if (!port_itr)
 			continue;
-		memcpy(&apps[i], app, sizeof(struct dcb_app));
-		if (del)
-			err = dcb_ieee_delapp(port_itr->ndev, &apps[i]);
-		else
-			err = dcb_ieee_setapp(port_itr->ndev, &apps[i]);
+		err = setdel(port_itr->ndev, app);
 		if (err)
 			return err;
 	}
@@ -226,7 +239,7 @@ static int sparx5_dcb_ieee_setapp(struct net_device *dev, struct dcb_app *app)
 	}
 
 	if (app->selector == IEEE_8021QAZ_APP_SEL_DSCP)
-		err = sparx5_dcb_ieee_dscp_setdel_app(dev, app, false);
+		err = sparx5_dcb_ieee_dscp_setdel(dev, app, dcb_ieee_setapp);
 	else
 		err = dcb_ieee_setapp(dev, app);
 
@@ -244,7 +257,7 @@ static int sparx5_dcb_ieee_delapp(struct net_device *dev, struct dcb_app *app)
 	int err;
 
 	if (app->selector == IEEE_8021QAZ_APP_SEL_DSCP)
-		err = sparx5_dcb_ieee_dscp_setdel_app(dev, app, true);
+		err = sparx5_dcb_ieee_dscp_setdel(dev, app, dcb_ieee_delapp);
 	else
 		err = dcb_ieee_delapp(dev, app);
 
@@ -283,11 +296,60 @@ static int sparx5_dcb_getapptrust(struct net_device *dev, u8 *selectors,
 	return 0;
 }
 
+static int sparx5_dcb_delrewr(struct net_device *dev, struct dcb_app *app)
+{
+	int err;
+
+	if (app->selector == IEEE_8021QAZ_APP_SEL_DSCP)
+		err = sparx5_dcb_ieee_dscp_setdel(dev, app, dcb_delrewr);
+	else
+		err = dcb_delrewr(dev, app);
+
+	if (err < 0)
+		return err;
+
+	return sparx5_dcb_app_update(dev);
+}
+
+static int sparx5_dcb_setrewr(struct net_device *dev, struct dcb_app *app)
+{
+	struct dcb_app app_itr;
+	int err = 0;
+	u16 proto;
+
+	err = sparx5_dcb_app_validate(dev, app);
+	if (err)
+		goto out;
+
+	/* Delete current mapping, if it exists. */
+	proto = dcb_getrewr(dev, app);
+	if (proto) {
+		app_itr = *app;
+		app_itr.protocol = proto;
+		sparx5_dcb_delrewr(dev, &app_itr);
+	}
+
+	if (app->selector == IEEE_8021QAZ_APP_SEL_DSCP)
+		err = sparx5_dcb_ieee_dscp_setdel(dev, app, dcb_setrewr);
+	else
+		err = dcb_setrewr(dev, app);
+
+	if (err)
+		goto out;
+
+	sparx5_dcb_app_update(dev);
+
+out:
+	return err;
+}
+
 const struct dcbnl_rtnl_ops sparx5_dcbnl_ops = {
 	.ieee_setapp = sparx5_dcb_ieee_setapp,
 	.ieee_delapp = sparx5_dcb_ieee_delapp,
 	.dcbnl_setapptrust = sparx5_dcb_setapptrust,
 	.dcbnl_getapptrust = sparx5_dcb_getapptrust,
+	.dcbnl_setrewr = sparx5_dcb_setrewr,
+	.dcbnl_delrewr = sparx5_dcb_delrewr,
 };
 
 int sparx5_dcb_init(struct sparx5 *sparx5)
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
index 6c93dd6b01b0..0d3bf2e84102 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
@@ -4,8 +4,8 @@
  * Copyright (c) 2021 Microchip Technology Inc.
  */
 
-/* This file is autogenerated by cml-utils 2022-09-28 11:17:02 +0200.
- * Commit ID: 385c8a11d71a9f6a60368d3a3cb648fa257b479a
+/* This file is autogenerated by cml-utils 2022-11-04 11:22:22 +0100.
+ * Commit ID: 498242727be5db9b423cc0923bc966fc7b40607e
  */
 
 #ifndef _SPARX5_MAIN_REGS_H_
@@ -5345,6 +5345,46 @@ enum sparx5_target {
 #define REW_PORT_VLAN_CFG_PORT_VID_GET(x)\
 	FIELD_GET(REW_PORT_VLAN_CFG_PORT_VID, x)
 
+/*      REW:PORT:PCP_MAP_DE0 */
+#define REW_PCP_MAP_DE0(g, r) \
+	__REG(TARGET_REW, 0, 1, 360448, g, 70, 256, 4, r, 8, 4)
+
+#define REW_PCP_MAP_DE0_PCP_DE0                  GENMASK(2, 0)
+#define REW_PCP_MAP_DE0_PCP_DE0_SET(x)\
+	FIELD_PREP(REW_PCP_MAP_DE0_PCP_DE0, x)
+#define REW_PCP_MAP_DE0_PCP_DE0_GET(x)\
+	FIELD_GET(REW_PCP_MAP_DE0_PCP_DE0, x)
+
+/*      REW:PORT:PCP_MAP_DE1 */
+#define REW_PCP_MAP_DE1(g, r) \
+	__REG(TARGET_REW, 0, 1, 360448, g, 70, 256, 36, r, 8, 4)
+
+#define REW_PCP_MAP_DE1_PCP_DE1                  GENMASK(2, 0)
+#define REW_PCP_MAP_DE1_PCP_DE1_SET(x)\
+	FIELD_PREP(REW_PCP_MAP_DE1_PCP_DE1, x)
+#define REW_PCP_MAP_DE1_PCP_DE1_GET(x)\
+	FIELD_GET(REW_PCP_MAP_DE1_PCP_DE1, x)
+
+/*      REW:PORT:DEI_MAP_DE0 */
+#define REW_DEI_MAP_DE0(g, r) \
+	__REG(TARGET_REW, 0, 1, 360448, g, 70, 256, 68, r, 8, 4)
+
+#define REW_DEI_MAP_DE0_DEI_DE0                  BIT(0)
+#define REW_DEI_MAP_DE0_DEI_DE0_SET(x)\
+	FIELD_PREP(REW_DEI_MAP_DE0_DEI_DE0, x)
+#define REW_DEI_MAP_DE0_DEI_DE0_GET(x)\
+	FIELD_GET(REW_DEI_MAP_DE0_DEI_DE0, x)
+
+/*      REW:PORT:DEI_MAP_DE1 */
+#define REW_DEI_MAP_DE1(g, r) \
+	__REG(TARGET_REW, 0, 1, 360448, g, 70, 256, 100, r, 8, 4)
+
+#define REW_DEI_MAP_DE1_DEI_DE1                  BIT(0)
+#define REW_DEI_MAP_DE1_DEI_DE1_SET(x)\
+	FIELD_PREP(REW_DEI_MAP_DE1_DEI_DE1, x)
+#define REW_DEI_MAP_DE1_DEI_DE1_GET(x)\
+	FIELD_GET(REW_DEI_MAP_DE1_DEI_DE1, x)
+
 /*      REW:PORT:TAG_CTRL */
 #define REW_TAG_CTRL(g)           __REG(TARGET_REW, 0, 1, 360448, g, 70, 256, 132, 0, 1, 4)
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_port.c b/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
index 107b9cd931c0..c8b5087769ed 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
@@ -1151,11 +1151,68 @@ int sparx5_port_qos_set(struct sparx5_port *port,
 {
 	sparx5_port_qos_dscp_set(port, &qos->dscp);
 	sparx5_port_qos_pcp_set(port, &qos->pcp);
+	sparx5_port_qos_pcp_rewr_set(port, &qos->pcp_rewr);
 	sparx5_port_qos_default_set(port, qos);
 
 	return 0;
 }
 
+int sparx5_port_qos_pcp_rewr_set(const struct sparx5_port *port,
+				 struct sparx5_port_qos_pcp_rewr *qos)
+{
+	int i, mode = SPARX5_PORT_REW_TAG_CTRL_CLASSIFIED;
+	struct sparx5 *sparx5 = port->sparx5;
+	u8 pcp, dei;
+
+	/* Use mapping table, with classified QoS as index, to map QoS and DP
+	 * to tagged PCP and DEI, if PCP is trusted. Otherwise use classified
+	 * PCP. Classified PCP equals frame PCP.
+	 */
+	if (qos->enable)
+		mode = SPARX5_PORT_REW_TAG_CTRL_MAPPED;
+
+	spx5_rmw(REW_TAG_CTRL_TAG_PCP_CFG_SET(mode) |
+		 REW_TAG_CTRL_TAG_DEI_CFG_SET(mode),
+		 REW_TAG_CTRL_TAG_PCP_CFG | REW_TAG_CTRL_TAG_DEI_CFG,
+		 port->sparx5, REW_TAG_CTRL(port->portno));
+
+	for (i = 0; i < ARRAY_SIZE(qos->map.map); i++) {
+		/* Extract PCP and DEI */
+		pcp = qos->map.map[i];
+		if (pcp > SPARX5_PORT_QOS_PCP_COUNT)
+			dei = 1;
+		else
+			dei = 0;
+
+		/* Rewrite PCP and DEI, for each classified QoS class and DP
+		 * level. This table is only used if tag ctrl mode is set to
+		 * 'mapped'.
+		 *
+		 * 0:0nd   - prio=0 and dp:0 => pcp=0 and dei=0
+		 * 0:0de   - prio=0 and dp:1 => pcp=0 and dei=1
+		 */
+		if (dei) {
+			spx5_rmw(REW_PCP_MAP_DE1_PCP_DE1_SET(pcp),
+				 REW_PCP_MAP_DE1_PCP_DE1, sparx5,
+				 REW_PCP_MAP_DE1(port->portno, i));
+
+			spx5_rmw(REW_DEI_MAP_DE1_DEI_DE1_SET(dei),
+				 REW_DEI_MAP_DE1_DEI_DE1, port->sparx5,
+				 REW_DEI_MAP_DE1(port->portno, i));
+		} else {
+			spx5_rmw(REW_PCP_MAP_DE0_PCP_DE0_SET(pcp),
+				 REW_PCP_MAP_DE0_PCP_DE0, sparx5,
+				 REW_PCP_MAP_DE0(port->portno, i));
+
+			spx5_rmw(REW_DEI_MAP_DE0_DEI_DE0_SET(dei),
+				 REW_DEI_MAP_DE0_DEI_DE0, port->sparx5,
+				 REW_DEI_MAP_DE0(port->portno, i));
+		}
+	}
+
+	return 0;
+}
+
 int sparx5_port_qos_pcp_set(const struct sparx5_port *port,
 			    struct sparx5_port_qos_pcp *qos)
 {
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_port.h b/drivers/net/ethernet/microchip/sparx5/sparx5_port.h
index fbafe22e25cc..b09c09d10a16 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_port.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_port.h
@@ -9,6 +9,11 @@
 
 #include "sparx5_main.h"
 
+/* Port PCP rewrite mode */
+#define SPARX5_PORT_REW_TAG_CTRL_CLASSIFIED 0
+#define SPARX5_PORT_REW_TAG_CTRL_DEFAULT 1
+#define SPARX5_PORT_REW_TAG_CTRL_MAPPED  2
+
 static inline bool sparx5_port_is_2g5(int portno)
 {
 	return portno >= 16 && portno <= 47;
@@ -99,6 +104,10 @@ struct sparx5_port_qos_pcp_map {
 	u8 map[SPARX5_PORT_QOS_PCP_DEI_COUNT];
 };
 
+struct sparx5_port_qos_pcp_rewr_map {
+	u16 map[SPX5_PRIOS];
+};
+
 #define SPARX5_PORT_QOS_DSCP_COUNT 64
 struct sparx5_port_qos_dscp_map {
 	u8 map[SPARX5_PORT_QOS_DSCP_COUNT];
@@ -110,6 +119,11 @@ struct sparx5_port_qos_pcp {
 	bool dp_enable;
 };
 
+struct sparx5_port_qos_pcp_rewr {
+	struct sparx5_port_qos_pcp_rewr_map map;
+	bool enable;
+};
+
 struct sparx5_port_qos_dscp {
 	struct sparx5_port_qos_dscp_map map;
 	bool qos_enable;
@@ -118,6 +132,7 @@ struct sparx5_port_qos_dscp {
 
 struct sparx5_port_qos {
 	struct sparx5_port_qos_pcp pcp;
+	struct sparx5_port_qos_pcp_rewr pcp_rewr;
 	struct sparx5_port_qos_dscp dscp;
 	u8 default_prio;
 };
@@ -127,6 +142,9 @@ int sparx5_port_qos_set(struct sparx5_port *port, struct sparx5_port_qos *qos);
 int sparx5_port_qos_pcp_set(const struct sparx5_port *port,
 			    struct sparx5_port_qos_pcp *qos);
 
+int sparx5_port_qos_pcp_rewr_set(const struct sparx5_port *port,
+				 struct sparx5_port_qos_pcp_rewr *qos);
+
 int sparx5_port_qos_dscp_set(const struct sparx5_port *port,
 			     struct sparx5_port_qos_dscp *qos);
 
-- 
2.34.1

