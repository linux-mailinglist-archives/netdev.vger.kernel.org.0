Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B3961123F
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 15:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbiJ1NF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 09:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiJ1NFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 09:05:17 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF28B42E51;
        Fri, 28 Oct 2022 06:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666962303; x=1698498303;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RrK2+3cqj0cFJ7faR9AV0V6TkeBPHwqWpVe0OmCgx2M=;
  b=sh6AKPMAsVDUYZpScSvvdsRo33mLEWNp+dVSFyNfrlP7RO30FXq4yV5g
   BQAyq4POcR/r86kvjGF+Qe7phwv612QefgJGaQ12D2qbPJf1zWT4fd+DH
   9YmcozAYhFfZ00FtWeLuEl7XhePsFk49piM5iNqwrriNTJ1UWgcg5ultj
   WIn2yhs+we5Qaav/L3HPNR/XA2m5YKO1CCM1ov/Txp55iCX75YKmM30OV
   AWNS4IvV/zPoKybfM0eG8L2tkWr2C5rcdlRFw31oZVdlGv+4CpTHlkYXc
   fSyUVSz7GCCnYI3ljJ/6Ib++NCYDNOih0MH7AcCNsH3dWgm1frGdnx3ru
   g==;
X-IronPort-AV: E=Sophos;i="5.95,221,1661842800"; 
   d="scan'208";a="186698640"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Oct 2022 06:05:01 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 28 Oct 2022 06:04:50 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 28 Oct 2022 06:04:47 -0700
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
Subject: [PATCH net-next v5 5/6] net: microchip: sparx5: add support for offloading dscp table
Date:   Fri, 28 Oct 2022 15:14:02 +0200
Message-ID: <20221028131403.1055694-6-daniel.machon@microchip.com>
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

Add support for offloading dscp app entries. Dscp values are global for
all ports on the sparx5 switch. Therefore, we replicate each dscp app
entry per-port.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 .../ethernet/microchip/sparx5/sparx5_dcb.c    | 66 ++++++++++++++++++-
 .../ethernet/microchip/sparx5/sparx5_port.c   | 39 +++++++++++
 .../ethernet/microchip/sparx5/sparx5_port.h   | 13 ++++
 3 files changed, 115 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
index 1fa150d46977..283d5f338e0e 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
@@ -34,6 +34,13 @@ static int sparx5_dcb_app_validate(struct net_device *dev,
 	int err = 0;
 
 	switch (app->selector) {
+	/* Dscp checks */
+	case IEEE_8021QAZ_APP_SEL_DSCP:
+		if (app->protocol > 63)
+			err = -EINVAL;
+		else if (app->priority >= SPX5_PRIOS)
+			err = -ERANGE;
+		break;
 	/* Pcp checks */
 	case DCB_APP_SEL_PCP:
 		if (app->protocol > 15)
@@ -104,17 +111,27 @@ static bool sparx5_dcb_apptrust_contains(int portno, u8 selector)
 
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
@@ -125,9 +142,44 @@ static int sparx5_dcb_app_update(struct net_device *dev)
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
@@ -146,7 +198,11 @@ static int sparx5_dcb_ieee_setapp(struct net_device *dev, struct dcb_app *app)
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
 
@@ -160,7 +216,11 @@ static int sparx5_dcb_ieee_delapp(struct net_device *dev, struct dcb_app *app)
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
index 99e86e87aa16..fb5e321c4896 100644
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
index fae9f5464548..a0cd53fa3ad0 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_port.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_port.h
@@ -95,14 +95,25 @@ struct sparx5_port_qos_pcp_map {
 	u8 map[16];
 };
 
+struct sparx5_port_qos_dscp_map {
+	u8 map[64];
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
@@ -110,4 +121,6 @@ int sparx5_port_qos_set(struct sparx5_port *port, struct sparx5_port_qos *qos);
 int sparx5_port_qos_pcp_set(const struct sparx5_port *port,
 			    struct sparx5_port_qos_pcp *qos);
 
+int sparx5_port_qos_dscp_set(const struct sparx5_port *port,
+			     struct sparx5_port_qos_dscp *qos);
 #endif	/* __SPARX5_PORT_H__ */
-- 
2.34.1

