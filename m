Return-Path: <netdev+bounces-3118-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EBB9A705884
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 22:16:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DACBF1C20C27
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 20:16:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4462D271E8;
	Tue, 16 May 2023 20:14:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E443112D
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 20:14:46 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9375C86AE;
	Tue, 16 May 2023 13:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684268074; x=1715804074;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SjCaKXU41yhQuI5R2Tyv5Ef59MCQWFfFrbSfh4rsgNk=;
  b=cBjRDk7IoBzCdHHn31vc6hEBfxC06weGSlbZkOdc9fRViXCWdyRB5yAO
   R4JpGX4qvFetr8mgwZnww/LE5X6SMv6EP5WBhKNxJtLcLruXYw2CBLBf2
   s+LFBrpl2tEV6ojF2MQ2/GXvsXfuX/rOkyHLtdAqqe3zGjbYyUuoD7bkb
   UC7U0cmRHDt7twSbD2omGIg9ZGF6AZ0UAA7dxnKOsjk3KsaPdB0yQS5Jl
   WMOM/mZBoN03NUJRYV/aPUf+9ddaJToLLgh0ywApSqEfjPbRkg93J3zYx
   08BxDMMXBGGCbtBQ/Ktdg7d9kzLYwlhmZigD5xWTksfWOB5cq7wzSZF9V
   g==;
X-IronPort-AV: E=Sophos;i="5.99,278,1677567600"; 
   d="scan'208";a="213606654"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 May 2023 13:14:34 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 16 May 2023 13:14:32 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Tue, 16 May 2023 13:14:30 -0700
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>,
	<daniel.machon@microchip.com>, <piotr.raczynski@intel.com>, Horatiu Vultur
	<horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 7/7] net: lan966x: Add support for DSCP rewrite
Date: Tue, 16 May 2023 22:14:08 +0200
Message-ID: <20230516201408.3172428-8-horatiu.vultur@microchip.com>
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

Add support for DSCP rewrite in lan966x driver. On egress DSCP is
rewritten from either classified DSCP, or frame DSCP. Classified DSCP is
determined by the Analyzer Classifier on ingress, and is mapped from
classified QoS class and DP level. Classification of DSCP is by default
enabled for all ports.

It is required that DSCP is trusted for the egress port *and* rewrite
table is not empty, in order to rewrite DSCP based on classified DSCP,
otherwise DSCP is always rewritten from frame DSCP.

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_dcb.c  | 36 +++++++++++++++++--
 .../ethernet/microchip/lan966x/lan966x_main.h | 13 +++++++
 .../ethernet/microchip/lan966x/lan966x_port.c | 35 ++++++++++++++++++
 3 files changed, 81 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c b/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c
index 0ea6509436531..ed2d96d7908eb 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c
@@ -46,10 +46,12 @@ static bool lan966x_dcb_apptrust_contains(int portno, u8 selector)
 
 static void lan966x_dcb_app_update(struct net_device *dev)
 {
+	struct dcb_ieee_app_prio_map dscp_rewr_map = {0};
 	struct dcb_rewr_prio_pcp_map pcp_rewr_map = {0};
 	struct lan966x_port *port = netdev_priv(dev);
 	struct lan966x_port_qos qos = {0};
 	struct dcb_app app_itr;
+	bool dscp_rewr = false;
 	bool pcp_rewr = false;
 
 	/* Get pcp ingress mapping */
@@ -81,6 +83,16 @@ static void lan966x_dcb_app_update(struct net_device *dev)
 		qos.pcp_rewr.map[i] = fls(pcp_rewr_map.map[i]) - 1;
 	}
 
+	/* Get dscp rewrite mapping */
+	dcb_getrewr_prio_dscp_mask_map(dev, &dscp_rewr_map);
+	for (int i = 0; i < ARRAY_SIZE(dscp_rewr_map.map); i++) {
+		if (!dscp_rewr_map.map[i])
+			continue;
+
+		dscp_rewr = true;
+		qos.dscp_rewr.map[i] = fls64(dscp_rewr_map.map[i]) - 1;
+	}
+
 	/* Enable use of pcp for queue classification */
 	if (lan966x_dcb_apptrust_contains(port->chip_port, DCB_APP_SEL_PCP)) {
 		qos.pcp.enable = true;
@@ -90,9 +102,13 @@ static void lan966x_dcb_app_update(struct net_device *dev)
 	}
 
 	/* Enable use of dscp for queue classification */
-	if (lan966x_dcb_apptrust_contains(port->chip_port, IEEE_8021QAZ_APP_SEL_DSCP))
+	if (lan966x_dcb_apptrust_contains(port->chip_port, IEEE_8021QAZ_APP_SEL_DSCP)) {
 		qos.dscp.enable = true;
 
+		if (dscp_rewr)
+			qos.dscp_rewr.enable = true;
+	}
+
 	lan966x_port_qos_set(port, &qos);
 }
 
@@ -272,7 +288,11 @@ static int lan966x_dcb_delrewr(struct net_device *dev, struct dcb_app *app)
 {
 	int err;
 
-	err = dcb_delrewr(dev, app);
+	if (app->selector == IEEE_8021QAZ_APP_SEL_DSCP)
+		err = lan966x_dcb_ieee_dscp_setdel(dev, app, dcb_delrewr);
+	else
+		err = dcb_delrewr(dev, app);
+
 	if (err < 0)
 		return err;
 
@@ -299,7 +319,11 @@ static int lan966x_dcb_setrewr(struct net_device *dev, struct dcb_app *app)
 		lan966x_dcb_delrewr(dev, &app_itr);
 	}
 
-	err = dcb_setrewr(dev, app);
+	if (app->selector == IEEE_8021QAZ_APP_SEL_DSCP)
+		err = lan966x_dcb_ieee_dscp_setdel(dev, app, dcb_setrewr);
+	else
+		err = dcb_setrewr(dev, app);
+
 	if (err)
 		goto out;
 
@@ -331,5 +355,11 @@ void lan966x_dcb_init(struct lan966x *lan966x)
 
 		lan966x_port_apptrust[port->chip_port] =
 			&lan966x_dcb_apptrust_policies[LAN966X_DCB_APPTRUST_DSCP_PCP];
+
+		/* Enable DSCP classification based on classified QoS class and
+		 * DP, for all DSCP values, for all ports.
+		 */
+		lan966x_port_qos_dscp_rewr_mode_set(port,
+						    LAN966X_PORT_QOS_REWR_DSCP_ALL);
 	}
 }
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 16b0149ac2b5d..27f272831ea5c 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -115,6 +115,11 @@
 #define LAN966X_PORT_REW_TAG_CTRL_CLASSIFIED	0
 #define LAN966X_PORT_REW_TAG_CTRL_MAPPED	2
 
+/* Port DSCP rewrite mode */
+#define LAN966X_PORT_REW_DSCP_FRAME		0
+#define LAN966X_PORT_REW_DSCP_ANALIZER		1
+#define LAN966X_PORT_QOS_REWR_DSCP_ALL		3
+
 /* MAC table entry types.
  * ENTRYTYPE_NORMAL is subject to aging.
  * ENTRYTYPE_LOCKED is not subject to aging.
@@ -418,10 +423,16 @@ struct lan966x_port_qos_pcp_rewr {
 	bool enable;
 };
 
+struct lan966x_port_qos_dscp_rewr {
+	u16 map[LAN966X_PORT_QOS_DSCP_COUNT];
+	bool enable;
+};
+
 struct lan966x_port_qos {
 	struct lan966x_port_qos_pcp pcp;
 	struct lan966x_port_qos_dscp dscp;
 	struct lan966x_port_qos_pcp_rewr pcp_rewr;
+	struct lan966x_port_qos_dscp_rewr dscp_rewr;
 	u8 default_prio;
 };
 
@@ -491,6 +502,8 @@ void lan966x_port_init(struct lan966x_port *port);
 
 void lan966x_port_qos_set(struct lan966x_port *port,
 			  struct lan966x_port_qos *qos);
+void lan966x_port_qos_dscp_rewr_mode_set(struct lan966x_port *port,
+					 int mode);
 
 int lan966x_mac_ip_learn(struct lan966x *lan966x,
 			 bool cpu_copy,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
index 6887746d081f6..92108d354051c 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
@@ -499,6 +499,40 @@ static void lan966x_port_qos_pcp_rewr_set(struct lan966x_port *port,
 	}
 }
 
+static void lan966x_port_qos_dscp_rewr_set(struct lan966x_port *port,
+					   struct lan966x_port_qos_dscp_rewr *qos)
+{
+	u16 dscp;
+	u8 mode;
+
+	if (qos->enable)
+		mode = LAN966X_PORT_REW_DSCP_ANALIZER;
+	else
+		mode = LAN966X_PORT_REW_DSCP_FRAME;
+
+	/* Enable the rewrite otherwise will use the values from the frame */
+	lan_rmw(REW_DSCP_CFG_DSCP_REWR_CFG_SET(mode),
+		REW_DSCP_CFG_DSCP_REWR_CFG,
+		port->lan966x, REW_DSCP_CFG(port->chip_port));
+
+	/* Map each classified Qos class and DP to classified DSCP value */
+	for (int i = 0; i < ARRAY_SIZE(qos->map); i++) {
+		dscp = qos->map[i];
+
+		lan_rmw(ANA_DSCP_REWR_CFG_DSCP_QOS_REWR_VAL_SET(dscp),
+			ANA_DSCP_REWR_CFG_DSCP_QOS_REWR_VAL,
+			port->lan966x, ANA_DSCP_REWR_CFG(i));
+	}
+}
+
+void lan966x_port_qos_dscp_rewr_mode_set(struct lan966x_port *port,
+					 int mode)
+{
+	lan_rmw(ANA_QOS_CFG_DSCP_REWR_CFG_SET(mode),
+		ANA_QOS_CFG_DSCP_REWR_CFG,
+		port->lan966x, ANA_QOS_CFG(port->chip_port));
+}
+
 void lan966x_port_qos_set(struct lan966x_port *port,
 			  struct lan966x_port_qos *qos)
 {
@@ -506,6 +540,7 @@ void lan966x_port_qos_set(struct lan966x_port *port,
 	lan966x_port_qos_dscp_set(port, &qos->dscp);
 	lan966x_port_qos_default_set(port, qos);
 	lan966x_port_qos_pcp_rewr_set(port, &qos->pcp_rewr);
+	lan966x_port_qos_dscp_rewr_set(port, &qos->dscp_rewr);
 }
 
 void lan966x_port_init(struct lan966x_port *port)
-- 
2.38.0


