Return-Path: <netdev+bounces-2445-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DF41D701F78
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 22:13:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 996D1281087
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 20:13:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1EDABE63;
	Sun, 14 May 2023 20:11:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE28C129
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 20:11:31 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E57F1985;
	Sun, 14 May 2023 13:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684095090; x=1715631090;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=42l68SITaSuGX9G45D7m4x8tsaphU07/rLdo8Qld6kg=;
  b=VFPdAMCZPHyaiS8+IOxW3TWckdwhKEEG0JeXWtXjCaLSKYBZzNCuELHW
   XQf4DPLfWjXjPf/mT8pGM58NgYCQR8OSBfjN34t8I2eWwsikfCjX7CDlc
   +Es9rhm0ZDN5rvLpQ/IHZnrcpMOuU+kEGIsnhKhJ3eAqFYqs7P2tin1/c
   KXqQWZgP3+k+XU52pn86RT0ZmKFo5Mclr7JLv9MhFx7hy+SCy9j8J00Ld
   00Ofd6oYuiRRbqnk65S00XuARWhb4K1l4eM6dQR0ZIbdZP6SpqLCGJiWJ
   VYlHInjaTEpnuxCXf+0bTKog77mT24qsZgPIC6SXHxctzdfNqvDv/mlrK
   A==;
X-IronPort-AV: E=Sophos;i="5.99,274,1677567600"; 
   d="scan'208";a="211196328"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 May 2023 13:11:30 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 14 May 2023 13:11:29 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Sun, 14 May 2023 13:11:27 -0700
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>, Horatiu Vultur
	<horatiu.vultur@microchip.com>
Subject: [PATCH net-next 5/7] net: lan966x: Add support for offloading default prio
Date: Sun, 14 May 2023 22:10:27 +0200
Message-ID: <20230514201029.1867738-6-horatiu.vultur@microchip.com>
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

Add support for offloading default prio.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_dcb.c  | 12 +++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.h |  1 +
 .../ethernet/microchip/lan966x/lan966x_port.c | 21 +++++++++++++++++++
 3 files changed, 34 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c b/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c
index 2b518181b7f08..d86369dd2d9b7 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c
@@ -64,6 +64,11 @@ static void lan966x_dcb_app_update(struct net_device *dev)
 		qos.dscp.map[i] = dcb_getapp(dev, &app_itr);
 	}
 
+	/* Get default prio */
+	qos.default_prio = dcb_ieee_getapp_default_prio_mask(dev);
+	if (qos.default_prio)
+		qos.default_prio = fls(qos.default_prio) - 1;
+
 	/* Enable use of pcp for queue classification */
 	if (lan966x_dcb_apptrust_contains(port->chip_port, DCB_APP_SEL_PCP))
 		qos.pcp.enable = true;
@@ -106,6 +111,13 @@ static int lan966x_dcb_app_validate(struct net_device *dev,
 	int err = 0;
 
 	switch (app->selector) {
+	/* Default priority checks */
+	case IEEE_8021QAZ_APP_SEL_ETHERTYPE:
+		if (app->protocol != 0)
+			err = -EINVAL;
+		else if (app->priority >= NUM_PRIO_QUEUES)
+			err = -ERANGE;
+		break;
 	/* Dscp checks */
 	case IEEE_8021QAZ_APP_SEL_DSCP:
 		if (app->protocol >= LAN966X_PORT_QOS_DSCP_COUNT)
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 8213440e08672..53711d5380166 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -412,6 +412,7 @@ struct lan966x_port_qos_dscp {
 struct lan966x_port_qos {
 	struct lan966x_port_qos_pcp pcp;
 	struct lan966x_port_qos_dscp dscp;
+	u8 default_prio;
 };
 
 struct lan966x_port {
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
index 11c552e87ee44..a6608876b71ef 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
@@ -443,11 +443,32 @@ static void lan966x_port_qos_dscp_set(struct lan966x_port *port,
 			lan966x, ANA_DSCP_CFG(i));
 }
 
+static int lan966x_port_qos_default_set(struct lan966x_port *port,
+					struct lan966x_port_qos *qos)
+{
+	/* Set default prio and dp level */
+	lan_rmw(ANA_QOS_CFG_DP_DEFAULT_VAL_SET(0) |
+		ANA_QOS_CFG_QOS_DEFAULT_VAL_SET(qos->default_prio),
+		ANA_QOS_CFG_DP_DEFAULT_VAL |
+		ANA_QOS_CFG_QOS_DEFAULT_VAL,
+		port->lan966x, ANA_QOS_CFG(port->chip_port));
+
+	/* Set default pcp and dei for untagged frames */
+	lan_rmw(ANA_VLAN_CFG_VLAN_DEI_SET(0) |
+		ANA_VLAN_CFG_VLAN_PCP_SET(0),
+		ANA_VLAN_CFG_VLAN_DEI |
+		ANA_VLAN_CFG_VLAN_PCP,
+		port->lan966x, ANA_VLAN_CFG(port->chip_port));
+
+	return 0;
+}
+
 void lan966x_port_qos_set(struct lan966x_port *port,
 			  struct lan966x_port_qos *qos)
 {
 	lan966x_port_qos_pcp_set(port, &qos->pcp);
 	lan966x_port_qos_dscp_set(port, &qos->dscp);
+	lan966x_port_qos_default_set(port, qos);
 }
 
 void lan966x_port_init(struct lan966x_port *port)
-- 
2.38.0


