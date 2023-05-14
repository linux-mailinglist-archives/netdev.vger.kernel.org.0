Return-Path: <netdev+bounces-2444-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 23CCA701F77
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 22:12:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D479A28108F
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 20:12:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6284C120;
	Sun, 14 May 2023 20:11:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E49BE63
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 20:11:29 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CFA172A;
	Sun, 14 May 2023 13:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684095088; x=1715631088;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7YaGTdp9shyBH18xqJKRb7USr12+Fc7HjIoRXdFaCBs=;
  b=yPGaCH3GjuVByE93C5pc+2aoHEkPSwJZ/SiVzoKLDC/1OaOyqigcl4n6
   2/yENQtrRoDzvos9+LNe8umgjb45CnS+dVOgbdFjzhmUrKhKchVYBD4Lf
   wx0119JF2EwGHdxMY3Bfyk/0INpzEiqFw9jiY+FhCsD0mIovlppwONT1K
   9QxAAdj5N7RWlmQAru317IlqfE3+jq51oDWramqQHmRcztya8jMqP+Gv9
   fotLaV4pGXrVFRomGDPr+V0FE18htMxKtc/4pV0FXWYI/XdZe5RUhKZkn
   V+NcpItb+UptKu2BJ38KbI9AKvr+LRtWfx4teen+KwBR8T96Forkjyalx
   w==;
X-IronPort-AV: E=Sophos;i="5.99,274,1677567600"; 
   d="scan'208";a="151989748"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 May 2023 13:11:27 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 14 May 2023 13:11:27 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Sun, 14 May 2023 13:11:25 -0700
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>, Horatiu Vultur
	<horatiu.vultur@microchip.com>
Subject: [PATCH net-next 4/7] net: lan966x: Add support for offloading dscp table
Date: Sun, 14 May 2023 22:10:26 +0200
Message-ID: <20230514201029.1867738-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230514201029.1867738-1-horatiu.vultur@microchip.com>
References: <20230514201029.1867738-1-horatiu.vultur@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add support for offloading dscp app entries. The dscp values are global
for all lan966x ports.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_dcb.c  | 61 +++++++++++++++++--
 .../ethernet/microchip/lan966x/lan966x_main.h |  8 +++
 .../ethernet/microchip/lan966x/lan966x_port.c | 26 ++++++++
 3 files changed, 90 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c b/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c
index c149f905fe9e3..2b518181b7f08 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c
@@ -57,19 +57,62 @@ static void lan966x_dcb_app_update(struct net_device *dev)
 		qos.pcp.map[i] = dcb_getapp(dev, &app_itr);
 	}
 
+	/* Get dscp ingress mapping */
+	for (int i = 0; i < ARRAY_SIZE(qos.dscp.map); i++) {
+		app_itr.selector = IEEE_8021QAZ_APP_SEL_DSCP;
+		app_itr.protocol = i;
+		qos.dscp.map[i] = dcb_getapp(dev, &app_itr);
+	}
+
 	/* Enable use of pcp for queue classification */
 	if (lan966x_dcb_apptrust_contains(port->chip_port, DCB_APP_SEL_PCP))
 		qos.pcp.enable = true;
 
+	/* Enable use of dscp for queue classification */
+	if (lan966x_dcb_apptrust_contains(port->chip_port, IEEE_8021QAZ_APP_SEL_DSCP))
+		qos.dscp.enable = true;
+
 	lan966x_port_qos_set(port, &qos);
 }
 
+/* DSCP mapping is global for all ports, so set and delete app entries are
+ * replicated for each port.
+ */
+static int lan966x_dcb_ieee_dscp_setdel(struct net_device *dev,
+					struct dcb_app *app,
+					int (*setdel)(struct net_device *,
+						      struct dcb_app *))
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+	int err;
+
+	for (int i = 0; i < NUM_PHYS_PORTS; i++) {
+		port = lan966x->ports[i];
+		if (!port)
+			continue;
+
+		err = setdel(port->dev, app);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 static int lan966x_dcb_app_validate(struct net_device *dev,
 				    const struct dcb_app *app)
 {
 	int err = 0;
 
 	switch (app->selector) {
+	/* Dscp checks */
+	case IEEE_8021QAZ_APP_SEL_DSCP:
+		if (app->protocol >= LAN966X_PORT_QOS_DSCP_COUNT)
+			err = -EINVAL;
+		else if (app->priority >= NUM_PRIO_QUEUES)
+			err = -ERANGE;
+		break;
 	/* Pcp checks */
 	case DCB_APP_SEL_PCP:
 		if (app->protocol >= LAN966X_PORT_QOS_PCP_DEI_COUNT)
@@ -93,8 +136,12 @@ static int lan966x_dcb_ieee_delapp(struct net_device *dev, struct dcb_app *app)
 {
 	int err;
 
-	err = dcb_ieee_delapp(dev, app);
-	if (err < 0)
+	if (app->selector == IEEE_8021QAZ_APP_SEL_DSCP)
+		err = lan966x_dcb_ieee_dscp_setdel(dev, app, dcb_ieee_delapp);
+	else
+		err = dcb_ieee_delapp(dev, app);
+
+	if (err)
 		return err;
 
 	lan966x_dcb_app_update(dev);
@@ -117,12 +164,16 @@ static int lan966x_dcb_ieee_setapp(struct net_device *dev, struct dcb_app *app)
 	if (prio) {
 		app_itr = *app;
 		app_itr .priority = prio;
-		dcb_ieee_delapp(dev, &app_itr);
+		lan966x_dcb_ieee_delapp(dev, &app_itr);
 	}
 
-	err = dcb_ieee_setapp(dev, app);
+	if (app->selector == IEEE_8021QAZ_APP_SEL_DSCP)
+		err = lan966x_dcb_ieee_dscp_setdel(dev, app, dcb_ieee_setapp);
+	else
+		err = dcb_ieee_setapp(dev, app);
+
 	if (err)
-		goto out;
+		return err;
 
 	lan966x_dcb_app_update(dev);
 
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index b9ca47ab6e8be..8213440e08672 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -109,6 +109,8 @@
 #define LAN966X_PORT_QOS_PCP_DEI_COUNT \
 	(LAN966X_PORT_QOS_PCP_COUNT + LAN966X_PORT_QOS_DEI_COUNT)
 
+#define LAN966X_PORT_QOS_DSCP_COUNT	64
+
 /* MAC table entry types.
  * ENTRYTYPE_NORMAL is subject to aging.
  * ENTRYTYPE_LOCKED is not subject to aging.
@@ -402,8 +404,14 @@ struct lan966x_port_qos_pcp {
 	bool enable;
 };
 
+struct lan966x_port_qos_dscp {
+	u8 map[LAN966X_PORT_QOS_DSCP_COUNT];
+	bool enable;
+};
+
 struct lan966x_port_qos {
 	struct lan966x_port_qos_pcp pcp;
+	struct lan966x_port_qos_dscp dscp;
 };
 
 struct lan966x_port {
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
index 0cee8127c48eb..11c552e87ee44 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
@@ -418,10 +418,36 @@ static void lan966x_port_qos_pcp_set(struct lan966x_port *port,
 	}
 }
 
+static void lan966x_port_qos_dscp_set(struct lan966x_port *port,
+				      struct lan966x_port_qos_dscp *qos)
+{
+	struct lan966x *lan966x = port->lan966x;
+
+	/* Enable/disable dscp for qos classification. */
+	lan_rmw(ANA_QOS_CFG_QOS_DSCP_ENA_SET(qos->enable),
+		ANA_QOS_CFG_QOS_DSCP_ENA,
+		lan966x, ANA_QOS_CFG(port->chip_port));
+
+	/* Map each dscp value to priority and dp */
+	for (int i = 0; i < ARRAY_SIZE(qos->map); i++)
+		lan_rmw(ANA_DSCP_CFG_DP_DSCP_VAL_SET(0) |
+			ANA_DSCP_CFG_QOS_DSCP_VAL_SET(*(qos->map + i)),
+			ANA_DSCP_CFG_DP_DSCP_VAL |
+			ANA_DSCP_CFG_QOS_DSCP_VAL,
+			lan966x, ANA_DSCP_CFG(i));
+
+	/* Set per-dscp trust */
+	for (int i = 0; i <  ARRAY_SIZE(qos->map); i++)
+		lan_rmw(ANA_DSCP_CFG_DSCP_TRUST_ENA_SET(qos->enable),
+			ANA_DSCP_CFG_DSCP_TRUST_ENA,
+			lan966x, ANA_DSCP_CFG(i));
+}
+
 void lan966x_port_qos_set(struct lan966x_port *port,
 			  struct lan966x_port_qos *qos)
 {
 	lan966x_port_qos_pcp_set(port, &qos->pcp);
+	lan966x_port_qos_dscp_set(port, &qos->dscp);
 }
 
 void lan966x_port_init(struct lan966x_port *port)
-- 
2.38.0


