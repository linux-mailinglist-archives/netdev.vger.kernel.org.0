Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFBCB611238
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 15:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiJ1NE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 09:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiJ1NEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 09:04:53 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3902E0F5;
        Fri, 28 Oct 2022 06:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666962288; x=1698498288;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JW8/U4h7fYaNc7zi7oS0xFNAW/ub+LYPamgBbsQLIJ0=;
  b=x+p1b6bXsjkpDIBu4c26fli0NmRr76hHMwSC4oCAJppBvbsdlFlldUAw
   8b8u98M4FsXx1uSUjdxf+YugrrYdgJZzsCIm9tZAxEK/c/Z7GdPVZUSgj
   Yp75XQu+qnWj1/ytCSr77uFbOh++RaTONc6gnPTQpYUt3B2Nb86bilhiL
   tO0EhUgLhNR/g0aOgOP6MuacrQONF2Dsc1U7AZYrDFYjleL2o+iuzm5wy
   fAmuWrTO8RcuZP2U+iZC2E+xGvFBkX8u9UaSRJwSFgoNYgFXn30CZtJkN
   kMZVhQ61iYP3okZs7EpSgHZva7QVTrjPa7xYgeTAQU8V0zo3+lHTevfWR
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,221,1661842800"; 
   d="scan'208";a="186779167"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Oct 2022 06:04:48 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 28 Oct 2022 06:04:46 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 28 Oct 2022 06:04:43 -0700
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
Subject: [PATCH net-next v5 4/6] net: microchip: sparx5: add support for apptrust
Date:   Fri, 28 Oct 2022 15:14:01 +0200
Message-ID: <20221028131403.1055694-5-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221028131403.1055694-1-daniel.machon@microchip.com>
References: <20221028131403.1055694-1-daniel.machon@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 .../ethernet/microchip/sparx5/sparx5_dcb.c    | 105 ++++++++++++++++++
 .../ethernet/microchip/sparx5/sparx5_port.c   |   4 +-
 .../ethernet/microchip/sparx5/sparx5_port.h   |   2 +
 3 files changed, 109 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
index 2a6e875a5860..1fa150d46977 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
@@ -8,6 +8,22 @@
 
 #include "sparx5_port.h"
 
+static const struct sparx5_dcb_apptrust {
+	u8 selectors[256];
+	int nselectors;
+	const char *names;
+} *apptrust[SPX5_PORTS];
+
+/* Sparx5 supported apptrust configurations */
+static const struct sparx5_dcb_apptrust apptrust_conf[4] = {
+	/* Empty *must* be first */
+	{ { 0                         }, 0, "empty"    },
+	{ { IEEE_8021QAZ_APP_SEL_DSCP }, 1, "dscp"     },
+	{ { DCB_APP_SEL_PCP           }, 1, "pcp"      },
+	{ { IEEE_8021QAZ_APP_SEL_DSCP,
+	    DCB_APP_SEL_PCP           }, 2, "dscp pcp" },
+};
+
 /* Validate app entry.
  *
  * Check for valid selectors and valid protocol and priority ranges.
@@ -37,12 +53,62 @@ static int sparx5_dcb_app_validate(struct net_device *dev,
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
+	for (i = 0; i < ARRAY_SIZE(apptrust_conf); i++) {
+		if (apptrust_conf[i].nselectors != nselectors)
+			continue;
+		match = true;
+		for (ii = 0; ii < nselectors; ii++) {
+			if (apptrust_conf[i].selectors[ii] !=
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
+		for (i = 0; i < ARRAY_SIZE(apptrust_conf); i++)
+			pr_info("order: %s\n", apptrust_conf[i].names);
+		*err = -EOPNOTSUPP;
+	}
+
+	return i;
+}
+
+static bool sparx5_dcb_apptrust_contains(int portno, u8 selector)
+{
+	const struct sparx5_dcb_apptrust *conf = apptrust[portno];
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
@@ -53,6 +119,12 @@ static int sparx5_dcb_app_update(struct net_device *dev)
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
 
@@ -95,9 +167,40 @@ static int sparx5_dcb_ieee_delapp(struct net_device *dev, struct dcb_app *app)
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
+	apptrust[port->portno] = &apptrust_conf[idx];
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
+	trust = apptrust[port->portno];
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
@@ -110,6 +213,8 @@ int sparx5_dcb_init(struct sparx5 *sparx5)
 		if (!port)
 			continue;
 		port->ndev->dcbnl_ops = &sparx5_dcbnl_ops;
+		/* Initialize [dscp, pcp] default trust */
+		apptrust[port->portno] = &apptrust_conf[3];
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_port.c b/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
index 9ffaaf34d196..99e86e87aa16 100644
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
index 9c5fb6b651db..fae9f5464548 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_port.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_port.h
@@ -97,6 +97,8 @@ struct sparx5_port_qos_pcp_map {
 
 struct sparx5_port_qos_pcp {
 	struct sparx5_port_qos_pcp_map map;
+	bool qos_enable;
+	bool dp_enable;
 };
 
 struct sparx5_port_qos {
-- 
2.34.1

