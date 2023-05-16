Return-Path: <netdev+bounces-3115-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C33970587C
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 22:15:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4843528121F
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 20:15:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B994A2720A;
	Tue, 16 May 2023 20:14:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4605271F6
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 20:14:30 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B917AA4;
	Tue, 16 May 2023 13:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684268067; x=1715804067;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IJ41MGCIxf1x/RNusHwRU1NWoc/mmjmttYkLXaVv/6g=;
  b=DP6/4REFJZxdYHZ/3BeMq3zAfW6vijzwZKPA9Y/+4CEd/P+PEFgVVvQM
   Ilq+OMlX1rBwDbcLBOig5J51A1m8c8/byQ/isLXR6owpuDsYpoZHv32cK
   lzXe2PgM+pkZ0HVmm8iwxqUg1t0+17FaLa7un7c9pcgnkLD8ErTmbUeVV
   BmgadheaIWJUTfGlzD4J6Qh69p/N8WraAFfoW2WyNu+7m40ulTXQHKd8E
   gsxYKA3U88rIPFJlKCyKaQs1yAartUtMvj8AbG9rOSn4HaeBrC+gMXKyL
   1NbIziiveEts3pqTg3sIQDu139G+CEzDhvs1uosXcUt9+FswKpC/PaSqD
   w==;
X-IronPort-AV: E=Sophos;i="5.99,278,1677567600"; 
   d="scan'208";a="152400229"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 May 2023 13:14:27 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 16 May 2023 13:14:25 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Tue, 16 May 2023 13:14:23 -0700
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>,
	<daniel.machon@microchip.com>, <piotr.raczynski@intel.com>, Horatiu Vultur
	<horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 4/7] net: lan966x: Add support for offloading dscp table
Date: Tue, 16 May 2023 22:14:05 +0200
Message-ID: <20230516201408.3172428-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230516201408.3172428-1-horatiu.vultur@microchip.com>
References: <20230516201408.3172428-1-horatiu.vultur@microchip.com>
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
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add support for offloading dscp app entries. The dscp values are global
for all lan966x ports.

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_dcb.c  | 59 +++++++++++++++++--
 .../ethernet/microchip/lan966x/lan966x_main.h |  8 +++
 .../ethernet/microchip/lan966x/lan966x_port.c | 26 ++++++++
 3 files changed, 89 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c b/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c
index d6210c70171e9..17cec9ec5ed25 100644
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
@@ -117,10 +164,14 @@ static int lan966x_dcb_ieee_setapp(struct net_device *dev, struct dcb_app *app)
 	if (prio) {
 		app_itr = *app;
 		app_itr.priority = prio;
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
 		return err;
 
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


