Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A9F5EFD3A
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 20:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235905AbiI2SnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 14:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235835AbiI2SnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 14:43:06 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4140314AD67;
        Thu, 29 Sep 2022 11:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1664476966; x=1696012966;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H0mwuHjJ6D6j8aKoMTPzwqtRfLpL1RDOiy5ZJp0/mTs=;
  b=pKBM51d85llr5rZBTicA4QuFF3lF/o4h38WvPACHH3x3FAEmyY0gBy8R
   IOeQDbV9FU6tB1XRllb7HzLIyYCAxJreRvdk2r7Hxv2gOVqIZIiZrQe0Y
   IC5oINws8kLAGJrpFSvc/BeWCAPs5h29DKWXszhcCOEfjiusBcPOcZq4w
   F1OU1QTaYFf5LZ0jzbmQJh2QUQe7CGgYvnltYLXkH0QSvCq6sFTlaldQs
   VNsKUGxZRrARLfJAR0+oey084LdXymtKhEpxVhND95QZUgIxbG/eGLbgE
   EfhyPvKJZnML9Bmyf8RTDh2mF8CxFwst9ru7Oii22n6vtiw3yAlvbF5hA
   w==;
X-IronPort-AV: E=Sophos;i="5.93,356,1654585200"; 
   d="scan'208";a="193094708"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Sep 2022 11:42:44 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 29 Sep 2022 11:42:43 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 29 Sep 2022 11:42:39 -0700
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
Subject: [PATCH net-next v2 4/6] net: microchip: sparx5: add support for apptrust
Date:   Thu, 29 Sep 2022 20:52:05 +0200
Message-ID: <20220929185207.2183473-5-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220929185207.2183473-1-daniel.machon@microchip.com>
References: <20220929185207.2183473-1-daniel.machon@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of set/getapptrust() to implement per-selector trust and trust
order.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 .../ethernet/microchip/sparx5/sparx5_dcb.c    | 116 ++++++++++++++++++
 .../ethernet/microchip/sparx5/sparx5_main.h   |   3 +
 .../ethernet/microchip/sparx5/sparx5_port.c   |   4 +-
 .../ethernet/microchip/sparx5/sparx5_port.h   |   2 +
 .../ethernet/microchip/sparx5/sparx5_qos.c    |   4 +
 5 files changed, 127 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
index db17c124dac8..10aeb422b1ae 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
@@ -8,6 +8,22 @@

 #include "sparx5_port.h"

+static const struct sparx5_dcb_apptrust {
+	u8 selectors[256];
+	int nselectors;
+	char *names;
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
@@ -37,12 +53,59 @@ static int sparx5_dcb_app_validate(struct net_device *dev,
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
+	int i;
+
+	for (i = 0; i < IEEE_8021QAZ_APP_SEL_MAX + 1; i++)
+		if (apptrust[portno]->selectors[i] == selector)
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
@@ -53,6 +116,12 @@ static int sparx5_dcb_app_update(struct net_device *dev)
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

@@ -95,7 +164,54 @@ static int sparx5_dcb_ieee_delapp(struct net_device *dev, struct dcb_app *app)
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
+int sparx5_dcb_init(struct sparx5 *sparx5)
+{
+	struct sparx5_port *port;
+	int i;
+
+	for (i = 0; i < SPX5_PORTS; i++) {
+		port = sparx5->ports[i];
+		if (!port)
+			continue;
+		/* Initialize [dscp, pcp] default trust */
+		apptrust[port->portno] = &apptrust_conf[3];
+	}
+
+	return sparx5_dcb_app_update(port->ndev);
+}
+
 const struct dcbnl_rtnl_ops sparx5_dcbnl_ops = {
 	.ieee_setapp = sparx5_dcb_ieee_setapp,
 	.ieee_delapp = sparx5_dcb_ieee_delapp,
+	.dcbnl_setapptrust = sparx5_dcb_setapptrust,
+	.dcbnl_getapptrust = sparx5_dcb_getapptrust,
 };
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index 0d8e04c64584..d07ef2e8b321 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -357,6 +357,9 @@ int sparx5_config_dsm_calendar(struct sparx5 *sparx5);
 void sparx5_get_stats64(struct net_device *ndev, struct rtnl_link_stats64 *stats);
 int sparx_stats_init(struct sparx5 *sparx5);

+/* sparx5_dcb.c */
+int sparx5_dcb_init(struct sparx5 *sparx5);
+
 /* sparx5_netdev.c */
 void sparx5_set_port_ifh_timestamp(void *ifh_hdr, u64 timestamp);
 void sparx5_set_port_ifh_rew_op(void *ifh_hdr, u32 rew_op);
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
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c b/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
index 1e79d0ef0cb8..379e540e5e6a 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
@@ -389,6 +389,10 @@ int sparx5_qos_init(struct sparx5 *sparx5)
 	if (ret < 0)
 		return ret;

+	ret = sparx5_dcb_init(sparx5);
+	if (ret < 0)
+		return ret;
+
 	return 0;
 }

--
2.34.1

