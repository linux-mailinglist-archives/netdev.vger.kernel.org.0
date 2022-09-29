Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDE7F5EF4D1
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 13:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235591AbiI2LzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 07:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235550AbiI2Ly7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 07:54:59 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DC42195;
        Thu, 29 Sep 2022 04:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1664452484; x=1695988484;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gvLTUJpUvV2pYzW+d1DB5vq6/GIuNsYPNE7m4vfLchY=;
  b=KDk38qbGt4HKYcEP3WdbxXlbw818xbh+xYTszhXFntGbbChMlEW0p91D
   VQKTpND4sXi1ZQJfdgjVuxaMC+CZhiACKef0J+ytWE7pBUaH/uNv79yjR
   Afaz+AxioLqWQodXSD8++uybBSRgPcuu6X3G2MWp7BoCdzeJjLZiLVzMN
   wj/s2KeWVNDTJBwuWdL1WLHZJTiMEFUnwjM/vut40NR1tDFMB7H0YLzlz
   4j5YbaWOH/hVSI3U3twGmenLMPNRHCX/iVV8gfClfJlf549jbRvWheXXU
   bT8oLgOdj2S+/TW8t8GgpMBB05cH88CQD9spHf6oHD+SQgaGhADbpEUOY
   w==;
X-IronPort-AV: E=Sophos;i="5.93,355,1654585200"; 
   d="scan'208";a="182465605"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Sep 2022 04:54:43 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 29 Sep 2022 04:54:41 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 29 Sep 2022 04:54:38 -0700
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
Subject: [PATCH net-next 6/6] net: microchip: sparx5: add support for offloading default prio
Date:   Thu, 29 Sep 2022 14:03:42 +0200
Message-ID: <20220929120342.2069359-7-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220929120342.2069359-1-daniel.machon@microchip.com>
References: <20220929120342.2069359-1-daniel.machon@microchip.com>
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

Add support for offloading default prio {ETHERTYPE, 0, prio}.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 .../ethernet/microchip/sparx5/sparx5_dcb.c    | 12 ++++++++++
 .../ethernet/microchip/sparx5/sparx5_port.c   | 23 +++++++++++++++++++
 .../ethernet/microchip/sparx5/sparx5_port.h   |  5 ++++
 3 files changed, 40 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
index 0cc46672b59c..50df24972643 100644
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
@@ -119,6 +126,11 @@ static int sparx5_dcb_app_update(struct net_device *dev)
 	dscp_map = &qos.dscp.map;
 	pcp_map = &qos.pcp.map;
 
+	/* Get default prio. */
+	qos.default_prio = dcb_ieee_getapp_default_prio_mask(dev);
+	if (qos.default_prio)
+		qos.default_prio = fls(qos.default_prio) - 1;
+
 	/* Get dscp ingress mapping */
 	dcb_ieee_getapp_dscp_prio_mask_map(dev, dscp_map);
 	for (i = 0; i < ARRAY_SIZE(dscp_map->map); i++)
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
index 00def02455a7..698d7d5a5c4e 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_port.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_port.h
@@ -110,6 +110,7 @@ struct sparx5_port_qos_dscp {
 struct sparx5_port_qos {
 	struct sparx5_port_qos_pcp pcp;
 	struct sparx5_port_qos_dscp dscp;
+	u8 default_prio;
 };
 
 int sparx5_port_qos_set(struct sparx5_port *port, struct sparx5_port_qos *qos);
@@ -119,4 +120,8 @@ int sparx5_port_qos_pcp_set(const struct sparx5_port *port,
 
 int sparx5_port_qos_dscp_set(const struct sparx5_port *port,
 			     struct sparx5_port_qos_dscp *qos);
+
+int sparx5_port_qos_default_set(const struct sparx5_port *port,
+				const struct sparx5_port_qos *qos);
+
 #endif	/* __SPARX5_PORT_H__ */
-- 
2.34.1

