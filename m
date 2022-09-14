Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105C95B8582
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 11:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbiINJvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 05:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiINJv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 05:51:26 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558D1647F3;
        Wed, 14 Sep 2022 02:51:25 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 28E9pAvR101276;
        Wed, 14 Sep 2022 04:51:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1663149070;
        bh=+u6FR2UGcNaI+4wkBrazoF5ehxal+nWP3zm0vD1dGwg=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=U2erNgg/uK3DljGTGk7g4Btj7dbbPjrDvFdQOeW2QCTgDUb0B0YjmQLHPaEbSY61G
         G9z6djCgX5y6w6msSGPXbqBWkS/3ujYMvmo9RYeTNrju2UtBHMeGE/p4RFlrDWp32t
         QYu5hlBqA4xa+K8iL3MRveelOtOSuMxKMCZWV/yc=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 28E9pA3e020292
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 14 Sep 2022 04:51:10 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Wed, 14
 Sep 2022 04:51:10 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Wed, 14 Sep 2022 04:51:10 -0500
Received: from uda0492258.dhcp.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 28E9osD2046564;
        Wed, 14 Sep 2022 04:51:05 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <grygorii.strashko@ti.com>,
        <vigneshr@ti.com>, <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kishon@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH 2/8] net: ethernet: ti: am65-cpsw: Add support for SERDES configuration
Date:   Wed, 14 Sep 2022 15:20:47 +0530
Message-ID: <20220914095053.189851-3-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220914095053.189851-1-s-vadapalli@ti.com>
References: <20220914095053.189851-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use PHY framework APIs to initialize the SERDES connected to CPSW.

Define the functions am65_cpsw_init_phy(), am65_cpsw_enable_phy() and
am65_cpsw_disable_phy() and invoke in am65_cpsw_nuss_init_slave_ports(),
am65_cpsw_mac_link_up() and am65_cpsw_mac_link_down() respectively.

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 55 ++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 7ef5d8208a4e..4e06def3b0de 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1404,6 +1404,50 @@ static const struct net_device_ops am65_cpsw_nuss_netdev_ops = {
 	.ndo_get_devlink_port   = am65_cpsw_ndo_get_devlink_port,
 };
 
+static void am65_cpsw_disable_phy(struct phy *phy)
+{
+	phy_power_off(phy);
+	phy_exit(phy);
+}
+
+static int am65_cpsw_enable_phy(struct phy *phy)
+{
+	int ret;
+
+	ret = phy_init(phy);
+	if (ret < 0)
+		return ret;
+
+	ret = phy_power_on(phy);
+	if (ret < 0) {
+		phy_exit(phy);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int am65_cpsw_init_phy(struct device *dev, struct device_node *port_np)
+{
+	const char *name = "serdes-phy";
+	struct phy *phy;
+	int ret;
+
+	phy = devm_of_phy_get(dev, port_np, name);
+	if (PTR_ERR(phy) == -ENODEV)
+		return 0;
+
+	ret =  am65_cpsw_enable_phy(phy);
+	if (ret < 0)
+		goto err_phy;
+
+	return 0;
+
+err_phy:
+	devm_phy_put(dev, phy);
+	return ret;
+}
+
 static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned int mode,
 				      const struct phylink_link_state *state)
 {
@@ -1427,6 +1471,9 @@ static void am65_cpsw_nuss_mac_link_down(struct phylink_config *config, unsigned
 	struct net_device *ndev = port->ndev;
 	int tmo;
 
+	/* disable phy */
+	am65_cpsw_disable_phy(port->slave.ifphy);
+
 	/* disable forwarding */
 	cpsw_ale_control_set(common->ale, port->port_id, ALE_PORT_STATE, ALE_PORT_STATE_DISABLE);
 
@@ -1472,6 +1519,9 @@ static void am65_cpsw_nuss_mac_link_up(struct phylink_config *config, struct phy
 
 	cpsw_sl_ctl_set(port->slave.mac_sl, mac_control);
 
+	/* enable phy */
+	am65_cpsw_enable_phy(port->slave.ifphy);
+
 	/* enable forwarding */
 	cpsw_ale_control_set(common->ale, port->port_id, ALE_PORT_STATE, ALE_PORT_STATE_FORWARD);
 
@@ -1881,6 +1931,11 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 			goto of_node_put;
 		}
 
+		/* Initialize the phy for the port */
+		ret = am65_cpsw_init_phy(dev, port_np);
+		if (ret)
+			return ret;
+
 		port->slave.mac_only =
 				of_property_read_bool(port_np, "ti,mac-only");
 
-- 
2.25.1

