Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6E59609D71
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 11:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbiJXJFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 05:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiJXJFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 05:05:06 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FFF2BB2F;
        Mon, 24 Oct 2022 02:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666602304; x=1698138304;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rVdNzdBQO+N6n0DeTiUUzVhpCEMcLGmACZM8CQ8W5rc=;
  b=o3i8zwZvUsbtmr4MeQnSyu65sPGzKYwEqqgsB8u2J8N03qopRaHU8wDF
   9R8Wq9m6UAE6fd6xsw1eGBKYhLKItcVgCdFesSnRuF9U6XTA+1a42n5/0
   ha0wula+nNTuNAvL4lGegSGP0DbZRbI64agw8+BrEbMxotbtNR4PHdVKO
   f6PQkZRr0qWahSso20TsANYtAjNubIky0JJENyYseWmkn4DxoMvAVU1H4
   MphglpiHzKd8wQXO8vt+wCTD8fKh4CeKJMgE9l+tRHOYxPJSHwUnp8pD2
   /fq9XCT69cCaCkav8+V1JgPTo8ZLR7jzTaNF9VUpP/HrRWhoDzee036PP
   A==;
X-IronPort-AV: E=Sophos;i="5.95,207,1661842800"; 
   d="scan'208";a="180204713"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Oct 2022 02:05:03 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 24 Oct 2022 02:04:57 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 24 Oct 2022 02:04:53 -0700
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
Subject: [net-next v3 6/6] net: microchip: sparx5: add support for offloading default prio
Date:   Mon, 24 Oct 2022 11:13:33 +0200
Message-ID: <20221024091333.1048061-7-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221024091333.1048061-1-daniel.machon@microchip.com>
References: <20221024091333.1048061-1-daniel.machon@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for offloading default prio {ETHERTYPE, 0, prio}.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 .../ethernet/microchip/sparx5/sparx5_dcb.c    | 12 ++++++++++
 .../ethernet/microchip/sparx5/sparx5_port.c   | 23 +++++++++++++++++++
 .../ethernet/microchip/sparx5/sparx5_port.h   |  5 ++++
 3 files changed, 40 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
index 283d5f338e0e..df2374e64b72 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
@@ -34,6 +34,13 @@ static int sparx5_dcb_app_validate(struct net_device *dev,
 	int err = 0;
 
 	switch (app->selector) {
+	/* Default priority checks */
+	case IEEE_8021QAZ_APP_SEL_ETHERTYPE:
+		if (app->protocol != 0)
+			err = -EINVAL;
+		else if (app->priority >= SPX5_PRIOS)
+			err = -ERANGE;
+		break;
 	/* Dscp checks */
 	case IEEE_8021QAZ_APP_SEL_DSCP:
 		if (app->protocol > 63)
@@ -122,6 +129,11 @@ static int sparx5_dcb_app_update(struct net_device *dev)
 	dscp_map = &qos.dscp.map;
 	pcp_map = &qos.pcp.map;
 
+	/* Get default prio. */
+	qos.default_prio = dcb_ieee_getapp_default_prio_mask(dev);
+	if (qos.default_prio)
+		qos.default_prio = fls(qos.default_prio) - 1;
+
 	/* Get dscp ingress mapping */
 	for (i = 0; i < ARRAY_SIZE(dscp_map->map); i++) {
 		app_itr.selector = IEEE_8021QAZ_APP_SEL_DSCP;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_port.c b/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
index fb5e321c4896..73ebe76d7e50 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
@@ -1151,6 +1151,7 @@ int sparx5_port_qos_set(struct sparx5_port *port,
 {
 	sparx5_port_qos_dscp_set(port, &qos->dscp);
 	sparx5_port_qos_pcp_set(port, &qos->pcp);
+	sparx5_port_qos_default_set(port, qos);
 
 	return 0;
 }
@@ -1220,3 +1221,25 @@ int sparx5_port_qos_dscp_set(const struct sparx5_port *port,
 
 	return 0;
 }
+
+int sparx5_port_qos_default_set(const struct sparx5_port *port,
+				const struct sparx5_port_qos *qos)
+{
+	struct sparx5 *sparx5 = port->sparx5;
+
+	/* Set default prio and dp level */
+	spx5_rmw(ANA_CL_QOS_CFG_DEFAULT_QOS_VAL_SET(qos->default_prio) |
+		 ANA_CL_QOS_CFG_DEFAULT_DP_VAL_SET(0),
+		 ANA_CL_QOS_CFG_DEFAULT_QOS_VAL |
+		 ANA_CL_QOS_CFG_DEFAULT_DP_VAL,
+		 sparx5, ANA_CL_QOS_CFG(port->portno));
+
+	/* Set default pcp and dei for untagged frames */
+	spx5_rmw(ANA_CL_VLAN_CTRL_PORT_PCP_SET(0) |
+		 ANA_CL_VLAN_CTRL_PORT_DEI_SET(0),
+		 ANA_CL_VLAN_CTRL_PORT_PCP |
+		 ANA_CL_VLAN_CTRL_PORT_DEI,
+		 sparx5, ANA_CL_VLAN_CTRL(port->portno));
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_port.h b/drivers/net/ethernet/microchip/sparx5/sparx5_port.h
index a0cd53fa3ad0..588eecff59f8 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_port.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_port.h
@@ -114,6 +114,7 @@ struct sparx5_port_qos_dscp {
 struct sparx5_port_qos {
 	struct sparx5_port_qos_pcp pcp;
 	struct sparx5_port_qos_dscp dscp;
+	u8 default_prio;
 };
 
 int sparx5_port_qos_set(struct sparx5_port *port, struct sparx5_port_qos *qos);
@@ -123,4 +124,8 @@ int sparx5_port_qos_pcp_set(const struct sparx5_port *port,
 
 int sparx5_port_qos_dscp_set(const struct sparx5_port *port,
 			     struct sparx5_port_qos_dscp *qos);
+
+int sparx5_port_qos_default_set(const struct sparx5_port *port,
+				const struct sparx5_port_qos *qos);
+
 #endif	/* __SPARX5_PORT_H__ */
-- 
2.34.1

