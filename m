Return-Path: <netdev+bounces-3113-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F16E705877
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 22:15:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59CF72811A4
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 20:15:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECAD724E9D;
	Tue, 16 May 2023 20:14:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD6E271F6
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 20:14:27 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6B27AB8;
	Tue, 16 May 2023 13:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684268067; x=1715804067;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6GmN2vyl9M4Fdqm+AssNAFL9EhJ9VMbLsi4KxEHNlkU=;
  b=hcTne1OF4NU2KkEgyGHtV06w0ysIu2qjTgKzfU3q4qh/RyzFvIsApRdE
   BYFSF+P/o0cui26tSd25H1i7rqV5LGSU6y2317Hr9F6B29paEI8iImcyb
   3fA7X4AJKmMNHAGeq9PRaJtTBfV3SoMNuH1NYd3a3UT/SXKcQig4bxe9l
   BSqfNVvC00weibdwnsjl3ZE+Oc5xjb27rl7j0oJbs3lxaQKlUxWkjuVQb
   D8ESfzjdEGNl3QEy/+8+MTiY8nmOBRFqGbidaYczpzQ6QZE8T9R5JQpvm
   HwLdtFoXnU2Uvuln6UNrhFXNFvxXR0FZFlfnhx2pDZK5cVsd2f5w6A353
   A==;
X-IronPort-AV: E=Sophos;i="5.99,278,1677567600"; 
   d="scan'208";a="211596935"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 May 2023 13:14:26 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 16 May 2023 13:14:23 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Tue, 16 May 2023 13:14:21 -0700
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>,
	<daniel.machon@microchip.com>, <piotr.raczynski@intel.com>, Horatiu Vultur
	<horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 3/7] net: lan966x: Add support for apptrust
Date: Tue, 16 May 2023 22:14:04 +0200
Message-ID: <20230516201408.3172428-4-horatiu.vultur@microchip.com>
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

Make use of set/getapptrust() to implement per-selector trust
and trust order.

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_dcb.c  | 118 +++++++++++++++++-
 1 file changed, 114 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c b/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c
index e0d49421812f1..d6210c70171e9 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c
@@ -2,7 +2,49 @@
 
 #include "lan966x_main.h"
 
-static void lan966x_dcb_app_update(struct net_device *dev, bool enable)
+enum lan966x_dcb_apptrust_values {
+	LAN966X_DCB_APPTRUST_EMPTY,
+	LAN966X_DCB_APPTRUST_DSCP,
+	LAN966X_DCB_APPTRUST_PCP,
+	LAN966X_DCB_APPTRUST_DSCP_PCP,
+	__LAN966X_DCB_APPTRUST_MAX
+};
+
+static const struct lan966x_dcb_apptrust {
+	u8 selectors[IEEE_8021QAZ_APP_SEL_MAX + 1];
+	int nselectors;
+} *lan966x_port_apptrust[NUM_PHYS_PORTS];
+
+static const char *lan966x_dcb_apptrust_names[__LAN966X_DCB_APPTRUST_MAX] = {
+	[LAN966X_DCB_APPTRUST_EMPTY]    = "empty",
+	[LAN966X_DCB_APPTRUST_DSCP]     = "dscp",
+	[LAN966X_DCB_APPTRUST_PCP]      = "pcp",
+	[LAN966X_DCB_APPTRUST_DSCP_PCP] = "dscp pcp"
+};
+
+/* Lan966x supported apptrust policies */
+static const struct lan966x_dcb_apptrust
+	lan966x_dcb_apptrust_policies[__LAN966X_DCB_APPTRUST_MAX] = {
+	/* Empty *must* be first */
+	[LAN966X_DCB_APPTRUST_EMPTY]    = { { 0 }, 0 },
+	[LAN966X_DCB_APPTRUST_DSCP]     = { { IEEE_8021QAZ_APP_SEL_DSCP }, 1 },
+	[LAN966X_DCB_APPTRUST_PCP]      = { { DCB_APP_SEL_PCP }, 1 },
+	[LAN966X_DCB_APPTRUST_DSCP_PCP] = { { IEEE_8021QAZ_APP_SEL_DSCP,
+					      DCB_APP_SEL_PCP }, 2 },
+};
+
+static bool lan966x_dcb_apptrust_contains(int portno, u8 selector)
+{
+	const struct lan966x_dcb_apptrust *conf = lan966x_port_apptrust[portno];
+
+	for (int i = 0; i < conf->nselectors; i++)
+		if (conf->selectors[i] == selector)
+			return true;
+
+	return false;
+}
+
+static void lan966x_dcb_app_update(struct net_device *dev)
 {
 	struct lan966x_port *port = netdev_priv(dev);
 	struct lan966x_port_qos qos = {0};
@@ -15,7 +57,10 @@ static void lan966x_dcb_app_update(struct net_device *dev, bool enable)
 		qos.pcp.map[i] = dcb_getapp(dev, &app_itr);
 	}
 
-	qos.pcp.enable = enable;
+	/* Enable use of pcp for queue classification */
+	if (lan966x_dcb_apptrust_contains(port->chip_port, DCB_APP_SEL_PCP))
+		qos.pcp.enable = true;
+
 	lan966x_port_qos_set(port, &qos);
 }
 
@@ -52,7 +97,7 @@ static int lan966x_dcb_ieee_delapp(struct net_device *dev, struct dcb_app *app)
 	if (err < 0)
 		return err;
 
-	lan966x_dcb_app_update(dev, false);
+	lan966x_dcb_app_update(dev);
 
 	return 0;
 }
@@ -79,7 +124,67 @@ static int lan966x_dcb_ieee_setapp(struct net_device *dev, struct dcb_app *app)
 	if (err)
 		return err;
 
-	lan966x_dcb_app_update(dev, true);
+	lan966x_dcb_app_update(dev);
+
+	return 0;
+}
+
+static int lan966x_dcb_apptrust_validate(struct net_device *dev,
+					 u8 *selectors,
+					 int nselectors)
+{
+	for (int i = 0; i < ARRAY_SIZE(lan966x_dcb_apptrust_policies); i++) {
+		bool match;
+
+		if (lan966x_dcb_apptrust_policies[i].nselectors != nselectors)
+			continue;
+
+		match = true;
+		for (int j = 0; j < nselectors; j++) {
+			if (lan966x_dcb_apptrust_policies[i].selectors[j] !=
+			    *(selectors + j)) {
+				match = false;
+				break;
+			}
+		}
+		if (match)
+			return i;
+	}
+
+	netdev_err(dev, "Valid apptrust configurations are:\n");
+	for (int i = 0; i < ARRAY_SIZE(lan966x_dcb_apptrust_names); i++)
+		pr_info("order: %s\n", lan966x_dcb_apptrust_names[i]);
+
+	return -EOPNOTSUPP;
+}
+
+static int lan966x_dcb_setapptrust(struct net_device *dev,
+				   u8 *selectors,
+				   int nselectors)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	int idx;
+
+	idx = lan966x_dcb_apptrust_validate(dev, selectors, nselectors);
+	if (idx < 0)
+		return idx;
+
+	lan966x_port_apptrust[port->chip_port] = &lan966x_dcb_apptrust_policies[idx];
+	lan966x_dcb_app_update(dev);
+
+	return 0;
+}
+
+static int lan966x_dcb_getapptrust(struct net_device *dev, u8 *selectors,
+				   int *nselectors)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	const struct lan966x_dcb_apptrust *trust;
+
+	trust = lan966x_port_apptrust[port->chip_port];
+
+	memcpy(selectors, trust->selectors, trust->nselectors);
+	*nselectors = trust->nselectors;
 
 	return 0;
 }
@@ -87,6 +192,8 @@ static int lan966x_dcb_ieee_setapp(struct net_device *dev, struct dcb_app *app)
 static const struct dcbnl_rtnl_ops lan966x_dcbnl_ops = {
 	.ieee_setapp = lan966x_dcb_ieee_setapp,
 	.ieee_delapp = lan966x_dcb_ieee_delapp,
+	.dcbnl_setapptrust = lan966x_dcb_setapptrust,
+	.dcbnl_getapptrust = lan966x_dcb_getapptrust,
 };
 
 void lan966x_dcb_init(struct lan966x *lan966x)
@@ -99,5 +206,8 @@ void lan966x_dcb_init(struct lan966x *lan966x)
 			continue;
 
 		port->dev->dcbnl_ops = &lan966x_dcbnl_ops;
+
+		lan966x_port_apptrust[port->chip_port] =
+			&lan966x_dcb_apptrust_policies[LAN966X_DCB_APPTRUST_DSCP_PCP];
 	}
 }
-- 
2.38.0


