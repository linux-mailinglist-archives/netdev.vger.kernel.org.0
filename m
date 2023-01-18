Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8E3672A03
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjARVJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbjARVJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:09:11 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F714611CE;
        Wed, 18 Jan 2023 13:09:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674076147; x=1705612147;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TxozTmbPs0Bq89lAb6eY8EV8ZkDaBK713HDS80D6e2o=;
  b=XOrOgG7HZSC16OEgr22nOJJoiQd8FpXDJGFzKvq49wGXshVmFpQpEvr1
   2uzYCxuXKcP5NUpcHe+ij5/3zV9H8qOj6PIVgVEnAon4oTKs/0TVhZDM0
   QfDOwLIVZ7yM3JQZT3pESGwlrJjlrRdT+QiMF92FoZF+ng/UgmJoC1r9X
   4Dp5DJ2thUV/MnmMFLJJsNNw7cnXw1wxQaK9zcKY/S7TqOqwySY7mKPVR
   jQKM055U6O5il3FIA5caYWoyLutpdclLHxlTAS0hzbswjNuuq5PiDnbfR
   XL446IFlExQLtvevADokATxf4HiOufO7W5k8uugEUlZ6xY5VbQPgzSnoh
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,226,1669100400"; 
   d="scan'208";a="208374481"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Jan 2023 14:09:06 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 14:09:06 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 14:09:02 -0700
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
Subject: [PATCH net-next v3 6/6] net: microchip: sparx5: add support for DSCP rewrite
Date:   Wed, 18 Jan 2023 22:08:30 +0100
Message-ID: <20230118210830.2287069-7-daniel.machon@microchip.com>
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

Add support for DSCP rewrite in Sparx5 driver. On egress DSCP is
rewritten from either classified DSCP, or frame DSCP. Classified DSCP is
determined by the Analyzer Classifier on ingress, and is mapped from
classified QoS class and DP level. Classification of DSCP is by default
enabled for all ports.

It is required that DSCP is trusted for the egress port *and* rewrite
table is not empty, in order to rewrite DSCP based on classified DSCP,
otherwise DSCP is always rewritten from frame DSCP.

classified_dscp = qos_dscp_map[8 * dp_level + qos_class];
if (active_mappings && dscp_is_trusted)
	rewritten_dscp = classified_dscp
else
	rewritten_dscp = frame_dscp

To rewrite DSCP to 20 for any frames with priority 7:

$ dcb apptrust set dev eth0 order dscp
$ dcb rewr add dev eth0 7:20 <-- not in iproute2/dcb yet

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 .../ethernet/microchip/sparx5/sparx5_dcb.c    | 35 ++++++++++++++++
 .../microchip/sparx5/sparx5_main_regs.h       | 26 ++++++++++++
 .../ethernet/microchip/sparx5/sparx5_port.c   | 40 +++++++++++++++++++
 .../ethernet/microchip/sparx5/sparx5_port.h   | 23 +++++++++++
 4 files changed, 124 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
index dd321dd9f223..871a3e62f852 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
@@ -133,6 +133,7 @@ static bool sparx5_dcb_apptrust_contains(int portno, u8 selector)
 
 static int sparx5_dcb_app_update(struct net_device *dev)
 {
+	struct dcb_ieee_app_prio_map dscp_rewr_map = {0};
 	struct dcb_rewr_prio_pcp_map pcp_rewr_map = {0};
 	struct sparx5_port *port = netdev_priv(dev);
 	struct sparx5_port_qos_dscp_map *dscp_map;
@@ -140,7 +141,9 @@ static int sparx5_dcb_app_update(struct net_device *dev)
 	struct sparx5_port_qos qos = {0};
 	struct dcb_app app_itr = {0};
 	int portno = port->portno;
+	bool dscp_rewr = false;
 	bool pcp_rewr = false;
+	u16 dscp;
 	int i;
 
 	dscp_map = &qos.dscp.map;
@@ -174,6 +177,26 @@ static int sparx5_dcb_app_update(struct net_device *dev)
 		qos.pcp_rewr.map.map[i] = fls(pcp_rewr_map.map[i]) - 1;
 	}
 
+	/* Get dscp rewrite mapping */
+	dcb_getrewr_prio_dscp_mask_map(dev, &dscp_rewr_map);
+	for (i = 0; i < ARRAY_SIZE(dscp_rewr_map.map); i++) {
+		if (!dscp_rewr_map.map[i])
+			continue;
+
+		/* The rewrite table of the switch has 32 entries; one for each
+		 * priority for each DP level. Currently, the rewrite map does
+		 * not indicate DP level, so we map classified QoS class to
+		 * classified DSCP, for each classified DP level. Rewrite of
+		 * DSCP is only enabled, if we have active mappings.
+		 */
+		dscp_rewr = true;
+		dscp = fls64(dscp_rewr_map.map[i]) - 1;
+		qos.dscp_rewr.map.map[i] = dscp;      /* DP 0 */
+		qos.dscp_rewr.map.map[i + 8] = dscp;  /* DP 1 */
+		qos.dscp_rewr.map.map[i + 16] = dscp; /* DP 2 */
+		qos.dscp_rewr.map.map[i + 24] = dscp; /* DP 3 */
+	}
+
 	/* Enable use of pcp for queue classification ? */
 	if (sparx5_dcb_apptrust_contains(portno, DCB_APP_SEL_PCP)) {
 		qos.pcp.qos_enable = true;
@@ -189,6 +212,12 @@ static int sparx5_dcb_app_update(struct net_device *dev)
 	if (sparx5_dcb_apptrust_contains(portno, IEEE_8021QAZ_APP_SEL_DSCP)) {
 		qos.dscp.qos_enable = true;
 		qos.dscp.dp_enable = qos.dscp.qos_enable;
+		if (dscp_rewr)
+			/* Do not enable rewrite if no mappings are active, as
+			 * classified DSCP will then be zero for all classified
+			 * QoS class and DP combinations.
+			 */
+			qos.dscp_rewr.enable = true;
 	}
 
 	return sparx5_port_qos_set(port, &qos);
@@ -366,6 +395,12 @@ int sparx5_dcb_init(struct sparx5 *sparx5)
 		sparx5_port_apptrust[port->portno] =
 			&sparx5_dcb_apptrust_policies
 				[SPARX5_DCB_APPTRUST_DSCP_PCP];
+
+		/* Enable DSCP classification based on classified QoS class and
+		 * DP, for all DSCP values, for all ports.
+		 */
+		sparx5_port_qos_dscp_rewr_mode_set(port,
+						   SPARX5_PORT_REW_DSCP_ALL);
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
index 0d3bf2e84102..a4a4d893dcb2 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
@@ -885,6 +885,16 @@ enum sparx5_target {
 #define ANA_CL_DSCP_CFG_DSCP_TRUST_ENA_GET(x)\
 	FIELD_GET(ANA_CL_DSCP_CFG_DSCP_TRUST_ENA, x)
 
+/*      ANA_CL:COMMON:QOS_MAP_CFG */
+#define ANA_CL_QOS_MAP_CFG(r) \
+	__REG(TARGET_ANA_CL, 0, 1, 166912, 0, 1, 756, 512, r, 32, 4)
+
+#define ANA_CL_QOS_MAP_CFG_DSCP_REWR_VAL         GENMASK(9, 4)
+#define ANA_CL_QOS_MAP_CFG_DSCP_REWR_VAL_SET(x)\
+	FIELD_PREP(ANA_CL_QOS_MAP_CFG_DSCP_REWR_VAL, x)
+#define ANA_CL_QOS_MAP_CFG_DSCP_REWR_VAL_GET(x)\
+	FIELD_GET(ANA_CL_QOS_MAP_CFG_DSCP_REWR_VAL, x)
+
 /*      ANA_L2:COMMON:AUTO_LRN_CFG */
 #define ANA_L2_AUTO_LRN_CFG       __REG(TARGET_ANA_L2, 0, 1, 566024, 0, 1, 700, 24, 0, 1, 4)
 
@@ -5385,6 +5395,22 @@ enum sparx5_target {
 #define REW_DEI_MAP_DE1_DEI_DE1_GET(x)\
 	FIELD_GET(REW_DEI_MAP_DE1_DEI_DE1, x)
 
+/*      REW:PORT:DSCP_MAP */
+#define REW_DSCP_MAP(g) \
+	__REG(TARGET_REW, 0, 1, 360448, g, 70, 256, 136, 0, 1, 4)
+
+#define REW_DSCP_MAP_DSCP_UPDATE_ENA             BIT(1)
+#define REW_DSCP_MAP_DSCP_UPDATE_ENA_SET(x)\
+	FIELD_PREP(REW_DSCP_MAP_DSCP_UPDATE_ENA, x)
+#define REW_DSCP_MAP_DSCP_UPDATE_ENA_GET(x)\
+	FIELD_GET(REW_DSCP_MAP_DSCP_UPDATE_ENA, x)
+
+#define REW_DSCP_MAP_DSCP_REMAP_ENA              BIT(0)
+#define REW_DSCP_MAP_DSCP_REMAP_ENA_SET(x)\
+	FIELD_PREP(REW_DSCP_MAP_DSCP_REMAP_ENA, x)
+#define REW_DSCP_MAP_DSCP_REMAP_ENA_GET(x)\
+	FIELD_GET(REW_DSCP_MAP_DSCP_REMAP_ENA, x)
+
 /*      REW:PORT:TAG_CTRL */
 #define REW_TAG_CTRL(g)           __REG(TARGET_REW, 0, 1, 360448, g, 70, 256, 132, 0, 1, 4)
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_port.c b/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
index c8b5087769ed..246259b2ae94 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
@@ -1152,6 +1152,7 @@ int sparx5_port_qos_set(struct sparx5_port *port,
 	sparx5_port_qos_dscp_set(port, &qos->dscp);
 	sparx5_port_qos_pcp_set(port, &qos->pcp);
 	sparx5_port_qos_pcp_rewr_set(port, &qos->pcp_rewr);
+	sparx5_port_qos_dscp_rewr_set(port, &qos->dscp_rewr);
 	sparx5_port_qos_default_set(port, qos);
 
 	return 0;
@@ -1241,6 +1242,45 @@ int sparx5_port_qos_pcp_set(const struct sparx5_port *port,
 	return 0;
 }
 
+void sparx5_port_qos_dscp_rewr_mode_set(const struct sparx5_port *port,
+					int mode)
+{
+	spx5_rmw(ANA_CL_QOS_CFG_DSCP_REWR_MODE_SEL_SET(mode),
+		 ANA_CL_QOS_CFG_DSCP_REWR_MODE_SEL, port->sparx5,
+		 ANA_CL_QOS_CFG(port->portno));
+}
+
+int sparx5_port_qos_dscp_rewr_set(const struct sparx5_port *port,
+				  struct sparx5_port_qos_dscp_rewr *qos)
+{
+	struct sparx5 *sparx5 = port->sparx5;
+	bool rewr = false;
+	u16 dscp;
+	int i;
+
+	/* On egress, rewrite DSCP value to either classified DSCP or frame
+	 * DSCP. If enabled; classified DSCP, if disabled; frame DSCP.
+	 */
+	if (qos->enable)
+		rewr = true;
+
+	spx5_rmw(REW_DSCP_MAP_DSCP_UPDATE_ENA_SET(rewr),
+		 REW_DSCP_MAP_DSCP_UPDATE_ENA, sparx5,
+		 REW_DSCP_MAP(port->portno));
+
+	/* On ingress, map each classified QoS class and DP to classified DSCP
+	 * value. This mapping table is global for all ports.
+	 */
+	for (i = 0; i < ARRAY_SIZE(qos->map.map); i++) {
+		dscp = qos->map.map[i];
+		spx5_rmw(ANA_CL_QOS_MAP_CFG_DSCP_REWR_VAL_SET(dscp),
+			 ANA_CL_QOS_MAP_CFG_DSCP_REWR_VAL, sparx5,
+			 ANA_CL_QOS_MAP_CFG(i));
+	}
+
+	return 0;
+}
+
 int sparx5_port_qos_dscp_set(const struct sparx5_port *port,
 			     struct sparx5_port_qos_dscp *qos)
 {
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_port.h b/drivers/net/ethernet/microchip/sparx5/sparx5_port.h
index b09c09d10a16..607c4ff1df6b 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_port.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_port.h
@@ -14,6 +14,12 @@
 #define SPARX5_PORT_REW_TAG_CTRL_DEFAULT 1
 #define SPARX5_PORT_REW_TAG_CTRL_MAPPED  2
 
+/* Port DSCP rewrite mode */
+#define SPARX5_PORT_REW_DSCP_NONE 0
+#define SPARX5_PORT_REW_DSCP_IF_ZERO 1
+#define SPARX5_PORT_REW_DSCP_SELECTED  2
+#define SPARX5_PORT_REW_DSCP_ALL 3
+
 static inline bool sparx5_port_is_2g5(int portno)
 {
 	return portno >= 16 && portno <= 47;
@@ -108,6 +114,11 @@ struct sparx5_port_qos_pcp_rewr_map {
 	u16 map[SPX5_PRIOS];
 };
 
+#define SPARX5_PORT_QOS_DP_NUM 4
+struct sparx5_port_qos_dscp_rewr_map {
+	u16 map[SPX5_PRIOS * SPARX5_PORT_QOS_DP_NUM];
+};
+
 #define SPARX5_PORT_QOS_DSCP_COUNT 64
 struct sparx5_port_qos_dscp_map {
 	u8 map[SPARX5_PORT_QOS_DSCP_COUNT];
@@ -130,10 +141,16 @@ struct sparx5_port_qos_dscp {
 	bool dp_enable;
 };
 
+struct sparx5_port_qos_dscp_rewr {
+	struct sparx5_port_qos_dscp_rewr_map map;
+	bool enable;
+};
+
 struct sparx5_port_qos {
 	struct sparx5_port_qos_pcp pcp;
 	struct sparx5_port_qos_pcp_rewr pcp_rewr;
 	struct sparx5_port_qos_dscp dscp;
+	struct sparx5_port_qos_dscp_rewr dscp_rewr;
 	u8 default_prio;
 };
 
@@ -148,6 +165,12 @@ int sparx5_port_qos_pcp_rewr_set(const struct sparx5_port *port,
 int sparx5_port_qos_dscp_set(const struct sparx5_port *port,
 			     struct sparx5_port_qos_dscp *qos);
 
+void sparx5_port_qos_dscp_rewr_mode_set(const struct sparx5_port *port,
+					int mode);
+
+int sparx5_port_qos_dscp_rewr_set(const struct sparx5_port *port,
+				  struct sparx5_port_qos_dscp_rewr *qos);
+
 int sparx5_port_qos_default_set(const struct sparx5_port *port,
 				const struct sparx5_port_qos *qos);
 
-- 
2.34.1

