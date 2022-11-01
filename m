Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC916146F1
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 10:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbiKAJkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 05:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbiKAJkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 05:40:08 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B67A193FE;
        Tue,  1 Nov 2022 02:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667295589; x=1698831589;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bHTeWhqSqGwh7ckEHIWWz7GSv9nFjjv8uomyqxQUjJE=;
  b=WobmV7Vvo4nKRjGAAig0HQB2MbcrjGh7UpvOVi2S5/gUdkRIx98oLOsK
   BvvunqUab54cz1g6/qHyxFTI6aWRascqwOM+OqllBNJzTBpjJEmq1H4HJ
   qiPhvXDh9tAVMs6P7w1Y2J3/4rs14TpwZzBf7IRLVO9kzUomFkK7Rk/kn
   SiLF5KPOVqRuQ2nOpHlMSgaIn3m6CRrjh8PNWp0Po5z1PhnaQc/j2PhVQ
   QhPI4jMmteuvB9hwffZaJmqtrzjtP7lyK78DnjfmZ+DIKaXdXXIulwh2A
   gVE7yz9OJXOTneBnfA4vNqQl+3lrRBfsKnVueXjF21iKpQGgijNfEf/LP
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,230,1661842800"; 
   d="scan'208";a="187176688"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Nov 2022 02:39:48 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 1 Nov 2022 02:39:48 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 1 Nov 2022 02:39:44 -0700
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
Subject: [PATCH net-next v6 4/6] net: microchip: sparx5: add support for apptrust
Date:   Tue, 1 Nov 2022 10:48:32 +0100
Message-ID: <20221101094834.2726202-5-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221101094834.2726202-1-daniel.machon@microchip.com>
References: <20221101094834.2726202-1-daniel.machon@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of set/getapptrust() to implement per-selector trust and trust
order.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 .../ethernet/microchip/sparx5/sparx5_dcb.c    | 122 ++++++++++++++++++
 .../ethernet/microchip/sparx5/sparx5_port.c   |   4 +-
 .../ethernet/microchip/sparx5/sparx5_port.h   |   2 +
 3 files changed, 126 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
index df96c17582ef..96100a063e13 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
@@ -8,6 +8,37 @@
 
 #include "sparx5_port.h"
 
+enum sparx5_dcb_apptrust_values {
+	SPARX5_DCB_APPTRUST_EMPTY,
+	SPARX5_DCB_APPTRUST_DSCP,
+	SPARX5_DCB_APPTRUST_PCP,
+	SPARX5_DCB_APPTRUST_DSCP_PCP,
+	__SPARX5_DCB_APPTRUST_MAX
+};
+
+static const struct sparx5_dcb_apptrust {
+	u8 selectors[IEEE_8021QAZ_APP_SEL_MAX + 1];
+	int nselectors;
+} *sparx5_port_apptrust[SPX5_PORTS];
+
+static const char *sparx5_dcb_apptrust_names[__SPARX5_DCB_APPTRUST_MAX] = {
+	[SPARX5_DCB_APPTRUST_EMPTY]    = "empty",
+	[SPARX5_DCB_APPTRUST_DSCP]     = "dscp",
+	[SPARX5_DCB_APPTRUST_PCP]      = "pcp",
+	[SPARX5_DCB_APPTRUST_DSCP_PCP] = "dscp pcp"
+};
+
+/* Sparx5 supported apptrust policies */
+static const struct sparx5_dcb_apptrust
+	sparx5_dcb_apptrust_policies[__SPARX5_DCB_APPTRUST_MAX] = {
+	/* Empty *must* be first */
+	[SPARX5_DCB_APPTRUST_EMPTY]    = { { 0 }, 0 },
+	[SPARX5_DCB_APPTRUST_DSCP]     = { { IEEE_8021QAZ_APP_SEL_DSCP }, 1 },
+	[SPARX5_DCB_APPTRUST_PCP]      = { { DCB_APP_SEL_PCP }, 1 },
+	[SPARX5_DCB_APPTRUST_DSCP_PCP] = { { IEEE_8021QAZ_APP_SEL_DSCP,
+					     DCB_APP_SEL_PCP }, 2 },
+};
+
 /* Validate app entry.
  *
  * Check for valid selectors and valid protocol and priority ranges.
@@ -37,12 +68,62 @@ static int sparx5_dcb_app_validate(struct net_device *dev,
 	return err;
 }
 
+/* Validate apptrust configuration.
+ *
+ * Return index of supported apptrust configuration if valid, otherwise return
+ * error.
+ */
+static int sparx5_dcb_apptrust_validate(struct net_device *dev, u8 *selectors,
+					int nselectors, int *err)
+{
+	bool match;
+	int i, ii;
+
+	for (i = 0; i < ARRAY_SIZE(sparx5_dcb_apptrust_policies); i++) {
+		if (sparx5_dcb_apptrust_policies[i].nselectors != nselectors)
+			continue;
+		match = true;
+		for (ii = 0; ii < nselectors; ii++) {
+			if (sparx5_dcb_apptrust_policies[i].selectors[ii] !=
+			    *(selectors + ii)) {
+				match = false;
+				break;
+			}
+		}
+		if (match)
+			break;
+	}
+
+	/* Requested trust configuration is not supported */
+	if (!match) {
+		netdev_err(dev, "Valid apptrust configurations are:\n");
+		for (i = 0; i < ARRAY_SIZE(sparx5_dcb_apptrust_names); i++)
+			pr_info("order: %s\n", sparx5_dcb_apptrust_names[i]);
+		*err = -EOPNOTSUPP;
+	}
+
+	return i;
+}
+
+static bool sparx5_dcb_apptrust_contains(int portno, u8 selector)
+{
+	const struct sparx5_dcb_apptrust *conf = sparx5_port_apptrust[portno];
+	int i;
+
+	for (i = 0; i < conf->nselectors; i++)
+		if (conf->selectors[i] == selector)
+			return true;
+
+	return false;
+}
+
 static int sparx5_dcb_app_update(struct net_device *dev)
 {
 	struct dcb_app app_itr = { .selector = DCB_APP_SEL_PCP };
 	struct sparx5_port *port = netdev_priv(dev);
 	struct sparx5_port_qos_pcp_map *pcp_map;
 	struct sparx5_port_qos qos = {0};
+	int portno = port->portno;
 	int i;
 
 	pcp_map = &qos.pcp.map;
@@ -53,6 +134,12 @@ static int sparx5_dcb_app_update(struct net_device *dev)
 		pcp_map->map[i] = dcb_getapp(dev, &app_itr);
 	}
 
+	/* Enable use of pcp for queue classification ? */
+	if (sparx5_dcb_apptrust_contains(portno, DCB_APP_SEL_PCP)) {
+		qos.pcp.qos_enable = true;
+		qos.pcp.dp_enable = qos.pcp.qos_enable;
+	}
+
 	return sparx5_port_qos_set(port, &qos);
 }
 
@@ -95,9 +182,40 @@ static int sparx5_dcb_ieee_delapp(struct net_device *dev, struct dcb_app *app)
 	return sparx5_dcb_app_update(dev);
 }
 
+static int sparx5_dcb_setapptrust(struct net_device *dev, u8 *selectors,
+				  int nselectors)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+	int err = 0, idx;
+
+	idx = sparx5_dcb_apptrust_validate(dev, selectors, nselectors, &err);
+	if (err < 0)
+		return err;
+
+	sparx5_port_apptrust[port->portno] = &sparx5_dcb_apptrust_policies[idx];
+
+	return sparx5_dcb_app_update(dev);
+}
+
+static int sparx5_dcb_getapptrust(struct net_device *dev, u8 *selectors,
+				  int *nselectors)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+	const struct sparx5_dcb_apptrust *trust;
+
+	trust = sparx5_port_apptrust[port->portno];
+
+	memcpy(selectors, trust->selectors, trust->nselectors);
+	*nselectors = trust->nselectors;
+
+	return 0;
+}
+
 const struct dcbnl_rtnl_ops sparx5_dcbnl_ops = {
 	.ieee_setapp = sparx5_dcb_ieee_setapp,
 	.ieee_delapp = sparx5_dcb_ieee_delapp,
+	.dcbnl_setapptrust = sparx5_dcb_setapptrust,
+	.dcbnl_getapptrust = sparx5_dcb_getapptrust,
 };
 
 int sparx5_dcb_init(struct sparx5 *sparx5)
@@ -110,6 +228,10 @@ int sparx5_dcb_init(struct sparx5 *sparx5)
 		if (!port)
 			continue;
 		port->ndev->dcbnl_ops = &sparx5_dcbnl_ops;
+		/* Initialize [dscp, pcp] default trust */
+		sparx5_port_apptrust[port->portno] =
+			&sparx5_dcb_apptrust_policies
+				[SPARX5_DCB_APPTRUST_DSCP_PCP];
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_port.c b/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
index 9444ec4fff15..3cd310f5b9ee 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
@@ -1163,8 +1163,8 @@ int sparx5_port_qos_pcp_set(const struct sparx5_port *port,
 	int i;
 
 	/* Enable/disable pcp and dp for qos classification. */
-	spx5_rmw(ANA_CL_QOS_CFG_PCP_DEI_QOS_ENA_SET(1) |
-		 ANA_CL_QOS_CFG_PCP_DEI_DP_ENA_SET(1),
+	spx5_rmw(ANA_CL_QOS_CFG_PCP_DEI_QOS_ENA_SET(qos->qos_enable) |
+		 ANA_CL_QOS_CFG_PCP_DEI_DP_ENA_SET(qos->dp_enable),
 		 ANA_CL_QOS_CFG_PCP_DEI_QOS_ENA | ANA_CL_QOS_CFG_PCP_DEI_DP_ENA,
 		 sparx5, ANA_CL_QOS_CFG(port->portno));
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_port.h b/drivers/net/ethernet/microchip/sparx5/sparx5_port.h
index 331d2ad0913a..ae9625cbca8e 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_port.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_port.h
@@ -101,6 +101,8 @@ struct sparx5_port_qos_pcp_map {
 
 struct sparx5_port_qos_pcp {
 	struct sparx5_port_qos_pcp_map map;
+	bool qos_enable;
+	bool dp_enable;
 };
 
 struct sparx5_port_qos {
-- 
2.34.1

