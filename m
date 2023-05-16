Return-Path: <netdev+bounces-3117-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3100705881
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 22:16:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 976911C20C03
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 20:16:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 626FB271E2;
	Tue, 16 May 2023 20:14:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCE027717
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 20:14:37 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C025E8A5F;
	Tue, 16 May 2023 13:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684268071; x=1715804071;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=duklK51YPFmuIlo8/14GTblSrxR6Ip8p9C9F0oEe0Wo=;
  b=OJkDQCZY7mCO8MqQB9V1hiR3dfYE8s/ITln3Yl1L3GV9gia7pNc/CiMo
   S5ROzXd62Y9pAds8BkM9vJMBsF2L5HgoaJwkWIplkbE4cdNmHO2g7QVwS
   xHt8jh0W+TzVz/kPrqxZeXbqxLv7rPIhnAz81VXczsSOdIDY7r9/gVTLK
   FOzaGnQJ6zHwYVVtd4WAhRjI+Ly1btKorG4QNOWXwN+9uMqV7K3X1T94W
   8ZTy16eNwvUX5kjasn8yJounUf2lRD+Jm/sY+guApu+0dUycL9k49xL9t
   eXqhnJVLiLpyW1Ja1IatV0OFLvAJKfr54S7ymt7ZY3EkXjQoEz4d7Y8Em
   g==;
X-IronPort-AV: E=Sophos;i="5.99,278,1677567600"; 
   d="scan'208";a="215748498"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 May 2023 13:14:30 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 16 May 2023 13:14:30 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Tue, 16 May 2023 13:14:28 -0700
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>,
	<daniel.machon@microchip.com>, <piotr.raczynski@intel.com>, Horatiu Vultur
	<horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 6/7] net: lan966x: Add support for PCP rewrite
Date: Tue, 16 May 2023 22:14:07 +0200
Message-ID: <20230516201408.3172428-7-horatiu.vultur@microchip.com>
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

Add support for rewrite of PCP and DEI value, based on QoS and DP level.

The DCB rewrite table is queried for mappings between priority and
PCP/DEI. The classified DP level is then encoded in the DEI bit, if a
mapping for DEI exists.

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_dcb.c  | 61 ++++++++++++++++++-
 .../ethernet/microchip/lan966x/lan966x_main.h | 10 +++
 .../ethernet/microchip/lan966x/lan966x_port.c | 37 +++++++++++
 3 files changed, 107 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c b/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c
index 273e3bfb23897..0ea6509436531 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c
@@ -46,9 +46,11 @@ static bool lan966x_dcb_apptrust_contains(int portno, u8 selector)
 
 static void lan966x_dcb_app_update(struct net_device *dev)
 {
+	struct dcb_rewr_prio_pcp_map pcp_rewr_map = {0};
 	struct lan966x_port *port = netdev_priv(dev);
 	struct lan966x_port_qos qos = {0};
 	struct dcb_app app_itr;
+	bool pcp_rewr = false;
 
 	/* Get pcp ingress mapping */
 	for (int i = 0; i < ARRAY_SIZE(qos.pcp.map); i++) {
@@ -69,10 +71,24 @@ static void lan966x_dcb_app_update(struct net_device *dev)
 	if (qos.default_prio)
 		qos.default_prio = fls(qos.default_prio) - 1;
 
+	/* Get pcp rewrite mapping */
+	dcb_getrewr_prio_pcp_mask_map(dev, &pcp_rewr_map);
+	for (int i = 0; i < ARRAY_SIZE(pcp_rewr_map.map); i++) {
+		if (!pcp_rewr_map.map[i])
+			continue;
+
+		pcp_rewr = true;
+		qos.pcp_rewr.map[i] = fls(pcp_rewr_map.map[i]) - 1;
+	}
+
 	/* Enable use of pcp for queue classification */
-	if (lan966x_dcb_apptrust_contains(port->chip_port, DCB_APP_SEL_PCP))
+	if (lan966x_dcb_apptrust_contains(port->chip_port, DCB_APP_SEL_PCP)) {
 		qos.pcp.enable = true;
 
+		if (pcp_rewr)
+			qos.pcp_rewr.enable = true;
+	}
+
 	/* Enable use of dscp for queue classification */
 	if (lan966x_dcb_apptrust_contains(port->chip_port, IEEE_8021QAZ_APP_SEL_DSCP))
 		qos.dscp.enable = true;
@@ -252,11 +268,54 @@ static int lan966x_dcb_getapptrust(struct net_device *dev, u8 *selectors,
 	return 0;
 }
 
+static int lan966x_dcb_delrewr(struct net_device *dev, struct dcb_app *app)
+{
+	int err;
+
+	err = dcb_delrewr(dev, app);
+	if (err < 0)
+		return err;
+
+	lan966x_dcb_app_update(dev);
+
+	return 0;
+}
+
+static int lan966x_dcb_setrewr(struct net_device *dev, struct dcb_app *app)
+{
+	struct dcb_app app_itr;
+	u16 proto;
+	int err;
+
+	err = lan966x_dcb_app_validate(dev, app);
+	if (err)
+		goto out;
+
+	/* Delete current mapping, if it exists. */
+	proto = dcb_getrewr(dev, app);
+	if (proto) {
+		app_itr = *app;
+		app_itr.protocol = proto;
+		lan966x_dcb_delrewr(dev, &app_itr);
+	}
+
+	err = dcb_setrewr(dev, app);
+	if (err)
+		goto out;
+
+	lan966x_dcb_app_update(dev);
+
+out:
+	return err;
+}
+
 static const struct dcbnl_rtnl_ops lan966x_dcbnl_ops = {
 	.ieee_setapp = lan966x_dcb_ieee_setapp,
 	.ieee_delapp = lan966x_dcb_ieee_delapp,
 	.dcbnl_setapptrust = lan966x_dcb_setapptrust,
 	.dcbnl_getapptrust = lan966x_dcb_getapptrust,
+	.dcbnl_setrewr = lan966x_dcb_setrewr,
+	.dcbnl_delrewr = lan966x_dcb_delrewr,
 };
 
 void lan966x_dcb_init(struct lan966x *lan966x)
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 53711d5380166..16b0149ac2b5d 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -111,6 +111,10 @@
 
 #define LAN966X_PORT_QOS_DSCP_COUNT	64
 
+/* Port PCP rewrite mode */
+#define LAN966X_PORT_REW_TAG_CTRL_CLASSIFIED	0
+#define LAN966X_PORT_REW_TAG_CTRL_MAPPED	2
+
 /* MAC table entry types.
  * ENTRYTYPE_NORMAL is subject to aging.
  * ENTRYTYPE_LOCKED is not subject to aging.
@@ -409,9 +413,15 @@ struct lan966x_port_qos_dscp {
 	bool enable;
 };
 
+struct lan966x_port_qos_pcp_rewr {
+	u16 map[NUM_PRIO_QUEUES];
+	bool enable;
+};
+
 struct lan966x_port_qos {
 	struct lan966x_port_qos_pcp pcp;
 	struct lan966x_port_qos_dscp dscp;
+	struct lan966x_port_qos_pcp_rewr pcp_rewr;
 	u8 default_prio;
 };
 
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
index a6608876b71ef..6887746d081f6 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
@@ -463,12 +463,49 @@ static int lan966x_port_qos_default_set(struct lan966x_port *port,
 	return 0;
 }
 
+static void lan966x_port_qos_pcp_rewr_set(struct lan966x_port *port,
+					  struct lan966x_port_qos_pcp_rewr *qos)
+{
+	u8 mode = LAN966X_PORT_REW_TAG_CTRL_CLASSIFIED;
+	u8 pcp, dei;
+
+	if (qos->enable)
+		mode = LAN966X_PORT_REW_TAG_CTRL_MAPPED;
+
+	/* Map the values only if it is enabled otherwise will be the classified
+	 * value
+	 */
+	lan_rmw(REW_TAG_CFG_TAG_PCP_CFG_SET(mode) |
+		REW_TAG_CFG_TAG_DEI_CFG_SET(mode),
+		REW_TAG_CFG_TAG_PCP_CFG |
+		REW_TAG_CFG_TAG_DEI_CFG,
+		port->lan966x, REW_TAG_CFG(port->chip_port));
+
+	/* Map each value to pcp and dei */
+	for (int i = 0; i < ARRAY_SIZE(qos->map); i++) {
+		pcp = qos->map[i];
+		if (pcp > LAN966X_PORT_QOS_PCP_COUNT)
+			dei = 1;
+		else
+			dei = 0;
+
+		lan_rmw(REW_PCP_DEI_CFG_DEI_QOS_VAL_SET(dei) |
+			REW_PCP_DEI_CFG_PCP_QOS_VAL_SET(pcp),
+			REW_PCP_DEI_CFG_DEI_QOS_VAL |
+			REW_PCP_DEI_CFG_PCP_QOS_VAL,
+			port->lan966x,
+			REW_PCP_DEI_CFG(port->chip_port,
+					i + dei * LAN966X_PORT_QOS_PCP_COUNT));
+	}
+}
+
 void lan966x_port_qos_set(struct lan966x_port *port,
 			  struct lan966x_port_qos *qos)
 {
 	lan966x_port_qos_pcp_set(port, &qos->pcp);
 	lan966x_port_qos_dscp_set(port, &qos->dscp);
 	lan966x_port_qos_default_set(port, qos);
+	lan966x_port_qos_pcp_rewr_set(port, &qos->pcp_rewr);
 }
 
 void lan966x_port_init(struct lan966x_port *port)
-- 
2.38.0


