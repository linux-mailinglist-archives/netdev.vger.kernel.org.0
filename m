Return-Path: <netdev+bounces-2443-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BB1F6701F76
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 22:12:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C76E281094
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 20:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E433BBE76;
	Sun, 14 May 2023 20:11:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CD2BE63
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 20:11:28 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EEC10EF;
	Sun, 14 May 2023 13:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684095086; x=1715631086;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=STnQLIfkKtnagaUMNVSTbqiWkD6BvIPnKTtZ917s+5g=;
  b=I7n54n14X1XANesYfQgO9CMXlV6/xjDTork/ptgvpGBYYQRcW+99Ldv0
   FHTI7mxxMgqUTvU80OIEr3GJXukgCY2tmckKthTxtO8jX59hRWarjmLCw
   gygbZzfm7gijwtu4tJDla59cjfuNaiShitWcJAaXyQhQWP3sGWvxmq1yF
   bswfXG2lL1fSBMMJH2kZ4+ZQk9wOGwfNg5uWqjJSMf2/OP5MZ71I0RAhA
   ZOhCVB9cyBSlaWj3WQYRl78qirwkItJI1cZQ4Ulthy2086uo4/QwvtamE
   DvQt4e3lZVoog39acNr28JVZFkv/Mpd8l70UQ3Pmv7IsMeDRlEuliDH7T
   g==;
X-IronPort-AV: E=Sophos;i="5.99,274,1677567600"; 
   d="scan'208";a="215325951"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 May 2023 13:11:25 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 14 May 2023 13:11:25 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Sun, 14 May 2023 13:11:23 -0700
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>, Horatiu Vultur
	<horatiu.vultur@microchip.com>
Subject: [PATCH net-next 3/7] net: lan966x: Add support for apptrust
Date: Sun, 14 May 2023 22:10:25 +0200
Message-ID: <20230514201029.1867738-4-horatiu.vultur@microchip.com>
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

Make use of set/getapptrust() to implement per-selector trust
and trust order.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_dcb.c  | 118 +++++++++++++++++-
 1 file changed, 114 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c b/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c
index 8ec64336abd5f..c149f905fe9e3 100644
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
@@ -79,15 +124,77 @@ static int lan966x_dcb_ieee_setapp(struct net_device *dev, struct dcb_app *app)
 	if (err)
 		goto out;
 
-	lan966x_dcb_app_update(dev, true);
+	lan966x_dcb_app_update(dev);
 
 out:
 	return err;
 }
 
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
+
+	return 0;
+}
+
 static const struct dcbnl_rtnl_ops lan966x_dcbnl_ops = {
 	.ieee_setapp = lan966x_dcb_ieee_setapp,
 	.ieee_delapp = lan966x_dcb_ieee_delapp,
+	.dcbnl_setapptrust = lan966x_dcb_setapptrust,
+	.dcbnl_getapptrust = lan966x_dcb_getapptrust,
 };
 
 void lan966x_dcb_init(struct lan966x *lan966x)
@@ -100,5 +207,8 @@ void lan966x_dcb_init(struct lan966x *lan966x)
 			continue;
 
 		port->dev->dcbnl_ops = &lan966x_dcbnl_ops;
+
+		lan966x_port_apptrust[port->chip_port] =
+			&lan966x_dcb_apptrust_policies[LAN966X_DCB_APPTRUST_DSCP_PCP];
 	}
 }
-- 
2.38.0


